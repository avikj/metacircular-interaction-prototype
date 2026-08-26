#!/bin/sh
# run-paksa-krama.sh -- the three arms of PaksaKrama_*, from ONE snapshot of
# the sources and ONE binary, differing in one flag.
#
# Same discipline as interactive/run-paksa.sh, and for the same reason recorded
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
cp "$ROOT"/interactive/*.hs "$SNAP/interactive/"
cp "$ROOT"/interactive/library.terms "$SNAP/interactive/"
cp "$ROOT"/interactive/machine.log   "$SNAP/interactive/"
ln -sfn "$ROOT/formal" "$SNAP/formal"

MAIN=interactive/PaksaKrama_TheEightThousandFreeAcceptancesAreASetAndThisIsTheirOrder.hs

echo "SNAPSHOT $SNAP"
echo "  the bytes every arm is built and run from:"
for f in "$MAIN" \
         interactive/PaksaLaksana_WhatIsWorthHandingTheKernelIsWhereTheTwoRewritersDisagree.hs \
         interactive/BhavanaTheorem.hs interactive/Obstruction.hs \
         interactive/library.terms interactive/machine.log ; do
  printf '    %s  %s\n' "$(shasum -a 256 "$SNAP/$f" | cut -c1-16)" "$f"
done
echo

cd "$SNAP"
ghc -O2 -iinteractive -outputdir "$SNAP/build" -o "$SNAP/krama" "$MAIN" > "$SNAP/ghc.log" 2>&1 \
  || { echo "BUILD FAILED, see $SNAP/ghc.log" ; exit 1 ; }
printf '  binary  %s\n\n' "$(shasum -a 256 "$SNAP/krama" | cut -c1-16)"

"$SNAP/krama" --self-test
echo
"$SNAP/krama" --krama "${KRAMA_TOP:-12}"
echo
if [ "$1" = "--anvaya" ] ; then
  "$SNAP/krama" --anvaya "${2:-8}"
else
  echo "  (the live-engine falsifier was not run; add:  sh interactive/run-paksa-krama.sh --anvaya 8)"
fi
