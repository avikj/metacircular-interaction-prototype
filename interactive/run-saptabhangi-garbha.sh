#!/bin/sh
# run-saptabhangi-garbha.sh -- the machine returns the seven positions.
#
#   sh interactive/run-saptabhangi-garbha.sh
#
# Needs ghc and nothing else: no network, no Agda, no Lean, no Python.
# The specification is checked in
# formal/cubical/NaturalMachine/SaptabhangiGarbha_ThePositionsCarryTheirNayasAndTheResidueSeedsTheNext.agda
set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT" || exit 2
exec runghc -iinteractive interactive/SaptabhangiGarbhaRun.hs "$@"
