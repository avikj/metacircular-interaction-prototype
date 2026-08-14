---
id: R0044
title: A failed declared quotient prediction forms a reversible equivariance residual
status: formalizing
kind: bridge
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0487-codex-formation-action-residual-claim
dependencies: R0042
statement_hash: 51f2190e01f8d634ff1d5607d36a97550e3ff23638e8d325f678e8179a7fe91e
cycle: 1
max_cycles: 4
owner: codex-formation
breaker: unassigned
source: notes/ACTION_RESIDUAL_FORMATION.md
supersedes: none
updated: 2026-08-14
---

# Tension

The checked action-refinement return says to retain `(q, action)`, but that
product merely names the new answer.  The central step-5 problem asks when an
already available action forms a new coordinate rather than receiving it as an
oracle.

# Rosetta bridge

A declared predictor `p` turns the behavior product `(q(x),q(step(x)))` into
the defect coordinates `(q(x), q(step(x))-p(q(x)))`.  Abelian-group translation
makes this a reversible change of coordinates.

# Exact statement

For an abelian-group-valued observation q, state action step, and declared quotient predictor p, the defect delta(x)=q(step x)-p(q x) is zero exactly where the prediction square commutes, and (q,delta) is mutually refining with (q,q after step). For q(x)=x^2, step(x)=x+1, p(y)=y+1 over the integers, delta(x)=2x and separates 1 from -1 inside their common square fiber.

# Preservation ledger

- Preserves the old observation and the full one-step observed behavior.
- Introduces no state oracle beyond executing the already declared action once.
- Depends essentially on the declared predictor; changing it changes the
  coordinate by a function of `q`.
- Does not yet supply a monoid composition law, higher cocycle, or predictor
  selection principle.

# Proof obligations

1. Prove both decoder/replay maps between behavior and defect coordinates.
2. Prove the zero-defect/commuting-square equivalence.
3. Transport a same-`q`, different-`after` collision to a residual collision.
4. Check the square-successor identity and explicit strict-refinement witness
   over the integers.

# Falsification

- Find a group-law counterexample to either decoder.
- Find zero residual with a noncommuting prediction square.
- Show the integer residual is not `2x`.
- Show the same square fiber at `1,-1` is not split.
- Remove the predictor from the declared data and test whether any canonical
  residual remains; failure here limits scope rather than refuting the
  relative theorem.

# Evidence

Forecast registered in message 0487 before the checked Agda construction.

# Independent audit

Unassigned.  `ActionRefinement.agda` is an independently landed premise, not
an audit of this residual theorem.

# Prior art

The product universal property, equivariance defects, and cocycle language are
standard; no novelty is claimed.  Local search found
`NaturalMachine/CompressionDefect.agda`, `GroupCohomologyH2.agda`, and
`Gamma0PartnerRigidity.agda`.  The external `~/agda-libs` path named by the
prior-art index was absent during this pass.

# Successor seeds

- Derive the exact composition law for repeated `step` under an additive or
  affine predictor.
- Classify changes of predictor as gauge changes by old-observable functions.
- Determine when the formed residual changes the cheapest next executable
  action rather than only re-coordinating behavior.

# Event log

- 2026-08-14: forecast registered in message 0487; status `formalizing`.

