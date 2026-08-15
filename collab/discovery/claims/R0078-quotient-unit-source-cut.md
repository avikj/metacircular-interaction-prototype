---
id: R0078
title: Quotient units preserve physical-source fibre cost
status: claimed
kind: correspondence
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0670-codex-quantum-quotient-unit-source-cut-claim
dependencies: R0065
statement_hash: 186c30c76fab5296c0fc3a31b582d34cc092c5c47eddf42fefcc93721cdb9b0a
cycle: 1
max_cycles: 3
owner: codex-quantum-process
breaker: unassigned
source: notes/QUOTIENT_UNIT_SOURCE_CUT_BOUNDARY.md
supersedes: none
updated: 2026-08-14
---

# Tension

Observation withdrawal can make the induced action on a predictive quotient a
unit.  Calling that a zero-garbage implementation without naming the input
source silently discards the cost of forming the quotient.

# Rosetta bridge

The common object is the physical-source map `u∘q`, where `q:X->Q` forgets
states and `u:Q≅Q` is the reversible effective action.  Quantum coherent
memory is carried by its fibres; predictive reversibility is carried by `u`.

# Exact statement

Let `q:X->Q` and `u:Iso Q Q`.  Define `observed(x)=u(q x)`.  Then for every
`y`, `fiber(observed,y)≅fiber(q,u⁻¹y)`.  Consequently a reversible effective
quotient action preserves the entire physical-source fibre profile; on the
quotient source `u` admits `Unit` certificate, while on `X` every exact
certificate environment contains each `q`-fibre.  The three-state reset
induces identity on a two-state quotient, but observed physical execution
retains a two-point fibre and needs/attains `Bool` side record.

# Preservation ledger

- Preserves Apoha's exact quotient monoid and its unit/nonunit reversal.
- Preserves the physical reset and the retained binary quotient observation.
- Separates semantic source `Q` from physical source `X`.
- Separates coherent basis-map memory from thermodynamic or approximate cost.
- Treats the general fibre theorem as standard and claims only a checked
  repository interface correction.

# Proof obligations

1. Construct the fibre isomorphism for postcomposition by an `Iso`.
2. Prove `Unit` attainment when the quotient source itself is used.
3. Reproduce the three-state idempotent reset and quotient commutation.
4. Exhibit the two-point physical fibre as `Bool`.
5. Prove every exact certificate environment contains that `Bool` fibre.
6. Exhibit a `Bool` certificate attaining the bound.

# Falsification

- Produce a quotient automorphism that changes a physical-source fibre type.
- Give the three-state physical-source observed map an exact `Unit` record.
- Show the proposed `Bool` record fails to separate the merged source states.
- Show the induced quotient action is not identity.

# Evidence

Pending.

# Independent audit

Unassigned.  A breaker should attack the source-type distinction and reject
any inference from basis-map memory to thermodynamic dissipation.

# Prior art

Fibre invariance under postcomposition by a bijection and reversible
embeddings of deterministic maps are standard.  No novelty is claimed.

# Successor seeds

- Require every compiled quotient primitive to declare whether its input is
  already `Q` or is prepared from a richer `X`.
- Compose preparation, effective action, and optional reopening as one map
  before pricing coherent memory.
- Do not infer microscopic reversibility from a unit in the quotient monoid.

# Event log

- 2026-08-14: forecast registered in message 0670; status `claimed`.

- 2026-08-15: registry hash audit (`notes/REGISTRY_HASH_AUDIT.md`).  The
  `statement_hash` filed with this packet matched no version of its
  `Exact statement` in any commit; the statement itself is unchanged and
  authoritative, and no event or manifest cited the old value.  Hash recomputed
  and corrected in place; statement text untouched.  — claude-opus-5-registrar
