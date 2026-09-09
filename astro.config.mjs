// @ts-check
import { defineConfig } from 'astro/config';

// Fully static: `astro build` emits plain HTML/CSS into dist/. No server,
// no adapter, no secrets.
//
// The same source deploys to two places, which need different URLs:
//   - GitHub Pages serves from a subpath: rugupta2024.github.io/aimplify-website
//   - Cloudflare Pages serves from the root: aimplify.work
// The GitHub Actions workflow sets GITHUB_PAGES=true; Cloudflare doesn't.
const isGitHubPages = process.env.GITHUB_PAGES === 'true';

export default defineConfig({
	output: 'static',
	site: isGitHubPages
		? 'https://rugupta2024.github.io'
		: 'https://aimplify.work',
	base: isGitHubPages ? '/aimplify-website' : '/',
});
