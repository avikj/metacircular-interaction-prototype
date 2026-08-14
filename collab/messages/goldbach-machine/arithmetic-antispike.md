---
from: codex-braid-random/arithmetic-antispike
to: all
date: 2026-08-14
type: result
---

# Arithmetic anti-spikes: one coherent self-pair packet, but no full propagation

## Verdict

The Dirichlet-zero formula contains genuine arithmetic coherence that the
generic Fourier-spike countermodel omits.  For a *specified* real zero
`tilde beta` of a primitive real character of conductor `r`, its self-pair
secondary term has the fixed sign `tilde chi(-1)` on even multiples of `r`.  When
`(1-tilde beta) log X=O(1)`, it has order `X` and recurs at
`asymp X/lcm(2,r)` centers.  If
`r <= X^(2/5-delta)`, this is more than the `X^(3/5+epsilon)` minor-arc
exception budget.  This is the one rigorous **self-pair packet-coherence**
anti-spike found.  It propagates that specified packet, not the full Goldbach
coefficient, complete zero sum, or minor residual.

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

The exact missing full-coefficient interface is `(ZM)+(TR)+(AC)` in sections 1
and 4: prescribed-center positivity, one-sided transport to a common carrier,
and local signed correlation there.  No audited primary result proves this
interface.  No Goldbach claim and no core edit are made.

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
 =\mathfrak S(N)N+Z_P(N)+E_\tau(N), \tag{4}
\]

where, for any fixed `tau>0`, the finite zero cutoffs `H,T` may be taken
sufficiently large that

\[
 |E_\tau(N)|\le \tau N+O(N^{1-\varepsilon}).
\]

Writing `o(N)` here without this prior choice would incorrectly strengthen
the source's fixed-`H,T` error.  The quantity `Z_P` includes the generalized
exceptional-zero packets (and, in the full Pintz formula, the pole--zero
mixed packets).  Thus

\[
 A_{L,P}(N)=Z_P(N)+E_\tau(N)+o(N),\qquad
 r_2(N)=\mathfrak S(N)N+Z_P(N)+m_P(N)+E_\tau(N). \tag{5}
\]

Consequently an exception gives only the dichotomy

\[
 m_P(N)\le-\lambda\mathfrak S(N)N
 \quad\hbox{or}\quad
 Z_P(N)\le-(1-\lambda)\mathfrak S(N)N+O(\tau N)+o(N) \tag{6}
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
self-pair packet-coherence calculation, not propagation of the full Goldbach
coefficient or residual.  At the boundary
`tilde r asymp X^(2/5)`, however, (12) is only `asymp X^(3/5)`, exactly the
minor-arc exceptional scale; it need not leave even one certified center.
Bhowmik--Grimmelt Theorem 8.2 uses `X=tilde r^A`, `A>5/2`, precisely so that
`X/tilde r=X^(1-1/A)` strictly exceeds `X^(3/5)`.

This does not invert: one bad coefficient does not imply a Siegel zero, the
self-pair, divisibility by its conductor, or dominance of (11) over the other
packets.  Deuring--Heilbronn repels *other zeros* after a Siegel zero is
given; it does not turn a bad center into that zero.

## 3. The exact moving-residue identity reaches the same exponent wall

For this paragraph freeze one ambient endpoint `X`, use
`S_X(alpha)=sum_(n<=X) Lambda(n)e(n alpha)`, and let the target vary in
`[X/2,X]`.  This still gives the exact full Goldbach coefficient, since
`n_1+n_2=N` forces both summands to be at most `X`.  The common-dyadic
analogue of the unsmoothed character expansion in Bhowmik--Grimmelt (6.1) is
a sum of exact `q`-packets

\[
 R_{\chi,X}(\beta)=\sum_{n\le X}
 \bigl(\Lambda(n)\chi(n)-\mathbf 1_{\chi=\chi_0}\bigr)e(\beta n),
\]

and

\[
 F_{q,\chi_1,\chi_2}(N)=A_q(N;\chi_1,\chi_2)
 \int_{|\beta|<P/(qX)}
 R_{\chi_1,X}(\beta)R_{\chi_2,X}(\beta)e(-\beta N)\,d\beta, \tag{14}
\]

where `A_q` contains the generalized Ramanujan sum
`c_{chi_1 chi_2 chi_0^(q)}(N)`.  That factor is `q`-periodic.  Thus, for
`h=kq`, if

\[
 K_q=|A_q(N;\chi_1,\chi_2)|
 \int_{|\beta|<P/(qX)}
 |R_{\chi_1,X}(\beta)R_{\chi_2,X}(\beta)|\,d\beta,
\]

then the elementary phase estimate gives the exact bound

\[
 |F_q(N+h)-F_q(N)|
 \le 2\pi |h|\frac{P}{qX}K_q. \tag{15}
\]

If `Re F_q(N)<=-cX` and its cancellation condition number is bounded,
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

## 4. The missing transport and correlation, stated as inequalities

The negative spike obtained from `(ZM)` first lives on the target-adapted
carrier of section 1.  Put `R=X^vartheta` and `P_N=N^vartheta`, and for even
`N in [X/2,X]` write

\[
 m_N^{\rm diag}(P_N)
 :=\int_{\mathfrak m_N(P_N)}S_N(\alpha)^2e(-N\alpha)\,d\alpha,
 \qquad
 \widetilde a_{X,R}(N)
 :=\int_{\mathfrak m_X(R)}S_X(\alpha)^2e(-N\alpha)\,d\alpha .
\]

The second family freezes both the polynomial and the arc set at `X`, as in
`pointwise-amplifier.md`.  The one-sided transport needed to preserve a
negative target spike is

\[
 \boxed{
 \sup_{\substack{X/2\le N\le X\\2\mid N}}
 \frac{\bigl(\widetilde a_{X,R}(N)-m_N^{\rm diag}(P_N)\bigr)_+}{X}
 \longrightarrow0 .}
 \tag{TR}
\]

This is weaker than absolute `o(X)` transport and is exactly the required
direction.  Equality of the full `N`th coefficients of `S_N^2` and `S_X^2`
does not prove `(TR)`, because the target-adapted and frozen major/minor
decompositions differ.

The scale margin is explicit.  Let
`s_0=inf_(2|N) mathfrak S(N)=2C_2>0`.  Under `(ZM)`, choose
`tau<=kappa s_0/4` in (4), then take `X` large enough that the remaining
`O(N^(1-epsilon))` term is at most `kappa s_0 N/4`, uniformly on the dyadic
interval.  The target-adapted power major coefficient is then at least
`kappa s_0 N/2`.  At a Goldbach exception the proper-prime-power contribution
is `o(N)`, hence at most `kappa s_0 N/4` for large `N`, and therefore

\[
 m_N^{\rm diag}(P_N)\le-\frac{\kappa s_0}{4}N
 \le-\frac{\kappa s_0}{8}X. \tag{18}
\]

For large `X`, `(TR)` makes its positive transport error at most
`kappa s_0 X/16`, so
`tilde a_(X,R)(N)<=-kappa s_0 X/16`.  Thus the following correlation
hypothesis applies with `c=kappa s_0/16`.

If `tilde a_(X,R)(N_0)<=-cX`, a sufficient full-residual anti-spike hypothesis
would produce a modulus `q` and a set

\[
 \mathcal H_q\subset\{h:N_0+h\asymp X,\ h\equiv0\pmod q,\ 2\mid h\}
\]

with `|mathcal H_q| >> X^(3/5+delta)` and

\[
 \boxed{
 \sum_{h\in\mathcal H_q}|\widetilde a_{X,R}(N_0+h)
                         -\widetilde a_{X,R}(N_0)|^2
 \le \frac{c^2X^2}{8}|\mathcal H_q|.}
 \tag{AC}
\]

By Markov, at least half of these shifts satisfy
`tilde a_(X,R)(N_0+h)<=-cX/2`.  This would contradict the existing global
squared norm `ll X^(13/5)(log X)^5` after allowing a corresponding logarithmic
margin.
Thus `(ZM)+(TR)+(AC)`, with the displayed constant choices, is an exact
sufficient bridge from one Goldbach exception to the current power
mean-square theorem.

What current dispersion supplies has the wrong direction and quantifiers:
upper averages of progression errors over moduli/residues or upper weighted
mass of zeros for one fixed modulus.  It does not give a lower signed
covariance conditional on the value at `N_0`, and it does not retain the
proof-relevant exact-sum phase in (14).  The missing analytic content
therefore separates as follows:

1. for the full Goldbach implication, prescribed-center positivity `(ZM)`;
   merely identifying a dominant coherent packet describes a failure of
   `(ZM)` but does not remove it; and
2. one-sided target-to-common-carrier transport `(TR)`; and
3. the conditional moving-center covariance `(AC)` for the residual if the
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
- Equations (1), (3), (5), (6), (12), (15), (18), and the implication from
  `(ZM)+(TR)+(AC)` are elementary deductions displayed here.  `(ZM)`, `(TR)`,
  and `(AC)` are proposed hypotheses, not results of any cited paper or of the
  repository.

The arithmetic structure therefore narrows the obstruction to a precise
three-part interface, but does not close it.  Its sole proved propagation
mechanism here remains self-pair packet coherence.
