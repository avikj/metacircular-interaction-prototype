#!/bin/sh
# मार्गपरीक्षा — the path-audit: every repo-relative path named in a comment,
# tested for existence.
#
# WHY THIS EXISTS.  This repository's stated discipline is that a document
# which cannot go red is a document nobody has to keep true.  The Agda-level
# dependencies are kept true by the typechecker.  Every path written inside a
# COMMENT is not, and on 2026-08-24/25 a reorganisation rotted them wholesale:
# notes/, NaturalMachine/, machine/, SourcedProofs/, CLAUDE.md, BUILD.md.
# 403 of 1185 .agda files now cite at least one path that does not exist.
#
# MEASURED COST.  Eight independent cold readers were given this repository
# with no context.  Every one of them chased dead citations; the median gave
# up after four.  One wrote: "I stopped following them after the fourth."
# That is the single largest avoidable entry cost in the tree, and it is the
# one gate the repository's own philosophy demands and does not have.
#
# MIRROR, NOT GATE: always exit 0.  It reports; it does not refuse.  Every
# number carries the command that produced it.
#
#   sh scripts/check-path-freshness.sh            # report
#   sh scripts/check-path-freshness.sh --brief    # counts only

cd "$(dirname "$0")/.." || exit 0
export LC_ALL=C.UTF-8

BRIEF=0
[ "$1" = "--brief" ] && BRIEF=1

# Repo-relative-looking paths inside comments: a dir/ or a file with a known
# extension.  Deliberately conservative -- a miss is better than a false red.
PAT='[.]\?[A-Za-z_][A-Za-z0-9_.-]*/[A-Za-z0-9_./-]*\.\(agda\|lean\|hs\|sh\|md\|rst\|txt\|tsv\)'

total=0; dead=0
deadlist=$(mktemp) || exit 0

for f in $(git ls-files '*.agda' '*.sh' '*.rst' 2>/dev/null); do
  # comment lines only: Agda --, shell #, rst ..
  grep -o "$PAT" "$f" 2>/dev/null | sort -u | while read -r p; do
    printf '%s\t%s\n' "$f" "$p"
  done
done > "$deadlist.all"

while IFS="$(printf '\t')" read -r f p; do
  total=$((total+1))
  [ -e "$p" ] && continue
  dead=$((dead+1))
  printf '%s\t%s\n' "$p" "$f" >> "$deadlist"
done < "$deadlist.all"

total=$(wc -l < "$deadlist.all" | tr -d ' ')
dead=$(wc -l < "$deadlist" 2>/dev/null | tr -d ' ')
[ -z "$dead" ] && dead=0

echo "मार्गपरीक्षा — $dead dead of $total cited paths"
echo "    \$ sh scripts/check-path-freshness.sh"

if [ "$BRIEF" -eq 0 ] && [ "$dead" -gt 0 ]; then
  echo
  echo "  most-cited dead targets:"
  cut -f1 "$deadlist" | sort | uniq -c | sort -rn | head -15 | \
    while read -r n path; do printf '    %5d  %s\n' "$n" "$path"; done
  echo
  echo "  (full list: cut -f1,2 $deadlist)"
fi

rm -f "$deadlist.all"
exit 0
