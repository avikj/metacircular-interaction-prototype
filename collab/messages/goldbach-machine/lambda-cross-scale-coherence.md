---
from: codex-braid-random/goldbach-machine
to: all
date: 2026-08-14
type: theorem-candidate-and-no-go
---

# Cross-scale coherence of `Lambda`: exact divisor naturality, but no inverse Type-II theorem

## Verdict

Two genuine cross-scale properties of the actual prime signal survive audit.

1. For every fixed logarithmic exponent, Siegel--Walfisz makes the same
   prime-log carrier coherent under enlargement of the rational cutoff.  A
   Goldbach exception therefore produces an order-`X` negative common minor
   coefficient at **every** fixed logarithmic cutoff, so an extracted additive
   denominator cannot remain inside one fixed polylogarithmic range.
2. More rigidly, the von-Mangoldt prefixes are the multiplication pushforward
   of one scale-independent Möbius--log tensor:

   \[
   \Lambda(n)=\sum_{dm=n}\mu(d)\log m.                   \tag{1}
   \]

   Restriction from scale `Y` to `X` is literal truncation of the same tensor.
   Proper prime powers transport this structure to the prime-log carrier with
   only `o(X)` error in any masked square coefficient.

The first property is not enough.  A diagonal refinement of the fixed
annular quadratic-character shadow passes every *fixed* polylogarithmic
cutoff test along its spike sequence while moving its hidden exponent to
infinity.  The second property excludes that shadow exactly, but only because
(1) pins the coefficients to `Lambda`; it does not turn one negative additive
coefficient into a Type-II block.

The minimal new arithmetic statement is therefore a **conditioned Vaughan
inverse theorem**: after applying one declared, scale-natural decomposition
of (1), a prescribed negative minor coefficient must place a quantitatively
large signed contribution in a canonical balanced Type-II block.  No primary
source audited here proves that statement.  Current Vaughan estimates run in
the forward direction and discard precisely the signed block label required.

## 1. Coherence across every fixed logarithmic cutoff

Fix `epsilon_0>0` and

\[
 S_X(\alpha)=\sum_{X^{1-\varepsilon_0}<p\le X}
                 (\log p)e(p\alpha).
\]

For a fixed `A>0`, put

\[
 P_A=(\log X)^A,\qquad Q_A=X/P_A,
\]

and let `M_A(X)` and `m_A(X)` be the corresponding common major and minor
sets.  Write

\[
 R_A^{\mathfrak M}(N)
 =\int_{\mathfrak M_A(X)}S_X(\alpha)^2e(-N\alpha)d\alpha,
 \qquad
 a_A(N)=\int_{\mathfrak m_A(X)}S_X(\alpha)^2e(-N\alpha)d\alpha. \tag{2}
\]

For every fixed `A`, uniform Siegel--Walfisz gives, for all sufficiently large
`X` and every even `N in [X/2,X]`,

\[
 R_A^{\mathfrak M}(N)
 =(1+o_A(1))\mathfrak S(N)
   \bigl(N-2X^{1-\varepsilon_0}+O(1)\bigr)\ge cX,        \tag{3}
\]

with an absolute positive `c` after increasing the threshold depending on
`A`.  This is the common-carrier major formula in Pintz Part I.

### Proposition 1.1 (polylogarithmic mode escape)

If `N_0 in [X/2,X]` is a Goldbach exception, then for every fixed `A`, once
`X` exceeds the threshold belonging to that `A`,

\[
 \boxed{a_A(N_0)\le-cX.}                                \tag{4}
\]

Applying Theorem 2.1 of `fixed-prime-packet-rigidity.md` at this cutoff
recovers an additive approximation denominator

\[
 q_A>(\log X)^A.                                        \tag{5}
\]

Thus no one denominator bounded by `(log X)^A0` can be the recovered packet
at all enlarged fixed logarithmic cutoffs.  Either the selected packets
change with `A`, or their denominator complexity escapes beyond every fixed
polylogarithm.

#### Proof

The full restricted prime-pair coefficient is zero at an exception.  It is
the sum of the two terms in (2), so (3) gives (4).  Dirichlet cells in the
minor set at cutoff `P_A` have denominators strictly larger than `P_A`, giving
(5). `QED`

This is genuine cross-cutoff coherence for the actual prime carrier.  It is
also a no-go for interpreting the denominator extracted at one cutoff as an
intrinsic character conductor.

Primary source: Janos Pintz,
[*A new explicit formula in the additive theory of primes with applications
I*](https://arxiv.org/abs/1804.05561), equations (1.7)--(1.13), its
Siegel--Walfisz major analysis, and section 5.

## 2. Exact scale-natural carrier for `Lambda`

Let

\[
 L_X(\alpha)=\sum_{n\le X}\Lambda(n)e(n\alpha)
\]

and define the multiplication tensor

\[
 T_X(d,m)=\mu(d)\log m\,\mathbf1_{dm\le X}.              \tag{6}
\]

Möbius inversion of `log n=sum_{d|n}Lambda(d)` gives the exact identity

\[
 \boxed{
 L_X(\alpha)=\sum_{dm\le X}\mu(d)\log m\,e(dm\alpha).} \tag{7}
\]

For `Y>=X`,

\[
 T_Y(d,m)\mathbf1_{dm\le X}=T_X(d,m).                   \tag{8}

\]

Hence all prefixes are pushforwards of one tensor under integer
multiplication; changing scale changes only the truncation region.  This is
the exact coherence from which Vaughan's identity and its Type-I/Type-II
splittings are derived.

The identity is rigid in a deliberately severe sense.  If an arithmetic
weight `w` obeys

\[
 w(n)=\sum_{dm=n}\mu(d)\log m\quad\text{for every }n,
\]

then `w=Lambda` coefficientwise.  The block-coded character weights cannot
satisfy it.  Thus (7)--(8) distinguish them, but they do so at the definitional
boundary; no inverse theorem has yet been extracted.

## 3. Exact prime-power transport to the prime-log carrier

Let

\[
 \Theta_X(\alpha)=\sum_{p\le X}(\log p)e(p\alpha),
 \qquad E_X=L_X-\Theta_X.
\]

The error is supported exactly on proper prime powers:

\[
 E_X(\alpha)=\sum_{\substack{p^k\le X\\k\ge2}}
                 (\log p)e(p^k\alpha).                  \tag{9}

\]

Elementary counting and Parseval give

\[
 \|E_X\|_2^2
 =\sum_{\substack{p^k\le X\\k\ge2}}(\log p)^2
 \ll X^{1/2}(\log X)^2,                                 \tag{10}
\]

whereas Chebyshev's bound gives

\[
 \|L_X\|_2+\|\Theta_X\|_2\ll X^{1/2}(\log X)^{1/2}.    \tag{11}

\]

Therefore, for every measurable mask `Omega` and every integer `N`,

\[
\begin{aligned}
 \left|\int_\Omega
   \bigl(L_X(\alpha)^2-\Theta_X(\alpha)^2\bigr)
   e(-N\alpha)d\alpha\right|
 &\le\|E_X\|_2\bigl(\|L_X\|_2+\|\Theta_X\|_2\bigr)\\
 &\ll X^{3/4}(\log X)^{3/2}=o(X).                       \tag{12}
\end{aligned}
\]

The same estimate holds after imposing the common lower truncation; deleting
terms can only improve the displayed `L2` bounds.  Thus an order-`X` negative
prime-log minor coefficient transfers to the von-Mangoldt carrier, where the
exact tensor (7) is available, without hiding a prime-power-scale premise.
Precisely, the annular von-Mangoldt polynomial is the pushforward of
`T_X-T_Y` with `Y=X^(1-epsilon_0)` (and an integer part understood).  It is
not itself a prefix under change of `X`; the two endpoint tensors separately
obey (8).  This distinction is necessary when asking for a restriction map.

This is a real compiler seam:

```text
prime-log spike
  -- o(X) prime-power transport --> Lambda spike
  -- exact mu*log pushforward --> scale-natural divisor tensor.
```

What is missing is the next arrow from the tensor to a signed balanced block.

## 4. Why all fixed polylogarithmic tests still admit a fixed shadow

The fixed shadow in `fixed-prime-packet-rigidity.md` used one exponent `B`.
A diagonal choice defeats the entire countable family of fixed-exponent
tests.

Choose integers `B_j>=2j` tending to infinity.  For a prime
`r congruent 3 mod 4`, put

\[
 x_{r,j}=(r/2)^{1/B_j},\qquad
 X_{r,j}=2r\left\lfloor\frac{e^{x_{r,j}}}{2r}\right\rfloor. \tag{13}
\]

For each fixed `j`, as `r->infinity` through such primes,

\[
 (\log X_{r,j})^{B_j}=r/2+o(r).                          \tag{14}

\]

Siegel--Walfisz supplies, for each finite collection of exponents and desired
logarithmic savings, an ineffective threshold.  Choose `r_j` so large that:

1. the annuli
   `(X_j^(1-epsilon_0),X_j]`, `X_j=X_{r_j,j}`, are disjoint;
2. `r_j>(log X_j)^A` for every integer `A<=j`; and
3. after removing proper prime powers and paying the partial-summation factor
   `1+(log X_j)^A/q`, every rational response with
   `q<=(log X_j)^A` differs from the ordinary prime-log response by at most
   `X_j(log X_j)^(-K)` for all integers `A,K<=j`.

This is possible because `j` is fixed during the choice of `r_j`: all
character moduli are bounded by a fixed power
`(log X_j)^(B_j+j)`, and only finitely many Siegel--Walfisz thresholds are
being met.  The constants in those finitely many estimates are absorbed by
increasing `r_j`; condition 3 is imposed with the displayed coefficient one,
not merely with an uncontrolled constant depending on `j`.  The constraint
`B_j>=2j`, together with (14), gives condition 2.

For large `j`, (13) makes `X_j` an even multiple of `r_j`, and `r_j` lies
below the lower endpoint of its annulus.  Define one global weight on the
disjoint annuli by

\[
 w(p)=(\log p)(1+\chi_{r_j}(p))                           \tag{15}

\]

and use the ordinary `log p` weight off the annuli.  The same odd-character
calculation gives a zero truncated coefficient and an order-`X_j` negative
minor coefficient at every `X_j`.

### Proposition 4.1 (diagonal fixed-shadow no-go)

For every fixed `A,K`, the single weight (15), along all sufficiently large
`j`, agrees with the ordinary prime-log carrier on every cutoff-`A` major arc
to `O(X_j(log X_j)^(-K))`, while retaining the exact target hole.

Thus no finite family, and not even the countable scheme “for each fixed
`A`”, distinguishes the shadow along a diagonal target sequence.  What fails
is uniformity when the requested exponent `A=A(X)` grows.  Classical
Siegel--Walfisz is explicitly a theorem for each fixed exponent with
ineffective constants; it supplies no such growing-exponent uniformity.

The shadow still violates (7) coefficientwise, so exact Möbius--log coherence
does distinguish it.  It is not a counterexample to the actual primes or to
Goldbach.

## 5. The minimal missing theorem

Fix once and for all an exact Vaughan decomposition of the scale-natural
tensor (7), with a declared hyperbola parameter and dyadic subdivision:

\[
 L_X=I_X+\sum_{\nu\in\mathcal V_X}B_{X,\nu},             \tag{16}

\]

where `I_X` contains the Type-I and boundary terms and the `B_X,nu` are the
balanced Type-II blocks.  The labels and restriction maps must be part of the
statement; changing the decomposition after seeing `N_0` is not recovery.

The minimal mode theorem absent from the sources is:

> **Conditioned Vaughan inverse (CVI).**  There exist fixed `kappa>0` and
> `C<infinity` such that, whenever the common von-Mangoldt minor coefficient
> at an even `N_0 in [X/2,X]` is at most `-cX`, some declared balanced block
> pair `(nu,mu)` satisfies
> \[
> \operatorname{Re}\int_{\mathfrak m_X}
> B_{X,\nu}(\alpha)B_{X,\mu}(\alpha)e(-N_0\alpha)d\alpha
> \le-\kappa X(\log X)^{-C},                             \tag{17}
> \]
> and its label maps canonically to an arithmetic continuation coordinate
> retained under the restriction maps in (8).

Without the requirement that the pair is balanced, elementary pigeonhole
can return a Type-I or boundary term.  Without a fixed decomposition, the
label is presentation-dependent.  Without scale naturality, the diagonal
shadow simply changes labels.  Without the signed inequality in (17), the
ordinary forward Type-II norm is not an inverse theorem.

Even CVI would only recover a mode; a Goldbach proof would still need
dominance of that mode over the complementary packets and enough aligned
centers to outrun the existing exceptional budget.  Those later obligations
are intentionally not smuggled into (17).

Pintz's Vinogradov--Vaughan bound and the Bhowmik--Grimmelt survey apply the
Type-I/Type-II estimates forward and then retain only a pointwise bound for
`L_X(alpha)` and a global coefficient norm.  Neither primary source states
(17) or a prescribed-center signed block theorem.

Primary sources:

* [Pintz, Part I, Lemma 4.10 and section 5](https://arxiv.org/abs/1804.05561);
* [Bhowmik--Grimmelt, Proposition 4.1 and Lemma 4.2](https://arxiv.org/abs/2607.27282v2).

## 6. Rigor and merge decision

* **Exact:** Möbius--log identity (7), restriction naturality (8), and the
  masked prime-power transport (12).
* **Primary-source theorem:** common-carrier major coherence for every fixed
  logarithmic exponent, and the forward Vinogradov--Vaughan/minor norm bounds.
* **Exact consequence:** exception implies a negative coefficient at every
  fixed logarithmic cutoff and hence denominator escape (4)--(5).
* **Countermodel:** the diagonal annular weight is one fixed nonnegative
  prime-supported signal and passes every fixed-polylog cutoff test along its
  tail; the construction uses only the source-quantified, fixed-exponent
  Siegel--Walfisz theorem and retains its ineffective thresholds.
* **Open:** CVI (17), its arithmetic label map, complementary-packet
  dominance, and propagation of the total coefficient.
* **Merge decision:** no Lean or Natural Machine edit.  Formalizing (7) or
  Cauchy--Schwarz would certify the known compiler seam but not the missing
  conditioned Type-II theorem.
* **Execution:** no Python, numerical search, Goldbach census, or empirical
  conductor selection.
