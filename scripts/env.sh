# Source this file (bash or zsh) to select the repo tooling.
# Usage: source scripts/env.sh
#
# Docker is the primary option: each tool runs from its pinned image when
# Docker is running and that image has been pulled (`make setup` pulls them).
# Otherwise the tool falls back to the local install in .tools/.
#
#   AAC_USE_DOCKER=0      always use .tools/ (CI does this, to use its cache)
#   STRUCTURIZR_IMAGE=x   use a different structurizr image
#   SITE_GENERATR_IMAGE=x use a different site generator image

_AAC_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
_AAC_TOOLS="$_AAC_ROOT/.tools"

# Pinned images — bump here.
: "${STRUCTURIZR_IMAGE:=structurizr/structurizr:2026.09.19}"
: "${SITE_GENERATR_IMAGE:=ghcr.io/avisi-cloud/structurizr-site-generatr:1.6.0}"
export STRUCTURIZR_IMAGE SITE_GENERATR_IMAGE

# Local tooling (the fallback).
if [ -x "$_AAC_TOOLS/jre/bin/java" ]; then
    export JAVA_HOME="$_AAC_TOOLS/jre"
    export PATH="$JAVA_HOME/bin:$PATH"
fi

if [ -x "$_AAC_TOOLS/graphviz/bin/dot" ]; then
    export PATH="$_AAC_TOOLS/graphviz/bin:$PATH"
fi

# True when Docker is usable and the image is present locally. Never pulls:
# a missing image means "use the local install", not "download it now".
_aac_docker_image() {
    [ "${AAC_USE_DOCKER:-1}" != "0" ] &&
        command -v docker >/dev/null 2>&1 &&
        docker image inspect "$1" >/dev/null 2>&1
}

if _aac_docker_image "$STRUCTURIZR_IMAGE"; then
    export STRUCTURIZR_CLI="$_AAC_ROOT/scripts/docker/structurizr.sh"
    _aac_cli_source="docker $STRUCTURIZR_IMAGE"
else
    export STRUCTURIZR_CLI="$_AAC_TOOLS/structurizr-cli/structurizr.sh"
    _aac_cli_source="local .tools/structurizr-cli"
fi

if _aac_docker_image "$SITE_GENERATR_IMAGE"; then
    export SITE_GENERATR="$_AAC_ROOT/scripts/docker/structurizr-site-generatr.sh"
    _aac_generatr_source="docker $SITE_GENERATR_IMAGE"
else
    export SITE_GENERATR="$_AAC_TOOLS/structurizr-site-generatr/bin/structurizr-site-generatr"
    _aac_generatr_source="local .tools/structurizr-site-generatr"
fi

echo "==> structurizr: $_aac_cli_source; site generator: $_aac_generatr_source" >&2
unset -f _aac_docker_image
unset _aac_cli_source _aac_generatr_source
