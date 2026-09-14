#!/usr/bin/env bash
# The N-cell benchmark on the full cubical HVM4 runtime: one program (a word of
# eight knockdowns), N cell states, four representations of the population, in
# two regimes (the shared program cheap to construct / expensive to construct).
#   list    a flat list of cells; the program is re-entered per cell
#   hoist   the program bound once outside the map (call-by-need sharing)
#   supin   the N cells as ONE superposed value; the program applied once
#   supout  N separate applications; the results superposed
# Usage: bench/run.sh [bend-binary] [hvm-binary]   (prints markdown tables)
set -u
export LC_ALL=C.utf8 LANG=C.utf8
BEND="${1:-$(cat /tmp/BENDBIN 2>/dev/null || echo bend)}"
HVM="${2:-${HVM:-/tmp/HVM4/src/hvm}}"
cd "$(dirname "$0")" || exit 1
for regime in light heavy; do
  printf '\n**regime: %s**\n\n| N | list | hoist | supin | supout | supin/hoist |\n|---|---|---|---|---|---|\n' "$regime"
  for N in 1 2 4 8 16 32; do
    declare -A I
    for mode in list hoist supin supout; do
      f="pop_${regime}_${mode}_${N}"
      "$BEND" "$f.bend" --to-hvm4-full > "/tmp/$f.hvm4" 2>/dev/null
      out=$("$HVM" "/tmp/$f.hvm4" -s -C64 2>&1)
      I[$mode]=$(printf '%s' "$out" | sed -n 's/.*Itrs: *\([0-9]*\) interactions.*/\1/p' | head -1)
      [ -n "${I[$mode]}" ] || I[$mode]="ERR"
    done
    r=$(python3 -c "print(round(${I[supin]}/${I[hoist]},2))" 2>/dev/null || echo -)
    printf '| %s | %s | %s | %s | %s | %s |\n' "$N" "${I[list]}" "${I[hoist]}" "${I[supin]}" "${I[supout]}" "$r"
  done
done
