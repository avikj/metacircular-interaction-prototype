---
id: R0002
title: Nonic prime-prefix factor classification
status: superseded
kind: measurement
certificate: exact-finite
load_bearing: false
novelty: unsearched
generator: factor-pipeline-acceptance
dependencies: none
statement_hash: 8c4122a70e711bc2b507eb3f132f93f71def84c882418caa559108a78b500b4b
cycle: 3
max_cycles: 8
owner: octic-frontier
breaker: unclaimed
source: machinery/specs/nonic-prime-prefix.json
supersedes: none
updated: 2026-08-11
---

# Tension

Exact classifications through degree eight suggest growing algebraic rigidity,
but the current scripts are hand-specialized and the degree-nine search space
may be the first layer where that method ceases to scale.  A theorem and a
quantified computational obstruction are both valuable outcomes.

# Rosetta bridge

Combine the unique-negative-root carrier used for odd degrees with the
Graeffe/resultant/sharded-enumeration machinery that closed the full octic
layer.  The common object is the even/odd decomposition
$g(x)=E(x^2)+xO(x^2)$ with unit resultant.

# Exact statement

Candidate theorem: for every real X, the prime-prefix polynomial $F_X(x)=\sum_{p\le X}x^{p-2}$ has no irreducible factor of degree $9$ over $\mathbb Q$.

# Preservation ledger

- Exact even/odd decomposition and first Graeffe transform preserve divisibility.
- Coefficient/root bounds may prune only after a written proof.
- Symmetry orbits must preserve candidate multiplicity and fixed points.
- Numerical root approximations may choose rational certificates but cannot
  settle root counts or tail signs.
- Finite cutoff exclusion needs a proved tail lemma covering every later prefix.

# Proof obligations

1. Independently expand the nonic Graeffe coefficients and resultant condition.
2. Prove a safe complete integer coefficient box from the Newman root annulus,
   the unique negative root, and Vieta bounds.
3. Enumerate every unit-resultant tuple in that box without overflow or unsafe
   heuristic filters; record sharded hashes and counts.
4. Apply exact Sturm/Routh topology, complete irreducibility checks, all earlier
   prefix resultants, and rational monotone-tail certificates.
5. Produce an implementation-independent audit of survivor hashes and all
   load-bearing formulas.

# Falsification

- Factor prime-prefix polynomials at accessible cutoffs and search directly for
  a degree-nine factor before building a universal exclusion.
- Ask SMT/CAS breakers for a tuple satisfying every proposed pruning inequality
  but omitted by the enumerator.
- Disable every filter independently and verify candidate-set containment.
- Cross-check resultants and Graeffe coefficients by three exact algorithms.

# Evidence

The literal all-real-$X$ statement is refuted at every $X<2$: then
$F_X=0$, so every polynomial divides it.  The corrected $X\ge2$ theorem is
proved by the fresh certificate registered as R0009, which supersedes this
boundary-defective seed.

# Independent audit

The R0009 hostile audit identified the missing boundary independently and
accepted the corrected theorem after a fresh full replay.

# Prior art

Pending targeted search in Newman/Borwein factor literature, lacunary
factorization, and prime-support polynomials.  General algorithms and root
bounds must be attributed separately from any prime-prefix specialization.

# Successor seeds

- Package exact low-degree factor machinery if the exp37 pipeline reproduces
  the octic regression ledger.
- If enumeration is infeasible, register the smallest quantified bottleneck as
  an obstruction packet and seek a new quotient/character before degree ten.

# Event log

- 2026-08-11: seeded as the first exact-computation acceptance experiment.
- 2026-08-11: refuted at $X<2$, then superseded by corrected theorem R0009.
- 2026-08-14: **PRIOR-ART SWEEP — serviced at the successor, not here.** This
  packet is superseded and refuted; its `novelty: unsearched` field is
  inherited by R0009, where the search is recorded (**RESOLVED-NO-MATCH** for
  the degree-nine prime-prefix theorem; Cohn's irreducibility theorem located
  as the nearest neighbour and explicitly *not* a match). Front-matter
  metadata deliberately not edited. Attribution status only.
