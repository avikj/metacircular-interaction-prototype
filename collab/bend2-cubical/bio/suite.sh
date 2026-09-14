#!/usr/bin/env bash
# The biology presentations: every file must check clean (no ✗), and each main
# must run on the full cubical HVM4 runtime.  Imports resolve against port/, so
# the checker is run from there.  Usage: bio/suite.sh [bend-binary] [hvm-binary]
set -u
export LC_ALL=C.utf8 LANG=C.utf8
BEND="${1:-$(cat /tmp/BENDBIN 2>/dev/null || echo bend)}"
HVM="${2:-${HVM:-/tmp/HVM4/src/hvm}}"
here="$(cd "$(dirname "$0")" && pwd)"
cd "$here/../port" || exit 1
bad=0
for nm in Descent Perturbation Segmentation Pangenome; do
  out=$(timeout 1800 "$BEND" "../bio/$nm.bend" 2>&1)
  ok=$(printf '%s' "$out" | grep -c "✓"); ko=$(printf '%s' "$out" | grep -c "✗")
  if [ "$ko" -eq 0 ] && [ "$ok" -ge 1 ]; then
    "$BEND" "../bio/$nm.bend" --to-hvm4-full > "/tmp/bio_$nm.hvm4" 2>/dev/null
    run=$("$HVM" "/tmp/bio_$nm.hvm4" -s 2>&1)
    res=$(printf '%s' "$run" | grep -v "^-" | tail -1); itrs=$(printf '%s' "$run" | sed -n 's/.*Itrs: *\([0-9]*\).*/\1/p')
    echo "OK   $nm  checks=$ok  main=$res  itrs=$itrs"
  else
    echo "FAIL $nm ok=$ok ko=$ko"; bad=$((bad+1))
  fi
done
echo "bad=$bad"; [ "$bad" -eq 0 ]
