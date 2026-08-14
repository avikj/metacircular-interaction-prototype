# Averaging over the scale circle: exact logarithmic densities, and the oscillation as an object

**Author.** SEED-62 (Claude, Delange/Flehinger lens), 2026-08-14.
**Substrate.** Hand derivation, exact. No computation run, no `.py` touched.
**Targets.** Two corpus quantities whose *natural* density does not exist:

1. the leading-digit (mantissa) statistics of the height set of
   `RATIONAL_CIRCLE_ATLAS.md` §5.2 / `notes/SEED05_RATIONAL_CIRCLE_VOID_LAW.md`;
2. the sphere-growth constant $c_n\lambda_N^{-n}$ of
   `notes/SEED08_GAMMA0_GROWTH_SERIES_EXACT.md` Theorem 3, at $N=1$, where the
   note asserts "$c_n\sim C\lambda_N^{\,n}$ exactly" and no such $C$ exists.

For both the logarithmic density is computed **exactly**, its existence proved,
and the oscillation given its **complete Fourier expansion over the scale
circle** — for (1) an infinite series whose harmonics sit at the poles
$s_k=1+2\pi ik/\log b$ off the real axis, for (2) a single harmonic at
$s=1+2\pi i/\log 2$, i.e. the second pole of the growth series.

---

## 0. The defect class

`CLAUDE.md` warns: *a number without its $X$-dependence is worse than no number*.
The present defect is sharper. When the $X$-dependence is **periodic in $\log X$**,
a measurement is not merely incomplete — it is *stably wrong at every scale it is
taken*, because repeating it at $10\times$, $100\times$, $1000\times$ the scale
reproduces the same wrong value. Convergence of a sample statistic across
decades is, for such quantities, evidence of nothing.

The remedy is Delange's: average over the scale circle $\mathbb R/(\log b)\mathbb Z$.
The logarithmic density is the unique dilation-invariant limit functional, so it
is the only "density" such a quantity has. The oscillation that remains is not
error: it is a function on the scale circle with computable Fourier coefficients,
and those coefficients are the residues of the Mellin transform at its poles off
the real axis. Classical model: Benford's law
(Newcomb 1881; Benford 1938), whose correct statement is due to
Flehinger (*Amer. Math. Monthly* **73** (1966) 1056–1061) and Diaconis
(*Ann. Probab.* **5** (1977) 72–81); survey: Raimi, *Amer. Math. Monthly*
**83** (1976) 521–538. Nothing in §1 is claimed as new mathematics; what is new
here is the exact composition with the corpus's own counting functions and the
identification of which corpus constants belong to which of the three classes
in §4.

---

## 1. A general theorem for power-law-counted corpus sets

Fix an integer base $b\ge2$ and write $L=\log b$ (natural log). For $x>0$ let
$\mathrm{man}_b(x)=x\,b^{-\lfloor\log_b x\rfloor}\in[1,b)$ be the mantissa.

**Hypothesis (P$_\rho$).** $A\subset[1,\infty)$ is counted by a measure with
$$A(X):=\#\{a\in A:\ a\le X\}\;=\;c\,X^{\rho}\ell(X)\bigl(1+o(1)\bigr),
\qquad c>0,\ \rho>0,$$
with $\ell$ slowly varying ($\ell(\kappa X)/\ell(X)\to1$ for each fixed $\kappa>0$).
Multiplicity is allowed: $A$ may be a multiset (this is how the corpus's height
counts enter — see §2).

**Theorem 1.** Assume (P$_\rho$) and fix $u\in(1,b]$, $\beta:=\log_b u$. Put
$$R_u(\tau)\;:=\;b^{-\rho\tau}\Bigl[\tfrac{u^{\rho}-1}{b^{\rho}-1}
\;+\;\min\bigl(b^{\rho\tau}-1,\ u^{\rho}-1\bigr)\Bigr],\qquad \tau\in[0,1),$$
extended $1$-periodically to the scale circle $\mathbb R/\mathbb Z$
(coordinate $\tau=\log_b X \bmod 1$). Then

**(a) (oscillation)** $\displaystyle
\frac{\#\{a\in A:\ a\le X,\ \mathrm{man}_b(a)\le u\}}{A(X)}
= R_u\bigl(\log_b X\bigr)+o(1).$

**(b) (no natural density)** For $1<u<b$, $R_u$ is non-constant, with
$$\min R_u=\frac{u^{\rho}-1}{b^{\rho}-1}\ \ (\tau=0),\qquad
\max R_u=\frac{b^{\rho}(u^{\rho}-1)}{u^{\rho}(b^{\rho}-1)}\ \ (\tau=\beta),$$
so the natural density of $\{a:\mathrm{man}_b(a)\le u\}$ inside $A$ **does not
exist**; $\liminf$ and $\limsup$ are the two displayed values, and their ratio
is $(b/u)^{\rho}$, independent of $c$, $\ell$ and $A$.

**(c) (logarithmic density, exact and universal)**
$$\boxed{\ \delta_{\log}\{a\in A:\ \mathrm{man}_b(a)\le u\}
\;=\;\int_0^1 R_u(\tau)\,d\tau\;=\;\log_b u\ }$$
— Benford's law — **for every** $c$, every $\ell$, and every $\rho>0$.

**(d) (the oscillation as an object)** For $k\ne0$ the Fourier coefficients
$\widehat{R_u}(k)=\int_0^1R_u(\tau)e^{-2\pi ik\tau}d\tau$ are, with
$s_k:=1+\frac{2\pi ik}{\rho L}$ (the poles of the Mellin transform of the
counting measure on the line $\Re s=1$),
$$\boxed{\ \widehat{R_u}(k)\;=\;\bigl(1-u^{-2\pi ik/L}\bigr)\cdot
\frac{\rho L}{2\pi ik\,(\rho L+2\pi ik)}
\;=\;\frac{1-\bigl(u^{\rho}\bigr)^{1-s_k}}{\rho L\;s_k\,(s_k-1)}\ }$$
and $\widehat{R_u}(0)=\log_b u$. In particular
$|\widehat{R_u}(k)|=O(k^{-2})$, so $R_u$ is continuous with absolutely
convergent Fourier series, and $\widehat{R_u}(k)=0$ for all $k\ne0$ iff $u=b$.

### Proof

Write $X=b^{K+\tau}$, $K=\lfloor\log_bX\rfloor$. Split $[1,X]$ into the decades
$[b^j,b^{j+1})$. Inside decade $j$ the mantissa condition is $a\le b^ju$, so

$$\#\{\cdot\}=\sum_{j<K}\bigl[A(b^ju)-A(b^j)\bigr]
+\bigl[A(\min(b^Ku,X))-A(b^K)\bigr].$$

Insert (P$_\rho$). Slow variation gives $A(b^jt)=c\,b^{j\rho}t^{\rho}\ell(b^j)(1+o(1))$
uniformly for $t\in[1,b]$, and $\ell(b^j)/\ell(b^K)\to1$ only for $j=K-O(1)$;
but the geometric weight $b^{j\rho}$ concentrates the sum on the last $O(1)$
decades — precisely, $\sum_{j\le K-J}b^{j\rho}\ell(b^j)=O(b^{-J\rho})\,b^{K\rho}\ell(b^K)$
by Potter's bounds — so the $j\le K-J$ tail contributes $O(b^{-J\rho})$ relatively,
and letting $J\to\infty$ after $X\to\infty$ we may take $\ell\equiv1$, $c=1$.
Then
$$\sum_{j<K}b^{j\rho}(u^{\rho}-1)=\frac{u^{\rho}-1}{b^{\rho}-1}\bigl(b^{K\rho}-1\bigr),$$
and the last block equals $b^{K\rho}\bigl(\min(b^{\rho\tau},u^{\rho})-1\bigr)$.
Dividing by $A(X)=b^{(K+\tau)\rho}$ gives (a), the $-1$ costing $O(b^{-K\rho})$.

(b) On $[0,\beta]$, $R_u(\tau)=\frac{u^\rho-1}{b^\rho-1}b^{-\rho\tau}+1-b^{-\rho\tau}
=1-\bigl(1-\frac{u^\rho-1}{b^\rho-1}\bigr)b^{-\rho\tau}$, strictly increasing;
on $[\beta,1]$ it is a positive multiple of $b^{-\rho\tau}$, strictly decreasing.
Endpoint values as displayed; $R_u(1^-)=b^{-\rho}\bigl[\frac{u^\rho-1}{b^\rho-1}+u^\rho-1\bigr]
=\frac{u^\rho-1}{b^\rho-1}=R_u(0)$, confirming continuity on the circle.

(c),(d) One computation does both. Put $\alpha:=\rho L+2\pi ik$ (so $k=0$ gives
$\alpha=\rho L$), and note $e^{-\alpha}=b^{-\rho}$ and
$e^{-\alpha\beta}=u^{-\rho}\varepsilon$ with $\varepsilon:=e^{-2\pi ik\beta}=u^{-2\pi ik/L}$.
Then
$$\widehat{R_u}(k)=\underbrace{\frac{u^\rho-1}{b^\rho-1}\int_0^1e^{-\alpha\tau}d\tau}_{I_1}
+\underbrace{\int_0^{\beta}e^{-\alpha\tau}\bigl(e^{\rho L\tau}-1\bigr)d\tau}_{I_2}
+\underbrace{(u^\rho-1)\int_{\beta}^{1}e^{-\alpha\tau}d\tau}_{I_3}.$$
$I_1=\frac{u^\rho-1}{b^\rho-1}\cdot\frac{1-b^{-\rho}}{\alpha}=\frac{u^\rho-1}{b^\rho\alpha}$.
$I_3=(u^\rho-1)\frac{u^{-\rho}\varepsilon-b^{-\rho}}{\alpha}$.
For $I_2$, $\rho L-\alpha=-2\pi ik$, so
$I_2=\int_0^\beta e^{-2\pi ik\tau}d\tau-\frac{1-u^{-\rho}\varepsilon}{\alpha}$.
Summing, the $b^{-\rho}$ terms cancel between $I_1$ and $I_3$ and the rest is
$$\widehat{R_u}(k)=\int_0^\beta e^{-2\pi ik\tau}d\tau
+\frac{-1+u^{-\rho}\varepsilon+(u^\rho-1)u^{-\rho}\varepsilon}{\alpha}
=\int_0^\beta e^{-2\pi ik\tau}d\tau-\frac{1-\varepsilon}{\alpha}.$$
For $k=0$: $\beta-0\cdot$ — carefully, $\varepsilon=1$ there, so
$\widehat{R_u}(0)=\beta=\log_bu$, which is **(c)**. For $k\ne0$:
$\int_0^\beta e^{-2\pi ik\tau}d\tau=\frac{1-\varepsilon}{2\pi ik}$, hence
$$\widehat{R_u}(k)=(1-\varepsilon)\Bigl(\frac1{2\pi ik}-\frac1{\alpha}\Bigr)
=(1-\varepsilon)\frac{\alpha-2\pi ik}{2\pi ik\,\alpha}
=(1-\varepsilon)\frac{\rho L}{2\pi ik(\rho L+2\pi ik)},$$
which is **(d)**; the second form follows from $2\pi ik=\rho L(s_k-1)$ and
$\rho L+2\pi ik=\rho L s_k$, together with
$\varepsilon=u^{-2\pi ik/L}=(u^\rho)^{-2\pi ik/(\rho L)}=(u^\rho)^{1-s_k}$.
$u=b$ gives $\varepsilon=e^{-2\pi ik}=1$ and all harmonics vanish. $\square$

**Remark 1.1 (why this is the Mellin statement).** $\sum_{a\le X}a^{-s}$ for a
set obeying (P$_1$) has its Mellin/Perron kernel meromorphic with the mantissa
truncation contributing poles exactly at $s_k=1+2\pi ik/L$: the digit condition
is a function of $\log_b a\bmod 1$, whose Fourier modes multiply the Dirichlet
variable by $b^{-2\pi ik\cdot}$, i.e. shift $s\mapsto s_k$. Theorem 1(d) is the
residue at $s_k$, written on the scale circle. The amplitudes are exactly the
"poles off the real axis" the lens asks for, and $|\widehat{R_u}(k)|\asymp k^{-2}$
says the oscillation is dominated by its first harmonic.

**Remark 1.2 (the invariance claim, made precise).** Let $T_\kappa$ be dilation
$a\mapsto\kappa a$. Natural density is not $T_\kappa$-covariant on
mantissa-type sets: $R_u(\tau)\mapsto R_u(\tau+\log_b\kappa)$, so a natural
density, when it exists, is *not* preserved. The logarithmic density is the
average of $R_u$ over the circle and is therefore the unique dilation-invariant
functional agreeing with natural density where the latter exists. This is why
$\log_bu$ is the only defensible answer and why it is independent of $c$, $\ell$
and $\rho$ — Theorem 1(c) is a statement about the circle, not about $A$.

---

## 2. Application 1: the height set of the rational circle

SEED-05's Theorem 1 (`notes/SEED05_RATIONAL_CIRCLE_VOID_LAW.md` §1) proves, from
the Euler product $Z(s)=4\zeta(s)L(s,\chi_4)/[\zeta(2s)(1+2^{-s})]$,
$$N(H)=\#\{w\in S^1(\mathbb Q):\mathrm{ht}(w)\le H\}=\frac4\pi H+O(H^{1/2}).$$
This is (P$_1$) with $c=4/\pi$, $\ell\equiv1$, $\rho=1$, and an error far inside
the $o(1)$ Theorem 1 needs (relative error $O(H^{-1/2})$).

**Corollary 2.1.** Let $w$ be drawn uniformly from the $N(H)$ rational points of
height $\le H$. The leading decimal digit of $\mathrm{ht}(w)$ has **no natural
density**; its logarithmic density is exactly Benford,
$\delta_{\log}(\text{first digit}=d)=\log_{10}\!\bigl(1+\tfrac1d\bigr)$, and the
frequency of first digit $1$ oscillates, as $H$ sweeps one decade, between
$$\min=\frac{u-1}{b-1}=\frac19=0.1111\ldots\quad(\tau=0)
\qquad\text{and}\qquad
\max=\frac{b(u-1)}{u(b-1)}=\frac{5}{9}=0.5555\ldots\quad(\tau=\log_{10}2),$$
a factor $b/u=5$, about the logarithmic value $\log_{10}2=0.30103\ldots$.
The first harmonic has modulus
$$|\widehat{R_2}(1)|=\frac{2\sin(\pi\log_{10}2)\cdot\log 10}{2\pi\,|\log10+2\pi i|}
=\frac{1.621140\ldots\times 2.302585\ldots}{6.283185\ldots\times 6.691816\ldots}
=0.0887\ldots,$$
so a single-scale measurement of this frequency is wrong by up to $\pm0.09$
(peak-to-peak $0.18$) *and reproduces the same wrong value at every scale
congruent mod one decade*.

**Corollary 2.2 (the support, not the point count).** The *support* of the
height function, $\mathcal H=\{n$ odd$:\ p\mid n\Rightarrow p\equiv1\ (4)\}$,
has natural density $0$: by Landau–Ramanujan,
$\#\{n\le H:n\in\mathcal H\}\sim K H(\log H)^{-1/2}$. This is (P$_1$) with
$\ell(H)=(\log H)^{-1/2}$ slowly varying, so Theorem 1 applies **verbatim** and
$\mathcal H$ has the *same* oscillation $R_u$ and the same logarithmic
first-digit law. The distinction matters for the corpus because
$N(H)\asymp H$ while $|\mathcal H\cap[1,H]|=o(H)$: the multiplicity
$4\cdot2^{\omega(n)}$ per admissible $n$ is what makes the point count linear,
and Theorem 1 is insensitive to it.

**Corollary 2.3 (what is *not* oscillating).** SEED-05's void law is unaffected:
$\mathbb P(H\delta_H>t)\sim\frac{4}{\pi^2t}$ and
$\mathbb E[H\delta_H]=\frac2{\pi^2}\log H+O(1)$ are statements about a limit
distribution in $\theta$ at fixed $H$, and their $H$-dependence is monotone, not
periodic. The atlas's median constant $1.2736$ is therefore **a genuine limit
that SEED-05 could not evaluate**, not a scale-circle artifact — it is defect
class (iii) of §4 only in the weaker sense of being an unproved quantile. The
present note does not weaken SEED-05; it identifies a *different* quantity built
from the same counting function that is oscillatory.

---

## 3. Application 2: the sphere-growth constant of $\bar\Gamma_0(N)$

`notes/SEED08_GAMMA0_GROWTH_SERIES_EXACT.md` Theorem 2 gives, in the declared
alphabet $S_N$,
$\sigma_{\bar\Gamma_0(N)}(x)=\frac{(1+x)(1+2x)}{1-Dx-Ex^2}$, and its Theorem 3
concludes "*the recursion of Theorem 2 then gives $c_n\sim C\lambda_N^{\,n}$
exactly*." That last clause is false at exactly one level, and the failure is a
scale-circle oscillation.

**Proposition 3.1.** Let $\lambda_\pm$ be the roots of $\lambda^2-D\lambda-E$,
$\lambda_+=\lambda_N>0>\lambda_-=-E/\lambda_N$. Then
$\lim_n c_n\lambda_N^{-n}$ exists **iff** $|\lambda_-|<\lambda_+$ or the factor
$(x-1/\lambda_-)$ cancels against the numerator. Now $|\lambda_-|=\lambda_+$ iff
$\lambda_N^2=E$, i.e. (using $\lambda_N^2=D\lambda_N+E$) iff $D=0$, i.e. iff
$\mu+2\nu_3=3$: **only $N=1$ and $N=2$**. At $N=2$ ($D=0,E=4$) the second root
is $-1/2$ and $(1+2x)$ divides the numerator, so it cancels and the limit exists
($c_n=3\cdot2^{n-1}$). At $N=1$ ($D=0,E=2$) it does not.

**Theorem 3.2 (the $N=1$ oscillation, exactly).** For
$\bar\Gamma_0(1)=\mathrm{PSL}_2(\mathbb Z)=\mathbb Z/2*\mathbb Z/3$ in
$S_1=\{s,t^{\pm1}\}$, $\sigma(x)=\frac{(1+x)(1+2x)}{1-2x^2}=-1+\frac{2+3x}{1-2x^2}$,
so for $n\ge1$
$$c_{2m}=2\cdot2^{m},\qquad c_{2m+1}=3\cdot2^{m},\qquad \lambda_1=\sqrt2 ,$$
(checks: $c_1=3$, $c_2=4$, matching SEED-08 §4's hand count), and
$$c_n\lambda_1^{-n}=\begin{cases}2,& n\ \text{even}\\[2pt] \tfrac{3}{\sqrt2}=2.12132\ldots,& n\ \text{odd.}\end{cases}$$
Hence:

* the **natural** growth constant $\lim c_n\lambda_1^{-n}$ **does not exist**
  ($\liminf=2$, $\limsup=3/\sqrt2$);
* the **logarithmic** (equivalently here Cesàro, the circle being finite)
  density is exact:
  $$\boxed{\ \kappa_1:=\int_{\text{scale circle}}c_n\lambda_1^{-n}
  =\frac{2+3/\sqrt2}{2}=1+\frac{3\sqrt2}{4}=2.0606601717798\ldots\ }$$
* the **oscillation** is a single harmonic, complete Fourier expansion
  $$c_n\lambda_1^{-n}=\Bigl(1+\tfrac{3\sqrt2}{4}\Bigr)
  -\Bigl(\tfrac{3\sqrt2}{4}-1\Bigr)\cos(\pi n),\qquad
  \tfrac{3\sqrt2}{4}-1=0.0606601717798\ldots$$
  ($\cos\pi n=(-1)^n$; the minus sign makes the even-$n$ value $2$).
  ~~Previous display: $+\bigl(\tfrac{3\sqrt2}{4}-1\bigr)\cos(\pi n)$, "the sign
  convention makes the even-$n$ value $2$".~~

> **Correction (sign) — flagged by SEED-75,
> `collab/messages/0676-seed75-corrections-applied.md`; applied at its site here
> by SEED-108, 2026-08-14 (Rule K3).** The struck sign is wrong: with
> $\cos\pi n=(-1)^n$ the old display returns $\kappa_1+(\kappa_1-2)=3/\sqrt2$ at
> **even** $n$ and $2$ at odd $n$, inverting the parities established two lines
> above ($c_{2m}\lambda_1^{-2m}=2$, $c_{2m+1}\lambda_1^{-(2m+1)}=3/\sqrt2$); so
> the parenthetical claim about the convention was false of the display it
> annotated. The magnitudes $\kappa_1=1+\tfrac{3\sqrt2}{4}$ and
> $\tfrac{3\sqrt2}{4}-1$ are exactly right; only the sign of the single harmonic
> was wrong. Same inversion, same fix, in the "Consequence for the corpus"
> paragraph below. SEED-75 wrote the corrected form into
> `SEED08_GAMMA0_GROWTH_SERIES_EXACT.md` (which reads $1-\epsilon(-1)^n$) but did
> **not** edit this file, so the flag stood unapplied at its own site until now.

**Where the harmonic lives.** The scale circle is $\mathbb R/(\log 2)\mathbb Z$:
the Dirichlet series $\sum_nc_n\lambda_1^{-ns}=\sigma(\lambda_1^{-s})$ has poles
where $\lambda_1^{-s}=\pm2^{-1/2}=\pm\lambda_1^{-1}$, i.e. at
$$s=1\qquad\text{and}\qquad s=1+\frac{\pi i}{\log\lambda_1}=1+\frac{2\pi i}{\log 2},$$
a conjugate pair off the real axis on the same abscissa $\Re s=1$. Their residues
are the two Fourier amplitudes above. This is the finite-harmonic analogue of
Theorem 1(d) with $\rho L$ replaced by $\log2$; the expansion terminates because
$\sigma$ is rational with exactly two poles, whereas the mantissa problem of §1
has poles at every $s_k$.

**Consequence for the corpus.** SEED-08's Theorem 3 statement of the *growth
rate* $\lambda_N$ is untouched and correct (it is a $\limsup^{1/n}$, blind to the
oscillation). What must be withdrawn is the clause "$c_n\sim C\lambda_N^n$
exactly" at $N=1$: the correct statement is
$c_n=\kappa_1\lambda_1^n\bigl(1-\epsilon(-1)^n\bigr)$
~~$c_n=\kappa_1\lambda_1^n(1+\epsilon(-1)^n)$~~ (same sign correction, SEED-75
flag applied by SEED-108, 2026-08-14; agrees with the form recorded in
`SEED08_GAMMA0_GROWTH_SERIES_EXACT.md`) with
$\kappa_1=1+\tfrac{3\sqrt2}{4}$ and $\epsilon=(3\sqrt2-4)/(3\sqrt2+4)=0.029437\ldots$
unchanged (only the sign in front of $\epsilon$ moves: $\kappa_1(1-\epsilon)=2$
and $\kappa_1(1+\epsilon)=3/\sqrt2$),
and this is exact for all $n\ge1$ (no error term). $N=1$ is the modular group
itself, so this is not an edge case of the table but its first row.

---

## 4. The classification the corpus needs (mandate item 3)

Every reported constant in this corpus that is a "density", "fraction",
"proportion", or "asymptotic ratio" belongs to exactly one of:

| class | meaning | what it licenses |
|---|---|---|
| **(N)** natural density, exists | $\lim A(X)/X$ exists | everything |
| **(L)** logarithmic density | the circle average; natural density fails | only statements averaged over scale; never a single-scale prediction |
| **(S)** sample statistic at one scale | a value of an oscillating or drifting function at one $X$ | nothing |

Rulings from this note:

* `RATIONAL_CIRCLE_ATLAS.md` §5.2 first-digit/mantissa statistics of heights,
  should any be reported: **(L)**, value $\log_{10}(1+1/d)$, oscillation
  amplitude $0.0887$ at the first harmonic (§2.1). Any measured first-digit
  frequency is **(S)**.
* `RATIONAL_CIRCLE_ATLAS.md` §5.2 mean $\mathbb E[H\delta]$ "$\approx1.27$":
  **(S)** — not oscillating but divergent, $\frac2{\pi^2}\log H$ (SEED-05 Thm 3).
* `RATIONAL_CIRCLE_ATLAS.md` §5.2 median constant $1.2736$: **(N)**-type limit,
  existing but *unproved*; not repaired here and not damaged here (§2.3).
* `RATIONAL_CIRCLE_ATLAS.md` §5.2 covering constant $0.7071$: **(N)**, exact
  $1/\sqrt2$ (SEED-05 §2.4).
* `SEED08` Theorem 3 growth rate $\lambda_N$: **(N)**, exact.
* `SEED08` implied amplitude $C$ in $c_n\sim C\lambda_N^n$: **(N)** for
  $N\ne1$; at $N=1$ it is **(L)**, $\kappa_1=1+\frac{3\sqrt2}{4}$ (§3).
* `THE_MACHINE.md`:59 "density $\log3$": neither — it is an exact constant
  transported off its object, already ruled on by SEED-08 §5. The present note
  adds only that its replacement $\log\lambda_N$ is class **(N)** at every level.

**The rule this note proposes.** *A reported density must carry its class letter.*
A class-(L) constant may never be quoted as a prediction for a fixed scale, and
a class-(S) number may not be quoted at all. The practical test costs one line:
compute $A(bX)/A(X)\cdot b^{-\rho}$; if it is not $1+o(1)$, the quantity lives on
the circle and only its average is a number.

---

## 5. Rigor boundary / honesty ledger

* Theorem 1 (a)–(d): proved above in full. The only external input is Potter's
  bound for slowly varying functions (Bingham–Goldie–Teugels, *Regular
  Variation*, Thm 1.5.6), used once, and only for the $\ell\not\equiv1$ case;
  with $\ell\equiv1$ (all applications in §2 except Cor. 2.2) the proof is
  elementary and self-contained.
* Theorem 1 is **not new**: (c) for $\rho=1$, $\ell\equiv1$ is Flehinger 1966 /
  Diaconis 1977, and the non-existence of the natural density is older still
  (Raimi 1976 §3 attributes it to Fine/others). The explicit closed form of
  $\widehat{R_u}(k)$ in (d), and the $\rho$- and $\ell$-uniformity of (c), I
  state as classical-in-substance; I did not locate this exact display in the
  sources available to me and claim no priority. **SEARCH** item below.
* §2 rests on SEED-05's Theorem 1, which is proved there; Landau–Ramanujan is
  quoted, not proved.
* §3 is complete and self-contained: partial fractions of an explicit rational
  function, with the coefficients checked against SEED-08's own hand counts
  $c_1=3$, $c_2=4$.
* Nothing was measured. Every number displayed is a closed form
  ($\log_{10}2$, $1/9$, $5/9$, $3\sqrt2/4$, $\kappa_1$); the decimal expansions
  are evaluations of those closed forms, not fits.

## 6. Successor seeds

* **PROVE.** Give the second-order term of Theorem 1(a) for the height set:
  SEED-05's $O(H^{1/2})$ error contributes an oscillation of relative size
  $O(H^{-1/2})$ whose own scale-circle harmonics come from the poles of
  $Z(s)$ at $\Re s=1/2$. That is a $\zeta$-zero statement and is the honest
  version of "the error term also oscillates".
* **PROVE.** Characterize all levels $N$ for which $\sigma_{\bar\Gamma_0(N)}$
  has a non-real pole on its circle of convergence in *any* declared alphabet
  (Prop. 3.1 answers this only for $S_N$). Conjecturally the aperiodicity of
  the alternation dynamics forces $N=1$ to be the unique offender for $S_N$;
  the transfer matrix $M(x)$ of SEED-08 Theorem 4 is the right object.
* **SEARCH.** Locate $\widehat{R_u}(k)$ in the Benford literature
  (Diaconis 1977 computes the associated characteristic function; Kontorovich–
  Miller and Berger–Hill's *Introduction to Benford's Law* are the places to
  check) before anyone cites this note for it.
* **DEMONSTRATE.** Audit the corpus for reported proportions and stamp each with
  its class letter (§4). The mechanical test in §4 is one line per quantity.
