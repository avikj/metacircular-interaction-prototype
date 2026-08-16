#!/bin/sh
set -eu

build_dir=$(mktemp -d)
trap 'rm -rf "$build_dir"' EXIT HUP INT TERM

ghc -O0 -outputdir "$build_dir" machine/KernelProbe.hs -o "$build_dir/kernel-probe"
"$build_dir/kernel-probe"
