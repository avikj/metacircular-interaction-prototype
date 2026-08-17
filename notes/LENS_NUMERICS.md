# LENS_NUMERICS: the Q-filtration face of the cut-norm lens (exp32)

Executes open interface #2 of the catchup branch's `INDEX.md`: "their
[sibling] cut-norm theorems use this branch's measured decomposition; the
Q-orthogonality table (exp11) is the numerical face of their spectral-gap
propositions." Target document:
`notes/LENS_REGULARITY.md` on `claude/prime-pair-field-research-18tq7b`
(Theorem 1: interval cut norm ⟺ RH, exponent identity $=2\Theta$; Theorem 2:
$\Lambda=\Lambda^\sharp_Q+\Lambda^\flat_Q$ as exact regularity decomposition;
Prop 3: Bohr cuts ⟺ GRH; Prop 6: exact counting lemma). Numerical
companion: `BLOCKS.md` §1 / exp11 on `claude/repo-catchup-math-tgs5hx`
(head `7804143`, post-audit: block *constants* are $Q$-dependent scheme
artifacts; only fluctuation statements are reliable). Code:
`code/exp32_lens_numerics.py` (~40 s at $N=10^7$); figure:
`figures/exp32_lens_numerics.png`. Author: this branch
(`claude/math-repo-inter-agent-psvg2m`).

**What was new to measure.** The sibling's exp36 measured $D_Q(X)$ at
$Q\in\{1,30\}$ only — one effective level. But Theorems 1–2 and Prop 6 are
stated *for every fixed $Q$*, and their content as a filtration statement is
exactly the spectral gap: removing more major-arc structure
($Q:1\to300$ strips 1 → 182 Farey atom systems from $\Lambda^\flat$) must
not move the discrepancy exponent, only the $O_Q(1)$ constant
(Corollary 1.2). That $Q$-uniformity, the Prop-6 slack budget, and the Bohr
(GRH) family had no numbers on any branch. This note supplies them.

**Verdict up front (graded):**

1. **$Q$-uniformity of Theorem 1 — VERIFIED (measured, RH-consistent).**
   $D_Q(X)/\sqrt X$ is flat over three decades at *every*
   $Q\in\{1,10,30,100,300\}$: fitted exponents $0.487$–$0.502$
   ($\pm0.006$), constants $0.976$–$0.983$ at $X=10^7$. The entire
   $Q$-dependence is $\max_X|D_Q-D_1|\le26.1$ — inside Corollary 1.2's
   budget $C_Q$ with slack factor 8–41.
2. **Prop 6 bound — HOLDS everywhere** on the $(X,Q)$ grid (minimum slack
   125, no violations). **Sharpness at $X^{5/2}$ — CONFIRMED for the
   oscillatory content, with a caveat the note's phrasing hides:** in the
   window $X\le10^7$ the measured error $|G_1-[\sharp\sharp]_Q|$ is
   dominated not by the single-zero layer but by a *smooth $X^2$-scale
   floor* (envelope exponents $2.05$–$2.16$, not $2.5$); the single-zero
   layer is present underneath at exactly its parameter-free predicted
   amplitude (band-passed corr $1.0000$, amplitude ratio $0.999$–$1.000$
   at all five $Q$) and overtakes the floor only at
   $X^*\approx3\times10^5$–$2.5\times10^6$ (envelope crossing; instantaneous
   dominance later still). Asymptotic waste of the bound: a constant
   $\approx680\,Q$, *not* $Q\sqrt X$ — the $Q\sqrt X$ reading is true only
   pre-asymptotically, below $X^*$.
3. **The smooth floor has a closed form — NEW (derived + verified to
   $\pm0.01$):** $c(Q)=c_0+M(Q)/2$ with $M$ the Mertens function and
   $c_0=-2.05$. This is the catchup audit's "$Q$-dependent block-constant
   artifact" *identified*: the artifact is exactly Mertens/2.
4. **Bohr cuts (Prop 3 / GRH face) — MEASURED, GRH-consistent:**
   $\sqrt X$-flat at every $q\le20$ (exponents $0.46$–$0.54$), constants
   $0.82$–$0.98$ — nearly $q$-independent, refuting the naive
   $1/\sqrt{\varphi(q)}$ RMS heuristic for this max statistic.
5. One cosmetic flag against `LENS_REGULARITY.md` §0 (the nesting
   $\mathcal I=\mathcal B_1\subset\mathcal B_q$), §6 below.

---

## 1. Protocol

**Objects.** $\Lambda^\sharp_Q(n)=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}c_q(n)$,
$\Lambda^\flat_Q=\Lambda-\Lambda^\sharp_Q$, sieved to $N=10^7$ (numpy).
$\Lambda^\sharp_Q$ is built by an independent algorithm from both prior
pipelines (exp11 tiles residue rows; exp36 uses per-$q$ residue tables):
expanding $c_q(n)=\sum_{d\mid(q,n)}d\,\mu(q/d)$ and swapping sums gives
$$\Lambda^\sharp_Q(n)=\sum_{d\mid n,\ d\le Q}A_d,\qquad
A_d=d\sum_{\substack{q\le Q,\ d\mid q}}\frac{\mu(q)\,\mu(q/d)}{\varphi(q)},$$
an $O(N\log Q)$ divisor sieve. Validated against direct
$c_q$-row tiling at $N=2\times10^5$: max abs difference
$\le1.8\times10^{-14}$ at $Q\in\{10,30,300\}$.

**Interval discrepancy.** $D_Q(X)=\sup_{I\subseteq(0,X]}|\sum_{n\in I}\Lambda^\flat_Q(n)|$
computed *exactly* by the prefix-path reduction: with
$P(x)=\psi^\flat_Q(x)$, $D_Q(X)=\max_{y\le X}P-\min_{y\le X}P$ (running
max/min accumulation gives all $X$ in one pass). For the rank-one array
$W_X=\Lambda^\flat_Q\otimes\Lambda^\flat_Q$ this *is* the cut norm:
$\|W_X\|_{\mathcal I}=D_Q(X)^2$ (Theorem 1(1), exact — no approximation
anywhere in this statistic).

**Prop 6 error.** $G_1-[\sharp\sharp]_Q=2[\sharp\flat]+[\flat\flat]$
computed from the FFT convolutions of $\Lambda^\sharp_Q$ and
$\Lambda^\flat_Q$ (length $2^{25}$, ~~no wraparound~~ **wrap-free because
$2^{25}=33\,554\,432>2N-1=2\cdot10^7-1$, the support of the linear
self-convolution of sequences supported in $[1,N]$, $N=10^7$; slack factor
$1.677\ldots$** — SEED-98, 2026-08-14, applying SEED-27 §6 item 2 and §9:
"no wraparound" is an assertion, the inequality is its proof), then
$[\cdot](X)=X R(X)-S(X)$ by prefix sums — numerically far better
conditioned than differencing the two $\sim X^3/6$ counts. Cross-validated
against the direct difference $G_1-[\sharp\sharp]$ at $N=10^6$, $Q=30$: max
relative deviation $4.5\times10^{-9}$.

**Bohr cuts.** $D_{\mathcal B_q}(X)=\max_{0\le a<q}\ \mathrm{osc}_{x\le X}
\sum_{n\le x,\ n\equiv a\,(q)}\Lambda^\flat_Q(n)$ at $Q=30$,
$q\in\{3,4,5,7,11,16,20\}$ — all residues $a$, coprime or not (the
non-coprime classes are $O(1)$-flat by Lemma 1.1 and never attain the max).

**Replication of exp36 (independent pipeline).** $D_1(10^4)=94.83$,
$D_1(10^6)=994.29$, $D_1(10^7)=3107.96$, $D_{30}(10^6)=988.92$,
$D_{30}(10^7)=3105.43$; measurable-cut scale $0.9335$ ($Q{=}1$) and
$0.8952$ ($Q{=}30$) at $10^7$ — every quoted digit of the sibling's exp36
table reproduces exactly.

---

## 2. Part A — the interval discrepancy across the $Q$-filtration

| $Q$ | $D(10^4)$ | $D(10^5)$ | $D(10^6)$ | $D(10^7)$ | exponent (1e4–1e7) | exponent (1e5–1e7) | $D/\sqrt X$ @ $10^7$ | $\max_X\|D_Q{-}D_1\|$ | $C_Q$ |
|----:|------:|------:|------:|------:|:---:|:---:|:---:|---:|---:|
|   1 | 94.83 | 334.99 | 994.29 | 3107.96 | $0.487\pm0.006$ | $0.491\pm0.011$ | 0.983 | — | 1.0 |
|  10 | 93.13 | 333.49 | 991.96 | 3105.96 | $0.489\pm0.006$ | $0.492\pm0.011$ | 0.982 | 3.50 | 28.8 |
|  30 | 92.24 | 334.60 | 988.92 | 3105.43 | $0.490\pm0.006$ | $0.492\pm0.011$ | 0.982 | 5.89 | 99.8 |
| 100 | 91.70 | 325.13 | 989.43 | 3101.01 | $0.494\pm0.006$ | $0.495\pm0.011$ | 0.981 | 11.01 | 346.2 |
| 300 | 90.02 | 323.34 | 975.81 | 3087.53 | $0.502\pm0.006$ | $0.495\pm0.011$ | 0.976 | 26.11 | 1067.0 |

($C_Q=\sum_{r\le Q}\sigma(r)/\varphi(r)$, Lemma 1.1's error constant;
regression over 61 log-spaced points; errors are least-squares standard
errors, which understate the truth since the running-osc statistic is
serially correlated — see caveats.)

**Readings.**

- **Exponent $Q$-uniformity, the headline:** all five exponents sit in
  $[0.487,0.502]$, pairwise within one standard error. Stripping the Farey
  atom systems up to $Q=300$ — i.e. deleting from $\Lambda^\flat$ every
  rational frequency $a/q$, $q\le300$, at its full $\mu(q)/\varphi(q)$
  weight — moves the cut-norm growth exponent by less than $0.015$. This is
  the discrepancy-side face of the spectral gap (BLOCKS.md Thm E2: the BC
  block is spectrally dead; all zero content lives in $\Lambda^\flat$ at
  every $Q$): if $\Lambda^\sharp_Q$ absorbed *any* zero mass, $D_Q$ would
  drop at scale $\sqrt X$ as $Q$ grows. It drops by $\le26$ — an $O(1)$
  amount, at scale $X^0$.
- **Corollary 1.2 verified with room:** $\max_X|D_Q-D_1|/C_Q$ =
  0.12, 0.059, 0.032, 0.024 for $Q$ = 10, 30, 100, 300 — the bound's
  constant is generous by a widening factor (8→41): the measured drift
  grows like $\sim Q^{0.6}$, not $\sim C_Q\sim Q$.
  **[CORRECTED 2026-08-13 — `DRIFT_EXPONENT_EXACT.md` Theorem D: the exponent is exactly $1/2$, unconditionally; the drift's scale is $\sqrt{\zeta(2)/3\zeta(4)}\,Q^{1/2}(1+O_\varepsilon(Q^{-1/2+\varepsilon}))=0.71176\,Q^{1/2}$, the mean square of the controlling function being exactly $\frac1{12}(\sum_{r\le Q}\mu^2(r)\sigma(r)/\varphi(r)-1)$; the fitted $0.6$ is $\tfrac12+\Theta(1/\log Q)$ read at four points, and the "widening slack" is the square root relating that sum to its own $\ell^1$ bound.]**
- **In cut-norm terms** (Theorem 1(2)): the measured growth exponent of
  $\|W_X\|_{\mathcal I}=D_Q^2$ is $0.97$–$1.00\pm0.02$ at every $Q$,
  consistent with $2\Theta=1$ (RH) and inconsistent with any power-law
  deviation $2\Theta\ge1.1$ *sourced at heights visible below $10^7$* (a
  violating zero at large height $T$ contributes $\sim x^\beta/T$ and
  would be invisible here; finite-$X$ caveat below).
- **Lemma 2 degeneration at every $Q$:** measurable-cut scale
  $\max(\sum f_+,\sum f_-)/X$ at $X=10^7$: 0.934, 0.904, 0.895, 0.859,
  0.798 for $Q$ = 1…300 — no decay in $X$ at any $Q$ (each column rises
  toward 1), approach slowed by $Q$ exactly as the $(1-o_Q(1))$ statement
  allows (larger $Q$ puts more $\Lambda^\sharp$ mass on prime powers,
  delaying the limit). The interval family sees $X^{1/2}$; the measurable
  family sees $X^1$ per factor. Both lens statements hold across the
  filtration.

---

## 3. Part B — Prop 6: bound, slack, and what the error actually is

Prop 6: $|G_1(X)-[\sharp\sharp]_Q(X)|\le2Q X^2D_Q(X)+XD_Q(X)^2$.

**Bound status: holds at every grid point** ($Q\in\{1,10,30,100,300\}$,
$X\in[10^4,10^7]$, 380 log-spaced points). Slack $=$ RHS$/|$LHS$|$:

| $Q$ | LHS @ $10^4$ | LHS @ $10^7$ | slack min | slack median | slack max |
|----:|---:|---:|---:|---:|---:|
|   1 | $-1.54\times10^{8}$ | $+3.56\times10^{14}$ | 125 | 829 | $2.9\times10^5$ |
|  10 | $-2.55\times10^{8}$ | $+2.56\times10^{14}$ | 739 | 5\,202 | $3.7\times10^5$ |
|  30 | $-3.55\times10^{8}$ | $+1.56\times10^{14}$ | 1\,572 | 11\,043 | $1.0\times10^6$ |
| 100 | $-1.55\times10^{8}$ | $+3.56\times10^{14}$ | 11\,982 | 81\,650 | $2.9\times10^7$ |
| 300 | $-4.55\times10^{8}$ | $+5.61\times10^{13}$ | 11\,996 | 85\,621 | $1.1\times10^7$ |

**What the error is (the substantive finding).** The task hypothesis pair
was: (i) Prop 6's own sharpness claim — the error is genuinely
$X^{5/2}$ (single-zero layer), bound wasteful by a constant; vs (ii) the
error is really $X^{3/2}$-ish and the bound wasteful by $\sim Q\sqrt X$.
**Neither is what the window shows; the truth splits by spectral
component:**

- *Measured envelope exponent of $|$LHS$|$ over $[10^4,10^7]$:
  $2.05$–$2.16$* — neither $5/2$ nor $3/2$. The error in this window is
  dominated by a **smooth $X^2$-scale floor** with coefficient
  $c(Q)\in[-4.55,-1.54]$.
- *The single-zero layer is present at exactly its predicted size.*
  Band-passing LHS$/X^{5/2}$ to the single-zero band $[10,27.5]$ in log-$X$
  frequency (cubic detrend, core 3/4 of the grid — the exp11 methodology)
  and comparing with the parameter-free pole×zero model
  $-4\,\mathrm{Re}\sum_{\gamma>0}X^{\rho+2}/(\rho(\rho+1)(\rho+2))$
  (5000 Odlyzko zeros):

  | $Q$ | 1 | 10 | 30 | 100 | 300 |
  |---|---|---|---|---|---|
  | corr | 1.0000 | 1.0000 | 1.0000 | 1.0000 | 1.0000 |
  | amplitude ratio | 0.9998 | 0.9996 | 0.9995 | 0.9997 | 0.9994 |

  No fitted parameters. The oscillatory part of the Prop-6 error **is** the
  single-zero layer — i.e. the mixed $[\sharp\flat]$ block of BLOCKS.md
  Thm E2, now confirmed at five profinite levels simultaneously
  (exp11 had $Q=30$ only).
- *Floor/layer crossover.* The layer envelope is
  $A\,X^{5/2}$ with $A=4\sum_{\gamma>0}|\rho(\rho+1)(\rho+2)|^{-1}
  =2.88\times10^{-3}$ — a tiny constant, because the weights decay like
  $\gamma^{-3}$. The envelope overtakes the floor at
  $X^*=(|c(Q)|/A)^2\approx2.8\times10^5$–$2.5\times10^6$; instantaneous
  dominance (the layer actually attaining its envelope) arrives later, and
  indeed at $10^6$ the LHS sign is decided by the floor-vs-layer
  competition (already positive for the small-$|c|$ levels $Q=1,100$,
  still floor-negative for $Q=10,30,300$), while by $10^7$ the layer wins
  at every $Q$.

**The Mertens law of the floor (new; derived, then verified).** The
measured floor coefficients at $X=10^4$ (zero-layer pollution $\pm0.1$):

| $Q$ | 1 | 10 | 30 | 100 | 300 |
|---|---|---|---|---|---|
| $c(Q)$ | $-1.54$ | $-2.55$ | $-3.55$ | $-1.55$ | $-4.55$ |
| $M(Q)$ | $+1$ | $-1$ | $-3$ | $+1$ | $-5$ |
| $c(Q)-M(Q)/2$ | $-2.04$ | $-2.05$ | $-2.05$ | $-2.05$ | $-2.05$ |

$c(Q)=c_0+M(Q)/2$ with $c_0=-2.05$, exact to the measurement precision,
non-monotone in $Q$ exactly as Mertens is. The law holds at the far end of
the window too: the pairwise differences $\mathrm{LHS}_Q(10^7)-
\mathrm{LHS}_{Q'}(10^7)$ equal $\frac{M(Q)-M(Q')}{2}X^2$ to four digits
(e.g. $Q{=}1$ vs $Q{=}30$: $2.000\times10^{14}$ vs predicted
$2\times10^{14}$) — the five LHS values at $10^7$ are one common layer
value $\approx+5.1\times10^{14}$ plus the five Mertens floors. Mechanism (one line): from
$\varphi=\mu*\mathrm{Id}$ and $\langle\{x/d\}\rangle=1/2$,
$$\Big\langle\sum_{n\le x}\Lambda^\sharp_Q(n)-x\Big\rangle
=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}\cdot\Big(-\frac{\varphi(q)}{2}\Big)
=-\frac{M(Q)}{2},$$
and this mean offset of $\psi^\sharp_Q$ propagates through the
$[\sharp\flat]$ cross term into an $X^2$ coefficient shift of exactly
$M(Q)/2$. This *identifies* the "$Q$-dependent block-constant artifact"
that the catchup audit (BLOCKS.md §5, post-`7804143`) could only flag as
scheme-dependent: the artifact is Mertens/2 — bounded, oscillating in $Q$,
and $o(Q^\varepsilon)$-small, so it never threatens any exponent statement,
but it is *not* zero and dominates the counting-lemma error for all
$X\lesssim10^6$. ($c_0=-2.05$: the $Q$-independent part; $-\log2\pi=-1.84$
is the pole×constant term of the explicit formula, ~~the residual $-0.21$ is
unattributed — prime-power diagonal and $\zeta'/\zeta$ constants; not
pursued.~~)

**Correction (2026-08-13; `PROVABLE_MEASUREMENTS_TRIAGE_20260813.md` §3,
Theorem F).** The residual is attributed and is exactly $-\tfrac14$: it is the
smooth part of the bilinear term $\int_0^XE(v)E(X-v)\,dv$, which the
Friedlander–Goldston singular-series average under the Cesàro weight $(X-n)n$
evaluates to $-\tfrac{X^2}{4}$. The guessed attribution above — prime-power
diagonal and further $\zeta'/\zeta$ constants — is **retracted**; it named the
wrong objects. So
$$c(Q)=\tfrac12M(Q)-\log2\pi-\tfrac14,\qquad c_0=-2.0878771\ldots,$$
conditional on (BK$_S$) (BK/strong-HL level, not implied by RH); the measured
$-2.05$ sits $+0.04$ above it at every $Q$, i.e. inside this experiment's own
declared $\pm0.1$ common-mode zero-layer pollution.

**Slack verdict.** Decompose the bound's waste at the layer envelope:
RHS $\approx2Q\cdot0.98\,X^{5/2}$ vs LHS envelope $2.88\times10^{-3}X^{5/2}$
gives asymptotic slack $\to\approx680\,Q$ — **constant in $X$, linear in
$Q$**. The two losses are structural: (a) factor $\sim Q$ from bounding
$\|\Lambda^\sharp_Q\|_\infty\le Q$ where the effective mean is 1;
(b) factor $\sim680$ from bounding $|\Psi_1^\flat(y)|\le XD_Q$ — the
sup-bound forfeits the $1/|\rho|^2$ gain of two integrations against the
oscillating $\psi^\flat$ (the true $\Psi_1^\flat$ carries weights
$\gamma^{-2}$, the bound charges the full oscillation). Below $X^*$ the
measured slack does grow like $\sim Q X^{1/2}/|c(Q)|$ — so hypothesis (ii)
is the correct description *of the pre-asymptotic window*, and
hypothesis (i) of the limit; at $X=10^7$ the two regimes are still mixed
(slack $10^3$–$10^6$, not yet settled at $680Q$). Prop 6's phrase "sharp up
to logarithms" survives, but only as a statement about the oscillatory
envelope beyond $X^*\sim10^6$; as a description of the counting error a
practitioner would see at accessible heights it is misleading — the error
there is the Mertens floor, three orders below the bound.

---

## 4. Part C — Bohr cuts (Prop 3 / GRH face), $Q=30$

| $q$ | $\varphi(q)$ | $D_{\mathcal B_q}(10^6)$ | $D_{\mathcal B_q}(10^7)$ | exponent (1e5–1e7) | $D/\sqrt X$ @ $10^7$ |
|----:|---:|---:|---:|:---:|:---:|
|  3 | 2 | 1113.7 | 3106.7 | $0.507\pm0.004$ | 0.982 |
|  4 | 2 | 1369.8 | 2897.9 | $0.490\pm0.004$ | 0.916 |
|  5 | 4 |  915.1 | 2786.6 | $0.479\pm0.004$ | 0.881 |
|  7 | 6 |  990.6 | 3071.7 | $0.540\pm0.004$ | 0.971 |
| 11 | 10 |  811.8 | 2644.7 | $0.524\pm0.003$ | 0.836 |
| 16 | 8 |  935.7 | 2640.7 | $0.464\pm0.004$ | 0.835 |
| 20 | 8 |  903.4 | 2598.8 | $0.503\pm0.004$ | 0.822 |

- **GRH-consistent at every $q$:** exponents $0.46$–$0.54$, no drift with
  $q$; the spread is wider than Part A's because a single progression path
  has $q\times$ fewer points and the max-over-$a$ statistic is noisier.
- **The constants refuse the RMS heuristic.** A
  variance count ($\varphi(q)$ characters entering with weight
  $1/\varphi(q)$) predicts class discrepancy $\sim\sqrt{X/\varphi(q)}$,
  i.e. constants $0.98/\sqrt{\varphi(q)}\approx0.31$–$0.69$ for these $q$.
  Measured: $0.82$–$0.98$ — nearly $q$-independent, a factor 1.9–2.7 above
  the heuristic at the larger $\varphi$. The max over $a$ and the
  oscillation over three decades of $x$ compound extreme-value factors that
  eat the $1/\sqrt{\varphi}$ almost exactly at these sizes. Observation
  only; we offer no theory, and the near-coincidence
  $D_{\mathcal B_3}(10^7)=3106.7\approx D_{\mathcal I}(10^7)=3105.4$
  (interval value) is, as far as we can tell, numerical accident (the two
  statistics share the $\zeta$-zero term with weight $1/2$ per coprime
  class mod 3, plus an $L(\chi_3)$ term of the same size).
- **Cosmetic flag on `LENS_REGULARITY.md` §0:** the claimed nesting
  $\mathcal I=\mathcal B_1\subset\mathcal B_q\subset\mathcal M$ fails as
  literally defined — an interval is not a single residue class mod $q>1$,
  and indeed we measure $\|W\|_{\mathcal B_{20}}^{1/2}=0.82\sqrt X<
  0.98\sqrt X=\|W\|_{\mathcal I}^{1/2}$: the $\mathcal B_q$ cut norm can be
  *smaller* than the interval one, which a nested family forbids. Harmless
  everywhere it is used (Prop 3's proof quantifies over prefix classes
  only, and monotonicity is never invoked), but the dictionary table's
  middle row should read $\mathcal B_q\cup\mathcal I$ if nesting is wanted.

---

## 5. Interpretation: the join executed

1. **Theorem 1's exponent identity now has its filtration face.** The
   identity $\limsup\log\|W_X\|_{\mathcal I}/\log X=2\Theta$ is stated per
   fixed $Q$; its nontrivial numerical content is that the left side is
   $Q$-independent. Measured: cut-norm exponent $=2\times(0.49\pm0.01)$ at
   all five $Q$ spanning the removal of all Farey structure to level 300.
   The mechanism is the catchup branch's spectral gap (exp11: BC block
   dead, Hardy projections $\frac1X\sum\Lambda c_q\to\mu(q)$, Besicovitch
   orthogonality $\sim10^{-4}$): $\Lambda^\sharp_Q$ contains the pole and
   rational atoms only, so at *no* level does the structured part absorb
   zero mass — which is exactly why $D_Q$ can only move by the $O_Q(1)$
   of Corollary 1.2. The two branches' statements are now numerically one.
2. **Prop 6 calibrated against the explicit formula.** The
   regularity-lemma route (cut norm × counting lemma) pays, relative to
   the explicit-formula route, an asymptotic constant $\approx680\,Q$ — not
   an exponent, and not $Q\sqrt X$ (that reading only describes
   $X<X^*\sim10^6$). The counting error itself is *exactly* the
   pole×zero mixed block at every $Q$ (corr 1.0000, ratio 0.999–1.000,
   parameter-free) — Prop 6 and BLOCKS.md Thm E2 are the same fact in two
   vocabularies, and this is measured, not just asserted, across the
   filtration.
3. **The audit's "$Q$-artifact" is now a formula.** The catchup
   cross-review demoted all block constants to scheme artifacts; exp32
   shows the counting-lemma floor constant is $c_0+M(Q)/2$ — the artifact
   is precisely the Mertens partial sum the truncation leaves behind. This
   upgrades "unreliable, $Q$-dependent" to "known, bounded, oscillating,
   removable": any future block-constant statement can subtract it.
   *(2026-08-13, `PROVABLE_MEASUREMENTS_TRIAGE_20260813.md` §3: the formula is
   now fully closed-form, $c(Q)=\tfrac12M(Q)-\log2\pi-\tfrac14$ under (BK$_S$),
   so the subtraction needs no measured input at all.)*
4. **What this does *not* touch.** All of this is the averaged/boxed
   sector: nothing here bears on the anti-diagonal slice (Props 7–8 of the
   sibling note, the relocated Goldbach wall). The lens is calibrated, not
   extended.

---

## 6. Caveats (all honest, none optional)

- **Finite $X$.** Three decades ($10^4$–$10^7$) is a short lever for
  exponents: the quoted $\pm0.006$–$0.011$ are regression standard errors
  under an independence assumption the running-osc statistic violates
  (its increments are strongly serially correlated); true uncertainty is
  larger, plausibly $\pm0.02$–$0.03$. A zero off the line at height
  $T\gtrsim10^2$ with $\beta>1/2$ contributes $x^\beta/T$ and would be
  invisible at these heights; nothing here *tests* RH beyond
  $X=10^7$-visible violations.
- **$D/\sqrt X\approx0.98$ is an extreme-value level, not a constant of
  nature.** Under RH + Littlewood's $\Omega_\pm(x^{1/2}\log\log\log x)$
  the ratio must creep upward without bound, at a rate invisible over
  three decades. "Flat" here means: no *power-law* drift. Same for every
  Bohr constant.
  **[SHARPENED 2026-08-14 — `notes/INTERVAL_DISCREPANCY_MEAN_SQUARE.md`: this
  caveat is right and is not conditional on RH (Thm A there splits on
  $\Theta$); but "creep upward" overstates it — $D_Q(X)/\sqrt X$ is a
  *discounted* running max (bound (2.1) there), so what is proved is
  $\limsup=+\infty$, with no known drift in the $\liminf$, and the proved rate
  needs $X\approx10^{986}$ to double. The exactly derivable companion statistic
  is the logarithmic mean square, limit $\sum_\gamma m_\gamma^2/(\tfrac14+\gamma^2)$
  $=2+\gamma_E-\log4\pi$ iff the zeros are simple.]**
- **Max-over-intervals statistics.** $D_Q(X)$ is a running maximum —
  monotone, upward-biased, and its fluctuations are not averaged out by
  the fit; the exponent estimates inherit step-structure (visible as the
  $1.03$–$1.06$ bump at $X\approx10^5$ in the $D/\sqrt X$ table).
- **Floor coefficient $c(Q)$** is read at $X=10^4$ where the zero layer
  pollutes at $\pm0.1$; the Mertens law is verified to $\pm0.01$ only
  because the pollution is common-mode across $Q$ (same $X$, same layer to
  leading order). ~~The $c_0=-2.05$ split into $-\log2\pi-0.21$ is
  *unverified attribution* beyond the $-\log2\pi$ term's existence in the
  explicit formula.~~ **(Caveat discharged 2026-08-13,
  `PROVABLE_MEASUREMENTS_TRIAGE_20260813.md` §3: the split is derived, not
  attributed — $-\log2\pi$ from the pole×constant cross term, unconditionally,
  and $-\tfrac14$ from the Friedlander–Goldston average against the Cesàro
  weight, conditional on (BK$_S$) alone. The one caveat that remains is the
  $\pm0.1$ pollution above, which is what the $+0.04$ residual offset sits
  inside.)**
- **Band-pass methodology:** corr/ratio are computed on the core 3/4 of
  the log-grid after cubic detrend; the log-grid has integer-rounding
  jitter $<10^{-3}$ treated as uniform for the FFT. exp11's band-edge
  robustness sweeps (documented in `CROSSREVIEW_BLOCKS.md`) cover the
  methodology's stability; we did not re-run edge sweeps here.
- **Model truncation:** 5000 zeros; the $\gamma^{-3}$ weights make the
  tail $<10^{-9}$ of $A$ — immaterial.
- **Bohr family** is measured as single residue classes (max over $a$,
  intervals $I$); unions of classes (which a "level-$\le q$" Bohr family
  would include) are not tested.
- **FFT arithmetic** validated at $4.5\times10^{-9}$ relative (flat-route
  vs direct difference, $N=10^6$); the flat-route conditioning argument is
  why we trust $10^{-3}$-level statements about LHS at $X=10^4$ where the
  direct difference would lose them.
