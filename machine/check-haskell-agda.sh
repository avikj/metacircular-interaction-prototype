#!/bin/sh

set -eu

fail() {
  printf 'check-haskell-agda: %s\n' "$*" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 \
    || fail "required command not found: $1"
}

script_directory=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repository_directory=$(CDPATH= cd -- "$script_directory/.." && pwd)

require_command ghc
require_command agda
require_command mktemp

math_machine_source="$repository_directory/machine/MathMachine.hs"
induction_gate_source="$repository_directory/machine/MathMachineInductionGate.hs"

[ -f "$math_machine_source" ] \
  || fail "missing machine API: $math_machine_source"
[ -f "$induction_gate_source" ] \
  || fail "missing induction-gate API: $induction_gate_source"
[ -d "$repository_directory/formal/cubical" ] \
  || fail "missing Agda include root: $repository_directory/formal/cubical"

check_directory=$(mktemp -d "${TMPDIR:-/tmp}/math-machine-check.XXXXXX")
cleanup() {
  case "$check_directory" in
    */math-machine-check.*)
      rm -rf -- "$check_directory"
      ;;
    *)
      printf 'check-haskell-agda: refusing unsafe cleanup target: %s\n' \
        "$check_directory" >&2
      ;;
  esac
}
trap cleanup EXIT HUP INT TERM

mkdir -p \
  "$check_directory/ghc/no-code-math" \
  "$check_directory/ghc/no-code-induction" \
  "$check_directory/ghc/math" \
  "$check_directory/ghc/induction" \
  "$check_directory/bin" \
  "$check_directory/generated/NaturalMachine"

cd "$repository_directory"

printf '%s\n' '==> compiling Haskell with warnings as errors'
ghc -Wall -Werror -fno-code -fforce-recomp \
  -outputdir "$check_directory/ghc/no-code-math" \
  "$math_machine_source"
ghc -Wall -Werror -fno-code -fforce-recomp \
  -outputdir "$check_directory/ghc/no-code-induction" \
  "$induction_gate_source"

ghc -Wall -Werror -fforce-recomp \
  -outputdir "$check_directory/ghc/math" \
  -o "$check_directory/bin/math-machine" \
  "$math_machine_source"
ghc -Wall -Werror -fforce-recomp \
  -outputdir "$check_directory/ghc/induction" \
  -o "$check_directory/bin/math-machine-induction-gate" \
  "$induction_gate_source"

math_machine="$check_directory/bin/math-machine"
induction_gate="$check_directory/bin/math-machine-induction-gate"
definition_manifest="$check_directory/generated/NaturalMachine/HaskellDefinitionManifestGenerated.agda"
discovery_manifest="$check_directory/generated/NaturalMachine/HaskellDiscoveryManifestGenerated.agda"

printf '%s\n' '==> checking thought format and definition firewall'
"$math_machine" --check-thought-format
"$math_machine" --check-definitions

printf '%s\n' '==> running bounded five-round machine smoke check'
"$math_machine" --smoke-rounds 5

printf '%s\n' '==> emitting five-round Haskell-to-Agda manifests'
"$math_machine" --emit-agda-manifest "$definition_manifest"
"$math_machine" --emit-agda-discoveries 5 "$discovery_manifest"
[ -s "$definition_manifest" ] \
  || fail "definition manifest was not emitted"
[ -s "$discovery_manifest" ] \
  || fail "five-round discovery manifest was not emitted"

printf '%s\n' '==> typechecking generated Agda manifests'
agda -i "$check_directory/generated" \
  -i "$repository_directory/formal/cubical" \
  "$definition_manifest"
agda -i "$check_directory/generated" \
  -i "$repository_directory/formal/cubical" \
  "$discovery_manifest"

printf '%s\n' '==> running checked induction installation gate'
"$induction_gate"

printf '%s\n' 'HASKELL-AGDA MACHINE CHECKED'
