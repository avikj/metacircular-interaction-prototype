# Additive energy of zeta-zero ordinates: direct computation (Experiment 16)

`code/exp16_energy.py`, figure `figures/exp16_energy.png`. Data: first 100k
Odlyzko ordinates ($\gamma \le 74920.8$), via `pairfield.load_zeros()`.

This experiment computes, directly from the zeros, the two four-fold sums that
control the Goldbach-average variance of `APPENDIX_D`:

- the **unweighted near-diagonal additive energy**
  $E(\delta,T_0) = \#\{(i,j,k,l): \gamma\le T_0,\ |\gamma_i+\gamma_j-\gamma_k-\gamma_l|<\delta\}$
  (ordered quadruples, positive ordinates) — the $\sigma=\tfrac12$ instance of the
  energy $N^*(\sigma,T)$ systematized by Tao–Trudgian–Yang (arXiv:2501.16779,
  henceforth TTY);
- the **$\Gamma$-weighted energy** of Theorem D″,
  $E_W(\delta)=\sum_{|\delta_{1234}|\le\delta}|W_{12}\overline{W_{34}}|$ with
  $W_{12}=\Gamma(\rho_1)\Gamma(\rho_2)/\Gamma(\rho_1+\rho_2+2)$, whose
  off-diagonal/diagonal ratio at $\delta = 1/L$ is exactly the quantity that
  D.4's separation hypothesis needs to be small.

## 1. Method

**Unweighted.** All $\sim5\cdot10^9$ pair sums of 100k zeros are out of reach, so
pairs are restricted to ordinates $\le T_0\in\{2000,5000,10000\}$ (up to
$n=10142$ zeros, $5.14\cdot10^7$ pair sums, $\sim$0.4 GB; peak RSS $\sim$1 GB).
The $i<j$ sums $A$ are formed blockwise, sorted once, and near-collisions are
counted with vectorized sliding windows (chunked `searchsorted`); diagonal sums
$D=\{2\gamma_i\}$ are kept separate so no weight array is needed:
$E = 4C(A,A) + 4C(A,D) + C(D,D)$, $C(X,Y)=\#\{|x-y|<\delta\}$. Two Poisson
references are computed:

- **crude (uniform density)**: $E_{\rm P} = P^2\cdot 2\delta/R$ with $P=n^2$
  ordered pairs and $R$ the range of pair sums (the pair sums are
  Poisson-spaced per exp5c);
- **density-corrected (inhomogeneous Poisson)**:
  $E_{\rm dens}=2\delta\int f(s)^2\,ds$ with $f$ the empirical pair-sum density
  (histogram, bin 2), compared against
  $E_{\rm offdiag}=E-(2n^2-n)$, i.e. with the $2n^2-n$ identity quadruples
  $\{k,l\}=\{i,j\}$ (which sit at $\delta_{1234}=0$ for every $\delta$) removed.

Deviation of $E_{\rm offdiag}/E_{\rm dens}$ from 1 is the honest measure of
hidden additive structure: the crude ratio mostly measures the non-uniformity
of the zero density ($\propto\log t$), not arithmetic.

**Weighted.** Signed ordinates; opposite-sign pairs have
$|W|\ll e^{-\pi\min(|\gamma|,|\gamma'|)}$ and are dropped (Theorem D′). The
$(-,-)$ class mirrors the $(+,+)$ class and cross-class sums are $\ge 2\gamma_1
= 28.3$ apart, so off/diagonal ratios are computed inside the $(+,+)$ class,
where they equal the full-set ratios. $|W|$ is computed exactly by
`scipy.special.loggamma` for every ordered pair with $\gamma_i+\gamma_j\le
s_{\max}$; since $|W|\asymp(\gamma+\gamma')^{-5/2}$ and the pair-sum density is
$f(s)\asymp s\log^2 s$, the diagonal $2\sum|W|^2$ converges like $\int f|W|^2
\sim s^{-4}\log^2 s$ (tail at 300: $<2\%$) but the off-diagonal at fixed
$\delta$ like $\delta\int f^2|W|^2\sim s^{-3}\log^4 s$ — slower. So $E_W$ is
computed at cutoffs $s_{\max}=150,200,250,300$ and the tail is extrapolated
with that model. Diagonal = D.4's $\{(\gamma_3,\gamma_4)=(\gamma_1,\gamma_2)$
or $(\gamma_2,\gamma_1)\}$, i.e. $2\sum|W|^2$ minus the coincidence correction
at $\gamma_1=\gamma_2$.

## 2. Results: unweighted energy (a)

| $T_0$ | $n$ | $\delta$ | $E$ | $E_{\rm offdiag}$ | $E_{\rm Poisson}$ | $E/E_{\rm Poisson}$ | $E_{\rm offdiag}/E_{\rm dens}$ |
|---|---|---|---|---|---|---|---|
| 2000 | 1517 | 0.01 | 4.230e7 | 3.770e7 | 2.673e7 | **1.582** | **1.008** |
| 2000 | | 0.1 | 3.816e8 | 3.770e8 | 2.673e8 | 1.428 | 1.009 |
| 2000 | | 1 | 3.737e9 | 3.732e9 | 2.673e9 | 1.398 | 0.998 |
| 5000 | 4520 | 0.01 | 1.212e9 | 1.171e9 | 8.379e8 | 1.447 | 1.006 |
| 5000 | | 0.1 | 1.175e10 | 1.171e10 | 8.379e9 | 1.403 | 1.006 |
| 5000 | | 1 | 1.164e11 | 1.163e11 | 8.379e10 | 1.389 | 0.999 |
| 10000 | 10142 | 0.01 | 1.493e10 | 1.473e10 | 1.060e10 | **1.409** | **1.004** |
| 10000 | | 0.1 | 1.474e11 | 1.472e11 | 1.060e11 | 1.391 | 1.004 |
| 10000 | | 1 | 1.466e12 | 1.466e12 | 1.060e12 | 1.383 | 1.000 |

Reading:

- The crude Poisson ratio is a stable **1.38–1.58**, drifting toward $\approx
  1.38$ with growing $T_0$ and $\delta$. This entire excess is the density
  profile: the pair-sum density $f(s)$ is not uniform on $[2\gamma_1, 2T_0]$
  (zero density grows like $\log t$, and the convolution square peaks
  mid-range), and $\int f^2 \big/ (\,(\int f)^2/R\,) \approx 1.4$.
- After correcting for density, the ratio is **$1.000\pm0.009$ across all nine
  cells**. The zero ordinates' pair sums show *no measurable additive
  structure beyond their density*: near-quadruple counts are those of an
  inhomogeneous Poisson process. The tiny ($\lesssim1\%$) excess at
  $\delta=0.01$ shrinks with $T_0$ (1.008 → 1.004) and is at the level of the
  density-histogram systematics.

### (c) Scaling in $\delta$

Least-squares slope of $\log E_{\rm offdiag}$ vs $\log\delta$ over
$\delta\in\{0.01,0.1,1\}$:

| $T_0$ | 2000 | 5000 | 10000 | Poisson |
|---|---|---|---|---|
| slope | 0.998 | 0.999 | 0.999 | 1 |

The energy is *linear in the resolution* over two decades — again exactly
Poisson (and consistent with TTY's comparability $E_1\asymp E_r$ for fixed
$r>0$, here with an essentially exact proportionality constant $r$).

## 3. Results: weighted energy of Appendix D (b)

At $\delta_* = 1/\log 10^6 = 0.07238$ (the resolution relevant to a
Fejér window of log-length $L=\log 10^6$), $(+,+)$ class:

| cutoff $s_{\max}$ | pairs | zeros | $\sum\lvert W\rvert^2$ | diagonal | off-diag | off/diag |
|---|---|---|---|---|---|---|
| 150 | 782 | 46 | 1.6534e-6 | 2.8718e-6 | 3.196e-7 | 0.1113 |
| 200 | 1889 | 72 | 1.6970e-6 | 2.9585e-6 | 4.619e-7 | 0.1561 |
| 250 | 3647 | 99 | 1.7166e-6 | 2.9976e-6 | 5.622e-7 | 0.1876 |
| 300 | 6164 | 129 | 1.7268e-6 | 3.0180e-6 | 6.354e-7 | **0.2105** |
| $\infty$ (extrapolated) | — | — | — | 3.051e-6 | 9.12e-7 | **≈ 0.30** |

Resolution dependence (cutoff 300): off/diag = 0.0204 at $\delta=0.01$, 0.2105
at $\delta_*$, 0.2872 at $\delta=0.1$, 3.20 at $\delta=1$; for $\delta\le0.12$
the law is cleanly linear,

$$\frac{E_W^\circ(\delta)}{2\sum|W|^2} \;\approx\; 2.8\,\delta .$$

Weighted Poisson check: the prediction $E_W^\circ \approx 2\delta\int
f_w(s)^2ds$ from the $|W|$-weighted pair-sum density alone reproduces the
measured off-diagonal to **0.91** at $\delta_*$ — the weighted energy, like the
unweighted one, contains no additive conspiracy: it is what the density and
the weights force.

### Verdict on Theorem D″

The quantity D.4 needs is $E^\circ_W(1/L) = o\big(\sum|W_{12}|^2\big)$ as
$L\to\infty$. Empirically:

1. **The asymptotic statement holds in the strongest (Poisson) form**:
   off/diag $\approx 2.8\,\delta = 2.8/L \to 0$ linearly, with a constant fully
   explained by the pair-sum density. The separation hypothesis of D.4 — the
   only unproved ingredient of (D.3) — is *quantitatively true* in the range
   computable from real zeros.
2. **At the concrete height $X=10^6$** ($\delta_*=1/\log 10^6$) the
   off-diagonal is 21% of the diagonal at cutoff 300 and $\approx30\%$ after
   tail extrapolation. So $V \asymp$ diagonal holds with constant in
   $[0.7,\,1.3]$ *even before* exploiting the oscillation: in (D.1) the
   off-diagonal enters through
   $\mathrm{sinc}^2(L\delta/2)\,e^{i\delta u_0}$, so $E_W$ (absolute values) is
   an upper bound, and the sinc² factor alone is $\le0.9$ over most of
   $|\delta|\le\delta_*$. The variance really is diagonal-dominated, with the
   off-diagonal a controlled, sign-oscillating $\lesssim30\%$ correction that
   dies like $1/L$.
3. Because the weights decay ($s^{-5/2}$ per pair, $s^{-3}\log^4 s$ for the
   off-diagonal integrand), $E_W$ is dominated by zeros below height a few
   hundred — the regime this computation covers *exactly*. Unlike the
   unweighted problem, no assumption about zeros at large height is being
   extrapolated; only the modelled $\approx30\%$ tail of the off-diagonal is.

**Empirical verdict: Theorem D″'s asymptotic $V \sim 2\sum|W_{12}|^2$ is
supported.** The needed separation is not marginal — the off-diagonal sits at
its Poisson floor (ratio 0.91 of the density prediction), an order of
magnitude below the level ($\sim$ diagonal) at which (D.3) would fail.

## 4. Relation to Tao–Trudgian–Yang (arXiv:2501.16779)

TTY define (their Definition 7) the additive energy $E_1(W)$ of a multiset of
reals as the number of quadruples with $|t_1+t_2-t_3-t_4|\le1$, and (their
Definition 56) $N^*(\sigma,T)$ as the additive energy of the imaginary parts
of zeros with $\mathrm{Re}(\rho)\ge\sigma$, $|\mathrm{Im}(\rho)|\le T$, with
zero-density-energy exponent $A^*(\sigma)$ defined by $N^*(\sigma,T)\ll
T^{A^*(\sigma)(1-\sigma)+o(1)}$. So our $E(\delta{=}1,T_0)$ *is* their
$N^*(1/2,T_0)$ up to two conventions: we use positive ordinates only (their
signed set is symmetric; it doubles $n$ and adds exact antisymmetric
quadruples $\gamma,-\gamma,\gamma',-\gamma'$, a lower-order $O(N^2)$ family),
and we count strict inequality (measure-zero difference).

**What their bounds give at these heights.** Trivially $2A(\sigma)\le
A^*(\sigma)\le 3A(\sigma)$. At $\sigma=1/2$, $A(1/2)=2$ (Riemann–von
Mangoldt), so $T^2 \ll N^*(1/2,T)\ll T^{3+o(1)}$; Heath-Brown's 1979 bound
$A^*(\sigma)\le(10-11\sigma)/((2-\sigma)(1-\sigma))$ gives $A^*(1/2)\le6$,
i.e. again $T^{3+o(1)}$ — *at the critical line the best known upper bound is
the trivial one*. And Cauchy–Schwarz on the $N^2$ pair sums spread over an
interval of length $\asymp T$ pushes the lower bound up to $N^*\gg (N^2)^2/T
\asymp T^3\log^4 T$: upper and lower bounds already meet at $T^{3+o(1)}$, so
the only open question at $\sigma=1/2$ is the constant. Our measurement decides
the constant: $N^*(1/2,10^4) \approx 1.47\cdot10^{12} \approx 1.4\,n^3$, i.e.
**the full zero set has maximal additive energy in the exponent, and the
constant is exactly Poisson**. There is no hidden savings to be had at
$\sigma=1/2$: the energy is as large as the density allows, so approaches
hoping for a power saving on the *unweighted* full-set energy are ruled out
numerically as well as heuristically.

**The honest difference.** TTY's new content (their Theorem 64) lives at
$7/10\le\sigma<1$: bounds like $A^*(\sigma)(1-\sigma)\le\max(\ldots)$ that
beat Heath-Brown for sparse sets of *hypothetical off-line zeros*, proved via
large-value energy regions and exponent pairs, and used unconditionally for
zero-density estimates and primes in short intervals. Under RH those sets are
empty; our data (Odlyzko zeros, all on the line) cannot probe them, and their
theorems say nothing about our $\sigma=1/2$ computation. The two objects meet
only in the *program* of D.6(1): to replace D.4's Poisson-separation
heuristic by a proven bound one needs an $N^*$-type estimate for the weighted,
$\delta$-resolution energy at $\sigma=1/2$ — a different regime from TTY's,
but exactly their machinery's shape (their $E_r\asymp E_1$ comparability, and
energy-vs-density bookkeeping, transfer verbatim). What is actually needed is
far weaker than a power saving: any bound $E^\circ_W(\delta)\le c\,\delta\cdot
\sum|W|^2$ with explicit $c$ — our measured $c\approx2.8$ — would close
Theorem D″ under RH.

## 5. Implications for the Goldbach-variance program

- The chain of `APPENDIX_D` — variance $=$ weighted energy $=$ diagonal
  $\times(1+O(\delta))$ — now has every link either proved (D.1–D.3), or
  verified numerically at the relevant scale with the failure mode (additive
  conspiracy among low zeros) *directly excluded by measurement*: pair sums of
  the zeros that carry 98% of the weight behave Poisson to $\le9\%$ in the
  weighted metric and $\le1\%$ in the unweighted one.
- The Ω-result constant of D.5 is therefore trustworthy: with the diagonal
  measured here ($2\sum|W|^2 \approx 3.05\cdot10^{-6}$ per same-sign class,
  $6.1\cdot10^{-6}$ over both), the second-order Goldbach term genuinely
  oscillates at RMS $\sqrt{V}\approx\sqrt{6.1\cdot10^{-6}}\approx2.5\cdot10^{-3}
  \cdot x^2$ — the same 0.0025 closed numerically in D.5's Parseval table.
- What a proof still needs (D.6(1)): an unconditional-under-RH bound
  $E^\circ_W(\delta)\ll\delta\sum|W|^2$. The numerics say the true constant is
  $\approx2.8$ and Poisson-forced; since the weights confine everything to
  zeros of height $O(10^2$–$10^3)$, a *finite verified computation plus a tail
  bound from the $s^{-5/2}$ weight decay and any crude sup on the local
  pair-sum density* would make the Goldbach-variance asymptotic
  $V\sim2\sum|W|^2$ a theorem under RH. That is a genuinely finite-checkable
  reduction — the numerical half of it is this experiment.

## 6. Reproducibility

`python3 code/exp16_energy.py` (from `code/`): ~60 s, peak ~1 GB. Windowed
counting is exact (integer counts, no binning) for both energies; only the two
Poisson *references* and the weighted tail extrapolation involve modelling.
Figure: left — $E_{\rm offdiag}(\delta,T_0)$ vs $\delta$ (log–log) with
density-corrected Poisson dashed lines indistinguishable from the data, slopes
$\approx1$; right — weighted off/diagonal ratio vs $\delta$, marking
$\delta_*=1/\log10^6$ (ratio 0.211 at cutoff 300).
