# Runtime status: what is built vs designed

Per `CRYSTAL.md` §6 — anything not listed as BUILT is designed, not built.
Updated by the integration lane as components land.

| layer | component | status |
|---|---|---|
| L0 exact identity | `kernel/term.py` — hash-consed de Bruijn STLC, address = blake2b of (head ‖ sort ‖ child addresses), names as a separate view table, ill-sorted construction impossible | **BUILT**, 33/33 tests, byte-identical under varied `PYTHONHASHSEED` |
| L1 typed edges | `kernel/edges.py` — 10 kinds, total composition (39/100 ordered pairs licensed, 61 `None`), exact `Fraction` ε, preservation as an intersection lattice over 9 tags | **BUILT** |
| L2 proof-relevant e-graph | `kernel/egraph.py` — union-find + congruence closure + genuine Nieuwenhuis–Oliveras proof forest (path reversed on union, NCA explain); directed edges never merge classes; retraction rebuilds only the cone | **BUILT** |
| L5 trusted heart | `kernel/check.py` — 189 statements, trust assumptions T1–T4 stated, recomputes every address from scratch, normalizes β-witnesses itself, verifies `Iso` by running the round trip on fresh probes, imports nothing from `egraph` | **BUILT** |
| §3.1 crystallization | derivation DAGs, sub-DAG mining, anti-unification, lemma install | in flight |
| §3.2 distinction compilation | collisions, minimal separating channels, partition refinement | in flight |
| L3 execution | rewriting, e-matching, cost-vector extraction | **designed, not built** |
| L4 consequence propagation | dependency cones, cache invalidation, route recomputation | **designed, not built** |
| §4 reachability discipline | generated locus / completion / omitted locus declarations | **designed, not built** |
| plural surfaces | perceptual/symbolic/executable projections with round-trip guarantees | **designed, not built** |

## The trust boundary, stated plainly

Only **`Eq` (proof paths), `Iso` (round-trip normalization), and β** are
genuinely machine-checked. For `Quotient`, `Embed`, `Implies`, `Approx`,
`Refine`, `Interp`, `Dual` the checker verifies that a matching certificate
was *declared* — not that the mathematics holds. That is the real trust
boundary of the current kernel. It is a caller-supplied dictionary rather
than a global, so every widening of trust is visible at the call site.

## Known failure modes, in the order they will bite

1. `explanations` enumerates simple paths exponentially and silently returns
   a subset once its `limit` is hit. It needs a real "distinct up to
   homotopy" notion — a cap is not a semantics. **This is the one that
   matters**: keeping distinct paths is the automorphism-preservation
   requirement (`CRYSTAL.md` §2 L1), so a silent subset is a silent loss of
   exactly the content the spec exists to protect.
2. `merge`'s duplicate-id scan is O(records) ⇒ O(n²) over n merges; wants an
   index.
3. **Retraction cone width**: the rebuild walks the transitive upward parent
   closure, so a heavily shared atom dirties nearly the whole graph. The
   locality *guarantee* holds (untouched classes assert `is`-identical); the
   locality *performance claim* would not survive a shared-atom workload.
4. `recompute_addr` is tree-recursive, not DAG-memoized — deliberate, to keep
   the trusted file obvious.

## Verification note

The kernel's own test suite passed 33/33 on first run, so it was
**mutation-tested**: 12 deliberate defects injected into copies. Three
survived — proof-forest rerooting, path contiguity, and the `Conjecture`
guard were not actually being tested. The suite was strengthened until
13/13 mutants die. A green suite that has not been mutation-tested is an
untested suite.
