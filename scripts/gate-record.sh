#!/usr/bin/env bash
# =====================================================================
# gate-record.sh — turn a green into a durable, dated, per-module record.
#
#   ./scripts/gate-record.sh              check every module, append rows
#   ./scripts/gate-record.sh --dry-run    print what would be checked; append
#                                         NOTHING; needs no toolchain
#   GATE_LEAN=1 ./scripts/gate-record.sh  also record the Lean lane, per module
#
# ---------------------------------------------------------------------
# WHY THIS FILE EXISTS
#
# `notes/THE_GATE_IS_A_CLAIM_ABOUT_A_STATE.md` (2026-08-16) establishes,
# from the Actions API rather than from a badge, that no CI job in this
# repository has ever been assigned a runner: every run reachable through
# the API — 990 of `no-python.yml`, 990 of `epistemic.yml`, all 30 of
# `formal-gates.yml`, both of the stranded `agda.yml` — completed in 2-4
# seconds with `runner_id: 0`, `runner_name: ""`, no `steps` array, 0
# billable milliseconds, and HTTP 404 on the logs.  The YAML is not at
# fault and no YAML edit repairs it.
#
# So the whole of this repository's mechanised evidence about whether the
# mathematics typechecks reduces to whatever a session with a toolchain
# wrote down.  And the durable form of "wrote down" was, until this file,
# two things and neither of them enough:
#
#   * `collab/orchestration/machine-ledger.tsv` — append-only, dated,
#     toolchain-stamped, and COUNTS ONLY.  "87 green" does not say WHICH
#     87.  Its last row carrying any green is 2026-08-14T05:06:10Z, for
#     87 modules, under a toolchain the schema of the day did not record.
#     There are 400 non-Control modules on disk today.
#   * `collab/orchestration/open-fibers.md` — names modules, but is
#     REGENERATED every cycle (the file says so in its own first line),
#     so it is a snapshot, not a record; and it names only the reds.  A
#     green module has never been named in a durable file by any machine
#     in this repository.
#
# This script writes the missing object: one row per module per run,
# appended, carrying the exit code, the toolchain that produced it, the
# commit it was produced at, and the host that produced it.
#
# ---------------------------------------------------------------------
# THE FIVE RULES IT OBEYS, EACH PAID FOR BY A DOCUMENTED DEFECT
#
# 1. ENUMERATE, NEVER LIST.  The module set comes from `find`.  A
#    hand-written list has rotted in this repository at least four times:
#    `Everything.agda`'s import list (SEED-81, and again 2026-08-16 —
#    `notes/AGDA_COVERAGE_INVENTORY.md` claimed 0 non-Control orphans at
#    03:43 and `scripts/check-agda-closure.sh` reports 21 at HEAD
#    5d011531, 04:19), `lean_lib Pairfield` without `globs`
#    (`notes/LEAN_LANE_AUDIT.md`, 21 modules built by nothing), the pin
#    sweep's 34 Agda orphans (`notes/PIN_SWEEP_NATURALMACHINE.md`), and
#    the 7-module hand-list inside the stranded `agda.yml`.
#
# 2. PER MODULE, NEVER THE AGGREGATE ALONE.  `run_the_natural_machine_forever`
#    §"THE FOUR PHASES" names three defects that survive any check reading
#    aggregate OUTPUT instead of `$?` per module: a warning read as an
#    error (correction 0395), a missing name read as a green for a day
#    (msg 0456), and a BUILD.md claiming "every module, exit 0" while
#    checking a minority.  The two aggregate roots are still checked, but
#    they are rows like any other, marked `kind=aggregate`.
#
# 3. THE TOOLCHAIN IS PART OF THE OBSERVATION.  Every row carries the
#    agda version, the cubical library, and whether the pair IS the pin
#    (BUILD.md "Toolchain": Agda 2.8.0 + cubical v0.9).  The ledger's own
#    2026-08-14T17:19Z row read "315 modules, 0 green" as if the corpus
#    had died overnight; what had happened is that the container had no
#    `agda` and every invocation exited 127.  A row without its toolchain
#    is a statement about a container being read as a statement about the
#    mathematics.
#
# 4. THE ENVIRONMENT'S EXIT IS NOT AGDA'S VERDICT.  Exit >= 124 (124
#    watchdog, 125-127 could-not-run, 128+n killed by signal n, 137 OOM)
#    is recorded `fiber_env`.  Agda, when it runs, exits 0 or 1 or 42 —
#    never 127.  A `fiber_env` row assigns no mathematical work and must
#    never be repaired by editing a module.
#
# 5. NO TOOLCHAIN MEANS ZERO ROWS.  A check that cannot start performed 0
#    checks; it did not perform N failed ones.  With no `agda` on PATH
#    this script appends nothing at all and exits 2.  It will not write a
#    row that a later reader could mistake for evidence about the tree.
#
# ---------------------------------------------------------------------
# WHAT IT DOES NOT DO
#
# It does not typecheck anything by itself; it invokes Agda and records
# what Agda returned.  Exit 0 on a module means that module typechecked
# under the recorded toolchain — it does NOT mean the module says what
# its comments claim (`notes/LEAN_LANE_AUDIT.md` §6), and it does not
# extend to any module absent from the run.  It does not touch
# `open-fibers.md` or `machine-ledger.tsv`; those belong to
# `run_the_natural_machine_forever` and racing them would corrupt both.
# It does not commit, push, or sync.
#
# LEDGER: collab/orchestration/module-gate-record.tsv, append-only, TSV,
# header written once.  Columns:
#
#   run_utc    UTC start of the run.  All rows of one run share it, which
#              is what makes a run reconstructable from the file alone.
#   commit     `git rev-parse --short HEAD` at run start.
#   dirty      `clean` or `DIRTY` (uncommitted tracked changes).  A green
#              recorded against a dirty tree is not a green for that
#              commit and must not be quoted as one.
#   toolchain  e.g. `agda-2.8.0`.  Never blank; the run aborts instead.
#   cubical    `v0.9`, `not-v0.9`, or `unregistered`.
#   pin        `pin` iff toolchain=agda-2.8.0 AND cubical=v0.9, else `off-pin`.
#   host       `hostname`.  Several agents share one checkout; a false red
#              from a `_build` race (see the mutex below) is traceable.
#   kind       `aggregate` (the two roots), `module`, or `control`.
#   module     path relative to formal/cubical/.
#   exit       raw exit code, `$?`, not parsed output.
#   secs       wall-clock seconds for that invocation.
#   verdict    green | fiber | fiber_env
#              | control-red-as-designed | control-FALSE-GREEN
#
# Exit: 0 iff on the pin AND every module/aggregate row is green AND every
# control row is control-red-as-designed.  2 if no toolchain.  1 otherwise.
# =====================================================================

set -uo pipefail

cd "$(dirname "$0")/.." || { echo "gate-record: cannot reach repo root" >&2; exit 2; }
REPO="$(pwd)"

# The locale, unconditionally and before anything else.  The lane emits
# ℕ/≡/Δ; under C/POSIX both Agda 2.6.3 and 2.8.0 die trying to print them
# and return 42 for that reason alone.  Two false "the corpus is red"
# reports in this repository trace to exactly that (`./run` header,
# formal/cubical/check.sh §1).
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

CUBICAL="$REPO/formal/cubical"
# GATE_LEDGER exists so this script's own plumbing (row classification,
# the lock, the summary) can be exercised against a stub compiler in a
# scratch directory without writing fiction into the repository's record.
# A REAL record always goes to the default path; a row written anywhere
# else is a test artefact and is not evidence about anything.
LEDGER="${GATE_LEDGER:-$REPO/collab/orchestration/module-gate-record.tsv}"
TIMEOUT_SECS="${GATE_TIMEOUT:-900}"
DRY=0
[ "${1:-}" = "--dry-run" ] && DRY=1

[ -d "$CUBICAL" ] || { echo "gate-record: no $CUBICAL" >&2; exit 2; }

# ---------------------------------------------------------------------
# 1. The module set, enumerated.  Rule 1.
# ---------------------------------------------------------------------
# NaturalMachine/Control/ is excluded from the module set BECAUSE its
# contents are deliberately false statements that MUST fail to typecheck
# (NaturalMachine.agda's own header).  Counting a designed refutation as
# a fiber is a false red, which is a false green with the sign flipped.
# They are checked separately, as controls, because a control that goes
# GREEN is a defect nobody would otherwise see.
AGG_ROOTS="Everything.agda NaturalMachine.agda"

list_modules() {
    ( cd "$CUBICAL" && find . -name '*.agda' \
        -not -path './_build/*' \
        -not -path './NaturalMachine/Control/*' \
      | sed 's|^\./||' | sort )
}
list_controls() {
    ( cd "$CUBICAL" && find ./NaturalMachine/Control -name '*.agda' 2>/dev/null \
      | sed 's|^\./||' | sort )
}

kind_of() {
    case " $AGG_ROOTS " in *" $1 "*) echo aggregate ;; *) echo module ;; esac
}

if [ "$DRY" -eq 1 ]; then
    echo "gate-record --dry-run: enumeration only. Nothing is invoked and"
    echo "NOTHING is appended to $LEDGER."
    echo
    nm=$(list_modules | wc -l | tr -d ' ')
    nc=$(list_controls | wc -l | tr -d ' ')
    echo "modules to check (excluding NaturalMachine/Control/): $nm"
    echo "controls to check (must all be red)                 : $nc"
    echo "aggregate roots, checked as rows like any other     : $AGG_ROOTS"
    echo
    echo "first and last five of the enumeration:"
    list_modules | head -5 | sed 's/^/    /'
    echo "    ..."
    list_modules | tail -5 | sed 's/^/    /'
    echo
    echo "row schema:"
    echo "    run_utc commit dirty toolchain cubical pin host kind module exit secs verdict"
    exit 0
fi

# ---------------------------------------------------------------------
# 2. The toolchain.  Rules 3 and 5.
# ---------------------------------------------------------------------
find_agda() {
    local c
    [ -n "${AGDA_PIN:-}" ] && { printf '%s\n' "$AGDA_PIN"; return; }
    for c in "$(command -v agda-2.8.0 2>/dev/null || true)" \
             "$HOME/.cabal/bin/agda" /root/.cabal/bin/agda; do
        [ -n "$c" ] && [ -x "$c" ] && { printf '%s\n' "$c"; return; }
    done
    command -v agda 2>/dev/null || true
}

AGDA="$(find_agda)"
if [ -z "$AGDA" ]; then
    cat >&2 <<'EOF'
gate-record: no agda on PATH.

ZERO rows appended. A check that cannot start performed 0 checks; it did
not perform N failed ones, and this script will not write a row a later
reader could mistake for evidence about the tree.

To build the pin (Agda 2.8.0 + cubical v0.9), see formal/cubical/BUILD.md
"Reproducing the pin" and the FATAL block in formal/cubical/check.sh.
EOF
    exit 2
fi

AGDA_VER="$("$AGDA" --version 2>/dev/null | head -1 | sed 's/^Agda version //; s/ .*//')"
TOOLCHAIN="agda-${AGDA_VER:-unknown}"

# cubical v0.9 is identified by CONTENT, not by directory name: v0.9 is the
# first release whose Cubical/Algebra/SymmetricGroup.agda defines `SymGroup`
# (v0.8 and earlier call it `Symmetric-Group`).  Borrowed verbatim in intent
# from formal/cubical/check.sh §3, which is the file that established it.
is_v09() { [ -f "$1/Cubical/Algebra/SymmetricGroup.agda" ] &&
           grep -q '^SymGroup' "$1/Cubical/Algebra/SymmetricGroup.agda" 2>/dev/null; }

LIBFILE=""
CUB_STATE="unregistered"
find_cubical() {
    local d line
    [ -n "${AGDA_CUBICAL_LIB:-}" ] && { printf '%s\n' "${AGDA_CUBICAL_LIB%/}"; return; }
    for d in /root/agda-libs/cubical-v0.9 "$HOME/agda-libs/cubical-v0.9" \
             /root/agda-libs/cubical "$HOME/agda-libs/cubical" \
             /root/cubical "$HOME/cubical" /usr/share/agda/cubical; do
        is_v09 "$d" && { printf '%s\n' "$d"; return; }
    done
    if [ -f "$HOME/.agda/libraries" ]; then
        while read -r line; do
            line="${line%%--*}"; line="$(printf '%s' "$line" | tr -d '[:space:]')"
            [ -z "$line" ] && continue
            d="$(dirname "$line")"
            is_v09 "$d" && { printf '%s\n' "$d"; return; }
        done < "$HOME/.agda/libraries"
    fi
    for d in /root/agda-libs/cubical "$HOME/agda-libs/cubical" /root/cubical "$HOME/cubical"; do
        [ -f "$d/cubical.agda-lib" ] && { printf '%s\n' "$d"; return; }
    done
}
CUB_DIR="$(find_cubical)"
if [ -n "$CUB_DIR" ]; then
    if is_v09 "$CUB_DIR"; then CUB_STATE="v0.9"; else CUB_STATE="not-v0.9"; fi
    LIBFILE="$(mktemp)"
    printf '%s\n' "$CUB_DIR/cubical.agda-lib" > "$LIBFILE"
fi

if [ "$TOOLCHAIN" = "agda-2.8.0" ] && [ "$CUB_STATE" = "v0.9" ]; then
    PIN="pin"
else
    PIN="off-pin"
fi

RUN_UTC="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
COMMIT="$(git -C "$REPO" rev-parse --short HEAD 2>/dev/null || echo unknown)"
if [ -n "$(git -C "$REPO" status --porcelain 2>/dev/null)" ]; then DIRTY=DIRTY; else DIRTY=clean; fi
HOST="$(hostname 2>/dev/null || echo unknown)"

# ---------------------------------------------------------------------
# 3. The mutex on the shared _build.  NOT optional.
# ---------------------------------------------------------------------
# The gate typechecks into the SHARED formal/cubical/_build/.  Two cycles
# at once (this script next to a `run_the_natural_machine_forever
# --supervise` loop, or two agents in one checkout — all three were live
# on 2026-08-16) write the same .agdai concurrently; Agda 2.6.3 takes no
# cross-process lock, so an interleaved write reads back as a corrupt
# interface: a FALSE fiber on a module that checks fine single-writer.
# This is the SAME lock directory the forever loop uses, deliberately, so
# the two serialise against each other rather than merely against
# themselves.  Skipping is correct behaviour, not a failure.
GATE_LOCK="$CUBICAL/_build/.gate.lock"
acquire_gate() {
    mkdir -p "$CUBICAL/_build" 2>/dev/null
    if mkdir "$GATE_LOCK" 2>/dev/null; then echo "$$" > "$GATE_LOCK/pid"; return 0; fi
    local owner
    owner=$(cat "$GATE_LOCK/pid" 2>/dev/null)
    if [ -n "$owner" ] && ! kill -0 "$owner" 2>/dev/null; then
        rm -rf "$GATE_LOCK" 2>/dev/null
        if mkdir "$GATE_LOCK" 2>/dev/null; then echo "$$" > "$GATE_LOCK/pid"; return 0; fi
    fi
    return 1
}
release_gate() {
    [ "$(cat "$GATE_LOCK/pid" 2>/dev/null)" = "$$" ] && rm -rf "$GATE_LOCK" 2>/dev/null
    [ -n "$LIBFILE" ] && rm -f "$LIBFILE"
    return 0
}

if ! acquire_gate; then
    echo "gate-record: another gate holds $GATE_LOCK (pid $(cat "$GATE_LOCK/pid" 2>/dev/null))."
    echo "Not racing the shared _build — a race produces false reds, which is"
    echo "the one thing this file exists to prevent. Nothing appended. Re-run"
    echo "when the holder is done."
    exit 3
fi
trap 'release_gate' EXIT INT TERM

# ---------------------------------------------------------------------
# 4. The watchdog.  GNU `timeout` is absent on the macOS host this
#    workspace has used; a missing watchdog must not turn every
#    mathematical check into exit 127 (`run_the_natural_machine_forever`,
#    run_checked).
# ---------------------------------------------------------------------
run_checked() {
    if command -v timeout >/dev/null 2>&1; then timeout "$TIMEOUT_SECS" "$@"
    elif command -v gtimeout >/dev/null 2>&1; then gtimeout "$TIMEOUT_SECS" "$@"
    else "$@"; fi
}

check_one() {   # check_one <relpath> ; echoes exit code
    if [ -n "$LIBFILE" ]; then
        ( cd "$CUBICAL" && run_checked "$AGDA" --library-file="$LIBFILE" "$1" ) >/dev/null 2>&1
    else
        ( cd "$CUBICAL" && run_checked "$AGDA" -i . -i theorems "$1" ) >/dev/null 2>&1
    fi
    echo $?
}

# ---------------------------------------------------------------------
# 5. The ledger.  Append-only; header once; a row is written the instant
#    its module finishes, so a run killed halfway still leaves a true
#    partial record instead of nothing.
# ---------------------------------------------------------------------
mkdir -p "$(dirname "$LEDGER")"
[ -f "$LEDGER" ] || printf 'run_utc\tcommit\tdirty\ttoolchain\tcubical\tpin\thost\tkind\tmodule\texit\tsecs\tverdict\n' > "$LEDGER"

emit() {  # emit <kind> <module> <exit> <secs> <verdict>
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
        "$RUN_UTC" "$COMMIT" "$DIRTY" "$TOOLCHAIN" "$CUB_STATE" "$PIN" "$HOST" \
        "$1" "$2" "$3" "$4" "$5" >> "$LEDGER"
}

echo "======================================================================"
echo "gate-record  run_utc=$RUN_UTC  commit=$COMMIT ($DIRTY)"
echo "  agda    : $AGDA  ($TOOLCHAIN)"
echo "  cubical : ${CUB_DIR:-<none found>}  ($CUB_STATE)"
echo "  pin     : $PIN   (BUILD.md: Agda 2.8.0 + cubical v0.9)"
echo "  host    : $HOST"
echo "  ledger  : $LEDGER"
if [ "$PIN" = "off-pin" ]; then
    echo
    echo "  *** OFF THE PIN. Rows below are recorded honestly and are real"
    echo "      exit codes, but they are evidence about THIS toolchain, not"
    echo "      about the pinned tree. This run exits nonzero regardless of"
    echo "      what Agda returns (formal/cubical/check.sh's contract)."
fi
echo "======================================================================"

GREEN=0; FIBER=0; FIBER_ENV=0; CTRL_OK=0; CTRL_FALSE_GREEN=0

while IFS= read -r m; do
    [ -n "$m" ] || continue
    t0=$SECONDS
    rc=$(check_one "$m")
    dt=$(( SECONDS - t0 ))
    k=$(kind_of "$m")
    if   [ "$rc" -eq 0 ];    then v=green;      GREEN=$((GREEN+1))
    elif [ "$rc" -ge 124 ];  then v=fiber_env;  FIBER_ENV=$((FIBER_ENV+1))
    else                          v=fiber;      FIBER=$((FIBER+1))
    fi
    emit "$k" "$m" "$rc" "$dt" "$v"
    printf '%-9s EXIT=%-4s %5ss  %s\n' "$v" "$rc" "$dt" "$m"
done < <(list_modules)

while IFS= read -r m; do
    [ -n "$m" ] || continue
    t0=$SECONDS
    rc=$(check_one "$m")
    dt=$(( SECONDS - t0 ))
    if [ "$rc" -eq 0 ]; then
        v=control-FALSE-GREEN; CTRL_FALSE_GREEN=$((CTRL_FALSE_GREEN+1))
    else
        v=control-red-as-designed; CTRL_OK=$((CTRL_OK+1))
    fi
    emit control "$m" "$rc" "$dt" "$v"
    printf '%-9s EXIT=%-4s %5ss  %s\n' "control" "$rc" "$dt" "$m"
done < <(list_controls)

# ---------------------------------------------------------------------
# 6. The Lean lane, per module, opt-in.
# ---------------------------------------------------------------------
# `lake build` alone is an aggregate, and the aggregate is exactly what
# hid 21 orphans (notes/LEAN_LANE_AUDIT.md).  `globs` in lakefile.toml
# closed the orphan hole at the root, but a whole-lane green still does
# not say which module contributed it.  Off by default because a cold
# `lake exe cache get` is ~10 GB.  Enumerated from disk, never from an
# import list.
LEAN_GREEN=0; LEAN_RED=0
if [ "${GATE_LEAN:-0}" = "1" ] && [ -d "$REPO/formal/lean/Pairfield" ]; then
    if command -v lake >/dev/null 2>&1; then
        echo "---- Lean lane (GATE_LEAN=1) ----"
        while IFS= read -r lm; do
            [ -n "$lm" ] || continue
            t0=$SECONDS
            ( cd "$REPO/formal/lean" && run_checked lake build "$lm" ) >/dev/null 2>&1
            rc=$?
            dt=$(( SECONDS - t0 ))
            if [ "$rc" -eq 0 ]; then v=green; LEAN_GREEN=$((LEAN_GREEN+1))
            elif [ "$rc" -ge 124 ]; then v=fiber_env
            else v=fiber; LEAN_RED=$((LEAN_RED+1)); fi
            emit lean "$lm" "$rc" "$dt" "$v"
            printf '%-9s EXIT=%-4s %5ss  %s\n' "$v" "$rc" "$dt" "$lm"
        done < <( cd "$REPO/formal/lean" && find Pairfield -name '*.lean' \
                  | sed 's|/|.|g; s|\.lean$||' | sort )
    else
        echo "GATE_LEAN=1 but no lake on PATH; Lean lane skipped, no rows written."
    fi
fi

# ---------------------------------------------------------------------
# 7. Summary.  The counts are a convenience; the ROWS are the record.
# ---------------------------------------------------------------------
TOTAL=$(( GREEN + FIBER + FIBER_ENV ))
echo "======================================================================"
echo "run_utc $RUN_UTC   commit $COMMIT ($DIRTY)   $TOOLCHAIN / $CUB_STATE / $PIN"
echo "  modules+aggregates invoked : $TOTAL"
echo "  green                      : $GREEN"
echo "  fiber (Agda's verdict)     : $FIBER"
echo "  fiber_env (container's)    : $FIBER_ENV"
echo "  controls red as designed   : $CTRL_OK"
echo "  controls FALSE GREEN       : $CTRL_FALSE_GREEN"
[ "${GATE_LEAN:-0}" = "1" ] && echo "  lean green / red           : $LEAN_GREEN / $LEAN_RED"
echo
echo "Per-module rows appended to $LEDGER."
echo "That file, not this console output, is the record. Quote a row."
echo "A row is an EVENT — this container, carrying this toolchain, invoked"
echo "these checks at this time and observed these exit codes. It is never"
echo "a STATE of the mathematics, and it covers only the modules named in"
echo "it (notes/BUILD_COVERAGE_IS_A_CHANNEL.md: the fibre over an observed"
echo "result has size 2^|omitted|, exactly)."
echo "======================================================================"

RC=0
[ "$FIBER" -gt 0 ] && RC=1
[ "$FIBER_ENV" -gt 0 ] && RC=1
[ "$CTRL_FALSE_GREEN" -gt 0 ] && RC=1
[ "$LEAN_RED" -gt 0 ] && RC=1
[ "$PIN" = "off-pin" ] && RC=1
exit "$RC"
