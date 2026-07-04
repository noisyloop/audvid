// User-supplied custom shaders: sanitize, cap, persist in localStorage.
//
// Everything stays on the visitor's device — a custom shader is never
// uploaded anywhere, so it costs the static host zero bandwidth. The caps
// below are about keeping the *client* healthy: bounded localStorage use,
// bounded compile times, and no prelude-hijacking directives. GLSL itself is
// sandboxed by the browser (it can't touch the page or the network); the
// worst a hostile shader can do is render garbage or run slow, and a compile
// failure is surfaced in the UI without killing the running visual.

export const MAX_SHADER_BYTES = 32 * 1024; // one shader source
export const MAX_CUSTOM_SHADERS = 16;
const MAX_STORE_BYTES = 256 * 1024;        // whole persisted set
const LS_KEY = 'audvid.customShaders.v1';

// Uniforms the prelude already declares — user re-declarations must be
// stripped or the program would fail with duplicate-declaration errors.
const CONTRACT_UNIFORM = /^\s*uniform\s+\w+\s+u_(?:res|resolution|time|speed|scale|intensity|bass|mid|treble|level|hand|pinch|mouth|smile|brow|tilt|cam|prev|camRes)[\w,\s]*;\s*$/gm;

/**
 * Normalize + validate a pasted/imported fragment body. Accepts both the
 * audvid format (bare body writing to outColor) and legacy WebGL1 shaders in
 * the prism style (gl_FragColor / u_resolution / own precision+uniform
 * declarations) — those are auto-converted.
 * Returns { ok: true, body } or { ok: false, error }.
 */
export function sanitizeShaderSource(input) {
  if (typeof input !== 'string') return { ok: false, error: 'Not text.' };
  let b = input.replace(/\r\n?/g, '\n');
  // Strip control characters that can hide content or break storage
  // (keep \n and \t).
  b = b.replace(/[\u0000-\u0008\u000B-\u001F\u007F]/g, '');
  if (new TextEncoder().encode(b).length > MAX_SHADER_BYTES) {
    return { ok: false, error: `Shader too large (max ${MAX_SHADER_BYTES / 1024}KB).` };
  }
  // The prelude owns the version/extension/precision story. #include does
  // not exist in WebGL GLSL; strip it rather than let it hit the compiler.
  b = b.replace(/^\s*#\s*(?:version|extension|include|pragma)[^\n]*$/gm, '');
  b = b.replace(/precision\s+\w+\s+\w+\s*;/g, '');
  b = b.replace(CONTRACT_UNIFORM, '');
  // Legacy WebGL1 → our ES3 contract.
  b = b.replace(/\bu_resolution\b/g, 'u_res');
  b = b.replace(/\bgl_FragColor\b/g, 'outColor');
  b = b.trim();
  if (!b) return { ok: false, error: 'Empty shader.' };
  if (!/void\s+main\s*\(/.test(b)) {
    return { ok: false, error: 'Shader needs a void main() that writes outColor.' };
  }
  if (/\bout\s+vec4\s+outColor\s*;/.test(b)) {
    return { ok: false, error: 'Remove "out vec4 outColor;" — the prelude declares it.' };
  }
  return { ok: true, body: b + '\n' };
}

function load() {
  try {
    const list = JSON.parse(localStorage.getItem(LS_KEY) ?? '[]');
    return Array.isArray(list) ? list : [];
  } catch {
    return [];
  }
}

function save(list) {
  const json = JSON.stringify(list);
  if (json.length > MAX_STORE_BYTES) {
    throw new Error('Custom shader storage is full — delete one first.');
  }
  localStorage.setItem(LS_KEY, json);
}

export function listCustomShaders() {
  return load();
}

/**
 * Add a sanitized shader. Compilation is the caller's job (it needs a GL
 * context); pass the body through sanitizeShaderSource + a renderer compile
 * check before calling this. Returns the stored entry.
 */
export function addCustomShader(name, body) {
  const list = load();
  if (list.length >= MAX_CUSTOM_SHADERS) {
    throw new Error(`Custom shader limit reached (${MAX_CUSTOM_SHADERS}).`);
  }
  const cleanName = String(name).replace(/[^\w ()\-.]/g, '').trim().slice(0, 40)
    || `Custom ${list.length + 1}`;
  const entry = { id: `${Date.now().toString(36)}${Math.floor(Math.random() * 1e6).toString(36)}`, name: cleanName, body };
  list.push(entry);
  save(list);
  return entry;
}

export function removeCustomShader(id) {
  save(load().filter((s) => s.id !== id));
}
