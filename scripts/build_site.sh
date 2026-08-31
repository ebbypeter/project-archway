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

# The version shown in the portal's menu. Without this the generator stamps
# every build "0.0.0", which tells a reader nothing about what they are looking
# at. `git describe` is informative in every state:
#   tagged commit      -> v1.2.0
#   3 commits later    -> v1.2.0-3-g784ebc9
#   never tagged       -> 784ebc9        (--always falls back to the SHA)
#   uncommitted edits  -> ...-dirty      (built from unreviewed work)
# Set a release version by tagging:  git tag -a v1.0.0 -m "..."
#   SITE_VERSION=x  overrides everything.
resolve_version() {
    if [ -n "${SITE_VERSION:-}" ]; then
        echo "$SITE_VERSION"; return
    fi
    git -C "$ROOT" describe --tags --always --dirty 2>/dev/null || echo "0.0.0"
}

VERSION="$(resolve_version)"

python3 "$ROOT/scripts/aggregate_docs.py"

rm -rf "$ROOT/build/site"

echo "==> Generating site for branch '$BRANCH' (version $VERSION)"
(cd "$ROOT/workspace" && "$SITE_GENERATR" generate-site \
    --workspace-file workspace.dsl \
    --default-branch "$BRANCH" \
    --version "$VERSION" \
    --assets-dir site \
    --output-dir "$ROOT/build/site")

python3 "$ROOT/scripts/inject_section_nav.py"

echo "==> Portal built in build/site/ ($(du -sh "$ROOT/build/site" | cut -f1)) — served at /$BRANCH/"

python3 "$ROOT/scripts/verify_published.py"
