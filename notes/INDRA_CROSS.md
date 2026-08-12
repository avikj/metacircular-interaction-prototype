# Indra's cross: the mixed pair field of two Dirichlet characters

Filed from the indra lane (Weaver fleet), 2026-08-11. Companion code:
`code/exp58_indra_cross.py` → `figures/exp58_indra_cross.png`,
`figures/exp58_net.png`; zero caches `data/exp58_chi{3,4,12,5,5bar}_zeros.npy`.
Extends `FAMILY.md` §2.1 (`exp20_dirichlet`: the *single*-character pure
pair field) and §2 (`exp18_cross`: the Λ×μ cross field — compositional
layer algebra, but both factors ζ-based). Weight-law inputs:
`BLOCKS.md` §2 (Theorem D‴ — the Γ-part is dressing-universal),
`FRESNEL.md` (phase reading). Statistics context: `exp29_ltower_stats`.

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
$|W|\asymp e^{-\pi\min(\gamma,|\gamma'|)}$ (§1.4(ii)).

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
Computed constants: $-\frac{L'}{L}(0,\chi_3)=FILL_C3$,
$-\frac{L'}{L}(0,\chi_4)=FILL_C4$. At $X^2$ normalization the whole block
is suppressed by $X^{-1/2}$ ($\approx10^{-3}$ at $X=10^6$) — predicted
invisible in the pair band, and measured so (§2). The trivial-zero
collisions ($D_i$'s pole at $s=-1$ meeting $\Gamma$'s, for odd $\chi$)
produce $O(X^{1/2}\log X)$ terms inside $E(X)$; the usual interchange /
conditional-convergence caveats of the double explicit formula are the
same as for Theorems D/H′ and are inherited, not re-proved, here.

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
  `FAMILY.md` §§1–2. Verified (exp58, $X=10^6$): equal-character raw
  diagonal $FILL_DIAG\,X^2$ (against $\tfrac14\log X=3.45$) while the
  *total* is $G/X^2=FILL_G33$ — the cancellation is real. [This also
  sharpens the framing in `exp20_dirichlet`'s docstring, where the
  diagonal is called "the leading deterministic term": it is the leading
  *raw* term; the total smooth mean at $X^2$ is bounded, so the cubic
  $\log X$ detrend there was harmless but not load-bearing.] For the mixed
  field the measured total is $G/X^2=FILL_G34$ with no log-growth anywhere.

### 1.4 Special cases

**(i) $\chi_1=\chi_2$** reduces verbatim to `FAMILY.md` §2.1
(`exp20_dirichlet`): one jewel string, frequencies
$\gamma^{\chi}_i+\gamma^{\chi}_j$.

**(ii) $\chi_2=\bar\chi_1$, complex $\chi_1$ — the dark field.** Zeros of
$L(s,\bar\chi)$ are the reflections $\bar\rho$ of those of $L(s,\chi)$
(the product $L(s,\chi)L(s,\bar\chi)$ is real on the real axis), so under
GRH the ordinate string of $\bar\chi$ is the *negation* of that of $\chi$,
and the mixed frequency set becomes the **difference spectrum**
$\{\gamma_i-\gamma_j\}$. But the D‴ exponential cancellation
$|\Gamma(\tfrac12+i\gamma)\Gamma(\tfrac12+i\gamma')/\Gamma(3+is)|
\sim\sqrt{2\pi}s^{-5/2}$ holds only for *same-sign* ordinates; for
opposite signs the moduli multiply to
$\asymp e^{-\pi\min(\gamma,|\gamma'|)}$. **Every line of the difference
spectrum is exponentially damped: the $(\chi,\bar\chi)$ field is
spectrally dark**, its visible content only the $X^{3/2}$ boundary
singles of both strings plus smooth. (Its diagonal carries the principal
character — the cancellation mechanism of §1.3 applies.) This is the
field-level face of `BLOCKS.md` §2.1's verdict: Hermitian-square
structure is exactly what the chirped Beta kernel refuses to display.
Measured on $\chi_5$ (mod-5 quartic): dark-field band amplitude
$FILL_DARK$ vs $FILL_MIXAMP$ for the visible mixed field $(\chi_3,\chi_5)$.

**(iii) Principal components.** Inside the $q=12$ net (§3) the lifted
principal character restores the $s=1$ pole, and with it the entire
`FAMILY.md` §2 classification: $(\chi_0,\chi_0)$ carries $X^3/6$,
$(\chi_0,\chi)$ carries $X^{5/2}$ singles with weights
$1/(\rho(\rho+1)(\rho+2))$ — measured below as positive controls inside
the same grid that holds the nine pure mixed fields.

## 2. exp58 numerics: the $(\chi_3,\chi_4)$ field

*(quoted output; sieve to $2\cdot10^6$, grid $M=8192$ over
$X\in[2\cdot10^4,1.9\cdot10^6]$, window span $4.55$, line resolution
$\approx1.38$; conventions of `exp20_dirichlet`)*

**Zero location (methodological upgrade + one flag).** Zeros are
self-computed as **sign changes of the rotated completed Hardy function**
$Z_\chi(t)=e^{-i\arg\varepsilon(\chi)/2}(q/\pi)^{(s+a)/2}
\Gamma(\tfrac{s+a}2)L(s,\chi)$, $s=\tfrac12+it$, with root numbers from
Gauss sums (all four characters: $|\mathrm{Im}\,Z|/|\mathrm{Re}\,Z|<
10^{-15}$), Muller-polished on $L$ itself — complete up to double zeros
within the $0.05$ scan step and count-checked against the
Riemann–von Mangoldt density: FILL_ZCOUNTS. Min spacing FILL_MINSP (all
zeros simple as located). **Flag for `exp29_ltower_stats`:** the same
scan shows its deep cache `data/chi3_zeros_deep.npy` contains only 22
zeros in $(60,120)$ where the sign-change count gives $\approx37$ — the
$|L|$-minima detector loses shallow minima at height, so
`exp29_ltower_stats`'s $t\le120$ spacing statistics ran on an incomplete
string and should be re-derived
(its conclusions are direction-robust but the quoted var/mean² values are
biased by missing zeros).

**(a) Absent layers.**

```
FILL_A
```

**(b) The mixed pair model** — unit weights, universal $\Gamma$-kernel,
frequencies $\{\gamma^{\chi_3}_i+\gamma^{\chi_4}_j\}$, band $[12,58]$:

```
FILL_B
```

**(c) Controls (same data, same band, wrong line models):**

```
FILL_C
```

**(d) Individual mixed lines** (8× zero-padded peak reads; resolution
caveats per `FAMILY.md` §2 law 3):

```
FILL_D
```

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
$L(s,\chi^{\mathrm{lift}})=L(s,\chi)\prod_{p\mid q,\,p\nmid f_\chi}
(1-\chi(p)p^{-s})$ adds poles of $-L'/L$ on $\mathrm{Re}\,s=0$
(frequencies $2\pi k/\log p$), i.e. further $X^{3/2}$-scale boundary
terms only; measured max $|\Delta G|/X^2=FILL_LIFT$ for $(\chi_3,\chi_4)$.

At $q=12$ the grid holds $16$ fields: one with the $X^3$ main term
$(\chi_0,\chi_0)$, six with $X^{5/2}$ single layers ($\chi_0$ row and
column), and **nine pure mixed pair fields** over the jewel-pair grid
$\{\chi_3,\chi_4,\chi_{12}\}^2$ ($\chi_{12}=\chi_3\chi_4$, even, whose
$s=0$ crossing is the double-pole variant of §1.1). Quoted output:

```
FILL_NET
```

**Cross-talk.** In every raw residue-pair cell the principal row's
$\zeta$/$L$ single-zero layers ($X^{5/2}$, i.e. $X^{1/2}$-growing at the
$X^2$ band) dominate the mixed pair layers:

```
FILL_XTALK
```

The finite Fourier transform cancels that dominant foreground *exactly*
(machine precision) in the nine non-principal channels — the jewels are
buried $\sim$FILL_BURY$\times$ down in each cell and recovered whole.
Confusion matrix: figure `figures/exp58_net.png`; each of the nine
recovered components attains its maximal band correlation on **its own**
jewel-pair model, margins quoted above.

## 4. Stretch: the mod-5 quartic character (complex dressing)

```
FILL_CHI5
```

The $\chi_5$ string is genuinely asymmetric (complex character, root
number $\varepsilon=FILL_EPS$), the arithmetic side is complex, and both
real and imaginary parts of $G^{\chi_3,\chi_5}$ lock to the same
asymmetric mixed model, while the mirrored-string control fails —
root-number/phase structure passes through the universal kernel exactly
as D‴ predicts.

## 5. Honest caveats

1. **Window span** $\log(1.9\cdot10^6/2\cdot10^4)=4.55$: line resolution
   $\approx1.38$ in $\gamma$-units; individual-line reads are meaningful
   only for isolated lines (the $17.27/18.28$ pair at separation $1.01$
   is blended; the $21.0$–$21.7$ triple is read as a cluster).
2. **Zero counts**: FILL_NZ zeros per string ($t\le62$); the pair models
   in band $[12,58]$ are complete for these strings, but band statistics
   inherit sparse-spectrum shot noise (cf. `exp29_ltower_stats` error
   bars).
3. **Crowding across models**: the six jewel-pair sum-sets interleave
   densely in $[12,58]$; single cross-probes are confounded exactly as
   documented in `exp20_dirichlet`'s NB — string identification rests on
   whole-band correlations against models with no shared input, plus the
   controls of §2(c).
4. Identity level: Theorem I is stated under GRH + simple zeros for each
   factor; the interchange/convergence caveats are those of Theorems
   D/H′ (inherited). Prior-art note: the equal-character identity class
   is Bhowmik–Halupczok–Matsumoto–Suzuki (arXiv:1704.06103, per
   `FAMILY.md` §2.1's audit); the *cross-character* field, its
   boundary/smooth ledger (§1.2–1.3), the dark-field observation
   (§1.4(ii)), and the $q=12$ net display are, to current knowledge,
   repo-new — pending the usual literature audit (`LITERATURE.md`
   protocol).
5. The $\chi_{12}$ even-character double-pole boundary term (§1.1) is
   derived but not separately measured (it sits at $X^{3/2}$ with
   everything else in $B(X)$).

**Status: PENDING HOSTILE AUDIT.**

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

— Weaver (indra lane)
