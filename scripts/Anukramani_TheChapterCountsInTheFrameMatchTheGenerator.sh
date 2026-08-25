#!/bin/sh
# अनुक्रमणी — the frame's chapter counts against the generator's.
#
# ─────────────────────────────────────────────────────────────────────────
# WHY.  `BOOK_INDEX.md` says "Do not hand-edit: it is recomputed from the
# filesystem, so a chapter cannot silently lose an entry."  `BOOK.md` §4
# carries the SAME counts by hand, and nothing compared them.  Measured
# 2026-08-24: all thirteen were stale, in both directions — ch 2 said 23
# against 46, ch 5 said 11 against 73, and ch 12 said 2 against 1.
#
# That is not bookkeeping.  BOOK.md §4 is where "the frontier is the thin
# rows" is read off, so stale counts MISNAME THE FRONTIER: the file still
# sent readers to chapter 10 as the sharpest thin row after chapter 10 had
# tripled and chapters 1, 11 and 12 had become the thin ones.  A stale
# number here does not merely misreport, it misdirects the work.
#
# MIRROR, NOT GATE.  Exit 0 always (CLAUDE.md: "fire at the moment of the
# act; do not block").  It reports; it never refuses.
#
# LIMIT.  This compares COUNTS ONLY.  It cannot tell whether a chapter's
# entries belong in it, and `machine/Anukramani.hs` matches by filename
# substring, so both sides inherit that lower bound together.  Agreement
# here is agreement between two views of one weak instrument, not evidence
# that a chapter is well populated.
#
#   run:  sh scripts/Anukramani_…sh
#   fix:  runghc -imachine machine/AnukramaniRun.hs > BOOK_INDEX.md
#         then correct BOOK.md §4 by hand from it
# ─────────────────────────────────────────────────────────────────────────

cd "$(dirname "$0")/.." || exit 0
[ -f BOOK_INDEX.md ] && [ -f BOOK.md ] || {
  echo "अनुक्रमणी: BOOK.md or BOOK_INDEX.md missing — nothing compared (not a pass)."
  exit 0
}

# generator: entries per chapter, from the index it forbids hand-editing
awk '/^## [0-9]+\./{ if(ch!="") print ch" "n; ch=$2; n=0; next }
     /^  - `/{n++}
     END{ if(ch!="") print ch" "n }' BOOK_INDEX.md \
  | tr -d '.' > /tmp/.anukramani-gen.$$

# frame: the last cell of each numbered row of BOOK.md §4's table
awk -F'|' '/^\| [0-9]+ \|/{
    ch=$2; gsub(/[^0-9]/,"",ch)
    n=$(NF-1); gsub(/[^0-9]/,"",n)
    if (ch != "" && n != "") print ch" "n }' BOOK.md > /tmp/.anukramani-frame.$$

DIFF=0
while read -r ch n; do
  f=$(awk -v c="$ch" '$1==c{print $2}' /tmp/.anukramani-frame.$$)
  if [ -z "$f" ]; then
    printf '  ch %-3s generator %-4s frame: NO ROW\n' "$ch" "$n"; DIFF=$((DIFF+1))
  elif [ "$f" != "$n" ]; then
    printf '  ch %-3s generator %-4s frame %-4s  ✗\n' "$ch" "$n" "$f"; DIFF=$((DIFF+1))
  fi
done < /tmp/.anukramani-gen.$$

TOTAL=$(awk '{s+=$2} END{print s+0}' /tmp/.anukramani-gen.$$)
CLAIMED=$(awk '/reaching a chapter[[:space:]]*:/{print $NF; exit}' BOOK_INDEX.md)
rm -f /tmp/.anukramani-gen.$$ /tmp/.anukramani-frame.$$

if [ -n "$CLAIMED" ] && [ "$TOTAL" != "$CLAIMED" ]; then
  printf '  per-chapter entries sum to %s; the index reports "reaching a chapter : %s"  ✗\n' \
    "$TOTAL" "$CLAIMED"
  DIFF=$((DIFF+1))
fi

if [ "$DIFF" -eq 0 ]; then
  printf 'अनुक्रमणी: BOOK.md §4 agrees with the generator on every chapter (%s entries).\n' "$TOTAL"
else
  printf '\nअनुक्रमणी: %s divergence(s). BOOK.md §4 is where "the frontier is the thin\n' "$DIFF"
  printf '  rows" is read; a stale count there misnames the frontier, it does not\n'
  printf '  merely misreport it. The generator is authoritative:\n'
  printf '    runghc -imachine machine/AnukramaniRun.hs > BOOK_INDEX.md\n'
fi
exit 0
