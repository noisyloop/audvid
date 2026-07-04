// Control panel wiring. This module owns the DOM and nothing else — it calls
// plain handler callbacks and exposes plain setters, so the UI never reaches
// into inputs/renderer/layer internals (and vice versa). Layer state comes in
// as a view object via setLayers(); the picker modal lives in shaderPicker.js.

const LAYER_SLIDERS = [
  { key: 'opacity', label: 'Opacity', min: 0, max: 1, step: 0.01 },
  { key: 'speed', label: 'Speed', min: 0, max: 2, step: 0.01 },
  { key: 'scale', label: 'Scale', min: 0.1, max: 3, step: 0.01 },
  { key: 'intensity', label: 'Intensity', min: 0, max: 2, step: 0.01 },
];

export function initControls(handlers) {
  const $ = (id) => document.getElementById(id);
  const els = {
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
    tabs: $('layerTabs'),
    shaderName: $('shaderName'),
    shaderCat: $('shaderCat'),
    eye: $('layerEye'),
    kill: $('layerKill'),
    sliders: $('sliders'),
    blendRow: $('blendRow'),
    gain: $('audioGain'),
    gainVal: $('audioGainVal'),
  };
  const audioButtons = [...document.querySelectorAll('[data-audio]')];
  const syncButtons = [...document.querySelectorAll('[data-sync]')];
  const agc = $('agcToggle');

  // --- layer card ---
  $('shaderPick').addEventListener('click', () => handlers.onOpenPicker());
  $('layerDice').addEventListener('click', () => handlers.onLayerDice());
  els.eye.addEventListener('click', () => handlers.onLayerToggleVisible());
  els.kill.addEventListener('click', () => handlers.onLayerRemove());

  const sliderInputs = {};
  for (const s of LAYER_SLIDERS) {
    const row = document.createElement('div');
    row.className = 'slider-row';
    const label = document.createElement('span');
    label.textContent = s.label;
    const input = document.createElement('input');
    input.type = 'range';
    input.min = s.min;
    input.max = s.max;
    input.step = s.step;
    const out = document.createElement('output');
    input.addEventListener('input', () => {
      out.textContent = Number(input.value).toFixed(2);
      handlers.onLayerParam(s.key, Number(input.value));
    });
    row.append(label, input, out);
    els.sliders.append(row);
    sliderInputs[s.key] = { input, out };
  }

  // --- shared controls ---
  $('randomize').addEventListener('click', () => handlers.onRandomize());
  $('photo').addEventListener('click', () => handlers.onPhoto());
  els.record.addEventListener('click', () => handlers.onRecordToggle());
  els.camToggle.addEventListener('click', () => handlers.onCameraToggle());
  els.playPause.addEventListener('click', () => handlers.onPlayPause());
  for (const btn of syncButtons) {
    btn.addEventListener('click', () => handlers.onSyncPreset(btn.dataset.sync));
  }
  agc.addEventListener('click', () => handlers.onAgcToggle());
  els.gain.addEventListener('input', () => {
    els.gainVal.textContent = Number(els.gain.value).toFixed(2);
    handlers.onAudioGain(Number(els.gain.value));
  });
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
    /**
     * Re-render the layer strip + card from a plain view:
     * { tabs: [{name, visible}], selected, canAdd, canRemove,
     *   current: {shaderName, shaderCat, visible, blend, opacity, speed,
     *   scale, intensity}, blendModes }
     */
    setLayers(view) {
      els.tabs.replaceChildren(
        ...view.tabs.map((t, i) => {
          const b = document.createElement('button');
          b.textContent = t.name.length > 14 ? t.name.slice(0, 13) + '…' : t.name;
          b.classList.toggle('sel', i === view.selected);
          b.classList.toggle('hiddenlayer', !t.visible);
          b.addEventListener('click', () => handlers.onLayerSelect(i));
          return b;
        }),
      );
      if (view.canAdd) {
        const add = document.createElement('button');
        add.className = 'addlayer';
        add.textContent = '+ layer';
        add.addEventListener('click', () => handlers.onLayerAdd());
        els.tabs.append(add);
      }

      const c = view.current;
      els.shaderName.textContent = c.shaderName;
      els.shaderCat.textContent = c.shaderCat;
      els.eye.textContent = c.visible ? '👁' : '🙈';
      els.kill.style.visibility = view.canRemove ? 'visible' : 'hidden';
      for (const s of LAYER_SLIDERS) {
        sliderInputs[s.key].input.value = c[s.key];
        sliderInputs[s.key].out.textContent = Number(c[s.key]).toFixed(2);
      }
      els.blendRow.replaceChildren(
        ...view.blendModes.map((mode) => {
          const b = document.createElement('button');
          b.textContent = mode;
          b.classList.toggle('on', mode === c.blend);
          b.addEventListener('click', () => handlers.onLayerBlend(mode));
          return b;
        }),
      );
    },

    setError: (msg) => {
      els.error.hidden = !msg;
      els.error.textContent = msg
        ? `Shader error (previous shader kept running):\n${msg}` : '';
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
    setSyncPreset: (name) => {
      for (const b of syncButtons) b.classList.toggle('on', b.dataset.sync === name);
    },
    setAgc: (on) => { agc.classList.toggle('on', on); },
    setAudioGainValue: (v) => {
      els.gain.value = v;
      els.gainVal.textContent = Number(v).toFixed(2);
    },
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
