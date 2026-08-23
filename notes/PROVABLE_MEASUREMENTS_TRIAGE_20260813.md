# Provable-measurements triage, 2026-08-13 — the delta, and the floor constant derived

Standing-discipline block (`CLAUDE.md`: no `PROVE` item claimed → re-read the
corpus for measured claims that are provable, before computing anything).
This note is the sweep of `notes/` and `papers/` for surviving
measured/fitted/empirical claims that are derivable, **restricted to the
delta**: claims *not* already on a triage list. Nothing here was computed;
§3 is a proof.

## 0. What already counts as triaged (excluded from the delta)

- `METHOD.md` §2–3: the 30-experiment verdict table, Proposition M1
  (exp27's $0.362$–$0.421\to\tfrac14$), and the proof queue (BARRIER
  Structure Prop, I1 prior art, E2 write-out, M1's $O(1)$, D″/DPP retirement).
- `SWEEP.md` §3 "Derivable-and-underived" queue items 1–7 ($\kappa(X)$,
  K′ re-closure, $C/D$ as $\langle\rho_2\rangle$, Fresnel quartic,
  $S_\infty$, $c_2$'s error bar, coherent-fraction closed form — item 7
  already retires the queued $k{=}3$ slope, so `phase_side.md` §4's measured
  $-1.66$ is *not* re-listed below).
- Per-note honesty ledgers where the measured number is a *verification of a
  stated derived value* (K2.md line amplitudes vs exact $\Gamma$-ratios;
  TERNARY.md coefficients $3.004/3.022/1.003$ vs proved $3,3,1$; DSIDE.md
  fits vs the quoted GM/MS constants; TWISTED_CARRIER.md null fits;
  RATIONAL_CIRCLE_ATLAS.md §6.1(2), where the exponents are proved and the
  prefactors declared fits).
- `MERTENS_FLOOR.md` MF1–MF3, MF7 (the $\tfrac12 M(Q)$ coefficient,
  proved). **MF4/MF5 are open and are the top item below.**

## 1. The delta: new provable-measurement claims

Ranked by (shortest proof)/(most load-bearing).

| # | claim (verbatim) + location | theorem it stands in for | route | est. length |
|---|---|---|---|---|
| **1** | "the residual $-0.21$ is unattributed — prime-power diagonal and $\zeta'/\zeta$ constants; not pursued" (`LENS_NUMERICS.md:231–234`; caveat at `:350–355`); "$c_0=-\log2\pi=-1.83788\ldots$ vs measured $-2.05\pm0.01$ … A gap of $0.21$ … one of the two sides is wrong" (`MERTENS_FLOOR.md:130–134`, open items MF4/MF5) | the $Q$-free constant of the exp32 smooth floor is exactly $c_0=-\bigl(\log2\pi+\tfrac14\bigr)$; the $-\tfrac14$ is the Friedlander–Goldston singular-series average pushed through the Cesàro weight | explicit formula for $\psi_1$ (pole$\times$constant term, unconditional) $+$ FG average (proven) via two exact partial summations $+$ the $S$-side Bogomolny–Keating renormalization already standard in `DSIDE.md` §3.3 (the one conditional input) | **1 page — proved in §3 below** |
| 2 | "$E_W^\circ(\delta)/2\sum\lvert W\rvert^2\approx2.8\,\delta$" and "the sampled value $c\approx2.8$ is evidence only" (`ENERGY.md:124,140,207,223`; echoed `papers/pairfield_monograph.md:433`) | the *constant* is not a sample: under the stated density model it is the closed-form ratio $\int\rho_2(s)\,\bar w(s)^2\,ds\,/\sum\lvert W\rvert^2$ with $\bar w$ the exact pair weight ($2\pi s^{-5}$ tail, `DPP.md`) and $\rho_2$ the corrected pair density $s\log^2s/8\pi^2$ (`SWEEP.md` §1.1) — a ratio of two absolutely convergent zero sums, evaluable as certified symbolic computation. The *separation hypothesis* stays open (that part is genuinely `DPP.md`/`DCLOSE_NO_GO.md` territory); the note currently lets the derivable constant hide behind the open hypothesis | zero-counting density + weight integral; tail by Stirling | ~1 page + one certified sum — **CLOSED 2026-08-13, `ENERGY_CONSTANT_EXACT.md`: $c=\langle\rho\rangle_{\lvert W\rvert^2}=N/D$ with $w^2=2\pi/(s(1{+}s^2)(4{+}s^2))$ and $\rho(s)=\frac{s}{4\pi^2}[(\log\frac s{2\pi}-1)^2+1-\zeta(2)]$; both sums proved absolutely convergent; the exact tail law gives $c(S)/c_\infty=1-\Theta(S^{-2}\log^4S)$, so $2.8$ was $c(300)$ in the wrong normalisation and is low by $1.7\times$ — the constant is $4.2$–$4.4$, conditional on the density hypothesis (P) only; and P4's uniform-in-$\delta$ constant is a different, SSH-conditional object** |
| 3 | "the measured drift grows like $\sim Q^{0.6}$, not $\sim C_Q\sim Q$" (`LENS_NUMERICS.md:130–133`) | a bound on $\max_X\lvert D_Q-D_1\rvert$, controlled by $\sup_x\lvert\varepsilon_Q(x)\rvert=\sup_x\lvert\sum_{d\le Q}A_d(\tfrac12-\{x/d\})\rvert$ (`MERTENS_FLOOR.md` Lemma 2). A fitted $0.6$ over 1.5 decades against a truth $Q^{1/2+o(1)}$ (Mertens scale: $\sup_n\lvert\Lambda^\sharp_Q\rvert=\lvert M(Q)\rvert$-driven, `E2_PROOF.md` U4) is the exp27 signature — an exponent read off a short lever | partial summation on $A_d=\frac{d\mu(d)}{\varphi(d)}\sum_{m\le Q/d,(m,d)=1}\frac{\mu^2(m)}{\varphi(m)}$ reduces to weighted Mertens sums; unconditional $o(Q)$ short, sharp $Q^{1/2+\varepsilon}$ needs $M(Q)$ cancellation | 1–2 pages for $o(Q)$; sharp exponent conditional — **CLOSED 2026-08-13, `DRIFT_EXPONENT_EXACT.md`: exponent exactly $\tfrac12$, unconditional, constant $\sqrt{\zeta(2)/3\zeta(4)}=0.71176$, correction $O_\varepsilon(Q^{-1/2+\varepsilon})$; the proposed route is superseded — $M(Q)$ is annihilated by the oscillation and plays no role** |
| 4 | Bohr-cut constants "$0.82$–$0.98$ — nearly $q$-independent, refuting the naive $1/\sqrt{\varphi(q)}$ RMS heuristic … we offer no theory", and "$D_{\mathcal B_3}(10^7)\approx D_{\mathcal I}(10^7)$ is … numerical accident" (`LENS_NUMERICS.md:52–55,272–283`) | the extreme-value law of $\max_a\,\mathrm{osc}_x$ of $\varphi(q)$ correlated character paths sharing the principal-character $\zeta$-zero term: the shared term alone forces $D_{\mathcal B_q}\ge(1-o(1))\cdot$class-resolved $\zeta$-oscillation, which is $q$-uniform — the "accident" at $q=3$ is the structural floor, not chance | explicit formula per character + max of correlated a.p. paths; the note's own parenthesis at `:281–283` is the proof sketch it declined to run | 2–3 pages |
| 5 | "The rank-$r$ rates for $r=2,3$ are MEASURED only. The $(\log H)^{-r}$ law is a counting heuristic plus equidistribution" (`RATIONAL_CIRCLE_ATLAS.md:660–664`) | quantitative linear independence of $\arg g_p$ over $\mathbb Q+\mathbb Q\pi$ (effective Baker) | not available at page length — correctly tagged by its own note; belongs on the ledger as `SEARCH` (effective-Baker literature), not `PROVE` | blocked |

Stale-queue hygiene found by the same sweep (corrections, not new claims):
`papers/pairfield_monograph.md:390` still queues "derive or refute the
empirical $0.0925\lambda^2/\log^2z$" — already resolved in
`papers/crossover.md` §6: the coefficient is
$(\gamma_1+\gamma^2/2)\lambda^2=0.0937731\ldots\lambda^2$ and $0.0925$ was
finite-$z$ bias. `SWEEP.md` §3.5's complaint about M1's $S_\infty$ is
superseded by the `E2_PROOF.md` §2.2 correction (the $\varphi(m)/m$ factor)
already adopted into `METHOD.md` §1.

---

## 2. Why item 1 outranks the rest

It is the only item that closes a *flagged contradiction between two filed
notes* — `MERTENS_FLOOR.md` §4 says in terminal language "one of the two
sides is wrong" — and it gates `INDEX_IA.md` open interface 1 ("the $-2.05$
is the candidate invariant" for the canonical smooth subtraction). It is
also the exact recurrence of the exp27 lesson this file exists to prevent:
an unattributed measured residual ($-0.21$) whose true value is a clean
rational-plus-classical constant, and — as with exp27 — the exact answer
once again contains a $\tfrac14$ produced by a $-\tfrac12\log$ average
integrated against a quadratic weight.

## 3. Theorem F: the floor constant is $-\bigl(\log2\pi+\tfrac14\bigr)$

**Objects** (as in exp32 / `LENS_NUMERICS.md` §1, `MERTENS_FLOOR.md`).
$R=\Lambda*\Lambda$ (additive convolution), $G_1(X)=\sum_{n\le X}(X-n)R(n)$;
$\Lambda^\sharp_Q(n)=\sum_{d\mid n,\,d\le Q}A_d$ with
$A_d=d\sum_{q\le Q,\,d\mid q}\mu(q)\mu(q/d)/\varphi(q)$;
$[\sharp\sharp]_Q(X)=\sum_{a,b\ge1}\Lambda^\sharp_Q(a)\Lambda^\sharp_Q(b)\,(X-a-b)_+$;
$\mathrm{LHS}(X)=G_1(X)-[\sharp\sharp]_Q(X)$, whose smooth $X^2$ floor exp32
measured as $c(Q)=c_0+\tfrac12M(Q)$, $c_0=-2.05$;
$\mathrm{Layer}(X)=-2\sum_\rho\frac{X^{\rho+2}}{\rho(\rho+1)(\rho+2)}$
(absolutely convergent, $=$ exp32's parameter-free pole$\times$zero model);
$\psi(x)=\sum_{n\le x}\Lambda(n)$, $E(x)=\psi(x)-x$;
$\Psi^\sharp_Q(x)=\sum_{n\le x}\Lambda^\sharp_Q(n)$;
$\mathfrak S$ the Goldbach/twin singular series, mean $1$, supported on even
integers.

### 3.1 An exact convolution identity

For any arithmetic $f,g$ with summatories $F,G$:
$$\sum_{a,b\ge1}f(a)g(b)\,(X-a-b)_+=\int_0^X F(X-v)\,G(v)\,dv,$$
since $F(X-v)G(v)=\sum_{a,b}f(a)g(b)\mathbf 1_{b\le v\le X-a}$ and the inner
measure of $\{v:\,b\le v\le X-a\}$ is $(X-a-b)_+$. Hence, exactly,
$$G_1(X)=\int_0^X\psi(v)\,\psi(X-v)\,dv,\qquad
[\sharp\sharp]_Q(X)=\int_0^X\Psi^\sharp_Q(v)\,\Psi^\sharp_Q(X-v)\,dv.$$

### 3.2 The $G_1$ side, unconditional part

Write $\psi=v+E$ and expand (the two cross terms are equal by $v\mapsto X-v$):
$$G_1(X)=\frac{X^3}{6}+2\int_0^X(X-v)E(v)\,dv+\mathrm{Bil}(X),
\qquad \mathrm{Bil}(X):=\int_0^X E(v)E(X-v)\,dv .$$
By parts $\int_0^X(X-v)E(v)\,dv=\int_0^X E_1(v)\,dv$ with
$E_1(y)=\int_0^yE=\psi_1(y)-y^2/2$, and the classical explicit formula
$$\psi_1(y)=\frac{y^2}{2}-\sum_\rho\frac{y^{\rho+1}}{\rho(\rho+1)}
-y\,\frac{\zeta'}{\zeta}(0)+O(1),\qquad \frac{\zeta'}{\zeta}(0)=\log2\pi,$$
with $\sum_\rho\lvert\rho(\rho+1)\rvert^{-1}<\infty$, gives unconditionally
$$\boxed{\;G_1(X)=\frac{X^3}{6}-\log(2\pi)\,X^2+\mathrm{Layer}(X)
+\mathrm{Bil}(X)+O(X\log X).\;}\tag{3.2}$$
This is a theorem; every constant in it is pinned. In particular the
$-\log2\pi$ that `LENS_NUMERICS.md` correctly attributed is the
pole$\times$constant cross term of the *square* of the explicit formula —
which is why it appears with coefficient $1$ here (once per cross term,
twice total, against weight $X^2/2$).

### 3.3 The $[\sharp\sharp]$ side, unconditional — closing MF4's worry (2)

By `MERTENS_FLOOR.md` Lemmas 1–2, $\Psi^\sharp_Q(x)=x-a+\varepsilon(x)$ with
$a=\tfrac12M(Q)$, $\varepsilon(x)=\sum_{d\le Q}A_d(\tfrac12-\{x/d\})$,
$\lvert\varepsilon\rvert\le K_Q:=\sum_{d\le Q}\lvert A_d\rvert$. Insert into
§3.1 and expand:
$$[\sharp\sharp]_Q(X)=\int_0^X(v-a)(X-v-a)\,dv
+2\int_0^X(X-v-a)\,\varepsilon(v)\,dv+\int_0^X\varepsilon(v)\varepsilon(X-v)\,dv.$$
The first integral is $\tfrac{X^3}{6}-aX^2+a^2X$. For the second: each
sawtooth has $\bigl|\int_0^y(\tfrac12-\{v/d\})\,dv\bigr|\le d/8$, so
$\lvert\int_0^X(X-v)\varepsilon\rvert\le\tfrac X8\sum_d\lvert A_d\rvert d$
and $\lvert\int\varepsilon\rvert\le\tfrac18\sum_d\lvert A_d\rvert d$. The
third is $\le K_Q^2X$. Hence, **unconditionally and elementarily**,
$$[\sharp\sharp]_Q(X)=\frac{X^3}{6}-\frac{M(Q)}{2}X^2+O_Q(X).\tag{3.3}$$
This upgrades Theorem MF's "$-at$ twice, rest mean-zero" to an explicit
error bound: the $\varepsilon$-correlation that MF4 worried about
contributes $O_Q(X)$, not $X^2$. The $X^2$ coefficient of
$[\sharp\sharp]_Q$ is exactly $-\tfrac12M(Q)$; no $Q$-free term hides here.
Subtracting (3.3) from (3.2):
$$\mathrm{LHS}(X)=\mathrm{Layer}(X)
+\Bigl(\frac{M(Q)}{2}-\log2\pi\Bigr)X^2+\mathrm{Bil}(X)+O_Q(X\log X).\tag{3.4}$$
So the entire disputed constant is the smooth part of $\mathrm{Bil}$ — the
bilinear fluctuation autocorrelation at complementary arguments — which
Theorem MF's §4 prediction implicitly set to zero. That was the missing
term, and it is *not* zero.

### 3.4 The singular-series average, pushed through the Cesàro weight (proven)

The corpus already holds the needed theorem (`DSIDE.md` §2, marked
**proven**, Friedlander–Goldston / Montgomery–Soundararajan):
$$\sum_{0<|j|<h}(h-\lvert j\rvert)\,\mathfrak S(j)
=h^2-h\log h-h(\gamma+\log2\pi-1)+O_\varepsilon(h^{1/2+\varepsilon}).$$
One-sided, and subtracting $\sum_{0<j<h}(h-j)\cdot1=h^2/2-h/2$:
$$T(h):=\sum_{n\le h}(h-n)\bigl(\mathfrak S(n)-1\bigr)
=-\frac h2\log h+c_1h+O_\varepsilon(h^{1/2+\varepsilon}),\qquad
c_1=1-\frac{\gamma+\log2\pi}{2}.$$
Now the exact double-partial-summation identity: for any arithmetic $f$
with $T_f(x)=\sum_{n\le x}(x-n)f(n)$, using $n=X-(X-n)$ and
$\int_0^XT_f=\tfrac12\sum_n(X-n)^2f(n)$,
$$\sum_{n\le X}(X-n)\,n\,f(n)=X\,T_f(X)-2\int_0^XT_f(t)\,dt .$$
With $f=\mathfrak S-1$:
$$X\,T(X)=-\frac{X^2}{2}\log X+c_1X^2,\qquad
2\int_0^XT=-\frac{X^2}{2}\log X+\frac{X^2}{4}+c_1X^2+O(X^{3/2+\varepsilon}),$$
$$\Longrightarrow\quad
\boxed{\;\sum_{n\le X}(X-n)\,n\,\bigl(\mathfrak S(n)-1\bigr)
=-\frac{X^2}{4}+O_\varepsilon(X^{3/2+\varepsilon}).\;}\tag{3.5}$$
Both the $\log$ terms and the constant $c_1$ cancel identically: the
$-\tfrac14$ depends *only* on the $-\tfrac12\log$ coefficient of the FG
average — the same mechanism (a logarithmic average met by a polynomial
weight) that produced M1's $\tfrac14\log^2Q$. It is unconditionally robust.

### 3.5 The conditional input, and the theorem

**Hypothesis (BK$_S$)** — the $S$-side mirror of the renormalized-diagonal
statement the corpus already uses on the $D$-side (`DSIDE.md` §3.3: "the
renormalized diagonal expectation of the boxed form equals
$(\mathfrak S(h)-1)X^2/2$"): *the smooth ($\log X$-frequency-zero) part of
$\mathrm{Bil}(X)$ equals its singular-series prediction with the matching
weight,*
$$\mathrm{Bil}(X)=\sum_{n\le X}(X-n)\,n\,\bigl(\mathfrak S(n)-1\bigr)
+\mathrm{Osc}(X)+o(X^2),$$
with $\mathrm{Osc}$ carried on the pair frequencies $\{\gamma+\gamma'\}$
(Theorem D's band — mean zero in $\log X$, hence invisible to the floor
readout). This is conjectural at exactly the BK/strong-HL level, the same
level `DSIDE.md` §3.5 files as "heuristic (standard)"; it is *not* implied
by RH. Everything else above is unconditional.

> **Theorem F.** Assume (BK$_S$). Then the smooth $X^2$ floor of
> $G_1-[\sharp\sharp]_Q$ is
> $$c(Q)=\frac{M(Q)}{2}-\log2\pi-\frac14+o(1),\qquad\text{i.e.}\qquad
> \boxed{\;c_0=-\Bigl(\log2\pi+\frac14\Bigr)=-2.0878771\ldots\;}$$

*Proof.* Insert (3.5) into (BK$_S$), then into (3.4). $\square$

**Corollary (Cesàro-mean second-order Hardy–Littlewood).** Under (BK$_S$),
comparing (3.2) with $G_1=\sum(X-n)R(n)$ and
$\sum_{n\le X}(X-n)n\,\mathfrak S(n)=\tfrac{X^3}{6}-\tfrac{X^2}{4}+O(X^{3/2+\varepsilon})$:
$$\sum_{n\le X}(X-n)\bigl(R(n)-n\,\mathfrak S(n)\bigr)
=\mathrm{Layer}(X)-\log(2\pi)\,X^2+\mathrm{Osc}(X)+o(X^2),$$
i.e. the Goldbach count runs on average $2\log2\pi=3.6758\ldots$ *below*
$n\mathfrak S(n)$ in Cesàro mean — the $S$-side sibling of the
Montgomery–Soundararajan constant $-(\gamma+\log2\pi)$ on the $D$-side,
with the constant here forced unconditionally by the
$\zeta'/\zeta(0)$-term of (3.2) once (BK$_S$) fixes the bilinear part.

### 3.6 Confrontation with the measurement (licensed: checking a derivation)

Exact prediction $c(Q)=\tfrac12M(Q)-2.0878771$ against exp32's printed
floor table (`LENS_NUMERICS.md:207–211`, read at $X=10^4$, stated
common-mode zero-layer pollution $\pm0.1$):

| $Q$ | 1 | 10 | 30 | 100 | 300 |
|---|---|---|---|---|---|
| measured $c(Q)$ | $-1.54$ | $-2.55$ | $-3.55$ | $-1.55$ | $-4.55$ |
| exact $\tfrac12M(Q)-\log2\pi-\tfrac14$ | $-1.588$ | $-2.588$ | $-3.588$ | $-1.588$ | $-4.588$ |

A *uniform* offset $+0.04$ at all five $Q$ — precisely the common-mode
layer pollution exp32 itself declared, and an order of magnitude inside its
$\pm0.1$. At the far end: exp32's $X=10^7$ decomposition (common layer
value $\approx+5.1\times10^{14}$ plus floor) gives predicted
$\mathrm{LHS}(10^7;Q{=}1)\approx(5.1-1.59)\times10^{14}=3.5\times10^{14}$
against the printed $3.56\times10^{14}$. The three candidate constants are
now separated by the data: $-\tfrac14$ alone ($-0.25$, naive HL with no
$\zeta'/\zeta(0)$ term) is off by $1.8$; $-\log2\pi$ alone ($-1.838$,
`MERTENS_FLOOR.md` §4's prediction, i.e. smooth $\mathrm{Bil}=0$) is off by
$0.21\gg$ the $Q$-stability; $-\log2\pi-\tfrac14$ sits inside the stated
error. **Resolution of MF5: neither side was wrong.** The measurement was
right; Theorem MF's $M(Q)/2$ was right; the §4 *prediction* for $c_0$ was
incomplete — it omitted the bilinear smooth part, which FG evaluates to
exactly $-\tfrac14$.

### 3.7 The exp27 echo

exp32's residual $-0.21$, "unattributed … not pursued", is exactly
$-\tfrac14$ polluted at the declared level, and the guessed attribution
("prime-power diagonal and $\zeta'/\zeta$ constants") named the wrong
objects — it is the singular-series average. As with exp27 ($0.362$ fitted
where $\tfrac14$ is exact), the truth is a $\tfrac14$ manufactured by a
$-\tfrac12\log$ integrated against a quadratic weight, and no fit at one
scale could have separated it from the neighbouring constants; the
derivation took one page and used only results the corpus already quotes as
proven.

## 4. Downstream corrections forced

1. **`MERTENS_FLOOR.md` §4** — the boxed prediction $c_0=-\log2\pi$ is
   superseded: correct value $-(\log2\pi+\tfrac14)$, conditional on
   (BK$_S$); the "sharp disagreement" paragraph and candidate list resolve
   as above. MF4 closes (the $\varepsilon$-correlation is $O_Q(X)$, §3.3);
   MF5 closes (no refit needed — the $X=10^4$ and $X=10^7$ readings both
   already match the corrected constant).
2. **`LENS_NUMERICS.md`** `:231–234` — "$-0.21$ unattributed" →
   $-\tfrac14$ (FG average), and the "prime-power diagonal" attribution
   retracted; `:350–355` caveat (the split "is unverified attribution")
   discharged; `:318–323` (§5 item 3) upgrades: the artifact formula is
   fully closed-form, $c(Q)=\tfrac12M(Q)-\log2\pi-\tfrac14$, so "any future
   block-constant statement can subtract it" now with no measured input.
3. **`INDEX_IA.md`** open interface 1 (`:58–63`) — "the $-2.05$ is the
   candidate invariant": the invariant is $-(\log2\pi+\tfrac14)$; the
   interface's canonical-smooth-subtraction object is now constant-free.
4. **`EXP_LEDGER.md:161`** (exp32 row) — "Mertens floor law
   $c(Q)=-2.05+M(Q)/2$" → exact form as above.
5. **`papers/pairfield_monograph.md:390`** (independent stale item found by
   this sweep) — queue entry for the $0.0925$ coefficient should be marked
   done per `papers/crossover.md` §6 ($0.0937731\ldots$).
6. No correction propagates to the $M(Q)/2$ coefficient, the exponent
   statements, Prop-6 slack, or any $Q$-difference claim: those never
   depended on $c_0$. `collab/` chronicle entries citing $-2.05$ are
   historical records and stay as filed.

## 5. Honesty ledger

| # | item | status |
|---|---|---|
| T1 | Identity §3.1; expansion (3.2) with $-\log2\pi$ and Layer | **Proved, unconditional** (absolutely convergent zero sum; no RH). |
| T2 | (3.3): $[\sharp\sharp]_Q$ floor exactly $-\tfrac12M(Q)$, error $O_Q(X)$ | **Proved, unconditional**; sharpens `MERTENS_FLOOR.md` Thm MF and closes MF4(2). |
| T3 | (3.5): FG average $\Rightarrow-\tfrac{X^2}{4}$ under weight $(X-n)n$ | **Proved**, given the FG/MS theorem as quoted (proven) in `DSIDE.md` §2; constants cancel identically. |
| T4 | (BK$_S$) | **Conjectural** (BK/strong-HL level), stated as the exact $S$-side mirror of `DSIDE.md` §3.3; *not* implied by RH. Theorem F and the Corollary are conditional on it and on nothing else. The exp32 data is its first quantitative test at the constant level: passed at $+0.04$ on a declared $\pm0.1$. |
| T5 | Prior art | **Not yet searched** for the Corollary's $-2\log2\pi$ Cesàro-mean constant; the Languasco–Zaccagnini Cesàro-average papers and Goldston–Yang (already cited at `CARRIER_JOIN.md:251` for the remainder bound) are the likely home — their $k$-Cesàro expansions contain $\zeta'/\zeta(0)$-type terms. `SEARCH` item filed: no novelty claim for the Corollary until read. The *application* (closing exp32's floor constant / MF5) is new in-corpus regardless. |
| T6 | Items 2–4 of §1 | Queued as `PROVE` in the stated order; item 5 as `SEARCH`. Nothing in this note was computed; the only numerics quoted are exp32's published tables, used to test the derivation. |
| T5′ | **SEARCH resolved 2026-08-14 (`cf-tessera`), split verdict, search-summary grade** | **(a) Input — RESOLVED-FOUND.** §3.4's FG average is Friedlander–Goldston, *Some singular series averages and the distribution of Goldbach numbers in short intervals*, Illinois J. Math. **39** (1995) 158–180 (confirmed). Goldston–Suriajaya, *The error term in the Cesàro mean of the prime pair singular series*, J. Number Theory **227** (2021) 144–157 (arXiv:2007.14616), state the one-sided Cesàro form verbatim: $\sum_{k\le x}(x-k)\mathfrak S(k)=\tfrac12x^2-\tfrac12x\log x+\tfrac12(1-\gamma-\log2\pi)x+O(x^{1/2+\varepsilon})$ — identically §3.4's halved import ($c_1=1-\tfrac{\gamma+\log2\pi}2$), with Vaughan's refinement $x^{1/2}\exp(-c(\log 2x)^{3/5}(\log\log 3x)^{-1/5})$ of the error. Companion: Goldston–Suriajaya, *A singular series average and the zeros of the Riemann zeta-function*, Acta Arith. **200** (2021) (arXiv:2007.16099) — that error term is itself an explicit formula over $\zeta$-zeros and oscillates, which is the literature's object matching (BK$_S$)'s $\mathrm{Osc}$. **(b) The $-\tfrac14$ — RESOLVED-NO-MATCH.** No source located for the second push-through, i.e. the weight $n(X-n)$ / order-2 Riesz mean giving $\sum_{n\le X}(X-n)n(\mathfrak S(n)-1)=-\tfrac{X^2}4+O(X^{3/2+\varepsilon})$, nor for $-\tfrac14$ as a named constant. Queries: *Goldston Yang average singular series Goldbach error term*; *Friedlander Goldston singular series average Montgomery Soundararajan prime pairs*; *Riesz mean order two singular series weight n(x−n) asymptotic −x²/4*; *Goldston Suriajaya Cesàro mean main term formula*. **(c) The Corollary's $-2\log2\pi$ — RESOLVED-NO-MATCH.** Nearest homes read and not matched: Brüdern–Kaczorowski–Perelli (arXiv:1712.00737, explicit formula for the Cesàro–Riesz mean of every order $k>0$), Languasco–Zaccagnini (arXiv:1206.0251), Goldston–Yang (arXiv:1601.06902); the located statements of all three carry $O(N)$ or $O(N^{1/2})$ errors at the order where this constant would sit, so it is not visible in them. Queries: *average Goldbach representations minus singular series second order term log 2π Cesàro*; *Fujii average Goldbach lower order term ζ′/ζ(0)*; *R(n) minus n𝔖(n) mean discrepancy constant Cesàro*. **Egress:** `WebSearch` worked; `WebFetch` blocked on every host tried with `{"error_type":"EGRESS_BLOCKED", ... "blocked by the network egress proxy."}` — no PDF read, all citations śabda grade. Attribution status only; Theorem F, the Corollary and (BK$_S$) are unchanged, and no novelty is claimed for (b) or (c) on the strength of a null search. |
