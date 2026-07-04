// Face + hand tracking via @mediapipe/tasks-vision.
//
// The JS library is bundled (it's small), but the WASM runtime and the .task
// models are lazy-loaded from CDNs at start() — they are tens of MB and must
// NOT be bundled or served from our static host.
//
// The tracker runs on its own throttled setTimeout loop (~16fps), fully
// decoupled from the render loop: the renderer reads the latest snapshot and
// never blocks on detection. This is what keeps 30-60fps rendering smooth on
// a phone while detection chugs along at its own pace.

// Keep this version in lockstep with package.json — the JS API and the WASM
// runtime must match.
const WASM_BASE = 'https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision@0.10.35/wasm';
const FACE_MODEL = 'https://storage.googleapis.com/mediapipe-models/face_landmarker/face_landmarker/float16/1/face_landmarker.task';
const HAND_MODEL = 'https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task';
const INTERVAL_MS = 60; // ~16 detections/sec

const clamp = (v, lo, hi) => Math.min(hi, Math.max(lo, v));
const dist = (a, b) => Math.hypot(a.x - b.x, a.y - b.y);

export function createTracking(getVideo) {
  // Live snapshot, mutated in place; consumers read it every render frame.
  const snap = {
    face: { mouth: 0, smile: 0, brow: 0, tilt: 0, present: false },
    hand: { x: 0.5, y: 0.5, pinch: 0.5, present: false },
  };

  let faceLm = null;
  let handLm = null;
  let starting = false;
  let running = false;
  let lastTs = 0;

  async function start() {
    if (starting || running) return;
    starting = true;
    try {
      const { FilesetResolver, FaceLandmarker, HandLandmarker } =
        await import('@mediapipe/tasks-vision');
      const fileset = await FilesetResolver.forVisionTasks(WASM_BASE);
      const make = (delegate) => Promise.all([
        FaceLandmarker.createFromOptions(fileset, {
          baseOptions: { modelAssetPath: FACE_MODEL, delegate },
          runningMode: 'VIDEO',
          numFaces: 1,
          outputFaceBlendshapes: true,
        }),
        HandLandmarker.createFromOptions(fileset, {
          baseOptions: { modelAssetPath: HAND_MODEL, delegate },
          runningMode: 'VIDEO',
          numHands: 1,
        }),
      ]);
      try {
        [faceLm, handLm] = await make('GPU');
      } catch {
        [faceLm, handLm] = await make('CPU'); // some browsers lack the GPU delegate
      }
      running = true;
      tick();
    } finally {
      starting = false;
    }
  }

  function tick() {
    if (!running) return;
    const video = getVideo();
    if (video && video.videoWidth > 0) detect(video);
    else easeFaceToNeutral();
    setTimeout(tick, INTERVAL_MS);
  }

  function detect(video) {
    // detectForVideo requires strictly increasing timestamps.
    const ts = Math.max(lastTs + 1, performance.now());
    lastTs = ts;
    try {
      readFace(faceLm.detectForVideo(video, ts));
      readHand(handLm.detectForVideo(video, ts));
    } catch {
      // A dropped detection frame is harmless; keep the last snapshot.
    }
  }

  function readFace(res) {
    const cats = res.faceBlendshapes?.[0]?.categories;
    const lms = res.faceLandmarks?.[0];
    if (!cats || !lms) {
      snap.face.present = false;
      easeFaceToNeutral();
      return;
    }
    const score = (name) => cats.find((c) => c.categoryName === name)?.score ?? 0;
    snap.face.present = true;
    snap.face.mouth = clamp(score('jawOpen') * 1.4, 0, 1);
    snap.face.smile = clamp((score('mouthSmileLeft') + score('mouthSmileRight')) * 0.7, 0, 1);
    snap.face.brow = clamp(score('browInnerUp') * 1.2, 0, 1);
    // Head roll from the line between the outer eye corners (33, 263).
    const a = lms[33];
    const b = lms[263];
    snap.face.tilt = clamp(Math.atan2(b.y - a.y, b.x - a.x) * 2.5, -1, 1);
  }

  function readHand(res) {
    const lms = res.landmarks?.[0];
    if (!lms) {
      snap.hand.present = false; // hold the last position rather than snapping
      return;
    }
    let cx = 0;
    let cy = 0;
    for (const p of lms) {
      cx += p.x;
      cy += p.y;
    }
    // X mirrored so the value matches the mirrored on-screen preview.
    snap.hand.x = clamp(1 - cx / lms.length, 0, 1);
    snap.hand.y = clamp(cy / lms.length, 0, 1);
    // Pinch: thumb tip (4) ↔ index tip (8), normalized by palm size so it is
    // distance-from-camera invariant. 0 = touching, 1 = fully spread.
    const ref = Math.max(dist(lms[0], lms[9]), 1e-3);
    snap.hand.pinch = clamp((dist(lms[4], lms[8]) / ref - 0.1) / 1.1, 0, 1);
    snap.hand.present = true;
  }

  function easeFaceToNeutral() {
    const f = snap.face;
    f.mouth *= 0.92;
    f.smile *= 0.92;
    f.brow *= 0.92;
    f.tilt *= 0.92;
  }

  return {
    start,
    snapshot: () => snap,
    isRunning: () => running,
  };
}
