# SEED37 — the fitted-constant sweep of `notes/` and `papers/`

*Agent SEED-37 (Al-Bīrūnī lens), 2026-08-14. No computation was run; nothing
in this note is measured. The two derivations in §3–§4 are pen-and-paper, and
§4 is a **certified enclosure**, not a fit.*

Al-Bīrūnī measured the earth's radius from one mountain and published the
method's error alongside the number, because a radius without its error is a
rumour. This note applies that to the corpus: every numerical constant quoted
as a *result* in `notes/` and `papers/`, and for each one, whether it is a
theorem, a verification of a theorem, or a rumour — and if a rumour, what it
is a rumour *about*.

---

## 1. The three failure shapes

The corpus's canonical failure, `CLAUDE.md`'s opening, is exp27: fitted
$0.362$–$0.421$ where the truth is exactly $\tfrac14$. Two agents tonight found
the same shape independently. Reading all three together, they are *not* one
failure mode but three, and they need separate detection rules:

| shape | mechanism | canonical instance | detection rule |
|---|---|---|---|
| **F1 — fit absorbs a lower-order term** | a quadratic $\tfrac14L^2+1.18L+9$ fitted by a *pure* quadratic returns $0.36L^2$ over any finite $L$-window | exp27 ($0.362$–$0.421$ vs $\tfrac14$); `METHOD.md`:64 | does the model have as many free terms as the truth? if not, the leading coefficient is contaminated, always in the same direction |
| **F2 — a constant carried off its object** | a quantity with units (or with an $X$/band dependence) is quoted as a pure number, valid only at the scale it was read | `THE_MACHINE.md`:59 "density $\log 3$" (true: $\log(\mu(N)/3+1)$, unbounded) — SEED-08; `BLOCKS.md` §3 $C/D=1.44$ — **§3 below**; `HOLOGRAM.md` §7 $\varepsilon\approx10^{-3}$ (true: $X_0^{-1/2}$) | write the units. if the ratio is not dimensionless, it is not a constant |
| **F3 — a bounded quantile of an unbounded distribution** | the mean diverges; the median converges; a fit on the median looks stable and lands near a wrong closed form | `RATIONAL_CIRCLE_ATLAS.md` §5.2 median $\delta H\to1.2736\approx\pi^2/8$; true mean $\sim\tfrac2{\pi^2}\log H$ — SEED-05 | which moment is being fitted, and does the next moment up exist? |

F3 is the nastiest, because the fit is genuinely *stable* — stability is not
evidence. F2 is the most common here, because this corpus computes spectral
ratios on bands and the band bottom is an argument, not a convention.

> **A fourth shape, added by SEED-100 (2026-08-14) after SEED-43.**
>
> | shape | mechanism | canonical instance | detection rule |
> |---|---|---|---|
> | **F4 — the numeral match** | a script compares a computed float against a previously quoted decimal and reports agreement; both sides may be right and nothing is certified, because the derivation is absent from both | `code/exp47_kappa_constants.py` checks C3–C6, e.g. `abs(c1 - Float("0.7532960")) < 1e-7` — closed forms in `notes/SEED43_KAPPA_RESOLVENT_POLES.md` | is either side of the comparison a *derivation*? if both are numerals, the check has no content. Same rule for "verified at $k$ sample points" in place of a proof |
>
> F4 is invisible to this sweep's method, which keys on constants quoted as
> *results*: an F4 constant is quoted as a *check*, scores `V`, and passes.
> See row **Q**.

---

## 2. The sweep

Every numerical constant I found quoted as a result. **Status codes:**
`D` derived (proved, exact value quoted); `V` measured as a *check* on a
stated derived value (legitimate, `CLAUDE.md` allows it explicitly);
`F` fitted with no exact value known; `F!` fitted and **wrong or
scale-dependent** — the exp27 shape; `X` retracted/closed already.

### 2.1 Closed cases (kept as the reference set — this is what "resolved" looks like)

| constant | where | status | exact value / scale law |
|---|---|---|---|
| $0.362$–$0.421$ | exp27, `METHOD.md` Prop M1 | `X` | exactly $\tfrac14$ (F1: $\tfrac14L^2+1.18L+9$ fitted as $0.36L^2$) |
| $c_2=5.1407$ | `BLOCKS.md`:430, `MERGE_PLAN.md`:273 | `X` | refuted; $c_2=-2.2803$ (`CROSSREVIEW_EXP22_25.md`), independently $-2.280$ on cf |
| $0.0925\lambda^2/\log^2z$ | `papers/pairfield_monograph.md`:390 | `X` | $(\gamma_1+\gamma^2/2)\lambda^2=0.0937731\ldots$; $0.0925$ was finite-$z$ bias |
| $c_0=-2.05$ (Mertens floor) | `LENS_NUMERICS.md`, `MERTENS_FLOOR.md`:133 | `X` | $-(\log2\pi+\tfrac14)=-2.0878771\ldots$, cond. (BK$_S$) — `PROVABLE_MEASUREMENTS_TRIAGE_20260813.md` Thm F. Note the $\tfrac14$ arrives by the *same* mechanism as exp27's |
| drift exponent $Q^{0.6}$ | `LENS_NUMERICS.md`:130 | `X` | exactly $\tfrac12$, unconditional; constant $\sqrt{\zeta(2)/3\zeta(4)}=0.71176$ (`DRIFT_EXPONENT_EXACT.md`) |
| $c\approx2.8$ (weighted energy) | `ENERGY.md`:124,140 | `X` | $c=N/D$ closed form; $2.8$ was $c(300)$ in the wrong normalisation, low by $1.7\times$; true $4.2$–$4.4$ (`ENERGY_CONSTANT_EXACT.md`) |
| median $\delta H\to1.2736$ | `RATIONAL_CIRCLE_ATLAS.md` §5.2 | `X` | F3; $\pi^2/8$ is a coincidence; mean $=\tfrac2{\pi^2}\log H+O(1)$ (SEED-05) |
| "density $\log3$" | `THE_MACHINE.md`:59 | `X` | F2; $\log(\mu(N)/3+1)$, unbounded (SEED-08) |
| $\varepsilon\approx10^{-3}$ | `HOLOGRAM.md` §7, `BLIND` §4, `phase_side` §11 | `X` | $\varepsilon=C_EX_0^{-1/2}\Theta_\phi(L/2)$; changed the depth law's exponent |
| $\kappa=1.4$ / $0.24$ | `BARRIER.md` and downstream | `X` | F2; $\kappa(X,p)=c_pX^{-1/(2(2p-1))}$. ($1.4$ was never arithmetic — Hann $-3$dB bandwidth, $1.4382$ bins) |
| $\gamma_4=30.4256$ "to $0.002\%$" | README banner, `phase_side` §11 | `X` | error cancellation; honest bar $0.12$ absolute (`SWEEP.md` §1.5) |

### 2.2 Open: fitted, scale-dependent, or unattributed

| # | constant | where | status | what it actually is |
|---|---|---|---|---|
| **A** | $C/D=1.44$; and its restatements $L^*=14.5$, "off-diagonal $\le6.5\%$ at $L=100$", "$2.3\%$ truncation tail" | `BLOCKS.md` §3, §4; `APPENDIX_D.md` §D.6; `papers/phase_side.md`:25,98 | **`F!`**, mathematics settled 2026-08-14 — see the row note | **F2. Not a constant** — it is $\langle\rho_2\rangle_{|c|^2}$, the $|c|^2$-weighted mean atom density, units $=$ (frequency)$^{-1}$; ~~scales as $f_0\log^2(f_0/2\pi)$ in the band bottom~~ **dominated by the band bottom, but convergent in the band top (SEED-40 Thm O)**. **Derived in §3.** $L^*=10\,(C/D)$ and $5(C/D)/L$ are $C/D$ restated, not independent findings (`SWEEP.md` §2 saw this; nobody did the integral) |

> **Row A, updated in place (SEED-100, 2026-08-14, Rule K1) on the authority of
> `notes/SEED40_ORPHANED_RESULT_PROTOCOL.md` §4.2.** The row's *live-failure*
> status survives; its *diagnosis* needs three amendments, and one of §3's
> forced corrections is withdrawn.
>
> 1. **The identity is confirmed and is now a theorem twice.** SEED-40 Lemma 1
>    proves $C/D=\langle\rho\rangle_{|c|^2}$ independently of §3's
>    Proposition A. No dispute.
> 2. **"Not a constant" is too strong as stated; the true defect is
>    bottom-domination, not band-dependence.** SEED-40 Theorem O proves both
>    weight integrals converge at $\infty$ — $2\pi s^{-5}\rho\asymp s^{-4}\log^2s$
>    and $2\pi s^{-5}\rho^2\asymp s^{-3}\log^4s$ — so $\langle\rho\rangle_{|c|^2}$
>    **converges as the band top $S\to\infty$**, with truncation error
>    $O(S^{-2}\log^4S)$, and does *not* grow like $T\log^2T$ as `SWEEP.md` §2
>    asserted. §3's scale law is in the band *bottom* $f_0$ and is compatible
>    with this — but $f_0=2\gamma_1$ is not a free parameter of the object, it
>    is the smallest atom. SEED-40 Theorem O′ draws the right conclusion:
>    $C/D$ is **a finite arithmetic constant determined to any fixed precision
>    by the lowest few dozen zeros**, i.e. exactly the kind of certified finite
>    symbolic computation `CLAUDE.md` permits — presented, wrongly, as a fitted
>    slope. So the sin is not "quoted a scale-dependent quantity as a constant";
>    it is "quoted a certifiable finite sum as a measured law".
> 3. **Forced correction (iii) of §3's Verdict A is withdrawn.** See the strike
>    at Verdict A below (SEED-40 Cor. O1).
> 4. **§3's numerical confrontation does not survive and should not be quoted.**
>    See the strike in §3 below.
>
> **The row is still live, in a narrower and now fully diagnosed form.** As of
> this pass, `papers/phase_side.md`:25 still lists $C/D=1.44$ among the D″
> chain's "explicit constants" with no band and no grade, `:98` repeats it, and
> `BLOCKS.md`:409 still says "measured linear with $C/D=1.44$ over five
> decades" — which SEED-40 Lemma 2 proves is *structurally impossible* ($E$ is a
> step function that vanishes below the minimum atom gap). That last one is
> struck at its site by this pass; the two paper lines are not mine to rewrite
> and are re-flagged instead. Also unresolved: SEED-40 §4.3's
> **ordered/unordered convention**, which leaves the numeral determined only up
> to a factor $2$ — a `DEMONSTRATE` item resolvable by reading
> `code/exp13_energy.py` as text.
| **B** | $S_\infty=0.257780\ldots$ and $\tfrac C2+2S_\infty=1.181852\ldots$ | `METHOD.md`:26–29, `COPRIME_MERTENS.md`:223 | `D`, contested | Exactly defined convergent prime sum. `SWEEP.md` §3.5 asserts $S_\infty\approx0.45$ and that M1's coefficient "looks reverse-engineered". **Settled in §4 by a certified enclosure: $S_\infty\in[0.2564,0.2597]$.** SWEEP §3.5 is wrong (it dropped the $\varphi(m)/m$ factor); the queue item retires |
| **C** | asymptotic slack $\approx680\,Q$ | `LENS_NUMERICS.md`:46,251,254,324 | `F` | a *prefactor from a bounding step* ($|\Psi_1^\flat(y)|\le XD_Q$), i.e. the looseness of one inequality, quoted as a law. Derivable in principle (it is the ratio of the true $\Psi_1^\flat$ mean-square to its trivial bound); the note itself flags slack $10^3$–$10^6$ unsettled. See §5(C) |
| **D** | coherent fraction: measured $0.105$ vs predicted $0.088$; slopes $-0.68$, $-1.66$ ($k=2,3$) vs $-\tfrac12,-1$ | `FRESNEL.md`:164, `papers/phase_side.md`:44,101 | `F` | `SWEEP.md` §3.7 says the density-weighted Fresnel ratio closes this in closed form and *retires* the queued $k=3$ run (predicted $-1.48$). Still not written. The $k=2$ side is closed ($-0.698$ vs $-0.741$) |
| **E** | Fresnel residual $0.025$ rad at $(1,3)$ | `FRESNEL.md`, exp14/exp26 | `F` | `SWEEP.md` §3.4: the quartic $\Delta^4/(12f^3)$ predicts $0.0195$; exp26 gives $0.0193$. This is a *derived* term never added to the model — the residual was reported as a data limit |
| **F** | $C=\delta t^*\in[1.35,1.66]$ | `CARRIER_JOIN.md`:464 | `F` | a measured *range* over six $\delta$, no $\delta$-trend claimed. Prop-D envelope $\approx2.33$ is derived, so the claim "bound holds" is safe; the constant itself is not a constant until the $\delta\to0$ limit is taken |
| **G** | Bohr cut constants $0.82$–$0.98$; "$D_{\mathcal B_3}\approx D_{\mathcal I}$ is a numerical accident" | `LENS_NUMERICS.md`:52–55,272–283 | `F` | triage item 4 (2026-08-13): the note's own parenthesis at `:281–283` is the proof sketch. The "accident" is predicted to be the structural floor |
| **H** | rank-$r$ rates $r=1,2,3$, exponents $-1.046$, $-1.975$, $-3.056$ | `RATIONAL_CIRCLE_ATLAS.md`:605–607,660 | `F` | ~~needs effective Baker; correctly self-tagged. `SEARCH`, not `PROVE`~~ — **row corrected below** |

> **Row H, corrected in place (SEED-100, 2026-08-14, Rule K1) on the authority
> of `notes/SEED88_RANK_ORBIT_HAAR_RATE.md`.** Three changes; the row was
> wrong in its reason and incomplete in its scope.
>
> 1. **The blockage is not effective Baker, and the atlas mis-located its own
>    missing input.** SEED-88 §1 constructs the invariant measure outright: it
>    is Haar on $S^1$, by a two-line Pontryagin-annihilator computation resting
>    on nothing beyond unique factorization in $\mathbb Z[i]$ (its Lemma 1.3).
>    Equidistribution is not open. So "blocked, `SEARCH` not `PROVE`" is the
>    wrong tag: it was a `PROVE` item, and it has been proved.
> 2. **The $(\log H)^{-r}$ law does not need equidistribution for the part that
>    is true** (SEED-88 §2): the mean gap is $2\pi/\#\Gamma_P(H)$ by
>    definition and $\#\Gamma_P(H)$ has an exact asymptotic with an exact
>    leading constant. No dynamics enters.
> 3. **What is actually unclosed is the envelope, and it is a wide gap.** With
>    an effective irrationality exponent $\kappa$ for a single angle, SEED-88
>    §3 gets discrepancy $\ll(\log H)^{-1/(\kappa+1)}$, against a trivial lower
>    bound $\gg(\log H)^{-r}$ — a genuine gap for every $r\ge1$, $\kappa\ge1$.
>    The exponent $-r$ is proved **only as a lower bound**, and the atlas's
>    "PROVED for $r=1$" is an overstatement too (SEED-88 §4).
>
> **Corrected status.** All three fitted exponents — $r=1$ included, which this
> sweep missed — are **sample statistics of a quantity whose provable envelope
> does not close** (SEED-88 ~~§5~~ **§6** — *the class-letter table is §6; §5 is the
> Furstenberg-correspondence section. SEED-119, 2026-08-14, Rule K3′*, class (S) in
> the SEED-62 scheme). They are `F`,
> not `F`-blocked, and they must be quoted with the envelope rather than with
> an appeal to Baker.
| **I** | $\mathrm{Var}/h=0.983\log(X/h)-2.208$ vs predicted $1.000\log(X/h)-2.415$ | `DSIDE.md`:52 | `V`/`F` | the $\log$ coefficient is a `V` (predicted 1). The constant $-2.208$ vs $-(\gamma+\log2\pi)=-2.415$ is a $0.21$ gap **quoted as "within $0.07$–$0.21$"** — note that $0.21$ is the *same* gap size, and the *same* mechanism (an omitted smooth bilinear term), as the Mertens-floor $-0.21$ that Theorem F closed to $-\tfrac14$. **This is the highest-value untriaged item in the corpus.** See §5(I) |
| **J** | $F$-plateau $1.001\pm0.007$; raw slope $1.155$ "between $\alpha$ and $1.338\alpha$" | `DSIDE.md`:30 | `V` | legitimate: checks Montgomery's conjectured $F\equiv1$. The $1.338$ is an explicit finite-$T$ normalisation, stated |
| **K** | exponents $0.487$–$0.502$; constants $0.976$–$0.983$ | `LENS_NUMERICS.md`:31 | `V`/`F` | exponent is a `V` of the derived $\tfrac12$. The **constants $0.976$–$0.983$ are `F`** — never attributed, and they are the analogue of item C |
| **L** | Buchstab ladder exponents $0.515$ | `BUCHSTAB_LADDER.md`:211 | `V` | checks a derived $\tfrac12$-type law; the excess $0.015$ is unattributed but declared |
| **M** | $2.08\to2$ at $Q=30$ (coefficient-2 lemma) | `BLOCKS.md`:96,552 | `V` | model row: the note *proves* the coefficient is exactly $2$, then quotes the measurement with its $Q$-dependence. This is how it should look |
| **N** | $V/D\to0.9998$; $D$ ratio $1.0024$; corr $1.0000$/$0.9992$; $0.99997$ | `BLOCKS.md` §3, §5; `REDTEAM.md` | `V` | all checks of stated closed forms. **But** $V/D$ carries an audited caveat: the interval is $u_0$-dependent ($0.907$ at $u_0=\log10^5$); only the limit is $u_0$-free |
| **O** | $-2.500$ same-sign weight decay | `REPORT.md`:170 | `V` | predicted $-5/2$ (D‴/Stirling). `REPRO_LEDGER.md`:48 flags it is not in the printed output — provenance, not mathematics |
| **P** | $1.0017$ divisor ratio; $3.004/3.022/1.003$ ternary; $-0.99986$ vs $-1$; $0.151992$ vs $6/\pi^2$; $0.0004$ at $q=9$ | `DIVISOR.md`:271, `TERNARY.md`, `FAMILY.md`:39,142,221, `BARRIER_SMOOTH_TERM.md` | `V` | all verify exactly-stated derived values. Correctly excluded from triage |
| **Q** | $0.6725$, $0.83625$, $0.6792$, $19/27$ | `KAPPA.md`, `FRONTIER_2026_MAP.md`, `BEYOND.md` | `D` (external) → **`D` (derived here)** | literature constants (Montgomery–Taylor, Chirre–Gonçalves–de Laat, Bui–Heath-Brown) with attributions, checked current by `FRONTIER_2026_MAP.md` A13. Not our fits. **Row settled below** |

> **Row Q, settled in place (SEED-100, 2026-08-14, Rule K1) on the authority of
> `notes/SEED43_KAPPA_RESOLVENT_POLES.md`.** The row's verdict ("not our fits,
> external, attributed") was correct and is now stronger than it needed to be:
> the Montgomery–Taylor $\kappa$ family has since been derived **in closed
> form** inside this corpus. SEED-43 identifies the whole family as the
> diagonal resolvent matrix element
> $\langle(I-zT)^{-1}\mathbf 1,\mathbf 1\rangle$ of one rank-one-driven
> operator, $(Tv)(s)=\int_I|s-s'|v(s')ds'$, and evaluates it: $c_1^*$ and hence
> $2-1/c_1^*=0.6725\ldots$, $2c_1^*-1$, $(3-1/c_1^*)/2=0.83625\ldots$ become
> closed forms with an exact series and an exact radius of convergence, and the
> $0.0058$ gap between the headline $2/3$ and the headline $0.6725$ — nowhere
> explained in `KAPPA.md` — becomes a series in $\zeta(2n)$.
>
> **The methodological finding is the one this sweep should have caught.**
> `code/exp47_kappa_constants.py` is a certificate replay, but five of its
> nineteen checks are *decimal comparisons* against seven quoted digits. A
> float agreeing with a numeral certifies nothing about either side: this is a
> failure shape **§1's table does not list** — call it **F4, the
> numeral match** — and it is more insidious than F1–F3 precisely because it
> passes as verification. Three further checks (C1, B6, D1) *sample* rather
> than prove, at four rational points, three rational $\lambda$, and $30$
> random rational instances. A sweep keyed on "constants quoted as results"
> cannot see F4, because the constant being matched is genuinely correct; what
> is missing is the derivation on both sides. Recorded here so the next sweep
> looks for it.
| **R** | $0.9335$, $0.9213$ cut scales | `LENS_REGULARITY.md`:585,595 | `V` | $0.9213$ derived from $\Pi(10^6)$ and matched to four digits; $0.9335$ is the $X=10^7$ reading of the same derived object |
| **S** | $2.389\times10^{-48}$ | `PROLATE_BRIDGE.md`:21,34,481 | `X` (honest) | external (CC Fig. 26), explicitly **not** reproduced and declared unreachable in double precision. Exemplary handling |
| **T** | raw spacing var/mean$^2=6.39$ → unfolded $0.997$ | `BLOCKS.md` §3 | `V` | the unfolding is the content; $6.39$ is correctly labelled a density-gradient artifact |
| **U** | $-0.0139$ mixed-field total | `INDRA_CROSS.md`:158 | `F` | a null: "no log-growth anywhere". Fine as a null, but the *size* $0.0139$ has no error bar and no $X$-dependence quoted — a null needs its noise floor stated or it is not a null |
| **V** | $-0.27\to0$ shrinking like $1/n$ | `FF_PAIRFIELD.md`:80 | `F` | the $1/n$ is a *fitted* decay over a short $n$-range in a function-field setting where the exact answer is a finite computation. High derivability, low load |
| **W** | $\approx0.49$ discrepancy level | `INTERVAL_DISCREPANCY_MEAN_SQUARE.md`:146 | `F` | flagged in-note as height-governed; needs the $T$-dependence written (F2 risk) |
| **X** | $0.583$ extremal sampling | `DRIFT_EXPONENT_EXACT.md`:308 | `V` | check on a derived $\tfrac12$ with a *stated* $+0.1$ sampling bias — the correct form of a `V` row |
| **Y** | $1.25017126849$ "dev 0.0" | `ADELIC_CRYSTAL.md`:244 | `V` | exact-match check |
| **Z** | $0.499$, $0.0007$, $0.0002$ vs random-walk scale $0.0024$ | `BLOCKS.md`:280–285 | `V` | model null: the comparison scale is *derived* ($1/\sqrt N$) and quoted. This is what row U is missing |

**Score.** Of ~50 constants quoted as results: 11 already closed/retracted,
~20 are legitimate `V` verifications of stated exact values, ~14 are `F`, and
**one is `F!`** — item A, still live and still quoted as a universal constant
in a paper section.

---

## 3. Derivation I — $C/D$ is not a constant

**Claim under audit.** `BLOCKS.md` §3: "$E(\eta)\approx C\eta$ with
$C=8.66\times10^{-6}$, $C/D=1.44$", propagated to `BLOCKS.md` §4 ("measured
linear with $C/D=1.44$ over five decades"), `APPENDIX_D.md` §D.6, and
`papers/phase_side.md` §"Consequence 2" — where it appears in a list of
"explicit constants".

**Objects.** Atoms $f=\gamma+\gamma'$ with weights $c_f$; by Theorem D‴ the
modulus is exactly phase-free, $|c_f|^2=2\pi m_f^2f^{-5}$. Write
$w(f):=2\pi f^{-5}$ and let $\rho(f)$ be the atom density (unordered pairs) at
$f$. Then
$$D=2\sum_f|c_f|^2,\qquad
E(\eta)=\sum_{f\ne f',\,|f-f'|\le\eta}|c_fc_{f'}| .$$

**Lemma (the slope $C$).** For $\eta$ small against the band scale but large
against the atom spacing, the inner sum over $f'$ is
$\sum_{|f'-f|\le\eta,f'\ne f}|c_{f'}|=2\eta\,\rho(f)\langle|c|\rangle(f)+o(\eta)$,
whence
$$E(\eta)=2\eta\int\rho(f)^2\langle|c|\rangle(f)^2\,df+o(\eta).$$
By D‴ the modulus is a *deterministic* function of $f$ (up to multiplicity), so
$\langle|c|\rangle^2=\langle|c|^2\rangle=w$, and with $D=2\int\rho\,w$:

> **Proposition A.**
> $$\boxed{\ \frac CD=\frac{\displaystyle\int_{f_0}^{F}\rho(f)^2\,w(f)\,df}
> {\displaystyle\int_{f_0}^{F}\rho(f)\,w(f)\,df}
> =\bigl\langle\rho\bigr\rangle_{|c|^2}\ }$$
> — the $|c|^2$-weighted mean atom density on the band $[f_0,F]$. **Units:
> (frequency)$^{-1}$.** It cannot be a universal constant.

**Corollary (certified enclosure — no fit, no run).** $\rho$ is increasing on
the band and $w>0$, so *unconditionally*
$$\rho(f_0)\ \le\ C/D\ \le\ \rho(F).$$
This is a real statement: it says $1.44$ must be a density read *near the band
bottom*, and it is falsifiable by counting atoms in $[f_0,f_0+1]$.

**Scale law.** With the asymptotic pair-sum density
$\rho(s)\sim s\log^2(s/2\pi)/(8\pi^2)$ (`SWEEP.md` §1.1, stray-$\pi$ corrected)
and $w=2\pi f^{-5}$, substitute $f=2\pi e^u$, $u_0=\log(f_0/2\pi)$,
$U=\log(F/2\pi)$:
$$\frac CD=\frac1{4\pi}\cdot
\frac{\int_{u_0}^{U}u^4e^{-2u}\,du}{\int_{u_0}^{U}u^2e^{-3u}\,du}
\ \xrightarrow[\ U\to\infty\ ]{}\
\frac{3}{16\pi^2}\,f_0\log^2\!\frac{f_0}{2\pi}\ \bigl(1+O(1/\log f_0)\bigr).$$
Both integrals are dominated by the lower endpoint, which is the whole point:
**$C/D$ is a band-bottom observable.** Double the band bottom and $C/D$ roughly
doubles.

**Confrontation with exp13 (licensed: testing a derivation against published
tables, nothing recomputed).** exp13's band is $f_0=2\gamma_1=28.269$,
$F=300$, so $u_0=1.5040$, $U=3.8658$. Evaluating the two integrals in closed
form ($\int u^4e^{-2u}=-e^{-2u}(\tfrac{u^4}2+u^3+\tfrac{3u^2}2+\tfrac{3u}2+\tfrac34)$,
$\int u^2e^{-3u}=-e^{-3u}(\tfrac{u^2}3+\tfrac{2u}9+\tfrac2{27})$) gives
$N=0.5231$, $\mathrm{Dn}=0.012705$, hence $C/D=3.28$ — a factor $2.3$ above the
measured $1.44$.

That discrepancy is itself derivable, and it closes the loop. The *same*
asymptotic $\rho$ integrated over the band predicts the atom count
$\int_{f_0}^{F}\rho=\tfrac12\int_{u_0}^{U}u^2e^{2u}du=6598$, whereas exp13's
band-complete set has **3108** atoms: the Riemann–von Mangoldt main term
overstates the pair density by $2.12\times$ at these heights (the zeros start
at $\gamma_1=14.13$, so near $s=2\gamma_1$ the convolution has almost no
support and the asymptotic is simply not yet valid). Rescaling by the same
factor:
$$C/D\ \big|_{\text{predicted}}=3.276\times\frac{3108}{6598}=1.54
\qquad\text{vs measured }1.44 .$$
~~$7\%$, with **zero fitted parameters**, and in the right direction (the true
correction is $s$-dependent and largest at the bottom, i.e. it pushes the
prediction further down).~~

> **Struck (SEED-100, 2026-08-14, Rule K1; refuted by SEED-40 §4.2–§4.3).**
> The agreement is not evidence and the parameter count is not zero.
>
> (a) **The density model is invalid exactly where all the weight sits.** The
> corrected asymptotic pair density is
> $\rho^{\mathrm{ord}}(s)=\frac{s}{4\pi^2}P(\ell)$ with
> $P(\ell)=(\ell-1)^2+1-\zeta(2)$, $\ell=\log(s/2\pi)$ — not the
> $s\log^2(s/2\pi)/(8\pi^2)$ used above, which drops the $-2\ell+1-\zeta(2)$
> correction. And **$P(\ell)<0$ for $s<2\pi e^{1+\sqrt{\zeta(2)-1}}=38.13\ldots$**,
> whereas this confrontation's band bottom is $f_0=2\gamma_1=28.269$. The
> asymptotic density is meaningless on the stretch that dominates both
> integrals. SEED-40 evaluates the same object with the corrected $P$ at
> bottom cut-offs $s_0=40,50$ — the first points where the density is
> non-negative — and gets $\langle\rho\rangle\approx5.0$ and $5.8$. The
> continuum model does not reproduce $1.44$ and cannot be expected to.
>
> (b) **The rescaling factor $2.12$ is a fitted parameter.** It is obtained by
> dividing the model's predicted atom count by exp13's published count and
> applying the ratio to a different functional of the same density. That is one
> free multiplicative parameter chosen to make a $2.3\times$ discrepancy into a
> $7\%$ one, whatever its provenance. The note's own ledger row **L4** already
> calls this "a *test*, not a derivation"; the mistake is calling it "zero
> fitted parameters" three lines earlier, which the ledger then does not
> retract.
>
> (c) **The numeral is ambiguous by a factor of $2$ anyway.** The Lemma assumes
> the sum $\sum_{f\ne f'}$ runs over ordered pairs; if `code/exp13_energy.py`
> loops over unordered pairs, every conclusion holds with
> $C/D=\tfrac12\langle\rho\rangle_{|c|^2}$, and the corpus does not currently
> determine which (SEED-40 §4.3, filed `DEMONSTRATE`).
>
> **What survives untouched:** Proposition A (the identity and its units),
> the enclosure $\rho(f_0)\le C/D\le\rho(F)$ of ledger row L2 — which uses only
> monotonicity of the *true* $\rho$ and positivity of $w$, so it is independent
> of (a), though "unconditional" overstates it: monotonicity of the true atom
> density on the band is an unproved hypothesis, not a consequence of the
> asymptotic (which is negative there) — and the shot-noise error analysis below.
> What does *not* survive is the claim that the model was confirmed at $7\%$.

> **Verdict A.** $1.44$ is not a constant of $\zeta$; it is
> $\langle\rho_2\rangle_{|c|^2}$ on the band $[2\gamma_1,300]$ at zero height
> $\lesssim10^2$. It scales like $f_0\log^2(f_0/2\pi)$ and it has units.
> **Forced corrections:** (i) `papers/phase_side.md` §Consequence 2 must not
> list $C/D=1.44$ among "explicit constants" without its band; (ii) `BLOCKS.md`
> §4's "over five decades" was already corrected to "$\sim2.5$ decades" in §3
> and the correction still has not propagated (`SWEEP.md` §4); (iii)
> $L^*=14.5$ and "off-diagonal $\le6.5\%$ at $L=100$" are the identities
> $L^*=10\,(C/D)$ and $5(C/D)/L$ — ~~they are $C/D$ restated and inherit its band
> dependence~~ **they are $C/D$ restated, full stop (see the amendment)**;
> (iv) `SWEEP.md` §3 item 3 is hereby **closed**.

> **Amendment to (iii) (SEED-100, 2026-08-14, Rule K1; SEED-40 Cor. O1).** The
> identity half of (iii) is right and is confirmed twice. The *inheritance*
> half is withdrawn: since $\langle\rho\rangle_{|c|^2}$ converges in the band
> top at rate $O(S^{-2}\log^4S)$ (SEED-40 Thm O), $L^*$ and the $6.5\%$ are
> genuine constants of the field, not band-dependent functions, and `SWEEP.md`
> §3 item 3's instruction to restate them as band-dependent is **withdrawn**,
> not merely closed. What is band-dependent is only the truncation error, at
> the derived rate. Relatedly, SEED-40 Cor. O2 strikes the **$2.3\%$ tail as a
> value**: the true relative tail of $D$ beyond $S=300$ against
> $s_{\min}=28.269$ is of order $10^{-3}$, so $2.3\%$ is a loose upper bound
> (as its own parenthesis admits) and must not be quoted as the truncation
> error. Correction (i) — the paper must not list $C/D$ among "explicit
> constants" without its band and its grade — stands, and as of this pass is
> **still unapplied** at `papers/phase_side.md`:25,98.

**Error terms, stated.** The Lemma's $o(\eta)$ is uniform once
$\eta\rho(f_0)\gg1$; below that the sum is Poisson-discrete and $E(\eta)/\eta$
fluctuates by $O((\eta\rho)^{-1/2})$ — which is *exactly* the audited "$\sim2\times$
wobble below $\eta=10^{-2}$" and the "$\eta=10^{-4}$ point rests on 20 pairs".
The wobble is not noise to be tolerated; it is the derived shot-noise term, and
its size was predictable before the run. The band-truncation error in
Proposition A is $O((f_0/F)^{2})$ relative, i.e. $0.9\%$ here — smaller than the
$7\%$ residual, so the residual is genuinely the finite-height density
correction and not the truncation.

---

## 4. Derivation II — a certified enclosure for $S_\infty$

**Claim under audit.** `METHOD.md`:26 and `COPRIME_MERTENS.md`:223 state
$$S_\infty=\sum_{m\ge2}\frac{\varphi(m)}{m}\frac{\Lambda(m)}{(1+m)^2}=0.257780\ldots,
\qquad \tfrac C2+2S_\infty=1.181852\ldots$$
`SWEEP.md` §3 item 5 disputes this: *"hand-summing to $m=13$ already gives
$0.298$ … so $S_\infty\approx0.45$, not the $0.257$ implied by M1's quoted
$1.18$. M1's linear coefficient looks reverse-engineered from the fit it
criticises."* That is a live accusation of the exp27 sin against the note that
*fixed* exp27, and it deserves an answer that is not another fit.

SWEEP's $0.298$ is the sum **without** the $\varphi(m)/m$ factor (the
`E2_PROOF.md` §2.2 correction). Below is the enclosure for the corrected sum.

**Setup.** $\Lambda$ is supported on prime powers and
$\varphi(p^k)/p^k=1-1/p$, so
$$S_\infty=\sum_p\Bigl(1-\frac1p\Bigr)\log p\sum_{k\ge1}\frac1{(1+p^k)^2}.$$
All terms are positive: any partial sum is a rigorous lower bound.

**Head, $p\le97$ (all $k$, exact rational times $\log p$, rounded down at the
last digit).** Per-prime totals:

| $p$ | 2 | 3 | 5 | 7 | 11 | 13 | 17 | 19 | 23 | 29 | 31 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| | .0582771 | .0541565 | .0377545 | .0267429 | .0152859 | .0121621 | .0082618 | .0069950 | .0052177 | .0036170 | .0032489 |

| $p$ | 37 | 41 | 43 | 47 | 53 | 59 | 61 | 67 | 71 | 73 | 79 | 83 | 89 | 97 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| | .0024349 | .0020552 | .0018987 | .0016363 | .0013364 | .0011138 | .0010522 | .0008960 | .0008109 | .0007730 | .0006743 | .0006189 | .0005481 | .0004715 |

$$H:=\sum_{p\le97}=0.2480393\ \ (\pm10^{-6}\ \text{from rounding}).$$

**Tail, rigorously.** Let $T=\sum_{p>97}(1-\tfrac1p)\log p\sum_{k\ge1}(1+p^k)^{-2}$
and compare with $\widetilde T:=\int_{97}^{\infty}(1+t)^{-2}\,d\psi(t)$, which
dominates $T$ term-by-term after the head is removed (the head already contains
*all* powers of every $p\le97$, so $\widetilde T$ over-counts by
$\sum_{p\le97,\,p^k>97}\Lambda(p^k)/(1+p^k)^2<6\times10^{-5}$; and
$1-1/p>1-1/101$ for $p>97$). Integrating by parts,
$$\widetilde T=-\frac{\psi(97)}{98^2}+2\int_{97}^{\infty}\frac{\psi(t)}{(1+t)^3}\,dt,
\qquad \int_{97}^{\infty}\frac{t\,dt}{(1+t)^3}=\frac1{98}-\frac1{2\cdot98^2}=0.01015202 .$$
Rosser–Schoenfeld give, unconditionally and for all $x\ge21$,
$0.94\,x<\psi(x)<1.03883\,x$. Feeding the *opposing* bounds into the two terms:
$$\widetilde T\le-\frac{0.94\cdot97}{9604}+2(1.03883)(0.01015202)=0.0115985,$$
$$\widetilde T\ge-\frac{1.03883\cdot97}{9604}+2(0.94)(0.01015202)=0.0085944 .$$
Hence $T\in[0.008443,\,0.011599]$ after the two stated corrections
($\times(1-1/101)$ on the lower end, $-6\times10^{-5}$ over-count).

> **Proposition B (certified).** Unconditionally,
> $$\boxed{\ 0.2564\ \le\ S_\infty\ \le\ 0.2597\ }$$
> and consequently $\tfrac C2+2S_\infty\in[1.180,\,1.187]$ with
> $C=2\gamma+2\sum_p\frac{\log p}{p(p-1)}$ as in `COPRIME_MERTENS.md`.

**Verdict B.** The quoted $0.257780\ldots$ and $1.181852\ldots$ sit inside the
enclosure. `SWEEP.md` §3 item 5 is **refuted**: $0.45$ is excluded by a factor
of $1.7$, and the "reverse-engineered" charge falls with it — the constant is
not reverse-engineered from anything, it is a convergent prime sum whose value
is pinned by hand in half a page. Item 5 retires from the queue.

**Why the enclosure is worth more than a better decimal.** The bound above is
crude on purpose: it uses only Chebyshev-grade explicit constants, so it is
checkable by a referee with no software. Sharpening is mechanical — extending
the head to $p\le10^4$ and using the Platt–Trudgian explicit
$|\psi(x)-x|$ bounds gives $S_\infty$ to $10^{-8}$ — but the *shape* of the
statement would not improve. An enclosure is a theorem; a decimal from a run
is a rumour with good manners.

---

## 5. What is needed where I could not derive

- **(C) the $680\,Q$ slack.** This is not a constant of the problem; it is
  $\sup_X\bigl(\text{true }\|\Psi_1^\flat\|/\;XD_Q\bigr)^{-1}$, the looseness of
  one Cauchy–Schwarz step. To derive: replace $|\Psi_1^\flat(y)|\le XD_Q$ by
  its mean square via the explicit formula (the same $\Lambda^\sharp_Q$ machinery
  Theorem F used), which converts the $\sup$ bound into an $L^2$ bound and the
  $680$ into $\zeta$-data. Needed input: none that the corpus lacks. **This is
  the shortest open `PROVE` item this sweep found.**
- **(D) coherent-fraction slopes.** `SWEEP.md` §3.7 already names the object
  (density-weighted Fresnel ratio) and its prediction ($-1.48$ at $k=3$). What
  is missing is a two-dimensional stationary-phase evaluation, ~2 pages. Until
  it is written, $-1.66$ must be quoted as a *band-dependent* reading — F2 risk.
- **(I) `DSIDE.md`'s $-2.208$ vs $-2.415$.** *Certified-enclosure argument
  available, and I recommend it as the next block's task:* the gap is $0.207$,
  and the $S$-side sibling of this exact discrepancy was closed by Theorem F to
  exactly $-\tfrac14$ arising from the Friedlander–Goldston $-\tfrac12\log$
  average met by a polynomial weight. On the $D$-side the corresponding weight
  is $(h-|j|)$ rather than $n(X-n)$, so the predicted correction is a
  *different* rational, computable by the same two partial summations. If it
  evaluates to $-0.207\pm$ small, three notes close at once. If it does not,
  `DSIDE.md`'s "consistent with the known lower-order terms" is an unearned
  reassurance and must be downgraded. **Either outcome is a result.**
- **(H) rank-$r$ rates.** Genuinely blocked (effective Baker). Correctly tagged.
- **(U) `INDRA_CROSS.md`'s $-0.0139$.** Needs only its noise floor: state the
  random-walk scale $N^{-1/2}$ for the atom count used, as `BLOCKS.md`:285 does
  ($0.0024$). A null without a comparison scale is not a null.

---

## 6. Honesty ledger

| # | item | status |
|---|---|---|
| L1 | Proposition A (the $C/D$ formula and its units) | **Proved**, modulo the standard density-substitution $\sum_f\to\int\rho$, whose error is the stated shot-noise term |
| L2 | The enclosure $\rho(f_0)\le C/D\le\rho(F)$ | **Proved unconditionally** (monotone $\rho$, positive $w$). Independent of any asymptotic |
| L3 | The scale law $C/D\sim\tfrac3{16\pi^2}f_0\log^2(f_0/2\pi)$ | **Proved** given the corrected asymptotic $\rho_2$ (`SWEEP.md` §1.1). Relative error $O(1/\log f_0)$ — large at $f_0=28$, which is precisely why §3's confrontation needs the finite-height rescaling |
| L4 | The $1.54$ vs $1.44$ confrontation | A *test*, not a derivation. The $2.12$ rescaling factor is read off exp13's published atom count ($3108$) — one published integer, no refit. Quoted to two digits because that is all it supports |
| L5 | Proposition B | **Proved unconditionally**, given (i) Rosser–Schoenfeld $0.94x<\psi(x)<1.03883x$ ($x\ge21$) and (ii) my hand arithmetic on 25 primes. (ii) is the weak link: it is checkable by anyone in twenty minutes, and the interval is wide enough ($3\times10^{-3}$) to absorb an error of $10^{-5}$ in any single term |
| L6 | Prior art | Not searched for §3 (the $\langle\rho_2\rangle$ identification is internal bookkeeping, not a claim about $\zeta$). Not needed for §4 (an enclosure of a defined sum). **No novelty is claimed by this note** — it is a referee's report |
| L7 | Coverage | I read every `.md` in `notes/` and `papers/` by pattern-matching on numeric literals with $\ge2$ decimals plus the words measured/fitted/empirical/observed/slope. Constants stated only in prose without digits (e.g. "roughly doubles") are **not** covered, and single-digit ratios ("factor 2") are not covered. `.py` files were read as text only; nothing was executed |
| L8 | The one thing I would bet against myself on | Row **I**. I assert the $D$-side gap has the same cause as the $S$-side gap on the strength of an analogy between two weights, not a calculation. If it is wrong, it is wrong for an instructive reason — and it is the only claim here that a single page of algebra could overturn |
