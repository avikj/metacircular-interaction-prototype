#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "$0")/.." && pwd)"

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
