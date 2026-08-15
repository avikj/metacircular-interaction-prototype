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
LIBS_DIR="$HOME/agda-libs"
LOG="${AGDA_INSTALL_LOG:-$HOME/.agda-install.log}"

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

have_cubical() {
  [ -f "$HOME/.agda/libraries" ] || return 1
  grep -q "cubical.agda-lib" "$HOME/.agda/libraries" || return 1
  lib=$(grep 'cubical.agda-lib' "$HOME/.agda/libraries" | head -1)
  [ -f "$lib" ] || return 1
  # registered under the plain name `cubical`, which is what
  # natural-machine.agda-lib depends on
  grep -q '^name: *cubical *$' "$lib"
}

check() {
  rc=0
  if have_agda; then
    say "agda: $(agda --version | head -1)"
  else
    if command -v agda >/dev/null 2>&1; then
      say "agda: WRONG VERSION — $(agda --version 2>&1 | head -1), need $AGDA_VERSION"
    else
      say "agda: MISSING"
    fi
    rc=1
  fi
  if have_cubical; then
    say "cubical: $(grep 'cubical.agda-lib' "$HOME/.agda/libraries" | head -1)"
  else
    say "cubical: MISSING (need $CUBICAL_TAG registered as name: cubical)"
    rc=1
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

install_ghcup() {
  command -v cabal >/dev/null 2>&1 && return 0
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
  say "==> cabal update"
  cabal update
  say "==> cabal install Agda-$AGDA_VERSION (expect tens of minutes)"
  cabal install "Agda-$AGDA_VERSION" --overwrite-policy=always
}

install_cubical() {
  have_cubical && return 0
  say "==> cubical $CUBICAL_TAG"
  mkdir -p "$LIBS_DIR"
  if [ ! -d "$LIBS_DIR/cubical/.git" ]; then
    rm -rf "$LIBS_DIR/cubical"
    git clone --depth 1 --branch "$CUBICAL_TAG" \
      https://github.com/agda/cubical "$LIBS_DIR/cubical"
  fi
  # BUILD.md: register under the plain name `cubical`; the upstream .agda-lib
  # names itself with the version, and natural-machine.agda-lib says
  # `depend: cubical`.
  sed -i 's/^name:.*/name: cubical/' "$LIBS_DIR/cubical/cubical.agda-lib"
  mkdir -p "$HOME/.agda"
  touch "$HOME/.agda/libraries"
  grep -q "$LIBS_DIR/cubical/cubical.agda-lib" "$HOME/.agda/libraries" \
    || printf '%s\n' "$LIBS_DIR/cubical/cubical.agda-lib" >> "$HOME/.agda/libraries"
}

do_install() {
  install_agda
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
