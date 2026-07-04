// WebGL2 fullscreen-quad fragment-shader runner with layered compositing.
//
// The renderer knows nothing about inputs or layers-as-a-concept — callers
// compile() fragment sources into program handles, then hand draw() an
// ordered list of passes: { program, uniforms, blend }. Uniforms are a flat
// bag of {name: number | [x, y]}; the camera video (if any) is uploaded once
// per frame and shared by every pass. A compile error is returned to the
// caller so the UI can surface it without killing the render loop.
//
// It also maintains a "previous frame" texture (u_prev): after all passes
// composite, the backbuffer is copied into it, which is what lets shaders do
// cheap feedback (trails, tunnels) — feeding on the *whole* composite, so
// feedback shaders smear the layers below them too.

const VERT_SRC = `#version 300 es
layout(location = 0) in vec2 a_pos;
out vec2 v_uv;
void main() {
  v_uv = a_pos * 0.5 + 0.5;
  gl_Position = vec4(a_pos, 0.0, 1.0);
}`;

const SCALAR_UNIFORMS = [
  'u_time', 'u_speed', 'u_scale', 'u_intensity',
  'u_bass', 'u_mid', 'u_treble', 'u_level',
  'u_bassHit', 'u_midHit', 'u_trebleHit',
  'u_pinch', 'u_mouth', 'u_smile', 'u_brow', 'u_tilt',
];

export const BLEND_MODES = ['normal', 'add', 'screen', 'multiply'];

export function createRenderer(canvas) {
  const gl = canvas.getContext('webgl2', {
    antialias: false,
    alpha: false,
    preserveDrawingBuffer: false,
  });
  if (!gl) throw new Error('WebGL2 is not available in this browser.');

  // Fullscreen triangle (covers the viewport with a single primitive).
  const vao = gl.createVertexArray();
  gl.bindVertexArray(vao);
  const buf = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, buf);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1, -1, 3, -1, -1, 3]), gl.STATIC_DRAW);
  gl.enableVertexAttribArray(0);
  gl.vertexAttribPointer(0, 2, gl.FLOAT, false, 0, 0);

  function makeTexture() {
    const t = gl.createTexture();
    gl.bindTexture(gl.TEXTURE_2D, t);
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, 1, 1, 0, gl.RGBA, gl.UNSIGNED_BYTE,
      new Uint8Array([0, 0, 0, 255]));
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
    return t;
  }

  const camTex = makeTexture();
  const prevTex = makeTexture();
  let camW = 1;
  let camH = 1;

  const vertShader = compileStage(gl.VERTEX_SHADER, VERT_SRC).shader;

  function compileStage(type, src) {
    const shader = gl.createShader(type);
    gl.shaderSource(shader, src);
    gl.compileShader(shader);
    if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
      const log = gl.getShaderInfoLog(shader) || 'unknown shader error';
      gl.deleteShader(shader);
      return { shader: null, error: log };
    }
    return { shader, error: null };
  }

  /**
   * Compile a fragment source into a program handle.
   * Returns { ok: true, program } or { ok: false, error }.
   */
  function compile(fragSrc) {
    const frag = compileStage(gl.FRAGMENT_SHADER, fragSrc);
    if (frag.error) return { ok: false, error: frag.error };

    const prog = gl.createProgram();
    gl.attachShader(prog, vertShader);
    gl.attachShader(prog, frag.shader);
    gl.linkProgram(prog);
    gl.deleteShader(frag.shader); // program keeps a reference
    if (!gl.getProgramParameter(prog, gl.LINK_STATUS)) {
      const log = gl.getProgramInfoLog(prog) || 'unknown link error';
      gl.deleteProgram(prog);
      return { ok: false, error: log };
    }

    const locs = {};
    for (const name of [...SCALAR_UNIFORMS, 'u_res', 'u_camRes', 'u_hand', 'u_cam', 'u_prev']) {
      locs[name] = gl.getUniformLocation(prog, name); // null (= no-op) if unused
    }
    gl.useProgram(prog);
    gl.uniform1i(locs.u_cam, 0);
    gl.uniform1i(locs.u_prev, 1);
    return { ok: true, program: { prog, locs } };
  }

  function release(program) {
    if (program?.prog) gl.deleteProgram(program.prog);
  }

  /** Resize the drawing buffer (also reallocates the feedback texture). */
  function resize(w, h) {
    canvas.width = w;
    canvas.height = h;
    gl.bindTexture(gl.TEXTURE_2D, prevTex);
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, w, h, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
  }

  function setBlend(mode) {
    // All shaders output alpha = 1, so "normal" is a plain replace.
    if (mode === 'normal') {
      gl.disable(gl.BLEND);
      return;
    }
    gl.enable(gl.BLEND);
    if (mode === 'add') gl.blendFunc(gl.ONE, gl.ONE);
    else if (mode === 'screen') gl.blendFunc(gl.ONE, gl.ONE_MINUS_SRC_COLOR);
    else if (mode === 'multiply') gl.blendFunc(gl.DST_COLOR, gl.ZERO);
    else gl.disable(gl.BLEND);
  }

  /**
   * Composite one frame. `passes` is bottom-to-top: [{ program, uniforms,
   * blend }]. `video` is the camera element or null when the camera is off.
   */
  function draw(passes, video) {
    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.bindVertexArray(vao);

    gl.activeTexture(gl.TEXTURE0);
    gl.bindTexture(gl.TEXTURE_2D, camTex);
    if (video && video.videoWidth > 0) {
      // Flip so texture v=0 is the bottom of the image, matching v_uv space.
      gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, true);
      gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, video);
      gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, false);
      camW = video.videoWidth;
      camH = video.videoHeight;
    }
    gl.activeTexture(gl.TEXTURE1);
    gl.bindTexture(gl.TEXTURE_2D, prevTex);

    gl.disable(gl.BLEND);
    gl.clearColor(0, 0, 0, 1);
    gl.clear(gl.COLOR_BUFFER_BIT);

    for (let i = 0; i < passes.length; i++) {
      const { program, uniforms, blend } = passes[i];
      if (!program) continue;
      const { prog, locs } = program;
      gl.useProgram(prog);
      // The bottom layer always replaces the cleared black backdrop —
      // "multiply" against black would blank the whole frame.
      setBlend(i === 0 ? 'normal' : blend);

      gl.uniform2f(locs.u_res, canvas.width, canvas.height);
      gl.uniform2f(locs.u_camRes, camW, camH);
      const hand = uniforms.u_hand || [0.5, 0.5];
      gl.uniform2f(locs.u_hand, hand[0], hand[1]);
      for (const name of SCALAR_UNIFORMS) {
        gl.uniform1f(locs[name], uniforms[name] ?? 0);
      }
      gl.drawArrays(gl.TRIANGLES, 0, 3);
    }
    gl.disable(gl.BLEND);

    // Snapshot the composite for next frame's u_prev. Must happen in the
    // same task as the draw (before compositing clears the backbuffer,
    // since preserveDrawingBuffer is off).
    gl.activeTexture(gl.TEXTURE1);
    gl.copyTexSubImage2D(gl.TEXTURE_2D, 0, 0, 0, 0, 0, canvas.width, canvas.height);
  }

  resize(canvas.width, canvas.height);

  return { compile, release, resize, draw };
}
