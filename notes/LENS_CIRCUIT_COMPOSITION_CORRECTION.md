# Correction: ordered affine composition in the sieve restriction monoid

## Scope

This note records a correction to `LENS_CIRCUIT.md`, Lemma R.3.  It was found
by a literal `/dev/urandom` draw selecting that file; the draw provenance and
pre-reading forecast are in
`collab/messages/codex-random-weil-06/20260814T0700Z-anchor-and-forecast.md`.
No analytic estimate or numerical experiment enters the correction.

## The false displayed equation

The sampled note defines

\[
  \rho_{W,r}(m)=Wm+r
\]

and prints

\[
  \rho_{W_2,r_2}\circ\rho_{W_1,r_1}
  =\rho_{W_1W_2,\,r_1+W_1r_2}. \tag{old}
\]

With the standard right-to-left convention for `\(\circ\)`, this is false.
Take

\[
  (W_1,r_1)=(2,0),\qquad (W_2,r_2)=(3,1),\qquad m=0.
\]

The left side of (old) is `1`, while its right side is `2`.

## Correct law and the common object

Direct expansion gives

\[
\boxed{
  \rho_{W_2,r_2}\circ\rho_{W_1,r_1}
  =\rho_{W_2W_1,\,W_2r_1+r_2}.} \tag{1}
\]

The old right side is instead the opposite composite:

\[
\boxed{
  \rho_{W_1,r_1}\circ\rho_{W_2,r_2}
  =\rho_{W_1W_2,\,r_1+W_1r_2}.} \tag{2}
\]

Thus iterated restrictions do still form one affine restriction.  The exact
carrier is the affine semigroup of pairs `(W,r)`, with ordered product

\[
  (W_2,r_2)\star(W_1,r_1)
  =(W_2W_1,\,W_2r_1+r_2)
\]

for outer-after-inner composition.  Projection to the scale `W` lands in the
commutative multiplicative monoid, but forgets the order-sensitive transported
offset.  In particular,

\[
  \rho_{W_2,r_2}\rho_{W_1,r_1}
  =\rho_{W_1,r_1}\rho_{W_2,r_2}
  \quad\Longleftrightarrow\quad
  W_2r_1+r_2=W_1r_2+r_1. \tag{3}
\]

Equation (3), rather than commutativity of the scale product, is the exact
criterion for forgetting restriction order.

## Consequence for the sampled note

Lemma R's closure claim survives after replacing (old) by (1), or after
reversing the composite on the left of (old).  Theorem 3 uses one restriction
at a time and does not invoke R.3, so none of its analytic conclusions is
demoted by this correction.  Any future use of iterated fibre labels must,
however, retain the affine order; the product `W_1W_2` alone does not recover
the final residue offset.

## Checked witness

`formal/pairfield/Pairfield/SieveRestriction.lean` proves (1), (2), (3), and
the explicit counterexample.  Replay without Python:

```text
cd formal/pairfield
lake build Pairfield.SieveRestriction
```

The focused target builds successfully (123 jobs).  The module is not yet
imported by the default `Pairfield` aggregate, so this is a focused green
claim, not an aggregate-green claim.

## Rigor boundary

- Proved: equations (1)--(3) and the counterexample, by elementary natural
  number algebra and by the checked Lean module.
- Unaffected but not reproved here: every analytic theorem in
  `LENS_CIRCUIT.md`.
- Not claimed: novelty.  The affine-semigroup law is standard; the result is a
  correction and an executable order boundary inside this corpus.

