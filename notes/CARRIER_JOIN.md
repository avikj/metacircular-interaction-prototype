# The carrier join: RH as one-point positivity of the finite pair carrier, the Theorem-J transport, and the surface/bulk split

**Task:** cross-branch JOIN — sharpest equivalence between RH/GRH and positivity of the
product-weighted pair object carried by an explicit arithmetic sum
(`PRODUCT_CARRIER.md` × `BLOCKS.md` §5 × `BARRIER.md`/`HOLOGRAM.md`).
**Code:** `code/exp56_carrier_join.py` → `figures/exp56_carrier_join.png`; full printed
output archived at `data/exp56_out.txt`. Every number quoted below is printed by that
script (numpy/scipy/mpmath only; runtime ~100 s; zeros from
`data/odlyzko_zeros_100k.txt` and `data/chi3_zeros_ext.npy`; Λ sieved to $2\cdot10^6$).

**Status: PENDING HOSTILE AUDIT.** Grades are stated per item. Cross-branch citations
use full stems only (`EXP_LEDGER.md` convention). Nothing in this note edits or
supersedes an existing note; where a statement sharpens an earlier one, the earlier
grading is quoted and the delta is stated.

---

## 0. Objects and conventions

$\rho=\beta+i\gamma$ runs over the nontrivial zeros of $\zeta$ (distinct zeros, each
with multiplicity $m_\rho\ge1$; $\gamma$ signed). Unconditionally define

$$H_1(X)\;=\;\sum_\rho \frac{m_\rho\,X^{\rho-1/2}}{\rho(1-\rho)}
\qquad(\text{absolutely convergent: } |\rho(1-\rho)|\ge\gamma^2,\ |\gamma_1|>14),$$

$$B=2+\gamma_E-\log4\pi=0.0461914\ldots=H_1(1),\qquad
a(\gamma)=\frac{m_\rho}{\gamma^2+\tfrac14}\Big|_{\rm RH}>0,$$

$$S(X)=\sum_{n\le X}\Lambda(n)\,\frac{X-n}{n},\qquad
T(X,Y)=\sum_{m\le X,\,n\le Y}\Lambda(m)\Lambda(n)\frac{(X-m)(Y-n)}{mn}=S(X)S(Y),$$

$$\widetilde M(X)=X\log X-(1+\gamma_E)X+\log2\pi+\delta(X),\qquad
\delta(X)=-\tfrac12\sum_{k\ge1}\frac{X^{-2k}}{k(2k+1)},$$

with $\delta(1)=\log2-1$ (the trivial-zero tail of `PRODUCT_CARRIER.md` Prop. C1 in
series form; series vs. quadrature agree to $\le1.8\cdot10^{-15}$, Part 0). Under RH,
$H_1(e^t)=h(t)=2\sum_{\gamma>0}a(\gamma)\cos\gamma t$, and the target measure is
$\nu=\sum_{\gamma,\gamma'}a(\gamma)a(\gamma')\delta_{\gamma+\gamma'}\ge0$
(`SCREW.md` §4.1, `PRODUCT.md`, `PRODUCT_CARRIER.md`).

**Lemma 0 (exact carrier ledger; unconditional).** For every real $X\ge1$,

$$S(X)-\widetilde M(X)\;=\;\sqrt X\,H_1(X)\qquad\textbf{exactly},$$

and in particular $\widetilde M(1)=-B$ (numerically $-0.046191417932$, diff
$1.1\cdot10^{-16}$), so equality $|H_1|=B$ holds at $X=1$.

*Proof.* `PRODUCT_CARRIER.md` Prop. C1 with the trivial-zero tail written as the
displayed series ($\log(1-t^{-2})=-\sum_k t^{-2k}/k$ integrated termwise). Both sides
are continuous in $X$ (the kernel $(X-n)/n$ vanishes at $n=X$; the zero sum converges
absolutely and uniformly), so the a.e. identity of the explicit formula holds for every
$X$. $\square$ Grade: **proved** (imports only the truncated von Mangoldt formula, as
C1 did).

Two remarks worth their space. (i) There is **no error term at all** — contrast MS
(1.6), whose arithmetic side needs $c_2+E(X)$, and `PRODUCT.md` Theorem P1, whose
arithmetic form needs an $N\to\infty$ compensator. (ii) On $1\le X<2$ the prime sum is
empty, so Lemma 0 degenerates to the pure zero-sum evaluation
$H_1(X)=-\widetilde M(X)/\sqrt X$ — an identity containing *no arithmetic data*,
which the numerics reproduce at the $9\cdot10^{-7}$ floor (Part 1, small grid). This
anchors the sharpness of everything below.

---

## 1. Task (a): the one-point Krein reduction, in full

### 1.1 The statement

**Theorem A (one-point reduction; the equivalence).** The following are equivalent.

1. **(RH)** Every nontrivial zero of $\zeta$ has $\beta=\tfrac12$.
2. **(Screw axiom / full Krein positivity of the pair object)** The even function
   $g_2(t)=H_1(e^{|t|})^2-B^2$ is a screw function: for every finite grid
   $\{t_i\}\subset\mathbb R$ and $\{\xi_i\}\subset\mathbb C$,
   $\sum_{i,j}G_{g_2}(t_i,t_j)\,\xi_i\bar\xi_j\ge0$, where
   $G_g(t,u)=g(t-u)-g(t)-g(-u)+g(0)$.
3. **(One-point positivity, two-sided)** $|H_1(X)|\le B$ for all $X\ge1$.
4. **(One-point positivity, one-sided)** $H_1(X)\le B$ for all $X\ge1$.
5. **(Finite-data pair form)** For all $X\ge1$:
   $\;T(X,X)-2\widetilde M(X)\,S(X)+\widetilde M(X)^2\;\le\;B^2X$.
6. **(Finite-data one-sided form)** For all $X\ge1$:
   $\;S(X)\;\le\;\widetilde M(X)+B\sqrt X$.

Equality in (3)/(5) holds at $X=1$ (Lemma 0), so the constant $B$ is sharp; any
equality point $X>1$ would force simultaneous rational relations
$\gamma_i/\gamma_j\in\mathbb Q$ among *all* ordinates (unknown; not needed).

**What "positivity of the carrier object" means as a statement about finite data.**
Three equivalent readings, in decreasing generality:

- *(quadratic form on test vectors)* PSD of every finite section
  $[G_{g_2}(t_i,t_j)]_{i,j}$ — item (2). Each entry is computable from primes
  $\le e^{\max|t_i-t_j|}$ by Lemma 0: **no limit of kernels is involved**; the
  truncation in "truncated Krein kernel" below refers to the sampling grid and to the
  zero list of the *model*, never to the arithmetic side.
- *(one inequality per $X$)* the $1\times1$ minors, item (5): a single scalar
  inequality about the finite double prime sum $T(X,X)$ against its closed-form
  companion. This is the entire content: **the full quadratic-form positivity is
  equivalent to its own diagonal** (the "rank collapse", §1.3).
- *(one-sided Chebyshev-type inequality)* item (6): drop the square entirely.

### 1.2 Proof of Theorem A

$(1)\Rightarrow(2)$: under RH the masses $a(\gamma)$ are positive outright, so
$\mu_1=\sum a(\gamma)\delta_\gamma\ge0$ and $\nu=\mu_1*\mu_1\ge0$ with
$\nu(\mathbb R)=B^2$; $g_2(t)=\int(e^{i\omega t}-1)\,d\nu(\omega)$ and
$\sum G_{g_2}(t_i,t_j)\xi_i\bar\xi_j=\int|\sum_i(e^{i\omega t_i}-1)\xi_i|^2d\nu\ge0$
— the Hermitian-square identity over the sum spectrum (`PRODUCT_CARRIER.md` C3,
`PRODUCT.md` P3; elementary).

$(2)\Rightarrow(3)$: take the $1\times1$ minor at $\{t\}$:
$G_{g_2}(t,t)=2g_2(0)-2g_2(t)=-2g_2(t)\ge0$, i.e. $H_1(e^{|t|})^2\le B^2$.

$(3)\Rightarrow(4)$: trivial.

$(4)\Rightarrow(1)$: **Lemma B′ below** (this was the direction that previously
rested on the quoted Matsumoto–Suzuki extraction; see §1.4).

$(3)\Leftrightarrow(5)$ and $(4)\Leftrightarrow(6)$: by Lemma 0,
$(S-\widetilde M)^2=X H_1(X)^2$ and $T(X,X)=S(X)^2$
(`PRODUCT_CARRIER.md` C2: the kernel is separable), so (5) is literally
$H_1(X)^2\le B^2$ and (6) is $H_1(X)\le B$. Restriction to $X\ge1$ loses nothing:
the multiset $\{\rho\}$ is invariant under $\rho\mapsto1-\rho$ (functional equation),
so $H_1(e^{-t})=H_1(e^t)$ unconditionally and half-line data determines the line.
$\square$

### 1.3 The rank collapse, stated as the result it is

$(2)\Leftrightarrow(3)$ says: for this kernel, PSD of all finite sections is
equivalent to nonnegativity of the diagonal. That is the precise, now *proved*, form
of the honest assessment in `PRODUCT_CARRIER.md` §4 ("the converse factors through
the one-body bound") and of `SCREW.md` §4.3 ("RH content is saturated at first
order"): the pair measure $\nu$ carries **no RH content beyond the one-body bound**,
not merely "none that our proof used". Structural reason: $g_2$ is a Krein transform
of a *convolution square*; its diagonal defect $-2g_2(t)=2(B^2-H_1(e^t)^2)$ already
contains the full boundedness statement, and boundedness alone kills off-line zeros
(Lemma B). The hologram reading of this collapse is §4.

### 1.4 Lemma B: boundedness forces the line — proved in-repo

The repo-wide caveat (`CROSSREVIEW_THMJ.md` §7, `PRODUCT_CARRIER.md` C3,
`TWISTED_CARRIER.md` §7) was that every screw⟺RH converse quoted [MS Cor. 3.1] from
the `SCREW.md` HTML extraction of arXiv:2409.00888, a single point of failure
(egress-blocked full text). The following two lemmas replace that import with
classical, textbook-verifiable inputs. Technique: Laplace transforms; Landau's
nonnegativity theorem for the one-sided version. **We make no novelty claim for the
technique** — this is Landau-type oscillation machinery — the point is that the
converse of Theorem A now has a complete in-repo proof.

**Setting.** Let $Z$ be a multiset of complex numbers $\rho=\beta+i\gamma$,
$0<\beta<1$, with: (Z1) discreteness (finitely many in any bounded region);
(Z2) closure under $\rho\mapsto1-\rho$; (Z3) $\sum_{\rho}m_\rho|\rho(1-\rho)|^{-1}
<\infty$; (Z4) no real elements ($\gamma\neq0$ throughout). Set
$\lambda_\rho=\rho-\tfrac12$, $c_\rho=m_\rho/(\rho(1-\rho))\ne0$, and
$H(t)=\sum_\rho c_\rho e^{\lambda_\rho t}$ (locally uniformly absolutely convergent
by (Z3), continuous). The zeta string satisfies (Z1)–(Z4) (no real zeros in $(0,1)$;
$|\gamma_1|=14.13$); so does the $L(s,\chi_3)$ string ($|\gamma_1|=8.04$; no real
zeros in $(0,1)$, `TWISTED_CARRIER.md` T1).

**Lemma B (two-sided).** If $\sup_{t\ge0}|H(t)|<\infty$, then $\beta\le\tfrac12$
for all $\rho\in Z$; with (Z2), $\beta=\tfrac12$ for all.

*Proof.* Let $C=\sup_{t\ge0}|H|$. The Laplace transform
$L(s)=\int_0^\infty H(t)e^{-st}\,dt$ is holomorphic on $\{\operatorname{Re}s>0\}$
with $|L(s)|\le C/\operatorname{Re}s$ (Morera + dominated convergence, standard).
For $\operatorname{Re}s>\tfrac12$, Tonelli applies
($\sum_\rho|c_\rho|\int_0^\infty e^{(1/2-\operatorname{Re}s)t}dt
=\frac{\sum|c_\rho|}{\operatorname{Re}s-1/2}<\infty$ since
$\operatorname{Re}\lambda_\rho\le\tfrac12$), giving
$L(s)=F(s):=\sum_\rho c_\rho/(s-\lambda_\rho)$ there. By (Z1) the set
$\Lambda=\{\lambda_\rho\}$ is closed and discrete; on any compact set at distance
$d>0$ from $\Lambda$ the series $F$ is dominated by $\sum|c_\rho|/d$, so $F$ is
holomorphic on $\mathbb C\setminus\Lambda$, and near an individual
$\lambda_0\in\Lambda$ it has a simple pole with residue $c_{\lambda_0}\ne0$ (the map
$\rho\mapsto\lambda_\rho$ is injective, so no cancellation between distinct zeros).
Now suppose some $\rho_0$ has $\beta_0>\tfrac12$, i.e.
$\lambda_0=\lambda_{\rho_0}$ has $\operatorname{Re}\lambda_0>0$. The set
$D=\{\operatorname{Re}s>0\}\setminus\Lambda$ is a domain (a half-plane minus a
discrete closed set is connected), $L$ and $F$ are holomorphic on $D$ and agree on
the sub-domain $\{\operatorname{Re}s>\tfrac12\}\setminus\Lambda$, hence on all of
$D$ (identity theorem). But then
$\lim_{s\to\lambda_0}(s-\lambda_0)L(s)=0$ (L is holomorphic at $\lambda_0$, which
lies in $\{\operatorname{Re}s>0\}$) while the same limit of $F$ is
$c_{\lambda_0}\ne0$ — contradiction. So $\beta\le\tfrac12$ for all $\rho$, and (Z2)
forces $\beta=\tfrac12$. $\square$

**Lemma B′ (one-sided).** If $H(t)\le C<\infty$ for all $t\ge0$, the same conclusion
holds.

*Proof.* $u(t):=C-H(t)\ge0$ is continuous with
$u(t)\le C+\big(\sum|c_\rho|\big)e^{t/2}$, so its Laplace transform $\widehat u$ has
abscissa of convergence $\sigma_c\le\tfrac12$, and on
$\operatorname{Re}s>\tfrac12$, $\widehat u(s)=C/s-F(s)$ as in Lemma B. By (Z4) no
$\lambda_\rho$ is real, so $C/s-F(s)$ is holomorphic at every point of the positive
real axis. If $\sigma_c>0$, Landau's theorem for Laplace transforms of nonnegative
functions (the real point of the abscissa of convergence is a singular point of
$\widehat u$; Widder, *The Laplace Transform*, Thm II.5b) is contradicted, because
$C/s-F$ furnishes an analytic continuation of $\widehat u$ to a neighborhood of
$\sigma_c$. Hence $\sigma_c\le0$ and $\widehat u$ is holomorphic on
$\{\operatorname{Re}s>0\}$; by the identity theorem on the domain $D$ of Lemma B,
$\widehat u=C/s-F$ on $D$, and the pole of $F$ at any $\lambda_0$ with
$\operatorname{Re}\lambda_0>0$ again contradicts holomorphy of $\widehat u$ there.
$\square$

**Answer to the task's question "which direction is a theorem today, and which needs
a new lemma".** As the notes stood: RH $\Rightarrow$ positivity was **proved**
(Hermitian square; needs nothing beyond $a(\gamma)>0$ under RH); positivity
$\Rightarrow$ RH was **proved modulo the quoted MS ingredient** — [MS Cor. 3.1 and
the proof of Thm 1.3] in the `SCREW.md` extraction, exactly as
`PRODUCT_CARRIER.md` C3 and `TWISTED_CARRIER.md` T3 graded it. The new lemma that
was needed is precisely Lemmas B/B′, supplied above. After them, **both directions
of Theorem A are proved in-repo**, with imports limited to: the truncated explicit
formula for $\psi$ (via Lemma 0), Fubini–Tonelli/Morera, the identity theorem, and
(for B′ only) Landau's theorem. The MS full-text check (`INDEX_IA.md` open interface
2) is thereby downgraded from *mathematical* single point of failure to an
*attribution* check: MS Theorem 1.3 remains the prior statement of the
$g_{H_1}$-level equivalence, and this note's Theorem A should be read as its
finite-carrier packaging plus an independent proof of the converse. (Honesty:
one-sided Landau criteria for RH-type statements are classical in spirit; we claim
the *assembly*, not the components.)

**Theorem A′ ($\chi_3$; per-character GRH).** With
$S_\chi,\;c_1X+c_0+\delta_\chi(X),\;B_\chi=0.113229969857$ as in
`TWISTED_CARRIER.md` T1, the same six-way equivalence holds verbatim for
GRH($\chi_3$), with sharp equality at $X=1$
($c_1+c_0+B_\chi+\delta_\chi(1)=0$ with $\delta_\chi(1)=-\log2$; printed
$+0.000\cdot10^{0}$ in Part 0). Proof identical: the $L$-string satisfies (Z1)–(Z4),
and Lemma 0's analogue is T1 (poleless, so the companion is linear-plus-constant).
Grade: **proved** (same imports; the $\Gamma$-closed forms of $c_0$ and the ledger
value of $L'/L(1,\chi_3)$ are verified against an independent central-difference
computation through the cancelling Hurwitz poles to $1.0\cdot10^{-18}$, Part 0).

---

## 2. Task (b): is the canonical subtraction of Theorem J the carrier's subtraction?

**The open item being addressed** (`BLOCKS.md` §5, `CROSSREVIEW_THMJ.md` §6): after
the retraction of the exact block identity, Theorem J survives as a *band-passed*
identification of the mixed block's fluctuation with the MS screw line; the open
item was "a canonical smooth subtraction upgrading the band-passed identification to
an exact statement", and `exp27_running` showed no such subtraction exists *at block
level at fixed $Q$* (constants run in $\log^2Q$).

**Answer: the two subtraction problems have the same canonical subtraction — the
carrier's $\widetilde M$, transported — and it achieves everything a subtraction can
achieve; but "exact" is impossible on the Goldbach side for a structural reason, and
the obstruction is precisely the second-variation (Beta pair) sector.** Formally:

**Proposition E (the transport; conditional).** Let
$T_G(X)=\sum_{n\le X}(\Lambda*\Lambda)(n)/n^2$. Assume RH and the quoted remainder
bound for Fujii's formula, $R(X)\ll X\log^3X$ (Languasco–Zaccagnini; Goldston–Yang;
as recorded in `SCREW.md` §1 from [MS (1.2)]). Then there is a constant $c_2$ with

$$T_G(X)\;=\;\log X\;+\;c_2\;+\;\frac{2}{\sqrt X}\,H_1(X)\;+\;E(X),
\qquad E(X)\ll X^{-1}\log^3X,$$

and by Lemma 0 the zero sum is eliminable in favor of prime data:

$$c_2(X):=T_G(X)-\log X-\frac{2}{X}\bigl(S(X)-\widetilde M(X)\bigr)
\;=\;c_2+O\!\bigl(X^{-1}\log^3X\bigr).$$

*Proof.* Stieltjes: $T_G(X)=\int_{1^-}^X y^{-2}\,d\Sigma(y)$,
$\Sigma(y)=\sum_{n\le y}G(n)=\tfrac{y^2}2+\Phi(y)+R(y)$ with
$\Phi(y)=-2\sum_\rho y^{\rho+1}/(\rho(\rho+1))$ (absolutely convergent,
$|\rho(\rho+1)|\ge\gamma^2$). The main term gives
$\int_1^X y^{-1}dy=\log X$. For the zero layer integrate by parts —
$\int_1^Xy^{-2}d\Phi=\Phi(X)X^{-2}-\Phi(1)+2\int_1^X\Phi(y)y^{-3}dy$ — and expand
the *integral* termwise (absolutely convergent, Fubini):
$\int_1^X y^{\rho-2}dy=(X^{\rho-1}-1)/(\rho-1)$; collecting,
$$\frac1{\rho(\rho+1)}+\frac{2}{(\rho-1)\rho(\rho+1)}
=\frac{1}{\rho(\rho-1)}=-\frac{1}{\rho(1-\rho)},$$
so the zero layer contributes $2X^{-1/2}H_1(X)+\text{const}$ — the same
symmetrization $\rho(\rho+1)\to\rho(1-\rho)$ that `CROSSREVIEW_THMJ.md` Prop. R1
derived and Prop. R2 proved unique ($n^{-2}$ is the only Krein gauge), obtained here
without differentiating a conditionally convergent series. For the remainder,
$\int_1^Xy^{-2}dR=R(X)X^{-2}-R(1)+2\int_1^XRy^{-3}dy$; the integral converges as
$X\to\infty$ by the quoted bound, leaving a constant plus
$O(X^{-1}\log^3X)$. Collect all constants into $c_2$. $\square$

Grade: **proved modulo the quoted $R$-bound** (which is under RH and imported at the
same trust level as `SCREW.md` §1's ledger — flag inherited). Numerically (Part 5,
primes only, no zeros anywhere in the pipeline):

```
  c2(X) = T_G(X) - log X - 2 q(X)/sqrt(X)
    X in [1e+04,1e+05): mean = -2.28017   std = 9.76e-05
    X in [1e+05,1e+06): mean = -2.28030   std = 1.01e-05
    X in [1e+06,2e+06): mean = -2.28031   std = 8.02e-07
  c2_hat = -2.28031
      window                RMS(E)       RMS(E) * Xmid
    [   1e+04,   4e+04)    8.967e-05       1.793
    [   4e+04,   2e+05)    2.208e-05       1.767
    [   2e+05,   6e+05)    5.599e-06       1.792
    [   6e+05,   2e+06)    1.362e-06       1.502
  log-log decay fit of |E|: slope = -1.22
```

$c_2=-2.28031$ agrees with the corrected `exp23_screwjoin`/`exp27_running`
total-field invariant ($-2.2803$, `BLOCKS.md` §5) and `SCREW.md` Part 5's fit
($-2.280$) — obtained here with **no fit and no band-pass**, from prime data plus
closed-form constants. The remainder envelope is measured at
$\mathrm{RMS}(E)\approx1.7/X$ (slope $-1.22$ vs the predicted $-1$ up to $\log^3$).
The identification is *pointwise* and sharpens at the predicted $X^{-1/2}$ relative
rate (no band-pass; per-window):

```
      window                corr      RMS ratio   RMS(E)/RMS(2q/sqrt X)
    [   3e+03,   1e+04)     0.7388      1.6653     1.146
    [   1e+04,   1e+05)     0.8000      1.4515     0.886
    [   1e+05,   5e+05)     0.9742      1.0604     0.242
    [   5e+05,   2e+06)     0.9944      1.0062     0.106
```

**Proposition F (no-go for an exact Theorem J; the characterization).** There is no
subtraction $\sigma$ with $\sigma(e^t)$ free of nonzero log-frequency content (i.e.
every Bohr–Fourier coefficient at $\omega\neq0$ vanishes — the defining property of
a "smooth subtraction"; all candidates ever proposed, $X^a\log^bX$ spans, block
constants, Mertens floors, are of this class) such that
$T_G(X)-\sigma(X)=2X^{-1/2}H_1(X)$ identically. The obstruction is the
second-variation sector: by Prop. E the defect $X\cdot E(X)$ carries the
$n^{-2}$-reweighted Beta pair layer — termwise, lines at every
$\omega=\gamma+\gamma'$ (and mixed-sign $\gamma-\gamma'$) with coefficients
$\frac{s}{s-2}\,\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+1)\neq0$,
$s=\rho+\rho'$ (the `exp30_screwjoin` §4.3 $[\flat\flat]$ model, identified there at
corr 0.990) — and a Bohr coefficient at $\omega\ne0$ is blind to $\sigma$. Grade:
**proved at termwise level**; the interchange needed to make the Bohr extraction
fully rigorous is the standard-but-unfinished $k=0$ bookkeeping (the pair sum at
$k=0$ converges conditionally, the caveat `CROSSREVIEW_THMJ.md` §7 already records).
Measured (Part 5): Hann amplitudes of $X\cdot E(X)$ at
$\gamma_1,\,2\gamma_1,\,\gamma_1{+}\gamma_2,\,\gamma_2{-}\gamma_1$
$=2.5\cdot10^{-2},\,1.8\cdot10^{-2},\,3.4\cdot10^{-2},\,3.0\cdot10^{-2}$ — sum
*and* difference lines, plus single-frequency cross content, all $O(1)$ in the
$X$-normalized defect: the pair sector is *there* and is not small.

**Verdict on task (b).** The subtraction that makes the carrier identification exact
and the subtraction that Theorem J admits are **the same object** — $\widetilde M$,
transported through the $n^{-2}$ ladder — *up to exactly one constant, $c_2$, which
is the only subtraction freedom the Goldbach side has left and which is not (yet) in
closed form.* The difference between the two subtraction *problems* is not a
different subtraction; it is a different residual algebra:

| | carrier side $S$ | Goldbach side $T_G$ |
|---|---|---|
| explicit-formula layers | 3 (smooth, trivial, single-zero) | 4 (+ Beta pair layer) |
| exact identity after subtraction | **yes** (Lemma 0, zero error) | **impossible** (Prop. F) |
| why | rank-one square; separable kernel | kernel of $m+n$ ⟹ Beta coupling forced (`PRODUCT_WEIGHT_NO_GO.md` Thm 2.1) |
| residual | $\sqrt X H_1(X)$, one oscillatory layer | $2X^{-1/2}H_1 + E$, $E\asymp X^{-1}$ carrying $\nu$'s Beta-phased cousin |

This *closes the open item by reclassification*, consistently with
`exp27_running`'s block-level finding: at block level, no canonical subtraction (the
scheme runs); at total-field level, the canonical subtraction exists, is the
carrier's, is $Q$-free, and upgrades "band-passed identification" to "pointwise
identification with one constant and an explicitly-sized remainder"; "exact" was
never available on the Goldbach side, and now it is a proposition rather than an
aspiration. The `INDEX_IA.md` open-interface-1 suggestion (Mertens floor law as the
canonical split) is thereby answered: the Mertens content is a $Q$-scheme artifact;
the canonical split needs no $Q$ at all.

---

## 3. Task (c): exp56 numerics

All output in `data/exp56_out.txt`; excerpts quoted. Conventions: grid of 8192
log-uniform $X\in[3\cdot10^3,1.9\cdot10^6]$ plus 3000 points in $[1.02,3\cdot10^3]$;
$q=(S-\widetilde M)/\sqrt X$ per `exp31_product_carrier.py` (with $\delta(X)$
included in the companion, so the identity is exact); sieve to $2\cdot10^6$ (task
convention; `exp31_product_carrier` used $4\cdot10^6$); zero side = all $10^5$
Odlyzko ordinates. **No fitted parameters anywhere.**

### 3.0 Identity floor (Part 1)

corr$(q,h)=1.000000000$; RMS ratio $1.0000000$; $\max|q-h|=4.5\cdot10^{-7}$
(main grid; the exp31 protocol at $4\cdot10^6$/30k zeros gave $1.5\cdot10^{-6}$ —
the improvement is the 100k-zero model). Small grid $[1.02,3\cdot10^3]$:
$\max|q-h|=9.0\cdot10^{-7}$, including the prime-free window $[1.02,2)$.

### 3.1 (c)(ii) one-point positivity margin from primes alone (Part 1)

```
  ONE-POINT CRITERION  B^2 X - (S - Mt)^2 >= 0  on 11192 grid points in [1.02, 1.9e6]:
    holds everywhere: True;   min defect = 1.619e-03 at X = 319433.030
    global max |q|/B = 0.4910 at X = 319433.0
      window                max q/B    min q/B   min (B^2-q^2)/B^2
      [    1.02,      10)    +0.4553    -0.4522     0.7927
      [   10.00,     100)    +0.3552    -0.3681     0.8645
      [  100.00,    1000)    +0.3934    -0.4180     0.8253
      [ 1000.00,   10000)    +0.4042    -0.3438     0.8366
      [10000.00,  100000)    +0.3580    -0.3774     0.8576
      [100000.00, 1000000)    +0.3923    -0.4910     0.7589
      [1000000.00, 1900000)    +0.2850    -0.3554     0.8737
```

The RH-equivalent inequality holds with relative margin $\ge0.7589$ on every audited
decade; the closest approach to the wall over six decades is $|q|/B=0.4910$. (The
margin is exactly $0$ at $X=1$ by construction — the criterion is sharp, not slack.)
Pair layer (Part 2): mean$(P)=$ mean$(h^2)=7.5002\cdot10^{-5}$ vs
$m_0=7.4201\cdot10^{-5}$ (window leakage equal in data and model, as in
`exp31_product_carrier`); band $[28,60]$: corr$(P,h^2)=1.000000$ ratio $1.000000$;
corr vs the binned-$\nu$ line model $=0.999972$, ratio $0.997829$, 34284 lines all
positive — the exp31 pair identity replicated at the $2\cdot10^6$ sieve.

### 3.2 (c)(i) smallest eigenvalue of the truncated product-weighted Krein kernel (Part 3)

Three truncation axes for $G_{g_2}$ ($g_2=h^2-h(0)^2$ model side;
$g_2=q(e^{|t|})^2-B^2$ arithmetic side — **primes only**):

```
  (a) grid refinement, T = 7 (arithmetic reach: differences |t|<=2T, e^{2T}=1.2e6<=2e6)
      n     model lam_min   model ratio     arith lam_min   arith ratio
       10   +1.656e-03    +6.836e-02    +1.660e-03    +6.840e-02
       20   +1.581e-03    +3.758e-02    +1.586e-03    +3.760e-02
       40   +1.375e-03    +1.661e-02    +1.379e-03    +1.663e-02
       80   +9.906e-04    +5.792e-03    +9.947e-04    +5.805e-03
      160   +1.045e-03    +3.154e-03    +1.049e-03    +3.160e-03
      320   +8.547e-04    +1.294e-03    +8.587e-04    +1.298e-03
  (b) radius growth (n = 8T), model:  T=5: +1.362e-03 ... T=40: +8.462e-04
  (c) zero-count truncation (T=14, n=160): K = 100 / 1e3 / 1e4 / 1e5:
      +4.711e-04 / +9.056e-04 / +1.013e-03 / +1.033e-03   [monotone ok]
```

Findings: $\lambda_{\min}$ stays **strictly positive** and stabilizes near
$0.9$–$1.0\cdot10^{-3}$ under grid refinement (the decreasing *ratio* reflects
$\lambda_{\max}$ growth, not any approach of $\lambda_{\min}$ to $0$); arithmetic and
model kernels agree entry-wise well enough that their $\lambda_{\min}$ match to
$0.3\%$ at every $n$; and $\lambda_{\min}(K)$ is nondecreasing in the zero count, as
it must be (adding atoms to $\nu$ adds a PSD Gram term; Weyl) — a structural
consistency check the data passes at all four $K$. **Caution** (learned the hard
way, disclosed): the Toeplitz difference arguments reach $|t|=2T$, so an arithmetic
kernel of radius $T$ needs primes to $e^{2T}$; at the $2\cdot10^6$ sieve the honest
arithmetic radius is $T=7$. A run at $T=14$ silently produces garbage
($\lambda_{\min}\sim-10^{14}$) because $S(X)$ beyond the sieve is wrong — any future
audit should check this reach condition first.

### 3.3 (c)(iii) falsifiability: off-line injection and sensitivity in $\delta$ (Part 4)

**Proposition D (explicit falsification depth).** Replace the first zero pair by the
quadruple $\{\beta\pm i\gamma_1,\,1-\beta\pm i\gamma_1\}$, $\beta=\tfrac12+\delta$,
$\delta>0$, keeping the rest on the line. Write $A_0=2/|\rho(1-\rho)|$
($\rho=\beta+i\gamma_1$), $A_0'$ likewise for $1-\beta+i\gamma_1$,
$B_r=\sum_{\text{rest}}a(\gamma)$, $B_t=\widetilde H_1(1)$. Then the one-point
criterion (Theorem A(3)) fails at some
$$t^*\;\le\;t_D:=\frac1\delta\log\frac{B_t+B_r+A_0'}{A_0}\;+\;\frac{2\pi}{\gamma_1}.$$
*Proof.* The injected growing part is $A_0e^{\delta t}\cos(\gamma_1t+\varphi)$; the
decaying part is $\le A_0'$ and the on-line rest is $\le B_r$ in absolute value; at
the first cosine peak after $t_0=\delta^{-1}\log((B_t+B_r+A_0')/A_0)$ the total
strictly exceeds $B_t$. $\square$ Grade: **proved** (elementary). Consequence: the
falsification depth is $\log X^*\asymp C/\delta$ — *exponential in
$1/\delta$ as a prime-data requirement*, with explicit constant.

Measured (model side, first $2\cdot10^4$ zeros retained):

```
      delta    t* (measured)   t_D (bound)    delta * t*
      0.002        727.90        1162.06  OK     1.456
      0.005        297.38         465.09  OK     1.487
      0.010        151.36         232.77  OK     1.514
      0.020         67.55         116.61  OK     1.351
      0.050         32.86          46.91  OK     1.643
      0.100         16.64          23.68  OK     1.664
      0.200          8.00          12.06  OK     1.600
      control delta = 0: max(H1^2 - H1(1)^2) on [0.04,100] = -1.87e-03  (< 0)
```

The bound holds at every $\delta$; the measured constant $C=\delta t^*\in[1.35,1.66]$
sits below the Prop.-D envelope $\approx2.33$. Kernel detection (T=25, n=120,
99,999 on-line zeros retained — the `exp31_product_carrier` Part-4 grid):

```
      delta    one-body g1 ratio     pair g2 ratio
      0.000      +6.220e-04         +2.987e-03
      0.005      +6.204e-04         +2.983e-03
      0.010      +1.248e-04         +2.970e-03
      0.020      -9.894e-03         -6.799e-03
      0.050      -1.070e-01         -2.142e-01
      0.100      -6.274e-01         -1.000e+00
      0.200      -9.976e-01         -1.000e+00
      detection radius (pair kernel ratio < -0.01, spacing 0.15):
      delta:  0.02   0.05   0.10   0.20
      T_det:    27     10      6      4      (delta*T_det in [0.5, 0.8])
```

Replications and deltas: at $\delta=0.05$ ($\beta=0.55$) the row
$(-0.107,\,-0.214)$ reproduces `exp31_product_carrier` Part 4's $(-0.108,\,-0.219)$
with a 33× larger on-line rest — and the pair kernel's $\approx2\times$ stronger
response (the doubled exponent $e^{2\delta|t|}$) replicates. **New quantification:**
(i) at fixed radius $T=25$ the margin is *unbroken* for $\delta\le0.01$ — the
criterion is blind to an off-line pair until the grid radius reaches
$T_{\rm det}\approx(0.5$–$0.8)/\delta$, matching the one-point law
$t^*\approx1.5/\delta$ up to the kernel's ability to integrate evidence below the
crossing; (ii) at the detection threshold the pair kernel's advantage disappears
($\delta=0.02$: one-body $-9.9\cdot10^{-3}$ vs pair $-6.8\cdot10^{-3}$) — the
doubling is an asymptotic-in-$T$ statement, not a threshold improvement. Grade:
measured; the $1/\delta$ scaling is Prop.-D-backed, the constants are empirical.

### 3.4 (c)(iv) $\chi_3$ replication (Part 6)

205 self-computed L-zeros (`data/chi3_zeros_ext.npy`, validated in
`exp34_twisted_carrier`); constants from closed forms, cross-checked by an
independent central-difference computation of $L'/L(1,\chi_3)$ through the
cancelling Hurwitz poles (agreement $1.0\cdot10^{-18}$; and
$L(1)=\pi/3\sqrt3$ to $10^{-41}$):

```
  corr(q_chi, h_chi) = 0.999988 (205-zero truncation);  band [5,45]: corr = 1.00000000, ratio 0.999997
  ONE-POINT CRITERION |q_chi| <= B_chi: holds everywhere: True
    max |q_chi|/B_chi = 0.5640 at X = 17511.5;  min defect/B_chi^2 = 0.6819
  Krein kernel of g2_chi (T=7, n=160): model lam_min = +3.317e-03; arithmetic +4.582e-03
  injection (T=25, n=120):  beta=0.55: one-body -0.136, pair -0.335
                            beta=0.60: one-body -0.690, pair -1.000
```

The injection rows reproduce `exp34_twisted_carrier` Part 5 to all printed digits
(same zero data, independent pipeline). The per-character one-point criterion holds
with margin $0.68$; the twisted carrier's margin is *larger* in $|q|/B$ maximum
($0.564$ vs $0.491$) but on a shorter zero string — not comparable beyond the sign.
Grade: numerics replicate; Theorem A′ gives the per-character equivalence.

---

## 4. The superresolution/hologram reading: why the reduction works, and what stays out of reach

`BARRIER.md` defines the windowed-linear class WL$_d(L,r)$; `HOLOGRAM.md` Theorem K
prices information: zero *locations* are surface (poly depth), zero *correlations*
are bulk (~~$X\sim\exp(cT\log^2T)$~~ — **struck 2026-08-22, lane क्षेप: superseded by
`HOLOGRAM.md` §7 Theorem K′, $\exp\Theta(T^{1/2}\log^{3/2}T)$ for **sum**-spectrum
atoms, and by `HOLOGRAM.md` §5, $\exp\Theta(T)$ for **difference** atoms. Which one
applies here is not a detail: §4's own object is the mixed-sign four-zero sector, so
it is the **difference** law, $\exp\Theta(T)$ — see the §3 note below**), with the superresolution toy K0
(`exp41_superres`) as the provable core. This framing does not change any theorem
above — it explains their shape, and it makes one prediction that the numerics
bear out.

1. **The rank collapse is the hologram's tautology made algebraic.** The pair
   carrier is $P=\Phi(Q_1)$ with $Q_1=S(X)$ a *single* WL$_1$ observable and
   $\Phi(x)=((x-\widetilde M)/\sqrt X)^2$ post-processing: arity 1, degree 1. By the
   Structure Proposition (`BARRIER.md` §1), such an observable is a function of the
   *one-body* blurred spectral measure only — so no statement about it can carry
   pair-correlation (bulk) content, and any RH-equivalence it supports must be a
   location (surface) statement. Theorem A's $(2)\Leftrightarrow(3)$ collapse is
   exactly this: the "pair" positivity was always one-body positivity in disguise.
   The pair carrier that *would* carry bulk content — a kernel of $m+n$ — is
   Beta-coupled by `PRODUCT_WEIGHT_NO_GO.md` and loses positivity; the carrier that
   keeps positivity is separable and loses the bulk. **That dichotomy is the barrier
   classification, not an accident of our constructions.**

2. **Off-line detection is not a Rayleigh problem — that is why falsification is
   cheap(er).** The superresolution lower bounds of K0 protect *close real
   frequencies* (coherent clusters indistinguishable below $(\delta L)^{2p-1}$).
   An off-line zero is a *non-real* frequency $\omega=\gamma-i\delta$: a growth
   channel, not a resolution channel. Prop. D quantifies it: depth
   $\log X^*\approx C/\delta$ with $C\in[1.35,1.66]$ measured — for fixed $\delta$
   this is *polynomial in the height* ($C$ grows like $2\log\gamma$ through
   $A_0=2/|\rho(1-\rho)|$), i.e. RH-defect detection sits in the **surface tier** of
   Theorem K, strictly cheaper than correlation reading. The carrier criterion is
   therefore genuinely falsifiable at feasible depth for macroscopic $\delta$ — and
   *infeasible* for microscopic $\delta$ ($\delta=0.002$ already needs
   $X^*\sim e^{728}$): the numerics of §3.1, six decades of margin $\ge0.76$, are
   evidence about $\delta\gtrsim1.5/\log(1.9\cdot10^6)\approx0.1$-scale violations
   at low height and *nothing more*. Stated so the audit cannot misread it: Part 1
   is a consistency check with known zero data, not numerical evidence for RH.

3. **What stays bulk stays open.** The single missing lemma of the product program —
   the microscopic energy bound $E^\circ_a(\eta)\ll\eta m_0^2$ needed for the
   variance rate $V=D_0+O(1/L)$ (`PRODUCT.md` P4(c), `PRODUCT_CARRIER.md` §5) — is
   a four-zero statement including the mixed-sign (difference/pair-correlation)
   sector. `DCLOSE_NO_GO.md` proved it is not finite-checkable; Theorem K prices its
   empirical face at ~~$\exp(cT\log^2T)$~~ depth.

   > **STRUCK 2026-08-22 (lane क्षेप), and the repair sharpens this item rather
   > than weakening it.** $\exp(cT\log^2T)$ is superseded by `HOLOGRAM.md` §7.
   > **The sentence names its own sector — "the mixed-sign
   > (difference/pair-correlation) sector" — and that sector's law is
   > `HOLOGRAM.md` §5's $\exp\Theta(T)$, not §7's
   > $\exp\Theta(T^{1/2}\log^{3/2}T)$.** The reason is exact and is now derived
   > rather than asserted (`notes/Ksepa_…IsNotBhavana.md` §2.2): since
   > $\sum_j\rho_j+2$ depends on the ordinates only through the signed sum and
   > $\cosh$ is even, the $k$-fold kernel's numerator is
   > $\asymp(2\pi)^ke^{-\pi\sum_j|\gamma_j|}$ for every configuration, and the
   > denominator's $e^{-\pi|s|}$ cancels it **exactly** when the signs agree and
   > only partially when they do not — leaving amplitude
   > $e^{-\pi(\sum_j|\gamma_j|-|\sum_j\gamma_j|)}$. Mixed signs means
   > $\log A\approx-\pi T$, which is what pushes the threshold from
   > $T^{1/2}\log^{3/2}T$ up to $T$. So this item's wall is a **whole power of
   > $T$ higher** than the struck figure's successor would suggest — and higher
   > for a reason internal to the sector it already correctly identified.
   The join adds: it is also exactly the
   sector that obstructs an exact Theorem J (Prop. F — the defect $X\,E(X)$ carries
   the sum *and difference* lines, measured in §2). One object, three walls, one
   classification: **everything in the join that closed is surface; the one thing
   open is bulk.** The hologram framing did not change the answer — it explains why
   the answer has this shape, and it upgraded one heuristic ("the converse factors
   through one-body") into an expectation the proof then met (the rank collapse).

---

## 5. Open lemmas and honest fencing

**Open lemmas, in order of importance.**

- **L1 (the single missing lemma).** $E^\circ_a(\eta)\le C\eta m_0^2$ for
  $0<\eta\le\eta_0$ — the microscopic product-energy bound, mixed-sign sector
  included. Needed *only* for the variance rate $V=D_0+O(1/L)$; every statement in
  §§1–2 is independent of it. Provably not finite-checkable (`DCLOSE_NO_GO.md`);
  bulk-priced (`HOLOGRAM.md`). Unchanged by this note.
- **L2.** A closed form (or independent determination) of $c_2=-2.28031$; currently
  a measured limit constant. Also: an unconditional version of Prop. E (the quoted
  $R$-bound is RH-conditional).
- **L3.** Strictness of $|H_1(X)|<B$ for $X>1$ under RH (equivalent to excluding a
  common period for all ordinates; LI-flavored; not needed for Theorem A).
- **L4.** A matching lower bound for the sensitivity law: is
  $\log X^*\gg\delta^{-1}$ *necessary* for every WL observable detecting an
  off-line pair at margin $\delta$? A proof would make Prop. D's rate a two-sided
  law and would be the first quantitative theorem of the barrier program's
  Problem 1.

**Fencing.**

- Lemma B/B′ are classical in technique (Laplace + Landau); the claim is a complete
  in-repo proof replacing the MS-extraction dependence, not mathematical novelty.
  Theorem A's content at the $g_{H_1}$ level is Matsumoto–Suzuki Theorem 1.3
  (as extracted in `SCREW.md`); the finite-data forms (5)/(6) with sharp constant
  $B$, zero error term, and the $X=1$ anchor are this repo's packaging via the
  interior carrier. A literature pass for one-sided/sharp-constant antecedents
  (Landau-type criteria) is owed before any external claim.
- Prop. E imports $R(X)\ll X\log^3X$ (under RH) *as quoted in* `SCREW.md` §1 —
  the same extraction-trust boundary as everything MS-adjacent in this repo;
  Prop. E's conclusion is otherwise independent of the MS text.
- Prop. F's Bohr-extraction step is termwise-rigorous only (conditional convergence
  of the $k=0$ pair sum); its empirical face is measured in Part 5.
- All kernel numerics are finite sections; PSD of every finite section is the
  correct finite-data meaning of the screw axiom (§1.1), but no finite computation
  certifies RH (Part 1 margins are consistency checks — see §4.2's scope
  statement). The arithmetic-kernel reach condition $e^{2T}\le N_{\rm sieve}$ is
  load-bearing (§3.2 caution).
- $\chi_3$: zero-list completeness rests on `exp34_twisted_carrier`'s count/gap
  diagnostics (205 vs 205.2 expected), not an argument-principle certificate.

**Relation to prior notes (no edits made).** `PRODUCT_CARRIER.md` C3's grade
"proved modulo one quoted MS ingredient" can, after Lemma B, be upgraded to
"proved in-repo"; same for `TWISTED_CARRIER.md` T3. `BLOCKS.md` §5's open item
(canonical smooth subtraction) is answered by §2 above: canonical subtraction =
$\widetilde M$ transported, one constant of freedom, exactness impossible with the
obstruction identified and measured. `APPENDIX_D.md` §D.6(3)'s corrected direction
is now fully closed at the equivalence level; its genuinely open residue is L1.

## Reproducibility

| artifact | contents |
|---|---|
| `code/exp56_carrier_join.py` | Parts 0–6; self-contained (numpy/scipy/mpmath/matplotlib); prints every number quoted here |
| `data/exp56_out.txt` | full captured output of the run quoted in this note |
| `figures/exp56_carrier_join.png` | (a) $q/B$ vs the RH wall; (b) $\lambda_{\min}$ vs grid size, model vs arithmetic; (c) injection indefiniteness vs $\delta$; (d) the Theorem-J transport constant |
