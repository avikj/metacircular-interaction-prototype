# Mathematical Wiki Build Specification

**Architecture:** Read [Bend2 � Unison reading and synthesis](BEND2_UNISON_READING_AND_SYNTHESIS.md) before implementing the site. The computational center is cubical Bend2 and its full HVM4 runtime. The target is to ground pages in addressable, checked, executable Bend2 constructions and their witnessed mathematical relations, retaining Agda source as relevant provenance during the port. The wiki is a view into that codebase.

## Invariants

- The site is a mathematical graph, not a topic tree.
- Wikipedia/textbooks explain standard nodes; this wiki owns project-specific constructions and nonstandard edges.
- Names are not pages: preserve aliases and merge only on exact/near-exact mathematical identity.
- Relations are typed: identity, equivalence, univalence, duality, restriction, truncation, projection, quotient, pullback, classification, specialization, generalization, refinement, composition, transport, implementation, realization, implication, corollary, counterexample, historical antecedent, observational/set/propositional shadow, carrier.
- Initial nuclei: universal classifier; forced lossless completion; composite residual; observation/descent; cubical composition; univalent transport; coinductive completion; dependent interaction/ISC; metacircular installation; locality/causal modulus; interaction geodesic; braid/noncommutation; phase/character quotient; Z4 invariant/symmetry; interaction-net realization; nonfactorization/interdependence.
- Every internal mathematical page eventually has one canonical Agda construction/facade covering its complete mathematical content. Linked concepts are imported/reused, not re-explained or independently re-proved. One theorem has one canonical source locus.
- The Pratt plate is installed as the initial front page concurrently with infrastructure; it is not blocked on wiki completeness.
- Work proceeds with heavy concurrency once page records/source loci exist; organization is continuously normalized as identities and equivalences are discovered.

## Pipeline

0. Preserve plan independently of chat history.
1. Inventory all candidate names/pages and preserve aliases.
2. Global identity/near-identity pass: mark identity, near identity, theorem-anchor, specialization, consequence, likely merge.
3. Global relation pass using typed graph edges.
4. Assign canonical Agda construction/facade and source anchors to every internal mathematical page.
5. Build site scaffold and install Pratt front page concurrently.
6. Generate pages concurrently from canonical records and constructions.
7. Continuously merge/redirect as mathematics reveals identities/equivalences; never erase alternate vocabulary.
8. Deploy once the first coherent graph is navigable and iterate continuously.

## Initial merge clusters

- Forced Completion: Fibre Law = Lossless Completion ≈ Trace Is Forced ≈ Residual Information Is Forced ≈ Exact Information Retained by an Observation ≈ What an Observation Forgets. `Losslessness Is a Property` is the uniqueness theorem; `Lawful Step Is the Map` its corollary.
- Executable Equivalence: Dynamic Reflection ≈ Equivalence Computes ≈ Univalent Transport as Inference ≈ Representation/Transformation through Univalence.
- ISC: Interactive Symbolic Computer = Dependent Interactive Coalgebra ≈ Interactive Symbolic Computing ≈ Query-Dependent Continuation ≈ Symbolic Object as Continuing Interaction.
- Metacircular Interaction: Metacircular Closure ≈ Mathematics Re-Enters Mathematics ≈ Derived Transformation as Future Operation ≈ Dynamic Universe of Operations; `IntrinsicRewrite`, Self-Presentation, ProductiveIndraNet remain distinct constructions.
- Causal Modulus: Causal Modulus = Unit-Speed Information Propagation ≈ Depth Is Time ≈ Word Length Is Causal Radius ≈ Interaction Light Cone.
- Interaction Geodesics: Interaction Geodesic ≈ Exact Interaction Complexity ≈ Geodesic Reduction ≈ Irreducibility as Geodesicity.
- Observation/Quotient: Observation Kernel ≈ Measurement as Quotient ≈ Observation Creates an Equivalence Relation ≈ What an Observation Forgets; Character Kernel is a structured specialization.
- Quarter-Turn/Z4: Quarter-Turn, Four-Phase Algebra, Z4 Charge, Global Charge/Local Unreadability, Exhausted Cellwise Centralizer, Chu4/Z4 are one tightly coupled theorem complex initially, with theorem anchors.
- Coinductive Completion: Coinductive Fibre ≈ Coinduction Is Completion ≈ Rope Completeness; finite/infinite and discrete/continuous are perspectives.
- Language Interaction: utterance=query, context=world, context change=successor, interpretation=dependent response, ambiguity=retained fibre are anchors of Language as Dependent Interaction unless independently substantial.
- Interface Interaction: interface=observation map, UI state=dependent world, UI=continuation, lossless interface are initially one theorem complex.
- Foundational slogans such as Geometry=Computation, Proof=Execution, Static/Dynamic Collapse, Syntax/Semantics Collapse are aliases/consequence anchors into precise theorem pages, not essays.

Expected working compression: hundreds of useful names � roughly 70�100 concepts � roughly 50 substantial pages � roughly 15�20 nuclei. This is descriptive, not a quota.

## Canonical page record

Each page record should contain: canonical title; aliases; historical names; standard external references; mathematical status; canonical Agda construction; source theorems; equivalent and dual presentations; restrictions/generalizations/specializations; instances; consequences; implementations; physical realizations; historical antecedents; parent nuclei; typed graph edges; checked/derived/conjectural status.

## Worker contract

A worker receives canonical page ID/title, aliases, status, canonical Agda source(s), prerequisite page IDs, known typed edges, relevant literature, and audience coordinates. It returns equation-dense page content, source anchors, relation updates, and proposed alias/merge discoveries. Workers never redefine shared mathematics: they import/link canonical constructions.

## Site behavior

Equation-dense expert pages; every loaded project-specific term linked internally; standard terms external when no project-specific specialization exists; aliases resolve without erasing vocabulary; direct theorem/source links to GitHub; typed relation graph navigation; multiple community entry routes; explicit checked/derived/conjectural status; anchor-level routing for theorem/perspective aliases; search indexes aliases and historical vocabulary; identity/equivalence discoveries are first-class UI events.

## Immediate work

Preserve/upgrade `research/pratt/PRATT_PLATE_V2.md` as site root; create machine-readable page manifest; run identity pass; run relation pass; start scaffold concurrently; begin canonical Agda facade pass; distribute canonical page records to workers; deploy as soon as the graph is navigable.

## Governing invariant

The wiki mirrors the mathematics: distinctions are preserved until an exact relation justifies collapse. When apparent subjects are proved identical, equivalent, or restrictions of one construction, the information architecture exposes that fact directly. Organization is part of the mathematical presentation, not a static taxonomy.
