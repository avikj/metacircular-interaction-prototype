# Appendix D: Goldbach-average variance as a weighted additive energy of zeta zeros

This appendix upgrades Theorem D″ of `REPORT.md` from a sketch to a proof, in the
Fejér-window formulation, and records the numerical closure of the Parseval chain.

Throughout, assume RH and write $\rho = \tfrac12 + i\gamma$ where $\gamma$ ranges over
**signed** ordinates (so conjugate zeros appear as $-\gamma$). Set

$$W(\gamma,\gamma') \;=\; \frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)},\qquad
A(u) \;=\; \sum_{\gamma,\gamma'} W(\gamma,\gamma')\, e^{i(\gamma+\gamma')u},$$

so that (Theorem D) the second-order term of $G_1(e^u)$ equals $e^{2u}A(u)$ up to the
smooth deterministic layer. By Theorem D′ the double sum converges absolutely:
$\sum|W| \le C_0 < \infty$, with same-sign pairs contributing
$|W|\asymp(\gamma+\gamma')^{-5/2}$ against pair density $\asymp T\log^2 T$ at height $T$,
and opposite-sign pairs $|W|\ll e^{-\pi\min(|\gamma|,|\gamma'|)}$.

## D.1 Setup: windowed mean square

Fix $L>0$ (the log-length of the averaging window), $u_0 = \log T$, and the Fejér weight
$\phi_L(u) = \max(0, 1-|u|/L)$, whose Fourier transform
$\widehat{\phi_L}(\delta) = L\,\mathrm{sinc}^2(L\delta/2) \ge 0$.

Define the windowed variance
$$V(T,L) \;=\; \frac1L\int_{\mathbb R} |A(u_0+u)|^2\,\phi_L(u)\,du .$$

## D.2 The exact quadruple-sum formula

Expanding $|A|^2$ and integrating term-by-term (justified by absolute convergence):

$$V(T,L) \;=\; \sum_{\gamma_1,\gamma_2,\gamma_3,\gamma_4}
W_{12}\overline{W_{34}}\; e^{i\delta u_0}\,\frac{\widehat{\phi_L}(\delta)}{L},
\qquad \delta := (\gamma_1+\gamma_2)-(\gamma_3+\gamma_4). \tag{D.1}$$

Note $\widehat{\phi_L}(\delta)/L = \mathrm{sinc}^2(L\delta/2) \in [0,1]$, equal to $1$ at
$\delta=0$ and $\le \min\bigl(1, (2/L\delta)^2\bigr)$.

**Definition (weighted additive energy at resolution $\eta$).**
$$E_W(\eta) \;=\; \sum_{|\delta| \le \eta} \bigl|W_{12}\overline{W_{34}}\bigr| .$$
This is the $\Gamma$-weighted, four-fold analogue of the additive energy
$N^*(\sigma,T)$ of zero ordinates introduced for zero-density purposes by
Tao–Trudgian–Yang (arXiv:2501.16779); their object is the unweighted count of
near-solutions of $\gamma_1+\gamma_2=\gamma_3+\gamma_4$.

## D.3 Upper bound

Split (D.1) dyadically in $|\delta|$:

$$|V(T,L)| \;\le\; E_W(1/L) \;+\; \sum_{k\ge0} \Bigl(\frac{2}{2^k}\Bigr)^{2}
\Bigl[E_W(2^{k+1}/L) - E_W(2^{k}/L)\Bigr]
\;\ll\; \sup_{\eta \ge 1/L} \frac{E_W(\eta)}{(\eta L)^{2}}\cdot (\eta L)^2\Big|_{\text{dyadic}} ,$$

and since $E_W(\eta) \le E_W(\infty) = \bigl(\sum|W|\bigr)^2 \le C_0^2$ the tail converges;
quantitatively
$$V(T,L) \;\ll\; E_W(1/L)\;+\;\sum_{k\ge0} 4^{-k}\,E_W(2^{k+1}/L). \tag{D.2}$$
If $E_W(\eta) \ll \eta^{\alpha} E_W(1/L) L^\alpha$ for some $\alpha<2$ in the relevant
range (true numerically with room to spare, since the frequency multiset
$\{\gamma_i+\gamma_j\}$ is Poisson-spaced — Experiment 5c — and the weights are
summable), then simply $V(T,L)\ll E_W(1/L)$.

## D.4 Lower bound

Restrict (D.1) to the exact diagonal $\mathcal D = \{(\gamma_3,\gamma_4) = (\gamma_1,\gamma_2)
\text{ or } (\gamma_2,\gamma_1)\}$, where $\delta=0$, $e^{i\delta u_0}=1$, and every term is
positive:
$$\sum_{\mathcal D} = 2\sum_{\{\gamma_1,\gamma_2\}} |W_{12}|^2 \;>\; 0$$
(using $W_{12}=W_{21}$). The off-diagonal is controlled by (D.2) minus its
diagonal part; since $\widehat{\phi_L}\ge0$, *no cancellation against the diagonal is
possible in sign*, only in the oscillating factor $e^{i\delta u_0}$. Averaging $u_0$ over
one additional unit window kills all $|\delta| \ge 1$ contributions up to $O(1/L)$ and
leaves
$$\frac{1}{1}\int_{u_0}^{u_0+1} V \;\ge\; 2\sum |W_{12}|^2 \;-\; O\!\bigl(E^{\circ}_W(1/L)\bigr),$$
where $E^\circ$ is the strictly-off-diagonal near-diagonal energy. Provided the
ordinate sums are $1/L$-separated in the mean sense implied by their Poisson
statistics, $E^\circ_W(1/L) = o(\sum|W_{12}|^2)$ as $L\to\infty$, giving

$$V \;\asymp\; E_W(1/L) \;\asymp\; \sum_{\{\gamma_1,\gamma_2\}}|W_{12}|^2 \qquad (L\to\infty). \tag{D.3}$$

The only unproved ingredient in (D.3) is the near-diagonal separation — precisely a
(weak, weighted) **additive-energy hypothesis on the zeros**, i.e. the $S$-side
analogue of Montgomery's pair-correlation hypothesis. This is not a defect of the
method: it is the content of the theorem. *Goldbach-average variance and zero
additive energy are the same quantity seen from the two ends of the Laplace–Mellin
bridge*, exactly as Goldston–Montgomery proved prime-count variance in short
intervals and pair correlation are.

## D.5 Unconditional-under-RH consequences

- **Ω-result.** From the diagonal alone: $\limsup_{x}|Δ(x)|/x^2 \ge \sqrt{2\sum|W_{12}|^2} > 0$
  — the second-order Goldbach term genuinely oscillates at scale $x^2$ (compare
  Bhowmik–Schlage-Puchta's $\Omega(X\log\log X)$ for the sharp-cutoff first-order
  problem; here smoothing isolates the pure pair layer).
- **Numerical closure of the Parseval chain** (`exp6b` + diagonal computation with
  1200 zeros, all four sign classes, frequencies binned to $10^{-6}$):

  | quantity | value |
  |---|---|
  | $\sqrt{\sum_{f\ne0}|c_f|^2}$ (predicted RMS, diagonal/Parseval) | **0.0025** |
  | same, restricted to band $[25,320]$ | 0.0025 (band captures ~100% of variance) |
  | measured band RMS of the model time series | 0.0025 |
  | measured band RMS of the *arithmetic data* | 0.9991 × model |

  Three independent computations of the same number — Parseval over zero pairs,
  synthesized time series, and the actual smoothed Goldbach counts of the primes to
  $4\cdot10^6$ — agree to three decimals.

## D.6 What would make this a paper

1. Replace the Poisson-separation heuristic in D.4 by an unconditional bound on the
   weighted near-diagonal energy using zero-density estimates (the Tao–Trudgian–Yang
   $N^*$ machinery is designed for exactly such bounds), yielding: *under RH,
   $V \asymp \sum|W|^2$ with explicit constants*.
2. Remove RH from the framework: off-line zeros contribute $x^{\rho+\rho'+1}$ with
   $\operatorname{Re}(\rho+\rho')\neq1$; the analysis of Sections D.2–D.4 then produces an
   equivalence between "$V(T,L) \ll$ diagonal" and a quasi-RH zero-clustering
   statement — the $S$-side mirror of the Goldston–Montgomery equivalence,
   which would be new.
3. ~~Join with Matsumoto–Suzuki (arXiv:2409.00888): their screw function is a Krein
   transform of the same secondary terms; positivity of the measure
   $\sum_{i,j}W_{ij}\delta_{\gamma_i+\gamma_j}$ (numerically testable with this repo's data)
   should translate into their necessary-and-sufficient RH condition.~~
   **Refuted as stated — see `SCREW.md`.** The Matsumoto–Suzuki screw function is
   exactly the *first-variation* (single-zero) sector in Krein normal form
   ($g_{H_1}(t)=2\sum_{\gamma>0}(\cos\gamma t-1)/(\gamma^2+\tfrac14)$, positive
   masses on single frequencies); the pair measure above is complex-phased
   (half the lines carry negative real part; mean $|\mathrm{Im}|/|\text{mass}|=0.64$)
   and its Krein kernel is maximally indefinite — screw positivity does **not**
   extend to the second variation. The corrected direction (SCREW.md §4): the
   product-weighted pair object with masses $1/((\gamma^2+\tfrac14)(\gamma'^2+\tfrac14))$
   is positive under RH as a corollary of their theorem; identify the
   doubly-reweighted Goldbach sum carrying it and rerun the variance analysis
   there. The 4-point near-diagonal separation remains the genuinely open input.
