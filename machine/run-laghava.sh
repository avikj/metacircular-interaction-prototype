#!/bin/sh
# run-laghava.sh -- the same sutras, on the carrier they actually run on.
#
#   sh machine/run-laghava.sh              self-test + equivalence, interpreted
#   sh machine/run-laghava.sh bench 50000  timing, interpreted (SLOW: see below)
#   sh machine/run-laghava.sh --compiled bench 50000
#
# THE FLAG IS NOT A CONVENIENCE.  Under `runghc` this engine is 1.50x the
# reference; compiled with -O2 it is 5.85x.  A Word8 comparison beats a
# String comparison only where a comparison is an instruction, and under the
# bytecode interpreter both are a thunk.  Timing this interpreted measures
# GHC's interpreter, not the encoding, so the compiled path is offered by
# name rather than left for the reader to discover.
#
# Needs ghc and nothing else: no network, no Agda, no Lean, no Python.
set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT" || exit 2

if [ "${1:-}" = "--compiled" ]; then
  shift
  OUT=$(mktemp -d) || exit 2
  trap 'rm -rf "$OUT"' EXIT
  ghc -O2 -v0 -imachine -outputdir "$OUT" -o "$OUT/laghava" machine/LaghavaRun.hs || exit 2
  exec "$OUT/laghava" "$@"
fi
exec runghc -imachine machine/LaghavaRun.hs "$@"
