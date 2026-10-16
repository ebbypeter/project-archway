#!/usr/bin/env bash
# Install pinned tooling (idempotent, no root required).
#
# Docker is the primary option: when Docker is running, pull the pinned images
# (versions in scripts/env.sh). Any tool whose image cannot be pulled — or
# every tool, without Docker or with AAC_USE_DOCKER=0 — is downloaded into
# .tools/ instead: Temurin JRE 21 (only if no system Java), structurizr-cli,
# structurizr-site-generatr and Graphviz.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS="$ROOT/.tools"

CLI_VERSION="v2025.11.09"
SITE_GENERATR_VERSION="1.6.0"

source "$ROOT/scripts/env.sh" 2>/dev/null

need_local_cli=1
need_local_generatr=1
if [ "${AAC_USE_DOCKER:-1}" != "0" ] && command -v docker >/dev/null 2>&1 \
        && docker info >/dev/null 2>&1; then
    echo "==> Pulling $STRUCTURIZR_IMAGE"
    docker pull -q "$STRUCTURIZR_IMAGE" && need_local_cli=0 \
        || echo "    pull failed — falling back to a local structurizr-cli"
    echo "==> Pulling $SITE_GENERATR_IMAGE"
    docker pull -q "$SITE_GENERATR_IMAGE" && need_local_generatr=0 \
        || echo "    pull failed — falling back to a local structurizr-site-generatr"
fi

if [ "$need_local_cli$need_local_generatr" = "00" ]; then
    echo "==> Tooling ready (Docker images)"
    exit 0
fi

mkdir -p "$TOOLS"

# --- Java (user-space Temurin JRE 21 if no system Java 17+) ---
if ! command -v java >/dev/null 2>&1 && [ ! -x "$TOOLS/jre/bin/java" ]; then
    echo "==> Downloading Temurin JRE 21 (user-space, no root needed)"
    curl -fsSL -o "$TOOLS/jre.tar.gz" \
        "https://api.adoptium.net/v3/binary/latest/21/ga/linux/x64/jre/hotspot/normal/eclipse"
    mkdir -p "$TOOLS/jre"
    tar -xzf "$TOOLS/jre.tar.gz" -C "$TOOLS/jre" --strip-components=1
    rm "$TOOLS/jre.tar.gz"
fi

# --- structurizr-cli ---
if [ "$need_local_cli" = 1 ] && [ ! -f "$TOOLS/structurizr-cli/structurizr.sh" ]; then
    echo "==> Downloading structurizr-cli $CLI_VERSION"
    curl -fsSL -o "$TOOLS/structurizr-cli.zip" \
        "https://github.com/structurizr/cli/releases/download/$CLI_VERSION/structurizr-cli.zip"
    mkdir -p "$TOOLS/structurizr-cli"
    unzip -q -o "$TOOLS/structurizr-cli.zip" -d "$TOOLS/structurizr-cli"
    chmod +x "$TOOLS/structurizr-cli/structurizr.sh"
    rm "$TOOLS/structurizr-cli.zip"
fi

# --- structurizr-site-generatr ---
if [ "$need_local_generatr" = 1 ] && [ ! -f "$TOOLS/structurizr-site-generatr/bin/structurizr-site-generatr" ]; then
    echo "==> Downloading structurizr-site-generatr $SITE_GENERATR_VERSION"
    curl -fsSL -o "$TOOLS/site-generatr.tar.gz" \
        "https://github.com/avisi-cloud/structurizr-site-generatr/releases/download/$SITE_GENERATR_VERSION/structurizr-site-generatr-$SITE_GENERATR_VERSION.tar.gz"
    mkdir -p "$TOOLS/structurizr-site-generatr"
    tar -xzf "$TOOLS/site-generatr.tar.gz" -C "$TOOLS/structurizr-site-generatr" --strip-components=1
    chmod +x "$TOOLS/structurizr-site-generatr/bin/structurizr-site-generatr"
    rm "$TOOLS/site-generatr.tar.gz"
fi

# --- Graphviz (needed by a local site-generatr for diagram auto-layout;
# the Docker image ships its own) ---
if [ "$need_local_generatr" = 1 ] && ! command -v dot >/dev/null 2>&1 && [ ! -x "$TOOLS/graphviz/bin/dot" ]; then
    echo "==> Installing Graphviz user-space via micromamba (no root needed)"
    curl -fsSL -o "$TOOLS/micromamba.tar.bz2" \
        "https://micro.mamba.pm/api/micromamba/linux-64/latest"
    tar -xjf "$TOOLS/micromamba.tar.bz2" -C "$TOOLS" bin/micromamba
    rm "$TOOLS/micromamba.tar.bz2"
    "$TOOLS/bin/micromamba" create -y -q -p "$TOOLS/graphviz" -c conda-forge graphviz >/dev/null
fi

echo "==> Tooling ready in $TOOLS"
