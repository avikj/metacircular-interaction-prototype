# The product-weighted pair object: carrier, positivity, and the variance program in the factorized metric

**Task:** STATE.md target 1 — the corrected form of the refuted conjecture APPENDIX_D.md §D.6(3),
per the program of `SCREW.md` §4, item 1, revised mid-task by the landing of
`PRODUCT_WEIGHT_NO_GO.md` (independently verified in §1 below).
**Code:** `code/exp20_product.py` → `figures/exp20_product.png`.

Throughout, RH is assumed where stated; $\rho=\tfrac12+i\gamma$ with $\gamma$ ranging over
**signed** ordinates, and

$$a(\gamma)\;=\;\frac{1}{\gamma^2+\tfrac14}\;=\;\frac{1}{\rho(1-\rho)}\Big|_{\mathrm{RH}}\;>\;0,
\qquad B:=\sum_\gamma a(\gamma)=2+\gamma_E-\log 4\pi=0.046191\ldots,$$

the Matsumoto–Suzuki screw masses (`SCREW.md` §1). Set
$h(u):=\sum_\gamma a(\gamma)e^{i\gamma u}=2\sum_{\gamma>0}\frac{\cos\gamma u}{\gamma^2+\frac14}$
(real, even, $h(0)=B$; absolutely and uniformly convergent), and

$$m_0:=\sum_\gamma a(\gamma)^2,\qquad S_4:=\sum_\gamma a(\gamma)^4 .$$

The MS screw function is $g_{H_1}=h-B$ with positive spectral measure
$\mu_1=\sum_\gamma a(\gamma)\delta_\gamma$ on single frequencies. The target is the
**product measure on the sum spectrum**,

$$\mu_2\;:=\;\mu_1*\mu_1\;=\;\sum_{\gamma,\gamma'}a(\gamma)a(\gamma')\,\delta_{\gamma+\gamma'},$$

positive with total mass $B^2$, and the questions: (1) which two-variable arithmetic object
carries it exactly; (2) what the Appendix-D variance program becomes in this metric;
(3) numerical certification.

---

## 1. Verification of the no-go (`PRODUCT_WEIGHT_NO_GO.md`, Theorem 2.1), and a strengthening

Before the no-go note landed, we had independently derived the same obstruction in the form
of a lemma: for **any** kernel depending on $m+n$ alone, the substitution $u=rt$, $v=r(1-t)$
(Jacobian $r$) gives

$$\int_0^\infty\!\!\int_0^\infty k\Bigl(\frac{u+v}{X}\Bigr)u^{z-1}v^{w-1}\,du\,dv
= X^{z+w}\,B(z,w)\,\widehat k(z+w),$$

so the Euler Beta coupling $B(z,w)=\Gamma(z)\Gamma(w)/\Gamma(z+w)$ is **intrinsic to additive
smoothing** — this is their §1, confirmed. Their Theorem 2.1 we verified line by line:
with $b=a/\Gamma$, $F=\widehat k/\Gamma$, the factorization hypothesis becomes
$b(z)b(w)=F(z+w)$ after cancelling the zero-free factors $\Gamma(z)\Gamma(w)$;
$\partial_z\log$ and $\partial_w\log$ give $b'/b(z)=F'/F(z+w)=b'/b(w)$ on an open product
set, forcing $b'/b$ constant on a subdomain avoiding the discrete zero/pole sets, hence
$b(z)=Ae^{\alpha z}$, $\widehat k(s)=A^2e^{\alpha s}\Gamma(s)$, $k(r)=A^2e^{-e^{-\alpha}r}$,
extended by analytic continuation. **The proof is airtight; no hole found.** Their §3
computation $b'/b=-\psi(z)-1/z+1/(1-z)\neq\mathrm{const}$ for the MS weight is also correct.

**Strengthening (new).** Within the *classified* family the critical-line masses are
$a(\rho)=Ae^{\alpha/2}e^{i\alpha\gamma}\Gamma(\tfrac12+i\gamma)$. Since
$\arg\Gamma(\tfrac12+i\gamma)$ (the Riemann–Siegel-type phase, $\sim\gamma\log\gamma$) is not
linear in $\gamma$, no choice of $A,\alpha$ makes these masses positive — or even real — on
the line. Hence:

> **Corollary 1.1.** No homogeneous kernel of $(m+n)/X$ has a two-zero sector with
> *positive* factorized masses of **any** form, MS or otherwise. Positivity of a factorized
> pair measure forces a **non-radial (separable) carrier**.

The same functional-equation argument disposes of the max/min-type radial variants
($a(z)=e^{cz}/z$, also complex-phased on the line). So the constructive task is fixed by
necessity, not by convenience: the carrier of $\mu_2$ must be a rank-one (per-variable)
weight, and the only freedom is *which* one-body kernel produces the masses $1/(\rho(1-\rho))$.

---

## 2. Route (a): the exact separable carrier

### 2.1 The Mellin kernel with $k(\rho)=1/(\rho(1-\rho))$ is the Kreĭn string kernel

$$\boxed{\;\int_0^\infty \min(X,t)\,t^{s-2}\,dt \;=\; \frac{X^s}{s(1-s)},\qquad 0<\operatorname{Re}s<1\;}$$

(split at $t=X$: $\int_0^X t^{s-1}dt=X^s/s$ and $X\int_X^\infty t^{s-2}dt=X^s/(1-s)$).
Equivalently, on the scale $v=t/X$ the kernel is $\min(1,1/v)$ with
$\widetilde k(s)=\frac1s+\frac1{1-s}=\frac{1}{s(1-s)}$, each piece convergent in its own
half-plane. This is exactly the hinted $\min(u,v)$-object: $G(x,y)=\min(x,y)$ is the Green
kernel of $-d^2/dx^2$ on $(0,\infty)$ with Dirichlet boundary at $0$ — the free **Kreĭn
string** — and $1/(s(1-s))$ is its Mellin symbol. The MS masses are string spectral masses;
this is the structural reason the symmetrization $\rho(\rho+1)\to\rho(1-\rho)$ of
`SCREW.md` §1 produces a screw function. In log variables $u=\log X$, $v=\log n$ the weight
is $\min(1,X/n)=e^{-(v-u)_+}$: a one-sided exponential Cesàro window — the min-kernel *is*
the natural "Cesàro variant" for this problem.

Note the sanity check against Theorem 2.1's classified family: the heat kernel
$e^{-cn/X}$ has one-body coefficient $\Gamma(z)$ (complex-phased); the min-kernel is not
radial in $u+v$ when squared, so it is not — and cannot be — in the classified family.

### 2.2 The compensated one-body sum $\Phi$

The naive sum $\sum_n\Lambda(n)\min(1,X/n)=\psi(X)+X\sum_{n>X}\Lambda(n)/n$ diverges: the
kernel's tail is not integrable against the *density* term $d t$ of $d\psi$ (the pole of
$-\zeta'/\zeta$ at $s=1$ collides with the pole of $\widehat k$ at $s=1$). The main term
must be subtracted inside the sum. Define

$$\boxed{\;\Phi(X)\;:=\;X\int_X^\infty\bigl(\psi(t)-t\bigr)\,\frac{dt}{t^{2}}\;}$$

The integral converges unconditionally (PNT with the de la Vallée Poussin error:
$\int^\infty e^{-c\sqrt{\log t}}\,dt/t<\infty$; under RH absolutely, $O(X^{-1/2}\log^2X)$).

**Theorem P1 (unconditional explicit formula; absolutely convergent).** For $X\ge2$,

$$\Phi(X)\;=\;-\sum_\rho\frac{X^{\rho}}{\rho(1-\rho)}\;-\;\log 2\pi\;+\;\delta(X),
\qquad 0<\delta(X)<\tfrac13X^{-2},$$

where the sum over nontrivial zeros converges **absolutely** even without RH
($1/|\rho(1-\rho)|\le\gamma^{-2}$), and
$\delta(X)=-X\int_X^\infty\tfrac12\log(1-t^{-2})\,t^{-2}dt$.

*Proof.* Insert the truncated explicit formula
$\psi(t)=t-\sum_{|\gamma|\le T}t^\rho/\rho-\log2\pi-\tfrac12\log(1-t^{-2})+R(t,T)$,
$R\ll t\log^2(tT)/T+\log t$, into $X\int_X^Y(\psi(t)-t)t^{-2}dt$. The error integrates to
$O(\log^2(YT)\log Y/T)\to0$ as $T\to\infty$ for fixed $X\le Y$. Term by term,
$X\int_X^Y t^{\rho-2}dt/\rho = \bigl(X^{\rho}-XY^{\rho-1}\bigr)/(\rho(1-\rho))$; the sum over
$\rho$ is dominated by $\sum\gamma^{-2}<\infty$, and each $Y^{\rho-1}\to0$ as $Y\to\infty$
(no zeros on $\operatorname{Re}s=1$), so by dominated convergence the $Y$-boundary terms
vanish. The $-\log2\pi$ term integrates to $-\log2\pi\,(1-X/Y)\to-\log2\pi$, and the trivial
zeros give $\delta(X)$, with $0<-\tfrac12\log(1-t^{-2})<t^{-2}$ for $t\ge2$. $\square$

**Arithmetic form.** Evaluating the truncated integral exactly (used verbatim in `exp20`):
with $S_\ell(y):=\sum_{n\le y}\Lambda(n)/n$,

$$\Phi_N(X):=X\int_X^N(\psi(t)-t)\frac{dt}{t^2}
=\psi(X)+X\bigl(S_\ell(N)-S_\ell(X)\bigr)-\frac{X}{N}\psi(N)-X\log\frac NX,$$

and $\Phi(X)-\Phi_N(X)=X c_N$ with $c_N=\int_N^\infty(\psi(t)-t)t^{-2}dt$ — the truncation
deficit is **exactly linear in $X$** (this is what makes the numerics of §5 clean). Letting
$N\to\infty$,

$$\Phi(X)=\lim_{N\to\infty}\Bigl[\sum_{n\le N}\Lambda(n)\min\bigl(1,\tfrac Xn\bigr)
-X\bigl(\log\tfrac NX+1\bigr)\Bigr].$$

**Corollary P1′ (RH form; relation to MS).** Under RH,
$\Phi(X)=-\sqrt X\,h(\log X)-\log2\pi+\delta(X)$; equivalently
$\Phi(X)=-\sqrt X\,H_1(X)-\log2\pi+\delta(X)$ with MS's
$H_1(X)=\sum_\rho X^{\rho-1/2}/(\rho(1-\rho))$. So $\Phi$ is a second, cleaner arithmetic
carrier of the MS screw data $H_1$ — one-body, with explicit $O(X^{-2})$ error — alongside
their Goldbach-side carrier [MS (1.6)] which needs the constants $c_2$, $E(X)$.

### 2.3 The doubly-reweighted pair sum and the exact four-layer identity

By Corollary 1.1 the pair carrier must be separable; the canonical choice is the square.
Define the **doubly-reweighted Goldbach pair sum** with rank-one weights
$w_X(m,n)=\min(1,X/m)\min(1,X/n)$:

$$G_w(X):=\lim_{N\to\infty}\Bigl[\sum_{m,n\le N}\Lambda(m)\Lambda(n)\,w_X(m,n)
-2X\bigl(\log\tfrac NX+1\bigr)\!\!\sum_{n\le N}\Lambda(n)\min\bigl(1,\tfrac Xn\bigr)
+X^2\bigl(\log\tfrac NX+1\bigr)^2\Bigr]\;=\;\Phi(X)^2 .$$

Note that on the square $\{m,n\le X\}$ the weight is identically $1$: $G_w$ is the
compensated completion of the *sharp* pair count $\psi(X)^2$ by its reweighted corner tails.
It is a genuine two-variable prime-pair statistic — the rank-one pair field
$a\otimes a$ of `pairfield.py` — but **not** a function of $m+n$; by §1 no such function
exists for these weights.

**Theorem P2 (exact layer decomposition).** Assume RH. For $X\ge2$,

$$G_w(X)\;=\;\underbrace{m_0\,X}_{\text{main}}
\;+\;\underbrace{X\!\!\sum_{\substack{\gamma,\gamma'\\ \gamma+\gamma'\neq0}}\!\!
a(\gamma)a(\gamma')\,e^{i(\gamma+\gamma')\log X}}_{\text{product pair layer, masses }>0}
\;+\;\underbrace{2\log(2\pi)\,\sqrt X\,h(\log X)}_{\text{first variation = MS screw data}}
\;+\;\underbrace{\log^2 2\pi+O(X^{-1/2})}_{\text{smooth}} .$$

*Proof.* Square Corollary P1′: $\Phi^2=Xh^2+2\log2\pi\sqrt Xh+\log^22\pi
+\delta(\delta-2\sqrt Xh-2\log2\pi)$, and $|h|\le B$ bounds the last term by
$O(X^{-3/2})$. Expand $h(u)^2=\sum_{\gamma,\gamma'}aa'e^{i(\gamma+\gamma')u}$; the
zero-frequency pairs are exactly $\gamma'=-\gamma$ (no linear-independence input needed),
contributing $\sum_\gamma a(\gamma)a(-\gamma)=m_0$. $\square$

Three structural remarks. (i) The **main term is the diagonal**: $m_0X$ is the DC mass of
$\mu_2$, i.e. the mean of the pair layer is *positive* — in the Beta metric the DC mass is
exponentially small. (ii) The pair layer is $X\,(h^2-m_0)$ with $h^2\ge0$ pointwise: the
oscillation is **one-sided** about its mean. (iii) The first variation reappears inside the
square with coefficient $2\log2\pi$ — the cross term of the archimedean constant with the
zero layer.

### 2.4 The correct Kreĭn-square and the screw theorem (corrected D.6(3))

The naive square $g_{H_1}^2=(h-B)^2$ has spectral measure
$\mu_2-2B\mu_1+B^2\delta_0$ — **signed** (single-frequency masses $-2Ba(\gamma)<0$), so it
is *not* the canonical object. The correct Kreĭn-square is

$$g_2(t)\;:=\;h(t)^2-h(0)^2\;=\;\int_{\mathbb R}\bigl(e^{i\omega t}-1\bigr)\,d\mu_2(\omega)
\;=\;g_{H_1}(t)^2+2B\,g_{H_1}(t),$$

whose spectral measure is exactly $\mu_2=\mu_1*\mu_1$, with $g_2(0)=0$.

**Theorem P3 (RH $\Rightarrow$ screw property of the product pair layer).** Under RH, $g_2$
is a screw function: it is continuous, real and even, and its Kreĭn kernel
$G_{g_2}(t,u)=g_2(t-u)-g_2(t)-g_2(-u)+g_2(0)$ is nonnegative definite.

*Proof.* Continuity and symmetry from uniform convergence and evenness of $h$. For the
kernel, since $\mu_2$ is a finite positive measure ($\mu_2(\mathbb R)=B^2$),

$$\sum_{i,j}G_{g_2}(t_i,t_j)\,\xi_i\bar\xi_j
=\int_{\mathbb R}\Bigl|\sum_i\bigl(e^{i\omega t_i}-1\bigr)\xi_i\Bigr|^2 d\mu_2(\omega)\;\ge\;0,$$

the Hermitian-square identity, now over the **sum spectrum**. Positivity of $\mu_2$ is the
corollary structure announced in `SCREW.md` §4.1: $\mu_1\ge0$ (MS theorem under RH) and
convolution preserves positivity; equivalently $h(t-u)$ is a positive-definite function
(Bochner, $\mu_1\ge0$) and so is its square (Schur product theorem). $\square$

*Remark (converse).* If some zero has $\beta>\tfrac12$, $h$ acquires terms
$\asymp e^{(\beta-1/2)|t|}$ whose almost-periodic coefficient does not vanish identically,
so $h^2$ grows like $e^{2(\beta-1/2)|t|}$ along a sequence and $\operatorname{Re}g_2$ is
unbounded, contradicting the screw property by the boundedness argument of [MS Cor. 3.1].
So $g_2$ screw $\iff$ RH, with the RH-detection already carried by the one-body factor —
consistent with the "RH content is saturated at first order" principle of `SCREW.md` §4.3.

**What does positivity say beyond one-body data?** Honestly: nothing about prime *pairs*.
$G_w=\Phi^2$ is one-body-squared; its positivity theorem is a theorem about $\mu_1$. Its
value is different: it is the **model metric in which the Appendix-D variance program
closes** (§3), it supplies unconditional lower bounds with explicit constants (§3, §5), and
it isolates exactly what the genuine (Beta-coupled) Goldbach layer still lacks (§4).

---

## 3. The Appendix-D variance program in the product metric

Let $A_2(u):=h(u)^2=\int e^{i\omega u}d\mu_2$ (the pair layer of $X^{-1}G_w(e^u)$, DC
included), and as in `APPENDIX_D.md` D.1 fix the Fejér window
$\phi_L(u)=(1-|u|/L)_+$, $\widehat\phi_L(\delta)/L=\mathrm{sinc}^2(L\delta/2)\in[0,1]$, and

$$V(u_0,L):=\frac1L\int_{\mathbb R}\bigl|A_2(u_0+u)\bigr|^2\phi_L(u)\,du
=\sum_{\gamma_1,\gamma_2,\gamma_3,\gamma_4}a_1a_2a_3a_4\;e^{i\delta u_0}\,
\mathrm{sinc}^2(L\delta/2),\qquad \delta=\gamma_1+\gamma_2-\gamma_3-\gamma_4,$$

the quadruple sum converging absolutely ($\sum a_1a_2a_3a_4=B^4$), **with all weights
positive** — the complex phases $\Gamma(\rho)$ of the Beta metric are gone. Define the
near-diagonal energy at resolution $\eta$ (the analogue of D.2):
$E^\circ_a(\eta)=\sum_{0<|\delta|\le\eta}a_1a_2a_3a_4$.

**Theorem P4 (variance $\asymp$ diagonal, product metric).** Assume RH.

**(a) Free lower bound at every finite $L$ (new; impossible in the Beta metric).**
Since $\phi_L(u)\,du/L$ is a probability measure and $|A_2|^2=h^4$, Cauchy–Schwarz/Jensen
gives, for every $u_0$ and every $L>0$,
$$V(u_0,L)\;\ge\;M_L(u_0)^2,\qquad
M_L(u_0):=\frac1L\int h^2(u_0+u)\phi_L(u)\,du
= m_0+\!\!\sum_{\gamma+\gamma'\neq0}\!\!aa'e^{i(\gamma+\gamma')u_0}\mathrm{sinc}^2(\ldots),$$
and $|M_L-m_0|\le\varepsilon(L):=\sum_{\gamma'\neq-\gamma}aa'\,
\mathrm{sinc}^2\bigl(L(\gamma+\gamma')/2\bigr)\to0$ as $L\to\infty$, **uniformly in $u_0$
and with no separation hypothesis** (dominated convergence against $B^2<\infty$). Hence
$V\ge(m_0-\varepsilon(L))^2$ for all $u_0,L$: positivity delivers the lower bound for free.

**(b) The limit is the diagonal; exact resonances can only help.** By dominated convergence
on the absolutely convergent quadruple sum,
$\lim_{L\to\infty}V(u_0,L)=\sum_{\delta=0}a_1a_2a_3a_4$, uniformly in $u_0$. The trivial
solutions of $\gamma_1+\gamma_2=\gamma_3+\gamma_4$ are
$(\gamma_3,\gamma_4)=(\gamma_1,\gamma_2)$, $(\gamma_2,\gamma_1)$, and the DC family
$\gamma_2=-\gamma_1\wedge\gamma_4=-\gamma_3$; inclusion–exclusion (pairwise overlaps each
$S_4$, triple overlap empty) gives
$$D_0\;=\;3\,(m_0^2-S_4),$$
the Wick/Gaussian factor $3$ for a real trigonometric sum. Any *nontrivial* additive
relation among ordinates adds a **positive** term: in this metric violations of linear
independence only increase the variance, whereas in the Beta metric they enter with
Riemann–Siegel phases and unknown sign. Thus $\lim V\ge D_0$ always, $=D_0$ iff no
nontrivial relations.

**(c) Rate under the same separation input as D.4.** Splitting off-diagonal terms
dyadically in $|\delta|$ exactly as D.3 (no absolute values needed — the weights are their
own absolute values):
$$\bigl|V(u_0,L)-D_0\bigr|\;\le\;E^\circ_a(1/L)+\sum_{k\ge0}4^{-k}E^\circ_a(2^{k+1}/L)
\;+\;(\text{nontrivial-resonance mass, }\ge0\text{ in }V).$$
If $E^\circ_a(1/L)=o(m_0^2)$ — the product-metric form of the near-diagonal separation
hypothesis, cf. `ENERGY.md`'s measured law $E^\circ(\delta)\approx2.8\,\delta\cdot\Sigma$ —
then $V=D_0(1+o(1))$ **uniformly in $u_0$, with no averaging over $u_0$** (D.4 needed a
unit average in $u_0$ to control phases; here only the lower-order off-diagonal does).

**(d) Ω-results with explicit constants.** From (a), $\limsup_u h(u)^2\ge m_0$, so
$$\limsup_{X\to\infty}\frac{|\Phi(X)|}{\sqrt X}\;\ge\;\sqrt{m_0}\;=\;0.00861\ldots,
\qquad
\limsup_{X\to\infty}\frac{G_w(X)}{X}\;\ge\;2m_0-\text{(mean)}\;\ge m_0,$$
and the pair layer $X(h^2-m_0)$ oscillates one-sidedly: $G_w$'s zero layer dips below its
mean by at most $m_0X+O(\sqrt X)$ but can exceed it without bound relative to $m_0$. $\square$

**Scorecard vs. `APPENDIX_D.md` (Beta metric).**

| item | Beta metric (D.2–D.4) | product metric (P4) |
|---|---|---|
| lower bound at finite $L$ | needs separation + unit $u_0$-average | free (Jensen), every $L$, every $u_0$ |
| exact resonances (LI violations) | unknown sign | strictly increase $V$ |
| upper/lower energy functional | $E_W$ with $\vert W\bar W\vert$ vs signed sum | one positive $E_a$ for both |
| diagonal | $2\sum\vert W_{12}\vert^2$, Beta-coupled | $3(m_0^2-S_4)$, factorized closed form |
| DC of pair layer | $e^{-\pi\gamma}$-small | $m_0>0$ = main term of $G_w$ |
| still open | 4-point near-diagonal separation | the **same** hypothesis (only for rates) |

The genuinely open input — near-diagonal separation of $\{\gamma_i+\gamma_j\}$ — is
untouched, as `SCREW.md` §4.3 predicted it must be (positivity is a 2-point statement). But
it is now needed *only for the rate in the upper bound*; every lower bound is free.

---

## 4. Route (b): the Schur-multiplier bridge to the true Goldbach weights

The Theorem-D pair layer has weights $W(\gamma,\gamma')=C(\rho,\rho')\,a(\gamma)a(\gamma')$
with coupling
$$C(\rho,\rho')=\rho(1-\rho)\rho'(1-\rho')\,
\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)},\qquad
|C|\asymp\frac{(\gamma\gamma')^2}{(\gamma+\gamma')^{5/2}}\ \ (\gamma,\gamma'>0\to\infty),$$
by Stirling ($|\Gamma(\sigma+it)|\sim\sqrt{2\pi}|t|^{\sigma-1/2}e^{-\pi|t|/2}$), with
Riemann–Siegel phases $\arg C$. On a dyadic block ($\gamma_i\in[T,2T]$, all four, same
sign class) $|C|\asymp T^{3/2}$ with absolute implied constants.

**Proposition R1 (the separation hypothesis is metric-independent).** For every $\eta>0$
and dyadic $T$, restricting all four ordinates to a same-sign dyadic block,
$$E^\circ_W(\eta;T)\;\asymp\;T^{3}\,E^\circ_a(\eta;T),$$
since $E^\circ$ sums absolute values and $|W_{12}\overline{W_{34}}|=|C_{12}||C_{34}|
(aa)_{12}(aa)_{34}$ with $|C|\asymp T^{3/2}$ blockwise. Hence the near-diagonal separation
hypothesis of D.4 holds in the Beta metric iff it holds in the product metric (blockwise
weighted); the phases of $C$ are invisible at this level. (The opposite-sign sector exists
only in the product metric — full mass $aa'$ on difference frequencies $|\gamma-\gamma'|$ —
where it is positive and harmless; in the Beta metric it is $e^{-\pi\min(\gamma,\gamma')}$-
suppressed, cf. Thm D′.)

**Consequence (the join, precisely).** The D.3/D.4 off-diagonal machinery uses only
absolute values, so by R1: *under RH + product-metric separation, the Beta-metric variance
also satisfies $V_W\asymp\sum|W_{12}|^2$* — Theorem D″ and Theorem P4(c) close under **one
and the same** zero-separation statement. What the multiplier $C$ destroys is exactly and
only the *unconditional* (Jensen) lower bound: with phases, $\inf$ over phase
configurations of the quadratic form can dip below the diagonal unless the near-diagonal
mass is small — i.e. the free-positivity layer of §3 is metric-specific, the conditional
layer is not. This is the precise content of the "Schur-multiplier route" flagged in
`SCREW.md` §4.2: $C$ is blockwise bounded (after the $T^{3/2}$ normalization) as an $L^2$
multiplier, and no pointwise-positivity statement about it is needed or possible
(`exp12` Part 4; §1 above).

---

## 5. Numerical verification (`code/exp20_product.py`, $\Lambda$ to $2\cdot10^6$, first $10^4$ zeros)

Grid: $X\in[3\cdot10^3,1.5\cdot10^6]$, $M=4096$ log-uniform points. Arithmetic side
computed by the **exact** finite form $\Phi_N$ of §2.2; the deficit $Xc_N$ and the constant
$-\log2\pi$ are removed by least squares on the exact smooth span $\{X,\sqrt X,1\}$;
residual $r$, $q:=-r/\sqrt X$ (arithmetic estimate of $h$), $P:=q^2$ (arithmetic estimate
of the pair layer $h^2$). The zero-side model is pushed through the **identical pipeline**
(shared detrending systematics), plus a raw-$h^2$ comparison.

Spectral constants ($10^4$ zeros): $B=0.045922$ (exact $0.046191$; tail as in `SCREW.md`),
$m_0=7.4201\cdot10^{-5}$, $S_4=1.320\cdot10^{-9}$, $D_0=3(m_0^2-S_4)=1.2559\cdot10^{-8}$,
$\sqrt{m_0}=0.008614$.

**Part 1 — first variation (MS screw data) in the min-kernel.** Band $[8,26.5]$ in
$\log X$ (single lines $\gamma_1..\gamma_3$ only): corr(arithmetic $q$, zero-side $h$)
$=\mathbf{1.000000}$, amplitude ratio $\mathbf{1.000000}$. ($\Phi$ is a cleaner carrier of
$H_1$ than the exp12 Part-5 route: no fitted $c_2$, error $O(X^{-2})$.)

**Part 2 — the product identity (headline).** Sum-spectrum band $[28,60]$
(pair lines $2\gamma_1=28.27$, $\gamma_1+\gamma_2=35.16$, $\gamma_1+\gamma_3=39.15$,
$2\gamma_2=42.05,\dots$):

| comparison | corr | amplitude ratio |
|---|---|---|
| $P$ vs. pipeline model | **1.000000** | 0.999999 |
| $P$ vs. raw $h^2$ | **0.999724** | 1.001227 |

Target was corr $>0.99$; the identity holds at the precision floor of the method (the only
unmodeled pieces are $O(X^{-2})$ trivial-zero terms and out-of-band zero truncation). The
positive DC prediction of Theorem P2: mean $P=7.514\cdot10^{-5}$ vs. mean
$h^2=7.483\cdot10^{-5}$ (ratio $1.0041$) vs. $m_0=7.420\cdot10^{-5}$. Parseval closure in
the new metric: band RMS data $6.163\cdot10^{-5}$ vs. model $6.155\cdot10^{-5}$.

**Part 3 — Kreĭn positivity (Theorem P3), corrected D.6(3).** Kernel of $g_2$: uniform
grid $n=160$, $T=40$: min eig $+9.77\cdot10^{-4}$, $\lambda_{\min}/|\lambda|_{\max}
=+2.99\cdot10^{-3}$; $T=12$: $+3.22\cdot10^{-3}$; five random grids: worst ratio $\ge0$ at
machine precision — **PSD**. Control (refuted original conjecture): the Beta pair layer
$A(u)$ on the same machinery: $\lambda_{\min}/|\lambda|_{\max}=-1.00$, maximally indefinite,
reproducing `exp12` Part 4.

**Part 4 — the two measures on the sum spectrum $[20,100]$** (binned at $0.02$, 300 zero
pairs, all sign classes): product measure: 3830 lines, **all masses positive** (min
$+2.6\cdot10^{-11}$, exactly real); Beta measure: 2626 lines, 50% with
$\operatorname{Re}<0$, mean $|\mathrm{Im}|/|\text{mass}|=0.64$.

**Part 5 — variance $\to$ diagonal with the free floor (Theorem P4).** $V(L)$ by direct
integration (3000 zeros, $u_0=12$): $V(L)/D_0\in[0.97,1.05]$ for $L\in\{4,\dots,128\}$, and
the Jensen floor $V\ge M_L^2$ holds at **every** $L$ (margin $\approx D_0/m_0^2\approx2.3$,
i.e. the floor is $\tfrac13D_0$ up to $S_4$). The $2$–$5\%$ excess over $D_0$ at large $L$
is the near-diagonal energy at resolution $1/L$ — the same $E^\circ(\delta)\propto\delta$
law measured in `ENERGY.md`, now with positive weights.

Figure `figures/exp20_product.png`: (a) first variation, arithmetic vs. zero side,
indistinguishable; (b) the pair layer of $\Phi^2$ vs. the product model, band $[28,60]$;
(c) the two measures — signed Beta cloud vs. strictly positive product cloud; (d) $V(L)$
against $D_0$ and the Jensen floor.

---

## 6. Verdict on Target 1

1. **Identity found and proved.** The product-weighted pair measure
   $\sum a(\gamma)a(\gamma')\delta_{\gamma+\gamma'}$ is carried exactly by the
   doubly-reweighted, compensated pair sum $G_w(X)=\Phi(X)^2$ with separable min-kernel
   weights $\min(1,X/m)\min(1,X/n)$ (Theorems P1–P2), where
   $\Phi(X)=X\int_X^\infty(\psi(t)-t)t^{-2}dt$. By the (verified) no-go this separability
   is forced, not chosen: no kernel of $m+n$ can do it, and (Corollary 1.1, new) no radial
   kernel yields *any* positive factorized weights. The Mellin kernel answering the task's
   question — $k(s)=1/(s(1-s))$ — is the Kreĭn string kernel $\min(X,t)$.
2. **Corrected conjecture proved.** $g_2=h^2-h(0)^2$ (not the naive $g_{H_1}^2$, whose
   measure is signed) is a screw function under RH, by a Hermitian-square identity over the
   sum spectrum (Theorem P3); numerically PSD while the Beta layer is maximally indefinite.
3. **Variance program rerun.** In the product metric the variance$\,\asymp\,$diagonal
   statement holds with the diagonal in closed form $D_0=3(m_0^2-S_4)$, a *free*
   lower bound at every window length (Jensen — positivity's gift), resonances that can
   only help, and the near-diagonal separation needed only for upper-bound rates
   (Theorem P4). Verified numerically to $V/D_0\in[0.97,1.05]$.
4. **What it buys the Goldbach-variance program vs. the Beta version.** Proposition R1
   shows the one genuinely open hypothesis — 4-point near-diagonal separation — is the
   *same statement* in both metrics (blockwise $|C|\asymp T^{3/2}$); so proving it for the
   positive-weight energy $E^\circ_a$ (a cleaner target for the Tao–Trudgian–Yang $N^*$
   machinery, D.6 item 1) closes Theorem D″ in *both* metrics at once. What does not
   transfer is unconditional positivity: that is metric-specific, and the no-go says no
   reweighting of a genuine $m+n$-kernel will ever import it. Target 1 therefore resolves
   into: (i) *done* — carrier, positivity, free lower bounds, closed-form diagonal;
   (ii) *sharpened* — the program's single remaining wall is $E^\circ_a(\eta)\ll\eta\,m_0^2$,
   now stated with positive weights and no Γ-phases in sight.
