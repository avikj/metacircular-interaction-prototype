#!/bin/sh
set -eu

if [ "$#" -lt 1 ]; then
  echo "usage: $0 PINNED_UNISON_CHECKOUT [--build|--patch-only]" >&2
  exit 2
fi

checkout=$1
mode=${2:---build}
repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
toolchain="$repo_root/research/biology_exact/build/toolchain"

case "$mode" in
  --build|--patch-only) ;;
  *) echo "usage: $0 PINNED_UNISON_CHECKOUT [--build|--patch-only]" >&2; exit 2 ;;
esac

apply_overlay() {
  overlay="$repo_root/integration/bend2_unison/$1"
  if (cd "$checkout" && patch --forward --batch --dry-run -p1 -i "$overlay" >/dev/null 2>&1); then
    (cd "$checkout" && patch --forward --batch -p1 -i "$overlay")
  else
    echo "Cannot apply overlay: $1" >&2
    exit 1
  fi
}

mkdir -p "$checkout/vendor"

if [ ! -e "$checkout/integration" ]; then
  ln -s "$repo_root/integration" "$checkout/integration"
fi
if [ -L "$checkout/vendor/Bend2" ]; then
  unlink "$checkout/vendor/Bend2"
fi
if [ ! -e "$checkout/vendor/Bend2" ]; then
  cp -R "$toolchain/Bend2-f026483" "$checkout/vendor/Bend2"
fi
if (cd "$checkout/vendor/Bend2" && patch --forward --batch --dry-run -p1 -i "$repo_root/integration/bend2_unison/admission/bend-parser-provenance.patch" >/dev/null 2>&1); then
  (cd "$checkout/vendor/Bend2" && patch --forward --batch -p1 -i "$repo_root/integration/bend2_unison/admission/bend-parser-provenance.patch")
fi
if [ -L "$checkout/vendor/HVM3" ]; then
  unlink "$checkout/vendor/HVM3"
fi
if [ ! -e "$checkout/vendor/HVM3" ]; then
  cp -R "$toolchain/HVM3-fba2e9c82faf6e2f019c9ecea94c32f19a8b7820" "$checkout/vendor/HVM3"
fi
if (cd "$checkout/vendor/HVM3" && patch --forward --batch --dry-run -p1 -i "$repo_root/integration/bend2_unison/cli/hvm3-ghc910.patch" >/dev/null 2>&1); then
  (cd "$checkout/vendor/HVM3" && patch --forward --batch -p1 -i "$repo_root/integration/bend2_unison/cli/hvm3-ghc910.patch")
fi
if [ -L "$checkout/vendor/hs-highlight" ]; then
  unlink "$checkout/vendor/hs-highlight"
fi
if [ ! -e "$checkout/vendor/hs-highlight" ]; then
  cp -R "$toolchain/hs-highlight-main" "$checkout/vendor/hs-highlight"
fi
if (cd "$checkout/vendor/hs-highlight" && patch --forward --batch --dry-run -p1 -i "$repo_root/integration/bend2_unison/cli/hs-highlight-ghc910.patch" >/dev/null 2>&1); then
  (cd "$checkout/vendor/hs-highlight" && patch --forward --batch -p1 -i "$repo_root/integration/bend2_unison/cli/hs-highlight-ghc910.patch")
fi

if [ ! -f "$checkout/.bend-ucm-overlays-applied" ]; then
  apply_overlay storage/unison-codebase-bend.patch
  apply_overlay storage/unison-bend-sync.patch
  apply_overlay interface/unison-codebase-semantic-peers.patch
  apply_overlay interface/unison-share-api-bend-subterm.patch
  apply_overlay interface/unison-cli-bend-lsp.patch
  apply_overlay interface/unison-local-bend-browser.patch
  apply_overlay cli/ucm-bend.patch
  apply_overlay cli/ucm-bend-type-display.patch
  apply_overlay interface/unison-cli-bend-browser-link.patch
  apply_overlay interface/unison-cli-bend-desktop-link.patch
  apply_overlay cli/ucm-bend-authored-types.patch
  apply_overlay cli/ucm-bend-names.patch
  apply_overlay cli/ucm-bend-divergent-merge.patch
  apply_overlay cli/ucm-bend-artifact-cache.patch
  apply_overlay cli/ucm-bend-view-display.patch
  apply_overlay storage/unison-bend-role-graph.patch
  touch "$checkout/.bend-ucm-overlays-applied"
else
  echo "Bend2/Unison overlays already applied"
fi

if [ "$mode" = --build ]; then
  export PATH="/Library/Developer/CommandLineTools/usr/bin:$HOME/.ghcup/bin:$PATH"
  export CC=/Library/Developer/CommandLineTools/usr/bin/clang
  export CXX=/Library/Developer/CommandLineTools/usr/bin/clang++
  export SDKROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk
  (cd "$checkout" && stack build unison-cli-main --fast -j1 --no-terminal)
fi
