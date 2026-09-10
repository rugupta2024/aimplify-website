#!/usr/bin/env bash
#
# One-command publish: verify, commit, push, watch the deploy, confirm it's live.
#
#   npm run deploy                  # uses a default commit message
#   npm run deploy "New about text" # your own message
#
set -euo pipefail

REPO="rugupta2024/aimplify-website"
SITE="https://aimplify.work"
MSG="${1:-Update site content}"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"

cd "$(git rev-parse --show-toplevel)"

# --- 1. Is there anything to publish? ------------------------------------
if [ -z "$(git status --porcelain)" ]; then
  echo "Nothing to publish — no changes since the last deploy."
  exit 0
fi

echo "About to publish these changes:"
git status --short | sed 's/^/   /'
echo

# --- 2. Catch a broken build here, not in production ---------------------
if [ -d node_modules ]; then
  printf 'Checking the site builds... '
  if npm run build --silent >/tmp/aimplify-build.log 2>&1; then
    echo "OK"
  else
    echo "FAILED"
    echo
    tail -20 /tmp/aimplify-build.log
    echo
    echo "Not publishing. Fix the build above, then run again."
    exit 1
  fi
fi

# --- 3. Commit and push --------------------------------------------------
git add -A
git commit -q -m "$MSG"
git push -q origin "$BRANCH"
echo "Pushed to $BRANCH."
echo

# --- 4. Follow the deploy ------------------------------------------------
sleep 5
run_id="$(gh run list --repo "$REPO" --workflow=deploy-cloudflare.yml \
            --branch "$BRANCH" --limit 1 --json databaseId --jq '.[0].databaseId')"

if [ -z "$run_id" ]; then
  echo "Pushed, but no deploy run appeared yet. Check:"
  echo "   https://github.com/$REPO/actions"
  exit 1
fi

gh run watch "$run_id" --repo "$REPO" --exit-status >/dev/null 2>&1 || {
  echo "Deploy FAILED. Details:"
  echo "   https://github.com/$REPO/actions/runs/$run_id"
  exit 1
}

# --- 5. Confirm it's actually serving ------------------------------------
if [ "$BRANCH" != "main" ]; then
  echo "Preview deployed for branch '$BRANCH'."
  echo "Preview URL is in the run summary:"
  echo "   https://github.com/$REPO/actions/runs/$run_id"
  echo
  echo "Happy with it? Merge to main to publish:"
  echo "   git checkout main && git merge $BRANCH && npm run deploy"
  exit 0
fi

printf 'Verifying %s ... ' "$SITE"
code="$(curl -sL --max-time 20 -o /dev/null -w '%{http_code}' "$SITE/")"
if [ "$code" = "200" ]; then
  echo "live (HTTP 200)"
  echo
  echo "Published: $SITE"
else
  echo "HTTP $code"
  echo "Deploy succeeded but the site returned $code. It may still be propagating."
  exit 1
fi
