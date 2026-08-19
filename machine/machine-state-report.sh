#!/usr/bin/env bash
# =====================================================================
# machine-state-report.sh — "Is the machine alive right now?"
#
#   ./machine/machine-state-report.sh
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
#   machine/library.txt                       proved-theorem count
# EVENT source, clearly labelled as such, never mistaken for state:
#   machine/machine.log                       pruning trend (informational)
# =====================================================================

set -u

cd "$(dirname "$0")/.." 2>/dev/null || cd "$(dirname "$0")" || exit 2

LEDGER=collab/orchestration/machine-ledger.tsv
FIBERS=collab/orchestration/open-fibers.md
LIBRARY=machine/library.txt
MLOG=machine/machine.log

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
# 3. THE ANSWER — screamed when dead, so it cannot be skimmed past
# =====================================================================
echo
if [ "$DEAD" -eq 1 ]; then
    cat <<'BANNER'
  ####################################################################
  ##                                                                ##
  ##   ███  MACHINE PRESUMED DEAD  ███                              ##
  ##                                                                ##
  ##   The loop is NOT certifiably running. A dead loop and a       ##
  ##   quiet loop look identical from the repository — this stamp   ##
  ##   is the whole reason we can tell, and it says: NOT ALIVE.     ##
  ##                                                                ##
  ##   RESTART with one cycle:   ./run_the_natural_machine_forever  ##
  ##                                                                ##
  ####################################################################
BANNER
    echo
    echo "   reason: ${REASON}."
else
    echo "  >>> MACHINE ALIVE — DUE-BY stamp is current (${REASON})."
fi

# =====================================================================
# 4. LIBRARY — proved-theorem count (persistent state)
# =====================================================================
echo
echo "-- Library ----------------------------------------------------------"
if [ -f "$LIBRARY" ]; then
    THMS=$(sed '/^[[:space:]]*$/d' "$LIBRARY" | wc -l | tr -d ' ')
    echo "   proved theorems (library.txt lines): ${THMS}"
    sed '/^[[:space:]]*$/d' "$LIBRARY" | sed 's/^/     · /'
else
    echo "   library.txt MISSING at $LIBRARY"
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
