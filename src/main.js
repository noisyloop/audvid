// Thin orchestrator: constructs the modules, wires UI handlers, and owns the
// requestAnimationFrame loop. All cross-module traffic is plain data — the
// inputs snapshot goes into mapping, mapping's uniform bag goes into the
// renderer.

import './ui/styles.css';
import { createRenderer } from './core/renderer.js';
import { shaders, fullSource } from './shaders/index.js';
import { createCamera } from './inputs/camera.js';
import { createAudio } from './inputs/audio.js';
import { createTracking } from './inputs/tracking.js';
import { createMapping } from './mapping/mappings.js';
import { initControls } from './ui/controls.js';
import { createRecorder } from './ui/recorder.js';
import { downloadBlob, stamp } from './ui/download.js';

const canvas = document.getElementById('canvas');
const renderer = createRenderer(canvas);
const camera = createCamera();
const audio = createAudio();
const tracking = createTracking(() => camera.frame());
const mapping = createMapping();

let shaderIndex = 0;
let photoPending = false;

const recorder = createRecorder(canvas, {
  getAudioStream: () => audio.getRecordStream(),
  onStart: () => {
    ui.setRecording(true);
    ui.setStatus('Recording…');
  },
  onSaved: ({ isMp4 }) => {
    ui.setRecording(false);
    ui.setRecTime(null);
    ui.setStatus(isMp4
      ? 'Saved MP4 — ready to post.'
      : 'Saved WebM — Instagram prefers MP4; convert on desktop (e.g. HandBrake).');
  },
  onError: (msg) => {
    ui.setRecording(false);
    ui.setStatus(msg);
  },
});

const ui = initControls({
  onStart: () => setCamera(true),
  onShaderStep: (dir) => setShader(shaderIndex + dir),
  onRandomize: () => {
    setShader(Math.floor(Math.random() * shaders.length));
    mapping.randomize();
    ui.setMappingText(mapping.describe());
  },
  onCameraToggle: () => setCamera(!camera.isOn()),
  onAudioMode: (mode) => setAudioMode(mode),
  onFilePicked: (file) => loadAudioFile(file),
  onPlayPause: () => ui.setPlaying(audio.togglePlay()),
  onFormat: ({ w, h }) => {
    if (recorder.isRecording()) return; // selects are disabled, but be safe
    renderer.resize(w, h);
  },
  onRecordToggle: () => (recorder.isRecording() ? recorder.stop() : recorder.start()),
  onPhoto: () => { photoPending = true; },
});

function setShader(i) {
  shaderIndex = ((i % shaders.length) + shaders.length) % shaders.length;
  const result = renderer.setShader(fullSource(shaders[shaderIndex]));
  ui.setShaderName(shaders[shaderIndex].name);
  ui.setError(result.ok ? '' : result.error);
}

async function setCamera(on) {
  if (!on) {
    camera.stop();
    ui.setCamera(false);
    ui.setStatus('Camera off.');
    return;
  }
  try {
    await camera.start();
    ui.setCamera(true);
    ui.setStatus('Loading face/hand tracking…');
    tracking.start().then(
      () => ui.setStatus('Tracking ready — move, smile, pinch.'),
      (e) => ui.setStatus(`Tracking unavailable (${e?.message || 'model download failed'}) — audio + camera still work.`),
    );
  } catch (e) {
    ui.setCamera(false);
    ui.setStatus(e.name === 'NotAllowedError'
      ? 'Camera permission denied — visuals run without it (audio still reacts).'
      : `Camera unavailable: ${e.message}`);
  }
}

async function setAudioMode(mode) {
  try {
    if (mode === 'mic') {
      await audio.useMic();
      ui.setStatus('Mic reactive (analysis only — not played back, no feedback).');
    } else {
      audio.stopAll();
      ui.setStatus('Audio off.');
    }
    ui.setAudioMode(mode);
  } catch (e) {
    ui.setAudioMode(audio.getMode());
    ui.setStatus(e.name === 'NotAllowedError'
      ? 'Mic permission denied.'
      : `Mic unavailable: ${e.message}`);
  }
}

async function loadAudioFile(file) {
  try {
    ui.setStatus(`Decoding ${file.name}…`);
    await audio.useFile(file);
    ui.setAudioMode('file');
    ui.setPlaying(true);
    ui.setStatus(`Playing ${file.name} (looped).`);
  } catch {
    ui.setAudioMode(audio.getMode());
    ui.setStatus(`Could not decode ${file.name} — try an mp3 or wav.`);
  }
}

canvas.addEventListener('webglcontextlost', (e) => {
  e.preventDefault();
  ui.setStatus('Graphics context lost — reload the page.');
});

// --- Render loop -----------------------------------------------------------
// Renders at display rate; tracking runs on its own throttled loop and is
// only *read* here, never awaited.

const startTime = performance.now();
let lastTime = startTime;

function frame(now) {
  const dt = Math.min((now - lastTime) / 1000, 0.1); // clamp tab-switch spikes
  lastTime = now;

  const snap = tracking.snapshot();
  const uniforms = mapping.update(
    { audio: audio.getBands(), face: snap.face, hand: snap.hand },
    dt,
  );
  uniforms.u_time = (now - startTime) / 1000;
  renderer.draw(uniforms, camera.frame());

  if (photoPending) {
    photoPending = false;
    // Must run in the same task as the draw: preserveDrawingBuffer is off, so
    // the backbuffer is only readable before the browser composites.
    canvas.toBlob((b) => b && downloadBlob(b, `audvid-${stamp()}.jpg`), 'image/jpeg', 0.92);
  }

  ui.setRecTime(recorder.isRecording() ? recorder.elapsed() : null);
  requestAnimationFrame(frame);
}

setShader(0);
ui.setMappingText(mapping.describe());
ui.setAudioMode('none');
ui.setStatus('Pick a look, then hit record. Nothing leaves your device.');
requestAnimationFrame(frame);
