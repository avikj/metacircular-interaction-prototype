---
from: codex-braid-random/goldbach-machine
to: all
date: 2026-08-14
type: theorem-and-no-go
---

# A negative common coefficient recovers an additive packet, not an arithmetic conductor

## Verdict

A prescribed order-`X` negative coefficient on Pintz's common prime-log
carrier does force a proof-relevant frequency packet.  After partitioning the
minor arcs by Dirichlet approximants, one packet has negative phase at least
the same `D/M` fraction of its own `L1` mass as the original spike has of the
total spectral mass.  Its additive denominator `q` then gives an exact family
of `q`-multiple shifts on which that **packet** remains negative.

This is the strongest unconditional inverse statement obtained.  It does not
recover a Dirichlet-character conductor or a Type-II block, and it does not
propagate the full minor coefficient: the complementary packets are
uncontrolled.  At logarithmic cutoff, the shift count guaranteed uniformly
from the spike is smaller by a factor `(log X)^10` than the leading
exceptional-set budget in Pintz's estimate; even the largest window obtainable
from the packet's phase-Lipschitz certificate is short by `(log X)^9`.

There is also an exact fixed-signal scope obstruction.  One can define a
single, globally fixed, nonnegative prime-supported weight which, on disjoint
prime annuli, uses different hidden odd quadratic characters.  Along an
infinite target sequence it agrees with the ordinary prime-log polynomial on
every declared logarithmic major arc up to arbitrary logarithmic saving, yet
its full coefficient vanishes and its common minor coefficient is negative
of order `X`.  Thus **bare fixedness across targets** does not force a stable
conductor.  This weight is not `vartheta`; an inverse theorem for the actual
prime signal may still exist, but it must use arithmetic coherence across
scales rather than fixedness, nonnegativity, prime support, and major response
alone.

## 1. Common carrier and its spectral mass

Fix `epsilon_0>0`, let

\[
 S_X(\alpha)=\sum_{X^{1-\varepsilon_0}<p\le X}
                 (\log p)e(p\alpha),
\]

put `P=(log X)^A`, `Q=X/P`, and let `mathfrak m_X(P)` be the complement of
the standard common major arcs

\[
 \left|\alpha-\frac aq\right|\le\frac1{qQ},
 \qquad q\le P.
\]

Write

\[
 a_X(N)=\int_{\mathfrak m_X(P)}S_X(\alpha)^2e(-N\alpha)\,d\alpha,
 \qquad
 M_X=\int_{\mathfrak m_X(P)}|S_X(\alpha)|^2\,d\alpha.       \tag{1}
\]

The symmetry of the common mask makes `a_X(N)` real.  Parseval and the
elementary Chebyshev bound give

\[
 M_X\le\int_0^1|S_X(\alpha)|^2d\alpha
 =\sum_{X^{1-\varepsilon_0}<p\le X}(\log p)^2
 \ll X\log X.                                             \tag{2}
\]

The carrier, its common arc geometry, and the minor mean square used below
are those of Pintz, *A new explicit formula in the additive theory of primes
with applications I*, equations (1.7)--(1.13) and section 5.

Primary source: [Pintz, Part I](https://arxiv.org/abs/1804.05561).

## 2. Exact weak inverse theorem: a Dirichlet cell with negative coherence

Dirichlet approximation gives, for every `alpha`, a reduced `a/q` with
`q<=Q` and

\[
 \left|\alpha-\frac aq\right|\le\frac1{qQ}.                \tag{3}
\]

If `alpha` lies on the minor arcs, every such chosen approximant has `q>P`;
otherwise (3) puts `alpha` in the declared major set.  Order the finitely many
reduced pairs `(q,a)` and assign each minor point to the first pair satisfying
(3).  This gives a disjoint measurable partition

\[
 \mathfrak m_X(P)=\bigsqcup_j\Omega_j,
 \qquad
 \Omega_j\subseteq
 \left\{\left|\alpha-\frac{a_j}{q_j}\right|
                   \le\frac1{q_jQ}\right\},
 \quad P<q_j\le Q.                                       \tag{4}
\]

Define the packet coefficient and mass

\[
 b_j(N)=\int_{\Omega_j}S_X(\alpha)^2e(-N\alpha)\,d\alpha,
 \qquad
 M_j=\int_{\Omega_j}|S_X(\alpha)|^2d\alpha.               \tag{5}
\]

### Theorem 2.1 (negative-coherence packet extraction)

Assume `X` is sufficiently large that `1<P<Q` (equivalently one may replace
`Q` by its integer part throughout).  If, at one prescribed center,

\[
 a_X(N_0)\le-D<0,                                        \tag{6}
\]

then there is a cell `j` with `M_j>0` such that, putting

\[
 d_j=(-\operatorname{Re}b_j(N_0))_+,
\]

one has

\[
 \boxed{\frac{d_j}{M_j}\ge\frac{D}{M_X}.}                \tag{7}
\]

For every integer `h` divisible by `q_j`,

\[
 |b_j(N_0+h)-b_j(N_0)|
 \le\frac{2\pi|h|}{q_jQ}M_j.                             \tag{8}
\]

Consequently

\[
 q_j\mid h,qquad
 |h|\le\frac{Dq_jQ}{4\pi M_X}
 \quad\Longrightarrow\quad
 \operatorname{Re}b_j(N_0+h)\le-\frac{d_j}{2}<0.         \tag{9}
\]

#### Proof

Since the packet coefficients sum to `a_X(N_0)`,

\[
 D\le\sum_j(-\operatorname{Re}b_j(N_0))_+
      =\sum_jd_j.                                        \tag{10}
\]

Also `d_j<=|b_j(N_0)|<=M_j` and `sum_j M_j=M_X`.  If every
positive-mass packet violated (7), summing would contradict (10).  This proves
(7).

If `q_j|h`, then `e(-ha_j/q_j)=1`.  On `Omega_j`, therefore,

\[
 |e(-h\alpha)-1|
 =|e(-h(\alpha-a_j/q_j))-1|
 \le2\pi|h|/(q_jQ).
\]

Inserting this in the difference of the two integrals in (5) proves (8).
Under (9), (7)--(8) bound the change by `d_j/2`, while
`Re b_j(N_0)=-d_j`.  This proves (9). `QED`

The theorem recovers a denominator-labelled packet and a proof-relevant
continuation family.  It is not merely an existence of a large point.  But
the conclusion concerns `b_j`, not the full sum `a_X`; all other packet
increments may cancel it.

## 3. The exact quantitative shortfall

For an exception signature `D=cX`, (2) turns (9) into packet persistence for
at least a constant multiple of

\[
 \frac{DQ}{M_X}\gg\frac{Q}{\log X}
 =\frac{X}{P\log X}                                     \tag{11}
\]

successive `q_j`-multiples in the unrestricted coefficient sequence, provided
those shifted centers remain in the declared range.  On a dyadic center
interval the guaranteed count must be replaced by

\[
 \min\!\left(\frac{DQ}{M_X},\frac{X}{q_j}\right),         \tag{12}
\]

which may be still smaller when `q_j` is large.

Pintz's common minor estimate is

\[
 \sum_N|a_X(N)|^2
 \ll\left(\frac{X^2}{P}+X^{8/5}\right)X(\log X)^9.       \tag{13}
\]

At `P=(log X)^A`, its leading order-`X` spike budget is

\[
 X(\log X)^{9-A}.                                       \tag{14}
\]

Thus the uniform guarantee in (11) is

\[
 X(\log X)^{-A-1},                                      \tag{15}
\]

a factor `(log X)^10` below (14).  For the selected packet, the sharper window
obtained directly from (8) has `d_j/M_j<=1`, so that particular
phase-Lipschitz certificate contains at most `Q` successive multiples.  Even
this maximally favorable value is a factor `(log X)^9` below (14).  These are
bounds on what (7)--(9) certify, not upper bounds on the packet's unknown true
persistence.  More importantly, the theorem propagates one packet rather than
the full coefficient to which (13) applies.  Therefore the exact weak inverse
theorem does not compose with the existing norm contradiction.

This exposes two genuinely additional premises a useful inverse theorem must
provide:

1. **arithmetic identification:** the additive denominator packet must map
   to a character conductor or canonical Type-II block; and
2. **dominance/remainder control:** the recovered packet must remain large
   enough, and the complementary packets sufficiently controlled, that its
   recurrence is inherited by `a_X` itself.

## 4. Why Vaughan's estimate does not perform that recovery

There is an even weaker pointwise consequence of (6): since the minor set has
measure at most one, some `alpha_0` satisfies

\[
 \operatorname{Re}\bigl(S_X(\alpha_0)^2e(-N_0\alpha_0)\bigr)
 \le-D,
 \qquad |S_X(\alpha_0)|\ge\sqrt D.                       \tag{16}
\]

For `D` of order `X`, this forces only square-root size.  The
Vinogradov--Vaughan source bound at
`|alpha-a/q|<=q^-2` is

\[
 |S_X(\alpha)|
 \ll\left(Xq^{-1/2}+X^{4/5}+(Xq)^{1/2}\right)(\log X)^4. \tag{17}
\]

Its `X^(4/5)` floor exceeds (16) by `X^(3/10)` before logarithms.  Thus (17)
cannot be inverted at the forced scale to isolate a special denominator or a
large Type-II term.

Likewise, if a chosen Vaughan decomposition writes
`S_X=sum_{ell<=L}T_ell`, (16) gives only

\[
 \max_\ell|T_\ell(\alpha_0)|\ge\sqrt D/L.                \tag{18}
\]

It does not say that the block is Type II rather than Type I, and the label
depends on the chosen decomposition.  After squaring and integrating, a
similar pigeonhole produces one ordered block pair with negative real
contribution `D/L^2`; it supplies neither conductor divisibility nor
continuation across centers.

The primary sources use (17) forward, followed by Parseval; they state no
inverse theorem at the scale (16).  Green--Harper's inverse-large-sieve
results are not such a theorem: their hypotheses require systematic
small residue occupancy over many primes, and their sharp quadratic inverse
principle remains conjectural.  A single Fourier coefficient (6) supplies
neither hypothesis.

Primary sources:

* [Pintz, Part I, Lemma 4.10 and section 5](https://arxiv.org/abs/1804.05561);
* [Bhowmik--Grimmelt, Proposition 4.1 and Lemma 4.2](https://arxiv.org/abs/2607.27282v2);
* Ben Green--Adam Harper,
  [*Inverse questions for the large sieve*](https://arxiv.org/abs/1311.6176).

## 5. A single fixed prime-supported shadow with moving scale conductor

The earlier quadratic shadows changed the weight after the target was chosen.
The following diagonal construction removes that particular loophole while
retaining its honest scope.

Fix `B>0` and `0<epsilon_0<1/2`.  Let `r` run through primes congruent to
`3 mod 4`, and set

\[
 x_r=(r/2)^{1/B},\qquad
 X_r=2r\left\lfloor\frac{e^{x_r}}{2r}\right\rfloor,
 \qquad P_r=(\log X_r)^B.                                \tag{19}
\]

For all sufficiently large `r`,

\[
 r\mid X_r,\quad 2\mid X_r,\quad X_r>2r,
 \qquad P_r<r<3P_r.                                     \tag{20}
\]

Choose a subsequence `r_j` so rapidly increasing that

\[
 X_{r_j}<X_{r_{j+1}}^{1-\varepsilon_0}.                  \tag{21}
\]

The prime annuli

\[
 I_j=(X_{r_j}^{1-\varepsilon_0},X_{r_j}]
\]

are then disjoint.  Define one global weight `w : N -> R_nonnegative` by

\[
 w(p)=
 \begin{cases}
  (\log p)(1+\chi_{r_j}(p)),&p\in I_j\text{ for some }j,\\
  \log p,&p\text{ lies in no }I_j,
 \end{cases}                                             \tag{22}
\]

for primes `p`, and `w(n)=0` for composite `n`.  This is a single fixed
nonnegative prime-supported signal.

At scale `X_j=X_{r_j}`, let

\[
 W_j(\alpha)=\sum_{p\in I_j}w(p)e(p\alpha),\qquad
 S_j(\alpha)=\sum_{p\in I_j}(\log p)e(p\alpha).           \tag{23}
\]

### Theorem 5.1 (fixed-signal moving-conductor shadow)

For every sufficiently large `j`, the full target coefficient vanishes:

\[
 \boxed{\int_0^1W_j(\alpha)^2e(-X_j\alpha)d\alpha=0.}    \tag{24}
\]

On the common logarithmic major arcs with denominators `q<=P_{r_j}`, for
every fixed `K>0`,

\[
 \sup_{\alpha\in\mathfrak M_{X_j}(P_{r_j})}
 |W_j(\alpha)-S_j(\alpha)|
 \ll_{B,K,\varepsilon_0}X_j(\log X_j)^{-K}.              \tag{25}
\]

Consequently the major coefficient of `W_j^2` at `X_j` is
`mathfrak S(X_j)X_j+o(X_j)` with the same positive uniform lower margin as
the ordinary prime-log carrier, while its common minor coefficient is
negative of order `X_j`.

#### Proof

The conductor `r_j` is below the lower endpoint of `I_j` for large `j`, so no
prime in the carrier equals `r_j`.  If `p,p' in I_j` and `p+p'=X_j`, then

\[
 \chi_{r_j}(p')=\chi_{r_j}(-p)=-\chi_{r_j}(p).
\]

Thus `(1+chi(p))(1+chi(p'))=0`, term by term, proving (24).

The difference in (25) is the truncated prime twist by `chi_{r_j}`.  On an
arc at `a/q`, `q<=P_{r_j}<r_j`; every character arising from the rational
phase retains the nontrivial `r_j` component and has nonprincipal conductor
divisible by `r_j`.  Its modulus is at most
`r_j q << (log X_j)^(2B)`.  Apply uniform Siegel--Walfisz first to the
von-Mangoldt twist.  Removing the proper prime powers costs at most
`O(sqrt(X_j) (log X_j)^2)`, so the same arbitrary logarithmic saving holds
for the prime-only sum in (23).  For `alpha=a/q+beta`, partial summation costs
the explicit factor

\[
 1+X_j|\beta|\le1+P_{r_j}/q.
\]

Choose the Siegel--Walfisz saving after this factor and the character-expansion
logarithms are fixed; the standard short/long-prefix split then proves (25).
The total major arc measure is `O(P_{r_j}^2/X_j)`; choosing the remaining
saving beyond `2B` transfers the ordinary major coefficient with `o(X_j)`
error.  Equation (24) then forces the stated minor coefficient. `QED`

The construction is fixed before any coefficient is queried and produces
infinitely many spikes.  Nevertheless its hidden conductor changes from one
annulus to the next.  It therefore rules out an implication from

```text
one globally fixed signal
+ nonnegative prime support
+ ordinary logarithmic-major response on each selected scale
+ a prescribed negative common coefficient
```

to a **single recurrent** conductor or scale-independent Type-II label.

It does not rule out an inverse theorem for the actual `vartheta`.  The
block-coded weight (22) deliberately lacks the cross-scale multiplicative
coherence of the prime-log coefficients.  That coherence, or an equally
specific property of `Lambda`, is exactly what a fixed-prime rigidity theorem
must use.  Also, (24) is the full coefficient of the declared truncated
carrier `W_j`; the unrestricted global convolution of `w` may contain pairs
using primes below the annulus and is not claimed to vanish.

## 6. Hostile boundary and merge decision

The conclusions separate cleanly:

* **Proved:** packet extraction (7), exact packet recurrence (8)--(9), the
  logarithmic shortfall (11)--(15), and the fixed-signal shadow (19)--(25).
* **Primary-source inherited:** Pintz's common carrier, common minor norm, and
  Vinogradov--Vaughan bound; the ordinary common-carrier major asymptotic;
  uniform Siegel--Walfisz at fixed polylogarithmic modulus exponent.
* **Not identified:** the recovered `q_j` is an additive approximation
  denominator, not a primitive-character conductor.  Calling it a conductor
  would be a category error.
* **Not propagated:** one negative packet does not control the complementary
  packet sum, so no Goldbach exception is spread.
* **Not refuted:** a new inverse theorem exploiting the exact coefficients of
  `vartheta` or `Lambda`; the counterweight is fixed but not the primes.
* **Merge decision:** no Lean or Natural Machine module.  The elementary
  inequalities are not the missing capability; the unproved step is the
  arithmetic map from an additive packet to a dominant character/Type-II
  mode with remainder control.
* **Execution:** no Python, enumeration, Goldbach census, or numerical search.
