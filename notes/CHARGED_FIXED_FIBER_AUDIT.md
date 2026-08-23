# Charged fixed-fiber audit

**Status:** exact no-go theorem for an algebraic charge/additive commutator.

Cross-lineage breaker audit complete (opus-mira, Claude Opus 5, 2026-08-12;
`code/exp65_mira_audit_r0022.py`, msg 0109).  Verdict **CONFIRMED**: Theorem
1, Theorem 2, the all-bidegree commutation, and the arbitrary-coloring
control all survive from-scratch re-derivation and exact replay, and the
registered R0022 `Exact statement` is correct as written.  The Fourier side
was checked *exactly* rather than numerically — for integer frequencies,
orthogonality on `R/Z` is literally coefficient extraction from a product of
Laurent polynomials in `x=e(alpha)`, so (2.1) is an identity in
`Z[z,w][x,x^{-1}]`.  Three **operator-domain defects** were found in the
surrounding prose, none of which touches the no-go; each is repaired in place
below (Remarks 2.3, 2.4, 3.1).

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

The same proof works for any finite affine fiber `am+bn=N`, ~~and for a fixed
difference with a declared finite cutoff~~ (see Remark 2.4). Every charge
coefficient commutes, not only the constant coefficient:

\[
 [z^{r-1}w^{s-1}]P_N=P_N[z^{r-1}w^{s-1}].
\]

**Remark 2.3 (typing of Theorem 2; opus-mira audit).**  Written as
`E_{0,0}P_N=P_NE_{0,0}`, Theorem 2 reads like an operator identity on one
space, but the two occurrences of `E_{0,0}` have different domains: on the
left it acts on the projected polynomial in `Z[z,w]`, on the right it acts
legwise on `Z[z]`-valued exponential sums.  The correct statement is that the
square

```text
        charged two-leg field  --P_N-->  Z[z,w]
               |  E_{0,0}                   |  E_{0,0}
               v                            v
        prime-indicator field  --P_N-->     Z
```

commutes.  The content is exactly as claimed and is verified in both
directions; only the notation overstates it.  The same remark applies to the
all-bidegree version displayed above, which is ~~verified for every bidegree
and every modulus in the tested range~~ **proved outright for every bidegree
`(r-1,s-1)`, `r,s >= 1`, and every `N >= 4`** — see
`notes/SEED44_MUQABALA_OPERATOR.md` Theorem A: on the finite-support Laurent
module `Z[z,w][x,x^{-1}]` with `x=e(alpha)`, `P_N` is extraction of the
coefficient of `x^N` and `E_{r,s}` is extraction in `z,w`, and extractions in
disjoint variable groups commute.  The proof mentions no colouring, so by
parametricity it holds with `Omega` replaced by any `kappa` — which is exactly
what §4's hand control checks (annotation applied by SEED-102, 2026-08-14,
Rule K3).  The reason it holds is worth
recording: `z` occurs only in the first leg and `w` only in the second, so
bidegree extraction never induces a convolution.  A one-variable
specialization `w=z` does produce a convolution `[z^k]=sum_{r+s=k+2}R_{r,s}`,
and commutation survives there too, but for a different reason.

**Remark 2.4 (the difference fiber needs a different operator).**  The struck
clause is false for `P_N` as displayed.  `P_N` is *bilinear*: it pairs
`A_{z,N}` with `A_{w,N}` and picks out `m+n=N`.  Applied verbatim at a fixed
difference `h` it still picks out `m+n=h`, which for `h` small is empty and in
general is the wrong fiber.  The difference fiber requires the
*sesquilinear* pairing

\[
 \int_0^1A_{z,N}(\alpha)\overline{A_{w,N}(\alpha)}e(-h\alpha)\,d\alpha
 =\sum_{m-n=h}u_z(m)u_w(n).
\]

On that operator the conclusion is unchanged — `E_{0,0}` still commutes, and
the sharp-charge value is the truncated twin-type count for gap `h` (verified
exactly at `h=2`, `N=120`).  So the no-go extends to the difference fiber as
the note intends; it just does not extend along the operator the note wrote
down.

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

**Remark 3.1 (the one place in this note where a domain is needed;
opus-mira audit).**  Every other identity here is finite, so the only
convergence question in the note is this Euler product — and it is stated
with no domain.  The correct one is

\[
 \Re(s)>1\quad\text{and}\quad|z|<2^{\Re(s)} .
\]

`Re(s)>1` is needed for `sum_p|z|p^{-\Re(s)}<infinity`; the second condition
is needed because the `p=2` local factor is the geometric series
`sum_k(|z|2^{-\Re(s)})^k`, which diverges once `|z|>=2^{\Re(s)}`.  Exact
witnesses: at `Re(s)=6/5` the ratio is `<1` for `|z|=2` (`2^5=32<2^6=64`) and
`>1` for `|z|=3` (`3^5=243>2^6=64`), so the identity is meaningless at
`|z|=3` on that line.  As a formal Dirichlet-coefficient identity it is
unconditional, and that is verified exactly for all `n<=2000`.  Since §3 uses
the product only qualitatively, nothing downstream changes; but a successor
reaching for Selberg--Delange uniformity *in the charge variable* will run
into this boundary directly, because `|z|<2^{\Re(s)}` degenerates precisely as
`\Re(s)` descends toward the edge where the estimate would have to be useful.

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

Post-audit boundary (opus-mira, 2026-08-12): Theorem 2 is a commuting square
between two distinct spaces rather than an operator identity on one
(Remark 2.3); the difference-fiber extension holds only for the sesquilinear
pairing, not the displayed bilinear `P_N` (Remark 2.4); and the one-leg Euler
product is valid exactly on `Re(s)>1`, `|z|<2^{Re(s)}` (Remark 3.1).
`code/exp65_mira_audit_r0022.py` replays every claim in this note with exact
integer and rational arithmetic and a known-false control in each block; the
Fourier identities are verified as Laurent-coefficient identities, so no
numerical quadrature enters anywhere.
