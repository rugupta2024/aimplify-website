# Aimplify

Community website for [aimplify.work](https://aimplify.work). A fully static site
built with [Astro](https://astro.build) and hosted on
[Cloudflare Pages](https://pages.cloudflare.com).

There is no server, no API keys, and no secrets. Cloudflare builds the site from
GitHub on every push — you never need to build or deploy from your own machine.

## Project structure

```text
/
├── public/                 # Static assets (favicon, images)
├── src/
│   ├── layouts/
│   │   └── Layout.astro    # Shared page shell (header/footer/styles)
│   └── pages/
│       ├── index.astro     # Homepage (about + newsletter signup)
│       └── contact.astro   # Contact page (embedded Google Form)
└── package.json
```

## How deploys work

Push to `main` → Cloudflare builds and publishes. That's the whole loop.

Pushes to any other branch get their own **preview URL**, so you can look at a
change before it goes live on the real domain.

## One-time Cloudflare setup

1. In the Cloudflare dashboard: **Workers & Pages → Create → Pages → Connect to Git**,
   then pick this repo.
2. Build settings:
   - Framework preset: **Astro**
   - Build command: `npm run build`
   - Build output directory: `dist`
3. **Custom domains** → add `aimplify.work`. Cloudflare issues the HTTPS
   certificate automatically.

No environment variables are needed.

## Editing the site

You can edit these files directly on github.com and the change will deploy
itself — no local setup required.

| To change            | Edit                    |
| :------------------- | :---------------------- |
| Homepage / about text | `src/pages/index.astro` |
| Contact page          | `src/pages/contact.astro` |
| Header, footer, colors | `src/layouts/Layout.astro` |

## Things still to fill in

Two placeholders are waiting on accounts that only you can create:

- **Contact form** — create a Google Form, then in Google Forms click
  **Send → `< >` (embed)** and copy the long ID out of the URL. Paste it into
  `GOOGLE_FORM_ID` in `src/pages/contact.astro`. Responses land in a Google
  Sheet, and Google can email you on each new one.
- **Newsletter** — replace `YOUR_USERNAME` in `src/pages/index.astro` with your
  [Buttondown](https://buttondown.com) username (it appears twice). Or delete
  that `<section id="newsletter">` block if you don't want a newsletter.

## Running locally (optional)

Not required, but if you ever want it:

```sh
npm install
npm run dev      # http://localhost:4321
```
