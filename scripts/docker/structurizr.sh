#!/usr/bin/env bash
# structurizr in Docker; takes the same arguments as .tools/structurizr-cli/structurizr.sh.
exec "$(dirname "$0")/run.sh" "$STRUCTURIZR_IMAGE" "$@"
