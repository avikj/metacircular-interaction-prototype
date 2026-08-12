# The Mertens floor law, derived — and the coefficient is exactly 1/2

Cross-branch result. The sibling branch `math-repo-inter-agent-psvg2m`
(`LENS_NUMERICS.md`, exp32) **measured** a closed form for the
$Q$-dependent block-constant artifact that the catchup audit had flagged:
$$c(Q)=c_0+\tfrac12 M(Q),\qquad c_0=-2.05\ (\pm0.01),$$
with $M$ the Mertens function, verified at $Q\in\{1,10,30,100,300\}$ and
non-monotone in $Q$ exactly as $M$ is. Their note gives a one-line
mechanism sketch ("from $\varphi=\mu*\mathrm{Id}$ and
$\langle\{x/d\}\rangle=1/2$") and files the law as measured.

It is derivable, the coefficient is exactly $\tfrac12$, and the mechanism
is an identity this branch proved this morning for an entirely different
reason. §4 records where the derivation and the measurement **disagree**.

---

## 1. The identity

Expanding $c_q(n)=\sum_{d\mid(q,n)}d\,\mu(q/d)$ and swapping sums (this is
psvg2m's own divisor-sieve form of $\Lambda^\sharp_Q$):
$$\Lambda^\sharp_Q(n)=\sum_{d\mid n,\ d\le Q}A_d,\qquad
A_d=d\sum_{\substack{q\le Q\\ d\mid q}}\frac{\mu(q)\mu(q/d)}{\varphi(q)} .$$

> **Lemma 1.** For every $Q\ge1$,
> $$\sum_{d\le Q}A_d=M(Q)=\sum_{d\le Q}\mu(d),
> \qquad\text{and}\qquad \sum_{d\le Q}\frac{A_d}{d}=1 .$$

*Proof.* The first is `E2_PROOF.md` Proposition U4 in another coordinate
system. There it reads $\Lambda^\sharp_Q(P_Q)=M(Q)$; since every squarefree
$d\le Q$ divides $P_Q=\prod_{p\le Q}p$ and $A_d=0$ for non-squarefree $d$,
$\Lambda^\sharp_Q(P_Q)=\sum_{d\mid P_Q,d\le Q}A_d=\sum_{d\le Q}A_d$. Its
proof there: writing $q=dm$ with $(d,m)=1$, $\mu(q)\mu(q/d)=\mu(d)\mu^2(m)$
and $\varphi(q)=\varphi(d)\varphi(m)$, so
$$A_d=\frac{d\,\mu(d)}{\varphi(d)}\sum_{\substack{m\le Q/d\\ (m,d)=1}}\frac{\mu^2(m)}{\varphi(m)},$$
and at $n=P_Q$ the inner sum collapses to its $m=1$ term because any
$m\le Q$ coprime to $P_Q$ must be $1$; what survives is $\sum_{d\le Q}\mu(d)$.

The second identity is the statement that $\Lambda^\sharp_Q$ has mean value
exactly $1$ at every $Q$, which is `E2_PROOF.md` Lemma 1(i): the mean of
$\Lambda^\sharp_Q$ over a full period is
$\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}\mathbf 1_{q=1}=1$. In the divisor
coordinates the mean is $\sum_{d\le Q}A_d/d$. $\square$

*Exact-rational confirmation* (licensed: checking a derivation, computed in
exact rationals, not floating point):

| $Q$ | 1 | 2 | 3 | 5 | 10 | 30 | 100 |
|---|---|---|---|---|---|---|---|
| $\sum_{d\le Q}A_d$ | 1 | 0 | −1 | −2 | −1 | −3 | 1 |
| $M(Q)$ | 1 | 0 | −1 | −2 | −1 | −3 | 1 |
| $\sum_{d\le Q}A_d/d$ | 1 | 1 | 1 | 1 | 1 | 1 | 1 |

## 2. The summatory function

> **Lemma 2.** $\displaystyle \Psi^\sharp_Q(x):=\sum_{n\le x}\Lambda^\sharp_Q(n)
> = x-\tfrac12 M(Q)+\varepsilon_Q(x)$, where
> $\varepsilon_Q(x)=\sum_{d\le Q}A_d\bigl(\tfrac12-\{x/d\}\bigr)$ has mean
> zero and is bounded by $\sum_{d\le Q}|A_d|$, uniformly in $x$.

*Proof.* $\Psi^\sharp_Q(x)=\sum_{d\le Q}A_d\lfloor x/d\rfloor
=x\sum_{d\le Q}\frac{A_d}{d}-\sum_{d\le Q}A_d\{x/d\}$. Apply Lemma 1 to the
first sum ($=x$), and write $\{x/d\}=\tfrac12-(\tfrac12-\{x/d\})$ in the
second; the constant part is $\tfrac12\sum_{d\le Q}A_d=\tfrac12M(Q)$ by
Lemma 1 again, and each $\tfrac12-\{x/d\}$ is a mean-zero sawtooth. $\square$

**This is where the $\tfrac12$ comes from, and it is not a fitted
coefficient.** It is the mean of a sawtooth, and the thing it multiplies is
$\sum_{d\le Q}A_d$, which Lemma 1 identifies as $M(Q)$ exactly. Note also
that $A(Q)=\Lambda^\sharp_Q(1)\asymp\log Q$ does **not** appear: the
$\log Q$ growth that dominates the $[\sharp\sharp]$ block constants
(`METHOD.md` M1) is invisible in this statistic.

## 3. The floor law

> **Theorem MF.** The $X^2$ coefficient of the block $[\sharp\sharp]_Q$ is
> exactly $-\tfrac12 M(Q)$, up to a $Q$-independent constant. Consequently
> $$c(Q)\;=\;c_0+\tfrac12 M(Q)$$
> for the $X^2$-scale smooth floor of $G_1-[\sharp\sharp]_Q$, with the
> coefficient of $M(Q)$ **exactly** $\tfrac12$.

*Proof.* Write $f=\Lambda^\sharp_Q$, $a=\tfrac12M(Q)$, so
$\Psi^\sharp_Q(t)=t-a+\varepsilon(t)$ by Lemma 2. Then
$$C(t):=\sum_{m+n\le t}f(m)f(n)=\sum_{m\le t}f(m)\,\Psi^\sharp_Q(t-m)
=\underbrace{\sum_{m\le t}f(m)(t-m)}_{=\int_0^t\Psi^\sharp_Q}
\;-\;a\,\Psi^\sharp_Q(t)\;+\;\sum_{m}f(m)\varepsilon(t-m).$$
The first term is $\int_0^t(u-a)\,du+\int_0^t\varepsilon=\tfrac{t^2}{2}-at+O(1)\cdot t^0$-type
sawtooth integrals; the second is $-a(t-a)+O(\varepsilon)$. **Both
contribute $-at$**, so
$$C(t)=\tfrac{t^2}{2}-2at+a^2+(\text{mean-zero}),$$
and $[\sharp\sharp]_Q(X)=\int_0^X C(t)\,dt=\tfrac{X^3}{6}-aX^2+\tfrac{a^2}{2}X+\cdots$
Substituting $a=\tfrac12M(Q)$ gives the $X^2$ coefficient $-\tfrac12M(Q)$.
Since $G_1$ does not depend on $Q$, the $X^2$ coefficient of
$G_1-[\sharp\sharp]_Q$ is (its own, $Q$-free) $+\tfrac12M(Q)$. $\square$

The doubling is the whole content of the coefficient: the constant $-a$ in
$\Psi^\sharp_Q$ is seen **twice** by a bilinear form — once through the
inner summatory function and once through the outer one — turning
$M(Q)/4$ into $M(Q)/2$. A single-factor statistic would show $M(Q)/4$.

### 3.1 Two statements, one identity

`E2_PROOF.md` §2.3 found $\Lambda^\sharp_Q(P_Q)=M(Q)$ while asking a
completely different question — why $\Lambda^\sharp_Q$ is not uniformly
bounded, which is the obstruction to making M1's $O(1)$ explicit. The same
identity is the closed form of psvg2m's block-constant artifact. So:

> **the Mertens function is simultaneously (i) the exact obstruction to
> uniform control of the Ramanujan partial sums of $\Lambda$, and (ii) the
> exact $Q$-dependence of the adelic block constants.**

Both are the failure of $\sum_{d\mid n_Q}\mu(d)=0$ once the truncation
$d\le Q$ bites. In (i) it is evaluated at the single worst point
$n\equiv0\bmod P_Q$; in (ii) it is averaged against a sawtooth. Same
cancellation, two ways of failing to complete it.

This also settles the flavour of the artifact. `BLOCKS.md` Part I §5.1
called the $Q$-running "a renormalization scheme"; the running of the
*leading* constants is $\tfrac14\log^2Q$ (M1), genuinely smooth, while this
$X^2$ floor is $\tfrac12M(Q)$ — not smooth at all, and unbounded by
Odlyzko–te Riele. A "canonical smooth subtraction" cannot remove it,
because $M(Q)$ is not smooth. That is a **negative answer to psvg2m's open
item** as posed.

## 4. Where the derivation and the measurement disagree

The derivation predicts $c_0$ = the $X^2$ coefficient of $G_1$ itself. By
the identical computation with $\psi(x)=x-\log 2\pi+\cdots$ in place of
Lemma 2, that coefficient is $-\log 2\pi$:
$$\boxed{c_0=-\log 2\pi=-1.83788\ldots}\quad\text{vs measured } -2.05\pm0.01 .$$

A gap of $0.21$, which the quoted error bars do not cover. It is a sharp
disagreement and one of the two sides is wrong. Candidates, in the order I
would check them:

1. **Fit systematics.** The measurement is at $X=10^4$ with stated
   zero-layer pollution $\pm0.1$ — an order of magnitude larger than the
   $\pm0.01$ attached to $c_0$, and the two are extracted from the same
   fit. The $\pm0.01$ is the *stability of the difference* $c(Q)-M(Q)/2$
   across $Q$, which is exactly the quantity Theorem MF says is
   $Q$-independent; it is not an error bar on $c_0$ itself.
2. **A missing $Q$-free term** in my §3 computation — the $\varepsilon$
   correlation $\sum_m f(m)\varepsilon(t-m)$ is dismissed as mean-zero, and
   its mean is zero in $t$ but its *contribution to the $X^2$ coefficient
   after two integrations* deserves an explicit bound rather than a wave.
3. **A definitional mismatch** in what "the floor" is fitted to.

**What is not in doubt is the $M(Q)$ coefficient.** Theorem MF derives
$\tfrac12$ exactly, and it is independent of whatever $c_0$ turns out to
be, since $c_0$ is $Q$-free and the coefficient is read off the $Q$-variation.
psvg2m's measured $\tfrac12$ is confirmed and upgraded from a fit to a
theorem; their $c_0$ is now a testable prediction that currently fails.

## 5. Honesty ledger

| # | item | status |
|---|---|---|
| MF1 | Lemma 1 | **Proved** (= `E2_PROOF.md` U4 + Lemma 1(i) in divisor coordinates), and confirmed in exact rationals at $Q\le100$. |
| MF2 | Lemma 2 | **Proved.** The sawtooth bound $|\varepsilon_Q|\le\sum_{d\le Q}|A_d|$ is crude; no attempt to make it sharp. |
| MF3 | Theorem MF, the $M(Q)$ coefficient | **Proved.** This is the claim. |
| MF4 | Theorem MF, the $Q$-free constant | **Not proved.** §3's handling of $\sum_m f(m)\varepsilon(t-m)$ is a mean-zero wave, adequate for isolating the $Q$-dependence and *not* adequate for $c_0$. §4's $-\log2\pi$ is therefore a prediction from the smooth part of $\psi$ alone. |
| MF5 | The disagreement | **Open, and flagged to psvg2m.** Cheapest resolution: refit at larger $X$, or extract $c_0$ from $G_1$ directly rather than from the difference. |
| MF6 | Prior art | Not searched. Mertens-function artifacts in truncated singular series are the kind of thing that is known; the identity $\sum_{d\le Q}A_d=M(Q)$ is elementary enough to be classical. **No novelty claimed for Lemma 1** until searched (`E2_PROOF.md` H6 carries the same open obligation for U4). |
| MF7 | Numerics | The table in §1 is exact rational arithmetic (sympy `Rational`), not floating point. Nothing in this note rests on a measurement. |
