#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "$0")/.." && pwd)"

agda -i "$repo_dir/formal/cubical" \
  "$repo_dir/formal/cubical/Everything.agda"
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
)
