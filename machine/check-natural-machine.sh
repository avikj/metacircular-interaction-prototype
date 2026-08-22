#!/bin/sh

# check-natural-machine.sh — one-command re-check of the NaturalMachine lane.
#
#   machine/check-natural-machine.sh [--timeout SECONDS] [--heap SIZE]
#
# Typechecks the lane's Agda modules in dependency order, one PASS/FAIL line
# each, then builds and runs the Haskell replay (machine/QuestionMachine.hs).
# Exits nonzero if anything fails.  Optional modules that do not exist yet are
# skipped silently: other agents are still writing them.
#
# Environment overrides:
#   NATURAL_MACHINE_TIMEOUT   per-module wall clock, seconds (default 600)
#   NATURAL_MACHINE_HEAP      Agda RTS heap cap (default 3g)
# Command line flags win over the environment.

set -eu

fail() {
  printf 'check-natural-machine: %s\n' "$*" >&2
  exit 1
}

usage() {
  printf '%s\n' \
    'usage: check-natural-machine.sh [--timeout SECONDS] [--heap SIZE]' \
    '  --timeout SECONDS  per-module wall clock (default 600,' \
    '                     or $NATURAL_MACHINE_TIMEOUT)' \
    '  --heap SIZE        Agda RTS heap cap (default 3g,' \
    '                     or $NATURAL_MACHINE_HEAP)'
}

require_command() {
  command -v "$1" >/dev/null 2>&1 \
    || fail "required command not found: $1"
}

script_directory=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repository_directory=$(CDPATH= cd -- "$script_directory/.." && pwd)

module_timeout=${NATURAL_MACHINE_TIMEOUT:-600}
agda_heap=${NATURAL_MACHINE_HEAP:-3g}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --timeout)
      [ "$#" -ge 2 ] || fail '--timeout needs an argument'
      module_timeout=$2
      shift 2
      ;;
    --heap)
      [ "$#" -ge 2 ] || fail '--heap needs an argument'
      agda_heap=$2
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      fail "unrecognised argument: $1"
      ;;
  esac
done

case "$module_timeout" in
  ''|*[!0-9]*) fail "timeout must be a whole number of seconds: $module_timeout" ;;
esac
case "$agda_heap" in
  ''|*[!0-9kKmMgG]*) fail "unusable heap size: $agda_heap" ;;
esac

require_command agda
require_command ghc
require_command timeout
require_command mktemp

cubical_directory="$repository_directory/formal/cubical"
[ -d "$cubical_directory/NaturalMachine" ] \
  || fail "missing Agda source root: $cubical_directory/NaturalMachine"

question_machine_source="$repository_directory/machine/QuestionMachine.hs"
[ -f "$question_machine_source" ] \
  || fail "missing Haskell replay: $question_machine_source"

# Dependency order.  Required modules first, then the ones being written now.
required_modules='
CostGeometry
CostGeometryWitness
Residual
KFlow
EndObstruction
QuestionMachine
ChuAdvance
AdvanceGate
TransportDiv
TransportDivWitness
'

optional_modules='
ResidualPath
KFlowWF
Lawvere
ChuDefect
TransportDivQuot
WalkFastInstance
'

check_directory=$(mktemp -d "${TMPDIR:-/tmp}/check-natural-machine.XXXXXX")
cleanup() {
  case "$check_directory" in
    */check-natural-machine.*)
      rm -rf -- "$check_directory"
      ;;
    *)
      printf 'check-natural-machine: refusing unsafe cleanup target: %s\n' \
        "$check_directory" >&2
      ;;
  esac
}
trap cleanup EXIT HUP INT TERM

passed=0
failed=0
skipped=0

# typecheck MODULE — prints one status line, never aborts the run itself.
typecheck() {
  module=$1
  log="$check_directory/$module.log"
  status=0
  (
    cd "$cubical_directory" || exit 127
    LC_ALL=C.UTF-8 timeout "$module_timeout" \
      agda +RTS "-M$agda_heap" -RTS "NaturalMachine/$module.agda"
  ) >"$log" 2>&1 || status=$?

  if [ "$status" -eq 0 ]; then
    printf 'PASS  %s\n' "$module"
    passed=$((passed + 1))
    return 0
  fi

  if [ "$status" -eq 124 ]; then
    printf 'FAIL  %s  (timeout after %ss)\n' "$module" "$module_timeout"
  else
    printf 'FAIL  %s  (agda exit %s)\n' "$module" "$status"
  fi
  sed 's/^/      | /' "$log" >&2
  failed=$((failed + 1))
  return 0
}

printf '%s\n' "==> typechecking NaturalMachine (timeout ${module_timeout}s, heap $agda_heap)"

for module in $required_modules; do
  [ -f "$cubical_directory/NaturalMachine/$module.agda" ] \
    || fail "missing required module: NaturalMachine/$module.agda"
  typecheck "$module"
done

for module in $optional_modules; do
  if [ -f "$cubical_directory/NaturalMachine/$module.agda" ]; then
    typecheck "$module"
  else
    skipped=$((skipped + 1))
  fi
done

printf '%s\n' '==> building and running the Haskell replay'
replay_status=0
(
  cd "$repository_directory" || exit 127
  ghc -O2 -Wall -outputdir "$check_directory/ghc" \
    machine/QuestionMachine.hs -o machine/question-machine >"$check_directory/ghc.log" 2>&1
) || replay_status=$?

if [ "$replay_status" -eq 0 ]; then
  if (cd "$repository_directory" && ./machine/question-machine); then
    printf 'PASS  %s\n' 'QuestionMachine.hs replay'
    passed=$((passed + 1))
  else
    printf 'FAIL  %s\n' 'QuestionMachine.hs replay (nonzero exit)'
    failed=$((failed + 1))
  fi
else
  printf 'FAIL  %s  (ghc exit %s)\n' 'QuestionMachine.hs build' "$replay_status"
  if [ -f "$check_directory/ghc.log" ]; then
    sed 's/^/      | /' "$check_directory/ghc.log" >&2
  fi
  failed=$((failed + 1))
fi

printf '%s passed, %s failed, %s skipped (absent)\n' "$passed" "$failed" "$skipped"

if [ "$failed" -eq 0 ]; then
  printf '%s\n' 'NATURAL MACHINE CHECKED'
  exit 0
fi

exit 1
