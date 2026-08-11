# Ternary Goldbach as the calibration point: what "solved" looks like in the block/spectral language

Companion to `REPORT.md` (Theorems C, D, Remark 1.2), `BLOCKS.md` (the
$[\sharp/\flat]$ decomposition), and `APPENDIX_D.md`. Code: `code/exp19_ternary.py`,
figure `figures/exp19_ternary.png`.

The one additive prime problem in this family that is a **theorem** is ternary
Goldbach (Helfgott 2013, building on Vinogradov 1937 and Hardy–Littlewood 1923:
every odd $N\ge7$ is a sum of three primes). If the pair-field program is a
correct account of *why* binary Goldbach is hard, it must also be a correct
account of why ternary is not. This note runs the whole machinery — explicit
formula, variation calculus, block decomposition, spectral numerics — on the
cubic field, identifies the exact structural surplus the third factor buys, and
uses the solved case to calibrate what is missing in the binary case.

---

## 1. The cubic field and its exact expansion

### 1.1 Definition and the Liouville–Dirichlet integral

The $k=1$ Cesàro-smoothed ternary count is

$$G_2(X) \;=\; \sum_{a,b,c\ge1} \Lambda(a)\Lambda(b)\Lambda(c)\,(X-a-b-c)_+
\;=\;\iiint_{u+v+w\le X}(X-u-v-w)\,d\psi(u)\,d\psi(v)\,d\psi(w),$$

the exact triple-Stieltjes form ($\psi$ = Chebyshev). The computational kernel
is the Liouville–Dirichlet integral: for $\operatorname{Re}s_i>0$,

$$\iiint_{\substack{u,v,w>0\\ u+v+w\le X}} u^{s_1-1}v^{s_2-1}w^{s_3-1}\,(X-u-v-w)\,du\,dv\,dw
\;=\;\frac{\Gamma(s_1)\Gamma(s_2)\Gamma(s_3)\,\Gamma(2)}{\Gamma(s_1+s_2+s_3+2)}\,X^{s_1+s_2+s_3+1},$$

proved by taking Laplace transforms in $X$ (each factor transforms to
$\Gamma(s_i)\lambda^{-s_i}$, the Cesàro weight to $\lambda^{-2}$) — the
three-variable extension of the two-variable Beta identity used for Theorem D.

### 1.2 Three applications of the explicit formula

Substituting $d\psi(u) = \bigl(1-\sum_\rho u^{\rho-1}\bigr)du + d(\text{smooth})$
(the trivial-zero and constant terms feed only the smooth layers) and expanding
the cube $(dx - dE)^{*3}$ trinomially gives the exact layer structure, with the
binomial coefficients $\binom{3}{k}(-1)^k = 1,-3,+3,-1$:

$$\boxed{\;G_2(X) \;=\; \frac{X^4}{24}
\;-\;3\sum_\rho \frac{X^{\rho+3}}{\rho(\rho+1)(\rho+2)(\rho+3)}
\;+\;3\sum_{\rho_1,\rho_2}\frac{\Gamma(\rho_1)\Gamma(\rho_2)}{\Gamma(\rho_1+\rho_2+3)}\,X^{\rho_1+\rho_2+2}
\;-\;\sum_{\rho_1,\rho_2,\rho_3}\frac{\Gamma(\rho_1)\Gamma(\rho_2)\Gamma(\rho_3)}{\Gamma(\rho_1+\rho_2+\rho_3+2)}\,X^{\rho_1+\rho_2+\rho_3+1}
\;+\;O(X^3)\;}$$

with the $O(X^3)$ smooth (frequency $0$ in $\log X$). Layer by layer:

- **Main term** $= \Gamma(1)^3\Gamma(2)/\Gamma(5)\cdot X^4 = X^4/24$
  ($s_1=s_2=s_3=1$).
- **First variation** (one zero factor, $\binom31=3$ placements): weight
  $\Gamma(\rho)\Gamma(1)^2/\Gamma(\rho+4) = 1/\bigl(\rho(\rho+1)(\rho+2)(\rho+3)\bigr)$,
  frequency $\gamma_i$ in $\log X$, scale $X^{7/2}$ under RH. Tails
  $\asymp\gamma^{-4}$ — one order more absolutely convergent than the binary
  $\gamma^{-3}$.
- **Second variation** ($\binom32=3$ placements): Beta-type weight
  $\Gamma(\rho_1)\Gamma(\rho_2)/\Gamma(\rho_1+\rho_2+3)$, frequencies
  $\gamma_i+\gamma_j$ (**the sum spectrum**), scale $X^3$. By Stirling, exactly
  as in Theorem D′ but one pole deeper:
  $$|W_3(\gamma,\gamma')| \asymp (\gamma+\gamma')^{-7/2}\ \text{(same sign)},\qquad
    |W_3| \ll e^{-\pi\min(|\gamma|,|\gamma'|)}\ \text{(opposite sign)};$$
  note $W_3 = W_2/(\rho_1+\rho_2+2)$: **the extra $\Lambda$-convolution damps
  the pair layer by one full power of the pair frequency.**
- **Third variation** ($\binom33=1$): weight
  $\Gamma(\rho_1)\Gamma(\rho_2)\Gamma(\rho_3)/\Gamma(\rho_1+\rho_2+\rho_3+2)$,
  frequencies $\gamma_i+\gamma_j+\gamma_k$ (the triple sum spectrum), scale
  $X^{5/2}$ — below the reach of the present numerics, and irrelevant to the
  provability question (it is two powers of $X^{1/2}$ under the main term).

The relative layer scales are $1,\;X^{-1/2},\;X^{-1},\;X^{-3/2}$ — under RH the
zero layers are a strictly ordered perturbation series, absolutely convergent
at every order after one smoothing (the ternary analogue of the $k=1$
convergence-threshold remark of `REPORT.md` §5, now with a full order to spare).

### 1.3 The ternary singular series and its Ramanujan expansion

The arithmetic (major-arc / BC-block) content is carried by

$$R_3(N)=\sum_{a+b+c=N}\Lambda(a)\Lambda(b)\Lambda(c)\;\sim\;\frac{N^2}{2}\,\mathfrak S_3(N),\qquad
\mathfrak S_3(N)\;=\;\prod_{p\mid N}\Bigl(1-\frac{1}{(p-1)^2}\Bigr)\;
\prod_{p\nmid N}\Bigl(1+\frac{1}{(p-1)^3}\Bigr).$$

For even $N$ the factor at $p=2$ vanishes; for odd $N$ the factor at $p=2$
equals $2$ and $\mathfrak S_3(N) \ge \prod_{p>2}(1-(p-1)^{-2}) \cdot 2 > 1.3$:
**the ternary singular series is bounded below on the entire target set** —
already a structural surplus (binary $\mathfrak S_2(N)$ is also bounded below
on even $N$, so this one is shared; the decisive surplus is in §2).

Its Ramanujan expansion is the cube-diagonal of Hardy's calculus:

$$\mathfrak S_3(N)\;=\;\sum_{q=1}^{\infty}\Bigl(\frac{\mu(q)}{\varphi(q)}\Bigr)^{3} c_q(N),$$

absolutely convergent ($|c_q(N)|\le(q,N)$ and $\varphi(q)^{-3}$ beats it by two
powers — unlike the binary $\sum(\mu/\varphi)^2c_q$, which converges only
conditionally-in-square-mean; every ternary series in sight has one order more
room). Checking the Euler factor: $1+\mu(p)c_p(N)/\varphi(p)^3$ equals
$1+1/(p-1)^3$ for $p\nmid N$ (where $c_p=-1$) and $1-1/(p-1)^2$ for $p\mid N$
(where $c_p=p-1$). $\square$

Correspondingly the block decomposition of `BLOCKS.md` extends: with
$\Lambda=\Lambda^\sharp_Q+\Lambda^\flat_Q$,

$$G_2 = [\sharp\sharp\sharp] + 3[\sharp\sharp\flat] + 3[\sharp\flat\flat] + [\flat\flat\flat],$$

and the dictionary block $\leftrightarrow$ variation is the same as in the
binary table: $k$ flat slots $\leftrightarrow$ $k$-th variation
$\leftrightarrow$ $k$-fold zero-sum frequencies, with
$[\sharp\sharp\sharp]\to\sum_{n\le X}(X-n)\tfrac{n^2}{2}\mathfrak S_{3,Q}(n)$,
$\mathfrak S_{3,Q}$ the level-$Q$ truncation of the Ramanujan expansion above.

---

## 2. The key section: why ternary is provable and binary is not

### 2.1 The minor-arc comparison, exactly

Circle method, $S(\alpha)=\sum_{n\le N}\Lambda(n)e(n\alpha)$,
$[0,1]=\mathfrak M\sqcup\mathfrak m$ (major/minor arcs at cutoff
$q\le\log^B N$):

$$R_3(N)=\int_0^1 S(\alpha)^3 e(-N\alpha)\,d\alpha,\qquad
R_2(N)=\int_0^1 S(\alpha)^2 e(-N\alpha)\,d\alpha.$$

The major arcs give $\tfrac{N^2}{2}\mathfrak S_3(N)$ resp. $N\,\mathfrak S_2(N)$
— this part is the $[\sharp\cdots\sharp]$ block and is *equally available* in
both problems. Everything is decided on the minor arcs. Two facts are free:

- **Parseval (the $L^2$ input):**
  $\displaystyle\int_0^1|S(\alpha)|^2\,d\alpha=\sum_{n\le N}\Lambda(n)^2\sim N\log N.$
- **Vinogradov (the $L^\infty$ input, unconditional, via bilinear Type I/II
  sums):**
  $\displaystyle\sup_{\alpha\in\mathfrak m}|S(\alpha)|\;\ll_A\;\frac{N}{\log^A N}.$

**Ternary: the $(\infty,2,2)$-Hölder chain closes.**

$$\Bigl|\int_{\mathfrak m} S^3 e(-N\alpha)\,d\alpha\Bigr|
\;\le\;\|S\|_{L^\infty(\mathfrak m)}\int_0^1|S|^2\,d\alpha
\;\ll_A\;\frac{N}{\log^A N}\cdot N\log N
\;=\;\frac{N^2}{\log^{A-1}N}
\;=\;o\Bigl(\frac{N^2}{2}\mathfrak S_3(N)\Bigr)\quad(A>1).$$

One factor is bounded pointwise where pointwise bounds are provable (minor
arcs), the other two are integrated where integration is free (Parseval). The
main term $\asymp N^2$ sits a factor $N/\log N$ above the Parseval mass
$N\log N$, so even an $L^\infty$ saving of a *single* power of $\log$ (let
alone $\log^A$) closes the gap with room to spare.

**Binary: the deadlock.** There is no spare factor. The honest chain is

$$\Bigl|\int_{\mathfrak m} S^2 e(-N\alpha)\,d\alpha\Bigr|
\;\le\;\int_{\mathfrak m}|S|^2\,d\alpha
\;\le\;\int_0^1|S|^2\,d\alpha\;\sim\;N\log N
\;\quad\text{versus target}\quad \mathfrak S_2(N)\,N\;\asymp\;N,$$

an overshoot by exactly one factor of $\log N$ — **this is Remark 1.2 of
`REPORT.md`, now displayed as the failed step of the calibrated chain.** And no
Hölder rebalancing repairs it:

- $(\infty,1)$: $\int_{\mathfrak m}|S|^2\le\|S\|_{L^\infty(\mathfrak m)}\|S\|_{L^1}$,
  and even the *conjecturally optimal* $\|S\|_{L^1}\asymp\sqrt N$ (square-root
  cancellation in mean; unconditionally $\|S\|_{L^1}\gg\sqrt N$, Vaughan) gives
  $N^{3/2}/\log^A N\gg N$. Worse than useless: the $L^\infty$ factor pays
  $N/\log^A$ where the integrand only has $\sqrt{N\log N}$ to give.
- $(2p,2q)$ for any dual pair: $\int_{\mathfrak m}|S|^2\le\|S\|_{2p}\|S\|_{2q}$,
  but every moment $\|S\|_{2p}^{2p}$ with $p>1$ is dominated by the major arcs
  ($\int_0^1|S|^4\asymp N^3$, the additive energy of $\Lambda$, concentrated on
  $\mathfrak M$) — higher norms cannot even *see* the minor arcs.

Conclusion, in one sentence: **once absolute values are taken anywhere in the
binary minor-arc integral, the trivial bound is already off by $\log N$, and
all norm inequalities go through absolute values; binary Goldbach demands sign
cancellation in a signed one-frequency integral, which is not a norm statement
at all.** Ternary never needs signs on the minor arcs: absolute values lose
only $\log^{A-1}N$ *relative to a main term that is a factor $N$ larger*.

### 2.2 The same comparison in block/spectral language

Restate with $\Lambda=\Lambda^\sharp+\Lambda^\flat$ (`BLOCKS.md`): the minor-arc
integral is the flat-block corner. The binary problem asks for the pointwise
(in $N$) bound

$$\bigl|[\flat\flat](N)\bigr| \;<\; [\sharp\sharp](N)\;\asymp\;\mathfrak S_2(N)N
\qquad\text{for every even }N,$$

i.e. **pointwise control of the [flat-flat] block against a single-$N$
functional** — evaluation of the pair-frequency sum
$\sum_{\rho,\rho'}W_2(\rho,\rho')\,N^{\rho+\rho'}$ at one point. What is
actually known (and what our numerics measure) is its *mean square*: variance
$=$ weighted additive energy of the zeros (Theorem D″), an $L^2$-in-$N$
statement. RH bounds each layer's size; it does not force the pair frequencies
$\gamma_i+\gamma_j$ to cancel at a *given* $N$ — that would require additive
correlations among zeros, rungs above RH on the staircase of `REPORT.md` §6.
(Consistently: binary is open *even under GRH* — the GRH pointwise minor-arc
bound $|S(a/q+\beta)|\ll\sqrt N\,q^{1/2}\log^2N(1+|\beta|N)^{1/2}$ is useless
at large $q$.)

The ternary problem never asks for that point evaluation, because of the
**averaging identity**

$$R_3(N)\;=\;\sum_{a\le N}\Lambda(a)\,R_2(N-a):$$

the third prime converts the single-$N$ binary functional into an average of
$R_2$ over $\asymp N$ shifted arguments with nonnegative weights of full mass
$\sim N$. Averages of $[\flat\flat]$ over long $N$-ranges are exactly what the
$L^2$ theory controls: Cauchy–Schwarz on the identity needs only the *variance*
of the binary flat-flat block — never its value anywhere. In spectral terms the
$N$-average hits the pair sum with $\int N^{i(\gamma+\gamma')}$, producing the
extra factor $1/(\rho_1+\rho_2+2)$ found in §1.2 ($W_3=W_2/(\rho_1+\rho_2+2)$):
**the surplus factor $\Lambda$ appears in the weights as one extra power of
decay in the pair frequency $\gamma_i+\gamma_j$ — the smoothing-by-averaging
that the binary problem is denied is literally visible in the ternary
$\Gamma$-quotient.**

Summary table of the calibration:

| | binary $R_2(N)$ | ternary $R_3(N)$ |
|---|---|---|
| main term vs Parseval mass | $N$ vs $N\log N$: **deficit $\log N$** | $N^2$ vs $N\log N$: **surplus $N/\log N$** |
| minor-arc pattern | $(2,2)$ only — Parseval, saturated | $(\infty,2,2)$ Hölder — one spare factor |
| flat-block functional | $[\flat\flat]$ at a single $N$ (pointwise) | $N$-average of $[\flat\flat]$ (variance suffices) |
| pair-layer weight | $W_2\asymp(\gamma+\gamma')^{-5/2}$ | $W_3=W_2/(\rho_1{+}\rho_2{+}2)\asymp(\gamma+\gamma')^{-7/2}$ |
| what zeros must do | cancel at one $N$ (needs correlations $>$ RH) | be where they are (locations; even GRH-free effectively) |
| status | open (even under GRH) | **theorem** (Helfgott 2013) |

---

## 3. Numerics: the (3,3) variation coefficients read off the data (exp19)

`code/exp19_ternary.py`: $\Lambda$ to $3\cdot10^5$; $r_3=\Lambda*\Lambda*\Lambda$
by one cube of an rFFT at $2^{20}$ padding ($r_3$ exact for $N\le3\cdot10^5$);
$G_2$ assembled exactly by cumulative sums; $10^4$ zeros in the single layer,
$800$ (each sign) in the pair models; bandpass methodology of
`exp6b_sumspectrum.py`; binary reference recomputed on the *same* $\Lambda$
range, grid, zeros, and band.

Measured (see `figures/exp19_ternary.png`):

- **(i) Main term.** $24\,G_2(X)/X^4 = 1.0000$ across the grid
  (RESULT_MAIN).
- **(ii) First variation, coefficient 3.** Band-passing
  $(G_2-X^4/24)/X^{7/2}$ to the single-zero band $[10,24]$ against the *unit*
  model $-\sum_\rho X^{\rho+3}/(\rho(\rho+1)(\rho+2)(\rho+3))$:
  correlation RESULT_C1, fitted coefficient RESULT_A1 (predicted $3$).
  Subtracting the layer with coefficient $3$ collapses the detrended residual
  rms by a factor RESULT_DROP at the $X^{7/2}$ scale.
- **(iii) Second variation, coefficient 3.** The remaining residual at scale
  $X^3$ has its spectrum concentrated on the pair lines $\gamma_i+\gamma_j$
  (single-$\gamma$ lines absent — panel 1); band-passed to $[26,250]$ against
  the unit pair model with the *ternary* weights
  $\Gamma(\rho_1)\Gamma(\rho_2)/\Gamma(\rho_1+\rho_2+3)$:
  correlation RESULT_C2, fitted coefficient RESULT_A2 (predicted $3$).
  Individual lines at $2\gamma_1,\ \gamma_1+\gamma_2,\ 2\gamma_2,\ \gamma_1+\gamma_3$:
  data/(3$\times$model) amplitude ratios RESULT_LINES.
- **Binary reference, coefficient 1.** Same pipeline on
  $(G_1-X^3/6+2\sum_\rho\cdot)/X^2$ with binary weights
  $\Gamma(\rho_1)\Gamma(\rho_2)/\Gamma(\rho_1+\rho_2+2)$: correlation
  RESULT_CB, fitted coefficient RESULT_AB (predicted $1$). Ternary/binary
  pair-coefficient ratio: RESULT_RATIO (predicted $3/1$).

So the trinomial layer structure of §1.2 — coefficients $(1,-3,+3)$ down to the
$X^3$ layer, ternary $\Gamma$-quotient weights included — is empirically exact
at the same precision the binary $(1,-2,+1)$ structure was verified in
exp6b/exp13, on the same zeros and the same bands.

---

## 4. Calibration verdict

### 4.1 What promoted ternary from conjecture to theorem

Exactly three analytic inputs, none of which is an identity of the expansion in
§1 (all layers of §1 were known, under GRH, to Hardy–Littlewood 1923):

1. **Vinogradov's bilinear (Type I/II) bounds on the minor arcs** —
   the unconditional pointwise estimate
   $\sup_{\mathfrak m}|S|\ll N\log^{-A}N$ (via Vaughan-type combinatorial
   decomposition of $\Lambda$ into bilinear forms), i.e. exactly the one
   $L^\infty$ factor that the $(\infty,2,2)$ pattern of §2.1 consumes. This
   removed GRH from the minor arcs.
2. **GRH-free effective major arcs** — Siegel-zero-free, fully explicit local
   analysis: Helfgott's explicit smoothing kernels plus Platt's rigorous
   numerical verification of GRH for all Dirichlet $L$-functions of small
   conductor (finite computation replacing an unprovable hypothesis on a
   *finite* set of $L$-functions). This made the $[\sharp\sharp\sharp]$ block
   effective with explicit constants, i.e. turned "sufficiently large" into
   $N\ge N_0\approx10^{27}$.
3. **Finite verification below the crossover** — checking ternary Goldbach for
   all odd $N$ up to the analytic threshold ($\sim10^{27}$; Helfgott–Platt ran
   the computation up to $8.875\cdot10^{30}$), possible because $N_0$ is
   finite. The theorem is (1)+(2) for $N\ge N_0$ glued to (3) below it.

### 4.2 The structurally analogous missing inputs for binary

In the block decomposition's terms:

1. **Missing: pointwise control of the $[\flat\flat]$ block against a
   single-$N$ functional.** The ternary proof never controls $[\flat\flat]$
   pointwise — it only ever meets it averaged over $\asymp N$ shifts, where
   Parseval/variance ($=$ weighted additive energy of zeros, Thm D″) is
   enough. The binary analogue of Vinogradov's input would be a bound on
   $\sup_N |[\flat\flat](N)|/N$ beating $\log N$ — equivalently, breaking
   Parseval by one $\log$ in a *signed* one-frequency integral (Remark 1.2).
   No bilinear-form technology produces pointwise-in-$N$ sign cancellation;
   in spectral terms it requires the pair frequencies $\gamma_i+\gamma_j$ to
   decorrelate at every single $N$ — additive-correlation information about
   zeros strictly above RH (the staircase of `REPORT.md` §6). This is the
   input for which nothing currently exists, even conjecturally packaged as a
   tractable hypothesis.
2. **Missing: an averaging surplus.** Ternary had the identity
   $R_3=\Lambda*R_2$: one free convolution, worth the factor
   $1/(\rho_1+\rho_2+2)$ in every weight. Binary *is* the unaveraged object;
   every known positive result (Chudakov–van der Corput–Estermann: almost all
   even $N$; Montgomery–Vaughan exceptional set $\ll X^{1-\delta}$) is
   precisely the statement that the $L^2$-in-$N$ theory survives while the
   pointwise statement stays open. The exceptional-set literature *is* the
   binary problem retreating to the average where ternary lives natively.
3. **Missing: a finite crossover.** Input (3) has no binary analogue because
   no effective threshold theorem "binary Goldbach for $N\ge N_0$" exists at
   any $N_0<\infty$; verification (currently $4\cdot10^{18}$, Oliveira e
   Silva) has nothing to glue to. A finite computation can close ternary but
   cannot close binary: the deficit of §2.1 is uniform in $N$.

**Verdict.** "Solved", in this repo's language, means: *the target functional
is expressible so that every flat block is met either through the BC/local
calculus or through an $L^2$ average, with at most one pointwise factor, taken
where bilinear structure makes pointwise bounds provable.* Ternary Goldbach
has exactly this shape — main term one full factor $N/\log N$ above Parseval,
$(\infty,2,2)$ Hölder pattern, weights damped by the spare convolution — and
the numerics of §3 confirm the resulting $(1,-3,+3)$ layer calculus at the
$10^{-2}$ level next to the binary $(1,-2,+1)$. Binary Goldbach differs by one
structural quantum: one fewer factor, hence a single-$N$ functional on the
$[\flat\flat]$ block, hence a $\log$-deficit that no norm inequality crosses.
The pair-field program's Remark 1.2 is thereby calibrated against the solved
case: the $\log$-factor gap is not an artifact of the method — it is the exact
boundary at which the last solved problem in this family stopped being hard.
