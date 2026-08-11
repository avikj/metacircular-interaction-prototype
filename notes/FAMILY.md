# The residue-dressing family: one spectrum, four fields, and a purity hierarchy

Companion to `LIOUVILLE.md` (Theorem H), `BLOCKS.md`, `REPORT.md` §7a.
Verified in `code/exp16_mobius.py` → `figures/exp16_mobius.png`.

## 1. Theorem H′ (Möbius–Goldbach trace formula)

$\sum\mu(n)n^{-s}=1/\zeta(s)$ has **no pole anywhere**, so the double explicit
formula predicts the extreme member of the family: with $v_\rho=1/\zeta'(\rho)$,
under RH + simple zeros,
$$G_1^\mu(X)=\sum_{m,n\ge1}\mu(m)\mu(n)(X-m-n)_+
=\sum_{\rho,\rho'}v_\rho v_{\rho'}\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}X^{\rho+\rho'+1}
+O(X^{3/2+\varepsilon}):$$
**no main term, no single-zero layer**. The smoothed Möbius–Goldbach average
*is* the sum-spectrum of the zeta zeros, with no foreground. (Absolute
convergence of the pair sum uses Gonek-type bounds on $\sum1/|\zeta'(\rho)|^2$
— the same caveat as `LIOUVILLE.md`; simple zeros assumed throughout.)

**Verified (exp16; $\mu$ to $2\cdot10^6$, 40 zeros, mpmath weights):**
- pair band $[28.5,60]$: corr **0.9999**, amplitude ratio **0.9999**;
- total mean of $G_1^\mu/X^2$: $+0.00007$ (predicted $0$);
- pair lines $2\gamma_1,\ \gamma_1{+}\gamma_2,\ 2\gamma_2$ at ratios 1.00, 1.00, 1.01;
- single-$\gamma$ lines suppressed by an order of magnitude relative to pair
  lines (single-band RMS $6\times$ below pair band; the residue is the
  $X^{3/2}$ boundary layer, e.g. $\mu(1)\cdot\sum_n\mu(n)(X{-}1{-}n)$-type edge
  terms) — where for $\Lambda$ the single lines *dominate* the pair lines by
  $\sim500\times$. The layer that is the loudest foreground of the prime field
  is *absent* from the Möbius field, as the pole count demands.

**Corollary (signed simplex average of two-point Möbius).** The diagonal
contributes $\sum_{2m\le X}\mu(m)^2(X-2m)=\frac{3}{2\pi^2}X^2+O(X^{3/2})$
deterministically (squarefree density $6/\pi^2$; measured $0.151992$ and
$0.151982$ at $X=10^5,10^6$ vs $3/2\pi^2=0.151982$), so
$$\sum_{\substack{m\ne n\\ m+n\le X}}\mu(m)\mu(n)(X-m-n)
=-\frac{3}{2\pi^2}X^2+\text{osc}=-0.151982\,X^2+\text{osc}$$
(measured: $-0.1473$, $-0.1534$ at $X=10^5,10^6$ — oscillating about the
predicted constant). An exact negative closed form for the smoothed simplex
average of two-point Möbius, while the pointwise two-point statement stays
open.

## 2. The classification

One zero spectrum $\{\gamma\}$; each completely multiplicative-ish dressing $a$
reads it through the residues of its generating series $D_a(s)$ at the zeros,
and its pole set determines which foreground layers exist:

| $a$ | $D_a(s)$ | poles | residue at $\rho$ | layers of $G_1^a$ | scales |
|---|---|---|---|---|---|
| $\Lambda$ | $-\zeta'/\zeta$ | $s=1$ | $1$ | main / single / pair | $X^3$ / $X^{5/2}$ / $X^2$ |
| $\lambda$ | $\zeta(2s)/\zeta(s)$ | $s=\tfrac12$ | $\zeta(2\rho)/\zeta'(\rho)$ | main / single / pair | $X^2$ / $X^2$ / $X^2$ (degenerate) |
| $\mu$ | $1/\zeta(s)$ | — | $1/\zeta'(\rho)$ | pair only | $X^2$ (pure) |
| $d$ | $\zeta(s)^2$ | $s=1$ (double) | $0$ (double **zeros** at $\rho$) | log-enhanced main only; zero layers absent | $X^3\log^2 X$-type |

Structural laws visible in the table, all now verified rows 1–3
(exp6b/exp11 · exp15 · exp16):

1. **Layer algebra (corrected per `CROSSREVIEW_WAVE2.md`).** The layers of
   $\sum a(m)b(n)(X{-}m{-}n)_+$ are the *pairwise products of the singularity
   sources of the two Mellin factors*, where the sources are
   poles $\cup$ {the zero string} $\cup$ {$s=0$} (exp18), with
   residue-vanishing deletions (row $d$: double zeros kill the string).
   For a self-field with one pole this gives the familiar three zero-visible
   layers (pole², pole×zero, zero²) plus $s=0$ crossings. $\mu$ is the
   terminal object: poleless, hence pure pair.
2. **Scale spacing = pole location.** $\Lambda$'s pole at $1$ spreads the stack
   over $X^3/X^{5/2}/X^2$; $\lambda$'s critical pole at $\tfrac12$ collapses it
   to a single scale; $\mu$ removes it.
3. **The $\Gamma$-part is universal, the residue part is the dressing.** All
   weight laws built from the archimedean integral — decay $s^{-5/2}$ (D′),
   modulus $\sqrt{2\pi}s^{-5/2}$ and entropy phase (D‴), the Fresnel gap
   inversion (G) — hold across the family verbatim; the arithmetic function
   only multiplies in $w_\rho$ per zero. **Verified in practice (exp19):**
   from Liouville data *alone*, the single lines calibrate the complex
   dressings ($w_1,w_2$ recovered to 1.5%/0.9% against mpmath truth, which
   is used only for validation), and the offset-subtracted pair-line phases
   recover $\gamma_2-\gamma_1$ to **0.0%** and $\gamma_3-\gamma_1$ to 1.4% —
   $\gamma_2=21.024$ (true 21.022) read entirely from $\lambda$. The
   degeneracy also bites back: singles and pairs interleave at equal
   amplitude, so line density doubles and crowded lines (the single line at
   $\gamma_4=30.425$ sits 2.2 rad from the $\sim38\times$-stronger $(1,1)$ pair
   line at 28.269, corrupting the $w_4$ calibration; similarly $w_3$ and the
   $(2,2)$ reading) are blocked
   by window resolution — a quantified spectral-crowding limit, not a
   failure of the phase law.
4. **Simplex-average two-point corollaries.** For each field the diagonal is
   deterministic and the trace formula fixes the smooth $X^2$ coefficient, so
   the *off-diagonal* smoothed average has an exact closed form:
   $-0.065862\,X^2$ for $\lambda$ (from $\pi/8\zeta(1/2)^2-\tfrac14$),
   $-0.151982\,X^2$ for $\mu$ (from $0-\tfrac{3}{2\pi^2}$). These are
   theorem-side (holomorphic) shadows of the Chowla conjectures, which remain
   the Hermitian side of the same fields.

## 2.1 The abelian tower (exp20)

The net extends beyond $\zeta$: for the quadratic character $\chi_3$,
$-L'/L(s,\chi_3)$ has **no pole** ($L(1,\chi_3)\ne0$) and residue $1$ at every
zero of $L(s,\chi_3)$, so the twisted field
$\sum\Lambda(m)\chi_3(m)\Lambda(n)\chi_3(n)(X-m-n)_+$ is another **pure pair
field** — over a *new jewel string*, with *unit* weights (pure D‴ structure):
$$G_1^{\chi_3}(X)=\sum_{\rho,\rho'\in Z(L(\cdot,\chi_3))}
\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}X^{\rho+\rho'+1}+\text{smooth}.$$

Verified fully self-contained (exp20): the L-zeros are computed from scratch
(mpmath/Hurwitz; first ordinates $8.0397, 11.2492, 15.7046,\dots$), the
arithmetic side from the sieve. Results: $X^3$ absent ($-0.000000$ vs $1/6$);
pair band corr **0.9994**, ratio **1.0004**; L-pair lines $2L_1$, $L_1{+}L_2$,
$2L_2$, $L_1{+}L_3$ to $0.3$–$0.7\%$; L-single lines suppressed $30$–$40\times$
(no pole to cross against). Caveat recorded in the code: the sum sets of the
$\zeta$ and $L$ spectra interleave too densely for isolated cross-probes at
this window span; string identification rests on the L-only model's $0.999+$
correlation. **Each Dirichlet character is a jewel: its twisted Goldbach
data displays the sum spectrum of its own $L$-zeros through the same
$\Gamma$-net.**

## 2.2 Finite-place fingerprints: three visibility classes (exp21)

Measuring both individual spectral atoms $|{\rm mean}\ a(n)e(an/q)|$ and
Ramanujan projections ${\rm mean}\ a(n)c_q(n)$ for all four dressings
($X=2\cdot10^6$, all to 4 decimals):

| dressing | Ramanujan (Galois-inv.) projections | individual atoms | class |
|---|---|---|---|
| $\Lambda$ | $\mu(q)$ | $|\mu(q)|/\varphi(q)$ | fully visible |
| $\Lambda\chi_3$ | **all $0$** | $\sin(2\pi/3)=0.8661$ at $q=3,6$ (vanishes at $q=9$: $1+\omega+\omega^2=0$; measured 0.0004) | Galois-twisted only |
| $\lambda,\ \mu$ | $0$ | $0$ | invisible |

And the Galois action is now a *lever*: $u=2\in(\mathbb Z/3)^\times$ fixes
$\Lambda$'s level-3 atom (ratio $+1.000$) and moves $\Lambda\chi_3$'s by exactly
$\chi(2)=-1.000$ (measured). The protection/exposure duality
(`LIOUVILLE.md`) refines to a hierarchy: full > twisted-only > none at the
finite places, while all four dressings display their zero spectra at full
strength at the archimedean place (exp6b/15/16/20). This answers the
"Galois remark" of `ADELIC.md` §1: the class-field action acts nontrivially
exactly on the character sector, i.e. on the twisted pair fields of §2.1.

## 2.3 The k-body ladder (exp22; companion to sibling `TERNARY.md`)

The sibling branch built the ternary (cubic) field's layer/block structure
and stopped at "the triple layer is below the reach of the present
numerics." Two additions close the chapter:

**Theorem D‴-k (k-body weight law; verified k = 2, 3, 4).** The
$k$-th-variation weight $W_k=\Gamma(2)\prod\Gamma(\rho_i)/\Gamma(\sum\rho_i+2)$
obeys, with $s=\sum\gamma_i$, $p_i=\gamma_i/s$:
$$W_k=(2\pi)^{\frac{k-1}{2}}\,s^{-\frac{k+3}{2}}\,
e^{-i\left(s\,H_k(\vec p)+\frac{(k+3)\pi}{4}\right)}
\Bigl(1+O\bigl(\tfrac1{\min\gamma_i}\bigr)\Bigr),\qquad
H_k(\vec p)=-\sum p_i\log p_i.$$
Modulus depends only on the total $s$ at every order; the phase is the
$k$-ary splitting entropy (stationary at the equal split $p_i=1/k$ — the
atom evaluates the $k$ waves at the equilibrium partition $m_i^*=p_iX$);
the Maslov ladder is $(k+3)\pi/4$. Measured: modulus ratios $0.99999$ with
max deviations $0.31\%/0.08\%/0.05\%$ for $k=2/3/4$; phase rms
$0.005$–$0.009$ rad with $1/\min$ envelopes.

**Corollary (diffraction hierarchy).** Near the equal split the phase is a
$(k-1)$-dimensional Fresnel form, so band coherence should decay like
$s^{-(k-1)/2}$ — each body adds one transverse Cornu factor. Measured
slopes: $-0.68$ ($k=2$), $-1.66$ ($k=3$) against leading-order $-0.5$, $-1.0$:
the hierarchy (steepening by roughly a factor 2 per added dimension) is
confirmed; the systematic excess is log-density growth and simplex-edge
structure beyond the leading Fresnel model — flagged, not hidden.

**Why the triple layer resists data extraction (quantified).** The first
six triple lines sit $0.09$–$0.74$ rad from the nearest (much stronger) pair
line — all inside the $\sim1.4$ rad window resolution (e.g.
$3\gamma_1=42.404$ vs $2\gamma_2=42.044$). The obstruction is spectral
crowding, exactly as for the $\lambda$-field's crowded lines (§2.3 above),
not amplitude: resolving it needs $\log X$ spans an order of magnitude
longer, not more precision.

## 3. Where this points

- The $d(n)$ row is the **anti-Möbius**: $\zeta^2$ has double *zeros* at every
  $\rho$, so the residues vanish and the $d$-field carries *no zeta-zero
  layer at all* — all foreground, no spectrum (its fluctuation spectrum is
  instead Voronoi's $\sqrt{nX}$ frequencies). The purity axis runs
  $d\ \to\ \Lambda\ \to\ \lambda\ \to\ \mu$: from all-pole/no-zero to
  all-zero/no-pole. It is exactly the two ends of this axis that are
  "solvable" — $d$ by $GL_2$ spectral theory on the $D$-side
  (Estermann/Motohashi, `REPORT.md` §7a), $\mu$ by being pure spectrum on the
  $S$-side — while the arithmetic-progression middle ($\Lambda$) is where both
  structures superpose. Solvability at the ends, conjecture in the middle.
- **Cross-dressings are compositional — verified, with a discovered layer
  (exp18).** The ordered field $\sum\Lambda(m)\mu(n)(X{-}m{-}n)_+$: the $X^3$
  main term is *annihilated* ($\mu$ has no pole; measured $G_1/X^3\to0.00000$
  vs $\Lambda$'s $1/6$); the single-zero layer survives at $X^{5/2}$ **with
  Möbius weights** $v_\rho=1/\zeta'(\rho)$ (corr 1.0000, ratio 1.0000); the
  pair layer carries the ordered weights $-1\otimes v$ (corr 1.0000, ratio
  1.0008). And the experiment corrected its own bookkeeping: the pole/zero
  layer algebra misses the **$s=0$ layer** — $M(v)$'s constant $1/\zeta(0)=-2$
  pairs with $\Lambda$'s pole to give the smooth term
  $\tfrac{1}{2\zeta(0)}X^2=-X^2$, *measured $-0.99986$: the arithmetic data
  reads off $\zeta(0)=-\tfrac12$ to four digits.* Corrected corollary: the
  diagonal $\Lambda\mu$ gives $-X^2/4$ (prime density), so
  $\sum_{m\ne n}\Lambda(m)\mu(n)(X{-}m{-}n)=-(3/4)X^2+\text{osc}$ (measured
  $-0.7551$, $-0.7484$ about $-0.75$; NB these readings are
  *single-layer-subtracted* — the $X^{5/2}$ oscillation grows like
  $X^{1/2}\cos(\gamma\log X)$ at $X^2$ normalization and asymptotically
  dominates the constant, so the corollary is about the smooth coefficient,
  not a pointwise limit). Moral: the complete layer algebra is
  indexed by *all* singularities of the two Mellin factors — poles, zeros,
  **and the $s=0$ residue** — composed pairwise.
- The Fresnel-zone resummation (`FRESNEL.md` §4) applies to the pure field
  most cleanly: for $\mu$ there is no foreground to subtract at all.

## Appendix: reproducibility

| artifact | produces |
|---|---|
| `code/exp16_mobius.py` | Theorem H′ verification: pure pair band, suppressed singles, diagonal/off-diagonal corollary; caches `data/mobius_weights_40.npy`; `figures/exp16_mobius.png` |

## 2.4 Sieve-circuit control run (exp24; closes INDEX join #3)

The sibling's `LENS_CIRCUIT.md` formalizes $\mathrm{SIEVE}_d(S,Q)$; by their
CRT normal form every depth-2 sieve circuit is a union of residue classes
mod its lcm $L$, so the best achievable circuit correlation
$\mathrm{adv}_a(L)=\sum_c\max(d_a(L,c),0)$ is exactly computable. Measured
over $L\in\{2,\dots,30\}$ at $X=2\cdot10^6$:

| dressing | $\mathrm{adv}(L)$ measured | prediction |
|---|---|---|
| $\Lambda$ | $1-\varphi(L)/L$ to 4 decimals at all 11 moduli | fully sieve-visible |
| $\Lambda\chi_3$ | $0.5000$ exactly when $3\mid L$, noise floor otherwise | **one literal deep** |
| $\lambda,\ \mu$ | $\le0.003$ (the $O(X^{-1/2})$ floor) at every $L$ | sieve-protected |

Two refinements over exp21: (i) sieve *literals* are strictly finer probes
than Ramanujan projections — they see the character sector the
Galois-invariant algebra misses, so the probe hierarchy is
Ramanujan $<$ sieve literals $<$ all additive characters, with $\Lambda$
visible to all levels, $\Lambda\chi$ from literals up, $\lambda,\mu$ to none;
(ii) the pure fields are exactly the **fixed points of the SIEVE calculus** —
the control objects the sibling's $\lambda$-orthogonality theorems
(their Thms 1/1″) describe, here measured as a uniform noise floor across
every modulus.

## 2.5 The anti-Möbius null test (exp25; row 4 verified)

The divisor field's Mellin factor $\zeta(s)^2$ has double **zeros** at every
$\rho$, so its residues vanish: row 4 of the table predicts *no zeta-zero
layer at all*. Verified as a null test with a positive control in identical
units (same pipeline, same scale $X^3$, degree-5 log-polynomial detrend):
the $\Lambda$ field shows $\gamma_1$ as a $27\times$-broadband outlier, while
the divisor field's $\gamma$-bins are statistically indistinguishable from
its own broadband (contrasts $1.1$–$3.8\times$ against a band fluctuation
ceiling of $6.9\times$; percentile ranks 56–92%). The purity axis
$d\to\Lambda\to\lambda\to\mu$ is now verified at **both ends**: all-pole/no-zero
($d$, this section) and all-zero/no-pole ($\mu$, §1). Complements the
sibling's `exp15_divisor` (Ingham marginals): their result is what the
$d$-field *has* (solvable local structure), this one is what it *lacks*
(zeta spectrum).
