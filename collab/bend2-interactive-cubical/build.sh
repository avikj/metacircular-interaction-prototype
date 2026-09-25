#!/usr/bin/env bash
# Build the cubical Bend compiler and the HVM4 runtime from the vendored
# sources into a NEW directory. Needs GHC 9.12.2, cabal >= 3.14, git, a C
# compiler, libgmp. Usage: bash build.sh NEW_BUILD_DIRECTORY
set -Eeuo pipefail
export LC_ALL=C.UTF-8 LANG=C.UTF-8
HERE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
[[ $# == 1 ]] || { echo "Usage: bash $0 NEW_BUILD_DIRECTORY" >&2; exit 2; }
WORK=$(realpath -m -- "$1")
[[ ! -e "$WORK" ]] || { echo "Build directory already exists: $WORK" >&2; exit 2; }
for tool in git ghc cabal; do command -v "$tool" >/dev/null; done
[[ $(ghc --numeric-version) == 9.12.2 ]] || { echo 'Pinned to GHC 9.12.2.' >&2; exit 2; }
CC=${CC:-clang}; command -v "$CC" >/dev/null || CC=cc
mkdir -p "$WORK"
trap 'rc=$?; echo "BUILD FAILED (exit $rc); logs remain at $WORK" >&2; exit "$rc"' ERR

cp -R "$HERE/vendor/Bend2" "$WORK/Bend2"
mkdir -p "$WORK/HVM4/src" && cp "$HERE/vendor/HVM4/src/hvm.c" "$WORK/HVM4/src/hvm.c"

# HVM3: unmodified library dependency; its C aggregator omits two includes.
git clone --no-checkout https://github.com/HigherOrderCO/HVM3.git "$WORK/HVM3"
git -C "$WORK/HVM3" checkout --detach fba2e9c82faf6e2f019c9ecea94c32f19a8b7820
R="$WORK/HVM3/src/HVM/Runtime.c"
for name in ref.c ref_sup.c; do
  [[ -f "$WORK/HVM3/src/HVM/runtime/reduce/$name" ]]
  grep -Fq "#include \"runtime/reduce/$name\"" "$R" || printf '\n#include "runtime/reduce/%s"\n' "$name" >> "$R"
done
if [[ -f "$HERE/hvm3-gcc15.patch" ]]; then
  git -C "$WORK/HVM3" apply "$HERE/hvm3-gcc15.patch"
fi

(cd "$WORK/Bend2" && cabal update && cabal build exe:bend 2>&1 | tee "$WORK/bend-build.log")
BEND=$(cd "$WORK/Bend2" && cabal list-bin exe:bend)
(cd "$WORK/HVM4" && "$CC" -O2 -o src/hvm src/hvm.c -lm 2>&1 | tee "$WORK/hvm-build.log")
HVM="$WORK/HVM4/src/hvm"
printf 'export BEND=%q\nexport HVM=%q\n' "$BEND" "$HVM" > "$WORK/env.sh"
{
  ghc --version; cabal --version; "$CC" --version | head -1
  git -C "$HERE" rev-parse HEAD
  sha256sum "$BEND" "$HVM"
} > "$WORK/build-identity.txt"
echo "Built. source $WORK/env.sh"
