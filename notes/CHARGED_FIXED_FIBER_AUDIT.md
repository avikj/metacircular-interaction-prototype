# Charged fixed-fiber audit

**Status:** exact no-go theorem for an algebraic charge/additive commutator.
The charged Euler--Radon family is a useful grading, but its sharp prime
specialization commutes identically with every finite additive projection.
The remaining analytic problem is the classical prime-pair Fourier remainder,
not a new commutator.

## 1. Finite charged fibers

For `n >= 2`, put

\[
 u_z(n)=z^{\Omega(n)-1}.
\]

For `N >= 4`, its ordered fixed-sum fiber is the finite polynomial

\[
 G_N(z,w)=\sum_{m=2}^{N-2}
 z^{\Omega(m)-1}w^{\Omega(N-m)-1}\in\mathbb Z[z,w].
\]

Let

\[
 \pi_r(n)={\bf1}_{\Omega(n)=r},\qquad
 R_{r,s}(N)=\sum_{m=2}^{N-2}\pi_r(m)\pi_s(N-m).
\]

**Theorem 1 (exact charge resolution).** For every `N >= 4`,

\[
 \boxed{G_N(z,w)=\sum_{r,s\ge1}R_{r,s}(N)z^{r-1}w^{s-1}.}
\]

Only finitely many terms occur. In particular,

\[
 G_N(0,0)=[z^0w^0]G_N(z,w)=R_{1,1}(N),
\]

the ordered Goldbach count with both primes at least two.

**Proof.** Partition the finite summation by the ordered pair
`(Omega(m), Omega(N-m))`. The constant term consists exactly of the pairs
with both values equal to one. \(\square\)

Thus `z -> 0` is not a singular limiting operation on a fixed fiber. It is
ordinary evaluation of a polynomial, equivalently extraction of its lowest
bidegree.

## 2. Fourier projection commutes with sharp charge

Write `e(t)=exp(2 pi i t)` and define the finite charged exponential sum

\[
 A_{z,N}(\alpha)=\sum_{2\le n\le N-2}u_z(n)e(\alpha n).
\]

Orthogonality on `R/Z` gives

\[
 \boxed{G_N(z,w)=\int_0^1
 A_{z,N}(\alpha)A_{w,N}(\alpha)e(-N\alpha)\,d\alpha.}
\tag{2.1}
\]

Let `P_N` denote the additive projection on the right of (2.1), and let
`E_{0,0}` evaluate the two charge variables at zero.

**Theorem 2 (zero commutator).** On the finite two-leg charged field,

\[
 \boxed{E_{0,0}P_N=P_NE_{0,0}.}
\]

Consequently

\[
 R_{1,1}(N)=\int_0^1
 \left(\sum_{2\le p\le N-2}e(\alpha p)\right)^2
 e(-N\alpha)\,d\alpha.
\tag{2.2}
\]

**Proof.** Both sums in (2.1) are finite. Evaluation at `(0,0)` is a linear
map on their polynomial coefficients, so it passes through multiplication,
the finite sums, and the integral. Equation (2.2) is the usual exact Fourier
coefficient formula for the prime indicator. \(\square\)

The same proof works for any finite affine fiber `am+bn=N`, and for a fixed
difference with a declared finite cutoff. Every charge coefficient commutes,
not only the constant coefficient:

\[
 [z^{r-1}w^{s-1}]P_N=P_N[z^{r-1}w^{s-1}].
\]

## 3. Where noncommutation can actually appear

Noncommutation can arise only after replacing an exact finite object by an
analytic approximation and then exchanging operations for which uniformity
has not been proved. For example, split the circle into declared major and
minor arcs `M` and `m`. At sharp charge, (2.2) is exactly

\[
 R_{1,1}(N)=
 \int_{\mathfrak M}S_N(\alpha)^2e(-N\alpha)\,d\alpha
 +\int_{\mathfrak m}S_N(\alpha)^2e(-N\alpha)\,d\alpha,
\]

where `S_N(alpha)=sum_{2<=p<=N-2}e(alpha p)`. The second term is precisely the
classical minor-arc remainder for the prime-indicator formulation. The charge
variable supplies no identity relating it to another bidegree.

Likewise, the one-leg Euler product

\[
 1+zB_z(s)=\prod_p(1-zp^{-s})^{-1}
\]

does not survive fixed-sum projection as a two-leg Euler product. Multiplicative
factorization is lost exactly where additive convolution is imposed. A
Selberg--Delange estimate uniform near a charge value can organize the
`Omega`-layers, but a version strong enough at bidegree `(0,0)` on one sharp
fiber already contains the prime-pair estimate it is meant to prove.

This distinguishes two statements that had been conflated:

1. **Exact algebra:** charge extraction and additive projection commute.
2. **Analytic method:** a chosen asymptotic replacement may not be uniform
   enough to justify exchanging its limit with either operation.

The second is approximation error, not an invariant commutator of the field.

## 4. Proves-too-much control

Let `kappa:{2,3,...}-> {1,2,...}` be an arbitrary coloring and replace
`Omega(n)` everywhere by `kappa(n)`. Theorems 1 and 2 remain true verbatim;
the zero-charge layer is simply the arbitrarily chosen color-one set.

Therefore the exact charged fixed-fiber identities use no unique
factorization, no Euler product, and no property of primes. The Euler product
adds one-leg multiplicative structure, but fixed additive projection removes
that factorization and leaves the standard convolution problem. This
false-model control kills the proposal that the finite commutator itself is a
prime-specific source of rigidity.

## 5. Verdict and surviving value

The proposed algebraic hard corner is **closed negatively**:

\[
 [\text{sharp charge},\text{fixed additive projection}]=0
\]

exactly at every finite scale. The charged Euler--Radon field remains a clean
bookkeeping object unifying one-leg prime-zeta singularities and all ordered
`Omega`-layer pair correlations. It does not, by itself, couple those layers
or improve a Goldbach/twin-prime estimate.

A successor must add a theorem absent from arbitrary colorings—for example a
genuine relation among distinct `Omega`-layers after additive projection, or
a multiplicative operator that survives the additive fiber and supplies new
off-diagonal control. Rephrasing a minor-arc estimate as uniformity in charge
does not qualify.

## 6. Rigor boundary

Proved here: the finite polynomial resolution, the Fourier coefficient
identity, exact commutation, and the arbitrary-coloring control. Standard
terminology only: the major/minor-arc decomposition. Not claimed: any new
estimate for its remainder, any asymptotic Goldbach theorem, or novelty of the
elementary identities.
