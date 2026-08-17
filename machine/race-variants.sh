#!/bin/sh

# race-variants.sh -- race MathMachine knob settings against each other and
# print a table.
#
#   machine/race-variants.sh [options] VARIANT...
#
# A VARIANT is  NAME:key=value,key=value  (the NAME: prefix is optional; with
# no overrides at all the variant is the defaults of machine/Knobs.hs, which
# are today's engine).  Example:
#
#   machine/race-variants.sh --rounds 12 \
#     baseline: \
#     'wide:kVars=4' \
#     'deep:kSizeCap=10' \
#     'cheap-probe:kProbe=100,kAssign=20'
#
# WHAT IT DOES AND DELIBERATELY DOES NOT DO.
#
# MathMachine.hs's KNOBS banner is explicit that the evolve step -- mutate
# source, compile variant, race it, exec the winner -- is designed and not
# built, and that describing it in the present tense is the sin this
# repository exists to stop.  This script builds the middle two verbs only.
# It compiles one binary per knob setting and measures each.  It never execs a
# winner, never edits machine/MathMachine.hs, and leaves machine/knobs.conf
# exactly as it found it (saved before the first variant, restored on exit,
# including on a signal).  The table at the end is a RECOMMENDATION addressed
# to a person, or to a later step that a person has gated.  Selection with
# nobody in the loop is out of scope on purpose.
#
# WHERE IT RUNS.  Every variant runs with the repository root as its working
# directory, because `kernelAccept` shells out to `agda -i formal/cubical`,
# and that is a relative path: run the engine anywhere else and every
# candidate is rejected, every variant scores zero, and the table reports a
# tie that is really an empty measurement.
#
# THREE ENVIRONMENT FACTS THAT SILENTLY ZERO THE PRIMARY METRIC.  All three
# produce the same symptom -- known=0 for every variant -- and none of them is
# about knobs:
#
#   1. LC_ALL must name a UTF-8 locale.  The engine writes an Agda candidate
#      containing the character N-with-double-bar; under LC_ALL=C it dies with
#      "cannot encode character '\8469'".  This script exports C.UTF-8.
#   2. Agda must be able to resolve Cubical.Foundations.Prelude from a bare
#      mktemp directory that contains no .agda-lib.  It does that through
#      $AGDA_DIR/defaults, and this image ships ~/.agda/libraries with NO
#      defaults file, so out of the box EVERY candidate fails with "Failed to
#      find source of module Cubical.Foundations.Prelude".  This script
#      synthesises a private AGDA_DIR naming every installed cubical* library
#      and does not touch ~/.agda.  (Verified: with the synthesised home the
#      engine's own --kernel-self-test accepts 0+x = x and rejects s(x) = x;
#      without it, it rejects both.)
#   3. The kernel gate certifies by `refl` over {0, s, +, *} only, so an
#      equation needing induction is KERNEL-REJECTed however good the knobs
#      are.  This one is real mathematics, not environment, and it caps what
#      the primary metric can ever show.
#
# The kernel preflight below reports which of these is in force before any
# variant runs, so a degenerate table is never mistaken for a result.
#
# WHAT THE TABLE CAN AND CANNOT CONTAIN.  --smoke-rounds is the fixed-budget
# entry point, and `runSmokeMachine` hands the round logger /dev/null for both
# its handles.  So the engine's rich per-round line -- terms=, normed=,
# pruned=, conj=, fresh= -- is not observable here at any price; the only
# thing that reaches stdout is
#
#   MACHINE SMOKE CHECKED: rounds= known= rules= lemmas= vocab= horizon=
#
# which this script parses BY KEY NAME, not by position, so the table survives
# new fields.  For terms explored and pruned%, the tool is machine/run-loop-ab.sh,
# which runs the unbounded loop in a scratch root and parses a real log.
#
# Conventions follow machine/check-natural-machine.sh: POSIX sh, set -eu,
# --help, mktemp plus trap, repository root taken from the script's own path.

set -eu

fail() {
  printf 'race-variants: %s\n' "$*" >&2
  exit 1
}

usage() {
  printf '%s\n' \
    'usage: race-variants.sh [options] VARIANT...' \
    '' \
    '  VARIANT            NAME:key=value,key=value  (NAME: optional; an empty' \
    '                     override list means the machine/Knobs.hs defaults)' \
    '' \
    '  --rounds N         --smoke-rounds budget per variant (default 12)' \
    '  --timeout SECONDS  wall-clock cap per variant (default 900)' \
    '  --engine SOURCE    engine to build (default machine/MathMachine.hs).' \
    '                     The file is snapshotted once so every variant' \
    '                     compiles identical text even while it is edited;' \
    '                     sibling modules come live from machine/.' \
    '  --agda-home DIR    use DIR as AGDA_DIR instead of synthesising one' \
    '  --keep DIR         copy confs, binaries and raw output into DIR' \
    '  --dry-run          validate the variants and print their knob files,' \
    '                     then stop without building or running anything' \
    '  -h, --help         this text'
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "required command not found: $1"
}

script_directory=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repository_directory=$(CDPATH= cd -- "$script_directory/.." && pwd)

rounds=12
run_timeout=900
engine_source="$repository_directory/machine/MathMachine.hs"
agda_home=
keep_directory=
dry_run=no

while [ "$#" -gt 0 ]; do
  case "$1" in
    --rounds)
      [ "$#" -ge 2 ] || fail '--rounds needs an argument'
      rounds=$2; shift 2 ;;
    --timeout)
      [ "$#" -ge 2 ] || fail '--timeout needs an argument'
      run_timeout=$2; shift 2 ;;
    --engine)
      [ "$#" -ge 2 ] || fail '--engine needs an argument'
      engine_source=$2; shift 2 ;;
    --agda-home)
      [ "$#" -ge 2 ] || fail '--agda-home needs an argument'
      agda_home=$2; shift 2 ;;
    --keep)
      [ "$#" -ge 2 ] || fail '--keep needs an argument'
      keep_directory=$2; shift 2 ;;
    --dry-run) dry_run=yes; shift ;;
    -h|--help) usage; exit 0 ;;
    --*) usage >&2; fail "unrecognised option: $1" ;;
    *) break ;;
  esac
done

case "$rounds" in ''|*[!0-9]*) fail "rounds must be a whole number: $rounds" ;; esac
case "$run_timeout" in
  ''|*[!0-9]*) fail "timeout must be whole seconds: $run_timeout" ;;
esac
[ "$#" -ge 1 ] || { usage >&2; fail 'name at least one variant'; }
[ "$#" -ge 2 ] || printf 'race-variants: note: one variant is not a race.\n' >&2

require_command ghc
require_command agda
require_command mktemp
require_command awk
require_command timeout
require_command date
require_command cmp

[ -f "$engine_source" ] || fail "missing engine source: $engine_source"
knobs_source="$repository_directory/machine/Knobs.hs"
[ -f "$knobs_source" ] || fail "missing knob module: $knobs_source"
[ -d "$repository_directory/formal/cubical" ] \
  || fail "missing Agda include root: $repository_directory/formal/cubical"

# ------------------------------------------------------------ scratch + trap

work_directory=$(mktemp -d "${TMPDIR:-/tmp}/race-variants.XXXXXX")
knobs_target="$repository_directory/machine/knobs.conf"
knobs_backup="$work_directory/knobs.conf.pre-existing"
knobs_origin=unknown        # unknown | saved | absent
knobs_installed=            # the conf this script last copied into place

# Sampled ONCE, before the first variant.  Re-sampling per variant looks
# tidier and is a trap: a collaborator who creates machine/knobs.conf while a
# variant is running would have it recorded as "was absent" and then deleted.
# That happened during this script's own first outing.
save_repository_knobs() {
  [ "$knobs_origin" = unknown ] || return 0
  if [ -f "$knobs_target" ]; then
    cp "$knobs_target" "$knobs_backup"
    knobs_origin=saved
  else
    knobs_origin=absent
  fi
}

# Idempotent, and it refuses to touch a file it did not write.  If what is at
# machine/knobs.conf right now is not byte-for-byte the conf this script
# installed, somebody else put it there while we were running: say so and
# leave it.  Losing a collaborator's file is a worse failure than leaving a
# stale one, and this script's own knob file is reproducible in one command.
restore_repository_knobs() {
  [ -n "$knobs_installed" ] || return 0
  if [ -f "$knobs_target" ] && ! cmp -s "$knobs_target" "$knobs_installed"; then
    printf 'race-variants: %s changed under us; leaving it alone.\n' \
      "$knobs_target" >&2
    printf '               The pre-race copy is at %s.\n' "$knobs_backup" >&2
    knobs_installed=
    return 0
  fi
  case "$knobs_origin" in
    saved)  cp "$knobs_backup" "$knobs_target" ;;
    absent) rm -f "$knobs_target" ;;
  esac
  knobs_installed=
}

cleanup() {
  restore_repository_knobs
  case "$work_directory" in
    */race-variants.*) rm -rf -- "$work_directory" ;;
    *) printf 'race-variants: refusing unsafe cleanup target: %s\n' \
         "$work_directory" >&2 ;;
  esac
}
trap cleanup EXIT HUP INT TERM

# The engine source is read ONCE.  A race whose arms compile different text
# because somebody saved the file halfway through is not a race.  This covers
# the engine FILE only: its sibling modules (Certificate, and whatever else it
# grows) are compiled live from machine/, because pinning those would mean
# racing a snapshot of a codebase rather than the codebase.  A run started
# while a sibling is mid-edit fails at the preflight build and says so.
engine_snapshot="$work_directory/EngineSnapshot.hs"
cp "$engine_source" "$engine_snapshot"
# Snapshot the knob module beside it, and put the work directory on GHC's
# search path, so that an engine which DOES import Knobs compiles here.
cp "$knobs_source" "$work_directory/Knobs.hs"

# Is the engine actually reading knob files yet?  If it is not, every binary
# below is byte-identical whatever the conf says, and the table measures
# nothing but run-to-run variance.  That has to be said at the top of the
# output, not discovered by a reader.
if grep -Eq '^[[:space:]]*import[[:space:]]+(qualified[[:space:]]+)?Knobs([[:space:]]|\(|$)' \
     "$engine_snapshot"; then
  engine_wired=yes
else
  engine_wired=no
fi

# ------------------------------------------------------------------- locale
#
# C.UTF-8 is built into glibc since 2.35 and is what
# machine/check-natural-machine.sh already relies on.
engine_locale=C.UTF-8

# ----------------------------------------------------------------- AGDA_DIR

if [ -z "$agda_home" ]; then
  agda_home="$work_directory/agda-home"
  mkdir -p "$agda_home"
  : >"$agda_home/libraries"
  : >"$agda_home/defaults"
  user_libraries="${HOME:-/root}/.agda/libraries"
  if [ -f "$user_libraries" ]; then
    cat "$user_libraries" >"$agda_home/libraries"
  fi
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
fi

# --------------------------------------------------------- the knob checker
#
# Variant knob files are validated by machine/Knobs.hs itself, not by this
# script.  There is exactly one place that knows the ranges, and it is the one
# with the self-test.
printf '==> building the knob checker\n' >&2
knobs_binary="$work_directory/knobs"
if ! ghc -O0 -main-is Knobs -outputdir "$work_directory/knobs-objects" \
     -o "$knobs_binary" "$knobs_source" >"$work_directory/knobs-build.log" 2>&1
then
  sed 's/^/      | /' "$work_directory/knobs-build.log" >&2
  fail 'machine/Knobs.hs does not build'
fi
if ! LC_ALL="$engine_locale" "$knobs_binary" --self-test \
     >"$work_directory/knobs-selftest.log" 2>&1
then
  sed 's/^/      | /' "$work_directory/knobs-selftest.log" >&2
  fail 'machine/Knobs.hs fails its own self-test; refusing to race'
fi

# ------------------------------------------------------------ the variants

variant_count=0
variants_file="$work_directory/variants"
: >"$variants_file"

while [ "$#" -gt 0 ]; do
  variant_argument=$1
  shift
  case "$variant_argument" in
    *:*)
      variant_name=${variant_argument%%:*}
      variant_overrides=${variant_argument#*:} ;;
    *)
      variant_name=
      variant_overrides=$variant_argument ;;
  esac
  variant_count=$((variant_count + 1))
  [ -n "$variant_name" ] || variant_name="v$variant_count"
  case "$variant_name" in
    *[!A-Za-z0-9_.-]*) fail "variant name has an unusable character: $variant_name" ;;
  esac
  if grep -q "^$variant_name	" "$variants_file" 2>/dev/null; then
    fail "two variants are both called $variant_name"
  fi

  variant_conf="$work_directory/$variant_name.conf"
  : >"$variant_conf"
  printf '# variant %s\n' "$variant_name" >>"$variant_conf"
  saved_ifs=$IFS
  IFS=,
  for pair in $variant_overrides; do
    [ -n "$pair" ] || continue
    case "$pair" in
      *=*) ;;
      *) IFS=$saved_ifs; fail "variant $variant_name: expected key=value, got: $pair" ;;
    esac
    printf '%s = %s\n' "${pair%%=*}" "${pair#*=}" >>"$variant_conf"
  done
  IFS=$saved_ifs

  # Validation is a hard stop for the whole race.  A knob file the engine
  # would refuse must not quietly become a zero row that reads like a result.
  if ! LC_ALL="$engine_locale" "$knobs_binary" --check "$variant_conf" \
       >"$variant_conf.canonical" 2>"$variant_conf.error"
  then
    sed 's/^/      | /' "$variant_conf.error" >&2
    fail "variant $variant_name has an invalid knob setting"
  fi

  [ -n "$variant_overrides" ] || variant_overrides=defaults
  printf '%s\t%s\n' "$variant_name" "$variant_overrides" >>"$variants_file"
done

if [ "$dry_run" = yes ]; then
  printf '==> dry run: %s variant(s) validated, nothing built or run\n' \
    "$variant_count" >&2
  while IFS='	' read -r variant_name variant_overrides; do
    printf '\n--- %s  (%s)\n' "$variant_name" "$variant_overrides"
    cat "$work_directory/$variant_name.conf"
  done <"$variants_file"
  exit 0
fi

# ------------------------------------------------------------------- build

build_variant() {
  build_label=$1
  build_output="$work_directory/engine-$build_label"
  build_objects="$work_directory/objects-$build_label"
  mkdir -p "$build_objects"
  if ! ghc -O1 -i"$work_directory" -i"$repository_directory/machine" \
       -outputdir "$build_objects" -o "$build_output" "$engine_snapshot" \
       >"$work_directory/build-$build_label.log" 2>&1
  then
    sed 's/^/      | /' "$work_directory/build-$build_label.log" >&2
    return 1
  fi
  return 0
}

# --------------------------------------------------------- kernel preflight
#
# Two Agda calls, before any variant runs.  The engine's own --kernel-self-test
# accepts the refl-provable 0+x = x and rejects s(x) = x.  If the positive
# control fails, the kernel gate is dead for an environment reason and EVERY
# variant will score known=0 -- a tie that is not about knobs.
printf '==> building the preflight engine\n' >&2
build_variant preflight || fail 'the engine source does not build'
kernel_state=unknown
if (
     cd "$repository_directory" \
       && AGDA_DIR="$agda_home" LC_ALL="$engine_locale" \
          timeout "$run_timeout" "$work_directory/engine-preflight" \
          --kernel-self-test
   ) >"$work_directory/kernel-preflight.log" 2>&1
then
  kernel_state=live
else
  kernel_state=dead
fi

# --------------------------------------------------------------- the runs

results_file="$work_directory/results"
: >"$results_file"

# smoke_field KEY FILE -- read one key from the engine's smoke line by NAME,
# so a new field in that line does not shift a column here.
smoke_field() {
  awk -v key="$1" '
    /MACHINE SMOKE CHECKED/ {
      for (i = 1; i <= NF; i++)
        if (split($i, kv, "=") == 2 && kv[1] == key) { value = kv[2]; found = 1 }
    }
    END { print (found ? value : "-") }' "$2"
}

save_repository_knobs

while IFS='	' read -r variant_name variant_overrides; do
  printf '==> %s: building\n' "$variant_name" >&2
  if ! build_variant "$variant_name"; then
    printf '%s\t%s\t-\t-\t-\t-\t-\t-\t-\tbuild-failed\n' \
      "$variant_name" "$variant_overrides" >>"$results_file"
    continue
  fi

  # The engine reads machine/knobs.conf relative to its working directory, and
  # its working directory has to be the repository root (see the header), so
  # the variant's knob file goes to the canonical path.  It is restored by the
  # trap whatever happens next.
  knobs_installed="$work_directory/$variant_name.conf.canonical"
  cp "$knobs_installed" "$knobs_target"

  printf '==> %s: %s rounds (timeout %ss)\n' \
    "$variant_name" "$rounds" "$run_timeout" >&2
  run_output="$work_directory/run-$variant_name.log"
  run_status=ok
  started=$(date +%s.%N)
  if ! (
         cd "$repository_directory" \
           && AGDA_DIR="$agda_home" LC_ALL="$engine_locale" \
              timeout "$run_timeout" "$work_directory/engine-$variant_name" \
              --smoke-rounds "$rounds"
       ) >"$run_output" 2>&1
  then
    run_status=engine-failed
  fi
  finished=$(date +%s.%N)
  wall=$(awk -v a="$finished" -v b="$started" 'BEGIN { printf "%.1f", a - b }')

  if ! grep -q 'MACHINE SMOKE CHECKED' "$run_output"; then
    [ "$run_status" = ok ] && run_status=no-summary
    printf 'race-variants: %s produced no summary line; its output follows\n' \
      "$variant_name" >&2
    sed 's/^/      | /' "$run_output" >&2
  fi

  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$variant_name" "$variant_overrides" \
    "$(smoke_field rounds "$run_output")" \
    "$(smoke_field known "$run_output")" \
    "$(smoke_field rules "$run_output")" \
    "$(smoke_field lemmas "$run_output")" \
    "$(smoke_field vocab "$run_output")" \
    "$(smoke_field horizon "$run_output")" \
    "$wall" "$run_status" >>"$results_file"

  restore_repository_knobs
done <"$variants_file"

restore_repository_knobs

# ------------------------------------------------------------------- report

printf '\n'
printf 'MathMachine knob race\n'
printf '  engine        %s\n' "$engine_source"
printf '  budget        %s rounds per variant, %ss wall cap\n' \
  "$rounds" "$run_timeout"
printf '  working dir   %s (the kernel gate uses the relative path formal/cubical)\n' \
  "$repository_directory"
printf '  locale        LC_ALL=%s\n' "$engine_locale"
printf '  AGDA_DIR      %s\n' "$agda_home"
printf '  knob wiring   %s\n' \
  "$(if [ "$engine_wired" = yes ]
     then printf 'the engine imports Knobs, so the confs below are live'
     else printf 'THE ENGINE DOES NOT IMPORT Knobs YET'
     fi)"
printf '  kernel gate   %s\n' \
  "$(if [ "$kernel_state" = live ]
     then printf 'live (--kernel-self-test accepts 0+x = x, rejects s(x) = x)'
     else printf 'DEAD (--kernel-self-test failed; see the note below)'
     fi)"
printf '\n'

printf '%-14s %-24s %6s %6s %6s %6s %6s %8s %8s %9s  %s\n' \
  variant knobs rounds known rules lemmas vocab horizon 'wall(s)' 'known/s' status
printf '%-14s %-24s %6s %6s %6s %6s %6s %8s %8s %9s  %s\n' \
  -------------- ------------------------ ------ ------ ------ ------ ------ \
  -------- -------- --------- ------
awk -F'	' '{
  known = ($4 == "-" ? 0 : $4 + 0)
  wall  = ($9 == "-" ? 0 : $9 + 0)
  rate  = (wall > 0 ? sprintf("%.3f", known / wall) : "-")
  knobs = $2
  if (length(knobs) > 24) knobs = substr(knobs, 1, 21) "..."
  printf "%-14s %-24s %6s %6s %6s %6s %6s %8s %8s %9s  %s\n",
    $1, knobs, $3, $4, $5, $6, $7, $8, $9, rate, $10
}' "$results_file"

printf '\n'
printf 'Full knob strings:\n'
awk -F'	' '{ printf "  %-14s %s\n", $1, $2 }' "$results_file"

printf '\n'
printf 'HOW TO READ THIS.\n'
printf '  known   theorems the Agda kernel gate certified and the machine kept.\n'
printf '          This is the primary metric.  It is the only column that is a\n'
printf '          mathematical result rather than a measurement of the search.\n'
printf '  rules/lemmas/vocab/horizon  the secondary metrics: how far the search\n'
printf '          actually got.  horizon is the term-size bound the machine\n'
printf '          reached, vocab the number of symbols in play.\n'
printf '  terms explored and pruned%% are NOT here and cannot be: --smoke-rounds\n'
printf '          runs the loop with /dev/null as its log handle, so the round\n'
printf '          line carrying terms= and pruned=%% is never written.  For those,\n'
printf '          use machine/run-loop-ab.sh, which runs the unbounded loop in a\n'
printf '          scratch root and parses a real log.\n'

if [ "$engine_wired" = no ]; then
  printf '\n'
  printf 'THE TABLE ABOVE IS NOT EVIDENCE ABOUT KNOBS.\n'
  printf '  %s does not import Knobs, so every variant\n' "$engine_source"
  printf '  compiled the same text and ignored its knob file.  Any spread in the\n'
  printf '  columns is run-to-run variance, and any tie is a tautology.  Wire the\n'
  printf '  engine to machine/Knobs.hs (loadKnobs reads machine/knobs.conf) and\n'
  printf '  run this again; until then the race is a harness test, not a result.\n'
fi

if [ "$kernel_state" = dead ]; then
  printf '\n'
  printf 'THE PRIMARY METRIC IS DEGENERATE FOR AN ENVIRONMENT REASON.\n'
  printf '  The engine`s own --kernel-self-test could not certify 0+x = x, which\n'
  printf '  is refl-provable.  Every candidate in every variant was therefore\n'
  printf '  rejected before any knob could matter.  The preflight log:\n'
  sed 's/^/      | /' "$work_directory/kernel-preflight.log"
  printf '  Fix that before reading the known column as anything at all.\n'
fi

zero_known=$(awk -F'	' '$4 == "0" || $4 == "-" { n++ } END { print n + 0 }' \
  "$results_file")
distinct_known=$(awk -F'	' '{ seen[$4] = 1 } END { print length(seen) }' \
  "$results_file")

if [ "$zero_known" = "$variant_count" ]; then
  printf '\n'
  printf 'PRIMARY METRIC DEGENERATE: every variant certified zero theorems.\n'
  printf '  The kernel gate certifies by `refl` over {0, s, +, *} only, so any\n'
  printf '  equation that needs induction is rejected however the knobs are set.\n'
  printf '  Read the secondary columns instead -- rounds reached, horizon, vocab,\n'
  printf '  wall -- and treat them as a measurement of the SEARCH, not of the\n'
  printf '  mathematics.  A knob that widens the search while the gate stays shut\n'
  printf '  has not been shown to help.\n'
elif [ "$distinct_known" = 1 ]; then
  printf '\n'
  printf 'PRIMARY METRIC DID NOT SEPARATE THE VARIANTS: every one certified the\n'
  printf '  same number of theorems.  Whatever the secondary columns show, this\n'
  printf '  race supports no claim that one knob setting proves more than another.\n'
fi

printf '\n'
printf 'RECOMMENDATION (for a person; nothing here acts on it).\n'
awk -F'	' -v wired="$engine_wired" -v distinct="$distinct_known" '
  $10 == "ok" && $4 != "-" {
    known = $4 + 0
    wall = $9 + 0
    if (best == "" || known > bestKnown || (known == bestKnown && wall < bestWall)) {
      best = $1; bestKnobs = $2; bestKnown = known; bestWall = wall
    }
    ok++
  }
  END {
    if (ok == 0) { print "  No variant completed.  There is nothing to recommend."; exit }
    printf "  Leader on (known, then wall): %s  [%s]  known=%d in %.1fs\n",
      best, bestKnobs, bestKnown, bestWall
    if (wired == "no") {
      print "  ...but the engine is not wired to the knob file, so every arm ran"
      print "  the same binary.  This leader is timing noise and recommends"
      print "  nothing at all.  Wire the engine to Knobs first."
    } else if (distinct == 1) {
      print "  ...on a tie in the primary metric, broken only by the wall clock."
      print "  That is a statement about speed, not about mathematics."
    } else {
      print "  Adopt it by writing the knob file yourself; this script will not."
    }
  }' "$results_file"

if [ -n "$keep_directory" ]; then
  mkdir -p "$keep_directory"
  cp "$results_file" "$variants_file" "$keep_directory/" 2>/dev/null || true
  cp "$work_directory"/*.conf "$work_directory"/*.canonical "$keep_directory/" \
    2>/dev/null || true
  cp "$work_directory"/run-*.log "$work_directory"/kernel-preflight.log \
    "$keep_directory/" 2>/dev/null || true
  printf '\nkept: %s\n' "$keep_directory"
fi

printf '\n'
printf 'machine/knobs.conf is as it was before this run.\n'
