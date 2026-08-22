#!/bin/sh
# run-paksa-krama.sh -- the three arms of PaksaKrama_*, from ONE snapshot of
# the sources and ONE binary, differing in one flag.
#
# Same discipline as machine/run-paksa.sh, and for the same reason recorded
# there: this host carries sixteen lanes, a same-source A/B was broken here on
# 2026-08-19 because two arms compiled at different times and a concurrent edit
# landed between them, and a per-arm sha256 did not catch it because each arm
# hashed what it had just built.  So: copy once, hash the copy, build the copy,
# run every arm out of the copy.  Every number printed is a statement about the
# hashes below and about nothing on disk.
#
# Exact: no clock is read, no arm is timed.  Every arm reprints the same four
# position counts and the same negative bound, so neither the order nor the
# falsifier can be quoted without them.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
SNAP=${KRAMA_SNAP:-$(mktemp -d "${TMPDIR:-/tmp}/paksakrama.XXXXXX")}
mkdir -p "$SNAP/machine"
cp "$ROOT"/machine/*.hs "$SNAP/machine/"
cp "$ROOT"/machine/library.terms "$SNAP/machine/"
cp "$ROOT"/machine/machine.log   "$SNAP/machine/"
ln -sfn "$ROOT/formal" "$SNAP/formal"

MAIN=machine/PaksaKrama_TheEightThousandFreeAcceptancesAreASetAndThisIsTheirOrder.hs

echo "SNAPSHOT $SNAP"
echo "  the bytes every arm is built and run from:"
for f in "$MAIN" \
         machine/PaksaLaksana_WhatIsWorthHandingTheKernelIsWhereTheTwoRewritersDisagree.hs \
         machine/BhavanaTheorem.hs machine/Obstruction.hs \
         machine/library.terms machine/machine.log ; do
  printf '    %s  %s\n' "$(shasum -a 256 "$SNAP/$f" | cut -c1-16)" "$f"
done
echo

cd "$SNAP"
ghc -O2 -imachine -outputdir "$SNAP/build" -o "$SNAP/krama" "$MAIN" > "$SNAP/ghc.log" 2>&1 \
  || { echo "BUILD FAILED, see $SNAP/ghc.log" ; exit 1 ; }
printf '  binary  %s\n\n' "$(shasum -a 256 "$SNAP/krama" | cut -c1-16)"

"$SNAP/krama" --self-test
echo
"$SNAP/krama" --krama "${KRAMA_TOP:-12}"
echo
if [ "$1" = "--anvaya" ] ; then
  "$SNAP/krama" --anvaya "${2:-8}"
else
  echo "  (the live-engine falsifier was not run; add:  sh machine/run-paksa-krama.sh --anvaya 8)"
fi
