// Echo Tunnel — infinite feedback zoom centered on the hand.
// level→zoom speed, bass→rotation kick, mouth→camera injection gate,
// brow→brightness, tilt→hue drift, smile→gentler decay (longer echoes).

void main() {
  vec2 c = u_hand;
  vec2 st = v_uv - c;

  float zoom = 0.965 - u_level * 0.05 - u_bass * 0.02;
  float rot = u_tilt * 0.06 + sin(u_time * 0.4) * 0.02 + u_bass * 0.05;
  mat2 m = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
  vec2 pv = m * st * zoom + c;

  vec3 fb = texture(u_prev, clamp(pv, 0.0, 1.0)).rgb;
  fb = hueRotate(fb, 0.06 + u_tilt * 0.1);
  fb *= 0.975 + u_smile * 0.015; // decay keeps feedback from blowing out

  vec3 live = cam((v_uv - 0.5) / max(u_scale, 0.1) + 0.5).rgb;
  float lum = dot(live, vec3(0.299, 0.587, 0.114));
  // Inject the camera where it is bright; opening the mouth opens the gate.
  float gate = smoothstep(0.75 - u_mouth * 0.45, 0.95, lum);

  vec3 col = max(fb, live * gate);
  col += live * 0.08; // faint live layer so the screen is never empty
  col += audioGlow(v_uv) * 0.5;
  col *= 0.9 + u_brow * 0.5;

  outColor = vec4(min(col * u_intensity, vec3(1.0)), 1.0);
}
