# The D-side has data: pair correlation, short-interval variance, and the conditional gap formula

Companion to `REPORT.md` §5–6. The repo's centerpiece (Theorem D, exp6b) is an $S$-side statement: under RH alone, Goldbach averages *display* the sum-spectrum $\{\gamma_i+\gamma_j\}$ — zero locations in, prime data out, absolutely convergent, verified to 0.1%. Section 6 of the report asserts the mirror principle: on the $D$-side (prime gaps ↔ $\gamma-\gamma'$), the logic reverses — **gap statistics are inputs to the zero spectrum**. Until now that cell of the dictionary held only citations. This note makes it quantitative with the repo's own data (exp17): (a) Montgomery's $F(\alpha)$ measured from the 100k zeros; (b) the Goldston–Montgomery variance bridge measured from the primes to $10^6$; (c) the conditional second-order gap formula — the would-be twin of Theorem D — derived in full, with the exact $F$-integrals it consumes marked, and with the precise point where "theorem" degrades to "conjecture" isolated.

All numerics: `code/exp17_dside.py`, figure `figures/exp17_dside.png`. Throughout $T=\gamma_{100000}=74920.827$, $\log T = 11.2242$, $N = N(T) = 10^5$, $X = 10^6$, $\gamma_E = 0.5772\ldots$

---

## 1. (a) Montgomery's $F(\alpha)$ from 100,000 zeros

**Definition (as computed).** With $w(u)=4/(4+u^2)$,
$$F(\alpha) \;=\; \frac1{N(T)}\sum_{0<\gamma,\gamma'\le T} T^{i\alpha(\gamma-\gamma')}\,w(\gamma-\gamma'),\qquad \alpha\in[0,3].$$
**Montgomery's theorem (proven, RH):** $F(\alpha) = T^{-2\alpha}\log T + \alpha + o(1)$ uniformly for $0\le\alpha\le 1$ (in his $(\tfrac{T}{2\pi}\log T)^{-1}$ normalization). **Montgomery's conjecture:** $F(\alpha)=1$ for $\alpha\ge1$ — equivalent to GUE pair correlation, and *not* a consequence of RH.

**Method.** Since $w(u)=\int e^{-2|s|}e^{ius}ds$ decays like $u^{-2}$, we truncate at gaps $\gamma'-\gamma\le 600$ (relative tail $\le 2\bar d\cdot 4/600 \approx 1.8\%$, and only at $\alpha\approx0$ where all phases align; negligible for $\alpha\gtrsim0.1$). The $80{,}936{,}744$ ordered pairs are binned into a $w$-weighted gap histogram at width $2.5\cdot10^{-4}$ (phase error $<4\cdot10^{-3}$ rad at $\alpha=3$), and $F(\alpha) = 1 + \frac2N\sum_k W_k\cos(\alpha\log T\, d_k)$ — the $1$ is the diagonal, exact in this normalization. We also compute the **unfolded** form: ordinates mapped by $\tilde\gamma = \bar N(\gamma)=\frac{\gamma}{2\pi}\log\frac{\gamma}{2\pi e}+\frac78$, phases $e^{2\pi i\alpha(\tilde\gamma-\tilde\gamma')}$, same $w$-weight. Unfolding matters at this height: the local density $\frac1{2\pi}\log\frac{\gamma}{2\pi}$ varies by a factor $\sim11$ across the sample, and the raw form reads all gaps at the single frequency scale $\log T$, smearing the effective $\alpha$; the finite-$T$ normalization ratio $(\tfrac{T}{2\pi}\log T)/N(T)=1.338$ measures the same mismatch.

**Results** (figure, panel a):

| $\alpha$ | 0.50 | 1.00 | 1.50 | 2.00 | 2.50 | 3.00 |
|---|---|---|---|---|---|---|
| $F$ raw | 0.652 | 1.029 | 0.996 | 1.002 | 1.004 | 1.010 |
| $F$ unfolded | 0.478 | 1.006 | 0.998 | 0.998 | 1.010 | 1.000 |
| theory | 0.500 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 |

| fit | slope on $[0.30,0.95]$ | plateau mean on $[1.05,3]$ | theory |
|---|---|---|---|
| raw | $1.155$ (intercept $+0.068$) | $1.001 \pm 0.007$ | $1,\ 1$ |
| unfolded | $1.002$ (intercept $-0.015$) | $1.009 \pm 0.020$ | $1,\ 1$ |

Reading: the **plateau** is a diagonal-dominance statement and is cleanest in the raw $N(T)^{-1}$ form — measured $1.001\pm0.007$ over $\alpha\in[1.05,3]$, i.e. the conjectured $F\equiv1$ holds at the **0.7% level across two full units of $\alpha$**. The **slope** is a density statement and is cleanest unfolded — measured $1.002$ against Montgomery's $\alpha$ (the raw slope $1.155$ sits between $\alpha$ and $1.338\,\alpha$, exactly the finite-$T$ normalization wobble; it is not a discrepancy with the theorem, whose $o(1)$'s absorb it as $T\to\infty$). The $T^{-2\alpha}\log T$ spike at $\alpha=0$ and the dip to $\approx0.3$ near $\alpha=0.25$ are both reproduced.

---

## 2. (b) The Goldston–Montgomery bridge: $\psi$-variance in short intervals

**The precise conjectural formula.** For $X^\varepsilon\le h\le X^{1-\varepsilon}$,
$$\mathrm{Var}(X,h):=\frac1X\int_0^X\bigl(\psi(x+h)-\psi(x)-h\bigr)^2dx \;\sim\; h\Bigl(\log\frac Xh + B\Bigr),\qquad B = -(\gamma_E+\log2\pi) = -2.41516\ldots$$
Provenance, carefully attributed: **Goldston–Montgomery (1987), proven under RH as an *equivalence*** — $F(\alpha)=1+o(1)$ uniformly for $1\le\alpha\le A$ (every $A$) $\iff$ $\int_1^X(\psi(x+\delta x)-\psi(x)-\delta x)^2dx\sim\frac12\delta X^2\log(1/\delta)$ for $X^{-1+\varepsilon}\le\delta\le X^{-\varepsilon}$; neither side is known unconditionally. The second-order constant $B$ is **Montgomery–Soundararajan (2004)**, under a strong Hardy–Littlewood hypothesis. The arithmetic route to $B$ is short enough to include, since it is the exact Fejér link between this section and §3. Summing over windows $(x,x+h]$, $x\le X$:
$$X\,\mathrm{Var}(X,h) \;=\; \sum_{0<|j|<h}(h-|j|)\sum_{n\le X}\Lambda(n)\Lambda(n+j)\;+\;h\sum_{n\le X}\Lambda(n)^2\;-\;h^2X\;+\;O\bigl(h^2\log^2X + hX^{1/2}\log^2X\bigr)\ \text{(RH, edges and mean recentering)}.$$
*The variance is the Fejér average in the shift $j$ of the gap correlations* — (b) and (c) are one object. Inserting $\sum_{n\le X}\Lambda(n)\Lambda(n+j)\approx\mathfrak S(j)X$ (Hardy–Littlewood, conjectural), $\sum_{n\le X}\Lambda(n)^2 = X\log X - X + O(\sqrt X\log^2X)$ (proven under RH), and the singular-series average (Friedlander–Goldston / Montgomery–Soundararajan, **proven**)
$$\sum_{0<|j|<h}(h-|j|)\,\mathfrak S(j) \;=\; h^2 - h\log h - h(\gamma_E+\log2\pi-1) + O_\varepsilon(h^{1/2+\varepsilon}),$$
the $h^2$ and $\pm1$ terms cancel and $\mathrm{Var}\sim h(\log(X/h)-\gamma_E-\log2\pi)$ drops out. That the *spectral* route (GM, via $F\equiv1$) and the *arithmetic* route (via $\mathfrak S$) give the same constant is the Bogomolny–Keating duality in miniature.

**Results** ($X=10^6$, exact sieve, figure panel b):

| $h$ | Var measured | GM/MS predicted | ratio | fitted $B$ | predicted $B$ |
|---|---|---|---|---|---|
| $10^2$ | 686.2 | 679.5 | **1.010** | $-2.348$ | $-2.415$ |
| $10^3$ | 4645.8 | 4492.7 | **1.034** | $-2.262$ | $-2.415$ |
| $10^4$ | 22022.8 | 21900.8 | **1.006** | $-2.403$ | $-2.415$ |

Global fit over 32 values $h\in[10,3\cdot10^4]$: $\ \mathrm{Var}/h = 0.983\,\log(X/h) - 2.208$ against the predicted $1.000\,\log(X/h)-2.415$. At $X=10^6$ the conjecture is verified to 1–3% per point, with the fitted constants within $0.07$–$0.21$ of $-(\gamma_E+\log2\pi)$; the residual drift is $O(X^{-1/2+\varepsilon}, h/X)$-sized, consistent with the known lower-order terms.

**The two measurements test each other.** Which $\alpha$-range of $F$ does interval length $h=X^\theta$ consume? Zeros at height $\gamma$ enter the variance with amplitude $4\sin^2(\gamma h/2X)/\gamma^2$ — the mass sits at $\gamma\lesssim X/h$ — and dyadic $x$-averaging resolves differences $|\gamma-\gamma'|\lesssim1/\log X$, which at height $T'$ is Montgomery's $F(T',\alpha)$ at $\alpha=\log X/\log T'$. The dominant block $T'\asymp X/h$ needs $\alpha^*=\frac{\log X}{\log(X/h)}=\frac1{1-\theta}$: our three $h$ probe $F$ near $\alpha^*=1.5,\ 2,\ 3$ — precisely the plateau measured in (a) at $1.001\pm0.007$. Panel (a) and panel (b) are the two ends of the same GM equivalence, both now measured in this repository, and they agree.

---

## 3. (c) The conditional gap formula: the D-side twin of Theorem D

Object: the once-Cesàro-smoothed gap count (same smoothing order as $G_1$ in Theorem D)
$$C_h(X) \;=\; \sum_{n}\Lambda(n)\Lambda(n+h)\,(X-n)_+ .$$

### 3.1 Exact decomposition (proven)

Write $r(n)=\Lambda(n)-1$, so $\Lambda(n)\Lambda(n+h) = 1 + r(n) + r(n+h) + r(n)r(n+h)$ and
$$C_h(X) = T_0 + T_1 + T_2 + B_h(X).$$
$T_0=\sum_{n\le X}(X-n) = \frac{X^2}2+O(X)$. Since $\sum_n\Lambda(n)(X-n)_+=\int_0^X\psi(t)\,dt$, integrating the explicit formula gives, **unconditionally with absolutely convergent zero sum**,
$$T_1 = \int_0^X\bigl(\psi(t)-t\bigr)dt + O(X) = -\sum_\rho\frac{X^{\rho+1}}{\rho(\rho+1)} + O(X),$$
of size $O(X^{3/2})$ under RH. The shifted layer $T_2$ equals the same sum up to $O(hX^{1/2}\log^2X + X)$ (routine: $(X+h)^{\rho+1}-X^{\rho+1}=(\rho+1)\int_X^{X+h}t^\rho dt$ plus a boundary sum controlled by $\psi(h)-h$). Hence, **proven under RH**,
$$C_h(X) = \frac{X^2}2 \;-\; 2\sum_\rho\frac{X^{\rho+1}}{\rho(\rho+1)} \;+\; B_h(X) \;+\; O\bigl(X + hX^{1/2}\log^2X\bigr),
\qquad B_h(X)=\sum_n (X-n)_+\,r(n)r(n+h).$$
This is the precise structural mirror of Theorem D: main term, single-zero layer with the *same* weights $1/\rho(\rho+1)$, and a bilinear layer. Everything so far is a theorem. Everything below is not.

### 3.2 The bilinear layer as a zero-pair form (heuristic under RH)

The density of $d\psi(t)-dt$ is $-\sum_\rho t^{\rho-1}$ plus trivial-zero terms. Inserting this **termwise** into $B_h$ — the step that is *not* justified, because the double sum is not absolutely convergent and the product of the two singular measures on the near-diagonal is exactly where the arithmetic hides (the same obstruction as the $k=0$ failure in REPORT §5) — gives
$$B_h(X) \;\approx\; \sum_{\rho,\rho'}\int_2^X (X-t)\,t^{\rho-1}(t+h)^{\rho'-1}\,dt .$$
Under RH write $\rho=\frac12+i\gamma_1$, $\rho'=\frac12+i\gamma_2$ with $\gamma_i$ of both signs. For $h\le t$, $(t+h)^{\rho'-1}=t^{\rho'-1}e^{i\gamma_2 h/t}\,(1+O(h/t))$, so each term is $\int_2^X(X-t)\,t^{-1+i(\gamma_1+\gamma_2)}e^{i\gamma_2h/t}\,dt$. Pairs of *opposite* sign, $\gamma_2=-\gamma'$ with $\gamma,\gamma'>0$, carry the **difference frequency** $\delta=\gamma-\gamma'$; same-sign pairs carry the sum frequency $\gamma+\gamma'$ and are the $S$-side leakage (below). With $t=Xv$ and the Beta evaluation $\int_0^1(1-v)v^{i\delta-1}dv = \frac1{i\delta(1+i\delta)}$, truncated at $v=2/X$:
$$\boxed{\;B_h(X)\;\approx\;2\,\mathrm{Re}\sum_{0<\gamma,\gamma'\le T_*}\mu_X(\gamma-\gamma')\,e^{-i\gamma'h/X}\,X^{1+i(\gamma-\gamma')}\;+\;\Sigma_{\rm same}\;+\;\Sigma_{\rm smooth},\;}$$
$$\mu_X(\delta) = \int_{2/X}^1(1-v)\,v^{i\delta-1}dv,\qquad |\mu_X(\delta)| \asymp \frac{\min(\log X,\;|\delta|^{-1})}{1+|\delta|}.$$
Here $e^{-i\gamma'h/X}$ stands for the $h$-modulation $e^{-i\gamma'h/t}$ frozen at the scale $t\asymp X$ carrying the Cesàro mass (leading order for $h\ll X$); $\Sigma_{\rm smooth}$ collects the sharp-endpoint terms $\sim X\,2^{i\delta}/(i\delta)$, which have frequency zero in $\log X$ and join the deterministic layer; and
$$\Sigma_{\rm same} = \mathrm{Re}\sum_{\gamma,\gamma'>0}\mu_X(\gamma+\gamma')\,e^{\mp i\gamma'h/X}X^{1+i(\gamma+\gamma')}\cdot 2,$$
suppressed only **polynomially**, $|\mu_X(\gamma+\gamma')|\asymp(\gamma+\gamma')^{-2}$. Note the asymmetry with Theorem D: there the $D$-leakage into the $S$-side identity was *exponentially* killed by $\Gamma$-weights ($e^{-\pi\min(\gamma,\gamma')}$, heat/Laplace smoothing); here the $S$-leakage into the $D$-side form dies only like $(\gamma+\gamma')^{-2}$ (Beta weights, Cesàro smoothing) and is removed by $\log X$-oscillation averaging, not by weight decay. The marginal-to-marginal segregation of Theorem B survives, but at finite $X$ it is enforced dynamically, panel (c) of the figure.

### 3.3 Where "theorem" becomes "conjecture": the convergence ledger

The twin comparison, which is the entire point:

| | $S$-side (Thm D, proven under RH) | $D$-side (this section, conjectural) |
|---|---|---|
| pair weight (**not** a form factor — see below) | $\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)$ | $\mu_X(\gamma-\gamma')\,e^{-i\gamma'h/X}$ |
| decay law | $(\gamma+\gamma')^{-5/2}$ same-sign, $e^{-\pi\min}$ opposite | $\min(\log X,|\delta|^{-1})(1+|\delta|)^{-1}$ near diagonal |
| absolute convergence | **yes** (vs pair density $T\log^2T$): a few hundred zeros suffice (exp6b used 1200) | **no**: near-diagonal mass $\sim\log X$ per pair, and pairs with $|\delta|\le1$ up to height $K$ number $\asymp K\log^2K$ — the formal sum diverges |
| what it needs | zero **locations** only | zero **correlations** at all heights: the value of the (conditionally convergent, renormalized) sum depends on the near-diagonal pair statistics — i.e. on $F$ |

> **Naming correction, 2026-08-14 (SEED-71, message 0672; applied by
> opus-orchestrator).** The row above is called a *pair weight*, and the
> resemblance to a random-matrix **form factor** is notation only. Proved,
> not asserted:
>
> - At fixed $s$, $|W(s,\delta)|^2/|W(s,0)|^2=(1+\cosh\pi s)/(\cosh\pi s+\cosh\pi\delta)
>   =1+O(e^{-2\pi\min(\gamma,\gamma')})$, which is below $3\times10^{-39}$ for
>   real zeros — the modulus is a function of $s$ alone, ~~**exactly flat on the
>   mean-spacing scale where GUE statistics live**~~ **flat on the mean-spacing
>   scale where GUE statistics live to within the bounded relative remainder
>   $O(e^{-2\pi\min(\gamma,\gamma')})$ displayed on the same line — a bound, not
>   an identity** (word "exactly" struck 2026-08-14, SEED-113, Rule K K1/K3;
>   same correction SEED-111 applied to the title of
>   `notes/SEED71_PAIR_WEIGHT_IS_NOT_A_FORM_FACTOR.md`, which this annotation
>   quotes. The struck word contradicted the formula immediately above it; the
>   conclusion below — that the row cannot see $\beta$ — is unaffected, since it
>   rests on Corollary C's support statement, which *is* exact).
> - Through §3.4's kernel identity (the only well-posed bridge), $|W(s,\cdot)|^2$
>   is analytic in $|\operatorname{Im}\delta|<1$, so all its Fourier mass sits
>   at $|\alpha|=O(1/\log T)\to0$: it probes $F$ only at the diagonal spike and
>   returns the **same value for GUE, GOE, GSE and Poisson**. It cannot see the
>   symmetry class $\beta$.
> - The mechanism is the one this corpus keeps rediscovering in other lanes:
>   RMT comparison requires the *unfolded* variable
>   $\tilde\delta=\delta\log(T/2\pi)/2\pi$, and $W$ is stated in raw $\delta$ —
>   blind to the grading, and constant once the grading is adjoined.
>
> Katz–Sarnak is the wrong authority to cite here (it concerns families, not a
> single $\zeta$). Nothing in this section's mathematics changes; what changes
> is that no later note may read this row as evidence about a symmetry class.

This is "gap statistics are inputs" made quantitative: the $S$-side bilinear form is a convergent function *of* the spectrum; the $D$-side bilinear form is a divergent expression whose renormalization *is* a correlation hypothesis. In particular the Hardy–Littlewood main term must come out of the near-diagonal: under the Bogomolny–Keating-refined pair correlation, the renormalized diagonal expectation of the boxed form equals $(\mathfrak S(h)-1)X^2/2$ — the singular series is stored in the fine structure of the zero gaps, and conversely. Defining the genuinely oscillatory second-order term
$$\Delta_h(X) \;:=\; C_h(X) - \mathfrak S(h)\frac{X^2}2 + 2\sum_\rho\frac{X^{\rho+1}}{\rho(\rho+1)},$$
the **conjectural D-twin of Theorem D** reads: under RH + strong pair correlation, $\Delta_h(X)$ is the fluctuating part of the boxed near-diagonal form, of conjectured size $O_\varepsilon(X^{3/2+\varepsilon})$ (matching the single-zero layer, square-root cancellation in the pair sum), with dyadic mean square given by a **difference-side additive energy** $\sum_{\gamma_1-\gamma_2\approx\gamma_3-\gamma_4}\mu\bar\mu\,\widehat\Phi(\cdots)$ — the exact mirror of Theorem D″.

### 3.4 Exactly which integrals of $F$ it needs

**Kernel identity (proven; Fubini + definition of $F$).** For $r(u)=\int \hat r(\alpha)\,T^{i\alpha u}d\alpha$ with $\hat r\in L^1$,
$$\sum_{0<\gamma,\gamma'\le T} r(\gamma-\gamma')\,w(\gamma-\gamma') \;=\; N(T)\int_{-\infty}^{\infty}\hat r(\alpha)\,F(\alpha)\,d\alpha .$$
Montgomery's theorem evaluates the right side unconditionally **only when $\hat r$ is supported in $|\alpha|<1$**. Now compute $\hat r$ for our kernel $r(u)=X^{iu}\mu_X(u)$ (take $T=X$; removing the $w$-weight costs a standard partial-summation step since $\mu_X$ decays exactly at the borderline rate $u^{-2}$). Substituting $v=e^{-\beta}$,
$$\mu_X(u)=\int_0^{\log(X/2)}\!\!(1-e^{-\beta})e^{-i\beta u}d\beta
\;\Longrightarrow\;
\hat r(\alpha) = \log X\,\bigl(1 - X^{-(1-\alpha)}\bigr)\ \ \text{for}\ \tfrac{\log2}{\log X}\le\alpha\le1,\quad 0\ \text{else}.$$
So the Cesàro kernel's spectral profile is a one-sided plateau of height $\log X$ ramping down to $0$ across the window $1-\alpha\lesssim 1/\log X$: **the second-order gap term consumes $F$ at the edge $\alpha=1^-$ at resolution $1/\log X$, and through the total mass it needs $\int_0^1F(\alpha)\,d\alpha$ to accuracy $o(1/\log X)$** — strictly beyond Montgomery's theorem, whose error is only $o(1)$. That is the precise mechanism by which the second-order term is conjectural *even under RH*: the proven region ends exactly where the $\log X$ weight concentrates. The $h$-modulation $e^{-i\gamma'h/X}$ then couples heights $\gamma'\lesssim X/h$, pushing the demand across $\alpha=1$ into the plateau: as in §2, dyadic height blocks $T'$ require $F(T',\alpha)$ at $\alpha=\log X/\log T'$, dominantly $\alpha^*=1/(1-\theta)$ for $h=X^\theta$, with exponentially decaying demand at larger $\alpha$. Summary of required spectral input:

1. $F(\alpha)$ on $[1-O(1/\log X),\,1]$ at resolution $1/\log X$ — edge of the proven region (single-zero-layer interface);
2. $\int_0^1 F(\alpha)\,d\alpha$ to $o(1/\log X)$ — beyond the proven $o(1)$;
3. the plateau $F(T',\alpha)=1$ for $1\le\alpha\le 1/(1-\theta)+o(1)$, uniformly in dyadic $T'\le X/h$ — Montgomery's conjecture, measured in §1 at $1.001\pm0.007$;
4. for the singular series $\mathfrak S(h)$ itself (not just the smooth variance constant): the arithmetic fine structure of $F$ beyond the plateau (Bogomolny–Keating), strictly stronger than 3.

Items 1–2 are why no unconditional theorem exists; item 3 is what panels (a)+(b) jointly verify; item 4 is the BK duality — the same duality that made the two derivations of $B=-(\gamma_E+\log2\pi)$ in §2 agree.

### 3.5 Proven vs conjectural, in one list

- **Proven (unconditional):** the decomposition §3.1 with absolutely convergent single-zero layer; the kernel identity §3.4; Montgomery's $F(\alpha)=T^{-2\alpha}\log T+\alpha+o(1)$ on $[0,1]$ *under RH*; the singular-series average of §2.
- **Proven under RH:** sizes $O(X^{3/2})$ of the single layer; the GM *equivalence* (either side implies the other).
- **Heuristic (standard but unjustified):** termwise squaring of the explicit formula in §3.2; freezing $e^{-i\gamma_2h/t}$ at $t\asymp X$; removal of the $w$-weight.
- **Conjectural:** $F\equiv1$ for $\alpha\ge1$ (items 3); $\int_0^1F$ to $o(1/\log X)$ and edge behavior (items 1–2); Hardy–Littlewood/BK (item 4); $\Delta_h\ll X^{3/2+\varepsilon}$.

---

## 4. The dictionary, now with data on both diagonals

REPORT §5.1, updated. New measured entries in bold; both diagonal cells now carry numbers produced by this repository.

| | prime-side $S$ (Goldbach) | prime-side $D$ (gaps) |
|---|---|---|
| **zero-side $S$** ($\gamma+\gamma'$) | Fujii/LZ; Thm D, D″. *Measured (exp6b):* spectral lines at $\gamma_i+\gamma_j$, corr $0.9999$, amplitude ratio $0.9991$; weight slope $-2.500$ vs $-5/2$. | leakage into gap formula only $(\gamma+\gamma')^{-2}$-suppressed (§3.2) — segregation by $\log X$-averaging, not weight decay |
| **zero-side $D$** ($\gamma-\gamma'$) | leakage into Thm D exponentially killed, $e^{-\pi\min(\gamma,\gamma')}$ | Montgomery PC; GM equivalence; MS constant. **Measured (exp17):** $F$ plateau $1.001\pm0.007$ on $\alpha\in[1.05,3]$ (raw), slope $1.002$ (unfolded); $\mathrm{Var}/h = 0.983\log(X/h)-2.208$ vs predicted $1.000\log(X/h)-2.415$, per-$h$ ratios $1.010/1.034/1.006$ at $h=10^{2,3,4}$ |

The asymmetry between the two diagonal cells is now itself measured. $S$-diagonal: absolutely convergent weights, RH-only, agreement at $10^{-3}$–$10^{-4}$ — the zeros *output* Goldbach data. $D$-diagonal: divergent-without-correlations weights, agreement at $10^{-2}$ and *conditional on the very statistics being tested* — the primes' gap data and the zeros' gap data are two measurements of one conjectural object ($F$), consistent at 1–3% at $X=10^6$, $T=\gamma_{10^5}$. The $D$-side of this repo now holds data, not just citations.
