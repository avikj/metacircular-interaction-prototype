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
