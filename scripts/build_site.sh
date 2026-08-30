#!/usr/bin/env bash
# Build the static architecture portal into public/:
#   public/index.html          landing page
#   public/<workspace>/        one site-generatr site per audience workspace
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/scripts/env.sh"

WORKSPACES=(Enterprise Technology Security Integration)

rm -rf "$ROOT/public"
mkdir -p "$ROOT/public"

for ws in "${WORKSPACES[@]}"; do
    echo "==> Generating site for $ws workspace"
    out_dir="$ROOT/build/site-$ws"
    rm -rf "$out_dir"
    (cd "$ROOT/workspaces/$ws" && "$SITE_GENERATR" generate-site \
        --workspace-file workspace.dsl \
        --default-branch main \
        --output-dir "$out_dir")
    lower="$(echo "$ws" | tr '[:upper:]' '[:lower:]')"
    mv "$out_dir" "$ROOT/public/$lower"
done

cp "$ROOT/scripts/portal-index.html" "$ROOT/public/index.html"
echo "==> Portal built in public/ ($(du -sh "$ROOT/public" | cut -f1))"
