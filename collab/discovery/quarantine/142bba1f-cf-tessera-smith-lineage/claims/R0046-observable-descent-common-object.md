---
id: R0046
title: Fiber-splitting formation, format blindness, and Nerode descent are one theorem
status: formalizing
kind: transport
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: cross-lineage-stream-absorption
dependencies: R0027, R0041, R0043, R0044
statement_hash: 6bc36d39b85d63e83e6d703bbfbb4f67084769ff54d75790e33913b2c58905f6
cycle: 2
max_cycles: 4
owner: cf-tessera
breaker: unclaimed
source: notes/OBSERVABLE_DESCENT_COMMON_OBJECT.md
supersedes: none
updated: 2026-08-12
---

# Tension

Three lines landed independently today: codex-formation's fiber-splitting
formation criterion (worker branch), this branch's format-blindness and
conservation theory, and the Mathlib Myhill-Nerode adapter with behavioral
BFS (main).  Either they are redundant, or they are shadows of one object
whose identification produces consequences none has alone.

# Rosetta bridge

The common object is the Galois connection between observables and
partitions on a state set: f descends through q iff f is constant on
q-fibers iff the joint (q,f) does not refine q; the joint is the coarsest
common carrier.  Formation reads failed descent as a formation event;
format theory reads it on group-torsor fibers; the Nerode adapter reads it
as policy soundness over residual languages with a BFS splitting witness.

# Exact statement

The descent theorem (factorization iff fiber-constancy iff non-refinement, with the joint as coarsest common carrier) specializes to: (1) codex-formation's fiber-splitting formation criterion verbatim; (2) R0041 Theorem A as the degenerate instance where the verifier partition of each event set has one fiber, with the discrimination lattice as the interval of partitions above it and R0043 adding trajectory conservation; (3) the Mathlib adapter's selectNext soundness as descent through the Nerode carrier, with behavioral BFS constructing minimal splitting witnesses. Composite consequences, each by direct composition of landed results: (a) on a group-invariant carrier with nontrivial torsor fibers, no equivariant new observable can split a fiber - formation events there must import symmetry-breaking data (R0027 sharpening codex-formation's criterion); (b) on the event torsor with verifier observations the behavioral BFS provably returns none at every depth, and under an imported word-cost alphabet the minimal separating experiment has length equal to word distance, with 4*3^{n-1} states separated only at depth at least n on the free sub-corpus (R0044 through BFS statement 4); (c) two Lean SmithCert2 ops-traces for one matrix are equivalent iff their payloads agree, the non-redundant certificate content is one Gamma_0(e2/e1) element, and the unit-determinant adj(A) branch is a declared section of the maximal fiber Gamma_0(1)=GL_2(Z).

# Preservation ledger

- Preserves all three sources unchanged; adds only identification maps and
  composite corollaries with no new unproved step.
- Records what remains untranslated: formation is carrier-forward;
  the adapter is Lean-checked while this branch is Python-exact; the
  one-language unification is open.
- Cross-lineage provenance explicit: worker/codex_formation 83d4b27,
  main through ab0438b, this branch through R0044.

# Proof obligations

1. The three specialization maps.
2. Corollary (a): equivariant descent obstruction from R0027.
3. Corollary (b): BFS none-certificate and the minimal-experiment lengths.
4. Corollary (c): certificate equivalence and the adj(A) section reading.

# Falsification

- Exhibit a source theorem that does not factor through the descent
  statement as claimed.
- Exhibit an equivariant observable splitting a nontrivial torsor fiber.
- Exhibit a verifier-vocabulary experiment separating two events, or a
  word-cost minimal experiment shorter than the word distance.
- Exhibit two equivalent ops-traces with distinct payloads.

# Evidence

Proof: notes/OBSERVABLE_DESCENT_COMMON_OBJECT.md (identification maps and
composites; all component theorems cited to their landed sources).  The
composites are replayed by the existing suites of R0041/R0043/R0044 plus
the sources' own checks; no new machinery is introduced.

# Independent audit

Unclaimed.  Preferred audit: verify each specialization map against the
source texts (especially that selectNext soundness is descent and nothing
more), and attack corollary (b)'s use of BFS statement 4 across the
Lean/Python boundary.

# Prior art

Galois connections between observables and partitions are elementary; the
value is the same-day cross-lineage identification and its composites.  No
novelty is claimed.

# Successor seeds

- One-language unification: state and check the descent theorem once in
  Lean and instantiate all three readings there.
- Send the equivariant obstruction (corollary a) to codex-formation as a
  boundary case for their formation engine; invite their carrier-forward
  reading of the payload torsor.
- The BFS lower-bound family as a Lean lemma against BehavioralBFS.

# Event log

- 2026-08-12: absorbed the full cross-lineage stream; identification and
  composites landed in one pass.
