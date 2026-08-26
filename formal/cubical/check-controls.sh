#!/usr/bin/env bash
# formal/cubical/check-controls.sh — the must-fail gate for
# NaturalMachine/Control/.
#
# WHY THIS EXISTS.  The nine files under NaturalMachine/Control/ are
# designed-annihilation controls (collab/PROTOCOL.md §7): each asserts a
# FALSE statement and *must fail to typecheck*.  Each header says, in its own
# words, "if a future edit makes this file compile, <a main claim> is broken."
# Until now nothing checked that.  check-agda-closure.sh guards the NEGATIVE
# obligation — a control is never imported, so it never turns an aggregate red
# — but the POSITIVE obligation, that each control still fails *and fails for
# the reason it was built to catch*, was guarded by nothing.  This script is
# that guard.  (Named as open work in collab/messages/0850; see
#
# A NAÏVE GATE IS NOT ENOUGH, AND WE HAVE THE COUNTEREXAMPLE.  "nonzero exit
# ⇒ pass" would green a control that has silently stopped testing its
# mathematics.  Measured 2026-08-18: under Agda 2.6.3 (OFF the pin),
# WrongFirstStep.agda fails with `Not in scope:` — a scope error, not the
# intended `0 != 1` type contradiction.  It exits nonzero while exercising
# nothing.  So each control carries an EXPECTED-MATCH signature (the message
# body its header quotes), and the gate demands that body appear in the
# output.  The match strings are the message BODY, not Agda's `error:[Tag]`
# header line — the tag is a 2.8.0 addition absent under 2.6.3, the body is
# stable across both.
#
# PIN DISCIPLINE (same contract as check.sh).  The recorded error sites live
# under Agda 2.8.0 + cubical v0.9 (BUILD.md).  This script NEVER certifies
# green off the pin: off-pin it still runs every control and prints
# diagnostics, but the banner says so and the exit code is nonzero regardless
# of what Agda returned.
#
# EXTENSIBILITY IS A GATE, NOT A COURTESY.  Every file matching
# NaturalMachine/Control/*.agda must have a row in EXPECT below.  A control
# with no row FAILS the gate ("unguarded control") — a new must-fail file
# cannot be added without declaring what its failure must look like.
#
# Overrides: AGDA_PIN, AGDA_CUBICAL_LIB (as in check.sh).
# Exit: 0 iff on the pin AND every control failed with its expected body
#       (and, where required, at its own last declaration).
set -uo pipefail

export LC_ALL=C.UTF-8
export LANG=C.UTF-8

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$here" || exit 2

CTRL_DIR="NaturalMachine/Control"

# ---- expected message body per control (grep -F fixed strings) -------------
# Each string is the body quoted in that file's own header verbatim block, and
# was re-observed live on 2026-08-18 (off-pin, Agda 2.6.3) except where noted.
# A '|' after the name flags the last-declaration property (see below).
declare -A EXPECT=(
  [FunctionBoundFromConstant]='2 != 1 of type'
  [InflationFlattened]='k0 != kι of type H2'
  [InjectivityNecessary]='one != two of type Three'
  [MaximizerWithoutNonvanishing]='NonVanishing W'
  [QuantifierDrop]='transports f s ≡ crit s'
  [ReachabilityWithoutStart]='st != s0 of type S'
  [SatisfactionWithoutCodomainAgreement]='Y q !=< Y′ q'
  [WrongEquivalence]='Canonical w'
  [WrongFirstStep]='0 != 1 of type'
  [WrongFirstStepNoTactic]='0 != 1 of type ℕ'
)
# Controls whose failure MUST land at their own last declaration, not earlier
# (an earlier error means an inlined copy has drifted and the control tests
# nothing — WrongFirstStepNoTactic header, "AND IT MUST FAIL AT ITS OWN LAST
# LINE, NOT EARLIER").  Value = grep -E pattern for the last decl's name.
declare -A LAST_DECL=(
  [WrongFirstStepNoTactic]='^wrong-step-names-tick'
)

# ---- locate the pin (mirrors check.sh; kept deliberately parallel) ---------
on_pin=1; deviations=()
note_dev() { on_pin=0; deviations+=("$1"); }

find_agda() {
  local c
  if [ -n "${AGDA_PIN:-}" ]; then printf '%s\n' "$AGDA_PIN"; return; fi
  for c in "$(command -v agda-2.8.0 2>/dev/null || true)" \
           "$HOME/.cabal/bin/agda" /root/.cabal/bin/agda; do
    [ -n "$c" ] && [ -x "$c" ] && { printf '%s\n' "$c"; return; }
  done
  command -v agda 2>/dev/null || true
}
is_v09() { [ -f "$1/Cubical/Algebra/SymmetricGroup.agda" ] &&
           grep -q '^SymGroup' "$1/Cubical/Algebra/SymmetricGroup.agda" 2>/dev/null; }
find_cubical() {
  local d
  if [ -n "${AGDA_CUBICAL_LIB:-}" ]; then printf '%s\n' "${AGDA_CUBICAL_LIB%/}"; return; fi
  for d in /root/agda-libs/cubical-v0.9 "$HOME/agda-libs/cubical-v0.9" \
           /root/agda-libs/cubical "$HOME/agda-libs/cubical"; do
    [ -f "$d/cubical.agda-lib" ] && { printf '%s\n' "$d"; return; }
  done
}

AGDA="$(find_agda)"
[ -z "$AGDA" ] && { echo "FATAL: no agda binary (see check.sh for the pin build)"; exit 2; }
ver="$("$AGDA" --version 2>/dev/null | head -1 | sed 's/^Agda version //;s/ .*//')"
[ "$ver" != "2.8.0" ] && note_dev "compiler is Agda ${ver:-unknown}, the pin is 2.8.0"
CUBICAL="$(find_cubical)"
[ -z "$CUBICAL" ] && { echo "FATAL: no cubical library (see check.sh)"; exit 2; }
is_v09 "$CUBICAL" || note_dev "cubical at $CUBICAL is not v0.9"

libfile="$(mktemp)"; trap 'rm -f "$libfile"' EXIT
printf '%s\n' "$CUBICAL/cubical.agda-lib" > "$libfile"

echo "======================================================================"
if [ "$on_pin" = 1 ]; then echo "MUST-FAIL GATE — RUNNING AGAINST THE PIN"
else echo "*** NOT THE PIN — a green here is NOT evidence about the pin ***"; fi
echo "  agda    : $AGDA (version ${ver:-unknown})"
echo "  cubical : $CUBICAL"
for d in "${deviations[@]:-}"; do [ -n "$d" ] && echo "  DEVIATION: $d"; done
echo "======================================================================"

# ---- 0. every control on disk has a declared expectation -------------------
status=0
declare -a report=()
for f in "$CTRL_DIR"/*.agda; do
  b="$(basename "$f" .agda)"
  if [ -z "${EXPECT[$b]:-}" ]; then
    report+=("UNGUARDED --  $b (no EXPECT row: declare its failure signature)")
    status=1
  fi
done

# ---- run each control ------------------------------------------------------
for b in "${!EXPECT[@]}"; do
  f="$CTRL_DIR/$b.agda"
  if [ ! -f "$f" ]; then report+=("MISSING   --  $b"); status=1; continue; fi
  want="${EXPECT[$b]}"
  log="$(mktemp)"
  "$AGDA" --library-file="$libfile" "$f" >"$log" 2>&1
  rc=$?

  if [ "$rc" -eq 0 ]; then
    report+=("COMPILED! --  $b  *** MUST FAIL BUT TYPECHECKED — a main claim is broken ***")
    status=1; rm -f "$log"; continue
  fi

  if ! grep -qF -- "$want" "$log"; then
    report+=("WRONG-ERR --  $b  exit=$rc but body not found: «$want» (fails for the wrong reason?)")
    echo "---- $b : observed error tail ----"; grep -v '^Checking' "$log" | tail -6
    status=1; rm -f "$log"; continue
  fi

  # optional: failure must be at the file's own last declaration
  if [ -n "${LAST_DECL[$b]:-}" ]; then
    decl_line="$(grep -nE "${LAST_DECL[$b]}" "$f" | head -1 | cut -d: -f1)"
    err_line="$(grep -oE "$b\.agda:[0-9]+" "$log" | head -1 | grep -oE '[0-9]+')"
    if [ -z "$decl_line" ] || [ -z "$err_line" ] || [ "$err_line" -lt "$decl_line" ]; then
      report+=("EARLY-ERR --  $b  error at line ${err_line:-?} precedes last decl (line ${decl_line:-?}) — inlined copy drifted")
      status=1; rm -f "$log"; continue
    fi
    report+=("OK (fail) --  $b  «$want» at last decl (line $err_line)")
  else
    report+=("OK (fail) --  $b  «$want»")
  fi
  rm -f "$log"
done

echo
echo "======================================================================"
echo "SUMMARY (must-fail gate over $CTRL_DIR)"
for l in "${report[@]}"; do echo "  $l"; done
if [ "$on_pin" = 0 ]; then
  echo
  echo "  *** NOT THE PIN — exit forced nonzero; do not read a green above as"
  echo "      a pin result.  Off-pin, error sites and even error KINDS can"
  echo "      differ (e.g. WrongFirstStep is scope-broken under 2.6.3)."
  status=1
fi
echo "======================================================================"
exit "$status"
