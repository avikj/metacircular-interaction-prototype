#!/bin/sh
set -eu

build_dir=$(mktemp -d /tmp/natural-machine-theorem-compiled.XXXXXX)
trap 'rm -rf "$build_dir"' EXIT HUP INT TERM

agda --compile --compile-dir="$build_dir" -i formal/executable \
  formal/executable/TheoremCompiledObservation.agda >/dev/null
ghc -O2 -i"$build_dir" machine/BenchTheoremCompiled.hs \
  "$build_dir"/MAlonzo/Code/TheoremCompiledObservation.hs \
  -outputdir "$build_dir/driver" -o "$build_dir/bench" >/dev/null
"$build_dir/bench" "$@"
