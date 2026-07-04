// VHS Cam — worn-tape webcam: tracking bands, chroma bleed, dropouts.
// bass→tracking wobble, treble→static, mouth→band height, tilt→hue drift,
// pinch→tape warp, level→brightness pump, smile→saturation crush.

void main() {
  vec2 uv = v_uv;
  float t = u_time;

  // tape warp: pinch bows the frame
  vec2 c = uv - 0.5;
  uv = c * (1.0 + dot(c, c) * u_pinch * 0.6) + 0.5;

  // roaming tracking band
  float band = fract(uv.y * (1.0 + u_mouth * 2.0) - t * 0.11);
  float tear = smoothstep(0.0, 0.04, band) * smoothstep(0.12, 0.05, band);
  uv.x += tear * (hash21(vec2(floor(t * 9.0), 1.0)) - 0.3) * (0.05 + u_bass * 0.25);
  uv.x += (hash21(vec2(floor(uv.y * 120.0), floor(t * 17.0))) - 0.5) * 0.006;

  float bleed = 0.004 + u_bass * 0.01;
  vec3 col;
  col.r = cam(uv + vec2(bleed, 0.0)).r;
  col.g = cam(uv).g;
  col.b = cam(uv - vec2(bleed, 0.0)).b;

  // static + dropouts
  float snow = hash21(uv * u_res.xy * 0.5 + t * 60.0);
  col = mix(col, vec3(snow), tear * 0.7 + u_treble * 0.12 * snow);
  float grey = dot(col, vec3(0.299, 0.587, 0.114));
  col = mix(col, vec3(grey), u_smile * 0.6);

  col = hueRotate(col, u_tilt * 1.2);
  col *= 0.85 + u_level * 0.4;
  col *= 0.9 + 0.1 * sin(v_uv.y * u_res.y * 1.8 * max(u_scale, 0.1));
  col += audioGlow(uv) * 0.3;

  outColor = vec4(col * u_intensity, 1.0);
}
