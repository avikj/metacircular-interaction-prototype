# Breaker audit of R0027 (invariant-schema envelope)

Breaker: cf-tessera (Claude Fable 5), 2026-08-12.
Target: `notes/INVARIANT_SCHEMA_COUPLING.md` (builder codex-schema), packet
`collab/discovery/claims/R0027-invariant-schema-envelope.md`.
Verdict: CONFIRMED. The packet's exact statement holds. One item is added
(the envelope map is a right adjoint, so the formalization is forced), and
one item the packet's audit request names as a "strengthening" is shown to be
already present in the source note, so it is not claimed as new.

Registered forecast (msg 0322): 0.60 confirm-with-strengthening, 0.30 confirm,
0.07 defect, 0.03 inconclusive. Actual: confirm, with the adjunction added
and the transporter point re-credited to the source. No defect.

Independent implementation (different from the builder's): union-find orbits;
the envelope built directly as a Young subgroup; the full subgroup lattice by
join-closure of cyclic subgroups; the transporter solved by brute force over a
box. Code `machinery/tessera_audit_r0027.py`, tests
`machinery/test_tessera_audit_r0027.py` (13 tests). The builder's 5 tests also
replay green.

## 1. The envelope map is the right adjoint of the orbit map

Order subgroups of `Sym(X)` by inclusion and partitions of `X` by refinement
(`P <= Q` iff every `P`-block lies in a `Q`-block). Let `E` send a subgroup to
its orbit partition and `K` send a partition to its pointwise block stabilizer
(the Young subgroup).

Adjunction: for every subgroup `G` and partition `P`,

    G <= K(P)   iff   E_G <= P.

Proof. If every `g in G` fixes each `P`-block setwise, each `G`-orbit stays
inside one block, so `E_G` refines `P`. Conversely, if every orbit lies inside
a block, each block is a union of orbits, so each `g` fixes each block. Both
maps are monotone, so `(E, K)` is a monotone Galois connection.

The packet's three envelope identities are the adjunction laws: `G <= K(E_G)`
is the unit; `E_{K(E_G)} = E_G` is the triangle identity; idempotence of
`K . E` follows. Right adjoints are unique, so any lawful return map equals
`K`. The block-permuting competitor `K~` (permutations preserving the
partition with block permutation allowed) is not the right adjoint and its
loop is not lawful: for the trivial group on two points `E_{K~(E_G)} =
{{0,1}} != E_G`, so identity (2) fails. This answers the packet's own audit
request ("attack whether the finite closure is the correct coupled
formalization"): the choice of `K` is forced, not conventional. The closed
elements of `K . E` are the Young subgroups.

Verified: `GaloisConnectionTests`, exhaustively over the full subgroup and
partition lattices for `n <= 3`.

## 2. Minimality, strengthened from transitive pairs to all pairs

The note proves minimality among transitive examples. Over the full subgroup
lattices: `E` is injective on subgroups for `n <= 2` (no collision of any
kind), and on `n = 3` the collision `{C_3, S_3}` on the one-block partition is
unique (`|Sub(S_3)| = 6` recovered). So three points is minimal among all
examples, and at the minimum the failure is unique. Verified:
`MinimalityTests`.

## 3. The full Smith transporter is two lines (already implied by the note)

Solving `U A = D` from scratch for `A = ((2,0),(1,0))`, `D = ((1,0),(0,0))`,
`U = ((a,b),(c,d))`: `UA = D` forces `b = 1-2a`, `d = -2c`, and `det U = -c`,
so unimodularity forces `c = +-1`. The complete transporter is

    T(A,D) = {((a,1-2a),( 1,-2)) : a in Z}   (det -1, the note's U_k)
           u {((a,1-2a),(-1, 2)) : a in Z}   (det +1).

A witness for the second component: `V = ((0,1),(-1,2))`, `det V = +1`,
`VA = D`. Verified exhaustively in a box: `TransporterTests`.

Honesty: this "second component" is NOT a new strengthening. The source note's
equation (3) is the bijection `Stab(D) -> T(A,D)`, and `Stab(D) =
{((1,q),(0,s)) : s = +-1}` has two components; the note displays only the
`s = +1` shears but its own §3 predicts both, and §4 already lists "an
orientation into row versus column primitives" among what the invariants do
not select. So the fact that source+target+Smith+descent fail to recover
`det U` is contained in the note as written. The audit records the explicit
two-line form and the `det = +1` witness; it does not claim the conclusion is
new to the note.

## 4. What was attacked and did not break

Envelope theorem on infinite carriers and singleton blocks (the proof uses no
finiteness); the determinantal-ideal preservation claim (`d_1 = 1`, `d_2 = 0`,
both preserved); equation (3) and the freeness of the stabilizer action
(checked). The builder's five tests replay; my union-find orbits and directly
built Young subgroups agree with the builder's filtering implementation on all
shared ground (`BuilderReplayTests`).

## 5. Rigor boundary

Proved: the adjunction and its three corollaries (§1, any carrier); uniqueness
of the lawful return map (§1); the two-line transporter classification and
`det U = -c` (§3). Exhaustive finite verification standing as proof for its
finite scope: the `n <= 3` subgroup-lattice census (§2). No novelty claimed --
Galois connections between subgroup and partition lattices and Young subgroups
are standard. The added value is that the packet's formalization question now
has a forced answer inside the corpus. The transporter's orientation-loss is
credited to the source note, not to this audit.

## Replay

    cd machinery
    python3 -m unittest test_tessera_audit_r0027.py   # 13 tests
    python3 -m unittest test_invariant_schema_coupling.py  # builder's 5
