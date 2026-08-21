#!/usr/bin/env bash
# Verify the whole development. Idempotent; bootstraps its own toolchain.
set -euo pipefail

AGDA_VERSION_WANTED="2.6.3"
CUBICAL_TAG="v0.5"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPS="${PUNARAGAMANA_DEPS:-$HOME/.cache/punaragamana}"

# LC_ALL matters: under a POSIX locale Agda crashes while PRINTING its own
# error messages for the Devanagari identifiers, hiding the real diagnosis.
export LC_ALL=C.utf8

SUDO=""
if [ "$(id -u)" -ne 0 ]; then SUDO="sudo"; fi

if ! command -v agda >/dev/null 2>&1; then
  echo "==> installing Agda"
  ${SUDO} apt-get update -qq
  ${SUDO} env DEBIAN_FRONTEND=noninteractive apt-get install -y -qq agda
fi

echo "==> $(agda --version)"
agda --version | grep -q "$AGDA_VERSION_WANTED" \
  || echo "    (warning: pinned against $AGDA_VERSION_WANTED; flag behaviour is version-sensitive)"

if [ ! -d "$DEPS/cubical/Cubical" ]; then
  echo "==> fetching agda/cubical $CUBICAL_TAG"
  mkdir -p "$DEPS"
  git clone --depth 1 --branch "$CUBICAL_TAG" https://github.com/agda/cubical.git "$DEPS/cubical"
fi

LIBFILE="$DEPS/libraries"
printf '%s\n' "$DEPS/cubical/cubical.agda-lib" "$ROOT/punaragamana.agda-lib" > "$LIBFILE"

echo "==> typechecking"
agda --library-file="$LIBFILE" -i "$ROOT/src" "$ROOT/src/Everything.agda"
echo "==> OK: all modules check under --cubical --safe"
