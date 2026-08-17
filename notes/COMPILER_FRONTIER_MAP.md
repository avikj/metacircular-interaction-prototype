# The compiler frontier map: what `runtime/CRYSTAL.md` is a re-specification of

**Status: ingestion / prior-art audit. No new mathematics. 2026-08-14.**
Occasioned by the owner's standing correction ("CONSUME... ALL COMPILERS
WORK", synthesize only across existing 2026 frontiers). Companion to
`notes/PRIOR_ART_INDEX.md`, which does the same job for the Agda libraries.

---

## The verdict, first paragraph, as asked

`runtime/CRYSTAL.md` is, to a first approximation, **egg + babble + TheSy /
CCLemma + TT Lite + LCF-style proof-carrying architecture, re-specified from
scratch under private names.** Layer by layer: §L0 is Unison's
content-addressed store (which CRYSTAL cites, so this one is honest) plus
Filliâtre–Conchon hash-consing; §L2 is *exactly* egg's proof-producing e-graph
(POPL 2021) sitting on Nieuwenhuis–Oliveras proof-producing congruence closure
(2005) — the repo's own `runtime/STATUS.md` already says "genuine
Nieuwenhuis–Oliveras proof forest", so L2 is a reimplementation the repo knows
is a reimplementation; §L3's "cost vector, keep nondominated routes" is the
e-graph **extraction** problem, NP-complete, with a 2024–2026 literature of
ILP / treewidth / MaxSAT / ASP / differentiable solvers and a public
benchmark harness (*extraction gym*); §L4 is self-adjusting computation
(Acar) / Adapton / incremental Datalog view maintenance, which `egglog` gets
for free from semi-naive evaluation; **§3.1 "derivation crystallization" is
`babble` (POPL 2023) — "Learning Better Abstractions with E-Graphs and
Anti-unification" — which is steps 1–4 of §3.1 verbatim, published, evaluated,
and faster than DreamCoder**, with the missing step 5 (rebuild and kernel-check
the proof) supplied by Klyuchnikov–Romanenko's **TT Lite / certifying
supercompilation for Martin-Löf type theory**, which is *literally the thing
§3.1 calls "proof-preserving supercompilation" and which already carries that
description in its own abstract; §3.2 "distinction compilation" is
Myhill–Nerode + Hopcroft/Paige–Tarjan partition refinement in the finite case
(CRYSTAL says so) and **CEGAR** in the infinite case (CRYSTAL does not say so);
§0's seed criterion is the observable shadow of **cut-introduction / proof
compression** (Hetzl) and, in its sharp form, of the **Gödel–Parikh speedup
theorems** — the fact that adding a true lemma can shorten later proofs
unboundedly is a theorem, not a thing to measure; §5's "trusted heart, small"
is the **LCF architecture** (Milner) and the **de Bruijn criterion**, both
older than everyone in this collaboration.

The one layer with a plausible unclaimed artifact is **§L1's typed-edge
table**, and specifically the `Order⟨≤⟩` kind with its `Sper` payload. Details
in §7 below.

**Citation grading.** WebFetch is EGRESS_BLOCKED in this channel; nothing below
was read. Every citation carries a grade:

- **[śabda]** — from a WebSearch result summary. Title, venue and claim are as
  reported by the search engine. *Not verified against the paper.*
- **[smṛti]** — from my own training memory, no search confirmation. Treat as a
  pointer to look up, not as a fact.
- **[pratyakṣa]** — read directly in this repository this session.

---

## 1. E-graphs and equality saturation — CRYSTAL §L2, §L3

### Correct name
**E-graph / equality saturation**, with the sub-areas *proof production
(explanations)*, *relational e-matching*, *e-graphs modulo theories*, *slotted
e-graphs*, *colored (contextual) e-graphs*, and *extraction*.

### Canonical citations
- Willsey, Nandi, Wang, Flatt, Tatlock, Panchekha, **"egg: Fast and Extensible
  Equality Saturation"**, POPL 2021 (PACMPL 5). Introduces the rebuilding
  ("deferred congruence maintenance") algorithm and, crucially, **e-class
  analyses** and the **explanation / proof-production mode**. [śabda]
- Nieuwenhuis & Oliveras, **"Proof-Producing Congruence Closure"**, RTA 2005 —
  the union-find-with-justifications + nearest-common-ancestor "explain"
  procedure that egg's proof forest is an implementation of. [śabda]
- Zhang, Wang, Willsey, Tatlock, **"Relational E-matching"**, POPL 2022 —
  e-matching as a conjunctive database query, worst-case-optimal joins. [śabda]
- Zhang et al., **"Better Together: Unifying Datalog and Equality Saturation"**
  (`egglog`), PLDI 2023 (PACMPL 7) — Datalog + EqSat, incremental execution,
  cooperating analyses, lattice-based reasoning. [śabda]
- Singher & Itzhaky, **"Colored E-Graph: Equality Reasoning with Conditions"**,
  2023 — many e-graphs' worth of conditional/contextual equalities in one
  structure at low overhead. [śabda]

### 2025–2026 state
- **Slotted e-graphs** (Steuwer et al., PLDI 2025, PACMPL): e-classes
  parameterised by *slots* abstracting free variables, so α-equivalent terms
  are represented once — first-class binders in e-graphs. [śabda]
- **E-graphs modulo theories** (Zucker et al., *"Omelets Need Onions"*, EGRAPHS
  2025, arXiv:2504.14340): semantic e-ids + bottom-up e-matching to get
  theory-aware equality (AC, linear arithmetic) instead of encoding theory
  axioms as rewrites. [śabda]
- **Extraction** is where the effort now is: extraction is **NP-complete**
  [śabda]; solvers include ILP (Peggy, SPORES, TenSat), dynamic programming
  (babble, eggcc), MaxSAT, ZDD, simulated annealing (KestRel), ASP
  (arXiv:2606.10644), differentiable relaxation (**SmoothE**, ASPLOS 2025),
  treewidth-based exact extraction (arXiv:2408.17042), and **e-boost**
  (arXiv:2508.13020). A public **extraction gym** benchmarks them, and the
  reported finding is sobering: *the expensive algorithms are "not
  significantly better than greedy" on the benchmark suite.* [śabda]
- **Completeness of equational proofs with equality saturation** — Remy Wang,
  2025 (a Birkhoff-completeness result for EqSat proofs). [śabda]
- **Lean 4 `grind`** (de Moura, Morrison; documented from Lean 4.16.0,
  Feb 2025) — E-graph congruence closure + E-matching + theory solvers +
  case-splitting **inside a dependently-typed kernel**, with explicit
  congruence-*proof* generation (`mkCongrProof`, preferring
  `congr`/`congrFun`/`congrArg`). This is the closest existing system to what
  CRYSTAL wants L2 to be, and it is production software. [śabda]
- **"Towards Pen-and-Paper-Style Equational Reasoning in ITPs by Equality
  Saturation"**, POPL 2026 (PACMPL, `thok.eu` preprint). [śabda]
- EGRAPHS workshop is annual at PLDI; **EGRAPHS 2026** is 15 June 2026. [śabda]

### Does proof-producing equality saturation already do CRYSTAL §L2 exactly?
**Yes, with one genuine delta.** egg's explanation is a chain of terms with
justifications `(rule id, direction, subterm position)` — a checkable path,
which is §L2's stated requirement. Nieuwenhuis–Oliveras gives the proof forest.
egglog gives incrementality. Colored e-graphs give the "directed edges live in
a separate structure and never merge classes" discipline (as conditional
worlds). The delta is CRYSTAL's insistence that **multiple distinct paths are
kept and not collapsed** because distinct automorphisms are content. egg's
explanations are optimised in the opposite direction — the 2022–2024 line
("Small Proofs from Congruence Closure", arXiv:2209.03398; "Towards Producing
Shorter Congruence Closure Proofs", PAAR 2024 [śabda]) is about producing
*shorter/fewer* proofs. So: the data structure is built; the *policy* of
retaining a proof-homotopy quotient rather than a shortest witness is a
deliberate inversion of the field's optimisation target, and the repo's own
`explanation_classes` (quotient by multiset of axiom justifications,
`runtime/STATUS.md`) is the only piece here that is not off-the-shelf
[pratyakṣa].

> **Verdict: CRYSTAL §L2 is already built as egg's proof-producing mode over
> Nieuwenhuis–Oliveras congruence closure (and, inside a dependent kernel, as
> Lean 4 `grind`). §L3's "nondominated routes under a cost vector" is an
> instance of e-graph extraction, an NP-complete problem with a 2025–2026
> solver literature and a public benchmark this repo is not using.**

---

## 2. Supercompilation and partial evaluation — CRYSTAL §3.1

### Correct name
**Supercompilation** (Turchin), with **driving**, **generalisation/whistle**
(homeomorphic embedding, Kruskal's tree theorem), **folding**; the stronger
**distillation** (Hamilton); **partial evaluation** and the **Futamura
projections**; and — the exact target — **certifying / proof-preserving
supercompilation**.

### Canonical citations
- Turchin, **"The Concept of a Supercompiler"**, TOPLAS 1986. [smṛti]
- Futamura, **"Partial Evaluation of Computation Process"**, 1971 — the three
  projections (specialise interpreter → compiler; specialise the specialiser →
  compiler generator). [smṛti]
- Jones, Gomard, Sestoft, **"Partial Evaluation and Automatic Program
  Generation"**, 1993 — the standard reference. [smṛti]
- Sørensen, Glück, Jones, **"Turchin's Supercompiler Revisited: an operational
  theory of positive information propagation"**. [śabda]
- Hamilton, **"Distillation: Extracting the Essence of Programs"**, PEPM 2007 —
  strictly more powerful than positive supercompilation; supercompilation
  gives linear speedups, distillation **superlinear**. [śabda]
- Hamilton & Jones, **"Asymptotic Speedups, Bisimulation and Distillation"**,
  2015 — bisimulation is the key to the correctness (semantics-preservation)
  proof for distillation. [śabda]

### Is "proof-preserving supercompilation" an existing named thing?
**Yes, and it has been named that for over a decade.**
- Krustev, **"A Simple Supercompiler Formally Verified in Coq"**, META 2010;
  and **"An Approach for Modular Verification of Multi-Result
  Supercompilers"**, META 2014 — a Coq framework for *building* verified
  supercompilers by plugging configurations/driving/folding into a generic
  verified skeleton. [śabda]
- `sergei-romanenko/agda-simple-scp` — "a simple supercompiler formally
  verified in Agda". **This repo is `--cubical --safe` Agda. There is an
  Agda-verified supercompiler on GitHub.** [śabda]
- Klyuchnikov & Romanenko, **"TT Lite: a supercompiler for Martin-Löf's Type
  Theory"** and **"Certifying Supercompilation for Martin-Löf's Type Theory"**,
  2015 — *"for any transformation performed by the supercompiler a proof of
  correctness is provided"*; the search summary uses the phrase **"the
  fundamental principles of proof-preserving supercompilation"** of this
  work. [śabda]
- Grechanik, **"Proving properties of functional programs by equality
  saturation"**, Programming and Computer Software, 2015 — supercompilation and
  equality saturation already joined. [śabda]

### 2025–2026 state
Supercompilation is a *mature, quiet* field: the active edge is multi-result
supercompilation and program-size control (arXiv:2006.02204, arXiv:2008.04669
[śabda]) rather than new foundations. The energy that used to go here now goes
to equality saturation and library learning (§3 below) — which is precisely why
§3.1 should be read as babble-plus-TT-Lite rather than as new supercompilation.

> **Verdict: CRYSTAL §3.1's self-description, "This is proof-preserving
> supercompilation", is not a metaphor and not a coinage — it names an existing
> research programme (Krustev; Klyuchnikov–Romanenko TT Lite) whose deliverable
> is a supercompiler that emits a correctness proof per transformation, in
> Martin-Löf type theory, with an Agda sibling implementation. §3.1 is an
> instance of it, missing its citations.**

---

## 3. Anti-unification, lemma discovery, theory exploration — CRYSTAL §3.1

### Correct names
**Anti-unification / least general generalization (lgg)** for step 3;
**frequent-subgraph / sub-DAG mining** for step 2; **library learning** for the
combination of both; **theory exploration** for the ITP-facing version.

### Canonical citations
- Plotkin, **"A Note on Inductive Generalization"**, Machine Intelligence 5,
  1970; Reynolds, **"Transformational Systems and the Algebraic Structure of
  Atomic Formulas"**, same volume, 1970 — the lgg, independently. The repo's
  `runtime/crystallize/` already says "Plotkin/Reynolds anti-unification"
  [pratyakṣa], so this attribution is correct in-repo.
- Cerna & Kutsia, **"Anti-unification and Generalization: A Survey"**,
  IJCAI 2023 (arXiv:2302.00277) — *the first comprehensive survey*, with a
  framework for categorising variants: term-graphs, higher-order, unranked,
  nominal, and equational (modulo a background theory). **Read this before
  writing another line of anti-unification code.** [śabda]
- Equational AU frontier: **"Equational Anti-unification over Absorption
  Theories"** (IJCAR 2024, arXiv:2310.11136); anti-unification over semirings;
  idempotent AU; **"Equational Generalization Problems with Atom-Variables"**
  (CICM 2025, Baumgartner–Kutsia–Nantes-Sobrinho–Schmidt-Schauß). [śabda]

### Library learning — the direct hit
- **Cao, Kunkel, Nandi, Willsey, Polikarpova, Tatlock et al., "babble: Learning
  Better Abstractions with E-Graphs and Anti-unification", POPL 2023
  (arXiv:2212.04596).** Contributions, as reported: **library learning modulo
  an equational theory; e-graph anti-unification to generate candidate
  abstractions; targeted common-subexpression elimination.** Evaluated against
  DreamCoder's deductive library learner: *"better compression, orders of
  magnitude faster"*. [śabda]
- **Stitch** (Bowers, Olausson, Ellis, Solar-Lezama, Tenenbaum et al.,
  POPL 2023) — concurrent with babble; corpus-driven top-down search,
  anytime branch-and-bound. [śabda/smṛti]
- **DreamCoder** (Ellis et al., PLDI 2021) — wake/sleep with a compression
  phase that invents library routines. [smṛti]

**Compare, line by line, against CRYSTAL §3.1:**

| CRYSTAL §3.1 step | babble/Stitch |
|---|---|
| 1. record derivations as DAGs | the corpus of programs, as e-graph/DAG |
| 2. mine repeated sub-DAGs across *different* derivations | candidate-pattern mining over the corpus |
| 3. **anti-unify** them, lgg, abstract differing positions to parameters | **e-graph anti-unification**, the paper's named contribution |
| 4. rebuild a proof of the generalised statement | *absent in babble* — supplied by TT Lite / certifying supercompilation |
| 5. kernel-check; install as one edge | *absent in babble* — this is the repo's only original move |
| 6. future derivations take one step where they took *k* | the compression objective, measured |

### Theory exploration (the ITP lineage)
- **IsaCoSy** (Johansson, Dixon, Bundy) — bottom-up synthesis of conjectures
  from constants and free variables, evaluated as an automatic generator of the
  background theory a mature proof assistant would have. [śabda]
- **QuickSpec** (Claessen, Smallbone, Hughes) — enumerate terms, use QuickCheck
  random testing to split them into equivalence classes, emit the equations.
  [śabda]
- **HipSpec / Hipster** (Johansson, Rosén, Smallbone, Claessen) — QuickSpec's
  background theory feeding automatic inductive proof, integrated into
  Isabelle/HOL; exploratory and proof modes; later **conditional** lemma
  discovery and recursion induction. [śabda]
- **TheSy** — Singher & Itzhaky, **"Theory Exploration Powered by Deductive
  Synthesis"**, CAV 2021 (arXiv:2009.04826): syntax-guided enumerative theory
  exploration **built on e-graphs and equality saturation**. [śabda]
- **CCLemma** — Polikarpova et al., **"E-Graph Guided Lemma Discovery for
  Inductive Equational Proofs"**, ICFP 2024 (PACMPL 8) — makes theory
  exploration *goal-directed*, using e-graphs + EqSat to represent the space of
  all goal-oriented proofs compactly. [śabda]
- 2025: **"Quick Theory Exploration for Algebraic Data Types"** /
  *LemmaCalc*, iFM 2025 [śabda]; and LLM-driven conjecturing as a separate,
  weaker lane (CEUR Vol-3432) [śabda].

### Is TheSy already CRYSTAL §3.1?
**TheSy is e-graph-driven lemma *discovery*; babble is e-graph-driven
*abstraction* discovery.** §3.1 as written — mine repeated structure, anti-
unify, install the generalisation as one edge, get later derivations shorter —
is **babble**. §3.1's *ambition* (the installed lemma is simultaneously
knowledge, code, rewrite rule and shortcut) is **TheSy/CCLemma** plus
babble. Neither kernel-checks in a dependent type theory; TT Lite does.

> **Verdict: CRYSTAL §3.1 is already built, as `babble` (POPL 2023) for steps
> 1–3 and 6, and as TheSy / CCLemma for the lemma-discovery framing. Step 4–5
> (rebuild the proof term, check it in a `--safe` dependent kernel, install)
> is the one part not present in babble — and it is present in TT Lite for
> supercompilation. The unassembled combination "e-graph anti-unification +
> dependent-kernel-checked lemma install" is the whole of §3.1's originality.**

---

## 4. Proof-carrying code and certified compilation — CRYSTAL §5, §0

### Correct names
**Proof-carrying code (PCC)**; **foundational PCC**; **certified compilation**
(compiler correctness proved once, in a proof assistant) vs **certifying
compilation / translation validation** (each run emits a checkable
certificate); the **LCF architecture** and the **de Bruijn criterion** for
"trusted heart, small".

### Canonical citations
- Necula, **"Proof-Carrying Code"**, POPL 1997 — untrusted code ships with a
  safety proof against a stated policy; the host checks the proof. [śabda]
- Necula & Lee, **"Safe Kernel Extensions Without Run-Time Checking"**,
  OSDI 1996. [smṛti]
- Appel, **"Foundational Proof-Carrying Code"**, LICS 2001 — verification from
  the smallest possible axiom set and simplest possible verifier; all types and
  their properties defined and proved from higher-order logic rather than
  assumed via a trusted type system. [śabda]
- Leroy, **"Formal Certification of a Compiler Back-end"** / CompCert,
  POPL 2006 and CACM 2009 — a fully verified optimising C compiler in Coq;
  Yang et al.'s Csmith fuzzing found no miscompilations in the verified
  middle-end. [śabda/smṛti]
- Kumar, Myreen, Norrish, Owens, **CakeML**, POPL 2014, and **"The Verified
  CakeML Compiler Backend"**, JFP 2019; **proof-producing code extraction** —
  the first toolchain giving formal guarantees about execution of extracted
  code *outside* the logic. [śabda]
- Milner, **LCF**, 1972/1979 — the abstract type `thm` whose only inhabitants
  come from inference rules. This *is* CRYSTAL §5's "no candidate may rewrite
  the kernel that judges it", fifty years earlier. [smṛti]

### 2025–2026 state
- **PureCake** (verified compiler for a Haskell-like language on top of CakeML)
  and **Pancake** (systems language reusing the CakeML backend) — the
  ecosystem, not the compiler, is now the unit of work. [śabda]
- **Verified Software Toolchain** (Appel) joins CompCert to verified static
  analysis for end-to-end C guarantees. [śabda]
- Recent: "End-to-end Compositional Verification of Program Safety through
  Verified and Verifying Compilation" (arXiv:2510.10015); "Verified VCG and
  Verified Compiler for Dafny" (arXiv:2512.05262); "Certificate-Carrying
  Transformation of Event-Driven Block Programs" (arXiv:2607.00563). The
  live direction is **certificate-carrying (per-run) rather than
  certified (once-for-all)** transformation — which is exactly CRYSTAL's
  posture. [śabda]

> **Verdict: CRYSTAL §5 is the LCF architecture plus the de Bruijn criterion,
> unchanged. CRYSTAL's overall stance — an untrusted optimiser proposing,
> a small kernel checking a per-transformation certificate — is
> certifying/certificate-carrying compilation, and is what TT Lite already does
> for supercompilation and what the 2025–2026 arXiv line above does for
> imperative and block languages. Genuinely not covered: nothing.**

---

## 5. Hash-consing, congruence closure with proofs, NbE, content addressing — §L0

### Correct names
**Hash-consing** (maximal sharing); **content-addressed / Merkle-DAG code**;
**congruence closure** with **proof production**; **normalization by
evaluation (NbE)**.

### Canonical citations
- **Unison** — content-addressed code: definitions identified by a hash of
  their AST *including their dependencies' hashes*; names are separately stored
  metadata. CRYSTAL §L0 cites this by name, correctly. **Unison reached 1.0 on
  2025-11-25** — "the first time a content-addressed language reached
  production status" [śabda]. Reported hash: SHA3-512 over structure +
  dependency hashes [śabda]. CRYSTAL's kernel uses blake2b [pratyakṣa]; the
  design is Unison's.
- Filliâtre & Conchon, **"Type-Safe Modular Hash-Consing"**, ML Workshop 2006.
  [smṛti]
- Downey, Sethi, Tarjan, **"Variations on the Common Subexpression Problem"**,
  JACM 1980 — congruence closure. Nelson & Oppen, **"Fast Decision Procedures
  Based on Congruence Closure"**, JACM 1980. [smṛti]
- Nieuwenhuis & Oliveras 2005, as in §1 — the proof-producing version. [śabda]
- Berger & Schwichtenberg, **"An Inverse of the Evaluation Functional for
  Typed λ-calculus"**, LICS 1991 — NbE. Coquand & Dybjer; Abel's habilitation
  for the dependent case. [smṛti]
- Merkle DAG lineage outside PL: Git, IPFS/IPLD, Nix store paths. [smṛti]

> **Verdict: CRYSTAL §L0 is already built as Unison (production, 1.0, Nov 2025)
> over Filliâtre–Conchon hash-consing; congruence-closure-with-proofs is
> Nelson–Oppen + Nieuwenhuis–Oliveras. §L0's only in-repo content is the
> decision to make *different presentations different addresses* and refuse a
> universal semantic hash — which is Unison's decision too.**

---

## 6. Automata learning, CEGAR, abduction — CRYSTAL §3.2 and the `Obstruction` loop

Two distinct mechanisms in the repo get conflated here; they have two different
correct names.

### 6a. §3.2 "distinction compilation" — collision-driven partition refinement

CRYSTAL §3.2 names its own finite case correctly: *partition refinement /
Myhill–Nerode / bisimulation quotient*. The citations are:

- Myhill 1957; Nerode 1958 (already in `notes/MATHEMATICS_THAT_LEARNS.md`
  "Doors" [pratyakṣa]). Hopcroft, **"An n log n algorithm for minimizing states
  in a finite automaton"**, 1971; Paige & Tarjan, **"Three Partition Refinement
  Algorithms"**, SICOMP 1987; Kanellakis & Smolka for bisimulation. [smṛti]
- Rutten, **"Universal coalgebra: a theory of systems"**, TCS 2000 — the
  minimal realization/final coalgebra statement. `notes/FUTURE_BEHAVIOR_IS_
  COALGEBRA.md` already records that this corpus re-proved it under private
  names, three times in one module [pratyakṣa]. **That finding applies verbatim
  to §3.2.**

The **infinite** case, which CRYSTAL leaves as "a candidate abstraction is
proposed and the kernel checks the certificate", is the exact statement of:

- Clarke, Grumberg, Jha, Lu, Veith, **"Counterexample-Guided Abstraction
  Refinement" (CEGAR)**, CAV 2000 / JACM 2003. The loop is: abstract, check,
  get a *spurious* counterexample (= CRYSTAL's **collision**: two states the
  abstraction identifies but the task separates), compute a refinement that
  eliminates it, repeat. [smṛti]
- Graf & Saïdi predicate abstraction (CAV 1997); Ball–Rajamani SLAM;
  Henzinger–Jhala–Majumdar–McMillan lazy abstraction with interpolants. [smṛti]
- Abstract interpretation (Cousot & Cousot, POPL 1977) supplies the
  soundness/completeness framework CRYSTAL §4 is groping toward. [smṛti]

**Active automata learning** is the same loop with membership/equivalence
queries instead of a model checker, and its "collision" is literally an
inconsistency in the observation table repaired by adding a **distinguishing
suffix** — CRYSTAL §3.2 step 3–4 exactly:

- Angluin, **"Learning Regular Sets from Queries and Counterexamples"**,
  Information and Computation 1987 — **L\***. [smṛti]
- Rivest & Schapire 1993 (counterexample processing); Isberner, Howar, Steffen,
  **TTT**, RV 2014 — "a redundancy-free approach to active automata learning"
  [śabda]; Vaandrager et al., **L#**. [śabda]
- Tools: **LearnLib** (Java) and **AALpy** implement L\*, TTT, L# for several
  automaton classes [śabda].
- 2025–2026: Henry, Mousavi, Neele, Sammartino, **"Compositional Active
  Learning of Synchronizing Systems Through Automated Alphabet Refinement"**,
  CONCUR 2025 — learns component models while *automatically refining the
  global alphabet into component alphabets*. This is CRYSTAL §3.2's step 4
  ("search the invariant library for a minimal channel separating the
  collision") as a published algorithm. [śabda] Also "Error-Awareness
  Accelerates Active Automata Learning", 2025 [śabda]; adaptive AAL with state
  matching and multiple references (arXiv:2406.19714) [śabda].

> **Verdict: CRYSTAL §3.2 is already built. Finite case: Hopcroft/Paige–Tarjan
> partition refinement and the coalgebraic minimal realization (which this
> corpus has already been caught re-proving). Infinite case: CEGAR, 2000, plus
> predicate abstraction. The "declare a task family, find the minimal channel"
> variant is compositional active automata learning with alphabet refinement,
> CONCUR 2025.**

### 6b. The `Obstruction` / `GenerativeLoop` mechanism — the correct name

The mechanism [pratyakṣa, `formal/cubical/NaturalMachine/GenerativeLoop.agda`,
`Obstruction.agda`, `CompileBridge.agda`]: attempt to match a task term against
an installed vocabulary; the match fails at a head; the **residual** of the
failure *is* the name of the missing capability; install it as a definitional
extension with a witness body; conservativity is eliminability by `unfold`;
progress is a target-indexed measure `deficit` that strictly drops; the loop
terminates in ≤ `deficit V t` steps.

That is not one thing, it is three known things composed:

1. **The loop shape** — propose, fail, read the failure, repair, repeat, with a
   termination measure — is **CEGIS**, counterexample-guided inductive
   synthesis (Solar-Lezama, Sketching, ASPLOS 2006; CEGIS(T) with a theory
   solver, CAV 2018 [śabda]). It is also literally CEGAR's loop (§6a) with
   "vocabulary" in place of "abstraction".
2. **"Read the residual of a failed match and name the missing structure"** is,
   in the deductive/ITP lineage, **proof-critics with lemma speculation and
   middle-out reasoning**: Ireland & Bundy, **"Productive Use of Failure in
   Inductive Proof"**, JAR 1996; Ireland, "The use of planning critics in
   mechanizing inductive proofs", LPAR 1992 [śabda]; the generalisation critic
   (Ireland & Bundy, 1996 [śabda]); the divergence critic (Walsh, CADE 1996,
   arXiv:cs/9604101 [śabda]); and its modern form, Montano-Rivas / Johansson /
   Dixon / Bundy, **"Dynamic Rippling, Middle-Out Reasoning and Lemma
   Discovery"**, VSTTE 2010 [śabda] — *a schematic lemma is speculated from the
   blocked wave-front and incrementally instantiated by unification as the
   proof proceeds*. Note the honest reported result: **"few proofs were found
   for which this critic was applicable and successful"** [śabda]. That is the
   base rate this corpus should expect.
3. **What gets named** — a *new symbol* rather than a new equation — is
   **predicate invention** in ILP, whose engine is **abduction**: Muggleton &
   Buntine's CIGOL/inverse resolution; Meta-Interpretive Learning (Muggleton,
   Lin, Tamaddoni-Nezhad, Metagol) which *uses abduction to invent predicates
   for relations absent from the background knowledge*; Inoue's meta-level
   abduction; and modern systems **Popper** (Cropper & Morel, "Learning
   programs by learning from failures", MLJ 2021 — the title is the mechanism)
   and **ADVENT** (LLM abductive generation + Prolog deductive verification).
   Cropper, Dumančić, Evans, Muggleton, **"Inductive logic programming at 30"**,
   MLJ 2022, is the survey; it reports predicate invention as *"a critical
   bottleneck"* and *"a frontier in terms of automaticity and scalability"*.
   [śabda]

And the *justification* for installing the name — conservativity plus strict
compression — is classical proof theory, not new: **extension by explicit
definitions is conservative** (Kleene; standard), and **abbreviation shortens
proofs**, which is Tseitin extension / extended resolution
(Tseitin 1968; Cook & Reckhow 1979 on extended Frege) [smṛti]. This is exactly
what `TypedUnfold.QAP.strict-growth` proves at one instance [pratyakṣa]: a
definition whose body has invocation size > 1 strictly grows the
budget-bounded language of reachable denotations, and one whose body has size 1
provably does not (`unit-body-no-growth`). Good instance; known phenomenon.

> **Verdict: the `Obstruction`/`GenerativeLoop` mechanism is
> *abductive predicate invention inside a CEGIS/CEGAR loop*, and in the
> theorem-proving lineage it is precisely Ireland–Bundy **proof critics /
> lemma speculation** ("productive use of failure"), specialised from
> speculating a lemma to speculating a signature symbol. It is an instance of
> existing named frameworks, not a new one. The Agda formalisation of the loop
> with a faithful measure (`Over→deficit0`/`deficit0→Over`) and a step bound is
> a genuine, small, checked contribution — but it is a formalisation of a 1996
> mechanism.**

---

## 7. §L1's typed-edge table, §0's seed criterion, §L4 — the remainder

### §L1 typed edges
Nothing in the searched literature names an eleven-kind edge lattice with
per-kind composition laws and preservation-as-intersection. Nearby existing
machinery: **colored e-graphs** (equalities valid only under a condition
[śabda]) is the closest e-graph analogue; **univalent parametricity / transport
along equivalences** is the type-theoretic analogue for `Iso`; ordered algebra
and the **real spectrum** `Sper` for the `Order` payload is standard real
algebraic geometry (Bochnak–Coste–Roy) [smṛti]. The observation that `Iso` does
not preserve `sign` because Galois conjugation of `ℚ(√2)` exchanges its two
orderings is correct, standard, and this corpus's own derivation
[pratyakṣa, `notes/POSITIVITY_HAS_A_PLACE.md` as cited].

> **Verdict: CRYSTAL §L1 is genuinely not covered *as a table*, and its parts
> are all standard. The `Order⟨≤⟩` kind carrying a point of `Sper` as a
> required payload is the one artifact in CRYSTAL I could not find named
> elsewhere. It is a design decision with a one-line justification, not a
> theorem.**

### §0 the seed criterion
"A theorem enters; an independent problem thereafter solves in strictly fewer
kernel steps, by exact counters, with a null control." As *engineering
discipline* (ablation + null control) this is unimpeachable and this repo
executes it [pratyakṣa, `runtime/STATUS.md`: 29→12 with a bit-identical null
control; 91551→28672 with a +616 null control]. As *mathematics* it is known:

- **Cut-introduction / proof compression**: Hetzl, Leitsch, Weller,
  "Towards Algorithmic Cut-Introduction" (LPAR 2012) and "Algorithmic
  Introduction of Quantified Cuts" (arXiv:1401.4330, TCS) — compute a
  compressed representation of the terms in an analytic proof, then a cut
  formula realising the compression; extended to equality
  (arXiv:1402.2474); connected to tree grammars for inductive theorem proving.
  [śabda] "Lemmas: Generation, Selection, Application" (Springer 2023) is the
  ATP-side survey. [śabda]
- **Speedup theorems**: Gödel's 1936 speedup remark; Parikh's and Ehrenfeucht–
  Mycielski's rigorous versions — adding a true axiom can shorten proofs by a
  non-elementary factor. The *existence* of §0's phenomenon is a theorem.
  [smṛti]
- **Proof-length compression by abbreviation**: Tseitin extension / extended
  resolution / extended Frege (§6b). [smṛti]

> **Verdict: CRYSTAL §0's criterion is an instance of cut-introduction /
> lemma-based proof compression, whose *possibility* is settled by the
> Gödel–Parikh speedup theorems. What the demos measure is real but is the
> shadow of a known theorem; per `CLAUDE.md`'s own rule, the interesting
> question is the *rate* — which lemma class gives which compression — and that
> is the cut-introduction literature's question.**

### §L4 incremental consequence propagation
- Acar, **self-adjusting computation** (thesis 2005; "Self-Adjusting
  Computation with Delta ML"); **Adapton** (Hammer et al., PLDI 2014) —
  composable, demand-driven incremental computation. [śabda]
- Mokhov, Mitchell, Peyton Jones, **"Build Systems à la Carte"**, ICFP 2018.
  [śabda]
- Incremental Datalog: semi-naive evaluation; **DRed** and the backward/forward
  algorithm (Motik et al., AAAI 2015); **DBSP** for general IVM. [śabda]
  `egglog` inherits incrementality from this line by construction. [śabda]
- 2025: "Incremental Computing by Differential Execution", ECOOP 2025. [śabda]

> **Verdict: CRYSTAL §L4 is already built, several times, and `egglog` provides
> it as a side effect of being Datalog. The repo's `propagate/` is a
> hand-rolled Adapton.**

---

## 8. Ranked table: ADOPT rather than build

Ranked by (cost of what we are duplicating) × (maturity of the alternative).

| # | Adopt | Instead of building | Why now | Friction |
|---|---|---|---|---|
| 1 | **egg / egglog** (Rust), used as an *untrusted oracle* that emits explanations; replay each explanation as a proof term in the Agda/Lean kernel | `runtime/kernel/egraph.py`, `runtime/execute/` | Proof-producing EqSat is exactly §L2+§L3; egglog adds §L4 incrementality free. Explanations are already a certificate format, which is the repo's doctrine ("exact/certified symbolic computation is proof") | Rust, not Python — *helps*: the Python ban (`CLAUDE.md`) already forbids extending `runtime/`. The replay checker is the only thing we must write |
| 2 | **babble**'s algorithm (e-graph anti-unification for library learning, POPL 2023) | `runtime/crystallize/`'s sub-DAG mining + Plotkin AU | It is §3.1 steps 1–3 and 6, published, measured against DreamCoder, orders of magnitude faster. Keep only our step 4–5 (rebuild + kernel-check) — that *is* the contribution | Needs a proof-rebuild pass babble does not have; take that from TT Lite |
| 3 | **TT Lite / certifying supercompilation** (Klyuchnikov–Romanenko) and `agda-simple-scp` (Romanenko) | writing "proof-preserving supercompilation" from scratch | It is the same phrase, in Martin-Löf type theory, with an Agda implementation already on GitHub. §3.1's step 4 is its raison d'être | Scala/Agda port work; the Agda one is `--without-K`-era, not cubical (same porting note as `PRIOR_ART_INDEX.md`) |
| 4 | **Lean 4 `grind`** as the reference design for a proof-producing e-graph *inside a dependent kernel* | designing our own kernel/e-graph trust boundary | The repo has a Lean lane (`formal/pairfield/`). `grind` solves precisely the "e-graph that must emit kernel-acceptable congruence proofs" problem | Lean-side only; does not help the cubical lane |
| 5 | **Cerna–Kutsia AU survey** (IJCAI 2023) + equational AU results | any further anti-unification design | One survey replaces a design phase. Equational AU (absorption, semirings, idempotence) is the version we actually need, since our terms live modulo theories | Reading only. Cheapest item on this list |
| 6 | **Extraction gym** + the ILP/treewidth/ASP/MaxSAT extraction literature | `runtime/execute/`'s Pareto route selection | Extraction is NP-complete and benchmarked; the reported result that *greedy is nearly as good* is a fact we should know before optimising | Benchmark harness is Rust |
| 7 | **CEGAR** + **LearnLib/AALpy** (L\*, TTT, L#) + Paige–Tarjan | `runtime/distinguish/` | §3.2 finite = partition refinement; §3.2 infinite = CEGAR. Compositional AAL with alphabet refinement (CONCUR 2025) is our "minimal separating channel" | Java/Python tooling; the *algorithms* are what we want, and they are textbook |
| 8 | **Hetzl cut-introduction** framing for §0 | further §0 demos with new counters | Turns "we measured a speedup" into "which lemma class yields which compression", which is the question `CLAUDE.md` demands | Reading + one reframing pass on `runtime/STATUS.md` |
| 9 | **Unison** semantics for §L0 (already cited) | further address-scheme design | Production 1.0 since Nov 2025. Our blake2b variant is a re-implementation of a shipped design | None; already acknowledged in CRYSTAL |
| 10 | **Ireland–Bundy proof critics** literature | further `GenerativeLoop` motivation prose | It names the mechanism and reports its base rate ("few proofs... applicable and successful"), which is calibration we do not have | Reading only |

## 9. Genuinely not already done (short, as predicted)

1. **`Order⟨≤⟩` as an edge kind carrying a point of `Sper` as a required
   payload**, inside a composition lattice where preservation is intersection
   of tags, with the consequence `(Iso;Order)` is unlicensed. I found no named
   prior art for the *table*. Real-closed-field content is standard; the
   application to a rewrite/transport lattice is, as far as this search goes,
   ours. Small.
2. **The composite "e-graph anti-unification (babble) → proof-term rebuild →
   `--safe` dependent kernel check → install"**. Each of the four exists;
   the chain does not appear assembled anywhere I found. This is CRYSTAL §3.1's
   only real claim to novelty, and it is an *engineering* composition of four
   published pieces, not a new idea.
3. **Retaining a proof-homotopy quotient of explanations rather than a shortest
   explanation** (`explanation_classes`, quotient by multiset of axiom
   justifications). The field optimises the other way. Whether the retained
   structure is worth its exponential cost is unanswered and is the right
   `PROVE` item here.
4. Everything else in `CRYSTAL.md` — §L0, §L2, §L3, §L4, §3.1's algorithm,
   §3.2, §5, §0's criterion — **is an existing system.**

## 10. One methodological consequence

`runtime/` is ~5 000 lines of Python implementing a proof-producing e-graph, an
anti-unification-based library learner, a partition refiner and an incremental
dependency propagator. All four are published, faster, better-tested systems in
Rust, HOL4, Coq and Java. Simultaneously, `CLAUDE.md` bans Python in this
repository. Those two facts point the same way: **the runtime should not be
ported to Agda and should not be extended in Python. It should be replaced by
(a) external, mature, untrusted oracles and (b) an Agda/Lean *certificate
replayer*, which is the only component of `CRYSTAL.md` that nobody else has
written and the only one the repo's own doctrine says is proof.**
