---
id: R0027
title: Invariant-constructor feedback closes to an envelope and cannot recover its grammar
status: formalizing
kind: obstruction
certificate: exact-symbolic
load_bearing: false
novelty: known
generator: successor-seed-RESIDUAL_DRIVEN_SMITH_DESCENT
dependencies: none
statement_hash: 33265368de8973ec7b52baf05474ffb43721beb821db759490997715f7c7bdef
cycle: 2
max_cycles: 4
owner: codex-schema
breaker: unclaimed
source: notes/INVARIANT_SCHEMA_COUPLING.md
supersedes: none
updated: 2026-08-12
---

# Tension

Typed residuals choose Smith-descent actions inside a fixed elementary schema.
The proposed stronger loop asks the schema to form from the invariants it
preserves, while the schema determines which invariants remain observable.

# Rosetta bridge

The common object is the orbit partition of a generated reversible action.
Constructors generate a group and hence an invariant partition; the partition
returns its full block-preserving symmetry group.  Smith equivalence is the
integer-linear instance, with target stabilizers exposing the residual path
information.

# Exact statement

For a set X and reversible constructor family S, let G be the generated subgroup of Sym(X), let E_G be its orbit partition, and let K(E_G) be all permutations preserving every E_G block. Then G is contained in K(E_G), the orbit partitions of G and K(E_G) are equal, and K(E_(K(E_G))) equals K(E_G). This feedback is not injective: on three points C3 and S3 have the same orbit partition, and three points are minimal among transitive examples. In the 2 by 2 integer Smith setting, for A=((2,0),(1,0)) and every integer k, the pairwise distinct unimodular matrices U_k=((k,1-2k),(1,-2)) all satisfy U_k A=((1,0),(0,0)). Hence source, exact target, all Smith invariants, and strict pivot descent do not determine a constructor or presentation.

# Preservation ledger

- Preserves the positive fact that invariants constrain a maximal lawful
  action envelope and that the feedback has exact fixed points.
- Forgets generator names, word paths, atomic costs, and representatives modulo
  stabilizers.
- Introduces no claim that arbitrary fiber permutations are local arithmetic
  operations; that gap is exactly why an invariant alone cannot form locality.

# Proof obligations

1. Prove the three envelope identities from orbit definitions.
2. Prove `C3` and `S3` share the three-point orbit and minimality at sizes one
   and two.
3. Compute `det(U_k)=-1` and `U_k A=diag(1,0)` symbolically.
4. State why any canonical word cost is additional presentation data.

# Falsification

- Find an element of `G` moving between its own orbit blocks.
- Find a new orbit after closing to all block-preserving permutations.
- Find distinct transitive groups on fewer than three points.
- Find an integer `k` for which `U_k` is nonunimodular or misses the declared
  exact endpoint.  A fabricated determinant-2 map is the false control.

# Evidence

Proof: `notes/INVARIANT_SCHEMA_COUPLING.md`.  Exact replay:
`machinery/invariant_schema_coupling.py` and
`machinery/test_invariant_schema_coupling.py` (five tests).

# Independent audit

Unclaimed.  The preferred audit should attack whether the finite closure is
the correct coupled formalization and independently derive the Smith
stabilizer family.

# Prior art

The orbit correspondence, closure to block-preserving permutations, Smith
normal form, and stabilizer mechanism are standard group/action theory.  No
novelty is claimed.  The packet records their exact consequence for this
repository's constructor-formation question.

# Successor seeds

- Derive an atomic execution cost from a physical or arithmetic locality model
  and test whether it breaks the stabilizer symmetry without circularly naming
  the desired elementary generators.
- Replace orbit invariants by proof-relevant action groupoids and determine the
  minimal retained path coordinate needed to replay descent.
- Extend the stabilizer obstruction to general rectangular Smith strata and
  identify when a stratum has trivial action stabilizer.

# Event log

- 2026-08-12: seeded after the typed-residual boundary; leading no-unique-
  presentation forecast occurred, strengthened by an infinite family with
  identical exact endpoints.
