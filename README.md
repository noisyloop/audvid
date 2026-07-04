# audvid

A fully client-side, browser-based audiovisual shader synth. Your webcam and
body motion (face expressions, hand position, pinch) drive GLSL shaders in
real time, audio adds another layer of reactivity, and you record the result
straight to a video file — 9:16 by default, ready for Reels.

Everything runs in your browser on your GPU. There are no accounts, no
database, and no backend: the camera feed, the mic, and your audio files never
leave the device. Recording and snapshots are assembled locally and saved as
plain downloads.

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
src/core/     WebGL2 fullscreen-quad shader runner (swappable at runtime,
              compile errors surface in the UI without killing the loop)
src/inputs/   camera (getUserMedia), audio (file/mic → bass/mid/treble/level),
              tracking (MediaPipe face + hand landmarks, throttled ~16fps)
src/mapping/  data-driven routes: input signals → shader uniforms; Randomize
              scrambles them
src/shaders/  4 starter fragment shaders + the shared uniform prelude
src/ui/       controls, recorder, downloads, styles
src/main.js   thin orchestrator — wires modules, owns the render loop
```

Modules only exchange plain data objects; none imports another's internals.

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
- The MediaPipe WASM runtime and models are lazy-loaded from public CDNs on
  first camera start (a few MB, cached after that). They are deliberately not
  bundled.
- 1080p recording is heavier than 720p on phones; if recording stutters, drop
  to 720p.

## Privacy

Camera, mic, audio files, recordings: all processed and kept locally in the
browser. The only network traffic the app makes is fetching its own static
files and the tracking models from a CDN.
