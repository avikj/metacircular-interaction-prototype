#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "$0")/.." && pwd)"

# The `--safe` header gate (notes/AGDA_PRAGMA_AUDIT.md).  Agda's `--safe` is
# asserted PER MODULE by an OPTIONS pragma; a file that omits it is checked
# without it, silently, and every `agda` invocation below would still pass.
# This runs FIRST because it needs no toolchain and because a missing pragma
# makes the subsequent green meaningless rather than merely incomplete.
"$repo_dir/scripts/check-agda-pragmas.sh"

# The anonymous-`example` oracle gate (notes/AXIOM_GATE.md §7a).  `lake exe
# axiom_gate` below can only reach NAMED declarations; an `example` emits no
# constant, so an oracle inside one is structurally invisible to it — and for
# a time the lane's single `native_decide` sat in exactly that position.  This
# is the complement, not a replacement, and like the pragma check it needs no
# toolchain, so it runs before anything expensive.
"$repo_dir/scripts/check-lean-example-oracles.sh"

# The silent-deletion gate (notes/REGISTRY_DELETION_142bba1f.md). Commit
# 142bba1f removed 53 registry files under a subject that describes a sync;
# the loss was found by an archivist draw, not by any check. Needs no
# toolchain, so it runs with the other cheap gates. HEAD only here; CI runs
# it over the pushed range, and `--pre-push` covers a branch before it lands.
"$repo_dir/scripts/check-no-silent-deletion.sh"

agda -i "$repo_dir/formal/cubical" \
  "$repo_dir/formal/cubical/NaturalMachine.agda"
agda -i "$repo_dir/formal/cubical" \
  "$repo_dir/formal/cubical/ProjectionChargeAudit.agda"
agda -i "$repo_dir/formal/cubical" \
  "$repo_dir/formal/cubical/ProjectionChargeAudit2.agda"
agda -i "$repo_dir/formal/cubical" \
  "$repo_dir/formal/cubical/NaturalMachine/CapabilityGraph.agda"
agda -i "$repo_dir/formal/cubical" \
  "$repo_dir/formal/cubical/NaturalMachine/LawfulContinuationCore.agda"

(
  cd "$repo_dir/formal/pairfield"
  lake build
  # The axiom gate: Lean's substitute for Agda's `--safe`.  Rejects any
  # Pairfield theorem/def/axiom whose `Lean.collectAxioms` set escapes
  # {propext, Classical.choice, Quot.sound} plus the commented allowlist in
  # axiom-allowlist.txt.  Sees taint through imports, which a grep cannot.
  # ~4 min on top of a warm build (it imports all 133 modules at once).
  # See notes/AXIOM_GATE.md.
  lake exe axiom_gate
)
