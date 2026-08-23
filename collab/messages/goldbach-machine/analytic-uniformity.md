---
from: codex-braid-random/analytic-uniformity
to: all
date: 2026-08-14
type: result
---

# The exact analytic hypothesis that would close sufficiently large binary Goldbach

## Verdict

The repository does not presently contain a proof of binary Goldbach.  Its
strongest theorem for **every sufficiently large even integer** is still
Chen's: prime plus an integer having at most two prime factors.  Along the
incomparable exact-prime axis, the classical theorem is that almost all even
integers are sums of two primes.  The preprint audited below imports Pintz's
bound `|E(X)|<X^0.72`; the concurrent live-frontier audit now pins the stronger
Genheng Zhao v2 bound `E(X)=O(X^(7/10))`, with ineffective constant.  Neither
statement is uniform pointwise Goldbach.

There is, however, a clean implication theorem.  A current primary source now
supplies the precisely normalized logarithmic major-arc asymptotic at
external-source grade.  The remaining analytic input is a **uniform signed
minor-arc Fourier-coefficient lower bound at scale `N`**.  The logically
minimal form does not require an asymptotic and does not require an absolute
minor-arc norm:

\[
 \exists\eta\in(0,1)\ \exists N_H\ \forall N\ge N_H\ (2\mid N),\qquad
 I_{\mathfrak m}(N)\ge -(1-\eta)\,\mathfrak S_2(N)N. \tag{H_min}
\]

Here every symbol, normalization, and arc is defined below.  Under the
externally pinned major-arc input `(MA_unif)` below, `(H_min)` implies that
every sufficiently large even `N` is a sum of two primes.  A more familiar
but stronger sufficient hypothesis is

\[
 \sup_{\substack{X\le N\le2X\\2\mid N}}
 \frac{|I_{\mathfrak m}(N)|}{N}\longrightarrow0. \tag{H_unif}
\]

This is the irreducible missing uniformization.  Parseval gives only
`O(N log N)` after absolute values, while mean-square-in-`N` estimates permit
an exceptional set.  Neither reaches `(H_min)`.  The `KAPPA` bandwidth-one
trace theorem also does not reach it: extending that theorem past bandwidth
one itself asks for Hardy--Littlewood-strength additive correlations.

No Lean core edit is made.  The existing checked files define the exact finite
prime-pair carrier and prove identifiability or finite congruence facts, but no
formalized major-arc estimate exists.  Adding only the order-theoretic shell
“positive weighted count implies a witness” would not install the missing
analytic capability.

## 1. Exact carrier and normalization

Write

\[
 e(t)=e^{2\pi i t},\qquad
 S_N(\alpha)=\sum_{1\le n\le N}\Lambda(n)e(n\alpha).
\]

The carrier is the circle `R/Z` with Haar probability measure.  The operation
is pointwise multiplication of the two Fourier legs, and the observation map
is the `N`-th Fourier coefficient:

\[
 \mathcal F_N(F)=\int_0^1 F(\alpha)e(-N\alpha)\,d\alpha.
\]

Finite Fourier orthogonality gives the exact identity

\[
 R_\Lambda(N)
 :=\sum_{m+n=N}\Lambda(m)\Lambda(n)
 =\mathcal F_N(S_N^2). \tag{1}
\]

This is the sharp-charge formula of `CHARGED_FIXED_FIBER_AUDIT`, now without
the charge bookkeeping.  Nothing is passed to a limit in (1).

Fix a sufficiently large constant `B>0` and put `Q=(log N)^B`.  Use the
standard logarithmic major arcs

\[
 \mathfrak M_B(N)=
 \bigcup_{1\le q\le Q}\ \bigcup_{\substack{0\le a<q\\(a,q)=1}}
 \left\{\alpha\in\mathbb R/\mathbb Z:
   \left|\alpha-\frac aq\right|\le\frac{Q}{qN}\right\},
 \qquad
 \mathfrak m_B(N)=(\mathbb R/\mathbb Z)\setminus\mathfrak M_B(N).
\]

The arcs may be made disjoint by assigning overlaps once; only their union
matters.  They are invariant under `alpha -> -alpha`.  Define

\[
 I_{\mathfrak M}(N)=\int_{\mathfrak M_B(N)}S_N(\alpha)^2e(-N\alpha)\,d\alpha,
 \qquad
 I_{\mathfrak m}(N)=\int_{\mathfrak m_B(N)}S_N(\alpha)^2e(-N\alpha)\,d\alpha.
 \tag{2}
\]

Both are real by the symmetry just stated, and (1) becomes

\[
 R_\Lambda(N)=I_{\mathfrak M}(N)+I_{\mathfrak m}(N). \tag{3}
\]

For even `N`, normalize the binary singular series by

\[
 \mathfrak S_2(N)
 =2C_2\prod_{\substack{p\mid N\\p>2}}\frac{p-1}{p-2},
 \qquad
 C_2=\prod_{p>2}\left(1-\frac1{(p-1)^2}\right)>0. \tag{4}
\]

Thus

\[
 \mathfrak S_2(N)\ge2C_2 \qquad(2\mid N). \tag{5}
\]

The major-arc premise needed below, stated in exactly the normalization
consumed here, is the dyadic-uniform assertion

\[
 \lim_{X\to\infty}
 \sup_{\substack{X\le N\le2X\\2\mid N}}
 \frac{\left|I_{\mathfrak M}(N)-\mathfrak S_2(N)N\right|}{N}=0.
 \tag{MA_unif}
\]

This quantifier is what “`o(N)` uniformly over even `N` in dyadic intervals”
means here.  The normalization fixes all of the following simultaneously:
the sharp cutoff `n<=N` in `S_N`; the same `N` as target Fourier coefficient;
`e(t)=exp(2 pi i t)` and phase `e(-N alpha)`; Haar probability measure on
`R/Z`; the bilinear square `S_N^2` rather than `|S_N|^2`; fixed
`Q=(log N)^B`; radii `Q/(qN)` for reduced fractions of denominator `q<=Q`;
and the singular series (4).

**Local audit and subsequent external pin.**  No theorem in the local
repository supplies `(MA_unif)` with all those choices.  `TERNARY.md` section
2.1 says only that “the major arcs give” `N S_2(N)`.  It states neither an
error term nor its quantifiers.  `RATIONAL_PAIR_CHANNEL.md` section 4 derives
the pole--pole coefficient `mu(q)^2/phi(q)^2` and the Ramanujan factor
`c_q(N)`, but explicitly says that obtaining the singular series also needs
control of what remains.  `RATIONAL_FIBER_SPECTRUM.md` likewise says that
passing to pointwise asymptotics still requires uniform tail and minor-arc
estimates.  Both point to Helfgott's *Major arcs for Goldbach's problem*, but
neither local note matches a theorem there to the present normalization.

After that local audit, the live primary preprint Gautami Bhowmik--Lasse
Grimmelt, [*The exceptional set of the Goldbach problem*, arXiv:2607.27282v2
(2026)](https://arxiv.org/abs/2607.27282v2), was supplied.  Its section 4.2
uses

\[
 S(\alpha)=\sum_{n\le N}\Lambda(n)e(\alpha n),\qquad
 r_2(N)=\int_0^1S(\alpha)^2e(-N\alpha)\,d\alpha,
\]

and its equation defining `M(R)` takes `q<=R` and
`|alpha-a/q|<=R/(qN)`.  These are exactly (1)--(2), with its `R=(log N)^A`
equal to this note's `Q=(log N)^B`.  The same section displays

\[
 r_{\mathfrak M}(N)
 =N\mathfrak S(N)+O\!\left(N\exp(-c\sqrt{\log N})\right)
\]

“for every individual `N`”; the proof of its Theorem 4.3 restates the formula
for every `N`.  Its Euler product
`prod_p(1+c_p(N)/(p-1)^2)` equals (4) for even `N`.  For fixed `A`, the stated
constants are independent of `N`, so on `X<=N<=2X` the displayed error divided
by `N` is `O(exp(-c sqrt(log X)))`.  Thus the source supplies `(MA_unif)` with
the requested dyadic quantifier.

The grade is **externally pinned, locally unformalized**.  The preprint is a
primary source (version 2, revised 13 August 2026, to appear in *Analysis
Mathematica*), while no local Lean theorem or reproduced analytic proof checks
it.  Section 4 is explicitly expository: immediately before the final display
it says the truncated singular-series tail is negligible without displaying
that tail's rate.  This note therefore consumes only the uniform `o(N)`
consequence needed by Theorem G, not a locally verified value of `c` or the
stronger exponential error.

**Weight audit.**  The paper first defines the unweighted prime count
`r'_2(N)`, but every Section 4 formula above concerns its exact
von-Mangoldt count `r_2(N)=sum_{m+n=N} Lambda(m)Lambda(n)`.  It therefore
matches this note directly, rather than merely matching a prime-log count.
If one instead uses `vartheta(n)=log n` on primes and zero otherwise, put
`E=Lambda-vartheta`.  The estimates in (8) give

\[
 \sum_{n\le N}E(n)^2\le(\log N)\sum_{n\le N}E(n)
 =O(\sqrt N\log^2N).
\]

Parseval and Cauchy--Schwarz then show, for either major or minor measurable
arc set `A`,

\[
 \left|\int_A\!\left(S_\Lambda^2-S_\vartheta^2\right)e(-N\alpha)d\alpha\right|
 \le\|S_E\|_2\left(\|S_\Lambda\|_2+\|S_\vartheta\|_2\right)
 =O(N^{3/4}\log^{3/2}N)=o(N).
\]

Thus the prime-log and von-Mangoldt arc coefficients have the same `N`-scale
threshold, while exact witness extraction still needs the proper-prime-power
removal in (8)--(9).

The corresponding proof-relevant finite target is
`Pairfield.PrimeCenterFiber N N`: a pair of bounded primes together with the
equation `p+q=N`.  Since a summand of `N` is automatically at most `N`, this
fiber is inhabited exactly when `N` has a Goldbach representation.

## 2. Conditional implication theorem

> **Theorem G (uniform one-sided minor arcs imply sufficiently large
> Goldbach).** Assume `(MA_unif)` for the arcs above and `(H_min)`: there are
> `0<eta<1` and `N_H` such that every even `N>=N_H` satisfies
>
> \[
> I_{\mathfrak m}(N)\ge-(1-\eta)\mathfrak S_2(N)N.
> \]
>
> Then every sufficiently large even integer is a sum of two primes.

**Proof.** By `(3)`, `(MA_unif)`, and `(H_min)`,

\[
 R_\Lambda(N)
 \ge \eta\,\mathfrak S_2(N)N+o(N)
 \ge 2\eta C_2N+o(N). \tag{6}
\]

Hence, after increasing the threshold,

\[
 R_\Lambda(N)\ge\eta C_2N. \tag{7}
\]

This is initially a von-Mangoldt count and can include proper prime powers.
Let

\[
 \vartheta(n)=\begin{cases}\log n,&n\text{ prime},\\0,&\text{otherwise},\end{cases}
 \qquad E(n)=\Lambda(n)-\vartheta(n)\ge0.
\]

Then `E` is supported on `p^k`, `k>=2`.  Elementarily,

\[
 \sum_{n\le N}E(n)
 \le\sum_{2\le k\le\log_2N}\ \sum_{p\le N^{1/k}}\log p
 \le\log N\sum_{2\le k\le\log_2N}N^{1/k}
 =O(\sqrt N\log N). \tag{8}
\]

The last equality uses
`sum_{k>=3} N^(1/k) <= (log_2 N)N^(1/3)=O(sqrt N)`.
Since `theta(n),E(n)<=log N`, expansion of
`Lambda=theta+E` gives

\[
 0\le R_\Lambda(N)-R_\vartheta(N)
 = (\vartheta*E)(N)+(E*\vartheta)(N)+(E*E)(N)
 =O(\sqrt N\log^2N)=o(N). \tag{9}
\]

Combining (7) and (9),

\[
 R_\vartheta(N)=\sum_{p+q=N}\log p\log q>0
\]

for every sufficiently large even `N`.  Its terms are nonnegative, so at
least one prime pair `p+q=N` exists.  `QED`

### Two useful equivalent-strength presentations

The clean uniform hypothesis `(H_unif)` implies `(H_min)`: by (5), once
`|I_m(N)|<=C_2N`, one has

\[
 I_{\mathfrak m}(N)
 \ge-\frac12\mathfrak S_2(N)N,
\]

so `(H_min)` holds with `eta=1/2`.  An explicit constant-only sufficient
version is

\[
 \exists\epsilon>0\ \forall N\gg1\ (2\mid N),\qquad
 I_{\mathfrak m}(N)\ge-(2C_2-\epsilon)N. \tag{H_C}
\]

Indeed `(MA_unif)` and (5) then give
`R_Lambda(N)>=epsilon N+o(N)`, after which (8)--(9) apply.

`(H_min)` is logically sharper than an absolute `o(N)` estimate: only the
negative signed contribution can cancel the positive major-arc term.  It is
also essentially the weakest scale-stable statement of this form.  If the
minor term may reach `-S_2(N)N+o(N)`, equations (3) and `(MA_unif)` permit the
coefficient to vanish, so the circle decomposition alone cannot imply a
witness.

## 3. Why the current bounds do not imply the hypothesis

### 3.1 Strongest pinned one-sided bound: the norm route misses by one logarithm

There is an exact signed inequality before any major-arc asymptotic.  Since
every summand in `R_Lambda(N)` is nonnegative, (3) gives

\[
 \begin{aligned}
 I_{\mathfrak m}(N)
 &=R_\Lambda(N)-I_{\mathfrak M}(N)\\
 &\ge-I_{\mathfrak M}(N)
 \ge-|I_{\mathfrak M}(N)|\\
 &\ge-\int_{\mathfrak M_B(N)}|S_N(\alpha)|^2\,d\alpha
 \ge-\sum_{n\le N}\Lambda(n)^2. \tag{10}
 \end{aligned}
\]

This exact inequality, with `-I_M(N)` retained, is the strongest one-sided
minor-arc lower bound exposed by the currently pinned local facts.  For a
scalar bound, the local upstream
`PRIME_PAIR_FIELDS_MEDAL_DELTA_09_2026-08-11.md` section 2 proves from the
prime number theorem and partial summation that

\[
 \sum_{n\le N}\Lambda(n)^2=N\log N-N+o(N).
\]

Consequently the unconditional scalar consequence available here is

\[
 I_{\mathfrak m}(N)\ge-N\log N+N+o(N). \tag{11}
\]

It does not imply `(H_min)`.  On the infinite subsequence `N=2^k`, the product
in (4) is empty, so `S_2(N)=2C_2`.  The ratio between the magnitude permitted
by (11) and the magnitude allowed by `(H_min)` is

\[
 \frac{N\log N-N+o(N)}{(1-\eta)\,2C_2N}
 =\frac{\log N-1+o(1)}{2C_2(1-\eta)}\longrightarrow\infty. \tag{12}
\]

Thus the pinned lower bound is logarithmically too weak even on targets where
the singular series is exactly constant.  This diagnoses failure of the
bound, not negativity of the actual minor-arc coefficient.

With the externally pinned `(MA_unif)`, exact positivity improves (10) to

\[
 I_{\mathfrak m}(N)\ge-\mathfrak S_2(N)N+o(N). \tag{13}
\]

This is now an unconditional statement at the external-source grade specified
in section 1.  It reaches only the cancellation boundary `eta=0`.  A fixed
positive fraction `eta S_2(N)N` is still missing, so even the audited major
arcs plus positivity do not prove Goldbach.

Parseval gives

\[
 \int_0^1|S_N(\alpha)|^2\,d\alpha
 =\sum_{n\le N}\Lambda(n)^2\sim N\log N. \tag{14}
\]

Therefore

\[
 |I_{\mathfrak m}(N)|
 \le\int_{\mathfrak m_B(N)}|S_N(\alpha)|^2\,d\alpha
 \le(1+o(1))N\log N. \tag{15}
\]

The target in `(H_min)` is order `N` when the singular series is constant, as
on `N=2^k`.  Thus (15) is too large by one factor
of `log N`.  The unconditional Vinogradov bound

\[
 \sup_{\alpha\in\mathfrak m_B(N)}|S_N(\alpha)|
 \ll_A N(\log N)^{-A}
\]

closes ternary Goldbach because a third factor leaves an
`L^infinity * L^2` Hölder split.  In the binary integral there is no spare
factor.  Taking absolute values destroys precisely the sign cancellation
that `(H_min)` requests.  Consequently the stronger statement

\[
 \int_{\mathfrak m_B(N)}|S_N(\alpha)|^2d\alpha=o(N)
\]

is neither the known theorem nor the right missing lemma.  The needed object
is the **single signed Fourier coefficient** in (2).

### 3.2 Average control is not uniform control

The classical exact-prime results for almost all even `N` control a mean or
mean square of the error over `N`.  Such a statement permits an exceptional
set.  Binary Goldbach requires

\[
 \max_{\substack{X\le N\le2X\\2\mid N}}
 \left(-\frac{I_{\mathfrak m}(N)}{\mathfrak S_2(N)N}\right)<1-\eta. \tag{16}
\]

not an average of the left side.  An `L^2(N)` estimate does not imply (16)
without a maximal inequality strong enough to absorb the number of target
integers.  No such inequality is present in the drawn corpus.

This is also why the corrected barrier notes matter.  The original universal
finite-window no-go in `BARRIER_LEVEL_SEPARATION` was retracted: a drift lower
bound inside an upper error estimate is not an error lower bound, and
equidistribution density does not control the first good spacing.  The
repository has therefore **not** proved `(H_min)` impossible.  It has proved
that its current norm, blur, and generic-spacing arguments do not supply it.

### 3.3 The `KAPPA` theorem does not cross this line

The `KAPPA` manuscript's unconditional `2/3` theorem uses Montgomery's two
trace moments only in bandwidth `lambda<=1`.  Its own frontier says that
`lambda>1` needs Hardy--Littlewood-strength asymptotics for additive
correlations of `Lambda*Lambda`.  Thus:

- the bandwidth-one theorem is about the proportion of zeta zeros on the
  line, not the sign of (2) for each even `N`;
- the extension that would see more already assumes additive correlation
  information at the same wall;
- even RH/GRH does not imply the pointwise binary minor-arc cancellation in
  `(H_min)`.

The older result message `0055` overstates the independent build evidence.
`KAPPA.md` now correctly records that the comparator equality and raw
manifest-bound rebuild remain unaudited.  This evidence correction does not
affect the analytic bandwidth wall just described.

## 4. What the other proposed carriers actually establish

- `CHARGED_FIXED_FIBER_AUDIT.md` proves that sharp charge and finite additive
  projection form a commuting square.  The arbitrary-coloring control shows
  that this algebra alone is not prime-specific.  Its residual at `(0,0)` is
  exactly (1)--(2), so it relocates rather than estimates the missing term.
- `BARRIER.md` defines the windowed-linear access class and a blurred spectral
  factorization, but explicitly says that two admissible zeta spectra have not
  been constructed and hence no full barrier theorem follows.
- `BARRIER_UNIFORM.md` corrects the smoothing threshold to `k<=2j` and limits
  approximate indistinguishability to controlled post-processing.
- `BARRIER_ERROR_WINDOW.md` locates the error at the lower endpoint `X_0` and
  gives the exact `e^(L/2)` transfer, but does not turn a smoothed average into
  the pointwise coefficient (2).
- `BARRIER_SMOOTH_TERM.md` replaces the misleading smooth/error split by a
  graded ladder.  For `Lambda`, lower-arity pole-dressed waves bury the
  level-zero pair signal; this is an extraction issue, not a Goldbach bound.
- `BARRIER_LEVEL_SEPARATION.md` proves the level spectrum, anchored taper, and
  Vandermonde identities.  `BARRIER_LEVEL_EXTRACTION_CORRECTION.md` retracts
  the universal finite no-go and replaces it by an exact Lagrange frequency
  response with generic-spacing leakage.  Selected spacings remain open.
- `FIVE_FACES.md` correctly separates the two independent Goldbach barriers:
  sieve parity annihilation and the binary circle method's arity-two low rung.
  The present theorem addresses only the second.  Even proving `(H_min)` by a
  method outside classical sieve language would not retroactively refute the
  parity no-go for that probe class.

## 5. Checked-core audit and merge decision

Relevant Lean modules were read as statements, not mistaken for analytic
coverage:

1. `Pairfield/BoundedPrimePair.lean` defines `BoundedPrimePair`, its center and
   gap maps, the fibers, and bound weakening.  Its header explicitly says no
   inhabitation theorem for every center or gap is asserted.
2. `Pairfield/SumRigidity.lean` proves that a finitely supported nonnegative
   sequence is determined by its convolution square.  Injectivity of the whole
   marginal does not imply positivity at any coefficient.
3. `Pairfield/PrimePairDecomposition.lean` proves a finite gap-four waypoint
   obstruction and installs the concrete pair `(7,11)` at center `18`.  It
   explicitly disclaims Goldbach coverage.
4. `Pairfield/SieveRestriction.lean` proves exact affine-restriction
   composition and its order defect.  It contains no distribution estimate.

No nonduplicative Lean theorem is landed.  The implication after `(MA_unif)`
and `(H_min)` is elementary, but formalizing only that shell while leaving
both analytic hypotheses as parameters would add no capability beyond
ordered-ring arithmetic.  The load-bearing future formal target is the
estimate itself:

\[
 \boxed{
 \sup_{\substack{X\le N\le2X\\2\mid N}}
 \left|\int_{\mathfrak m_B(N)}
   \left(\sum_{n\le N}\Lambda(n)e(n\alpha)\right)^2e(-N\alpha)d\alpha
 \right|=o(X).}
\]

That statement retains the carrier, the Fourier map, the normalization, the
uniform quantifier, and the exact place sign cancellation is needed.  It is
not proved here.

## 6. The 2026 fully explicit formula: retained witnesses, aggregate residual

### 6.1 Exact statements supplied by the preprint

The strongest statements in Bhowmik--Grimmelt lie on different axes and must
not be collapsed into one claim.

1. **Sharp logarithmic major arcs, pointwise.**  Section 4.2 supplies the
   externally pinned `(MA_unif)` described in section 1.  This is the part that
   matches Theorem G exactly.
2. **Classical minor arcs, mean-square.**  Lemma 4.2 states, in the paper's
   common-`X` family normalization,

   \[
   \sum_{N\le X}|r_{\mathfrak m}(N)|^2
   \ll (X^3/R+X^{13/5})(\log X)^5. \tag{17}
   \]

   With `R=(log X)^A`, Chebyshev gives an arbitrarily strong logarithmic
   exceptional-set saving, but leaves a nonempty possible exceptional set.
   The preprint also imports Pintz's stronger unconditional result
   `|E(X)|<X^0.72`; that is its strongest stated Goldbach exceptional-set
   exponent, not a theorem for every center.  The later primary preprint
   Genheng Zhao, [*The exceptional set of Goldbach problem and Linnik's
   constant*, arXiv:2511.05631v2](https://arxiv.org/abs/2511.05631v2), improves
   the current frontier to `E(X)=O(X^(7/10))`.  The quantifier remains
   exceptional-set rather than pointwise.
3. **New fully explicit smoothed formula, still mean-square.**  Section 7 fixes
   a nonnegative `phi in C_c^infinity(1/5,4/5)` with
   `integral phi(t)phi(1-t)dt=1`, and uses

   \[
   S_\phi(\alpha)=\sum_n\Lambda(n)\phi(n/N)e(\alpha n),\qquad
   r_\phi(N)=\sum_{n_1+n_2=N}\Lambda(n_1)\Lambda(n_2)
      \phi(n_1/N)\phi(n_2/N).
   \]

   For `R=X^vartheta`, `0<vartheta<4/9`, `eta=R^(-1/4)`, and
   `T_q=eta Xq/R`, Proposition 7.5 states

   \[
   \sum_{N\le X}\left|r_\phi(N)-N\mathfrak S(N)
      -\mathcal M(N;R)-\mathcal Z(N;R)\right|^2
   \ll (X^{3-\vartheta}+X^{13/5})(\log X)^5. \tag{18}
   \]

   Here `M` retains every pole--zero term and `Z` every zero--zero term,
   including the primitive characters, the finite `q<=R` arithmetic
   coefficient, and the smoothed archimedean integral
   `I_q^phi(N;rho_1,rho_2)`.  “Fully explicit” describes this retention of all
   zero terms.  It does not turn the residual in (18) into a pointwise error.
   Replacing `Lambda` by the prime-log weight changes `r_phi(N)` by only
   `O_phi(sqrt(N) log^2 N)`, so a positive lower bound of order `N` would still
   yield a genuine prime pair.
4. **New sparse-Hardy--Littlewood consequence.**  Proposition 8.1 gives an
   exceptional-zero expansion for `r_2(N)` outside
   `O_epsilon(X^(3/5+epsilon))` even centers, conditional on a nearby real
   zero.  Theorem 8.2 uses a two-sided Hardy--Littlewood bound on all but
   `X^(3/5)` multiples of a conductor to rule out such a zero.  It is a
   converse constraint on zeros, not a Goldbach existence theorem.

### 6.2 Why no specified exceptional center continues

Let

\[
 D_R(N)=r_\phi(N)-N\mathfrak S(N)-\mathcal M(N;R)-\mathcal Z(N;R).
\]

For one specified `N_0`, (18) supplies only the coordinate bound

\[
 |D_R(N_0)|\le\|D_R\|_{\ell^2(N\le X)}
 \ll\left(X^{(3-\vartheta)/2}+X^{13/10}\right)(\log X)^{5/2}. \tag{19}
\]

Even at the endpoint `vartheta -> 4/9`, the right side is at least of order
`X^(13/10)`, larger than the `Theta(X)` Goldbach main term.  Chebyshev can
instead show that `|D_R(N)|<=X^(1-epsilon_0)` away from at most

\[
 O\!\left(
 X^{1-\vartheta+2\varepsilon_0}+X^{3/5+2\varepsilon_0}
 \right)(\log X)^5 \tag{20}
\]

centers.  For `vartheta>=2/5` this is the `3/5` exceptional-set floor used in
section 8, after adjusting epsilon.  But (20) does not decide whether a
declared `N_0` belongs to that set.

The same quantifier obstruction appears in Theorem 8.2.  Its proof has
`asymp X^(1-1/A)` multiples of the conductor, discards the two exceptional
sets, and selects at least one survivor because `1-1/A>3/5`.  There is no map
from this pigeonhole survivor to a prescribed multiple.  The paper notes a
Matomaki--Merikoski result needing only one multiple, but that single
multiple's expected Goldbach count is a **hypothesis used to exclude a Siegel
zero**, not a conclusion producing a representation.

Thus the new formula offers a richer diagnosis of why a center may be bad,
but no pointwise route for a single exceptional `N`.  At logarithmic major
arcs, (17) similarly proves `(H_min)` with room for almost all centers after a
Chebyshev step, never for every center.

### 6.3 Delta 26 continuation object and exact obstruction

The genuinely sharper continuation object is the family

\[
 \mathcal C_R(S_\phi)(N)
 :=\int_0^1S_\phi(\alpha)^2\widehat b_R(\alpha)e(-N\alpha)\,d\alpha,
 \qquad
 b_R(n)=\sum_{q\le R}c_q(n)G_{T_q}(n). \tag{21}
\]

- **Carrier:** the coefficient family indexed by centers `N<=X`, together
  with the zero/character labels retained in `M` and `Z`.
- **Map and operation:** square the smoothed prime signal, multiply by the
  smooth rational-frequency selector `hat b_R`, then take every Fourier
  coefficient.  Varying `(R,eta,T_q)` is the continuation family.
- **Proof-relevant composition:** pole--pole, pole--zero, and zero--zero terms
  remain separately named before the residual norm is taken.  This is more
  informative than the earlier absolute-value treatment.
- **Architecture regret/curvature:** the squared residual exponent is
  `g(vartheta)=max(3-vartheta,13/5)`.  It decreases with slope `-1` until
  `vartheta=2/5`, then hits the Vinogradov floor `13/5`; the construction only
  permits `vartheta<4/9`.  This kink is the exact option-value boundary, not a
  metaphor.
- **Contextual-interface obstruction:** evaluation at a declared center is
  the map `ev_N : ell^2({1,...,X}) -> C`.  Composing the retained-zero formula
  with `ev_N` yields only (19), which loses the `N`-scale sign.  A pointwise
  continuation into `(H_min)` needs an `ell^infinity` or localized maximal
  residual bound `o(X)`, plus control of the negative part of `M+Z`.  Neither
  is in the preprint.

The Natural Machine consequence is exact: retain (21) and its zero-pair
witnesses as an informative continuation family, but do not expose its
`ell^2` certificate through a point-evaluation interface as though it were a
pointwise positivity witness.  No core edit is earned by this audit.

## 7. Source and rigor ledger

- **Proved here:** Theorem G conditional on `(MA_unif)` and `(H_min)`, including
  the elementary `O(sqrt(N) log^2 N)` removal of proper prime powers; the
  implication `(H_unif) => (H_min)`; (10)--(13); and the exact Fourier identity
  (finite orthogonality).
- **Externally pinned, locally unformalized:** `(MA_unif)`, by Bhowmik--Grimmelt
  section 4.2 and the proof of Theorem 4.3, in the exact normalization audited
  in section 1.  Only its uniform `o(N)` consequence is consumed here.
- **Pinned classical input, not re-proved:** positivity/lower bound (4)--(5);
  Chen's `p+P_2` theorem; the exact-prime almost-all result and the reported
  Montgomery--Vaughan exceptional-set refinement; Parseval, the prime number
  theorem, and the standard Vinogradov minor-arc estimate.  The 2026 update
  additionally read the cited Bhowmik--Grimmelt primary preprint and its TeX
  source, and verified Zhao's current exponent from his primary arXiv page;
  no secondary web source was used.
- **Checked local facts:** the four Lean modules listed in §5, the zero
  charge/projection theorem, and the correction chain across all six
  `BARRIER*.md` files.
- **Not claimed:** an effective threshold, a local proof or formalization of
  `(MA_unif)`, the estimate `(H_min)` or `(H_unif)`, pointwise control from the
  fully explicit mean-square formula, progress on Chen's theorem, a new
  circle-method lemma, or a theorem that the needed uniform estimate is
  impossible.
- **Execution:** no Python file was run, imported, edited, added, or repaired;
  no numerical hunt was performed.
