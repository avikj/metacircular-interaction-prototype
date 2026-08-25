#!/bin/sh

# run-loop-ab.sh — bounded, deterministic measurement of the MathMachine loop,
# and an A/B of two builds of it.
#
#   machine/run-loop-ab.sh [--rounds N] [--budget SECONDS] [--baseline REV]
#                          [--current-only] [--baseline-only] [--thoughts]
#                          [--memory]
#                          [--keep DIR] [--agda-home DIR] [--help]
#
# WHAT IT MEASURES.  The engine's per-round log line
#
#   round N  vocab=V size=S  terms=T normed=Nn pruned=P%  conj=C fresh=F
#            proved=Pr  known=K  Xs
#
# is parsed by KEY NAME, not by position, so the table survives new fields.
# The control-law lines FLOW / GATE / ROUTE / FLOW-HOLD / GATE-HOLD are picked
# up when present and shown as '-' when the binary predates them.
#
# THE BOUND IS A ROUND COUNT, NOT A CLOCK.  `main` never returns (the loop is
# `round1 >> loop`), so this script watches the engine's own log and stops it
# the moment round N has been written.  The engine's only source of randomness
# is `assignments`, an LCG with the literal seed 12345 (MathMachine.hs ~l.633),
# and it reads no clock, so N rounds from a fixed input is a reproducible
# object: rerunning gives the identical table except for the wall column.
# --budget is a safety net, not the bound; if it fires the table says so.
#
# WHERE IT RUNS.  The engine hardcodes the relative paths machine/machine.log,
# machine/library.txt, machine/thoughts.math and (inside kernelAccept) the Agda
# include `-i formal/cubical`.  It therefore has to run from something shaped
# like the repository root.  This script builds one per binary in a scratch
# mktemp directory -- a real `machine/` subdirectory plus a symlink to the
# repository's `formal/` -- so the run appends to a scratch machine.log and
# machine/library.txt and machine/machine.log in the repository are untouched.
#
# TWO ENVIRONMENT FACTS THAT SILENTLY FALSIFY THE MEASUREMENT, both handled
# here, both discovered by watching a run produce proved=0 for twelve rounds:
#
#   1. LC_ALL must select a UTF-8 locale.  The engine writes the Agda
#      candidate with ℕ in it; under LC_ALL=C it dies at the first candidate
#      with "withFile: invalid argument (cannot encode character '\8469')".
#   2. Agda must be able to find the cubical library from a temporary
#      directory that contains no .agda-lib.  Agda resolves that through
#      $AGDA_DIR/defaults, and this image ships ~/.agda/libraries with NO
#      defaults file -- so every candidate fails with "Failed to find source
#      of module Cubical.Foundations.Prelude", every theorem is KERNEL-REJECT,
#      the machine proves nothing and then grows because it proved nothing.
#      This script synthesises a private AGDA_DIR with a defaults file naming
#      the cubical library.  It does not touch ~/.agda.
#
# Proof acceptance is external: each surviving conjecture costs one `agda`
# process.  The trailing `Xs` in the engine's round line is getCPUTime of the
# Haskell process only, so it EXCLUDES that cost; the wall column here is what
# the round actually took.  Read the gap between them as kernel time.
#
# SEEDING.  machine/thoughts.math sets required-vocab=8, which is the whole
# vocabulary, so a seeded run starts with the Widen move unavailable and can
# only ever Deepen.  The growth chooser is therefore not exercised at all.
# The default here is the unseeded start (vocab=3, horizon=4) that produced
# machine/machine.log.gen1; --thoughts opts into the seeded one.

set -eu

fail() {
  printf 'run-loop-ab: %s\n' "$*" >&2
  exit 1
}

usage() {
  printf '%s\n' \
    'usage: run-loop-ab.sh [--rounds N] [--budget SECONDS] [--baseline REV]' \
    '                      [--current-only] [--baseline-only] [--thoughts]' \
    '                      [--memory]' \
    '                      [--keep DIR] [--agda-home DIR]' \
    '' \
    '  --rounds N       stop each binary after round N has been logged' \
    '                   (default 12, i.e. rounds 0..12)' \
    '  --budget SECONDS wall-clock safety net per binary (default 900)' \
    '  --baseline REV   git revision whose machine/MathMachine.hs is the' \
    '                   baseline build.  Default: the commit before the most' \
    '                   recent one that touched machine/MathMachine.hs.' \
    '  --current-only   measure only the working tree' \
    '  --baseline-only  measure only the baseline revision' \
    '  --thoughts       copy machine/thoughts.math into the scratch root' \
    '                   (seeds required-vocab=8; disables the Widen move)' \
    '  --memory         copy machine/library.terms in as startup memory' \
    '                   (only newer builds read it; off by default so that' \
    '                    an A/B is not measuring the seed)' \
    '  --baseline-args FLAGS' \
    '  --current-args FLAGS' \
    '                   engine flags for that arm.  parseDispatch ignores' \
    '                   unknown flags, so this also works against an older' \
    '                   baseline binary.  With --baseline REV omitted and' \
    '                   both arms built from the same source, the two arms' \
    '                   are ONE BINARY differing in these flags alone --' \
    '                   the tightest single-factor control available.' \
    '  --baseline-variant old-flow' \
    '                   build the baseline from the CURRENT source with the' \
    '                   growth trigger reverted to the pre-KFlow boolean.' \
    '                   Isolates the control law with everything else held' \
    '                   fixed -- the cell of the design that is not a commit.' \
    '  --keep DIR       copy raw logs and binaries into DIR before cleanup' \
    '  --agda-home DIR  use DIR as AGDA_DIR instead of synthesising one'
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "required command not found: $1"
}

script_directory=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repository_directory=$(CDPATH= cd -- "$script_directory/.." && pwd)

rounds=12
budget=900
baseline_rev=
run_baseline=yes
run_current=yes
use_thoughts=no
use_memory=no
baseline_variant=
baseline_args=
current_args=
keep_directory=
agda_home=

while [ "$#" -gt 0 ]; do
  case "$1" in
    --rounds)
      [ "$#" -ge 2 ] || fail '--rounds needs an argument'
      rounds=$2; shift 2 ;;
    --budget)
      [ "$#" -ge 2 ] || fail '--budget needs an argument'
      budget=$2; shift 2 ;;
    --baseline)
      [ "$#" -ge 2 ] || fail '--baseline needs an argument'
      baseline_rev=$2; shift 2 ;;
    --current-only) run_baseline=no; shift ;;
    --baseline-only) run_current=no; shift ;;
    --thoughts) use_thoughts=yes; shift ;;
    --memory) use_memory=yes; shift ;;
    --baseline-args)
      [ "$#" -ge 2 ] || fail '--baseline-args needs an argument'
      baseline_args=$2; shift 2 ;;
    --current-args)
      [ "$#" -ge 2 ] || fail '--current-args needs an argument'
      current_args=$2; shift 2 ;;
    --baseline-variant)
      [ "$#" -ge 2 ] || fail '--baseline-variant needs an argument'
      baseline_variant=$2; shift 2 ;;
    --keep)
      [ "$#" -ge 2 ] || fail '--keep needs an argument'
      keep_directory=$2; shift 2 ;;
    --agda-home)
      [ "$#" -ge 2 ] || fail '--agda-home needs an argument'
      agda_home=$2; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; fail "unrecognised argument: $1" ;;
  esac
done

case "$rounds" in ''|*[!0-9]*) fail "rounds must be a whole number: $rounds" ;; esac
case "$budget" in ''|*[!0-9]*) fail "budget must be whole seconds: $budget" ;; esac
[ "$run_baseline" = yes ] || [ "$run_current" = yes ] \
  || fail '--current-only and --baseline-only are mutually exclusive'

require_command ghc
require_command agda
require_command git
require_command mktemp
require_command awk

[ -f "$repository_directory/machine/MathMachine.hs" ] \
  || fail "missing engine source: $repository_directory/machine/MathMachine.hs"
[ -d "$repository_directory/formal/cubical" ] \
  || fail "missing Agda include root: $repository_directory/formal/cubical"

work_directory=$(mktemp -d "${TMPDIR:-/tmp}/run-loop-ab.XXXXXX")
engine_pid=
cleanup() {
  if [ -n "$engine_pid" ]; then
    kill "$engine_pid" 2>/dev/null || true
  fi
  case "$work_directory" in
    */run-loop-ab.*) rm -rf -- "$work_directory" ;;
    *) printf 'run-loop-ab: refusing unsafe cleanup target: %s\n' \
         "$work_directory" >&2 ;;
  esac
}
trap cleanup EXIT HUP INT TERM

# ------------------------------------------------------------------ locale
#
# Pick a UTF-8 locale that exists.  C.UTF-8 is built into glibc since 2.35 and
# is what machine/check-natural-machine.sh already relies on.
engine_locale=C.UTF-8

# --------------------------------------------------------------- AGDA_DIR
#
# Synthesise a private Agda home whose `defaults` names every installed
# library called cubical*.  Without it, a Candidate.agda written to a bare
# mktemp directory cannot resolve Cubical.Foundations.Prelude.
if [ -z "$agda_home" ]; then
  agda_home="$work_directory/agda-home"
  mkdir -p "$agda_home"
  : >"$agda_home/libraries"
  : >"$agda_home/defaults"
  user_libraries="${HOME:-/root}/.agda/libraries"
  if [ -f "$user_libraries" ]; then
    cat "$user_libraries" >"$agda_home/libraries"
  fi
  # Always make the repository's own library visible too.
  for candidate in "$repository_directory"/formal/cubical/*.agda-lib; do
    [ -f "$candidate" ] || continue
    grep -qxF "$candidate" "$agda_home/libraries" 2>/dev/null \
      || printf '%s\n' "$candidate" >>"$agda_home/libraries"
  done
  while IFS= read -r library_file; do
    [ -n "$library_file" ] || continue
    [ -f "$library_file" ] || continue
    library_name=$(awk '/^[ \t]*name[ \t]*:/ {
                          sub(/^[ \t]*name[ \t]*:[ \t]*/, "")
                          print $1; exit
                        }' "$library_file")
    case "$library_name" in
      cubical*) printf '%s\n' "$library_name" >>"$agda_home/defaults" ;;
    esac
  done <"$agda_home/libraries"
  if [ ! -s "$agda_home/defaults" ]; then
    printf 'run-loop-ab: warning: no cubical library found in %s;\n' \
      "$agda_home/libraries" >&2
    printf '             every candidate will be KERNEL-REJECTed and the\n' >&2
    printf '             table will show proved=0 for structural reasons.\n' >&2
  fi
fi

# ------------------------------------------------------------------ build
#
# build_engine SOURCE OUTPUT LABEL
build_engine() {
  build_source=$1
  build_output=$2
  build_label=$3
  build_objects="$work_directory/objects-$build_label"
  mkdir -p "$build_objects"
  # machine/MathMachine.hs is edited while the engine is being developed, so
  # "the working tree" is not a stable name for a measurement.  Record what
  # was actually compiled; the table means nothing without it.
  if command -v sha256sum >/dev/null 2>&1; then
    printf '==> building %s from sha256 %s\n' "$build_label" \
      "$(sha256sum "$build_source" | cut -d' ' -f1)" >&2
  fi
  printf '==> building %s\n' "$build_label" >&2
  # -i<repo>/machine so `import Certificate` resolves; harmless for baselines
  # that predate it.  -outputdir keeps every .o/.hi out of the repository, so
  # the tracked machine/MathMachine.{o,hi} are never rewritten.
  if ! ghc -O1 -i"$snapshot_include" \
       -outputdir "$build_objects" -o "$build_output" "$build_source" \
       >"$work_directory/build-$build_label.log" 2>&1; then
    sed 's/^/      | /' "$work_directory/build-$build_label.log" >&2
    fail "build failed: $build_label"
  fi
}

# prepare_root DIR — a minimal repository-shaped working directory.
prepare_root() {
  root=$1
  mkdir -p "$root/machine"
  ln -s "$repository_directory/formal" "$root/formal"
  if [ "$use_thoughts" = yes ]; then
    [ -f "$repository_directory/machine/thoughts.math" ] \
      || fail 'missing machine/thoughts.math'
    cp "$repository_directory/machine/thoughts.math" "$root/machine/"
  fi
  # machine/library.terms is the engine's own memory, re-admitted through the
  # gate at startup.  It is OFF by default: a binary that predates the memory
  # feature ignores the file, so seeding it would hand the newer build a set
  # of theorems the older one cannot see, and the A/B would be measuring the
  # seed.  Both builds start from nothing unless --memory says otherwise.
  if [ "$use_memory" = yes ]; then
    [ -f "$repository_directory/machine/library.terms" ] \
      || fail 'missing machine/library.terms'
    cp "$repository_directory/machine/library.terms" "$root/machine/"
  fi
}

now_seconds() {
  date +%s.%N
}

# run_bounded BIN ROOT LABEL — run until round $rounds is logged, or the
# budget expires, or the engine dies.  Writes ROOT/stamps (one wall timestamp
# per observed round line) and ROOT/status.
run_bounded() {
  bin=$1
  root=$2
  label=$3
  engine_args=$4
  log="$root/machine/machine.log"
  stamps="$root/stamps"
  : >"$stamps"
  printf '==> running %s for rounds 0..%s (budget %ss)\n' \
    "$label" "$rounds" "$budget" >&2
  start=$(now_seconds)
  printf '%s\n' "$start" >"$root/start"
  (
    cd "$root" || exit 127
    # ENGINE ARGUMENTS.  Unquoted on purpose: the caller supplies a
    # whitespace-separated flag list, and the engine's `parseDispatch`
    # ignores any flag it does not know, so passing a newer flag to an
    # older baseline binary is a no-op rather than an error.  That is
    # what makes a SAME-BINARY A/B possible: one build, two flag sets,
    # and exactly one bit of behaviour between them.
    # shellcheck disable=SC2086
    AGDA_DIR="$agda_home" LC_ALL="$engine_locale" exec "$bin" $engine_args
  ) >"$root/stdout.log" 2>&1 &
  engine_pid=$!
  seen=0
  status=budget-exhausted
  while :; do
    observed=0
    if [ -f "$log" ]; then
      observed=$(grep -c '^round ' "$log" 2>/dev/null || true)
      [ -n "$observed" ] || observed=0
    fi
    while [ "$seen" -lt "$observed" ]; do
      seen=$((seen + 1))
      now_seconds >>"$stamps"
    done
    if [ "$seen" -gt "$rounds" ]; then
      status=rounds-reached
      break
    fi
    if ! kill -0 "$engine_pid" 2>/dev/null; then
      status=engine-exited
      break
    fi
    elapsed=$(awk -v a="$(now_seconds)" -v b="$start" 'BEGIN{printf "%d", a-b}')
    if [ "$elapsed" -ge "$budget" ]; then
      status=budget-exhausted
      break
    fi
    sleep 0.1
  done
  kill "$engine_pid" 2>/dev/null || true
  wait "$engine_pid" 2>/dev/null || true
  engine_pid=
  printf '%s\n' "$status" >"$root/status"
  if [ "$status" = engine-exited ] && [ -s "$root/stdout.log" ]; then
    printf 'run-loop-ab: %s died; its stdout follows\n' "$label" >&2
    sed 's/^/      | /' "$root/stdout.log" >&2
  fi
}

# ------------------------------------------------------------------ parse
#
# summarise LOG STAMPS START > TSV
# One record per round:
#   round vocab size terms normed pruned conj fresh proved known cpu wall
#   flow gate route grow
cat >"$work_directory/summarise.awk" <<'AWK'
function flush() {
  if (round_index < 0) return
  printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
    rnd, vocab, size, terms, normed, pruned, conj, fresh, proved, known,
    cpu, wall[round_index + 1], flow, gate, route, grow, assign
}
BEGIN { round_index = -1; FS = "[ \t]+" }
{
  line = $0
  sub(/^[ \t]+/, "", line)
  n = split(line, tok, /[ \t]+/)
  # The round line is the only unindented one; everything else the engine
  # writes is indented by two spaces, and Agda's rejection text is echoed
  # verbatim inside KERNEL-REJECT, so anchoring at column 1 is what keeps a
  # stray "round" in that text out of the table.
  if ($0 ~ /^round[ \t]/) {
    flush()
    round_index++
    rnd = tok[2]
    vocab = size = terms = normed = pruned = "-"
    conj = fresh = proved = known = "-"
    cpu = "-"
    flow = gate = route = grow = assign = "-"
    for (i = 3; i <= n; i++) {
      t = tok[i]
      p = index(t, "=")
      if (p > 0) {
        k = substr(t, 1, p - 1)
        v = substr(t, p + 1)
        sub(/%$/, "", v)
        if (k == "vocab") vocab = v
        else if (k == "size") size = v
        else if (k == "terms") terms = v
        else if (k == "normed") normed = v
        else if (k == "pruned") pruned = v
        else if (k == "conj") conj = v
        else if (k == "fresh") fresh = v
        else if (k == "proved") proved = v
        else if (k == "known") known = v
      } else if (t ~ /^[0-9.]+s$/) {
        cpu = substr(t, 1, length(t) - 1)
      }
    }
    next
  }
  if (round_index < 0) next
  if (tok[1] == "FLOW") flow = tok[2]
  else if (tok[1] == "FLOW-HOLD") flow = (flow == "-" ? "hold" : flow "/hold")
  else if (tok[1] == "GATE") {
    # gateName renders a refusal as "refused: <reason>", so the verdict is
    # not a single token.  Normalise it, and pick up assignments= as its own
    # column: mAssign is engine state now (a refusal doubles it, capped at
    # 8*kAssign), so the test-set size is no longer a constant to assume.
    gate = (tok[2] ~ /^refused/) ? "refused" : tok[2]
    for (i = 2; i <= n; i++) {
      p = index(tok[i], "=")
      if (p > 0 && substr(tok[i], 1, p - 1) == "assignments")
        assign = substr(tok[i], p + 1)
    }
  }
  else if (tok[1] == "GATE-HOLD") gate = (gate == "-" ? "hold" : gate "/hold")
  else if (tok[1] == "ROUTE") route = tok[2]
  else if (tok[1] == "GROW") {
    if (line ~ /vocabulary widens/) grow = (grow == "-" ? "widen" : grow ",widen")
    else if (line ~ /size horizon rises/) grow = (grow == "-" ? "deepen" : grow ",deepen")
    else grow = "other"
  }
}
END { flush() }
AWK

# Per-round wall seconds are the differences of the observed stamps.  The
# poller samples at 0.1s, so each figure carries about +/-0.1s; rounds that
# cost less than that read as 0.00 and the totals are unaffected.
summarise() {
  log=$1
  stamps=$2
  start=$3
  awk -v start="$start" '
    BEGIN { prev = start; i = 0 }
    { i++; w[i] = $1 - prev; prev = $1 }
    END { for (j = 1; j <= i; j++) printf "%.2f\n", w[j] }
  ' "$stamps" >"$work_directory/walls.txt"
  # The engine can log one more round between the poll that trips the bound
  # and the kill; the table is truncated to the requested budget so that the
  # two binaries are always compared over the same rounds.
  awk -v wallfile="$work_directory/walls.txt" \
      -f "$work_directory/prelude.awk" \
      -f "$work_directory/summarise.awk" "$log" \
    | awk -v want=$((rounds + 1)) 'NR <= want'
}

cat >"$work_directory/prelude.awk" <<'AWK'
BEGIN {
  k = 0
  while ((getline w < wallfile) > 0) { k++; wall[k] = w }
  close(wallfile)
  for (j = 1; j <= k; j++) if (wall[j] == "") wall[j] = "-"
}
AWK

# ------------------------------------------------------------------ table
print_table() {
  tsv=$1
  label=$2
  status=$3
  printf '\n== %s ==  (stop reason: %s)\n' "$label" "$status"
  awk -F'\t' '
    BEGIN {
      printf "%5s %5s %4s %9s %8s %8s %7s %6s %5s %7s %7s %6s  %-14s %-9s %-7s %s\n",
        "round","vocab","size","terms","pruned%","conj","fresh","proved",
        "cum","cpu_s","wall_s","assign","flow","gate","route","grow"
    }
    {
      printf "%5s %5s %4s %9s %8s %8s %7s %6s %5s %7s %7s %6s  %-14s %-9s %-7s %s\n",
        $1,$2,$3,$4,$6,$7,$8,$9,$10,$11,$12,$17,$13,$14,$15,$16
    }
  ' "$tsv"
  awk -F'\t' '
    {
      n++
      cum = $10
      cpu += $11
      wall += $12
      pruned_sum += $6
      if ($9 == 0) { stuck++; run++; if (run > longest) longest = run } else run = 0
      if ($13 != "-" || $14 != "-" || $15 != "-") control++
      if ($14 ~ /refused/) refusals++
      if ($15 != "-") routes++
      if ($17 != "-") {
        if (assign_lo == "" || $17 + 0 < assign_lo) assign_lo = $17 + 0
        if (assign_hi == "" || $17 + 0 > assign_hi) assign_hi = $17 + 0
      }
      if (first_pruned == "") first_pruned = $6
      last_pruned = $6
    }
    END {
      if (n == 0) { print "  (no rounds observed)"; exit }
      printf "  rounds=%d  theorems=%s  theorems/round=%.3f", n, cum, cum / n
      if (wall > 0) printf "  theorems/wall-s=%.4f", cum / wall
      printf "\n"
      printf "  cpu=%.2fs  wall=%.2fs  kernel-and-io=%.2fs (%.0f%% of wall)\n",
        cpu, wall, wall - cpu, (wall > 0 ? 100 * (wall - cpu) / wall : 0)
      printf "  pruned%% %s -> %s  mean=%.1f   rounds stuck (proved=0)=%d  longest stuck run=%d\n",
        first_pruned, last_pruned, pruned_sum / n, stuck + 0, longest + 0
      printf "  rounds carrying FLOW/GATE/ROUTE lines=%d  GATE refusals=%d  ROUTE firings=%d\n",
        control + 0, refusals + 0, routes + 0
      if (assign_lo != "")
        printf "  assignments %d -> %d%s\n", assign_lo, assign_hi,
          (assign_lo == assign_hi ? "  (constant)" : "  (moved: mAssign is state)")
    }
  ' "$tsv"
}

# ------------------------------------------------------------ measurement
# THE SNAPSHOT, and why it is not paranoia.  This repository is worked by
# many agents on one machine, and machine/MathMachine.hs is edited while it
# is being measured -- which this script's own build banner was already
# written to cope with, by printing the sha256 of what it compiled.
#
# Printing the hash is not enough once the two ARMS are built at different
# times.  `--baseline-variant same` cuts the baseline from the source at
# script start and the current arm compiles it again after the baseline has
# finished running, which on a seeded run is half an hour later.  An edit
# landing in that window silently turns a single-factor A/B into a
# two-factor one, and the table gives no sign of it beyond two hashes that
# a reader has to notice differ.  Observed on 2026-08-20: a concurrent
# agent added a self-test path and changed a constructor arity between the
# two builds of one arm.
#
# So the source is COPIED ONCE, here, and both arms are built from the
# copy.  The run then measures one program whatever else happens to the
# tree, and the hash printed is the hash of what ran.
#
# The IMPORTS are snapshotted too, and for the same reason: the concurrent
# edit observed on 2026-08-20 changed a constructor's arity in an imported
# module, so freezing only MathMachine.hs would have frozen half a program.
snapshot_include="$work_directory/machine-src"
mkdir -p "$snapshot_include"
cp "$repository_directory"/machine/*.hs "$snapshot_include/" 2>/dev/null || true
current_source="$snapshot_include/MathMachine.hs"


# --------------------------------------------------- synthesised baselines
#
# Some cells of the design are not any revision.  The control law and the
# certificate generator landed in separate commits, so "old control law with
# the new certificate" -- the cell that says whether the control law still
# matters once the machine can actually install theorems -- exists nowhere in
# git.  It is, however, exactly one line: the growth trigger.
#
#   6835a4e3   let stuck = null checkedResults
#   current    let stuck = flow == Resonance && null checkedResults
#
# `--baseline-variant old-flow` builds the baseline from the CURRENT source
# with that one line reverted, and nothing else touched.  The other two rules
# ride along unchanged, which is sound precisely because the tables report
# that they never bind: if a run shows a nonzero GATE refusal or ROUTE firing
# count, this variant stops being a clean single-factor control and the
# comparison must be read as three factors again.
#
# The substitution must match exactly once.  A variant that silently failed to
# apply would be a copy of the current build wearing a baseline's label, and
# would report "no difference" for the most flattering possible reason.
make_variant() {
  variant_name=$1
  variant_out=$2
  case "$variant_name" in
    old-flow)
      old_line='  let stuck = flow == Resonance && null checkedResults'
      new_line='  let stuck = null checkedResults'
      hits=$(grep -c -F -x "$old_line" "$current_source" || true)
      [ "$hits" = 1 ] \
        || fail "variant old-flow: growth trigger matched $hits times, expected 1"
      awk -v old="$old_line" -v new="$new_line" \
        '{ if ($0 == old) print new; else print }' "$current_source" >"$variant_out"
      grep -q -F -x "$new_line" "$variant_out" \
        || fail 'variant old-flow: substitution did not take'
      ;;
    # `same` is the identity.  It exists so that an A/B can hold the
    # SOURCE fixed and vary only the engine flags (--baseline-args /
    # --current-args), which is a tighter control than any pair of
    # revisions can be: the two arms are then the same program.
    same)
      cp "$current_source" "$variant_out"
      ;;
    *) fail "unknown baseline variant: $variant_name" ;;
  esac
}

if [ "$run_baseline" = yes ] && [ -n "$baseline_variant" ]; then
  baseline_source="$work_directory/VariantMathMachine.hs"
  make_variant "$baseline_variant" "$baseline_source"
  baseline_short="variant:$baseline_variant"
elif [ "$run_baseline" = yes ]; then
  if [ -z "$baseline_rev" ]; then
    baseline_rev=$(cd "$repository_directory" \
      && git log --format='%H' -- machine/MathMachine.hs | sed -n '2p')
    [ -n "$baseline_rev" ] \
      || fail 'no earlier revision of machine/MathMachine.hs to use as baseline'
  fi
  baseline_source="$work_directory/BaselineMathMachine.hs"
  (cd "$repository_directory" && git show "$baseline_rev:machine/MathMachine.hs") \
    >"$baseline_source" || fail "cannot read machine/MathMachine.hs at $baseline_rev"
  baseline_short=$(cd "$repository_directory" && git rev-parse --short "$baseline_rev")
fi

printf 'engine     : %s\n' "$current_source"
printf 'rounds     : 0..%s   budget: %ss per binary\n' "$rounds" "$budget"
printf 'seeding    : %s\n' \
  "$([ "$use_thoughts" = yes ] && echo 'machine/thoughts.math (vocab starts at 8)' \
     || echo 'none (vocab starts at 3, horizon 4)')"
printf 'AGDA_DIR   : %s\n' "$agda_home"
if [ "$run_baseline" = yes ]; then
  printf 'baseline   : %s\n' "$baseline_short"
fi

if [ "$run_baseline" = yes ]; then
  build_engine "$baseline_source" "$work_directory/engine-baseline" baseline
  prepare_root "$work_directory/root-baseline"
  run_bounded "$work_directory/engine-baseline" "$work_directory/root-baseline" \
    "baseline $baseline_short" "$baseline_args"
  summarise "$work_directory/root-baseline/machine/machine.log" \
    "$work_directory/root-baseline/stamps" \
    "$(cat "$work_directory/root-baseline/start")" \
    >"$work_directory/baseline.tsv"
fi

if [ "$run_current" = yes ]; then
  build_engine "$current_source" "$work_directory/engine-current" current
  prepare_root "$work_directory/root-current"
  run_bounded "$work_directory/engine-current" "$work_directory/root-current" \
    'current worktree' "$current_args"
  summarise "$work_directory/root-current/machine/machine.log" \
    "$work_directory/root-current/stamps" \
    "$(cat "$work_directory/root-current/start")" \
    >"$work_directory/current.tsv"
fi

if [ "$run_baseline" = yes ]; then
  print_table "$work_directory/baseline.tsv" "baseline $baseline_short" \
    "$(cat "$work_directory/root-baseline/status")"
fi
if [ "$run_current" = yes ]; then
  print_table "$work_directory/current.tsv" 'current worktree' \
    "$(cat "$work_directory/root-current/status")"
fi

if [ "$run_baseline" = yes ] && [ "$run_current" = yes ]; then
  printf '\n== deltas (baseline %s -> current worktree) ==\n' "$baseline_short"
  awk -v base="$work_directory/baseline.tsv" -v cur="$work_directory/current.tsv" '
    function stats(file, which,   n, line, f, run) {
      n = 0
      while ((getline line < file) > 0) {
        split(line, f, "\t")
        n++
        R[which, n] = f[1]; V[which, n] = f[2]; S[which, n] = f[3]
        cum[which] = f[10]
        cpu[which] += f[11]; wall[which] += f[12]
        pr[which] += f[6]
        if (f[9] == 0) {
          stuck[which]++; run++
          if (run > longest[which]) longest[which] = run
        } else run = 0
        if (f[14] ~ /refused/) refusals[which]++
        if (f[15] != "-") routes[which]++
        P[which, n] = f[6]
        T[which, n] = f[10]
      }
      close(file)
      N[which] = n
      return n
    }
    function row(name, a, b,   d) {
      d = b - a
      printf "  %-28s %10.3f %10.3f %+10.3f\n", name, a, b, d
    }
    BEGIN {
      stats(base, "b"); stats(cur, "c")
      printf "  %-28s %10s %10s %10s\n", "metric", "baseline", "current", "delta"
      row("rounds completed", N["b"], N["c"])
      row("theorems (cumulative)", cum["b"], cum["c"])
      row("theorems / round", N["b"] ? cum["b"]/N["b"] : 0, N["c"] ? cum["c"]/N["c"] : 0)
      row("theorems / wall second", wall["b"] ? cum["b"]/wall["b"] : 0,
                                    wall["c"] ? cum["c"]/wall["c"] : 0)
      row("mean pruned%", N["b"] ? pr["b"]/N["b"] : 0, N["c"] ? pr["c"]/N["c"] : 0)
      row("rounds stuck (proved=0)", stuck["b"]+0, stuck["c"]+0)
      row("longest stuck run", longest["b"]+0, longest["c"]+0)
      row("wall seconds total", wall["b"], wall["c"])
      row("engine cpu seconds total", cpu["b"], cpu["c"])
      row("GATE refusals", refusals["b"]+0, refusals["c"]+0)
      row("ROUTE firings", routes["b"]+0, routes["c"]+0)
      m = (N["b"] < N["c"] ? N["b"] : N["c"])
      # The two trajectories the control law is supposed to move, round by
      # round, rather than collapsed into a mean that can hide a crossover.
      printf "\n  %-7s %10s %10s   %10s %10s\n",
        "round", "pruned% b", "pruned% c", "theorems b", "theorems c"
      for (i = 1; i <= m; i++)
        printf "  %-7s %10s %10s   %10s %10s\n",
          R["b", i], P["b", i], P["c", i], T["b", i], T["c", i]
      div = ""
      for (i = 1; i <= m; i++) {
        if (V["b", i] != V["c", i] || S["b", i] != S["c", i]) {
          div = sprintf("round %s: baseline (vocab %s, size %s) vs current (vocab %s, size %s)",
                        R["b", i], V["b", i], S["b", i], V["c", i], S["c", i])
          break
        }
      }
      if (div == "")
        printf "\n  first divergence in (vocab,size): none within %d common rounds\n", m
      else
        printf "\n  first divergence in (vocab,size): %s\n", div
    }
  ' </dev/null
fi

if [ -n "$keep_directory" ]; then
  mkdir -p "$keep_directory"
  for label in baseline current; do
    [ -f "$work_directory/$label.tsv" ] || continue
    cp "$work_directory/$label.tsv" "$keep_directory/$label.tsv"
    cp "$work_directory/root-$label/machine/machine.log" \
       "$keep_directory/$label.machine.log" 2>/dev/null || true
    cp "$work_directory/root-$label/stdout.log" \
       "$keep_directory/$label.stdout.log" 2>/dev/null || true
    cp "$work_directory/root-$label/machine/library.txt" \
       "$keep_directory/$label.library.txt" 2>/dev/null || true
  done
  printf '\nraw logs kept in %s\n' "$keep_directory"
fi

printf '\nLOOP MEASURED\n'
