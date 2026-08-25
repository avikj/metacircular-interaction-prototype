#!/bin/sh
# run-paksa.sh -- the two arms of PaksaLaksana_*, from ONE snapshot of the
# sources and ONE binary, differing in one flag.
#
# WHY THE SNAPSHOT.  This host carries sixteen lanes.  A same-source A/B was
# broken here on 2026-08-19 because the two arms compiled at different times
# and a concurrent edit landed between them; the sha256 print did not catch it
# because each arm hashed what it had just built.  So: copy once, hash the
# copy, build the copy, run both arms out of the copy.  Every number the run
# prints is a statement about the hashes below and about nothing on disk.
#
# Exact: no clock is read, no arm is timed.  Both arms print the same four
# position counts, so a reader can check they are the same object.
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
SNAP=${PAKSA_SNAP:-$(mktemp -d "${TMPDIR:-/tmp}/paksa.XXXXXX")}
mkdir -p "$SNAP/machine"
cp "$ROOT"/interactive/*.hs "$SNAP/interactive/"
cp "$ROOT"/interactive/library.terms "$SNAP/interactive/"
cp "$ROOT"/interactive/machine.log   "$SNAP/interactive/"
ln -sfn "$ROOT/formal" "$SNAP/formal"

MAIN=interactive/PaksaLaksana_WhatIsWorthHandingTheKernelIsWhereTheTwoRewritersDisagree.hs

echo "SNAPSHOT $SNAP"
echo "  the bytes both arms are built and run from:"
for f in "$MAIN" interactive/BhavanaTheorem.hs interactive/Obstruction.hs \
         interactive/Certificate.hs interactive/library.terms interactive/machine.log ; do
  printf '    %s  %s\n' "$(shasum -a 256 "$SNAP/$f" | cut -c1-16)" "$f"
done
echo

cd "$SNAP"
ghc -O1 -iinteractive -outputdir "$SNAP/build" -o "$SNAP/paksa" "$MAIN" > "$SNAP/ghc.log" 2>&1 \
  || { echo "BUILD FAILED, see $SNAP/ghc.log" ; exit 1 ; }
printf '  binary  %s\n\n' "$(shasum -a 256 "$SNAP/paksa" | cut -c1-16)"

"$SNAP/paksa" --self-test
echo
"$SNAP/paksa" --asamskrta
echo
"$SNAP/paksa" --paksa
echo
if [ "$1" = "--kernel" ] ; then
  "$SNAP/paksa" --kernel "${2:-8}"
else
  echo "  (the kernel falsifier was not run; add:  sh interactive/run-paksa.sh --kernel 8)"
fi
