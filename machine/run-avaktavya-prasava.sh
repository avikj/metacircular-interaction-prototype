#!/bin/sh
# The fourth position bearing the rule that decides it, from the repository
# root:
#
#   sh machine/run-avaktavya-prasava.sh
#
# Runs, in order: the sites in the engine's own definitional rule set where
# all four metarules go silent, with the residue and what it bears; the same
# derivations before and after the birth (before: stopped at a written
# defect; after: finished); a constructed witness where the standpoints
# disagree and NOTHING is born; and the transport check over every term of
# depth <= 3, exhaustively.
#
# Also runs `--vipratisedha-self-test`, which is the state this starts from.
set -eu

build_dir=$(mktemp -d "${TMPDIR:-/tmp}/avaktavya-prasava.XXXXXX")
trap 'rm -rf "$build_dir"' EXIT HUP INT TERM

ghc -O0 -imachine -outputdir "$build_dir/obj" \
  -o "$build_dir/math-machine" machine/MathMachine.hs > "$build_dir/log" 2>&1 \
  || { cat "$build_dir/log"; exit 1; }

"$build_dir/math-machine" --vipratisedha-self-test
echo
"$build_dir/math-machine" --avaktavya-prasava
