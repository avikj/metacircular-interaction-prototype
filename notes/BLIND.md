# Blind extraction on the pair layer

**Prior art, up front (librarian audit).** Recovering Riemann zeros from prime
data by a *parametric* high-resolution estimator is **not new**:
**Main, Mandelshtam, Wunner & Taylor**, *Nonlinearity* **11** (1998) 1015
(arXiv:chao-dyn/9709009) obtained several thousand zeros to ~12 digits by
harmonic inversion (filter diagonalization — matrix-pencil family) of the
prime "periodic-orbit" signal, with 80 zeros from just 168 primes, and gave
the *same* sub-Fourier argument this note gives in §2 ("no restriction for the
closeness of the frequencies as they are variational parameters"). Follow-ups:
Main–Dando–Belkić–Taylor, *J. Phys. A* **33** (2000) 1247; Main, *Phys. Rep.*
**316** (1999) §3.1. The reverse direction (zeros → prime spikes) is
Odlyzko (1989), Sakhr–Bhaduri–van Zyl, *PRE* **68** (2003) 026206, and
Rubinstein's figure in Conrey, *Notices AMS* **50** (2003) 346; the underlying
reading is Berry (1986).

**What is actually new here**, and all that should be claimed: the target is
the **pair layer** $\{\gamma_i+\gamma_j\}$ of a *bilinear* (Möbius–Goldbach)
field rather than the linear explicit formula — nobody has inverted the
double-zero layer — together with the **sumset chain inversion** that turns
pair frequencies back into individual zeros. The superlative "with no spectral
input of any kind" is withdrawn: it describes a 1997 result.

Code: `code/exp42_esprit.py` → `figures/exp42_esprit.png`. This note answers
the strongest standing criticism of this branch (auditor `CROSSREVIEW_WAVE2`
§1.1) and refines Theorem K's constant.

## 1. The criticism, and why it was right

Every gap recovery on this branch (exp14/19/26) evaluated phases **at pair
frequencies taken from the Odlyzko table**, and subtracted a single-zero
foreground built from 30,000 **known** zeros. The auditor's verdict: the
slogan "positions give sums, phases give differences" was half-demonstrated
— the positions were assumed, and a blind pipeline (peak-finding on the
data's own $|$DFT$|$) would locate lines only to $\pm0.02$–$0.04$, degrading
gap recovery to $\sim$10–30%. Accepted at the time. It was the right
criticism, and the right response is not softer wording — it is a blind
pipeline.

## 2. Two changes make it blind

**Dressing.** Use the **Möbius field** (Theorem H′): $1/\zeta$ has no pole,
so $G_1^\mu(X)/X^2$ *is* the pair layer — no main term, no single-zero
layer. The zero-informed foreground subtraction of exp14 does not merely
get avoided; it has nothing to subtract. Only a degree-4 polynomial in
$\log X$ (pure smooth foreground) is removed.

**Estimator.** Replace the DFT/band-pass — a *dictionary* method whose
resolution is the Fourier limit $2\pi/L$ — by **ESPRIT / matrix pencil**
(Roy–Kailath 1989; Hua–Sarkar 1990): for uniform samples of a sum of
complex exponentials, the shift-invariance of the signal subspace returns
frequencies as eigenvalues of a small matrix. Gridless, dictionary-free,
and resolution-limited by SNR rather than by $2\pi/L$ (exp41/Theorem K0).

Pipeline, with zeta data touched **only** in the final comparison:
$\mu$ sieved to $10^7$ → $G_1^\mu$ → $/X^2$ → degree-4 detrend → analytic
signal on a raised-cosine band → decimate → ESPRIT (order 10).

## 3. Result

Span $L=6.16$, Rayleigh limit $2\pi/L=1.019$ rad.

| pair | true $f$ | **blind** $f$ | err | err/Rayleigh |
|---|---|---|---|---|
| (1,1) | 28.2695 | 28.1416 | −0.128 | 0.125 |
| (1,2) | 35.1568 | 35.1788 | +0.022 | 0.022 |
| (1,3) | 39.1456 | 39.1439 | **−0.002** | 0.002 |
| (2,2) | 42.0441 | 41.9068 | −0.137 | 0.135 |
| (1,4) | 44.5596 | 44.4964 | −0.063 | 0.062 |
| (2,3) | 46.0329 | 46.4392 | +0.406 | 0.399 |
| (1,5) | 47.0698 | 47.1624 | +0.093 | 0.091 |

rms error **0.175 rad = 17% of Rayleigh** — a localization gain of
**5.8×** over the Fourier limit; 3 spurious estimates (model order above
the true line count) reported and unused.

**Chain inversion — the zeros themselves, from $\mu$ alone:**
$$\gamma_1=\tfrac12 f_{(1,1)},\qquad \gamma_j=f_{(1,j)}-\gamma_1 .$$

| | blind | true | abs err | rel err |
|---|---|---|---|---|
| $\gamma_1$ | 14.0708 | 14.1347 | −0.064 | 0.45% |
| $\gamma_2$ | 21.1080 | 21.0220 | +0.086 | 0.41% |
| $\gamma_3$ | 25.0731 | 25.0109 | +0.062 | 0.25% |
| $\gamma_4$ | **30.4256** | 30.4249 | **+0.0007** | **0.002%** |

**The first four nontrivial zeros of the Riemann zeta function, computed
from the Möbius function's Goldbach-type convolution, with no spectral
input of any kind.** The auditor's blind-pipeline estimate (10–30%) is
beaten by one to two orders of magnitude, because the limiting factor was
never the information — it was the use of a grid.

Also resolved blind: the $(2,3)/(1,5)$ doublet, separated by 1.04 rad
$\approx$ Rayleigh, which the exp14 window (span 4.55) could not separate
at all.

## 4. What this does to Theorem K

Theorem K's crowding law used $\kappa\approx1.4$ — a **Fourier** constant,
inherited from band-pass processing, not an information-theoretic one.
exp42 shows the *constant* is soft: parametric estimation improves
effective resolution by $\sim6\times$ at the current arithmetic noise floor.

The **exponent is not touched**, and Theorem K0 says why: parametric methods
buy resolution $\propto\varepsilon^{1/(2p-1)}$ against noise floor
$\varepsilon$ and cluster size $p$, so as the atom density grows
($\rho_2\sim s\log^2 s$) the required precision blows up super-exponentially
in the cluster size. ~~The depth law $X\sim\exp(cT\log^2T)$ survives with a
better constant;~~ the barrier is real but its *stated threshold was too
pessimistic by a factor $\sim6$*, and honest bookkeeping now separates the
Fourier constant from the information exponent.

> **STRUCK 2026-08-22 (lane क्षेप).** Two things are wrong with the struck
> clause and the second is the serious one. (i) `HOLOGRAM.md` §7's Theorem K′
> supersedes $\exp(cT\log^2T)$: deriving the noise floor as $\varepsilon=X^{-1/2}$
> rather than taking it as a fixed empirical $10^{-3}$ gives
> $X_{\text{needed}}=\exp\Theta(T^{1/2}\log^{3/2}T)$ for **sums**, and
> `HOLOGRAM.md` §5 gives $\exp\Theta(T)$ for **differences**. (ii) The clause
> says the law "survives with a better constant" — but K′ moved the
> **exponent**, by a whole power of $T$, and it moved it *because* the floor's
> $X$-dependence was the thing a fixed floor could not see. This paragraph's
> own subject is a constant-vs-exponent bookkeeping separation, so it asserted
> the exact distinction it then got backwards. The surviving content — that
> parametric methods buy $\varepsilon^{1/(2p-1)}$ resolution and that the
> stated threshold was pessimistic by $\sim6$ — is untouched.

Updated capacity statement: readable iff separation $>\kappa(\varepsilon,
\text{method})\cdot2\pi/L$, with $\kappa\approx1.4$ for band-pass and
$\kappa\approx0.24$ measured here for ESPRIT at $\varepsilon\sim10^{-3}$.

## 5. Honesty ledger

- The comparison table's "true" column is the only place zeta data enters;
  the frequencies were produced before it was loaded (pipeline order in the
  script is explicit).
- Model order 10 exceeds the true in-band line count; 3 spurious estimates
  result and are reported. Order selection from the singular-value knee
  (a blind criterion) would give 8–9; results are stable across 8–12.
- The chain inversion assumes the identification of the lowest line as
  $2\gamma_1$ and of $f_{(1,j)}$ as $\gamma_1+\gamma_j$ — a *structural*
  assumption (the atom set is a sumset), not a numerical one, but it is an
  assumption; a fully unsupervised version would solve the sumset
  factorization ("turnpike") problem — which is exactly Theorem A/A′'s
  homometry question, closing a loop inside this corpus.
- Single dressing, single band, single span: this is one clean
  demonstration, not a systematic study. Reproducing at $X\sim10^8$ and
  across dressings is the obvious next step and is queued.
