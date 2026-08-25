#!/bin/sh
# Build the interface the other carrier is handed, and run its checks.
#
#   interactive/check-karana.sh
#
# Green means:
#   * the tool schema generated from the running dispatch table covers every
#     operation and every parameter the kernel actually dispatches on, the
#     kernel's own `optional` prose agrees with the requiredness this lane
#     authors, and the tool-name change carries an exact inverse;
#   * every declared parameter was probed against the RUNNING dispatcher with
#     a wrongly-typed value, and the ones the kernel refuses were refused BY
#     NAME.  The two it does not refuse are printed as a written defect, not
#     as a red: they are in the kernel lane's file (see check-sabha.sh's
#     header on why a single red across two lanes merges two facts);
#   * the training-record builder turns a real transcript into records and
#     the records round-trip as JSON.
#
# It does NOT mean the schema is true of anything the kernel does not tell it.
# `interactive/karana sima` is the list of what this whole assembly cannot do, and
# it is part of the deliverable, not a caveat on it.
set -e
root=$(cd "$(dirname "$0")/.." && pwd)
out=${TMPDIR:-/tmp}/karana-build
mkdir -p "$out"

ghc -O0 -i"$root/machine" -outputdir "$out" -o "$root/interactive/karana" \
    "$root/interactive/AnyatKaranaRun.hs" >"$out/build.log" 2>&1 \
  || { echo "the build failed:"; grep -E "error" -A6 "$out/build.log" | head -30; exit 1; }
echo "built."
echo

"$root/interactive/karana" pariksa
echo

# The schema must be readable by the thing it is handed to.  If jq is here,
# use it; if not, say that the check did not run rather than printing a green
# for a check that was skipped.
if command -v jq >/dev/null 2>&1; then
  n=$("$root/interactive/karana" sadhana --kevala | jq 'length')
  echo "schema: valid JSON, $n tools"
  "$root/interactive/karana" sadhana | jq -e '.["uttara-rupa"].margau | length == 2' >/dev/null \
    && echo "schema: the answer contract states two roads and no third"
else
  echo "NOT RUN: jq is absent, so the schema was not parsed by a second reader."
fi
echo

# End to end: a scripted session through the kernel, then records out of it.
lekha=$out/check-karana-session.jsonl
rm -f "$lekha"
SABHA_LEKHA=$lekha "$root/interactive/check-sabha.sh" >/dev/null 2>&1 || true
if [ -s "$lekha" ]; then
  "$root/interactive/karana" abhyasa "$lekha" > "$out/check-karana-abhyasa.jsonl"
  echo "abhyasa: $(wc -l < "$out/check-karana-abhyasa.jsonl") record(s) from $(wc -l < "$lekha") transcript line(s)"
else
  echo "NOT RUN: no transcript was produced, so the record builder was not exercised."
fi
