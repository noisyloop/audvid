// Liquid Mirror — domain-warped webcam.
// bass→warp depth, mouth→ripple, pinch→zoom, tilt→hue, treble→chroma shimmer,
// smile→trail length, hand→swirl center.

vec2 swirl(vec2 st, vec2 c, float k) {
  vec2 d = st - c;
  float r = length(d);
  float a = atan(d.y, d.x) + k * exp(-r * 3.0);
  return c + r * vec2(cos(a), sin(a));
}

void main() {
  vec2 uv = v_uv;
  float t = u_time * 0.4;

  // bass onset punches the zoom for a frame-accurate kick
  float zoom = mix(1.15, 0.65, u_pinch) / max(u_scale, 0.1) * (1.0 - u_bassHit * 0.12);
  uv = (uv - 0.5) * zoom + 0.5;

  uv = swirl(uv, u_hand, (u_bass * 2.2 + 0.3) * sin(t * 0.7));

  float ripple = 0.008 + u_mouth * 0.05;
  uv.x += sin(uv.y * 24.0 + t * 5.0) * ripple;
  uv.y += cos(uv.x * 21.0 - t * 4.0) * ripple;

  vec2 warp = vec2(
    sin(uv.y * 6.0 + t * 2.0) + sin(uv.y * 17.0 - t * 3.1),
    sin(uv.x * 7.0 - t * 1.7) + sin(uv.x * 13.0 + t * 2.3)
  ) * (0.01 + u_bass * 0.05);

  vec3 col = cam(uv + warp).rgb;

  float sh = u_treble * 0.02 + u_trebleHit * 0.02;
  col.r = cam(uv + warp + vec2(sh, 0.0)).r;
  col.b = cam(uv + warp - vec2(sh, 0.0)).b;

  col = hueRotate(col, u_tilt * 1.8 + u_mid * 0.6);
  col += col * pow(u_level, 2.0) * 0.25;
  col += audioGlow(uv) * (1.0 - smoothstep(0.0, 0.4, dot(col, vec3(0.333))));

  vec3 trail = texture(u_prev, v_uv).rgb;
  col = max(col, trail * (0.35 + u_smile * 0.45));

  outColor = vec4(col * u_intensity, 1.0);
}
