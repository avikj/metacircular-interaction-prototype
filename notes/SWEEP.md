# Audit sweep: what two independent verifiers found

Filed from adversarial re-derivation (validity-by-redundancy, `kernel/nodes/003`).
Two agents, independent, no shared code path. **They agree on a headline
reversal and on a stray $\pi$.** Full findings below; corrections applied in
the same commit.

## 0. The reversal (both agents, independently)

`HOLOGRAM.md` §7 asserted that although Theorem K′ lowers the depth exponent,
"every qualitative conclusion of `BARRIER.md` survives — still hopeless
numerically." **That assertion is retracted.** Solving K′'s own boxed
inequality with its own $\rho_2$ gives, at $T=100$:

| source | $\log_{10}X$ needed |
|---|---|
| the asserted figure | $\approx43$ |
| verifier A (corrected $\rho_2$, self-consistent closure) | $\approx4.8$–$15.5$ |
| verifier B (independent hand solution) | $\approx10$–$14$ |

Not hopeless — **reachable**. Corroborating evidence already in the corpus:
exp42 resolved the $(2,3)/(1,5)$ doublet blind at $X=10^7$, i.e.
correlation-grade reading that the old law said was pinned at zero. The
barrier survives *asymptotically* ($T=10^3\Rightarrow\log_{10}X\approx62$–$111$;
$T=10^4\Rightarrow\approx400$), but the qualitative claim must be **recomputed
per $T$, never asserted.** The $T=100$ figure is deleted rather than corrected:
at $p\approx10$ an unspecified $O(1)$ inside $(c\delta L)^{2p-1}$ is raised to
the ~20th power, so that regime carries no information.

## 1. Errors of fact

1. **$\rho_2$ carries a stray $\pi$.** Correct: $\rho_2^{\text{unord}}(s)\sim
   s\log^2 s/(8\pi^2)$ (ordered: $/(4\pi^2)$). The corpus had $/(8\pi^3)$.
   Verified two ways by verifier A (mass check $\int_0^{2T}\rho_2^{\rm ord}=2N(T)^2$;
   direct enumeration at $s=50$).
2. **Lemma N's $O(X^{-1/2})$ is not an error term — it is a determinate layer**,
   $-4\sum_\rho X^{\rho-1}/(\zeta'(\rho)\rho(\rho+1))$, living on the *single-zero*
   frequency set (density $\tfrac{1}{2\pi}\log T$), not the pair set. It is
   therefore *modellable*; subtract it and the true residual is $O(X^{-2})$.
   This changes what $\varepsilon$ should even mean in K′.
3. **Lemma N's written proof is invalid at the edge.** Inserting the explicit
   formula for $M(u)$ on $u\in[0,1)$ (where $M\equiv0$ but the series does not
   vanish), plus $\Gamma(-2k)$ divergence in the Beta integral. The conclusion
   survives; the *coefficient cannot be read off that way*. Replace with the
   double-Mellin proof (verifier A supplied it).
4. **Hypotheses insufficient.** "Unconditional given RH + simple zeros" is
   **false**: convergence needs a Gonek-type input
   $\sum_{0<\gamma\le T}|\zeta'(\rho)|^{-2}\ll T^{1+o(1)}$ (only the lower bound
   is known under RH).
5. **$\gamma_4=30.4256$ at "0.002%" is error cancellation** — the two inputs
   carry $-0.063$ and $-0.064$ and they cancel. The honest bar on every
   chain-inverted zero is the line rms $0.175/\sqrt2\approx0.12$ absolute
   (0.4–0.9%), which is what $\gamma_1,\gamma_2,\gamma_3$ show. **This is the
   exp27 pattern in miniature — a fluctuation promoted to a headline** — and it
   was in the README banner and `phase_side` §11. Retracted.

## 2. Constants that are not constants (the Lemma N disease, recurring)

Fixing $\varepsilon$ froze two *new* variables:

- **$\kappa$ is a function of $X$.** Composing K0 with Lemma N:
  $\kappa(X,p)=c_p X^{-1/(2(2p-1))}$ — so $\kappa\propto X^{-1/6}$ for a pair
  cluster. The corpus quotes frozen $1.4$ / $0.24$ everywhere, including the
  on-record span-8.5 prediction. ($\kappa=1.4$ is not arithmetic at all: it is
  the Hann window's $-3$dB bandwidth, $1.4382$ bins — a table lookup.)
- **$L$ = span vs $L$ = $\log X$ were conflated in K′'s own derivation.**
  Resolution is governed by the span ($\log(X/X_{\min})$, with $X_{\min}\approx2\times10^4$
  held fixed in every experiment); ~~the noise floor by $\log X$. The boxed
  exponent survives only for $X_{\min}=O(1)$;~~ the honest closure is
  two-parameter.

  **Correction (2026-08-13; `BARRIER_ERROR_WINDOW.md` §5.2–5.3, Theorems
  U1–U2, B1″).** The floor is set by $\log X_0$ — the window's **bottom** —
  not by $\log X$. A windowed observable is the profile-weighted *average* of
  the field over $[X_0,X]$ and the error term decays in scale, so the smallest
  scale the window touches sets the floor. Exactly,
  $$\varepsilon=C_E\,X_0^{-1/2}\,\Theta_\phi(L/2),\qquad\text{not }X^{-1/2},$$
  with $\Theta_\phi$ that note's profile functional (Lemma 5) and the exponent
  $\alpha=\tfrac12$ derived, not fitted. Two consequences for the struck
  sentence. **(i)** With the bottom held fixed at $X_0=X_{\min}$ — what every
  experiment in this corpus did — the arithmetic contributes only the constant
  $C_EX_{\min}^{-1/2}$, and **all** of the $L$-decay of the floor comes from
  $\Theta_\phi(L/2)$: a property of the window profile, not of $\zeta$
  ($\asymp1/L$ for a boxcar, $O_N(L^{-N})$ for $\phi\in C_c^\infty$). Feeding
  $\varepsilon=e^{-L/2}$ into K′ at fixed $X_0$ therefore *understates* the
  floor, by exactly $e^{L/2}\Theta_\phi(L/2)$. **(ii)** The boxed exponent does
  not require $X_{\min}=O(1)$: in the regime $X_0=X^{\theta}$, $\theta\in(0,1)$
  fixed, $\varepsilon=X^{-\theta/2}\Theta_\phi$ is still $X^{-\Theta(1)}$, so
  K′'s own robustness remark applies verbatim and the boxed
  $T^{1/2}\log^{3/2}T$ survives with $\alpha\mapsto\theta/2$. The two-parameter
  closure asked for here is $(X_0,L)$, and against $X_0$ the $E$-term bound is
  uniform in $L$ (and improves with it).
- **$C/D=1.44$ has units of inverse frequency.** $C/D=\langle\rho_2\rangle$
  weighted by $|c|^2$, so it scales like $T\log^2T$; a dimensional ratio cannot
  be a universal constant. Consequently **$L^*=10\cdot(C/D)$ identically** —
  $L^*=14.5$ is $C/D$ restated, not an independent finding — and the
  "off-diagonal $\le6.5\%$ at $L=100$" is the closed form $5(C/D)/L=7.2\%$.

## 3. Derivable-and-underived (queue, priority order)

1. $\kappa(X)$ composition, and re-issue the span-8.5 prediction parameterised.
2. Recompute K′'s threshold with span and $\log X$ separated; state per-$T$
   reachability rather than a blanket claim. *(2026-08-13: the input is now
   available in exact form — $\varepsilon=C_EX_0^{-1/2}\Theta_\phi(L/2)$,
   `BARRIER_ERROR_WINDOW.md` Theorem U2 — so the separation is no longer the
   obstacle; the recomputation itself and the per-$T$ statement remain open.)*
3. $C/D$ as $\langle\rho_2\rangle$; restate $L^*$, the 6.5%, and the "2.3%
   truncation tail" as band-dependent functions.
4. **The Fresnel quartic $\Delta^4/(12f^3)$** — this exactly explains the
   residuals the corpus reported as data limits: at $(1,3)$ it predicts
   $0.0195$ rad against measured $0.025$ (exp14) and $0.0193$ (exp26). Adding
   it should bring $(1,3)$ to $\sim0.1\%$.
5. $S_\infty=\sum_{m\ge2}\Lambda(m)/(1+m)^2$: hand-summing to $m=13$ already
   gives $0.298$ with all terms positive, so $S_\infty\approx0.45$, **not** the
   $0.257$ implied by M1's quoted $1.18$. M1's linear coefficient looks
   reverse-engineered from the fit it criticises. Evaluate the prime sum.
6. $c_2$'s convergent prime sum, with its exact error bar
   $0.0924X^{-1/2}=6.7\times10^{-5}$ (here the quoted precision *is* justified —
   but the error term was never written, which is exactly what the protocol
   says is the content).
7. The coherent-fraction closed form (density-weighted Fresnel ratio), which
   also **retires the queued $k=3$ experiment**: predicted slope $-1.48$.

## 4. Cross-cutting

- **Stale $\varepsilon\sim10^{-3}$ still cited** in `BLIND` §4 and
  `phase_side` §11 — retracted by Lemma N three sections earlier in the same
  file.
- **"Five decades" vs "2.5 decades"**: the audited correction in `BLOCKS` §3
  never propagated to `BLOCKS` §4 or `APPENDIX_D` §D.6.
- **Band guard is under one resolution cell.** The $[10,27.5]$/$[28.5,320]$
  split leaves a 1.0-rad guard around $2\gamma_1=28.269$ against a 1.02-rad
  resolution — every cross-band attribution sits at the leakage level it is
  trying to exclude.
- **Structural objection to K′ (verifier A, K7).** The SRF bound is minimax
  over *arbitrary* measures, but the atoms are the **sumset** of $N(T)$
  generators: perturbing one $\gamma_j$ moves $N(T)$ atoms coherently
  ($\sqrt N$ gain), and the moment-matched merge saturating the bound is
  probably not realisable by any admissible zero configuration. **K′ must be
  restated as a bound on structure-blind recovery of the sumset, explicitly
  not on recovery of $\{\gamma\}$.** Note this is exactly Theorem I1's content
  seen from the other side: the sumset determines the zeros, so sumset
  structure is information the minimax bound throws away.
- **Thresholds set by inspection, nowhere recorded**: the $0.1D$ in $L^*$; the
  $6.9\times$ band ceiling; $s\le300$; the $\eta$ fit window; detrend degrees;
  model order; grid sizes; zero counts. Each should be listed with the
  quantity it gates.

## 5. What survived cleanly

exp30's $1.022\pm0.112$ over 16 bands (a ratio-to-model *with* an error bar —
the template the rest should copy); exp12's deviations as checks of a proved
remainder; exp23's amplitude ratio $0.9992$ (a genuine discrete test: a wrong
prefactor reads 2 or ½); `BLIND`'s model-order sensitivity analysis; and the
$37/(12f)$ Stirling constant, independently re-derived
($3+\tfrac1{12}=\tfrac{37}{12}$) — though "verified numerically to three
digits" should be dropped, since reporting it invites the reader to think it
was measured.
