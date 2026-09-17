#!/usr/bin/env bash
set -euo pipefail

: "${BEND_BIN:?Set BEND_BIN to the existing checked Bend2 executable}"
: "${HVM_BIN:?Set HVM_BIN to the HVM4 executable}"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fixture="$repo_root/collab/bend2-cubical/path_transport.bend"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

"$BEND_BIN" "$fixture" --total > "$work/check.log"
rg -q -- '--total: every definition is \[total\] or \[productive\]' "$work/check.log"

"$BEND_BIN" "$fixture" --to-hvm4-full > "$work/program.hvm4"
"$HVM_BIN" "$work/program.hvm4" -s -C10 > "$work/run.log"
rg -q '^0 ' "$work/run.log"

cat "$work/run.log"
