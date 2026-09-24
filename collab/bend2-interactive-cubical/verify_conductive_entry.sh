#!/usr/bin/env bash
# End-to-end check of the compiler-generated conductive path.
set -euo pipefail
BEND="${1:-bend}"
HVM="${2:-hvm}"
HERE="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

"$BEND" "$HERE/conductive_entry_smoke.bend" --to-hvm4-full > "$TMP/raw.hvm4"
python3 "$HERE/check_conductive_entry.py" "$TMP/raw.hvm4"

# The full target now routes @main through the intrinsic lossless presentation.
# The original checked entry is retained as @sourceMain for exact differential
# testing; no textual retargeting of the generated net is necessary.
OUT="$("$HVM" "$TMP/raw.hvm4" -s 2>&1)"
printf '%s\n' "$OUT"
printf '%s\n' "$OUT" | grep -Eq '(^|[^0-9])2([^0-9]|$)' || {
  echo "intrinsic conductive main did not report 2" >&2
  exit 1
}
echo "CONDUCTIVE-RUNTIME OK"

# Execute the retained continuation directly by changing only the root name.
python3 - "$TMP/raw.hvm4" "$TMP/twice.hvm4" <<'PY'
import pathlib, re, sys
src = pathlib.Path(sys.argv[1]).read_text()
src = re.sub(r'(?m)^@main = .*$', '@main = @conductiveTwiceMain', src, count=1)
pathlib.Path(sys.argv[2]).write_text(src)
PY
OUT2="$("$HVM" "$TMP/twice.hvm4" -s 2>&1)"
printf '%s\n' "$OUT2"
printf '%s\n' "$OUT2" | grep -Eq '(^|[^0-9])2([^0-9]|$)' || {
  echo "conductive continuation smoke did not report 2" >&2
  exit 1
}
echo "CONDUCTIVE-CONTINUATION OK"
