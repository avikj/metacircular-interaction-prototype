# C0_RESOLUTION: the −log 2π vs −2.05 disagreement — claim sites, derivation re-checked, verdict

Filed 2026-08-23. Task: resolve the open disagreement between the prediction
$c_0=-\log2\pi\approx-1.83788$ and the psvg2m-lane measurement
$c_0\approx-2.05$. Finding up front: **the disagreement was already closed
in-corpus on 2026-08-13** (`PROVABLE_MEASUREMENTS_TRIAGE_20260813.md` §3,
Theorem F), and the closure is correct — this note locates every claim
site, re-derives the constant by hand step by step (every step re-checked
independently below, including the integrals), and records the verdict so
the "open disagreement" cannot be reopened by a reader who lands on a stale
claim site. Nothing here is new mathematics; it is an audit of the
resolution, which passes.

**Verdict: RESOLVED.** Correct value
$$c_0=-\Bigl(\log2\pi+\tfrac14\Bigr)=-2.087877066408\ldots$$
The error was on the *prediction* side (`MERTENS_FLOOR.md` §4, echoed in
`collab/messages/0108`), which implicitly set the smooth part of the
bilinear term $\mathrm{Bil}(X)=\int_0^X E(v)E(X-v)\,dv$ to zero; that
smooth part is exactly $-\tfrac{X^2}{4}$ (conditional on (BK$_S$), see
§3.4). The measurement was right: $-2.05$ sits $+0.04$ above the exact
value, inside the experiment's own declared $\pm0.1$ common-mode
zero-layer pollution. The two sides were the **same quantity under the same
normalization** — this is *not* a `DIFFERENT_QUANTITIES` case; no Mertens
constant, Euler–Mascheroni term, or $\log\log X$ absorption separates them.

---

## 1. What $c_0$ is, exactly

**The quantity.** With $R=\Lambda*\Lambda$ (additive convolution) and
$$G_1(X)=\sum_{n\le X}(X-n)\,R(n)=\int_0^X\psi(v)\,\psi(X-v)\,dv$$
(the Cesàro/Riesz-order-1 weighted Goldbach count), and
$\Lambda^\sharp_Q(n)=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}c_q(n)$ the
Ramanujan-truncated major-arc model with
$[\sharp\sharp]_Q(X)=\int_0^X\Psi^\sharp_Q(v)\Psi^\sharp_Q(X-v)\,dv$, the
error $\mathrm{LHS}(X)=G_1(X)-[\sharp\sharp]_Q(X)$ has (below the
zero-layer crossover $X^*\sim10^6$) a smooth $X^2$-scale floor with
coefficient $c(Q)$. exp32 (`LENS_NUMERICS.md`) measured, at
$Q\in\{1,10,30,100,300\}$, floor read at $X=10^4$ with declared
common-mode zero-layer pollution $\pm0.1$, cross-checked against the
pairwise LHS differences at $X=10^7$:
$$c(Q)=c_0+\tfrac12M(Q),\qquad c_0=-2.05\ (\pm0.01),$$
where the $\pm0.01$ is the $Q$-stability of $c(Q)-M(Q)/2$, **not** an
error bar on $c_0$ itself ($c_0$'s own uncertainty is the $\pm0.1$
pollution). $c_0$ is the $Q$-independent part of that floor: the smooth
$X^2$ coefficient of $G_1-[\sharp\sharp]_Q$ after the exact
$-\tfrac12M(Q)$ of the $[\sharp\sharp]_Q$ side is removed.

**The prediction.** `MERTENS_FLOOR.md` §4 derived the $[\sharp\sharp]_Q$
side exactly and predicted $c_0$ from the smooth part of $\psi$ alone
($\psi(x)=x-\log2\pi+\cdots$ heuristically), obtaining
$c_0=-\log2\pi=-1.83788$ — a $0.21$ gap the quoted bars do not cover, filed
as "one of the two sides is wrong."

## 2. Claim sites (verbatim, file:line as of 2026-08-23)

Prediction / disagreement-open sites:

- `notes/MERTENS_FLOOR.md:143` — "$c_0=-\log 2\pi=-1.83788\ldots$ vs
  measured $-2.05\pm0.01$" (boxed; superseded marker at `:145–146`;
  original "one of the two sides is wrong" struck at `:148–149`).
- `collab/messages/0108-cf-transseries-is-the-compilation-target.md:146–152`
  — "One live disagreement, flagged to psvg2m: my derivation predicts
  $c_0 = -\log 2\pi = -1.83788$ against their measured $-2.05\pm0.01$. The
  bar does not cover the gap." (Historical record; stays as filed per
  `PROVABLE_MEASUREMENTS_TRIAGE_20260813.md` §4.6. Mirrored at
  `collab/chronicle/MESSAGES.md:6737`, `collab/chronicle/COMMITS.md:2155`.)

Measurement sites:

- `notes/LENS_NUMERICS.md:216–218` — the floor table
  ($c(Q)-M(Q)/2=-2.04,-2.05,-2.05,-2.05,-2.05$ at the five $Q$) and
  "$c(Q)=c_0+M(Q)/2$ with $c_0=-2.05$, exact to the measurement precision".
- `notes/LENS_NUMERICS.md:236–239` — the (struck) partial split
  "$c_0=-2.05$ … $-\log2\pi=-1.84$ is the pole×constant term … the
  residual $-0.21$ is unattributed".
- `notes/EXP_LEDGER.md:161` (exp32 row), `notes/INDEX_IA.md:62` (open
  interface 1), `notes/MERTENS_FLOOR.md:6`.

Resolution sites (2026-08-13, all cross-consistent):

- `notes/PROVABLE_MEASUREMENTS_TRIAGE_20260813.md:64–229` — §3, Theorem F
  (the derivation audited below); §3.6 the confrontation table; boxed
  result at `:176–177`.
- `notes/MERTENS_FLOOR.md:171–194` (Correction), `:203–204` (MF4/MF5
  closed); `notes/LENS_NUMERICS.md:241–251` (Correction), `:381–389`
  (caveat discharged); `notes/INDEX_IA.md:67–74`;
  `notes/SEED37_FITTED_CONSTANT_SWEEP.md:60`.

Line-number drift, so future greps don't miss: the triage note cites
`MERTENS_FLOOR.md:130–134` and SEED37 cites `MERTENS_FLOOR.md:133` for the
boxed prediction; after the 2026-08-14 SEED-147 insertion that text now
sits at `MERTENS_FLOOR.md:143`. Content unchanged.

## 3. The derivation, re-checked by hand (every displayed step recomputed)

All objects as in `PROVABLE_MEASUREMENTS_TRIAGE_20260813.md` §3;
$E(x)=\psi(x)-x$, $a=\tfrac12M(Q)$.

**3.1 Convolution identity.** For summatories $F,G$ of $f,g$:
$\sum_{a,b}f(a)g(b)(X-a-b)_+=\int_0^XF(X-v)G(v)\,dv$, since the measure of
$\{v:b\le v\le X-a\}$ is $(X-a-b)_+$. Exact; checked. Hence the two
integral forms of $G_1$ and $[\sharp\sharp]_Q$ above.

**3.2 The $G_1$ side (unconditional).** Write $\psi=v+E$:
$$G_1(X)=\underbrace{\int_0^Xv(X-v)\,dv}_{=X^3/6}
+2\int_0^X(X-v)E(v)\,dv+\mathrm{Bil}(X).$$
By parts, $\int_0^X(X-v)E(v)\,dv=\int_0^XE_1$, $E_1(y)=\psi_1(y)-y^2/2$.
The explicit formula for $\psi_1(y)=\int_0^y\psi$ (residues of
$\frac{y^{s+1}}{s(s+1)}\bigl(-\frac{\zeta'}{\zeta}\bigr)(s)$: the $s=0$
residue is $-y\,\frac{\zeta'}{\zeta}(0)$, and
$\frac{\zeta'}{\zeta}(0)=\log2\pi$ from $\zeta(0)=-\tfrac12$,
$\zeta'(0)=-\tfrac12\log2\pi$ — checked):
$$\psi_1(y)=\frac{y^2}{2}-\sum_\rho\frac{y^{\rho+1}}{\rho(\rho+1)}
-y\log2\pi+O(1),$$
the zero sum absolutely convergent. Integrating and doubling:
$$G_1(X)=\frac{X^3}{6}-\log(2\pi)X^2+\mathrm{Layer}(X)+\mathrm{Bil}(X)
+O(X\log X),\qquad
\mathrm{Layer}(X)=-2\sum_\rho\frac{X^{\rho+2}}{\rho(\rho+1)(\rho+2)}.$$
Coefficient check: $2\cdot(-\log2\pi)\cdot\int_0^Xv\,dv/X^2\cdot X^2
=2\cdot(-\log2\pi)\cdot\tfrac{X^2}{2}=-\log(2\pi)X^2$. ✓ The $-\log2\pi$ is
the pole×constant cross term, coefficient exactly $1$.

**3.3 The $[\sharp\sharp]_Q$ side (unconditional).** By `MERTENS_FLOOR.md`
Lemmas 1–2, $\Psi^\sharp_Q(x)=x-a+\varepsilon(x)$ with
$\varepsilon=\sum_{d\le Q}A_d(\tfrac12-\{x/d\})$ bounded. Main term:
$$\int_0^X(v-a)(X-v-a)\,dv=\frac{X^3}{6}-\frac{aX^2}{2}-\frac{aX^2}{2}+a^2X
=\frac{X^3}{6}-aX^2+a^2X.\ \checkmark$$
Each sawtooth antiderivative is bounded by $d/8$, so the
$\varepsilon$-cross and $\varepsilon\!\cdot\!\varepsilon$ terms are
$O_Q(X)$ — this closes MF4's worry: **no $Q$-free $X^2$ term hides in the
sharp-side sawtooths**. Hence
$[\sharp\sharp]_Q(X)=\tfrac{X^3}{6}-\tfrac12M(Q)X^2+O_Q(X)$ and
$$\mathrm{LHS}(X)=\mathrm{Layer}(X)
+\Bigl(\tfrac12M(Q)-\log2\pi\Bigr)X^2+\mathrm{Bil}(X)+O_Q(X\log X).$$
So the whole dispute is the smooth part of $\mathrm{Bil}$, which the §4
prediction set to $0$.

**3.4 The bilinear smooth part is $-\tfrac{X^2}{4}$ (the missing term).**
Input (proven; Friedlander–Goldston 1995, one-sided form stated verbatim in
Goldston–Suriajaya 2021, per ledger row T5′; held in-corpus at `DSIDE.md`
§2): $\sum_{0<|j|<h}(h-|j|)\mathfrak S(j)
=h^2-h\log h-h(\gamma+\log2\pi-1)+O_\varepsilon(h^{1/2+\varepsilon})$.
Halve (symmetry of $\mathfrak S$), subtract
$\sum_{0<j<h}(h-j)=\tfrac{h^2}{2}-\tfrac h2$:
$$T(h)=\sum_{n\le h}(h-n)(\mathfrak S(n)-1)
=-\frac h2\log h+c_1h+O_\varepsilon(h^{1/2+\varepsilon}),\quad
c_1=1-\frac{\gamma+\log2\pi}{2}.$$
Constant check: $-\tfrac12(\gamma+\log2\pi-1)+\tfrac12
=1-\tfrac{\gamma+\log2\pi}{2}$. ✓ Exact identity (double partial
summation): $\int_0^XT_f=\tfrac12\sum_n(X-n)^2f(n)$, so
$\sum_{n\le X}(X-n)\,n\,f(n)=X\,T_f(X)-2\int_0^XT_f$. With
$f=\mathfrak S-1$, using
$\int_0^Xt\log t\,dt=\tfrac{X^2}{2}\log X-\tfrac{X^2}{4}$:
$$X\,T(X)=-\frac{X^2}{2}\log X+c_1X^2,\qquad
2\!\int_0^X\!T=-\frac{X^2}{2}\log X+\frac{X^2}{4}+c_1X^2
+O(X^{3/2+\varepsilon}),$$
$$\Longrightarrow\ \sum_{n\le X}(X-n)\,n\,(\mathfrak S(n)-1)
=-\frac{X^2}{4}+O_\varepsilon(X^{3/2+\varepsilon}).$$
Both the $\log$ and $c_1$ cancel **identically** — the $-\tfrac14$ depends
only on the $-\tfrac12\log$ coefficient of the FG average met by the
quadratic Cesàro weight $(X-n)n$ (the same mechanism that made exp27's
exact $\tfrac14$). Re-derived; every cancellation checks.

**3.5 The one conditional input.** (BK$_S$): the smooth part of
$\mathrm{Bil}(X)$ equals its singular-series prediction
$\sum_{n\le X}(X-n)n(\mathfrak S(n)-1)$ up to a mean-zero oscillation on
the pair frequencies plus $o(X^2)$. This is BK/strong-HL level — the
$S$-side mirror of `DSIDE.md` §3.3 — and is **not** implied by RH.
Everything else above is unconditional. Therefore, under (BK$_S$):
$$c(Q)=\frac{M(Q)}{2}-\log2\pi-\frac14,\qquad
c_0=-(\log2\pi+\tfrac14)=-2.087877066408\ldots$$
(Numerics: $\log2\pi=1.837877066408\ldots$; recomputed to 12 digits.)

**3.6 Against the measurement.** Exact $c(Q)$ at
$Q=1,10,30,100,300$: $-1.588,-2.588,-3.588,-1.588,-4.588$; exp32 printed
$-1.54,-2.55,-3.55,-1.55,-4.55$ — a *uniform* $+0.04$ offset, an order of
magnitude inside the declared $\pm0.1$ common-mode layer pollution, and
uniform across $Q$ exactly as common-mode pollution must be. The $X=10^7$
cross-check also passes ($3.5\times10^{14}$ predicted vs $3.56\times10^{14}$
printed at $Q=1$). The three candidates are separated by the data:
$-\tfrac14$ alone misses by $1.8$; $-\log2\pi$ alone misses by
$0.21\gg$ the $\pm0.01$ $Q$-stability; $-\log2\pi-\tfrac14$ sits inside
the stated error.

## 4. Verdict

**RESOLVED** (confirming the 2026-08-13 in-corpus closure; independently
re-derived here, all steps pass).

1. **Same quantity, same normalization.** Both sides speak of the
   $Q$-independent smooth $X^2$ floor of $G_1-[\sharp\sharp]_Q$ under the
   Cesàro weight $(X-n)$, floor read on $X\in[10^4,10^7]$. No
   normalization gap (no Mertens-constant, $\gamma$, or $\log\log X$
   absorption) separates them.
2. **The error is located on the prediction side**: `MERTENS_FLOOR.md:143`
   (and `collab/messages/0108:146–152`) predicted $c_0=-\log2\pi$ by
   accounting for the pole×constant cross term only, implicitly setting
   the smooth part of $\mathrm{Bil}(X)=\int_0^XE(v)E(X-v)\,dv$ to zero.
   That part is $-\tfrac{X^2}{4}$ under (BK$_S$).
3. **Correct value** $c_0=-(\log2\pi+\tfrac14)=-2.0878771\ldots$, the
   $-\log2\pi$ unconditional, the $-\tfrac14$ conditional on (BK$_S$)
   alone. The measured $-2.05$ was never wrong: it is the exact value plus
   the $+0.04$ common-mode zero-layer pollution its own note declared.

## 5. Honesty ledger

| # | item | status |
|---|---|---|
| C1 | Claim-site inventory §2 | Complete for `notes/` and `collab/` as of 2026-08-23 (grep: "log 2π", "log2\pi", "1.8378", "−2.05", "c_0", "psvg2m"); chronicle mirrors listed once, not per-copy. |
| C2 | Re-derivation §3 | All displayed integrals, residues, and cancellations recomputed by hand in this session; no step of Theorem F failed. Nothing computed in floating point beyond the 12-digit constant check (`bc`, transcription of $\log2\pi$). |
| C3 | Conditionality | $c_0=-(\log2\pi+\tfrac14)$ is conditional on (BK$_S$) (BK/strong-HL level, not implied by RH); stating it unconditionally would overclaim. The $M(Q)/2$ coefficient and the $[\sharp\sharp]_Q$ side are unconditional. |
| C4 | Novelty | None claimed. This note is an audit of `PROVABLE_MEASUREMENTS_TRIAGE_20260813.md` §3; prior-art status of the $-\tfrac14$ and the Corollary's $-2\log2\pi$ is as ledgered there (T5′: FG/Goldston–Suriajaya found for the input; NO-MATCH for the $n(X-n)$ push-through). |
