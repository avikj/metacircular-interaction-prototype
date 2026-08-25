#!/usr/bin/env bash
# चक्रम् — the wheel.  The loop that was running through a mind, closed so it
# runs through the machine: frontier → template → kernel → landing → commit,
# turning until a pass lands nothing (DRY), then one heartbeat to show the
# body moved.  Built 2026-08-23 at the owner's direction ("close all loops,
# full-auto") after the owner's question exposed the gap: every organ
# existed and a mind was hand-carrying reports between them.
#
# WHAT TURNS, per revolution:
#   1  scripts/Tapas_…sh    the one-pass chain (Lopa queue → Upalabdhi
#                           annotations → Tapas match/emit → kernel check →
#                           land).  Its own safety rules are inherited
#                           whole: only kernel exit 0 lands, nothing is
#                           overwritten, every non-match is a written
#                           refusal.
#   2  git commit           what landed, committed with the pass counts —
#                           the ONE act the pass script deliberately
#                           refuses, supplied here because the owner asked
#                           for full-auto explicitly.
#   3  again, until a revolution lands zero modules.  DRY is the fixpoint:
#      the template library's reach is exhausted, and what remains is the
#      refusal ledger — the exact frontier that needs a MIND (a new
#      template, a new reading), which is where minds belong.
# Then machine/Jiva_…hs runs once: the heartbeat's priced count is the
# wheel's receipt, diffable against the pre-wheel beat in aisthesis.jsonl.
#
# WHAT THIS DOES NOT DO.  No push (the caller decides where the stream
# goes); no aggregate wiring on a skewed carrier (CHAKRA_SKIP_AGGREGATE=1
# is set when Everything.agda is red for pre-existing pin reasons — the
# imports are owed to the pinned container, stated in each commit); no
# editing of any organ — this file only turns them.
#
#   sh scripts/Chakra_…sh [max-revolutions]        default 4

set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"; cd "$ROOT" || exit 2
export LC_ALL=C.utf8
MAX="${1:-4}"
SCRATCH="${TMPDIR:-/tmp}/tapas"
say() { printf '%s\n' "$*"; }

# The aggregate gate is usable only where Everything.agda was green before
# the wheel started; probe cheaply by carrier: the v0.5 container is the
# known-skewed seat (BUILD.md catalogue), so skip there.
AGDA_VER="$(agda --version 2>/dev/null | head -1)"
case "$AGDA_VER" in
  *2.6.3*) export CHAKRA_SKIP_AGGREGATE=1
           say "carrier $AGDA_VER: aggregate gate skipped (pre-existing pin skew); imports owed" ;;
  *)       export CHAKRA_SKIP_AGGREGATE=0 ;;
esac

rev=0
while [ "$rev" -lt "$MAX" ]; do
  rev=$((rev+1))
  say ""
  say "════ चक्र revolution $rev of at most $MAX ════"
  bash scripts/Tapas_TheLoopThatMintsReceiptsForUnpricedFibres.sh || {
    say "the pass failed; the wheel stops rather than spins on a broken organ"; exit 1; }
  if [ -s "$SCRATCH/landed.this-pass" ] || git status --porcelain formal/cubical/Tapas 2>/dev/null | grep -q .; then
    landed_n="$(git status --porcelain formal/cubical/Tapas | grep -c '^??\|^ M' || true)"
    landed_names="$( [ -s "$SCRATCH/landed.this-pass" ] && tr '\n' ' ' < "$SCRATCH/landed.this-pass" || echo '(see git status)')"
    rm -f "$SCRATCH/landed.this-pass"
    git add formal/cubical/Tapas machine/aisthesis.jsonl formal/cubical/Everything.agda 2>/dev/null
    git commit -m "चक्र revolution $rev — तपस् minted and the kernel accepted: $landed_names($landed_n module(s) landed, each agda exit 0 standing where it lives; aggregate wiring $( [ "${CHAKRA_SKIP_AGGREGATE}" = "1" ] && echo 'owed to the pinned container' || echo 'checked' ); refusal ledger in the pass log)" >/dev/null \
      && say "committed revolution $rev ($landed_n module(s))"
  else
    say ""
    say "DRY at revolution $rev: the template library's reach is exhausted."
    say "What remains is the refusal ledger — the frontier that needs a mind:"
    grep '^REFUSED' "$SCRATCH/ledger.tsv" 2>/dev/null | cut -f4 | sort | uniq -c | sort -rn | head -6 | sed 's/^/  /'
    break
  fi
done

# the receipt: one heartbeat, diffable against the pre-wheel beat
say ""
say "── the body, after ──"
runghc --ghc-arg=-imachine machine/Jiva_TheMachineComputesItsOwnMetric.hs 2>/dev/null \
  | grep -E "priced|unpriced|JIVA-HEARTBEAT" | head -4
if ! git diff --quiet machine/aisthesis.jsonl 2>/dev/null; then
  git add machine/aisthesis.jsonl
  git commit -m "aisthesis.jsonl: the wheel's closing heartbeat" >/dev/null && say "heartbeat committed"
fi
say "चक्र complete after $rev revolution(s).  Push is the caller's act."
