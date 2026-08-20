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

if [ -f .correction_reach_fail ]; then
  rm -f .correction_reach_fail
  status=1
fi
exit $status
