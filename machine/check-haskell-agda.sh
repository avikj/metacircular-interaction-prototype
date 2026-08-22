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
agda_rewrite_gate_source="$repository_directory/machine/AgdaRewriteGate.hs"

[ -f "$math_machine_source" ] \
  || fail "missing machine API: $math_machine_source"
[ -f "$induction_gate_source" ] \
  || fail "missing induction-gate API: $induction_gate_source"
[ -f "$agda_rewrite_gate_source" ] \
  || fail "missing rewrite-gate API: $agda_rewrite_gate_source"
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
  "$check_directory/ghc/no-code-rewrite-gate" \
  "$check_directory/ghc/pramana" \
  "$check_directory/ghc/rewrite-gate" \
  "$check_directory/ghc/math" \
  "$check_directory/ghc/induction" \
  "$check_directory/bin" \
  "$check_directory/generated/NaturalMachine"

cd "$repository_directory"

# MathMachine.hs imports Certificate, Certify, TraceReplay, Knobs, ArithVocab,
# DSO and NestedInduction, all of which live in machine/.  This script never
# passed an include path, so every invocation below died at "Could not find
# module `Certificate'" -- i.e. the script could not compile the machine it
# exists to check, and had not been able to since MathMachine.hs gained its
# first sibling import.  `runghc -imachine` is how the machine is actually
# run from the repository root; this is the same flag.
machine_include="-i$repository_directory/machine"

printf '%s\n' '==> compiling Haskell with warnings as errors'
ghc -Wall -Werror -fno-code -fforce-recomp "$machine_include" \
  -outputdir "$check_directory/ghc/no-code-math" \
  "$math_machine_source"
ghc -Wall -Werror -fno-code -fforce-recomp \
  -outputdir "$check_directory/ghc/no-code-induction" \
  "$induction_gate_source"
ghc -Wall -Werror -fno-code -fforce-recomp \
  -outputdir "$check_directory/ghc/no-code-rewrite-gate" \
  "$agda_rewrite_gate_source"

ghc -Wall -Werror -fforce-recomp "$machine_include" \
  -outputdir "$check_directory/ghc/math" \
  -o "$check_directory/bin/math-machine" \
  "$math_machine_source"
ghc -Wall -Werror -fforce-recomp \
  -outputdir "$check_directory/ghc/induction" \
  -o "$check_directory/bin/math-machine-induction-gate" \
  "$induction_gate_source"
ghc -Wall -Werror -fforce-recomp \
  -outputdir "$check_directory/ghc/rewrite-gate" \
  -o "$check_directory/bin/math-machine-rewrite-gate" \
  "$agda_rewrite_gate_source"

math_machine="$check_directory/bin/math-machine"
induction_gate="$check_directory/bin/math-machine-induction-gate"
rewrite_gate="$check_directory/bin/math-machine-rewrite-gate"
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

# machine/AgdaRewriteGate.hs was `module Main` and no file, script or workflow
# in the repository referenced it: a self-test that nothing ran.  It is not an
# organ and it must not be made one by translation -- there is no producer of
# `Certificate` values in MathMachine.hs, and collab message 0553 says in as
# many words that turning the prover's Boolean success into installation
# authority "must not" happen by trust.  What it IS, is the only executable
# coverage of the NaturalMachine.RewriteCertificate grammar's non-induction
# lane, and of the admission gate's verdict taxonomy: admitted /
# refuted-by-type-error / refuted-by-timeout / cache-hit.  So it is called
# from here, which is the honest caller for a test.  ~18s, 12s of which is a
# deliberately non-terminating candidate proving the timeout fires.
printf '%s\n' '==> running Agda rewrite-certificate grammar and hardening gate'
"$rewrite_gate"

# The pramana layer: hetvabhasa, abhava with its pratiyogin and its searched
# extent, and the five-membered inference that will not conclude without a
# verified udaharana.  Run from here because machine/Yogyata.hs's header
# records what a module with a selfTest nobody calls costs: Upamana.hs sat
# 896 lines unread, Pramana.hs's own table called it ABSENT, and the first run
# found three defects latent since it was written.  Exits nonzero on any
# failed check; its log census never affects the exit code, because a log is
# a description and not a regression.
printf '%s\n' '==> running the pramana layer self-tests and hetvabhasa census'
# -Wall but NOT -Werror, and the reason is recorded rather than left to look
# like laziness: Obstruction.hs and Pramana.hs carry pre-existing -Wx-partial
# warnings (head/tail) that belong to their own lanes, and promoting them to
# errors here would make this step an outage for someone else's warning.  The
# three modules this step introduces are -Wall clean on their own.
ghc -Wall -fforce-recomp "$machine_include" \
  -outputdir "$check_directory/ghc/pramana" \
  -o "$check_directory/bin/nyayapariksa" \
  "$repository_directory/machine/Nyayapariksa_RunThePramanaLayer.hs"
"$check_directory/bin/nyayapariksa"

printf '%s\n' 'HASKELL-AGDA MACHINE CHECKED'
