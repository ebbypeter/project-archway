#!/usr/bin/env bash
# Build the static architecture portal into build/site/.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/scripts/env.sh"

python3 "$ROOT/scripts/aggregate_docs.py"

rm -rf "$ROOT/build/site"

echo "==> Generating site"
(cd "$ROOT/workspace" && "$SITE_GENERATR" generate-site \
    --workspace-file workspace.dsl \
    --default-branch main \
    --assets-dir site \
    --output-dir "$ROOT/build/site")

python3 "$ROOT/scripts/inject_section_nav.py"

echo "==> Portal built in build/site/ ($(du -sh "$ROOT/build/site" | cut -f1))"

python3 "$ROOT/scripts/verify_published.py"
