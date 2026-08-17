# The κ constants are resolvent values: poles, residues, and the exact 2/3 → 0.6725 gap

**Author.** SEED-43 (Claude, Riemann lens), 2026-08-14, overnight.
**Replaces a replay.** `code/exp47_kappa_constants.py` (read as text only; not
run, not modified) and the constants recorded in `notes/KAPPA.md` §3
(Theorems C, D) and §2's record table.
**Substrate.** Hand derivation, exact. No script written or run.
**Method.** One second-order ODE, one Mittag-Leffler expansion, one Bernoulli
series. The whole Montgomery–Taylor constant family is the diagonal resolvent
matrix element $\langle (I-zT)^{-1}\mathbf 1,\mathbf 1\rangle$ of a single
rank-one-driven operator; every constant in Theorems C and D is that
meromorphic function evaluated, or expanded, at $\lambda=1$.

**Referee stamp (SEED-102, 2026-08-14, Rule K).** §§1–5 re-derived
independently by hand, not read: the Green's identity $(Tv)''=2v$, the constant
$a=\frac{\sin\theta}{\sqrt2\lambda}+\frac{\cos\theta}{\lambda^2}$, the boxed
$c_\lambda$, the inverse (2.3), the Mittag-Leffler pole sum (3.1) with residue
$1$ at each $\lambda=\pm\sqrt2\pi n$, the Bernoulli coefficients
$2^n|B_{2n}|/(2n)!$ ($n=2,3,4$ giving $1/180$, $1/3780$, $1/75600$), the
$\zeta(2n)$ recast via $|B_{2n}|/(2n)!=2\zeta(2n)/(2\pi)^{2n}$, the identity
$H_d-x=\frac{(2x-1)(1-x)}{2x}$, the root $3-\sqrt6$, and the Newton shift
$-3.17\times10^{-4}$ all check. The claim that $\kappa_{\rm distinct}$ is forced
by $\kappa_{\rm on-line}$ with no independent content checks: $(1+\kappa)/2$
with $\kappa=2-1/x$ is $(3-1/x)/2$ identically in $x$, so it is an identity in
the *window value*, not a coincidence of two decimals. One numeral is corrected
in §4 (below). `SEED37_FITTED_CONSTANT_SWEEP.md` row Q **was** updated on this
note's authority (by SEED-100, in place); no further sweep edit is owed.

---

## 0. What exp47 actually did, and what was wrong with it

`exp47` is not a fitting experiment — its docstring correctly calls it a
certificate replay — but five of its nineteen checks are *decimal comparisons*,
which is the same failure in a better disguise. Verbatim:

```
check("C3: c1* = 0.7532960...", abs(c1 - sp.Float("0.7532960")) < 1e-7)
check("C4: 2-1/c1* = 0.6725007...", ...)
check("C5: 2c1*-1  = 0.5065921...", ...)
check("C6: (3-1/c1*)/2 = 0.8362503...", ...)
```

and two more that sample rather than prove:

```
C1: "v* + l^2 T v* is constant in s (Euler-Lagrange, exact sample pts)"
     — checked at four rational points s, for three values of l.
B6: "Hd-F and H have the same sign at test points"
     — three rational λ.
D1: Lemma 3.2 on 30 random exact-rational instances.
```

A comparison of a computed float against seven quoted digits certifies
nothing about either side: it is an agreement of two numerals, and it hides
the only structural question there is — *where do these numbers come from,
and what is the next term?* CLAUDE.md's rule applies exactly: the derivable
quantity behind the measurement existed and is shorter than the run. Below,
C1 and C2 become a two-line ODE argument, C3–C7 become closed forms with an
exact series and an exact radius of convergence, B5–B6 become an algebraic
identity, and the 0.0058 gap between the headline $2/3$ and the headline
$0.6725$ — nowhere explained in `KAPPA.md` — becomes a series in $\zeta(2n)$.

Not touched here: D1 (an inequality, not a constant) — see §7 for the
`PROVE` item it leaves.

Distinct from tonight's siblings: SEED-05 took `RATIONAL_CIRCLE_ATLAS`'s
median, SEED-08 took `THE_MACHINE`/$\Gamma_0(N)$'s $\log 3$. This note takes
the κ family and nothing else.

---

## 1. The variational problem, stated exactly

Let $I=[-\tfrac12,\tfrac12]$ and let $T:L^2(I)\to L^2(I)$ be the symmetric
integral operator

$$(Tv)(s)=\int_I |s-s'|\,v(s')\,ds' .$$

For $\lambda>0$ define, on $v\in L^2(I)$ with $\int v\neq0$,

$$c_\lambda(v)\;=\;\frac{\lambda\big(\int_I v\big)^2}{\langle v,v\rangle+\lambda^2\langle Tv,v\rangle},
\qquad c_\lambda \;=\;\sup_v c_\lambda(v).$$

(This is the functional coded in exp47 lines 90–94, i.e. the manuscript's
window functional; $v\equiv 1$ gives the flat window.)

**Lemma 1 (resolvent form).** Put $A_\lambda=I+\lambda^2T$, positive definite
for the range of $\lambda$ considered. Then the supremum is attained at
$v^\*=A_\lambda^{-1}\mathbf 1$ (up to scale) and

$$\boxed{\;c_\lambda=\lambda\,\big\langle A_\lambda^{-1}\mathbf 1,\mathbf 1\big\rangle
=\lambda\,G(-\lambda^2),\qquad G(z):=\big\langle (I-zT)^{-1}\mathbf 1,\mathbf 1\big\rangle.\;}$$

*Proof.* $c_\lambda(v)=\lambda\langle v,\mathbf 1\rangle^2/\langle A_\lambda v,v\rangle$;
by Cauchy–Schwarz in the inner product $\langle A_\lambda\cdot,\cdot\rangle$,
$\langle v,\mathbf 1\rangle^2=\langle A_\lambda v,A_\lambda^{-1}\mathbf 1\rangle^2\le
\langle A_\lambda v,v\rangle\langle \mathbf 1,A_\lambda^{-1}\mathbf 1\rangle$,
with equality iff $v\parallel A_\lambda^{-1}\mathbf 1$. $\square$

So there is exactly one analytic object in play: the diagonal resolvent matrix
element of $T$ at the constant vector. Everything else is arithmetic on it.
This is the Riemann move — stop optimizing and look at where $G$ fails to be
holomorphic.

## 2. $G$ in closed form: the singularities of a second-order ODE

The kernel $|s-s'|$ is the Green's-type kernel of $\tfrac12\,d^2/ds^2$:

$$(Tf)''(s)=2f(s),\qquad (Tf)'(s)=\int_I \operatorname{sgn}(s-s')f(s')\,ds'. \tag{2.1}$$

**Proposition 2.** With $\theta:=\lambda/\sqrt2$,

$$v^\*(s)=\cos(\sqrt2\,\lambda s),\qquad
(I+\lambda^2T)v^\*=\cos\theta+\theta\sin\theta\ \ (\text{constant in } s),$$

$$\boxed{\;c_\lambda=\frac{\sqrt2\,\sin\theta}{\cos\theta+\theta\sin\theta}
=\frac{\sqrt2\,\tan\theta}{1+\theta\tan\theta},\qquad \theta=\frac{\lambda}{\sqrt2}. \;}$$

*Proof.* $A_\lambda v=\mu\mathbf 1$ with $\mu$ constant; apply $d^2/ds^2$ and
(2.1): $v''+2\lambda^2v=0$, so $v=A\cos(\sqrt2\lambda s)+B\sin(\sqrt2\lambda s)$,
and $B=0$ because the problem is even. Take $A=1$, $c:=\sqrt2\lambda$. By
(2.1), $Tv=a-\frac{2}{c^2}\cos(cs)$ for a constant $a$ (the linear term is
excluded by evenness), and

$$(Tv)(\tfrac12)=\int_I(\tfrac12-s')\cos(cs')ds'=\tfrac12\cdot\frac{2\sin(c/2)}{c}
=\frac{\sin\theta}{\sqrt2\,\lambda},$$

the $\int s'\cos(cs')ds'$ term vanishing by oddness. Hence
$a=\frac{\sin\theta}{\sqrt2\lambda}+\frac{\cos\theta}{\lambda^{2}}$ and
$v+\lambda^2Tv=\lambda^2a=\cos\theta+\theta\sin\theta=:\mu$, constant — which
is the Euler–Lagrange identity **exactly**, replacing exp47's C1 sampling.
Finally $\int_I v=\frac{2\sin(c/2)}{c}=\frac{\sqrt2\sin\theta}{\lambda}$ and
Lemma 1 gives $c_\lambda=\lambda\int v/\mu$ as stated. $\square$

Equivalently, in the variable $z$ of Lemma 1 (so $\theta=\sqrt{-z/2}$; both
functions below are even in $\theta$, hence entire in $z$ of order $1/2$):

$$G(z)=\frac{N(z)}{D(z)},\qquad N(z)=\frac{\sin\theta}{\theta},
\qquad D(z)=\cos\theta+\theta\sin\theta. \tag{2.2}$$

**The singularities speak.**

* **Poles of $G$** ($D=0$): $\cot\theta=-\theta$, i.e. $\theta_n\in((n-\tfrac12)\pi,n\pi)$,
  $\theta_1=2.79838\ldots$, $\theta_n=n\pi-\frac1{n\pi}+O(n^{-3})$. These are
  the reciprocal eigenvalues of $T$ in its even sector: $z_n=-2\theta_n^2$,
  i.e. $\operatorname{spec}(T)\ni -1/(2\theta_n^2)$. The nearest one to the
  origin gives the **exact radius of convergence of the $c_\lambda$ Taylor
  series: $\lambda<\sqrt2\,\theta_1=3.95749\ldots$**
* **Zeros of $G$** ($\sin\theta=0$): $\lambda=\sqrt2\,\pi n$. These are the
  poles of $1/c_\lambda$, hence of the κ constants themselves, and the nearest
  is $\lambda=\sqrt2\pi=4.44288\ldots$

**Corollary 3 (the inverse, exp47's C7, proved).**

$$\frac1{c_\lambda}=\frac{\cos\theta+\theta\sin\theta}{\sqrt2\sin\theta}
=\frac{\lambda}{2}+\frac{1}{\sqrt2}\cot\!\frac{\lambda}{\sqrt2}. \tag{2.3}$$

At $\lambda=1$: $1/c_1^\*=\tfrac12+\tfrac1{\sqrt2}\cot\tfrac1{\sqrt2}$ — the
Montgomery–Taylor constant $1.3274992\ldots$, now an identity rather than a
digit match.

## 3. The κ constants, exactly

`KAPPA.md` §3 Theorem D quotes $2-1/c_1^\*=0.67250\ldots$, the same for simple
zeros, and $(3-1/c_1^\*)/2=0.83625\ldots$. By (2.3), with no decimals anywhere:

$$\boxed{\ \kappa_{\text{on-line}}=\kappa_{\text{simple}}=2-\frac1{c^\*_1}
=\frac32-\frac{1}{\sqrt2}\cot\frac{1}{\sqrt2}\ }$$

$$\boxed{\ \kappa_{\text{distinct}}=\frac{3-1/c_1^\*}{2}=\frac54-\frac{1}{2\sqrt2}\cot\frac1{\sqrt2}\ }$$

$$c_1^\*=\Big(\tfrac12+\tfrac1{\sqrt2}\cot\tfrac1{\sqrt2}\Big)^{-1},\qquad
2c_1^\*-1=\frac{2\sqrt2\tan\frac1{\sqrt2}}{1+\frac1{\sqrt2}\tan\frac1{\sqrt2}}-1 .$$

The third constant is not independent: for **any** value $x$ of the window
functional the distinct-zero constant is $(1+\kappa)/2$ with $\kappa=2-1/x$,
i.e. $(3-1/x)/2$. So Theorem D's $0.83625$ is *forced* by its $0.67250$; it
carries no additional analytic content, and $H_d=(1+H)/2$ in Theorem C is the
same identity with $x=F(\lambda)$.

**Poles as a series for the record constant.** Mittag-Leffler for $\cot$,
$\cot w=\frac1w+\sum_{n\ge1}\frac{2w}{w^2-n^2\pi^2}$, applied to (2.3):

$$\frac{1}{c_\lambda}=\frac1\lambda+\frac\lambda2+\sum_{n\ge1}\frac{2\lambda}{\lambda^2-2n^2\pi^2},
\qquad\text{residue }1\text{ at each }\lambda=\pm\sqrt2\,\pi n, \tag{3.1}$$

and therefore, at the physical bandwidth $\lambda=1$,

$$\boxed{\ \kappa_{\text{on-line}}=\frac12+\sum_{n\ge1}\frac{2}{2\pi^2n^2-1}=0.6725007\ldots\ }$$

Every term is the residue of the resolvent at one pole $\lambda=\sqrt2\pi n$;
the record constant is literally a sum over the spectrum. The tail is
$\sum_{n>M}\frac{2}{2\pi^2n^2-1}=\frac1{\pi^2M}+O(M^{-2})$, so the series is
$O(1/M)$ — slow, which is why the closed form (2.3) is the right object and
the $\zeta$-series of §4 is the right *expansion*.

## 4. The flat window is the Bernoulli truncation: the $2/3\to0.6725$ gap derived

Theorem C's flat-window value is $F(\lambda)=\lambda/(1+\lambda^2/3)$ and
$H(\lambda)=2-\frac1\lambda-\frac\lambda3$. First an identity that `KAPPA.md`
never states:

$$H(\lambda)=2-\frac{1}{F(\lambda)}. \tag{4.1}$$

So the flat and optimal windows produce the *same* functional shape
$2-1/x$, evaluated at $F(\lambda)$ and at $c_\lambda$ respectively. Expanding
Proposition 2,

$$c_\lambda=\lambda-\frac{\lambda^3}{3}+\frac{7\lambda^5}{60}-\cdots,\qquad
F(\lambda)=\lambda-\frac{\lambda^3}{3}+\frac{\lambda^5}{9}-\cdots,$$

so **$F$ is the $[1/2]$ Padé approximant of $c_\lambda$ at $0$**, and
$c_\lambda-F(\lambda)=\frac{\lambda^5}{180}+O(\lambda^7)$. Better, work with
the inverses, where the statement is exact and closed:

**Theorem 4 (the κ defect).** Let
$\Delta(\lambda):=\dfrac1{F(\lambda)}-\dfrac1{c_\lambda}
=\kappa_{\rm opt}(\lambda)-H(\lambda)$. Then, from (2.3) and
$\cot w=\frac1w-\sum_{n\ge1}\frac{2^{2n}|B_{2n}|}{(2n)!}w^{2n-1}$,

$$\boxed{\ \Delta(\lambda)=\sum_{n\ge2}\frac{2^{n}\,|B_{2n}|}{(2n)!}\,\lambda^{2n-1}
=\frac{2}{\lambda}\sum_{n\ge2}\zeta(2n)\Big(\frac{\lambda}{\sqrt2\,\pi}\Big)^{2n}
=\frac{2}{\lambda}\sum_{m\ge1}\frac{y_m^2}{1-y_m},\quad y_m=\frac{\lambda^2}{2\pi^2m^2}. \ }$$

*Proof.* $\frac1{F}=\frac1\lambda+\frac\lambda3$ and
$\frac1{c_\lambda}=\frac\lambda2+\frac1{\sqrt2}\cot\frac\lambda{\sqrt2}$. In
the cotangent series with $w=\lambda/\sqrt2$, the $n=0$ term $1/w$ contributes
$1/\lambda$ and the $n=1$ term contributes $\lambda/6$; together with
$\lambda/2$ these reproduce $\frac1\lambda+\frac\lambda3$ exactly, so
$\Delta$ is the $n\ge2$ tail, with
$\frac{1}{\sqrt2}\frac{2^{2n}|B_{2n}|}{(2n)!}\big(\frac{\lambda}{\sqrt2}\big)^{2n-1}
=\frac{2^n|B_{2n}|}{(2n)!}\lambda^{2n-1}$. Euler's
$|B_{2n}|/(2n)!=2\zeta(2n)/(2\pi)^{2n}$ gives the middle form since
$2^n\pi^{2n}=(\sqrt2\pi)^{2n}$; expanding $\zeta(2n)=\sum_m m^{-2n}$ and
summing the geometric series in $n\ge2$ gives the last. $\square$

Consequences, all exact:

* **$F$ is not an approximation to $c$; it is the $n\le1$ Bernoulli section of
  the same generating function $\cot$.** The flat window sees $\zeta(2)$ and
  nothing beyond; the optimal window sees all of $\zeta(4),\zeta(6),\dots$
  This is the entire content of "0.6725 beats 2/3".
* First terms: $\Delta(\lambda)=\frac{\lambda^3}{180}+\frac{\lambda^5}{3780}
  +\frac{\lambda^7}{75600}+\cdots$, so at the physical $\lambda=1$
  $$\kappa_{\rm opt}(1)-\tfrac23=\Delta(1)=\tfrac56-\tfrac1{\sqrt2}\cot\tfrac1{\sqrt2}
  =\tfrac1{180}+\tfrac1{3780}+\tfrac1{75600}+\cdots=~~0.0058338~~\,0.0058340\ldots$$
  *(numeral corrected in place, SEED-102, 2026-08-14, Rule K1: the note's own
  $1/c_1^\*=1.3274992\ldots$ and $\kappa_{\rm on-line}=0.6725007\ldots$ give
  $\Delta(1)=4/3-1/c_1^\*=0.6725007-0.6666667=0.0058340$, and the series sums
  to $0.00555556+0.00026455+0.00001323+0.00000067+0.00000003=0.00583404$. The
  struck value was internally inconsistent with both. Nothing else changes: the
  first term is still $95.2\%$ of the gap and two terms still give $0.005820$.)*
  The **first term alone, $1/180=0.005556$, explains 95% of the celebrated
  gap**, and two terms give $0.005820$ — four correct digits of a constant the
  manuscript and `KAPPA.md` quote only as a decimal difference.
* **Explicit scale dependence** (the thing CLAUDE.md §Corollary demands):
  $\Delta$ converges for $|\lambda|<\sqrt2\pi$, the nearest pole of $\cot$;
  successive terms decay by the factor $(\lambda/\sqrt2\pi)^2$, which at
  $\lambda=1$ is $1/(2\pi^2)=0.0506606$. Truncating the window's Bernoulli
  order at $M$ costs exactly
  $$\Delta(\lambda)-\sum_{n=2}^{M}(\cdot)=\frac{2\zeta(2M+2)}{\lambda}\Big(\frac{\lambda}{\sqrt2\pi}\Big)^{2M+2}
  \big(1+O((\lambda/\sqrt2\pi)^2)\big).$$
  A constant quoted without this factor looks like knowledge; it is one term of
  a geometric series whose ratio is set by a pole.

## 5. The Theorem C algebra, as identities (replacing exp47 B5, B6)

`exp47` checks the threshold $\lambda\ge3-\sqrt6$ by root-solving and the
sign relation by three sample points. Both are one line.

* $H(\lambda)=0\iff \frac1\lambda+\frac\lambda3=2\iff\lambda^2-6\lambda+3=0
  \iff\lambda=3\pm\sqrt6$; the root in $(0,1]$ is $3-\sqrt6=0.5505102\ldots$
* With $x$ any window value and $H=2-1/x$, $H_d=(1+H)/2$:
  $$\boxed{\;H_d-x=\frac{(2x-1)(1-x)}{2x}\;}$$
  since $H_d-x=\frac{3-1/x}{2}-x=-\frac{2x^2-3x+1}{2x}$. For $0<x<1$ this is
  $\ge0$ **iff $x\ge\frac12$ iff $H\ge0$** — exp47's B6 as an identity, with
  the sign structure visible instead of sampled, and valid for the optimal
  window too (put $x=c_\lambda$).
* Hence the optimal-window crossover $\lambda^\*$ (where
  $\kappa_{\rm distinct}$ switches from $(3-1/c_\lambda)/2$ to $c_\lambda$)
  solves $c_\lambda=\frac12$, i.e. $\frac1{F(\lambda)}=2+\Delta(\lambda)$;
  by Theorem 4 and one Newton step off the flat root,
  $$\lambda^\*=(3-\sqrt6)-\frac{\Delta(3-\sqrt6)}{\frac{1}{(3-\sqrt6)^2}-\frac13}+O(\Delta^2)
   =0.5501934\ldots$$
  (the flat threshold $3-\sqrt6$ shifted by $-3.17\times10^{-4}$). The shift is
  *derived*, with its own error term, not fitted.

## 6. What does not yield to this, and what is still exact about it

Honest boundary, per mandate item 3.

1. **The $T$-dependence.** Theorems A–D carry an error
   $c(\lambda)\log\log T/\log T$. Nothing above touches it: this note derives
   the exact $\lambda$-profile of the main term and its singularities, not the
   analytic error terms (Prop 4.2, Lemma 5.4, Prop 5.6/5.7 of the manuscript),
   which `KAPPA.md` §8 also records as unverified here. The $\lambda$-profile
   is meromorphic with nearest singularity $\sqrt2\pi$; the $T$-profile remains
   an input.
2. **The PairCeiling constant $0.68185$** (`KAPPA.md` §7.2) is a certified
   *enclosure* from a kernel-checked integer computation, not a resolvent
   value; it is not derivable by the above and should keep its enclosure
   status. What *is* derivable in its neighbourhood is the exponent: any
   certificate whose window functional is of the form $\lambda G(-\lambda^2)$
   has all its $\lambda$-dependence controlled by the same two spectra
   ($\sqrt2\theta_n$, $\sqrt2\pi n$), so the distance from $0.6725$ to any such
   ceiling is $O(\lambda^3/180)$-sized by Theorem 4 — the "shape axis is
   saturated" claim of §7.2 is a statement that the $n\ge2$ zeta tail is
   already fully harvested, and Theorem 4 quantifies it.
3. **Lemma 3.2** (exp47 D1) is an inequality, not a constant, so it is outside
   this note's remit; but 30 random rational instances is not a proof. The
   completion-of-square route
   $\|R\|_F^2\ge2\langle R,S\rangle-\|S\|_F^2$ with
   $S=\frac c2\Pi_{\operatorname{ran}P}+c\,\Pi_{+}(Q)$ reproduces the stated
   right-hand side and attains equality at exp47's D2 configuration, but the
   cross term $c\langle Q,\Pi_{\operatorname{ran}P}\rangle$ is not sign-definite;
   closing that is a genuine `PROVE` item (§7).

## 7. Queue

* `PROVE` — Lemma 3.2 (`rank–trace via von Neumann`) with the cross-term gap
  of §6.3 closed; retire exp47's D1 random-instance block.
* `PROVE` — the same resolvent analysis for the $\xi'$ constants
  ($0.85838$ flat, $0.86864$ quartic window, `KAPPA.md` §2): the quartic window
  should be the $M=2$ Bernoulli section, and Theorem 4 predicts its gap from
  the flat one to be $\Delta_2$-sized. If it is, the two quoted $\xi'$ decimals
  collapse to one closed form as well.
* `DEMONSTRATE` (last) — nothing. There is no computation this note wants run.

## 8. Appendix: what is deleted, and the deletion is the trapdoor

Two priming lenses, discharged rather than decorated.

*Sphoṭa.* The manuscript presents $2/3$ and $0.6725$ as two results; the
audit trail treats them as two numbers to be matched to seven digits each.
Theorem 4 says they are one meaning-bearing unit: a single function
$\lambda\mapsto2-1/(\lambda G(-\lambda^2))$, read at two truncation depths of
one Bernoulli/zeta series. The numeral $0.6725007$ is not the result; the
result is $\frac32-\frac1{\sqrt2}\cot\frac1{\sqrt2}$, and its digits are a
shadow that any of the three representations (closed form, pole sum (3.1),
zeta series of Theorem 4) casts on demand.

*The deleted information as trapdoor.* Passing from $c_\lambda$ to
$F(\lambda)$ is a quotient: it deletes every $\zeta(2n)$, $n\ge2$ — equivalently
every pole $\lambda=\sqrt2\pi n$ with $n\ge1$ beyond the residue already
absorbed into $\lambda/3$. The deletion is invisible in the value ($95\%$ of
the surviving gap sits in the single term $\lambda^3/180$), which is precisely
why a decimal comparison cannot detect it and why the flat window looks nearly
optimal. It is recoverable only by knowing the generating function, not by
knowing the number: the digits of $2/3$ and $0.6725$ contain no trace of where
the difference came from. That asymmetry — cheap to delete, impossible to
invert from the residue alone — is the same trapdoor shape this corpus keeps
meeting when it passes to $\mathbb Z/N$, and it is the reason CLAUDE.md's rule
about constants without their scale dependence is not a style preference.

---

### Provenance

`code/exp47_kappa_constants.py` read as text (never executed);
`notes/KAPPA.md` §§2,3,7,8 read. No Python run, no file in `code/` touched.
All numerics quoted above (e.g. $0.0058338$, $0.5501934$) are hand
evaluations of closed forms proved here, not measurements; each is the
truncation of an explicitly bounded series whose ratio is stated.
