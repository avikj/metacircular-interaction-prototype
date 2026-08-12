---
id: R0043
title: Fiber conditionals are exact conserved quantities of format-measurable learning
status: formalizing
kind: synthesis
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: human-frame-information-geometry
dependencies: R0041
statement_hash: 878f4894d7c5e8657e2297f47f56a163f4be7009c5dcbc9b0905664c9a6fb532
cycle: 2
max_cycles: 4
owner: cf-tessera
breaker: unclaimed
source: notes/FORMAT_CONSERVED_LEARNING_GEOMETRY.md
supersedes: none
updated: 2026-08-12
---

# Tension

R0041 is statics: outcome rewards have fiber-saturated argmax.  A learner
is a trajectory, not an argmax; the open question was whether learning
dynamics can nevertheless drift inside the fiber, and what exactly a trace
format's partition conserves along natural-gradient trajectories.

# Rosetta bridge

The common object is the policy simplex over an event window with the
format's discrimination partition.  A format is a Markov coarse-graining;
policies factor as class marginals times within-class conditionals;
multiplicative weights is the exact rational discretization of the
natural-gradient (replicator) flow.

# Exact statement

Let W be a finite event carrier, P a partition of W, and MWU the update pi'_w proportional to pi_w beta^{r_w} with rational beta>1 and integer reward r. (1) Within-class conditionals are invariant under MWU for every policy, base, and horizon iff r is P-measurable; if r is non-constant on a class, some conditional strictly changes in one step. (2) Policies factor bijectively as (class marginals, conditionals); MWU with P-measurable r acts as the induced class MWU on marginals and the identity on conditionals; the tangent kernel of the marginal map has dimension |W|-r and the replicator field of a P-measurable reward is tangent to the conditional leaves. (3) On the event torsor with R0041's formats: outcome supervision makes MWU the identity map (learning frozen pointwise); the sign format induces a two-state replicator with strict marginal movement and frozen conditionals; the Bezout format freezes the conditional on the unrecorded complement; an injective chart conserves nothing beyond normalization. The conserved-quantity count is sum over classes of (|C|-1), maximal for outcome supervision and zero for the chart.

# Preservation ledger

- Preserves R0041's lattice; upgrades each partition to its conservation
  laws.
- All theorems are discrete and exact-rational; the continuous envelope
  (replicator = Fisher natural gradient, Chentsov canonicity, KL chain
  rule) is cited as classical and is not load-bearing.
- No claim about stochastic gradients, function approximation, or any
  learner other than exact MWU/replicator.
- The information-geometry frame was user-requested and is attributed;
  the mathematics stands without it.

# Proof obligations

1. The conservation iff (both directions, one step and multi-step).
2. The factorization, induced dynamics, kernel dimension, and tangency.
3. The four-format gradation on real event windows.

# Falsification

- Exhibit a P-measurable reward, base, and policy where a conditional
  moves.
- Exhibit a non-measurable reward conserving all conditionals for all
  policies.
- Exhibit an outcome-supervised MWU step that is not the identity.
- Exhibit a sign-format step moving a conditional or a non-strict
  marginal move under distinct class rewards.

# Evidence

Proof: notes/FORMAT_CONSERVED_LEARNING_GEOMETRY.md.  Exact replay:
machinery/format_conserved_learning_geometry.py and
machinery/test_format_conserved_learning_geometry.py (6 tests, all
Fraction arithmetic, on real event windows from the R0041 grid:
multi-step conservation for three formats, the converse witness, frozen
outcome dynamics, induced two-state dynamics with strict growth and
commuting marginalization, product round-trip, kernel dimensions).

# Independent audit

Unclaimed.  Preferred audit: attack the converse's quantifier structure
(for every policy vs some policy), the identification of the induced
marginal dynamics with class MWU (the commuting-square test), and whether
strict positivity of policies is load-bearing anywhere.

# Prior art

Replicator conservation of within-type ratios under equal fitness is
classical evolutionary dynamics; MWU-replicator correspondence, Chentsov's
theorem, and the KL chain rule are textbook (Amari; Cover-Thomas).  No
novelty is claimed.  The content is the exact composition with the
computed event fibers and the R0041 format lattice.

# Successor seeds

- The e/m dual foliation: exponential-family formats (log-linear rewards
  in payload coordinates) and their I-projections, exactly.
- Conservation under bandit feedback (sampled events) as a martingale
  statement on conditionals - state exactly what survives sampling.
- The rank-r version over the five-coordinate payload group (R0039).

# Event log

- 2026-08-12: composed by cf-tessera from the user's information-geometry
  frame against R0041; six-test exact replay green.
