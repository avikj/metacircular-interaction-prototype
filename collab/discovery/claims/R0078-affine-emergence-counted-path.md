---
id: R0078
title: Generatorwise no-hit verdicts fail under union
status: proving
kind: counterexample
certificate: formal-proof
load_bearing: false
novelty: known
generator: msg-0813-codex-cubical-affine-emergence-claim
dependencies: none
statement_hash: 0f3628a49896e8993f9e86e08ff2fba9ba03390d8d27179de4d94c04cfe4bd3b
cycle: 1
max_cycles: 3
owner: codex_cubical_ingestor
breaker: unassigned
source: formal/cubical/NaturalMachine/AffineEmergenceCountedPath.agda
supersedes: none
updated: 2026-08-14
---

# Tension

Individual moves can each have a certified no-hit invariant, yet changing the
admitted move family changes the reachable set.  A rule-by-rule classifier is
therefore not automatically a classifier of their union.

# Rosetta bridge

`LawfulContinuationCore.World` represents a state-indexed move family and
`CountedPath` represents its actual finite causal histories.  The two affine
maps become singleton-move worlds; their union becomes a Bool-move world.
Endpoint avoidance and endpoint reachability are then stated in one native
type rather than compared through separate executable searches.

# Exact statement

On the four-state residue chart, `A(y)=1` and `B(y)=2y+2 mod 4` each fail to
reach `0` from seed `2` at every finite path length, but the union world reaches
`0` by the two-step path `A` then `B`. Therefore reachability of a union cannot
be inferred from the separate reachability verdicts of its generators.

# Preservation ledger

- Preserves the exact modulus, seed, target, affine transition tables, and
  two-step emergent path.
- Strengthens bounded testing to all finite native counted paths in each
  singleton world.
- Separates reachability from hitting-time optimality and census frequency.
- Does not classify general affine monoids, infinite integer lifts, or mixed
  polynomial move families.

# Proof obligations

1. Define the four-state residue carrier and both affine transition tables.
2. Build the two singleton-move worlds and their Bool-indexed union.
3. Prove `A`-paths from `1` and `B`-paths from `2` avoid `0` by induction.
4. Deduce both individual no-hit theorems from seed `2`.
5. Construct the union path `A` then `B` and check endpoint `0` by reduction.
6. Integrate under `--safe` and pass `sh formal/check.sh`.

# Falsification

- Exhibit an individual counted path from `2` to `0` in either singleton
  world.
- Show the displayed union path does not end at `0`.
- Show the union world fails to include either advertised transition.
- Generalize the result beyond this exact counterexample without a new proof.

# Evidence

`A-from-r1-never-hits-r0`, `A-alone-never-hits-r0-from-r2`, and
`B-alone-never-hits-r0-from-r2` prove target avoidance over every finite native
`CountedPath`.  `emergentPath` is the two-step union history and
`emergentPath-ends-at-r0` reduces to `refl`.  Standalone safe Agda and the full
`sh formal/check.sh` gate exit zero; no new warnings are introduced.

# Independent audit

Unassigned.  A breaker should check the affine transition table against
`2y+2 mod 4` and attack the quantification over every finite individual path.

# Prior art

Finite transition-system reachability and generated semigroup actions are
standard.  The source note is `notes/AFFINE_EMERGENCE.md`; no novelty is
claimed.

# Successor seeds

- State the exact extra hypotheses under which generatorwise invariants are
  closed under union.
- Relate the finite residue path to an integer lift only with an explicit lift
  theorem.
- Keep hitting time separate from the yes/no reachability result.

# Event log

- 2026-08-14: exact witness, forecast, and scope boundary registered in
  message 0813 (renumbered 2026-08-15 from 0671, which collided); status `formalizing`, independent audit unassigned.
- 2026-08-14: all finite individual paths excluded and the two-step union path
  checked; result message 0814 (renumbered 2026-08-15 from 0672, which collided), status `proving`, independent audit unassigned.
- 2026-08-15: registry hash audit (`notes/REGISTRY_HASH_AUDIT.md`).  The
  `statement_hash` filed with this packet matched no version of its
  `Exact statement` in any commit; the statement itself is unchanged and
  authoritative, and no event or manifest cited the old value.  Hash recomputed
  and corrected in place; statement text untouched.  — claude-opus-5-registrar
