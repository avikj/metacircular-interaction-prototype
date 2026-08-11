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
*is* the sum-spectrum of the zeta zeros, with no foreground.

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

1. **Layer count = pole count + 1.** Each pole of $D_a$ contributes a
   foreground layer through pole×pole and pole×zero blocks; the zero×zero
   pair layer is universal. $\mu$ is the **terminal object**: poleless, hence
   pure.
2. **Scale spacing = pole location.** $\Lambda$'s pole at $1$ spreads the stack
   over $X^3/X^{5/2}/X^2$; $\lambda$'s critical pole at $\tfrac12$ collapses it
   to a single scale; $\mu$ removes it.
3. **The $\Gamma$-part is universal, the residue part is the dressing.** All
   weight laws built from the archimedean integral — decay $s^{-5/2}$ (D′),
   modulus $\sqrt{2\pi}s^{-5/2}$ and entropy phase (D‴), the Fresnel gap
   inversion (G) — hold across the family verbatim; the arithmetic function
   only multiplies in $w_\rho$ per zero. In particular gap-reading à la
   `FRESNEL.md` works from Möbius or Liouville data too: single-layer phases
   calibrate $\arg w_\rho$ (for $\lambda$), pair-line phases then yield
   $(\gamma-\gamma')^2/2f$.
4. **Simplex-average two-point corollaries.** For each field the diagonal is
   deterministic and the trace formula fixes the smooth $X^2$ coefficient, so
   the *off-diagonal* smoothed average has an exact closed form:
   $-0.065862\,X^2$ for $\lambda$ (from $\pi/8\zeta(1/2)^2-\tfrac14$),
   $-0.151982\,X^2$ for $\mu$ (from $0-\tfrac{3}{2\pi^2}$). These are
   theorem-side (holomorphic) shadows of the Chowla conjectures, which remain
   the Hermitian side of the same fields.

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
- Cross-dressings $\sum a(m)b(n)$ ($a\ne b$) interpolate rows: e.g.
  $\Lambda\times\mu$ has one pole (from $\Lambda$) ⟹ main $=0$? No —
  pole×pole needs both; $\Lambda\times\mu$ has main term $0$, single layers
  from $\Lambda$'s pole × $\mu$'s zeros ($X^{3/2}$-scale, weights $v_{\rho}$)
  and from... — a clean exercise; predicted fully by the same mechanism.
- The Fresnel-zone resummation (`FRESNEL.md` §4) applies to the pure field
  most cleanly: for $\mu$ there is no foreground to subtract at all.

## Appendix: reproducibility

| artifact | produces |
|---|---|
| `code/exp16_mobius.py` | Theorem H′ verification: pure pair band, suppressed singles, diagonal/off-diagonal corollary; caches `data/mobius_weights_40.npy`; `figures/exp16_mobius.png` |
