#!/usr/bin/env bash
# Check the two attached proof-source additions with the repository's pin.
set -Eeuo pipefail
HERE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
ROOT=$(cd "$HERE/../../.." && pwd)
PREFIX=${MATH_PREFIX:-$HOME}
AGDA=${AGDA:-$PREFIX/.local/bin/agda}
[[ -x "$AGDA" ]] || AGDA=$(command -v agda)
[[ $("$AGDA" --version) == 'Agda version 2.8.0'* ]] || { echo 'Agda 2.8.0 required.' >&2; exit 2; }
CUBICAL=${CUBICAL:-$PREFIX/.cache/cubical-v0.9}
[[ $(git -C "$CUBICAL" describe --tags --exact-match) == v0.9 ]] || { echo 'cubical v0.9 required.' >&2; exit 2; }
LIBFILE=${AGDA_LIBRARIES:-$PREFIX/.agda-pin/libraries}
[[ -f "$LIBFILE" ]] || { echo 'Pinned library file absent; run the repository setup script.' >&2; exit 2; }
export LC_ALL=C.UTF-8 LANG=C.UTF-8
cd "$ROOT/formal/cubical"
"$AGDA" --library-file="$LIBFILE" BitcoinMiningOnTheWire.agda
"$AGDA" --library-file="$LIBFILE" BitcoinMiningCut.agda
