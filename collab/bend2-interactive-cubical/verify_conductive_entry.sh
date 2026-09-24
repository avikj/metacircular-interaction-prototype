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
printf '%s\n' "$OUT" | grep -Fq '#Suc{#Suc{#Zer{}}}' || {
  echo "intrinsic conductive main did not report 2" >&2
  exit 1
}
echo "NATIVE-RUNTIME OK"

# Execute the first lossless observation companion explicitly and require the
# same visible result.
python3 - "$TMP/raw.hvm4" "$TMP/conductive.hvm4" <<'PY'
import pathlib, re, sys
src = pathlib.Path(sys.argv[1]).read_text()
src = re.sub(r'(?m)^@main = [^\n]*', '@main = @conductiveMain', src, count=1)
pathlib.Path(sys.argv[2]).write_text(src)
PY
OUTC="$("$HVM" "$TMP/conductive.hvm4" -s 2>&1)"
printf '%s\n' "$OUTC"
printf '%s\n' "$OUTC" | grep -Fq '#Suc{#Suc{#Zer{}}}' || exit 1
echo "CONDUCTIVE-RUNTIME OK"

# Execute the retained continuation directly by changing only the root name.
python3 - "$TMP/raw.hvm4" "$TMP/twice.hvm4" <<'PY'
import pathlib, re, sys
src = pathlib.Path(sys.argv[1]).read_text()
src = re.sub(r'(?m)^@main = [^\n]*', '@main = @conductiveTwiceMain', src, count=1)
pathlib.Path(sys.argv[2]).write_text(src)
PY
OUT2="$("$HVM" "$TMP/twice.hvm4" -s 2>&1)"
printf '%s\n' "$OUT2"
printf '%s\n' "$OUT2" | grep -Fq '#Suc{#Suc{#Zer{}}}' || {
  echo "conductive continuation smoke did not report 2" >&2
  exit 1
}
echo "CONDUCTIVE-CONTINUATION OK"
