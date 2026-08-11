# Why continuous one-body centering cannot change exact pair counts

The centered two-body program uses several inequivalent meanings of
"subtract the mean."  This note isolates a general measure-theoretic fact
that prevents them from being conflated.

> Subtracting an absolutely continuous one-body mean can change smoothed and
> transformed pair fields, but it cannot change the atomic coefficient on
> any exact sum or exact difference fiber.

The statement applies equally to Goldbach sums and fixed gaps.  Their later
analytic asymmetry comes from properness/positivity and from the kind of
pair-level baseline one needs, not from this atomic fact.

---

## 1. Atomic invariance theorem

Let `mu` be a locally finite pure-point measure on `R`, let

\[
 d\lambda(x)=q(x)\,dx
\]

be locally finite and absolutely continuous, and let

\[
 L(x,y)=ax+by,\qquad ab\ne0.
\]

Allow also a locally bounded product weight `w_1(x)w_2(y)` for which all
pushforwards below are locally finite.  Denote weighted measures by a
subscript `w`.

### Theorem 1.1 (atomic invariance)

\[
 \boxed{
 \operatorname{Atom}
 L_*\bigl[((\mu-\lambda)\otimes(\mu-\lambda))_w\bigr]
 =
 \operatorname{Atom}L_*[(\mu\otimes\mu)_w].
 }
\]

Here `Atom` means the pure-point part in the Lebesgue decomposition of a
measure.

### Proof

Expand the tensor square.  It is enough to show that

\[
 L_*(\mu\otimes\lambda),\qquad
 L_*(\lambda\otimes\mu),\qquad
 L_*(\lambda\otimes\lambda)
\]

are nonatomic.

Write `mu=sum_j c_j delta_{x_j}`.  For fixed `x_j`, the map

\[
 y\longmapsto ax_j+by
\]

is an affine diffeomorphism because `b != 0`.  The pushforward of
`q(y)dy`, even after multiplication by the allowed weight, is absolutely
continuous.  A locally finite countable sum of such measures is absolutely
continuous, proving the mixed case.  The other mixed term is identical with
`a` and `b` exchanged.  Finally, the pushforward of
`q(x)q(y)dxdy` under a nonconstant linear map has a density obtained by a
one-dimensional convolution (or by Fubini in coordinates `(L,x)`).  Hence it
too is nonatomic.  Only the pure-point tensor `mu tensor mu` can contribute
atoms.  $\square$

The same proof works for signed or complex Radon measures by total-variation
decomposition.

---

## 2. Mangoldt heat field

Take

\[
 \mu_\Lambda=\sum_{n\ge1}\Lambda(n)\delta_n,
 \qquad
 \lambda=\mathbf1_{[1,\infty)}(x)\,dx,
\]

and the heat weight `exp(-t(x+y))`, `t>0`.  Put

\[
 \xi=\mu_\Lambda-\lambda,
 \qquad
 \Xi=\xi\otimes\xi.
\]

For the difference projection `D(x,y)=y-x`, Theorem 1.1 gives exactly

\[
 \boxed{
 D_*[e^{-t(x+y)}\Xi](\{h\})
 =\sum_{n-m=h}\Lambda(m)\Lambda(n)e^{-t(m+n)}
 =C_h(t).
 }
\]

Every term containing Lebesgue measure contributes a density in `h`; none can
cancel or alter the singleton mass.

For the sum projection `S(x,y)=x+y`, the same theorem gives

\[
 \boxed{
 S_*[e^{-t(x+y)}\Xi](\{N\})
 =e^{-tN}\sum_{m+n=N}\Lambda(m)\Lambda(n).
 }
\]

Thus the common phrase "PNT centering subtracts the Goldbach main term" must
be interpreted after pairing against a test function, taking a cumulative
count, or passing to Laplace/Mellin transforms.  It is false if interpreted as
literal subtraction of the coefficient at the atom `{N}`.

---

## 3. Why gaps still require a pair-level baseline

The theorem is symmetric in `S` and `D`, but the desired reference measures
are not.

- In the sum channel, the map on the positive quadrant is proper.  Continuous
  mean terms give a locally finite pushforward density, and integration over
  a unit window or a cumulative cutoff produces the classical archimedean
  main term.  This is why PNT centering is effective for smoothed Goldbach
  formulas even though it does not change singleton masses.
- In the difference channel, the positive fiber is noncompact.  A fixed-gap
  statistic requires a radial cutoff, and its conjectural main term is the
  discrete Hardy--Littlewood factor `S(h)` times the radial volume.  That
  arithmetic factor is not the pushforward of a continuous one-body mean.

Consequently the Hardy--Littlewood background must be inserted or derived at
the pair level.  Two legitimate ways already present in this repository are:

1. the finite-adic correlation measure of `ADELIC.md`, whose normalized
   two-point function is the singular series;
2. the discrete finite-sieve density `nu_W` of `BUCHSTAB_WINDOW.md`, whose
   tensor square really does have atoms on exact sum and gap fibers.

The second point is crucial: replacing Lebesgue measure by a **discrete**
arithmetic reference sequence escapes Theorem 1.1.  It can modify exact pair
coefficients because all four terms in the centered tensor square are then
pure point.

---

## 4. Three centerings, three jobs

There is no canonical centering that simultaneously performs every desired
operation.

| centering | exact effect | what it does not do |
|---|---|---|
| `mu_Lambda - dx` | removes the pole at `s=1` in Mellin space; centers smoothed PNT-scale tests | does not alter exact sum/gap atoms |
| completed-zeta split `M=A_infinity+F` | separates zero-free/archimedean, one-zero, and two-zero meromorphic sectors | is bookkeeping in transform space, not a positive discrete pair baseline |
| `Lambda-nu_W` or `Lambda-tilde_nu` | subtracts finite local arithmetic directly on integer atoms | needs Buchstab finite-window normalization at polynomial sieve depth and still faces parity |

The correct centered two-body framework is therefore graded rather than
singular:

\[
 \boxed{
 \text{finite local geometry}
 \;\oplus\;
 \text{archimedean window response}
 \;\oplus\;
 \text{linear zero sector}
 \;\oplus\;
 \text{quadratic zero/parity sector}.
 }
\]

This grading is not cosmetic.  Theorem 1.1 proves that collapsing the first
two jobs into a continuous one-body subtraction loses the exact arithmetic
object one intended to center.

