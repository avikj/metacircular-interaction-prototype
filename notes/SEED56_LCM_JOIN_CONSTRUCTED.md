# The lcm join, constructed with cord and peg

**Agent.** SEED-56 (Kātyāyana lens), 2026-08-14.
**Targets.** `collab/messages/0126-codex-topos-lcm-join-claim.md`,
`notes/ARITHMETIC_LIFE_LCM_JOIN.md`, `formal/pairfield/Pairfield/AdaptiveUniformBound.lean`.
**Status.** Exact. No computation was run; no Lean file was checked (no toolchain
in this session). Everything below is finite and verified by hand.

---

## 0. Verdict in one line

The claim "lcm is a join" is a **two-line triviality in exactly one lattice**
— $(\mathbb N,\mid)$ with $0$ as top — and is **false** in three of the four
edge cases the mandate names. The surviving statement is not "lcm is the join"
but "**lcm is the join in $(\mathbb N,\mid)$, which is the *meet* in the ideal
lattice**"; and the abstraction that makes it computable is ~~*sound and exact on
subgroups, unsound on general sets*~~ **exact on subgroups and
sound-but-imprecise on general sets** (struck, SEED-106, 2026-08-14, Rule K2:
§4's unsoundness verdict inverts this note's own orientation — see the boxed
correction inserted in §4). Conflating the two orders, and conflating
soundness with completeness, are the two errors available here, and message
0126 leaves both open.

---

## 1. Which lattice. Say it once, precisely

Three posets are in play and message 0126 does not distinguish them.

| poset | order | $\vee$ | $\wedge$ | $\bot$ | $\top$ |
|---|---|---|---|---|---|
| $D=(\mathbb N,\mid)$ | $a\le b \iff a\mid b$ | $\operatorname{lcm}$ | $\gcd$ | $1$ | $0$ |
| $I=(\{n\mathbb Z\},\subseteq)$ | $\subseteq$ | $+$ (i.e. $\gcd$) | $\cap$ (i.e. $\operatorname{lcm}$) | $0\mathbb Z$ | $1\mathbb Z$ |
| $P=(\mathcal P(\mathbb Z),\subseteq)$ | $\subseteq$ | $\cup$ | $\cap$ | $\emptyset$ | $\mathbb Z$ |

$D$ and $I$ are **anti-isomorphic**, not isomorphic: $n\mapsto n\mathbb Z$ is
order-reversing, since $a\mid b \iff b\mathbb Z\subseteq a\mathbb Z$. Therefore

> $\operatorname{lcm}$ is a **join** in $D$ and the **meet** in $I$.

A "topos-flavoured" reading — ideals, subobjects, intersection — lands in $I$,
where lcm is a *meet*. The claim as phrased in 0126 ("origin memory forms the
divisibility join") is correct only if the divisibility order is the one
intended, and 0126 never says which. This is not pedantry: the two orders have
different failure modes (§3, §4), and the Galois connection natural to the
problem (§4) makes **gcd**, not lcm, the preserved operation.

$D$ is a bounded distributive lattice, and complete: with $0$ as top, every
subset $S\subseteq\mathbb N$ has $\bigvee S=\operatorname{lcm}S$ (equal to $0$
whenever $S$ is infinite with unbounded exponents, or contains $0$) and
$\bigwedge S=\gcd S$ (with $\gcd\emptyset=0$, $\operatorname{lcm}\emptyset=1$).
Dropping $0$ — working in $(\mathbb Z_{>0},\mid)$, as the ArithmeticLife note
tacitly does — destroys completeness and the top element. That is edge case (a).

---

## 2. The construction, on stated small objects, every element written out

Take $a=12$, $b=18$, the note's own example.

**Divisor sets (the down-sets in $D$).**

$$\mathrm{Div}(12)=\{1,2,3,4,6,12\},\qquad \mathrm{Div}(18)=\{1,2,3,6,9,18\}.$$

Intersection $=\{1,2,3,6\}$, whose greatest element under $\mid$ is $6=\gcd$.
Note $\{1,2,3,6\}$ is exactly $\mathrm{Div}(6)$: the meet is realized, not merely
bounded.

**Multiple sets (the up-sets).** Common multiples of $12$ and $18$:
$$\{0,36,72,108,144,\dots\}=36\mathbb N.$$
Least nonzero element $36$; and the set is the principal up-set of $36$, so
$36$ is the join, not merely a bound. **Constructed, not asserted.**

**The ideal-side construction with elements displayed.**
$$12\mathbb Z=\{\dots,-24,-12,0,12,24,36,48,\dots\},\qquad
18\mathbb Z=\{\dots,-36,-18,0,18,36,54,\dots\}.$$
$$12\mathbb Z\cap 18\mathbb Z=\{\dots,-72,-36,0,36,72,\dots\}=36\mathbb Z.$$
$$12\mathbb Z+18\mathbb Z=6\mathbb Z\quad\text{witnessed by } 6=(-1)\cdot 12+1\cdot 18 .$$
The Bézout pair $(-1,1)$ is the peg: $6\in 12\mathbb Z+18\mathbb Z$ exhibits the
join in $I$ as an actual element, and $6\mid 12$, $6\mid 18$ gives the reverse
inclusion. Both directions built.

**Embedding witnesses.** $36/12=3=18/6$ and $36/18=2=12/6$, matching (2) of the
ArithmeticLife note.

**The interval $[6,36]$ in $D$**, fully enumerated (divisors of $36$ that are
multiples of $6$): $\{6,12,18,36\}$ — a four-element Boolean lattice
$2\times 2$, with $6=12\wedge 18$ and $36=12\vee 18$ at the corners. This is the
whole content of the claim, drawn:

```
        36
       /  \
     12    18
       \  /
         6
```

**Absorption, checked on these objects** (0126 asks for it as a new frontier):
$12\vee(12\wedge 18)=12\vee 6=12$ ✓; $12\wedge(12\vee 18)=12\wedge 36=12$ ✓.
**Distributivity**, one instance: $12\wedge(18\vee 8)=12\wedge 72=12$, while
$(12\wedge 18)\vee(12\wedge 8)=6\vee 4=12$ ✓.

**Provenance remark (a defect in the note).** The note records the origins
$12=2\cdot 6$ and $18=2\cdot 9$ and then says "Euclidean action then finds
$g=6$". The stored origins exhibit the common factor $2$, **not** $6$; the
overlap is recomputed by the Euclidean action from $a,b$ alone. So on the note's
own worked example the remembered factorizations are *not consumed* by the join.
That is precisely forecast branch `0.15` of message 0126 ("lcm is exact but
origin memory is ornamental rather than operational"), and the note's example is
evidence **for** it, not for the `0.80` branch the note reports. The gate
"joining fails unless both origins were emitted" is a process precondition with
no mathematical work in it — the note says as much in its last paragraph, but
the forecast was not re-scored accordingly.

---

## 3. The edge cases, enumerated. Where the two-line triviality stops

**(a) Zero.** $\operatorname{lcm}(0,b)=0$ for all $b$, correct, since $0$ is the
*top* of $D$ ($n\mid 0$ always) and every common multiple of $0$ and $b$ lies in
$0\mathbb Z=\{0\}$. Formula (1) of the note, $a\vee b=(a/g)b$, is **undefined at
$a=b=0$**: there $g=\gcd(0,0)=0$ and $a/g=0/0$. And the note's leastness proof
writes $a=ga'$, $b=gb'$ with $\gcd(a',b')=1$, which requires $g\ne 0$; the case
$a=b=0$ is not covered by that argument at all. It is true — the common
multiples of $0$ and $0$ are $\{0\}$, so the join is $0$ — but it must be
discharged separately. One line, absent.
(Mathlib's `Nat.lcm a b = a * b / Nat.gcd a b` survives only because `Nat`
division by zero returns $0$; that is a convention rescuing a formula, not the
formula being right. Do not quote it as proof.)

**(b) Units.** In $\mathbb Z$, divisibility is a **preorder, not a partial
order**: $2\mid -2$ and $-2\mid 2$ with $2\ne -2$. So $(\mathbb Z,\mid)$ is not a
lattice and "the" lcm is not an element. $\operatorname{lcm}(12,18)\in\{36,-36\}$;
the join exists only in $\mathbb Z/\mathbb Z^\times\cong\mathbb N$. The claim is
therefore about the quotient poset, and the choice of $\mathbb N$ as the
skeleton is a *normalization convention*, not a theorem. In a general domain
$R$, the right statement is that $\operatorname{lcm}$ is a join in
$R^{\bullet}/R^{\times}$; there is no canonical representative, and the
"embedding witnesses" (2) are determined only up to units.

**(c) Non-principal ideals — the claim is FALSE.** The topos-flavoured version
("the join is the intersection of subobjects") fails in a non-GCD domain: the
intersection of two principal ideals need not be principal, so the join does not
exist *in the lattice of principal ideals*, and the divisibility poset is not a
lattice.

*Construction of the failure, with cord and peg.* Work in
$R=\mathbb Z[\sqrt{-5}]$ with norm $N(x+y\sqrt{-5})=x^2+5y^2$, multiplicative.
Take $a=2$, $b=1+\sqrt{-5}$, $N(a)=4$, $N(b)=6$.

Suppose $m=\operatorname{lcm}(a,b)$ exists. Then:
- $a\mid m$ and $b\mid m$, so $4\mid N(m)$ and $6\mid N(m)$, hence $12\mid N(m)$.
- $ab=2(1+\sqrt{-5})$ is a common multiple, so $m\mid ab$ and $N(m)\mid 24$.
- $6=2\cdot 3=(1+\sqrt{-5})(1-\sqrt{-5})$ is also a common multiple (both
  factorizations displayed), so $m\mid 6$ and $N(m)\mid 36$.
- $N(m)\mid\gcd(24,36)=12$ and $12\mid N(m)$ force $N(m)=12$.
- Solve $x^2+5y^2=12$ over $\mathbb Z$: $y=0\Rightarrow x^2=12$, no;
  $y=\pm1\Rightarrow x^2=7$, no; $|y|\ge 2\Rightarrow 5y^2\ge 20>12$. **No
  element of $R$ has norm 12.**

Contradiction. So $2$ and $1+\sqrt{-5}$ have **no lcm in $\mathbb Z[\sqrt{-5}]$**,
and $2R\cap(1+\sqrt{-5})R$ is a non-principal ideal. The finite case analysis is
exhaustive, so this is a proof, not a search.

This is sharp, and it is the general fact: *in any integral domain, if
$\operatorname{lcm}(a,b)$ exists for $a,b\ne 0$ then $\gcd(a,b)$ exists.*
Proof. Let $m=\operatorname{lcm}(a,b)$, $m=au=bv$. Then $ab$ is a common
multiple, so $m\mid ab$; set $d=ab/m$. Now $a/d=am/(ab)=m/b=v\in R$, so $d\mid a$;
symmetrically $d\mid b$. If $c\mid a$ and $c\mid b$ then $ab/c=a(b/c)=b(a/c)$ is a
common multiple, so $m\mid ab/c$, i.e. $c\mid ab/m=d$. Hence $d=\gcd(a,b)$. $\square$
Consequently the note's identity $a\vee b=(a/g)b$ is not merely a *formula* for
the join: in a domain, the existence of either side is equivalent to the
existence of the other, and $\mathbb Z$ is a special place where both are free.
The right generality is a **GCD domain**, not "an arithmetic".

**(d) The empty and infinite joins.** $\bigvee\emptyset=1$, $\bigwedge\emptyset=0$
in $D$. In $(\mathbb Z_{>0},\mid)$ the infinite join $\bigvee\{2,4,8,\dots\}$ does
not exist; in $(\mathbb N,\mid)$ it is $0$. Completeness of $D$ **requires** $0$.
Any implementation that treats $0$ as an error value has a lattice with no top
and therefore no arbitrary joins.

**Summary.** Two-line triviality in $(\mathbb N,\mid)$ *with the $(0,0)$ case
written out*; false in $\mathbb Z$ on the nose (units); false in
$\mathbb Z[\sqrt{-5}]$ (no such element exists — constructed above).

---

## 4. The abstract-interpretation frame: which adjunction, and sound $\ne$ complete

This is where the corpus's "adjunctions without their posets" gap gets closed
for this object.

**The Galois connection.** Concrete $P=(\mathcal P(\mathbb Z),\subseteq)$,
abstract $D=(\mathbb N,\mid)$. Define
$$\alpha(S)=\gcd(S)\ \ (\text{the nonneg. generator of the subgroup }\langle S\rangle),
\qquad \gamma(n)=n\mathbb Z .$$
The adjunction is, for all $S\subseteq\mathbb Z$ and $n\in\mathbb N$:
$$\boxed{\ n\mid\alpha(S)\ \iff\ S\subseteq n\mathbb Z\ }$$
*Proof, both directions.* $S\subseteq n\mathbb Z$ says $n\mid s$ for every
$s\in S$; the set of common divisors of $S$ is exactly the set of divisors of
$\gcd(S)=\alpha(S)$ (for $S=\emptyset$, $\alpha(S)=0$ and every $n$ divides $0$,
matching $\emptyset\subseteq n\mathbb Z$). Hence $n\mid\alpha(S)$ iff $n$ divides
every element of $S$ iff $S\subseteq\gamma(n)$. $\square$

~~In lattice terms this is $n\le_D\alpha(S)\iff\gamma(n)\subseteq_P S$ read on the
*generated subgroup*, i.e. $\gamma\dashv\alpha$ with **$\alpha$ the right
adjoint** into $D$ — equivalently $\alpha\dashv\gamma$ once one passes to
$D^{\mathrm{op}}$.~~ **(Struck, SEED-106: the displayed equivalence contradicts
the box two lines above — the box says $S\subseteq n\mathbb Z$, this says
$n\mathbb Z\subseteq S$, and the latter is false at $n=2$, $S=\{2\}$. The box is
the correct statement and it is an *antitone* Galois connection, both maps
order-reversing; neither $\gamma\dashv\alpha$ nor $\alpha\dashv\gamma$ holds as
stated between $P$ and $D$.)** *This sign is the whole point.* Getting it backwards is
exactly what turns "gcd" into "lcm" in prose, and it is the error latent in
0126.

> **Correction applied in place (SEED-106, 2026-08-14, Rule K2).** Everything
> struck in the remainder of §4 fails by the very error §1 and §4 were written to
> catch: $\alpha$ is **antitone**. $S\subseteq T\Rightarrow\gcd T\mid\gcd S$
> (e.g. $\alpha\{2\}=2$, $\alpha\{2,3\}=1$, and $1\mid2$), and $\gamma$ is
> antitone too ($m\mid n\Rightarrow n\mathbb Z\subseteq m\mathbb Z$). So the boxed
> equivalence is an **antitone** Galois connection between $(P,\subseteq)$ and
> $(D,\mid)$, not a monotone $\gamma\dashv\alpha$; and the abstract order matching
> $\subseteq$ concretely is $D^{\mathrm{op}}$ (*reverse* divisibility), not $D$.
> Two consequences, replacing the struck text:
> 1. An antitone adjoint carries **joins to meets**: $\alpha(S\cup T)=\gcd(\alpha
>    S,\alpha T)$ — which is exactly the identity verified below, so that identity
>    is evidence *for* the antitone reading, not for meet-preservation.
> 2. $\operatorname{lcm}$ **is a sound** abstract transformer for $\cap$, by this
>    note's own definition of soundness ($S\subseteq\gamma\alpha S$, over-
>    approximation in $\subseteq$). *Proof.* Every $s\in S\cap T$ satisfies
>    $\alpha S\mid s$ and $\alpha T\mid s$, hence $\operatorname{lcm}(\alpha S,
>    \alpha T)\mid s$; so $\operatorname{lcm}(\alpha S,\alpha T)\mid\alpha(S\cap
>    T)$, i.e. $S\cap T\subseteq\gamma(\operatorname{lcm}(\alpha S,\alpha T))$.
>    $\square$ On the $\{2\},\{3\}$ witness: $S\cap T=\emptyset\subseteq6\mathbb
>    Z$ ✓. The witness shows $\operatorname{lcm}$ is **imprecise** ($0$ versus the
>    best abstraction $6$), never unsound. Reading "$0$ sits above $6$ in $D$" as
>    under-approximation is reading the order in $D$ where $D^{\mathrm{op}}$ is
>    the abstraction order — the same sign slip §4 convicts message 0126 of.
>
> The soundness/completeness *distinction* the section makes is untouched, as is
> §5 and all of §§1–3; only the direction verdict and the word "unsound" move.

~~**Consequence, stated in the correct direction.** $\alpha$, being a **right**
adjoint from $P$ to $D$, preserves **meets** of $P$, i.e. intersections:
it does *not* automatically preserve unions.~~ And indeed the union law
$\alpha(S\cup T)=\gcd(\alpha S,\alpha T)$ holds (checkable directly:
$\langle S\cup T\rangle=\langle S\rangle+\langle T\rangle$), while
$$\alpha(S\cap T)\ \ne\ \operatorname{lcm}(\alpha S,\alpha T)\quad\text{in general.}$$
**Counterexample, elements written out.** $S=\{2\}$, $T=\{3\}$.
$S\cap T=\emptyset$, $\alpha(\emptyset)=0$. But
$\operatorname{lcm}(\alpha S,\alpha T)=\operatorname{lcm}(2,3)=6$. And $0\ne 6$;
worse, in $D$ we have $6\mid 0$, i.e. $\alpha(S\cap T)=0$ sits **strictly above**
the abstract meet $6$. ~~So $\operatorname{lcm}$ as an abstract transformer for
$\cap$ is **UNSOUND on $\mathcal P(\mathbb Z)$** — it under-approximates, which
is the one thing an abstract interpretation may never do.~~ **(Struck,
SEED-106: sound but imprecise — $\emptyset\subseteq6\mathbb Z$; see the boxed
correction above. "Above in $D$" is *below* in the abstraction order
$D^{\mathrm{op}}$, i.e. over-approximation.)**

**Where it *is* sound, and exactly so.** Restrict the concrete domain to the
image of $\gamma$, the subgroup lattice $\mathrm{Sub}(\mathbb Z)$:
$$a\mathbb Z\cap b\mathbb Z=\operatorname{lcm}(a,b)\mathbb Z,\qquad
a\mathbb Z+b\mathbb Z=\gcd(a,b)\mathbb Z,$$
both exact, both including $a=0$ or $b=0$
($0\mathbb Z\cap b\mathbb Z=\{0\}=\operatorname{lcm}(0,b)\mathbb Z$ ✓). On
$\mathrm{Sub}(\mathbb Z)$, $\alpha\circ\gamma=\mathrm{id}$ and
$\gamma\circ\alpha=\mathrm{id}$: this is a lattice **anti-isomorphism**, not an
abstraction at all. So:

> ~~**Sound and complete on $\mathrm{Sub}(\mathbb Z)$; complete-but-unsound as a
> transformer of $\cap$ on $\mathcal P(\mathbb Z)$.**~~
> **Sound and complete on $\mathrm{Sub}(\mathbb Z)$; sound but forward-incomplete
> (imprecise) as a transformer of $\cap$ on $\mathcal P(\mathbb Z)$.**
> (Struck, SEED-106, 2026-08-14.)

**Sound $\ne$ complete, spelled out for this pair.**
- *Soundness (over-approximation):* $S\subseteq\gamma(\alpha(S))$ — every set is
  contained in the subgroup it generates. ✓ Always. $\{2,3\}\subseteq 1\mathbb Z$.
- *Completeness / no-loss:* $\alpha(\gamma(n))=n$ for every $n$ — the abstraction
  is a **Galois insertion**: no two abstract elements are redundant. ✓ Always.
- These are the two conditions, and **both hold**, and the abstraction is still
  lossy: $\alpha(\{2,3\})=\alpha(\{1\})=\alpha(\mathbb Z)=1$. Three distinct
  concrete objects, one abstract value. A Galois insertion is complete *on the
  abstract side* — it says nothing about concrete information retained. **This
  is the standard error the mandate warns about**, and stating "$\alpha\gamma=
  \mathrm{id}$, therefore nothing is lost" is exactly it. Nothing is lost
  *about the generated subgroup*; everything else is gone.
- Orthogonally, *forward completeness for an operation* ($\alpha\circ f=
  f^\#\circ\alpha$) holds for $f=\cup$ with $f^\#=\gcd$, and **fails** for
  $f=\cap$ with $f^\#=\operatorname{lcm}$, by the $\{2\},\{3\}$ witness above —
  ~~and there it fails by being unsound, not merely imprecise.~~ **and there it
  fails by being imprecise only; soundness holds (SEED-106, boxed proof above).**
  Soundness and
  completeness are independent axes and this single example separates them
  **— it separates them in the direction "sound but forward-incomplete", which is
  the ordinary direction, not the alarming one.**

**What this settles for message 0126.** The "join" the message wants lives in
$D=(\mathbb N,\mid)$. Under the natural Galois connection to sets of integers it
is the operation the adjunction does **not** preserve; the one it does preserve
is gcd. So "gcd supplies the overlap and origin memory forms the join" has the
adjunction backwards: gcd is the adjoint-preserved operation and needs no
memory, while lcm is the one requiring an existence proof — which is available
in $\mathbb Z$ (§2) and unavailable in $\mathbb Z[\sqrt{-5}]$ (§3c).

---

## 5. `AdaptiveUniformBound.lean`: is the bound uniform in the claimed parameter?

*Read as text only. There is no Lean toolchain in this session and I make no
claim that any of it typechecks.*

**Prose header (lines 5–6).** "Every exact adaptive identification policy is at
least as deep as the least parallel uniform observable horizon."

**What the file actually proves** (`globalObservableHorizon_le_adaptive_depth`,
line 87):
$$\texttt{globalObservableHorizon}\ M\ \texttt{alphabet}\ \le\ \texttt{tree.depth}.$$

Auditing "uniform" against the definitions:

- `BoundedFutureEq step observe fuel x y` (`ObservableHorizon.lean:18`) is
  $\forall\,w,\ |w|\le\texttt{fuel}\Rightarrow\dots$ — **uniform in the
  experiment word.** ✓
- `ObservableClosesAt` is $\forall x\,y\,\forall\texttt{action}$ — **uniform in
  the state pair and in the action.** ✓
- `globalObservableHorizon` is `Finset.univ.sup` over $X\times X$ of
  `pairObservableHorizon` — a genuine **sup over all ordered state pairs**, so
  uniform in states rather than pointwise. ✓
- `tree` is universally quantified, so "every exact adaptive identification
  policy" is honest. ✓

So the four uniformities the prose implies are the four the Lean statement has.
**The bound is uniform in the parameters claimed. No wrong-variable defect.**

Two real caveats, neither fatal, both worth recording:

1. **The alphabet parameter is suppressed in the prose and in the name.**
   `globalObservableHorizon M alphabet` depends on `alphabet : List A`, and the
   leastness result (`globalObservableHorizon_isLeast`) and both theorems here
   carry the hypothesis `complete : ∀ action : A, action ∈ alphabet`. The
   formal statements are therefore clean — the dependence is an explicit
   argument and the soundness side-condition is an explicit hypothesis. But the
   *name* says "global" and the *header prose* says "the least parallel uniform
   observable horizon", definite article, no mention of the alphabet. With an
   incomplete `alphabet` the definition still elaborates to a natural number,
   still typechecks, and is neither least nor a lower bound. This is the
   CLAUDE.md pattern — a quantity quoted without the parameter it depends on —
   caught here at the level of prose only. Suggested fix: rename to
   `observableHorizonOver M alphabet`, or add a doc line "relative to
   `alphabet`; a lower bound only under `complete`". No proof changes.

2. **The lower bound is loose in a way the docstring understates.**
   `adaptiveIdentification_closesAt_depth` (line 72) proves closure by deriving
   `left = right` from `IdentifiesAll` plus `trace_eq_of_boundedFutureEq` —
   i.e. it shows the depth-`tree.depth` kernel is the *identity relation*, which
   is far stronger than "closes". `globalObservableHorizon` is the least fuel at
   which the kernel merely **closes**, and closure permits genuinely
   future-equivalent distinct states. So the gap between the two sides is not
   only the adaptivity gain; it also contains the whole Nerode collapse. The
   control example is consistent with this: $1<2$ (line 131), a strict gap, but
   its strictness is not by itself evidence about adaptivity, since part of the
   gap is definitional. The file does not claim otherwise; the risk is a reader
   quoting the strictness as an adaptive-versus-parallel separation. It is a
   lower bound, and it is correct; it is not tight, and nothing here claims a
   matching upper bound.

3. **Axiom footprint.** Line 122 uses `native_decide`, which admits
   `Lean.ofReduceBool` — a compiler-trust axiom, not a kernel reduction. In a
   repository whose protocol says "no postulates", a `native_decide` in the
   control example is a postulate wearing a tactic's clothes. It appears inside
   an `example`, so it does not leak into the named theorems; that is the right
   containment, but it should be stated rather than left for an auditor. (For a
   two-state automaton `decide` would very likely suffice.)

---

## 6. What should be corrected, concretely

1. `notes/ARITHMETIC_LIFE_LCM_JOIN.md`: add the $a=b=0$ case to the leastness
   proof, or restrict formula (1) to $(a,b)\ne(0,0)$; state that the ambient
   lattice is $(\mathbb N,\mid)$ with top $0$; state that in a general domain
   the identity presupposes existence (§3), and that the correct hypothesis is
   *GCD domain*.
2. Same note: re-score message 0126's forecast. The worked example
   ($12=2\cdot 6$, $18=2\cdot 9$, then $g=6$ recomputed) supports branch `0.15`
   (memory ornamental), not `0.80`.
3. Message 0126: name the order. "Divisibility join" and "topos/subobject join"
   are opposite operations (§1).
4. `AdaptiveUniformBound.lean`: one doc line recording the alphabet-relativity
   of `globalObservableHorizon` and the `native_decide` axiom use.

## 7. Prior art

Nothing here is new mathematics and none is claimed. §1 is the standard
divisibility/ideal anti-isomorphism; §3(c) is the textbook non-GCD example in
$\mathbb Z[\sqrt{-5}]$; the lcm$\Rightarrow$gcd implication in a domain is
classical (Bourbaki, *Alg. Comm.* VII; Cohn, *GCD domains*); §4's
$\gamma\dashv\alpha$ is Cousot–Cousot Galois-insertion machinery applied to a
one-generator case. The contribution is **auditing**: the corpus's claim was
stated without its order, without its edge cases, and without the
sound/complete distinction, and all three are now written down.
