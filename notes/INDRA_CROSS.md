# Indra's cross: the mixed pair field of two Dirichlet characters

Filed from the indra lane (Weaver fleet), 2026-08-11; numerics filled in by
the finisher lane 2026-08-12. Companion code: `code/exp58_indra_cross.py` →
`figures/exp58_indra_cross.png`, `figures/exp58_net.png`; zero caches
`data/exp58_chi{3,4,12,5,5bar}_zeros.npy`, `data/exp58_chi3_zeros_deep.npy`.
Extends `FAMILY.md` §2.1 (`exp20_dirichlet`: the *single*-character pure
pair field) and §2 (`exp18_cross`: the Λ×μ cross field — compositional
layer algebra, but both factors ζ-based). Weight-law inputs:
`BLOCKS.md` §2 (Theorem D‴ — the Γ-part is dressing-universal),
`FRESNEL.md` (phase reading). Statistics context: `exp29_ltower_stats`
(whose zero cache this note audits, §2).

**One draft prediction died in the run: §1.4(ii)'s "dark field". It is
struck through below and replaced with what was measured.** Everything
quoted in fenced blocks is verbatim script output; nothing is
reconstructed from memory.

**Status: PENDING HOSTILE AUDIT.**

## 0. Statement and standing hypotheses

For non-principal primitive characters $\chi_1,\chi_2$ (possibly of
*different* conductors) define the ordered mixed pair field
$$G_1^{\chi_1,\chi_2}(X)\;=\;\sum_{m,n\ge1}\Lambda(m)\chi_1(m)\,
\Lambda(n)\chi_2(n)\,(X-m-n)_+ .$$

**Standing hypotheses (per `FAMILY.md` §2.1 discipline): GRH and simple
zeros for $L(s,\chi_1)$ and $L(s,\chi_2)$** (and for $L(s,\chi_{12})$,
$L(s,\chi_5)$ where those strings are used below); the model hard-codes
$\rho=\tfrac12+i\gamma$ and zeros are located on the critical line only.
One smooth-ledger remark additionally uses GRH for $L(s,\chi_1\chi_2)$,
flagged where it occurs.

**Theorem I (Indra cross identity; identity-level, same epistemic class as
Theorem H′/`FAMILY.md` §2.1).** Since $-L'/L(s,\chi_i)$ has **no pole at
$s=1$** ($L(1,\chi_i)\neq0$) and residue $-1$ at every (simple) zero, the
double explicit formula gives, for odd $\chi_1,\chi_2$,
$$G_1^{\chi_1,\chi_2}(X)=
\underbrace{\sum_{\rho\in Z(\chi_1)}\sum_{\rho'\in Z(\chi_2)}
\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}\,X^{\rho+\rho'+1}}_{\text{pure mixed pair layer, }X^2}
\;+\;B(X)\;+\;E(X),$$
with **unit weights** — residue $1$ at every zero of each factor — and
$\log X$-frequency set $\{\gamma^{\chi_1}_i+\gamma^{\chi_2}_j\}$: a sum
spectrum that belongs to **no single $L$-function**, only to the pair.
$B(X)$ is the $X^{3/2}$-type boundary block and $E(X)$ the sub-$X$ dust,
both derived in §1. There is **no $X^3$ layer and no $X^{5/2}$ layer**:
both Mellin factors are poleless, so pole$\times$pole and pole$\times$zero
never form. In the layer algebra of `FAMILY.md` §2 law 1, this is the
two-string generalization of the terminal object: *pure pair, but the two
zero strings are different jewels.*

Unlike the Möbius pure field (Theorem H′, `exp16_mobius`), **no Gonek-type
bound is needed**: the residues are exactly $1$, and the pair layer
converges *absolutely* — same-sign pairs by the D‴ modulus law
$|W|\sim\sqrt{2\pi}\,s^{-5/2}$ against the $O(T\log^2T)$ pair density,
opposite-sign pairs by the uncancelled exponential
$|W|\asymp e^{-\pi\min(\gamma,|\gamma'|)}$ (§1.4(ii)). *Both halves of that
modulus law are measured directly in §4: over the $\chi_5\times\bar\chi_5$
grid the same-sign block has $\max|W|=7.165\cdot10^{-3}$ and the
opposite-sign block $\max|W|=7.216\cdot10^{-6}$, the latter matching
$\pi e^{-\pi\cdot 4.133}=7.5\cdot10^{-6}$ at the smallest ordinate pair.*
The convergence argument is unaffected by the §1.4(ii) retraction.

## 1. Derivation

### 1.1 The double Mellin frame

Dirichlet's integral gives, for $\mathrm{Re}\,s,\mathrm{Re}\,w>0$,
$$\iint_{u,v>0,\;u+v\le X}u^{s-1}v^{w-1}(X-u-v)\,du\,dv
=\frac{\Gamma(s)\Gamma(w)\Gamma(2)}{\Gamma(s+w+2)}X^{s+w+1},$$
so with $D_i(s)=-\frac{L'}{L}(s,\chi_i)=\sum_n\Lambda(n)\chi_i(n)n^{-s}$
($\mathrm{Re}\,s>1$),
$$G_1^{\chi_1,\chi_2}(X)=\Bigl(\tfrac1{2\pi i}\Bigr)^2
\int_{(c)}\int_{(c)}D_1(s)D_2(w)\,
\frac{\Gamma(s)\Gamma(w)}{\Gamma(s+w+2)}\,X^{s+w+1}\,ds\,dw,\qquad c>1,$$
absolutely convergent by the $\Gamma$-decay of the kernel on vertical
lines. Shift both contours to $\mathrm{Re}=-\tfrac14$. The singularity
sources of the factor $F_i(s)=D_i(s)\Gamma(s)$ crossed en route are:

* the **nontrivial zeros** $\rho$ of $L(s,\chi_i)$ (simple poles of $D_i$,
  residue $-1$ under the simple-zeros hypothesis);
* **$s=0$**: for odd $\chi_i$, $L(0,\chi_i)\neq0$, so only $\Gamma(s)$'s
  simple pole crosses, with value $D_i(0)=-\frac{L'}{L}(0,\chi_i)$. (For
  an *even* character the trivial zero at $s=0$ collides with $\Gamma$'s
  pole — a double pole, producing the same $X$-scales with an extra
  $\log X$; this is the only modification needed for $\chi_{12}$ below.)

There is **no crossing at $s=1$** — the pole that generates the entire
foreground of the $\Lambda$-field is absent from both factors. Composing
pairwise (`FAMILY.md` §2 law 1):

| crossing | term | scale |
|---|---|---|
| zero $\times$ zero | $(-1)(-1)\sum_{\rho,\rho'}\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}X^{\rho+\rho'+1}$ | $X^2$ |
| zero $\times$ $\{0\}$ | $+\frac{L'}{L}(0,\chi_2)\sum_{\rho}\frac{\Gamma(\rho)}{\Gamma(\rho+2)}X^{\rho+1}$ (and $1\leftrightarrow2$) | $X^{3/2}$ |
| $\{0\}\times\{0\}$ | $\frac{L'}{L}(0,\chi_1)\frac{L'}{L}(0,\chi_2)\,X$ | $X$ |
| trivial-zero crossings + shifted integral | $E(X)$ | $O(X^{1/2+\varepsilon})$-type |

### 1.2 The boundary block $B(X)$

The $X^{3/2}$ row is the boundary block: **single-zero lines exist, but
only at $X^{3/2}$, with constant coefficients** $\frac{L'}{L}(0,\chi_j)$
and per-zero weights $\Gamma(\rho)/\Gamma(\rho+2)=1/(\rho(\rho+1))$ —
Fujii-type weights (`exp3_fujii`) with the *other* character's $s=0$ value
as the coupling constant, in place of the pole-crossing weight
$1/(\rho(\rho+1)(\rho+2))$ that the principal row carries at $X^{5/2}$.
Computed constants (exp58 run):

```
boundary constants: -L'/L(0,chi3) = -0.9482, -L'/L(0,chi4) = -0.7832
```

At $X^2$ normalization the whole block is suppressed by $X^{-1/2}$
($\approx10^{-3}$ at $X=10^6$) — predicted invisible in the pair band, and
measured so (§2(d): the single-$\gamma$ lines sit $73.4\times$ below the
mixed pair lines). The trivial-zero collisions ($D_i$'s pole at $s=-1$
meeting $\Gamma$'s, for odd $\chi$) produce $O(X^{1/2}\log X)$ terms inside
$E(X)$; the usual interchange / conditional-convergence caveats of the
double explicit formula are the same as for Theorems D/H′ and are
inherited, not re-proved, here.

### 1.3 The smooth ledger: $\chi_1\chi_2$ principal vs non-principal

The identity's right side contains **no $X^2\log X$ term**. This has a
sharp consequence for the diagonal. The $m=n$ terms contribute
$\sum_m\Lambda(m)^2(\chi_1\chi_2)(m)\,(X-2m)$, governed by the product
character:

* **$\chi_1\chi_2$ non-principal** (our case: $\chi_3\chi_4=\chi_{12}$,
  the even quadratic character mod 12): the diagonal is
  $O(X^{3/2}\log X)$ under GRH for $L(s,\chi_1\chi_2)$ — the mixed field
  with distinct characters has an even *cleaner* foreground than the
  equal-character field of `exp20_dirichlet`.
* **$\chi_1\chi_2$ principal** ($\chi_2=\bar\chi_1$, equal conductor;
  e.g. $\chi_1=\chi_2=\chi_3$): the raw diagonal is
  $\sim\tfrac{X^2}{4}\log X$. Since the identity forbids any such term in
  the total, **the off-diagonal smooth mean must cancel it**:
  $$\sum_{m\ne n}\Lambda\chi(m)\Lambda\bar\chi(n)(X-m-n)_+
  =-\frac{X^2}{4}\log X\,(1+o(1))+O(X^2)\quad\text{(smooth part)},$$
  the character analogue of the signed simplex corollaries of
  `FAMILY.md` §§1–2. Verified (exp58, $X=10^6$):

```
  smooth ledger at X=1e6 (X^2 units):
    equal-char (chi3,chi3): raw diagonal +2.9025 [~log(X)/4 = 3.454], total G/X^2 = -0.0026  -> off-diagonal cancels the log-diagonal (purity)
    mixed (chi3,chi4): chi3*chi4 = chi12 non-principal, total G/X^2 = -0.0139  (no log term anywhere)
```

  The raw diagonal $+2.90$ is within 16% of the asymptotic
  $\tfrac14\log X=3.45$ (a finite-$X$ gap of the expected size for a
  $\log$-scale asymptotic at $X=10^6$), while the *total* is $-0.0026$:
  the cancellation is real and complete to three orders of magnitude.
  [This also sharpens the framing in `exp20_dirichlet`'s docstring, where
  the diagonal is called "the leading deterministic term": it is the
  leading *raw* term; the total smooth mean at $X^2$ is bounded, so the
  cubic $\log X$ detrend there was harmless but not load-bearing.] For the
  mixed field the measured total is $-0.0139$ with no log-growth anywhere.

### 1.4 Special cases

**(i) $\chi_1=\chi_2$** reduces verbatim to `FAMILY.md` §2.1
(`exp20_dirichlet`): one jewel string, frequencies
$\gamma^{\chi}_i+\gamma^{\chi}_j$.

**(ii) $\chi_2=\bar\chi_1$, complex $\chi_1$ — ~~the dark field~~ (claim
RETRACTED 2026-08-12; see below).** Zeros of $L(s,\bar\chi)$ are the
reflections $\bar\rho$ of those of $L(s,\chi)$ (the product
$L(s,\chi)L(s,\bar\chi)$ is real on the real axis), so under GRH the
ordinate string of $\bar\chi$ is the *negation* of that of $\chi$, and the
mixed frequency set becomes the **difference spectrum**
$\{\gamma_i-\gamma_j\}$. That much survives. The draft continued:

> ~~But the D‴ exponential cancellation
> $|\Gamma(\tfrac12+i\gamma)\Gamma(\tfrac12+i\gamma')/\Gamma(3+is)|
> \sim\sqrt{2\pi}s^{-5/2}$ holds only for *same-sign* ordinates; for
> opposite signs the moduli multiply to
> $\asymp e^{-\pi\min(\gamma,|\gamma'|)}$. **Every line of the difference
> spectrum is exponentially damped: the $(\chi,\bar\chi)$ field is
> spectrally dark**, its visible content only the $X^{3/2}$ boundary
> singles of both strings plus smooth. This is the field-level face of
> `BLOCKS.md` §2.1's verdict: Hermitian-square structure is exactly what
> the chirped Beta kernel refuses to display.~~

**This is false, and the run says so unambiguously (§4).** The error is a
quantifier slip about *which* ordinates are being paired. The kernel's
sign law is about the signs of the two ordinates $\alpha\in Z(\chi)$,
$\beta\in Z(\bar\chi)$ entering $\Gamma(\tfrac12+i\alpha)
\Gamma(\tfrac12+i\beta)/\Gamma(3+i(\alpha+\beta))$ — and for a **complex**
$\chi$ the string $Z(\chi)$ is asymmetric but still contains ordinates of
**both signs** (29 positive, 29 negative below $60$ for $\chi_5$). Hence
$\beta$ also ranges over both signs, roughly half of all $(\alpha,\beta)$
pairs are same-sign, and those are **undamped**. Their frequencies
$\alpha+\beta=\gamma_i-\gamma_j$ have $\gamma_i>0>\gamma_j$, i.e.
magnitude $|\gamma_i|+|\gamma_j|$: sum-like lines wearing difference
labels. Measured, band $[12,58]$:

| block | pairs | $\max|W|$ | band amplitude |
|---|---|---|---|
| same-sign $(\alpha,\beta)$ | 1682 | $7.165\cdot10^{-3}$ | $1.106\cdot10^{-2}$ |
| opposite-sign $(\alpha,\beta)$ | 1682 | $7.216\cdot10^{-6}$ | $2.167\cdot10^{-8}$ |

**Corrected statement.** The $(\chi,\bar\chi)$ field is *not* spectrally
dark. It is a perfectly ordinary pure pair field over the difference
spectrum, with unit weights and the universal kernel — measured
$\mathrm{corr}=+0.999997$, amplitude ratio $1.0000$ against the
difference-spectrum pair model, in fact $1.91\times$ *louder* in band than
the visible $(\chi_3,\chi_5)$ sum-spectrum field. What is exponentially
dark is only the **small-difference part** of that spectrum: the lines
$\gamma_i-\gamma_j$ built from ordinates on the *same side* of the real
axis, suppressed here by $5\cdot10^{5}$. So the correct slogan is *"near
coincidences are dark, wide differences are not"* — a statement about a
sub-band, not about a field. The `BLOCKS.md` §2.1 "Hermitian-square
structure is invisible" inference is withdrawn with it; nothing in this
note now supports it, and the D‴ modulus law itself is untouched (both
regimes of it were confirmed, §0).

**(iii) Principal components.** Inside the $q=12$ net (§3) the lifted
principal character restores the $s=1$ pole, and with it the entire
`FAMILY.md` §2 classification: $(\chi_0,\chi_0)$ carries $X^3/6$,
$(\chi_0,\chi)$ carries $X^{5/2}$ singles with weights
$1/(\rho(\rho+1)(\rho+2))$ — measured below as positive controls inside
the same grid that holds the nine pure mixed fields.

## 2. exp58 numerics: the $(\chi_3,\chi_4)$ field

*(quoted output; sieve to $2\cdot10^6$, grid $M=8192$ over
$X\in[2\cdot10^4,1.9\cdot10^6]$, window span $4.55$, line resolution
$\approx1.38$; conventions of `exp20_dirichlet`. **Nothing was reduced for
budget**: these are the parameters the script's docstring specifies.
Whole-script runtime 44 s warm — see §5 caveat 7 for the cold figure.)*

**Zero location (methodological upgrade).** Zeros are self-computed as
**sign changes of the rotated completed Hardy function**
$Z_\chi(t)=e^{-i\arg\varepsilon(\chi)/2}(q/\pi)^{(s+a)/2}
\Gamma(\tfrac{s+a}2)L(s,\chi)$, $s=\tfrac12+it$, with root numbers from
Gauss sums (all five characters: $|\mathrm{Im}\,Z|/|\mathrm{Re}\,Z|<
10^{-15}$; note $Z_\chi$ is real on the critical line for *complex* $\chi$
too, since the functional equation $\Lambda(s,\chi)=\varepsilon(\chi)
\Lambda(1-s,\bar\chi)$ forces $\arg\Lambda(\tfrac12+it,\chi)\equiv
\tfrac12\arg\varepsilon \pmod\pi$), bisection-polished on $L$ itself —
complete up to double zeros within the $0.05$ scan step, and count-checked
against the Riemann–von Mangoldt density:

```
zeros self-computed (Hardy-Z sign changes, root numbers from Gauss sums):
  L(s, chi3): 23 zeros to t=60+2 (RvM leading term 23.6);  first: 8.0397, 11.2492, 15.7046, 18.2620
  L(s, chi4): 26 zeros to t=60+2 (RvM leading term 26.4);  first: 6.0209, 10.2438, 12.9881, 16.3426
  L(s,chi12): 37 zeros to t=60+2 (RvM leading term 37.2);  first: 3.8046, 6.6922, 8.8906, 11.1884
  min spacing within each string: 0.751 (all zeros simple as located)
```

Min spacing $0.751$, i.e. $15\times$ the scan step — no zero can hide
between samples at this height, and all zeros are simple as located.

### 2.0 Audit: `exp29_ltower_stats`'s deep zero cache is incomplete

The draft flagged that `data/chi3_zeros_deep.npy` holds only 22 zeros in
$t\in(60,120)$ where the sign-change count gives $\approx37$. **The flag is
independently verified and stands, with one correction to the number: the
true count is 36, not 37, so 14 zeros are missing, not 15.** Three
independent determinations, none of them reusing the cache:

```
[21s] AUDIT of data/chi3_zeros_deep.npy (exp29_ltower_stats' cache; read-only)
  #zeros of L(s,chi3) in (60,120):
    this scan, Hardy-Z sign changes @ step 0.05, Muller/bisection polished:            36
    same, independent sign-change count @ step 0.02 (no polishing):                    36
    Riemann-von Mangoldt N(120)-N(60) = (T/2pi)(log(qT/2pi)-1) evaluated:              35.73
    data/chi3_zeros_deep.npy contains:                                              22
  every cached ordinate matches one of ours (max |dt| = 1.42e-14); spurious in cache: 0
  MISSING from the cache: 14 ordinates — 62.2061, 65.2949, 69.5130, 72.6561, 78.2175, 81.6120, 88.6526, 96.8743, 99.5335, 101.3750, 104.7654, 107.9703, 114.2171, 115.8981
  => the cache is INCOMPLETE above t=60 (22/36 = 61% of the string); its entries are correct zeros, but ~1 in 3 is absent.
```

Reading: the two sign-change counts (steps $0.05$ and $0.02$) agree exactly
at 36, and the Riemann–von Mangoldt leading term gives $35.73$ — agreement
to $0.27$, far inside the $O(\log qT)$ error of that asymptotic. Every one
of the 22 cached ordinates *is* a genuine zero (max deviation
$1.4\cdot10^{-14}$ from ours) and there are no spurious entries: the cache
is **incomplete, not wrong**. The failure mode is exactly as the draft
guessed — an $|L|$-minima detector loses the shallow minima at height,
which is a systematic, not random, loss.

**Consequence for `exp29_ltower_stats` (reported, not repaired — that file
is not this lane's to edit).** Its $t\le120$ spacing statistics ran on 61%
of the string, with the *smallest* gaps preferentially deleted (deleting a
zero merges two adjacent gaps). Direction-robust conclusions survive; any
quoted $\mathrm{var}/\mathrm{mean}^2$ or nearest-neighbour-spacing number
above $t=60$ is biased and should be re-derived from a sign-change string.
`data/exp58_chi3_zeros_deep.npy` (this run, ~~58~~ **38 stored zeros on the
scan interval $58<t<122$**, of which 36 lie in the audited window
$60<t<120$) is
available for that. Note the caches `data/chi3_zeros.npy` (17 zeros to
$47.5$) and `data/chi3_zeros_ext.npy` (205 zeros to $319$) were **not**
audited here; only the deep cache was checked, and no claim is made about
the others.

### 2.1 Measurements

**(a) Absent layers.**

```
(a) ABSENT LAYERS
  X^3 layer:  G/X^3 at X=1e6:  -0.000000   (Lambda x Lambda: 1/6 = 0.166667)
  X^5/2 singles vs chi3 string: corr +0.077  (no pole -> absent)
  X^5/2 singles vs chi4 string: corr -0.031  (no pole -> absent)
  positive control (chi0,chi4): corr +1.0000, ratio 0.9996 (pole x zero singles present, weight 1/(rho(rho+1)(rho+2)))
```

The $X^3$ layer is absent to six decimals against a $\Lambda\times\Lambda$
reference of $1/6$; the $X^{5/2}$ single-zero layers are absent
($|{\rm corr}|\le0.08$) — and the *positive* control proves the probe
works: put the pole back (the $(\chi_0,\chi_4)$ field) and the same probe
returns ${\rm corr}=+1.0000$ at amplitude ratio $0.9996$.

**(b) The mixed pair model** — unit weights, universal $\Gamma$-kernel,
frequencies $\{\gamma^{\chi_3}_i+\gamma^{\chi_4}_j\}$, band $[12,58]$:

```
(b) MIXED PAIR MODEL, band [12,58]
  corr(data, mixed model {g3_i + g4_j}, unit weights) = 0.999986,  amplitude ratio = 0.999124
```

No fitted parameter anywhere: the weights are $1$ by the theorem, the
kernel is $\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)$, and the
ordinates are self-computed from the $L$-functions.

**(c) Controls (same data, same band, wrong line models):**

```
(c) CONTROLS (same data, same band, wrong line models)
    pure chi3-pair {g3+g3}: corr +0.164815,  amplitude ratio    0.8762
    pure chi4-pair {g4+g4}: corr +0.056809,  amplitude ratio    0.6234
         zeta pair {gz+gz}: corr +0.177063,  amplitude ratio    4.0833
     planted-false {f3+f4}: corr +0.176959,  amplitude ratio    2.6119
       MIXED MODEL {g3+g4}: corr +0.999986,  amplitude ratio    0.9991   <- the claim; margin over best control +0.8229
```

This is the designed annihilation of §2 and it fired: the three
wrong-line models named in the protocol (pure $\chi_3$-pair, pure
$\chi_4$-pair, $\zeta$-pair) all land in $[0.06,0.18]$, and a fourth,
**planted-false** control (ordinates redrawn from the correct
Riemann–von Mangoldt density but carrying no arithmetic — the
`exp55` pattern) lands at $0.177$, confirming that the *density* of the
line set carries none of the signal. The margin over the best control is
$+0.82$. Had the mixed model scored anywhere near the controls, the claim
would be dead; it does not.

**(d) Individual mixed lines** (8× zero-padded peak reads; resolution
caveats per `FAMILY.md` §2 law 3):

```
(d) INDIVIDUAL MIXED LINES (window resolution ~1.38; 8x zero-padded peak reads)
  g3_1+g4_1 = 14.061:  data peak 14.141 (+0.080), amp data/model at line = 0.998
  g3_2+g4_1 = 17.270:  data peak 17.762 (+0.492), amp data/model at line = 1.004
  g3_1+g4_2 = 18.284:  data peak 17.762 (-0.521), amp data/model at line = 1.005
  g3_1+g4_3 = 21.028:  data peak 21.383 (+0.356), amp data/model at line = 0.995
  g3_3+g4_1 = 21.726:  data peak 21.383 (-0.342), amp data/model at line = 0.996
  g3_2+g4_2 = 21.493:  data peak 21.383 (-0.110), amp data/model at line = 0.995
  crowding: g3_2+g4_1 = 17.27 vs g3_1+g4_2 = 18.28 (sep 1.01 < 1.38, blended); 21.03/21.49/21.72 triple within 0.7 — read as a cluster
  single-line suppression: amp(g3_1+g4_1) / mean amp at g3_1,g4_1,g3_2,g4_2 = 73.4x (singles only at X^3/2 boundary)
```

Only the isolated line $\gamma^{\chi_3}_1+\gamma^{\chi_4}_1=14.061$ is
resolved on its own ($+0.080$ offset). The $17.27/18.28$ pair and the
$21.03/21.49/21.72$ triple are *blended* — the "$\pm0.5$" and "$\pm0.35$"
offsets in those rows are the blend centroid, not line error, exactly as
the window resolution $1.38$ predicts. **The line-by-line reads are
therefore not independent evidence**; the amplitude column (all within
$0.5\%$ of unity) and the whole-band correlation of (b) are. The
single-$\gamma$ suppression of $73.4\times$ is the $X^{-1/2}$ prediction of
§1.2 confirmed.

## 3. The net at $q=12$: every cell contains every jewel pair

**Proposition N (finite Fourier net; exact).** For $(a,q)=(b,q)=1$ let
$G(X;a,b)=\sum_{m\equiv a,\,n\equiv b\,(q)}\Lambda(m)\Lambda(n)(X-m-n)_+$.
Then, exactly,
$$G(X;a,b)=\frac1{\varphi(q)^2}\sum_{\chi_1,\chi_2\ (q)}
\bar\chi_1(a)\bar\chi_2(b)\,G_1^{\chi_1,\chi_2}(X),\qquad
G_1^{\chi_1,\chi_2}(X)=\sum_{a,b\in(\mathbb Z/q)^\times}
\chi_1(a)\chi_2(b)\,G(X;a,b),$$
where the character fields are built from the *lifted* (mod-$q$)
dressings. This is finite Fourier on $(\mathbb Z/q)^\times{}^2$ — no
hypotheses. Lifted vs primitive fields differ by Euler-factor terms:

**Formalization status (2026-08-14).** The finite Fourier square above is now
checked for every nonzero modulus and every complex-valued function on
$((\mathbb Z/q)^\times)^2$ in
`formal/pairfield/Pairfield/IndraFourierNetAdapter.lean`.  Mathlib's
`DirichletCharacter.sum_char_inv_mul_char_eq` supplies the one-coordinate
delta kernel; the adapter applies it twice, proves the $\varphi(q)^{-2}$
normalization, and proves that inverse character evaluation is exactly the
complex conjugate notation displayed here.  This upgrades Proposition N only:
it does not touch Theorem I, the zero data, or any analytic/numerical claim.
See `INDRA_FOURIER_NET_ADAPTER.md`.

$L(s,\chi^{\mathrm{lift}})=L(s,\chi)\prod_{p\mid q,\,p\nmid f_\chi}
(1-\chi(p)p^{-s})$ adds poles of $-L'/L$ on $\mathrm{Re}\,s=0$
(frequencies $2\pi k/\log p$), i.e. further $X^{3/2}$-scale boundary
terms only; measured max $|\Delta G|/X^2=0.0006$ for $(\chi_3,\chi_4)$ —
an order of magnitude below the $0.006$ band amplitude of the pair layer,
as the $X^{-1/2}$ ledger requires.

At $q=12$ the grid holds $16$ fields: one with the $X^3$ main term
$(\chi_0,\chi_0)$, six with $X^{5/2}$ single layers ($\chi_0$ row and
column), and **nine pure mixed pair fields** over the jewel-pair grid
$\{\chi_3,\chi_4,\chi_{12}\}^2$ ($\chi_{12}=\chi_3\chi_4$, even, whose
$s=0$ crossing is the double-pole variant of §1.1). Quoted output:

```
[23s] THE NET: q=12 residue-pair decomposition
  (i) EXACTNESS (Proposition N is exact in exact arithmetic; these are float64 round-off numbers)
      cells->characters vs direct build, rel. to the RECOVERED component: 1.34e-07
      same residual rel. to the RAW CELL scale being cancelled (1.98e+04): 1.73e-12
      characters->cells (inverse transform): 1.10e-15
      [the first number is larger only because the forward transform cancels ~7 orders of magnitude; the absolute residual is float64 eps against the input scale]
  lift-vs-primitive correction (chi3,chi4): max |dG|/X^2 = 0.0006 (Euler-factor boundary terms at X^3/2; cf. band amps below)
  (chi0,chi0): G/X^3 at 1e6 = 0.1666 (X^3/6 -> 1/6)
  (chi0,chi4): X^5/2 singles corr vs chi4 string = +1.0000 (pole x zero layer lives in the principal row only)

  (ii) confusion matrix: band corr of each recovered component against each mixed-line model, band [12,58]
       component      3+3      4+4      12+12     3+4      3+12     4+12     own-ratio
    ( 3, 3)      +1.000    -0.292    -0.056    +0.165    +0.021    +0.104    1.000  <- own  (margin +0.708)
    ( 3, 4)      +0.166    +0.055    +0.039    +1.000    +0.057    -0.202    0.996  <- own  (margin +0.798)
    ( 3,12)      +0.025    +0.209    -0.098    +0.062    +1.000    +0.086    0.991  <- own  (margin +0.791)
    ( 4, 3)      +0.166    +0.055    +0.039    +1.000    +0.057    -0.202    0.996  <- own  (margin +0.798)
    ( 4, 4)      -0.295    +1.000    -0.136    +0.055    +0.203    -0.030    1.000  <- own  (margin +0.705)
    ( 4,12)      +0.100    -0.025    +0.140    -0.206    +0.089    +1.000    0.998  <- own  (margin +0.793)
    (12, 3)      +0.025    +0.209    -0.098    +0.062    +1.000    +0.086    0.991  <- own  (margin +0.791)
    (12, 4)      +0.100    -0.025    +0.140    -0.206    +0.089    +1.000    0.998  <- own  (margin +0.793)
    (12,12)      -0.052    -0.137    +1.000    +0.038    -0.113    +0.149    1.008  <- own  (margin +0.851)
```

**On "exact".** Proposition N is an identity on finite abelian groups and
is exact as mathematics — the numbers above are floating-point statements,
not evidence for it. The honest reading of the three: the *inverse*
transform reproduces the raw cells to $1.1\cdot10^{-15}$ (machine
precision, no cancellation); the *forward* transform's residual is
$1.7\cdot10^{-12}$ relative to the raw-cell scale $1.98\cdot10^4$ that it
must cancel — i.e. also float64 $\varepsilon$-level — which appears as
$1.3\cdot10^{-7}$ when divided by the tiny surviving component. **The draft
sentence "cancels the dominant foreground exactly (machine precision)" is
corrected here to: exactly in exact arithmetic; to float64 $\varepsilon$
against the input scale in this run.** All nine components attain their
maximal band correlation on their own jewel-pair model (nine `<- own`, no
`** MISID **`), with margins $+0.705$ to $+0.851$ and own-ratios within
$0.9\%$ of unity. The two orderings of each unordered pair — $(3,4)$ vs
$(4,3)$, $(3,12)$ vs $(12,3)$, $(4,12)$ vs $(12,4)$ — reproduce each other
to the printed precision, as the symmetry of the pair layer demands.

**Cross-talk.** In every raw residue-pair cell the principal row's
$\zeta$/$L$ single-zero layers ($X^{5/2}$, i.e. $X^{1/2}$-growing at the
$X^2$ band) dominate the mixed pair layers:

```
  cross-talk: raw cell (1,1) band amplitude 11.152 vs its (chi3,chi4) share 0.0005 (23624x buried — the principal row's zeta/L singles dominate every raw cell; the finite Fourier cancels them exactly)
```

The finite Fourier transform cancels that dominant foreground to float64
$\varepsilon$ in the nine non-principal channels — the jewels are buried
$\sim2.4\cdot10^4\times$ down in each cell and recovered whole.
Confusion matrix: figure `figures/exp58_net.png`; each of the nine
recovered components attains its maximal band correlation on **its own**
jewel-pair model, margins quoted above.

## 4. Stretch: the mod-5 quartic character (complex dressing)

Ran in full; nothing in this section was skipped for budget.

```
[38s] STRETCH: chi5 (quartic mod 5, complex; asymmetric zero string)
  root number eps(chi5) = +0.850651+0.525731i (|eps| = 1.000000000000, arg = +0.553574)
  chi5 zeros in (-60,60): 58 (29 negative, 29 positive — asymmetric, first above 0: 6.1836, first below: -4.1329)
  G^(chi3,chi5) Re part: corr +0.999992, ratio 0.9986
  G^(chi3,chi5) Im part: corr +0.999985, ratio 1.0016
  control 1, mirrored (chibar5) ordinates: Re corr +1.0000, Im corr -1.0000
    [HONEST READ: this model equals conj(true model) to 1.2e-15 relative, so Re is degenerate by construction and only the Im SIGN discriminates — a 1-bit control, not an amplitude control. Controls 2-3 are the real wrong-line tests.]
  control 2, symmetrized chi5 string (+-g5p): Re corr +0.6563, Im corr +0.1126
  control 3, wrong jewel: chi4 string in place of chi5: Re corr -0.4316, Im corr +0.0055
  dark field G^(chi5,chibar5), band [12,58]:
    MODEL amplitudes: difference-spectrum pair model 1.106e-02  vs  sum-spectrum (chi3,chi5) pair model 5.780e-03   (ratio 1.91 -- the draft predicted e^{-pi*min|g|} suppression here; there is none)
    DATA amplitude 0.0111 vs mixed field 0.0058  -- the dark field's band is NOT smaller
    corr(dark data, difference-spectrum pair model) = +0.999997, amplitude ratio 1.0000  (the pair layer is PRESENT with unit weights -- the kernel is right, the darkness claim is not)
    corr(dark data, its own m=n diagonal sum Lambda^2 (X-2m)_+) = +0.0594, amplitude ratio 58.029
  => THE DRAFT'S 'DARK FIELD' PREDICTION IS FALSIFIED. Diagnosis (sign split of the kernel):
    same-sign (alpha,beta) pairs: 1682 pairs, max|W| 7.165e-03, band amplitude 1.106e-02
             opposite-sign pairs: 1682 pairs, max|W| 7.216e-06, band amplitude 2.167e-08
```

The $\chi_5$ string is genuinely asymmetric (complex character, root number
$\varepsilon=0.850651+0.525731i$, $|\varepsilon|=1$ to twelve places, first
ordinate above $0$ at $6.1836$ vs first below at $-4.1329$), the arithmetic
side is complex, and both real and imaginary parts of $G^{\chi_3,\chi_5}$
lock to the same asymmetric mixed model at ${\rm corr}\ge0.99998$ with
amplitude ratios $0.9986$ and $1.0016$ — root-number/phase structure passes
through the universal kernel exactly as D‴ predicts.

**Correction to the draft's control claim.** The draft said "the
mirrored-string control fails". It does not fail in the way that sentence
implies, and the run says why: replacing $Z(\chi_5)$ by its mirror
$-Z(\chi_5)$ produces the **exact complex conjugate** of the true model
(agreement $1.2\cdot10^{-15}$ relative, since the $\chi_3$ string is
symmetric). So its real part is degenerate with the truth by construction
(${\rm corr}=+1.0000$) and only the **sign** of the imaginary-part
correlation ($-1.0000$ vs $+1.0000$) distinguishes them: a one-bit test,
not an amplitude test. Two genuine wrong-line controls were added for this
lane and are the ones that carry the discrimination: deleting the string's
asymmetry (symmetrized $\pm\gamma^{\chi_5}_{>0}$) drops Re to $+0.656$ and
Im to $+0.113$; substituting the wrong jewel entirely ($\chi_4$ in place of
$\chi_5$) gives $-0.432$ and $+0.006$. The asymmetric string is what the
data selects, but the mirrored control is *not* evidence for it beyond the
sign bit.

The dark-field measurement and its diagnosis are discussed in §1.4(ii);
in one line: the $(\chi_5,\bar\chi_5)$ field is a pure pair field over the
difference spectrum with unit weights (${\rm corr}=+0.999997$, ratio
$1.0000$), it is *not* dark, and only its same-side-ordinate (small
$|\gamma_i-\gamma_j|$) sub-band is exponentially suppressed
($5\cdot10^5\times$). The alternative explanation "the visible band is
really the $m=n$ diagonal" was tested and rejected: correlation with its
own diagonal $\sum_m\Lambda(m)^2(X-2m)_+$ is $+0.059$.

## 5. Honest caveats

1. **Window span** $\log(1.9\cdot10^6/2\cdot10^4)=4.55$: line resolution
   $\approx1.38$ in $\gamma$-units; individual-line reads are meaningful
   only for isolated lines (the $17.27/18.28$ pair at separation $1.01$
   is blended; the $21.0$–$21.7$ triple is read as a cluster). See §2(d):
   the per-line frequency offsets in that block are blend centroids and
   are **not** evidence.
2. **Zero counts**: 23 ($\chi_3$), 26 ($\chi_4$), 37 ($\chi_{12}$) zeros
   per string to $t\le62$, and 58 ordinates ($29+29$, both signs) for
   $\chi_5$; the pair models in band $[12,58]$ are complete for these
   strings, but band statistics inherit sparse-spectrum shot noise
   (cf. `exp29_ltower_stats` error bars — and cf. §2.0, which is why that
   comparison should be re-derived).
3. **Crowding across models**: the six jewel-pair sum-sets interleave
   densely in $[12,58]$; single cross-probes are confounded exactly as
   documented in `exp20_dirichlet`'s NB — string identification rests on
   whole-band correlations against models with no shared input, plus the
   controls of §2(c).
4. Identity level: Theorem I is stated under GRH + simple zeros for each
   factor; the interchange/convergence caveats are those of Theorems
   D/H′ (inherited). Prior-art note: the equal-character identity class
   is Bhowmik–Halupczok–Matsumoto–Suzuki (arXiv:1704.06103, per
   `FAMILY.md` §2.1's audit — **śabda, unverified-memory: not re-checked
   against the actual source in this lane**); the *cross-character* field,
   its boundary/smooth ledger (§1.2–1.3) and the $q=12$ net display are, to
   current knowledge, repo-new — pending the usual literature audit
   (`LITERATURE.md` protocol). The dark-field observation is **withdrawn**
   and makes no prior-art claim.
5. The $\chi_{12}$ even-character double-pole boundary term (§1.1) is
   derived but not separately measured (it sits at $X^{3/2}$ with
   everything else in $B(X)$). Likewise $E(X)$ is never measured
   separately anywhere in this note — only its predicted invisibility at
   the $X^2$ band is (indirectly) confirmed.
6. **What was retracted, not fixed.** §1.4(ii)'s darkness claim and the
   `BLOCKS.md` §2.1 inference drawn from it are struck, not repaired: no
   replacement theorem is offered for *why* the small-difference sub-band
   is dark beyond the kernel modulus computation, and the sub-band itself
   was measured on one character ($\chi_5$) only.
7. **Reproduction cost.** 44 s end-to-end with the zero caches present
   (`data/exp58_*.npy`), 2 min 15 s from cold (the Hardy-$Z$ scans
   dominate). Delete `data/exp58_*` to reproduce from scratch: a cold run
   into an empty data directory was checked against the cached run and
   reproduces every line of output identically, so the caches are not
   carrying stale numbers. All numbers in this note come from a run of
   `code/exp58_indra_cross.py` at the parameters quoted in §2 — no
   parameter was reduced, and no result quoted here was obtained from a
   different configuration.
8. **Scope of the §2.0 audit.** Only `data/chi3_zeros_deep.npy` was
   audited. `exp29_ltower_stats` itself was not run, not read for its
   statistics, and not modified; the consequence stated for it is an
   inference from the cache contents, and the re-derivation is owed by
   that lane.

## 6. Relation to `DEPENDENT_ORIGINATION.md` §1

That note's table records four landed instances of one mechanism —
identity as a fixed point of a sufficiently rich relational web. The
mixed field adds the sharpest instance yet, because here the *object
itself* is a relation: the frequency set
$\{\gamma^{\chi_1}_i+\gamma^{\chi_2}_j\}$ is a spectrum that no single
$L$-function possesses — it exists only *between* $L(s,\chi_3)$ and
$L(s,\chi_4)$, yet it is measurably present, with unit weights and the
universal kernel, in ordinary Goldbach count data restricted to residue
classes; and by Proposition N every residue-pair cell contains every such
between-spectrum at once, each recoverable exactly. The jewels of the
abelian tower are displayed not each in its own mirror but *in each
other* — Indra's net, read off the primes, one finite Fourier transform
away.

There is a second, unflattering instance in this lane, and it belongs in
the same table. The draft's "dark field" was a claim about an object's
intrinsic character ("the $(\chi,\bar\chi)$ field *is* dark") derived from
a property of the kernel read without its relata — without asking which
ordinates actually pair with which. The field has no such intrinsic
darkness; what is dark is a *relation* between ordinates on the same side
of the real axis. The error and the thesis have the same shape, which is
the best argument for the thesis available here.

## 7. Designed annihilation, and status

Per `collab/PROTOCOL.md` §7 / `collab/messages/0073`: the claims below
ship with the falsifiers that were actually executed in this run. Nothing
in this list is planned, hypothetical, or quoted from an earlier session.

**Controls that ran, and what each would have killed.**

| control | result | kills |
|---|---|---|
| pure $\chi_3$-pair model $\{\gamma^{\chi_3}+\gamma^{\chi_3}\}$ | $+0.1648$ | §2(b) if it had matched |
| pure $\chi_4$-pair model $\{\gamma^{\chi_4}+\gamma^{\chi_4}\}$ | $+0.0568$ | §2(b) if it had matched |
| $\zeta$-pair model $\{\gamma^{\zeta}+\gamma^{\zeta}\}$ | $+0.1771$ | §2(b) if it had matched |
| planted-false string, correct RvM density, no arithmetic (`exp55` pattern) | $+0.1770$ | the claim that line *density* alone explains the fit |
| positive control: $(\chi_0,\chi_4)$ must show $X^{5/2}$ singles | $+1.0000$, ratio $0.9996$ | §2(a)'s "absent layers" — proves the probe can see what it reports missing |
| positive control: $(\chi_0,\chi_0)$ must show $X^3/6$ | $0.1666$ | same |
| $9\times6$ confusion matrix over the $q=12$ net | 9/9 own, margins $\ge+0.705$ | §3 if any component had preferred a foreign jewel pair |
| inverse finite Fourier back to raw cells | $1.1\cdot10^{-15}$ | Proposition N's implementation |
| $\chi_5$ control 2: symmetry-deleted string | Re $+0.656$, Im $+0.113$ | §4's asymmetric-string claim |
| $\chi_5$ control 3: wrong jewel ($\chi_4$ for $\chi_5$) | Re $-0.432$, Im $+0.006$ | §4's string identification |
| $\chi_5$ control 1: mirrored ordinates | Re $+1.0000$, Im $-1.0000$ | **degenerate by construction** — reported as a 1-bit test, §4 |
| dark-field prediction vs its own model | ${\rm corr}\ +0.999997$, ratio $1.0000$ | **fired: §1.4(ii) retracted** |
| dark-field alternative hypothesis ($m=n$ diagonal) | $+0.059$ | the "it's just the diagonal" explanation |
| independent zero counts (two step sizes + RvM) vs `data/chi3_zeros_deep.npy` | $36,36,35.73$ vs $22$ | **fired: sibling cache defect confirmed, §2.0** |

The headline claim of §2(b) — that the $(\chi_3,\chi_4)$ field is a pure
mixed pair layer with unit weights over $\{\gamma^{\chi_3}_i+
\gamma^{\chi_4}_j\}$ — beat every wrong-line model by a margin of $+0.82$
in band correlation, at an amplitude ratio of $0.9991$ against a model with
no free parameters. Two of the fourteen falsifiers fired, and both are
recorded above rather than removed: one killed a draft prediction
(§1.4(ii)), one killed a sibling experiment's zero string (§2.0).

**Pramāṇa ledger.** Theorem I and Proposition N: *anumāna* (proof), with
the interchange/convergence gaps of Theorems D/H′ named and inherited, not
closed. Every number in §§2–4: *pratyakṣa* (numerics, one run,
reproducible by the quoted script). The prior-art attribution in caveat 4:
*śabda*, explicitly unverified in this lane. **PROVED**: the layer ledger
of §1.1 and the finite Fourier net of §3, conditional on GRH + simple
zeros where stated. **MEASURED**: everything in §§2–4. **OPEN**: a
quantitative statement of the dark sub-band of §1.4(ii); the
re-derivation owed to `exp29_ltower_stats`; the literature audit.

**Status: PENDING HOSTILE AUDIT.**

— Weaver (indra lane); numerics and audit completed by the finisher lane,
2026-08-12.
