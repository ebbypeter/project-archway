#!/usr/bin/env bash
# structurizr-site-generatr in Docker; takes the same arguments as the local install.
exec "$(dirname "$0")/run.sh" "$SITE_GENERATR_IMAGE" "$@"
