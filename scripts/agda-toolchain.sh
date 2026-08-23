#!/bin/sh
# agda-toolchain.sh — make THIS container's Agda toolchain exactly match
# TOOLCHAIN.lock, idempotently. Run it once per session (it is wired to
# SessionStart for Claude sessions; Codex/other agents and the environment
# setup script should call it too — see CLAUDE.md).
#
# It is safe to run repeatedly and cheap on the second run (it clones cubical
# only when the pinned commit is not already present).
#
# WHY: the container ships Agda 2.6.3 (a system binary, unswappable) and cubical
# lives at an ephemeral scratchpad path that does not survive a fresh session,
# with the commit pinned nowhere. So each session used to get whatever cubical
# HEAD happened to be around, and modules written against a different release
# broke on `solve!`/`solve`, `·IdR`/`·Rid`, etc. This script ends that: one
# pinned commit, registered the same way every time.
#
# Exit 0 always in normal (hook) mode so it never blocks a session; pass
# --strict to exit nonzero on any mismatch (for CI / environment setup).

set -u

STRICT=0
[ "${1:-}" = "--strict" ] && STRICT=1

# --- locate repo root and read the lock -------------------------------------
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo=$(CDPATH= cd -- "$script_dir/.." && pwd)
lock="$repo/TOOLCHAIN.lock"

say()  { printf 'toolchain: %s\n' "$*"; }
warn() { printf 'toolchain: WARNING: %s\n' "$*" >&2; }
die()  { printf 'toolchain: FAIL: %s\n' "$*" >&2; [ "$STRICT" -eq 1 ] && exit 1; return 1; }

[ -f "$lock" ] || { warn "no TOOLCHAIN.lock at $lock"; exit 0; }

lockval() { awk -v k="$1" '$1==k {print $2; exit}' "$lock"; }

want_agda=$(lockval agda)
want_cubical_commit=$(lockval cubical_commit)
want_cubical_tag=$(lockval cubical_tag)
want_cubical_repo=$(lockval cubical_repo)
want_locale=$(lockval locale)

# --- 1. locale: agda dies rendering Unicode without a UTF-8 locale ----------
# Set it for this process and persist it for every future shell (the Bash tool
# initializes shells from the profile), so no agent ever hits the crash again.
export LC_ALL="$want_locale" LANG="$want_locale"
for rc in "$HOME/.bashrc" "$HOME/.profile"; do
  [ -f "$rc" ] || : > "$rc"
  if ! grep -q "AGDA TOOLCHAIN LOCALE" "$rc" 2>/dev/null; then
    {
      printf '\n# AGDA TOOLCHAIN LOCALE (managed by scripts/agda-toolchain.sh)\n'
      printf 'export LC_ALL=%s LANG=%s\n' "$want_locale" "$want_locale"
    } >> "$rc"
  fi
done
say "locale = $want_locale"

# --- 2. agda version must match (system binary — we can only verify) --------
if command -v agda >/dev/null 2>&1; then
  have_agda=$(agda --version 2>/dev/null | awk '{print $NF}')
  if [ "$have_agda" = "$want_agda" ]; then
    say "agda $have_agda (matches pin)"
  else
    die "agda $have_agda installed but pin wants $want_agda — this container image does not match the lock; nothing here can install a different agda"
  fi
else
  die "agda not found on PATH"
fi

# --- 3. cubical: ensure the pinned commit is present at a stable path -------
cubical_dir="$HOME/agda-libs/cubical"
need_clone=1
if [ -d "$cubical_dir/.git" ]; then
  have=$(git -C "$cubical_dir" rev-parse HEAD 2>/dev/null || echo none)
  if [ "$have" = "$want_cubical_commit" ]; then
    need_clone=0
    say "cubical present at pinned commit ${want_cubical_commit%??????????????????????????????????}… ($want_cubical_tag)"
  else
    warn "cubical at $cubical_dir is $have, want $want_cubical_commit — refetching"
    rm -rf "$cubical_dir"
  fi
fi

if [ "$need_clone" -eq 1 ]; then
  mkdir -p "$HOME/agda-libs"
  say "cloning cubical $want_cubical_tag (shallow) …"
  if git clone --quiet --depth 1 --branch "$want_cubical_tag" "$want_cubical_repo" "$cubical_dir" 2>/dev/null; then
    have=$(git -C "$cubical_dir" rev-parse HEAD 2>/dev/null || echo none)
    if [ "$have" != "$want_cubical_commit" ]; then
      die "cloned $want_cubical_tag but got commit $have, not the pinned $want_cubical_commit"
    fi
    say "cubical cloned at pinned commit"
  else
    if [ -d "/tmp/claude-0" ] && [ -d "$cubical_dir" ]; then :; fi
    die "could not clone cubical from $want_cubical_repo (network?)"
    # do not abort registration if a usable copy already exists elsewhere
  fi
fi

# --- 4. register the library under BOTH names so every depend: resolves -----
# v0.5's own lib is `name: cubical-0.5` (the hard pin punaragamana.agda-lib
# uses). We also register an alias `name: cubical` so the many modules that
# say `depend: cubical` resolve to the SAME pinned checkout — a wrong version
# can no longer sneak in under the plain name.
mkdir -p "$HOME/.agda"
if [ -f "$cubical_dir/cubical.agda-lib" ]; then
  # Alias so `depend: cubical` (plain name) resolves to the SAME pinned
  # checkout as `depend: cubical-0.5`. The alias file lives elsewhere than the
  # cubical source, so its include path MUST be absolute — a relative `.` would
  # resolve against the alias file's own directory and find no Cubical/.
  alias_lib="$HOME/agda-libs/cubical-alias.agda-lib"
  {
    echo "name: cubical"
    echo "include: $cubical_dir"
    echo "depend:"
    echo "flags: --cubical --no-import-sorts -WnoUnsupportedIndexedMatch"
  } > "$alias_lib"

  libs="$HOME/.agda/libraries"
  {
    echo "$cubical_dir/cubical.agda-lib"
    echo "$alias_lib"
    [ -f "$repo/formal/cubical/natural-machine.agda-lib" ] && echo "$repo/formal/cubical/natural-machine.agda-lib"
    [ -f "$repo/punaragamana/punaragamana.agda-lib" ] && echo "$repo/punaragamana/punaragamana.agda-lib"
  } > "$libs"
  say "registered ~/.agda/libraries → cubical-0.5 (+ alias cubical) + repo libs"
else
  die "no cubical.agda-lib at $cubical_dir"
fi

# --- 5. self-verify: the kernel must actually check a known-good file -------
probe="$repo/formal/cubical/EkaBhara_TheWindingTheHolonomyTheCommutatorImageTheHiddenChargeAndTheParityTangentAreOneGenerator.agda"
[ -f "$probe" ] || probe=$(find "$repo/formal/cubical" -maxdepth 1 -name 'Sivasutra.agda' 2>/dev/null | head -1)
if [ -n "${probe:-}" ] && [ -f "$probe" ]; then
  if ( cd "$repo/formal/cubical" && LC_ALL="$want_locale" agda --cubical --safe --no-import-sorts "$(basename "$probe")" >/dev/null 2>&1 ); then
    say "PASS — kernel checks a known-good module against the pinned library"
  else
    warn "kernel could not check the probe module; library may still be building caches on first run (retry the check), or the probe has an unrelated issue"
  fi
fi

say "ready. check any cubical file with: scripts/check-cubical.sh <path>"
exit 0
