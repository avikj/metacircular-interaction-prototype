#!/bin/sh
# Ensure the pinned Agda toolchain exists, or say so loudly.
#
# Written 2026-08-15 after a session shipped four hand proofs with the ledger
# line "no Agda was added: agda is not installed in this session". That is the
# substrate being absent deciding what mathematics gets written, which is
# exactly backwards. `formal/cubical/BUILD.md` had the install recipe the whole
# time; nothing enforced or ran it.
#
# Pinned by BUILD.md: Agda 2.8.0, cubical library v0.9 (release tag).
#
#   ensure-toolchain.sh            check only; exit 0 if usable, 1 if not
#   ensure-toolchain.sh --install  install what is missing, then check
#   ensure-toolchain.sh --install --background
#                                  start the install detached, log to
#                                  $LOG, return immediately
#
# Idempotent. Safe to run on every session start. Installs nothing on a
# --check run.

set -eu

AGDA_VERSION=2.8.0
CUBICAL_TAG=v0.9
# Pinned by COMMIT, not by tag. `--branch v0.9` resolves a moveable label at
# clone time; three sessions recorded three different cubical versions
# (v0.5 in the module headers, v0.7 in claims R0079/R0080/R0081, v0.9 in
# BUILD.md) partly because nothing ever wrote down an immutable identifier.
# This is v0.9 as it stood on 2026-08-21.
CUBICAL_COMMIT=b150186d2544e7efeddd31e5d14a8b9ecbb100f7
LIBS_DIR="$HOME/agda-libs"
LOG="${AGDA_INSTALL_LOG:-$HOME/.agda-install.log}"
# Marker recording the (agda, cubical) pair the probe last accepted, so the
# probe runs once per pair and every later session start is a string compare.
PROBE_MARK="$HOME/.agda/.probe-ok"

# ghcup and cabal put binaries here; a fresh shell has not sourced env yet.
PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$HOME/.local/bin:$PATH"
export PATH

# Agda emits ℕ, ≃, … and dies on error output under a non-UTF-8 locale.
LC_ALL="${LC_ALL:-C.UTF-8}"
LANG="${LANG:-C.UTF-8}"
export LC_ALL LANG

say() { printf '%s\n' "$*"; }

# ---------------------------------------------------------------- check

have_agda() {
  command -v agda >/dev/null 2>&1 || return 1
  agda --version 2>/dev/null | grep -q "$AGDA_VERSION"
}

# The PATH this script gives itself is not the PATH anything else has.  We
# prepend ~/.cabal/bin above, that export dies with the script, and a session's
# shells, hooks and tools resolve `agda` to Ubuntu's /usr/bin/agda -- 2.6.3,
# which cannot parse cubical v0.9.  So `have_agda` passing proves only that
# THIS script can see a good Agda, which is not the claim anybody needs.
#
# This asks the question consumers actually ask: with the ordinary PATH, is
# `agda` the pinned version?  Caught 2026-08-21, when the repaired script
# reported exit 0 while `env -i ... sh -c 'agda --version'` still said 2.6.3.
DEFAULT_PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

have_agda_on_default_path() {
  env -i HOME="$HOME" PATH="$DEFAULT_PATH" LC_ALL=C.UTF-8 \
    sh -c 'command -v agda >/dev/null 2>&1 && agda --version' 2>/dev/null \
    | grep -q "$AGDA_VERSION"
}

# Put the pinned build where the ordinary PATH finds it.  /usr/local/bin
# precedes /usr/bin, so this wins over the distribution package without
# removing it.  Runs whether or not a build was needed this time: the binary
# can be present from an earlier run and still be invisible.
publish_agda() {
  have_agda || return 1
  have_agda_on_default_path && return 0
  [ "$(id -u)" = 0 ] || {
    say "!! not root; cannot publish agda to /usr/local/bin."
    say "!! add $HOME/.cabal/bin to PATH by hand, ahead of /usr/bin."
    return 1
  }
  src=$(command -v agda)
  say "==> publishing $src to /usr/local/bin/agda (was: $(env -i PATH="$DEFAULT_PATH" sh -c 'command -v agda' 2>/dev/null || echo none))"
  ln -sf "$src" /usr/local/bin/agda
  m=$(command -v agda-mode 2>/dev/null) && ln -sf "$m" /usr/local/bin/agda-mode
  hash -r 2>/dev/null || true
}

have_cubical() {
  [ -f "$HOME/.agda/libraries" ] || return 1
  grep -q "cubical.agda-lib" "$HOME/.agda/libraries" || return 1
  lib=$(grep 'cubical.agda-lib' "$HOME/.agda/libraries" | head -1)
  [ -f "$lib" ] || return 1
  # It must be the checkout THIS script manages. A registration pointing into
  # /tmp is a leftover from some earlier session's hand-clone; it outlives the
  # container that made it only in ~/.agda/libraries, where it silently wins,
  # and it is how the corpus came to record three different cubical versions.
  case "$lib" in
    "$LIBS_DIR"/*) ;;
    *) return 1 ;;
  esac
  # registered under the plain name `cubical`, which is what
  # natural-machine.agda-lib depends on
  grep -q '^name: *cubical *$' "$lib" || return 1
  # and at the pinned commit, if it is a git checkout we made
  d=$(dirname "$lib")
  if [ -d "$d/.git" ]; then
    [ "$(git -C "$d" rev-parse HEAD 2>/dev/null)" = "$CUBICAL_COMMIT" ] || return 1
  fi
  return 0
}

# Does this Agda actually accept this cubical?  `have_agda` and `have_cubical`
# together do NOT answer that: a registered cubical v0.9 with Agda 2.6.3 passes
# both and then dies on the first `opaque` block in
# Cubical/Foundations/Structure.agda, because v0.7+ uses a construct 2.6.3
# cannot parse.  Measured 2026-08-21.  A check that reports READY for a pair
# that cannot typecheck anything is worse than no check, so: compile a probe.
#
# The probe imports Structure DELIBERATELY.  An earlier probe that imported
# only Cubical.Data.Nat passed against exactly the broken pair above, because
# nothing on that path reaches the module that fails.  Widen this, never
# narrow it.
probe_id() {
  printf '%s %s' "$(agda --version 2>/dev/null | head -1)" "$CUBICAL_COMMIT"
}

have_probe() {
  command -v agda >/dev/null 2>&1 || return 1
  [ -f "$PROBE_MARK" ] || return 1
  [ "$(cat "$PROBE_MARK")" = "$(probe_id)" ]
}

run_probe() {
  d=$(mktemp -d) || return 1
  cat > "$d/Probe.agda" <<'PROBE'
{-# OPTIONS --cubical --guardedness --safe #-}
module Probe where
open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure   -- `opaque`: version-sensitive
open import Cubical.Data.Nat
open import Cubical.Data.Sigma
open import Cubical.Induction.WellFounded
open import Cubical.HITs.PropositionalTruncation using (∥_∥₁; ∣_∣₁; squash₁)
_ : 2 + 2 ≡ 4
_ = refl
PROBE
  printf 'name: probe\ninclude: .\ndepend: cubical\n' > "$d/probe.agda-lib"
  if (cd "$d" && agda Probe.agda) >/dev/null 2>&1; then
    mkdir -p "$HOME/.agda"
    probe_id > "$PROBE_MARK"
    rm -rf "$d"
    return 0
  fi
  rm -rf "$d"
  return 1
}

check() {
  rc=0
  if have_agda; then
    say "agda: $(agda --version | head -1)"
    if ! have_agda_on_default_path; then
      say "agda: NOT ON THE DEFAULT PATH — a plain shell still gets"
      say "      $(env -i PATH=$DEFAULT_PATH sh -c 'command -v agda && agda --version | head -1' 2>/dev/null || echo none)"
      rc=1
    fi
  else
    if command -v agda >/dev/null 2>&1; then
      say "agda: WRONG VERSION — $(agda --version 2>&1 | head -1), need $AGDA_VERSION"
    else
      say "agda: MISSING"
    fi
    rc=1
  fi
  if have_cubical; then
    say "cubical: $(grep 'cubical.agda-lib' "$HOME/.agda/libraries" | head -1) @ ${CUBICAL_COMMIT}"
  else
    say "cubical: MISSING (need $CUBICAL_TAG @ ${CUBICAL_COMMIT} registered as name: cubical)"
    rc=1
  fi
  # Only meaningful once both halves are present; a probe against a missing
  # agda is noise.
  if [ "$rc" -eq 0 ]; then
    if have_probe || run_probe; then
      say "probe: OK (agda parses cubical through Cubical.Foundations.Structure)"
    else
      say "probe: FAILED — this agda cannot typecheck this cubical."
      say "        agda/cubical's README fixes the pairing: v0.9 needs Agda"
      say "        2.8.0; v0.8 needs 2.6.4.1/2.7.0.1; v0.5 needs 2.6.3."
      say "        Change AGDA_VERSION and CUBICAL_COMMIT together, never one."
      rc=1
    fi
  fi
  return $rc
}

# ---------------------------------------------------------------- install

# GHC links against libgmp and ncurses. A container without the -dev packages
# builds every dependency and then dies at the first link with
# `/usr/bin/ld: cannot find -lgmp`, tens of minutes in. Found the hard way,
# 2026-08-15.
install_sysdeps() {
  [ -e /usr/lib/x86_64-linux-gnu/libgmp.so ] && return 0
  command -v apt-get >/dev/null 2>&1 || {
    say "!! libgmp headers missing and no apt-get; install libgmp-dev by hand"
    return 0
  }
  say "==> system deps (libgmp-dev, zlib1g-dev, libncurses-dev, build-essential)"
  apt-get update -qq || true
  apt-get install -y -qq libgmp-dev zlib1g-dev libncurses-dev build-essential
}

# Hackage's package index is TUF-signed, and the agent proxy re-serves it, so
# `cabal update` fails with
#
#     <repo>/root.json does not have enough signatures signed with the
#     appropriate keys
#
# and `set -eu` kills the install on that line — every session, silently, into
# a log nobody read.  THIS IS WHY THE AUTO-INSTALL NEVER FINISHED.  Reproduced
# and fixed 2026-08-21.
#
# This disables Hackage's own content signing, NOT TLS.  TLS verification stays
# on and the proxy CA bundle at /root/.ccr is untouched — see the environment
# note that says never to disable TLS verification; this is a different check.
allow_hackage_behind_proxy() {
  cfg="$HOME/.cabal/config"
  [ -f "$cfg" ] || cabal user-config init >/dev/null 2>&1 || true
  [ -f "$cfg" ] || return 0
  grep -qE '^[[:space:]]*secure:[[:space:]]*False' "$cfg" && return 0
  say "==> hackage: disabling TUF signature check (proxy re-serves the index)"
  sed -i 's/^\([[:space:]]*\)--[[:space:]]*secure:[[:space:]]*True/\1secure: False/' "$cfg"
  grep -qE '^[[:space:]]*secure:[[:space:]]*False' "$cfg" || \
    printf '\nrepository hackage.haskell.org\n  url: http://hackage.haskell.org/\n  secure: False\n' >> "$cfg"
  rm -rf "$HOME/.cabal/packages/hackage.haskell.org"
}

install_ghcup() {
  command -v cabal >/dev/null 2>&1 && return 0
  # The distribution's ghc/cabal are enough to build Agda and are a single apt
  # transaction; ghcup's bootstrap is a curl to get-ghcup.haskell.org, which is
  # one more thing the proxy can refuse.  Try apt first.
  if command -v apt-get >/dev/null 2>&1; then
    say "==> ghc + cabal-install via apt"
    apt-get update -qq || true
    if apt-get install -y -qq ghc cabal-install; then
      command -v cabal >/dev/null 2>&1 && return 0
    fi
  fi
  say "==> installing ghcup + GHC + cabal (long; this is the slow part)"
  BOOTSTRAP_HASKELL_NONINTERACTIVE=1 \
  BOOTSTRAP_HASKELL_INSTALL_NO_STACK=1 \
  BOOTSTRAP_HASKELL_ADJUST_BASHRC=1 \
    sh -c "$(curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org)"
  # shellcheck disable=SC1091
  [ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"
}

install_agda() {
  have_agda && return 0
  install_sysdeps
  install_ghcup
  allow_hackage_behind_proxy
  say "==> cabal update"
  cabal update
  say "==> cabal install Agda-$AGDA_VERSION (expect tens of minutes)"
  # --installdir=/usr/local/bin, NOT cabal's default ~/.cabal/bin.
  #
  # The second reason this script never succeeded, and it only became visible
  # once the `cabal update` failure above was fixed: the build works, the
  # binary lands in ~/.cabal/bin, and NOTHING ELSE LOOKS THERE.  This script
  # prepends ~/.cabal/bin to its own PATH, but that export dies with the
  # script, so every later shell, hook and tool resolves `agda` to Ubuntu's
  # /usr/bin/agda -- version 2.6.3, which cannot parse cubical v0.9 at all.
  # A correct build shadowed by a stale package is indistinguishable from no
  # build.  /usr/local/bin precedes /usr/bin in the default PATH, so landing
  # there makes the pinned Agda the one everything finds, with no environment
  # surgery and nothing to source.  Measured 2026-08-21.
  if [ -w /usr/local/bin ] || [ "$(id -u)" = 0 ]; then
    cabal install "Agda-$AGDA_VERSION" --overwrite-policy=always \
      --installdir=/usr/local/bin
  else
    say "!! /usr/local/bin not writable; installing to cabal's default."
    say "!! `agda` on PATH may remain the distribution's older build."
    cabal install "Agda-$AGDA_VERSION" --overwrite-policy=always
  fi
  # The shell caches command lookups.  `agda` was resolved to /usr/bin/agda by
  # the have_agda call that sent us down this path, and without this the check
  # below re-reads that cached entry and reports the version we just replaced.
  hash -r 2>/dev/null || true
}

install_cubical() {
  have_cubical && return 0
  say "==> cubical $CUBICAL_TAG @ $CUBICAL_COMMIT"
  mkdir -p "$LIBS_DIR"
  # By commit. `--branch v0.9` follows a label that can move under us; fetching
  # the object cannot.
  if [ ! -d "$LIBS_DIR/cubical/.git" ]; then
    rm -rf "$LIBS_DIR/cubical"
    git init -q "$LIBS_DIR/cubical"
    git -C "$LIBS_DIR/cubical" remote add origin https://github.com/agda/cubical
  fi
  if [ "$(git -C "$LIBS_DIR/cubical" rev-parse HEAD 2>/dev/null)" != "$CUBICAL_COMMIT" ]; then
    git -C "$LIBS_DIR/cubical" fetch -q --depth 1 origin "$CUBICAL_COMMIT"
    git -C "$LIBS_DIR/cubical" checkout -q --detach FETCH_HEAD
  fi
  # BUILD.md: register under the plain name `cubical`; the upstream .agda-lib
  # names itself with the version, and natural-machine.agda-lib says
  # `depend: cubical`.
  sed -i 's/^name:.*/name: cubical/' "$LIBS_DIR/cubical/cubical.agda-lib"
  mkdir -p "$HOME/.agda"
  touch "$HOME/.agda/libraries"
  # Drop every other cubical registration first. Leaving a stale /tmp entry
  # above ours means Agda resolves `depend: cubical` to whichever it finds,
  # and the pin becomes advisory.
  grep -v 'cubical\.agda-lib' "$HOME/.agda/libraries" > "$HOME/.agda/libraries.new" || true
  printf '%s\n' "$LIBS_DIR/cubical/cubical.agda-lib" >> "$HOME/.agda/libraries.new"
  mv "$HOME/.agda/libraries.new" "$HOME/.agda/libraries"
  rm -f "$PROBE_MARK"
}

do_install() {
  install_agda
  publish_agda || true
  install_cubical
  say "==> installed; checking"
  check
}

# ---------------------------------------------------------------- main

BACKGROUND=0
INSTALL=0
for arg in "$@"; do
  case "$arg" in
    --install) INSTALL=1 ;;
    --background) BACKGROUND=1 ;;
    --check) INSTALL=0 ;;
    *) say "usage: $0 [--install] [--background]"; exit 2 ;;
  esac
done

if [ "$INSTALL" -eq 0 ]; then
  check
  exit $?
fi

if check >/dev/null 2>&1; then
  check
  exit 0
fi

if [ "$BACKGROUND" -eq 1 ]; then
  if [ -f "$LOG.pid" ] && kill -0 "$(cat "$LOG.pid")" 2>/dev/null; then
    say "install already running (pid $(cat "$LOG.pid")); log: $LOG"
    exit 0
  fi
  : > "$LOG"
  # nohup so it survives the hook's shell
  nohup sh "$0" --install >>"$LOG" 2>&1 &
  echo $! > "$LOG.pid"
  say "install started in background (pid $(cat "$LOG.pid")); log: $LOG"
  exit 0
fi

do_install
