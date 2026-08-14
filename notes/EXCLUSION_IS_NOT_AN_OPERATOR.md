# Exclusion is not an operator on this repository's meaning-carriers

**Status: PROVED, checked.** `formal/cubical/ExclusionScope.agda`, Agda 2.6.3 +
cubical v0.5, `--cubical --safe`, `agda -W error ExclusionScope.agda` exits 0,
no postulates, no holes, no warnings.
Author `genius-02` (DIGNĀGA draw), 2026-08-14.
Draw: `collab/orchestration/draws/2026-08-14-genius-16.txt`, section
`DRAW for genius-02`.

---

## 0. The question, and whose question it is

`notes/INDIC_FORMAL_TRADITIONS_MAP.md` §2.2 states a conjecture and flags it
`[MINE]` — unsourced, its author's structural reading:

> Apoha is not Boolean complementation. The nearest *shape* is a complement
> relative to a position in a concept hierarchy, i.e. something closer to a
> **relative pseudo-complement in a lattice** than to `¬` in a Boolean algebra.

The same section records that no rigorous formal reconstruction of apoha was
located, and calls that absence the finding. §2.3 adds a warning: do not label
`formal/cubical/NaturalMachine/Obstruction.agda`'s residual "apoha", because
that residual is drawn from a fixed finite vocabulary list — the pre-given
universe apoha denies.

This note settles the §2.2 conjecture on this repository's own objects. **The
answer is negative, and the §2.3 warning becomes a theorem.**

All Sanskrit below, and every attribution of a verse to Dignāga, is carried
from `notes/APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` and
`notes/INDIC_FORMAL_TRADITIONS_MAP.md` §2.1. It is theirs, not mine. I read no
primary or secondary text; `WebFetch` is `EGRESS_BLOCKED`.

---

## 1. Which lattice — and this is the whole decision

An exclusion operator has to act on *something*. The Boolean gloss
("cow = not-(non-cow)") silently answers: the powerset $\mathcal{P}(X)$ of a
fixed universe. That answer is not available here, because this repository has
already fixed what a term/probe/channel *is*, and it is not a subset.

`runtime/render/channel.py` states it as the proposition that bounds its whole
package:

> A channel is a function `encode` on the declared language $L$. Hence
> $|\mathrm{image}| \le |L|$, and the partition of $L$ induced by `encode` is a
> **coarsening of equality**.

So a channel's content is its **fibre partition**, and `decode` structurally
returns the fibre, never a representative. `machinery/active_observer_design.py`
agrees independently: a `Probe` is a total map `response : State → Output`, and
`resource_distinguishability` prices exactly the pairs its kernel separates.
`notes/LEAKAGE_BOUND_ATTAINMENT.md` works throughout in the partition lattice —
partitions $\pi,\sigma$ of a finite $X$, their join $\pi\vee\sigma$, and block
counts of the join blocks.

Three independent lanes, one ambient object. **The lattice is $\mathrm{Eq}(X)$,
the equivalence relations on $X$ ordered by inclusion, not $\mathcal{P}(X)$.**
Everything below is a statement about $\mathrm{Eq}(X)$.

Order convention, as in the Agda: $R \sqsubseteq S$ means $R \subseteq S$ as
relations, i.e. $R$ separates at least as much — $R$ is finer. So $\Delta$ is
$\bot$, the all-relation is $\top$, and meet is intersection.

**Definition (exclusion).** For $P, S \in \mathrm{Eq}(X)$, an *exclusion of $P$
relative to scope $S$* is a greatest $E \in \mathrm{Eq}(X)$ with
$E \sqcap P \sqsubseteq S$. Read: the most that can be admitted while everything
$P$ still identifies stays inside the scope $S$. Taking $S = \Delta$ gives the
absolute reading the popular gloss presupposes. This is the relative
pseudo-complement, and nothing else; `Excludes` in the Agda is literally this
universal property.

---

## 2. The theorems

### T1 (control). On unrestricted relations, exclusion always exists.

For any $X$ and any $P,S : X \to X \to \mathsf{Type}$, pointwise implication
$E(x,y) := P(x,y) \to S(x,y)$ is the greatest relation with
$E \sqcap P \sqsubseteq S$. Agda: `Imp-meet`, `Imp-greatest`. Three lines,
general, constructive.

*Why it is here.* It isolates the cause. Nothing that follows is a failure of
relations, of constructivity, or of the definition of `Excludes`.

### T1′ (control). `Excludes` is satisfiable inside $\mathrm{Eq}(X)$.

For every $X$, the universal term excludes exactly equality:
$\top$ has exclusion $\Delta$ relative to $\Delta$. Agda: `top-excludes-id`.
So the two nonexistence theorems below are not artefacts of an unsatisfiable
definition.

### T2 (the mechanism, in positive form). Two admissible exclusions through a common third point already collapse.

> **Lemma.** Let $E, T_1, T_2$ be relations with $E$ an equivalence,
> $T_1 \sqsubseteq E$, $T_2 \sqsubseteq E$. If $T_1(u,w)$ and $T_2(v,w)$ then
> $E(u,v)$.

Agda: `joins-through`. Proof: $E(u,w)$, $E(v,w)$, symmetry, transitivity. **The
statement contains no negation at all.** Its corollary is the nonexistence
theorem (`no-exclusion`), and that corollary is the only place falsity appears.

This is worth saying plainly because it is the shape of the whole result: what
defeats the exclusion operator is not a complement, not a paradox, not
constructivity. It is **transitivity** — the fact that distinctions compose.
T1 gives the same lattice-free construction on relations, where transitivity is
not demanded, and there it works.

### T3. Three coordinate terms destroy the operator.

$X = \{a,b,c\}$. Let $P$ merge $a$ with $b$; let $T_{ac}$ merge $a$ with $c$ and
$T_{bc}$ merge $b$ with $c$. Then $T_{ac} \sqcap P = \Delta$ and
$T_{bc} \sqcap P = \Delta$, so both are admissible; but any equivalence above
both relates $a$ to $c$ and $c$ to $b$, hence $a$ to $b$, hence meets $P$ outside
$\Delta$. **No exclusion of $P$ relative to $\Delta$ exists.**
Agda: `three-coordinates-collapse` (the positive core) and `three-coordinates`.

Three points is minimal: on $|X| \le 2$, $\mathrm{Eq}(X)$ has at most two
elements and is a Boolean chain.

### T4a. Exclusion *does* exist relative to a declared vocabulary.

Let $X = \prod_{i \in I} Y_i$ with $I$ finite and every $|Y_i| \ge 2$, and let
$K_T := \{(u,v) : u_i = v_i \text{ for all } i \in T\}$ be the kernel of the
projection onto the coordinates $T \subseteq I$ — the *declared vocabulary*.
Then $K_T \sqcap K_{T'} = K_{T \cup T'}$ and $K_T \sqsubseteq K_{T'}
\iff T' \subseteq T$, so $T \mapsto K_T$ is an order-reversing bijection onto its
image. Within that image,

$$\{K_U : K_U \sqcap K_S \sqsubseteq K_T\} = \{K_U : T \setminus S \subseteq U\},$$

whose $\sqsubseteq$-greatest (= smallest index set) member is
$K_{T \setminus S}$, and $K_{T\setminus S}$ is itself in the set. So

$$K_S \Rightarrow K_T \;=\; K_{T \setminus S}.$$

**The exclusion operator exists on the declared vocabulary and *is* relative
complement in the Boolean algebra $\mathcal{P}(I)$ of vocabulary indices.**
Three lines; proved on paper here, and checked in Agda for $I = \{1,2\}$,
$Y_i = \mathsf{Bool}$, $S = \{1\}$, $T = I = \{1,2\}$ (so $K_T = \Delta$ and
$K_{T\setminus S} = K_{\{2\}} = \ker(\mathrm{snd})$) — Agda:
`declared-vocabulary`, which exhibits the two admissible vocabulary members, the
two inadmissible ones, and the domination.

### T4b. It does not survive leaving the vocabulary.

On the same $X = \mathsf{Bool} \times \mathsf{Bool}$ and the same pair
$(K_{\{1\}}, \Delta)$: the **parity** equivalence
$\mathrm{ker}(x,y \mapsto x \oplus y)$ is an equivalence relation the vocabulary
did not list, it is admissible, and it is incomparable with $K_{\{2\}}$. Both
reach the common third point, so by T2 nothing above both is admissible.
**No exclusion of $K_{\{1\}}$ relative to $\Delta$ exists in
$\mathrm{Eq}(\mathsf{Bool} \times \mathsf{Bool})$.** Agda:
`kpar-adm`, `no-vocabulary-extension`.

T4a and T4b are about *the same pair*. That is the point.

### T5 (paper only). The dual fails too, at the same three points.

The co-Heyting subtraction $\sigma \setminus \pi := $ least $\tau$ with
$\sigma \sqsubseteq \pi \sqcup \tau$ also fails on $\mathrm{Eq}(\{a,b,c\})$: take
$\sigma = \top$, $\pi = P$. Both $T_{ac}$ and $T_{bc}$ satisfy
$P \sqcup T = \top$; but $T_{ac} \sqcap T_{bc} = \Delta$ and
$P \sqcup \Delta = P \neq \top$, so no least exists. Not formalised — it needs
joins, i.e. transitive closure. Marked PROVED-on-paper, not checked.

**Corollary.** For $|X| \ge 3$, $\mathrm{Eq}(X)$ carries neither an exclusion
operator nor its dual. Neither the intuitionistic nor the paraconsistent repair
is available.

---

## 3. What this says about apoha, said with the scope stated

Dignāga's PS(V) V.25cd–38, *as reported by
`notes/APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` §2*, holds that the scope of "the
other" is not uniform: synonyms need not exclude one another, sub- and
superordinate terms interact asymmetrically, incompatible coordinate terms
exclude directly.

What the theorems above formalise, and only this:

| the claim | the exact statement | grade |
|---|---|---|
| apoha is not Boolean complementation in a pre-given universe | $\mathcal{P}(X)$ is not the ambient lattice of this repository's meaning-carriers; $\mathrm{Eq}(X)$ is, by `runtime/render/channel.py`'s own proposition | PROVED (that $\mathrm{Eq}$ is the right home is an argument from three corpus files, not a theorem) |
| the "relative pseudo-complement" repair conjectured in §2.2 `[MINE]` | **fails.** T3, checked | PROVED |
| the scope of exclusion varies with position | T4a + T4b: the same pair has an exclusion relative to the declared vocabulary and none absolutely | PROVED |
| **incompatible coordinate terms exclude directly** | T3 is exactly this configuration: three pairwise-incompatible coordinates, each excluding the other two, and no greatest "other" | PROVED as a lattice fact; the identification with the doctrine is MINE and unsourced |
| synonym / super-subordinate asymmetry | **not formalised.** Nothing here distinguishes those two cases | OPEN |
| Dharmakīrti's causal / error account | untouched | OPEN |

The strongest honest summary: **on this repository's meaning-carriers, "the
other" is not a function of the term. It is a function of the term and the
declared scope, and the absolute scope has no value at all.** The
Boolean gloss is not merely philosophically defeated; on this lattice it is
type-incorrect, because the object it would produce (T1's pointwise
implication) is not an equivalence relation and so is not a meaning-carrier.

I am **not** claiming this is a formal reconstruction of apoha. It is a negative
result about one candidate reconstruction — the one this corpus itself proposed
and flagged as unsourced. `notes/APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` is
graded EARNED by refusal; this note is the same genre with a checked theorem
attached.

### The §2.3 warning, upgraded

`formal/cubical/NaturalMachine/Obstruction.agda` carries
`failed : memb residual V ≡ false` — the residual is decidable non-membership in
a declared list `V`, and `extend V o = residual o ∷ V` grows that list. So the
scope is explicit and mutable in the file already. T4a says such a residual **is**
an exclusion operator, and identifies it: relative complement in the Boolean
algebra of the vocabulary index. T4b says it does not extend past the list.
§2.3 said "do not call it apoha". The reason is now exact rather than
cautionary: *the operator that exists there is precisely the one Dignāga's
scope analysis excludes, and the one that would deserve the name does not
exist.* A handle is still not a citation.

---

## 4. Prior art — searched before writing, and one correction to the corpus

`WebSearch` only; `WebFetch` `EGRESS_BLOCKED`. **Nothing below was read.**
Grade: CITED (search-summary), never characterised beyond the quoted summary.

1. **Classical lattice theory — NOT NOVEL, and the note claims nothing here.**
   Query: *lattice of equivalence relations partition lattice relatively
   pseudo-complemented Heyting algebra distributive*. Returned the standard
   facts: a Heyting algebra is a relatively pseudo-complemented distributive
   lattice; distributivity follows from the existence of relative
   pseudo-complements; Birkhoff's M₃/N₅ forbidden-sublattice criterion; and
   that the three-element partition lattice is the standard non-distributive
   example. **So T3 is, as a lattice fact, classical.** What is done here is the
   choice of lattice, the negation-free form of the obstruction (T2), and T4a/T4b.

2. **David Ellerman, "Negation and Implication in Partition Logic"
   (arXiv:2007.05192; 2025 version "On implication and negation in partition
   logic", PISRT).** Query: *Ellerman "Negation and Implication in Partition
   Logic" partition lattice implication not Heyting*. Search summary reports
   that partition logic is dual to Boolean subset logic, and that there are at
   least four equivalent definitions of an implication $\sigma \Rightarrow \pi$
   on partitions, the set-of-blocks one being: $\sigma \Rightarrow \pi$ is like
   $\pi$ except every block $B \in \pi$ contained in some $C \in \sigma$ is
   replaced by singletons.
   **This is directly on my topic and I have not read it.** What I may say
   without reading it is only what my own T3 forces: *whatever* that operation
   is, it is not right adjoint to meet on $\mathrm{Eq}(X)$ for $|X| \ge 3$,
   because no such adjoint exists. That is an inference from my theorem, not a
   characterisation of his paper. **Anyone continuing this line must read
   Ellerman first.** This is the single most likely place for my contribution to
   turn out to be a rediscovery.

3. **Correction to `notes/INDIC_FORMAL_TRADITIONS_MAP.md` §2.2.** That section
   records "Searched for, NOT FOUND: a rigorous formal reconstruction of apoha —
   Boolean, lattice-theoretic, formal-concept-analytic, or type-theoretic."
   Query: *Dignaga apoha formal semantics lattice theoretic reconstruction
   anyapoha mathematical* returns, via the SEP entry on Dharmakīrti, that
   **Hans Herzberger (1975)** developed a "resourceful nominalism" using
   possibilities from **Emil Post's theory of twofold propositions**, addressing
   how predicates apply non-arbitrarily without commitment to universals. A
   follow-up query for the Post/twofold detail returned nothing further.
   **This is a located formal-logical engagement with apoha that §2.2's sweep
   missed.** It is not lattice-theoretic and I have not read it, so §2.2's
   headline (no lattice/FCA/type-theoretic reconstruction located) may still
   stand — but "NOT FOUND" should be narrowed. Absence of a located source is
   not evidence of novelty, and this is a live instance of that.

4. **Apoha + Heyting specifically.** Query: *apoha exclusion Heyting algebra
   relative pseudo-complement formal reconstruction* — returned only generic
   Heyting-algebra material, no apoha hit. Recorded as: nothing located.
   That is not evidence of novelty.

---

## 5. Where the two drawn lenses disagree — the assignment, answered

The draw assigned **Ashby** ("a regulator must have at least as much variety as
what it regulates") against **Brahmagupta** ("find the composition law that
makes solutions a group"), and asked for the point where they give different
answers about the drawn material.

They differ on **whether exclusion is an operation.**

- **Ashby's demand is order-theoretic.** In `runtime/render/channel.py` it is
  exactly `certify_preservation`: a channel preserves a task iff
  $\ker(\mathrm{encode}) \sqsubseteq \ker(\mathrm{task})$ — requisite variety as
  a refinement inequality. This needs $\sqsubseteq$ and $\sqcap$ and nothing
  else. It is **available on $\mathrm{Eq}(X)$ for every $X$.**
- **Brahmagupta's demand is algebraic**: make the exclusions close under an
  operation. **T3 says it fails for $|X| \ge 3$; T5 says the dual fails too.**

So on this material Ashby is right and Brahmagupta is wrong — but only up to
scope, which is the interesting part. **T4a says Brahmagupta's demand is
satisfiable exactly on a declared coordinate sublattice**, where the composition
law exists and is set difference on the vocabulary index. The disagreement
between the two lenses is precisely located at the scope: order survives
everywhere, algebra survives only inside a declared vocabulary. That is the same
distinction `channel.py` enforces with its load-bearing word *declared*, and the
same one `restrict` exists to make visible.

The same split appears in
`collab/messages/workers/20260812T144712.509661Z--codex_quantum_process--0002.md`
independently: a faithful closed-unitary representation of a finite
transformation monoid exists iff the monoid is a group, and the recommended move
is "compute the unit group as its closed-reversible sector" — find the
sub-object on which the algebra does exist, and type the rest. Structurally the
same manoeuvre as T4a. I claim a parallel, not a theorem.

---

## 6. What I deliberately did not claim

- **Not claimed: novelty of T3 as lattice theory.** It is Birkhoff's M₃ in
  disguise, and §4.1 says so.
- **Not claimed: that Ellerman's partition implication is or is not this
  object.** I did not read the paper. I said only what my own theorem forces.
- **Not claimed: a formal reconstruction of apoha.** This is a refutation of one
  candidate, plus a scope theorem. The synonym and sub/superordinate cases of
  V.25cd–38 are not formalised and I do not know how to formalise them.
- **Not claimed: that `Obstruction.agda` is or should be called apoha.** T4a
  says what its residual *is*, in lattice terms. That is a description of the
  file's mathematics, not a rename, and I edited nothing there.
- **Not claimed: any relation between T4b's parity obstruction and
  `collab/messages/shilpin/contextuality_is_limit_not_coequalizer.py`.** Both
  are failures of a global object assembled from pairwise-admissible data, and
  in both the destroyer is a parity relation on binary coordinates. That is
  suggestive and I did not prove it is one theorem. **OPEN.**
- **No measurement, no fitted constant, no numerical run.** Nothing in this
  note has an error bar because nothing in it is measured.

---

## 7. Corpus files consumed, all eleven drawn, credited by name

Uniform draw, no triage. What each actually contributed:

- `runtime/render/channel.py` — **load-bearing.** Supplied the semantics
  (meaning = fibre partition), the proposition that no channel gains
  information, the word *declared*, and `restrict`, which is scope-variance
  already mechanised.
- `machinery/active_observer_design.py` — **load-bearing.** Probes as total
  response maps; `resource_distinguishability` as a kernel computation;
  `audit_revision` / `audit_revision_composition` as comparison across a change
  of model, i.e. across a change of scope.
- `notes/LEAKAGE_BOUND_ATTAINMENT.md` — **load-bearing.** Its Proposition A
  works in the partition lattice with joins and block counts; it is where I
  confirmed the ambient lattice is $\Pi(X)$ and not $\mathcal{P}(X)$.
- `collab/messages/shilpin/twist_memory_independence.py` — **used.** The
  coefficient-blind and phase-sensitive consumers are two different kernels on
  the same carrier, with `predictive_classes` returning the induced partition.
  A concrete instance of the same distinction varying with the declared probe.
- `notes/MELLIN_LAYER_GENERATION.md` — **used.** Its no-go ("head-only
  vocabulary is insufficient; a state carrying only layer names and coverage
  cannot reconstruct the expansion") is the same shape as T4b: the declared list
  does not determine the object.
- `collab/messages/workers/20260812T144712.509661Z--codex_quantum_process--0002.md`
  — **used**, as the structural parallel in §5.
- `collab/messages/shilpin/contextuality_is_limit_not_coequalizer.py` — **used**,
  as the flagged-OPEN parity coincidence in §6.
- `collab/messages/vajra/0001-unimodular-word.md` — **used for its discipline,
  not its content.** Its "Hostile scope audit" (the circle projection is
  two-to-one; the density claim concerns the closure of the nondegenerate
  shadows, not literal endpoint coverage) is a scope correction of exactly the
  kind §3's table is trying to be. The unimodular word itself is the contrast
  case: a free structure where every question has an answer.
- `.githooks/worktree-guard.sh` — **used for its move, honestly small:** it is
  written in shell so that it does not depend on the thing it forbids. Writing
  this result in checked Agda rather than in prose is the same move.
- `code/exp29_ltower_stats.py` — **contributed nothing mathematically**, and I
  will say why rather than pad it: it reports `var/mean^2 = 0.997` against a
  Poisson prediction and a "coherent fraction vs Fresnel" comparison. Under
  `CLAUDE.md` those are fitted comparisons standing in for an error analysis.
  It served here only as the negative example of the genre this note avoids.
- `collab/orchestration/workers/tasks.example.jsonl` — **contributed nothing**
  beyond the task/context record format. Two lines and a blank.

Also consumed: `CLAUDE.md`; `notes/APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md`;
`notes/INDIC_FORMAL_TRADITIONS_MAP.md` §§2.1–2.3;
`formal/cubical/BUILD.md`; `formal/cubical/NaturalMachine/Obstruction.agda`
(read, not edited); `formal/cubical/PMNoSection.agda` (header, for module
convention).

The assigned frontier field (random matrix theory) and ancient field (Babylonian
base-60) did not enter. I looked for a way in and did not find one I would
defend; inventing a connection to Plimpton 322 here would be decoration, and the
draw explicitly says the ancient field is prior literature, not ornament.

---

## 8. Rigor boundary

- **Checked in Agda (`--safe`, exit 0, `-W error`):** T1, T1′, T2, T3, T4a for
  $I=\{1,2\}$/$\mathsf{Bool}$, T4b, and uniqueness of the exclusion when it
  exists (`excludes-unique`).
- **Proved on paper, not checked:** T4a in general $I$ (three lines, §2); T5,
  the co-Heyting failure (needs transitive closure).
- **Argued, not proved:** that $\mathrm{Eq}(X)$ is the right ambient lattice for
  this repository's meaning-carriers. That is an argument from three corpus
  files. If someone shows the corpus's real carrier is something else, T3 still
  holds and stops being relevant.
- **My least-sure step, stated for refusal:** §3's identification of T3's
  three-coordinate configuration with Dignāga's *incompatible coordinate terms*
  is mine, unsourced, and made from a repository note's summary rather than from
  Katsura or the text. If it is wrong, the mathematics is untouched and the
  apoha framing of this note should be struck exactly as
  `APOHA_CHANGES_THE_TYPE_OF_ALIGNMENT.md` struck its own. **The second
  least-sure step is §4.2:** I have not read Ellerman, and if his implication is
  already this analysis under another name, the contribution reduces to T4a/T4b.
- **Open, tagged:** the synonym and super/subordinate scope cases (`PROVE` or
  `SEARCH`); the parity coincidence with
  `contextuality_is_limit_not_coequalizer.py` (`PROVE`); reading Ellerman
  arXiv:2007.05192 (`SEARCH`, blocked on egress); reading Herzberger 1975
  (`SEARCH`, blocked on egress).
