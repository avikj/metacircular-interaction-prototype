# Runtime status: what is built vs designed

Per `CRYSTAL.md` §6 — anything not listed as BUILT is designed, not built.
Updated by the integration lane as components land.

| layer | component | status |
|---|---|---|
| L0 exact identity | `kernel/term.py` — hash-consed de Bruijn STLC, address = blake2b of (head ‖ sort ‖ child addresses), names as a separate view table, ill-sorted construction impossible | **BUILT**, 33/33 tests, byte-identical under varied `PYTHONHASHSEED` |
| L1 typed edges | `kernel/edges.py` — 10 kinds, total composition (39/100 ordered pairs licensed, 61 `None`), exact `Fraction` ε, preservation as an intersection lattice over 9 tags | **BUILT** |
| L2 proof-relevant e-graph | `kernel/egraph.py` — union-find + congruence closure + genuine Nieuwenhuis–Oliveras proof forest (path reversed on union, NCA explain); directed edges never merge classes; retraction rebuilds only the cone | **BUILT** |
| L5 trusted heart | `kernel/check.py` — 189 statements, trust assumptions T1–T4 stated, recomputes every address from scratch, normalizes β-witnesses itself, verifies `Iso` by running the round trip on fresh probes, imports nothing from `egraph` | **BUILT** |
| §3.1 crystallization | `crystallize/` — derivation DAGs, contiguity-windowed sub-DAG mining, Plotkin/Reynolds anti-unification, 7-gate lemma install | **BUILT**, 27/27 tests, **seed criterion MET**: independent P4 29→12 steps, null control bit-identical at 29 |
| §3.2 distinction compilation | `distinguish/` — collision finder, exact minimum-cardinality channel search, Moore refinement | **BUILT**, 51/51 tests, **seed criterion MET**: 46656 states → 216 blocks, independent queries 91551→28672 steps, null control +616 and removed |
| L3 execution | rewriting, e-matching, cost-vector extraction | **designed, not built** |
| L4 consequence propagation | dependency cones, cache invalidation, route recomputation | **designed, not built** |
| §4 reachability discipline | generated locus / completion / omitted locus declarations | **partial** — `distinguish/` attaches it to every claim (a quotient sufficient for one task family is not sufficient for the ambient problem; two later tasks collide, one recompiling to 108× compression, one to *none*, with the omitted locus identified as the endian class) |
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


## Seed criterion: MET, twice, independently

Both self-improvement algorithms satisfy `CRYSTAL.md` §0 on their own
domains, with null controls:

| | mathematics that entered | independent problem | before | after | null control |
|---|---|---|---|---|---|
| §3.1 | difference of squares, mined from three unrelated derivations, rebuilt and 7-gate checked | P4, verified not an instance of any training problem, firing on compound arguments no instance exhibited | 29 steps | **12** | unrelated valid lemma: **29**, bit-identical (search work +12%) |
| §3.2 | a coarsest sufficient quotient (46656 states → 216 blocks) | 512 fresh states with fresh action words, **zero overlap** with the states that drove refinement | 91551 steps | **28672** | irrelevant valid channel: **+616 steps**, and removed by the redundancy step |

Neither reduction is a cache: in both cases a *true but irrelevant* fact
leaves cost unchanged or worse. That gap is the entire thesis.

**The honest counterweight, kept in the table rather than omitted:**
compilation is not free. The §3.2 compile costs 23.8M steps against 122
steps saved per query — break-even at ~39,000 queries. Mathematics lowers
the cost of *further* understanding; it does not pay for itself on first
use. Any claim that it does would be measuring the wrong thing.
