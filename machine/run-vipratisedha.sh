#!/bin/sh
# The scheduler, on both domains, from the repository root:
#
#   sh machine/run-vipratisedha.sh
#
# Domain 1 -- the Aṣṭādhyāyī: the general scheduler pointed at
# Astadhyayi.hs's own sūtras, checked to reach the same forms as the
# hand-written engine on the whole corpus (transport, not a rewrite).
# Domain 2 -- MathMachine's term rewriting: the scheduler wired into `step`'s
# root site, with the transport verified exhaustively over every term of
# depth <= 3 and every undecided tie written out as a defect.
set -eu

build_dir=$(mktemp -d "${TMPDIR:-/tmp}/vipratisedha.XXXXXX")
trap 'rm -rf "$build_dir"' EXIT HUP INT TERM

ghc -O0 -imachine -outputdir "$build_dir/obj" \
  -o "$build_dir/vipratisedha" machine/VipratisedhaRun.hs > "$build_dir/log" 2>&1 \
  || { cat "$build_dir/log"; exit 1; }

ghc -O0 -imachine -outputdir "$build_dir/obj2" \
  -o "$build_dir/math-machine" machine/MathMachine.hs > "$build_dir/log2" 2>&1 \
  || { cat "$build_dir/log2"; exit 1; }

"$build_dir/vipratisedha"
echo
"$build_dir/math-machine" --vipratisedha-self-test
