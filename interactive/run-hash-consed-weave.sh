#!/bin/sh
set -eu
build_dir=$(mktemp -d)
trap 'rm -rf "$build_dir"' EXIT HUP INT TERM
ghc -O2 -outputdir "$build_dir" interactive/HashConsedWeave.hs -o "$build_dir/hash-consed-weave"
"$build_dir/hash-consed-weave"
