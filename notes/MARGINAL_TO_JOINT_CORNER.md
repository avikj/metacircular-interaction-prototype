# The marginal-to-joint corner, done as measure theory: the polytope, its vertices, and the one scalar that decides

**Author.** cf-swarm-kolmogorov (Claude Fable 5), 2026-08-14. Method lens:
Kolmogorov — probability as measure, dependence as exact structure, nothing
asymptotic where a finite-dimensional statement suffices.
**Formalizes.** Factory IV §XI
(`collab/upstream/library/raw/ETERNAL_GOLDEN_BRAID_THEOREM_FACTORY_IV_2026-08-14.md`):
"the projectors commute; the information does not … the true problem is a
marginal-to-joint lower-bound problem."
**Builds on.** `notes/FACTORY_IV_CHEN_CORNER_AUDIT.md` (cf-corner; cited below
as *the audit*), `notes/INDEX_LAW.md`, `notes/THE_INDEX_IS_THE_SUBJECT.md`.
**Missing sources flag (audit §0).** Factories II–III are absent from this
repository. "Radius transfer" is referred to below by name only, never by
theorem number.

Everything in §§1–7 is finite-dimensional: measures on a set of $2R$ points,
linear constraints, lattice inequalities. Every proof is complete and
hand-checkable. No computation was run; none was needed (`CLAUDE.md` rule 1).

---

## 1. The abstract problem, stated exactly

Fix integers $R\ge 2$ (radius range) and $2\le K\le R$ (Maynard cutoff;
arithmetically $K=123$, $R=K$). Work on the finite square

$$\Sigma \;=\; \{1,\dots,R\}\times\{1,2\}, \qquad (r,c)=(\text{radius},\text{charge}).$$

A **field state** is a finite nonnegative measure $\nu$ on $\Sigma$,
normalized to $\nu(\Sigma)=1$ (the normalization is a choice; §1.1 records
what it suppresses). Distinguish two events:

$$A \;=\; \{(r,1) : r\le K\} \quad(\text{Maynard face: exact charge, bounded radius}),$$
$$B \;=\; \{(1,c) : c\in\{1,2\}\} \quad(\text{Chen face: exact radius, two-charge envelope}),$$

and note the finite-set identity that is the whole geometry of Factory IV §I:

$$A\cap B \;=\; \{(1,1)\} \;=\; \text{the twin corner}.$$

**Known** (the two inhabited faces, per Factory IV §I and the audit §1): two
constants $a,b\in(0,1]$ with

$$(\mathrm M)\;\; \nu(A)\;=\;\sum_{r\le K}\nu(r,1)\;\ge\;a,
\qquad
(\mathrm C)\;\; \nu(B)\;=\;\nu(1,1)+\nu(1,2)\;\ge\;b.$$

**Target:** $\nu(1,1)>0$.

Define the **constraint polytope**

$$P(a,b)\;=\;\Bigl\{\nu\ge 0 \;:\; \nu(\Sigma)=1,\ \nu(A)\ge a,\ \nu(B)\ge b\Bigr\}.$$

The marginal-to-joint problem of Factory IV §XI is, verbatim in this
language: *compute $\inf_{\nu\in P(a,b)}\nu(1,1)$, and classify which
additional constraint sets $S\subseteq P(a,b)$ make the infimum positive.*

### 1.1 What the normalization carries, and what it hides

Arithmetically $\nu=\nu_X$ is the counting measure
$\nu_X(r,c)=\#\{w\le X:\ w-r \text{ prime},\ \Omega(w+r)=c\}$ restricted to
$c\in\{1,2\}$, divided by its total. The indices $X$ and the choice of
ambient set are limitors in the sense of `THE_INDEX_IS_THE_SUBJECT.md`, and
per `HOLOGRAM.md` §7 (quoted in `CLAUDE.md`) a constant without its
$X$-dependence is worse than no constant. So, exactly:

- $(\mathrm C)$ holds with $b=b(X)\gg 1/\log^{O(1)}X$-type relative mass along
  all large $X$ — Chen's theorem, quantitatively Green–Tao's
  $\gg X/\log^2X$ points on the row (Factory IV §I; audit §1).
- $(\mathrm M)$ holds along a subsequence $X_j\to\infty$ for some **fixed**
  $r_0\le 123$: bounded gaps ($\liminf(p_{n+1}-p_n)\le 246$) plus pigeonhole
  give infinitely many exact prime pairs at one exact radius $r_0$, so
  $\nu_{X_j}(r_0,1)>0$, indeed $\to\infty$ in counts.
- Both faces are **density-zero** relative to any natural ambient
  normalization: $a(X)+b(X)\to 0$, not merely $a+b\le 1$. This is not a
  detail; by Theorem 1 it is the exact reason the marginals are worth nothing.

Every statement below is per-$X$ (a statement about one finite measure);
"recurrence" of the corner is the per-$X$ positivity along an unbounded
sequence. No limit is ever interchanged with anything.

---

## 2. The no-go, exactly: Fréchet–Hoeffding on a four-cell square

**Theorem 1 (sharp marginal-to-joint bound).**
For all $a,b\in(0,1]$,

$$\inf_{\nu\in P(a,b)}\ \nu(1,1)\;=\;\max(a+b-1,\;0),$$

and the infimum is attained.

*Proof.* Lower bound: by inclusion–exclusion on the finite set $\Sigma$,
$\nu(1,1)=\nu(A\cap B)=\nu(A)+\nu(B)-\nu(A\cup B)\ge a+b-1$, and
$\nu(1,1)\ge0$ always.

Attainment, case $a+b\le1$ (the arithmetic case): take

$$\nu^\ast \;=\; b\,\delta_{(1,2)}\;+\;a\,\delta_{(2,1)}\;+\;(1-a-b)\,\delta_{(2,2)}$$

(legal since $K\ge2$). Then $\nu^\ast(A)=a$, $\nu^\ast(B)=b$,
$\nu^\ast(1,1)=0$. This is Factory IV §XI's own sentence — "a nonnegative
field may place all exact-prime mass at radius two and all radius-one mass at
charge two" — as a measure.

Case $a+b>1$: take $\nu(1,1)=a+b-1$, $\nu(1,2)=1-a$, $\nu(2,1)=1-b$; both
constraints are tight and the value $a+b-1$ is attained. $\square$

**Corollary 1.1 (the faces imply nothing).** Since the arithmetic faces have
$a(X)+b(X)\to0$, the marginal information $(\mathrm M),(\mathrm C)$ yields
the corner **only** in the regime $a+b>1$ — co-saturating events — which no
sieve output inhabits or can inhabit (the parity barrier caps the provable
charge-$1$ proportion of the row strictly below certainty; audit §3, first
item). The bound is vacuous for structural reasons, not for want of effort.

This is the Fréchet–Hoeffding lower bound / Bonferroni inequality in its
smallest instance (prior-art record: §8, Q1–Q2). Factory IV §XI is therefore
exactly right that the problem is marginal-to-joint, and exactly wrong to
hope any refinement of the two marginals alone can close it: Theorem 1 is an
equality, not an estimate.

**Proposition 2 (twin failure is extremal dependence).** For
$\nu\in P(a,b)$,

$$\nu(1,1)=0
\iff
\operatorname{Cov}_\nu(\mathbf 1_A,\mathbf 1_B)=-\,\nu(A)\,\nu(B),$$

the minimum possible covariance given the face masses. In particular a
**product** measure $\nu=\mu_{\mathrm{rad}}\otimes\mu_{\mathrm{ch}}$ with
positive marginals already has $\nu(1,1)=\nu(A')\nu(B')>0$: even exact
*independence* of radius and charge forces the corner. The enemy is not
absence of positive dependence; it is the logical possibility of **perfect
negative dependence** between the two favorable events. A twin-free world is
not generic — it sits on the boundary of the dependence order.

*Proof.* $\operatorname{Cov}(\mathbf 1_A,\mathbf 1_B)
=\nu(A\cap B)-\nu(A)\nu(B)=\nu(1,1)-\nu(A)\nu(B)$. $\square$

### 2.1 $R=2$: every vertex of the polytope, by hand

Take $R=K=2$; cells $x=\nu(1,1)$, $y=\nu(1,2)$, $z=\nu(2,1)$, $w=\nu(2,2)$.
$P(a,b)$ is cut out of the simplex $x+y+z+w=1$, $x,y,z,w\ge0$ by
$(5)\;x+z\ge a$ and $(6)\;x+y\ge b$. The polytope is $3$-dimensional; a
vertex is a feasible point with $3$ linearly independent tight constraints
among the six inequalities $(1)\,x\ge0$, $(2)\,y\ge0$, $(3)\,z\ge0$,
$(4)\,w\ge0$, $(5)$, $(6)$. All $\binom63=20$ triples, for the generic
arithmetic regime $0<b<a$, $a+b<1$ (the case $b<a$ is WLOG: the relabeling
$y\leftrightarrow z$, $a\leftrightarrow b$ is the $r\leftrightarrow c$
symmetry of the square):

| tight triple | point | feasible? | reason / name |
|---|---|---|---|
| $\{1,2,3\}$ | $(0,0,0,1)$ | no | violates $(5)$: $0\ge a$ |
| $\{1,2,4\}$ | $(0,0,1,0)$ | no | violates $(6)$ |
| $\{1,3,4\}$ | $(0,1,0,0)$ | no | violates $(5)$ |
| $\{2,3,4\}$ | $(1,0,0,0)$ | **yes** | $V_1$: all mass at the corner |
| $\{1,2,5\}$ | — | no | $x=y=0$ violates $(6)$ |
| $\{1,2,6\}$ | — | no | forces $b=0$ |
| $\{1,3,5\}$ | — | no | forces $a=0$ |
| $\{1,3,6\}$ | $(0,b,0,1-b)$ | no | violates $(5)$: $0\ge a$ |
| $\{1,4,5\}$ | $(0,1-a,a,0)$ | **yes** | $V_2$ (uses $1-a\ge b$) |
| $\{1,4,6\}$ | $(0,b,1-b,0)$ | **yes** | $V_3$ (uses $1-b\ge a$) |
| $\{1,5,6\}$ | $(0,b,a,1-a-b)$ | **yes** | $V_4$: Factory IV's extremal, minimal mass |
| $\{2,3,5\}$ | $(a,0,0,1-a)$ | **yes** | $V_5$ (uses $a\ge b$) |
| $\{2,3,6\}$ | $(b,0,0,1-b)$ | no | violates $(5)$: $b\ge a$ fails |
| $\{2,4,5\}$ | — | no | $y=w=0$ forces $x+z=1\ne a$ |
| $\{2,4,6\}$ | $(b,0,1-b,0)$ | **yes** | $V_6$ |
| $\{2,5,6\}$ | $(b,0,a-b,1-a)$ | **yes** | $V_7$ (uses $a\ge b$) |
| $\{3,4,5\}$ | $(a,1-a,0,0)$ | **yes** | $V_8$ |
| $\{3,4,6\}$ | — | no | $z=w=0$ forces $x+y=1\ne b$ |
| $\{3,5,6\}$ | $(a,b-a,0,1-b)$ | no | needs $b\ge a$ |
| $\{4,5,6\}$ | $(a{+}b{-}1,\,1{-}a,\,1{-}b,\,0)$ | no | needs $a+b\ge1$; is the extremal vertex in that regime |

**Eight vertices**: $V_1,\dots,V_8$ as listed. Degenerations: at $a=b$,
$V_7\to V_5$ (seven vertices); at $a+b=1$, $V_2=V_3=V_4$ (the corner-free
face collapses to a point, and the Fréchet bound starts to bite).

The **corner-free set** $\{x=0\}\cap P$ is exactly the $2$-face
$\operatorname{conv}\{V_2,V_3,V_4\}$: a whole two-parameter family of
extremal counterexamples, of which Factory IV's sentence names the vertex
$V_4$ (both constraints tight, slack parked at $(2,2)$). Five of the eight
vertices have a positive corner; the marginals cannot tell the two groups
apart. That is the no-go with its exact facial structure.

---

## 3. Classification (a): positive dependence — FKG stated exactly, and why it is circular here

Order $\Sigma$ as the product of chains $1<2<\dots<R$ (radius) and $1<2$
(charge), a distributive lattice under coordinatewise $\vee,\wedge$. Both
favorable events are **decreasing**: $A'=\{c=1\}$ (full column) and
$B'=\{r=1\}$ (full row), and $A\subseteq A'$, $B=B'$.

**Definition (FKG lattice condition / TP2).** $\nu$ is *log-supermodular* if
$\nu(s\vee t)\,\nu(s\wedge t)\ \ge\ \nu(s)\,\nu(t)$ for all $s,t\in\Sigma$
(cell masses). On a product of two chains this is exactly total positivity
of order 2 of the matrix $\bigl(\nu(r,c)\bigr)$:

$$(\mathrm{TP2})\qquad \nu(r,1)\,\nu(r',2)\ \ge\ \nu(r',1)\,\nu(r,2)
\qquad\text{for all } r<r',$$

i.e. **the odds of exact primality are nonincreasing in the radius**.

**Theorem 3 (FKG forces the corner).** If $\nu$ satisfies (TP2) and
$\nu(A)>0$, $\nu(B)>0$, then $\nu(1,1)>0$. Quantitatively, by the FKG/Harris
inequality for decreasing events on the finite distributive lattice,

$$\nu(1,1)\;=\;\nu(A'\cap B')\;\ge\;\nu(A')\,\nu(B')\;\ge\;ab\;>\;0.$$

*Proof.* FKG 1971 (or Harris 1960 in this product-of-two-chains case; §8,
Q3): log-supermodularity implies positive association, so decreasing events
are nonnegatively correlated. $A'\cap B'=\{(1,1)\}$. $\square$

So positive dependence is a genuine, exactly stated sufficient structure.
Now the two exact reasons it is not *additional* structure here.

**Theorem 4 (corner-circularity of the hypothesis).** Every instance of
(TP2) involving the corner cell reads, for $r'>1$,

$$\nu(1,1)\,\nu(r',2)\ \ge\ \nu(r',1)\,\nu(1,2),$$

with $\nu(1,1)$ a factor of the **large** side. Consequently, in any
corner-free world consistent with the two faces (so $\nu(r_0,1)>0$ for some
$r_0>1$ by $(\mathrm M)$, and $\nu(1,2)\ge b>0$ by $(\mathrm C)$), the
right-hand side is positive while the left is zero: (TP2) *fails* at
$(1,r_0)$. Verifying any corner instance of (TP2) with positive right side
is therefore already a twin lower bound
$\nu(1,1)\ \ge\ \nu(r_0,1)\,\nu(1,2)/\nu(r_0,2)$; the hypothesis is not
upstream of the conclusion — at the corner it **is** the conclusion.
$\square$

**No-go for the natural monotone structure.** The one arithmetically
motivated candidate for (TP2) — "primality is likeliest at small radius" —
is contradicted at the level of conjectured main terms by radical
degeneracy (Factory IV Theorem 54, audited correct in the audit §3): the
Hardy–Littlewood density of charge-$1$ mass at radius $r$ is proportional to
$\mathfrak S(2r)$, which depends only on the odd squarefree radical of $r$
and satisfies $\mathfrak S(2r)\ge\mathfrak S(2)$ with equality **iff $r$ is a
power of two**. So $r=1$ *minimizes* (with ties) the conjectural charge-1
density: odd-radical radii are strictly heavier, and raw-radius (TP2) is
conjecturally false. The only sublattices where the HL main terms even
permit (TP2) are the $2$-power radii $\{1,2,4,\dots\}\times\{1,2\}$, where
all main terms coincide — and there the inequality's truth lives entirely in
the un-derived error terms. Per `CLAUDE.md`: *the content is the error
term*; a strict (TP2) conjecture on the $2$-power sublattice is exactly as
strong as the twin corner (Theorem 4 with $r_0=2$, given Maynard mass at
$r_0$) and is recorded not as a route but as a reformulation:

> **Conjecture A (equivalent form, not a route).** For the arithmetic
> $\nu_X$ and some $2$-power radius $r_0\le 123$ carrying Maynard mass,
> $\nu_X(1,1)\,\nu_X(r_0,2)\ \ge\ \nu_X(r_0,1)\,\nu_X(1,2)$ along an
> unbounded $X$-sequence. Implies twins; is implied by nothing weaker in
> known technology; supported by HL only through equality of main terms.

Classification verdict for (a): sufficient, exactly stated, and **not
additional** — its usable instances contain the target as a factor.

---

## 4. Classification (b): transport — the exact requirement is domination, not a map

**Definition.** A *radius transfer* is a sub-Markov kernel $Q$ on $\Sigma$
that is charge-equivariant ($Q((r,c),\cdot)$ supported on
$\{1,\dots,R\}\times\{c\}$) with transfer rate
$q=\min_{r\le K}Q\bigl((r,1),\{(1,1)\}\bigr)>0$: it moves Maynard-face mass
to radius one without touching charge.

**Theorem 5 (transport forces the corner iff dominated).** If, in addition
to the existence of $Q$, the arithmetic field satisfies the **domination**

$$(\mathrm D)\qquad Q_*\bigl(\nu|_A\bigr)\ \le\ C\,\nu
\quad\text{for some }C<\infty,$$

then $\nu(1,1)\ \ge\ C^{-1}\,Q_*(\nu|_A)(1,1)\ \ge\ C^{-1}q\,a\ >\ 0$.
Conversely, **without** $(\mathrm D)$ transport is vacuous: for the
corner-free vertex $V_4$ the kernel moving the atom at $(2,1)$ to $(1,1)$
exists trivially, and $Q_*\nu^\ast$ has a full corner — but $Q_*\nu^\ast$ is
a different measure; no constraint ties it back to $\nu^\ast$, which remains
in $P(a,b)$ with empty corner. A transport theorem is precisely the
assertion $\nu\in S_Q=\{\nu: (\mathrm D)\text{ holds}\}$, and
$\inf_{S_Q\cap P}\nu(1,1)\ge C^{-1}qa>0$ while
$\inf_{P}\nu(1,1)=0$. $\square$

Three exact remarks.

1. **This is Factory III's absent "radius transfer", typed.** (Source absent
   from the repository — audit §0; named, not numbered.) The missing object
   was never the map: maps between measures are cheap (on two given measures
   with ordered masses, Strassen's domination theorem even characterizes
   when a dominated coupling exists — §8, Q4). The missing object is the
   inequality $(\mathrm D)$ asserting the transported mass is *recognized as
   mass of the same field*. Both sides of $(\mathrm D)$ involve the one
   unknown measure; that is why no soft argument produces it.
2. **The Lyapunov selection is blocked.** Radical degeneracy (§3 above) says
   singular-series ranking cannot select the transfer direction toward
   $r=1$: the local data ties $r=1$ with every $2$-power and prefers odd
   radicals. Any proof of $(\mathrm D)$ must use non-local input.
3. $(\mathrm D)$ restricted to the corner cell reads
   $Q_*(\nu|_A)(1,1)\le C\,\nu(1,1)$ — again the target appears on the large
   side. Transport, like FKG, forces the corner exactly through a functional
   that already mentions it. This is not an accident; §6 proves it must.

---

## 5. Classification (c): cancellation — the only linear route, and its exact price

The audit §2 fixed the envelope: on the **truncated Chen set** (Green–Tao
normalization, both row branches $\asymp X/\log^2X$) the anti-saturation
constant $\delta$ is meaningful and is the classical sieve-constant deficit.
In the present language anti-saturation is a *single linear constraint*:

$$S_\delta \;=\;\Bigl\{\nu\;:\;\nu(1,2)\ \le\ (1-\delta)\,\bigl(\nu(1,1)+\nu(1,2)\bigr)\Bigr\},
\qquad \delta\in(0,1].$$

**Theorem 6.** $\displaystyle\inf_{\nu\in P(a,b)\cap S_\delta}\nu(1,1)\;=\;\delta\,b$,
attained at the measure with $\nu(1,1)=\delta b$, $\nu(1,2)=(1-\delta)b$,
$\nu(2,1)=a$ (if $a+b\le1$; mass balance at $(2,2)$).

*Proof.* $\nu(1,1)\ge\delta\,\nu(B)\ge\delta b$ directly; the stated measure
is feasible and tight. $\square$

Unlike (a) and (b), route (c) needs no auxiliary object: one scalar
inequality on the row, and the polytope's corner-free face
$\operatorname{conv}\{V_2,V_3,V_4\}$ is cut off entirely (every corner-free
measure has $\nu(1,2)=\nu(B)\ge b>0$, violating $S_\delta$). The audit §4
locates the only admissible proof technology for it (charged-sector,
bilinear; Halász-grade mean value along shifted primes) and this note adds
nothing to that location — it proves instead (§6) that (c) is not one route
among three but the invariant content of all three.

---

## 6. The information-theoretic reading: the minimal deciding scalar, exactly

Let $\sigma:\Sigma\to\Sigma$ be the **charge involution on the Chen row**:
$\sigma(1,1)=(1,2)$, $\sigma(1,2)=(1,1)$, identity elsewhere. On the
arithmetic field this is the Liouville gauge flip restricted to the row —
the involution whose machine-checked shadow is `saturation-blinds` in
`formal/cubical/NaturalMachine/ChenProjector.agda` (audit §5). Write
$C=\nu(1,1)+\nu(1,2)$ (row mass) and

$$L\;=\;\nu(1,2)-\nu(1,1)\;=\;\int_{B}\lambda\,d\nu
\qquad(\lambda=+1\text{ on charge }2,\ -1\text{ on charge }1),$$

the corpus's $L_T$ at scale $X$. The exact identity
$\ \nu(1,1)=(C-L)/2\ $ is Factory IV's Theorem 58 / the audit's
$T=(C_T-L_T)/2$ in measure form.

**Lemma 7 (unobservability).** For every corner-free $\nu\in P(a,b)$, the
flipped measure $\sigma_*\nu$ also lies in $P(a,b)$ and has
$\sigma_*\nu(1,1)=\nu(1,2)\ge b>0$.

*Proof.* Chen mass: $\sigma$ preserves the row, so $\sigma_*\nu(B)=\nu(B)\ge b$.
Maynard mass: $\sigma_*\nu(A)=\nu(A)-\nu(1,1)+\nu(1,2)=\nu(A)+\nu(1,2)\ge a$
since $\nu(1,1)=0$. Nonnegativity and total mass are clear. $\square$

**Theorem 8 (the deciding scalar is $L$, and it is minimal).**

1. *No $\sigma$-invariant knowledge decides.* If $\Phi$ is any family of
   observables with $\Phi(\sigma_*\nu)=\Phi(\nu)$, then $\Phi$ together with
   $(\mathrm M),(\mathrm C)$ cannot determine whether the corner is
   inhabited: by Lemma 7 the pair $\{\nu^\ast,\sigma_*\nu^\ast\}$ (e.g.
   $\nu^\ast=V_4$) agrees on $\Phi$ and on both constraints and differs in
   verdict. In particular $C$, all off-row masses, all marginals, and every
   symmetric function of the row pair are $\sigma$-invariant: **no amount of
   refinement of charge-symmetric information closes the corner.**
2. *One $\sigma$-odd scalar decides.* The linear functionals supported on
   the row form a $2$-dimensional space with $\sigma$-eigenbasis
   $\{C\ (\text{even}),\ L\ (\text{odd})\}$; the $\sigma$-odd line is
   spanned by $L$ alone. Given the known $C>0$ (Chen, quantitatively
   Green–Tao), knowledge of the single real number $L$ decides the corner
   exactly: $$\boxed{\ \nu(1,1)>0 \iff L<C.\ }$$
3. *Minimality and uniqueness.* Any deciding scalar must be
   non-$\sigma$-invariant (by 1), and any $\sigma$-odd affine observable on
   the row equals $\alpha L$ + ($\sigma$-even terms), $\alpha\ne0$. So the
   missing knowledge is exactly one number, and it is $L$ up to already-known
   corrections and scale. $\square$

**Proposition 9 (normal form: every route exits through anti-saturation).**
A constraint set $S\subseteq P(a,b)$ forces the corner
($\inf_{S}\nu(1,1)=\varepsilon>0$) **iff** $S$ implies the quantitative
anti-saturation bound $C-L\ge 2\varepsilon$ — immediately from the identity
$C-L=2\nu(1,1)$. Hence FKG (§3) and transport (§4) force the corner exactly
through their $\sigma$-odd content (visible in Theorems 4 and 5.3: each
usable instance carries $\nu(1,1)$ explicitly), and route (c) is not a third
option but the invariant form of any option. $\square$

**In the corpus's index language** (`THE_INDEX_IS_THE_SUBJECT.md` §1,
`INDEX_LAW.md` Theorem E): the corner verdict is an observable that is not
invariant under a symmetry ($\mathbb Z/2$, generated by $\sigma$) preserving
every known constraint; on the orbit $\{\nu,\sigma_*\nu\}$ the verdict
flips, so **the joint is unobservable until an index breaking the charge
gauge is carried on the claim**. The index that makes the joint observable
is the Liouville index along the radius-one row — the scalar $L$ — and
Theorem 8.3 says it is the *unique minimal* such index. This is the parity
problem restated as measure theory, deliberately: the audit §3 graded
Factory IV's enlargement as a rederivation of the parity identity, and this
section shows the marginal-to-joint framing rederives, exactly and with a
uniqueness clause, *which* number parity has been hiding all along. What is
new here is not the wall; it is the finite-dimensional proof that the wall
is one-dimensional.

---

## 7. Prior-art record (model knowledge; egress-blocked, queries recorded per protocol)

- **Q1** "sharp lower bound on joint probability given marginals" →
  Fréchet (1935), Hoeffding (1940): the copula lower bound
  $W(u,v)=\max(u+v-1,0)$ is sharp; Bonferroni inequalities. Theorem 1 is
  the smallest instance; **no novelty claimed**.
- **Q2** "marginal problem, existence of measures with given marginals" →
  Kellerer (1964); Strassen (1965). The polytope $P(a,b)$ is a baby
  marginal problem; its vertex enumeration (§2.1) is elementary LP.
- **Q3** "FKG inequality, Harris inequality, TP2, association" →
  Harris (1960); Esary–Proschan–Walkup (1967); Fortuin–Kasteleyn–Ginibre
  (1971); Karlin's total positivity. The product-of-two-chains equivalence
  (lattice condition $\iff$ TP2 of the matrix) is standard.
- **Q4** "Strassen domination theorem" → Strassen (1965): stochastic
  domination $\iff$ monotone coupling; cited in §4 to separate "a kernel
  exists" (cheap) from "the field dominates its own transport" (the
  content).
- **Q5** "correlation inequalities for primes / positive association of
  prime events" → nothing applicable known to this model: the known
  dependence results for prime-like events run through sieve upper bounds
  (negative-direction information) and the parity barrier; no FKG-type
  lattice condition for shifted-prime charges appears in literature known
  here. Recorded as a standing `SEARCH` for a successor with egress.
- **Q6** "Liouville along shifted primes, sparse Halász" → already recorded
  as open by the audit §4.2; not duplicated, cross-referenced.

---

## 8. Honesty ledger

- **Proved here, exactly:** Theorems 1, 3–6, 8; Propositions 2, 9; Lemma 7;
  the complete $R=2$ vertex table (20 triples checked by hand, 8 vertices,
  degenerations at $a=b$ and $a+b=1$). All are finite-dimensional
  linear-algebra/lattice statements; each proof is complete above and
  contains no asymptotic step, no measurement, no fitted constant. No code
  was run (no Python, per ban; no Agda was needed — nothing here exceeds
  hand-checkable size; formalization of Theorem 1 and Lemma 7 would be a
  reasonable `PROVE` follow-up in `formal/cubical/`).
- **Classical, not claimed:** Theorem 1 is Fréchet–Hoeffding/Bonferroni;
  Theorem 3 is FKG/Harris. The contribution of this note is the assembly:
  the identification of Factory IV §XI with the Fréchet bound (with its
  facial structure), the circularity theorems 4 and 5.3, and the
  $\sigma$-minimality Theorem 8 with its uniqueness clause tied to the
  corpus's index law.
- **Conjectural and labelled:** Conjecture A (equivalent to twins, not a
  route); all Hardy–Littlewood main-term statements in §3 are heuristic
  inputs used only *negatively* (to rule out a monotone structure), never as
  evidence for a positive claim.
- **Index discipline:** the normalization and scale $X$ are carried
  explicitly (§1.1); $a,b$ are $X$-indexed and density-zero; no constant is
  quoted without its dependence.
- **Absent sources:** Factories II–III remain unrecovered; "radius transfer"
  is used as a name only.
- **What this note does not do:** it does not advance the arithmetic
  estimate. It proves the problem's exact shape: the corner is decided by
  one $\sigma$-odd scalar, everything $\sigma$-even is provably useless, and
  the three proposed routes are one route. The arithmetic work remaining is
  exactly the audit §4's: an upper bound for $L$ strictly inside $C$ on the
  truncated set.

**Queue.**
- `PROVE` — formalize Theorem 1 + Lemma 7 in `formal/cubical/` (finite
  measure on a $4$-point set; both are decidable-arithmetic statements).
- `SEARCH` — Q5 above (correlation inequalities for shifted-prime events).
- `PROVE` — restate Theorem 6's $\delta$ against the Chen /
  Halberstam–Richert sieve constants on the truncated set (joint with the
  audit's queue item; exact constants only).

Signed: **cf-swarm-kolmogorov**, 2026-08-14.
