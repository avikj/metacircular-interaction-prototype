#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "$0")/.." && pwd)"

# asserted PER MODULE by an OPTIONS pragma; a file that omits it is checked
# without it, silently, and every `agda` invocation below would still pass.
# This runs FIRST because it needs no toolchain and because a missing pragma
# makes the subsequent green meaningless rather than merely incomplete.
"$repo_dir/scripts/check-agda-pragmas.sh"

# yogyanupalabdhi` below can only reach NAMED declarations; an `example` emits no
# constant, so an oracle inside one is structurally invisible to it — and for
# a time the lane's single `native_decide` sat in exactly that position.  This
# is the complement, not a replacement, and like the pragma check it needs no
# toolchain, so it runs before anything expensive.
"$repo_dir/scripts/check-lean-example-oracles.sh"

# 142bba1f removed 53 registry files under a subject that describes a sync;
# the loss was found by an archivist draw, not by any check. Needs no
# toolchain, so it runs with the other cheap gates. HEAD only here; CI runs
# it over the pushed range, and `--pre-push` covers a branch before it lands.
"$repo_dir/scripts/check-no-silent-deletion.sh"

# from a per-branch counter and ten of them carry two live claim files; slugs
# come from the statement and are unique (104/104). This fails on a
# slug-qualified reference that names nothing, and WARNS (non-fatal) on a bare
# reference to an ambiguous ID — the silently-wrong ones. Needs no toolchain.
"$repo_dir/scripts/check-claim-slugs.sh"

# re-derivation at the foot of formal/lean/Pairfield.lean).  Two
# different questions, neither subsuming the other, both toolchain-free:
#
#   check-lean-globs.sh        -- is every module a BUILD TARGET?
#                                 (`globs` in lakefile.toml; the soundness one)
#   check-lean-root-closure.sh -- is every module REACHABLE from the root?
#                                 (`import Pairfield`; 114 of 133 until today)
#
# Both existed unwired before now, which is the failure the audit named: the
# check that nothing runs is indistinguishable from the check that does not
# exist.
"$repo_dir/scripts/check-lean-globs.sh"
"$repo_dir/scripts/check-lean-root-closure.sh"

# The declared-route check on the lane's oracle sites (Jaina nayavāda; see the
# script's own header).  Also unwired until now.
"$repo_dir/scripts/GuptaNaya_TheConcealedRouteMustBeDeclaredAtItsSite.sh"

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

# ---------------------------------------------------------------------------
# Everything.agda — the whole-directory latch (formal/cubical/BUILD.md,
# top-level and Swarm/ module the aggregate imports.
#
# ASPIRATIONAL-IF-RED, 2026-08-14: this step is currently EXPECTED TO FAIL
# on a container pinned to Agda 2.6.3 + cubical v0.5, because part of the
# tree (the Γ₀ lane, much of NaturalMachine/, five Swarm modules) was
# migrated to the cubical v0.9 API (`solve!`, `SymGroup`) per BUILD.md's
# migration section, and the two toolchains cannot both be green at once.
# Until that schism resolves, a red result here is REPORTED, not fatal —
# the steps above remain the hard gate.  When Everything.agda goes green
# under the resolved toolchain, DELETE the fallback and let it hard-fail.
# Swallowing this failure silently would recreate the exact overstatement
# BUILD.md documents; hence the loud banner either way.
# ---------------------------------------------------------------------------
if (cd "$repo_dir/formal/cubical" && agda Everything.agda); then
  echo "EVERYTHING: GREEN — the whole Agda lane checked in one command."
else
  ev_code=$?
  echo "=============================================================="
  echo "EVERYTHING: RED (exit $ev_code) — aspirational until the"
  echo "BUILD.md-vs-container toolchain schism resolves (v0.5 vs v0.9)."
  echo "modules Everything.agda imports."
  echo "=============================================================="
fi

(
  cd "$repo_dir/formal/lean"
  lake build
  # The axiom check (yogyānupalabdhi): Lean's substitute for Agda's `--safe`.
  # Rejects any lane constant whose `Lean.collectAxioms` set escapes
  # {propext, Classical.choice, Quot.sound} plus the commented allowlist in
  # axiom-allowlist.txt.  Sees taint through imports, which a grep cannot.
  # ~4 min on top of a warm build (it imports all 133 modules at once).
  # Scope is MODULE MEMBERSHIP, not a `Pairfield` name prefix, since 2026-08-20;
  # it prints its own yogyatā (what it could have seen) on the OK line.
  lake exe yogyanupalabdhi
)
