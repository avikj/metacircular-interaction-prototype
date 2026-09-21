#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
cd "$repo_root"
toolchain="$repo_root/research/biology_exact/build/toolchain"
store_db="$toolchain/cabal-store/ghc-9.14.1-ea4f/package.db"
bend_db="$toolchain/Bend2-f026483/dist-newstyle/packagedb/ghc-9.14.1"
sdk=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk
clt=/Library/Developer/CommandLineTools/usr/bin
hvm=${BEND_UCM_HVM4:-"$toolchain/hvm4"}
build_dir=$(mktemp -d /private/tmp/bend-ucm-canonical.XXXXXX)
trap 'rm -rf "$build_dir"' EXIT HUP INT TERM

ghc -v0 \
  -pgmc "$clt/clang" -pgma "$clt/clang" -pgml "$clt/clang" \
  -pgmotool "$clt/otool" -pgminstall_name_tool "$clt/install_name_tool" \
  -optc-isysroot -optc"$sdk" \
  -opta-isysroot -opta"$sdk" \
  -optl-isysroot -optl"$sdk" \
  -package-db "$store_db" -package-db "$bend_db" \
  -package bend -package crypton -package ram -package binary \
  -iintegration/bend2_unison/admission \
  -iintegration/bend2_unison/execution \
  -iintegration/bend2_unison/reify \
  -iintegration/bend2_unison/storage \
  -outputdir "$build_dir" \
  integration/bend2_unison/execution/CanonicalExecutionSmoke.hs \
  -o "$build_dir/bend-ucm-canonical-smoke"

"$build_dir/bend-ucm-canonical-smoke" collab/bend2-interactive-cubical/t_fwd_neg.bend "$hvm" 146 3701
"$build_dir/bend-ucm-canonical-smoke" collab/bend2-interactive-cubical/path_transport.bend "$hvm" 4992 22157
