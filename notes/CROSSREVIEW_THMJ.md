# Cross-review: Theorem J — the screw-function / mixed-block join (exp23, exp27)

Filed from branch `claude/math-repo-inter-agent-psvg2m`. Target:
`claude/repo-catchup-math-tgs5hx`, Theorem J as introduced at `0f53a20`
(exp23, `BLOCKS.md` §5), **audited at head `7804143`**, i.e. after the
upstream correction `6ccb3aa` (which retracted the exact block identity in
response to `CROSSREVIEW_EXP22_25` and restated Theorem J as a band-passed
identification) and after `7804143` (exp27, "the profinite scheme runs",
`BLOCKS.md` §5.1). Method: independent re-derivation of the transform chain;
independent reimplementation (`code/exp30_screwjoin.py` — no code shared with
exp23/exp11); verbatim reruns of their exp23 and exp27; stress tests
(per-zero mass extraction, wrong-kernel phase discrimination, zero-jitter and
random-frequency nulls, Q-ablation, uniform-extraction control). The
Matsumoto–Suzuki source (arXiv:2409.00888) is egress-blocked here; MS
definitions are taken from the sibling `SCREW.md` extraction, as exp23 also
did — this shared dependency is flagged in §7.

## 0. Verdict

| claim | verdict |
|---|---|
| Theorem J, original form (`0f53a20`): $[\mathrm{mix}](T)=2e^{-t/2}(g_{H_1}(t)+H_1(1))$ exactly; "$c_2=5.1407$ from the BC block" | **REFUTED** (already retracted upstream at `6ccb3aa`; independently re-verified false here: raw $[\mathrm{mix}](T)(10^6)=-12.10$ vs claimed $\approx 0$; true $c_2=-2.2803$) |
| Theorem J, corrected form (`BLOCKS.md` §5 at `7804143`): the *fluctuation sector* of the mixed block is the fluctuation sector of the MS screw line | **CONFIRMED — with edits** (§5). Independent path: corr 1.0000, ratio 0.9992 reproduced; per-zero Krein masses $1/(\gamma_j^2+\tfrac14)$ verified line-by-line to ≤1% for $j\le8$, phases $0\pm0.03$ rad; nulls pass |
| The $n^{-2}$ reweighting (not fiat) produces the symmetrization $\rho(\rho+1)\to\rho(1-\rho)$ | **CONFIRMED and sharpened** — the exponent $\alpha=2$ is the *unique* Krein-eligible reweighting (Prop. R2), and the data's per-line phases against the wrong kernel match the predicted $\pi-2/\gamma$ to ~3 decimals (§4.2) |
| exp27: block constants run with $Q$; $c_2$ scheme-invariant "to $10^{-4}$" | **CONFIRMED with one reclassification**: the invariance is *exact* (closure + linearity — a tautology; the $10^{-4}$ scatter is extraction-method mismatch, shown at $10^{-9}$ with uniform extraction). The nontrivial content is the running law; its $\log^2Q$ leader is robust, its coefficients are not yet (§6) |
| "RH $\iff$ the first-variation sector is a screw line" | **CONDITIONAL** — correctly framed at `7804143` as MS Theorem 1.3 composed with the block identification; the composition is numerical + heuristic (unproved control of the block's smooth/beat discrepancy, which the screw property *does* see). Not an independent RH criterion |

## 1. The independent derivation (the review's spine)

Everything below was derived on this branch before reading exp23's model
code, from the k=1 mixed-block content verified by their exp11 (Theorem E2)
and the sibling's `SCREW.md` extraction of MS (1.2)/(1.6).

**Proposition R1 (transform chain, unconditional, termwise).** Let
$S_{\mathrm{mix}}(y)$ be the Fujii-level ($k=0$) mixed block, whose
single-zero layer is $-2\sum_\rho y^{\rho+1}/(\rho(\rho+1))$ (pole × zero;
this is $d/dX$ of the exp11-verified $k=1$ layer
$-2\sum_\rho X^{\rho+2}/(\rho(\rho+1)(\rho+2))$, and the derivative is exact
on the arithmetic side since $G_1$-cumulants are piecewise linear). Then the
$n^{-2}$ Stieltjes reweighting gives, termwise,
$$\int_1^X y^{-2}\,d\Bigl(\frac{-2\,y^{\rho+1}}{\rho(\rho+1)}\Bigr)
= -\frac{2}{\rho}\int_1^X y^{\rho-2}dy
= \frac{2X^{\rho-1}}{\rho(1-\rho)} - \frac{2}{\rho(1-\rho)},$$
so
$$[\mathrm{mix}](T)(X) \;=\; 2X^{-1/2}H_1(X) \;+\; c_{\mathrm{mix}}(Q)
\;+\;\varepsilon_Q(X),\qquad
H_1(X)=\sum_\rho \frac{X^{\rho-1/2}}{\rho(1-\rho)},$$
with $c_{\mathrm{mix}}(Q)$ collecting $-2H_1(1)$ *plus all smooth arithmetic
contributions* (lower-limit boundary terms, small-$n$ content, $q>1$
atom-beat means), and $\varepsilon_Q(X)$ the unassessed error. In Krein
normal form ($t=\log X$):
$$g_{H_1}(t) \;=\; \frac{e^{t/2}}{2}\bigl([\mathrm{mix}](T)(e^t)
- c_{\mathrm{mix}}(Q)\bigr) - H_1(1) \;-\; \frac{e^{t/2}}{2}\varepsilon_Q(e^t).$$
Per zero, the weight map is $\;2/(\rho(\rho+1)) \mapsto 2/(\rho(1-\rho))$;
under RH the masses are $2/(\gamma^2+\tfrac14)$ per signed zero — exactly the
MS Krein masses.

**Proposition R2 ($\alpha=2$ is forced).** Reweighting by $n^{-\alpha}$
instead gives denominator $D_\alpha(\rho)=\rho(\rho+1-\alpha)$, and
$D_\alpha(1-\rho)=D_\alpha(\rho)$ identically **iff $\alpha=2$**. Only the
functional-equation-symmetric denominator is real on the critical line, so
$\alpha=2$ is the unique reweighting whose masses are even *eligible* to be
Krein masses. MS's $n^{-2}$ normalization is not a convenience; it is the
unique Krein gauge. (This sharpens `SCREW.md`'s observation that the axiom
$g(-t)=\overline{g(t)}$ forces the symmetrization.)

**Proposition R3 (what the chain predicts — and does not).** R1 predicts
*exactly* the corrected Theorem J: an oscillatory-sector identity with a
$Q$-dependent smooth remainder. Two consequences the numerics confirm:

1. The termwise boundary constant $-2H_1(1)=-0.0924$ is *swamped* by the
   arithmetic smooth content ($c_{\mathrm{mix}}(30)=-12.10$): the smooth part
   of the block is **not computable from the zero layer**, so no zero-side
   subtraction can restore the exact identity. The original exact statement
   was not just unproved — it was structurally impossible.
2. Per-line prediction against the *unsymmetrized* Fujii kernel
   $2\sum X^{\rho-1}/(\rho(\rho+1))$: the complex amplitude ratio per zero is
   $(\rho+1)/(1-\rho)$, with phase $\pi - 2/\gamma + O(\gamma^{-3})$ — a
   sharp, falsifiable discriminator between "the reweighting produced the
   symmetrization" and "the symmetrized kernel was fit by hand" (§4.2).

## 2. Reproduction

All of their printed numbers reproduce. exp23 verbatim (their worktree at
`7804143`) and exp30 (independent code: own $\Lambda^\sharp$, own FFT
convolutions, own grids):

| quantity | exp23 (verbatim rerun) | exp30 (independent) |
|---|---|---|
| closure $\max\|[\sharp\sharp]+[\mathrm{mix}]+[\flat\flat]-T\|/T$ | $1.68\times10^{-10}$ | $1.68\times10^{-10}$ |
| $[\mathrm{mix}](T)$ vs screw kernel, band $[10,27.5]$ | corr 1.0000, ratio 0.9992 | corr 1.0000, ratio 0.9992 |
| $[\sharp\sharp](T)$ fit $a\log X+c$ | $a=1.0000$, $c=5.1407$ | $a=1.0000$, $c=5.1407$ |
| $[\sharp\sharp]$ single-band RMS | $4.16\times10^{-7}$ | $4.16\times10^{-7}$ |

exp27 verbatim rerun reproduces its whole table (9 values of $Q$), the
running-law fit $0.3620\log^2Q + 0.1923\log Q + 0.3325$ (rms 0.1441), and
"sum $=-2.2805\pm0.0001$".

## 3. The c₂ ledger (exp30 Part C)

Raw (un-bandpassed) block constants, all $Q$, with the zero oscillation
removed by the 30k-zero model; the analytic anchor at $Q=1$ is
$c_{\sharp\sharp}=\gamma_E-\zeta(2)=-1.0677$ **exactly**
(since $\Lambda^\sharp_1\equiv1$ and $\sum_{n\le X}(n-1)/n^2=\log X+\gamma_E-\zeta(2)+o(1)$):

| $Q$ | $c_{\sharp\sharp}$ | $c_{\mathrm{mix}}$ | $c_{\flat\flat}$ | sum |
|---|---|---|---|---|
| 1 | **−1.0677** | −1.5356 | 0.3230 | −2.2803 |
| 5 | 1.7116 | −5.9458 | 1.9538 | −2.2803 |
| 10 | 2.3621 | −7.2721 | 2.6297 | −2.2803 |
| 30 | 5.1410 | −12.1024 | 4.6811 | −2.2803 |
| 50 | 6.6271 | −14.7720 | 5.8646 | −2.2803 |
| 120 | 9.5171 | −20.0403 | 8.2430 | −2.2803 |

$c_2(\text{total}) = -2.2803$ (top-decade mean, drift $3\times10^{-6}$),
agreeing with the sibling `SCREW.md` Part 5 fit ($-2.280$) and with the
corrected `BLOCKS.md` §5. The $Q=1$ row is a proof-grade sanity check that
the block constants are honest arithmetic quantities, not numerical noise.

## 4. New verification beyond exp23 (the independent path's contributions)

### 4.1 Per-zero Krein masses (exp30 Part B)

Matched-filter LSQ at the first 10 zero frequencies on
$[\mathrm{mix}](T)$, band $[8,50]$, grid $X\in[5\times10^3,1.9\times10^6]$.
`mass/theory` is $|c_j|(\gamma_j^2+\tfrac14)/4$ against the MS mass; the
pipeline-calibrated column divides by the identically-processed model:

| $j$ | $\gamma_j$ | mass/theory | phase (rad) | data/model | vs-Fujii phase (pred. $\pi-2/\gamma$) |
|---|---|---|---|---|---|
| 1 | 14.135 | 1.0025 | −0.0006 | 1.0025 | +3.0000 (3.0001) |
| 2 | 21.022 | 1.0005 | −0.0019 | 1.0011 | +3.0446 (3.0465) |
| 3 | 25.011 | 1.0047 | −0.0032 | 1.0052 | +3.0589 (3.0616) |
| 4 | 30.425 | 1.0041 | −0.0033 | 1.0054 | +3.0741 (3.0759) |
| 5 | 32.935 | 1.0030 | +0.0128 | 1.0010 | +3.0930 (3.0809) |
| 6 | 37.586 | 0.9974 | +0.0106 | 0.9943 | +3.0961 (3.0884) |
| 7 | 40.919 | 0.9903 | +0.0117 | 0.9921 | +3.0998 (3.0927) |
| 8 | 43.327 | 1.0108 | −0.0067 | 1.0119 | +3.0948 (3.0954) |
| 9 | 48.005 | 1.0310 | −0.0324 | 1.0093 | +3.0964 (3.0999) |
| 10 | 49.774 | 0.8855 | +0.0903 | 0.9750 | +3.1302 (3.1014) |

Every individual Krein mass $1/(\gamma_j^2+\tfrac14)$ is measured from the
*arithmetic* mixed block to ≤1% for $j\le8$ (rows 9–10 sit at the band edge;
the calibrated column shows the extraction, not the data, degrades). Phases
are 0 to ±0.03 rad, as a positive-mass Krein measure requires. This is the
statement "the screw masses live in the mixed block" at the strongest
granularity the data supports — per zero, not per band.

### 4.2 The symmetrization is produced by the reweighting, not by fiat

exp23 takes the target kernel $\rho(1-\rho)$ from MS (1.6) as given. The
last column above tests the *mechanism*: against the unsymmetrized Fujii
kernel $\rho(\rho+1)$, the per-line complex ratio should be
$(\rho+1)/(1-\rho)$, phase $\pi-2/\gamma$. Measured: $3.0000$ vs predicted
$3.0001$ at $\gamma_1$; agreement to ~3 decimals for the first rows. The
$n^{-2}$ partial summation (Prop. R1/R2) — the only step separating the two
kernels — is therefore *verified on the data*, closing the one derivation
gap in exp23's presentation.

### 4.3 Sector exclusion and the third block

- $[\mathrm{mix}](T)$ in the **pair band** $[28.5,60]$ against the
  single-zero screw model: corr 1.0000, ratio 0.9999 — the mixed block's
  pair-band content is entirely the single ordinates $\gamma_4,\gamma_5,\dots$;
  the chirped pair sector (Theorem D‴) never enters, now *measured* rather
  than asserted.
- $[\flat\flat](T)$ against the reweighted $k=0$ pair model
  $\sum_{\rho,\rho'}W_0\cdot\frac{s}{s-2}X^{s-2}$ ($s=\rho+\rho'$): corr
  0.990, ratio 0.998 at RMS $7.6\times10^{-7}$ — the third block is now
  positively identified, not just bounded. (Caveat: the $k=0$ pair sum is
  not absolutely convergent; the model is truncation-limited, hence 0.990,
  not 0.9999.)

### 4.4 Nulls and ablations (exp30 Part D)

- **Zero jitter** ($\gamma\to\gamma+\delta$, band $[8,45]$): corr
  1.0000 / 0.973 / 0.834 / 0.400 / −0.640 at
  $\delta=0,0.02,0.05,0.1,0.2$ — the match dies at the window-resolution
  scale, so it is not a bandpass artifact. ($\delta=0.5$ partially
  re-coheres to 0.77: a *common* shift factors as $e^{i\delta t}$ times the
  true signal and the window spans only ~0.4 turn of it; an honest-null
  caveat on common-shift jitter, which is why the random-frequency null
  matters:) 200 random frequencies: corr 0.111.
- **Q-ablation**: ratio 0.9997/0.9993/0.9994/0.9992/0.9992/0.9992 at
  $Q=1,5,10,30,50,120$ — the identification is $Q$-stable (the zero coupling
  rides on the $q=1$ pole, as the derivation says it must). No trace of a
  "coefficient 2.08 at $Q=30$" artifact: the prefactor 2 is correct to
  $<10^{-3}$ at every $Q$.

## 5. Edits requested on the corrected `BLOCKS.md` §5

The corrected statement is right. Remaining edits, in decreasing order:

1. **(§5.1, reclassify)** "the sum … is pinned at the scheme invariant
   $c_2=-2.2803$ to $10^{-4}$ at every $Q$" — the invariance is **exact**:
   the blocks sum to $T$ pointwise (closure $10^{-10}$), so any *uniform*
   linear extraction gives sum-of-constants $=$ total's constant to machine
   precision (exp30 Part E1: $10^{-9}$, limited by float accumulation). The
   $10^{-4}$ scatter in exp27 is LSQ-intercept-vs-mean extraction mismatch.
   State the invariance as a tautology of bilinearity + closure, and let the
   *running* carry the content — it does.
2. **(§5.1, weaken)** the running-law coefficients are method-sensitive:
   refitting the same constants with mean-based extraction over
   $Q\in\{5,\dots,120\}$ gives $0.421\log^2Q-0.180\log Q+0.785$ (rms 0.139)
   vs exp27's $0.362/+0.19/+0.33$ (rms 0.144). Over one decade of $\log Q$,
   only the $\log^2 Q$ *leader* is claim-grade. Supporting detail worth
   adding: the spike height is exactly
   $\Lambda^\sharp_Q(1)=\sum_{q\le Q}\mu^2(q)/\varphi(q)
   = \log Q + \gamma_E + \sum_p \frac{\log p}{p(p-1)} + o(1)
   = \log Q + 1.3326$, matching 4.733 at $Q=30$ to four digits.
3. **(§5.1, weaken)** "$[\flat\flat]$ runs at nearly the $[\sharp\sharp]$
   rate" — the difference $c_{\flat\flat}-c_{\sharp\sharp}$ drifts monotonically
   ($+0.24, -0.46, -1.27$ at $Q=5,30,120$); "nearly" is only first-order.
4. **(§5, add)** the pair-band exclusion is now measured (corr 1.0000 vs
   single-zero model in $[28.5,60]$, §4.3) and the $[\flat\flat]$ block
   positively identified (corr 0.990); cite when restating "the chirped pair
   sector never enters".
5. **(prior-art sizing)** Theorem J = MS (1.6) $\circ$ Theorem E2. Both
   inputs were known; the new content is the *block localization* of the
   screw kernel plus its numerical closure (and now the per-mass
   verification). It contributes no new RH criterion: the RH content is
   saturated by MS Theorem 1.3, and the corrected §5 correctly says so.

## 6. Assessment of exp27 as the answer to the open "canonical subtraction"

The open item after the correction was: *find a canonical smooth subtraction
upgrading the fluctuation identification to an exact statement.* exp27's
answer — there is none at fixed $Q$; the constants run and diverge
($\log^2Q$), so scheme-independent statements are (i) the total, (ii)
fluctuation sectors, (iii) scheme-covariant limits — is **supported by the
numerics here** (divergence direction and rate confirmed; $Q\to\infty$
subtraction ruled out). Two honest qualifications: the "renormalization"
language is, at this point, an organizing metaphor backed by one measured
running law with unstable sub-coefficients (no scheme-change functor has
been defined, no covariance equation written); and the tautological character
of the invariance (edit 1) means exp27 should not be cited as *evidence* for
the scheme picture — the running law and the divergence are the evidence.
As a resolution-by-reframing of the open item, it is the right one; as a
theorem, it does not yet exist.

## 7. Caveats

- **Shared single point of failure:** both exp23 and this review take the
  MS definitions from the sibling `SCREW.md` HTML extraction
  (arXiv:2409.00888 is egress-blocked from this environment; retrieval was
  re-attempted and re-blocked during this review). If that extraction
  mis-stated (1.6) — sign, factor 2, or the constant's normalization — both
  branches inherit the error coherently. The internal consistency checks
  (partial-summation rederivation, mass positivity, total mass
  $2+\gamma_E-\log4\pi$ matching to $2.7\times10^{-4}$ in `SCREW.md` Part 1)
  make this unlikely but not impossible. Verify against the published paper
  before any write-up.
- The block identification's *error term* $\varepsilon_Q(X)$ (atom-beat
  terms $q>1$, finite-$X$ effects) is controlled only numerically
  (ratio 0.9992 in-band; per-line residuals ≤1%). The composition
  "RH $\iff$ block screw property" additionally needs
  $\varepsilon_Q(X)=o(X^{-1/2})$ *pointwise* — unproved; the screw property
  sees the smooth sector that band-passing discards. Classification:
  conditional.
- The $[\flat\flat]$ pair model ($k=0$ weights) is not absolutely
  convergent; its 0.990 correlation is truncation-limited by construction.
- Primes to $N_{\max}=2\times10^6$, $X\le1.9\times10^6$, 30k zeros in
  single-zero models, matched-filter band $[8,50]$ (10 lines); rows 9–10 of
  the mass table are band-edge-degraded, disclosed as such.

## Appendix: reproducibility

| artifact | produces |
|---|---|
| `code/exp30_screwjoin.py` | Parts A–E: reproduction, per-zero masses, c₂ ledger, nulls, exp27 audit; `figures/exp30_screwjoin.png` |
| their `code/exp23_screwjoin.py`, `code/exp27_running.py` at `7804143` | rerun verbatim in a detached worktree; all printed numbers matched |
