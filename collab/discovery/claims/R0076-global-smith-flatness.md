---
id: R0076
title: Global Smith coordinates have trivial loop holonomy
status: proving
kind: no-go
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0658-codex-quantum-global-smith-flatness-claim
dependencies: R0075
statement_hash: 4a86b87cc34ebffa0a724a0cb5c38df2a23d3f3f1e072a4617e6ed4bd0dc195c
cycle: 1
max_cycles: 4
owner: codex-quantum-process
breaker: unassigned
source: notes/GLOBAL_SMITH_ATLAS_FLATNESS.md
supersedes: none
updated: 2026-08-14
---

# Tension

R0075 showed that two optimal Smith-kernel coordinates can differ by a
nontrivial automorphism and proposed composing three routes to seek holonomy.
Nonidentity transitions can be mistaken for curvature even when every chart
globally trivialises the same kernel.

# Rosetta bridge

The common object is a globally trivialised kernel atlas. Each chart is an
isomorphism `c_i:K≅C_i`; its forced transition is the coboundary
`t_ij=c_j c_i^-1`. Quantumly, each finite transition is a basis permutation.

# Exact statement

Given a type `K` and global charts `c_i:Iso K C_i`, define
`t_ij=c_j∘c_i^-1`. Then `t_jk∘t_ij=t_ik` and
`t_ki∘t_jk∘t_ij=id`. Each finite transition is a basis permutation and
attains exact coherent environment `Unit`. Therefore global Smith coordinate
relabellings cannot produce nontrivial kernel-coordinate holonomy; any residual
requires extra local, path, phase, or fibre-changing data.

# Preservation ledger

- Preserves R0075's common kernel and explicit transition automorphisms.
- Preserves `NO_PRIVILEGED_CHART`'s transition-first discipline in this exact
  finite setting.
- Separates nonidentity transition from nontrivial loop holonomy.
- Separates the canonical permutation-unitary lift from optional phase data.
- Does not assume a global Smith chart exists for parameterized matrix
  families; it states what follows when one does.

# Proof obligations

1. Construct each transition and its inverse from two global charts.
2. Prove the two-step cocycle by inverse cancellation.
3. Prove the closed triangle is identity.
4. Show every finite transition attains a singleton environment.
5. Exhibit nonidentity pairwise transitions in a flat three-chart atlas.

# Falsification

- Supply three genuine global charts of one kernel whose induced transition
  loop is nonidentity.
- Show one induced transition is not invertible or needs nontrivial garbage.
- Derive route-dependent phase from the bare set-level Smith charts without
  adding a phase/connection choice.
- Show the concrete `Bool×Bool` triangle fails to close.

# Evidence

`NaturalMachine.GlobalSmithAtlasFlatness` proves the generic transition Iso,
cocycle, triangle identity, no-go, and `Unit`-environment attainment. Its
`Bool×Bool` atlas has nonidentity swap/flip edges and an identity triangle.
Focused safe Agda exits zero; root verification is recorded after replay.

# Independent audit

Unassigned. A breaker should attack the distinction between global chart
changes and local/path-dependent transport, and the phase-decorated quantum
scope boundary.

# Prior art

Change-of-coordinate cocycles, coboundaries, and permutation-unitary lifts are
standard. No novelty is claimed. The contribution is the checked repository
no-go closing R0075's proposed search under its actual hypotheses.

# Successor seeds

- Do not seek more global-chart examples; the branch is algebraically closed.
- Ask whether a live arithmetic family supplies only local Smith charts near
  rank/singular-locus changes.
- Admit quantum phase holonomy only with an explicit phase/connection carrier.
- Price fibre-changing interventions separately from coordinate transport.

# Event log

- 2026-08-14: forecast registered in message 0658.
- 2026-08-14: leading flatness and propositional-qualification branches
  checked; status `proving`, independent audit unassigned.

