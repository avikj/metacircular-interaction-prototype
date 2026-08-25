#!/usr/bin/env bash
# रात्रिः — the overnight run.
#
# WHAT THIS IS.  One loop that (a) verifies every lane, (b) puts the
# punarāgamana question to the kernel across the whole corpus, and (c) writes
# what it found into a dated log that is APPENDED and never rewritten.  It is
# meant to be started and left.
#
# WHY IT IS SHAPED LIKE THIS.  §१५ करणक्षयः: वाहकः म्रियते, वाच्यं न म्रियेत —
# the carrier dies and the carried must not.  This script's carrier is a
# terminal session that will be closed.  So: every number is recomputed from
# the filesystem on each pass (nothing stored can go stale), every pass appends
# rather than overwrites (§६: लिखितो दोषो जीवति), and the loop is resumable from
# any point because it holds no state of its own.
#
#   sh scripts/Ratri_TheOvernightRunThatCensusesAndGatesAndNeverOverwrites.sh
#   sh scripts/Ratri_…sh --once          one pass, then exit
#   sh scripts/Ratri_…sh --interval 1800 seconds between passes (default 1800)
#   sh scripts/Ratri_…sh --push          commit and push the log each pass
#
# WHAT IT DOES NOT DO, stated so nobody reads more into a green than is there:
#   · it does not write Agda into the corpus.  The census emits probes into a
#     scratch directory and asks the kernel; keeping a probe would be storing a
#     question as though it were a result.
#   · it does not run selfTests.  `ghc -fno-code` typechecks; a module that
#     passes the gate may still fail at runtime.
#   · it does not prove anything new.  It is an instrument, and its whole value
#     is that its numbers are recomputed rather than remembered.

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 2

INTERVAL=1800
ONCE=0
PUSH=0
while [ $# -gt 0 ]; do
  case "$1" in
    --once)     ONCE=1 ;;
    --push)     PUSH=1 ;;
    --interval) shift; INTERVAL="${1:-1800}" ;;
    *) echo "ratri: unknown flag $1" >&2; exit 2 ;;
  esac
  shift
done

LOGDIR="$ROOT/notes/ratri"
mkdir -p "$LOGDIR"
LOG="$LOGDIR/$(date -u +%Y-%m-%d).log"

export LC_ALL=C.utf8
export NIRDHARANA_SCRATCH="${TMPDIR:-/tmp}/nirdharana"
mkdir -p "$NIRDHARANA_SCRATCH"

say() { printf '%s\n' "$*" | tee -a "$LOG"; }
rule() { say "------------------------------------------------------------"; }

pass() {
  local t0 stamp
  stamp="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  t0=$(date +%s)
  rule
  say "रात्रिः  pass at $stamp   HEAD $(git rev-parse --short HEAD 2>/dev/null)"
  rule

  # ---- 0 · take in whatever other seats pushed.  पुनरागमन: nothing local is
  #         overwritten; a divergence is reported, never resolved silently.
  git fetch -q origin main 2>/dev/null
  local behind ahead
  behind=$(git rev-list --count HEAD..origin/main 2>/dev/null || echo "?")
  ahead=$(git rev-list --count origin/main..HEAD 2>/dev/null || echo "?")
  say "  git: $behind behind, $ahead ahead of origin/main"
  if [ "$behind" != "0" ] && [ "$behind" != "?" ]; then
    if git merge --no-edit -q origin/main 2>/dev/null; then
      say "  git: merged origin/main"
    else
      say "  git: MERGE CONFLICT — left for a person; this pass continues on the old tree"
      git merge --abort 2>/dev/null
    fi
  fi

  # ---- 1 · अनाथः · the machine lane must typecheck
  local out rc
  out="$(sh scripts/Anatha_TheMachineLaneHadNoGateAndNowItHasOne.sh --quiet 2>&1)"; rc=$?
  say "  अनाथः (machine/): $(printf '%s' "$out" | grep -E 'modules typechecked|failures' | tr -s ' ' | tr '\n' ' ')"
  [ $rc -ne 0 ] && printf '%s\n' "$out" | grep -A20 'failing modules' | tee -a "$LOG" >/dev/null

  # ---- 2 · the cubical lane.  Everything.agda is the latch: a module not
  #         reachable from it is verified by nothing.
  if command -v agda >/dev/null 2>&1; then
    local libs; libs="$NIRDHARANA_SCRATCH/libraries"
    { ls /opt/homebrew/Cellar/agda/*/share/agda/stdlib/standard-library.agda-lib 2>/dev/null | head -1
      ls /opt/homebrew/share/agda/cubical/cubical.agda-lib 2>/dev/null | head -1
    } > "$libs"
    ( cd formal/cubical && timeout_bin="" ; agda --library-file="$libs" -i . Everything.agda >"$NIRDHARANA_SCRATCH/everything.log" 2>&1 )
    rc=$?
    if [ $rc -eq 0 ]; then
      say "  Everything.agda: exit 0"
    else
      say "  Everything.agda: exit $rc  — first error:"
      grep -m1 -A3 'error' "$NIRDHARANA_SCRATCH/everything.log" | sed 's/^/      /' | tee -a "$LOG" >/dev/null
    fi
  else
    say "  Everything.agda: SKIPPED (agda not on PATH) — this is not a pass"
  fi

  # ---- 3 · निर्धारण · put the punarāgamana question to the kernel
  if command -v runghc >/dev/null 2>&1; then
    runghc machine/Nirdharana_WhichRecordFieldsRideFreeAndWhichMustSurvive.hs \
      >"$NIRDHARANA_SCRATCH/census.txt" 2>&1
    say "  निर्धारण:"
    grep -E 'record .* declarations|witness field|GREEN|SEPARATED|carrier unsaid|वाहकानुक्त' \
      "$NIRDHARANA_SCRATCH/census.txt" | head -12 | sed 's/^/    /' | tee -a "$LOG" >/dev/null
    cp "$NIRDHARANA_SCRATCH/census.txt" "$LOGDIR/census-$(date -u +%Y-%m-%dT%H%M%SZ).txt"
  else
    say "  निर्धारण: SKIPPED (runghc not on PATH) — this is not a pass"
  fi

  say "  pass took $(( $(date +%s) - t0 ))s"

  # ---- 4 · hand the remainder forward (§१६, 遺題継承)
  if [ "$PUSH" -eq 1 ]; then
    git add "$LOGDIR" 2>/dev/null
    if ! git diff --cached --quiet 2>/dev/null; then
      git commit -q -o "$LOGDIR" -m "रात्रिः — overnight pass $stamp

Recomputed, not remembered: every number in this log is measured from the
filesystem on the pass that wrote it. Appended, never rewritten (§६: a written
defect lives). See the log for the machine-lane gate, the cubical latch, and
the निर्धारण census." 2>/dev/null \
        && sh scripts/Parampara_TheCarrierFailsAndTheTransmissionContinues.sh >/dev/null 2>&1 \
        && say "  pushed"
    fi
  fi
}

say ""
say "============================================================"
say "रात्रिः — started $(date -u +%Y-%m-%dT%H:%M:%SZ), interval ${INTERVAL}s, log $LOG"
say "============================================================"

if [ "$ONCE" -eq 1 ]; then
  pass
  exit 0
fi

while true; do
  pass
  sleep "$INTERVAL"
done
