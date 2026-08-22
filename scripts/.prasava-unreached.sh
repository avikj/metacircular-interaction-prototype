#!/bin/sh
# modules that NO Everything root imports.  A module nothing reaches is
# verified by nothing, so this is the number that decides whether a green
# means anything.  Transitive: an Everything importing X, X importing Y,
# counts Y as reached.
cd "$(dirname "$0")/.."
T=$(mktemp); R=$(mktemp)
find formal/cubical punaragamana/src -name '*.agda' | sed 's|.*/||; s|\.agda$||' | sort -u > $T
for root in formal/cubical/Everything.agda formal/cubical/MachineMinted/Everything.agda punaragamana/src/Everything.agda; do
  [ -f "$root" ] && sed -n 's/^import  *\([A-Za-z0-9_.]*\).*/\1/p' "$root"
done | sed 's|.*\.||' | sort -u > $R
# one transitive step through the reached set's own imports
for m in $(cat $R); do
  f=$(find formal/cubical punaragamana/src -name "$m.agda" | head -1)
  [ -n "$f" ] && sed -n 's/^open import  *\([A-Za-z0-9_.]*\).*/\1/p;s/^import  *\([A-Za-z0-9_.]*\).*/\1/p' "$f" | sed 's|.*\.||'
done >> $R
sort -u $R -o $R
comm -23 $T $R | wc -l | tr -d ' '
rm -f $T $R
