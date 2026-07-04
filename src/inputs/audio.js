// Audio input → coarse spectrum { bass, mid, treble, level }, each 0..1.
//
// Platform reality: browsers CANNOT read Spotify / Apple Music / system or
// other-app audio. No web API exists for it and DRM streaming is sandboxed.
// Do not attempt it. The two real sources are:
//   (a) a user-imported audio file → decodeAudioData → looped playback + FFT
//   (b) the microphone → FFT only. The mic is deliberately NEVER connected to
//       ctx.destination (speakers) — that would be an instant feedback loop.
//
// A MediaStreamDestination node carries whichever source is active so the
// recorder can mux the same audio into the captured video.

const clamp01 = (v) => Math.min(1, Math.max(0, v));

export function createAudio() {
  let ctx = null;
  let analyser = null;
  let recordDest = null;
  let bins = null;
  let mode = 'none';

  let micStream = null;
  let micSource = null;

  let fileBuffer = null;
  let fileSource = null;
  let fileGain = null;
  let fileOffset = 0;
  let fileStartedAt = 0;
  let filePlaying = false;

  const bands = { bass: 0, mid: 0, treble: 0, level: 0 };
  // Master reactivity: multiplies the analyzed bands before they reach the
  // mapping layer. Live-adjustable (including mid-recording) — it shapes how
  // hard the visuals ride the music, not the audio that gets recorded.
  let gain = 1;

  function ensureCtx() {
    if (ctx) return;
    ctx = new (window.AudioContext || window.webkitAudioContext)();
    analyser = ctx.createAnalyser();
    analyser.fftSize = 1024;
    analyser.smoothingTimeConstant = 0.7;
    bins = new Uint8Array(analyser.frequencyBinCount);
    recordDest = ctx.createMediaStreamDestination();
  }

  async function useMic() {
    stopAll();
    ensureCtx();
    await ctx.resume();
    micStream = await navigator.mediaDevices.getUserMedia({ audio: true });
    micSource = ctx.createMediaStreamSource(micStream);
    micSource.connect(analyser);
    micSource.connect(recordDest);
    // NOT connected to ctx.destination — see header comment (feedback).
    mode = 'mic';
  }

  async function useFile(file) {
    stopAll();
    ensureCtx();
    await ctx.resume();
    fileBuffer = await ctx.decodeAudioData(await file.arrayBuffer());
    fileGain = ctx.createGain();
    fileGain.connect(analyser);
    fileGain.connect(ctx.destination);
    fileGain.connect(recordDest);
    fileOffset = 0;
    startFileSource();
    mode = 'file';
  }

  // BufferSource nodes are one-shot; pause/resume = stop + recreate at offset.
  function startFileSource() {
    fileSource = ctx.createBufferSource();
    fileSource.buffer = fileBuffer;
    fileSource.loop = true;
    fileSource.connect(fileGain);
    fileSource.start(0, fileOffset % fileBuffer.duration);
    fileStartedAt = ctx.currentTime;
    filePlaying = true;
  }

  /** Toggle file playback. Returns whether it is now playing. */
  function togglePlay() {
    if (mode !== 'file' || !fileBuffer) return false;
    if (filePlaying) {
      fileOffset = (fileOffset + ctx.currentTime - fileStartedAt) % fileBuffer.duration;
      try { fileSource.stop(); } catch { /* already stopped */ }
      fileSource.disconnect();
      fileSource = null;
      filePlaying = false;
    } else {
      startFileSource();
    }
    return filePlaying;
  }

  function stopAll() {
    if (fileSource) {
      try { fileSource.stop(); } catch { /* already stopped */ }
      fileSource.disconnect();
      fileSource = null;
    }
    if (fileGain) {
      fileGain.disconnect();
      fileGain = null;
    }
    fileBuffer = null;
    filePlaying = false;
    if (micSource) {
      micSource.disconnect();
      micSource = null;
    }
    if (micStream) {
      for (const t of micStream.getTracks()) t.stop();
      micStream = null;
    }
    mode = 'none';
    bands.bass = bands.mid = bands.treble = bands.level = 0;
  }

  /** Per-frame coarse spectrum read. Cheap; call from the render loop. */
  function getBands() {
    if (!analyser || mode === 'none') return bands;
    analyser.getByteFrequencyData(bins);
    const hzPerBin = ctx.sampleRate / 2 / bins.length;
    const avg = (lo, hi) => {
      const i0 = Math.max(0, Math.floor(lo / hzPerBin));
      const i1 = Math.min(bins.length - 1, Math.ceil(hi / hzPerBin));
      let sum = 0;
      for (let i = i0; i <= i1; i++) sum += bins[i];
      return sum / ((i1 - i0 + 1) * 255);
    };
    // Gentle per-band shaping: FFT magnitudes fall off toward the highs.
    bands.bass = clamp01(avg(20, 250) * gain);
    bands.mid = clamp01(avg(250, 2000) * 1.2 * gain);
    bands.treble = clamp01(avg(2000, 8000) * 1.6 * gain);
    bands.level = clamp01(avg(20, 8000) * 1.1 * gain);
    return bands;
  }

  return {
    useMic,
    useFile,
    togglePlay,
    stopAll,
    getBands,
    getMode: () => mode,
    isPlaying: () => filePlaying,
    setGain: (g) => { gain = Math.min(4, Math.max(0, g)); },
    getGain: () => gain,
    /** Stream for the recorder to mux; null when no audio source is active. */
    getRecordStream: () => (mode !== 'none' && recordDest ? recordDest.stream : null),
  };
}
