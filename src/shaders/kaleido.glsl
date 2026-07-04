// Kaleido — mirrored-wedge kaleidoscope over the webcam.
// pinch→segment count, tilt→rotation, bass→radial pulse, hand→sample center,
// mouth→bloom, smile→trail length, mid→radial hue sweep.

void main() {
  vec2 st = v_uv - 0.5;
  st.x *= u_res.x / max(u_res.y, 1.0);

  float seg = floor(mix(3.0, 11.0, u_pinch));
  float wedge = 6.2831853 / seg;
  float a = atan(st.y, st.x) + u_time * 0.2 + u_tilt * 1.5;
  float r = length(st) * (1.0 - u_bass * 0.3) + sin(u_time * 0.5) * 0.02;

  a = mod(a, wedge);
  a = abs(a - wedge * 0.5);

  vec2 uv = vec2(cos(a), sin(a)) * r + 0.5 + (u_hand - 0.5) * 0.35;
  vec3 col = cam(uv).rgb;
  col = hueRotate(col, r * 3.0 * u_mid + u_tilt);

  float lum = dot(col, vec3(0.299, 0.587, 0.114));
  col += col * smoothstep(0.55, 1.0, lum) * (u_mouth * 2.0 + u_level * 0.5);
  col += audioGlow(uv) * (1.0 - smoothstep(0.0, 0.4, lum));

  // Feedback: previous frame, slightly rotated and shrunk → spiral smear.
  float ca = 0.02 * sin(u_time * 0.3);
  vec2 pv = mat2(cos(ca), -sin(ca), sin(ca), cos(ca)) * (v_uv - 0.5) * 0.995;
  vec3 trail = texture(u_prev, pv + 0.5).rgb;
  col = max(col, trail * (0.5 + u_smile * 0.35));

  outColor = vec4(col, 1.0);
}
