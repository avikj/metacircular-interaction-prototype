# The interval discrepancy has no constant, and its $L^2$ replacement has an exact one

**Author.** genius-03 (Mādhava lane), 2026-08-14. Draw
`collab/orchestration/draws/2026-08-14-genius-16.txt` §genius-03; method lenses
Martin-Löf and Serre (§6).

**Target.** `notes/LENS_REGULARITY.md` §7, the sentence

> Read: $D_Q(X)/\sqrt X\approx0.98$, flat over three decades — square-root
> cancellation of the interval cut norm on the nose […] even the $\log^2$
> allowance is invisible at these heights

and the same number carried across the $Q$-filtration in
`notes/LENS_NUMERICS.md` §2 ("constants $0.976$–$0.983$ at $X=10^7$").

**Claim of this note.** There is no constant. $D_Q(X)/\sqrt X$ has
$\limsup=+\infty$, unconditionally (§1). The exactly derivable quantity behind
the measurement is the *logarithmic mean square*, not the sup; it converges,
its limit is a closed form, and that closed form is a constant this corpus
already proved in a different lane — $B=2+\gamma_E-\log4\pi=0.0461914\ldots$,
`CARRIER_JOIN.md` Lemma 0, `PRODUCT_CARRIER.md`, `SCREW.md` §1 (§3). Replacing
the sup by the mean square converts `LENS_REGULARITY.md` Theorem 1(3) from an
inequality-criterion into an **equality-criterion with a computable limit**,
and the limit additionally detects zero *simplicity* (§4).

**Substrate.** Prose mathematics. Cubical Agda v0.5 has no real analysis
(`formal/cubical/BUILD.md`); nothing below is formalizable there, and no Agda
was written. Grades used: PROVED / MEASURED / CITED / OPEN.

---

## 0. Objects

Notation of `LENS_REGULARITY.md` §0. $Q\ge1$ fixed,
$\Lambda^\sharp_Q=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}c_q$,
$\Lambda^\flat_Q=\Lambda-\Lambda^\sharp_Q$,
$\psi^\flat_Q(y)=\sum_{n\le y}\Lambda^\flat_Q(n)$, and

$$D_Q(X)=\sup_{I\subseteq(0,X]}\big|\psi^\flat_Q(I)\big|
=\max_{y\le X}\psi^\flat_Q(y)-\min_{y\le X}\psi^\flat_Q(y),
\qquad \|W_X\|_{\mathcal I}=D_Q(X)^2 .$$

Write $E(x)=\psi(x)-x$. By that note's Corollary 1.2,
$\psi^\flat_Q(x)=E(x)+O(C_Q+1)$ uniformly, so

$$D_Q(X)=\operatorname{osc}_{[0,X]}E+O_Q(1),\qquad
D_Q(X)\ \ge\ |\psi^\flat_Q(X)|=|E(X)|-O_Q(1) \tag{0.1}$$

(the second because $I=(0,X]$ is itself an admissible interval). Let
$\Theta=\sup\{\Re\rho:\zeta(\rho)=0\}$; let $\gamma$ run over the distinct
ordinates of nontrivial zeros and $m_\gamma\ge1$ their multiplicities.

---

## 1. Theorem A — the type is empty

> **Theorem A (unconditional).** For every fixed $Q\ge1$,
> $$\limsup_{X\to\infty}\frac{D_Q(X)}{\sqrt X}=+\infty,
> \qquad\text{equivalently}\qquad
> \limsup_{X\to\infty}\frac{\|W_X\|_{\mathcal I}}{X}=+\infty .$$
> In particular $\lim_{X\to\infty}D_Q(X)/\sqrt X$ does not exist, and no number
> is "the" value of $D_Q(X)/\sqrt X$.

*Proof.* Dichotomy on $\Theta$.

*Case $\Theta>1/2$.* This is `LENS_REGULARITY.md`'s own Theorem 1(2),
$\limsup\log D_Q(X)/\log X=\Theta$: pick $\varepsilon<\Theta-\tfrac12$; then
$D_Q(X)>X^{\Theta-\varepsilon}$ for arbitrarily large $X$, and
$X^{\Theta-\varepsilon-1/2}\to\infty$.

*Case $\Theta=1/2$ (RH).* Littlewood's oscillation theorem
$E(x)=\Omega_\pm\big(x^{1/2}\log\log\log x\big)$ [CITED: Littlewood 1914;
standard textbook form, e.g. Montgomery–Vaughan §15.2] gives $c>0$ and
$x_n\to\infty$ with $E(x_n)>c\,\sqrt{x_n}\log\log\log x_n$. Take $X=x_n$ in
(0.1). $\square$

The two cases are exhaustive, so Theorem A needs no hypothesis. (The usual
statement of Littlewood's theorem is itself proved by exactly this dichotomy —
if RH fails one has the stronger $\Omega_\pm(x^{\Theta-\varepsilon})$ — which
is why the $\Omega$ result is unconditional even though its proof assumes RH in
one branch.)

**Relation to what the corpus already says.** `LENS_NUMERICS.md` §6, caveat 2,
already records "$D/\sqrt X\approx0.98$ is an extreme-value level, not a
constant of nature. Under RH + Littlewood's $\Omega_\pm(x^{1/2}\log\log\log x)$
the ratio must creep upward without bound". **No novelty is claimed for the
qualitative observation.** Two corrections are owed to that sentence, and they
are the reason this note exists:

1. *It is not conditional on RH.* Theorem A's dichotomy removes the hypothesis.
2. *It does not "creep upward".* $D_Q(X)$ is a running maximum, hence monotone,
   but $D_Q(X)/\sqrt X$ is not, and nothing proves it drifts. What is proved is
   $\limsup=+\infty$; the $\liminf$ is not known to grow at all. "Creeps upward"
   describes a drift; the truth is an excursion structure. §2 says why the
   difference is exactly what the measurement cannot see.

And the sentence lives in the caveats of `LENS_NUMERICS.md`, not in
`LENS_REGULARITY.md` §7, where the number is quoted as "square-root
cancellation on the nose". A caveat in one note does not repair a headline in
another.

---

## 2. Why three decades of flatness carry no information

Two elementary facts, both PROVED, both a line.

**2.1 The $\sqrt X$ normalization discounts the past.** Put $u=\log x$,
$U=\log X$, and — this definition is used throughout —

$$e(u):=\frac{E(e^u)}{e^{u/2}},\qquad\text{so that under RH}\quad
e(u)=-\sum_\rho\frac{e^{i\gamma u}}{\rho}+O\!\big(u\,e^{-u/2}\big)$$

by the explicit formula (the $O$ absorbs $-\log2\pi-\tfrac12\log(1-x^{-2})$ and
the half-jumps of $\psi_0$). Then, by (0.1),

$$\frac{D_Q(X)}{\sqrt X}
=\sup_{u\le U}e^{-(U-u)/2}e(u)-\inf_{u\le U}e^{-(U-u)/2}e(u)+O_Q\!\big(X^{-1/2}\big),$$

so a point $x=Xe^{-T}$ enters with weight $e^{-T/2}$ *no matter how large the
oscillation was there*: under RH ($|e|\ll u^2$, von Koch),

$$\sup_{u\le U-T}e^{-(U-u)/2}|e(u)|\ \ll\ e^{-T/2}U^2 . \tag{2.1}$$

$D_Q(X)/\sqrt X$ is therefore a **discounted** running maximum — a local
statistic wearing the clothes of a global one. The monotonicity of $D_Q$ that
would make a drift visible is exactly what the discount cancels. This is the
mechanism behind `LENS_NUMERICS.md`'s "at a rate invisible over three decades";
(2.1) is the proof of it.

**2.2 The proved growth rate cannot be seen by any computation.** The only
proved divergence in Theorem A is Littlewood's $\log\log\log$. At $X=10^7$,

$$\log\log\log X=\log\log 16.1181=\log 2.7799=1.0224 .$$

The first $X$ at which this doubles is
$\exp\exp\exp(2.0449)=\exp\exp(7.7288)=\exp(2271.4)=10^{986.4}$.
**To see the "constant" grow by a factor $2$ one must extend the computation
from $10^{7}$ to $10^{986}$.** Flatness over three decades is not weak evidence
for a limit; it is the theorem's own prediction, and it would persist over
nine hundred decades.

Under Montgomery's conjecture [CITED: Montgomery 1980,
$\limsup E(x)/(\sqrt x(\log\log\log x)^2)=1/2\pi$] the extremal law is
$(\log\log\log x)^2/2\pi$, worth $0.166$ at $X=10^7$ against a one-sided
observed level $\approx0.49$: at these heights the observed number is governed
by neither the extremal law nor (see §3) the mean square. Whether the
pre-asymptotic running max and the conjectural envelope are reconcilable below
$10^{141}$ (where the envelope first reaches $0.49$) is **OPEN** and I do not
need it.

---

## 3. Theorem B — the exact scale, and it is already in the corpus

The statistic that *does* converge is the logarithmic mean square. Substituting
$t=e^u$,

$$V_Q(X):=\frac{1}{\log X}\int_1^X\frac{\psi^\flat_Q(t)^2}{t^2}\,dt
=\frac1U\int_0^U e(u)^2du+O_Q\big((\log X)^{-1/2}\big), \tag{3.1}$$

the error by Cauchy–Schwarz against $\psi^\flat_Q=E+O_Q(1)$.

> **Theorem B (under RH).**
> $$\lim_{X\to\infty}V_Q(X)\;=\;B_2:=\sum_{\gamma}\frac{m_\gamma^{2}}{\tfrac14+\gamma^{2}}
> \;\ge\;B:=\sum_{\gamma}\frac{m_\gamma}{\tfrac14+\gamma^{2}}
> \;=\;2+\gamma_E-\log4\pi\;=\;0.0461914179\ldots,$$
> with $B_2=B$ **iff every nontrivial zero is simple**. Hence, for simple zeros,
> the root-mean-square of $(\psi(x)-x)/\sqrt x$ in logarithmic measure is exactly
> $$\sqrt B=\sqrt{2+\gamma_E-\log4\pi}=0.2149219\ldots$$

*Derivation of the constant.* For $\Re s>1$,
$\int_1^\infty E(t)t^{-s-1}dt=-\frac{\zeta'(s)}{s\zeta(s)}-\frac1{s-1}$.
With $g_\delta(u)=e(u)e^{-\delta u}\mathbf 1_{u>0}$ this says
$\hat g_\delta(\tau)=F(\delta+i\tau)$, where

$$F(w)=-\frac{(\zeta'/\zeta)(w+\tfrac12)}{w+\tfrac12}-\frac{1}{w-\tfrac12}.$$

Plancherel gives $\int_0^\infty e(u)^2e^{-2\delta u}du
=\frac1{2\pi}\int_{\mathbb R}|F(\delta+i\tau)|^2d\tau$. Under RH the poles of
$F$ on $\Re w=0$ are $w=i\gamma$, and since $-\zeta'/\zeta(s)=-m_\gamma/(s-\rho)+O(1)$
at a zero of multiplicity $m_\gamma$, the residue of $F$ there is
$-m_\gamma/\rho$. Each pole contributes

$$2\delta\cdot\frac1{2\pi}\int_{\mathbb R}\frac{m_\gamma^2/|\rho|^2}{\delta^2+(\tau-\gamma)^2}\,d\tau
=2\delta\cdot\frac{1}{2\pi}\cdot\frac{\pi}{\delta}\cdot\frac{m_\gamma^2}{|\rho|^2}
=\frac{m_\gamma^2}{\tfrac14+\gamma^2},$$

and the pole at $w=\tfrac12$ contributes $O(\delta)$. So the Abel mean
$2\delta\int_0^\infty e^2e^{-2\delta u}du\to B_2$; since
$U\mapsto\int_0^Ue^2$ is nondecreasing, Karamata's Tauberian theorem upgrades
the Abel mean to $\frac1U\int_0^Ue^2\to B_2$. The evaluation
$\sum_\gamma m_\gamma/(\tfrac14+\gamma^2)=2+\gamma_E-\log4\pi$ is the corpus's
own: under RH $|\rho|^2=\rho(1-\rho)$, so this sum is
$H_1(1)=\sum_\rho m_\rho/(\rho(1-\rho))$, evaluated in `CARRIER_JOIN.md`
Lemma 0 / `PRODUCT_CARRIER.md` Prop. C1 / `SCREW.md` §1 (equivalently
$2\sum_\rho1/\rho$ via $\rho\mapsto1-\rho$, with
$\sum_\rho\frac1\rho=1+\frac{\gamma_E}2-\frac12\log4\pi$ from the Hadamard
product). Finally $m^2\ge m$ for $m\ge1$ with equality iff $m=1$, and
$\sum_\gamma m_\gamma^2/\gamma^2<\infty$ because $m_\gamma\ll\log\gamma$
against $N(T)\sim\frac{T}{2\pi}\log T$. $\square$

*Status.* The analytic step "the non-polar part of $|F|^2$ contributes
$o(1/\delta)$", which is what makes the pole sum legitimate, is Cramér's mean
value theorem [CITED: H. Cramér, *Ein Mittelwertsatz in der Primzahltheorie*,
Math. Z. **12** (1922) 147–153; located by search, **not read** — `WebFetch` is
EGRESS_BLOCKED here]. I claim PROVED for the identification of the constant
given that step, and CITED for the step.

**The multiplicity bookkeeping is a real difference and my least-sure step.**
Classical restatements of Cramér's theorem are normally written
$\sum_\rho|\rho|^{-2}$ "over zeros with multiplicity", i.e. $B$, not $B_2$. But
$e(u)=-\sum_\rho e^{i\gamma u}/\rho$ has a *single* Fourier–Bohr coefficient
$-m_\gamma/\rho_\gamma$ at the frequency $\gamma$, and Parseval squares it; so
the mean square is $\sum m_\gamma^2/|\rho|^2$ and the two agree only under
simplicity. Either the classical statements tacitly assume simple zeros, or I
have miscounted. **This is the step I most want refused.**

---

## 4. Theorem D — the $L^2$ criterion, with a limit instead of an inequality

> **Theorem D.** For every fixed $Q\ge1$:
> 1. $V_Q(X)=O(1)$ as $X\to\infty$ $\iff$ **RH**.
> 2. Under RH, $V_Q(X)\to B_2$, and $B_2=2+\gamma_E-\log4\pi$ $\iff$ every
>    nontrivial zero of $\zeta$ is simple.

*Proof.* ($\Leftarrow$ of 1, and 2) Theorem B.

($\Rightarrow$ of 1) Suppose $V_Q(X)\le C$ for all $X\ge2$; by (3.1) also
$\Phi(X):=\int_1^XE(t)^2t^{-2}dt\le C'\log X$. For $\sigma>\tfrac12$,
integrating $\int_1^\infty t^{1-2\sigma}\,d\Phi(t)$ by parts (boundary terms
vanish: $\Phi(1)=0$ and $t^{1-2\sigma}\Phi(t)\to0$) gives

$$\int_1^\infty E(t)^2t^{-2\sigma-1}dt=(2\sigma-1)\int_1^\infty \Phi(t)\,t^{-2\sigma}dt
\ \le\ (2\sigma-1)C'\!\int_1^\infty\!\frac{\log t}{t^{2\sigma}}dt=\frac{C'}{2\sigma-1}.$$

So $g_\sigma(u):=E(e^u)e^{-\sigma u}\mathbf1_{u>0}$ lies in $L^2(\mathbb R)$ with
$\|g_\sigma\|_2^2\le C'/(2\sigma-1)$, and its Fourier transform is
$\widehat{g_\sigma}(\tau)=-\frac{(\zeta'/\zeta)(\sigma+i\tau)}{\sigma+i\tau}-\frac1{\sigma-1+i\tau}$.
Plancherel: $\int|\widehat{g_\sigma}|^2d\tau\le 2\pi C'/(2\sigma-1)$.

Now suppose $\zeta(\rho_0)=0$ with $\rho_0=\beta_0+i\gamma_0$, $\beta_0>\tfrac12$,
of multiplicity $m$. Fix $\delta>0$ small enough that the closed disc
$|s-\rho_0|\le2\delta$ contains no other zero and misses $s=1$; on it
$-\zeta'/\zeta(s)+m/(s-\rho_0)$ is holomorphic, so for $\beta_0-\delta<\sigma<\beta_0$
and $|\tau-\gamma_0|\le\delta$,
$$|\widehat{g_\sigma}(\tau)|\ \ge\ \frac{m}{(|\rho_0|+1)\sqrt{(\beta_0-\sigma)^2+(\tau-\gamma_0)^2}}-K$$
with $K=K(\delta,\rho_0)$ fixed. Using $(a-b)^2\ge\frac12a^2-b^2$,

$$\int|\widehat{g_\sigma}|^2d\tau\ \ge\
\frac{m^2}{2(|\rho_0|+1)^2}\cdot\frac{2}{\beta_0-\sigma}\arctan\frac{\delta}{\beta_0-\sigma}
\;-\;2\delta K^2\ \xrightarrow[\sigma\uparrow\beta_0]{}\ +\infty,$$

while the upper bound $2\pi C'/(2\sigma-1)\to2\pi C'/(2\beta_0-1)<\infty$.
Contradiction; so $\beta_0\le\tfrac12$ for every zero. $\square$

**What this buys, in the vocabulary of `LENS_REGULARITY.md` §4's dictionary.**
Its Theorem 1(3) reads RH off an *inequality* ($D_Q\ll X^{1/2+\varepsilon}$)
whose constant is unavailable — by Theorem A there is none. Theorem D reads the
same hypothesis off a *convergent* statistic whose limit is a closed form, and
gets zero-simplicity for free. The row to add:

| statistic on $\Lambda^\flat_Q$ | criterion | limit |
|---|---|---|
| interval cut norm $\|W_X\|_{\mathcal I}=D_Q(X)^2$ | growth exponent $=2\Theta$ (Thm 1) | **none** — $\limsup D_Q X^{-1/2}=\infty$ (Thm A) |
| logarithmic mean square $V_Q(X)$ | bounded $\iff$ RH (Thm D.1) | $B_2=\sum m_\gamma^2/(\tfrac14+\gamma^2)$; $=2+\gamma_E-\log4\pi$ iff simple (Thm D.2) |

The exchange is the whole of the Mādhava lane in one line: *the sup-statistic
has no error term, the $L^2$ statistic is nothing but its error term.*

---

## 5. What the exp36 / exp32 tables actually measure

Reading of `LENS_REGULARITY.md` §7 and `LENS_NUMERICS.md` §2, column by column.
Nothing here is a new measurement; each entry says which theorem the column is
standing in for.

| column | content | verdict |
|---|---|---|
| $D_Q(X)$ | the oscillation itself | the only column carrying data |
| $D/\sqrt X$ | $0.948,0.994,0.983$ ($Q=1$) | **no limit** (Thm A). Reading: $0.98=4.56\sqrt B$, i.e. a range of $\pm2.28$ RMS units — an ordinary extreme-value level for a mean-zero oscillation over a few decades, with RMS exactly $\sqrt{2+\gamma_E-\log4\pi}$ (Thm B) |
| $D/(\sqrt X\log^2X)$ | $0.01118,0.00521,0.00378$ | **identically** column 3 divided by $\log^2X$: $0.948/9.2103^2=0.011175$, $0.99429/13.8155^2=0.005209$, $0.98283/16.1181^2=0.003783$. It re-plots $1/\log^2X$ and contains no arithmetic. "The $\log^2$ allowance is invisible" says only that von Koch's bound is not attained — which Thm A and Montgomery's conjecture both predict |
| meas-cut$/X$ ($Q=1$) | $0.8737,0.9213,0.9335$ | exactly $1-\Pi(X)/X+O(X^{-1}\log X)$ by Lemma 2(2), $\Pi$ the prime-power count — i.e. PNT, no cut-norm content. The exact identification (not the $1-1/\log X$ gloss printed in §7) is already in cross-review msg 0029, verified to four decimals at $X=10^6$ |
| $D_Q-D_1$ | $O_Q(1)$ | Corollary 1.2; the exponent of its $Q$-growth was closed exactly in `DRIFT_EXPONENT_EXACT.md` Theorem D ($\tfrac12$, scale $0.71176\,Q^{1/2}$), replacing a fitted $0.6$ |

Four of the five columns are determined in closed form by classical theory or
by results already in this corpus; the fifth is a quantity with no limit. The
precedent is exact: `DRIFT_EXPONENT_EXACT.md` performed this replacement for
the last row of the same table. This note performs it for the headline row.

---

## 6. Where the two drawn lenses disagree

They disagree about whether a replacement is owed, and the disagreement is not
cosmetic.

**Serre — shortest correct form, delete the rest.** §7 goes. Its five columns
reduce to two sentences: *$D_Q(X)=D_1(X)+O_Q(1)$; and
$\limsup D_1(X)X^{-1/2}=+\infty$.* Everything else in the table is a
restatement of $1/\log^2X$, of PNT, or of a quantity that does not converge.
Serre stops there: a number with no limit is not a result, and there is nothing
to put in its place because the note's own theorem (Theorem 1) already says
everything true about the sup.

**Martin-Löf — what would a canonical element of this type be?** The type §7
implicitly inhabits is $\Sigma(c:\mathbb R).\ \lim_X D_Q(X)/\sqrt X=c$.
Theorem A says the type is **empty**; and an empty type is not a small defect
in a measurement, it is a category error in the statement. The constructive
response is not deletion but *re-typing*: find the nearest type that does have
a canonical element. That is $\lim_X V_Q(X)$, whose canonical element is
$\sum_\gamma m_\gamma^2/(\tfrac14+\gamma^2)$ — and which, under simplicity,
normalizes to a real number the corpus has already constructed elsewhere.
Martin-Löf's lens is what produced §§3–4; Serre's lens would have stopped at §1.

I side with Serre on §7 (the paragraph should go) and with Martin-Löf on the
deliverable (Theorem D is worth more than the deletion). A third thing both
lenses agree on, and which I did not expect: the *repair* is cheaper than the
*measurement*. `code/exp36_cutnorm.py` sieves to $10^7$; §§3–4 are two pages
and reuse a constant this corpus had already proved, in the carrier lane
(`SCREW.md`, `PRODUCT_CARRIER.md`, `CARRIER_JOIN.md`), without either lane
noticing the other. The join was available before the sieve ran.

---

## 7. Rigor boundary

- **PROVED here.** Theorem A (both cases; case 1 quotes
  `LENS_REGULARITY.md` Theorem 1(2), case 2 quotes Littlewood). The
  localization bound (2.1). The reduction (3.1). Theorem B's *identification*
  of the constant, including $B_2\ge B$ with equality iff simplicity, given
  Cramér's analytic step. Theorem D.1 in both directions (the $\Rightarrow$
  direction is self-contained: Plancherel plus a pole lower bound). The column
  arithmetic of §5.
- **CITED, unread.** Littlewood's $\Omega_\pm(x^{1/2}\log\log\log x)$ (1914);
  Cramér, *Ein Mittelwertsatz in der Primzahltheorie*, Math. Z. **12** (1922)
  147–153; Wintner (1935), limiting distribution of $e^{-y/2}(\psi(e^y)-e^y)$
  under RH; Montgomery (1980) extremal conjecture. Searched 2026-08-14;
  `WebFetch` EGRESS_BLOCKED, so every one of these is a search-summary
  attribution and **none was read**. Queries: *Littlewood 1914 omega result
  psi(x)-x Omega_pm sqrt x log log log x*; *Cramér 1922 mean square integral
  (psi(x)-x)^2/x^2 dx asymptotic sum 1/|rho|^2 log X*; *limiting distribution
  (psi(x)-x)/sqrt(x) logarithmic density Rubinstein Sarnak Wintner variance*;
  *Montgomery conjecture extreme values psi(x)-x limsup sqrt(x)
  (log log log x)^2 2 pi*.
- **NOT claimed.** (i) No novelty for the observation that $0.98$ is an
  extreme-value level — `LENS_NUMERICS.md` §6 has it; I sharpen it (removal of
  RH; "excursion, not drift") and move it to where the number is quoted.
  (ii) No novelty for Theorem B as an asymptotic — that is Cramér's, and the
  constant $B$ is this corpus's own. What I claim as new *to this repository*
  is the identification of $B$ as the exact scale of the `LENS_REGULARITY`
  discrepancy, the $m_\gamma^2$ refinement, and Theorem D. (iii) I did **not**
  claim that $D_Q(X)/\sqrt X$ has a limiting distribution. It probably does
  under RH, but a weighted-sup functional of $e$ is not continuous in the
  $B^2$-mean in which $e$ is almost periodic ($\sum_\rho|\rho|^{-1}$ diverges),
  and Wintner's theorem is a one-dimensional statement about the value of $e$,
  not about a sup over a window. Getting from Wintner to a positive-density
  lower bound on $D_Q/\sqrt X$ with the constant $\sqrt{B_2}$ needs
  $\int t^2\,d\nu=B_2$ for the limiting measure $\nu$, which is a moment-
  convergence statement I did not prove and did not want to import unread.
  **OPEN**, and worth someone's page.
- **Least-sure step, stated for refusal.** The $m_\gamma^2$ versus $m_\gamma$
  bookkeeping of §3. If a reader confirms that Cramér's constant is
  $\sum m_\gamma^2/|\rho|^2$, Theorem D.2's simplicity clause stands as
  written; if the classical constant is genuinely $\sum m_\gamma/|\rho|^2$ then
  I have miscounted a Parseval and D.2's second clause should be struck while
  D.1 and Theorem A survive untouched.
- **Prior art for Theorem D.** Searched once, 2026-08-14. Query: *"mean square"
  of psi(x)-x logarithmic average bounded equivalent to Riemann hypothesis
  criterion integral (psi(t)-t)^2/t^2 dt*. Result: mean-square integral
  criteria for RH are a **known family** (the $\int_2^X(\psi(t)-t)^2dt\ll
  X^2\log^2X$ line, and the general "criteria equivalent to RH" surveys, e.g.
  arXiv:0808.0640 — located, **not read**); the exact statement of Theorem D,
  with the $\log$-average normalization and the limit
  $\sum_\gamma m_\gamma^2/(\tfrac14+\gamma^2)$, was not located. Given how
  standard the Mellin/Plancherel route is, I expect Theorem D to be classical
  or folklore and I claim **no novelty** for it — it is stated here as a
  *reformulation for this corpus's dictionary*, in the slot
  `LENS_REGULARITY.md` §4 leaves empty. One search is one search; absence of a
  located source is not evidence of novelty (`CLAUDE.md`).

## 8. Files consumed

`notes/LENS_REGULARITY.md` (target), `notes/LENS_NUMERICS.md`,
`notes/CARRIER_JOIN.md`, `notes/PRODUCT_CARRIER.md`, `notes/SCREW.md`,
`notes/CROSS_LENS.md`, `notes/DRIFT_EXPONENT_EXACT.md` (via
`LENS_NUMERICS.md`), `notes/EXP_LEDGER.md`, `notes/METHOD.md` (via
`site/candidates/channel.html` §5), `CLAUDE.md`, `formal/cubical/BUILD.md`.
Drawn files read in full and not used mathematically:
`collab/messages/0244-codex-ananta-backward-basin-boundary.md`,
`code/exp56_exposed_point_rigidity.py`,
`collab/messages/workers/20260812T090836.491254Z--claude_history--0001.md`,
`notes/LENS_ORDER_COMMUTATION.md`,
`collab/messages/0252-codex-arithmetic-life-linear-congruence-result.md`,
`collab/messages/workers/20260812T144712.610033Z--codex_ananta--0003.md`,
`collab/messages/0090-cfprime-budget-answers-atlas4.md`,
`site/candidates/channel.html`, `collab/orchestration/SOURCE_INDEX.md`,
`collab/orchestration/draws/2026-08-14-swarm-0814.txt`.
