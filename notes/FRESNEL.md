# Fresnel phases: the off-diagonal cell was never empty

Companion to `REPORT.md`, `BLOCKS.md`. This note records a step-back audit of the
program and its payoff: a lens (semiclassical/Fresnel phase reading) that had
not been applied, which converts our own Theorem D‴ into a statement filling
the *empty off-diagonal cell* of the 2×2 dictionary — and a numerical
demonstration that **zeta zero gaps can be read off Goldbach counts of primes**,
to 0.1% for the first gap.

---

## 1. The tunnel-vision audit

What the program had settled into, without noticing:

1. **Every statistic we computed was Hermitian.** Amplitudes, band powers,
   correlations, variances — all $|\cdot|^2$-type functionals. The
   holomorphic/Hermitian dichotomy (`REPORT.md` §6) *itself* says structure
   hides in what Hermitian squares destroy — yet we kept measuring squares.
2. **The 2×2 dictionary's off-diagonal (`REPORT.md` §5.1) was declared empty**
   ("the bridge is marginal-to-marginal, without mixing" — Theorem B), and
   this was treated as structural. Theorem B is a statement about *frequency
   supports*. It says nothing about *phases*.
3. An erratum found while auditing (`REPORT.md` §8.1): the parenthetical
   "no reciprocal non-cyclotomic factor (this alone implies rigidity by the
   proof of Thm A′)" is **wrong as stated**: a reciprocal factor satisfies
   $\tilde h=\pm h$ and so *removes* swap freedom in $G\tilde G=F\tilde F$
   rather than creating it. Absence of reciprocal factors does not by itself
   exclude 0-1 mixed products when the non-cyclotomic part is reducible; the
   correct cheap certificate remains "irreducible non-cyclotomic part"
   (Thm A′) or the explicit enumeration of factor splits (exp1 does this).

The unapplied lens: **read the phases**. Everything below follows from a
two-line Taylor expansion of Theorem D‴.

---

## 2. Theorem G: the difference spectrum lives in the sum-spectrum phases

By Theorem D‴ (`BLOCKS.md` §2), the atom of the pair layer at frequency
$f=\gamma+\gamma'$ has phase $-fH(p)-\tfrac{5\pi}{4}$ with $p=\gamma/f$. Expand the
binary entropy about the equal split: with $p-\tfrac12=\frac{\gamma-\gamma'}{2f}$,
$$H(p)=\log2-2\Bigl(p-\tfrac12\Bigr)^2+O\bigl((p-\tfrac12)^4\bigr)
\;\Longrightarrow\;$$

**Theorem G (Fresnel coupling).** For same-sign zero pairs, the sum-spectrum
atom at $f=\gamma+\gamma'$ carries the phase
$$\arg c_f \;=\; -f\log 2-\frac{5\pi}{4}
\;+\;\underbrace{\frac{(\gamma-\gamma')^2}{2f}}_{\text{Fresnel term}}
\;+\;\frac{37}{12f}+\frac{1}{24}\Bigl(\frac1\gamma+\frac1{\gamma'}\Bigr)
\;+\;O\!\Bigl(\frac{(\gamma-\gamma')^4}{f^3}\Bigr)+O(f^{-3}),$$
where the $37/(12f)$ and $\tfrac1{24}$ terms are the next order of the same
Stirling expansion (from $\operatorname{Im}\log\Gamma$: $-3/s-\tfrac1{12s}$ from the
denominator and $+\tfrac1{24\gamma}$ per numerator factor; verified numerically to
three digits against exact $\arg W$ at the diagonal lines). **The zero
difference $\gamma-\gamma'$ sits in the phase of the prime-sum line, as a Fresnel
(quadratic) chirp.**

Consequences:

- **The off-diagonal cell of the dictionary is populated — by a
  phase-sensitive statistic.** Line *positions* of the Goldbach residual give
  zero *sums*; line *phases* give zero *differences*. Theorem B (no frequency
  mixing) is untouched: the coupling is invisible at the level of spectral
  supports and moduli (the D‴ modulus law depends only on $f$), and lives
  entirely in phase.
- **The dichotomy, sharpened to a slogan.** Every Hermitian statistic
  ($|\cdot|^2$: band powers, variances, the D″ additive energy) kills exactly
  this term. The boundary between the theorem-factory and the conjectures is
  literally the boundary between amplitude and phase of the same lines.
- **Semiclassical reading.** Writing the atom's contribution as
  $\cos\bigl(f(\log X-H(p))-\tfrac{5\pi}4\bigr)$: this is two Berry–Keating-type
  waves evaluated at the stationary split $m^*=pX$, $n^*=(1-p)X$ — a
  *two-orbit interference term* with entropy action and a Maslov-type constant
  $\tfrac{5\pi}4$. At fixed $f$, the phase is stationary in $p$ exactly at
  $p=\tfrac12$: the coherent part of the pair layer at frequency $f$ is carried
  by the **Fresnel zone** $|\gamma-\gamma'|\lesssim\sqrt{2\pi f}$ around the
  diagonal — heuristically, Goldbach oscillation at frequency $f$ is an echo of
  the zeros near height $f/2$.

## 3. Experiment 14: reading zero gaps off the primes

Pipeline of exp6b (smoothed Goldbach counts of primes to $4\cdot10^6$, single-zero
layer removed), then a phase-sensitive DFT at the exact line frequencies
(cubic detrend + Hann window; with a real symmetric window the DFT phase at
the line *is* $\arg c_f$, no calibration). Inversion of Theorem G:
$$|\gamma_i-\gamma_j| = \sqrt{2f\cdot\Bigl[\operatorname{wrap}_{[0,2\pi)}\bigl(\varphi_{\rm data}+f\log2+\tfrac{5\pi}4\bigr)-\tfrac{37}{12f}-\tfrac1{24}\bigl(\tfrac1{\gamma_i}+\tfrac1{\gamma_j}\bigr)\Bigr]}$$
(iterated, since the correction involves the recovered gap).

| line | $f$ | $\varphi_{\rm data}$ | $\varphi_{\rm model}$ | gap recovered | gap true | error |
|---|---|---|---|---|---|---|
| (1,1) | 28.269 | 1.729 | 1.726 | 0.43 | 0 | (floor) |
| (1,2) | 35.157 | −2.395 | −2.394 | **6.892** | 6.887 | **0.1%** |
| (1,3) | 39.146 | 1.975 | 1.970 | **10.968** | 10.876 | **0.8%** |
| (2,2) | 42.044 | −1.551 | −1.550 | 1.47 | 0 | (floor) |
| (1,4) | 44.560 | 0.064 | 0.058 | 17.38 | 16.29 | 6.7% (leakage) |
| (2,3) | 46.033 | 1.308 | 1.307 | — | 3.99 | fails (leakage) |

- **Data-vs-model phase agreement: rms 0.0035 rad (0.20°)** across all lines —
  the arithmetic carries the predicted phases at millirad accuracy.
- Recovered zeros from (sums, differences) of clean lines:
  $\gamma_2=21.024$ (true 21.022), $\gamma_3=25.057$ (true 25.011),
  using **only prime data** on the arithmetic side.
- The two failures are *spectral resolution*, not arithmetic: for (1,4) and
  (2,3) — separated by 1.47 in frequency against a window resolution
  $\approx2\pi/4.55\approx1.4$ — the data phase still matches the *model* phase
  to 0.006 rad; both differ from the isolated-atom value. Longer $X$-range is
  the only fix (resolving mean atom spacing 0.087 at $s\le300$ needs
  $\log X\sim72$; individual *low* lines are exponentially easier).

Figure: `figures/exp14_fresnel.png` (measured phase residuals landing on the
Fresnel parabola $2f\varphi=(\Delta\gamma)^2$; recovered vs true gaps).

## 4. What this does and does not change

Does **not** change: the Hermitian barrier for *statistics*. Recovering
finitely many gaps at bounded height from super-precise smoothed counts is an
information-location statement, not an asymptotic method; pair correlation as
a distributional limit remains untouched, and all D″-type variance statements
remain phase-blind by construction.

Does change:

1. The 2×2 dictionary (`REPORT.md` §5.1) needs its footnote: the off-diagonal
   is empty *for Hermitian statistics only*. The full holomorphic data of one
   marginal determines the other side's difference structure **explicitly and
   locally** — through Fresnel phases with known constants, not just through
   the abstract "Goldbach determines $\Lambda$ determines everything".
2. The right formulation of the dichotomy is now: *the Laplace bridge
   transports difference information into phases; Hermitian compression is
   the (only) step that destroys it.* Phase retrieval — the program's founding
   metaphor — turns out to be not just an analogy but the literal mechanism,
   with $(\gamma-\gamma')^2/2f$ as the retrievable phase.
3. A concrete new question (add to the problem list): **the Fresnel-zone
   resummation.** Make Corollary "Goldbach oscillation at frequency $f$ =
   coherent echo of zeros near $f/2$" precise: partial-sum the pair layer over
   the Fresnel zone $|\gamma-\gamma'|\le c\sqrt f$ and show the complement is
   $o$ of the zone (stationary phase against the Poisson-spaced sum spectrum,
   using the D‴ modulus law). This would upgrade the pair layer from a
   $2$-parameter sum to an effective $1$-parameter "half-height single-zero
   layer" — a genuinely new compression of Theorem D.

## Appendix: reproducibility

| artifact | produces |
|---|---|
| `code/exp14_fresnel.py` | phase measurement at exact line frequencies, corrected Fresnel inversion, gap/zero recovery; `figures/exp14_fresnel.png` |
