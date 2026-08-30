# Source this file (bash or zsh) to put the repo tooling on PATH.
# Usage: source scripts/env.sh

_AAC_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
_AAC_TOOLS="$_AAC_ROOT/.tools"

if [ -x "$_AAC_TOOLS/jre/bin/java" ]; then
    export JAVA_HOME="$_AAC_TOOLS/jre"
    export PATH="$JAVA_HOME/bin:$PATH"
fi

if [ -x "$_AAC_TOOLS/graphviz/bin/dot" ]; then
    export PATH="$_AAC_TOOLS/graphviz/bin:$PATH"
fi

export STRUCTURIZR_CLI="$_AAC_TOOLS/structurizr-cli/structurizr.sh"
export SITE_GENERATR="$_AAC_TOOLS/structurizr-site-generatr/bin/structurizr-site-generatr"
