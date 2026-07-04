// Pure DSP for the analyser's per-frame band read: noise floor, per-source
// input gain, optional auto-gain (AGC), master gain, and per-band transient
// (onset) detection. No Web Audio here — plain numbers in, plain numbers
// out — so the timing-critical math is unit-testable outside a browser.

const BANDS = ['bass', 'mid', 'treble'];

const SLOW_TAU = 0.6;   // onset reference average (s) — what "the recent past" means
const HIT_RELEASE = 0.12; // onset envelope release (s) — how long a hit flashes
const ONSET_GAIN = 3.5; // raw positive delta → 0..1 hit strength
const ONSET_DEADZONE = 0.04; // ignore slow drift while the reference converges
const AGC_TAU = 4.0;    // rolling-peak decay (s)
const AGC_TARGET = 0.85; // where the rolling peak gets normalized to
const AGC_MAX_BOOST = 6.0; // quiet-room boost ceiling (noise floor guards silence)

const clamp01 = (v) => Math.min(1, Math.max(0, v));

export function createBandProcessor() {
  const slow = { bass: 0, mid: 0, treble: 0 };
  const hit = { bass: 0, mid: 0, treble: 0 };
  let peak = 0.25;

  /**
   * raw: { bass, mid, treble, level } straight from the analyser (0..1).
   * dt: seconds since last call.
   * cfg: { noiseFloor, inputGain, masterGain, autoGain }
   * Returns { bass, mid, treble, level, bassHit, midHit, trebleHit }.
   */
  function process(raw, dt, cfg) {
    dt = Math.min(Math.max(dt, 1e-4), 0.25);
    const vals = {};
    for (const b of [...BANDS, 'level']) {
      let v = raw[b] ?? 0;
      // Ambient mic hiss sits at a fairly constant low magnitude; subtracting
      // it and renormalizing makes silence read as 0 instead of ~0.05.
      if (cfg.noiseFloor > 0) {
        v = Math.max(0, v - cfg.noiseFloor) / (1 - cfg.noiseFloor);
      }
      vals[b] = v * cfg.inputGain;
    }

    if (cfg.autoGain) {
      // Rolling peak: jumps up instantly, decays over ~AGC_TAU seconds, so a
      // quiet room gets boosted but a loud passage corrects within a frame.
      peak = Math.max(vals.level, peak * Math.exp(-dt / AGC_TAU));
      const agc = Math.min(AGC_MAX_BOOST, AGC_TARGET / Math.max(peak, 0.05));
      for (const b in vals) vals[b] *= agc;
    } else {
      peak = Math.max(vals.level, 0.25);
    }

    const out = {};
    for (const b in vals) out[b] = clamp01(vals[b] * cfg.masterGain);

    // Onset per band: positive difference against a slow running average.
    // Instant attack (a spike registers the same frame it arrives) with an
    // exponential release so the flash reads even at 60fps.
    for (const b of BANDS) {
      slow[b] += (out[b] - slow[b]) * (1 - Math.exp(-dt / SLOW_TAU));
      const onset = Math.max(0, out[b] - slow[b] - ONSET_DEADZONE) * ONSET_GAIN;
      out[`${b}Hit`] = clamp01(Math.max(onset, hit[b] * Math.exp(-dt / HIT_RELEASE)));
      hit[b] = out[`${b}Hit`];
    }
    return out;
  }

  return { process };
}
