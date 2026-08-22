#!/usr/bin/env bash
# शेषः — Śeṣa — the census of non-computing pattern matches in
# formal/cubical/, as a ratchet.
#
# (*Śeṣa* is the remainder: what the kuṭṭaka keeps and recurses on rather
# than discards — Āryabhaṭa, *Āryabhaṭīya*, gaṇitapāda 32–33, 499 CE; and
# the fourth position of the saptabhaṅgī, *avaktavya*, is where
# `notes/AHIMSA_SUTRA_VISTARA.md` §३ puts it: अवक्तव्ये शेषो वसति — the
# remainder dwells in the inexpressible, and it is a गर्भ, a womb, not a
# failure.  The word is the corpus's; no claim is made that anyone in
# 499 wrote a shell script.)
#
# ─────────────────────────────────────────────────────────────────────
# WHY THIS EXISTS
#
# `scripts/check-agda-pragmas.sh` guarantees every module ASSERTS
# `--safe`.  `scripts/check-agda-closure.sh` guarantees every module is
# REACHED by an aggregate root.  `scripts/Pariksa_UnivalentAudit.sh`
# counts collapses.  None of them sees the aggregate's OTHER remainder:
# the clauses that typecheck, are `--safe`, have no postulates and no
# holes, and STILL do not compute.
#
# Agda's own words for it:
#
#   "This clause uses pattern-matching features that are not yet
#    supported by Cubical Agda, the function to which it belongs will
#    not compute when applied to transports.
#    Reason: It relies on injectivity of the data constructor …"
#
# The match required constructor injectivity on an INDEX, so Cubical
# Agda could not build a case tree carrying a `transp` computation rule.
# The function still reduces on ordinary closed terms — every `refl`
# proof of a concrete instance is untouched — but `transp` does not
# reduce through it.  So the cost is exactly: any proof that needs the
# function to compute UNDER A TRANSPORT must state the path instead.
#
# That is AHIMSA_SUTRA_VISTARA §६'s two roads with one of them closed.
# संक्रमणम् — transport — is the road on which nothing is lost.  Where a
# clause cannot compute under transport, that road is shut at that site,
# and §६'s only other road applies: यत्र संक्रमणं न सम्भवति तत्र दोषो लिख्यते —
# where transport is not possible, the remainder is WRITTEN.  लिखितो दोषो
# जीवति । अलिखितो दोषो हिंसा — written, it lives; unwritten, it is harm.
# There is no third road.  This script is the mechanism that makes the
# writing happen at the moment of the act, on the CLAUDE.md precedent:
# "enforced mechanically because prose failed."
#
# ─────────────────────────────────────────────────────────────────────
# READ THIS BEFORE QUOTING A NUMBER.  Two ways to get it wrong, both of
# which have already happened in this repository.
#
# 1.  **AGDA PRINTS EVERY WARNING TWICE.**  Once as it checks the
#     module, and again in the block after
#     `———— All done; warnings encountered ————`.  So
#
#         agda Everything.agda 2>&1 | grep -c UnsupportedIndexedMatch
#
#     reports 214 where the corpus has 107 sites, and the figure "214"
#     has circulated as if it were a site count.  It is not.  Verified
#     2026-08-20: 107 before the separator, 107 after, byte-identical.
#     THIS SCRIPT DEDUPLICATES.  A raw `grep -c` is always 2×.
#
# 2.  **THE FIGURE DEPENDS ON WHICH ROOT YOU CHECK.**  On the same tree
#     on the same day, `agda Everything.agda` gives 107 sites and
#     `agda NaturalMachine.agda` gives 100 — NaturalMachine's closure
#     does not reach `PMNoSection.agda` (4 sites) and three others.
#     Neither number is wrong; a number quoted without its root is.
#     This script fixes the root at `Everything`, the wider of the two,
#     and prints it.
#
#     The same lesson the BUILD.md closure paragraph learned four times:
#     quote the gate's exit code, not the table.  Here: quote the root
#     and the dedup, not the grep.
#
# ─────────────────────────────────────────────────────────────────────
# WHAT IT MEASURES
#
#   One row per module, counting DISTINCT (source range, reason) pairs.
#   A single clause range can raise two rows when the match inverts two
#   different constructors (`suc` and `zero` both, typically) — those
#   are two separate obligations and are counted separately.
#
#   The number may FALL freely.  Raising it means editing the baseline,
#   and editing the baseline means writing, for that module, WHAT no
#   longer computes and WHAT THAT COSTS — which is the whole point.
#
# WHAT IT DOES NOT MEASURE, said plainly so nobody quotes it for more
# than it is:
#
#   * It does not say the cost is nonzero.  A site is a site; whether it
#     is LOAD-BEARING is the question of whether anything ever transports
#     through that function, and that is a reading obligation, recorded
#     in the baseline's reason column per module and in the modules'
#     own headers.  No grep can decide it.  Stated here so that
#     `unmechanisable` is not mistaken for `unenforced` (CLAUDE.md,
#     "Regressions observed in one long session").
#
#   * It says nothing about the LIBRARY.  `cubical-0.9`'s own
#     `cubical.agda-lib` carries `-WnoUnsupportedIndexedMatch`, so
#     upstream suppresses this warning for its own modules.  This lane's
#     `formal/cubical/natural-machine.agda-lib` does NOT, deliberately:
#     every site counted here is OURS, and it stays visible.  Turning the
#     flag on would take this number to 0 and destroy the census.  Do
#     not do it; that is सङ्क्षेप, not repair.
#
#   * It is not a build gate.  It runs the pinned Agda because nothing
#     textual can know which clause the case-tree compiler rejected, but
#     its verdict is about the census, not about green.  Green is
#     `formal/check.sh` and the pin in `formal/cubical/BUILD.md`.
#
# Usage:
#   scripts/Sesa_IndexedMatchCensus.sh              # ratchet (runs Agda)
#   scripts/Sesa_IndexedMatchCensus.sh --list       # ratchet + every site
#   scripts/Sesa_IndexedMatchCensus.sh --update     # rewrite the baseline
#   scripts/Sesa_IndexedMatchCensus.sh --from LOG   # parse a saved Agda log
#                                                   # instead of re-running
set -uo pipefail

cd "$(dirname "$0")/.."
BASELINE="scripts/sesa-indexedmatch-baseline.tsv"
LANE="formal/cubical"
ROOT="Everything"

mode="${1:-}"
LOG=""
if [ "$mode" = "--from" ]; then LOG="${2:-}"; mode="${3:-}"
  [ -f "$LOG" ] || { echo "FAIL: no such log: $LOG"; exit 1; }
fi

if [ -z "$LOG" ]; then
  LOG=$(mktemp -t sesa-agda-log)
  trap 'rm -f "$LOG"' EXIT
  ( cd "$LANE" && LC_ALL=C.UTF-8 agda "$ROOT.agda" ) > "$LOG" 2>&1
  rc=$?
  if [ "$rc" -ne 0 ]; then
    echo "FAIL: agda $ROOT.agda exited $rc — the census is only meaningful"
    echo "      on a green aggregate.  Fix the red first."
    sed -n '1,40p' "$LOG"
    exit 1
  fi
fi

# Parse: one line per warning block, "file<TAB>range<TAB>reason<TAB>def".
# Dedup by (file, range, reason) — see "AGDA PRINTS EVERY WARNING TWICE".
sites=$(awk '
  function flush(){ if(loc!=""){ gsub(/  +/," ",reason); gsub(/^ +| +$/,"",reason);
                                 print loc "\t" reason "\t" def } loc="";reason="";def="";mode="" }
  /warning: -W\[no\]UnsupportedIndexedMatch/ { flush(); split($0,a,": warning"); loc=a[1]; next }
  /^Reason:/ { r=$0; sub(/^Reason: */,"",r); reason=r; mode="reason"; next }
  mode=="reason" && /^ +[^ ]/ { reason=reason " " $0; next }
  /^when checking the definition of / { d=$0; sub(/^when checking the definition of /,"",d); def=d; mode=""; next }
  END{ flush() }
' "$LOG" \
  | sed 's|.*/formal/cubical/||' \
  | sed 's/, which is not yet supported//' \
  | sed 's/It relies on injectivity of the data constructor //' \
  | awk -F'\t' '{split($1,a,":"); print a[1] "\t" a[2] "\t" $2 "\t" $3}' \
  | sort -u)

total=$(printf '%s' "$sites" | grep -c . || true)
raw=$(grep -c 'UnsupportedIndexedMatch' "$LOG" || true)
mods=$(printf '%s\n' "$sites" | awk -F'\t' 'NF{print $1}' | sort -u)
nmods=$(printf '%s' "$mods" | grep -c . || true)

if [ "$mode" = "--list" ]; then
  echo "── every site (module, range, inverted constructor, definition) ──"
  printf '%s\n' "$sites" | sort -t'	' -k1,1 -k2,2V | column -t -s'	'
  echo
fi

echo "root              : $ROOT.agda (exit 0)"
echo "raw grep -c       : $raw   ← 2× the truth; Agda prints each warning twice"
echo "distinct sites    : $total"
echo "modules affected  : $nmods"
echo

per_module=$(printf '%s\n' "$sites" | awk -F'\t' 'NF{print $1}' | sort | uniq -c \
             | awk '{print $2"\t"$1}' | sort -t'	' -k2,2nr -k1,1)
printf '%s\n' "$per_module" | while IFS=$'\t' read -r m n; do
  printf '  %-88s %s\n' "$m" "$n"
done

if [ "$mode" = "--update" ]; then
  {
    echo "# Baseline for scripts/Sesa_IndexedMatchCensus.sh."
    echo "#"
    echo "# One row per module. The count is DISTINCT (source range, reason)"
    echo "# pairs of UnsupportedIndexedMatch under \`agda Everything.agda\`."
    echo "# A raw \`grep -c\` gives twice this; see the script header."
    echo "#"
    echo "# Each number may FALL freely. Raising one requires editing this"
    echo "# file, and editing this file is where the ŚEṢA gets written:"
    echo "# say WHAT no longer computes under transport, and WHETHER"
    echo "# anything in the corpus actually transports through it."
    echo "# A latched number with a stale reason is a rubber stamp."
    echo "#"
    echo "# module<TAB>count<TAB>what does not compute, and what that costs"
    printf '%s\n' "$per_module" | while IFS=$'\t' read -r m n; do
      old=$(awk -F'\t' -v m="$m" '$1==m {print $3}' "$BASELINE" 2>/dev/null)
      [ -z "$old" ] && old="REASON NOT YET WRITTEN — say what does not compute and what it costs."
      printf '%s\t%s\t%s\n' "$m" "$n" "$old"
    done
    printf 'TOTAL\t%s\tsum of the rows above; the figure to quote, with the root named.\n' "$total"
  } > "$BASELINE.tmp" && mv "$BASELINE.tmp" "$BASELINE"
  echo
  echo "baseline written: $BASELINE"
  echo "NOW WRITE THE REASONS. A row whose reason is unwritten is not a census."
  exit 0
fi

if [ ! -f "$BASELINE" ]; then
  echo "FAIL: no baseline at $BASELINE — run with --update once, write the"
  echo "      reasons, and commit it."
  exit 1
fi

status=0
# A rise in any module, or a module that has no baseline row at all, fails.
printf '%s\n' "$per_module" | while IFS=$'\t' read -r m n; do
  want=$(awk -F'\t' -v m="$m" '$1==m {print $2}' "$BASELINE")
  if [ -z "$want" ]; then
    echo "FAIL: $m has $n site(s) and NO baseline row."
    echo "      A new module started shipping non-computing matches."
    exit 1
  fi
  if [ "$n" -gt "$want" ]; then
    echo "FAIL: $m rose $want → $n."
    echo "      Clauses were added that do not compute under transport,"
    echo "      with nothing written about what that costs."
    exit 1
  fi
  if [ "$n" -lt "$want" ]; then
    echo "note: $m FELL $want → $n — run --update to latch it, and REWRITE"
    echo "      the reason; a latched number with a stale reason is a rubber stamp."
  fi
done || status=1

want_total=$(awk -F'\t' '$1=="TOTAL" {print $2}' "$BASELINE")
if [ -n "$want_total" ] && [ "$total" -gt "$want_total" ]; then
  echo "FAIL: TOTAL rose $want_total → $total."
  status=1
fi

# Every baselined module must still exist and still be reachable, or the
# baseline is describing a tree that is gone.
awk -F'\t' '$1!="TOTAL" && $1 !~ /^#/ && NF {print $1}' "$BASELINE" | while read -r m; do
  [ -f "$LANE/$m" ] || { echo "FAIL: baseline names $m, which is not on disk."; exit 1; }
done || status=1

# The suppression flag must NOT be in this lane's library file: it would
# silently take every number here to zero.
if grep -q 'noUnsupportedIndexedMatch' "$LANE/natural-machine.agda-lib" 2>/dev/null; then
  echo "FAIL: $LANE/natural-machine.agda-lib suppresses UnsupportedIndexedMatch."
  echo "      That does not repair a site; it deletes the census. Remove the flag."
  status=1
fi

if [ "$status" -eq 0 ]; then
  echo
  echo "OK: no new non-computing match, and the census is still visible."
fi
exit "$status"
