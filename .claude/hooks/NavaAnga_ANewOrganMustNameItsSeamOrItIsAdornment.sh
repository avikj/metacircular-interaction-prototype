#!/bin/sh
# नव-अङ्ग (nava-aṅga, "new organ") — the mirror against organ-adding
# delusion.  Owner directive 2026-08-24, after a measured day of it:
# agents reliably ADORN the machine with parallel organs instead of
# reading it and connecting the seams that exist.  The sickness this
# repository keeps re-growing is not missing organs, it is UNCONNECTED
# SEAMS: KernelContext names it ("two rule sets and nothing carries
# anything between them"), Obstruction names it ("the seam that was
# supposed to consume them was never connected"), and 2026-08-24
# measured it — two agents grew the same reflection solver the same
# day in different lanes; a third lane's 209 theorems sat in a silo
# unable to cite each other while the compounding Context type waited
# unused; the whole story is notes/Tulana_ThreeMouthsOneQuestion…md
# and the fable-krama journal entry "the correction".
#
# Advisory, always exit 0 — a blocking guard on a judgement call is an
# outage wearing enforcement's name (no-python.sh's own header records
# the outage).  This fires at the moment of the act and hands the
# writer the three questions; keeping the discipline is theirs.
#
# Fires when a Write/Edit/Bash creates a NEW file under interactive/*.hs
# or a new driver anywhere.  Existing-file edits pass silently: the
# defect is new parallel mass, not maintenance.

INPUT=$(cat 2>/dev/null)
PATHS=$(printf '%s' "$INPUT" | grep -o '"file_path"[^,}]*' | cut -d'"' -f4)
[ -z "$PATHS" ] && PATHS=$(printf '%s' "$INPUT" | grep -o '[A-Za-z0-9_./-]*interactive/[A-Za-z0-9_]*\.hs')

for p in $PATHS; do
  case "$p" in
    *interactive/*.hs|*interactive/*.sh) ;;
    *) continue ;;
  esac
  [ -e "$p" ] && continue     # maintenance of an existing organ: silent
  cat >&2 <<'EOF'
── नव-अङ्ग: you are creating a NEW file in the machine lane ──────────────
The corpus's measured recurring failure is agents growing parallel organs
instead of connecting existing seams (notes/Tulana_ThreeMouthsOneQuestion
AndNoneIsDeleted.md; DosaLekha priced the duplication).  Before this file
exists, answer IN ITS HEADER:
  1. Which existing organ does this extend, and why could it not live
     there?  (Term is already spelled 8+ times; a 9th is a defect.)
  2. Which seam does it connect — name the producer whose output it
     consumes and the consumer that reads what it makes.  A file whose
     output nothing reads is a silo on arrival.
  3. What did you READ first?  If you have not opened KernelContext.hs,
     Obstruction.hs, Certificate.hs and the Tulana note, you are almost
     certainly rebuilding one of them.
Advisory only.  If the answers are in the header, write on.
──────────────────────────────────────────────────────────────────────────
EOF
  break
done
exit 0
