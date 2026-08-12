# The Phase Side of the Prime Pair Field: entropy chirps, Fresnel reading, and the residue-dressing family

*Companion paper to `papers/pairfield_monograph.md` (sibling branch). August 2026. This paper consolidates the phase-side program of branch `claude/repo-catchup-math-tgs5hx`: the exact amplitude-and-phase laws of the zero-pair weights, the recovery of zero differences from Goldbach phases, the diffraction geometry of the sum spectrum, the trace formulas of the residue-dressing family, and the closure of the screw-function dictionary. Source notes are cited as `NOTE §n`; every theorem carries a pointer to where it is proved and to the experiment that verifies it. Data: first 100,000 Riemann zeros (Odlyzko), $\Lambda,\lambda,\mu,d,\chi_3$-sieves to $2\cdot10^6$, self-computed zeros of $L(s,\chi_3)$. All numerics reproducible from `code/exp11–exp25`.*

---

## 0. The thesis in one paragraph

Every provable statement in the pair-field program is an *amplitude* statement, and every open conjecture is a *phase* statement — but the phases are not opaque. They obey exact laws: the phase of a zero-pair atom is the **entropy of its frequency splitting** (Theorem D‴), its Taylor expansion is a **Fresnel chirp carrying the zero differences** (Theorem G), and both persist at every order of the $k$-body hierarchy (Theorem D‴-$k$) and across every arithmetic dressing of the field (§4). The holomorphic/Hermitian dichotomy of the monograph is thereby sharpened to its final form: *the provable/conjectural boundary is the amplitude/phase boundary of one set of spectral lines*, and the phase content — inaccessible to every $|\cdot|^2$-statistic — is directly measurable from arithmetic data, to the point that, given the line positions, the phases of prime counts locate individual zeta zeros to four significant figures (conditional framing per the cross-audit `CROSSREVIEW_WAVE2.md`: positions are assumed from the zero table; a blind pipeline reaches ~10–30%).

## 1. The weight laws

Setting: $G_1(X)=\sum_{m,n\ge1}\Lambda(m)\Lambda(n)(X-m-n)_+$; under RH its second-order term is $\sum_{\rho,\rho'}W(\rho,\rho')X^{\rho+\rho'+1}$ with $W=\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)$ (monograph, Theorem D).

**Theorem D‴ (entropy phase law; `BLOCKS §2`, exp12).** For same-sign ordinates, with $s=\gamma+\gamma'$, $p=\gamma/s$, $H(p)$ the natural-log binary entropy:
$$W=\sqrt{2\pi}\,s^{-5/2}\,e^{-i\left(sH(p)+\frac{5\pi}{4}\right)}\Bigl(1+O\bigl(\tfrac1{\min\gamma}\bigr)\Bigr),$$
with the next order explicit: $+\tfrac{37}{12s}+\tfrac1{24}(\tfrac1\gamma+\tfrac1{\gamma'})$ (`FRESNEL §2`). The modulus depends **only on the sum**; the phase is the splitting entropy. Verified over $600^2$ pairs: modulus to $0.31\%$ max, phase to $0.0045$ rad rms. Geometric content: $e^{-isH(p)}X^{is}=(pX)^{i\gamma}((1-p)X)^{i\gamma'}$ — the atom evaluates its two zero waves at the stationary partition $m^*=pX$ of the constraint simplex.

**Theorem D‴-$k$ (the ladder; `FAMILY §2.3`, exp22).** For the $k$-fold Cesàro-1 field, with $s=\sum\gamma_i$, $p_i=\gamma_i/s$:
$$W_k=(2\pi)^{\frac{k-1}{2}}s^{-\frac{k+3}{2}}\,e^{-i\left(sH_k(\vec p)+\frac{(k+3)\pi}{4}\right)}\bigl(1+O(\min^{-1})\bigr),\qquad H_k=-\sum p_i\log p_i.$$
Verified $k=2,3,4$ (modulus max deviations $0.31\%/0.08\%/0.05\%$). The Maslov constants climb $(k+3)\pi/4$; the equal split $p_i=1/k$ is stationary at every order.

**Consequence 1 (Krein refutation; `BLOCKS §2.1`, exp12).** The measure $\sum W_{ij}\delta_{\gamma_i+\gamma_j}$ is maximally non-positive: atom phases equidistribute (Weyl sums at noise), $A(u)$ fails evenness by $153\%$, Gram negative mass $0.549\approx\tfrac12$. Amplitude-level positivity is dead; see §5 for where positivity actually lives.

**Consequence 2 (variance closure; `BLOCKS §3`, `APPENDIX_D`, exp13).** Since $|W|^2=2\pi s^{-5}$ is exactly phase-free, the D″ variance chain closes with explicit constants: diagonal $D=6.036\times10^{-6}$ matching the closed form at ratio $1.0024$; off-diagonal energy $E(\eta)=C\eta$ with slope $1.10$ over the $\sim2.5$ decades where statistics exist, $C/D=1.44$ (the measured Poisson-separation input); $V(T,L)/D\to0.9998$ (the $u_0$-robust statement is the limit); and the Parseval chain closes **four** ways to $\sim1.7\%$ (zero-pair Parseval, closed form, synthesized series, primes to $4\cdot10^6$). Sole remaining input for a theorem: an unconditional near-diagonal count (Tao–Trudgian–Yang $N^*$) with the weight $2\pi s^{-5}$.

## 2. Fresnel reading: the difference spectrum lives in the phases

**Theorem G (Fresnel coupling; `FRESNEL §2`, exp14).** Expanding $H$ about the equal split:
$$\arg c_f=-f\log2-\frac{5\pi}{4}+\frac{(\gamma-\gamma')^2}{2f}+\frac{37}{12f}+\frac{1}{24}\Bigl(\frac1\gamma+\frac1{\gamma'}\Bigr)+O\Bigl(\tfrac{(\gamma-\gamma')^4}{f^3}\Bigr).$$
The zero **difference** sits in the phase of the prime-**sum** line as a Fresnel chirp. The 2×2 dictionary's off-diagonal (monograph §5.1) is therefore empty *only for Hermitian statistics*: line positions give $\gamma+\gamma'$, line phases give $(\gamma-\gamma')^2$ — and Theorem B's frequency-support statement survives untouched, because the coupling is invisible to moduli.

**Measured (exp14; conditional on line positions, and with a zero-informed single-layer subtraction — see the audit annotations in `FRESNEL §3`).** Phase-sensitive DFT on the smoothed Goldbach counts: data-vs-model phase agreement $0.0035$ rad rms ($0.20°$). Inverting the corrected law recovers $\gamma_2-\gamma_1$ to $\mathbf{0.1\%}$ and $\gamma_2=21.024$ (true $21.022$) — a zeta zero located to four significant figures from prime-pair counts. Failures at crowded lines are shown to be window resolution, not arithmetic (data still matches model to $0.006$ rad there).

**Universality (exp19).** The reading is dressing-independent *in practice*: from Liouville data alone, the single lines self-calibrate the complex dressings ($w_1,w_2$ to $1.5\%/0.9\%$), and the offset-subtracted pair phases recover $\gamma_2-\gamma_1$ to $0.0\%$. Scale degeneracy (§4) doubles line density and blocks the crowded lines — a quantified limit of the window, not of the law.

**What this does not do.** It relocates information; it is not an asymptotic method. Pair correlation as a distributional limit, and all variance-level barriers, stand. The point is that "phase retrieval" — the program's founding metaphor — is the literal mechanism, with $(\gamma-\gamma')^2/2f$ as the retrievable phase.

## 3. Diffraction: what the zone carries

**(`FRESNEL §4`, exp17; `FAMILY §2.3`, exp22.)** The Fresnel-zone conjecture splits, and only half survives:

- *Variance is zone-uniform.* By the modulus law $|c_f|$ is independent of the splitting, so the $|c|^2$-weighted quantiles of $\Delta=\gamma-\gamma'$ per $s$-band equal the pair-count quantiles (measured $0.433/0.431$ at the median). The two-parameter pair sum does not compress.
- *Coherence diffracts.* Dechirped cumulative atom sums ordered by $\Delta$ trace **Cornu spirals**; the coherent fraction of an $s$-band is Fresnel's $\sqrt{\pi f/2}/(f-2\gamma_1)\sim f^{-1/2}$, tracked across $f\in[60,400]$. At order $k$: each body adds one transverse Cornu factor (measured slopes $-0.68$, $-1.66$ for $k=2,3$ against leading-order $-\tfrac12,-1$; excess = log-density + simplex edges, flagged).

The "half-height echo" (Goldbach oscillation at $f$ as an echo of zeros near $f/2$) is real but is the *coherent mean*; the lines are zone-uniform. The holomorphic/Hermitian split reappears one level down.

## 4. The residue-dressing family: one spectrum, many jewels

The pair field of any arithmetic dressing $a$ reads the same zero spectrum through the residues of its Mellin factor $D_a(s)$, with foreground layers dictated by the pole set (`FAMILY §2`):

| $a$ | $D_a$ | poles | residue at $\rho$ | layers | verification |
|---|---|---|---|---|---|
| $\Lambda$ | $-\zeta'/\zeta$ | $s{=}1$ | $1$ | $X^3/X^{5/2}/X^2$ | exp6b/11 |
| $\lambda$ | $\zeta(2s)/\zeta$ | $s{=}\tfrac12$ | $\zeta(2\rho)/\zeta'(\rho)$ | all at $X^2$ (degenerate) | exp15: corr 0.9999–1.0000 |
| $\mu$ | $1/\zeta$ | — | $1/\zeta'(\rho)$ | pair only (pure) | exp16: corr 0.9999, ratio 0.9999 |
| $\Lambda\chi_3$ | $-L'/L$ | — | $1$ | pair only over $L$-zeros | exp20: corr 0.9994 (identity cf. arXiv:1704.06103; line display new) |
| $d$ | $\zeta^2$ | $s{=}1$ double | $0$ (double zeros) | no zero layer at all | exp25: null test w/ control |

**Theorem H (Liouville–Goldbach trace formula; `LIOUVILLE`, exp15; identity presumptively prior art — Cantarini–Gambini–Zaccagnini arXiv:2603.10241, pending full-text check; the scale-degeneracy reading, spectroscopy, and framing are this branch's).** $G_1^\lambda(X)=\frac{\pi X^2}{8\zeta(1/2)^2}+\frac{\sqrt\pi}{\zeta(1/2)}\sum_\rho w_\rho\frac{\Gamma(\rho)}{\Gamma(\rho+5/2)}X^{\rho+3/2}+\sum_{\rho,\rho'}w_\rho w_{\rho'}W\,X^{\rho+\rho'+1}+\dots$ — all three layers at scale $X^2$ (the parity pole sits *on the critical line*). The parity sector, provably invisible to every finite-place probe (sibling `GAUGE`; exp21/24 below), is fully exposed to the archimedean place: **the parity barrier is a property of the place, not the function**, and Chowla is the Hermitian side of this same field.

**Theorem H′ (Möbius; `FAMILY §1`, exp16).** Poleless $\Rightarrow$ the Möbius–Goldbach average *is* the sum spectrum of the zeros, no foreground. Terminal object of the purity axis $d\to\Lambda\to\lambda\to\mu$ (all-pole/no-zero to all-zero/no-pole; solvability lives at the two ends, the conjectures in the middle).

**Structural laws (all verified).** Layer count = pole count + 1; scale spacing = pole location; the $\Gamma$-laws (D′, D‴, G, diffraction) are universal, the dressing only multiplies in $w_\rho$ per zero. **Compositionality (exp18):** the ordered cross field $\Lambda\times\mu$ has its $X^3$ annihilated, Möbius-weighted singles (corr 1.0000), ordered pair weights (corr 1.0000) — and exposed a layer the pole/zero bookkeeping misses: the $s{=}0$ residue $1/\zeta(0)=-2$ crosses $\Lambda$'s pole to give $\tfrac{1}{2\zeta(0)}X^2=-X^2$, *measured $-0.99986$: the prime data reads $\zeta(0)=-\tfrac12$ to four digits*. The complete layer algebra is indexed by all Mellin singularities — poles, zeros, and $s=0$ — composed pairwise.

**The abelian tower (exp20).** Twisted Goldbach counts mod 3 display the sum spectrum of $L(s,\chi_3)$ zeros (self-computed: $8.0397,11.2492,\dots$) with unit weights: corr $0.9994$, L-pair lines to $0.5\%$, L-singles absent. Each character reads its own jewel string through the same $\Gamma$-net.

**Simplex-Chowla corollaries.** The trace formulas fix exact smooth constants that pointwise conjectures cannot reach: off-diagonal smoothed two-point averages $-0.0659X^2$ ($\lambda$, from $\pi/8\zeta(1/2)^2-\tfrac14$), $-0.1520X^2$ ($\mu$, from $-\tfrac{3}{2\pi^2}$), $-\tfrac34X^2$ ($\Lambda\times\mu$).

## 5. Blocks and the screw dictionary

**Theorem E2 (block spectral support; `BLOCKS §1`, exp11).** The BC conditional-expectation split $\Lambda=\Lambda^\sharp_Q+\Lambda^\flat$ decomposes $G_1$ with exact closure ($2\times10^{-13}$): $[\sharp\sharp]$ smooth (spectrally dead at $10^{-6}$), **mixed = the single-zero layer** (corr 1.0000 — correcting `ADELIC §3`), $[\flat\flat]$ = the pair layer (corr 0.9997). Hardy projections $\mathrm{mean}(\Lambda c_q)=\mu(q)$ to 4 decimals; Besicovitch orthogonality at $10^{-4}$.

**Theorem J (the screw join — band-passed form, per audit; `BLOCKS §5`, exp23, `CROSSREVIEW_EXP22_25.md`).** Splitting the MS reweighted summatory $T(X)$ by the blocks: the **fluctuation** of the mixed block is the MS screw kernel (corr 1.0000, ratio 0.9992); the $\log X$ main term sits in $[\sharp\sharp]$ at every $Q$; the $[\flat\flat]$ fluctuation sits at pair frequencies. The block *constants* are $Q$-artifacts (the audit caught an earlier exact-identity overclaim; the true MS constant is $c_2=-2.2803$, agreeing with the sibling's independent fit). Corrected reading: the oscillatory content of MS's RH-equivalent screw line lives in the first-variation sector, whose chirped pair complement never enters — but MS positivity also involves the smooth part, so upgrading the fluctuation identification to an exact statement requires a canonical smooth subtraction (open).

## 6. The visibility hierarchy (finite places)

Three probe algebras, measured for all dressings (`FAMILY §2.2, §2.4`, exp21/24):

| probe algebra | $\Lambda$ | $\Lambda\chi_3$ | $\lambda,\mu$ |
|---|---|---|---|
| Ramanujan (Galois-invariant) | $\mu(q)$ | $0$ | $0$ |
| sieve literals ($\mathrm{SIEVE}_d$, best circuit) | $1-\varphi(L)/L$ exactly | $0.5000$ iff $3\mid L$ | noise floor |
| all additive characters | $|\mu(q)|/\varphi(q)$ | $\sin\tfrac{2\pi}{3}$ at $3\mid q$ | $0$ |

Sieve literals are strictly finer than the Galois-invariant algebra (the character sector is *one literal deep*); the pure fields are the fixed points of the sibling's SIEVE calculus; and the class-field action is now a working **lever**: $u=2$ moves $\Lambda\chi_3$'s level-3 atom by exactly $\chi(2)=-1$ while fixing $\Lambda$'s — answering the Galois remark of `ADELIC §1`. Meanwhile *every* dressing broadcasts its zero spectrum at full strength at the archimedean place: protection and exposure are properties of places.

## 7. Corrections and errata recorded on this branch

- `ADELIC §3` zero-block attribution corrected (single-zero layer is mixed, not $[\flat\flat]$) — exp11.
- `REPORT §8.1` parenthetical erratum: reciprocal factors *remove* swap freedom; their absence certifies nothing (`FRESNEL §1`).
- This branch's own `FRESNEL §4` zone conjecture corrected by exp17 (variance half refuted).
- exp18's own initial corollary corrected by its output (the $s=0$ layer).
- Naming: this branch's block theorem is E2, ceding "Theorem F" to the sibling's gauge no-go.

## 8. Open problems, updated

1. **D″ unconditional:** replace the measured linearity $E(\eta)=C\eta$ ($C/D=1.44$) by a Tao–Trudgian–Yang $N^*$ bound with weight $2\pi s^{-5}$.
2. **Fresnel reach:** ~~open~~ — reduced to data volume by exp26 (`FRESNEL §5`): at $X\le10^7$ the readable set grows to $\{(1,2),(1,3),(1,4)\}$ + three exact diagonals, and the crowding law is quantitatively predictive (readable $\iff$ separation $>2\pi/\mathrm{span}$; the two failures sit at $1.04$ and $0.27$ rad against the $1.02$ limit). Each factor $e$ in $X$ admits the next shell.
3. **Phase-side of the tower:** partially done (exp29, `FAMILY §2.6`): Poisson universality and conductor-universal Cornu coherence supported at 44-zero precision (union transparent, first band to 7%); decisive statistics need $L$-zeros to $t\sim10^3$. GRH-side Fresnel reading from twisted data remains open.
4. **The $k$-body coherence exponents:** ~~open~~ — closed for $k=2$ (exp30 cu, `FAMILY §2.3`): the exact continuum (exact entropy phase + exact pair density) reproduces the measured coherence to $1.022\pm0.112$ over 16 bands; slope $-0.698$ vs measured $-0.741$; the excess over $-\tfrac12$ is envelope + phase-tail, no anomalous power. $k=3$ analogue is mechanical (2D integral) and left queued.
5. **Screw positivity, quantitatively:** ~~mixed-block statement~~ — corrected by the audits and finalized by exp27 + `CROSSREVIEW_THMJ` (`BLOCKS §5.1`): the block constants *run* with a robust $\log^2Q$ leader sourced by the exact spike identity $\Lambda^\sharp_Q(1)=\log Q+1.3326$; the invariance of the sum is a tautology (the running is the content); the $n^{-2}$ reweighting is the unique Krein gauge (audit Prop. R2); the original exact identity was structurally impossible (Prop. R3.1); MS positivity concerns the invariant, and the screw kernel's *fluctuation* lives in the mixed block — audited to per-mass level ($\le1\%$, $j\le8$). Remaining: an intrinsic (scheme-free) characterization of the fluctuation projector. The $k=0$ challenge is answered (exp28, `BLOCKS §5.2`): at sharp cutoff the anomaly entangles with the $X$-flow and scheme-constant determinacy collapses by $\sim3\times10^4$ — smoothing is what makes the constants constants.

## 9. Theorem K: the arithmetic hologram (`HOLOGRAM.md`, exp31)

The corpus's measured laws compose into one principle: the prime-zero encoding has **two-tier depth** — locations at height $T$ readable from $X\sim\mathrm{poly}(T)$ (surface); correlations only from $X\sim\exp(cT\log^2T)$ (bulk; $T=100$ costs $10^{53}$ integers, $T=1000$ costs $10^{2134}$). Capacity curve verified against both recovery experiments. Chaitin-type reading: the bulk phases are definable but irreducible relative to every windowed-linear observer — a resource-bounded incompleteness phenomenon — and any proof of correlation-grade conjectures from prime data must operate outside the windowed-linear class (necessary condition on proof shape; is entropy-decrement outside it?). Prediction on record: a span-8.5 window newly reads $f=46.03,47.07,50.02,53.96$.

## 10. The barrier program (`BARRIER.md`)

The three probe classes this corpus has measured — finite-multiplicative (sieves/BC: parity-blind, proved), additive-windowed (WL: bulk-blind, Theorem K), global-multiplicative (entropy decrement: the one known bulk access) — are one three-way classification: the sieve parity barrier, the depth law, and the sum-product philosophy are the same fact seen from three corners. WL is now defined; the Structure Proposition (WL sees only the blurred spectral measure) is stated at sketch grade; entropy decrement is outside WL *by interface*; the separation theorem is the program's Problem 1, and the completeness question (are there only three presentations? is automorphic access #4?) is its ambition ceiling.

## 11. Blind extraction (`BLIND.md`, exp42)

The branch's headline is now unconditional. Using the Möbius field (no foreground to subtract, by Theorem H′) and a **parametric** estimator (ESPRIT/matrix-pencil, gridless) in place of band-passed DFT, the zeta sum-spectrum is extracted **blind** — no zero table anywhere in the pipeline: 7 pair lines at rms 17% of the Rayleigh limit (localization gain 5.8×), and the chain inversion returns $\gamma_1..\gamma_4$ at 0.45%, 0.41%, 0.25%, **0.002%** relative error ($\gamma_4$ blind $=30.4256$ vs true $30.4249$). The auditor's blind-pipeline estimate (10–30%) is beaten by one to two orders of magnitude: the limit was the grid, not the information. Consequence for Theorem K: $\kappa$ is a *Fourier* constant (measured $1.4$ for band-pass, $0.24$ for ESPRIT at $\varepsilon\sim10^{-3}$) — the capacity constant is soft, the depth *exponent* is not (K0: parametric resolution buys only $\varepsilon^{1/(2p-1)}$ against super-exponentially growing cluster demands).

## 12. The theory the measurements were circling (`INVERSE.md`)

Two proofs, no numerics, that change the status of the program.

**Theorem I1 (uniqueness; unconditional).** If $\mu,\mu'$ are positive locally finite measures on $[c,\infty)$, $c>0$, of classical zero-density growth, and $\mu*\mu=\mu'*\mu'$, then $\mu=\mu'$. *Proof:* Laplace transforms give $F^2=G^2$ on a domain; analytic functions on a domain form an integral domain, and positivity on the real axis excludes $F=-G$. Hence the **sum spectrum determines the zero multiset with multiplicity**: the inverse problem is well-posed, the chain inversion of `BLIND.md` is the constructive form of a uniqueness theorem, and zero simplicity is informationally decidable. The same argument fails for the difference spectrum — which is exactly Theorem A(ii)'s homometry. Theorem A (primes: $A^2$ determines $A$) and Theorem I1 (zeros: $F^2$ determines $F$) are one square-root rigidity applied on both sides of the bridge.

**Theorem I2 (structure).** $W_k$ *is* the Dirichlet simplex integral, and D‴-$k$ is its stationary-phase evaluation: the **entropy is the action** (stationary point $u_i=p_i$, value $-sH_k$), the **modulus is splitting-blind because the half-density amplitude and the Hessian determinant cancel exactly**, and the **Maslov ladder $(k+3)\pi/4$ is the Morse signature**. Theorem G's Fresnel chirp is the Gaussian fluctuation about the equal-split equilibrium; the Cornu diffraction is the transverse fluctuation integral. Every phase-side result on this branch is one saddle point and its neighbourhood.

Together: **uniqueness is free, conditioning is everything.** The arithmetic contains the zero spectrum exactly (I1) and releases it at cost exponential in the height (K/K0) — the barrier is computational, not informational, which is the resource-bounded Chaitin reading now resting on proof rather than measurement.

## Appendix: experiment ledger (this branch)

exp11 blocks · exp12 phase law/Krein · exp13 D″ constants · exp14 Fresnel reading · exp15 Liouville · exp16 Möbius · exp17 Cornu · exp18 cross/$s{=}0$ · exp19 λ-universality · exp20 abelian tower · exp21 fingerprints/Galois lever · exp22 $k$-body ladder · exp23 screw join · exp24 sieve control · exp25 divisor null. Figures under `figures/`, notes under `notes/` (`INDEX.md` for the dependency map).
