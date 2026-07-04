// Shader registry. Three sources, one list:
//   - built-in camera shaders (bodies in this folder, use webcam + tracking)
//   - the ported library (src/shaders/library/*.glsl, generative — no camera)
//   - user customs (localStorage-backed, see custom.js)
// Every shader is a fragment *body*; PRELUDE prepends the shared contract.
//
// Uniform contract (every shader gets the same flat bag):
//   u_res, u_time, u_bass, u_mid, u_treble, u_level, u_hand (vec2), u_pinch,
//   u_mouth, u_smile, u_brow, u_tilt, u_cam (sampler2D)
// Per-layer additions (so one shader can run differently on each layer):
//   u_speed (always 1.0 — layer speed is applied to u_time CPU-side so live
//   speed changes don't jump; the uniform exists because the ported library
//   references it), u_scale, u_intensity (layer intensity × opacity)
// Renderer-provided extras:
//   u_prev (sampler2D) — previous composited frame, for feedback effects
//   u_camRes (vec2)    — camera pixel size, used by camUV() for cover-fit

import liquid from './liquid.glsl?raw';
import kaleido from './kaleido.glsl?raw';
import smear from './smear.glsl?raw';
import tunnel from './tunnel.glsl?raw';
import halftone from './halftone.glsl?raw';
import vhscam from './vhscam.glsl?raw';
import { listCustomShaders } from './custom.js';

export const PRELUDE = `#version 300 es
precision highp float;

in vec2 v_uv;
out vec4 outColor;

uniform vec2  u_res;
uniform float u_time;
uniform float u_speed;
uniform float u_scale;
uniform float u_intensity;
uniform float u_bass;
uniform float u_mid;
uniform float u_treble;
uniform float u_level;
uniform vec2  u_hand;
uniform float u_pinch;
uniform float u_mouth;
uniform float u_smile;
uniform float u_brow;
uniform float u_tilt;
uniform sampler2D u_cam;
uniform sampler2D u_prev;
uniform vec2  u_camRes;

// Cover-fit the camera into the canvas (crop, never letterbox) and mirror X
// so the front camera behaves like a mirror.
vec2 camUV(vec2 uv) {
  float ca = u_camRes.x / max(u_camRes.y, 1.0);
  float ra = u_res.x / max(u_res.y, 1.0);
  vec2 st = uv - 0.5;
  if (ca > ra) st.x *= ra / ca;
  else st.y *= ca / ra;
  st.x = -st.x;
  return clamp(st + 0.5, vec2(0.001), vec2(0.999));
}

vec4 cam(vec2 uv) { return texture(u_cam, camUV(uv)); }

vec3 hueRotate(vec3 c, float a) {
  const vec3 k = vec3(0.57735);
  float s = sin(a);
  float co = cos(a);
  return c * co + cross(k, c) * s + k * dot(k, c) * (1.0 - co);
}

float hash21(vec2 p) {
  p = fract(p * vec2(234.34, 435.345));
  p += dot(p, p + 34.23);
  return fract(p.x * p.y);
}

// Cheap audio-tinted glow so there is still something on screen when the
// camera is off or denied (audio-only mode).
vec3 audioGlow(vec2 uv) {
  vec3 c = 0.5 + 0.5 * cos(6.2831 * (uv.xyx * vec3(0.7, 0.9, 1.1))
                           + vec3(0.0, 2.1, 4.2) + u_time * 0.3);
  return c * (0.05 + u_bass * 0.2 + u_level * 0.1);
}
`;

const BUILTINS = [
  { name: 'Liquid Mirror', body: liquid },
  { name: 'Kaleido Cam', body: kaleido },
  { name: 'Chroma Glitch Cam', body: smear },
  { name: 'Echo Tunnel', body: tunnel },
  { name: 'Halftone Cam', body: halftone },
  { name: 'VHS Cam', body: vhscam },
].map((s, i) => ({
  key: `cam:${i}`,
  name: s.name,
  category: 'camera',
  body: s.body,
}));

// Eagerly bundle the whole ported library; each file carries its own
// name/category in header comments written by the conversion script.
const libraryFiles = import.meta.glob('./library/*.glsl', {
  query: '?raw',
  import: 'default',
  eager: true,
});

const LIBRARY = Object.entries(libraryFiles).map(([file, body]) => {
  const name = /^\/\/ name: (.+)$/m.exec(body)?.[1]
    ?? file.replace(/^.*\/|\.glsl$/g, '');
  const category = /^\/\/ category: (.+)$/m.exec(body)?.[1] ?? 'misc';
  return { key: `lib:${file.replace(/^.*\/|\.glsl$/g, '')}`, name, category, body };
}).sort((a, b) => a.name.localeCompare(b.name));

/** Full registry, customs included (re-read each call so adds show up). */
export function listShaders() {
  const customs = listCustomShaders().map((c) => ({
    key: `custom:${c.id}`,
    name: c.name,
    category: 'custom',
    body: c.body,
  }));
  return [...BUILTINS, ...LIBRARY, ...customs];
}

export function getShader(key) {
  return listShaders().find((s) => s.key === key) ?? BUILTINS[0];
}

export function listCategories() {
  const cats = new Set(listShaders().map((s) => s.category));
  return ['all', ...cats];
}

export function fullSource(shader) {
  return PRELUDE + '\n' + shader.body;
}
