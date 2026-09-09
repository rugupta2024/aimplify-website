const base = import.meta.env.BASE_URL;

/**
 * Prefix a site-root-relative path with the deploy base path.
 *
 * Cloudflare serves from the root ("/"), GitHub Pages from a subpath
 * ("/aimplify-website/"), so links have to be built rather than hardcoded.
 */
export function url(path: string): string {
	return `${base.replace(/\/+$/, "")}/${path.replace(/^\/+/, "")}`;
}
