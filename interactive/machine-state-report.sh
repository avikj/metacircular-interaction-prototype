#!/usr/bin/env bash
# =====================================================================
# machine-state-report.sh — "Is the machine alive right now?"
#
#   ./interactive/machine-state-report.sh
#
# Answers that question from PERSISTENT STATE ALONE — the ledger, the
# open-fibers stamp, and the library file. It never inspects a process,
# never greps `ps`, never runs a cycle. A dead loop and a quiet loop are
# indistinguishable from any process check (msg 0463: a sibling machine
# was DEAD an hour before anyone noticed). They are NOT indistinguishable
# from the files the loop leaves behind, because the loop stamps a DUE-BY
# time into `open-fibers.md` every cycle. If that time has passed, no
# process needs to be found: death is self-reporting.
#
# This is the state-vs-event discipline of the runner's own header, read
# back out: the ledger row is an EVENT ("this container invoked these
# checks at this time"); this report turns the latest events into the one
# STATE question a human actually asks, and SCREAMS when the answer is
# "dead / cannot be certified alive".
#
# STATE sources (read-only, all persistent):
#   collab/orchestration/machine-ledger.tsv   last event: cycle, utc, counts
#   collab/orchestration/open-fibers.md       the DUE-BY presence stamp
#   interactive/library.txt                       proved-theorem count
# EVENT source, clearly labelled as such, never mistaken for state:
#   interactive/machine.log                       pruning trend (informational)
# =====================================================================

set -u

cd "$(dirname "$0")/.." 2>/dev/null || cd "$(dirname "$0")" || exit 2

LEDGER=collab/orchestration/machine-ledger.tsv
FIBERS=collab/orchestration/open-fibers.md
LIBRARY=interactive/library.txt
MLOG=interactive/machine.log

NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)
NOW_EPOCH=$(date -u +%s)

# --- epoch of an ISO-8601 Z timestamp, or empty on failure ------------
iso_epoch() {
    [ -n "${1:-}" ] || { echo ""; return; }
    date -u -d "$1" +%s 2>/dev/null || echo ""
}

# --- human-friendly duration from a second count ----------------------
human_dur() {
    local s=$1 d h m
    [ "$s" -lt 0 ] && s=$(( -s ))
    d=$(( s / 86400 )); s=$(( s % 86400 ))
    h=$(( s / 3600 ));  s=$(( s % 3600 ))
    m=$(( s / 60 ))
    if   [ "$d" -gt 0 ]; then printf '%dd %dh %dm' "$d" "$h" "$m"
    elif [ "$h" -gt 0 ]; then printf '%dh %dm' "$h" "$m"
    else printf '%dm' "$m"; fi
}

echo "======================================================================"
echo " MACHINE STATE REPORT   (read from persistent state, no process check)"
echo " as of  $NOW"
echo "======================================================================"

# =====================================================================
# 1. LAST LEDGER EVENT — the most recent thing the loop actually did
# =====================================================================
if [ ! -f "$LEDGER" ]; then
    echo
    echo "  !! NO LEDGER at $LEDGER — the loop has never written a row here."
    echo "     Cannot certify the machine as ever having run. Treat as DEAD."
    LAST_UTC=""; LAST_CYCLE="?"; TOOLCHAIN="?"
    MODULES="?"; GREEN="?"; FIBER="?"; FIBER_ENV="?"; AGG="?"
else
    # last non-empty data row (skip the header line)
    LAST_ROW=$(grep -v '^utc' "$LEDGER" | sed '/^[[:space:]]*$/d' | tail -1)
    IFS=$'\t' read -r LAST_UTC LAST_CYCLE TOOLCHAIN MODULES GREEN FIBER FIBER_ENV AGG WALK <<EOF
$LAST_ROW
EOF
    echo
    echo "-- Last ledger event ------------------------------------------------"
    echo "   cycle #        : ${LAST_CYCLE}"
    echo "   stamped (UTC)  : ${LAST_UTC}"
    echo "   toolchain      : ${TOOLCHAIN}"
    echo "   modules invoked: ${MODULES}"
    echo "   green / fiber  : ${GREEN} green   ${FIBER} fiber   ${FIBER_ENV} env-event"
    echo "   aggregate exit : ${AGG}     walk frontier: ${WALK:-}"
fi

# =====================================================================
# 2. PRESENCE — the DUE-BY stamp, read from where the loop writes it
#    (open-fibers.md). This is the single source of "is it alive".
# =====================================================================
echo
echo "-- Presence (DUE-BY stamp) ------------------------------------------"

DUE_BY=""
if [ -f "$FIBERS" ]; then
    DUE_BY=$(grep -oE 'due by [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z' "$FIBERS" \
             | head -1 | awk '{print $3}')
    if [ -z "$DUE_BY" ]; then
        # the loop writes the literal word "unknown" when its host `date`
        # cannot compute a future stamp (e.g. BSD date without -d).
        grep -q 'due by unknown' "$FIBERS" && DUE_BY="unknown"
    fi
fi

DEAD=0            # 0 = certified current, 1 = expired/uncertifiable = DEAD
REASON=""

if [ ! -f "$FIBERS" ]; then
    DEAD=1; REASON="no open-fibers stamp file ($FIBERS) exists"
    echo "   stamp file     : MISSING"
elif [ "$DUE_BY" = "unknown" ]; then
    DEAD=1; REASON="DUE-BY stamp is literally \"unknown\" — the loop could not record when it would be back, so liveness CANNOT be certified"
    echo "   next cycle due : unknown  (loop's host could not compute a due time)"
elif [ -z "$DUE_BY" ]; then
    DEAD=1; REASON="no parseable DUE-BY stamp found in $FIBERS"
    echo "   next cycle due : (none found in stamp file)"
else
    DUE_EPOCH=$(iso_epoch "$DUE_BY")
    echo "   next cycle due : ${DUE_BY}"
    if [ -z "$DUE_EPOCH" ]; then
        DEAD=1; REASON="DUE-BY stamp \"$DUE_BY\" could not be parsed as a time"
    elif [ "$NOW_EPOCH" -gt "$DUE_EPOCH" ]; then
        DEAD=1
        REASON="DUE-BY expired $(human_dur $(( NOW_EPOCH - DUE_EPOCH ))) ago"
    else
        REASON="within window, $(human_dur $(( DUE_EPOCH - NOW_EPOCH ))) remaining"
    fi
fi

# Independent corroboration: staleness of the last ledger EVENT itself.
# The DUE-BY is the primary signal; this is the backstop for when the
# stamp is unknown/missing, and it is stated always so the age is visible.
LAST_EPOCH=$(iso_epoch "${LAST_UTC:-}")
if [ -n "$LAST_EPOCH" ]; then
    AGE=$(( NOW_EPOCH - LAST_EPOCH ))
    echo "   last event age : $(human_dur "$AGE") ago  (ledger row time vs now)"
fi

# =====================================================================
# 3. TWO REGISTERS, REPORTED SEPARATELY
#
#    The DUE-BY stamp knows whether `run_the_natural_machine_forever` is
#    certifiably running.  That is a fact about a bash daemon and not a
#    fact about the machine, so no line here combines the two: the
#    combination is what cannot be computed from this file.
# =====================================================================
echo
echo "-- The loop (what the DUE-BY stamp actually knows) -------------------"
if [ "$DEAD" -eq 1 ]; then
    echo "   run_the_natural_machine_forever: NOT certifiably running."
    echo "   reason: ${REASON}."
    echo "   re-enter with one cycle:  ./run_the_natural_machine_forever"
    echo "   (idempotent and cheap; any arriving mind advances the ledger.)"
else
    echo "   run_the_natural_machine_forever: stamp current (${REASON})."
fi

# --- the other register, which the stamp says nothing about ----------
echo
echo "-- The corpus (activity since that ledger row) ----------------------"
if [ -n "${LAST_UTC:-}" ]; then
    C=$(git log --since="$LAST_UTC" --oneline 2>/dev/null | wc -l | tr -d ' ')
    A=$(git log --since="$LAST_UTC" --diff-filter=A --name-only --format='' 2>/dev/null | grep -c '\.agda$')
    R=$(git log --since="$LAST_UTC" --format='%s' 2>/dev/null | grep -Eic 'retract|withdraw|refut|was wrong|is false|struck|correction')
    echo "   commits: ${C}    agda modules added: ${A}    corrections landed: ${R}"
else
    echo "   (no ledger timestamp to measure from)"
fi
echo
echo "   These are counts of EVENTS, not a verdict, and this repository does"
echo "   not rank by volume (CLAUDE.md). README's criterion is the one that"
echo "   matters and no script computes it: mathematics runs when a"
echo "   mathematical event changes the conditions of later mathematical"
echo "   life. Whether that happened is read, not measured."

# =====================================================================
# 4. LIBRARY — proved-theorem count (persistent state)
# =====================================================================
echo
echo "-- Library ----------------------------------------------------------"
# CORRECTION, 2026-08-20.  This block used to print "library.txt MISSING"
# and stop.  interactive/library.txt has not existed for some time; the engine's
# proved terms live in library.terms, with library.snapshot.txt and
# library.gen1.txt beside them.  So the report announced an absence while
# 138 theorems sat in the same directory under another name -- which is the
# same defect as the struck verdict in §3, one register down: my not-seeing
# reported as its non-existence.  It now looks for each file it might be.
found=0
for lib in "$LIBRARY" interactive/library.terms interactive/library.snapshot.txt interactive/library.gen1.txt; do
    [ -f "$lib" ] || continue
    found=1
    THMS=$(sed '/^[[:space:]]*$/d' "$lib" | wc -l | tr -d ' ')
    echo "   ${lib}: ${THMS} lines"
done
if [ "$found" -eq 0 ]; then
    echo "   no library file found (looked for library.txt, library.terms,"
    echo "   library.snapshot.txt, library.gen1.txt under interactive/)"
else
    echo
    echo "   A line count is not a theorem count and neither is a verdict:"
    echo "   these files are appended by different runs under different gates,"
    echo "   and CERTIFICATE_REACH.md records that the kernel refused 13 of 28"
    echo "   at the time it was measured.  Read the file, not the number."
fi

# =====================================================================
# 5. PRUNING TREND
#    The ledger schema has NO pruning column, so there is no pruning
#    trend "across ledger rows" to report — stated plainly rather than
#    invented. The machine.log DOES carry per-round pruning, but that is
#    an EVENT log, not certified state; shown here informationally only.
# =====================================================================
echo
echo "-- Pruning trend ----------------------------------------------------"
if grep -q 'pruned=' "$LEDGER" 2>/dev/null; then
    echo "   (from ledger rows:)"
    grep -oE 'pruned=[0-9.]+%' "$LEDGER"
else
    echo "   ledger schema carries NO pruning column — no pruning trend in state."
    if [ -f "$MLOG" ]; then
        echo "   informational only (machine.log is an EVENT log, not state):"
        LAST_RD=$(grep -oE 'round [0-9]+ .*pruned=[0-9.]+%' "$MLOG" | tail -1)
        FIRST_RD=$(grep -oE 'round [0-9]+ .*pruned=[0-9.]+%' "$MLOG" | head -1)
        [ -n "$FIRST_RD" ] && echo "     first round: $(echo "$FIRST_RD" | grep -oE 'round [0-9]+|pruned=[0-9.]+%' | paste -sd' ' -)"
        [ -n "$LAST_RD"  ] && echo "     last round : $(echo "$LAST_RD"  | grep -oE 'round [0-9]+|pruned=[0-9.]+%' | paste -sd' ' -)"
    fi
fi

echo
echo "======================================================================"
[ "$DEAD" -eq 1 ] && exit 1 || exit 0
