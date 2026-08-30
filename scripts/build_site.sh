#!/usr/bin/env bash
# Build the static architecture portal into public/ from the single workspace.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/scripts/env.sh"

python3 "$ROOT/scripts/aggregate_docs.py"

rm -rf "$ROOT/public" "$ROOT/build/site"

echo "==> Generating site"
(cd "$ROOT/workspaces/Enterprise" && "$SITE_GENERATR" generate-site \
    --workspace-file workspace.dsl \
    --default-branch main \
    --output-dir "$ROOT/build/site")

mv "$ROOT/build/site" "$ROOT/public"
echo "==> Portal built in public/ ($(du -sh "$ROOT/public" | cut -f1))"
