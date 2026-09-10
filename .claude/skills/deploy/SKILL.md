---
name: deploy
description: Publish the aimplify.work site — commit any pending changes, push, watch the Cloudflare Pages deploy, and confirm the live site is serving. Use when the user says "deploy", "publish", "ship it", "push it live", or asks to put changes on aimplify.work.
---

# Deploy aimplify.work

One command publishes the site. Run it and report the result.

```bash
bash scripts/deploy.sh "<short commit message describing the change>"
```

Always pass a real commit message describing what changed. Only fall back to the
default if the change genuinely defies a one-line summary.

## What the script does

1. Stops early if there is nothing to publish
2. Builds locally first — a broken build never reaches production
3. Commits and pushes the current branch
4. Watches the GitHub Actions run to completion
5. On `main`, verifies https://aimplify.work returns HTTP 200

## Branch behaviour

- On `main` → publishes to production at https://aimplify.work
- On any other branch → deploys a **preview** and prints the run URL where the
  preview link appears. Production is untouched.

**Prefer a branch when the change is visual or substantial** — anything affecting
layout, styling, or page structure. Create one, deploy it, and give the user the
preview URL before touching production:

```bash
git checkout -b <short-descriptive-branch-name>
bash scripts/deploy.sh "<message>"
```

Go straight to `main` only for small, low-risk edits (copy fixes, typos) or when
the user explicitly asks to publish now.

## Reporting back

Tell the user plainly whether it published, and give them the URL — the live site
for `main`, or the Actions run for a preview. If the script exits non-zero, show
the failure it printed rather than re-running it blindly. A failed build means the
site was left untouched, which is the intended outcome — say so.

## Related

- Site config, including the per-host base path: `astro.config.mjs`
- Deploy workflow: `.github/workflows/deploy-cloudflare.yml`
- Secrets live in GitHub Actions, never in the repo
