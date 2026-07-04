// Shader registry. Each starter shader is a fragment-shader *body* (helpers +
// main); PRELUDE prepends the shared uniform contract and sampling helpers.
//
// Uniform contract (every shader gets the same flat bag):
//   u_res, u_time, u_bass, u_mid, u_treble, u_level, u_hand (vec2), u_pinch,
//   u_mouth, u_smile, u_brow, u_tilt, u_cam (sampler2D)
// Plus two renderer-provided extras beyond the contract:
//   u_prev (sampler2D) — previous frame, for feedback effects
//   u_camRes (vec2)    — camera pixel size, used by camUV() for cover-fit

import liquid from './liquid.glsl?raw';
import kaleido from './kaleido.glsl?raw';
import smear from './smear.glsl?raw';
import tunnel from './tunnel.glsl?raw';

export const PRELUDE = `#version 300 es
precision highp float;

in vec2 v_uv;
out vec4 outColor;

uniform vec2  u_res;
uniform float u_time;
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

export const shaders = [
  { name: 'Liquid Mirror', body: liquid },
  { name: 'Kaleido', body: kaleido },
  { name: 'Chroma Glitch', body: smear },
  { name: 'Echo Tunnel', body: tunnel },
];

export function fullSource(shader) {
  return PRELUDE + '\n' + shader.body;
}
