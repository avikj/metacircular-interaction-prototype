#!/usr/bin/env bash
# The N-cell benchmark on the full cubical HVM4 runtime: one program (a word of
# eight knockdowns), N cell states, several representations of the population.
#   list    a flat list of cells; the program is re-entered per cell
#   hoist   the program bound once outside the map (call-by-need sharing)
#   supin   the N cells as ONE superposed value; the program applied once
#   supout  N separate applications; the results superposed
# Sections: the emitter's output in three regimes (light: Peano nats; heavy: the
# shared program forced-expensive; i64: native numbers, records still nested
# pairs), then hand-written HVM4 with FLAT constructors (flat/gen.py), Peano and
# native.  Usage: bench/run.sh [bend-binary] [hvm-binary]   (markdown tables)
set -u
export LC_ALL=C.utf8 LANG=C.utf8
BEND="${1:-$(cat /tmp/BENDBIN 2>/dev/null || echo bend)}"
HVM="${2:-${HVM:-/tmp/HVM4/src/hvm}}"
cd "$(dirname "$0")" || exit 1
itrs() { "$HVM" "$1" -S -s 2>&1 | sed -n 's/.*Itrs: *\([0-9]*\) interactions.*/\1/p' | head -1; }
ratio() { python3 -c "print(round($1/$2,2))" 2>/dev/null || echo -; }
for regime in light heavy; do
  printf '\n**emitter, regime: %s**\n\n| N | list | hoist | supin | supout | supin/hoist |\n|---|---|---|---|---|---|\n' "$regime"
  for N in 1 2 4 8 16 32; do
    declare -A I
    for mode in list hoist supin supout; do
      f="pop_${regime}_${mode}_${N}"; "$BEND" "$f.bend" --to-hvm4-full > "/tmp/$f.hvm4" 2>/dev/null; I[$mode]=$(itrs "/tmp/$f.hvm4"); [ -n "${I[$mode]}" ] || I[$mode]=ERR
    done
    printf '| %s | %s | %s | %s | %s | %s |\n' "$N" "${I[list]}" "${I[hoist]}" "${I[supin]}" "${I[supout]}" "$(ratio "${I[supin]}" "${I[hoist]}")"
  done
done
printf '\n**emitter, I64 fields (native numbers; records still nested pairs)**\n\n| N | list | supin | supin/list |\n|---|---|---|---|\n'
for N in 1 2 4 8 16 32; do
  a=; b=; for mode in list supin; do f="pop_i64_${mode}_${N}"; "$BEND" "$f.bend" --to-hvm4-full > "/tmp/$f.hvm4" 2>/dev/null; done
  a=$(itrs /tmp/pop_i64_list_$N.hvm4); b=$(itrs /tmp/pop_i64_supin_$N.hvm4); printf '| %s | %s | %s | %s |\n' "$N" "$a" "$b" "$(ratio "$b" "$a")"
done
for enc in peano native; do
  printf '\n**hand-written HVM4, flat constructors, %s numbers (flat/gen.py)**\n\n| N | list | supin | supin/list |\n|---|---|---|---|\n' "$enc"
  for N in 1 2 4 8 16 32; do a=$(itrs flat/flat_${enc}_list_$N.hvm4); b=$(itrs flat/flat_${enc}_supin_$N.hvm4); printf '| %s | %s | %s | %s |\n' "$N" "$a" "$b" "$(ratio "$b" "$a")"; done
done
