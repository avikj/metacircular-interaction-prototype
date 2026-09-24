# Language-Level Conductive Fibre Integration

## Purpose

This is the implementation handoff for making the already-existing lossless cubical / conductive-fibre semantics a language-level capability of Cubical Bend2 rather than an application-level pattern that individual programs must manually invoke.

**This is an integration task, not a mathematics-research task.** The mathematical construction is already present, checked, and executable. The compiler already contains the cubical primitives and full HVM4 runtime lowering. SAT already executes the relevant fibre process end-to-end. The task is to identify and close the small remaining seam by which ordinary Bend execution bypasses the richer presentation unless source code explicitly constructs it.

A fresh agent must not invent a new solver, optimizer, search procedure, proof engine, theorem-discovery subsystem, Rubik-specific representation, SAT algorithm, Erdős-specific state machine, or new mathematical foundation. Those are distractions.

The working question is:

> **Why is the canonical lossless / conductive presentation currently an opt-in Bend construction instead of the default execution/presentation of mathematical objects and propositions, and what is the smallest correct compiler/runtime wiring change that makes it intrinsic?**

Do not answer from intuition. Read the sources below completely first.

---

# 1. Mandatory reading before editing anything

The order matters. Do not skim search snippets. Read each file completely, including definitions surrounding the named ones. The same construction appears under several vocabularies; searching for one English word is not sufficient.

## 1.1 Compiler/core — read the entire patch

**Read completely:**

- collab/bend2-interactive-cubical/cubical-paths.patch

This is the most important implementation source. It is large; read it anyway. Understand every change to Core.Type, parsing/term representation, Core.Check, Core.WHNF, substitution/collapse/traversal utilities, Core.CLI, Target.HVM4, Target.HVM4Full, totality/analysis, and the cubical tests introduced by the patch.

Verify directly:

1. --to-hvm4-full parses/checks a Bend Book and passes it to HVM4Full.compileFull.
2. compileFull emits definitions by applying emitFull to their existing Core terms. There is no generic semantic/fibre elaboration pass between checked Core and full HVM4 emission.
3. Cubical computation is deeply integrated into WHNF, not an external DSL.
4. whnfCoe is type-directed and handles Π, Σ, PathP, ua, Glue, lists, HITs, superposed type lines, etc.
5. whnfHCm is likewise type-directed.
6. dup is extended through the cubical syntax.
7. full HVM4 lowering retains cubical structure rather than erasing it.
8. superposed type-line transport deliberately uses ordinary HVM sharing/SUP behavior.

Read the comments around the SUP case in whnfCoe and the full-runtime emitter especially carefully.

## 1.2 The law and executable Bend realization

**Read completely:**

- collab/bend2-interactive-cubical/port/Carrier.bend
- collab/bend2-interactive-cubical/port/FibreElement.bend
- collab/bend2-interactive-cubical/port/WholeProcess.bend
- collab/bend2-interactive-cubical/port/FibreCoalgebra.bend
- collab/bend2-interactive-cubical/port/PORT.md

Do not treat Carrier, FibreElement, WholeProcess, and FibreCoalgebra as unrelated libraries. They are presentations/names of the same central lossless construction and its continuing form.

The law is:

    f : A -> B
    A ≃ Σ (b : B). fiber f b
    fiber f b = Σ (a : A). Path B (f a) b

In Carrier.bend understand all of Carrier, descend, ascend, ascend_descend, descend_ascend, CarrierEquiv, CarrierPath, carry_transport, carry_transport_descend, phi_carrier, phi_square.

The carrier is not a log appended to the source. It is a lossless re-presentation/change of coordinates of the same information. The source field in the concrete representation witnesses the residual distinction; mathematically the fibre is the complement of what the observation collapses.

In FibreCoalgebra.bend understand:

    type FibreCoalgebra(A: Set, a: A):
      case @fibreCoalgebra:
        respond: all B: Set. all f: A -> B.
                 FibreObservation(A, a, B, f)

and especially:

    next: FibreCoalgebra(FibreElement(A,B,f), value)

The same law applies again to the new lossless presentation. This is not an append-only list of observations.

## 1.3 Elemental point/question calculus

Read completely corpus_calculus.bend as introduced by cubical-paths.patch.

Its core is:

    Point = Σ A : Set. A
    Question(s) = Σ B : Set. (Src(s) -> B)
    target(s,(B,f)) = (B, f(src(s)))

This is the simple/lossy point-question calculus. Fibre completion is its lossless form. A mathematical object is already a typed point; a question is already an arbitrary map out of its current type.

## 1.4 SAT — read deployed execution, not just theorem prose

**Read completely:**

- research/SAT_FIBRE_BEND_HVM_DEPLOYED_TECHNICAL_REPORT.md
- research/sat_fibre/SATProcess.bend
- research/sat_fibre/SATFibre.agda as provenance where useful
- research/sat_fibre/README.md
- research/sat_fibre/REPORT.md
- research/sat_fibre/check_bend.py
- research/sat_fibre/audit.py
- research/sat_fibre/bend-receipt.json
- research/sat_fibre/profile-build.json
- generated HVM4 artifacts referenced by the report for XOR and at least one nontrivial CNF family

SATProcess constructs one shared labelled object:

    @assignment{&100{False, True}, &101{False, True}}

and conducts formula through it via the whole/fibre process. The full run returns four XOR readings with a native HVM receipt. The answer-only demand is much cheaper because it projects less of the retained object.

Do not misread this as four host-side calls or ordinary brute-force enumeration. Inspect the emitted net.

## 1.5 Full runtime cubical/SUP behavior

Read completely:

- supline.bend
- applypath.bend
- applypath_bwd.bend
- chain.bend
- uaequiv.bend
- uaglue.bend
- coinduction.bend

Especially internalize supline.bend: superposed-line transport needs no special new HVM rule; coe dispatch commutes over superposition and same-label duplication annihilates.

## 1.6 Integration context

Read:

- collab/bend2-interactive-cubical/README.md
- collab/bend2-interactive-cubical/WRITEUP.md
- collab/bend2-interactive-cubical/REMAINING.md
- research/wiki/BEND2_UNISON_READING_AND_SYNTHESIS.md
- integration/bend2_unison/execution/Bend/UCM/Execution.hs

Treat historical commentary cautiously. Code and theorem types are authoritative.

---

# 2. One law, many readings

Do not decompose the system into a fictional stack of independent algorithms called fibre, optimizer, proof search, cost engine, univalence engine, etc.

For f : A -> B:

    A ≃ Σ (b : B). fiber f b

At a : A, the canonical forward presentation is conceptually:

    a  <->  (f(a), residual_f(a))

The concrete Bend value often looks like (base=a, carried=f(a), witness=refl), but these are not three independent pieces being accumulated. The whole value is a lossless coordinate change. The fibre coordinate is exactly the distinction among sources collapsed by the visible observation.

Univalence makes equivalence of presentations executable identity. Cubical transport/composition executes through those identities. Higher paths retain coherence among alternative transformations.

Coinduction means the resulting lossless presentation is again an object to which the same law applies:

    A0 ≃ A1 ≃ A2 ≃ ...

These are successive equivalent presentations of the same information, not historical logs.

---

# 3. Keep four meanings of "step" separate

**Observation:** choose f : A -> B.

**Fibre presentation:** expose f(a) while retaining the exact residual.

**Primitive execution:** beta reduction, coe, hcomp, SUP/DUP, path reduction, etc. Evaluating one observation can require many primitive interactions.

**Coinductive continuation:** after an observation, retain the fibre-completed whole and allow another observation.

One observation is not one HVM interaction.


# 4. A proposition already supplies the observation

This is essential for the language-level integration.

For a finite Boolean proposition:

    P : X -> Bool

the proposition itself is the map whose fibres classify X:

    True(P)  = Σ x : X. Path Bool (P x) True
    False(P) = Σ x : X. Path Bool (P x) False

Presenting P over its domain already presents conditions/witnesses where P holds, conditions/counterexamples where it fails, universal truth when the false fibre is empty, universal falsity when the true fibre is empty, and the exact nontrivial classification otherwise.

No human must issue a separate "solve P" opcode. The proposition is already the observation.

For general dependent propositions/types, the same principle is proof-relevant rather than merely Boolean: dependencies and witnesses remain coordinates of the object.

The FibreCoalgebra respond(B,f) interface is additional interactive power: after an object is presented/conducted, request further projections while retaining everything each projection forgets. Do not mistake that follow-up interface for the inference engine itself.

SAT demonstrates both levels: the proposition defines the true/false fibres; query then demonstrates subsequent projections of the retained whole.

---

# 5. Univalence executes equivalence; the rest of the mathematics derives it

Do not claim ua discovers every equivalent representation for free.

Given e : A ≃ B:

    ua(e) : Path Set A B

and transport along that path computes the representation change.

The broader universal mathematical machinery derives properties/identities/equivalences of the object. Those results are themselves objects in the same theory. Univalence makes derived equivalences executable.

Do not invent a separate heuristic optimizer above the theory.

---

# 6. What the compiler already gets right

The cubical surgery is foundational, not superficial.

## 6.1 Checker

Core.Check understands paths, dependent paths, interval structure, hcomp, Glue, quotients, HITs, truncations, endpoint constraints, and typed path-spine normalization.

## 6.2 WHNF

Core.WHNF contains real type-directed cubical computation.

whnfCoe structurally handles:

- Π: argument backward, result forward;
- Σ: first component plus dependent second;
- ua: transport computes to forward/backward equivalence;
- PathP: endpoint-preserving composition;
- Glue: fibre/equivalence-based transport;
- lists and HIT constructors;
- superposed type lines: coherent duplication at the label, branch transport, re-superposition.

whnfHCm likewise computes according to the type.

This already realizes the principle that the mathematical structure determines computation.

## 6.3 Sharing

dup traverses cubical terms. Cubical structure participates in Bend/HVM sharing.

## 6.4 Full target

--to-hvm4-full is the relevant target. It preserves the cubical runtime. Do not validate this project using an erasing or pre-normalizing backend.

---

# 7. The actual compiler seam

The key implementation fact is:

> **There is no generic lossless/fibre presentation pass between a checked Bend term and HVM4Full.compileFull.**

The path is approximately:

    parseFile
      -> checkBook
      -> Book(Core.Term, type, ...)
      -> HVM4Full.compileFull
      -> emitFull term
      -> HVM4

compileFull faithfully emits the Core term it receives.

Therefore ordinary source code that never explicitly constructs Carrier/FibreCoalgebra does not automatically become the canonical lossless presentation merely because the language supports cubical TT.

Once fibre/cubical/superposed structure is present, the evaluator handles it powerfully. The missing issue is making canonical lossless presentation intrinsic at the language/program presentation boundary rather than requiring applications to manually import and invoke WholeProcess/FibreCoalgebra.

This is the integration task.

---

# 8. Do not wrap every nested App

A tempting wrong direction is rewriting every App f x into an explicit fibre object.

Do not do this blindly.

The semantic unit is the current mathematical whole plus an observation of that whole. Internal calls used while evaluating one observation are not necessarily successive top-level observations. Arithmetic, recursion, comparison, folds, etc. inside a mathematical observation are part of evaluating that observation.

The goal is not an append-only trace of every beta redex. It is lossless presentation of the mathematical map/object being evaluated.

---

# 9. SAT already demonstrates the missing language behavior manually

SATProcess manually does what the language should make intrinsic.

It constructs a shared unresolved mathematical object, constructs WholeProcess for it, conducts formula through it, receives Carrier + source path + continuation, and optionally asks the continuation for another projection.

This proves:

1. The fibre process is executable Bend today.
2. HVM4-full can run it.
3. SUP/DUP and cubical transport interact in a deployed run.
4. Demand affects how much retained structure is exposed.
5. The continuation can remain lazy.
6. No new HVM primitive is obviously required merely to make the process intrinsic.

Therefore the first implementation attempt should generalize the already-running pattern, not replace it.

---

# 10. Presentation effects are not evidence against conductive fibre

The SAT corpus records very large interaction-count differences for different presentations of the same Boolean denotation. TSP similarly distinguishes a shared min-plus presentation from a reference-expanding one.

Interpret this correctly.

The runtime conducts/factors structure that is actually represented/exposed in the net. An equivalence that exists mathematically but has not yet become executable structure cannot be reduced through by raw HVM merely because it is true.

The complete mathematical system derives properties/equivalences of its objects; those derived identities can then become executable cubical structure. The language integration must not replace this with a heuristic optimizer. It must ensure the existing derivational/lossless machinery is actually in the execution loop rather than available only to programs that manually invoke it.

---

# 11. Naturals, min/max, and premature decategorification

Do not reduce the system to ordinary scalar programming.

The corpus identifies naturals with the set-truncated connected components of finite sets:

    Nat ≃ π0(FinSet)

Before truncation, an n-element finite object has its full equivalence/automorphism geometry. The numeral is a decategorified reading.

Likewise a mathematically correct minimum/maximum can be represented proof-relevantly, with witnesses and leastness/greatestness evidence retained as dependent coordinates. The cubical theory then computes over the whole object; the scalar is a projection.

However, do not infer that legacy scalar-looking functions are forever opaque. Functions/programs are themselves objects of the same theory and can be related to equivalent presentations. The implementation question is whether execution exposes/uses those derived identities, not whether programmers guessed one blessed syntax.

---

# 12. The likely language-level model

The elemental universal state is already:

    Point = Σ A : Set. A

Every checked Bend value a : A canonically determines a point (A,a).

Every map f : A -> B is already an observation of that point.

The lossy target is:

    (A,a) --f--> (B,f(a))

The lossless completion is:

    (A,a) ≃ (Carrier(A,B,f), descend(A,B,f))

and the continuation is the same universal machine over that new equivalent presentation.

A checked program/object should therefore not need to opt into FibreCoalgebra. A canonical fibre process exists for every typed point.

The exact compiler representation should be chosen only after reading the complete core and existing process code. Do not prematurely force one particular AST design.


# 13. Program entry and proposition presentation are related but distinct

## 13.1 Ordinary closed value

If main : A evaluates to a : A, then (A,a) canonically has a fibre coalgebra. Attaching that coalgebra gives a universal interactive presentation of the result without changing the ordinary projection.

This is useful for REPL/follow-up interaction.

## 13.2 Presented map/proposition

If a program presents P : X -> B together with the mathematical domain/object X, then P itself determines the fibre decomposition/classification. For proposition-valued P, this is the inference problem already.

Do not force an unnecessary external question protocol before the proposition can run.

The language-level design must support both:

- automatic presentation/conduction of a mathematical map/proposition;
- indefinite subsequent observations of the retained whole.

---

# 14. Source semantics are preserved by the rewrite

Do not treat the richer representation as a dangerous semantic change.

The entire point of the law is that the rewrite is witnessed:

    A ≃ Σ b. fiber f b

and univalence turns this equivalence into executable identity.

The visible old computation is a projection of the richer one:

    observed(descend f a) = f(a)

Thus ordinary semantics are preserved while the runtime retains distinctions that ordinary evaluation discards.

This is the same pattern already visible throughout the repository: a lawful rewrite is a transformation plus the witness that its invariant is preserved.

Relevant concrete reading:

- RewriteCertificate.bend
- ControlledGrammar.bend
- GenerativeKernel.bend
- Carrier.bend
- quotient/effectivity ports
- SAT boundary/representative/continuation material

Do not add defensive architecture whose sole purpose is preventing the lossless equivalent presentation from "changing semantics." Its equivalence is exactly the semantics-preservation certificate.

---

# 15. What is probably NOT needed

Based on the current compiler/core, do not begin by adding:

- a new theorem prover;
- a global search engine;
- a heuristic optimizer;
- a SAT solver;
- a problem-specific scheduler;
- a new HVM interaction rule;
- a second type theory;
- a separate IR for proof versus program;
- manual candidate enumeration;
- a new mathematical notion of fibre;
- a wholesale rewrite of Core.WHNF;
- a wrapper around every App node;
- a requirement that users manually specify all useful equivalences.

If investigation proves one of these necessary, document the exact missing invariant first. Do not assume it.

---

# 16. What likely DOES need wiring

The exact patch must be derived from the code, but the likely missing pieces are small.

## 16.1 Canonical presentation at a typed execution boundary

The Book already stores each definition's term and type. At the point where a mathematical object/map is selected for execution, both the object and its type are known.

The compiler/runtime should be able to canonically construct the corresponding lossless presentation/process without requiring source imports.

## 16.2 Fibre/whole-process primitives available intrinsically

Carrier/FibreElement and FibreCoalgebra/WholeProcess are currently Bend library definitions. Determine whether they should be:

- injected into the full-runtime prelude;
- generated by the full target;
- represented by a tiny intrinsic Core form;
- or simply linked automatically as canonical library definitions.

Prefer the smallest mechanism that preserves the existing checked definitions rather than duplicating their mathematics in Haskell.

## 16.3 Automatic proposition/map presentation

Identify the typed form that represents "this is the mathematical map/proposition being presented." Do not assume it is main, every App, or a special SAT form.

The desired behavior is that presenting P : X -> B over X automatically gives the lossless fibre presentation of P, rather than requiring explicit application code to reconstruct FibreCoalgebra manually.

## 16.4 Follow-up interaction as an interface, not the engine

Once the object is presented, expose the existing arbitrary observation family:

    all B : Set. (A -> B)

for subsequent interactions. This can become a REPL/UCM/runtime interface.

Do not require a follow-up question merely to perform the original proposition's own classification.

## 16.5 Keep continuation lazy

SAT demonstrates why. A request for one visible projection must not eagerly serialize the entire retained fibre. The continuation/residual should remain in the graph and be forced by demand.

---

# 17. The derivation/equivalence loop

The language is stronger than "losslessly remember the input while computing a function."

Programs, proofs, paths, equivalences, and transformations are themselves objects in the same theory. Therefore properties derived about the running object can become structure of the running object.

The intended closed loop is not an external optimizer pass:

    program -> optimizer -> rewritten program

but mathematical self-application inside one theory:

    object
      -> derive lawful property / identity / equivalence
      -> that result is another object/path
      -> transport/install/use it
      -> continue losslessly
      -> repeat

Univalence is the execution of equivalence, not the source of all equivalences. The rest of the universal derivational mathematics supplies those properties.

When examining the Bend integration, ask whether this loop is actually connected to ordinary execution or whether its pieces are merely available as libraries. Do not search for a new "resolve" function if the same law already expresses the operation under another vocabulary.

---

# 18. How to reason about the SAT evidence

SAT is the best deployed sanity check because it shows the full path:

    finite proposition
      -> shared/superposed domain
      -> fibre classification
      -> retained carrier/path/continuation
      -> HVM4-full
      -> native interaction receipt

The XOR WholeProcess run and the answer-only run are different demands on the same mathematical object. The interaction-count difference is evidence that the richer retained object is not necessarily eagerly exposed.

The larger SAT families show presentation sensitivity. This should motivate closing the self-presentation/derived-equivalence loop, not motivate inventing a host optimizer.

The TSP material is also useful because it demonstrates a minimum-cost observation over a shared continuation object. It is structurally closer to general optimization than a Boolean-only example.

---

# 19. Negative examples: what prior failed application work teaches

The Rubik and Erdős experiments are useful only as integration diagnostics.

## 19.1 Rubik

The failed code explicitly generated Word[]/candidate structures before asking the fibre machinery to do useful work. That exposes free syntactic expansion rather than allowing the mathematical action/identity object to conduct first.

Do not optimize that enumeration. It is a negative example of bypassing the intended semantics.

## 19.2 Erdős

One failed adapter effectively used:

    A = Set
    a = ErdosProblem1
    f = identity

so the fibre law correctly returned the proposition/type itself. Another path bounded/Booleanized/scheduled the proposition before giving it to the universal machinery.

Again, do not optimize those adapters. They show that manually wrapping the wrong object does not test the universal machine.

These application failures are why the capability should be language-level: users should not have to reverse-engineer the correct library wrapper for every mathematical object.

---

# 20. Implementation strategy

A fresh coding agent should proceed in this order.

## Phase A — establish the exact current path

1. Build the patched compiler.
2. Run the existing cubical test suite.
3. Compile SATProcess.bend with --to-hvm4-full.
4. Save the emitted HVM4.
5. Trace exactly which source definitions implement Carrier/FibreCoalgebra in that output.
6. Compile an equivalent simple ordinary Bend computation without WholeProcess.
7. Diff the emitted structures.
8. Identify the earliest compiler boundary where the typed mathematical map/object is known but the canonical fibre presentation is not yet attached.

Do not modify anything before this trace is clear.

## Phase B — make the smallest intrinsic bridge

Implement the smallest mechanism that makes the canonical lossless presentation available automatically at that boundary.

Prefer reuse of the existing Bend definitions over a second Haskell reimplementation of the law.

If a compiler-generated wrapper is sufficient, use that before inventing a new Core constructor.

If a runtime-prelude linkage is sufficient, use that before modifying WHNF.

If an AST/Core form is genuinely necessary, document why the existing typed Book + generated wrapper cannot express the behavior.

## Phase C — prove ordinary projection agreement

For each test object, compare:

    old ordinary result

with:

    visible projection of new lossless presentation

They must agree by the existing carrier law, and the concrete runtime outputs should agree too.

## Phase D — verify residual accessibility

Show that after obtaining the ordinary result, the exact source/residual and continuation remain accessible without recomputation from scratch.

## Phase E — verify demand sensitivity

Use SAT's established pattern. Asking only for a visible projection should not eagerly serialize every retained distinction. Asking for source/witness/all models should force more of the fibre.

## Phase F — verify cubical transport through the intrinsic path

Use supline/applypath/chain-style tests to ensure the automatic presentation has not accidentally bypassed full cubical runtime behavior.

## Phase G — only then test arbitrary propositions/optimization

After the generic language bridge works, use existing proposition and optimization examples as regression tests. Do not use them to design the architecture.

---

# 21. Required invariants for the implementation

Any proposed patch should be rejected unless the agent can explain how it preserves these.

**Losslessness:** the richer state is equivalent to the source, not merely observationally similar.

**Exact residual:** distinctions forgotten by the visible projection remain in the fibre.

**No premature collapse:** do not Booleanize, truncate, enumerate, or scalarize before the mathematics requires it.

**Cubical identity:** equivalent presentations remain executable paths, with higher coherence retained.

**Demand-driven execution:** retained structure need not be eagerly serialized.

**Coinductive closure:** the result of an interaction is again a valid whole object for the same law.

**Type-directed computation:** preserve the existing whnfCoe/whnfHCm semantics.

**SUP label coherence:** correlated branches remain correlated through transport/duplication.

**Ordinary projection compatibility:** old observable program results are projections of the richer semantics.

**No problem-specific policy:** the language integration cannot depend on SAT clauses, Rubik moves, Erdős parameters, etc.

---

# 22. Tests that should exist before calling this done

At minimum:

1. **Identity observation:** automatic presentation followed by identity projection reproduces the source exactly.
2. **Non-injective map:** visible result collapses sources while residual distinguishes them.
3. **Sequential observation:** observe f, then observe a function of the resulting carrier; reconstruct source.
4. **Univalent transport:** automatic presentation survives transport across an explicit equivalence.
5. **SUP transport:** automatic path uses the existing same-label routing behavior.
6. **Dependent Σ:** ensure residual/presentation survives dependent second components.
7. **Path-valued observation:** ensure the automatic wrapper does not erase higher structure.
8. **HIT/quotient example:** ensure full-runtime intrinsic presentation composes with existing eliminators.
9. **SAT XOR:** match existing readings and preserve a comparable native execution path.
10. **SAT answer-only demand:** confirm the entire retained fibre is not eagerly emitted.
11. **Coinductive follow-up:** multiple observations continue from retained state.
12. **Ordinary legacy program:** visible result unchanged.
13. **No accidental use of erasing backend:** tests explicitly use --to-hvm4-full.

Where possible, make tests compare old manual WholeProcess behavior with new intrinsic behavior.

---

# 23. Anti-patterns for agents

Stop immediately if the implementation plan contains phrases like:

- "let's write a search algorithm";
- "enumerate all candidates";
- "we need a SAT solver";
- "first convert the theorem to CNF";
- "let's add a heuristic optimizer";
- "the fibre law is just bookkeeping";
- "univalence is only proof-level and erased";
- "we need to port the mathematics from Agda first";
- "let's add a list of allowed questions";
- "let's manually supply all enabled futures";
- "let's wrap every function call and append it to a trace";
- "let's redesign HVM";
- "the existing mathematical result seems impossible, so first weaken the goal."

Those are signs that the agent has not understood the code it was told to read.

---

# 24. What "done" means

The task is not done when another demo manually imports FibreCoalgebra.

It is done when a normal checked Cubical Bend mathematical object/proposition can enter the full runtime through the canonical lossless/conductive semantics **without application-specific wrapper code**, while:

- ordinary visible results remain projections of the richer execution;
- exact residual structure remains available;
- continuation can be queried further;
- cubical equivalences remain executable;
- HVM sharing/SUP behavior remains active;
- no eager enumeration or pre-collapse is introduced.

The ideal result is that SATProcess.bend can be substantially simplified because the language now supplies the generic process that SATProcess previously had to spell manually.

---

# 25. Final mental model

Keep this model in view while coding:

    mathematical object / proposition
                |
                v
      typed point in Cubical Bend
                |
                v
      canonical lossless presentation
      A ≃ Σ b. fiber f b
                |
                v
      cubical transport / composition
      over all available identities
                |
                v
      HVM shared/superposed reduction
                |
                v
      requested visible projection
          + exact residual
          + continuation
                |
                v
      same law again when demanded

The proposition/map itself supplies the initial observation. The arbitrary question family is the interface for further projections of the already-presented whole.

The central implementation problem is not to invent this machine. **The machine already exists. Make the language actually run through it by default.**
