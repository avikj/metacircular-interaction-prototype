#!/usr/bin/env bash
# usage: compare.sh BASEDIR NEWDIR
set -u
B=$1; N=$2
declare -A cnt
while IFS=$'\t' read -r path crc hm rrc sha itrs; do
  [ "$path" = path ] && continue
  slug=${path//\//__}
  nrow=$(awk -F'\t' -v p="$path" '$1==p' "$N/summary.tsv")
  if [ -z "$nrow" ]; then cat=MISSING-IN-NEW
  else
    IFS=$'\t' read -r _ ncrc nhm nrrc nsha nitrs <<<"$nrow"
    if [ "$crc" = 0 ] && [ "$ncrc" != 0 ]; then cat=NEWLY-FAILS-COMPILE
    elif [ "$crc" != 0 ] && [ "$ncrc" = 0 ]; then cat=NEWLY-COMPILES
    elif [ "$rrc" != "$nrrc" ]; then cat=RUN-RC-CHANGED
    elif [ "$sha" != "$nsha" ]; then cat=RESULT-CHANGED
    else cat=SAME; fi
  fi
  cnt[$cat]=$(( ${cnt[$cat]:-0} + 1 ))
  printf '%-20s %s\n' "$cat" "$path"
  if [ "$cat" = RESULT-CHANGED ]; then
    diff -u "$B/$slug.norm" "$N/$slug.norm" 2>&1 | head -15 | sed 's/^/    /'
  fi
done < "$B/summary.tsv"
echo "---- counts"
for k in SAME RESULT-CHANGED NEWLY-FAILS-COMPILE NEWLY-COMPILES RUN-RC-CHANGED MISSING-IN-NEW; do
  printf '%-20s %d\n' "$k" "${cnt[$k]:-0}"
done
