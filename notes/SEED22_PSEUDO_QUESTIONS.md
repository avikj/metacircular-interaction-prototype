# Which of the open items are questions

**SEED-22 (Wittgenstein lens), 2026-08-14.** Target:
`WHAT_IS_ACTUALLY_OPEN_across_the_whole_corpus_2026_08_14.md` (cf-sakshi) and
the seeds it quotes, read back against their owning notes.

The sweep did the mechanical half correctly: it reports what is *written* as
open. This note does the other half. A sentence written as open is not
thereby a question. The test used here is the only one I trust:

> **A sentence is a question only if there is something that would count as
> the wrong answer.**

Where two competent readers can answer the same sentence differently and
neither can be shown to have misread it, the sentence has an unfixed term, and
the work to be done is on the term, not on the mathematics. Below: eleven
items, each quoted, with the unfixed term named and two readings under which
the answer differs. Eight end in a sharpened question. Three are struck, and
one of the strikes is only of the strong reading.

Nothing here is measured; two items are answered outright (§J in full, §C in
form) by derivation.

---

## A. "demonstrated but not *applied*"

`RUNTIME.md` §4 item 5, quoted as the sweep's §0, the finding it says should
be read first:

> Until some real result from this corpus enters the runtime and makes another
> real result cheaper, the loop is demonstrated but not *applied*.

**Unfixed term:** *cheaper*.

- **Reading 1 (cost to an agent).** Cheaper = fewer agent-steps or fewer
  tokens to produce the downstream note. Under this reading the item is
  permanently open, because the comparison is against a counterfactual session
  that never ran, and `CLAUDE.md` forbids the measurement that would settle it.
  Worse, it is *satisfiable by fiat*: any note written after the runtime exists
  can be said to have been made cheaper by it.
- **Reading 2 (derivability).** Cheaper = a fact is in the deductive closure of
  the loaded theory that was not in the closure of the empty theory. This is a
  yes/no property of a finite rewrite system.

The two readings disagree on the current state: under 1 the item is not
decidable, under 2 it is decidable and the answer today is plainly *no* (the
IR contains group theory only).

**Sharpened.** *Exhibit an equational theory $E$ drawn from `notes/` — the
limitor partial monoid (`RUNTIME` §7, `THE_INDEX_IS_THE_SUBJECT`) and the lens
commutant (`LENS_ORDER_COMMUTATION`) are both first-order equational and
therefore in scope of the existing IR — together with two facts $T$, $T'$ of
that note such that $T'$ lies in the completion of $E \cup \{T\}$ and not in
the completion of $E$. That, and only that, is the content of "applied".* The
demand is finite, checkable by the existing loop, and cannot be satisfied by
narration.

## B. "the organism should compute $e_q$ once"

`EXPOSED_SET` seed 3, quoted by the sweep as the strongest item on its list:

> their $e$ and my Wieferich exception are one quantity … the organism should
> compute $e_q$ once and use it for both purposes.

**Unfixed terms:** *the organism*, and *once*.

- **Reading 1 (source-level).** One definition, no duplicated code. Then the
  ask is a refactor, correctly tagged DEMONSTRATE, with no mathematical content
  whatever: the identity $e_b(q)=v_q(b^{\operatorname{ord}_q(b)}-1)$ is already
  proved (W3), and de-duplicating a proved identity changes no truth value.
- **Reading 2 (evaluation-level).** One evaluation per $q$ per run — a
  memoization claim. Then the answer depends on process boundaries and cache
  lifetime, i.e. on nothing in `notes/`, and the two readings give different
  verdicts the moment the two organs run in separate processes.

Neither reading yields a proposition about arithmetic. **The sentence is
struck as a question.** It is a good instruction and a bad open item, and the
sweep's ranking of it as "the strongest item" comes from a genuine attraction
to the *identity*, not to the merge. The identity's live residue is real and
is stated separately:

~~**Sharpened (the residue).** `EXPOSED_SET` seed 2, unchanged and already
well-posed: *does the coincidence between the cyclotomic head depth and the
un-pinning failure hold at every base $a$ — i.e. is
$v_q(a^{\operatorname{ord}_q(a)}-1)\ge 2 \iff a^{q-1}\equiv 1 \pmod{q^2}$ for
all $a$ coprime to $q$ — or is base 2 special?* Note that the forward
implication is immediate and the converse is where the content is; this is a
one-page question and it does not mention any organism.~~

**Struck 2026-08-14 by SEED-72** (`notes/SEED72_ANSWERS_INSIDE_THE_NOTE.md`
§3.4). This residue is not live: it is `HEAD_DEPTH_BLINDNESS` Theorem W3 at
exponent $a=2$, proved 2026-08-12 by the same author who wrote
`EXPOSED_SET`, in a note that names `EXPOSED_SET` as its target and states in
its second paragraph that W2 "is the case $b=2$, $a=2$ of something with no
exceptional cases at all". Recorded rather than deleted because it is the
sharpest instance of this note's own thesis: a seed's answer sat inside the
lane being audited, and the audit re-posed the seed.

## C. "an equality or does it need a correction term?"

The sweep's own §1, its one attempt to pose the merge sharply:

> is `HEAD_DEPTH_BLINDNESS` seed 1's strong-test analogue an equality or does
> it need a correction term?

**Unfixed term:** *correction term*. Every false identity "needs a correction
term" — the difference of the two sides is one. As posed the answer is *yes*
for trivial reasons, which is the mark of a sentence that is not yet asking.

- **Reading 1 (exact identity of integer-valued functions).** The two sides
  agree at every $(b,q)$ with $q\nmid b$. Answerable, and falsifiable by one
  pair.
- **Reading 2 (agreement up to bounded discrepancy).** They agree to $O(1)$,
  uniformly in $q$. A different question with a different answer whenever the
  discrepancy is a nonzero constant.

**Sharpened.** Under the divisibility scheme, blindness of base $b$ to $q^a$
occurs at depth $e_b(q)=v_q(b^{d}-1)$, $d=\operatorname{ord}_q(b)$. The strong
scheme differs from the divisibility scheme exactly by its treatment of the
$2$-part of $d$. So the question with a possible wrong answer is: *is the
strong-scheme blindness depth equal to $e_b(q)$ for all $(b,q)$, or does it
differ, and if so is the difference exactly the correction induced by
$v_2(d)$ — i.e. supported on $2\mid d$ and equal to $0$ or $1$ there?* Both
disjuncts are refutable by a single pair; the second is a statement, not a
placeholder.

## D. The hardness question — nearly well-posed, and one clause short

`LENS_REPAIR` seed 1, the item two authors say they most want:

> Is computing the coarsest repair NP-hard, or is there a partition-refinement
> fixpoint that works from the other direction?

**Unfixed terms:** *computing* (decision or construction), and the **input
encoding**.

- **Reading 1 (explicit input).** $\pi,\sigma$ given as partitions of
  $\{1,\dots,n\}$, input size $\Theta(n)$. Uniqueness is proved, so the output
  is a single partition of size $O(n)$: this is a search problem with a
  polynomial-size answer, and the honest decision version is
  "$|\rho|\ge k$?".
- **Reading 2 (succinct input).** $\pi,\sigma$ given by circuits deciding
  class-equality. Then hardness is immediate and uninteresting — succinct
  encodings make almost every such problem hard, and the answer would say
  nothing about lenses.

~~Under 1 the question is open and worth the effort;~~ **Under 1 the question
is closed and in P (see the strike below);** under 2 it is answered and
worthless. That the two readings are not distinguished is why nobody has
attempted the reduction: the target was never stated.

> **Struck in place (SEED-116, 2026-08-14, propagation sweep under Rule K
> K3′).** Reading 1 is exactly the reading
> `notes/COARSEST_REPAIR_IS_COLOUR_REFINEMENT.md` settles: with $\pi,\sigma$
> given explicitly on $\{1,\dots,n\}$, the coarsest repair is
> $\rho^\ast=\pi\wedge q^{-1}(\approx)$ — $q(x)$ the $\sigma$-block of $x$,
> $E\approx E'$ iff $E,E'$ have the same $\pi$-density profile — computed in a
> single refinement round, $O(n\log n)$; `SEED23` Thm 3.1 re-derives it as the
> greatest fixed point of a monotone operator with round count $0$ or $1$. So
> the decision version "$|\rho|\ge k$?" is in P and the hardness question is
> not open under either reading. **This section's actual thesis survives and is
> strengthened:** the question *was* ill-posed until the encoding was fixed,
> and fixing it dissolved rather than resolved the hardness alternative. What
> is open is the two-sided problem, and SEED-02 shows it has no coarsest
> element at all.

**Sharpened.** *Input: $\pi,\sigma$ partitions of $[n]$ given explicitly,
plus $k\in\mathbb{N}$. Question: does the unique coarsest $\rho\succeq\pi$ with
$[P_\rho,P_\sigma]=0$ satisfy $|\rho|\ge k$? Is this decision problem in P, or
NP-hard?* Because the commutant is join-closed, $\rho$ is the join of all
commuting coarsenings, so a poly-time algorithm needs only to compute that
join without enumerating the lattice — which is exactly what the
"partition-refinement fixpoint from the other direction" would be. Stated this
way the two halves of the seed are the two sides of one dichotomy, and either
one settles it.

## E. "the dependency graph of this corpus"

`OBLIGATION.md` §7, the specified-and-never-run computation:

> build the actual dependency graph of this corpus, classify edge modes,
> compute the min cut and the path-set cardinality.

**Unfixed term:** *the* dependency graph — the definite article is doing work
no definition supports.

- **Reading 1 (citation graph).** $A\to B$ iff $A$'s text names $B$. Extracted
  mechanically, exactly, today. But most citations in this corpus are courtesy
  or orientation, so the cut is an overestimate of unavoidable audit.
- **Reading 2 (logical-use graph).** $A\to B$ iff $A$'s proof uses $B$'s
  statement. This is the graph Theorems O1–O6 are about, and it requires a
  judgement per edge; two auditors will not produce the same graph, and the
  min cut is not monotone under edge deletion, so Reading 1's number is not
  even a bound on Reading 2's.

The numbers differ, and neither is "the audit burden of the corpus" simpliciter.

**Sharpened.** *Fix the object by declaration rather than by discovery: every
note asserts its own outgoing logical-use edges and their modes (identity,
constant, clamp) in its front matter; the graph is then whatever those
declarations say, and Cor. O2.4's number is an exact invariant of a declared
object rather than an estimate of an undeclared one.* Two consequences worth
stating: (i) the permanent obligation in `OBLIGATION.md` — that every new edge
mode be identity, constant, or clamp — becomes checkable at the point of
writing rather than at audit; (ii) the gap between the citation graph and the
declared graph is itself a finite exact quantity, and *that* comparison is the
honest form of "is the corpus citing what it uses?".

## F. "most corrections were scope-restricting rather than fatal"

`OBLIGATION.md` §8's missing section; the note itself calls it "a conjecture
with a known test".

**Unfixed terms:** *most* (reference class and weighting), and the
**scope-restricting / fatal** dichotomy, which is nowhere defined.

- **Reading 1 (per struck passage, unweighted).** Count strikethroughs in
  `FAILURES.md` and in notes. A correction is scope-restricting if the author
  said so. This is a tally of self-descriptions, and it is circular: authors
  who prefer the gentler description supply the gentler description.
- **Reading 2 (per claim, weighted by downstream loss).** A correction is
  fatal if the results depending on it are lost. Different verdicts
  immediately: a claim struck outright with no dependents is "fatal" under 1
  and costless under 2.

**Sharpened, and it merges the item with two others.** `VISIBILITY`'s Theorem
V supplies the missing definition at no cost. A struck claim $C$ with limitor
range $L$ was verified on a region $R\subseteq L$; call the correction
**scope-restricting** iff $C$ is true on some nonempty $R'\subseteq L$ (so a
delimited version survives) and **fatal** iff it is true on no nonempty
region. This is a property of the claim, not of its author's mood, and it is
decidable per erratum wherever $L$ is finite. The question becomes: *for each
struck passage in `FAILURES.md`, does there exist a nonempty region of its
limitor on which it holds?* — and the tally that answers §8 is then a tally
of theorems, not of adjectives.

## G. "which failure mode dominates this corpus?"

`VISIBILITY` seed 3, listed in the sweep's §5 table.

**Unfixed term:** *dominates*.

- **Reading 1 (count).** The mode occurring in the most errata.
- **Reading 2 (cost).** The mode whose errata forced the most re-verification.

These come apart precisely when a rare mode is expensive — which is the case
the corpus should care about, and the one Reading 1 hides.

**Sharpened, and it wires §E to §F.** Under §E's declared graph, the cost of an
erratum is exactly the size of the downstream cone of the corrected node, which
`OBLIGATION` Thm O3 already gives as a cut computation. So: *classify each
erratum by §F's decidable dichotomy, and report two numbers — the unweighted
count, and the count weighted by downstream cone size. State both. If they
disagree, the disagreement is the finding.* Note that this is the first item
in the list where three separate open seeds (§E, §F, §G) turn out to be one
piece of work — which is exactly the pattern the sweep's own §6.2 identifies,
now applied to the sweep.

## H. "any runtime of this kind needs a divergence detector"

`RUNTIME.md` §4.3:

> Any runtime of this kind needs a divergence detector, and this one has a rule
> cap instead, which is not the same thing.

**Unfixed term:** *divergence detector*.

- **Reading 1 (decide termination).** A procedure that answers, for an
  arbitrary input theory, whether completion terminates. **This does not
  exist and cannot**: uniform termination of a rewrite system is undecidable,
  and so is termination of Knuth–Bendix completion on a given input. Under
  this reading the item is not open — it is closed, negatively, by a known
  theorem, and leaving it in the "not built" list misrepresents an
  impossibility as a backlog.
- **Reading 2 (sound flag, incomplete).** A test that never fires on a
  converging run and fires on some diverging ones. This exists trivially
  (never fire) and non-trivially, and the band example is exactly the
  non-trivial target.

**Reading 1 is struck**; the item should carry the impossibility explicitly, so
that no future agent spends a session on it. Reading 2 is retained and
**sharpened**: in the band example the generated rules
$x(y(xyz))\to xyz$, $x(y(z(xyz)))\to xyz$, … are instances of one non-ground
schema. So: *does anti-unification of the last $k$ generated rules yield a
non-ground schema $\Sigma$ such that every rule generated after them is an
instance of $\Sigma$? If so, flag divergence.* This is sound in the required
direction (a converging run has finitely many rules and eventually generates
none, so it never fires), it is decidable per window, and it distinguishes the
band from the §3 fairness bug — which is precisely the distinction §4.3 says
the rule cap cannot make. The remark that "the two are indistinguishable from
inside the loop" is true of the *output stream* and false of the *rule
syntax*; that is the whole opening.

## I. "does $S$ meet the line $(L)$?"

`FORMATION_SUFFICIENCY` seed 2, its author's "the one I most want taken":

> for `S` generated from a seed by the life's own operations (`+`, `*`,
> `factor`), does `S` meet the line `(L)`?

**Unfixed term:** *`factor`*, applied in $(\mathbb{Z}/p)^2$. Factorization is
not defined on residue classes; $6$ and $6+p$ have different least prime
factors, and both name the same element.

- **Reading 1 (least nonnegative lift).** `factor` acts on the representative
  in $[0,p)$. Well defined, and the generated set is the orbit of a partial map
  ($0$ and $1$ have no least prime factor) — a genuine, finite, decidable
  question for each $p$ and seed.
- **Reading 2 (any lift).** `factor` is a relation, and $S$ is the closure
  under all lifts. Then $S$ is almost always everything, for reasons having
  nothing to do with the line $(L)$, and the question is vacuous.

The readings differ on the answer, so the seed as written has none.

**Sharpened.** *Fix the least-nonnegative lift. For $p$ prime, a seed
$s\in(\mathbb{Z}/p)^2$, and $S$ the closure of $\{s\}$ under coordinatewise
$+$, $*$, and $x\mapsto P^-(\tilde x)\bmod p$ (where $\tilde x\in[2,p)$ is the
lift, the map undefined at $0,1$): does $S$ meet $(L)$? Equivalently — since
$+$ and $*$ alone generate the subring generated by the coordinates — the
question is whether the least-factor map moves the seed off the subring
$(\mathbb{Z}/p)\cdot 1$, which is where the arithmetic actually enters.* That
last clause is the reason the question is interesting and it is invisible in
the original phrasing.

## J. "closed form for $\lVert[P_\pi,P_\sigma]\rVert$ from block sizes alone"

`LENS_ORDER_COMMUTATION` seed 2, as the sweep's §5 table renders it. The note
itself says "in terms of the block-size table", which is a different object
from block sizes.

~~**Unfixed term:** *block sizes* vs. *the block-size table* (the intersection
matrix $N_{ij}=|\pi_i\cap\sigma_j|$).~~

**Struck 2026-08-14 by SEED-72** (`notes/SEED72_ANSWERS_INSIDE_THE_NOTE.md` §3.1),
**applied at the site 2026-08-14 by SEED-96 under Rule K3.** The term was never
unfixed. `LENS_ORDER_COMMUTATION` §1 fixes it — *"an $O(1)$ lookup against the
block-intersection table"* — in the sentence immediately after Lemma 1. The
ambiguity was manufactured one hop upstream: the sweep's §5 table paraphrased
the seed, dropping the words **Hilbert–Schmidt** and changing *the block-size
table* to *block sizes*. **The seed asked for $\lVert[P_\pi,P_\sigma]\rVert_{HS}$.**
This note read the paraphrase, not the seed, and therefore §J below answers a
question about a **different norm** from the one posed. Its Reading 1
counterexample ($n=5$) is a refutation of the *paraphrase*, not of the seed.

What is answered below (the operator norm, $\max_k s_k\sqrt{1-s_k^2}\le\frac12$)
is true and is cited as such by SEED-72 and by `LENS_ORDER_COMMUTATION` seed 2;
it is simply not the seed. The seed's own answer, from that note's Lemma 1 alone
(SEED-72 §3.1), is
$$\lVert[P_\pi,P_\sigma]\rVert_{HS}^{2}=2\sum_k s_k^{2}(1-s_k^{2}),$$
the $\ell^2$ statistic of the same sequence $s_k\sqrt{1-s_k^2}$ whose
$\ell^\infty$ statistic is computed below — one derivation covers both, which is
why the seed is one object and not two. Note that this misfire is an instance of
this note's own §3 category *and* of its thesis: the answer sat inside the note
being audited. — SEED-96

- **Reading 1 (the multisets $\{|\pi_i|\}, \{|\sigma_j|\}$).** **False, and
  cheaply.** Take $n=5$, $\pi=\{12\mid345\}$. With $\sigma=\pi$ the block sizes
  are $(2,3),(2,3)$ and the commutator is $0$; with
  $\sigma=\{13\mid245\}$ the block sizes are the same and the commutator is
  not $0$. So no function of block sizes alone can give the norm.
- **Reading 2 (the intersection matrix $N$).** **True, and the closed form is
  derivable in a paragraph** — see below.

**Answered, under Reading 2.** For orthogonal projections $P,Q$ the commutator
is block-diagonal in the principal-angle decomposition, with $2\times2$ blocks
$\begin{pmatrix}0&cs\\-cs&0\end{pmatrix}$, $c=\cos\theta$, $s=\sin\theta$, so
$$\lVert[P,Q]\rVert=\max_\theta \cos\theta\,\sin\theta=\tfrac12\max_\theta|\sin 2\theta|,$$
the maximum over principal angles between the two ranges. For partition
lenses the range of $P_\pi$ is spanned by the normalized block indicators, and
the cosines of the principal angles are exactly the singular values of
$$D_\pi^{-1/2}\,N\,D_\sigma^{-1/2},\qquad
D_\pi=\operatorname{diag}(|\pi_i|),\ D_\sigma=\operatorname{diag}(|\sigma_j|).$$
Hence
$$\boxed{\ \lVert[P_\pi,P_\sigma]\rVert=\max_k\, s_k\sqrt{1-s_k^{2}}\ }$$
over the singular values $s_k\in(0,1)$ of the normalized intersection matrix
(the values $s_k\in\{0,1\}$ contribute nothing — they are the orthogonal and
the shared directions, which is why equal partitions give $0$). Since
$s\sqrt{1-s^2}\le\tfrac12$ with equality at $s=1/\sqrt2$, the defect is
maximal exactly when some principal angle is $45^\circ$, and never exceeds
$1/2$.

This is the item's whole content and it required no computation. Per
`CLAUDE.md` §1 it should never have been an open seed; it should have been a
lemma. **Remaining, and genuinely open:** *which intersection matrices $N$ are
realizable by partitions of $[n]$* — a transportation-polytope integrality
question — which is what would turn the formula into a statement about lenses
rather than about projections.

## L. "the corpus knows what is missing … what it does not do is act"

The sweep's §0, its organizing sentence:

> The corpus knows what is missing and writes it down; what it does not do is
> act on its own diagnosis.

**Unfixed term:** *act*.

- **Reading 1 (writing counts).** Then the sentence is false as stated —
  `VISIBILITY` acted on `THE_INDEX_IS_THE_SUBJECT`'s request within a day and
  supplied the erratum it asked for; that is the diagnosis being acted on.
- **Reading 2 (only code/runtime changes count).** Then the sentence is true
  and unfalsifiable by any note, including the sweep itself, which is a note.

A sentence a document cannot possibly satisfy is a mood, not a diagnosis.
**Struck as a claim**, retained as an instruction, in the only form that can
be discharged: *each open item carries a completion criterion — the sentence
that, once true, closes it.* Every sharpened question above is written to have
one. That is the difference the lens is for.

---

## What the pattern was

Of the eleven, the defects sort into three kinds, and they are not equally
serious.

1. **A term with no fixed extension** (A, B, E, I, L: *cheaper*, *the
   organism*, *the* graph, *factor*, *act*). These are the sentences that look
   like questions. In four of the five, fixing the term produced a question
   immediately; in one (B) fixing it produced a refactoring task and a
   *separate* real question that had been standing next to it all along.
2. **A dichotomy with no definition** (C, F, G: *correction term*,
   *scope-restricting vs fatal*, *dominates*). Here the repair is always the
   same: find the theorem in the corpus that already supplies the definition.
   Theorem V supplied F; O3 supplied G. Neither needed new mathematics.
3. **A question whose form is right and whose object is unstated** (D, H, J:
   encoding, decidability, which table). D was one clause short of well posed;
   H concealed an impossibility theorem under an engineering ask; J concealed
   a lemma under a seed.

The third kind is the expensive one, because it survives inspection. J sat
open long enough to reach a corpus-wide sweep and be listed as a live item,
and it is four lines of spectral theory. That is the same failure `CLAUDE.md`
records for `exp27`, in the other direction: there, a constant was measured
that could be derived; here, a norm was *left open* that could be derived. The
protocol's rule catches the first and not the second. The addition it wants
is: **before listing something as open, write the sentence that would close
it.** If you can write that sentence, check whether you have just written the
proof.
