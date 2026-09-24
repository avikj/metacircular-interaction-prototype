#!/usr/bin/env bash
# usage: run.sh BENDBIN OUTDIR
set -u
export LC_ALL=C.UTF-8 LANG=C.UTF-8
REPO=$(git -C "$(dirname "$0")" rev-parse --show-toplevel)
HVM=${HVM:?set HVM to the hvm4 binary}
JOBS=${JOBS:-8}
BENDBIN=$(readlink -f "$1"); OUTDIR=$(mkdir -p "$2" && readlink -f "$2")
HVM=$(readlink -f "$HVM")
export REPO HVM BENDBIN OUTDIR

one() {
  rel=$1
  slug=${rel//\//__}
  d=$(dirname "$REPO/$rel"); f=$(basename "$rel")
  o=$OUTDIR/$slug
  ( cd "$d" && timeout 120 "$BENDBIN" "$f" --to-hvm4-full > "$o.hvm4" 2> "$o.cerr" ); crc=$?
  hasmain=0; rrc=-; sha=-; itrs=-
  if [ $crc -eq 0 ] && grep -q '^@main = ' "$o.hvm4"; then
    hasmain=1
    ( cd "$d" && timeout 120 "$HVM" "$o.hvm4" -s > "$o.out" 2>&1 ); rrc=$?
    # stat lines printed by hvm -s: "- Itrs: N interactions", "- Heap: N nodes", "- Time: X seconds", "- Perf: X M interactions/s"
    grep -Ev '^- (Itrs|Heap|Time|Perf): ' "$o.out" > "$o.norm"
    sha=$(sha1sum < "$o.norm" | cut -c1-40)
    itrs=$(sed -n 's/^- Itrs: \([0-9]*\) interactions.*/\1/p' "$o.out" | tail -1)
    [ -n "$itrs" ] || itrs=-
  fi
  printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$rel" "$crc" "$hasmain" "$rrc" "$sha" "$itrs" > "$o.row"
}
export -f one

git -C "$REPO" ls-files '*.bend' | xargs -d '\n' -P "$JOBS" -I{} bash -c 'one "$1"' _ {}

{ printf 'path\tcompile_rc\thas_main\trun_rc\tnorm_sha1\titrs\n'
  git -C "$REPO" ls-files '*.bend' | while IFS= read -r rel; do cat "$OUTDIR/${rel//\//__}.row"; done
} > "$OUTDIR/summary.tsv"
echo "wrote $OUTDIR/summary.tsv"
