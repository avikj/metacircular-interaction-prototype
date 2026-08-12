# Arithmetic Hadamard ramification

**Status:** exact elementary nucleus; proposed adelic successor is open and
non-load-bearing.  This note isolates the part of the sum--difference picture
that is genuinely arithmetic.  The rank-one pair field and the identity
`S^2-D^2=4Q` are already recorded in `REPORT.md` and are generic.  The new
orientation here is the integral defect of the coordinate change, not those
generic identities.

## 1. The integral Hadamard map

Put

\[
 H:\mathbb Z^2\longrightarrow\mathbb Z^2,
 \qquad H(m,n)=(S,D)=(m+n,m-n).
\]

**Theorem 1 (the determinant-two defect).**  The map `H` is injective and

\[
 \operatorname{im}H
 =\{(S,D)\in\mathbb Z^2:S\equiv D\pmod 2\},\qquad
 \operatorname{coker}H\cong\mathbb Z/2\mathbb Z.
\]

It becomes an isomorphism over `Z[1/2]`.  For every odd prime `p`, its
reduction modulo `p` is invertible, while modulo `2` it has rank one and the
two coordinates coincide: `S=D=m+n`.

**Proof.**  The matrix of `H` is

\[
 \begin{pmatrix}1&1\\1&-1\end{pmatrix},
 \]

with determinant `-2`.  Its inverse over `Z[1/2]` is
`(S,D) -> ((S+D)/2,(S-D)/2)`.  These halves are integral exactly when
`S` and `D` have the same parity.  Reduction modulo an odd prime preserves
the nonzero determinant; modulo `2` the two rows agree.  This also computes
the cokernel. \(\square\)

Thus the sum--difference duality is an ordinary linear rotation over the
real or complex spectral plane, but a degree-two, uniquely ramified change
of lattice coordinates over the integers.

## 2. Positive pairs and the third coordinate

For positive integers `m,n`, the image additionally satisfies

\[
 S>|D|,\qquad S\equiv D\pmod2,
 \]

and these conditions are sufficient to reconstruct a unique ordered positive
pair.  The multiplicative coordinate is then forced:

\[
 Q=mn=\frac{S^2-D^2}{4}.
\]

Consequently `(S,D,Q)` is not three independent data streams.  It is one
integral Lorentz-cone chart with two gluing conditions: parity makes the
quarter integral, and positivity selects the positive pair cone.  Reflection
`(m,n)->(n,m)` fixes `S,Q` and sends `D->-D`.

## 3. Why the prime 2 is structurally exceptional

For two odd primes, both `S` and `D` are even.  Conversely, the only way a
prime pair occupies the other parity coset is for exactly one leg to be the
prime `2`.  Hence the same unique ramified place has four exact appearances:

1. sum and difference fibers become indistinguishable modulo `2`;
2. odd--odd Goldbach targets and odd-prime gaps are even;
3. the `p=2` local factor is exceptional in both Hardy--Littlewood channels;
4. after shifting a finite prime prefix by `2`, the exponent `0` is the unique
   even exponent, which is the singleton anchor used by
   `PARITY_RIGIDITY.md` to prove homometric rigidity.

Items 1--3 are local-coordinate facts, not cancellation estimates.  Item 4
is the already-proved corpus theorem viewed through the same ramified place.
No claim is made here that determinant two explains the analytic parity
barrier in full; it identifies the exact integral datum that any proposed
sum/difference spectral equivalence must retain.

## 4. The projective pair pencil

Let

\[
 \mu=\sum_{n\ge1}\Lambda(n)\,\delta_n,
 \qquad A(z)=\int e^{-zx}\,d\mu(x)
             =\sum_{n\ge1}\Lambda(n)e^{-nz}.
\]

The two-leg measure `mu tensor mu` has two-variable Laplace transform
`A(z_1)A(z_2)`.  For every primitive integer vector `(a,b)`, pushforward by
`L_{a,b}(m,n)=am+bn` gives one member of a projective Radon pencil.  When
`a,b>0`, its Laplace transform is exactly

\[
 A(at)A(bt).
\]

The distinguished directions are `(1,0)` (one-leg marginal), `(1,1)`
(Goldbach), and `(1,-1)` (differences, interpreted in the Fourier--Laplace
tube).  Substitution of the explicit formula sends a zero pair
`(rho,rho')` to the corresponding linear combination `a rho+b rho'`;
under RH its oscillatory part is `a gamma+b gamma'`.

This is the exact common carrier of the RH, Goldbach, and twin directions.
It is still only a reformulation until different directions impose a new
compatibility condition.

## 5. The first adelic closure: determinant conservation

Normalize the absolute values of `Q` by `|p|_p=p^{-1}`.  The determinant of
the Hadamard map obeys

\[
 |\det H|_\infty=2,\qquad |\det H|_2=\frac12,\qquad
 |\det H|_p=1\quad(p\ne2),
\]

and therefore

\[
 \boxed{\prod_{v\le\infty}|\det H|_v=1.}
\]

This is the ordinary product formula for the rational number `2`.  In pair
coordinates it says that the archimedean Jacobian of the sum--difference
rotation is cancelled exactly by its unique `2`-adic ramification.  Haar
measure on the full adele plane therefore acquires no global determinant
defect under `H`.

This exact closure is useful but negative for the ambitious route.  At the
volume/determinant level, the adelic transform supplies only a standard
product formula and the familiar exceptional local normalization.  It does
not couple pole--zero or zero--zero terms.  Any new content must live after
volume has cancelled: in phase, positivity/order, or in the failure of a
positive-cone truncation to factor place by place.

The unrestricted quadratic phase is not enough either.  The form
`Q=mn=(S^2-D^2)/4` is a split hyperbolic plane, so its unrestricted adelic
Fourier theory is governed by the standard local Weil indices and their
product formula.  The datum that has no placewise restricted-product
description is the order cut

\[
 m,n>0\quad\Longleftrightarrow\quad S>|D|,
\]

because only the real completion is ordered.  The first potentially new
object is therefore the boundary distribution created by imposing this real
cone simultaneously with the integral/2-adic lattice.  This is an
Arakelov-style orientation, not a claim that existing Arakelov intersection
theory already supplies the needed estimate.

## 6. Proposed successor: an adelic ramified pair transform

The archimedean explicit formula transports the real Hadamard plane but does
not by itself retain the index-two lattice cokernel or positive cone.  The
rational-character fibers in `RATIONAL_FIBER_SPECTRUM.md` retain finite-place
information but are currently assembled direction by direction.

The next target is therefore precise:

> Construct one adelic two-leg transform whose archimedean component is the
> zero-pair Radon pencil and whose finite components retain the integral
> Hadamard lattice, including its unique ramification at `2`.  Determine
> whether the global compatibility law couples distinct projective
> directions beyond the known pole--pole singular series.

### Advancement and kill criteria

- **Advance** only if the construction yields an exact cross-direction
  constraint on a pole--zero or zero--zero term that cannot be recovered by
  applying the existing explicit formulas independently in each direction.
- **Kill** if it is merely the restricted product of the already-known
  Dirichlet-character formulas, or if its only global content is the
  classical Hardy--Littlewood singular series.
- The determinant layer has already met this kill criterion: it is exactly
  the product formula for `2`.  Next test the Fourier phase.  If that is only
  the standard Weil-index product formula, retain the computation as a no-go
  and move to the non-factorizing positive-cone boundary term.
- No positivity, cancellation, RH, Goldbach, twin-prime, or novelty claim is
  made by the elementary nucleus alone.

## 7. Rigor boundary

Proved here: the integral image/cokernel theorem, its local reductions, the
positive-cone reconstruction, and the elementary projective pushforward
identity; also the adelic determinant identity, which is the standard product
formula.  Reinterpreted from proved corpus work: singleton parity rigidity.
Standard structural input: the split-form Weil product law.  Proposed only:
the ordered-cone boundary transform and any cross-place or cross-direction
constraint.  A targeted prior-art search is required before any novelty label
stronger than `possibly-new` is attached to that successor.
