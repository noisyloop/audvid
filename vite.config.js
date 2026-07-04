import { defineConfig } from 'vite';

// COOP/COEP make the origin cross-origin-isolated. MediaPipe's WASM and any
// future threaded work (SharedArrayBuffer, e.g. ffmpeg.wasm) require it.
// Under COEP require-corp, cross-origin assets must be served with CORS/CORP
// headers — jsDelivr (MediaPipe WASM) and Google's model CDN both do.
const isolationHeaders = {
  'Cross-Origin-Opener-Policy': 'same-origin',
  'Cross-Origin-Embedder-Policy': 'require-corp',
};

export default defineConfig({
  server: { headers: isolationHeaders },
  preview: { headers: isolationHeaders },
  build: { target: 'es2022' },
});
