#!/usr/bin/env bash
# formal/cubical/check.sh — typecheck the cubical corpus against THE PIN.
#
# The pin (see BUILD.md "Reproducing the pin"):
#     Agda 2.8.0, built from Hackage against GHC 9.4.7
#     agda/cubical at tag v0.9 (commit b150186)
#
# Contract of this script:
#   * It NEVER reports green under a toolchain that is not the pin. If it has
#     to fall back, every line of its output says so and the exit code is
#     non-zero regardless of what Agda returned.
#   * It sets LC_ALL=C.UTF-8 unconditionally. Without it Agda 2.6.3 and 2.8.0
#     both die trying to print non-ASCII and return 42 for that reason alone.
#     Two false "the corpus is red" reports in this repo trace to exactly that.
#   * It reports a per-module exit code, and does not stop at the first red.
#
# Overrides:
#   AGDA_PIN            path to the pinned agda 2.8.0 binary
#   AGDA_CUBICAL_LIB    path to the cubical v0.9 checkout (dir with cubical.agda-lib)
#   NM_MODULES          space-separated module list to override the default
#
# Exit: 0 iff every module exited 0 AND both halves of the pin were found.

set -uo pipefail

# ---- 1. The locale. Unconditional, before anything else. -------------------
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PIN_AGDA_VERSION="2.8.0"
on_pin=1          # 1 = still believed to be on the pin; 0 = degraded
deviations=()

note_deviation() { on_pin=0; deviations+=("$1"); }

# ---- 2. Locate the pinned compiler. ----------------------------------------
find_agda() {
  local c
  if [ -n "${AGDA_PIN:-}" ]; then printf '%s\n' "$AGDA_PIN"; return; fi
  for c in \
    "$(command -v agda-2.8.0 2>/dev/null || true)" \
    "$HOME/.cabal/bin/agda" \
    /root/.cabal/bin/agda
  do
    [ -n "$c" ] && [ -x "$c" ] && { printf '%s\n' "$c"; return; }
  done
  # A `cabal get` + `cabal build` tree, wherever it was unpacked.
  for c in $(ls -d \
        "$HOME"/Agda-2.8.0/dist-newstyle/build/*/ghc-*/Agda-2.8.0/x/agda/build/agda/agda \
        /tmp/claude-*/*/*/scratchpad/Agda-2.8.0/dist-newstyle/build/*/ghc-*/Agda-2.8.0/x/agda/build/agda/agda \
        2>/dev/null); do
    [ -x "$c" ] && { printf '%s\n' "$c"; return; }
  done
  command -v agda 2>/dev/null || true
}

AGDA="$(find_agda)"
if [ -z "$AGDA" ]; then
  cat >&2 <<'EOF'
FATAL: no agda binary at all.

To build the pin (about 40 minutes of CPU; needs hackage.haskell.org):

  apt-get install -y cabal-install        # 3.8.1.0 is known to work
  cabal update
  cabal get Agda-2.8.0                    # NOT `cabal install`: under cabal
                                          # 3.8 that dies in its sdist step
                                          # with "Could not find module:
                                          # Agda.Benchmarking"
  cd Agda-2.8.0
  cabal build exe:agda --ghc-options=-j4  # system GHC 9.4.7 suffices; Agda's
                                          # tested-with says 9.4.8
  # `cabal build` does not populate the prim bundle the binary looks for:
  mkdir -p ~/.cabal/share/x86_64-linux-ghc-9.4.7/Agda-2.8.0
  cp -r src/data/* ~/.cabal/share/x86_64-linux-ghc-9.4.7/Agda-2.8.0/

Then re-run with AGDA_PIN=<path to the built agda>.
EOF
  exit 2
fi

agda_version="$("$AGDA" --version 2>/dev/null | head -1 | sed 's/^Agda version //;s/ .*//')"
if [ "$agda_version" != "$PIN_AGDA_VERSION" ]; then
  note_deviation "compiler is Agda ${agda_version:-unknown} at $AGDA, the pin is Agda $PIN_AGDA_VERSION"
fi

# ---- 3. Locate cubical v0.9. -----------------------------------------------
# Identified by content, not by directory name: v0.9 is the first release with
# `SymGroup` in Cubical/Algebra/SymmetricGroup.agda (v0.8 and earlier call it
# `Symmetric-Group`), and the first to rename `·Rid` to `·IdR`.
is_v09() { [ -f "$1/Cubical/Algebra/SymmetricGroup.agda" ] &&
           grep -q '^SymGroup' "$1/Cubical/Algebra/SymmetricGroup.agda" 2>/dev/null; }

find_cubical() {
  local d
  if [ -n "${AGDA_CUBICAL_LIB:-}" ]; then printf '%s\n' "${AGDA_CUBICAL_LIB%/}"; return; fi
  for d in /root/agda-libs/cubical-v0.9 "$HOME/agda-libs/cubical-v0.9" \
           /root/agda-libs/cubical "$HOME/agda-libs/cubical" \
           /usr/share/agda/cubical; do
    is_v09 "$d" && { printf '%s\n' "$d"; return; }
  done
  # Anything already registered in ~/.agda/libraries.
  if [ -f "$HOME/.agda/libraries" ]; then
    while read -r line; do
      line="${line%%--*}"; line="$(printf '%s' "$line" | tr -d '[:space:]')"
      [ -z "$line" ] && continue
      d="$(dirname "$line")"
      is_v09 "$d" && { printf '%s\n' "$d"; return; }
    done < "$HOME/.agda/libraries"
  fi
  # Give up on v0.9; fall back to whatever cubical exists so the run is still
  # informative, but the caller will be told loudly.
  for d in /root/agda-libs/cubical "$HOME/agda-libs/cubical"; do
    [ -f "$d/cubical.agda-lib" ] && { printf '%s\n' "$d"; return; }
  done
}

CUBICAL="$(find_cubical)"
if [ -z "$CUBICAL" ]; then
  cat >&2 <<'EOF'
FATAL: no cubical library found.

  git clone --depth 1 --branch v0.9 https://github.com/agda/cubical \
      /root/agda-libs/cubical-v0.9

Do NOT edit its cubical.agda-lib. Upstream names the library `cubical-0.9`
while formal/cubical/natural-machine.agda-lib says `depend: cubical`; Agda
resolves an unversioned dependency against a version-suffixed library, so the
two already agree. (Verified: see BUILD.md, "The naming question".)

Then re-run with AGDA_CUBICAL_LIB=/root/agda-libs/cubical-v0.9.
EOF
  exit 2
fi
if ! is_v09 "$CUBICAL"; then
  note_deviation "cubical at $CUBICAL is NOT v0.9 (no SymGroup in Cubical/Algebra/SymmetricGroup.agda)"
fi

libfile="$(mktemp)"
trap 'rm -f "$libfile"' EXIT
printf '%s\n' "$CUBICAL/cubical.agda-lib" > "$libfile"

# ---- 4. Announce, before running anything. ---------------------------------
echo   "======================================================================"
if [ "$on_pin" = 1 ]; then
  echo "RUNNING AGAINST THE PIN"
else
  echo "*** NOT THE PIN — RESULTS BELOW ARE NOT EVIDENCE ABOUT THE PIN ***"
fi
echo   "  agda    : $AGDA (version ${agda_version:-unknown})"
echo   "  cubical : $CUBICAL"
echo   "  locale  : LC_ALL=$LC_ALL"
for d in "${deviations[@]:-}"; do [ -n "$d" ] && echo "  DEVIATION: $d"; done
echo   "======================================================================"

# ---- 5. The modules. --------------------------------------------------------
# The root aggregate carries the load-bearing claim (BUILD.md): exit 0 there is
# exit 0 for everything it transitively imports. Everything.agda is wider and
# is currently expected red under the pin (Sl2TensorProduct, ·Rid → ·IdR); it is
# checked anyway, because an aggregate nobody runs is how the last overstatement
# hid.
default_modules="NaturalMachine.agda Everything.agda"
modules="${NM_MODULES:-$default_modules}"

cd "$here" || exit 2
rc_all=0
declare -a report=()
for m in $modules; do
  if [ ! -f "$m" ]; then
    report+=("MISSING  --  $m"); rc_all=1; continue
  fi
  echo
  echo "---- $m ----"
  log="$(mktemp)"
  "$AGDA" --library-file="$libfile" "$m" >"$log" 2>&1
  rc=$?
  errs=$(grep -c 'error:' "$log")
  warns=$(grep -c 'warning' "$log")
  # Show errors, and the tail for context; suppress the (many) Checking lines.
  grep 'error:' "$log" | head -20
  [ "$rc" -ne 0 ] && tail -5 "$log"
  rm -f "$log"
  echo "EXIT=$rc  (errors: $errs, warning lines: $warns)"
  if [ "$rc" -eq 0 ]; then report+=("EXIT 0   --  $m")
  else report+=("EXIT $rc  --  $m"); rc_all=1; fi
done

# ---- 6. Summary. ------------------------------------------------------------
echo
echo "======================================================================"
echo "SUMMARY"
for l in "${report[@]}"; do echo "  $l"; done
if [ "$on_pin" = 0 ]; then
  echo
  echo "  *** This run was NOT under the pin. Whatever is green above is"
  echo "      green under something else. Do not report it as a pin result."
  rc_all=1
fi
echo "======================================================================"
exit $rc_all
