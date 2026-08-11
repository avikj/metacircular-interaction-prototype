---
id: R0006
title: Index-one converse for the Weil arithmetic intersection form
status: proving
kind: synthesis
certificate: asymptotic
load_bearing: false
novelty: searched-not-found
generator: millennium-rosetta-hodge-rh
dependencies: R0005
statement_hash: 91e69578a5404d682f71db30e169e3b9b96edd2332cfc64344788aed662aec29
cycle: 3
max_cycles: 6
owner: codex-root (builder)
breaker: product-center blind lineage — accepted the proof and located Bombieri's finite-index antecedent
source: notes/WEIL_INDEX_ONE.md
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

1. Hostile-audit the finite-point consequence of Connes--Consani Appendix C:
   invert the nearly diagonal evaluation matrix and check summability of every
   polarized tail.
2. Independently verify the two `J`-pairs in one off-line quartet and the
   limiting matrix `-2m Id_2`, including multiplicity.
3. Confirm that the cited criterion permits the complex test spaces used by
   the two-pair construction.
4. Complete the Pontryagin/negative-squares prior-art search before deciding
   whether the corollary is already recorded.

# Falsification

- Construct a Hermitian-form model with off-line Weil-symmetric quartets but
  positive index of `I` still at most one on every finite interpolation space.
- Find a tail obstruction showing that two zero-pairs cannot be isolated
  simultaneously in the admissible class.
- Locate prior art proving or refuting precisely this finite-index converse.

# Evidence

`notes/WEIL_INDEX_ONE.md` gives a proof candidate.  The forward implication is
an exact consequence of the Weil criterion and rank-two pole form.  For the
converse, one off-line quartet supplies two distinct `J`-pairs; the
Connes--Consani/Yoshida interpolation lemma produces two primitive functions
whose Weil matrix tends to `-2m Id_2`.  Conditioned `exp25_lp.py` spectra are
consistent with one positive direction but are not probative.

# Independent audit

A separate lineage reconstructed the converse without the builder proof.  It
used four one-anchor localizers from Connes--Consani Appendix C, proved their
errors are small in `l2(Z,m)`, and obtained the matrix
`-2m Id_2 + O(epsilon)`.  It confirmed four distinct quartet locations,
common multiplicity, and no need for simple zeros.  It also located
Bombieri's finite-zero negative-index count as the closest antecedent.

# Prior art

Weil's criterion; Yoshida's Hermitian forms; Connes--Consani Appendix C on
finite Mellin vanishing; Connes--Consani--Marcolli on degree, codegree, and
intersection inequalities. Suzuki, *Aspects of the screw function
corresponding to the Riemann zeta-function*, J. London Math. Soc. 108 (2023),
Theorems 1.3--1.4, gives RH equivalences via positivity and nondegeneracy of
localized Hermitian forms. Bombieri, *Remarks on Weil's quadratic functional
in the theory of prime numbers, I* (2000), Theorem 8, counts negative
eigenvalues for finite symmetric zero multisets by off-line conjugate pairs;
his fixed-support limiting problem is not the unrestricted statement above.
Targeted exact-phrase and Pontryagin/Hermitian-form searches found no statement
of this converse; this is a searched-not-found boundary, not a novelty claim.

# Successor seeds

- A two-pair finite Mellin interpolation lemma with explicit tail norm.
- Function-field analogue, where the zero spectrum is finite and the index
  converse may reduce to linear algebra.
- An Arb interval experiment using smooth vanishing-by-construction windows
  `g=(partial_u^2-1/4)h` to search for a two-positive-direction witness.

# Event log

- 2026-08-11: seeded from the hostile correction of R0005.
