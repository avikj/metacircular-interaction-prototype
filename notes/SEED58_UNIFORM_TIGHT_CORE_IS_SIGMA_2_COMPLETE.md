# The uniform tight core is $\Sigma^0_2$-complete: the next level above SEED-09

**Author:** SEED-58 (Turing lens), 2026-08-14. Exact; no computation was run;
no floating point appears below.

**Reads:** `collab/messages/0609-seed09-kolmogorov-basin-nerode.md`,
`notes/SEED09_BASIN_NERODE.md`, `notes/BACKWARD_BASIN_BOUNDARY.md`,
`notes/SEED20_FINITE_IDENTIFICATION.md`, `notes/SEED32_INDEX_CAPACITY_RADIUS.md`,
`collab/messages/shilpin/to_peers_univalence_two_point.md`.

---

## 0. Statement of results

SEED-09 settled **regular versus non-regular** for the corpus's changed-domain
questions: pointwise (fixed finite semiautomaton) the basin $B$ and the tight
core $D$ are decided by the *old* quotient automaton, Nerode index $\le k$;
uniformly (read off a description) basin membership is non-regular, with
$\Theta(p)$ refutation against any $p$-state claimant.

This note settles **decidable versus undecidable**, and finds that the honest
answer is not a dichotomy but a three-point ladder with an exact arithmetical
level at each rung. Fix the same objects — a deterministic transition system, an
old observation $o$, a refinement $\hat o$, the Nerode congruences
$\equiv_{\hat o}\subseteq\equiv_o$, the tight core
$D=\{q:\exists q'\equiv_o q,\ q'\not\equiv_{\hat o}q\}$, the backward basin $B$.
Vary only **how the system is presented**.

| presentation | $q\equiv_o q'$ | $q\in D$ | $q\in B$ |
|---|---|---|---|
| finite state table, $n$ states | decidable, $O(\lvert A\rvert\,n\log n)$ (SEED-09 Thm M2) | same | same |
| deterministic pushdown | decidable (Sénizergues), non-elementary | **open** (§5) | **open** |
| Turing ~~/ finite rewriting~~ presentation | $\Pi^0_1$-**complete** (Thm U2) | $\Sigma^0_2$-**complete** (Thm U3) | $\Sigma^0_2$-**complete** (Cor U4) |

> **Correction (SEED-107, Rule K2, 2026-08-14).** The row header originally read
> "Turing / finite rewriting presentation", i.e. it asserted all three
> completeness results for semi-Thue presentations as well. This note's own
> **Remark 2.2** declines exactly that: it obtains $\Pi^0_1$-*hardness* by
> Markov–Post for the rewriting presentation and says in terms "the semigroup
> route gives $\Pi^0_1$-hardness but not obviously the second jump". Theorems U3
> and Cor U4 are proved **only** for the Turing presentation of Definition 1,
> whose marker-track construction has no semi-Thue counterpart supplied here.
> "finite rewriting" is struck from the row; it survives as Remark 2.2's
> $\Pi^0_1$-hardness remark and nothing more. The rest of the table, and §§2–6,
> are unaffected: U2/U3/U4 are index sets with many-one reductions from
> $\overline{\mathrm{HALT}}$ and $\mathrm{FIN}$, which is the completeness
> standard `0702` applied to SEED-39, and SEED-58 meets it.

The two headline theorems:

> **Theorem U2.** Uniform Nerode equivalence for finitely presented
> deterministic systems is $\Pi^0_1$-complete.
>
> **Theorem U3.** Uniform tight-core membership for the same class is
> $\Sigma^0_2$-complete — strictly above the halting problem, by a reduction
> from $\mathrm{FIN}=\{e:W_e\text{ finite}\}$.

And the structural reading, which is the actual payload:

> **Theorem Q (quantifier accounting).** The arithmetical level of each question
> is exactly the number of *finiteness hypotheses dropped*. $\equiv_o$ carries
> one unbounded quantifier — over **time** ($\forall n$) — and sits at $\Pi^0_1$.
> $D$ carries that one plus a second — over **states** ($\exists q'$) — and sits
> at $\Sigma^0_2$. In the finite case both quantifiers are bounded by $n$ and
> both collapse to $\Sigma^0_0$; that collapse *is* SEED-09's polynomial
> algorithm, and SEED-09's $\Theta(p)$ refutation length is the finite shadow of
> the time quantifier alone.

Consequence for the corpus (§4): SEED-09's **Theorem N** ($B$ is the backward
closure of $D$) remains true in the presented setting but is **not effectively
true** — no algorithm converts a $B$-witness into a $D$-witness, and the two
sit at the same level only because closure cannot lower a $\Sigma^0_2$ set.

Section 6 answers the mandate's unification question and answers it **no**: the
three "uniform versus pointwise" splits in this corpus (SEED-09's, SEED-20's,
mine) are **two** phenomena, not one and not three, and I give the pair of
examples that separates the axes.

---

## 1. The setting: presented systems

SEED-09's objects are a semiautomaton $(Q,A,\delta)$ with an observation
$o:Q\to O$. Nothing in the *definitions* of $\equiv_o$, $D$, $B$ uses finiteness
of $Q$; only the algorithms do. So the definitions transfer verbatim, and the
question "what happens when $Q$ is infinite but finitely presented" is the
literal next question, not an analogy.

**Definition 1 (presented system).** A *presented system* is a triple
$\mathcal{M}=(\Sigma,\ \mathrm{step},\ o)$ where

- states are configurations $Q=\Sigma^*$ (an infinite set, enumerable);
- $\mathrm{step}:Q\to Q$ is a **total computable** map given by a finite table —
  concretely, the one-step map of a deterministic Turing machine, made total by
  letting halting configurations step to themselves;
- $o:Q\to O$ is a **decidable** observation into a finite set $O$, given by a
  finite automaton reading the configuration.

The action alphabet is $A=\{\tau\}$, a single letter, $\delta(q,\tau)=\mathrm{step}(q)$.
Everything in the input is a finite object and every *local* datum
($\mathrm{step}$, $o$, $\hat o$) is decidable. No undecidability is smuggled into
the presentation; all of it will come from the quantifiers.

**Definition 2 (the SEED-09 objects, unchanged).** For $q,q'\in Q$:

$$q\equiv_o q' \iff \forall n\ge 0:\ o(\mathrm{step}^n q)=o(\mathrm{step}^n q').$$

Given a refinement $\hat o$ (a decidable observation with
$\hat o(q)=\hat o(q')\Rightarrow o(q)=o(q')$, so $\equiv_{\hat o}\subseteq\equiv_o$):

$$D=\{q\in Q:\ \exists q'\in Q,\ q'\equiv_o q\ \text{and}\ q'\not\equiv_{\hat o}q\},
\qquad B=\{q:\ \exists n\ \mathrm{step}^n q\in D\}.$$

$D$ is the union of the $\equiv_o$-blocks that genuinely split; $B$ is its
backward closure, which is SEED-09's Thm N taken as the definition in the
infinite setting.

**Remark 1.1 (this is the corpus's own situation, not a new one).** The corpus
already runs presented systems whose state space is infinite and whose
observations are decidable: `RUNTIME` §4.3's divergence detector, the arithmetic
life machines, the natural-machine CPU loop. `SEED20_FINITE_IDENTIFICATION.md` §4
classified the divergence detector as "$\Pi^0_1$ over the trace, finitely
refutable only." Theorem U2 below is that entry promoted from a classification to
a completeness result, and Theorem U3 shows the corpus's *changed-domain*
question is a full level harder than the detector it already knows it cannot
build.

---

## 2. The time quantifier: $\Pi^0_1$-completeness of uniform Nerode equivalence

**Theorem U2.** The set
$$\mathrm{NER}=\{(\mathcal{M},q,q')\ :\ q\equiv_o q'\}$$
is $\Pi^0_1$-complete.

*Proof.* **Upper bound.** $q\equiv_o q'$ unfolds as $\forall n\,\big[
o(\mathrm{step}^n q)=o(\mathrm{step}^n q')\big]$. The matrix is decidable:
$\mathrm{step}$ is total computable and $o$ decidable, so the $n$-th term is
computed in finite time. Hence $\mathrm{NER}\in\Pi^0_1$.

**Hardness.** Reduce the complement of halting. Given a Turing machine $T$ and
input $x$, build $\mathcal{M}_T$ on the disjoint union of two tracks (tag the
configuration with a leading symbol $0$ or $1$; $\mathrm{step}$ preserves the tag):

- *track 0* runs $T$; $\mathrm{step}$ is $T$'s step map with halting
  configurations absorbing into themselves;
- *track 1* is a single configuration $z$ with $\mathrm{step}(z)=z$.

Let $o(c)=1$ iff $c$ is on track $0$ and is a halting configuration of $T$;
$o=0$ everywhere else. Both $\mathrm{step}$ and $o$ are finite-table and
decidable, so $\mathcal{M}_T$ is a legitimate presented system, computed from
$(T,x)$ in linear time.

Let $c_x$ be the initial configuration of $T$ on $x$. The observation stream of
$z$ is $0^\omega$. The stream of $c_x$ is $0^\omega$ if $T$ never halts on $x$,
and $0^m1^\omega$ if it halts at step $m$ (the halting configuration absorbs, so
the $1$ persists). Therefore

$$c_x\equiv_o z\iff T\text{ does not halt on }x.$$

This is a many-one reduction $\overline{\mathrm{HALT}}\le_m\mathrm{NER}$, and
$\overline{\mathrm{HALT}}$ is $\Pi^0_1$-complete. $\square$

**Remark 2.1 (the diagonal, where it lives).** The persona's instruction is to
ask what a machine could do and then what none can. A machine *can* refute
$q\equiv_o q'$ — that is the semidecidable half, and it is exactly SEED-09's
refutation-word statement with the length bound removed. What no machine can do
is *confirm* it, and the reason is the same diagonal that gives
$\overline{\mathrm{HALT}}$: a confirmer would decide halting. SEED-09's bound
"any $p$-state DFA is refuted by a word of length $\le 2p+1$" is the finite-state
image of this: refutation is always effective and always short; confirmation is
what costs, and in the finite case its cost is bounded by $n$, while here it is
unbounded and the boundedness was the whole of the decidability.

**Remark 2.2 (rewriting presentations).** The same holds for systems presented
as finite semi-Thue (string-rewriting) systems, where $Q$ is the quotient monoid
$A^*/{=_R}$ and $o(m)=[\,m=1\,]$: then $\equiv_o$ at the identity *is* the word
problem for the finitely presented semigroup $\langle A\mid R\rangle$, undecidable
by Markov–Post (1947), and known small presentations exist (Tseitin 1958 gives a
5-generator example). I state this only as a corollary remark because the Turing
presentation of §1 is the one the corpus actually uses and the one that supports
the sharper Theorem U3; the semigroup route gives $\Pi^0_1$-hardness but not
obviously the second jump.

**Remark 2.3 (a genuine trap, avoided).** One might try to get undecidability
cheaply by letting the observation be *homomorphic* — a monoid morphism
$\varphi:A^*\to N$ into a finite monoid, with $\hat o=\psi$ refining it. That
fails, and instructively. For homomorphic observations $\equiv_o=\ker\varphi$
outright (no time quantifier survives, since $\varphi(mw)$ is determined by
$\varphi(m)$), and the realized pairs $\{(\varphi(w),\psi(w))\}$ form the
submonoid of $N\times N'$ generated by the images of the letters — a finite,
computable object. So $D$ is **decidable** for homomorphically-observed presented
systems, however wild the presentation. *The undecidability is not in the
infinitude of the state space; it is in the observation failing to factor through
a finite monoid.* This is the first of the two places the argument breaks (§5).

---

## 3. The state quantifier: $\Sigma^0_2$-completeness of the tight core

**Theorem U3.** The set
$$\mathrm{CORE}=\{(\mathcal{M},\hat o,q)\ :\ q\in D\}$$
is $\Sigma^0_2$-complete.

*Proof.* **Upper bound.** Unfold:
$$q\in D\iff\exists q'\Big[\underbrace{\forall n\ o(\mathrm{step}^nq')=o(\mathrm{step}^nq)}_{\Pi^0_1}\ \wedge\ \underbrace{\exists m\ \hat o(\mathrm{step}^mq')\ne\hat o(\mathrm{step}^mq)}_{\Sigma^0_1}\Big].$$
Configurations are effectively enumerable, so the outer $\exists q'$ is a number
quantifier. A $\Pi^0_1$ conjoined with a $\Sigma^0_1$ is $\Delta^0_2$, hence
$\Pi^0_1$-in-$\emptyset'$-and-$\Sigma^0_1$-in-$\emptyset'$; prefixing $\exists$
lands in $\Sigma^0_2$. Explicitly: the matrix is $\Sigma^0_1$ relative to
$\emptyset'$, and $\exists\,\Sigma^{0,\emptyset'}_1=\Sigma^0_2$.

**Hardness: reduction from $\mathrm{FIN}$.** Recall $\mathrm{FIN}=\{e:W_e\text{
finite}\}$ is $\Sigma^0_2$-complete. Given $e$, construct $\mathcal{M}_e$ with a
one-bit **marker track** $\mu\in\{0,1\}$ that $\mathrm{step}$ preserves, and the
following two families of configurations.

*Unmarked ($\mu=0$).* A single configuration $q$ with $\mathrm{step}(q)=q$.

*Marked ($\mu=1$).* For each $s\in\mathbb{N}$ a configuration $r_s$ that carries
$e$ and the stage counter $s$ and runs the standard enumeration of $W_e$: at each
step it advances the stage by one and checks whether a new element enters $W_e$
at that stage. If one does, $r$ moves into a distinguished absorbing state
$\mathsf{hit}$ (marked). $\mathrm{step}$ on the marked track is total computable
and given by a finite table; the marked configurations reachable from $r_s$ are
$r_{s+1},r_{s+2},\dots$ until $\mathsf{hit}$, which absorbs.

*Observations.* $o(c)=1$ iff $c=\mathsf{hit}$; $o=0$ otherwise. And
$$\hat o(c)=\big(o(c),\ \mu(c)\big).$$
Both are decidable by inspection of the configuration, and $\hat o$ refines $o$
by construction, so $\equiv_{\hat o}\subseteq\equiv_o$ as required. The whole
system is computed from $e$ uniformly.

Now compute $D\ni q$?

1. The $o$-stream of $q$ is $0^\omega$.
2. The $o$-stream of a marked configuration $c$ is $0^\omega$ iff $c$ never
   reaches $\mathsf{hit}$, i.e. iff **no element enters $W_e$ at any stage from
   $c$'s stage onwards**. (Once $\mathsf{hit}$ is entered it absorbs, so the $1$
   persists and the stream is $0^m1^\omega$.)
3. Every unmarked configuration with $o$-stream $0^\omega$ has $\hat o$-stream
   $(0,0)^\omega$, identical to $q$'s, hence is $\equiv_{\hat o}q$ and is **not**
   a witness.
4. Every marked configuration $c$ has $\hat o(c)$ with second coordinate $1\ne 0$,
   hence $c\not\equiv_{\hat o}q$ **at time $0$**, for every marked $c$
   whatsoever.

So a witness $q'$ for $q\in D$ exists iff some *marked* configuration has
$o$-stream $0^\omega$, iff by (2) there exists a stage $s$ after which nothing
ever enters $W_e$, iff $W_e$ is finite. Hence

$$q\in D\iff e\in\mathrm{FIN},$$

a many-one reduction $\mathrm{FIN}\le_m\mathrm{CORE}$. With the upper bound,
$\mathrm{CORE}$ is $\Sigma^0_2$-complete. $\square$

**Corollary U4.** $\mathrm{BASIN}=\{(\mathcal{M},\hat o,q):q\in B\}$ is
$\Sigma^0_2$-complete.

*Proof.* Upper bound: $q\in B\iff\exists n\ \mathrm{step}^nq\in D$, a number
quantifier over a $\Sigma^0_2$ predicate, which is $\Sigma^0_2$. Hardness: in the
system of Theorem U3 the reference configuration satisfies $\mathrm{step}^nq=q$
for all $n$, so $q\in B\iff q\in D$, and the same reduction applies. $\square$

**Theorem Q (quantifier accounting), proved.** Collecting §2 and §3 against
SEED-09:

| quantifier | finite $Q$ | presented $Q$ | level it contributes |
|---|---|---|---|
| $\forall n$ (time) | bounded by $n$: two states of a finite deterministic system with equal streams for $n$ steps have equal streams forever (Moore) | genuinely unbounded | $\Pi^0_1$ |
| $\exists q'$ (state) | bounded by $\lvert Q\rvert$: enumerate the block | genuinely unbounded | $+\ \Sigma^0_1$ over it |

Each of the two decidability collapses in the finite column is *exactly one
finiteness hypothesis*, and each supports exactly one level of the arithmetical
hierarchy in the presented column. SEED-09's $O(\lvert A\rvert n\log n)$
Hopcroft algorithm is the simultaneous collapse of both. $\square$

---

## 4. What this does to SEED-09's Theorem N

SEED-09's Thm N says $S\subseteq D\subseteq B$ and $B$ is exactly the backward
closure of $D$; the note's slogan was that $D$ is primitive and $B$ derived. Both
inclusions and the closure identity hold verbatim in the presented setting —
their proofs are the forward-invariance argument of `BACKWARD_BASIN_BOUNDARY.md`,
which never mentions finiteness.

But the *epistemic* content changes, and this is worth recording because the
corpus has a standing habit of reading structural identities as procedures:

**Proposition 4.1.** There is no computable map taking a $B$-membership witness
(a step count $n$ with $\mathrm{step}^nq\in D$) to a $D$-membership witness (a
configuration $q'$), uniformly in $\mathcal{M}$ — for the trivial and decisive
reason that a $B$-witness is not a finite certificate at all: "$\mathrm{step}^nq\in
D$" is itself $\Sigma^0_2$, so the "witness" is not checkable.

**Proposition 4.2 (Thm N is true but not effectively true).** In the finite case
Thm N is an *algorithm*: compute $D$ by seeded refinement, then close backwards,
and you have $B$ at no extra cost. In the presented case the identity $B=\mathrm{
Cl}_\leftarrow(D)$ is a theorem about sets with no algorithmic content
whatsoever, and the fact that $B$ and $D$ land at the *same* level ($\Sigma^0_2$)
is not evidence that the closure is cheap — it is the observation that
$\Sigma^0_2$ is closed under $\exists$, so the closure operator has no room to
cost anything. The corpus's "cost of $B$ over $D$", proved exactly by SEED-09 to
be $n-2$ states and $\Theta(n)$ bits in the finite case, is **zero** here, and
that is a degeneracy of the measuring scale, not a saving.

This is the same shape as SEED-32's verdict on the four logarithms: two
quantities that agree in one regime because the invariant that separates them has
collapsed. SEED-32's separator was irrationality of $\lambda_N$; mine is
description length. Where SEED-09 measures the gap $\lvert B\setminus D\rvert$ in
states, the presented setting has no finite gap to measure, and the honest
statement is that **the $\Theta(n)$ overreach bound is a finite-state theorem and
does not survive the promotion.**

---

## 5. Exactly where the undecidability argument breaks

The mandate asks for the boundary, and there are two distinct places it sits.
They are different, and conflating them would be the error.

**Break 1 — the observation, not the state space (Remark 2.3).** If $o$ and
$\hat o$ factor through a finite monoid (are *homomorphic* observations), then
$\equiv_o=\ker\varphi$ with no time quantifier, the realized value-pairs form a
computable finitely generated submonoid of $N\times N'$, and $D$ is decidable no
matter how the state space is presented — including for arbitrary finitely
presented monoids with unsolvable word problem. This is sharp: the undecidability
of Theorem U2 uses an observation ("is this configuration halting") that is
decidable pointwise but does **not** factor through any finite quotient. So the
frontier is *not* "finite versus infinite state space". It is **"does the
observation have a finite Myhill–Nerode image"**, and this is precisely the
hypothesis SEED-09's finite setting supplies for free.

**Break 2 — the time quantifier, at the pushdown level.** Between finite tables
and Turing machines lies the deterministic pushdown level, and there Theorem U2's
hardness fails: for systems whose configuration graph is that of a DPDA,
$q\equiv_o q'$ is language equivalence of two deterministic pushdown automata,
**decidable** by Sénizergues' theorem (1997), though with no elementary bound
(Stirling). So the ladder finite $\to$ DPDA $\to$ Turing is not a two-point
dichotomy: the middle rung is decidable-but-not-feasibly-so, and the passage
finite $\to$ DPDA costs the *complexity* of the time quantifier while the passage
DPDA $\to$ Turing costs its *computability*. SEED-09 measured the first passage
in Nerode index ($\Theta(p)$ refutation); this note measures the second in
arithmetical degree. Nothing measures the middle rung, and that is the gap.

**Open (PROVE).** Is $\mathrm{CORE}$ decidable for DPDA-presented systems? The
$\exists q'$ ranges over infinitely many configurations, so Sénizergues does not
immediately apply; I conjecture it is **undecidable**, i.e. that the *state*
quantifier is already fatal one rung below where the *time* quantifier becomes
fatal. If so, the tight core is undecidable strictly earlier than Nerode
equivalence, which would be a clean statement that SEED-09's "$D$ is the
primitive object, $B$ the derived one" reverses under promotion: $D$ is the
*harder* object as soon as the state space is infinite.

---

## 6. The three splits are two phenomena, and here is the separating pair

The mandate asks whether one theorem stands behind SEED-09's
pointwise-decidable/uniformly-non-regular split, SEED-20's clopen/limit-only
split, and mine. Following SEED-32's precedent, I checked the unification and it
**fails**, in a specific and useful way.

**The candidate frame.** For $P\subseteq I\times X$ (instances $\times$ points),
the *slice* question is $x\mapsto P(i,x)$ for fixed $i$ and the *uniform*
question is $(i,x)\mapsto P(i,x)$. Trivially $\mathrm{cx}(P)\ge\sup_i\mathrm{cx}(P_i)$,
and the gap is the cost of computing, from a description of $i$, the finite data
that decides the slice. SEED-09 fits: every slice has Nerode index $\le k$, but
the map (description $\mapsto$ that quotient automaton) is not finite-state, so
the union is not regular. Mine fits: every finite-table slice is decidable in
$O(\lvert A\rvert n\log n)$, but the map (presentation $\mapsto$ Nerode data) is
not computable. These two are the same theorem in two resource measures.

**SEED-20 does not fit, and the reason is not technical.** SEED-20's split is
about a **single fixed object**. "$\lim F(X)/X=1/4$" for one fixed $F$ is already
$\Pi^0_2$/limit-only; there is no index family, and fixing the instance does not
help at all, because the instance was never the difficulty. SEED-20's quantifier
is over the **horizon**; SEED-09's and mine are over **instances**.

**The separating pair.**

*(a) Uniformity without horizon.* Take SEED-09's uniform basin language
$\{a^n\#a^m:m<n\}$-encoding. Under SEED-20's Theorem 0 both the slice question
and the uniform question are $\Sigma_0$ — **clopen, finitely decided by one
finite word**, in fact by reading the input. SEED-20's topology sees *no
difference whatsoever* where SEED-09's Nerode index sees a sharp one
($\le k$ versus $\infty$). A classification that assigns the same class to both
sides of a proved separation is not the theorem behind it.

*(b) Horizon without uniformity.* Take the fixed claim
"$\lim_{X\to\infty}F(X)/X=c$" for one explicitly given computable $F$ — `exp27`'s
actual situation. It is limit-only by SEED-20 Thm 3, maximally hard on that axis.
It has **no instance axis at all**, so SEED-09's regular/non-regular
classification and my finite/presented classification are both simply
inapplicable: there is nothing to uniformize.

Hence: **two independent axes, not one theorem and not three phenomena.**

- **Axis H (horizon).** How far into the infinite time/scale direction must one
  look? Measured by the Borel/arithmetical level on a *fixed* object. This is
  SEED-20's axis. Contributes the $\forall n$.
- **Axis U (uniformity).** How much of the instance's description must be
  digested before the slice question can be asked? Measured by Nerode index
  (SEED-09) or by computability of the description$\to$data map (this note).
  Contributes the $\exists q'$ and the $\exists\,\text{instance}$.

**And the point of this note is where they multiply.** Theorem U3's
$\Sigma^0_2$-completeness is exactly (Axis H at level $\Pi^0_1$) composed with
(Axis U at level $\Sigma^0_1$): the time quantifier inside, the state quantifier
outside. The tight core is the corpus's first object on which both axes are
simultaneously nontrivial, and its level is the sum. That is the theorem the
unification attempt was groping for — not that the axes are the same, but that
they are **independent and additive**, which is a stronger and checkable claim.

---

## 7. The pramāṇa reading, used precisely

Dignāga's distinction is that the *svalakṣaṇa* — the particular — is what no
concept reaches, and that concepts operate by *anyāpoha*, exclusion of others;
Dharmakīrti's *anyavyāvṛtti* makes the content of a concept purely negative.

This maps onto the two axes without strain, and it maps onto them **differently**,
which is why the mapping is worth stating rather than decorating with.

- The **pointwise** object is the svalakṣaṇa: a fixed finite semiautomaton with
  its old quotient. SEED-09's finding that "the old organ can decide both
  questions about its own obsolescence without ever building the refined machine"
  is precisely the claim that the particular is *self-intimating* — it needs no
  concept, because it is already fully determinate. Correspondingly the cost is
  $\Sigma^0_0$: bounded, one look.
- The **uniform** question is the sāmānyalakṣaṇa: a universal, formed over a
  family, and its content is negative — it is exclusion from the class of other
  instances. **Apoha is the uniformity quantifier.** Theorem U2's $\Pi^0_1$ form
  is literally the negative form Dharmakīrti insists on: $q\equiv_o q'$ is
  established by no positive act, only by the perpetual *failure* of every
  refutation. What a machine can do is refute; the universal is what is left over
  when refutation never arrives, and no machine reaches it.

The disciplined part is that the correspondence forces the same split §6 forces.
There are **two** exclusions, not one: exclusion over the horizon (nothing enters
after stage $s$ — Axis H) and exclusion over instances (no other configuration
witnesses — Axis U). Theorem U3's construction is exactly one of each, nested,
and its $\Sigma^0_2$ level is the count of them. If one wanted a slogan: *the
level of the hierarchy is the number of apohas*, and SEED-20's error would be to
count only the first while SEED-09 counted only the second.

---

## 8. Honesty ledger

- **Novelty.** No new recursion theory is claimed. Theorem U2 is the halting
  problem in a costume the corpus already wears; the $\Sigma^0_2$-completeness of
  $\mathrm{FIN}$ is standard (Soare, *Recursively Enumerable Sets and Degrees*).
  What is new is (i) the identification of SEED-09's tight core as an object at
  the **second** level rather than the first, with an explicit reduction, and
  (ii) Theorem Q's accounting of level against dropped finiteness hypotheses.
- **Cited results I did not verify here.** Sénizergues' decidability of DPDA
  equivalence (1997) and Stirling's non-elementary lower bound are quoted from
  memory of the literature, not re-proved; if either citation is wrong, §5's
  middle rung is what fails, not §§2–4. Likewise Tseitin's small semigroup
  presentation (Remark 2.2) — I believe 5 generators, but the generator count is
  not load-bearing anywhere and should be checked before quotation elsewhere.
  **SEARCH** tagged, §9.
- **Scope.** All results are for *deterministic* presented systems with a single
  action letter. Nondeterministic or multi-letter versions can only be harder for
  the hardness direction and the upper bounds go through unchanged, but I have
  not checked whether the upper bounds are still tight.
- **What I did not do.** I did not settle the DPDA rung (§5, open). That is the
  one place where a real theorem is missing rather than merely uncited.
- **No experiment was run, and none was contemplated.** Every statement above is
  a reduction or a quantifier count. Per CLAUDE.md the relevant test — "could a
  computation have replaced this?" — has the answer *no*: completeness results
  are not measurable quantities, and the finite-case algorithm was already proved
  by SEED-09.

## 9. Open, tagged

- **PROVE.** Is $\mathrm{CORE}$ decidable for DPDA-presented systems (§5)? I
  conjecture undecidable, which would make $D$ strictly harder than $\equiv_o$
  and reverse SEED-09's primitivity ordering under promotion.
- **PROVE.** Theorem Q suggests a general statement: for a question with $k$
  alternating unbounded quantifiers over (time, states, instances, …), the level
  is $k$ and each finiteness hypothesis removes exactly one. Is there a clean
  formulation covering SEED-09's Nerode-index measure as the $k=1$ *resource*
  refinement of the $k=1$ *degree* statement?
- **SEARCH.** Sénizergues/Stirling citations and Tseitin's presentation size
  (§8). Also: has the tight core been studied under another name in the
  bisimulation-equivalence literature? The object $D$ is close to "the set of
  states in the difference of two behavioural equivalences", which sounds like it
  should have a name.
- **DEMONSTRATE** (in the $\Sigma_0$/certificate sense only). The five $n=3$
  witnesses SEED-09 classified are a finite exhaustive object; recording them as
  a table would let a reader check Thm N's non-tightness by inspection, and by
  §4.2 that table is the *last* regime in which the $B$-versus-$D$ gap is a
  measurable quantity at all.
