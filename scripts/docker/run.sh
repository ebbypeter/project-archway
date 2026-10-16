#!/usr/bin/env bash
# Run a containerised tool as if it were installed locally:
#   scripts/docker/run.sh <image> [tool arguments...]
#
# The repository is mounted at its own absolute path and the working directory
# is kept, so relative and absolute paths in the arguments mean the same thing
# inside the container as outside it (the workspace pulls in ../models, so the
# whole repository must be visible, not just workspace/). The container runs as
# the calling user, so build output is not left owned by root.
set -euo pipefail

image="$1"
shift

root="$(git rev-parse --show-toplevel)"
case "$PWD" in
    "$root" | "$root"/*) ;;
    *) echo "scripts/docker/run.sh: run from inside the repository ($root)" >&2; exit 1 ;;
esac

exec docker run --rm \
    --user "$(id -u):$(id -g)" \
    -e HOME=/tmp \
    -v "$root:$root" \
    -w "$PWD" \
    "$image" "$@"
