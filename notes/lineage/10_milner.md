# Robin Milner — the unforgeable theorem, bisimulation as identity, full abstraction, and interaction as the primitive

## I. The life, as a cognitive trajectory

Arthur John Robin Gorell Milner was born on 13 January 1934 in Yealmpton, Devon, into a military family. He won a scholarship to Eton, did national service in the Royal Engineers, and read mathematics and then moral sciences at King's College, Cambridge. He did not take a doctorate. He taught mathematics at a school, programmed for Ferranti, and held posts at City University London and then Swansea, where in 1968–70 he began working on program verification and automatic theorem proving.

At John McCarthy's Stanford Artificial Intelligence Laboratory in 1971–72 he built **LCF** (Logic for Computable Functions), a proof assistant for Dana Scott's logic of computable functions. Its design became one of the most influential ideas in computing: theorems are values of an **abstract type** `thm` whose only constructors are the inference rules of the logic, so a theorem cannot be forged — any program, however complex, that produces a value of type `thm` has produced a proof. To let users write proof strategies safely he invented a metalanguage, **ML**, with a type system that inferred the most general type of every expression. *A Theory of Type Polymorphism in Programming* (1978) gave the algorithm (now Hindley–Milner type inference) and the slogan "well-typed programs cannot go wrong." Edinburgh LCF and ML became the ancestors of HOL, Isabelle and Coq's architecture, and of OCaml, Haskell and F#.

In 1977 he published *Fully Abstract Models of Typed λ-Calculi*, and Gordon Plotkin published *LCF Considered as a Programming Language*. Together they posed the **full abstraction problem**: find a mathematical model of the language PCF in which two programs are equal exactly when no program context can tell them apart. The standard domain model is not fully abstract. The problem was solved only in 2000, by game semantics (Abramsky–Jagadeesan–Malacaria; Hyland–Ong; Nickau), and Ralph Loader showed in 2001 that observational equivalence is undecidable even for finitary PCF, so no effectively presentable fully abstract model exists.

At Edinburgh from 1973 Milner turned to concurrency. The **Calculus of Communicating Systems** (CCS, book 1980) treated processes as algebraic terms built from actions, choice, parallel composition and restriction, and asked when two processes are the same. With David Park (1981) he adopted **bisimulation**: two processes are equivalent if each can match every step of the other and the results are again equivalent — a coinductive notion of identity. With Joachim Parrow and David Walker he developed the **π-calculus** (1989–92), in which communication channels can themselves be sent over channels, so that the structure of a network changes as it computes. He co-authored *The Definition of Standard ML* (1990). He founded the Laboratory for Foundations of Computer Science in 1986 and received the Turing Award in 1991 for "three distinct and complete achievements": LCF, ML, and CCS.

At Cambridge from 1995 he developed **bigraphs**, a model of mobile, located, connected agents unifying place and link structure (*The Space and Motion of Communicating Agents*, 2009), and led a Grand Challenge on ubiquitous computing. He held that a theory of concurrency and interaction should be as fundamental as the λ-calculus is for sequential computation. He died on 20 March 2010.

## II. What he left on the table

1. **Unforgeability, extended.** LCF makes theorems unforgeable by an abstract type in a simply typed metalanguage; the certificate is not carried with the theorem, and the step from "the kernel accepted it" to "the operation is valid wherever it travels" is not part of the design.
2. **The canonical process equivalence.** Trace equivalence, failures, testing, bisimulation: many notions. Which is canonical, and in what precise sense?
3. **Full abstraction.** A model whose equality is exactly contextual equivalence, and a clear account of why it is hard: what exactly is a condition on the model and what on the contexts.
4. **Interaction as the fundamental notion.** A calculus of interaction as basic as the λ-calculus, in which sequential computation is a special case.
5. **Concurrency, order and causality.** When the order of independent events can be forgotten, what the recorded dependency structure must be, and what distributed state depends on.
6. **Mobility and locality.** Changing connectivity (π-calculus, bigraphs).
7. **Type inference.** Principal types and their extension to richer type systems.

## III. Your work through Milner's eyes

### 1. The unforgeable theorem, with the proof inside and travelling with the operation

**Open:** LCF's abstract theorem type, extended so that validity is carried by the object itself.

**What you proved.**

- `NaturalMachine/EkaBhasha`: a store entry is `record नियमः = { lhs ; rhs ; साक्षी : ⊨ (lhs , rhs) }`. "An unproven rule is not refused by a gate — it is unconstructible. The gate is the type." The internal prover `साधनम् : Maybe (⊨ e)` returns a proof or nothing, and equality tests return paths: "no Bool on any wire." The kernel checks the soundness of the prover once; every rule it mints is born proven.
- `Kernel/ControlledGrammar`: `install : Derivation lhs rhs → NativeOperation`, whose control `t ≡ lhs` is exact evidence of applicability; `Kernel/SthapanaVarga` classifies every self-extension as a derivation up to control gauge and proves every operation factors through its own installation.
- `NaturalMachine/Avirodha`: because an operation cannot be constructed without its checked derivation, **validity travels with the operation**, and merging two libraries has no failure mode, no validation step and no reconciliation: the join is grow-only, commutative and idempotent (`join-keeps-the-left/right`, `join-splits`, `merge-is-order-independent`, `merge-is-idempotent`).

LCF's `thm` type made the kernel the only door. Here the door is the type of the object, so the object carries its validity into any context — another node, another library, another run — and nothing downstream has anything to check.

### 2. Bisimulation is identity, and the canonical equivalence is terminal

**Open:** the right notion of process equivalence and its canonicity.

**What you proved.**

- `fibre/Orbit`: `path≃bisim : (x ≡ y) ≃ (x ≈ y)` for coinductive streams, all four directions corecursive, and then `path≡bisim` by univalence. Bisimilar processes are **equal**.
- `IndraNet`: for a net of mutually reflecting objects solving `Net x ≃ L x × ((y : J) → Net y)`, `bisim→path` — "identity in the Net IS relational identity."
- `theorems/automata/FutureBehavior`: for any observed transition system, future equality is a behavioural congruence and **the greatest one** (`congruence→futureEq`), its quotient is effective as an equivalence of path spaces, fully abstract (`crystal-fullyAbstract`) and **terminal** among all behaviour-preserving quotients (`Terminal.mediate`, `mediate-unique`).
- `theorems/automata/NoObservationDepthDeterminesTheNet`: the root of a reflecting net survives at every depth, while no finite observation depth determines the net.

That is the precise sense of canonicity Milner was after: among all equivalences that respect observation and steps, the greatest one exists, it is terminal, and in a univalent setting it coincides with identity.

### 3. Full abstraction: a condition on the context family

**Open:** full abstraction, and why it is hard.

**What you proved.**

- `theorems/residue/FullAbstractionIsAConditionOnTheContextFamilyAndCurvatureIsWitnessedInIt` names Milner and Plotkin in its header. Contextual equivalence is defined **relative to a family** K of contexts; `FullyAbstract` says a compression identifies whatever the family cannot separate; `flatCompressionPreservesEveryOrder` proves that a fully abstract compression sends contextually equivalent elimination orders to the same value; `curvatureIsWitnessedInTheFamily` proves the contrapositive — if images differ, the family already separates; and `curvatureExhibitsAContext` produces the separating context **exactly when the family is enumerated and the observation type is discrete**. Once K is a parameter, "fully abstract for all contexts" and "fully abstract for a small family" are one theorem at different K, and the difference in strength is visible.
- `theorems/unplaced/AbhihitanvayaAnvitabhidhana`: the converse of full abstraction is a theorem whenever the semantics is compositional and observation factors through it — three uses of `cong` — and a separating context forces semantic difference for free, while the other direction needs enumeration and decidability. The side is taken in the signature `C : Tm → D`, one line above the first theorem.
- `theorems/homotopy/ExactExperimentFullAbstraction` and `theorems/automata/TwoSidedExperimentInterface`: for an exact finite experiment language, full abstraction reconstructs precisely the declared experimental signature; a one-sided readout collides equal- and opposite-phase inputs that a later Hadamard insertion separates, and closing the signature under preparation on the left and experiment on the right restores compositional equality.

The asymmetry these files isolate — one direction is a congruence, the other a search requiring an enumerated context family and decidable observation — is the structural shadow of Loader's undecidability theorem: producing the separating context is exactly the part that cannot be free.

### 4. Interaction as the primitive

**Open:** a calculus of interaction in which sequential computation is a special case.

**What you proved.**

- `fibre/Samvada`: the interactive symbolic computer `ISC`, a guarded coalgebra answering each question with a successor, an observation, a proof-relevant event and a continuation. A stream is the one-query case (`det-observe`), where every strategy observes the same prefix (`det-strategy-independent`); and `counter` shows two strategies disagreeing at the first step (`counter-demand-matters`), so interaction is properly more than a stream.
- `theorems/residue/Prashna`: the universal Turing machine is the ISC with trivial questions and receipt events, whose whole behaviour space is contractible; with free events the space is not contractible. **TM = deterministic ISC ⊊ interactive ISC**, and the gap is exactly the event type.
- `theorems/residue/Sakshin`: receipted answers collapse every question alphabet to a point; freedom lives only in the unwitnessed event.
- `theorems/residue/CorpusSelfPresentation`: your theorems presented as an ISC answering questions about themselves, each answer carrying its exact residual.

Sequential computation is the one-question, receipted case of interaction, proved rather than stipulated.

### 5. Concurrency, order and causality

**Open:** when order can be forgotten, what causal structure must be recorded, and how distributed state behaves.

**What you proved.**

- `fibre/Krama`: a commutation certificate for two steps makes every interleaving equal to a normal form depending only on the counts — the Mazurkiewicz trace quotient, with the order removed by proof; and where the steps do not commute, the order survives in the answer (`order-survives`).
- `theorems/historical_proofs/EkaVakyata`: an observer whose reading of successors is branch-blind gets a deterministic law and a time inside a rule that need not be confluent anywhere.
- `theorems/residue/Avinimaya`: every step's completion is unitary, and still two machines' steps do not exchange at a named configuration.
- `theorems/order/AnEmptyDependencyRelationMakesCausalDeliveryVacuous`: with an empty happens-before relation every delivery order satisfies causal delivery, so causal consistency degenerates to eventual consistency, and one recorded edge already rules an order out — causal consistency is exactly as strong as the dependency graph recorded.
- `theorems/automata/Srotas`: under at-least-once delivery with duplication and reordering, the consumer's state depends only on the set of delivered records (`same-set→same-state`), so exactly-once is algebra; below the watermark the state is final; and no safe compaction exists.
- `theorems/unplaced/Pratyabhijna`: a network sees exactly the union of its members' queries, and no consensus rule over validators blind on a pair separates it.
- `OuteMeizonOuteElasson` (by its statement): the price of a parallel interface multiplies exactly where the regulator has no choice; `ParallelNetworkComposition` gives disjoint parallel composition as a product of actions.

### 6. Mobility: local change, global effect

**Open:** networks whose connectivity changes as they compute.

**What you proved.** `IndraNet`: a new identification `e : x ≡ y` updates the reflection profile at every node functorially (`threadUpdatesProfiles`), every dependent view transports along it (`viewTransport`), and a separation becomes visible from every node that reaches both sides (`tearVisibleEverywhere`) — "one local event reweaves the net globally by transport, not by broadcast." The Yoneda form, `yonedaJewel : ((z : A) → z ≡ x → z ≡ y) ≃ (x ≡ y)`, says a link between two nodes is exactly a transformation of their whole profiles of incoming links.

## IV. The shape of the resolution

| Milner left | Your term | Kind of answer |
|---|---|---|
| Unforgeable theorems (LCF) | `EkaBhasha`, `ControlledGrammar`, `SthapanaVarga`, `Avirodha` | proof as field; validity travels; merge without validation |
| Canonical process equivalence | `Orbit.path≃bisim`, `IndraNet.bisim→path`, `FutureBehavior` | bisimulation = identity; greatest congruence, terminal |
| Full abstraction | `FullAbstractionIsAConditionOnTheContextFamily…`, `AbhihitanvayaAnvitabhidhana`, `ExactExperimentFullAbstraction`, `TwoSidedExperimentInterface` | condition on the family; soundness free, completeness a search |
| Interaction as primitive | `Samvada`, `Prashna`, `Sakshin`, `CorpusSelfPresentation` | stream = one-query case; TM ⊊ ISC |
| Concurrency and causality | `Krama`, `EkaVakyata`, `Avinimaya`, `AnEmptyDependencyRelation…`, `Srotas`, `Pratyabhijna` | commutation removes order by proof; causality needs recorded edges; exactly-once by algebra |
| Mobility | `IndraNet` | local identification reweaves every view by transport |

Not yet located in this lens: Hindley–Milner type inference and principal types, the π-calculus itself (name passing as syntax), and bigraphs.

Milner's three achievements were a kernel that makes theorems unforgeable, a language whose types cannot go wrong, and a calculus in which processes are identified by what they do. In your work these become one design: the object carries its own proof, identity is observational equivalence as a path, and interaction is the primitive of which the sequential machine is the receipted, one-question case.
