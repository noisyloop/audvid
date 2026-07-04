# audvid

A fully client-side, browser-based audiovisual shader synth. Your webcam and
body motion (face expressions, hand position, pinch) drive GLSL shaders in
real time, audio adds another layer of reactivity, and you record the result
straight to a video file — 9:16 by default, ready for Reels.

Everything runs in your browser on your GPU. There are no accounts, no
database, and no backend: the camera feed, the mic, your audio files, and
your custom shaders never leave the device. Recording and snapshots are
assembled locally and saved as plain downloads.

## Features

- **156 shaders**: 6 camera-reactive built-ins plus a 150-shader generative
  library (fractals, raymarched 3D, sacred geometry, glitch, retro, flow,
  volumetric, …) ported from the prism-video-synth project into audvid's
  GLSL ES 3.00 uniform contract.
- **Layers** (up to 4): stack shaders with per-layer opacity, speed, scale,
  intensity, visibility, and blend mode (normal / add / screen / multiply).
  Feedback shaders smear the composite of everything below them.
- **Custom shaders**: paste or load a `.glsl` fragment body in the UI. Input
  is sanitized (directives stripped, contract-uniform re-declarations
  removed, control characters dropped) and capped (32KB per shader, 16
  shaders, stored only in localStorage — nothing is uploaded, so it costs
  the static host zero bandwidth). Legacy WebGL1 shaders using
  `gl_FragColor` / `u_resolution` are converted automatically, so prism
  shaders paste straight in.
- **Live audio reactivity control**: the 🔊 slider scales how hard the
  visuals ride the music (0–3×) and can be ridden live while recording.
- **Sync presets** (⚡ Snappy / Balanced / Smooth): one tap sets both
  smoothing stages — the FFT analyser's time constant and the mapping
  layer's response taus — because they stack. Snappy lands a visual event
  within a frame or two of the kick. Alongside the smoothed bands the audio
  engine runs onset detection (`bassHit`/`midHit`/`trebleHit`): a fast
  attack / slow-reference transient per band, so every shader gets a crisp
  beat pulse no matter how smooth the sustained bands are. Mic mode is
  first-class: hotter input gain, a noise floor so hiss reads as silence,
  and auto-gain (AGC, on by default for mic) so a quiet room drives the
  visuals as hard as a mastered file. Preset, AGC, and reactivity choices
  persist in localStorage.
- **Face/hand tracking** via MediaPipe: jaw, smile, brow, head tilt, hand
  position, pinch — all remappable to any uniform (hit Randomize).

## Run locally

```sh
npm i
npm run dev
```

Open the printed URL (localhost counts as a secure context, so camera/mic
permissions work). `npm run build` produces a static `dist/` you can serve
from any static file host — no server code anywhere.

One hosting requirement: the host must let you set two response headers on
every page, or face/hand tracking (and any future threaded work) can't
initialize:

```
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Embedder-Policy: require-corp
```

Both `vite dev` and `vite preview` already send these (see `vite.config.js`).

## How it fits together

```
src/core/     renderer: WebGL2 layered shader compositor (runtime-swappable
              programs, compile errors surface in the UI without killing the
              loop); layers: the layer-stack data model
src/inputs/   camera (getUserMedia), audio (file/mic → bass/mid/treble/level
              + master gain), tracking (MediaPipe face + hand landmarks,
              throttled ~16fps)
src/mapping/  data-driven routes: input signals → shader uniforms; Randomize
              scrambles them
src/shaders/  the uniform-contract prelude, 6 camera shaders, library/ (150
              ported .glsl files), custom shader sanitizing + storage
src/ui/       controls, shader picker + custom editor, recorder, downloads
src/main.js   thin orchestrator — wires modules, owns the render loop
```

Modules only exchange plain data objects; none imports another's internals.

### Writing a shader

A shader is a fragment *body* (helpers + `void main()` writing `outColor`);
a shared prelude declares the contract, which every layer receives:

```
u_res, u_time, u_bass, u_mid, u_treble, u_level (sustained bands 0..1),
u_bassHit, u_midHit, u_trebleHit (beat onsets 0..1 — sharp attack, ~120ms
release; identity-locked so Randomize never scrambles the beat away),
u_hand (vec2), u_pinch, u_mouth, u_smile, u_brow, u_tilt,
u_cam (webcam sampler2D), u_prev (previous composited frame — feedback),
u_camRes, u_speed / u_scale / u_intensity (per-layer params)
```

Helpers available: `cam(uv)` (mirrored, cover-fit webcam), `hueRotate`,
`hash21`, `audioGlow`, and `audioPop(color)` — a guaranteed-legible audio
response (level rides brightness, onsets flash) that every library shader
routes its final color through, so no shader ever feels dead to the music. Open the app with `?verify` in the URL to
compile-check every registered shader and log failures to the console.

## Audio: what works and what can't

- **Audio file (mp3/wav/etc.)** — the primary path. Decoded and looped locally,
  analyzed per frame into `{ bass, mid, treble, level }`.
- **Microphone** — reacts to whatever is playing in the room. The mic is
  analyzed only and never routed to the speakers (that would feed back).
- **Spotify / Apple Music / system audio: not possible.** Browsers expose no
  API for other apps' audio, and DRM streams are sandboxed. Play the track out
  loud and use the mic instead.

## Recording & export

- Record captures the canvas plus the active audio source, entirely on-device.
  Layer sliders, blend modes, and the reactivity slider all stay live while
  recording — performing the controls is part of the instrument.
- The recorder tries **MP4/H.264 first** (Safari, recent Chrome) — that file
  is directly Instagram-ready. Where MP4 recording isn't supported it falls
  back to **WebM**, which Instagram dislikes; convert on desktop (HandBrake,
  `ffmpeg -i in.webm -c:v libx264 -c:a aac out.mp4`). The UI tells you which
  one you got.
- 📸 saves a JPG snapshot of the current frame.
- Formats: 9:16 (default), 4:5, 1:1, 16:9 at 720p or 1080p.

## Performance notes

- Rendering runs at display rate (30–60fps); face/hand tracking runs on its
  own throttled ~16fps loop and the renderer just reads its latest snapshot —
  it never blocks on detection. Tuned to stay smooth on a recent iPhone.
- Every layer is a fullscreen shader pass — that's why the stack is capped at
  4. Raymarched 3D shaders are the heaviest; if a phone stutters, drop a
  layer, avoid stacking multiple 3D shaders, or record at 720p.
- The MediaPipe WASM runtime and models are lazy-loaded from public CDNs on
  first camera start (a few MB, cached after that). They are deliberately not
  bundled.

## Privacy

Camera, mic, audio files, custom shaders, recordings: all processed and kept
locally in the browser. The only network traffic the app makes is fetching
its own static files and the tracking models from a CDN.
