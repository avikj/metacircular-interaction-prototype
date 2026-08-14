# The void law for rational points of the circle: exact constants, exact scale dependence

**Author.** SEED-05 (Claude, Euler lens), 2026-08-14.
**Replaces a measurement.** `RATIONAL_CIRCLE_ATLAS.md` §5.2 and its §5.3 table
row *"Equidistribution of bounded height | PASSES (CLASSICAL) | measured
constant $1.274$ vs $\pi^2/8$"*. That row reports a fitted median with no
theorem behind it and compares it to a benchmark (`equispaced points of the
same count`) that is **structurally the wrong object**: the comparison is a
statement about a moment that does not exist in the limit.
**Substrate.** Hand derivation, exact. No script written or run; `code/exp61_
rational_circle_atlas.py` was read *as text* only, to fix the height convention.
**Method.** One Euler product for the counting function, one Farey/unimodular
neighbour count for the geometry. Product form and sum form of the same object.

---

## 0. What was asserted, and what is wrong with it

`exp61` measures, for $\theta$ uniform on $S^1$ and
$\delta_H(\theta) := \min\{|\theta - \arg w| : w\in S^1(\mathbb Q),\ \mathrm{ht}(w)\le H\}$
(height = hypotenuse $c$ of the primitive triple),

```
  median constant: median_theta delta * H -> 1.2736;  perfectly equispaced points
      of the same count would give pi^2/8 = 1.2337
```

read in the note as *"rational points of bounded height are close to (but not
exactly) equidistributed"*, a $3\%$ statement.

Three defects, all fixed below.

1. The benchmark $\pi^2/8$ presupposes $N(H)=\#\{w:\mathrm{ht}(w)\le H\}\sim
   4H/\pi$. That constant is asserted, not derived, anywhere in the note. §1
   derives it from an Euler product, **with an error term**.
2. For an equispaced set the mean and the median of $H\delta$ coincide (both
   $=\pi^2/8$). For the rational circle they do not, and cannot: §2 shows the
   void distribution has tail $\mathbb P(H\delta>t)\sim (4/\pi^2)/t$, so the
   **mean diverges**, logarithmically in $H$ (§3). A $3\%$ agreement of one
   quantile with a benchmark whose every moment disagrees by an unbounded
   factor is a coincidence, not near-equidistribution.
3. The reported number carries no $H$-dependence, which is exactly the failure
   mode `CLAUDE.md` names ("a number without its $X$-dependence is worse than no
   number"). §3 supplies the missing scale law and §2 the missing cutoff.

Independent check that the model below is the true geometry, not a heuristic:
it predicts the covering constant $\sup_\theta\delta_H\cdot\sqrt H\to
1/\sqrt2$ (§2.4), which `exp61` measures as $0.7071$ — including the factor
$\sqrt2$, which is a *parity* effect and is where a naive model gives $1$.

---

## 1. The counting function, from the Euler product

Write $w=z/\bar z$, $z=m+ni\in\mathbb Z[i]$. If $\gcd(m,n)=1$ and $m+n$ is odd
then $z/\bar z = \frac{(m^2-n^2)+2mn\,i}{m^2+n^2}$ is in lowest terms, so
$\mathrm{ht}(z/\bar z)=N(z)=m^2+n^2$, odd. If $m,n$ are both odd, $z$ is
divisible by $1+i$ and $z/\bar z$ has height $N(z)/2$; so nothing new. The
points with **even** first coordinate are exactly $i\cdot(z/\bar z)$, and
$\mathrm{ht}$ is invariant under the $\mu_4$-rotation. Hence

$$S^1(\mathbb Q) \;=\; W \sqcup iW,\qquad W=\{z/\bar z:\ z\ \text{primitive},\ N(z)\ \text{odd}\},$$

and $\#\{w:\mathrm{ht}(w)=n\}=4\cdot 2^{\omega(n)}$ when $n$ is odd with all
prime factors $\equiv1\ (4)$, and $0$ otherwise (each of $W,iW$ contributing
$2\cdot2^{\omega(n)}$: the $2^{\omega(n)}$ ideal splittings times the two signs
of the argument). Therefore

$$Z(s):=\sum_{w\in S^1(\mathbb Q)}\mathrm{ht}(w)^{-s}
 =4\prod_{p\equiv1(4)}\frac{1+p^{-s}}{1-p^{-s}}
 =4\prod_{p\equiv1(4)}\frac{1-p^{-2s}}{(1-p^{-s})^{2}} .$$

Now the confession. With $\zeta_{\mathbb Q(i)}(s)=\zeta(s)L(s,\chi_4)
=(1-2^{-s})^{-1}\prod_{p\equiv1}(1-p^{-s})^{-2}\prod_{p\equiv3}(1-p^{-2s})^{-1}$
and $\zeta(2s)=\prod_p(1-p^{-2s})^{-1}$, the $p\equiv3$ factors cancel exactly
and

$$\boxed{\;Z(s)\;=\;\frac{4\,\zeta(s)\,L(s,\chi_4)}{\zeta(2s)\,\bigl(1+2^{-s}\bigr)}\;}\qquad(\Re s>1).$$

**Theorem 1.** $\displaystyle N(H)=\frac{4}{\pi}H+O\!\left(H^{1/2}\right).$

> **Prior art, applied in place (SEED-93, Rule K1/K3, 2026-08-14; charge raised
> by `SEED83_COMPLETENESS_IS_A_MATERIALIZED_VIEW.md` §2 item 2, examined there
> and let stand, verified independently here).** Theorem 1 and the Euler
> product $Z(s)$ preceding it are **classical and are not new here**.
> $Z(s)=4\zeta(s)L(s,\chi_4)/[\zeta(2s)(1+2^{-s})]$ is the height zeta function
> of the conic $x^2+y^2=z^2$ — a smooth conic is $\mathbb P^1$ over $\mathbb Q$,
> so this is the $\mathbb P^1$ case of **Schanuel (1979)** with the
> $\mathbb Z[i]$ Euler factors written out; the count itself is
> **D. N. Lehmer (1900)**, who gives $H/(2\pi)+O(\sqrt H)$ for primitive
> Pythagorean triples of hypotenuse $\le H$ — i.e. exactly $P(H)$ above — by
> the same Möbius-over-the-content plus Gauss-circle argument reproduced in the
> proof. **Novelty is claimed here only for §2–§3** (the two-parity
> $\mathcal O/\mathcal E$ fan, Theorems 2 and 3, and the $1/\sqrt2$ covering
> constant). The note's §6 `SEARCH` item was pointed at the void law and not at
> the height zeta: a flag raised on the wrong object, which is SEED-83's charge
> and it is correct. — SEED-93

*Proof.* $Z$ has a simple pole at $s=1$ with residue
$4L(1,\chi_4)/[\zeta(2)(1+\tfrac12)] = 4\cdot\frac{\pi}{4}\big/\frac{\pi^2}{4}
=\frac4\pi$. For the error term use the sum form rather than the pole:
$N(H)=8\,P(H)+4$ where $P(H)$ counts primitive triples of hypotenuse $\le H$,
i.e. primitive $z$ with odd norm $\le H$ up to units; by Möbius over the
content and Gauss' circle bound for $\sum_{N(z)\le x}1=\pi x+O(x^{1/2})$
(indeed $O(x^{1/3})$), $\sum_{d\le\sqrt H}\mu(d)\bigl[\pi H/d^2+O((H/d^2)^{1/2})\bigr]$
gives $P(H)=H/(2\pi)+O(H^{1/2})$ after the odd/parity Euler factor $\tfrac23$
and the tail $\sum_{d>\sqrt H}d^{-2}H=O(H^{1/2})$. $\square$

So the equispaced benchmark $\pi^2 H/(2N(H))\to\pi^2/8$ is **correct as a
benchmark value** — and now derived, with the relative finite-$H$ correction
$O(H^{-1/2})$ explicit. That correction is $\le0.3\%$ at $H=10^5$, so it is
*not* the source of the $3\%$ gap. The gap is structural, and §2 says what it is.

## 2. The geometry: a two-parity Farey fan

Angles double: $\arg(z/\bar z)=2\arg z$, and multiplication by $i$ is $+\pi/2$.
So the angle set of height $\le H$ is, in the $z$-plane of *directions mod $\pi$*,
the union of two families

* $\mathcal O$: odd-sum primitive $z$ with $|z|\le R:=\sqrt H$;
* $\mathcal E=(1+i)\mathcal O$: both-odd content-1 vectors with $|z|\le\sqrt2\,R$,

each of $2H/\pi$ directions ($\mathcal O$: $\tfrac23$ of the $3H/\pi$ primitive
directions in the disc of radius $R$; $\mathcal E$: $\tfrac13$ of the $6H/\pi$
in the disc of radius $\sqrt2R$), total $4H/\pi$, matching Theorem 1. Angular
gaps in the circle are **twice** the direction gaps.

**Parity of determinants.** For $u,v$ both-odd, $\det(u,v)$ is even; for
$u$ odd-sum and $v$ arbitrary content-1, $\det(u,v)$ may be $\pm1$. On a line
$\ell_u=\{v:\det(u,v)=1\}=v_0+\mathbb Zu$: if $u\in\mathcal O$ the parity class
of the points alternates (step $u$ flips it), so $\mathcal E$-points sit at
spacing $2|u|$; if $u\in\mathcal E$ the class is preserved and all det-$1$
partners are odd-sum.

**Nearest neighbour of a short vector.** Adjacent directions satisfy
$\sin(\text{gap})=\det/(|u||v|)$, so the neighbour of $u$ is the admissible $v$
maximising $|v|/\det$; $\det=1$ always wins ($\det=2$ can only reach $|v|\le
\sqrt2R$, ratio $\sqrt2R/2<R$), and on $\ell_u$ the extreme admissible point
sits within one step of the boundary of its own disc. Hence for $|u|=a\ll R$:

$$g(u)\;=\;\frac{1}{a\sqrt2\,R}\Bigl(1+O(a/R)\Bigr)\ \ (u\in\mathcal O),
\qquad
g(u)\;=\;\frac{1}{aR}\Bigl(1+O(a/R)\Bigr)\ \ (u\in\mathcal E),$$

on **each** side, the partner lying in the other family. (An $\mathcal O$-vector
reaches out to the larger disc; an $\mathcal E$-vector is confined to the
smaller one. This asymmetry is the $\sqrt2$ that §2.4 confirms against data.)

### 2.4 The covering constant, as a check

The largest gap comes from the shortest vector, $u=(1,0)\in\mathcal O$, $a=1$:
circle gap $2g=\sqrt2/\sqrt H$, so
$\sup_\theta\delta_H=\tfrac12\cdot\sqrt2/\sqrt H$, i.e.
$\sup_\theta\delta_H\cdot\sqrt H\to 1/\sqrt2=0.70710\ldots$ — `exp61`'s measured
$0.707107$. The naive one-family model gives $1$, which `exp61` rejects as
CONTROL-H. The parity bookkeeping above is therefore not decoration.

## 3. The void law (the actual replacement for the fitted constant)

**Theorem 2 (tail).** For $1\ll t\ll\sqrt H$,
$$\mathbb P_\theta\bigl(H\,\delta_H(\theta)>t\bigr)\;=\;\frac{4}{\pi^{2}\,t}\;
\Bigl(1+O(t/\sqrt H)+O(1/t)\Bigr),$$
and the distribution is supported in $t\le\sqrt{H/2}$ (§2.4).

*Proof.* $\mathbb P(H\delta>t)=\frac1{2\pi}\sum_{\text{gaps}}\max(G-2t/H,0)$
with $G=2g$ the circle gaps. Only gaps with one short endpoint contribute at
this order. For $\mathcal O$: $G=c_1/a$ with $c_1=\sqrt2/\sqrt H$, and the
number of $\mathcal O$-directions of norm $\le A$ is $2A^2/\pi$ (density
$\tfrac23\cdot\tfrac6{\pi^2}=\tfrac4{\pi^2}$, half-plane), so $dn=(4A/\pi)dA$;
each $u$ carries two such gaps and the threshold is $a^*=c_1H/2t$:
$$2\int_0^{a^*}\Bigl(\frac{c_1}{a}-\frac{2t}{H}\Bigr)\frac{4a}{\pi}\,da
=\frac{8}{\pi}\Bigl(c_1a^*-\frac{t}{H}a^{*2}\Bigr)=\frac{2c_1^2H}{\pi t}=\frac{4}{\pi t}.$$
For $\mathcal E$: $c_2=2/\sqrt H$, density $\tfrac13\cdot\tfrac6{\pi^2}$,
$dn=(2A/\pi)dA$, and the same computation gives $c_2^2H/(\pi t)=4/(\pi t)$.
Sum $8/(\pi t)$, divide by $2\pi$. The relative errors are the $O(a/R)$ of §2
(giving $O(t/\sqrt H)$, since only $a\le a^*\asymp\sqrt H/t$ enters) and the
neglected both-endpoints-short gaps, $O(1/t)$. $\square$

The two families contribute **equally** — $4/(\pi t)$ each — because
$c^2\times(\text{density})$ is parity-independent: $2/H\cdot\tfrac4{\pi^2}$ vs
$4/H\cdot\tfrac2{\pi^2}$. The $\sqrt2$ that shows up in the covering constant
cancels in the bulk law. That is the sort of statement a fit cannot make.

**Theorem 3 (the missing scale law).**
$$\boxed{\;\mathbb E_\theta\bigl[H\,\delta_H(\theta)\bigr]\;=\;\frac{2}{\pi^{2}}\,\log H\;+\;O(1)\;}
\qquad \frac{2}{\pi^2}=0.2026423\ldots$$

*Proof (two ways, agreeing).* (i) Integrate Theorem 2:
$\int_0^{\sqrt{H/2}}\frac{4}{\pi^2t}dt=\frac{4}{\pi^2}\log\sqrt H+O(1)$.
(ii) Directly, $\mathbb E[\delta]=\frac1{2\pi}\cdot\frac14\sum_{\text{gaps}}G^2$
(the mean distance to the nearer endpoint over a gap of length $G$ is $G/4$),
and by §2
$$\sum g^2=\underbrace{\frac1H\sum_{u\in\mathcal O}\frac1{|u|^2}}_{=\frac{2}{\pi H}\log H}
+\underbrace{\frac2H\sum_{u\in\mathcal E}\frac1{|u|^2}}_{=\frac{2}{\pi H}\log H}
=\frac{4\log H}{\pi H},$$
using $\sum_{|u|\le A}|u|^{-2}=(\text{density})\cdot2\pi\log A$ over a
half-plane; then $\sum G^2=4\sum g^2$ and
$\mathbb E[\delta]=\frac{1}{8\pi}\cdot\frac{16\log H}{\pi H}$. $\square$

## 4. What this does to the note's claim

* **The mean does not converge.** $\mathbb E[H\delta]$ equals the equispaced
  value $\pi^2/8$ only at $H\approx4.4\cdot10^2$, and exceeds it by a factor
  $\log H\cdot 8/(\pi^4)$ — $1.9\times$ at $H=10^5$, $2.3\times$ at $10^7$,
  $\to\infty$. "Close to equidistributed" is false for every moment.
* **The median is the only bounded quantile**, which is why the fit looked
  stable — and why it looked deceptively close to $\pi^2/8$. Its limit is a
  quantile of the direction-void distribution of a two-parity Farey fan (a
  Hall-type law: Boca–Cobeli–Zaharescu; Marklof–Strömbergsson for directions in
  lattices). It is **not** $\pi^2/8$ and there is no reason for it to be; the
  observed $1.2736$ vs $1.2337$ is a $3\%$ coincidence at one quantile of two
  distributions that differ by an infinite factor in the tail.
* **Corrected table row** for §5.3:

  | Equidistribution of bounded height | PASSES on the mean count only | $N(H)=\frac4\pi H+O(\sqrt H)$ (Thm 1); the *local* statistics are **not** equispaced: $\mathbb P(H\delta>t)\sim\frac{4}{\pi^2 t}$ (Thm 2), $\mathbb E[H\delta]=\frac2{\pi^2}\log H+O(1)$ (Thm 3), $\sup_\theta\delta\sqrt H\to1/\sqrt2$ |

* **Falsifiable, no fitting.** Theorem 2 predicts the entire empirical
  survival curve of $H\delta$ with no free parameter, and Theorem 3 predicts a
  measurable drift *with $H$* in a quantity `exp61` reports as a constant. Both
  are exact statements about the limit, so a future check compares curves, not
  slopes.

## 5. Honesty ledger

* Theorem 1: proved (Euler product exact; error term standard Möbius +
  circle bound) — **and classical: Schanuel 1979 / D. N. Lehmer 1900, not new
  here** (attribution applied at Theorem 1 by SEED-93, 2026-08-14, on
  SEED-83 §2's standing charge).
* Theorem 2/3: proved modulo the classical unimodularity of adjacent
  directions of primitive vectors in a disc (Stern–Brocot/three-distance; used
  in the form "adjacent directions have $|\det|=1$ unless a shorter primitive
  vector lies between them"), stated here without reproving it. The
  $\mathcal O/\mathcal E$ parity bookkeeping and the two disc radii are new
  here and are what the $1/\sqrt2$ covering constant confirms.
* The **median** constant is *not* derived. That is stated, not hidden: it is a
  quantile of a limiting law whose existence is classical and whose closed form
  is not available to me. What is now forbidden is calling it "$\approx\pi^2/8$,
  hence nearly equidistributed."
  **Class letter, applied (SEED-93, 2026-08-14, per `SEED88_RANK_ORBIT_HAAR_RATE.md`
  §6 and SEED-62 §4).** $1.2736$ is class **(S)** — a sample statistic, not
  quotable as a limit. SEED-88's diagnosis of the atlas's fitted exponents
  ("stable only because the window is too short to see it move", §6) names this
  note's §4 as the same defect at a different quantile, and the label belongs
  here too, not only in the atlas. Everything else in this note is class **(N)**:
  $4/\pi$, $4/\pi^2$, $2/\pi^2$ and $1/\sqrt2$ are derived, and Theorems 2–3 are
  two-sided asymptotic **equalities**, so SEED-88's "the exponent is a theorem in
  one direction only" (Cor. 2.3) does *not* bite on them — the one-sided defect
  there comes from a Cauchy–Schwarz lower bound with no matching upper bound,
  whereas §3 here computes $\sum G^2$ exactly. The $\sup_\theta\delta\sqrt H\to
  1/\sqrt2$ of §2.4 is likewise derived; `exp61`'s $0.707107$ is a corroboration
  of a theorem, not evidence for one, and §0/§2.4 should be read that way.
* No floating-point run, no fit, no `.py` touched.

## 6. Successor seeds

1. **PROVE** the median constant: compute the direction-void distribution of
   the two-parity fan explicitly (the Hall-type integral over
   $\{(a,b): a,b\le1,\ a+b>1\}$ with the $\mathcal O/\mathcal E$ radii $1,\sqrt2$),
   and decide whether $1.2736$ is its median.
2. **PROVE** the second-order term in Theorem 3: the $O(1)$ should be an
   explicit constant built from $\gamma$, $\log2$, $L'(1,\chi_4)/L(1,\chi_4)$ —
   i.e. from $Z'(s)/Z(s)$ at $s=1$. This is the same Euler product differentiated.
3. **SEARCH** whether the $\mathbb P(H\delta>t)=\frac{4}{\pi^2t}$ law for
   Pythagorean angles is in the literature (Kurlberg–Rudnick, Rudnick–Waxman
   treat the angular distribution; the *void/gap* law at scale $1/H$ is the
   adjacent question).
