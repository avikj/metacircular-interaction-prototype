#!/bin/sh
# check-cubical.sh — the ONE way to typecheck a cubical module in this repo.
#
#   scripts/check-cubical.sh formal/cubical/NaturalMachine/Foo.agda
#   scripts/check-cubical.sh NaturalMachine/Foo.agda          # path under formal/cubical also works
#
# It sets the UTF-8 locale (Agda crashes rendering ℕ/≃/… otherwise, and that
# crash masks the real type error), runs from the include root, and uses the
# pinned flags. Exit 0 = the kernel accepts it; nonzero = it does not, and the
# real error is printed. Use THIS, not a hand-written `agda …` line, so the
# invocation can never drift.
#
# If the library is not registered yet, it runs the bootstrap first.

set -u

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo=$(CDPATH= cd -- "$script_dir/.." && pwd)
lock="$repo/TOOLCHAIN.lock"
locale=$(awk '$1=="locale"{print $2; exit}' "$lock" 2>/dev/null)
: "${locale:=C.UTF-8}"

[ $# -ge 1 ] || { echo "usage: scripts/check-cubical.sh <file.agda> [more.agda ...]" >&2; exit 2; }

# ensure the pinned library is registered (cheap if already done)
if [ ! -f "$HOME/.agda/libraries" ] || ! grep -q "cubical" "$HOME/.agda/libraries" 2>/dev/null; then
  sh "$script_dir/agda-toolchain.sh" >/dev/null 2>&1 || true
fi

status=0
for f in "$@"; do
  # accept a repo-relative path, a formal/cubical-relative path, or absolute
  if [ -f "$f" ]; then
    abs=$(CDPATH= cd -- "$(dirname -- "$f")" && pwd)/$(basename -- "$f")
  elif [ -f "$repo/$f" ]; then
    abs="$repo/$f"
  elif [ -f "$repo/formal/cubical/$f" ]; then
    abs="$repo/formal/cubical/$f"
  else
    echo "check-cubical: not found: $f" >&2; status=1; continue
  fi

  rel=${abs#"$repo/formal/cubical/"}
  printf '==> %s\n' "$rel"
  if ( cd "$repo/formal/cubical" && LC_ALL="$locale" LANG="$locale" \
         agda --cubical --safe --no-import-sorts "$rel" ); then
    printf 'OK   %s\n' "$rel"
  else
    printf 'FAIL %s\n' "$rel"
    status=1
  fi
done

exit "$status"
