#!/bin/sh
# Build the certificate handler and exercise it, twice over:
#
#   machine/check-yantra-pariksa.sh
#
#   1  DIRECTLY — five inputs, one per road the handler can take, and the
#      assertion is that they land on five DIFFERENT answers.  In particular
#      that a FALSE equation and an UNPROVED one do not arrive at the same
#      place: the first comes back with a numeric witness, the second with
#      agda's located type error and no witness at all.  A boolean returns
#      the same value for both, and the engine paid for that identification
#      with weeks of rejecting everything it proved.
#
#   2  THROUGH THE ASSEMBLY — one turn of `machine/sabha` naming
#      `yantra.pariksa`, so the green covers the WIRING and not only the
#      module.  Written-and-not-connected is on this repository's record
#      (CLAUDE.md, 2026-08-20: a hook documented as live and absent from
#      settings.json), and a check that only ran the module would have
#      reproduced it.
#
# Road १ needs agda and the cubical library.  Where the kernel is not
# reachable the runner still runs and says so on its first line, because
# "agda is not installed here" and "the handler is broken" are two facts and
# one red merges them — the same discipline machine/check-sabha.sh states.
set -e
root=$(cd "$(dirname "$0")/.." && pwd)
out=${TMPDIR:-/tmp}/yantra-pariksa-build
mkdir -p "$out"
cd "$root"

export LC_ALL=C.UTF-8

echo "1  the five roads, directly"
echo "--------------------------------------------------------------"
ghc -O0 -Wall -Werror -i"$root/machine" -outputdir "$out" \
    -o "$out/yantra-pariksa-run" \
    "$root/machine/YantraPariksaRun_TheFiveRoadsExercisedNotDescribed.hs" \
    >"$out/build.log" 2>&1 || { cat "$out/build.log"; exit 1; }
"$out/yantra-pariksa-run"

echo ""
echo "2  one turn through the assembly"
echo "--------------------------------------------------------------"
ghc -O0 -i"$root/machine" -outputdir "$out/sabha" -o "$out/sabha-bin" \
    "$root/machine/SabhaRun.hs" >"$out/sabha-build.log" 2>&1 \
  || { cat "$out/sabha-build.log"; exit 1; }

# `yantra.pariksa` must be dispatched by name, and the answer must be a
# saṃkramaṇa.  Asking for an operation that is not in the table produces a
# doṣalekha naming every operation there is, so a missing wire fails here
# rather than passing quietly.
lekha="$out/turn.jsonl"
printf '%s\n' '{"kriya":"yantra.pariksa","angani":{"vama":"+(0,x)","daksina":"x"}}' \
  | SABHA_LEKHA="$lekha" "$out/sabha-bin" 2>/dev/null >"$out/turn.out"

if grep -q '"uttara":"samkramana"' "$out/turn.out" \
   && grep -q '"kriya":"yantra.pariksa"' "$out/turn.out"; then
  echo "   the assembly dispatched yantra.pariksa and answered with a transport."
else
  echo "   !! the assembly did not answer yantra.pariksa with a saṃkramaṇa:"
  cat "$out/turn.out"
  exit 1
fi

echo ""
echo "green: five roads stay five, and the wire carries the operation."
