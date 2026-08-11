# The product-weighted pair carrier: a finite doubly-reweighted Goldbach sum for the measure ν = Σ a(γ)a(γ′) δ_{γ+γ′}

**Task:** fleet STATE board open target 1 (the product-weighted pair object of `SCREW.md` §4.1).
**Code:** `code/exp31_product_carrier.py` → `figures/exp31_product_carrier.png`.
**Status of claims:** graded per item below. This note was written in deliberate *adversarial
collision* with the sibling branch's `PRODUCT.md`/`exp20_product.py` (fleet-product + Codex),
which attacked the same target with a different carrier; §7 reconciles the two and states
exactly what is replicated and what is new here.

Throughout, RH is assumed where stated; $\rho=\tfrac12+i\gamma$ with $\gamma$ over **signed**
ordinates;

$$a(\gamma)=\frac{1}{\gamma^2+\tfrac14}=\frac{1}{\rho(1-\rho)}\Big|_{\rm RH}>0,\qquad
B=\sum_\gamma a(\gamma)=2+\gamma_E-\log 4\pi = 0.0461914\ldots,$$

the Matsumoto–Suzuki screw masses [MS, arXiv:2409.00888]; $h(u)=\sum_\gamma a(\gamma)e^{i\gamma u}
=2\sum_{\gamma>0}a(\gamma)\cos\gamma u$ (real, even, $h(0)=B$, absolutely convergent);
$\mu_1=\sum_\gamma a(\gamma)\delta_\gamma$; and the target measure on the sum spectrum

$$\nu=\mu_1*\mu_1=\sum_{\gamma,\gamma'}a(\gamma)a(\gamma')\,\delta_{\gamma+\gamma'},
\qquad \nu(\mathbb R)=B^2,\ \ \nu\ge0\ \text{under RH}.$$

Constants used without fitting: $m_0=\sum_\gamma a(\gamma)^2 = 7.420127\cdot10^{-5}$,
$S_4=\sum_\gamma a(\gamma)^4=1.31966\cdot10^{-9}$ (both converged at 1000 zeros to all
displayed digits; $B$ itself converges only like $1/\gamma$, Part 0).

---

## 1. The carrier question, and the boundary conditions set by the no-go

Theorem D's pair layer carries Beta weights $\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)$ —
complex-phased, Krein-indefinite (`SCREW.md` Part 4). The product weights $a(\gamma)a(\gamma')$
are positive under RH, but `PRODUCT_WEIGHT_NO_GO.md` (Theorem 2.1, verified line-by-line in
`PRODUCT.md` §1) proves **no kernel of $m+n$ can carry factorized Mellin coefficients** except
the trivially-separable heat kernel: the Euler Beta coupling is intrinsic to additive smoothing.
So the carrier must be a genuinely two-variable (separable) transform: reweight **per variable
first**, correlate **after**, restrict to the diagonal **at the end**. The construction below is
forced by this order of operations, not chosen for convenience.

External context (2026): Suzuki's zero-side program (arXiv:2606.09096, "Weil's quadratic form
via the screw function", with numerical companions 2607.24830, 2607.02828) develops
screw-function positivity from the zero side. Per the fleet's deep-read (abstract/snippet
level): all three are **single-zero-index** Weil-form objects, with cross terms at difference
frequencies only — none treats product weights $a(\gamma)a(\gamma')$ on pair *sums*, and none
has a two-variable arithmetic carrier. Likewise MS's own arithmetic side [MS (1.6)] is a
*one-variable* smoothing ($n^{-2}$ against the total $m+k$), which by the no-go can and does
yield only the single-zero layer $H_1$. What this note supplies, and that literature lacks, is
the **arithmetic pair carrier**: an explicit finite double sum over prime powers whose
oscillatory layer *is* the screw square, i.e. prime data carrying $\nu$ directly. (Caveat:
the deep-read is abstract/snippet-level; a full-text pass should recheck this differentiation.)

---

## 2. Proposition C1: the interior one-body carrier (proved, unconditional)

**Proposition C1.** For $X>1$ let

$$S(X):=\sum_{n\le X}\Lambda(n)\,\frac{X-n}{n}\;=\;X\int_1^X \psi(t)\,\frac{dt}{t^2}.$$

Then, unconditionally, with the zero sum **absolutely** convergent
($|\rho(1-\rho)|\ge\gamma^2$),

$$S(X)=X\log X-(1+\gamma_E)\,X+\log 2\pi+\sum_\rho\frac{X^\rho}{\rho(1-\rho)}+\delta(X),$$

$$\delta(X)=X\int_X^\infty \tfrac12\log(1-t^{-2})\,\frac{dt}{t^2},\qquad
-\tfrac29\,X^{-2}\le\delta(X)<0\quad(X\ge2).$$

Under RH, $S(X)=X\log X-(1+\gamma_E)X+\log2\pi+\sqrt X\,h(\log X)+\delta(X)$: the oscillatory
layer is exactly the Matsumoto–Suzuki screw data $H_1(X)=\sum_\rho X^{\rho-1/2}/(\rho(1-\rho))$,
with **positive masses** $a(\gamma)$ and **closed-form smooth part** — no fitted constants.

*Proof.* The first equality is partial summation:
$\int_1^X\psi(t)t^{-2}dt=\sum_{n\le X}\Lambda(n)\int_n^X t^{-2}dt=\sum_{n\le X}\Lambda(n)(\tfrac1n-\tfrac1X)$.
Insert the truncated von Mangoldt formula
$\psi(t)=t-\sum_{|\gamma|\le T}t^\rho/\rho-\log2\pi-\tfrac12\log(1-t^{-2})+R(t,T)$,
$R\ll t\log^2(tT)/T+\log t$ uniformly on compacts of $(1,\infty)$; the error integrates to
$O(\log^3(XT)/T)\to0$. Termwise: $\int_1^X t^{-1}dt=\log X$;
$\tfrac1\rho\int_1^X t^{\rho-2}dt=\frac{X^{\rho-1}-1}{\rho(\rho-1)}$, and
$-\frac{1}{\rho(\rho-1)}=\frac{1}{\rho(1-\rho)}$, so after multiplying by $X$ the zero layer is
$\sum_\rho X^\rho/(\rho(1-\rho))-BX$, dominated by $\sum\gamma^{-2}<\infty$. The trivial-zero
term contributes $-X\,I(X)$ with $I(X)=\int_1^X\tfrac12\log(1-t^{-2})t^{-2}dt$; substituting
$x=1/t$,

$$I_\infty=\tfrac12\int_0^1\log(1-x^2)\,dx=\tfrac12\big[(-1)+(2\log2-1)\big]=\log2-1,$$

(numerically confirmed to $1.8\cdot10^{-15}$, Part 0), and the collected $X$-coefficient is
$-(B+\log2\pi+I_\infty)=-(1+\gamma_E)$ using $B=2+\gamma_E-\log4\pi$. The constant term is
$+\log2\pi$ (from $-\log2\pi\int_1^X t^{-2}dt$ times $X$), and $\delta$ is the tail of the
trivial-zero integral, bounded by $|\log(1-y)|\le\tfrac43y$ for $y\le\tfrac14$. $\square$

Grade: **proved** (the only imported ingredients are the truncated explicit formula with its
standard error term, and the classical constants; every constant was verified numerically to
the precision floor in Parts 0–1).

**Remark (interior vs exterior).** The sibling branch's carrier is the *exterior* compensated
integral $\Phi(X)=X\int_X^\infty(\psi(t)-t)t^{-2}dt$ (`PRODUCT.md` Theorem P1), which requires
an $N\to\infty$ limit in its arithmetic form. The two are exact complements:

$$S(X)+\Phi(X)=X\log X-(1+\gamma_E)X\qquad\text{exactly},$$

equivalently $\int_1^\infty(\psi(t)-t)t^{-2}dt=-1-\gamma_E$ (PNT-strength classical constant);
in particular the zero layers are equal and opposite, and the two error terms satisfy
$\delta_S=-\delta_\Phi$ *exactly* — consistent with the independently derived bounds
($0<\delta_\Phi<\tfrac13X^{-2}$ there, $-\tfrac29X^{-2}\le\delta_S<0$ here). This is a
nontrivial cross-check of both explicit formulas. $S$ is the version with no tail, no
compensator and no limit: a finite sum over prime powers.

---

## 3. Proposition C2: the doubly-reweighted Goldbach pair sum (proved)

**Proposition C2.** Define the two-variable prime-pair statistic with **independent cutoffs**

$$T(X,Y):=\sum_{m\le X,\ n\le Y}\Lambda(m)\Lambda(n)\,\frac{(X-m)(Y-n)}{mn}
\;=\;S(X)\,S(Y),$$

a finite double sum with the separable kernel $K(m,n)=(X-m)_+(Y-n)_+/(mn)$ — a
per-variable Cesàro-times-harmonic reweighting, *not* a function of $m+n$ (nor of $mn$).
Let $M(X)=X\log X-(1+\gamma_E)X+\log2\pi$ and take the diagonal **at the end**:

$$P(X):=\frac{\big(S(X)-M(X)\big)^2}{X}
=\frac{T(X,X)-2M(X)S(X)+M(X)^2}{X}.$$

Then unconditionally $P(X)=X^{-1}\big(\sum_\rho X^\rho/(\rho(1-\rho))+\delta(X)\big)^2$, and
under RH

$$P(X)=\sum_{\gamma,\gamma'}a(\gamma)a(\gamma')\,e^{i(\gamma+\gamma')\log X}
+O(X^{-5/2})
=\int_{\mathbb R}e^{i\omega\log X}\,d\nu(\omega)+O(X^{-5/2}).$$

*Proof.* $T=SS$ is immediate from the factorization of the kernel; square Proposition C1 and
use $|h|\le B$: $(\sqrt Xh+\delta)^2/X=h^2+2h\delta X^{-1/2}+\delta^2X^{-1}
=h^2+O(X^{-5/2})$. $\square$

Grade: **proved** (corollary of C1). $P$ is the doubly-reweighted smoothed Goldbach sum the
target asked for: its zero-pair layer has *exactly* the product weights $a(\gamma)a(\gamma')$,
positive under RH, DC mass $m_0>0$ (the diagonal of $\nu$), supported on the **signed** sum
spectrum $\{\gamma+\gamma'\}$ — which contains both the same-sign lines
$\gamma_i+\gamma_j\ge2\gamma_1$ and the mixed-sign difference lines $\gamma_i-\gamma_j$
(total difference-sector mass $B^2/2$; cf. `PRODUCT.md` §4, `DCLOSE_NO_GO.md`).

**Why this evades the no-go.** Theorem 2.1 of `PRODUCT_WEIGHT_NO_GO.md` classifies kernels of
$(m+n)/X$; $K(m,n)$ is separable, so the Beta coupling never arises. The order of operations
is the entire content: reweighting each variable by $n^{-1}(X-n)_+$ *first* produces one-body
zero masses $1/(\rho(1-\rho))$; correlating *afterwards* (diagonal $X=Y$ last) produces the
product masses. Any attempt to correlate first (a kernel of the total $m+n$) is provably
Beta-coupled. Honesty about what this means: $T(X,X)=S(X)^2$ is the rank-one square of a
one-body statistic — by the no-go this is *forced*, not a defect of the construction, but it
does mean the positivity content of $\nu$ is one-body content (see C3 and §6).

---

## 4. Proposition C3: "ν is a screw measure ⟺ RH" (proved modulo one quoted MS ingredient)

Define, unconditionally (absolutely convergent, real, even, $g_2(0)=0$):

$$g_2(t):=H_1(e^t)^2-H_1(1)^2,\qquad
H_1(e^t)=\sum_\rho \frac{e^{(\rho-1/2)t}}{\rho(1-\rho)},\quad H_1(1)=B.$$

Under RH, $H_1(e^t)=h(t)$ and $g_2(t)=\int(e^{i\omega t}-1)\,d\nu(\omega)$: $g_2$ is the
Krein transform of $\nu$. By Proposition C2, $g_2$ is computable from prime data:
$g_2(t)=P(e^t)-P(1)+O(e^{-t/2})$-type arithmetic approximants (numerically realized in Part 2).

**Proposition C3.** $g_2$ is a screw function $\iff$ RH.

*Proof.* ($\Leftarrow$, i.e. RH $\Rightarrow$ screw) $\nu=\mu_1*\mu_1$ is a finite positive
measure ($\mu_1\ge0$ under RH is [MS Thm 1.3, easy direction]); then
$\sum_{i,j}G_{g_2}(t_i,t_j)\xi_i\bar\xi_j=\int\big|\sum_i(e^{i\omega t_i}-1)\xi_i\big|^2d\nu(\omega)\ge0$
— a Hermitian-square identity over the sum spectrum. ($\Rightarrow$) One-point Krein
positivity at the grid $\{t\}$ gives $G_{g_2}(t,t)=-2g_2(t)\ge0$, i.e.
$H_1(e^t)^2\le B^2$ for **all** $t\in\mathbb R$: the screw axiom alone bounds $H_1$ on the
whole line. By [MS Cor. 3.1 and the proof of Thm 1.3] (boundedness of the generalized
Dirichlet series $\sum_\rho m_\rho e^{(\rho-1/2)t}$, $\sum|m_\rho|<\infty$, forces all
exponents real), every zero has $\beta=\tfrac12$. $\square$

Grades. Direction RH $\Rightarrow$ screw: **proved** (elementary given MS positivity; this is
the corollary structure already announced in `SCREW.md` §4.1 and proved as Theorem P3 in
`PRODUCT.md` — our formulation differs only in packaging). Direction screw $\Rightarrow$ RH:
**proved modulo the quoted MS boundedness result** (Cor. 3.1), which we have only in the
arXiv-extraction form recorded in `SCREW.md` §1; the reduction of the pair statement to
one-body boundedness via the one-point kernel value $-2g_2(t)$ is ours and is elementary.

**Honest assessment (unchanged from the fleet's):** the converse factors through the
*one-body* bound $|H_1|\le B$. The pair measure $\nu$ adds **no independent RH content** —
exactly as `SCREW.md` §4.3 predicted ("RH content is saturated at first order"). What the pair
level adds is *quantitative sensitivity* (below) and the metric in which the Appendix-D
variance program closes (§5).

**Off-line contamination, measured (Part 4).** Injecting the quadruple
$\{\beta\pm i\gamma_1,\,1-\beta\pm i\gamma_1\}$ in place of the first zero pair (2999 zeros on
the line retained), the Krein kernels on a uniform grid ($n=120$, $T=25$) give

| $\beta$ | 0.50 | 0.55 | 0.60 | 0.65 | 0.70 |
|---|---|---|---|---|---|
| one-body $g_1$: $\lambda_{\min}/\vert\lambda\vert_{\max}$ | $+5.4\cdot10^{-4}$ | $-0.108$ | $-0.629$ | $-0.983$ | $-0.998$ |
| pair $g_2$ (kernel of $\nu$): | $+2.9\cdot10^{-3}$ | $-0.219$ | $-1.000$ | $-1.000$ | $-1.000$ |

Random-grid check at $\beta=0.60$: $-1.000$. The $\beta=0.55$ row of $g_1$ reproduces
`exp12_screw.py` Part 3b ($-0.108$ there) — an independent replication — and the pair kernel
detects roughly **twice as strongly** at small $\beta-\tfrac12$, consistent with the doubled
growth exponent $e^{2(\beta-1/2)|t|}$ of $H_1^2$ vs $H_1$. Grade: numerical observation; the
doubling heuristic is Stirling-free and robust, but we prove no rate.

---

## 5. The Appendix-D variance analysis in the product metric

The pair layer is $A_2(u)=h(u)^2=\int e^{i\omega u}d\nu$. With the Fejér window
$\phi_L(u)=(1-|u|/L)_+$,

$$V(u_0,L)=\frac1L\int|A_2(u_0+u)|^2\phi_L(u)\,du
=\sum_{\gamma_1\gamma_2\gamma_3\gamma_4}a_1a_2a_3a_4\,e^{i\delta u_0}\,
\mathrm{sinc}^2(L\delta/2),\quad\delta=\gamma_1{+}\gamma_2{-}\gamma_3{-}\gamma_4,$$

absolutely convergent with **all weights positive** — the Riemann–Siegel phases of the Beta
metric (`APPENDIX_D.md` D.1–D.2) are gone. This quadruple formula and the Jensen lower bound
$V\ge M_L^2$, $M_L\to m_0$, are `PRODUCT.md` Theorem P4(a); we re-derived both independently.

**Diagonal (independent re-derivation, confirming P4(b)).** Assuming no nontrivial additive
relations among ordinates, the solutions of $\delta=0$ are
$E_1{:}\,(\gamma_3,\gamma_4)=(\gamma_1,\gamma_2)$, $E_2{:}\,(\gamma_4,\gamma_3)=(\gamma_1,\gamma_2)$,
$E_3{:}\,\gamma_2=-\gamma_1\wedge\gamma_4=-\gamma_3$ (the DC family), each of mass $m_0^2$;
pairwise intersections each have mass $S_4$ ($(\gamma,\gamma,\gamma,\gamma)$,
$(\gamma,-\gamma,\gamma,-\gamma)$, $(\gamma,-\gamma,-\gamma,\gamma)$), triple intersection
empty ($\gamma=0$ impossible). Inclusion–exclusion:

$$D_0=3m_0^2-3S_4=3(m_0^2-S_4)=1.255852\cdot10^{-8},$$

confirming the fleet's formula and value ($1.2559\cdot10^{-8}$). Exact resonances would only
*add* positive mass. The full-spectrum AC variance has the closed form
$\overline{(h^2-m_0)^2}=2m_0^2-3S_4$.

**Numbers (Parts 2–3; $\Lambda$ to $4\cdot10^6$, model 30,000 zeros, line measure from 1500
zeros = 3000 signed ordinates, $u_0=12$, $K=800$ zeros for the $V$ scan).**

- DC: mean$(P)=7.488\cdot10^{-5}$, mean$(h^2)=7.488\cdot10^{-5}$ (identical), vs
  $m_0=7.420\cdot10^{-5}$; the $0.9\%$ excess is finite-window leakage, equal in data and
  model. The **positive DC = diagonal mass of $\nu$** is the signature that distinguishes the
  product metric from the Beta metric (where DC is $e^{-\pi\gamma}$-small).
- Parseval closure in band $[28,60]$, three ways: $\sqrt{\sum_{f\in\rm band}2c_f^2}$ over the
  binned $\nu$ lines $=6.342\cdot10^{-5}$; windowed RMS of the model $h^2=6.290\cdot10^{-5}$;
  windowed RMS of the **arithmetic** $P=6.290\cdot10^{-5}$. Data and model agree to five
  digits; the $0.8\%$ line-sum excess is cross-term leakage of the finite window
  (predictable, shared by neither grid quantity).
- Full-spectrum: $2m_0^2-3S_4=7.05\cdot10^{-9}$ vs grid variance $6.67\cdot10^{-9}$
  (finite window, band-limited grid — consistent).
- Windowed variance against the diagonal (Fejér, model side):

  | $L$ | 4 | 8 | 16 | 32 | 64 | 128 |
  |---|---|---|---|---|---|---|
  | $V/D_0$ | 0.976 | 0.971 | 1.032 | 1.047 | 1.034 | 1.019 |
  | Jensen floor $M_L^2$ holds | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |

  replicating `PRODUCT.md` Part 5 ($[0.97,1.05]$) with an independent implementation. The
  2–5% excess at large $L$ is near-diagonal energy at resolution $1/L$ — the positive-weight
  avatar of `ENERGY.md`'s linear law.

**What remains open (unchanged).** A quantitative upper-bound *rate* $V=D_0+O(1/L)$ needs the
microscopic energy bound $E^\circ_a(\eta)\ll\eta\,m_0^2$ — by `DCLOSE_NO_GO.md` a genuine
four-zero correlation conjecture (including the mixed-sign/difference sector), not
finite-checkable. Every lower bound is free (positivity). Nothing in this experiment changes
that boundary; the numerics above are evidence, not certificates.

---

## 6. Verification of the carrier identity (the headline numerics)

Protocol: grid of $M=8192$ log-uniform $X\in[3\cdot10^3,3.9\cdot10^6]$; arithmetic side from
the sieve via exact prefix sums (long-double accumulation); **no fitted constants anywhere**
— the smooth part $M(X)=X\log X-(1+\gamma_E)X+\log2\pi$ is subtracted with its closed-form
coefficients (contrast: `exp20_product.py` removes the smooth span by least squares; a
fortiori our protocol is the stronger falsification test). $q:=(S-M)/\sqrt X$ estimates $h$;
$P:=q^2$ estimates the pair layer.

**One-body identity (Prop. C1).** corr$(q,h)=1.00000000$; RMS ratio $1.000000$;
$\mathrm{RMS}(q-h)/\mathrm{RMS}(h)=2.7\cdot10^{-5}$; $\max|q-h|=1.5\cdot10^{-6}$ absolute —
the identity holds at the double-precision/zero-truncation floor with zero free parameters.
Single lines: data/model amplitude ratios $1.0000$ at $\gamma_1,\gamma_2,\gamma_3$, absolute
amplitudes matching $2a(\gamma_i)$ to the window floor.

**Pair identity (Prop. C2).** Band $[28,60]$ in $\log X$:

| comparison | corr | amplitude ratio |
|---|---|---|
| $P$ vs $h^2$ | **1.000000** | 1.000001 |
| $P$ vs binned-$\nu$ line model (34,284 lines, all masses $>0$) | **0.999885** | 0.995181 |

Line table (Hann-windowed DFT; "$\nu$-model" = reconstruction from the binned line measure;
"isolated $2c_f$" = the bare line mass):

| line | $f$ | data amp | $\nu$-model | ratio | isolated $2c_f$ |
|---|---|---|---|---|---|
| $2\gamma_1$ | 28.269 | $4.829\cdot10^{-5}$ | $4.830\cdot10^{-5}$ | 0.9998 | $4.998\cdot10^{-5}$ |
| $\gamma_1+\gamma_2$ | 35.157 | $4.596\cdot10^{-5}$ | $4.594\cdot10^{-5}$ | 1.0005 | $4.522\cdot10^{-5}$ |
| $\gamma_1+\gamma_3$ | 39.146 | $2.642\cdot10^{-5}$ | $2.642\cdot10^{-5}$ | 1.0001 | $3.195\cdot10^{-5}$ |
| $2\gamma_2$ | 42.044 | $5.348\cdot10^{-6}$ | $5.336\cdot10^{-6}$ | 1.0022 | $1.023\cdot10^{-5}$ |

**Methodological caution worth recording:** the isolated-mass column deviates by up to a
factor 2 (at $2\gamma_2$) — *not* an error but unresolved interference from $\nu$'s own
difference lines at the window resolution $\sim0.9$ (e.g. $\gamma_{12}-\gamma_1=42.31$ sits
$0.27$ from $2\gamma_2=42.04$). Any future line-based test in the product metric must compare
against the full line measure, not bare masses; same-sign lines do not own the sum spectrum.

**Absence of single-zero lines — with a twist.** At $\gamma_4=30.425$ and $\gamma_5=32.935$
(inside the pair band): amplitude in $q$ is $2.2\cdot10^{-3}$ / $1.9\cdot10^{-3}$; in $P$ it
is $3.00\cdot10^{-6}$ / $3.58\cdot10^{-6}$ — suppressed by a factor $500$–$700$, and the
residue is **not leakage**: $\nu$'s own difference-line clusters near those frequencies
predict $2.99\cdot10^{-6}$ / $3.59\cdot10^{-6}$ (0.3% agreement). Even the "contamination" at
single-zero frequencies is carried by $\nu$.

Grade of §6: numerics at the stated precision, fully reproducible from
`code/exp31_product_carrier.py` (running time ~1 min).

---

## 7. Reconciliation with `PRODUCT.md` (the collision report)

The sibling branch landed first with carrier $\Phi(X)=X\int_X^\infty(\psi-t)t^{-2}dt$ and
$G_w=\Phi^2$ (min-kernel $\min(1,X/m)\min(1,X/n)$, Krein-string reading, Theorems P1–P4).
Where the two constructions overlap they agree exactly ($R_S=-R_\Phi$; §2 Remark), so this
work **independently replicates**: their P1/P2 identity chain (our corr $1.000000$ at both
layers, via a disjoint pipeline with exact constants instead of least squares); their P3/exp20
Part-3 positivity and exp12 Part-3b detection row ($-0.108$ at $\beta=0.55$); their Part-4
measure contrast (our 1200-zero binning: 55% of mass-carrying lines with $\mathrm{Re}<0$,
64% of $|$mass$|$, mean $|\mathrm{Im}|/|c|=0.69$; theirs: 50%/60%/0.64 at 300–400 zeros);
their P4(b) diagonal $D_0=3(m_0^2-S_4)$ (re-derived by inclusion–exclusion) and Part-5
variance window $V/D_0\in[0.97,1.05]$.

New here, beyond replication:

1. **The interior carrier** $S(X)=\sum_{n\le X}\Lambda(n)(X-n)/n$: a *finite* arithmetic sum
   (no tail, no compensator, no $N\to\infty$), with closed-form smooth part
   ($1+\gamma_E$, $\log2\pi$, $I_\infty=\log2-1$) and the exact complement identity
   $S+\Phi=X\log X-(1+\gamma_E)X$, $\delta_S=-\delta_\Phi$ — a cross-check of both branches'
   explicit formulas. This is the cleanest "doubly-reweighted smoothed Goldbach sum" answer to
   the target: $T(X,Y)=\sum_{m\le X,n\le Y}\Lambda(m)\Lambda(n)(X-m)(Y-n)/(mn)$ with
   independent cutoffs, diagonal at the end.
2. **No-fit verification protocol** (exact constants; the identity is falsifiable to
   $1.5\cdot10^{-6}$ absolute, and passes).
3. **Individual line table** in the product metric, including the unresolved-doublet caution
   and the 0.3%-level identification of the *difference-line* content of $\nu$ at single-zero
   frequencies (§6) — the mixed-sign sector of `PRODUCT.md` §4, made visible in data.
4. **Proposition C3 packaged as a two-line equivalence** (one-point Krein positivity $\to$
   $|H_1|\le B$ $\to$ MS boundedness), making explicit that the converse factors through the
   one-body layer; plus the measured **doubled detection strength** of the pair kernel.

Discrepancies found: none — every fleet number we re-measured reproduced within stated
tolerances. (One presentational correction to our own earlier reporting: raw *counts* of
negative Beta lines are dominated by exponentially tiny mixed-sign lines and are
uninformative; mass-weighted statistics, as in `SCREW.md`, are the meaningful ones.)

---

## 8. Verdict and open edges

- The target's question — *which* doubly-reweighted smoothed Goldbach sum carries
  $\nu=\sum a(\gamma)a(\gamma')\delta_{\gamma+\gamma'}$ — has a complete answer: the finite
  separable double sum $T(X,Y)$ of Proposition C2, per-variable reweighting first, diagonal
  last; forced separable by the no-go. Proved, and verified to the numerical floor.
- "$\nu$ is a screw measure on the sum spectrum $\iff$ RH" **holds** (Proposition C3), with
  the essential honesty that both directions live at the one-body layer: $\nu$'s positivity
  is inherited, and its indefiniteness under off-line zeros (measured, Part 4) is inherited
  with a doubled exponent. The pair level's genuine added value is (i) the arithmetic
  carrier — prime data computing the screw square directly, which the zero-side literature
  (MS; Suzuki 2026) does not have — and (ii) the positive-weight variance frame of §5.
- Open, and untouched by this experiment (as it must be, per `DCLOSE_NO_GO.md`): the
  microscopic product-energy bound $E^\circ_a(\eta)\ll\eta m_0^2$, including its mixed-sign
  (pair-correlation-type) sector. That is the wall between "$V\to D_0$ qualitatively" (free)
  and "$V=D_0+O(1/L)$" (conjectural).
- External differentiation (fleet deep-read, abstract/snippet level): the 2026 Suzuki
  Weil-form/screw papers are single-zero-index with difference-frequency cross terms only; the
  product-weighted pair-sum object and its two-variable arithmetic carrier are externally
  unanticipated. A full-text pass should confirm before any publication-grade novelty claim.
