// Layer state: an ordered stack of { shaderKey, opacity, speed, scale,
// intensity, blend, visible, time }. Pure data + bookkeeping — no GL, no DOM.
//
// Per-layer time is accumulated CPU-side (time += dt * speed) instead of
// letting shaders compute u_time * u_speed, so dragging the speed slider
// mid-recording glides instead of jumping.

import { BLEND_MODES } from './renderer.js';

// Every layer is a fullscreen fragment pass; phones run out of GPU fast.
export const MAX_LAYERS = 4;

const rnd = (a, b) => a + Math.random() * (b - a);

export function createLayers(defaultShaderKey) {
  let nextId = 1;
  let layers = [];
  let selected = 0;

  function makeLayer(shaderKey) {
    return {
      id: nextId++,
      shaderKey,
      opacity: 1,
      speed: 0.5,
      scale: 1,
      intensity: 1,
      blend: 'add',
      visible: true,
      time: 0,
    };
  }

  layers.push(makeLayer(defaultShaderKey));

  function clampSelection() {
    selected = Math.min(Math.max(selected, 0), layers.length - 1);
  }

  return {
    list: () => layers,
    count: () => layers.length,
    selectedIndex: () => selected,
    selected: () => layers[selected],
    select(i) {
      selected = i;
      clampSelection();
    },

    add(shaderKey) {
      if (layers.length >= MAX_LAYERS) return null;
      const l = makeLayer(shaderKey);
      l.opacity = 0.7;
      layers.push(l);
      selected = layers.length - 1;
      return l;
    },

    remove(i) {
      if (layers.length <= 1) return;
      layers.splice(i, 1);
      clampSelection();
    },

    update(i, patch) {
      Object.assign(layers[i], patch);
    },

    randomize(i, shaderKeys) {
      Object.assign(layers[i], {
        shaderKey: shaderKeys[Math.floor(Math.random() * shaderKeys.length)],
        opacity: rnd(0.3, 1),
        speed: rnd(0.1, 1.8),
        scale: rnd(0.3, 2.5),
        intensity: rnd(0.5, 2),
        blend: BLEND_MODES[Math.floor(Math.random() * BLEND_MODES.length)],
      });
    },

    randomizeAll(shaderKeys) {
      for (let i = 0; i < layers.length; i++) this.randomize(i, shaderKeys);
    },

    /** Advance per-layer clocks; call once per rendered frame. */
    tick(dt) {
      for (const l of layers) l.time += dt * l.speed;
    },
  };
}
