// Chroma Glitch — RGB split + blocky glitch + feedback smear toward the hand.
// treble→RGB split, bass→block glitch, hand→smear target, smile→posterize,
// brow→inversion strobe, tilt→hue.

void main() {
  vec2 uv = v_uv;
  float t = u_time;

  // Blocky horizontal displacement, gated by bass.
  float blocks = mix(6.0, 24.0, hash21(vec2(floor(t * 0.5), 3.7)));
  vec2 cell = floor(uv * vec2(blocks, blocks * 1.8));
  float jitter = hash21(cell + floor(t * 8.0));
  float gAmt = smoothstep(0.75, 1.0, jitter) * (u_bass * 0.15 + 0.005);
  uv.x += (jitter - 0.5) * gAmt * 2.0;

  float split = 0.002 + u_treble * 0.03;
  vec3 col;
  col.r = cam(uv + vec2(split, 0.0)).r;
  col.g = cam(uv).g;
  col.b = cam(uv - vec2(split, split * 0.5)).b;

  // Smear the previous frame toward the hand position.
  vec2 toHand = (u_hand - v_uv) * (0.02 + u_level * 0.04);
  vec3 sm = texture(u_prev, v_uv + toHand).rgb;
  col = mix(col, max(col, sm * 0.96), 0.5 + u_mid * 0.3);

  col += audioGlow(uv) * (1.0 - smoothstep(0.0, 0.4, dot(col, vec3(0.333))));

  float steps = mix(24.0, 4.0, u_smile);
  col = floor(col * steps) / steps;

  // Brow raise strobes an inversion.
  col = mix(col, 1.0 - col, step(0.97, sin(t * 9.0) * u_brow));
  col = hueRotate(col, u_tilt * 2.0);

  outColor = vec4(col, 1.0);
}
