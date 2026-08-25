#!/bin/sh
# Modules that no aggregate root reaches.  A module nothing reaches is
# verified by nothing, so this is the number that decides whether a green
# means anything.
#
# ─────────────────────────────────────────────────────────────────────────
# THIS SCRIPT USED TO PRINT 134 AND 134 WAS WRONG BY A FACTOR OF THIRTEEN.
# Corrected 2026-08-22.  The version it replaces is quoted in full below,
# because striking a number silently is how this repository loses its own
# history, and both of its defects are worth carrying:
#
#   1. IT DID ONE TRANSITIVE STEP, NOT A CLOSURE.  It expanded the roots'
#      direct imports once and stopped, so anything at depth ≥ 3 counted as
#      unreached.  That inflates.
#   2. IT MATCHED MODULE NAMES WITH `[A-Za-z0-9_.]`, AN ASCII-ONLY CLASS.
#      Every module named `…_ℤ±`, `…Occupancy₄`, `…_विवेक` therefore read as
#      NEVER IMPORTED however many roots imported it — 17 of them.  So the
#      count was inflated a second time, and specifically at the files whose
#      names were not English.  CLAUDE.md names this exact failure one level
#      up, about the header lint: "a check that scores a Devanagari citation
#      below a romanised one is this rule's own scrubbing arriving through
#      the back door as a lint."  It arrived through the back door again.
#   3. IT COLLAPSED MODULE NAMES TO BASENAMES (`sed 's|.*\.||'`), so
#      `Ratri.Foo` and a top-level `Foo` were the same key.
#
#   The old body, verbatim:
#     find formal/cubical loss/src -name '*.agda' | sed 's|.*/||; s|\.agda$||' | sort -u > $T
#     for root in .../Everything.agda ...; do sed -n 's/^import  *\([A-Za-z0-9_.]*\).*/\1/p' "$root"; done | sed 's|.*\.||' | sort -u > $R
#     for m in $(cat $R); do ... one more step ... done >> $R
#     comm -23 $T $R | wc -l
#
#   True value at the moment of the correction, full closure, no alphabet
#   named: 10 — every one of which typechecked at exit 0 individually and is
#   now wired.  Then 0.
# ─────────────────────────────────────────────────────────────────────────
#
# The computation now lives in Haskell, where the parse is a real parse and
# the closure is a real fixpoint:
#     machine/Samuccaya_TheAggregateRootIsGeneratedFromTheTreeSoNothingCanBeOmitted.hs
# That program also GENERATES an aggregate root from the tree, so this class
# of rot has a fix and not only a count.
#
# NOTE ON SCOPE: samuccaya walks BOTH trees — formal/cubical/ and
# loss/src/ — as separate closure questions, because they are
# separate Agda include paths with separate Everything.agda files.  The
# number printed here is their sum; run the program without --orphans to see
# the two apart, which is the form you want when the sum moves.
cd "$(dirname "$0")/.." || exit 2

if ! command -v runghc >/dev/null 2>&1; then
  # A missing tool is NOT a zero.  Printing 0 here would be the worst possible
  # failure for a gate whose whole job is to say "nothing checks these": it
  # would report perfect coverage because it could not look.
  echo "NA(runghc absent)"
  exit 0
fi

runghc machine/Samuccaya_TheAggregateRootIsGeneratedFromTheTreeSoNothingCanBeOmitted.hs --orphans 2>/dev/null | grep -c .
