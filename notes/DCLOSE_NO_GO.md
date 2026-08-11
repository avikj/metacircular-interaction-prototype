# The D-double-prime boundary: why the microscopic energy estimate is not a finite check

This note closes the interrupted `exp21_dclose.py` branch by a no-go, not by
proving the conjectured estimate.  Throughout RH is assumed when the symbols
are interpreted as zeta zeros.  Write

$$
a(\gamma)=\frac1{\gamma^2+1/4},\qquad
\mu=\sum_{\gamma\ \mathrm{signed}}a(\gamma)\delta_\gamma,qquad
\nu=\mu*\mu,
$$

and put $m_0=\sum_\gamma a(\gamma)^2$.  If
$\kappa=\nu*\widetilde\nu$, then the phase-free near-diagonal energy is

$$
E_a^\circ(\eta)
=\kappa\bigl([ -\eta,\eta]\setminus\{0\}\bigr)
=\sum_{0<|\gamma_1+\gamma_2-\gamma_3-\gamma_4|\le\eta}
 a_1a_2a_3a_4. \tag{1}
$$

The target was

$$
E_a^\circ(\eta)\ll \eta m_0^2. \tag{2}
$$

The numerical evidence remains compatible with (2), but (2) is a new
microscopic correlation hypothesis.  It is not a consequence of RH plus a
finite zero table and Riemann--von Mangoldt tail bounds.

## 1. The unconditional statement and the missing rate

**Proposition 1 (automatic continuity, no automatic Lipschitz rate).**  The
measure $\kappa$ is finite and

$$E_a^\circ(\eta)\longrightarrow0\qquad(\eta\downarrow0). \tag{3}$$

The estimate (2) is equivalent to finite upper one-density at the origin of
the punctured autocorrelation measure
$\kappa^\circ=\kappa|_{\mathbb R\setminus\{0\}}$:

$$
\limsup_{\eta\downarrow0}
\frac{\kappa^\circ([ -\eta,\eta])}{\eta}<\infty. \tag{4}
$$

*Proof.*  Since $\sum_\gamma a(\gamma)<\infty$, $\mu$, $\nu$, and $\kappa$
are finite positive pure-point measures.  The sets
$[-\eta,\eta]\setminus\{0\}$ decrease to the empty set, so (3) is continuity
from above.  Formula (4) is just (2) after division by the fixed positive
constant $m_0^2$.  Nothing in continuity from above supplies a rate. $\square$

This already gives the correct qualitative conclusion for the product
variance.  Dominated convergence sends the Fejer-windowed variance to its
exact-resonance mass.  If there are no nontrivial exact additive relations,
the limit is $D_0=3(m_0^2-S_4)$.  Estimate (2) is needed only for a quantitative
$O(1/L)$ rate, not for this qualitative limit.

## 2. What the desired estimate would prove about the zeros

**Proposition 2 (four-zero Diophantine separation).**  If (2) holds with
constant $C$ for $0<\eta\le\eta_0$, then every nonzero four-zero defect of
size at most $\eta_0$ satisfies

$$
|\gamma_1+\gamma_2-\gamma_3-\gamma_4|
\ge \frac{a_1a_2a_3a_4}{C m_0^2}. \tag{5}
$$

In a block $|\gamma_j|\asymp T$, this is a polynomial separation theorem of
order $T^{-8}$.

*Proof.*  Put $\eta=|\gamma_1+\gamma_2-\gamma_3-\gamma_4|$ in (1).  The
specified ordered quadruple contributes $a_1a_2a_3a_4$ to the left side of
(2). $\square$

There is also a lower-order obstruction which the same-sign analysis misses.
Let $0<\gamma_1<\gamma_2<\cdots$ denote the positive ordinates.  The atom of
$\nu$ at zero has mass

$$
\nu(\{0\})=2\sum_{j>0}a(\gamma_j)^2=m_0.
$$

For $i<j$, each of the atoms at
$\pm(\gamma_j-\gamma_i)$ has mass at least $2a_i a_j$.  Comparing those atoms
with the zero atom in both orders gives the exact lower bound

$$
\boxed{
E_a^\circ(\eta)
\ge 8m_0\sum_{\substack{i<j\\0<\gamma_j-\gamma_i\le\eta}}a_i a_j .}
\tag{6}
$$

Consequently (2) implies the all-scale weighted small-gap estimate

$$
\sum_{\substack{i<j\\0<\gamma_j-\gamma_i\le\eta}}a_i a_j
\le \frac C8\eta m_0. \tag{7}
$$

Thus the target contains genuine pair-correlation information in addition to
four-point sum information.  RH locates the zeros on a line; it does not by
itself provide (5) or (7).  Montgomery's original RH-conditional theorem
controls a smoothed, height-averaged pair correlation in a restricted Fourier
range, and its full pair-correlation law remains conjectural.  The additive
energy estimates of Tao--Trudgian--Yang concern height exponents for zeros
with real part at least $\sigma$ at fixed macroscopic resolution.  At
$\sigma=1/2$ they do not imply the microscopic, weighted, all-height bound
(2).

Primary references:

- H. L. Montgomery, *The pair correlation of zeros of the zeta function*,
  Proc. Sympos. Pure Math. 24 (1973), 181--193,
  [DOI 10.1090/pspum/024/9944](https://doi.org/10.1090/pspum/024/9944).
- T. Tao, T. Trudgian, A. Yang, *New exponent pairs, zero density estimates,
  and zero additive energy estimates: a systematic approach* (2025),
  [arXiv:2501.16779](https://arxiv.org/abs/2501.16779).

## 3. A rigorous no-go for finite-prefix closure

The following statement identifies the exact limitation of the proposed
finite computation.

**Theorem 3 (finite prefix plus counting bounds cannot certify (2)).**  Fix
any finite initial list of signed ordinates.  Suppose that beyond it the only
available information is symmetry, simplicity, reality of the ordinates, and
a Riemann--von Mangoldt-type counting envelope

$$|N(t)-M(t)|\le R(t),$$

where $M'(t)\asymp\log t$ and $R(t)\to\infty$ (in particular, $R(t)$ is
eventually at least $6$).  There are infinite extensions
obeying all these data for which

$$
\limsup_{\eta\downarrow0}\frac{E_a^\circ(\eta)}{\eta m_0^2}=\infty. \tag{8}
$$

*Proof.*  Continue the prescribed prefix through a finite admissible
transition, then, beyond a height where $R(t)\ge6$, take inverse images of
consecutive integers under $M$.  This baseline has bounded counting error
and at least five units of slack in the stated envelope.  Choose
disjoint intervals $I_n=[T_n,T_n+5]$ tending to infinity.  Since
$M'(t)\asymp\log t$, each $I_n$ eventually contains at least four baseline
points.  Remove four of them and insert, avoiding the finitely many unchanged
points,

$$q_n,\quad q_n+\alpha_n,\quad q_n+\beta_n,\quad
q_n+\alpha_n+\beta_n+\varepsilon_n$$

inside $I_n$, together with their negatives.  The counting function changes
by at most four inside $I_n$ and is unchanged outside it.  Since
$R(t)\to\infty$, taking the $T_n$ large preserves the counting envelope.

All four new weights are bounded below by
$c_n=((T_n+5)^2+1/4)^{-1}$.  The total $m_0$ is bounded uniformly because
$\int^\infty (\log t)t^{-4}\,dt<\infty$.  Choose nonzero

$$
0<|\varepsilon_n|<\frac{c_n^4}{n\,\overline m_0^{\,2}}.
$$

The displayed quartet has pair-sum defect $\varepsilon_n$, hence contributes
at least $c_n^4$ to $E_a^\circ(|\varepsilon_n|)$.  The corresponding quotient
is greater than $n$. $\square$

This theorem does **not** construct another zeta function and therefore does
not disprove (2) for the actual zeta zeros under RH.  It proves the relevant
methodological no-go: the proposed finite prefix and the tail information
used in `exp21_dclose.py` cannot entail (2).  A proof must use new analytic
information controlling microscopic zero correlations, not only zero counts.

## 4. Audit of `exp21_dclose.py`

The interrupted program is useful exploratory code but is not a certificate
for the phase-free target.

1. It computes the **Beta-metric** weights
   $|W(\gamma,\gamma')|$ through `w_exact`; it never computes
   $a(\gamma)a(\gamma')$.
2. It discards opposite-sign pairs using their exponential suppression in
   the Beta metric.  In the product metric they are not suppressed.  If
   $A=\sum_{\gamma>0}a(\gamma)=B/2$, their two-orientation total mass is

   $$2A^2=\frac{B^2}{2}=1.066\ldots\times10^{-3},$$

   and their difference spectrum is exactly the sector producing (6).
3. Its far/out estimates leave an $\eta$-independent remainder.  The current
   run reports an alleged $L\to\infty$ ``floor'' equal to $0.0367D$.  This is
   a floor of that bounding method, not a bound tending to zero, so it cannot
   prove (2) or an asymptotic diagonal formula.
4. Only the decimal pair-sum scan in Part A uses integer arithmetic.  The
   weights, FFT convolution, analytic-tail constants, and roundoff slop in
   Part B are floating point, not interval arithmetic, so Part B is not V2.5.
5. Even Part A is limited by the input precision.  With the program's
   $14$-nanounit error allowance, the minimum stored pair-sum gap is already
   unresolved at sum cutoff $H=2000$ (one nanounit).  At $H=10000$ it finds
   2032 ordered near-pairs inside that allowance.  Certified zeros at greater
   precision could resolve those finitely many cases, but Theorem 3 would
   still block an all-height Lipschitz conclusion.

## 5. Correct status

- **Proved:** $E_a^\circ(\eta)\to0$; the Jensen lower bound in PRODUCT P4(a);
  the dominated-convergence limit in P4(b), including all exact resonances;
  the same-sign dyadic comparison of Beta and product weights in R1.
- **Conditional:** an $O(1/L)$ variance rate follows from absence of
  nontrivial exact resonances plus a multiscale estimate such as (2).
- **Open:** (2) for the actual zeta zeros under RH.
- **False as previously stated:** that (2) is finitely checkable from a zero
  prefix and crude counting tails; that `exp21_dclose.py` computes the
  phase-free energy; and that same-sign R1 makes the full product and Beta
  separation problems equivalent.

The durable frontier is therefore not a larger zero-table run.  It is a
weighted microscopic pair/four-correlation theorem strong enough to imply
(5)--(7), or a weaker multiscale estimate tailored directly to the Fejer
kernel.
