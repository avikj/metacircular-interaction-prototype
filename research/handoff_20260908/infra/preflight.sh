#!/bin/sh
# Nonmutating repository/toolchain probe. Does not install, build or start Yantra.
# Usage: sh preflight.sh /absolute/repository/path [/absolute/output/directory]
set -u
ROOT=$(cd "${1:-.}" && pwd) || exit 2
OUT=${2:-${TMPDIR:-/tmp}/mip-handoff-preflight-$(date +%Y%m%d-%H%M%S)-$$}
mkdir -p "$OUT" || exit 2
OUT=$(cd "$OUT" && pwd) || exit 2
LOG="$OUT/preflight.log"
: > "$LOG"
run() {
  printf '\nCOMMAND:' >> "$LOG"
  for arg in "$@"; do printf ' [%s]' "$arg" >> "$LOG"; done
  printf '\n' >> "$LOG"
  (cd "$ROOT" && "$@") >> "$LOG" 2>&1
  result=$?
  printf 'EXIT_STATUS=%s\n' "$result" >> "$LOG"
}
printf 'Repository=%s\nOutput=%s\nNo installation/build attempted.\n' "$ROOT" "$OUT" >> "$LOG"
run git status --short
run git rev-parse HEAD
run git log -1 --format=fuller
run sh setup --report
run sh -c 'command -v agda; command -v ghc; command -v cabal; command -v lake'
run sh -c 'agda --version; ghc --version; cabal --version; lake --version'
run sh -c 'printf "MATH_PREFIX=%s\n" "${MATH_PREFIX:-$HOME}"; cat "${MATH_PREFIX:-$HOME}/.agda-pin/libraries"'
run sh -c 'printf "Case-sensitive candidate kernel paths:\n"; for d in formal/cubical/kernel formal/cubical/Kernel; do if [ -d "$d" ]; then printf "%s exists; module count " "$d"; find "$d" -maxdepth 1 -name "*.agda" | wc -l; else printf "%s absent\n" "$d"; fi; done'
run sh -c 'cat formal/cubical/natural-machine.agda-lib; cat fibre/fibre.agda-lib; cat formal/lean/lean-toolchain'
run sh -c 'grep -n -E "kriya|sadhana.patra|sadhana.vislesana|kernel|Kernel" interactive/Server.hs check | head -100'
printf '\nPreflight completed; individual statuses are evidence, not a combined theorem verdict.\n' >> "$LOG"
printf 'Report: %s\n' "$LOG"
