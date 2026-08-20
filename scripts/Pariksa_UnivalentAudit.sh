#!/usr/bin/env bash
# परीक्षा — Parīkṣā — the univalent audit of formal/cubical/, as a ratchet.
#
# (Nyāya uses *parīkṣā* for the critical examination of what has already
# been stated — Vātsyāyana, *Nyāyabhāṣya* on NS 1.1.1, c. 5th c.  The word
# is the corpus's, the mechanism is a shell script; no claim is made that
# the Naiyāyikas wrote gates.)
#
# ─────────────────────────────────────────────────────────────────────
# WHY THIS EXISTS
#
# `scripts/check-agda-pragmas.sh` guarantees every module ASSERTS
# `--safe`.  `scripts/check-agda-closure.sh` guarantees every module is
# REACHED by an aggregate root.  Neither says anything about the thing
# `notes/AHIMSA_SUTRA_VISTARA.md` calls हिंसा: a COLLAPSE — two things
# identified without an exhibited equivalence, or an h-level assumed
# where it was not earned.  `--safe` does not forbid a collapse.  It is
# perfectly safe, perfectly total, and perfectly irreversible (§५:
# प्रत्यानयनं नास्ति — there is no retraction; what is destroyed is not
# recoverable).
#
# So this measures four quantities and FAILS IF ANY OF THEM RISES.  It
# does not forbid any of them.  A propositional truncation is frequently
# the honest move; what is forbidden is adding one SILENTLY.  Raising a
# number means editing the baseline, and editing the baseline means
# writing down what was collapsed and why — which is exactly §६'s second
# path, दोषो लिख्यते, mechanised at the moment of the act.
#
# Same reasoning as the Python ban in CLAUDE.md: "enforced mechanically
# because prose failed."
#
# ─────────────────────────────────────────────────────────────────────
# WHAT IT MEASURES  (all four are exact text analysis, no toolchain)
#
#   api-skew            modules importing a name the PINNED cubical
#                       (v0.9, formal/cubical/BUILD.md) does not export:
#                       a bare `solve` under a `…Solver.Reflection`
#                       import — v0.9 exports only `solve!` / `solveℕ!` —
#                       and `Symmetric-Group`, which v0.9 spells
#                       `SymGroup`.  Every such module
#                       FAILS TO TYPECHECK under the pin.  This is not a
#                       style rule; it is a count of modules whose green
#                       is stale.  Verified by running the pinned Agda on
#                       a sample (see NOTES at the bottom).
#
#   hlevel-redundant    files where `isSet X` and `Discrete X` (or
#                       `Separated X`) both occur for the same `X`.
#                       Hedberg makes the first derivable from the second,
#                       so a site ASSUMING both is assuming an h-level it
#                       already had — the audit question
#                       `NaturalMachine/HypothesesAssumedWhereTheyAreDerivable`
#                       asks of its own thread, asked of the whole lane.
#                       Coarse by design (per file, not per telescope):
#                       it is a ratchet, and a false positive costs one
#                       baseline line with a reason, which is cheap.
#
#   trunc-modules       modules that INTRODUCE a truncation (`∣ … ∣₁`,
#                       `∣ … ∣₂`).  Each is a point at which the WHICH is
#                       destroyed and only the THAT survives, with no way
#                       back (AHIMSA_SUTRA_VISTARA §४–§५;
#                       `Apratikaryatva_TheRetractionTypeIsTheHLevelHypothesis`
#                       proves the no-retraction theorem uniformly in the
#                       level).
#
#   settrunc-modules    modules mentioning `∥_∥₂` specifically — a
#                       set-truncation kills all higher structure, and in
#                       a `--cubical` development that structure may be
#                       the content (`SetTruncationDescentBoundary`
#                       proves the descent datum for set-level descent IS
#                       `isSet A`, so a set-truncation is exactly the
#                       assumption of UIP where it was not earned).
#
# WHAT IT DOES NOT MEASURE, said plainly so nobody quotes it for more
# than it is:
#   * it is TEXT, not a build.  It cannot see through an import, and it
#     says nothing about whether anything typechecks (that is
#     `formal/check.sh` and the pin in `formal/cubical/BUILD.md`).
#   * it cannot detect an identification-by-name at the level of MEANING
#     — two objects declared equal because their carriers happen to have
#     the same shape.  No grep can.  That one stays a reading obligation
#     and is stated here so `unmechanisable` is not mistaken for
#     `unenforced` (CLAUDE.md, "Regressions observed in one long
#     session").
#
# Usage:
#   scripts/Pariksa_UnivalentAudit.sh              # ratchet, exit 1 on a rise
#   scripts/Pariksa_UnivalentAudit.sh --list       # ratchet + name every site
#   scripts/Pariksa_UnivalentAudit.sh --update     # rewrite the baseline
#   scripts/Pariksa_UnivalentAudit.sh --build      # additionally run the
#                                                  # pinned Agda per module
#                                                  # (slow; needs the pin)
set -uo pipefail

cd "$(dirname "$0")/.."
BASELINE="scripts/pariksa-baseline.tsv"
LANE="formal/cubical"

mode="${1:-}"


# ---- 1. api-skew ------------------------------------------------------
# Only IMPORT lines count: the strings appear in prose in several headers
# (BUILD.md's migration notes are quoted inside IndianLane.agda), and a
# gate that fires on a comment is a gate people learn to ignore.
api_skew() {
  for f in $(find "$LANE" -name '*.agda' -not -path '*/_build/*' | sort); do
    # comment lines stripped: the v0.5 spellings are quoted in several
    # headers (IndianLane.agda quotes BUILD.md's migration note verbatim),
    # and a gate that fires on prose is a gate people learn to ignore.
    code=$(grep -vE '^[[:space:]]*--' "$f")
    if printf '%s\n' "$code" \
       | grep -qE '^[[:space:]]*open[[:space:]]+import[[:space:]]+Cubical\.Tactics\.(CommRing|Nat)Solver\.Reflection'
    then
      # A BARE `solve`: cubical v0.9 exports only `solve!` and `solveℕ!`.
      # EGBPairConic.agda is why the check is on the USE and not on the
      # `using (solve)` form — it imports the module unqualified and calls
      # `solve` forty lines later, and an import-line-only check missed it
      # while the pinned Agda did not.
      if printf '%s\n' "$code" | grep -qE '(^|[^!ℕA-Za-z0-9_])solve([^!ℕA-Za-z0-9_]|$)'
      then printf '%s\n' "$f"; continue; fi
    fi
    printf '%s\n' "$code" | grep -q 'Symmetric-Group' && printf '%s\n' "$f"
  done
  return 0
}

# ---- 2. hlevel-redundant ---------------------------------------------
hlevel_redundant() {
  for f in $(find "$LANE" -name '*.agda' -not -path '*/_build/*' | sort); do
    s=$(grep -o "isSet [A-Za-z][A-Za-z0-9'_]*" "$f" 2>/dev/null | awk '{print $2}' | sort -u)
    [ -z "$s" ] && continue
    d=$(grep -oE "(Discrete|Separated) [A-Za-z][A-Za-z0-9'_]*" "$f" 2>/dev/null | awk '{print $2}' | sort -u)
    [ -z "$d" ] && continue
    c=$(comm -12 <(printf '%s\n' "$s") <(printf '%s\n' "$d"))
    [ -n "$c" ] && printf '%s\t%s\n' "$f" "$(printf '%s' "$c" | tr '\n' ' ')"
  done
}

# ---- 3/4. truncation --------------------------------------------------
trunc_modules() {
  grep -lE '∣[^|]*∣₁|∣[^|]*∣₂|∣_∣₁|∣_∣₂' \
    $(find "$LANE" -name '*.agda' -not -path '*/_build/*') 2>/dev/null | sort -u
}
settrunc_modules() {
  grep -l '∥₂' \
    $(find "$LANE" -name '*.agda' -not -path '*/_build/*') 2>/dev/null | sort -u
}

A=$(api_skew);            a=$(printf '%s' "$A" | grep -c . || true)
H=$(hlevel_redundant);    h=$(printf '%s' "$H" | grep -c . || true)
T=$(trunc_modules);       t=$(printf '%s' "$T" | grep -c . || true)
S=$(settrunc_modules);    s=$(printf '%s' "$S" | grep -c . || true)

if [ "$mode" = "--list" ]; then
  echo "── api-skew (cannot typecheck under the pin) ──";        printf '%s\n' "$A"
  echo "── hlevel-redundant (isSet co-assumed with Discrete) ──"; printf '%s\n' "$H"
  echo "── settrunc-modules (∥_∥₂: UIP, silently) ──";            printf '%s\n' "$S"
  echo
fi

printf 'api-skew          : %s\n' "$a"
printf 'hlevel-redundant  : %s\n' "$h"
printf 'trunc-modules     : %s\n' "$t"
printf 'settrunc-modules  : %s\n' "$s"

if [ "$mode" = "--update" ]; then
  {
    echo "# Baseline for scripts/Pariksa_UnivalentAudit.sh."
    echo "# Each number may FALL freely.  Raising one requires editing this"
    echo "# file, and editing this file is where the defect gets written."
    echo "# metric<TAB>count<TAB>reason the current level stands"
    printf 'api-skew\t%s\tv0.5 solver/SymGroup spellings not migrated to the v0.9 pin. NOT hypothetical: the per-module census (--build, 2026-08-20, Agda 2.8.0 + cubical-0.9) reports 165 green / 28 red at top level, `agda Everything.agda` exits 42 at EGBDetConservation:89, and every module this metric names that was run individually exited 42 (Madhava, Brahmagupta, Cakravala, GhanaBaddha, Dvikarani, EGBPairConic, NaturalMachine/{BoundedStateNeedsAGroup,DescentIsNotInversion,EveryTripleIsARotation}). The count is DIRECT users only; modules red merely by importing one of them are additional (Ardhaccheda, GunaDhana, Jiva, KuttakaCRT, ... all fail inside Vargana/YugapatZ/BhavanaSemiring). One top-level red has a different cause and is not counted here: SubgroupIndex.agda:155, where v0.9 Cubical.Relation.Nullary newly exports the same `⟪_⟫` as Cubical.Algebra.Group.Subgroup.\n' "$a"
    printf 'hlevel-redundant\t%s\tthe assumed one is ExclusionRecoversGroundAtAPrice:267 (isSet T with Discrete T), already documented by NaturalMachine/HypothesesAssumedWhereTheyAreDerivable; the rest are DERIVED at their sites (LinearOrderFinite from isFinSet, StagewiseComposite says so in its header) and are ratchet noise, not findings.\n' "$h"
    printf 'trunc-modules\t%s\ttruncation is often the honest move; this number exists so a new one cannot be added without someone writing why.\n' "$t"
    printf 'settrunc-modules\t%s\tset-truncation assumes UIP at the object; each of these should be able to say what higher structure it destroys.\n' "$s"
  } > "$BASELINE"
  echo "baseline written: $BASELINE"
  exit 0
fi

if [ ! -f "$BASELINE" ]; then
  echo "FAIL: no baseline at $BASELINE — run with --update once, and commit it."
  exit 1
fi

status=0
check() { # check <metric> <now>
  want=$(awk -F'\t' -v m="$1" '$1==m {print $2}' "$BASELINE")
  if [ -z "$want" ]; then
    echo "FAIL: $1 has no baseline row in $BASELINE"; status=1; return
  fi
  if [ "$2" -gt "$want" ]; then
    echo "FAIL: $1 rose $want → $2."
    echo "      A collapse was added without a written defect."
    echo "      Either remove it, or raise the baseline WITH ITS REASON:"
    echo "        scripts/Pariksa_UnivalentAudit.sh --list   # find the new site"
    echo "        scripts/Pariksa_UnivalentAudit.sh --update # then edit the reason"
    status=1
  elif [ "$2" -lt "$want" ]; then
    echo "note: $1 FELL $want → $2 — run --update to latch the improvement."
  fi
}
check api-skew          "$a"
check hlevel-redundant  "$h"
check trunc-modules     "$t"
check settrunc-modules  "$s"

# ---- optional: the real thing -----------------------------------------
if [ "$mode" = "--build" ]; then
  echo
  echo "── per-module typecheck under the pin (slow) ──"
  red=0; green=0
  for f in $(ls "$LANE"/*.agda); do
    m=$(basename "$f")
    if (cd "$LANE" && LC_ALL=C.UTF-8 agda "$m" >/dev/null 2>&1); then
      green=$((green+1))
    else
      red=$((red+1)); echo "RED  $LANE/$m"
    fi
  done
  echo "top-level modules: $green green, $red red"
  [ "$red" -gt 0 ] && status=1
fi

if [ "$status" -eq 0 ]; then
  echo "OK: no new collapse, no new API skew."
fi
exit "$status"

# ─────────────────────────────────────────────────────────────────────
# NOTES, 2026-08-20, from the run that produced the first baseline.
#
# * The api-skew number is not a hypothetical.  `agda Everything.agda`
#   exits 42 under the pin (Agda 2.8.0 + cubical-0.9) at
#   EGBDetConservation.agda:89, and individual runs of Madhava.agda,
#   Brahmagupta.agda, Cakravala.agda, GhanaBaddha.agda and
#   Dvikarani.agda all exit 42 for the same reason.  The modules
#   carrying this book's own primary-source mathematics — Mādhava's
#   series, Brahmagupta's bhāvanā, the cakravāla — are RED, and have
#   been since the v0.9 migration was done partially.  Nothing in
#   `formal/check.sh` fails on this: the Everything step is wrapped in a
#   fallback that prints a banner and continues.
#
# * hlevel-redundant is SMALL, and that is a real result about this
#   corpus rather than a limitation of the check: the lane earns its
#   h-levels.  Where `isSet` and `Discrete` co-occur they are almost
#   always both DERIVED (from `isFinSet`, via `Discrete→isSet`) rather
#   than both assumed.  One genuine co-ASSUMPTION exists and was already
#   found and documented by the lane itself.
# ─────────────────────────────────────────────────────────────────────
