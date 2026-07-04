// Halftone Cam — the webcam as a pulsing CMYK-ish dot screen.
// scale→dot density, bass→dot swell, treble→dot jitter, tilt→screen angle,
// mouth→color split, smile→invert blend, level→brightness.

float dotChannel(vec2 uv, float angle, float lum, float cell) {
  float c = cos(angle);
  float s = sin(angle);
  vec2 p = mat2(c, -s, s, c) * uv * cell;
  vec2 f = fract(p) - 0.5;
  float r = (1.0 - lum) * (0.55 + u_bass * 0.35);
  return smoothstep(r, r - 0.12, length(f));
}

void main() {
  vec2 uv = v_uv;
  uv.x *= u_res.x / max(u_res.y, 1.0);
  float cell = 60.0 * max(u_scale, 0.1);
  float jit = u_treble * 0.01;
  uv += vec2(hash21(uv + u_time), hash21(uv - u_time)) * jit;

  float base = u_tilt * 0.6;
  float split = u_mouth * 0.35;
  vec3 src = cam(v_uv).rgb;
  float lum = dot(src, vec3(0.299, 0.587, 0.114)) * (0.7 + u_level * 0.6);

  vec3 col;
  col.r = dotChannel(uv, base + 0.26 + split, lum, cell);
  col.g = dotChannel(uv, base + 1.05, lum, cell);
  col.b = dotChannel(uv, base + 1.83 - split, lum, cell);
  col *= mix(vec3(1.0), src * 1.6, 0.65);
  col = mix(col, 1.0 - col, u_smile * 0.5);
  col += audioGlow(v_uv) * (1.0 - lum);

  outColor = vec4(col * u_intensity, 1.0);
}
