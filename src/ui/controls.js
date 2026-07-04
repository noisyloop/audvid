// Control panel wiring. This module owns the DOM and nothing else — it calls
// plain handler callbacks and exposes plain setters, so the UI never reaches
// into inputs/renderer internals (and vice versa).

export function initControls(handlers) {
  const $ = (id) => document.getElementById(id);
  const els = {
    name: $('shaderName'),
    error: $('shaderError'),
    status: $('status'),
    recTime: $('recTime'),
    record: $('record'),
    camToggle: $('camToggle'),
    playPause: $('playPause'),
    file: $('filePick'),
    aspect: $('aspect'),
    res: $('res'),
    mapText: $('mapText'),
    overlay: $('startOverlay'),
  };
  const audioButtons = [...document.querySelectorAll('[data-audio]')];

  $('shaderPrev').addEventListener('click', () => handlers.onShaderStep(-1));
  $('shaderNext').addEventListener('click', () => handlers.onShaderStep(1));
  $('randomize').addEventListener('click', () => handlers.onRandomize());
  $('photo').addEventListener('click', () => handlers.onPhoto());
  els.record.addEventListener('click', () => handlers.onRecordToggle());
  els.camToggle.addEventListener('click', () => handlers.onCameraToggle());
  els.playPause.addEventListener('click', () => handlers.onPlayPause());
  els.overlay.addEventListener('click', () => {
    els.overlay.hidden = true;
    handlers.onStart();
  }, { once: true });

  for (const btn of audioButtons) {
    btn.addEventListener('click', () => {
      // 'file' routes through the picker; the mode only switches once a file
      // actually loads, so a cancelled picker changes nothing.
      if (btn.dataset.audio === 'file') els.file.click();
      else handlers.onAudioMode(btn.dataset.audio);
    });
  }
  els.file.addEventListener('change', () => {
    const f = els.file.files[0];
    if (f) handlers.onFilePicked(f);
    els.file.value = ''; // allow re-picking the same file
  });

  const applyFormat = () =>
    handlers.onFormat(computeSize(els.aspect.value, Number(els.res.value)));
  els.aspect.addEventListener('change', applyFormat);
  els.res.addEventListener('change', applyFormat);

  return {
    setShaderName: (n) => { els.name.textContent = n; },
    setError: (msg) => {
      els.error.hidden = !msg;
      els.error.textContent = msg ? `Shader error (previous shader kept running):\n${msg}` : '';
    },
    setStatus: (msg) => { els.status.textContent = msg; },
    setCamera: (on) => { els.camToggle.classList.toggle('on', on); },
    setAudioMode: (mode) => {
      for (const b of audioButtons) b.classList.toggle('on', b.dataset.audio === mode);
      els.playPause.hidden = mode !== 'file';
    },
    setPlaying: (playing) => { els.playPause.textContent = playing ? '⏸' : '▶'; },
    setRecording: (on) => {
      els.record.classList.toggle('rec', on);
      // Resizing the canvas mid-recording breaks the captured stream.
      els.aspect.disabled = on;
      els.res.disabled = on;
    },
    setRecTime: (seconds) => {
      els.recTime.textContent = seconds == null
        ? ''
        : `${Math.floor(seconds / 60)}:${String(Math.floor(seconds % 60)).padStart(2, '0')}`;
    },
    setMappingText: (t) => { els.mapText.textContent = t; },
  };
}

/** "9:16" + short side (720) → even-numbered pixel dimensions. */
export function computeSize(aspect, shortSide) {
  const [a, b] = aspect.split(':').map(Number);
  let w;
  let h;
  if (a <= b) {
    w = shortSide;
    h = Math.round((shortSide * b) / a);
  } else {
    h = shortSide;
    w = Math.round((shortSide * a) / b);
  }
  // Video encoders want even dimensions.
  return { w: w - (w % 2), h: h - (h % 2) };
}
