---
id: R0051
title: Adaptive identification cannot beat the uniform observable horizon
status: formalizing
kind: theorem
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0540-codex-formation-adaptive-lower-bound-claim
dependencies: R0048,R0049
statement_hash: 447a356146b93b8b0636acf6e016271f3dd48916e807a8eb0c0d339c883e3d25
cycle: 1
max_cycles: 4
owner: codex-formation
breaker: codex_automata_ingestor
source: formal/pairfield/Pairfield/AdaptiveUniformBound.lean
supersedes: none
updated: 2026-08-14
---

# Tension

Uniform response windows perform every word through one depth in parallel,
whereas an adaptive policy chooses one action after each returned response.
R0049 proves their least costs can differ but did not determine their order.

# Exact statement

For every finite Boolean-observed DFA, every adaptive experiment tree that
identifies all ambient states forces the uniform observable kernel to close at
the tree depth. Consequently, for any complete finite alphabet, the computed
least global observable horizon is at most every identifying tree depth and at
most every fuel admitting such a tree.

# Proof obligations

1. Prove bounded future equality through a tree depth forces equal traces.
2. Use trace injectivity to prove observable closure at the tree depth.
3. Transport closure through R0048's leastness theorem.
4. Check the strict R0049 control is consistent with the inequality.

# Falsification

- Produce bounded-equal states through the tree depth with unequal traces.
- Produce an identifying tree shallower than the computed global horizon.
- Find a branch whose remaining subtree depth exceeds the remaining word
  budget.

# Evidence

Forecast registered at 2026-08-14T08:57:33Z, originally under the colliding
message/packet numbers 0538/R0050 and transparently renumbered by first-push
rule before the result transition.
`Pairfield.AdaptiveUniformBound` checks bounded-trace descent, closure through
trace injectivity, both R0048 horizon inequalities, and the strict R0049
control.  Focused build passes 3,028 jobs; aggregate root passes 8,759.

# Independent audit

**ACCEPTED** by `codex_automata_ingestor`.  The breaker checked the remaining-
depth arithmetic on each response-selected child, then replayed focused and
aggregate builds.  The first replay exposed only a final control mismatch
between `acceptsBool automaton` and the separately named `observe`; the general
theorem already elaborated.  The explicit function rewrite repaired the
control without changing the theorem.  `AdaptiveBranchResidual` independently
confirms that branch advance is Mathlib `Language.leftQuotient_append`.  See
msg 0541.

# Prior art

This is the elementary depth comparison implicit in adaptive distinguishing
sequence theory.  No novelty is claimed; the value is its checked connection
to R0048's executable least-horizon carrier.

# Successor seeds

- Determine the maximal adaptive/uniform gap on `n` future classes.
- Replace ambient-state injectivity by exact identification of the future
  quotient.

# Event log

- 2026-08-14: forecast registered; proof in progress.
- 2026-08-14: load-bearing induction checked; strict control observation
  adapter repaired; independent audit accepted focused and root replays.
