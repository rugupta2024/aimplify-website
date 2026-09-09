// @ts-check
import { defineConfig } from 'astro/config';

// https://astro.build/config
// Fully static: `astro build` emits plain HTML/CSS into dist/, which Cloudflare
// Pages serves directly. No server, no adapter, no secrets.
export default defineConfig({
	output: 'static',
	site: 'https://aimplify.work',
});
