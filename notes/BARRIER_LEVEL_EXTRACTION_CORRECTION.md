# Finite window extraction is a frequency response, not a drift norm

This corrects Theorem L8(b),(d) and the finite-impossibility headline of
`BARRIER_LEVEL_SEPARATION.md`.  The earlier note contains a sound exact
Vandermonde construction, but its final no-go makes two invalid inferences:

1. Theorem L7 gives an **upper bound** on extraction error in terms of a sum
   of coefficient drifts.  A lower bound on one drift inside that upper bound
   does not give a lower bound on the actual error.  Cancellation and the
   extractor's signed coefficients were discarded by the triangle inequality.
2. Under linear independence, equidistribution can make the set of good
   spacings have small asymptotic measure.  That does not bound the **first**
   good spacing, much less prove that none lies in a prescribed finite data
   interval.  The honesty ledger's row Y7 already admits this, contradicting
   L8(d)'s theorem statement.

The correction is not that finite extraction is exact.  It is that its error
has a more precise object: the frequency response of the Lagrange polynomial.

## Exact response theorem

Use Theorem L4's distinct positive nodes

`xi_mu = exp(mu Delta / 2)`

and, for target level `nu`, its Lagrange basis polynomial

`ell_nu(z) = sum_p a_(nu,p) z^(p-1)`,

so `ell_nu(xi_mu)=1` for `mu=nu` and zero otherwise.  Suppose one Bohr mode

`c_gamma exp(i gamma u)`

occurs in the moving coefficient `C_mu(u)`.  Its contribution to the
`nu`-extractor `sum_p a_(nu,p) R_p` is exactly

`exp(mu u_0/2) c_gamma exp(i gamma u_0)
  ell_nu(xi_mu exp(i gamma Delta)).`                         (1)

**Proof.**  At translated window `p`, the scale and phase factors are

`xi_mu^(p-1) exp(i gamma (p-1) Delta)
 = (xi_mu exp(i gamma Delta))^(p-1)`.

Multiplying by `a_(nu,p)` and summing is the definition of `ell_nu` at the
phase-rotated node.  `formal/pairfield/Pairfield/VandermondeFrequencyResponse.lean`
checks this geometric-mode identity over every commutative ring.  No estimate
or zeta-zero hypothesis enters.  □

Three consequences replace L8(b).

- Constant coefficients have `gamma=0`, so (1) reduces to the ordinary
  Vandermonde delta.  Constant modes remain exact.
- A **target** mode is also distorted when the family has more than one node:
  its desired multiplier is `1`, while the translated extractor supplies
  `ell_nu(xi_nu exp(i gamma Delta))`.  This polynomial equals `1` at phase
  one but is not identically one, so almost every phase distorts it.  Thus the
  old claim of exact extraction through level `k-1` fails even before
  considering leakage from other levels.  The one-node `mu` family is the
  exceptional case: its Lagrange polynomial is identically one.
- For a non-target level `mu != nu`, leakage is governed by
  `ell_nu(xi_mu exp(i gamma Delta))`, **not** by the raw drift norm.  The
  latter remains a useful upper bound but is not an error identity.
- The roots of `ell_nu` are the other distinct positive nodes.  Because the
  phase-rotated point has modulus `xi_mu`, its response at a non-target node
  vanishes exactly when `exp(i gamma Delta)=1`.  Thus any fixed nonzero mode
  leaks for almost every spacing, while resonant and near-resonant spacings
  require a separate quantitative analysis.

For `a=Lambda`, the level `k-1` coefficient contains unconditional nonzero
arity-one Bohr modes.  At a fixed spacing for which one response in (1) is
nonzero, that level contributes a term of order `X^((k-1)/2)` to the
corresponding extractor mode; lower levels have smaller powers of `X`.
Therefore **generic fixed spacings have asymptotically amplified leakage**.
This is a valid, narrower obstruction.  It does not prove that every
data-admissible spacing fails at a requested finite tolerance.

## What survives and what reopens

The following parts of `BARRIER_LEVEL_SEPARATION.md` survive unchanged:

- L1--L6: collision law, anchored taper, Vandermonde family, sufficiency, and
  asymptotic peeling;
- L7 as an upper error bound and L7-prime for constant fibers;
- L8(a) as a lower bound on raw coefficient drift;
- L8(c) as a positive-measure statement about raw drift;
- L9, the exact rank-one `lambda` degeneracy.

What does **not** survive is L8(b)'s claimed error lower bound or L8(d)'s
universal conditional no-spacing theorem.  The finite question is now exact:

> Can one choose a spacing inside the available data range for which every
> relevant response polynomial in (1), after including the inverse
> Vandermonde conditioning, is below the target tolerance?

Equidistribution density alone does not answer this first-return problem.
Neither does the existence of Bohr almost-periods, because small `Delta`
simultaneously worsens the inverse Vandermonde coefficients.  An effective
simultaneous-Diophantine/conditioning estimate, or a different extractor, is
still required.

## Boyd return and prior art grade

The randomly selected Boyd lens asked whether an endpoint verdict concealed
the tempo of the argument.  Here it did: the note's final status said the row
was discharged, while its own later ledger weakened “no admissible spacing”
to a typical-density heuristic.  Restoring the intermediate response operator
turns that timing mismatch into equation (1).

Prony/Vandermonde frequency response and conditioning are classical; public
search metadata was consulted before the sampled note was opened, and no
novelty is claimed.  The contribution is a correction internal to this
corpus.  No numerical scan, zero census, or fitted constant is used.
