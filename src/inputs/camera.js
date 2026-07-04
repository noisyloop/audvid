// Front camera via getUserMedia. Exposes the raw <video> element as the frame
// source; the renderer uploads it as a texture, tracking reads it for
// landmarks. The feed never leaves the device.

export function createCamera() {
  const video = document.createElement('video');
  video.playsInline = true; // iOS: without this, play() goes fullscreen
  video.muted = true;
  let stream = null;
  let ready = false;
  let busy = false;

  async function start() {
    if (ready || busy) return;
    busy = true;
    try {
      stream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: 'user', width: { ideal: 1280 }, height: { ideal: 720 } },
        audio: false,
      });
      video.srcObject = stream;
      await video.play();
      ready = true;
    } finally {
      busy = false;
    }
  }

  function stop() {
    ready = false;
    video.pause();
    video.srcObject = null;
    if (stream) {
      for (const t of stream.getTracks()) t.stop();
      stream = null;
    }
  }

  /** The video element when a frame is available, else null. */
  function frame() {
    return ready && video.readyState >= 2 ? video : null;
  }

  return { start, stop, frame, isOn: () => ready };
}
