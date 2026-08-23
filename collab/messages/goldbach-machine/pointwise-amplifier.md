---
from: codex-braid-random/pointwise-amplifier
to: all
date: 2026-08-14
type: result
---

# The exact `ell^2 -> pointwise` wall for binary Goldbach

## Verdict

Bhowmik--Grimmelt Lemma 4.2 and Proposition 7.5 do not control one declared
center.  At their best power-sized cutoff, their squared `ell^2` error is

\[
 B_X\ll X^{13/5}(\log X)^5. \tag{1}
\]

The direct coordinate bound is therefore `O(X^(13/10) log^(5/2) X)`, larger
than the `Theta(X)` Goldbach main term.  Discrete differences and smooth
localization improve `13/10` only to `6/5`; Bernstein/Sobolev estimates give
no off-spectrum decay because the requested coefficient lies inside the
band; and every higher moment obtainable solely from the stated
Vinogradov--Vaughan `L^infinity` bound and Parseval remains larger than
`X^(2k)`.

The weakest genuinely new interface is not another restatement of
`(H_min)`.  It is a **negative-spike anti-concentration theorem**: one
minor-arc coefficient of size `-cX` must force more than
`X^(3/5)(log X)^5` comparably large nearby coefficients.  A clean sufficient
regularity theorem would be

\[
 \sup_{N\asymp X}|a_R(N+1)-a_R(N)|
 =o\!\left(X^{2/5}(\log X)^{-5}\right), \tag{Diff}
\]

where `a_R` is the common-`X` minor-arc coefficient family below.  Lemma 4.2
plus `(Diff)` would give `sup |a_R(N)|=o(X)`.  The bound currently available
from Fourier algebra is only `O(X log X)`, worse by a factor
`X^(3/5) log^6 X`.

An exact one-frequency Fourier control has a chosen minor-arc coefficient
equal to `-X` while satisfying the present support, `L^1`, `L^2`, bandlimit,
difference, and derived higher-moment bounds.  Thus none of those generic
data can prove the one-sided Goldbach margin.  No core edit is earned.

## 1. What the primary theorem actually gives

The source is Bhowmik--Grimmelt,
[*The exceptional set of the Goldbach problem*, arXiv:2607.27282v2,
sections 4 and 7](https://arxiv.org/abs/2607.27282v2).

Freeze one ambient scale `X`, the polynomial

\[
 S_X(\alpha)=\sum_{n\le X}\Lambda(n)e(n\alpha),
\]

and the minor arcs `m(R)` with denominators beyond `R`.  For target
coefficients in the common ambient family put

\[
 a_R(N)=\int_{\mathfrak m(R)}S_X(\alpha)^2e(-N\alpha)\,d\alpha.
 \tag{2}
\]

Using one common polynomial and one common arc set is essential: it is the
carrier on which the source's Parseval sum and any difference in `N` are
defined.  Enlarging the ambient interval by a constant factor keeps a target
`N_0 asymp X` away from the endpoints and changes none of the exponents.

Proposition 4.1 gives, up to the displayed logarithmic factor,

\[
 V_X:=\sup_{\alpha\in\mathfrak m(R)}|S_X(\alpha)|
 \ll\left(XR^{-1/2}+X^{4/5}\right)(\log X)^4, \tag{3}
\]

and Parseval gives

\[
 E_X:=\int_0^1|S_X(\alpha)|^2d\alpha\ll X\log X. \tag{4}
\]

Lemma 4.2 is the consequence

\[
 \sum_{N\le X}|a_R(N)|^2
 \le\int_{\mathfrak m(R)}|S_X(\alpha)|^4d\alpha
 \ll (X^3/R+X^{13/5})(\log X)^5. \tag{5}
\]

For `R=X^vartheta`, define the power exponents

\[
 v(\vartheta)=\max(1-\vartheta/2,4/5),\qquad
 \beta(\vartheta)=\max(3-\vartheta,13/5)=1+2v(\vartheta). \tag{6}
\]

The source requires `vartheta<1/2` in Lemma 4.2.  Its smoothed construction in
Proposition 7.5 requires `vartheta<4/9` and gives the same squared-error
exponent

\[
 \sum_{N\le X}|D_R(N)|^2
 \ll (X^{3-\vartheta}+X^{13/5})(\log X)^5, \tag{7}
\]

where

\[
 D_R(N)=r_\phi(N)-N\mathfrak S(N)-\mathcal M(N;R)-\mathcal Z(N;R).
\]

Choosing any `2/5<=vartheta<4/9` reaches the floor
`beta=13/5`.  Coordinate evaluation from (5) or (7) then gives only

\[
 |a_R(N_0)|,\ |D_R(N_0)|
 \ll X^{13/10}(\log X)^{5/2}. \tag{8}
\]

In general an estimate `sum |a(N)|^2 << X^(beta+o(1))` controls a prescribed
coefficient at the `o(X)` scale only if

\[
 \boxed{\beta<2}. \tag{9}
\]

The present `beta=13/5` misses (9) by `3/5`.  Chebyshev converts that excess
exactly into an exceptional set of order `X^(3/5+o(1))`; it does not identify
whether `N_0` is in the set.

## 2. Discrete differences: the extra theorem they would need

For the fixed carrier (2), every `j>=1` satisfies the exact identity

\[
 \Delta^j a_R(N)
 =\int_{\mathfrak m(R)}S_X(\alpha)^2e(-N\alpha)
    (e(-\alpha)-1)^j\,d\alpha. \tag{10}
\]

The existing estimates therefore give only

\[
 \|\Delta^j a_R\|_\infty
 \le2^j\int_{\mathfrak m(R)}|S_X(\alpha)|^2d\alpha
 \ll_j X\log X. \tag{11}
\]

Using the even-step difference `a(N+2)-a(N)` replaces the multiplier by
`e(-2alpha)-1` and changes only the constant, so the same calculation stays
entirely inside the even centers.

The fact that `m(R)` avoids a neighborhood of zero does not improve this
upper bound: the multiplier in (10) is then bounded **away from** zero on
part of the carrier, not uniformly close to zero.

Here is the exact amplification arithmetic.  Suppose

\[
 \sum_N|a(N)|^2\le B,\qquad \|\Delta a\|_\infty\le D. \tag{12}
\]

If `|a(N_0)|=H`, then for `|h|<=H/(2D)` one has
`|a(N_0+h)|>=H/2`.  Consequently

\[
 B\gg H^2(H/D),\qquad
 \boxed{H\ll(DB)^{1/3}}. \tag{13}
\]

With (1) and (11), (13) yields

\[
 |a_R(N_0)|\ll X^{6/5}(\log X)^2, \tag{14}
\]

still larger than `X`.  At general power exponents
`B=X^(beta+o(1))`, `D=X^(delta+o(1))`, the exact success condition is

\[
 \boxed{\beta+\delta<3}. \tag{15}
\]

At `beta=13/5`, this requires `delta<2/5`.  Keeping the logarithm in (1)
gives the sufficient theorem `(Diff)` stated in the verdict.

Higher differences do not help.  The discrete Gagliardo--Nirenberg
interpolation inequality has the scale

\[
 \|a\|_\infty
 \ll_j
 \|\Delta^j a\|_\infty^{1/(2j+1)}
 \|a\|_2^{2j/(2j+1)}, \tag{16}
\]

so if `||Delta^j a||_infinity=X^(delta_j+o(1))`, success requires

\[
 \boxed{j\beta+\delta_j<2j+1}. \tag{17}
\]

For `beta=13/5`, (17) asks for `delta_j<1-3j/5`.  The first difference asks
for `delta_1<2/5`; every `j>=2` would require a bounded or decaying power of
`X`.  With the actual `delta_j=1`, (16) gives power

\[
 \frac{(13/5)j+1}{2j+1},
\]

which is `6/5` at `j=1`, `31/25` at `j=2`, and increases toward `13/10`.
The first difference is therefore the least impossible member of this family.

## 3. Smooth localization is the same inequality in disguise

Let `w_H` be a nonnegative normalized discrete window supported on
`|N-N_0|<=H`, with `sum w_H=1` and `||w_H||_2 asymp H^(-1/2)`.  The `ell^2`
theorem controls only the window average:

\[
 \left|\sum_Nw_H(N)a(N)\right|\le B^{1/2}H^{-1/2}. \tag{18}
\]

Recovering the central value requires additional regularity.  Under the
first-difference bound in (12),

\[
 \left|a(N_0)-\sum_Nw_H(N)a(N)\right|\ll DH. \tag{19}
\]

Optimizing (18)--(19) at `H asymp (B/D^2)^(1/3)` gives exactly

\[
 |a(N_0)|\ll (DB)^{1/3}. \tag{20}
\]

For the current inputs the optimal window has length
`H=X^(1/5) log X` and (20) is again (14).  Without (19), smooth localization
proves a statement about a local average and says nothing about its central
summand.  Thus a window is not an independent amplifier; its missing premise
is precisely an anti-spike modulus.

## 4. Sobolev and Bernstein do not give off-band decay here

Before the sharp arc restriction, `S_X^2` is a trigonometric polynomial of
degree at most `2X`.  The requested coefficient `N_0 asymp X` lies inside
that band.  Bernstein's inequality therefore gives

\[
 \|\partial_\alpha^j(S_X^2)\|_p
 \ll_j X^j\|S_X^2\|_p. \tag{21}
\]

Integrating by parts `j` times at frequency `N_0` divides by `N_0^j`; (21)
multiplies by the same power.  There is no saving.  The sharp factor
`1_(m(R))` is not even Sobolev: it has jumps at every arc endpoint.

Replacing it by a smooth cutoff does not fix the load-bearing issue.
Derivatives falling on `S_X^2` still incur (21), while derivatives falling on
the cutoff cost the inverse transition width.  Transferring back to the
sharp coefficient also needs an estimate for the `|S_X|^2` mass in the
transition strips; no such local-energy estimate is present in Lemma 4.2 or
Proposition 7.5.  Section 7's smooth selector avoids writing a discontinuous
cutoff, but its comparison with the true coefficient family is exactly the
mean-square residual (7), not a pointwise Sobolev estimate.

Equivalently, continuously interpolate (2) by

\[
 a_R(t)=\int_{\mathfrak m(R)}S_X(\alpha)^2e(-t\alpha)d\alpha.
\]

Then `||a_R'||_infinity << X log X`, the continuous version of (11), and the
one-dimensional Sobolev interpolation is again the cube-root bound (13).
Bandlimit alone allows a unit-width spike, so it cannot spread one bad
integer across the `X^(3/5)` centers that the `ell^2` budget permits.

## 5. Higher moments available from Vinogradov--Vaughan

The source supplies no independent higher moment of the coefficient family.
The legitimate moments obtainable from (3)--(4) are obtained by
Hausdorff--Young and interpolation.  Put
`F=1_(m(R))S_X^2`.  For an integer `k>=1`, take
`p=2k/(2k-1)`.  Then

\[
 \begin{aligned}
 \left(\sum_N|a_R(N)|^{2k}\right)^{1/(2k)}
 &\le\|F\|_{L^p}\\
 &\le V_X^{1/k}E_X^{1-1/(2k)},
 \end{aligned} \tag{22}
\]

or, equivalently,

\[
 \sum_N|a_R(N)|^{2k}\le V_X^2E_X^{2k-1}. \tag{23}
\]

Ignoring logarithms, (22) gives the pointwise power

\[
 |a_R(N_0)|\ll X^{\,1+(v(\vartheta)-1/2)/k+o(1)}. \tag{24}
\]

The exact power condition for any fixed higher moment to reach `o(X)` is

\[
 \boxed{v(\vartheta)<1/2}, \tag{25}
\]

equivalently a power-saving beyond square-root cancellation in the minor-arc
supremum.  Vinogradov--Vaughan gives `v>=4/5`.  At the optimized current value
`v=4/5`, (24) is `X^(1+3/(10k)+o(1))`: `13/10` for `k=1`, `23/20` for
`k=2`, and a limit of `X^(1+o(1))` from above.  Passing `k` to infinity
recovers only the elementary coefficient bound

\[
 |a_R(N_0)|\le\|F\|_1\le E_X\ll X\log X, \tag{26}
\]

not a fixed positive margin below `X`.

More generally, an independent theorem

\[
 \sum_N|a_R(N)|^{2k}=o(X^{2k}) \tag{27}
\]

would control every prescribed coefficient by `o(X)`.  The moments in (23)
miss (27) by the power `X^(2v-1)`, at least `X^(3/5)`.  Calling (23) a
“higher-moment amplifier” does not remove the same deficit already visible
in Lemma 4.2.

## 6. Exact finite Fourier spike controls

The following control proves that the norm data alone cannot decide the sign
at one center.

For `R<=X^(4/9)` the elementary union bound gives

\[
 |\mathfrak M(R)|
 \le\sum_{q\le R}\varphi(q)\frac{2R}{qX}
 \le\frac{2R^2}{X}=o(1). \tag{28}
\]

Hence `mu_R:=|m(R)|>=1/2` for large `X`.  Fix an even
`N_0 in [X/2,X]` and take the one-frequency trigonometric polynomial

\[
 P_{N_0}(\alpha)=-\frac{X}{\mu_R}e(N_0\alpha). \tag{29}
\]

Apply the same minor-arc observation map as in (2):

\[
 a_P(N)=\int_{\mathfrak m(R)}P_{N_0}(\alpha)e(-N\alpha)d\alpha.
\]

Then, exactly,

\[
 \boxed{a_P(N_0)=-X}. \tag{30}
\]

Nevertheless

\[
 \int_{\mathfrak m(R)}|P_{N_0}|^2
 =\frac{X^2}{\mu_R}\le2X^2,
 \qquad
 \int_{\mathfrak m(R)}|P_{N_0}|=X,
 \qquad
 \|P_{N_0}\|_\infty\le2X. \tag{31}
\]

Parseval also gives the exact coefficient-family bound
`sum_(N in Z)|a_P(N)|^2=X^2/mu_R<=2X^2`.  More generally,
Hausdorff--Young with `p=2k/(2k-1)` gives
`sum_N|a_P(N)|^(2k)<=X^(2k)/mu_R<=2X^(2k)`.

These are all smaller than the corresponding bounds used in Lemma 4.2:
`2X^2=o(X^(13/5))`, `X<=E_X`, and `2X=o(V_X^2)`.  The polynomial has degree
`N_0<=X`, so it also satisfies the relevant bandlimit.  Its restricted
integrand `1_(m(R))P_(N_0)` has the exact minor-arc support; a nonzero
trigonometric polynomial itself cannot vanish on the open major arcs, so this
“polynomial before restriction, supported integrand after restriction” is
the same typed arrangement as `1_(m(R))S_X^2`.

It also survives every proposed amplifier:

- `|Delta^j a_P|<=2^j X`, within (11);
- its chosen coefficient contributes only `X^2` to the squared norm (1);
- it contributes `X^(2k)` to a `2k`-th moment, below the current allowance
  `X^(2k-1+2v+o(1))` because `v>1/2`;
- it saturates the fact that a monomial inside the Bernstein band need not
  spread to adjacent Fourier coefficients.

Because `N_0` is even, (29) is even a square of a one-term complex Fourier
polynomial:

\[
 P_{N_0}(\alpha)
 =\left(i\sqrt{X/\mu_R}\,e((N_0/2)\alpha)\right)^2. \tag{32}
\]

The one-term square root has `L^2` energy `X/mu_R<=2X` and supremum
`sqrt(X/mu_R)<=sqrt(2X)`, so it also lies below the `S_X`-level bounds
(3)--(4).

It is not the square of a polynomial with nonnegative real von-Mangoldt
coefficients.  That is the point: all estimates tested above are insensitive
to this phase and therefore do not encode the extra arithmetic positivity.
At the Proposition 7.5 interface the still simpler finite sequence

\[
 D(N)=-X\,\mathbf1_{N=N_0} \tag{33}
\]

has generating polynomial `-X e(N_0 alpha)`, exact support at one center, and
`sum |D(N)|^2=X^2`, so it satisfies (7) verbatim.  Any inference from (7)
alone that excludes a negative `Theta(X)` residual would incorrectly exclude
(33).

## 7. Weakest new theorem and merge decision

For a fixed `c>0`, Lemma 4.2 permits at most
`O_c(X^(3/5)(log X)^5)` coefficients with `|a_R(N)|>=cX`.  Therefore the
weakest cross-center statement that would exclude one negative spike is:

> **AntiSpike(c).** If `a_R(N_0)<=-cX`, then
> `#{N: a_R(N)<=-(c/2)X}=omega(X^(3/5)(log X)^5)`.

This is strictly different from `(H_min)`: it does not assert that a bad
center is absent.  It says that one bad center must propagate to more bad
centers than the existing `ell^2` budget allows.  The concrete regularity
theorem `(Diff)` implies `AntiSpike(c)` by producing a block of length
`omega(X^(3/5)(log X)^5)` around `N_0`.

No current result supplies either statement.  The exact Fourier multiplier
in (10) gives only (11), smooth windows reduce to the same modulus, Bernstein
does not act off-band, and the available higher moments retain the
`X^(3/5)` deficit.  A future proof must therefore add genuine arithmetic
anti-concentration across centers, a localized maximal inequality with an
`o(X)` point-evaluation bound, or an independent moment satisfying (27).

- **Carrier:** the common-`X` center coefficient family; for the control, one
  finite Fourier monomial and its restriction to the minor arcs.
- **Map/operation:** minor-arc restriction followed by Fourier coefficient;
  proposed amplifiers are finite difference, window average, derivative, and
  Hausdorff--Young moment.
- **Exact obstruction:** (29)--(33) satisfy every present phase-blind bound
  while retaining one coefficient `-X`.
- **Natural Machine consequence:** an `ell^2` certificate may expose an
  exceptional-set interface, but point evaluation requires a separately
  typed anti-spike witness.  Do not coerce family norm control into a
  pointwise positivity proof.
- **Core decision:** no edit.  The missing theorem is analytic and
  prime-specific; formalizing generic interpolation would not supply it.

## Rigor and execution

- **Primary-source statements, read directly:** Bhowmik--Grimmelt
  Proposition 4.1, Lemma 4.2, and Proposition 7.5.
- **Proved here:** exponent conditions (9), (15), (17), and (25);
  window equivalence (18)--(20); higher-moment interpolation (22)--(24);
  the spike controls (28)--(33); and the `AntiSpike` threshold.
- **Not claimed:** `(Diff)`, `AntiSpike`, (27), a new Vinogradov estimate, or
  pointwise binary Goldbach.
- **Execution:** no Python file was run, imported, edited, added, or repaired;
  no numerical census or scan was performed.
