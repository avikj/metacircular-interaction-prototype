#!/bin/sh
set -eu

extract_dir=$(mktemp -d)
trap 'rm -rf "$extract_dir"' EXIT HUP INT TERM

agda -i formal/executable --compile --ghc-dont-call-ghc --no-main \
  --compile-dir="$extract_dir" formal/executable/RootedReweave.agda
agda -i formal/executable --compile --ghc-dont-call-ghc --no-main \
  --compile-dir="$extract_dir" formal/executable/BalancedReweave.agda
agda -i formal/executable --compile --ghc-dont-call-ghc --no-main \
  --compile-dir="$extract_dir" formal/executable/TheoremCompiledObservation.agda
agda -i formal/executable --compile --ghc-dont-call-ghc --no-main \
  --compile-dir="$extract_dir" formal/executable/InstalledRootedQuotient.agda
agda -i formal/executable --compile --ghc-dont-call-ghc --no-main \
  --compile-dir="$extract_dir" formal/executable/BoundedMinimization.agda
agda -i formal/executable --compile --ghc-dont-call-ghc --no-main \
  --compile-dir="$extract_dir" formal/executable/ConsequenceFiber.agda
agda -i formal/executable --compile --ghc-dont-call-ghc --no-main \
  --compile-dir="$extract_dir" formal/executable/FiberJewelNet.agda
mkdir -p "$extract_dir/build"
ghc -O2 -i"$extract_dir" -outputdir "$extract_dir/build" \
  machine/ExtractedRewrite.hs -o "$extract_dir/rewrite-dynamics"
"$extract_dir/rewrite-dynamics"
