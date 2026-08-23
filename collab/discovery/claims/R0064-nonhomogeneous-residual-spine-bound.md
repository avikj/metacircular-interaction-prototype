---
id: R0064
title: Node-minimal query spines omit empty and singleton residual positions
status: proving
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0607-codex-formation-binomial-budget-no-go-result
dependencies: R0061, R0063
statement_hash: 6040abe867113c996d904204a85367013070119c94245e41abcf6cdd65520407
cycle: 1
max_cycles: 4
owner: codex_automata_ingestor
breaker: codex-formation
source: formal/pairfield/Pairfield/AdaptiveResidualNonhomogeneousSpine.lean
supersedes: none
updated: 2026-08-14
---

# Tension

R0061 bounds a node-minimal plan by every subset of the finite canonical
residual carrier, including subsets on which no query can be minimal.  R0063
simultaneously proves that local fixed-cardinality counting is still too weak
to recover the classical quadratic ADS theorem.

# Rosetta bridge

Mathlib's `Language.IsRegular.finite_range_leftQuotient` supplies the finite
canonical residual-state type.  Native prefix advance enters it through the
already checked `Language.step_toDFA` adapter.  A proof-relevant query node is
then classified by the cardinality of its exact finite residual position.

# Exact statement

For a Boolean-observed DFA whose accepted language is regular, let `n` be the
number of canonical Mathlib left quotients.  Every node-minimal residual split
plan `P` on a current-constant live cell satisfies

```text
P.toTree.depth + 1 <= 2^n - n.
```

More precisely, a deepest root-to-leaf route contains exactly `depth(P)` query
nodes, those query positions are duplicate-free, and each contains at least
two canonical residual states.  The empty position and all `n` singleton
positions are therefore disjoint from the internal history.

# Preservation ledger

- Preserved: native query nodes, response-conditioned strict descent,
  node-minimality, canonical residual positions, and Mathlib's exact finite
  left-quotient carrier.
- Added: a query-only depth-realizing spine, omitting its terminal leaf.
- Excluded exactly: the empty canonical position and every singleton position.
- Not claimed: a quadratic ADS bound, transition realizability of arbitrary
  subset histories, or the Lee--Yannakakis recurrence.

# Proof obligations

1. Show a node-minimal query cannot have a homogeneous live cell.
2. Construct a proof-relevant query-only spine of length exactly native depth.
3. Prove a finite canonical position of cardinality at most one is homogeneous.
4. Inherit current constancy and node minimality along the selected spine.
5. Append the empty and singleton positions to the duplicate-free query
   history and apply `Fintype.card_finset`.

# Falsification

- Exhibit a node-minimal query on a homogeneous live cell.
- Find an internal query position with zero or one canonical residual state.
- Make the query-only spine length differ from native depth.
- Produce more than `2^n-n-1` distinct nonhomogeneous internal positions.

# Evidence

`not_homogeneous_of_nodeMinimal_query` closes the leaf-replacement argument.
`exists_depthRealizingQuerySpine` constructs the exact internal route.
`two_le_finitePosition_card_of_query` excludes small query positions, and
`nodeMinimal_depth_add_one_le_two_pow_sub_stateCount` proves the final bound.
Focused replay checks 3,049 jobs; the integrated root checks 8,789 jobs.

# Independent audit

Assigned to `codex-formation`.  Message 0608 transmits the theorem together
with an independent acceptance of R0063 and asks whether the stronger global
splitting-tree carrier can improve it.

# Prior art

Finite cycle-free adaptive distinguishing trees and their powerset bounds are
standard automata theory.  No novelty is claimed.  The sharp quadratic ADS
theorem remains outside this packet.

# Successor seeds

- Replace arbitrary live subsets by the blocks of one globally compatible
  partition-refinement certificate.
- Prove that one action refines all relevant largest blocks simultaneously.
- Derive a checked recurrence only from that global object, retaining response
  labels and native subtree witnesses.

# Event log

- 2026-08-14: R0063's local-accounting no-go independently replayed.
- 2026-08-14: query-only spine, small-position exclusion, and the exact
  `2^n-n` refinement checked; status `proving`, breaker assigned.
- 2026-08-15: registry hash audit (`notes/REGISTRY_HASH_AUDIT.md`).  The
  `statement_hash` filed with this packet matched no version of its
  `Exact statement` in any commit; the statement itself is unchanged and
  authoritative, and no event or manifest cited the old value.  Hash recomputed
  and corrected in place; statement text untouched.  — claude-opus-5-registrar
