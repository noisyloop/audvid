// Thin orchestrator: constructs the modules, wires UI handlers, and owns the
// requestAnimationFrame loop. All cross-module traffic is plain data — the
// inputs snapshot goes into mapping, mapping's shared uniform bag is merged
// with each layer's params, and the resulting pass list goes to the renderer.

import './ui/styles.css';
import { createRenderer, BLEND_MODES } from './core/renderer.js';
import { createLayers, MAX_LAYERS } from './core/layers.js';
import { listShaders, listCategories, getShader, fullSource } from './shaders/index.js';
import { sanitizeShaderSource, addCustomShader, removeCustomShader } from './shaders/custom.js';
import { createCamera } from './inputs/camera.js';
import { createAudio } from './inputs/audio.js';
import { createTracking } from './inputs/tracking.js';
import { createMapping } from './mapping/mappings.js';
import { initControls } from './ui/controls.js';
import { initShaderPicker } from './ui/shaderPicker.js';
import { createRecorder } from './ui/recorder.js';
import { downloadBlob, stamp } from './ui/download.js';

const canvas = document.getElementById('canvas');
const renderer = createRenderer(canvas);
const camera = createCamera();
const audio = createAudio();
const tracking = createTracking(() => camera.frame());
const mapping = createMapping();
const layers = createLayers('cam:0');

let photoPending = false;

// --- shader program cache -------------------------------------------------
// Compiled lazily per shader key; `false` marks a failed compile so a broken
// shader doesn't retry every frame.
const programs = new Map();

function programFor(key) {
  if (!programs.has(key)) {
    const shader = getShader(key);
    const res = renderer.compile(fullSource(shader));
    if (!res.ok) {
      ui.setError(`${shader.name}\n${res.error}`);
      programs.set(key, false);
    } else {
      programs.set(key, res.program);
    }
  }
  return programs.get(key) || null;
}

/** Compile-check without touching the cache (for custom shader validation). */
function tryCompile(body) {
  const res = renderer.compile(PRELUDE_SOURCE + body);
  if (res.ok) renderer.release(res.program);
  return res;
}
// fullSource needs a shader object; reuse its prelude via a tiny fake.
const PRELUDE_SOURCE = fullSource({ body: '' });

const pickerData = () => ({
  shaders: listShaders().map(({ key, name, category }) => ({ key, name, category })),
  categories: listCategories(),
  currentKey: layers.selected().shaderKey,
});

const shaderKeys = () => listShaders().map((s) => s.key);

// --- recorder ---------------------------------------------------------------
const recorder = createRecorder(canvas, {
  getAudioStream: () => audio.getRecordStream(),
  onStart: () => {
    ui.setRecording(true);
    ui.setStatus('Recording… layer + reactivity tweaks stay live.');
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

// --- UI wiring --------------------------------------------------------------
function layersView() {
  const cur = layers.selected();
  const shader = getShader(cur.shaderKey);
  return {
    tabs: layers.list().map((l) => ({
      name: getShader(l.shaderKey).name,
      visible: l.visible,
    })),
    selected: layers.selectedIndex(),
    canAdd: layers.count() < MAX_LAYERS,
    canRemove: layers.count() > 1,
    blendModes: BLEND_MODES,
    current: {
      shaderName: shader.name,
      shaderCat: shader.category,
      visible: cur.visible,
      blend: cur.blend,
      opacity: cur.opacity,
      speed: cur.speed,
      scale: cur.scale,
      intensity: cur.intensity,
    },
  };
}

const refreshLayers = () => ui.setLayers(layersView());

const ui = initControls({
  onStart: () => setCamera(true),

  // layers
  onLayerSelect: (i) => { layers.select(i); refreshLayers(); },
  onLayerAdd: () => {
    const keys = shaderKeys();
    layers.add(keys[Math.floor(Math.random() * keys.length)]);
    refreshLayers();
  },
  onLayerRemove: () => { layers.remove(layers.selectedIndex()); refreshLayers(); },
  onLayerToggleVisible: () => {
    layers.update(layers.selectedIndex(), { visible: !layers.selected().visible });
    refreshLayers();
  },
  onLayerDice: () => {
    layers.randomize(layers.selectedIndex(), shaderKeys());
    refreshLayers();
  },
  onLayerParam: (key, value) => layers.update(layers.selectedIndex(), { [key]: value }),
  onLayerBlend: (mode) => {
    layers.update(layers.selectedIndex(), { blend: mode });
    refreshLayers();
  },
  onOpenPicker: () => picker.open(pickerData()),

  onRandomize: () => {
    layers.randomizeAll(shaderKeys());
    mapping.randomize();
    ui.setMappingText(mapping.describe());
    refreshLayers();
  },
  onAudioGain: (g) => audio.setGain(g),

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

const picker = initShaderPicker({
  onSelect: (key) => {
    layers.update(layers.selectedIndex(), { shaderKey: key });
    ui.setError('');
    refreshLayers();
  },
  onCustomSave: (name, source) => {
    const clean = sanitizeShaderSource(source);
    if (!clean.ok) return clean;
    const compiled = tryCompile(clean.body);
    if (!compiled.ok) return { ok: false, error: compiled.error };
    try {
      const entry = addCustomShader(name, clean.body);
      layers.update(layers.selectedIndex(), { shaderKey: `custom:${entry.id}` });
      refreshLayers();
      picker.refresh(pickerData());
      ui.setStatus(`Custom shader "${entry.name}" saved (this browser only).`);
      return { ok: true };
    } catch (e) {
      return { ok: false, error: e.message };
    }
  },
  onCustomDelete: (key) => {
    removeCustomShader(key.replace(/^custom:/, ''));
    programs.delete(key);
    // Any layer still pointing at the deleted shader falls back to builtin 0.
    layers.list().forEach((l, i) => {
      if (l.shaderKey === key) layers.update(i, { shaderKey: 'cam:0' });
    });
    refreshLayers();
    picker.refresh(pickerData());
  },
});

// --- camera / audio ---------------------------------------------------------
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

// --- render loop ------------------------------------------------------------
// Renders at display rate; tracking runs on its own throttled loop and is
// only *read* here, never awaited.

let lastTime = performance.now();

function frame(now) {
  const dt = Math.min((now - lastTime) / 1000, 0.1); // clamp tab-switch spikes
  lastTime = now;

  const snap = tracking.snapshot();
  const shared = mapping.update(
    { audio: audio.getBands(), face: snap.face, hand: snap.hand },
    dt,
  );

  layers.tick(dt);
  const passes = [];
  for (const l of layers.list()) {
    if (!l.visible) continue;
    const program = programFor(l.shaderKey);
    if (!program) continue;
    passes.push({
      program,
      blend: l.blend,
      uniforms: {
        ...shared,
        u_time: l.time,
        u_speed: 1, // speed already folded into l.time (see layers.js)
        u_scale: l.scale,
        u_intensity: l.intensity * l.opacity,
      },
    });
  }
  renderer.draw(passes, camera.frame());

  if (photoPending) {
    photoPending = false;
    // Must run in the same task as the draw: preserveDrawingBuffer is off, so
    // the backbuffer is only readable before the browser composites.
    canvas.toBlob((b) => b && downloadBlob(b, `audvid-${stamp()}.jpg`), 'image/jpeg', 0.92);
  }

  ui.setRecTime(recorder.isRecording() ? recorder.elapsed() : null);
  requestAnimationFrame(frame);
}

// --- boot -------------------------------------------------------------------
refreshLayers();
ui.setMappingText(mapping.describe());
ui.setAudioMode('none');
ui.setStatus('Stack layers, dial a look, then hit record. Nothing leaves your device.');
requestAnimationFrame(frame);

// Dev aid: open with ?verify to compile-check the whole registry (used by CI
// smoke tests and handy after adding library shaders). No-op otherwise.
if (new URLSearchParams(location.search).has('verify')) {
  const failures = [];
  for (const s of listShaders()) {
    const res = renderer.compile(fullSource(s));
    if (res.ok) renderer.release(res.program);
    else failures.push({ name: s.name, key: s.key, error: res.error.slice(0, 500) });
  }
  window.__audvidVerify = { total: listShaders().length, failures };
  console.log('[verify]', JSON.stringify(window.__audvidVerify));
}
