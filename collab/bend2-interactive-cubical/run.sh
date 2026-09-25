#!/usr/bin/env bash
# Build from the vendored sources (build.sh) and run the suite.
# Usage: bash run.sh [NEW_BUILD_DIRECTORY]
set -Eeuo pipefail
HERE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
WORK=${1:-$(mktemp -d -u /tmp/bend-cubical-XXXXXX)}
bash "$HERE/build.sh" "$WORK"
source "$WORK/env.sh"
bash "$HERE/suite.sh" "$BEND"
