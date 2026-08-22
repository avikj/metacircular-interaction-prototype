# The divisor pair field: the exactly solvable analog

Companion to `REPORT.md` §7(a). Code: `code/exp15_divisor.py`; figure:
`figures/exp15_divisor.png`. Divisor function sieved to $2\cdot10^6$.

**Purpose.** Replace $\Lambda(n)$ by $d(n)=\sum_{e\mid n}1$ in the pair field
$K(w,\delta)=a_{w-\delta}a_{w+\delta}$. The tensor structure is identical
(rank-one, Prop. 1.1 applies verbatim), but every conjecture of the prime
program becomes a **theorem**, most of them a century old. This note assembles
the theorems with references, explains *why* this field is solvable, translates
each of our results (A, C, D, block decomposition) into the divisor model, and
ends with a one-page "dictionary of solvability" calibrating what a solution
of the prime pair field would structurally require.

---

## 1. Setup and the local object

Both marginals of the divisor pair field are governed by the single local
object

$$\sigma_{-1}(k)\;=\;\sum_{e\mid k}\frac1e\;=\;\frac{\sigma(k)}{k}
\;=\;\prod_{p^a\|k}\Bigl(1+\tfrac1p+\cdots+\tfrac1{p^a}\Bigr),$$

an Euler product over the primes dividing $k$ — the exact structural analog of
the Hardy–Littlewood singular series $\mathfrak S(k)$. The analogy is precise
at the level of Ramanujan sums: by Ramanujan's classical identity
[Ramanujan 1918]

$$\frac{6}{\pi^2}\,\sigma_{-1}(k)\;=\;\frac1{\zeta(2)}\,\frac{\sigma(k)}{k}
\;=\;\sum_{q=1}^{\infty}\frac{c_q(k)}{q^{2}},
\qquad\text{vs.}\qquad
\mathfrak S(k)=\sum_{q=1}^{\infty}\frac{\mu(q)^2}{\varphi(q)^2}\,c_q(k).$$

Same shape: a Ramanujan-sum expansion with square local weights — $1/q$ per
factor for $d$ (whose "sharp part" has Ramanujan coefficients of size $1/q$),
$\mu(q)/\varphi(q)$ per factor for $\Lambda$. This is the exp4 phenomenon
("one singular series, two marginals") one level down — where it is provable.

---

## 2. The difference marginal (shifted convolution): theorems

**Theorem (Ingham 1927).** For each fixed $h\ge1$,
$$D_h(X):=\sum_{n\le X} d(n)\,d(n+h)\;\sim\;\frac{6}{\pi^2}\,\sigma_{-1}(h)\,
X\log^2 X .$$

**Theorem (Estermann 1931; lower terms).** There is a quadratic polynomial
$P_2(t;h)=c_2(h)t^2+c_1(h)t+c_0(h)$ with
$$D_h(X)=X\,P_2(\log X;h)+E(X;h),\qquad
c_2(h)=\frac{6}{\pi^2}\sigma_{-1}(h),$$
where $c_1,c_0$ are linear combinations of $\sigma_{-1}(h)$ and
$\sigma_{-1}^{\log}(h):=\sum_{e\mid h}(\log e)/e$ with universal coefficients
built from $\gamma$ and $\zeta'(2)/\zeta(2)$ (explicit forms: Estermann 1931;
modern derivations with explicit constants in Motohashi 1994 §3 and
Topacogullari 2016), and $E(X;h)\ll X^{11/12+\varepsilon}$.

**Error-term history (the spectral ascent).**
- $X^{11/12+\varepsilon}$ — Estermann 1931, Kloosterman-refined circle method
  with elementary Kloosterman-sum bounds.
- $X^{5/6+\varepsilon}$, uniformly for $h\le X^{5/6}$ — Heath-Brown 1979
  (en route to the fourth moment of $\zeta$).
- $X^{2/3+\varepsilon}$ (fixed $h$) — **Deshouillers–Iwaniec 1982**, the first
  use of the Kuznetsov trace formula here: the Kloosterman sums are converted
  into the spectrum of the hyperbolic Laplacian, and the spectral gap of
  $SL(2,\mathbb Z)\backslash\mathbb H$ delivers the exponent.
- **Exact spectral resolution — Motohashi 1994** (announced in the language of
  Eisenstein series already by Vinogradov–Takhtajan 1984): $E(X;h)$ *is* an
  explicit spectral expansion
  $$E(X;h)\;=\;\sum_{j\ge1}\alpha_j\,t_j(h)\,H_j(\tfrac12)^2\,
  \Psi(\kappa_j;X,h)\;+\;(\text{Eisenstein integral})\;+\;(\text{small explicit terms}),$$
  over an orthonormal basis of Maass cusp forms $u_j$ for
  $SL(2,\mathbb Z)$ with Laplace eigenvalues $\lambda_j=\tfrac14+\kappa_j^2$,
  Hecke eigenvalues $t_j$, Hecke $L$-functions $H_j$,
  $\alpha_j=|\rho_j(1)|^2/\cosh(\pi\kappa_j)$; each discrete term oscillates
  like $X^{1/2+i\kappa_j}$. The continuous-spectrum (Eisenstein) term carries
  $|\zeta(\tfrac12+it)|^4$ — closing the circle with Ingham's *other* 1927
  theorem, $\int_0^T|\zeta(\tfrac12+it)|^4\,dt\sim T\log^4T/(2\pi^2)$, whose
  own exact spectral expansion (coefficients $\alpha_j H_j(\tfrac12)^3$) is
  Motohashi's fourth-moment formula (Motohashi 1997): the Hermitian square of
  a Hermitian square.
- Consequently the true size of $E(X;h)$ is $X^{1/2+o(1)}$ in mean square
  (Motohashi 1994; Ivić–Motohashi), and $E=\Omega(X^{1/2})$: the "RH-quality"
  square-root error is a *theorem* here.

The frequencies of the divisor field's difference marginal are the
$\kappa_j$ — real numbers, because $\Delta$ is self-adjoint. That single
sentence is the solvability of the model.

---

## 3. The sum marginal (Ingham's additive divisor theorem)

**Theorem (Ingham 1927).** As $N\to\infty$,
$$r(N):=\sum_{m+n=N} d(m)\,d(n)\;\sim\;\frac{6}{\pi^2}\,\sigma_{-1}(N)\,
N\log^2 N .$$

**Theorem (Estermann 1930).** With a full main term,
$r(N)=N\,Q_2(\log N;N)+O(N^{11/12+\varepsilon})$, where $Q_2$ is quadratic in
$\log N$ with leading coefficient $(6/\pi^2)\sigma_{-1}(N)$ and lower
coefficients again linear in $\sigma_{-1}(N),\sigma_{-1}^{\log}(N)$.
The Kloosterman-refined circle method is Estermann's engine here too; the
modern $\delta$-method treatment of the general quadratic divisor problem
$am\pm bn=h$ (Duke–Friedlander–Iwaniec 1994) gives power savings uniform in
the parameters, and the same Kuznetsov conversion applies.

**The key structural point.** The SAME local object $\sigma_{-1}$, with the
SAME normalization $(6/\pi^2)$, governs the sum marginal at $N$ and the
difference marginal at $h$ — exactly the "one local object, two transverse
marginals" configuration that exp4 verified *conjecturally* for
$\Lambda$ (Hardy–Littlewood $\mathfrak S$ governing both Goldbach and twins).
For the divisor field both statements have been theorems since 1927, in the
same paper. Ingham's paper is, in our language, the proven exp4.

---

## 4. Why the divisor field is solvable

Everything reduces to one fact: **$d(n)$ is an automorphic Fourier
coefficient; $\Lambda(n)$ is not.**

1. **Dirichlet series: which side of the fraction bar.**
   $\sum d(n)n^{-s}=\zeta(s)^2$; $\sum\Lambda(n)n^{-s}=-\zeta'/\zeta(s)$.
   For $d$, the zeros of $\zeta$ appear as *zeros* of the generating object —
   harmless. For $\Lambda$ they appear as *poles* — every zero is a
   singularity of the transform, and the singularities are exactly the
   unknowns. All analytic control of $d$-sums (functional equation, analytic
   continuation, truncated Voronoi expansions) is inherited from $\zeta^2$
   *without knowing anything about the zeros*.

2. **Voronoi summation (GL(2) harmonic analysis exists for $d$).**
   $d(n)$ is the $n$-th Fourier coefficient of the derivative at $s=1/2$ of
   the real-analytic Eisenstein series $E(z,s)$ for $SL(2,\mathbb Z)$.
   Hence the Voronoi summation formula (Voronoi 1904): for smooth $f$,
   $\sum_n d(n)e(na/c)f(n)$ = main term + dual sum over $d(m)$ with Bessel
   kernels and modular inverses $\bar a/c$. No such formula exists for
   $\Lambda$: a Voronoi formula for $\Lambda$ with power-saving control would
   encode the analytic continuation of $\sum\Lambda(n)e(n\alpha)n^{-s}$ past
   $\mathrm{Re}\,s=1$, i.e. GRH-type information.

3. **The hyperbola carries a group.** $d(n)$ counts lattice points on
   $uv=n$, i.e. $\Gamma_\infty$-classes of integer matrices of determinant
   $n$; the pair $d(n)d(n+h)$ counts solutions of the determinant equation
   $ad-bc=h$, which carries an $SL_2$ action. Poincaré-series unfolding turns
   $D_h$ into an inner product against an automorphic kernel; the Kuznetsov
   trace formula (Kuznetsov 1980; Deshouillers–Iwaniec 1982b) converts the
   resulting Kloosterman sums $S(m,n;c)$ into the Maass spectrum; Weil's
   bound $|S(m,n;c)|\le d(c)\sqrt{(m,n,c)}\sqrt c$ (Weil 1948) supplies the
   initial cancellation. The primes are the free generators of the
   multiplicative monoid — no group acts on them.

4. **The circle-method $\log$-barrier is absent.** For $\Lambda$, individual
   Goldbach requires beating Parseval by one factor of $\log$
   (`REPORT.md` Remark 1.2). For $d$, Kloosterman's refinement of the circle
   method (Kloosterman 1926) plus Weil cancellation turns *every* arc into a
   contributing arc with power savings — there are no minor arcs left, which
   is why even the *pointwise* statements (fixed $h$, fixed $N$: the "twin"
   and "Goldbach" analogs) are theorems with power-saving errors.

5. **The RH of the model is self-adjointness.** The frequencies
   $\tfrac12+i\kappa_j$ of the divisor field lie on the critical line
   *because $\Delta$ on $L^2(SL(2,\mathbb Z)\backslash\mathbb H)$ is
   self-adjoint and has no exceptional spectrum* ($\lambda_1=\tfrac14+
   \kappa_1^2\approx 91.14$, $\kappa_1\approx9.5337$ — Hejhal's tables;
   Selberg's $\lambda_1\ge\tfrac14$ conjecture is trivially true at level 1).
   The divisor field *has* its Hilbert–Pólya operator, and it is the
   hyperbolic Laplacian.

---

## 5. Our theorems, transported to the divisor model

**Theorem A (marginal rigidity) — holds verbatim, and is revealed as
arithmetic-free.** A is a statement about arbitrary nonnegative sequences;
nothing changes. The homometry kernel of the difference marginal and the
injectivity of the sum marginal are properties of the *projection*, not of
the weight. Status: **trivially inherited**. The analog of A′ (homometric
rigidity of the specific weight) is *uninteresting* for $d$: $d$ is far from
a 0-1 indicator and is already determined by trivial data.

**Theorem B (aperture law) — becomes empty, for an instructive reason.** The
one-variable transform $D(z)=\sum_n d(n)e^{-nz}$ (Lambert series) has Mellin
partner $\Gamma(s)\zeta(s)^2$, whose only singularities are on the real axis.
Wigert's classical expansion (Wigert 1916/17)
$$\sum_{n\ge1}d(n)e^{-nz}=\frac{\gamma-\log z}{z}+\frac14
-\sum_{k\ge0}\frac{1}{(2k+1)!}\Bigl(\frac{B_{2k+2}}{2k+2}\Bigr)^{2}z^{2k+1}
\quad(\text{asymptotic, } z\to0^+ \text{ in sectors})$$
has **no oscillatory layer at all**. The aperture opens onto an empty
spectrum: rotating $z=t+i\theta$ buys nothing because there are no
$z^{-\rho}$ terms to amplify. Consequence (a genuine structural disanalogy):
in the prime field the pair-level oscillations are *products of single-level
oscillations* (the spectrum is rank-one, inherited from $P(z)$); in the
divisor field the spectrum (Maass forms) **lives only at pair level** — it
appears in the shifted convolution and nowhere in the single-variable
transform. The solvable model's spectrum is intrinsically a correlation
phenomenon.

**Theorem C (smoothing trivialization) — trivializes completely, and the
mechanism is the sharpest entry of the dictionary.** For $\Lambda$,
$\Theta=\sup\mathrm{Re}\,\rho$ is unknown and Theorem C converts it into the
error exponent of the smoothed sum marginal (RH $\iff$ error
$O(t^{-3/2-\varepsilon})$). For $d$, the corresponding invariant is *known and
equals $-1$*: by Wigert, $E_d(t):=D(t)-(\gamma-\log t)/t-\tfrac14$ has a
complete asymptotic expansion beginning $-t/144$. There is nothing left to
detect, because $\zeta$ sits in the *numerator*: no poles off the real line,
no hidden exponent. **Provability of the smoothed field = which side of the
fraction bar $\zeta$ occupies.**

**Theorem D (sum-spectrum identity) — the analog is a theorem, with
$\gamma_j\mapsto\kappa_j$.** For
$G_1^d(X)=\sum_{m+n\le X}d(m)d(n)(X-m-n)$, double Mellin inversion gives a
smooth main term $X^3\times(\text{quadratic in }\log X)$ and **no zero-pair
layer** (again: no poles off the real axis). The oscillatory secondary
structure of divisor pair-data sits instead in the shifted convolutions and
is *exactly resolved* by the Maass spectrum (Motohashi's formula, §2): the
spectral lines of the divisor field are at the $\kappa_j$, they are
theorem-grade, and their weights ($\alpha_j t_j(h)H_j(1/2)^2$, decay in
$\kappa_j$ via $\Gamma$-factors in $\Psi$) are explicit — the precise analog
of our weight law D′. **What remains interesting** is the analog of D″: the
*variance* of divisor-field errors involves 4-tuple statistics
$\kappa_i\pm\kappa_j\approx\kappa_k\pm\kappa_l$ — the additive energy of the
Maass spectrum. The spacing statistics of $\{\kappa_j\}$ are conjecturally
Poisson (arithmetic quantum chaos: Sarnak; numerics: Hejhal, Steil) and this
is **open even in the solvable model**. The model solves everything at the
level of *marginal asymptotics* and then hits the same second wall as the
prime field: fine correlations of its own spectrum.

**Block decomposition (`BLOCKS.md`) — the $\sharp$ block is classical and the
mixed block is empty.** The Ramanujan/BC projection of $d$ is Ramanujan's own
exact expansion $d(n)=-\sum_{q\ge1}(\log q)/q\;c_q(n)$ (Ramanujan 1918,
suitably summed), and the $[\sharp\sharp]$ correlator calculus reproduces the
Ingham constant via $\sum_q c_q(h)/q^2=(6/\pi^2)\sigma_{-1}(h)$ (§1). The
$[\flat\flat]$ block carries the Maass/Eisenstein layer. The mixed block
$[\sharp\flat]$ — which for primes carried the single-zero oscillations
(first variation) — is **empty at all oscillatory frequencies**, because the
single-variable transform has no oscillatory layer (Theorem B analog). The
divisor field is "mean + second variation": a critical point of the
variational structure. Status: theorem-grade; numerically visible in exp15
as the absence of any intermediate-frequency layer between the smooth main
term and the pair-level error.

---

## 6. Numerics (exp15): every prediction verified, and it is proven

`code/exp15_divisor.py`, $d(n)$ sieved to $N=2\cdot10^6$
(`d[k::k]+=1`), marginals by FFT, $D_h(X)$ by direct cumulative sums.

> **Missing wrap guard (marked proposal — SEED-98, 2026-08-14, per SEED-27 §6
> item 3 and §9).** No transform length is stated here, so the reader cannot
> check the FFT marginals. The sum marginal is a self-convolution of a sequence
> supported in $[1,N]$, $N=2\cdot10^6$, hence supported up to $4\cdot10^6$; the
> difference marginal is a correlation and needs the same bound. The guard that
> must be stated is
> $$\text{FFT length}\;>\;2N-1=4\cdot10^6-1 .$$
> $2^{21}=2\,097\,152$ would wrap and corrupt the sum marginal;
> $2^{22}=4\,194\,304$ suffices. ~~This is **not applied as a fix** because the
> length actually used lives only in the (banned, legacy) `code/exp15_divisor.py`
> and cannot be verified here; it is a documentation defect, not a demonstrated
> error. Whoever knows the length should replace this block with the inequality.~~
>
> > **Decline discharged; the guard holds (seed126, 2026-08-14, Rule K3).**
> > SEED-98's reason has expired: the ban is on *writing, modifying or running*
> > Python, not on reading a legacy file as text, and the length is determinate
> > from the source without any execution. `code/exp15_divisor.py` line 45 sets
> > $N=2\,000\,000$ and calls `additive_convolution` / `autocorrelation` from
> > `code/pairfield.py`; both (lines 43–62) choose
> > $L=\min\{2^k : 2^k \ge 2n\}$ with $n=\texttt{len}(a)=N+1=2\,000\,001$. So
> > $2n=4\,000\,002$, $2^{21}=2\,097\,152<2n\le 2^{22}=4\,194\,304$, giving
> > $L=2^{22}$, and the linear convolution has length $2n-1=4\,000\,001\le L$.
> > **No wrap occurs, on either marginal.** The length is chosen adaptively, so
> > there is no literal to quote — which is why the earlier pass, reasoning
> > about "the length actually used", found nothing to check. The inequality
> > above is exactly the guard the code satisfies; it is now stated here, which
> > is what SEED-27 §6 item 3 asked for. Finite arithmetic, redone by hand.
> By SEED-27 Theorem 5 that inequality is the only thing making these numbers
> mean what they are said to mean — the ratio $2N/\text{length}$ bounds the
> number of colliding layers, never the mass that collides.
Figure: `figures/exp15_divisor.png`.

**(i) One local object, two marginals** (leading term only,
$X\log^2X$ / $N\log^2N$ normalization; sum marginal sampled at
$N\in[2\cdot10^5,2\cdot10^6]$, difference marginal at $h\le3000$,
$X=2\cdot10^6$):

| statistic | sum marginal | difference marginal |
|---|---|---|
| mean ratio to $(6/\pi^2)\sigma_{-1}\cdot$leading term | **1.0458** | **1.0520** |
| slope through origin vs $(6/\pi^2)\sigma_{-1}$ | 0.9921 | 1.0024 |
| corr of logs with $\sigma_{-1}$ | 0.9930 | 0.9945 |

Slope agreement between the two marginals: **1.0104**. In the scatter
(figure, panel 1) the two clouds coincide *pointwise*, including their common
deviation from the leading-order dashed line — that shared deviation is
Estermann's proven $O(1/\log X)$ polynomial tail, identical in structure for
both marginals, and it explains the mean-ratio offsets of $+5\%$ at
$\log X\approx14.5$. This is exp4's plot with the conjecture replaced by a
theorem.

**(ii) $\log^2X$ growth.** Fitting $D_h(X)/X=a_2\log^2X+a_1\log X+a_0$ over
$X\in[10^4,2\cdot10^6]$, for $h\in\{1,2,3,4,6,12\}$:
fitted $a_2/[(6/\pi^2)\sigma_{-1}(h)]=1.0008$–$1.0034$ (mean **1.0017**).
Free-exponent fit $D_h/X\propto\log^pX$ gives $p=1.83$–$2.02$ (contaminated
by the lower-order terms; the coefficient-level fit is the real test).
Sum marginal: global fit $r(N)/(N\sigma_{-1}(N))=b_2\log^2N+\dots$ returns
$b_2/(6/\pi^2)=$ **0.9998**.

**(iii) The error term.** Fixing $a_2$ at its proven value and fitting only
$a_1,a_0$, the residual $E(X;h)$ has windowed-RMS growth exponents
$\theta_h=0.57,\,0.62,\,0.69,\,0.69,\,0.76,\,0.84$ for
$h=1,2,3,4,6,12$ (mean **0.695**), with absolute size at $X=2\cdot10^6$
between $1.6\times$ and $21\times$ $X^{1/2}$ — i.e. of the order of the
classical envelopes ($X^{1/2}=1.4\cdot10^3$, $X^{2/3}=1.6\cdot10^4$), and far
below the pre-spectral bound $X^{11/12}\approx6\cdot10^5$. A spectral
diagnostic of $E(X;h)/\sqrt X$ against $\log X$ shows the residual power
concentrated at frequencies $\kappa<2$: at these heights the slow
(Eisenstein-continuum plus $\log$-power) layer dominates, and the discrete
Maass lines ($\kappa_1=9.53,\;12.17,\;13.78,\dots$) are not yet individually
resolvable — the $\log X$ window has length $\approx5.3$ (resolution
$\Delta\kappa\approx1.2$) but the first cusp-form amplitudes
$\alpha_jH_j(1/2)^2$ are small. The honest empirical summary: the error is
$X^{1/2+o(1)}$-to-$X^{2/3}$-sized, consistent with the proven
Deshouillers–Iwaniec envelope, with local exponents pushed above $1/2$ by the
continuum's logarithms over a finite range. Resolving individual $\kappa_j$
lines (the divisor analog of exp6b's $\gamma_i+\gamma_j$ lines) needs a much
longer $\log X$ baseline — a clean target for a follow-up at $X\sim10^{9}$
with a segmented sieve.

---

## 7. The dictionary of solvability

Calibration table: each prime-field object against its divisor-field
counterpart, with the honest gaps marked. "THM" = theorem, "OPEN" = open even
in the divisor model.

| prime pair field ($a_n=\Lambda(n)$) | divisor pair field ($a_n=d(n)$) | status on divisor side |
|---|---|---|
| generating series $-\zeta'/\zeta$: **zeros become poles** | $\zeta^2$: **zeros stay zeros** | THM — *the* mechanism of solvability |
| singular series $\mathfrak S(k)=\sum_q\frac{\mu(q)^2}{\varphi(q)^2}c_q(k)$ | $\frac{6}{\pi^2}\sigma_{-1}(k)=\sum_q\frac{c_q(k)}{q^2}$ | THM (identity, Ramanujan 1918) |
| twin/HL conjecture $\sum_{n\le X}\Lambda(n)\Lambda(n+h)\sim\mathfrak S(h)X$ | Ingham–Estermann $D_h(X)\sim\frac6{\pi^2}\sigma_{-1}(h)X\log^2X$ | THM (1927) |
| Goldbach average $\sum_{m+n=N}\Lambda\Lambda\sim\mathfrak S(N)N$ | Ingham $r(N)\sim\frac6{\pi^2}\sigma_{-1}(N)N\log^2N$ | THM (1927, same paper: one object, two marginals) |
| explicit formula (primes $\leftrightarrow$ zeros) | Voronoi summation + Kuznetsov trace formula (Kloosterman $\leftrightarrow$ Maass) | THM |
| zeta zeros $\tfrac12+i\gamma_j$ (location = RH, open) | Maass parameters $\tfrac12+i\kappa_j$, real | THM: $\Delta$ self-adjoint, $\lambda_1\approx91.14>\tfrac14$ |
| Hilbert–Pólya operator: conjectural | $\Delta$ on $L^2(SL(2,\mathbb Z)\backslash\mathbb H)$ | **exists** — RH-analog is self-adjointness + spectral gap |
| minor-arc $\log$-barrier (Remark 1.2) | dissolved by Kloosterman refinement + Weil + spectral gap | THM — pointwise statements provable, not just averages |
| error quality: $X^{1/2+\varepsilon}$ *under RH* | $E(X;h)\ll X^{2/3+\varepsilon}$ proven; $X^{1/2+o(1)}$ in mean square | THM (D–I 1982; Motohashi 1994) |
| Thm C: RH $\iff$ smoothed-marginal exponent | Wigert: complete expansion, invariant known ($=-1$), nothing to detect | trivialized |
| Thm D: pair lines at $\gamma_i+\gamma_j$ (under RH) | Motohashi's spectral expansion: lines at $\kappa_j$, explicit weights | THM — and intrinsically pair-level (no single-variable spectrum) |
| Thm D″: variance = additive energy of $\{\gamma_j\}$ | additive energy / 4-tuple statistics of $\{\kappa_j\}$; Poisson conjecture | **OPEN** — the solvable model's own second wall |
| pair correlation of zeros (Montgomery, GUE) | spacing statistics of $\{\kappa_j\}$ (arithmetic QUE; conjectured Poisson) | **OPEN** |
| parity sector / Möbius sign (Chowla; `PARITY.md`) | trivial: $d\ge1$, $d=\mathbf 1*\mathbf 1$ is "even" in the sieve-parity sense — no sign to lose | trivially absent ($\Lambda=-\mu*\log$ carries $\mu$ inside) |
| Thm A (marginal rigidity), homometry | identical — arithmetic-free | THM (verbatim, no content gained) |
| block decomposition $\sharp/\flat$ (`BLOCKS.md`) | $\sharp$ = Ramanujan's exact expansion of $d$; mixed block empty; $\flat\flat$ = Maass layer | THM-grade; "mean + second variation" only |
| uniformity in the shift $h$ growing with $X$ | known to $h\le X^{2/3}$-type ranges (Meurman; DFI $\delta$-method) | partial — technical gap |
| next weight up: $\Lambda$ (GL(1) log-derivative) | next weight up: $d_3$ — shifted convolution $\sum d_3(n)d_3(n+h)$ | **OPEN** — solvability is a GL(2) miracle; the wall reappears at GL(3) |

**What a solution of the prime pair field would structurally require.** The
divisor model isolates three sufficient ingredients, in order:

1. a **summation formula** for the weight (Voronoi analog) — i.e. an
   automorphic realization of $\Lambda$; this is the missing object, and its
   absence is not accidental: it would encode continuation of additively
   twisted $\Lambda$-series, GRH-adjacent information;
2. a **trace formula** converting the resulting exponential sums into a
   spectrum (Kuznetsov analog);
3. **self-adjointness + a spectral gap** for that spectrum (Selberg analog) —
   which *is* RH in the Hilbert–Pólya reading.

The divisor field shows this triple suffices and that nothing weaker seems to
be needed: with (1)–(3) one gets both marginals with power-saving errors,
pointwise in $h$ and $N$ — the full "twin + Goldbach" package. It also shows
what even a solution would *not* give: the fine correlations of the resulting
spectrum (Poisson/GUE questions, variance laws, D″) remain open one level up.
Solvability transports the frontier; it does not abolish it.

---

## 8. References

- S. Ramanujan, *On certain trigonometrical sums and their applications in
  the theory of numbers*, Trans. Cambridge Philos. Soc. **22** (1918), 259–276.
- H. D. Kloosterman, *On the representation of numbers in the form
  $ax^2+by^2+cz^2+dt^2$*, Acta Math. **49** (1926), 407–464.
- A. E. Ingham, *Some asymptotic formulae in the theory of numbers*,
  J. London Math. Soc. **2** (1927), 202–208. [Both marginals; also the
  fourth moment $\sim T\log^4T/(2\pi^2)$.]
- T. Estermann, *On the representations of a number as the sum of two
  products*, Proc. London Math. Soc. (2) **31** (1930), 123–133.
- T. Estermann, *Über die Darstellungen einer Zahl als Differenz von zwei
  Produkten*, J. Reine Angew. Math. **164** (1931), 173–182.
- S. Wigert, *Sur la série de Lambert et son application à la théorie des
  nombres*, Acta Math. **41** (1916), 197–218.
- A. Weil, *On some exponential sums*, Proc. Nat. Acad. Sci. USA **34**
  (1948), 204–207.
- D. R. Heath-Brown, *The fourth power moment of the Riemann zeta-function*,
  Proc. London Math. Soc. (3) **38** (1979), 385–422.
- N. V. Kuznetsov, *Petersson's conjecture for cusp forms of weight zero and
  Linnik's conjecture. Sums of Kloosterman sums*, Mat. Sb. **111** (1980),
  334–383.
- J.-M. Deshouillers, H. Iwaniec, *An additive divisor problem*, J. London
  Math. Soc. (2) **26** (1982), 1–14.
- J.-M. Deshouillers, H. Iwaniec, *Kloosterman sums and Fourier coefficients
  of cusp forms*, Invent. Math. **70** (1982), 219–288.
- A. I. Vinogradov, L. A. Takhtajan, *The zeta function of the additive
  divisor problem and the spectral decomposition of the automorphic
  Laplacian*, Zap. Nauchn. Sem. LOMI **134** (1984), 84–116.
- Y. Motohashi, *The binary additive divisor problem*, Ann. Sci. École Norm.
  Sup. (4) **27** (1994), 529–572.
- Y. Motohashi, *Spectral Theory of the Riemann Zeta-Function*, Cambridge
  Tracts in Math. **127**, CUP, 1997.
- W. Duke, J. Friedlander, H. Iwaniec, *A quadratic divisor problem*,
  Invent. Math. **115** (1994), 209–217.
- T. Meurman, *On the binary additive divisor problem*, in: Number Theory
  (Turku, 1999), de Gruyter, 2001, 223–246. [Uniformity in $h$.]
- B. Topacogullari, *The shifted convolution of divisor functions*,
  Q. J. Math. **67** (2016), 331–363. [Explicit lower-order terms.]
- D. Hejhal, *The Selberg Trace Formula for $PSL(2,\mathbb R)$*, vol. 2,
  Springer LNM 1001, 1983. [Maass eigenvalue numerics, $\kappa_1\approx
  9.5337$.]
- P. Sarnak, *Arithmetic quantum chaos*, Israel Math. Conf. Proc. 8 (1995),
  183–236. [Poisson conjecture for the Maass spectrum.]
