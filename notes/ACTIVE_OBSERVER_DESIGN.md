# Active observer design for a finite compositional crystal

## 1. Operational object

Let `X` be a finite hypothesis set. A probe is a triple

\[
q=(c_q,r_q,Y_q),\qquad r_q:X\to Y_q,
\]

where `c_q` is a positive integer resource cost. A history is a finite list
`(q_i,y_i)`. Given an exact prior `p`, its posterior is obtained by restricting
to the fiber `r_{q_i}^{-1}(y_i)` at every step and renormalizing. An impossible
history fails closed.

For states `x,x'`, define their one-probe distinguishing cost

\[
d_Q(x,x')=\min\{c_q:r_q(x)\ne r_q(x')\},                 \tag{1}
\]

with value infinity if no available probe separates them. The budget-`B`
observational quotient identifies exactly the pairs with `d_Q(x,x')>B`.
This is resource-indexed distinguishability, not a claim that the underlying
states are identical.

## 2. Active objective

For posterior mass `p_h`, the exact gain of a probe is

\[
G_h(q)=1-\sum_{y\in Y_q}p_h(r_q^{-1}(y))^2.              \tag{2}
\]

Equivalently, independently sample the true state and a rival from the
posterior. `G_h(q)` is the probability that the probe distinguishes them.
The implemented policy chooses an unused affordable probe maximizing

\[
G_h(q)/c_q,                                               \tag{3}
\]

then breaks ties by raw gain, lower cost, and stable name.

**One-step optimality.** Among the declared affordable probes, this policy
maximizes the expected posterior mass eliminated per unit cost under the
independent-rival experiment.

**Proof.** Conditional on true state `x`, a rival survives precisely when it
lies in the response fiber containing `x`. Averaging over `x` gives survival
mass `sum_y p_h(r_q^{-1}(y))^2`; subtraction gives (2). Dividing by the
declared cost and maximizing proves the statement. `square`

This theorem is deliberately myopic. It does not assert optimality over a
multi-step decision tree. Greedy information gain can be globally suboptimal.

## 3. Interface with the compositional crystal

`COMPOSITIONAL_CRYSTAL_THEOREM.md` emits a shortest elementary-context word
for every behaviorally inequivalent pair and a minimum separating context
basis. Each word `C[-]` becomes the executable probe

\[
r_C(x)=o(C[x]),\qquad c_C=1+\operatorname{length}(C).    \tag{4}
\]

The identity costs one observation. The active runtime compiles the union of
the identity, pairwise shortest witnesses, and the minimum basis. Consequently
every finite distinguishing experiment synthesized by the crystal can be
priced, conditioned on previous outcomes, and selected as a next action.

This adds an operational axis without changing the crystal theorem:

- the crystal proves which distinctions are possible and supplies shortest
  contexts;
- the observer layer records which hypotheses remain live at a given history;
- the resource layer says which distinctions are currently affordable;
- the active policy chooses the next probe by an explicit local objective.

The pairwise cost (1) is not generally a metric: it can violate the triangle
inequality, and infinity may occur. Its honest name is **distinguishing cost**.

## 4. Interaction and relative state

An observation outcome is relative to the pair `(probe,state)` through the
evaluation map `r_q(x)`. The runtime never installs a probe-independent
description as metaphysically privileged. Nevertheless, the finite state and
probe sets are declared externally; this is a laboratory model of interacting
observers, not a derivation of quantum mechanics, spacetime, agency, or
relational ontology.

Different observers may have different probe pools, costs, priors, and
histories. Their observational quotients can therefore differ without
contradiction. Communication is modeled only after an outcome from one pool is
translated into a named probe/outcome constraint in another. No equivalence of
such translations is assumed.

## 5. Persona-independent constructive salon

The salon is an internal deliberation protocol, not an assignment of historical
identities to agents. One execution process hosts several influence-labeled
questions and integrates their answers into one construction. Any later agent
may resume the same room.

- A **relational-physics-influenced** question asks which outcome exists only
  relative to a declared interaction and which invariance survives observer
  translation.
- A **computational-universe-influenced** question asks how the state graph and
  probe histories can be executed, bounded, and replayed.
- A **Chandrasekhar-influenced** question asks for the stability boundary: at
  what resource or perturbation threshold does a distinguishable phase cease
  to be supportable?
- A **Bacon-influenced** question asks which intervention discriminates rival
  explanations and what negative instance would kill the proposed rule.

These are simulated, influence-based prompts. No sentence is attributed to a
historical person, and no persona has epistemic authority. The integrated
constructive output is the neutral probe API, equations (1)--(4), its tests,
and its rigor boundary.

## 6. Computational boundary

All posterior and gain calculations use exact rational arithmetic. Computing
all pairwise one-probe distinguishing costs is polynomial in the explicit
response table. The upstream minimum context basis is an exact hitting-set
problem and can be exponential. Globally optimal adaptive experiment design is
also generally combinatorial; it is not implemented here.

The implementation does not learn priors, invent costs, infer causality, or
promote experimental utility into mathematical truth. A high-gain probe only
partitions the declared hypothesis family efficiently. If the true possibility
is absent from `X`, exact arithmetic cannot repair the model misspecification.

## 7. Buildable loop

1. Crystallize a finite algebra under a declared observation.
2. Compile shortest contexts into finite probes by (4).
3. Supply an exact prior and current history.
4. Compute the posterior and all resource-indexed pair defects.
5. Choose the affordable probe maximizing (3).
6. Execute it outside the model, append its actual outcome, and repeat.
7. Stop when the posterior support is a singleton, no affordable positive-gain
   probe remains, or the remaining ambiguity is structurally invisible.

The last two stops are different: **resource exhaustion** may be repaired by a
larger budget; **structural invisibility** requires a new operation or lens.

## 8. Rigor boundary

Proved here: equations (1)--(4), exact posterior conditioning, the one-step
optimality statement, and compilation of existing shortest crystal contexts.

Not proved: global optimality of the greedy policy, a unique objective for all
observers, emergence of physical law, equivalence with Rovelli's relational
quantum mechanics, equivalence with Wolfram-style multiway systems, or any
claim about consciousness. Those names indicate the operational question—what
interaction distinguishes what, at what cost—not imported authority.

## 9. Durable resume contract

Future sessions should begin by reading this note together with
`COMPOSITIONAL_CRYSTAL_THEOREM.md`, then run:

```text
python3 -m unittest machinery/test_compositional_crystal.py \
  machinery/test_active_observer_design.py
```

Resume only from one of three exact successors:

1. prove or refute adaptive submodularity for a sharply stated class of crystal
   probe pools;
2. implement an exact bounded-horizon decision tree and exhibit a smallest
   counterexample to greedy global optimality;
3. define and verify a translation morphism between two observers' probe
   contexts, recording precisely which distinctions it preserves and destroys.

Do not expand the physical metaphors until one of these finite interfaces earns
the expansion.
