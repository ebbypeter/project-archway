#!/usr/bin/env bash
# Build the static architecture portal into build/site/.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/scripts/env.sh"

# The published site is organised by branch, so the label must match the branch
# actually being built — otherwise develop work is published under /main/ and
# the branch selector lies. CI runners usually check out a detached HEAD, so
# their own ref variables are preferred over `git rev-parse`.
#   SITE_BRANCH=x  overrides everything (useful for a one-off preview build)
resolve_branch() {
    if [ -n "${SITE_BRANCH:-}" ]; then
        echo "$SITE_BRANCH"; return
    fi
    if [ -n "${GITHUB_REF_NAME:-}" ]; then          # GitHub Actions
        echo "$GITHUB_REF_NAME"; return
    fi
    if [ -n "${CI_COMMIT_REF_NAME:-}" ]; then       # GitLab CI
        echo "$CI_COMMIT_REF_NAME"; return
    fi
    local branch
    branch="$(git -C "$ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")"
    # Detached HEAD reports literally "HEAD"; fall back to a stable name.
    if [ -z "$branch" ] || [ "$branch" = "HEAD" ]; then
        echo "main"; return
    fi
    echo "$branch"
}

# Branch names may contain '/', which would nest the output directory and break
# the generator's relative asset links. Flatten to a single path segment.
BRANCH="$(resolve_branch | tr '/' '-')"

python3 "$ROOT/scripts/aggregate_docs.py"

rm -rf "$ROOT/build/site"

echo "==> Generating site for branch '$BRANCH'"
(cd "$ROOT/workspace" && "$SITE_GENERATR" generate-site \
    --workspace-file workspace.dsl \
    --default-branch "$BRANCH" \
    --assets-dir site \
    --output-dir "$ROOT/build/site")

python3 "$ROOT/scripts/inject_section_nav.py"

echo "==> Portal built in build/site/ ($(du -sh "$ROOT/build/site" | cut -f1)) — served at /$BRANCH/"

python3 "$ROOT/scripts/verify_published.py"
