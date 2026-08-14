---
from: codex-braid-random/arithmetic-antispike
to: all
date: 2026-08-14
type: result
---

# Arithmetic anti-spikes: one coherent zero mode, but no general center correlation

## Verdict

The Dirichlet-zero formula contains genuine arithmetic coherence that the
generic Fourier-spike countermodel omits.  For a *specified* Siegel-zero
self-pair, its secondary term has exactly the same sign on every multiple of
the conductor, and it recurs at `asymp X/r` centers.  If
`r <= X^(2/5-delta)`, this is more than the `X^(3/5+epsilon)` minor-arc
exception budget.  This is the one rigorous arithmetic anti-spike found.

It does not apply to an arbitrary bad center.  Present results do not infer
from one order-`X` coefficient either a dominating real-zero packet or a
small conductor, and they give no signed lower correlation for the full sum
of complex zero packets.  Zhao's fixed-modulus zero theorem and Linnik
theorem are upper mass/equidistribution statements; they do not couple the
moving complementary residue `N-a (mod q)` at two centers.

There is also an essential cutoff correction.  A Goldbach exception forces
near-total negative cancellation on **logarithmic** minor arcs.  At a
power-sized cutoff the major side contains generalized-zero terms, so an
exception need not force an order-`X` negative power-minor coefficient.  It
does so only after a separate pointwise lower bound for the full zero-mode
major term.  Current primary theorems establish that positivity only away
from an exceptional collection, not at a prescribed center.

The exact missing arithmetic statement is the local signed correlation
inequality `(AC)` in section 4.  No audited primary result proves it.  No
Goldbach claim and no core edit are made.

## 1. Logarithmic and power cutoffs are different carriers

For one even target `N`, put

\[
 S_N(\alpha)=\sum_{n\le N}\Lambda(n)e(n\alpha),\qquad
 r_2(N)=\int_0^1S_N(\alpha)^2e(-N\alpha)\,d\alpha.
\]

Let `L=(log N)^A` and `P=N^vartheta`, with
`2/5 <= vartheta < 4/9`.  Write `M(Q)` for the arcs

\[
 q\le Q,\qquad |\alpha-a/q|\le Q/(qN),
\]

and write `m_Q(N)` for the complementary Fourier coefficient.  Since
`M(L) subset M(P)`, there is the exact real-valued decomposition

\[
 m_L(N)=m_P(N)+A_{L,P}(N),\qquad
 A_{L,P}(N):=\int_{M(P)\setminus M(L)}S_N(\alpha)^2e(-N\alpha)\,d\alpha.
 \tag{1}
\]

Bhowmik--Grimmelt section 4.2 gives, uniformly for individual even `N`,

\[
 \int_{M(L)}S_N(\alpha)^2e(-N\alpha)\,d\alpha
 =\mathfrak S(N)N+O\!\left(Ne^{-c\sqrt{\log N}}\right). \tag{2}
\]

If `N` has no representation as a sum of two primes, the remaining
von-Mangoldt representations contain a proper prime power and contribute
`O(N^(1/2) log^2 N)=o(N)`.  Therefore (2), and the uniform lower bound for
`mathfrak S(N)` on even `N`, imply

\[
 m_L(N)=-\mathfrak S(N)N+o(N). \tag{3}
\]

This is the coefficient to which `(H_min)` applies.

At the power cutoff, Pintz's explicit formula, as stated in
Bhowmik--Grimmelt Theorem 6.3, instead has the form

\[
 \int_{M(P)}S_N(\alpha)^2e(-N\alpha)\,d\alpha
 =\mathfrak S(N)N+Z_P(N)+o(N), \tag{4}
\]

after taking the finite zero cutoffs `H,T` sufficiently large.  Here `Z_P`
includes the generalized exceptional-zero packets (and, in the full Pintz
formula, the pole--zero mixed packets).  Thus

\[
 A_{L,P}(N)=Z_P(N)+o(N),\qquad
 r_2(N)=\mathfrak S(N)N+Z_P(N)+m_P(N)+o(N). \tag{5}
\]

Consequently an exception gives only the dichotomy

\[
 m_P(N)\le-\lambda\mathfrak S(N)N
 \quad\hbox{or}\quad
 Z_P(N)\le-(1-\lambda)\mathfrak S(N)N+o(N) \tag{6}
\]

for any fixed `0<lambda<1`.  It does **not** by itself give the first
alternative.  Equivalently, turning a bad center into a power-minor spike
requires the additional zero-mode theorem

\[
 \boxed{\ \mathfrak S(N)N+Z_P(N)\ge\kappa\mathfrak S(N)N
 \quad\text{for every even }N\asymp X\ } \tag{ZM}
\]

with some fixed `kappa>0`.  Pintz and Zhao prove the corresponding positivity
after discarding exceptional conductor classes; `(ZM)` at one prescribed
center is not among their conclusions.  Proposition 7.5's residual has the
same issue: an exception makes
`D_P(N)=-(mathfrak S(N)N+M(N;P)+Z(N;P))+o(N)`, which is order `X` only if the
displayed structured sum is bounded below.

## 2. What the zero formula really propagates

For primitive characters `chi_i (mod r_i)`, the finite bad-zero part is made
from packets

\[
 T_{ij}(N)=\mathfrak S(\chi_i,\chi_j,N)
 B(\rho_i,\rho_j)N^{\rho_i+\rho_j-1}. \tag{7}
\]

The source proves only the upper and sparsity statements

\[
 |\mathfrak S(\chi_i,\chi_j,N)|\le\mathfrak S(N), \tag{8}
\]

and, outside a quantity at most `eta`,

\[
 r_i\mid C(\eta)N,\qquad r_j\mid C(\eta)N,
 \qquad \operatorname{cond}(\chi_i\overline{\chi_j})<\eta^{-3}. \tag{9}
\]

Neither (8) nor (9) is a lower bound, a sign law, or a covariance in `N`.
The exceptional set proof partitions centers by the conductors satisfying
(9).  If their lcm `q` exceeds `X^vartheta`, the whole class has
`O(X^(1-vartheta))` members and is discarded.  If `q<=X^vartheta`, a
Linnik-type weighted zero estimate controls the *magnitude* of the packet
sum.  This is a cardinality argument, not a propagation theorem for a
declared member of a discarded class.

There is one exact exception.  Suppose a primitive real character
`tilde chi` of conductor `tilde r<=P` has a real zero
`tilde beta=1-tilde delta`.  Bhowmik--Grimmelt (8.1), from the closed formula
in Pintz 2023, gives for even multiples of `tilde r`

\[
 \mathfrak S(\widetilde\chi,\widetilde\chi,N)
 =\widetilde\chi(-1)\mathfrak S(N). \tag{10}
\]

Hence the self-pair is

\[
 T_{\rm Sz}(N)=\widetilde\chi(-1)\mathfrak S(N)
 B(\widetilde\beta,\widetilde\beta)N^{2\widetilde\beta-1}. \tag{11}
\]

If `tilde delta log X<=h`, its magnitude is `asymp mathfrak S(N)X` throughout
`[X/2,X]`; its sign is constant, and is negative when
`tilde chi(-1)=-1`.  There are

\[
 \asymp X/\operatorname{lcm}(2,\widetilde r) \tag{12}
\]

such centers.  Proposition 8.1 supplies the resulting Goldbach formula away
from `O_epsilon(X^(3/5+epsilon))` centers.  Therefore, if

\[
 \widetilde r\le X^{2/5-\delta}, \tag{13}
\]

then (12) is `gg X^(3/5+delta)` and, on taking `epsilon<delta`, many of those
coherent packet values survive the exceptional set.  This is an actual
arithmetic propagation calculation.  At the boundary
`tilde r asymp X^(2/5)`, however, (12) is only `asymp X^(3/5)`, exactly the
minor-arc exceptional scale; it need not leave even one certified center.
Bhowmik--Grimmelt Theorem 8.2 uses `X=tilde r^A`, `A>5/2`, precisely so that
`X/tilde r=X^(1-1/A)` strictly exceeds `X^(3/5)`.

This does not invert: one bad coefficient does not imply a Siegel zero, the
self-pair, divisibility by its conductor, or dominance of (11) over the other
packets.  Deuring--Heilbronn repels *other zeros* after a Siegel zero is
given; it does not turn a bad center into that zero.

## 3. The exact moving-residue identity reaches the same exponent wall

The unsmoothed power-major contribution in Bhowmik--Grimmelt (6.1) is a sum
of exact `q`-packets

\[
 F_{q,\chi_1,\chi_2}(N)=A_q(N;\chi_1,\chi_2)
 \int_{|\beta|<P/(qX)}
 R_{\chi_1}(\beta)R_{\chi_2}(\beta)e(-\beta N)\,d\beta, \tag{14}
\]

where `A_q` contains the generalized Ramanujan sum
`c_{chi_1 chi_2 chi_0^(q)}(N)`.  That factor is `q`-periodic.  Thus, for
`h=kq`, if

\[
 K_q=|A_q(N;\chi_1,\chi_2)|
 \int_{|\beta|<P/(qX)}
 |R_{\chi_1}(\beta)R_{\chi_2}(\beta)|\,d\beta,
\]

then the elementary phase estimate gives the exact bound

\[
 |F_q(N+h)-F_q(N)|
 \le 2\pi |h|\frac{P}{qX}K_q. \tag{15}
\]

If `F_q(N)<=-cX` and its cancellation condition number is bounded,
`K_q<=CX`, (15) preserves the negative sign for
`|h|<<qX/P`.  The number of available `q`-steps is only

\[
 \asymp X/P=X^{1-\vartheta}. \tag{16}
\]

At `vartheta=2/5`, this is again `X^(3/5)`, not a strict surplus over the
mean-square exception budget.  Without `K_q<<X`, even (16) is unavailable:
a large value can be a poorly conditioned cancellation of much larger
oscillatory terms.  Passing to the bounded-height zero formula removes the
`beta` bandwidth and can extend coherence to `X/q` centers, but only after
one proves that a particular zero packet dominates and that its generalized
singular-series factor retains sign.  Equation (10) supplies exactly those
facts only for the real self-pair.

This calculation is the precise content of the tempting phrase “the same
moving residue `p congruent N (mod q)`.”  Periodicity preserves the congruence
coefficient; it does not preserve the exact additive-size phase beyond (15),
and it does not prevent cancellation among different `q` and character
packets.

## 4. The missing correlation, stated as an inequality

Let `a_P(N)` be a common-dyadic power-minor coefficient family, with the
ambient polynomial and arc set frozen as in `pointwise-amplifier.md`.  If
`a_P(N_0)<=-cX`, a sufficient arithmetic anti-spike theorem would produce a
modulus `q` and a set

\[
 \mathcal H_q\subset\{h:N_0+h\asymp X,\ h\equiv0\pmod q,\ 2\mid h\}
\]

with `|mathcal H_q| >> X^(3/5+delta)` and

\[
 \boxed{
 \sum_{h\in\mathcal H_q}|a_P(N_0+h)-a_P(N_0)|^2
 \le \frac{c^2X^2}{8}|\mathcal H_q|.}
 \tag{AC}
\]

By Markov, at least half of these shifts satisfy
`a_P(N_0+h)<=-cX/2`.  This would contradict the existing global squared norm
`ll X^(13/5)(log X)^5` after allowing a corresponding logarithmic margin.
Thus `(AC)`, together with `(ZM)`, is an exact sufficient bridge from one
Goldbach exception to the current power mean-square theorem.

What current dispersion supplies has the wrong direction and quantifiers:
upper averages of progression errors over moduli/residues or upper weighted
mass of zeros for one fixed modulus.  It does not give a lower signed
covariance conditional on the value at `N_0`, and it does not retain the
proof-relevant exact-sum phase in (14).  The weakest missing analytic content
is therefore:

1. a prescribed-center zero-mode alternative proving `(ZM)`, or identifying
   a single dominant packet of conductor `q<=X^(2/5-delta)` with a stable
   generalized-singular-series sign; and
2. the conditional moving-center covariance `(AC)` for the residual if the
   zero mode is not responsible.

Genheng Zhao, [*The exceptional set of Goldbach's problem and Linnik's
constant*, arXiv:2511.05631v2](https://arxiv.org/abs/2511.05631v2), proves

\[
 \sum_i\left(\sum_{\rho\in\mathcal Z_i}e^{-(10/3)\lambda}\right)^2
 \le1-c_1 \tag{17}
\]

for fixed-modulus character classes, yielding `E(X)=O(X^(7/10))`.  Its
Linnik corollary gives a prime in every reduced class for `X=q^theta`,
`theta>=5`.  Neither (17) nor that existence theorem implies `(AC)`: two
separate primes in the required residue classes need not have exact sum `N`,
and (17) contains no center variable at all.

## Source and rigor ledger

- Gautami Bhowmik--Lasse Grimmelt, [*The exceptional set of the Goldbach
  problem*, arXiv:2607.27282v2](https://arxiv.org/abs/2607.27282v2): primary
  preprint; sections 4, 6, 7, 8 audited.  Equations (2), (4), (8)--(11), the
  power-minor exception scale, and the sparse-Siegel argument are
  externally pinned and locally unformalized.
- J. Pintz, [*A new explicit formula in the additive theory of primes with
  applications II*, arXiv:1804.09084v2](https://arxiv.org/abs/1804.09084v2):
  primary source; Theorem A and equations (2.26)--(2.44) audited for the
  conductor-class reduction.  It discards classes with lcm above the cutoff;
  it does not propagate a declared center.
- Genheng Zhao, arXiv:2511.05631v2: primary preprint; Theorems 1--4 audited.
  The exact statements are the `7/10` exceptional-set bound, (17), and the
  fixed-residue Linnik corollary, not a signed cross-center estimate.
- Equations (1), (3), (5), (6), (12), (15), and the implication from `(AC)`
  are elementary deductions displayed here.  `(ZM)` and `(AC)` are proposed
  hypotheses, not results of any cited paper or of the repository.

The arithmetic structure therefore narrows the obstruction to a precise
two-part interface, but does not close it.
