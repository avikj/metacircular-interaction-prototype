#!/bin/sh
# check-correction-reach.sh — a correction that names a target file must be
# reachable FROM that file.
#
# Motivation (notes/CORRECTION_REACH_AUDIT.md, 2026-08-15): "correct by
# addition" is not position-neutral. Three corrections in this corpus were
# written in note A as "Correction to `B.md`" and never appeared in B, so every
# reader of B — including the ones who only read B's summary — got the
# uncorrected claim.
#
# Rule, deliberately weak so it cannot false-positive on judgement calls:
# if notes/A.md contains "correction to `B.md`" (case-insensitive) then B.md
# must mention the string "A.md" somewhere. It does NOT check placement,
# wording, or whether the correction is right. Failing this check means the
# correction is unreachable from the corrected file, which is decidable.
#
# Exit 0 = clean, 1 = unreached corrections found.

set -u
root=$(git rev-parse --show-toplevel 2>/dev/null || echo .)
cd "$root" || exit 0
status=0

for src in notes/*.md collab/journals/*.md; do
  [ -f "$src" ] || continue
  srcbase=${src##*/}
  # Extract every "correction to `X.md`" target on one line each.
  grep -ohiE "correction to \`?[A-Za-z0-9_./-]+\.md\`?" "$src" 2>/dev/null |
  sed -e 's/.*[Tt][Oo] //' -e 's/`//g' |
  while read -r tgt; do
    [ -n "$tgt" ] || continue
    tgtbase=${tgt##*/}
    [ "$tgtbase" = "$srcbase" ] && continue          # self-correction: in place
    path=""
    for cand in "$tgt" "notes/$tgtbase" "collab/journals/$tgtbase"; do
      [ -f "$cand" ] && { path=$cand; break; }
    done
    [ -n "$path" ] || continue                       # target absent: not our check
    if grep -qF "$srcbase" "$path"; then
      :
    else
      echo "UNREACHED: $src corrects $path, but $path never names $srcbase"
      echo "$path" >> .correction_reach_fail
    fi
  done
done

# ---------------------------------------------------------------------
# INTRA-FILE POINTERS.  Added 2026-08-20 after a 75-line loss the check
# above could not see.
#
# 53a5ed41 struck a claim in notes/BRAHMASPHUTASIDDHANTA_IN_ITS_OWN_ORDER.md
# and wrote, inside the strike, `see "Correction to §IV, appended
# 2026-08-19" below` -- and deleted that section in the same commit, along
# with §V Transmission and the whole provenance section.  The pointer
# pointed at nothing for a day and a half.
#
# The check above cannot catch it by construction: it verifies that a
# correction naming file B is reachable FROM B, so when the correction and
# the corrected text are the same file it has a blind spot exactly one
# document wide.
#
# Rule, deliberately weak so it cannot false-positive: if a file contains
# see "TITLE" below   (or above)
# then a heading whose text contains TITLE must exist in that same file.
# It does not check placement or ordering, only existence, which is
# decidable.
# ---------------------------------------------------------------------
for src in notes/*.md collab/journals/*.md *.md; do
  [ -f "$src" ] || continue
  grep -ohE 'see "[^"]{4,}" (below|above)' "$src" 2>/dev/null |
  sed -e 's/^see "//' -e 's/" \(below\|above\)$//' |
  while read -r title; do
    [ -n "$title" ] || continue
    if grep -qF "$title" "$src"; then
      # the quoted title appears somewhere; require it as a HEADING
      if grep -qE "^#{1,6} .*$(printf '%s' "$title" | sed 's/[][\.*^$/]/\\&/g')" "$src"; then
        :
      else
        echo "DANGLING: $src points at \"$title\" but no heading in that file matches"
        echo "$src" >> .correction_reach_fail
      fi
    else
      echo "DANGLING: $src points at \"$title\" and that text is absent from the file"
      echo "$src" >> .correction_reach_fail
    fi
  done
done

if [ -f .correction_reach_fail ]; then
  rm -f .correction_reach_fail
  status=1
fi
exit $status
