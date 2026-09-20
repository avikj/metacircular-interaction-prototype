#!/usr/bin/env bash
# The suite. Every .bend must check clean, EXCEPT the files registered below,
# which must each contain at least one rejected definition (the soundness
# probes: a proof that must not go through). Run: ./suite.sh [path-to-bend]
#
# If you add a file containing a deliberate failure, REGISTER IT HERE — an
# unregistered one reads as a regression, and a registered file that suddenly
# passes reads as the checker having gone unsound.
set -u
export LC_ALL=C.utf8 LANG=C.utf8   # without this bend aborts silently (0/0)
BEND="${1:-$(cat /tmp/BENDBIN 2>/dev/null || echo bend)}"
MUSTFAIL="coinduction_mustfail erasure glue_mustfail hfill kan_mustfail quotient_mustfail sub_mustfail transp_mustfail partial_mustfail circle_mustfail truncation_mustfail hit_circle_mustfail hit_mustfail
          silence_mustfail uaequiv_mustfail uaroundtrip"
cd "$(dirname "$0")" || exit 1
bad=0; n=0
for f in *.bend; do
  nm=$(basename "$f" .bend); n=$((n+1))
  out=$(timeout 300 "$BEND" "$f" 2>&1)
  ok=$(printf '%s' "$out" | grep -c "✓"); ko=$(printf '%s' "$out" | grep -c "✗")
  if printf '%s' "$MUSTFAIL" | tr -s ' \n' '\n\n' | grep -qx "$nm"; then
    [ "$ko" -ge 1 ] || { echo "MUSTFAIL-PASSED $nm (expected a rejection, got none)"; bad=$((bad+1)); }
  else
    { [ "$ko" -eq 0 ] && [ "$ok" -ge 1 ]; } || { echo "FAIL $nm ok=$ok ko=$ko"; bad=$((bad+1)); }
  fi
done
echo "files=$n bad=$bad"; [ "$bad" -eq 0 ]
