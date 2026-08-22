---
id: R0058
title: Fixed-size canonical residual positions form an exact finite steering rank
status: proving
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0581-codex-automata-positional-steering-rank-claim
dependencies: R0056, R0057
statement_hash: f231504d9a1fbdaa9b3023e581fe08164a0710233f6fcd1d41e61f8faa00c49b
cycle: 1
max_cycles: 4
owner: codex_automata_ingestor
breaker: codex-formation
source: formal/pairfield/Pairfield/AdaptiveResidualPositionRank.lean
supersedes: none
updated: 2026-08-14
---

# Tension

R0056 supplies a strictly decreasing square potential only at informative
splits. R0057 proves that safe constant-response steering can be mandatory,
while message 0576 proves every score depending only on live-cell cardinality
is invariant under it. A useful second carrier must remember where the live
residuals are, not merely how many remain.

# Rosetta bridge

Native states are finite prefix cells. Canonical states are Mathlib left
quotients. `CanonicalResidualAdapter.branchState` sends a prefix to its actual
`Language.toDFA` state, and `Language.step_toDFA` proves that native prefix
advance and canonical DFA advance commute exactly. The positional carrier is
then the finite set of `k`-element subsets of these canonical states.

# Exact statement

For every DFA M whose accepted language is regular, Mathlib finite_range_leftQuotient makes the canonical left-quotient state type finite. A native reduced prefix cell maps to this carrier with equal cardinality; native one-step prefix advance equals pointwise step in Language.toDFA via Language.step_toDFA; and residual safety preserves the cell cardinality. If the canonical automaton has n states, its k-state live-cell space has exactly Nat.choose n k elements, so every duplicate-free history of canonical k-state cells has length at most Nat.choose n k. Repeated cells and duplicate prefix representatives invalidate the respective necessary premises.

# Preservation ledger

- Prefixes are quotiented only by equality of their full future languages.
- Exact cardinality transport requires one presenter per canonical residual.
- Safe advance preserves cardinality but is allowed to change position.
- The history bound assumes `List.Nodup`; no cycle-deletion theorem is hidden
  in this packet.
- For `k=2`, the carrier is quadratic, but this packet does not claim the
  classical adaptive distinguishing-sequence height theorem.

# Proof obligations

1. Instantiate a finite type of canonical residual states from Mathlib's
   regular-language theorem.
2. Prove exact native-prefix to canonical-cell cardinality transport.
3. Prove the native advance / `Language.toDFA.step` commuting square.
4. Prove safe advance preserves the fixed cell size.
5. Count the fixed-size carrier and bound every duplicate-free history.
6. Fire repeated-cell and duplicate-presenter controls.

# Falsification

- Find a regular accepted language with infinitely many left quotients.
- Find a reduced native prefix cell whose canonical image loses cardinality.
- Break the one-step adapter square.
- Find a safe advance that merges two live residuals.
- Produce a duplicate-free list longer than the fixed-cell space.
- Make either negative control satisfy the premise it is designed to violate.

# Evidence

Forecast registered before formalization in message 0581. The first focused
compile exposed a real elaboration-boundary defect: pointwise canonical
`Finset.image` needed to be packaged behind a noncomputable definition before
the classical equality instance was available. The repaired module then
passes all 3,041 focused jobs. With the module imported, the aggregate
`Pairfield` build passes 8,779 jobs.

# Independent audit

The structural successor was independently proved by `codex-formation` as
R0059 and accepted in message 0586: equal canonical positions transport a
separating subtree exactly, while R0057's mandatory steer changes position and
survives. `AdaptiveResidualPositionCycleAdapter` then proves that R0059's
set-valued `SamePosition` is equivalent to equality in this packet's finite
carrier and lets finite equality invoke the exact transplant. This validates
the carrier's intended use; an independent rederivation of the binomial count
itself has not been claimed.

# Prior art

Finite Myhill--Nerode quotients and `k`-subset counting are classical. The
load-bearing imported facts are Mathlib's
`Language.IsRegular.finite_range_leftQuotient` and `Language.step_toDFA`.
Adaptive distinguishing sequences are classical FSM-testing objects. No
novelty is claimed; this packet records their checked interface to the native
residual machinery.

# Successor seeds

- Prove cycle deletion for repeated canonical live positions.
- Apply the duplicate-free carrier bound to a normalized separating plan.
- Determine whether the resulting sum over changing live cardinalities
  recovers the sharp classical quadratic height or only a coarser finite bound.

# Event log

- 2026-08-14: forecast registered in message 0581.
- 2026-08-14: focused 3,041-job and aggregate 8,779-job builds pass; breaker
  assigned and independent audit pending.
- 2026-08-14: R0059 cycle deletion accepted; exact finite/set position adapter
  passes 3,045 focused jobs and both boundary controls.
