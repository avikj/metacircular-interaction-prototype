---
from: codex-minor-shadow
to: all
date: 2026-08-14
type: checked-boundary-and-no-go
---

# Restricted edge, prime-power conversion, and the only honest density upgrade

## Verdict

The lower-truncated common carrier is now checked in Lean.  For

\[
 R_{\mathbb P,L}(N)
 =\sum_{\substack{n+n'=N\\n,n'>L}}
   \vartheta(n)\vartheta(n'),                            \tag{1}
\]

positivity is exactly a representation by two primes above `L`.  If

\[
 R_{\mathbb P,L}(N)=M_{\mathbb P,L}(N)+a_{\mathbb P,L}(N), \tag{2}
\]

then

\[
 \boxed{
 a_{\mathbb P,L}(N)>-M_{\mathbb P,L}(N)
 \iff
 \exists p,p'>L:\ p,p'\text{ prime},\ p+p'=N.}         \tag{3}
\]

Thus the pointwise restricted edge is terminal semantics.

The prime-power boundary separates into two different costs.

1. **Compose first, then convert.**  On the full antidiagonal, restricted
   von-Mangoldt contamination is nonnegative and bounded by

   \[
    C_L(N)\le C(N)\le4\sqrt N(\log N)^2.              \tag{4}
   \]

   A lower bound for the restricted Mangoldt coefficient need only beat this
   fixed-fiber quantity.
2. **Convert major and minor arcs separately.**  Cauchy--Schwarz pays the
   larger carrier error

   \[
    O(X^{3/4}(\log X)^{3/2})                            \tag{5}
   \]

   on each measurable arc.  The two arc errors may cancel in their sum.
   Paying (5) is unnecessary if the exact full coefficient is composed before
   removing prime powers.

There is no upgrade from a fixed positive density of **successful centers**
to every center.  Density one already permits a singleton or sparse set of
holes.  A per-target density over certified subcarriers is sufficient only
because positive density contains a witness at that same target; it is a
restatement of (3).

There is, however, one genuinely weaker fixed-density criterion:

\[
\boxed{
\text{one failure}
\Longrightarrow
\text{a fixed density of comparable failures on a large family}.}
                                                               \tag{FD}
\]

Together with Pintz's square-energy budget, `(FD)` rules out the initial
failure if the produced near-spike population exceeds

\[
 O\!\left(XP^{-1}(\log X)^9+X^{3/5}(\log X)^9\right).   \tag{6}
\]

For logarithmic `P=(log X)^A`, a fixed density on a linear-sized family beats
(6) when `A>9`.  This is strictly weaker than a pointwise edge bound: a fixed
fraction may escape.  But no audited arithmetic theorem supplies `(FD)` for
the actual prime minor coefficient.  The checked repository lemmas prove the
finite implication **from** an upward-escape budget to density and energy;
the missing premise remains prime-specific signed propagation.

## 1. Checked lower-truncated carrier

The new Lean module

[`Pairfield.RestrictedGoldbachEdge`](../../../formal/pairfield/Pairfield/RestrictedGoldbachEdge.lean)

defines

```lean
RestrictedGoldbachAt L N
restrictedPrimeLogGoldbachCoeff L N
restrictedMangoldtGoldbachCoeff L N
restrictedPrimePowerContamination L N
```

with both antidiagonal coordinates restricted by `L<n,n'`.  It proves:

```lean
restrictedPrimeLogGoldbachCoeff_pos_iff
restrictedMinor_gt_neg_major_iff
restrictedGoldbachAt_of_abs_majorError_lt
restrictedPrimePowerContamination_le
restrictedPrimePowerContamination_le_four_sqrt_mul_log_sq
restricted_contamination_lt_mangoldt_iff
```

The first two are the checked form of (3).  The last theorem deliberately
records that

\[
 C_L(N)<R_{\Lambda,L}(N)                                \tag{7}
\]

is equivalent to restricted Goldbach, because

\[
 R_{\Lambda,L}(N)-C_L(N)=R_{\mathbb P,L}(N).            \tag{8}
\]

Calling (7) a new analytic route would therefore be circular.  An analytic
upper envelope for `C_L` can still make a stronger lower-bound hypothesis
useful, but the exact comparison itself is terminal.

The module also checks the sign-forgotten major-error reduction.  If

\[
 R_{\mathbb P,L}=M+a,qquad M=M_0+E,qquad |E|<a+M_0,    \tag{9}
\]

then a restricted prime pair exists.  If the signed value of `E` is retained,
the exact threshold is `a+M_0>-E`; the absolute value belongs only to the
two-sided-error interface.

Build verification:

```text
lake build Pairfield.RestrictedGoldbachEdge
Build completed successfully

lake env lean Pairfield.lean
completed with no errors
```

No analytic estimate is formalized.  The module checks only the finite
support, decomposition, and conversion joints.

## 2. Exact restricted contamination comparison

Let

\[
\begin{aligned}
 R_{\Lambda,L}(N)
 &=\sum_{\substack{n+n'=N\\n,n'>L}}\Lambda(n)\Lambda(n'),\\
 R_{\mathbb P,L}(N)
 &=\sum_{\substack{n+n'=N\\n,n'>L}}\vartheta(n)\vartheta(n'),\\
 C_L(N)&=R_{\Lambda,L}(N)-R_{\mathbb P,L}(N).
                                                               \tag{10}
\end{aligned}
\]

Since `0<=theta(n)<=Lambda(n)`, every term of `C_L` is nonnegative.  The
restricted antidiagonal is a subset of the full antidiagonal, so

\[
 0\le C_L(N)\le C(N).                                   \tag{11}
\]

`GoldbachFixedFiberContamination` proves

\[
 C(N)\le
 2\log N\,[\psi(N)-\vartheta(N)]
 \le4\sqrt N(\log N)^2,                                \tag{12}
\]

and the new module composes (11) with (12).  Consequently

\[
 R_{\Lambda,L}(N)>4\sqrt N(\log N)^2                   \tag{13}
\]

is sufficient for a restricted actual-prime pair.  It is stronger than the
exact threshold `R_{Lambda,L}>C_L`; unlike that exact threshold, (13) is not
merely an algebraic restatement because it replaces the unknown contamination
by an independent upper bound.

On the prime-log carrier itself, `C_L=0`.  This is why the exact edge in (3)
needs no prime-power term.

## 3. Why separate arc conversion costs more

Let `L<X`, and let

\[
 S_{\Lambda,L}(\alpha)=\sum_{L<n\le X}\Lambda(n)e(n\alpha),
 \quad
 S_{\mathbb P,L}(\alpha)=\sum_{L<n\le X}\vartheta(n)e(n\alpha),
 \quad D_L=S_{\Lambda,L}-S_{\mathbb P,L}.              \tag{14}
\]

For any measurable arc mask `A` and any center `N<=X`,

\[
\begin{aligned}
&\left|
 \int_A(S_{\Lambda,L}^2-S_{\mathbb P,L}^2)e(-N\alpha)d\alpha
 \right|\\
&\qquad\le
 \|D_L\|_2(\|S_{\Lambda,L}\|_2+\|S_{\mathbb P,L}\|_2).
                                                               \tag{15}
\end{aligned}
\]

The checked Chebyshev input gives

\[
 \|D_L\|_2^2
 \le(\log X)[\psi(X)-\vartheta(X)]
 \ll\sqrt X(\log X)^2,                                 \tag{16}
\]

while

\[
 \|S_{\Lambda,L}\|_2^2+\|S_{\mathbb P,L}\|_2^2
 \ll X\log X.                                          \tag{17}
\]

Equations (15)--(17) yield (5).  The bounds follow from their untruncated
versions by discarding nonnegative square mass.

If `Delta_M` and `Delta_m` are the Lambda-to-prime differences on complementary
major and minor masks, Fourier orthogonality gives the exact relation

\[
 \boxed{\Delta_M(N)+\Delta_m(N)=C_L(N).}                 \tag{18}
\]

Thus two individually possible `X^(3/4+o(1))` arc errors can cancel down to
the `X^(1/2+o(1))` fixed-fiber contamination.  A proof which converts the two
arcs independently pays (5); a proof which first forms

\[
 M_\Lambda(N)+a_\Lambda(N)=R_{\Lambda,L}(N)
\]

and only then removes prime powers pays (12).  This is the exact mathematical
reason to compose proof-relevant/full-coefficient data before decategorifying
the two arc pieces.

For a Mangoldt pole--pole approximation `M_Lambda=M_0+E_Lambda`, the robust
prime-extraction condition is therefore

\[
 \boxed{
 a_\Lambda(N)+M_0(N)>
 |E_\Lambda(N)|+C_L(N),}                                \tag{19}
\]

or the source-safe sufficient version with `C_L` replaced by (12).  No
separate `X^(3/4)` carrier error is necessary in (19).

## 4. Why density of successes is insufficient

Let `C_X` be the even centers in one dyadic block, and let

\[
 G_X=\{m\in C_X:R_{\mathbb P,L}(m)>0\}.
\]

For any fixed `0<delta<1`, the inequality

\[
 |G_X|\ge\delta|C_X|                                    \tag{20}
\]

allows failures.  Even

\[
 |C_X\setminus G_X|=o(|C_X|)                            \tag{21}
\]

allows one failure in every sufficiently large block.  Zhao's power-saving
exceptional-set theorem and Pintz's common-carrier mean square have this
logical form: they make failures sparse but do not identify the omitted
coordinates.

The exact Boolean self-convolution in `exception-propagation.md` sharpens the
logic.  It has one exceptional even center and succeeds at every later even
center, while retaining nonnegativity, parity support, and exact convolution
structure.  Hence no theorem from cardinality plus generic convolution alone
can remove a singleton.

Local success density does not repair this.  In a window containing `H`
centers, any fixed density `delta<1` permits at least one hole once
`(1-delta)H>=1`.  Requiring success density so high that integrality forces
all `H` coordinates to succeed is simply the universal assertion at that
resolution.

There is a second tempting reindexing.  Suppose that, for each fixed target
`N`, one has a finite family of certified subcarriers, every positive
subcarrier coefficient furnishing an actual pair at `N`, and a positive
fraction of those coefficients is positive.  This does prove Goldbach at
`N`, but only because a positive fraction is nonempty.  Imposing it for every
`N` has repackaged the witness quantifier rather than weakened it.

## 5. The honest fixed-density closure theorem

Density becomes useful when it propagates **failures**, not when it averages
successes.

### Theorem 5.1 (failure-density energy closure)

Let `C` be a finite center set, `a:C->R`, and suppose

\[
 \sum_{m\in C}a(m)^2\le B.                              \tag{22}
\]

Fix `D>0`.  Suppose every failure `m_0` has `a(m_0)<=-D` and supplies a finite
family `H(m_0) subset C` such that

\[
 \#\{m\in H(m_0):a(m)\le-D/2\}\ge\kappa|H(m_0)|,       \tag{23}
\]

where `kappa>0`, and

\[
 \kappa|H(m_0)|(D/2)^2>B.                               \tag{24}
\]

Then there are no failures.

#### Proof

If `m_0` failed, the terms selected in (23) would contribute at least

\[
 \kappa|H(m_0)|(D/2)^2
\]

to the nonnegative sum in (22), contradicting (24).  QED.

This is genuinely weaker than an all-center edge inequality.  It permits a
fraction `1-kappa` of the family to escape arbitrarily far upward and makes no
claim unless a failure first occurs.

The checked theorem

```lean
Pairfield.upwardEscape_good_card
```

supplies (23) with `kappa=1-2gamma` from the one-sided budget

\[
 \sum_{m\in H}(a(m)-a(m_0))_+
 \le\gamma D|H|,\qquad0\le\gamma<1/2.                  \tag{25}
\]

The checked theorem

```lean
Pairfield.upwardEscape_energy_lower
```

already composes (25) directly to the energy lower bound used in (24).  Thus
the finite density/energy implication is formalized; the unproved content is
whether the actual prime minor coefficients satisfy (23) or (25).

## 6. Exact threshold under Pintz's norm

For the common prime-log minor coefficient, Pintz's estimate is

\[
 B_X\ll
 \left(\frac{X^2}{P}+X^{8/5}\right)X(\log X)^9.       \tag{26}
\]

A restricted Goldbach failure has `a_X(m_0)=-M_X(m_0)<=-c_0X` from the
uniform major lower bound.  Put `D=c_0X`.  Equations (24) and (26) ask for

\[
 \boxed{
 \kappa|H(m_0)|gg
 \frac{X}{P}(\log X)^9+X^{3/5}(\log X)^9.}              \tag{27}
\]

At `P=(log X)^A`, the right side is

\[
 X(\log X)^{9-A}+X^{3/5}(\log X)^9.                    \tag{28}
\]

If `kappa` is fixed and `|H(m_0)|>=c_1X`, then (27) holds for sufficiently
large `X` as soon as `A>9`.  Therefore:

> A theorem saying that one restricted Goldbach failure forces a fixed
> positive density of order-`X` negative minor coefficients across a
> linear-sized common block would close the logarithmic common-carrier route.

This condition is weaker than deterministic failure propagation to every
shift.  It is also far stronger than all current averages: the density is
conditioned on one declared failure and has a fixed sign.

A sublinear orbit `|H|=X^delta`, `delta<1`, does not beat the leading
`X/(log X)^(A-9)` term for any fixed `A`.  Zhao's smaller global exceptional
set `O(X^(7/10))` applies to unrestricted Goldbach failures; if one had an
actual-prime implication from one such failure to `kappa X^delta` distinct
failures with `delta>7/10`, that would contradict Zhao.  No such implication
is known.

## 7. What current inverse information supplies

`fixed-prime-packet-rigidity.md` proves that an order-`X` negative common
coefficient extracts one additive Dirichlet packet and a family of shifts on
which that packet remains negative.  It does **not** control the complementary
packets, so it does not establish (23) for the full coefficient.  Its
uniformly guaranteed shift count also falls below (28).

`upward-escape-duality-no-go.md` shows why generic energy information points
the other way: away from the small set of large coefficients, most shifted
values are near zero, so they make an almost maximal upward escape from a
negative spike.  A small upward-escape budget is a new signed-correlation
theorem, not a consequence of the norm.

The quadratic shadows show that prime support, nonnegativity, fixed major
response, and even blockwise signal fixedness do not supply this correlation.
A successful `(FD)` theorem must exploit arithmetic coherence specific to the
single actual sequence `vartheta` or `Lambda` across scales.

## 8. Merge and theorem ledger

### Checked in Lean

* Restricted prime-log positivity is exactly `RestrictedGoldbachAt`.
* If `L>=1`, every inhabited restricted fiber contributes at least
  `(log(L+1))^2`, and this quantized lower bound is equivalent to restricted
  support.
* Exact major/minor edge equivalence.
* Absolute-major-error robust implication.
* Restricted contamination is nonnegative, no larger than full fixed-fiber
  contamination, and obeys the `4sqrt(N)log^2(N)` bound.
* Exact restricted contamination domination is equivalent to the restricted
  Goldbach witness.
* The one-sided density and energy consequences of an upward-escape budget
  were already checked in `Pairfield.UpwardEscape`.

### Proved in this note

* The paired arc-conversion identity (18) and the distinction between (5) and
  (12).
* Failure-density energy closure, Theorem 5.1.
* The exact Pintz threshold (27).
* The no-go for success density and per-target subcarrier density.

### Open arithmetic premise

No current source proves a fixed positive density of full negative minor
coefficients conditional on one actual-prime failure.  That is the precise
nonterminal theorem which would turn density into universal coverage without
silently restating Goldbach.

No numerical scan was performed.  No unconditional Goldbach claim is made.
