// Data-driven mapping layer: routes input signals → shader uniforms.
//
// The inputs snapshot is a plain object:
//   { audio: {bass,mid,treble,level}, face: {mouth,smile,brow,tilt}, hand: {x,y,pinch} }
// Each route says which source feeds which uniform, with a gain and a
// smoothing time constant. Because shaders only ever see the uniform bag,
// remapping (pinch→u_mouth, handY→u_bass, ...) changes the whole feel of a
// shader without touching GLSL — that is what Randomize scrambles.

const SOURCES = {
  bass: (i) => i.audio.bass,
  mid: (i) => i.audio.mid,
  treble: (i) => i.audio.treble,
  level: (i) => i.audio.level,
  bassHit: (i) => i.audio.bassHit ?? 0,
  midHit: (i) => i.audio.midHit ?? 0,
  trebleHit: (i) => i.audio.trebleHit ?? 0,
  mouth: (i) => i.face.mouth,
  smile: (i) => i.face.smile,
  brow: (i) => i.face.brow,
  tilt: (i) => i.face.tilt,
  pinch: (i) => i.hand.pinch,
  handX: (i) => i.hand.x,
  handY: (i) => i.hand.y,
};

const SCALAR_TARGETS = [
  'u_bass', 'u_mid', 'u_treble', 'u_level',
  'u_bassHit', 'u_midHit', 'u_trebleHit',
  'u_mouth', 'u_smile', 'u_brow', 'u_tilt', 'u_pinch',
];

// The hit uniforms stay identity-routed even under Randomize: every shader's
// beat flash keys off them, so scrambling them away would make whole layers
// stop reading the beat (the exact "feels dead" bug this exists to fix).
const LOCKED_TARGETS = new Set(['u_bassHit', 'u_midHit', 'u_trebleHit']);

// Natural (identity) source for each uniform.
const IDENTITY = {
  u_bass: 'bass', u_mid: 'mid', u_treble: 'treble', u_level: 'level',
  u_bassHit: 'bassHit', u_midHit: 'midHit', u_trebleHit: 'trebleHit',
  u_mouth: 'mouth', u_smile: 'smile', u_brow: 'brow', u_tilt: 'tilt',
  u_pinch: 'pinch',
};

// Smoothing time constants (seconds): audio fast, body a touch slower.
const DEFAULT_TAU = {
  bass: 0.06, mid: 0.06, treble: 0.05, level: 0.08,
  // hits carry their own attack/release envelope (bandProcessor.js) — the
  // mapping barely smooths them so the flash lands the frame it fires
  bassHit: 0.015, midHit: 0.015, trebleHit: 0.015,
  mouth: 0.1, smile: 0.15, brow: 0.12, tilt: 0.15,
  pinch: 0.1, handX: 0.12, handY: 0.12,
};

const clamp = (v, lo, hi) => Math.min(hi, Math.max(lo, v));

export function createMapping() {
  let routes = defaultRoutes();
  const smoothed = {};
  // One knob for the whole response feel: multiplies every route's tau.
  // Snappy (<1) tightens everything at once; smooth (>1) loosens it.
  let tauScale = 1;

  function defaultRoutes() {
    const r = {};
    for (const t of SCALAR_TARGETS) {
      const source = IDENTITY[t];
      r[t] = { source, gain: 1, tau: DEFAULT_TAU[source] };
    }
    r.u_hand = { gainX: 1, gainY: 1, tau: DEFAULT_TAU.handX };
    return r;
  }

  function smooth(key, target, dt, tau) {
    const prev = smoothed[key];
    if (prev === undefined) {
      smoothed[key] = target;
      return target;
    }
    const k = 1 - Math.exp(-dt / Math.max(tau, 1e-3));
    smoothed[key] = prev + (target - prev) * k;
    return smoothed[key];
  }

  /** Compute this frame's uniform bag from the inputs snapshot. */
  function update(inputs, dt) {
    const out = {};
    for (const t of SCALAR_TARGETS) {
      const rt = routes[t];
      const raw = (SOURCES[rt.source]?.(inputs) ?? 0) * rt.gain;
      const lo = t === 'u_tilt' ? -1 : 0; // tilt is the one bipolar uniform
      out[t] = smooth(t, clamp(raw, lo, 1), dt, rt.tau * tauScale);
    }
    const rh = routes.u_hand;
    const hx = clamp(0.5 + (inputs.hand.x - 0.5) * rh.gainX, 0, 1);
    const hy = clamp(0.5 + (inputs.hand.y - 0.5) * rh.gainY, 0, 1);
    out.u_hand = [
      smooth('u_hand.x', hx, dt, rh.tau * tauScale),
      smooth('u_hand.y', hy, dt, rh.tau * tauScale),
    ];
    return out;
  }

  /** Scramble the routing: random sources, gains, and response speeds. */
  function randomize(rng = Math.random) {
    const pool = Object.keys(SOURCES);
    for (const t of SCALAR_TARGETS) {
      if (LOCKED_TARGETS.has(t)) continue;
      // Keep the natural mapping about a third of the time so results stay legible.
      const source = rng() < 0.35 ? IDENTITY[t] : pool[Math.floor(rng() * pool.length)];
      routes[t] = {
        source,
        gain: 0.6 + rng() * 1.1,
        tau: 0.04 + rng() * 0.25,
      };
    }
    routes.u_hand = {
      gainX: rng() < 0.15 ? -1 : 1, // occasionally flip the hand axes
      gainY: rng() < 0.15 ? -1 : 1,
      tau: 0.06 + rng() * 0.2,
    };
  }

  function reset() {
    routes = defaultRoutes();
  }

  /** Human-readable routing table for the UI. */
  function describe() {
    const lines = SCALAR_TARGETS.map((t) => {
      const r = routes[t];
      return `${t.padEnd(9)} ← ${r.source.padEnd(7)} ×${r.gain.toFixed(2)}`;
    });
    const rh = routes.u_hand;
    lines.push(`u_hand    ← hand    ${rh.gainX < 0 ? '(x flipped)' : ''}${rh.gainY < 0 ? ' (y flipped)' : ''}`);
    return lines.join('\n');
  }

  function setTauScale(s) {
    tauScale = Math.min(3, Math.max(0.1, s));
  }

  return { update, randomize, reset, describe, setTauScale, getTauScale: () => tauScale };
}
