#!/usr/bin/env bash
# End-to-end check of the compiler-generated conductive path.
# Usage:
#   ./verify_conductive_entry.sh /path/to/bend /path/to/hvm
set -euo pipefail
BEND="${1:-bend}"
HVM="${2:-hvm}"
HERE="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

"$BEND" "$HERE/conductive_entry_smoke.bend" --to-hvm4-full > "$TMP/raw.hvm4"
python3 "$HERE/check_conductive_entry.py" "$TMP/raw.hvm4"

# HVM4 executes @main. Retarget the emitted program to the compiler-generated
# identity observation while preserving the ordinary source main as
# @ordinary_main. The generated conductive definitions must then reduce to the
# same value (2), through fibreCoalgebra -> observe -> FibreElement projection.
python3 - "$TMP/raw.hvm4" "$TMP/run.hvm4" <<'PY'
import pathlib, sys
src = pathlib.Path(sys.argv[1]).read_text()
# HVM definition references are token-like here; this smoke program has no
# user identifier containing "main", so exact @main replacement is sufficient.
src = src.replace("@main", "@ordinary_main")
src += "\n@main = @conductiveMain\n"
pathlib.Path(sys.argv[2]).write_text(src)
PY

OUT="$("$HVM" "$TMP/run.hvm4" -s 2>&1)"
printf '%s\n' "$OUT"
# HVM versions differ in stats formatting; require the resulting numeral 2 to
# occur as the reported normal form, while the command itself must exit 0.
printf '%s\n' "$OUT" | grep -Eq '(^|[^0-9])2([^0-9]|$)' || {
  echo "conductive runtime smoke did not report 2" >&2
  exit 1
}
echo "CONDUCTIVE-RUNTIME OK"
