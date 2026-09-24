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
