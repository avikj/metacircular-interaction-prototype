---
id: R0006
title: Index-one converse for the Weil arithmetic intersection form
status: seed
kind: synthesis
certificate: asymptotic
load_bearing: false
novelty: unsearched
generator: millennium-rosetta-hodge-rh
dependencies: R0005
statement_hash: 91e69578a5404d682f71db30e169e3b9b96edd2332cfc64344788aed662aec29
cycle: 1
max_cycles: 6
owner: unclaimed
breaker: unclaimed
source: notes/LP_CERT.md
supersedes: none
updated: 2026-08-11
---

# Tension

Weil positivity makes RH a sign condition on an infinite-dimensional test
space.  The explicit formula also has a distinguished rank-two pole moment
plane, so RH forces the complementary arithmetic intersection form to have at
most one positive direction.  It is unknown here whether that weaker-looking
index bound still detects every off-critical zero quartet.

# Rosetta bridge

Translate the Hodge-index pattern "one ample positive direction and negative
primitive complement" into the explicit-formula identity
`I = pole - W`.  An off-line quartet contains two distinct hyperbolic
zero-pairs.  The proposed converse asks whether finite Mellin interpolation can
isolate both pairs strongly enough to manufacture two positive directions for
`I`, with every other zero controlled as a tail.

# Exact statement

Conjecture. Let A be the admissible complex test-function class in the Weil explicit formula with the normalization of notes/WEIL.md, let W be the Weil Hermitian form, let pole(g)=2 Re(Phi_g(0) conjugate(Phi_g(1))), and let I=pole-W. Then the Riemann Hypothesis is equivalent to the following finite-dimensional index condition: for every finite-dimensional complex subspace V of A, the restriction I|V has positive index at most one.

# Preservation ledger

- RH implies the condition exactly: `W >= 0`, hence `I <= pole`, and the
  pullback of the pole moment form has positive index at most one.
- The converse is not inherited from Connes--Consani Appendix C, which proves
  the stronger primitive negativity criterion.  It requires a new reduction
  from an off-line quartet to two simultaneously positive directions.
- "Positive index" means the maximal dimension of a subspace on which the
  Hermitian form is positive definite; numerical matrix inertia is evidence
  only unless the matrix entries and truncation error are certified.

# Proof obligations

1. State an admissible Mellin interpolation lemma that imposes the two pole
   vanishings and prescribed values on both off-line zero-pairs.
2. Prove tail suppression without assuming RH or simplicity of zeros.
3. Show that the resulting two test functions make the exact Weil form
   negative definite on their span, equivalently `I` positive definite there.
4. Audit conjugation, multiplicity, and the possibility that the two apparent
   hyperbolic pairs coincide on the critical line.

# Falsification

- Construct a Hermitian-form model with off-line Weil-symmetric quartets but
  positive index of `I` still at most one on every finite interpolation space.
- Find a tail obstruction showing that two zero-pairs cannot be isolated
  simultaneously in the admissible class.
- Locate prior art proving or refuting precisely this finite-index converse.

# Evidence

The forward implication is an exact consequence of the Weil criterion and
rank-two pole form.  Conditioned `exp25_lp.py` spectra are consistent with one
positive direction but are not probative for the converse.

# Independent audit

None.  R0005's blind audit generated this successor by rejecting the false
equivalence between the form inequality and the index bound while identifying
the index converse as the remaining theorem-shaped question.

# Prior art

Weil's criterion; Yoshida's Hermitian forms; Connes--Consani Appendix C on
finite Mellin vanishing; Connes--Consani--Marcolli on degree, codegree, and
intersection inequalities.  An exact prior-art search for the index-one
converse has not yet been completed.

# Successor seeds

- A two-pair finite Mellin interpolation lemma with explicit tail norm.
- Function-field analogue, where the zero spectrum is finite and the index
  converse may reduce to linear algebra.
- An Arb interval experiment using smooth vanishing-by-construction windows
  `g=(partial_u^2-1/4)h` to search for a two-positive-direction witness.

# Event log

- 2026-08-11: seeded from the hostile correction of R0005.
