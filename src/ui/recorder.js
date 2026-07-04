// Recording: canvas.captureStream + active audio, muxed by MediaRecorder.
// 100% local — the file is assembled in memory and saved as a download.
//
// Container reality: Instagram wants MP4/H.264. Safari records MP4 natively
// and recent Chrome can too, so MP4 is tried first; otherwise we fall back to
// WebM (VP9/VP8 + Opus) and the UI tells the user to convert on desktop.
// (An in-browser ffmpeg.wasm transcode was deliberately skipped — it's a
// ~30MB download and very heavy on phones, our primary target.)

import { downloadBlob, stamp } from './download.js';

const MIME_CANDIDATES = [
  'video/mp4;codecs=avc1.42E01E,mp4a.40.2',
  'video/mp4',
  'video/webm;codecs=vp9,opus',
  'video/webm;codecs=vp8,opus',
  'video/webm',
];

export function createRecorder(canvas, { getAudioStream, onStart, onSaved, onError }) {
  let rec = null;
  let chunks = [];
  let t0 = 0;

  function start() {
    if (rec) return;
    if (typeof MediaRecorder === 'undefined' || !canvas.captureStream) {
      onError?.('Recording is not supported in this browser.');
      return;
    }
    const stream = canvas.captureStream(30);
    const audio = getAudioStream?.();
    if (audio) {
      for (const t of audio.getAudioTracks()) stream.addTrack(t);
    }
    const mime = MIME_CANDIDATES.find((m) => MediaRecorder.isTypeSupported(m));
    try {
      rec = new MediaRecorder(stream, {
        ...(mime ? { mimeType: mime } : {}),
        videoBitsPerSecond: 12_000_000,
        audioBitsPerSecond: 192_000,
      });
    } catch (e) {
      onError?.(`Could not start recording: ${e.message}`);
      return;
    }
    chunks = [];
    rec.ondataavailable = (e) => {
      if (e.data && e.data.size > 0) chunks.push(e.data);
    };
    rec.onstop = () => {
      const type = rec.mimeType || mime || 'video/webm';
      const isMp4 = type.includes('mp4');
      downloadBlob(new Blob(chunks, { type }), `audvid-${stamp()}.${isMp4 ? 'mp4' : 'webm'}`);
      chunks = [];
      rec = null;
      onSaved?.({ isMp4 });
    };
    rec.start(1000); // collect in 1s chunks so a crash loses little
    t0 = performance.now();
    onStart?.();
  }

  function stop() {
    if (rec && rec.state !== 'inactive') rec.stop();
  }

  return {
    start,
    stop,
    isRecording: () => rec != null,
    elapsed: () => (rec ? (performance.now() - t0) / 1000 : 0),
  };
}
