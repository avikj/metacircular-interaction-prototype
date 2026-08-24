#!/bin/sh
# साक्षिन् — the witness.
#
# ─────────────────────────────────────────────────────────────────────────
# WHAT THIS CHECKS.  Every Refused row of `notes/anuloma/NirnayaPanjika.tsv`
# must carry a non-empty obligation column (field 8) — the kernel output that
# says WHY.  A row with a class label and an empty witness is a verdict with
# nothing under it.
#
# WHY IT EXISTS, with the measurement that caused it.  On 2026-08-24 the
# ledger held 47 open rows, 36 of them classed `मम दोषः · module path`, and
# ALL 36 had an empty column 8.  The classifier in
# `machine/AnulomaPratiloma_…hs` read the witness by anchoring on a line
# containing `error:` and taking the four after it; agda's `Failed to find
# source of module X in any of the following locations:` carries no such
# line, so `dropWhile` consumed the output, the window was `[]`, and the one
# fact that identified the defect — WHICH module — was discarded 36 times.
# The class label survived and the evidence did not, which is how a fixed
# environment kept being reported as a code defect and 36 candidate pairs
# stayed invisible.
#
# THE RULE IS THE REPOSITORY'S OWN, TWICE OVER, and neither statement was
# being enforced on the ledger that reports them:
#   machine/Hetvabhasa_TheRefusalNamesItsDefectOrItIsNotARefusal.hs
#   formal/cubical/Nirnaya_TheVerdictCannotDropItsWitness.agda
# and `machine/Uttara_SamkramanaOrDosalekhaNeverABareBoolean.hs`: a
# doṣalekha carries naṣṭa item by item, because a count is the collapse
# again — `36 module path` without the modules is ∥·∥₁ of the defects.
#
# TERM.  साक्षिन् is used in its ordinary technical sense — the witness, one
# who was present and can say what happened.  NO TEXT IS CLAIMED FOR THIS
# APPLICATION and no author is credited with anything below; the discipline
# formalised here is `Nirnaya_…agda`'s, in this repository.
#
# MIRROR, NOT GATE.  Exits 0 always (CLAUDE.md: "fire at the moment of the
# act; do not block" — a blocking guard on a judgement call is an outage
# wearing enforcement's name).  It reports; it never refuses.
#
#   run:  sh scripts/Saksin_…sh
# ─────────────────────────────────────────────────────────────────────────

cd "$(dirname "$0")/.." || exit 0
LEDGER=notes/anuloma/NirnayaPanjika.tsv

if [ ! -f "$LEDGER" ]; then
  echo "साक्षिन्: no ledger at $LEDGER — nothing to check (this is not a pass)."
  exit 0
fi

OPEN=$(awk -F"\t" '!/^#/ && $5 == "Refused" {n++} END{print n+0}' "$LEDGER")
MUTE=$(awk -F"\t" '!/^#/ && $5 == "Refused" && $8 == "" {n++} END{print n+0}' "$LEDGER")

if [ "$MUTE" -eq 0 ]; then
  printf 'साक्षिन्: %s open row(s), every one carries its witness.\n' "$OPEN"
  exit 0
fi

printf 'साक्षिन्: %s of %s open row(s) carry an EMPTY witness column.\n' "$MUTE" "$OPEN"
printf '  A class label with no kernel output under it is not a refusal.\n\n'

awk -F"\t" '!/^#/ && $5 == "Refused" && $8 == "" {print "  " $6 "\t" $7}' "$LEDGER" \
  | sort | head -40

printf '\n  by class:\n'
awk -F"\t" '!/^#/ && $5 == "Refused" && $8 == "" {print $6}' "$LEDGER" \
  | sort | uniq -c | sort -rn | while read -r n cls; do
      printf '    %4s  %s\n' "$n" "$cls"
    done

printf '\n  These rows are repaired by RE-RUNNING the emitter, not by editing the\n'
printf '  ledger: it is keyed on content addresses and a row stands until one of\n'
printf '  them moves. `runghc -imachine machine/AnulomaPratiloma_…hs --check`\n'
printf '  with agda on PATH and a library file, then re-run scripts/Sadhya_…sh.\n'
exit 0
