# Weil positivity and the pair field: the exact obstruction

Companion to `REPORT.md` §7(b) and Remark 1.2. This note (i) fixes a normalization
of the Weil explicit-formula quadratic form and proves it, (ii) states and proves,
as a displayed proposition, *exactly why* the automatic Hermitian-square positivity
of the pair field ($Z=|P|^2\ge0$, Prop 1.1(ii)) does not transfer to Weil
positivity — the pole and archimedean terms are the obstruction, and we write the
exact identity relating the two quadratic forms, (iii) verifies the explicit
formula numerically to $\le 2\cdot10^{-10}$ relative on 16 test functions using up
to 100,000 Odlyzko zeros (`code/exp14_weil.py`, `figures/exp14_weil.png`), and
(iv) maps the positivity margin over a Gaussian test family, locating where it is
thinnest. A closing section states honestly what Connes–Consani have proven and
what a pair-field contribution could add.

---

## 1. Normalization: the Weil explicit formula

For $F:\mathbb R\to\mathbb C$ write $u=\log x$ (so $F$ lives on the multiplicative
group $\mathbb R_{>0}$) and define the *completed transform*

$$\Phi(s)\;=\;\int_{\mathbb R}F(u)\,e^{(s-\frac12)u}\,du ,$$

so that $\Phi(\tfrac12+i\tau)=\widehat F(-\tau)$ is a Fourier transform on the
critical line. Call $F$ **admissible** if $F\in C^2(\mathbb R)$ and
$F,F',F''\ll e^{-(\frac12+\delta)|u|}$ for some $\delta>0$ (then $\Phi$ is
holomorphic in $-\delta<\operatorname{Re}s<1+\delta$ and
$\Phi(\sigma+i\tau)\ll(1+|\tau|)^{-2}$ there, uniformly on compact $\sigma$-sets).
Gaussians and $C_c^\infty$ functions are admissible.

**Proposition W1 (explicit formula).** For admissible $F$, with $\rho$ running
over the nontrivial zeros of $\zeta$ with multiplicity,

$$\boxed{\;\sum_\rho \Phi(\rho)\;=\;\underbrace{\Phi(0)+\Phi(1)}_{\text{pole}}
\;-\;\underbrace{\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}\bigl[F(\log n)+F(-\log n)\bigr]}_{\text{prime side}}
\;+\;\underbrace{\frac1{2\pi}\int_{\mathbb R}\Phi(\tfrac12+i\tau)\Bigl[\operatorname{Re}\psi\bigl(\tfrac14+\tfrac{i\tau}2\bigr)-\log\pi\Bigr]d\tau}_{\text{archimedean }A(F)}\;}$$

where $\psi=\Gamma'/\Gamma$. (Equivalently, with $h(\tau)=\Phi(\frac12+i\tau)$,
this is the Riemann–Weil formula $\sum_\gamma h(\gamma)= h(\frac i2)+h(-\frac i2)
-\sum_n \Lambda(n)n^{-1/2}[F(\log n)+F(-\log n)]+\frac1{2\pi}\int
h(\tau)[\operatorname{Re}\psi(\frac14+\frac{i\tau}2)-\log\pi]\,d\tau$.)

*Proof.* Let $\xi(s)=\tfrac12 s(s-1)\pi^{-s/2}\Gamma(s/2)\zeta(s)$, whose zeros
are exactly the nontrivial zeros of $\zeta$ and which satisfies $\xi(s)=\xi(1-s)$,
hence $\frac{\xi'}{\xi}(1-s)=-\frac{\xi'}{\xi}(s)$, and

$$\frac{\xi'}{\xi}(s)=\frac1s+\frac1{s-1}-\frac{\log\pi}2+\frac12\psi\Bigl(\frac s2\Bigr)+\frac{\zeta'}{\zeta}(s).$$

Integrate $\Phi(s)\frac{\xi'}{\xi}(s)\frac{ds}{2\pi i}$ counterclockwise around
the rectangle $\operatorname{Re}s\in[-1,2]$, $|\operatorname{Im}s|\le T_j$, with
$T_j\to\infty$ chosen along the standard sequences avoiding ordinates of zeros so
that $\xi'/\xi\ll\log^2 T_j$ on the horizontal edges; since
$\Phi\ll(1+|\tau|)^{-2}$ those edges vanish. The residues give
$\sum_\rho\Phi(\rho)$. Substituting $s\mapsto1-s$ on the left edge and using the
functional equation,

$$\sum_\rho\Phi(\rho)=\frac1{2\pi i}\int_{(2)}\bigl[\Phi(s)+\Phi(1-s)\bigr]\frac{\xi'}{\xi}(s)\,ds .$$

Now treat the four pieces of $\xi'/\xi$.

*(a) Dirichlet piece.* $\zeta'/\zeta(s)=-\sum_n\Lambda(n)n^{-s}$ converges
absolutely on $(2)$. By Fourier inversion of
$\Phi(\sigma+i\tau)=\int F(u)e^{(\sigma-\frac12)u}e^{i\tau u}du$,

$$\frac1{2\pi i}\int_{(2)}\Phi(s)\,n^{-s}\,ds=F(\log n)\,n^{-1/2},\qquad
\frac1{2\pi i}\int_{(2)}\Phi(1-s)\,n^{-s}\,ds=F(-\log n)\,n^{-1/2},$$

giving the prime side with its minus sign.

*(b) Pole piece.* Move $\frac1{2\pi i}\int_{(2)}[\Phi(s)+\Phi(1-s)]
\bigl(\frac1s+\frac1{s-1}\bigr)ds$ to the line $(\tfrac12)$: the only pole crossed
is $s=1$, with residue $\Phi(1)+\Phi(0)$. On the half-line the integrand vanishes
by parity: $\frac1{\frac12+i\tau}+\frac1{-\frac12+i\tau}
=\frac{-2i\tau}{\frac14+\tau^2}$ is odd in $\tau$ while
$\Phi(\frac12+i\tau)+\Phi(\frac12-i\tau)$ is even.

*(c) Archimedean piece.* $\frac12\psi(s/2)-\frac12\log\pi$ is holomorphic in
$\operatorname{Re}s>0$; moving to $(\tfrac12)$ crosses no pole, and on
$s=\frac12+i\tau$, symmetrizing in $\tau$ and using
$\psi(\bar z)=\overline{\psi(z)}$,

$$\frac1{2\pi}\int\Phi(\tfrac12+i\tau)\,\tfrac12\bigl[\psi(\tfrac14+\tfrac{i\tau}2)+\psi(\tfrac14-\tfrac{i\tau}2)-2\log\pi\bigr]d\tau
=\frac1{2\pi}\int\Phi(\tfrac12+i\tau)\bigl[\operatorname{Re}\psi(\tfrac14+\tfrac{i\tau}2)-\log\pi\bigr]d\tau. \qquad\blacksquare$$

Note the trivial zeros need no separate term: $\xi$ has none, and their effect
sits inside $\psi(s/2)$. The archimedean density
$D(\tau)=\operatorname{Re}\psi(\frac14+\frac{i\tau}2)-\log\pi$ is **negative for
$|\tau|<2\pi$** (at $\tau=0$: $\psi(\frac14)-\log\pi=-\gamma_E-\frac\pi2-3\log2-\log\pi
\approx-5.372$) and $\sim\log\frac{|\tau|}{2\pi}$ at large $|\tau|$ — the mean
zero density, as it must be.

## 2. The Weil quadratic form

For a test bump $g$ (admissible, complex-valued) put
$\tilde g(u)=\overline{g(-u)}$ and $F=g\star\tilde g$ (multiplicative
convolution, $F(u)=\int g(v)\overline{g(v-u)}\,dv$). Then
$\Phi_F(s)=\Phi_g(s)\cdot\overline{\Phi_g(1-\bar s)}$, so **on the critical line**
$\Phi_F(\frac12+i\tau)=|\Phi_g(\frac12+i\tau)|^2\ge0$, and
$\overline{F(-u)}=F(u)$, so $F(\log n)+F(-\log n)=2\operatorname{Re}F(\log n)$.
Define the **Weil form**

$$W(g)\;:=\;\sum_\rho \Phi_{g\star\tilde g}(\rho)
\;=\;\underbrace{2\operatorname{Re}\bigl[\Phi_g(0)\overline{\Phi_g(1)}\bigr]}_{\text{pole}}
\;-\;\underbrace{\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}\,2\operatorname{Re}F(\log n)}_{\text{prime}}
\;+\;\underbrace{A(g\star\tilde g)}_{\text{arch}} .$$

**Proposition W2 (Weil's criterion).** RH $\iff$ $W(g)\ge0$ for all
$g\in C_c^\infty(\mathbb R)$.

*Proof sketch.* ($\Rightarrow$) Under RH every $\rho=\frac12+i\gamma$ gives
$\Phi_F(\rho)=|\Phi_g(\frac12+i\gamma)|^2\ge0$ termwise. ($\Leftarrow$) If
$\rho_0=\beta_0+i\gamma_0$ with $\beta_0>\frac12$, take
$g_t(u)=e^{(\beta_0-\frac12+i\gamma_0)u}\chi(u/t)$ with $\chi$ a fixed bump; as
$t\to\infty$ the pair $\{\rho_0,1-\bar\rho_0\}$ contributes to $W(g_t)$ a term
growing like $t^2$ times an oscillating factor of non-constant sign, while all
on-line zeros, pole and archimedean terms are $O(t)$; a suitable $t$-sequence
makes $W(g_t)<0$ (Weil 1952; Bombieri 2000 for this quantitative form). $\square$

## 3. The obstruction: why automatic positivity does not transfer

This is `REPORT.md` Remark 1.2 and §7(b) made precise. Recall the pair-field
objects: $P(z)=\sum_n\Lambda(n)e^{-nz}$, $Z(t,\theta)=|P(t+i\theta)|^2\ge0$
automatically, and the expansion (REPORT §3)

$$P(z)=M(z)-N(z),\qquad M(z)=\frac1z-\log2\pi+R(z),\qquad
N(z)=\sum_\rho\Gamma(\rho)z^{-\rho},$$

$M$ = pole + archimedean amplitude ($R$ collects the trivial-zero/$\Gamma$-pole
terms, $O(|z|)$ in sectors), $N$ = zero amplitude. On the linear (Weil)
side, for admissible $g$ supported in $(0,\infty)$ define the prime amplitude
$L(g)=\sum_n\Lambda(n)n^{-1/2}g(\log n)$ and the pole+arch functional
$C(g)=\Phi_g(0)+\Phi_g(1)+A(g)$, so that Proposition W1 reads
$L(g)=C(g)-\sum_\rho\Phi_g(\rho)$.

**Proposition W3 (transfer obstruction).**

1. **(Prime-side Hermitian square = zero-side form + pole + archimedean
   corrections.)** For every admissible $g$ supported in $(0,\infty)$,
   $$0\;\le\;\bigl|L(g)\bigr|^2\;=\;\Bigl|\sum_\rho\Phi_g(\rho)\Bigr|^2
   \;-\;2\operatorname{Re}\Bigl[C(g)\,\overline{\sum_\rho\Phi_g(\rho)}\Bigr]
   \;+\;\bigl|C(g)\bigr|^2 ,$$
   and identically in the pair field, on $\operatorname{Re}z>0$:
   $$0\;\le\;Z(t,\theta)=|P(z)|^2=\underbrace{|N(z)|^2}_{\text{full zero-pair form}}
   -\;2\operatorname{Re}\bigl[M(z)\overline{N(z)}\bigr]\;+\;|M(z)|^2 .$$
2. **(Coefficient-blindness.)** The left inequalities hold with $\Lambda$
   replaced by an arbitrary sequence (Prop 1.1(ii) of REPORT.md); they use no
   property of $\zeta$. Consequently they cannot imply any sign statement about
   a zero functional: the automatic positivity is a property of the *rank-one
   tensor* $a\otimes a$, not of the arithmetic.
3. **(Tensor-level mismatch.)** The zero content of the prime-side square is the
   **full pair form** $|N|^2=\sum_{\rho,\rho'}\Gamma(\rho)\overline{\Gamma(\rho')}
   z^{-\rho}\bar z^{-\bar\rho'}$ (equivalently $|\sum_\rho\Phi_g(\rho)|^2$): all
   off-diagonal zero pairs, with oscillating phases and no fixed sign. The Weil
   form is the **diagonal** $\sum_\gamma|\Phi_g(\frac12+i\gamma)|^2$: linear in
   $\Lambda$, quadratic in $g$. In the language of REPORT §6, $W(g)$ is a
   *Hermitian-square (difference-marginal) functional of the zeros* while
   $|L(g)|^2$ is a *Hermitian square of prime data*; extracting the diagonal
   from $|N|^2$ (a Besicovitch average over the aperture/modulation variable)
   transfers the cross terms $-2\operatorname{Re}(M\overline N)$ — i.e. the pole
   and archimedean corrections — intact, and these are sign-indefinite: the pole
   quadratic $2\operatorname{Re}[\Phi_g(0)\overline{\Phi_g(1)}]$ has signature
   $(1,1)$, and the archimedean density $D(\tau)$ is negative on $|\tau|<2\pi$.
4. **(The inequality points the wrong way.)** If $(g\star\tilde g)(u)\ge0$ for
   $|u|\ge\log2$ (e.g. any real Gaussian bump, where $g\star\tilde g\ge0$
   everywhere), then $\Lambda\ge0$ gives $\operatorname{prime}(g)\ge0$, hence
   $$W(g)\;\le\;2\operatorname{Re}\bigl[\Phi_g(0)\overline{\Phi_g(1)}\bigr]+A(g\star\tilde g):$$
   prime-side positivity yields an **upper** bound on the Weil form. RH is the
   **lower** bound $W(g)\ge0$, i.e. the statement that the prime side never
   overshoots the pole + archimedean budget:
   $$\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}\,2\operatorname{Re}F(\log n)
   \;\le\;2\operatorname{Re}\bigl[\Phi_g(0)\overline{\Phi_g(1)}\bigr]+A(F)
   \qquad\forall g .$$
5. **(Quantitative domination by the pole.)** As $z\to0$ in sectors
   $|\arg z|\le\frac\pi2-\delta$, $|M(z)|\sim1/|z|$ while (under RH)
   $|N(z)|=O(|z|^{-1/2})$; thus $|P|^2\ge0$ is implied by $|M|>|N|$ — the pole
   term alone certifies the automatic inequality in the very regime where the
   zero amplitude carries its information, leaving the sign of the diagonal form
   completely undetermined.

*Proof.* (1) is the algebraic expansion of $|C-\Sigma|^2$ resp. $|M-N|^2$,
using Prop W1 for the first display and REPORT §3 for the second. (2) is
Prop 1.1(ii): $|\,\cdot\,|^2\ge0$. (3) The two displays in (1) show the zero
content enters only as $|\Sigma_\rho|^2$; expanding gives all pairs
$(\rho,\rho')$, and the diagonal cannot be isolated by any operation that is
positive on Hermitian squares without carrying the cross term
$-2\operatorname{Re}(C\overline\Sigma)$ along; the signature claim is the
elementary fact that $(x,y)\mapsto2\operatorname{Re}(x\bar y)$ has eigenvalues
$\pm1$, and $D(\tau)<0$ on $|\tau|<2\pi$ was computed in §1. (4) Drop
nonnegative terms in the $W$-decomposition of §2. (5) Stirling gives
$|\Gamma(\frac12+i\gamma)|=\sqrt{\pi/\cosh\pi\gamma}$, so
$|N(z)|\le|z|^{-1/2}\sum_\rho|\Gamma(\rho)|e^{|\gamma\arg z|}<\infty$ for
$|\arg z|<\frac\pi2$, uniformly $O(|z|^{-1/2})$ in sectors. $\blacksquare$

**Remark.** Part (4) is the cleanest one-line answer to "why doesn't
$|P|^2\ge0$ help": *the prime term enters Weil's form with a minus sign.* The
free positivity lives on the wrong side of the inequality that RH asserts. What
RH demands is a two-sided equidistribution: the smoothed prime sum must track
the pole term ($\Phi_F(1)$, i.e. PNT in the window $F$) so accurately that the
archimedean term controls the residual — and the residual *is* the zero side.
Experiment 14 below displays this budget being saturated.

## 4. Gaussian test family: closed forms

Take bumps on the multiplicative group, $u=\log x$:
$g_{a,\sigma,\beta}(u)=e^{-(u-a)^2/2\sigma^2}e^{i\beta u}$ (center $a$, width
$\sigma$, modulation/frequency-center $\beta$). Every term of $W$ is independent
of $a$ — a translation on the group is a modulation, and $g\star\tilde g$ kills
it (verified numerically to $8\cdot10^{-15}$) — so the honest parameters are
$(\sigma,\beta)$, and $|\Phi_g(\frac12+i\tau)|^2$ is a Gaussian window of width
$1/\sigma$ *centered at $\tau=\beta$ on the zero axis*. Writing $w=s-\frac12$:

$$\Phi_F(s)=2\pi\sigma^2e^{\sigma^2(w+i\beta)^2},\qquad
F(u)=\sigma\sqrt\pi\,e^{-u^2/4\sigma^2}e^{i\beta u},$$

$$W(g)=2\pi\sigma^2\sum_{\gamma>0}\Bigl[e^{-\sigma^2(\gamma-\beta)^2}+e^{-\sigma^2(\gamma+\beta)^2}\Bigr]
\quad\text{(zero side, using RH-verified data)},$$

$$\text{pole}=4\pi\sigma^2e^{\sigma^2(\frac14-\beta^2)}\cos(\sigma^2\beta),\qquad
\text{prime}=2\sigma\sqrt\pi\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}e^{-(\log n)^2/4\sigma^2}\cos(\beta\log n),$$

$$\text{arch}=\sigma^2\int_{\mathbb R}e^{-\sigma^2(\tau-\beta)^2}D(\tau)\,d\tau .$$

A second, independent family — complex mixtures
$g=\sum_kc_k e^{-(u-a_k)^2/2\sigma_k^2}e^{i\beta_ku}$ with $F=g\star\tilde g$
computed by a separate Gaussian-product formula and cross-checked against direct
quadrature ($\le2\cdot10^{-15}$) — tests the same normalization with genuinely
complex $F$ and center-dependence.

## 5. Numerical verification (exp14)

`code/exp14_weil.py`; $\Lambda$ to $10^7$ (665,134 prime powers), first
$K\le100{,}000$ Odlyzko zeros, archimedean integral by trapezoid at step
$h=0.02$ (integrand analytic in $|\operatorname{Im}\tau|<\frac12$, so the
quadrature error is $\sim e^{-\pi/h}$). Both sides computed independently;
relative deviation $|{\rm zero\ side}-({\rm pole}-{\rm prime}+{\rm arch})|/
|{\rm zero\ side}|$:

| test function | zero side | pole − prime + arch | rel. dev. |
|---|---|---|---|
| $\sigma=0.001,\ \beta=0$ | 7.257005e−03 | 7.257005e−03 | 3.6e−16 |
| $\sigma=0.005,\ \beta=0$ | 2.224169e−02 | 2.224169e−02 | 6.8e−14 |
| $\sigma=0.02,\ \beta=0$ | 4.312423e−02 | 4.312423e−02 | 2.1e−12 |
| $\sigma=0.05,\ \beta=0$ | 4.313596e−02 | 4.313596e−02 | 1.6e−11 |
| $\sigma=0.1,\ \beta=0$ | 1.881161e−02 | 1.881161e−02 | 7.5e−11 |
| $\sigma=0.15,\ \beta=0$ | 3.169642e−03 | 3.169642e−03 | 1.7e−10 |
| $\sigma=0.3,\ \beta=\gamma_1$ | 5.734133e−01 | 5.734133e−01 | 3.9e−12 |
| $\sigma=0.5,\ \beta=\gamma_1$ | 1.570807e+00 | 1.570807e+00 | 5.7e−15 |
| $\sigma=1,\ \beta=\gamma_1$ | 6.283185e+00 | 6.283185e+00 | 1.4e−16 |
| $\sigma=1.5,\ \beta=\gamma_1$ | 1.413717e+01 | 1.413717e+01 | 2.4e−11 |
| $\sigma=0.5,\ \beta=\gamma_2$ | 1.600227e+00 | 1.600227e+00 | 5.4e−12 |
| $\sigma=0.7,\ \beta=\gamma_4$ | 3.219202e+00 | 3.219202e+00 | 2.8e−11 |
| $\sigma=1,\ \beta=\gamma_3$ | 6.283186e+00 | 6.283186e+00 | 4.2e−16 |
| $\sigma=1.2,\ \beta=\gamma_8$ | 9.047788e+00 | 9.047788e+00 | 5.9e−16 |
| mixture M1 (2 bumps, complex) | 1.146317e−01 | 1.146317e−01 | 1.8e−10 |
| mixture M2 (2 bumps, complex) | 6.612528e−01 | 6.612528e−01 | 1.9e−11 |

**Worst case 1.8e−10 — four orders below the 1e−6 target**; the residual floor
is set by the $3\cdot10^{-9}$ accuracy of the zero data, not by the
normalization. $K$-dependence at $\sigma=0.001$ (the window then weights
$\approx5{,}700$ zeros, needing ordinates up to $\sim6000$): $K=10^3$ leaves a
$6\cdot10^{-2}$ deficit; $K=10^4$ already reaches $6\cdot10^{-16}$; $K=10^5$
idem. This is a stringent joint test of *every* constant in Proposition W1 (a
wrong $\log\pi$, a missing $\frac12$ in $\psi(\frac14+\frac{i\tau}2)$, or a
dropped pole term shows up at $10^{-2}$–$10^{0}$).

## 6. The positivity margin

Margin $\mu:=W/(|\text{pole}|+|\text{prime}|+|\text{arch}|)$ — the fraction of
the terms' total mass that survives cancellation. Since our zeros lie on the
line, $W\ge0$ always; the question is *how thin* it runs. Findings
(`figures/exp14_weil.png`, panels b–d):

- **Narrow bumps ($\sigma\lesssim0.08$, i.e. $F$ supported in
  $(\frac12,2)$ multiplicatively — the Connes–Consani window): comfortable.**
  The prime term is empty ($F(\log2)\approx e^{-(\log2)^2/4\sigma^2}$), the
  pole term $4\pi\sigma^2e^{\sigma^2/4}>0$, and the archimedean term is
  *positive* here (it flips sign at $\sigma\approx0.06$; positive because a
  width-$1/\sigma\gg2\pi$ window in $\tau$ sees the positive density
  $\log\frac{\tau}{2\pi}$, not the negative well at $\tau=0$). Margin
  $\mu=1.00$: no cancellation at all in the Gaussian family.
- **Wide bumps at low frequency ($\beta\approx0$, $\sigma\gtrsim0.3$): the
  margin collapses doubly exponentially.** The window
  $|\Phi_g|^2$ sits in the **spectral gap $(0,\gamma_1)$**, so
  $W\approx4\pi\sigma^2e^{-\sigma^2\gamma_1^2}$, while pole and prime terms are
  individually large and cancel: at $\sigma=1.5$, pole $=+49.62$, prime
  $=+38.90$ (ratio $0.784\to1$ as $\sigma\to\infty$: both approach
  $4\pi\sigma^2e^{\sigma^2/4}$ — the PNT cancellation in the window $F$), arch
  $=-10.25$, and $W=\mu\cdot O(10^2)$ with measured $\mu=1.7\cdot10^{-196}$ at
  $(\beta,\sigma)=(0,1.5)$ — the thinnest point on the scanned grid. Measured
  scan: $\mu=1.9\cdot10^{-6}$ at $\sigma=0.25$, $1.3\cdot10^{-18}$ at
  $\sigma=0.45$, $8.5\cdot10^{-64}$ at $\sigma=0.85$. Where the zero side
  underflows entirely, the assembled pole − prime + arch cancels to the
  double-precision floor ($|{\rm RHS}|/{\rm scale}\le5\cdot10^{-15}$) — the
  prime side "knows" the emptiness of $(0,\gamma_1)$ to that depth.
- **Frequency scans ($\sigma=1$, $\beta\in[0,45]$):** $\mu$ peaks at $\approx1$
  when $\beta$ sits on a zero $\gamma_j$ and dips between zeros
  ($\mu\approx2\cdot10^{-5}$ mid-gap between $\gamma_1$ and $\gamma_2$), with
  the deep collapse reserved for the central gap $\beta<\gamma_1$:
  min $\mu=6.7\cdot10^{-88}$ at $\beta=0$.
- **Uncertainty tradeoff.** To aim the window into the gap one needs
  $\sigma\gamma_1\gg1$, i.e. $\sigma\gtrsim0.2$; but then
  $e^{-(\log2)^2/4\sigma^2}$ is no longer small and the primes enter the
  budget: *in the Gaussian family one cannot probe the spectral gap without
  invoking the prime–pole cancellation.* Conversely with support inside
  $(\frac12,2)$ the frequency resolution $1/\sigma\gtrsim12$ cannot resolve
  either the gap or the negative archimedean well $|\tau|<2\pi$. The thin
  margin is exactly the arithmetic regime; the prime-free regime is safe — and
  is the one that has been proven (next section).

Summary: **the margin is thinnest for wide, low-frequency windows — test
functions whose spectral mass sits in the gap $(0,\gamma_1)$ below the first
zero — where Weil positivity is precisely the statement that the smoothed prime
sum saturates but never exceeds the pole + archimedean budget, to relative
accuracy $e^{-\sigma^2\gamma_1^2}$.** The first zero governs the sharpest
window; RH (all zeros real) governs all of them.

## 7. What is proven (Connes–Consani), and what a pair field could add

**Proven.** Weil (1952) established the criterion of Proposition W2 (for all
$L$-functions; Bombieri's Clay account gives the $\zeta$ normalization used
here). Connes–Consani, *Weil positivity and trace formula, the archimedean
place* (Selecta Math. 27 (2021), arXiv:2006.13771), prove: for
$g\in C_c^\infty(\mathbb R_+^*)$ **supported in $[2^{-1/2},2^{1/2}]$** with
$\widehat g$ vanishing at $0$ and $i/2$ (killing the pole terms),
$W_\infty(g\star\tilde g)\ \ge\ \operatorname{Tr}(\vartheta(g)\,\mathbf S\,
\vartheta(g)^*)\ \ge 0$: Weil positivity holds on this class. The support
condition puts $F=g\star\tilde g$ inside $(\frac12,2)$, so *no prime
contributes* — this is exactly our prime-free regime $\sigma\lesssim0.08$, but
their theorem covers **all** test functions there, not a Gaussian family: a
genuine uncertainty-principle statement (our panel-b margin $\mu=1$ is the
Gaussian shadow of it; adversarial $g$ can still weight the negative
archimedean well, which is why their proof needs the compression of the scaling
action onto Sonin space, prolate spheroidal wave functions, and Toeplitz-matrix
control). The program has continued through Connes–Moscovici (*The UV prolate
spectrum matches the zeros of zeta*, PNAS 119 (2022)),
Connes–Consani–Moscovici (*Zeta zeros and prolate wave operators*, Ann. Funct.
Anal. 15 (2024), arXiv:2310.18423), and the zeta-spectral-triple papers
(arXiv:2106.01715, arXiv:2511.22755): a semilocal prolate operator whose
positive spectrum realizes the low-lying zeros and whose negative part (Sonin
space) drives the positivity. Enlarging the support past $\sqrt2$ brings in the
place $2$, then $3,\dots$: each new place must be absorbed into the semilocal
trace formula — the difficulty grows exactly as our margin thins.

**Honestly, what the pair field adds and does not add.** It adds no theorem
toward RH. Proposition W3 is a *clarification*: it locates the reason the
framework's free positivity is silent — wrong tensor level (pair form vs.
diagonal), wrong sign (upper vs. lower bound), with the pole and archimedean
terms as the exact separating corrections — and Experiment 14 gives what appears
to be the first systematic *margin cartography* over a window family, exhibiting
the spectral gap $(0,\gamma_1)$ as the extremal window and the prime–pole
budget saturation at $e^{-\sigma^2\gamma_1^2}$ depth. Plausible contributions
from here: (i) the $S$-side mirror — by REPORT §6 the Weil form is a
Hermitian-square ($D$-side) functional, and its holomorphic ($S$-side) partner
is the Matsumoto–Suzuki screw-function positivity built from the *same*
secondary terms (exp12 tested its Krein kernel; the natural conjecture, still
open, is an exact dictionary between screw positivity and the Weil form's
diagonal); (ii) sharp quantitative versions of the uncertainty tradeoff of §6 —
"any window that resolves the gap must sample $\Lambda$ at $n=2$" — which is a
provable statement about Gaussian-type families and might be the right toy
lemma for what enlarging the Connes–Consani support really costs; (iii) the
margin map as a testbed: any proposed positivity mechanism must reproduce the
$\mu$-landscape of panel (d), and its hardest case is not "many zeros" but the
*absence* of zeros below $\gamma_1$.

**References.** A. Weil, *Sur les "formules explicites" de la théorie des
nombres premiers* (1952). E. Bombieri, *The Riemann Hypothesis* (Clay, 2000).
A. Connes, C. Consani, Selecta Math. 27 (2021),
[arXiv:2006.13771](https://arxiv.org/abs/2006.13771). A. Connes, H. Moscovici,
[PNAS 119 (2022)](https://www.pnas.org/doi/10.1073/pnas.2123174119).
A. Connes, C. Consani, H. Moscovici, Ann. Funct. Anal. 15 (2024),
[arXiv:2310.18423](https://arxiv.org/abs/2310.18423). K. Matsumoto, M. Suzuki,
arXiv:2409.00888 (J. Number Theory 2026); cf. `notes/SCREW`-material in
`code/exp12_screw.py`. Data: Odlyzko's tables (first 100,000 zeros, accurate to
$3\cdot10^{-9}$).

---

**Continuation (2026-08-11):** the finite Cohn–Elkies LP on this form, the
Hodge-index reformulation (the negativity that RH actually is, per ATIYAH §2/§4),
the measured inertia of the arithmetic intersection form $I=\mathrm{prime}-\mathrm{arch}$,
the per-prime-power cost of the certificate, and the interpolation-basis
conditioning are in `notes/LP_CERT.md` (`code/exp25_lp.py`).
