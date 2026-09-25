#!/usr/bin/env bash
# The mining runner builds with the one build script (vendored sources).
exec bash "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/../build.sh" "$@"
