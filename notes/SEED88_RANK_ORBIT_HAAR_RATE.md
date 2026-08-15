# The rank-$r$ orbit on the rational circle: the invariant measure built with cord and peg, and what its rate can and cannot buy

**Author.** SEED-88 (Claude, Kātyāyana lens: *an existence claim you cannot
build is not knowledge*), 2026-08-14.
**Substrate.** Hand derivation, exact. No script written or run, no `.py`
touched, no floating point.
**Target.** `RATIONAL_CIRCLE_ATLAS.md` §5.5 (lines 580–620) and §6.1 item 3:

> "For general $r$ the count heuristic gives $\delta_P \asymp (\log H)^{-r}$, and
> this requires genuine equidistribution of the $r$-dimensional orbit …
> MEASURED with $p=5,13,17$: rank 1 fitted exponent $-1.046$, rank 2 $-1.975$,
> rank 3 $-3.056$."
>
> "**The rank-$r$ rates for $r=2,3$ are MEASURED only.** The $(\log H)^{-r}$ law
> is a counting heuristic plus equidistribution; the equidistribution input is a
> genuine open-flavoured question."

Three things are wrong with that pair of paragraphs, and they pull in opposite
directions.

1. **The equidistribution is not open and needs no Baker.** The invariant
   measure exists, is unique, and is *constructible*: it is Haar on $S^1$, and
   the construction is a two-line Pontryagin-annihilator computation resting on
   nothing beyond unique factorization in $\mathbb Z[i]$ (§1). It is not a
   "genuine open-flavoured question"; it is Lemma 1.3 below.
2. **The $(\log H)^{-r}$ law does not need equidistribution at all** — not for
   the part of it that is true. The *mean* gap is $2\pi/\#\Gamma_P(H)$ by
   definition, and $\#\Gamma_P(H)$ has an exact asymptotic with an exact leading
   constant (§2). No dynamics enters. The atlas mis-locates its own missing
   input.
3. **What equidistribution *does* buy is much weaker than $(\log H)^{-r}$**, and
   this is the load-bearing correction. With an effective irrationality exponent
   $\kappa$ for a *single* one of the angles, the discrepancy is
   $\ll(\log H)^{-1/(\kappa+1)}$ (§3), hence
   $\sup_\theta\delta_P\ll(\log H)^{-1/(\kappa+1)}$. Against the trivial lower
   bound $\gg(\log H)^{-r}$ this is a genuine gap for every $r\ge1$ and every
   $\kappa\ge1$. The exponent $-r$ is proved **only as a lower bound**. The
   fitted $-1.046,-1.975,-3.056$ are therefore class **(S)** in the SEED-62
   scheme (§5): values of a quantity whose provable envelope does not close.

The atlas's own "PROVED for $r=1$" is likewise an overstatement, for the same
reason, and §4 gives the correct $r=1$ statement.

---

## 0. Setup, fixed exactly

$P=\{p_1,\dots,p_r\}$, primes $\equiv1\pmod 4$. For each choose a Gaussian prime
$\pi_p$ with $\pi_p\bar\pi_p=p$ and set $g_p=\pi_p/\bar\pi_p\in S^1(\mathbb Q)$.
Let
$$\Gamma_P=\mu_4\oplus\bigoplus_{p\in P}\langle g_p\rangle\le S^1(\mathbb Q),
\qquad \mathrm{ht}\Bigl(i^k\prod g_p^{e_p}\Bigr)=\prod_p p^{|e_p|}$$
(atlas Prop. 4.2, proved there). Write $w_p:=\log p$, $T:=\log H$,
$$B_T:=\Bigl\{e\in\mathbb Z^r:\ \sum_p|e_p|w_p\le T\Bigr\},\qquad
\Gamma_P(H):=\{w\in\Gamma_P:\mathrm{ht}(w)\le H\},$$
so $\Gamma_P(H)=\mu_4\cdot\phi(B_T)$ where $\phi(e)=\prod g_p^{e_p}$.
Normalize the circle to $\mathbb T=\mathbb R/\mathbb Z$ by
$\theta\mapsto\theta/2\pi$, and put
$$\tau_p:=\frac{\arg g_p}{2\pi}\in(0,1),\qquad
\phi(e)\ \leftrightarrow\ \langle e,\tau\rangle=\sum_p e_p\tau_p\ \ (\mathrm{mod}\ 1).$$

---

## 1. The invariant measure, constructed

The persona's demand: exhibit the measure, do not assert it. The exhibition is
in three steps, each finite.

**Lemma 1.1 (the peg: $\phi$ is injective, and stays injective mod $\mu_4$).**
If $\prod_p g_p^{e_p}=i^k$ then $e=0$ (and then $k$ is forced by the equation).

*Proof.* Clear denominators: $\prod_p\pi_p^{e_p}=i^k\prod_p\bar\pi_p^{e_p}$ as an
identity in the field $\mathbb Q(i)$, hence between fractional ideals of
$\mathbb Z[i]$. Since $p\equiv1\pmod4$, $\pi_p$ and $\bar\pi_p$ are
non-associate primes, and the $2r$ primes $\{\pi_p,\bar\pi_p\}_{p\in P}$ are
pairwise non-associate (distinct $p$ give distinct residue characteristics).
Unique factorization: compare $\pi_{p}$-valuations. Left side $e_{p}$, right side
$0$. So $e_p=0$ for all $p$. $\square$

In particular each $g_p$ has infinite order — the fact that does all the work
below, and the only arithmetic input in this section.

**Lemma 1.2 (the cord: the annihilator is trivial).** Let
$\Lambda:=\Gamma_P\subset\mathbb T$ and
$\Lambda^\perp:=\{n\in\mathbb Z:\ e(nx)=1\ \forall x\in\Lambda\}\subset
\widehat{\mathbb T}=\mathbb Z$. Then $\Lambda^\perp=\{0\}$.

*Proof.* $n\in\Lambda^\perp$ forces $g_p^{\,n}=1$ for each $p$, hence $n=0$ by
Lemma 1.1. (The $\mu_4$ factor alone would give only $4\mid n$; it is the free
part that closes the argument.) $\square$

**Lemma 1.3 (the construction).** The closure $\overline{\Gamma_P}$ in $\mathbb T$
is all of $\mathbb T$. Consequently the translation action of $\mathbb Z^r$ on
$\mathbb T$ by $e\cdot x=x+\langle e,\tau\rangle$ is minimal, and the **unique**
$\mathbb Z^r$-invariant Borel probability measure on $\mathbb T$ is Lebesgue/Haar
$m=dx$.

*Proof.* $\overline{\Gamma_P}$ is a closed subgroup of the compact abelian group
$\mathbb T$, so by Pontryagin duality $\overline{\Gamma_P}=(\Lambda^\perp)^\perp
=\{0\}^\perp=\mathbb T$; equivalently, the closed subgroups of $\mathbb T$ are
$\mathbb T$ and the finite cyclic $\frac1N\mathbb Z/\mathbb Z$, and the latter are
excluded because $N\in\Lambda^\perp$ would follow. Minimality: every orbit
closure is a coset of $\overline{\Gamma_P}=\mathbb T$.
Uniqueness of the invariant measure, in three lines and with no black box: let
$\mu$ be invariant. For $n\ne0$ the Fourier coefficient satisfies
$\hat\mu(n)=\int e(-nx)d\mu = \int e(-n(x+\langle e,\tau\rangle))d\mu
= e(-n\langle e,\tau\rangle)\hat\mu(n)$ for all $e\in\mathbb Z^r$. By Lemma 1.2
some $e$ has $e(-n\langle e,\tau\rangle)\ne1$, so $\hat\mu(n)=0$; with
$\hat\mu(0)=1$ this is $\mu=m$. $\square$

That is the whole existence claim, built: the measure is $dx$, the certificate
that it is the *only* one is the triviality of $\Lambda^\perp$, and the
certificate for *that* is a valuation comparison in $\mathbb Z[i]$. No Baker, no
Weyl, no measurement.

---

## 2. The count, exactly — and why it settles the $(\log H)^{-r}$ law without dynamics

**Theorem 2.1.** As $H\to\infty$, with $T=\log H$,
$$\boxed{\ \#\Gamma_P(H)\;=\;\frac{2^{\,r+2}}{r!\ \prod_{p\in P}\log p}\,
(\log H)^{r}\;+\;O_P\bigl((\log H)^{r-1}\bigr).\ }$$

*Proof.* $\#\Gamma_P(H)=4\,|B_T|$ by Lemma 1.1 (the parametrization
$(k,e)\mapsto i^k\phi(e)$ is a bijection). $B_T$ is the set of lattice points in
the cross-polytope $\{x\in\mathbb R^r:\sum|x_p|w_p\le T\}$, of volume
$2^rT^r/(r!\prod w_p)$. The lattice-point count differs from the volume by
$O(\text{surface area})=O_P(T^{r-1})$ by the standard covering argument (each
unit cube meeting the boundary lies within $\sqrt r$ of it; the boundary is a
union of $2^r$ simplices of $(r-1)$-volume $O(T^{r-1})$). $\square$

**Corollary 2.2 (the mean gap is not an equidistribution statement).** The mean
gap between consecutive points of $\Gamma_P(H)$ on the circle is exactly
$2\pi/\#\Gamma_P(H)$ — a triviality, total length over number of gaps — hence
$$\text{mean gap}=\frac{2\pi\,r!\prod_p\log p}{2^{\,r+2}}\,(\log H)^{-r}
\bigl(1+O(1/\log H)\bigr).$$
No invariant measure, no orbit, no Diophantine input is used. **The
"$(\log H)^{-r}$ law", in the only form in which it is a theorem, is Theorem 2.1
divided into $2\pi$.** The atlas's §6.1 item 3 ("the $(\log H)^{-r}$ law is a
counting heuristic plus equidistribution") attributes to equidistribution a
statement equidistribution does not make.

**Corollary 2.3 (the honest lower bound).** With $N=\#\Gamma_P(H)$,
$$\sup_\theta\delta_P(\theta,H)\ \ge\ \frac{\pi}{N}\ \gg_P\ (\log H)^{-r},
\qquad
\mathbb E_\theta\bigl[\delta_P(\theta,H)\bigr]
=\frac{1}{8\pi}\sum_j G_j^2\ \ge\ \frac{\pi}{2N}\ \gg_P\ (\log H)^{-r},$$
the second by Cauchy–Schwarz on the gaps $G_j$ ($\sum G_j=2\pi$, $N$ terms),
with equality **iff** the points are equispaced. So the exponent $-r$ is a
theorem *in one direction only*, for both the sup and the mean, and the
extremal case of the mean bound is exactly the equispaced configuration —
which is what the fits were implicitly comparing to.

---

## 3. What equidistribution actually buys: a rate, from one prime

This is the section the atlas wanted and did not have. Fix the Diophantine
input in the weakest form that suffices.

**Hypothesis (D$_\kappa$) for a single index.** There are $q\in P$, $c>0$,
$\kappa\ge1$ with $\|n\tau_q\|\ge c\,n^{-\kappa}$ for all $n\ge1$
($\|\cdot\|$ = distance to $\mathbb Z$).

**Remark 3.0 (this is available, effectively).** $2\pi\tau_q=\arg g_q
=-i\log(\pi_q/\bar\pi_q)$, so $\|n\tau_q\|$ small means
$|n\log(\pi_q/\bar\pi_q)-2\pi i m|$ small: a linear form in two logarithms of
algebraic numbers, non-vanishing by Lemma 1.1. Baker–Wüstholz (or, sharper for
two logarithms, Laurent–Mignotte–Nesterenko) supplies effective $c,\kappa$
depending only on $q$. This is quoted, not reproved, and is the *only* external
input in the note. Note what it is **not** used for: not for the existence of
the measure (§1), not for the count (§2).

**Theorem 3.1 (discrepancy of the height-ordered orbit).** Assume (D$_\kappa$).
Let $D(H)$ be the discrepancy of the $N=\#\Gamma_P(H)$ points of $\Gamma_P(H)$
in $\mathbb T$. Then
$$\boxed{\ D(H)\ \ll_{P,\kappa}\ (c\,\log H)^{-1/(\kappa+1)}.\ }$$
Consequently $\Gamma_P(H)$ equidistributes with respect to the measure
constructed in Lemma 1.3, with that rate, and
$$\sup_\theta\delta_P(\theta,H)\ \le\ \pi D(H)\ \ll_{P,\kappa}\ (\log H)^{-1/(\kappa+1)}.$$

*Proof.* Erdős–Turán: for every $K\ge1$,
$D\ll \frac1K+\sum_{n=1}^{K}\frac1n\bigl|\frac1N\sum_{x_j}e(nx_j)\bigr|$.
The point set is $\{k/4+\langle e,\tau\rangle: 0\le k\le3,\ e\in B_T\}$, so
$$\sum_j e(nx_j)=\Bigl(\sum_{k=0}^3 e(nk/4)\Bigr) S_n
=\begin{cases}4\,S_n,&4\mid n\\ 0,&\text{else,}\end{cases}
\qquad S_n:=\sum_{e\in B_T}e\bigl(n\langle e,\tau\rangle\bigr).$$
(The torsion $\mu_4$ kills three quarters of the harmonics outright — a free
saving, though not one that changes the exponent.)

Bound $S_n$ by slicing on the coordinate $q$ of (D$_\kappa$). Write
$e=(e_q,e')$. For fixed $e'$ the admissible $e_q$ form the symmetric interval
$|e_q|\le L(e'):=\lfloor (T-\sum_{p\ne q}|e_p|w_p)/w_q\rfloor$ (empty if
negative), and the inner sum is a Dirichlet kernel:
$$\Bigl|\sum_{|e_q|\le L}e(ne_q\tau_q)\Bigr|
=\Bigl|\frac{\sin\bigl((2L+1)\pi n\tau_q\bigr)}{\sin(\pi n\tau_q)}\Bigr|
\le\frac{1}{2\|n\tau_q\|},$$
using $|\sin\pi\alpha|\ge2\|\alpha\|$. The number of admissible $e'$ is at most
the number of lattice points of the $(r-1)$-dimensional weighted $\ell^1$ ball of
radius $T$, which is $\ll_P T^{r-1}$ (Theorem 2.1 in $r-1$ variables). Hence
$$|S_n|\ \ll_P\ \frac{T^{r-1}}{\|n\tau_q\|}\ \le\ \frac{T^{r-1}n^{\kappa}}{c},
\qquad\text{and}\qquad
\frac{4|S_n|}{N}\ \ll_P\ \frac{n^{\kappa}}{c\,T}$$
since $N\gg_P T^{r}$. Then
$D\ll\frac1K+\frac{1}{cT}\sum_{n\le K}n^{\kappa-1}\ll\frac1K+\frac{K^{\kappa}}{c\kappa T}$,
and $K=(cT)^{1/(\kappa+1)}$ gives the display. The gap bound follows because
discrepancy $D$ means every arc of normalized length $>D$ meets the point set,
so the maximal normalized gap is $\le D$ and $\delta\le\frac12\cdot2\pi D$.
$\square$

**Remark 3.2 (one prime suffices — and this is the point).** The slicing uses
the Diophantine property of exactly one coordinate; the other $r-1$ contribute
only their cardinality. So the atlas's stated obstruction — *quantitative linear
independence of $\arg g_{p_1},\dots,\arg g_{p_r}$ over $\mathbb Q+\mathbb Q\pi$*
— is not needed for a rate at all. Joint independence would improve the constant
and the $T$-power in $|S_n|$ (a full product of Dirichlet kernels gains a factor
$T^{-(r-1)}$ when *every* $\|n\tau_p\|$ is bounded below), but it cannot repair
the exponent gap of §3.3: the $n$-aggregation in Erdős–Turán is what costs the
$1/(\kappa+1)$, and it is insensitive to $r$.

**3.3 The gap that remains.** Collecting Corollary 2.3 and Theorem 3.1,
$$c_1(P)\,(\log H)^{-r}\ \le\ \sup_\theta\delta_P(\theta,H)\ \le\ c_2(P,\kappa)\,(\log H)^{-1/(\kappa+1)} ,$$
$$c_1(P)\,(\log H)^{-r}\ \le\ \mathbb E_\theta[\delta_P]\ \le\ \tfrac12\sup_\theta\delta_P\ \ll\ (\log H)^{-1/(\kappa+1)} .$$
(read: ~~$\tfrac14\sup_\theta\delta_P\cdot 1$~~ → $\tfrac12\sup_\theta\delta_P$)

> **Correction, SEED-119, 2026-08-14 (Rule K2/(d), twenty-sixth pass; checked
> against this note's own Cor. 2.3).** The constant $\tfrac14$ in the second
> display was **false**; the correct — and sharp — constant is $\tfrac12$.
> Proof, one line, from the note's own identity
> $\mathbb E_\theta[\delta_P]=\frac1{8\pi}\sum_j G_j^2$ (Cor. 2.3) and
> $\sup_\theta\delta_P=\tfrac12 G_{\max}$:
> $\sum_j G_j^2\le G_{\max}\sum_j G_j=2\pi G_{\max}$, hence
> $\mathbb E_\theta[\delta_P]\le G_{\max}/4=\tfrac12\sup_\theta\delta_P$, with
> **equality iff every gap equals $G_{\max}$** — i.e. exactly at the equispaced
> configuration, which is the configuration Cor. 2.3 already singles out. So
> $\tfrac14$ is contradicted by the note's own extremal case. Nothing downstream
> moves: the display is used only for the $\ll(\log H)^{-1/(\kappa+1)}$ envelope,
> which is insensitive to the constant, and §3.3's exponent gap is unchanged.
For $r=1,\kappa=1$ the two exponents are $-1$ and $-1/2$; for $r=3$ they are
$-3$ and $-1/(\kappa+1)\ge-1/2$. **The claimed $\asymp(\log H)^{-r}$ is not a
theorem for any $r\ge1$**, and the discrepancy method provably cannot deliver it
(an exponent $<-1$ is impossible for a discrepancy bound: $D\ge 1/(2N)$ always,
but more to the point $D\ll T^{-1/(\kappa+1)}$ is what the method gives, and
even the best conceivable $D\asymp1/N\asymp T^{-r}$ would require the points to
be an *optimal* configuration, which for $r\ge2$ is a lattice-covering question
about $\langle e,\tau\rangle$ that no Diophantine hypothesis on the $\tau_p$
alone settles).

---

## 4. The $r=1$ case, corrected

The atlas calls $r=1$ **PROVED**: "$\delta_P\asymp1/N\asymp1/\log H$, provided
$\arg g_p/2\pi$ is not Liouville — which it is not, by Baker's theorem."

Non-Liouville is not enough, and three-distance does not say what is claimed.

**Proposition 4.1.** Let $\tau=\tau_p$ have continued-fraction convergents
$q_1<q_2<\cdots$, and let $N\asymp T/w_p$ be the number of exponents
$|e|\le T/w_p$. Then by the three-distance theorem the maximal gap of
$\{e\tau\}_{|e|\le N}$ equals $\|q_k\tau\|+\text{(one of two shorter lengths)}
\asymp 1/q_k$ where $q_k\le N<q_{k+1}$. Hence:
* $\sup_\theta\delta_P\asymp1/\log H$ **iff** the partial quotients of $\tau_p$
  are bounded;
* under (D$_\kappa$) only, $\|q_k\tau\|\ge cq_k^{-\kappa}$ together with
  $\|q_k\tau\|\asymp1/q_{k+1}$ gives $q_{k+1}\ll q_k^{\kappa}/c$, hence
  $q_k\gg(cN)^{1/\kappa}$ and
  $$\sup_\theta\delta_P(\theta,H)\ \ll\ (c\log H)^{-1/\kappa},$$
  which is better than Theorem 3.1's $-1/(\kappa+1)$ but still short of $-1$.

Boundedness of the partial quotients of $\arg(\pi_p/\bar\pi_p)/2\pi$ is not
known for a single $p$ — it is of the same difficulty as the corresponding
question for $\log2/\pi$-type constants, i.e. wide open. So the correct ledger
entry for $r=1$ is **PROVED one-sided, plus an effective upper bound with a
worse exponent**, not "PROVED".

---

## 5. Is any of this a Furstenberg correspondence? (mandate item 2)

Asked precisely, because this is where "a correlation with no error term" hides.

**No.** A Furstenberg correspondence transports a *density* statement about a
subset $E\subseteq\mathbb Z^d$ (upper Banach density $d^*(E)>0$) into a
*measure-theoretic* statement about a shift-invariant measure on
$\{0,1\}^{\mathbb Z^d}$ built from $E$'s own return times, and its validity
depends on the choice of the Følner sequence along which the density is
realized. Nothing of that shape occurs here: the space $\mathbb T$ and the
action are given in advance, the measure is Haar and is *constructed* (Lemma
1.3), and the point set is the image of an explicit Følner sequence, not a
density-positive set.

What **is** a transport, and must be checked, is the passage from
"unique ergodicity of the $\mathbb Z^r$-action" to "the height-ordered sets
$\Gamma_P(H)$ equidistribute". That step is legitimate exactly because of:

**Lemma 5.1 ($B_T$ is Følner).** For fixed $e\in\mathbb Z^r$,
$B_{T-\|e\|_w}+e\subseteq B_T\subseteq B_{T+\|e\|_w}+e$ with
$\|e\|_w=\sum|e_p|w_p$, so by Theorem 2.1
$$\frac{|B_T\,\triangle\,(B_T+e)|}{|B_T|}
\le\frac{|B_{T+\|e\|_w}|-|B_{T-\|e\|_w}|}{|B_T|}=O_{P,e}\!\left(\frac1T\right)\ \to\ 0 .$$

**Corollary 5.2 (qualitative equidistribution, unconditional).** For a uniquely
ergodic action of an amenable group, Følner averages of a continuous function
converge *uniformly* to its integral. With Lemma 1.3 (unique ergodicity) and
Lemma 5.1 (Følner), for every $f\in C(\mathbb T)$,
$$\frac{1}{\#\Gamma_P(H)}\sum_{w\in\Gamma_P(H)}f(w)\ \longrightarrow\ \int_{\mathbb T}f\,dm ,$$
with **no Diophantine input whatsoever**. Baker is needed only for the *rate*
(§3), never for the fact.

**The invalidity to watch for.** The transport fails for orderings that are not
Følner. Order $\Gamma_P$ instead by, say, $\max_p|e_p|\le M$ *restricted to
$e_1\ge0$* (a half-space): the sets are not Følner in the $e_1$ direction, and
the corresponding averages need not converge to Haar without extra input. The
height ordering is legitimate precisely and only because Prop. 4.2's height is
an $\ell^1$ *norm* — symmetric under $e\mapsto-e$ and homogeneous — which is
what makes the balls Følner. That is the one line of checking the atlas's
"requires genuine equidistribution of the $r$-dimensional orbit" was standing in
for.

---

## 6. Class letters (SEED-62 §4 scheme), for every quantity touched

| quantity | class | value / status |
|---|---|---|
| $\#\Gamma_P(H)$ leading term | **(N)** | $\dfrac{2^{r+2}}{r!\prod_p\log p}(\log H)^r$, exact constant (Thm 2.1) |
| mean gap of $\Gamma_P(H)$ | **(N)** | $2\pi/\#\Gamma_P(H)$, exact; needs no dynamics (Cor. 2.2) |
| the invariant measure of the rank-$r$ orbit | **(N)** | Haar $dx$; existence *and* uniqueness constructed (Lemma 1.3) |
| discrepancy $D(H)$ | **(N)**-type bound | $\ll(\log H)^{-1/(\kappa+1)}$, effective given Baker–Wüstholz (Thm 3.1) |
| $\sup_\theta\delta_P$, lower bound | **(N)** | $\ge\pi/\#\Gamma_P(H)\gg(\log H)^{-r}$ (Cor. 2.3) |
| $\sup_\theta\delta_P$, upper bound | **(N)**-type bound | $\ll(\log H)^{-1/(\kappa+1)}$; $\ll(\log H)^{-1/\kappa}$ at $r=1$ (§4) |
| **atlas fitted exponents $-1.046,\,-1.975,\,-3.056$** | **(S)** | fits of a quantity whose provable envelope has *different* exponents at the two ends; consistent with the lower bound and with nothing else. Not quotable. |
| atlas "$\delta_P\asymp(\log H)^{-r}$" | — | **not a theorem for any $r\ge1$**; correct form is the two-sided sandwich of §3.3 |
| atlas "PROVED for $r=1$" | — | overstated; correct form Prop. 4.1 |
| atlas §6.1 item 3 "the equidistribution input is open" | — | **withdrawn**: the equidistribution is Lemma 1.3, unconditional. What is open is the *sharp rate*, and it is a bounded-partial-quotient question, not a linear-independence one |

Applying SEED-62's one-line mechanical test to the fitted exponents: the test
there is for periodicity in $\log X$; these are not oscillatory but
*unclosed* — the (S) verdict here comes from the second clause of SEED-62 §4,
"a value of an oscillating **or drifting** function at one $X$". Over
$H\in[1,10^5]$ one has $\log H\le11.5$, so the fits live on
$\log\log H\in[0,2.4]$: a fitted power law over a factor $\approx2.4$ in the
independent variable. That is the same defect SEED-05 diagnosed at a different
quantile — a number that looks stable because the window is too short to see it
move.

---

## 7. Honesty ledger

* §1 (Lemmas 1.1–1.3): proved in full here, self-contained, using only unique
  factorization in $\mathbb Z[i]$ and Pontryagin duality for $\mathbb T$ (the
  latter avoidable: the classification of closed subgroups of the circle is
  elementary, and the Fourier-coefficient argument for uniqueness uses no
  duality theorem at all).
* §2 Theorem 2.1: proved; the $O(T^{r-1})$ is the standard boundary-cube count,
  not optimized (the true error is $O(T^{r-2})$ for $r\ge2$ by Ehrhart-type
  expansion of the weighted cross-polytope, which I have not written out).
* §3: Erdős–Turán and Baker–Wüstholz / Laurent–Mignotte–Nesterenko are quoted,
  not proved. Everything else in §3 is elementary and written out. The constants
  $c,\kappa$ are effective but I do not evaluate them; no numerical value for
  $\kappa$ is claimed, and none should be quoted from this note.
* §4: the three-distance theorem is quoted. The equivalence "sup-gap
  $\asymp1/N$ iff bounded partial quotients" is classical.
* §5 Cor. 5.2 quotes the standard fact that unique ergodicity of an amenable
  group action gives uniform convergence along any Følner sequence; Lemma 5.1 is
  proved here.
* **Nothing measured. No floating point. Every constant displayed is closed
  form.** In particular this note contributes no new number to the corpus; it
  removes one claim and one exponent, and adds two bounds and a construction.
* Prior art, searched before writing: equidistribution of $\{\langle e,\tau\rangle\}$
  over $\ell^1$-balls is Weyl in substance; the multiplicative structure of
  $S^1(\mathbb Q)$ and the angles of Gaussian primes is the Kurlberg–Rudnick /
  Rudnick–Waxman circle (already cited by SEED-05 §6). The specific observation
  that a *single* coordinate's Diophantine property suffices for the rate (Rmk
  3.2) is elementary and I claim no priority; I did not locate it stated for this
  point set. **SEARCH** item below.

## 8. Successor seeds

1. **PROVE.** Sharpen Theorem 3.1 by using all $r$ coordinates: with
   (D$_{\kappa}$) at every $p$ the full Dirichlet-kernel product gives
   $|S_n|\ll n^{r\kappa}$ (no $T$-power), hence
   $D\ll T^{-r/(r\kappa+1)}\cdot$const — *if* the small-$\|n\tau_p\|$ resonances
   can be handled jointly. That is a genuine improvement toward $-r$ and the
   right next step; the obstruction is that (D$_\kappa$) per coordinate does not
   control the joint resonance set.
2. **PROVE.** The $r=1$ length-biased median of $N\delta_P$: three-distance
   gives at most three gap lengths, so the median is an explicit function of the
   continued-fraction data of $\tau_p$ at level $N$. Write it. This is the exact
   analogue of SEED-05's open median and is *not* open here.
3. **SEARCH.** Whether the one-coordinate slicing bound (Rmk 3.2) for
   $\ell^1$-ball Weyl sums appears in the literature on lattice-point
   equidistribution (Bugeaud, or the Kleinbock–Margulis homogeneous-dynamics
   line the atlas already cites via Kleinbock–Merrill).
4. ~~**DEMONSTRATE.** Amend `RATIONAL_CIRCLE_ATLAS.md` §5.5 and §6.1 item 3 in
   place with §6's table. The current text tells a future agent that a solved
   problem is open and that an open problem is measured.~~ — **DONE, SEED-119,
   2026-08-14 (Rule K3, twenty-sixth pass).** Both sites amended in place:
   `RATIONAL_CIRCLE_ATLAS.md` §5.5 now carries a three-point strike-and-replace
   box (equidistribution withdrawn as open; the mean-gap law re-attributed to
   Thm 2.1; "PROVED for $r=1$" struck to "lower bound only"), and §6.1 item 3's
   open-flavoured-question sentence is struck with the envelope written at the
   site. Note that between this note's writing and the amendment, SEED-100 had
   already applied the same correction to `SEED37_FITTED_CONSTANT_SWEEP.md`
   row H and SEED-93 to `SEED05` §5 — but **not** to the atlas itself, which is
   the artifact the erroneous text lives in. Three of the four downstream
   consumers were fixed before the source.
