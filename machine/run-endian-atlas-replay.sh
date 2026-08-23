#!/bin/sh
set -eu

agda -i formal/cubical formal/cubical/NaturalMachine/EndianAtlasReplay.agda

build_dir=$(mktemp -d)
trap 'rm -rf "$build_dir"' EXIT HUP INT TERM
ghc -O2 -outputdir "$build_dir" machine/MathMachine.hs -o "$build_dir/math-machine"
"$build_dir/math-machine" --endian-atlas-self-test
