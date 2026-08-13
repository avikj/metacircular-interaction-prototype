# Minimal signals for identifying a finite language extension

**Status.** Exact finite theorem and prior-art identification. The signature,
candidate interpretations, query domain, response semantics, and truthful
teacher/oracle are fixed in advance. This is formal identification, not a model
or empirical claim of human learning.

## 1. Fixed formation boundary

Let `Σ⁺=Σ∪{u}` be a supplied language extension. Let `H` be a finite declared
class of possible interpretations of the new control, represented as response
functions

\[
  h:Q\to Y.
\]

The unknown intended interpretation is `h_*∈H`. A labeled interaction at
`q∈Q` returns the atomic satisfaction fact `(q,h_*(q))`.

For each rival `h≠h_*`, define its disagreement set

\[
  D_h=\{q\in Q:h(q)\ne h_*(q)\}.
\]

If `D_h` is empty, the response language cannot distinguish `h` from `h_*`;
the candidate class is observationally non-identifiable at this interface.

## 2. Minimal teaching-signal theorem

**Theorem 1.** A finite set `S⊆Q` of truthfully labeled interactions uniquely
identifies `h_*` within `H` iff

\[
  S\cap D_h\ne\varnothing
  \qquad\text{for every }h\in H\setminus\{h_*\}.       \tag{1}
\]

Consequently the minimum number of nonadaptive labeled interactions is the
transversal number of the disagreement hypergraph `{D_h:h≠h_*}`.

**Proof.** If (1) holds, every rival disagrees with the target on some labeled
query and is eliminated. Conversely, if `S∩D_h=∅` for a rival, then `h` and
`h_*` have identical labels on `S`, so `S` does not uniquely identify the
target. □

This is exactly the target teaching-set theorem: the target's teaching
dimension is the minimum size in (1). For the identity/swap expansions on
`{0,1}`, either query `0` or `1`, together with its returned label, suffices;
zero queries cannot distinguish the two.

## 3. Atomic-satisfaction Rosetta entry

`OBSERVER_REVISION_IS_ATOMIC_SATISFACTION` interprets `(q,y)` by

\[
  h\models(q,y)\quad\Longleftrightarrow\quad h(q)=y.
\]

Theorem 1 says that the conjunction of the selected target atoms has singleton
model class inside `H`:

\[
 \{h\in H:h\models(q,h_*(q))\text{ for every }q\in S\}=\{h_*\}. \tag{2}
\]

Institutional satisfaction transports these atoms along a supplied language
morphism. The teaching theorem selects a sufficient family of atoms after the
target model and candidate class are fixed. Neither theorem forms the new
signature, candidate class, or target.

## 4. Three protocols, three different minima

There is no protocol-independent “minimal signal.”

### Benevolent nonadaptive teacher

The teacher knows `h_*` and presents all labels at once. The exact cost is the
target teaching dimension of Theorem 1.

### Adaptive membership queries

The learner chooses `q`, receives `h_*(q)`, and updates the live version space.
The exact optimum is the minimum worst-case depth of a decision tree whose
internal nodes are queries and whose edges are responses. It can differ from
the target teaching dimension because the learner does not know which target
the teacher intends. `ACTIVE_OBSERVER_DESIGN` supplies a one-step gain policy
but explicitly does not prove this global optimum.

### Equivalence/counterexample oracle

The learner proposes `h`. The oracle either confirms `h=h_*` or returns a
query `q` with `h(q)≠h_*(q)` and the target label. In a finite exact class,
proposing any live hypothesis eliminates at least that hypothesis after each
counterexample, so identification terminates after at most `|H|-1`
counterexamples and one confirmation. This bound is elementary, not generally
minimal; the oracle's counterexample policy matters.

Angluin's query-learning framework is the mature vocabulary for distinguishing
these protocols. Teaching dimension instead models a helpful teacher choosing
a succinct labeled sample. Conflating them hides who chooses the interaction
and what they know.

## 5. Existing corpus theorem under another vocabulary

The repository had already solved the global sibling of Theorem 1.
`COMPOSITIONAL_CRYSTAL_THEOREM` defines contextual dimension as the minimum
number of contexts whose observation vectors separate **every** pair of
behavioral classes—an all-pairs hitting set. Theorem 1 uses only the star of
pairs `(h_*,h)` incident to one intended extension.

Thus:

\[
\begin{array}{ll}
\text{contextual dimension} & \text{one probe basis identifies every state},\\
\text{target teaching dimension} & \text{one labeled set identifies }h_*.
\end{array}
\]

The active-observer machinery already contains the disagreement tables needed
for both. What was missing was the target-versus-global distinction, not a new
optimizer.

## 6. Linguistic and pedagogical boundary

For inherited Pāṇinian control, a labeled derivational contrast—same visible
stage, different later operation under `laṭ` versus `loṭ`—can eliminate a
candidate semantics that forgets the inherited designation. But the theorem
assumes the candidate derivational ontologies and admissible contrasts have
already been articulated. It cannot adjudicate Pāṇini versus Patañjali from
surface forms alone when their accounts posit different state objects.

Likewise, a formal teaching set is not a lesson and teaching dimension is not
human difficulty. It assumes a perfectly consistent learner that knows `H`
and returns the unique consistent target. Real learners may not share the
hypothesis class, parse the examples alike, retain the labels, or adopt the
teacher's ontology. Those are empirical and developmental questions.

## 7. Positive answer and residual

Within a fixed finite extension problem, the minimally sufficient added signal
is exact: a labeled atom set hitting every rival's disagreement set. Outside
that scope, the earlier obstruction survives.

> Examples identify an interpretation only relative to a supplied signature,
> candidate class, query semantics, and interaction protocol. If the encounter
> revises any of those, formation has reopened and teaching dimension no longer
> answers the question.

## Prior art and rigor boundary

**Proved here:** Theorem 1, equation (2), the identity/swap minimum, and finite
termination of the stated counterexample protocol.

**Prior art:** teaching dimension is the Goldman--Kearns formal measure for the
smallest target-identifying example set; Dana Angluin, “Queries and Concept
Learning,” *Machine Learning* 2 (1988), distinguishes membership,
equivalence, subset, superset, disjointness, and exhaustiveness queries. The
publisher record and Angluin paper text were checked. No novelty claimed.

**Already in the corpus:** global all-pairs hitting-set characterization in
`COMPOSITIONAL_CRYSTAL_THEOREM`; finite probe tables and myopic active choice
in `ACTIVE_OBSERVER_DESIGN`; atomic response satisfaction in
`OBSERVER_REVISION_IS_ATOMIC_SATISFACTION`.

**Not proved:** efficient computation of the minimum hitting set, optimal
adaptive query complexity for arbitrary `H`, formation of `H` or `Q`, truthful
or realizable physical oracles, or any human-learning claim.
