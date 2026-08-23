#!/usr/bin/env bash
# =====================================================================
# यन्त्रस्थिति — yantra-sthiti, the standing of the machine.
#
#   machine/YantraSthiti_WhatTheMachineDoesTodayGeneratedNotWritten.sh
#   ... --quick     skip the builds; filesystem and persistent state only
#   ... --secs N    per-program watchdog, default 90
#
# ONE COMMAND that answers "what does this machine actually do today":
# which entry points build, which self-tests pass, how many sūtras are
# implemented, how many derivations run end to end, what the falsifier
# catches, what residuals are outstanding.
#
# ---------------------------------------------------------------------
# EVERY FIGURE BELOW IS COMPUTED AT RUN TIME.  Nothing is stored.  The
# form is `machine/Anukramani.hs`'s and its reason is the same one, in
# that file's words: "a hand-written table of contents is true on the day
# it is written."  This repository has the receipts on that -- CLAUDE.md
# records a fitted constant that propagated into two notes, a paper
# section and a review round; `machine-state-report.sh` records a report
# that printed "library.txt MISSING" while 138 theorems sat beside it
# under another name.  A hand-kept status table decays the same way and
# is read as knowledge the whole time.
#
# WHAT THIS IS NOT.  It is not a verdict on the mathematics.  A green
# self-test closes a step; it does not choose one (CLAUDE.md).  Counts of
# sūtras and of modules are counts, and this repository does not rank by
# volume.  The numbers are here so that a claim about the state of the
# machine can be checked instead of believed.
#
# ON THE NAME.  yantra (instrument/machine) and sthiti (standing, state)
# are ordinary Sanskrit, joined here descriptively; NO source is being
# cited for a technical term, and inventing one would be the mirror of
# the scrubbing the naming rule corrects.  What IS taken from a source is
# the anukramaṇī's form -- an index is part of the work, computed over
# the corpus, giving per entry what it is and where it stands.
# =====================================================================
set -u

SECS=90
QUICK=0
while [ $# -gt 0 ]; do
  case "$1" in
    --quick) QUICK=1; shift ;;
    --secs)  SECS="${2:?--secs needs a number}"; shift 2 ;;
    -h|--help) sed -n '2,20p' "$0"; exit 0 ;;
    *) echo "yantrasthiti: unknown argument '$1'" >&2; exit 2 ;;
  esac
done

ROOT=$(cd "$(dirname "$0")/.." && pwd) || exit 2
cd "$ROOT" || exit 2
OUT=${TMPDIR:-/tmp}/yantrasthiti.$$
mkdir -p "$OUT"
trap 'rm -rf "$OUT"' EXIT

NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)
n() { printf '%s' "$1" | tr -d ' '; }

hr()  { echo "======================================================================"; }
sec() { echo; echo "-- $* $(printf '%.0s-' $(seq 1 $((66 - ${#1}))) 2>/dev/null)"; }

hr
echo " यन्त्रस्थिति — WHAT THE MACHINE DOES, computed $NOW"
echo " host: $(uname -s) $(uname -m)   ghc: $(ghc --numeric-version 2>/dev/null || echo absent)   agda: $(agda --version 2>/dev/null | head -1 || echo absent)"
echo " tree: $(git rev-parse --short HEAD 2>/dev/null)  on $(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
hr

# =====================================================================
# 1. THE CORPUS, counted from the filesystem
# =====================================================================
sec "1. corpus census (find, not a list)"
AGDA=$(find formal/cubical -name '*.agda' 2>/dev/null | wc -l)
# The first version of this line counted 9,649 .lean files and 9,514 of them
# were Mathlib under .lake/ -- a vendored dependency reported as this
# repository's own work, seventy times over. Caught by reading the number
# and disbelieving it, which is the only check a census gets.
LEAN=$(find formal/pairfield -name '*.lean' -not -path '*/.lake/*' 2>/dev/null | wc -l)
VENDORED=$(find formal/pairfield -name '*.lean' -path '*/.lake/*' 2>/dev/null | wc -l)
HS=$(find machine -name '*.hs' 2>/dev/null | wc -l)
NOTES=$(find notes -name '*.md' 2>/dev/null | wc -l)
SH=$(find scripts machine -name '*.sh' 2>/dev/null | wc -l)
printf '   %-34s %6s\n' "agda modules (formal/cubical)" "$(n "$AGDA")"
printf '   %-34s %6s\n' "lean modules (formal/pairfield)" "$(n "$LEAN")"
printf '   %-34s %6s\n' "vendored, excluded (.lake/ Mathlib)" "$(n "$VENDORED")"
printf '   %-34s %6s\n' "haskell modules (machine/)" "$(n "$HS")"
printf '   %-34s %6s\n' "prose (notes/*.md)" "$(n "$NOTES")"
printf '   %-34s %6s\n' "checks and helpers (*.sh)" "$(n "$SH")"
echo "   These are file counts. CLAUDE.md's headline ratio (book vs apparatus)"
echo "   is BOOK_INDEX.md's to compute: runghc -imachine machine/AnukramaniRun.hs"

# =====================================================================
# 2. IN-FLIGHT WORK — who else is mid-edit in this one checkout
#    Reported FIRST among the build results' preconditions, because a red
#    build in a file another seat is holding open is their work in
#    progress, not a fault, and calling it a fault is how a shared tree
#    turns into sixteen people reverting each other.
# =====================================================================
sec "2. in-flight in this working tree (not faults)"
DIRTY=$(git status --porcelain 2>/dev/null | wc -l)
printf '   %-34s %6s\n' "modified / untracked paths" "$(n "$DIRTY")"
git status --porcelain 2>/dev/null | awk '{print "     " $0}' | head -25
[ "$(n "$DIRTY")" -gt 25 ] && echo "     ... $(( $(n "$DIRTY") - 25 )) more"

# =====================================================================
# 3. THE HASKELL LANE — built and run, here, now
# =====================================================================
# portable watchdog: this host has no timeout(1) and no gtimeout(1).
watch_run() {
  local secs=$1 log=$2; shift 2
  ( "$@" >"$log" 2>&1 ) & local pid=$! w=0
  while kill -0 "$pid" 2>/dev/null; do
    if [ "$w" -ge "$secs" ]; then kill -9 "$pid" 2>/dev/null; wait "$pid" 2>/dev/null; return 124; fi
    sleep 1; w=$(( w + 1 ))
  done
  wait "$pid"; return $?
}

BUILT=0; BROKE=0; PASSED=0; FAILED=0; TIMEDOUT=0
declare -a BROKEN_LIST=()

if [ "$QUICK" -eq 1 ]; then
  sec "3. haskell lane"
  echo "   --quick: not built. Re-run without --quick for the real answer."
else
  sec "3. haskell entry points: built from source, then run"
  echo "   ghc -O0 per machine/*Run.hs, then run at its own self-test entry"
  echo "   (no arguments for all but Nalanda, which takes --self-test)."
  echo "   ${SECS}s watchdog; this host has neither timeout(1) nor gtimeout(1)."
  echo
  for src in machine/*Run.hs; do
    name=$(basename "$src" Run.hs)
    bin="$OUT/$name"
    if ! ghc -O0 -imachine -outputdir "$OUT/o_$name" -o "$bin" "$src" >"$OUT/b_$name.log" 2>&1; then
      BROKE=$(( BROKE + 1 )); BROKEN_LIST+=("$name")
      first=$(grep -m1 -E '^[^ ]+\.hs:[0-9]+:[0-9]+: error' "$OUT/b_$name.log" | cut -c1-64)
      printf '   %-22s BUILD FAILS  %s\n' "$name" "${first:-see log}"
      continue
    fi
    BUILT=$(( BUILT + 1 ))
    # A program's self-test is not always "no arguments", and assuming it is
    # reports a usage message as a failure.  NalandaRun with no arguments
    # prints its usage and exits 1 by design.
    case "$name" in
      Nalanda) selfarg=(--self-test) ;;
      *)       selfarg=() ;;
    esac
    watch_run "$SECS" "$OUT/r_$name.log" "$bin" ${selfarg+"${selfarg[@]}"}
    rc=$?
    fails=$(grep -ciE '^[[:space:]]*(FAIL|fail )' "$OUT/r_$name.log" 2>/dev/null | tr -d ' ')
    lines=$(wc -l < "$OUT/r_$name.log" | tr -d ' ')
    if [ "$rc" -eq 124 ]; then
      TIMEDOUT=$(( TIMEDOUT + 1 ))
      printf '   %-22s built; RAN OVER %ss (not a failure, a long run)\n' "$name" "$SECS"
    elif [ "$rc" -eq 0 ] && [ "${fails:-0}" -eq 0 ]; then
      PASSED=$(( PASSED + 1 ))
      printf '   %-22s built; ran clean, exit 0, %s lines out\n' "$name" "$lines"
    else
      FAILED=$(( FAILED + 1 ))
      printf '   %-22s built; exit %s, %s FAIL line(s)\n' "$name" "$rc" "${fails:-0}"
      grep -iE '^[[:space:]]*(FAIL|fail )' "$OUT/r_$name.log" | head -3 | sed 's/^/        /'
    fi
  done
  echo
  printf '   TOTAL  built %s   build-fails %s   clean %s   with-failures %s   over-watchdog %s\n' \
    "$BUILT" "$BROKE" "$PASSED" "$FAILED" "$TIMEDOUT"
  if [ "$BROKE" -gt 0 ]; then
    echo "   A build failure here is FIRST a question about §2: if the module is"
    echo "   in the modified list above, another seat is mid-edit and this is"
    echo "   their in-flight state. Do not repair another identity's file."
  fi
fi

# =====================================================================
# 4. THE AṢṬĀDHYĀYĪ — sūtras implemented, derivations run
#    Read out of the program's OWN output, so the count cannot drift from
#    the code the way a README's count does.
# =====================================================================
sec "4. Aṣṭādhyāyī: sūtras implemented, derivations run"
AST="$OUT/Astadhyayi"
if [ -x "$AST" ] && [ -s "$OUT/r_Astadhyayi.log" ]; then
  grep -E '^ +(sūtras (encoded here|in the Aṣṭādhyāyī)|of which vidhi[^:]*|saṃjñā / paribhāṣā[^:]*|fraction):' "$OUT/r_Astadhyayi.log" | sed 's/^ */   /' | head -8
  DERIV=$(grep -cE '^  .* +-> +' "$OUT/r_Astadhyayi.log")
  SUTRA_FIRE=$(grep -cE '^      [0-9]+\.[0-9]+\.[0-9]+ ' "$OUT/r_Astadhyayi.log")
  BEAT=$(grep -c 'beat ' "$OUT/r_Astadhyayi.log")
  ASIDDHA=$(grep -c 'pūrvatrāsiddham' "$OUT/r_Astadhyayi.log")
  printf '   %-40s %5s\n' "derivations run end to end" "$DERIV"
  printf '   %-40s %5s\n' "sūtra firings in those traces" "$SUTRA_FIRE"
  printf '   %-40s %5s\n' "conflicts decided by metarule (beat)" "$BEAT"
  printf '   %-40s %5s\n' "8.2.1 asiddhatva refusals recorded" "$ASIDDHA"
else
  # The program did not run.  Say what can still be counted from source,
  # and say plainly that it is a source count and not a run.
  SRC_SUTRAS=$(awk '/^sutras :: \[Sutra\]/,/^$/' machine/Astadhyayi.hs 2>/dev/null | grep -c '^  *[,[] *Sutra')
  echo "   the Aṣṭādhyāyī program did not run in this pass (see §3)."
  printf '   %-40s %5s   <- counted from SOURCE, not from a run\n' \
     "Sutra constructors in Astadhyayi.hs" "${SRC_SUTRAS:-?}"
  echo "   Against ~3983 sūtras in the text (recensions differ: 3959-3996)."
fi

# =====================================================================
# 5. THE FALSIFIER — what the kernel refuses
#    A gate that has never rejected anything is not evidence of soundness;
#    it is an untested gate.  So the figure that matters is not how many
#    things passed, it is whether the thing that MUST be refused was.
# =====================================================================
sec "5. falsifier: what gets refused"
FALS=0
for lg in "$OUT"/r_*.log; do
  [ -f "$lg" ] || continue
  c=$(grep -ciE 'falsifier|refus|reject|must fail|correctly fails' "$lg" 2>/dev/null | tr -d ' ')
  [ "${c:-0}" -gt 0 ] && { printf '   %-24s %4s refusal line(s)\n' "$(basename "$lg" .log | sed 's/^r_//')" "$c"; FALS=$(( FALS + c )); }
done
[ "$FALS" -eq 0 ] && echo "   no refusal line observed in this pass — either nothing ran (§3) or"
[ "$FALS" -eq 0 ] && echo "   no gate was exercised against a case it is required to reject."
echo "   source-side: $(grep -ril falsif machine/*.hs 2>/dev/null | wc -l | tr -d ' ') machine modules mention a falsifier;"
echo "   machine/CERTIFICATE_REACH.md records the kernel refusing 13 of 28"
echo "   certificates at the time that file was written — read it, not this."

# =====================================================================
# 6. THE AGDA LANE — read from the loop's own generated stamp
#    NOT typechecked here: 761 modules is the natural-machine loop's cycle,
#    not a status command's. What is reported is state the loop GENERATED,
#    with its age, so a stale number cannot pass as a fresh one.
# =====================================================================
sec "6. agda lane (read from the loop's stamp, not typechecked here)"
FIB=collab/orchestration/open-fibers.md
if [ -f "$FIB" ]; then
  head -8 "$FIB" | grep -E 'Cycle|Modules|fibers|exit' | sed 's/^/   /'
  DUE=$(grep -oE 'due by [0-9T:-]+Z' "$FIB" | head -1 | awk '{print $3}')
  echo "   next cycle due: ${DUE:-unstamped}"
  echo "   liveness verdict is machine/machine-state-report.sh's job, and it"
  echo "   exits nonzero when that stamp has expired. This line only reports."
  echo "   listed fibers: $(grep -c '^- `' "$FIB") module(s) named as reconstruction questions"
else
  echo "   no $FIB — the loop has never stamped. Treat the agda lane as unknown."
fi

# =====================================================================
# 7. RESIDUALS — the queue the next block starts from
# =====================================================================
sec "7. residual queue"
RQ=collab/orchestration/SesaPanktih_TheResidualQueue.md
if [ -f "$RQ" ]; then
  P=$(grep -c '^- \[PROVE\]' "$RQ"); S=$(grep -c '^- \[SEARCH\]' "$RQ"); D=$(grep -c '^- \[DEMONSTRATE\]' "$RQ")
  C=$(grep -c '^- \[x\]' "$RQ")
  printf '   %-34s %6s\n' "PROVE" "$P"
  printf '   %-34s %6s\n' "SEARCH" "$S"
  printf '   %-34s %6s\n' "DEMONSTRATE" "$D"
  printf '   %-34s %6s\n' "closed (struck, kept in place)" "$C"
  echo "   $RQ"
  echo "   Worked in that order — CLAUDE.md, standing queue discipline."
else
  echo "   no residual queue at $RQ"
fi

echo
hr
echo " Read the logs, not the summary. Nothing above is a verdict on the"
echo " mathematics; a checked term closes a step and does not choose one."
hr
# Exit code carries ONE fact: did anything that built then fail its own
# self-test. Build failures do not set it, because in this tree they are
# usually another seat mid-edit (§2) and an exit code cannot tell the
# difference between that and a fault.
[ "$FAILED" -gt 0 ] && exit 1
exit 0
