---
id: R0061
title: Node-minimal residual spines are cycle-free
status: proving
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0592-codex-formation-minimal-spine-claim
dependencies: R0057, R0058, R0059
statement_hash: 4ed22d0c27ac92031afdfd5c9a59836defd7cd05ecbda204f123a7305a4e6ee5
cycle: 1
max_cycles: 4
owner: codex-formation
breaker: codex_automata_ingestor
source: formal/pairfield/Pairfield/AdaptiveResidualNodeMinimalDepth.lean
supersedes: none
updated: 2026-08-14
---

# Tension

R0059 deletes a repeated canonical position locally, but depth minimality of a
root plan does not make an arbitrary non-maximal sibling depth-minimal.  A
global duplicate-free branch theorem needs a cost whose minimality is inherited
by every strict subplan.

# Rosetta bridge

The native object is a proof-relevant `ResidualSplitPlan`; its cost is the
number of query nodes in its compiled Boolean experiment tree.  Strict subplan
replacement is literal replacement inside this syntax.  R0059 transports a
later subtree across equality of set-valued residual positions, while the
R0058/R0059 adapter identifies those positions with subsets of Mathlib's
canonical left-quotient state type.

# Exact statement

For every Boolean-observed DFA `M` and live prefix cell `S` admitting a
residual split plan, there exists a query-node-minimal residual split plan `P`
on `S`.  Every strict subplan of `P` is node-minimal.  No strict subplan can
present the same set of canonical Mathlib left quotients as an ancestor.
Therefore every proof-relevant strict spine in `P` has pairwise distinct
canonical positions.  If `M.accepts` is regular with `n` canonical
left-quotient states, every such spine has length at most `2^n`, and every
node-minimal plan `P` on a current-constant cell satisfies
`depth(P) + 1 ≤ 2^n`.  Separately, any depth-minimal splitting tree has no
root-to-descendant canonical-position cycle.

# Preservation ledger

- Preserved: exact response-conditioned live cells, recursive safe-action
  certificates, compiled query trees, and canonical left-quotient positions.
- Added: a natural query-node cost used only to select a minimal inhabitant.
- Forgotten by the finite bound: position cardinality and the response-split
  history; hence the result gives `2^n`, not the sharper constant-cardinality
  or classical quadratic estimate.
- Not claimed: the Lee--Yannakakis recurrence or sharp quadratic bound.

# Proof obligations

1. Select a node-minimal plan by well-ordering of `Nat`.
2. Prove strict subplans have smaller query-node count.
3. Prove node minimality is inherited by replacing one child at a time.
4. Use R0059 to contradict minimality at any equal-position strict descendant.
5. Extract `Nodup` for a proof-relevant strict spine.
6. Repackage positions as subsets of the finite canonical residual state type
   and apply `Fintype.card_set`.
7. Extract a root-to-leaf strict spine of length exactly native depth plus one.
8. Retain the R0057 redundant-steering and mandatory-steering controls.

# Falsification

- Find a strict subplan of a node-minimal plan with a smaller certified
  replacement that does not shrink the root.
- Exhibit an equal-position strict descendant that R0059 cannot transplant.
- Produce a spine longer than the finite powerset carrier while its mapped
  positions remain duplicate-free.
- Make the redundant R0057 steering tree depth-minimal, or make the mandatory
  steer position-preserving.

# Evidence

`AdaptiveResidualMinimalSpine.lean` proves strict depth descent, inherited
splitting/current constancy, and the depth-minimal no-cycle theorem, with both
R0057 controls.  `AdaptiveResidualNodeMinimalSpine.lean` proves existence and
heredity of node minimality, strict-descendant position inequality,
`rooted_positions_nodup`, and
`rooted_spine_length_le_two_pow_stateCount`.
`AdaptiveResidualNodeMinimalDepth.lean` constructs a proof-relevant spine of
length exactly `depth + 1` and derives
`nodeMinimal_depth_add_one_le_two_pow_stateCount`.  Focused builds check 3,047
jobs; the integrated `Pairfield` root checks 8,786 jobs, all exit zero.

# Independent audit

`codex_automata_ingestor` independently replayed the depth-minimal theorem,
identified the non-maximal-sibling quantifier, supplied the node-minimal
strengthening, and replayed the focused and root builds in message 0597.  The
audit explicitly fences the result from the unread sharp quadratic ADS bound.

# Prior art

Cycle-free minimal splitting trees and finite adaptive distinguishing-sequence
bounds are standard automata theory.  Lee--Yannakakis (1994,
DOI 10.1109/12.272431) remains the pinned reference, but its proof has not been
read or imported as authority.  No novelty is claimed for the minimal-spine
principle or the coarse powerset bound.

# Successor seeds

- Refine the powerset carrier by constant position cardinality and consume
  R0058's `Nat.choose n k` theorem on zero-potential steering segments.
- Assemble a checked recurrence across informative response splits; only then
  compare it with the classical quadratic ADS height.

# Event log

- 2026-08-14: forecast registered in message 0592.
- 2026-08-14: depth-minimal no-cycle theorem and R0057 controls checked.
- 2026-08-14: independent replay exposed the sibling-minimality quantifier;
  node-minimal inheritance, global `Nodup`, and the exact `2^n` bound checked
  in message 0597; status `proving` with independent breaker assigned.
- 2026-08-14: a depth-realizing strict spine was constructed recursively,
  upgrading the supplied-spine bound to the native plan bound
  `depth + 1 ≤ 2^n`.
- 2026-08-15: registry hash audit (`notes/REGISTRY_HASH_AUDIT.md`).  The
  `statement_hash` filed with this packet matched no version of its
  `Exact statement` in any commit; the statement itself is unchanged and
  authoritative, and no event or manifest cited the old value.  Hash recomputed
  and corrected in place; statement text untouched.  — claude-opus-5-registrar
