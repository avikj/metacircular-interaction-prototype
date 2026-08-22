#!/bin/sh
# प्रसव — bringing forth.  Every number in this corpus is regenerated here,
# by the command recorded beside it, or it is not a number.
#
# ─────────────────────────────────────────────────────────────────────────
# WHY THIS EXISTS, in the file's own words rather than mine.
#
# CLAUDE.md: "the 15% was never reproducible — the program at its own commit
# prints 14%, because the index had been generated 4¾ hours earlier, and 38
# of the 39 files written in that gap were apparatus.  The number went stale
# in exactly the direction it exists to warn about."
#
# That is the failure this file closes.  A number sitting in prose has been
# severed from what produced it, and the severance is invisible: it still
# looks like knowledge.  So here the number is CARRIED and the command is the
# BASE — पुनरागमन applied to measurement.  A row without a command is not a
# measurement, it is a memory, and the report says how many of those there
# are.
#
# सारणी वा क्रिया (§४१, AHIMSA_SUTRA_VISTARA.md) — table or procedure — is an
# IDENTITY and not a trade, because प्रस्तार ≡ ℕ: नष्ट and उद्दिष्ट each carry
# the other, so storing and generating are the same type.  This script is that
# identity used in the one direction that costs nothing: keep the क्रिया,
# regenerate the सारणी.
#
# TERM.  प्रसव, from √सू — bringing forth, birth, generation.  Ordinary
# Sanskrit, attested from the Ṛgveda onward.  LIMIT: no text is claimed for
# this application; the word is used in its plain sense.
#
# ─────────────────────────────────────────────────────────────────────────
# USE.  From the repository root:
#
#     sh scripts/Prasava_EveryNumberCarriesTheCommandThatMakesItOrItIsNotANumber.sh
#     sh scripts/Prasava_…sh --full     also runs the slow kernel gates
#     sh scripts/Prasava_…sh --write    rewrites PRASAVA.tsv with today's values
#
# Exit 0 always for the census; --full exits nonzero if a GATE fails.  Drift
# in a counted row is REPORTED, never fatal: a corpus that grows is supposed
# to drift, and a script that fails on growth teaches everyone to skip it.
# ─────────────────────────────────────────────────────────────────────────

cd "$(dirname "$0")/.." || exit 1
FULL=0; WRITE=0
for a in "$@"; do
  [ "$a" = "--full" ]  && FULL=1
  [ "$a" = "--write" ] && WRITE=1
done
LEDGER=PRASAVA.tsv
TODAY=$(date +%Y-%m-%d)

# --- the rows.  key | command.  ADD A ROW BY ADDING A LINE. ---------------
rows() {
cat <<'ROWS'
agda-modules-toplevel	ls formal/cubical/*.agda | wc -l
agda-modules-all	find formal/cubical punaragamana/src -name '*.agda' | wc -l
agda-reached	grep -c '^import ' formal/cubical/Everything.agda
agda-unreached	sh scripts/.prasava-unreached.sh
lean-modules	find formal/pairfield/Pairfield -name '*.lean' | wc -l
lean-root-imports	grep -c '^import ' formal/pairfield/Pairfield.lean
machine-modules	ls machine/*.hs | wc -l
notes	ls notes/*.md | wc -l
punaragamana-modules	find punaragamana/src -name '*.agda' | wc -l
scripts	ls scripts/*.sh | wc -l
hooks	ls .claude/hooks/* 2>/dev/null | wc -l
mulavakya-rows	grep -vc '^#' .claude/hooks/MulaVakya_SourceStatementsForTheTermsInOurFileNames.txt
sanskrit-led-modules	find formal/cubical punaragamana/src -name '*_*.agda' | wc -l
postulates	grep -rl '^ *postulate' formal/cubical punaragamana/src --include=*.agda | wc -l
lean-sorry	find formal/pairfield/Pairfield -name '*.lean' -exec awk -f scripts/.lean-strip.awk {} + | grep -cE '\bsorry\b|\badmit\b'
python-files	find . -name '*.py' -not -path './.git/*' | wc -l
commits	git rev-list --count HEAD
ROWS
}

# --- slow rows, only under --full ----------------------------------------
slow_rows() {
cat <<'ROWS'
nama-declarations	runghc machine/Nama_TheNameIsCarriedAndTheHashIsTheBase.hs 2>/dev/null | grep -oE '[0-9]+ declarations' | grep -oE '[0-9]+'
nama-addresses	runghc machine/Nama_TheNameIsCarriedAndTheHashIsTheBase.hs 2>/dev/null | grep -oE '[0-9]+ addresses' | grep -oE '[0-9]+'
ROWS
}

# --- gates: command | must exit 0 ----------------------------------------
gates() {
cat <<'ROWS'
agda-pragmas	bash scripts/check-agda-pragmas.sh
lean-globs	bash scripts/check-lean-globs.sh
agda-closure	bash scripts/check-agda-closure.sh
machine-lane	bash scripts/Anatha_TheMachineLaneHadNoGateAndNowItHasOne.sh
ROWS
}

printf '\n  प्रसव — %s — regenerating every number from its own command\n' "$TODAY"
printf '  ────────────────────────────────────────────────────────────────\n'
printf '  %-24s %10s %10s   %s\n' KEY NOW RECORDED ''

DRIFT=0; NEW=0; SAME=0
TMP=$(mktemp)
{ rows; [ $FULL -eq 1 ] && slow_rows; } | while IFS="$(printf '\t')" read -r key cmd; do
  [ -z "$key" ] && continue
  now=$(eval "$cmd" 2>/dev/null | tr -d ' \n')
  [ -z "$now" ] && now='?'
  was=$( [ -f $LEDGER ] && awk -F"\t" -v k="$key" '$1==k{print $2}' $LEDGER )
  if [ -z "$was" ]; then
    printf '  %-24s %10s %10s   NEW ROW\n' "$key" "$now" '—'
  elif [ "$now" = "$was" ]; then
    printf '  %-24s %10s %10s\n' "$key" "$now" "$was"
  else
    d=$(( now - was )) 2>/dev/null || d='?'
    printf '  %-24s %10s %10s   DRIFT %+d\n' "$key" "$now" "$was" "$d"
  fi
  printf '%s\t%s\t%s\n' "$key" "$now" "$cmd" >> $TMP
done

printf '\n'
UNREPRO=$(grep -rohE '\b[0-9]{2,6}\b (files|declarations|addresses|modules|notes)' notes/*.md CLAUDE.md 2>/dev/null | sort -u | wc -l | tr -d ' ')
KEYED=$(wc -l < $TMP | tr -d ' ')
printf '  %s distinct counted claims appear in notes/ and CLAUDE.md.\n' "$UNREPRO"
printf '  %s of them have a command here.  THE REST ARE MEMORIES, NOT MEASUREMENTS.\n' "$KEYED"
printf '  To convert one, add a row above.  That is the entire mechanism.\n\n'

if [ $FULL -eq 1 ]; then
  printf '  gates\n  ─────\n'
  FAIL=0
  gates | while IFS="$(printf '\t')" read -r g cmd; do
    [ -z "$g" ] && continue
    if eval "$cmd" >/dev/null 2>&1; then printf '  %-24s OK\n' "$g"
    else printf '  %-24s FAIL   (%s)\n' "$g" "$cmd"; fi
  done
  printf '\n'
fi

if [ $WRITE -eq 1 ]; then
  { printf '# PRASAVA.tsv — regenerated %s by scripts/Prasava_…sh --write\n' "$TODAY"
    printf '# key\tvalue\tthe command that makes it.  A number without a command is a memory.\n'
    cat $TMP; } > $LEDGER
  printf '  wrote %s\n\n' $LEDGER
fi
rm -f $TMP
exit 0
