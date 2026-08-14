#!/usr/bin/env bash
# Zero-dependency fallback for the entry draw.  `seed.rs` is canonical --
# use it when a Rust toolchain is present.  This script exists so that the
# entry gate is never blocked by a missing toolchain, because a gate that
# cannot run is a gate nobody passes through, and then the reading path
# reverts to "what looks relevant", which is the whole failure this
# directory was built to stop.
#
#   ./seed.sh <handle>              one agent
#   ./seed.sh <handle> --swarm 16   a swarm, drawn WITHOUT REPLACEMENT
#
# Deterministic in (handle, UTC day): the same handle on the same day gets
# the same door, so a session is replayable and auditable, and nothing is
# sampled by a model.  Requires only coreutils (shuf, md5sum, awk).
#
# Needs bash for process substitution.  If even bash is unavailable, draw
# by hand: `shuf -n 8` over `git ls-files` is 95% of the value.

set -euo pipefail
cd "$(dirname "$0")/.."

HANDLE="${1:?usage: seed.sh <handle> [--swarm N]}"
SWARM=1
if [ "${2:-}" = "--swarm" ]; then SWARM="${3:?--swarm needs a count}"; fi

DAY="$(date -u +%Y-%m-%d)"
SEEDER_DIR=random_entry_seeder_so_agents_dont_cluster

# a deterministic byte stream keyed by (handle, day), for shuf
keystream() {
  local s="$1" acc
  while :; do
    acc="$(printf '%s' "$s" | md5sum | cut -d' ' -f1)"
    s="$acc"
    printf '%s' "$acc"
  done
}
draw() { # draw <n> <file> <key>
  shuf -n "$1" --random-source=<(keystream "$3") "$2"
}

FILES="$(mktemp)"; trap 'rm -f "$FILES"' EXIT
git ls-files | grep -vE '(^|/)(_build|\.git)/' > "$FILES"
NFILES=$(wc -l < "$FILES")

strip_comments() { grep -v '^#' "$1" | grep -v '^[[:space:]]*$'; }
FRONTIER="$(mktemp)"; ANCIENT="$(mktemp)"; LENSES="$(mktemp)"
trap 'rm -f "$FILES" "$FRONTIER" "$ANCIENT" "$LENSES"' EXIT
strip_comments "$SEEDER_DIR/frontier_fields.txt" > "$FRONTIER"
strip_comments "$SEEDER_DIR/ancient_fields.txt"  > "$ANCIENT"
strip_comments "$SEEDER_DIR/method_lenses.txt"   > "$LENSES"

# Swarm draws are DISJOINT: draw the whole swarm's worth at once and deal
# out slices.  Sharing a file or a lens between two agents rebuilds the
# clustering this directory exists to break.
tot_files=$(( SWARM * 8 ))
tot_dirs=$((  SWARM * 3 ))
tot_lens=$((  SWARM * 2 ))

ALLF="$(draw "$tot_files" "$FILES" "$HANDLE|$DAY|files")"
# uniform over DIRECTORIES, then within: upweights small rare corners.
# This is the draw that found collab/upstream/ -- see why_this_exists.md.
DIRS="$(awk -F/ 'NF>1{OFS="/"; NF--; print}' "$FILES" | sort -u)"
ALLD=""
i=0
while [ "$i" -lt "$tot_dirs" ]; do
  d="$(printf '%s\n' "$DIRS" | shuf -n 1 --random-source=<(keystream "$HANDLE|$DAY|dir|$i"))"
  f="$(grep -E "^$(printf '%s' "$d" | sed 's/[][\.*^$/]/\\&/g')/[^/]*$" "$FILES" \
        | shuf -n 1 --random-source=<(keystream "$HANDLE|$DAY|dirfile|$i") || true)"
  [ -n "$f" ] && ALLD="$ALLD$f"$'\n'
  i=$((i+1))
done
ALLFR="$(draw "$SWARM" "$FRONTIER" "$HANDLE|$DAY|frontier")"
ALLAN="$(draw "$SWARM" "$ANCIENT"  "$HANDLE|$DAY|ancient")"
ALLLE="$(draw "$tot_lens" "$LENSES" "$HANDLE|$DAY|lens")"

slice() { printf '%s\n' "$1" | sed -n "$2,$3p"; }

n=0
while [ "$n" -lt "$SWARM" ]; do
  fa=$(( n*8 + 1 )); fb=$(( n*8 + 8 ))
  da=$(( n*3 + 1 )); db=$(( n*3 + 3 ))
  la=$(( n*2 + 1 )); lb=$(( n*2 + 2 ))
  echo "================================================================"
  printf '  DRAW for %s-%02d   (%s, urn = %s tracked files)\n' "$HANDLE" "$n" "$DAY" "$NFILES"
  echo "================================================================"
  echo
  echo "-- 8 files, uniform over all tracked files --"
  slice "$ALLF" "$fa" "$fb" | sed 's/^/   /'
  echo
  echo "-- 3 files, uniform over directories then within (rare corners) --"
  slice "$ALLD" "$da" "$db" | sed 's/^/   /'
  echo
  echo "-- frontier field (assigned, not chosen) --"
  slice "$ALLFR" $((n+1)) $((n+1)) | sed 's/^/   /'
  echo
  echo "-- ancient field (prior literature, not ornament) --"
  slice "$ALLAN" $((n+1)) $((n+1)) | sed 's/^/   /'
  echo
  echo "-- two method lenses, so they DISAGREE --"
  slice "$ALLLE" "$la" "$lb" | sed 's/^/   /'
  echo
  echo "   Read all eleven files in full before forming any plan.  Do not"
  echo "   triage them.  Your assignment is where the two lenses give"
  echo "   different answers about the drawn material."
  echo
  n=$((n+1))
done
