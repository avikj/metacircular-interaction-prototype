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
| L4 consequence propagation | `propagate/` — both indices, exact forward cone, survival by homotopy class, stale-vs-dead caches, route deltas, obligation triage | **BUILT**, 26/26 tests (15 capabilities, 11 controls), 12/12 mutants dead; cone 7/45 facts, incremental 42 vs full rebuild 226, null control 1 step / 0 cost |
| §4 reachability discipline | generated locus / completion / omitted locus declarations | **partial** — `distinguish/` attaches it to every claim (a quotient sufficient for one task family is not sufficient for the ambient problem; two later tasks collide, one recompiling to 108× compression, one to *none*, with the omitted locus identified as the endian class) |
| plural surfaces | `render/` — channels carrying proved preservation, an explicit collision witness, and `decode` returning the **fiber** (a lossy channel structurally cannot return a guess); layered chromatic coding in exact rationals; SVG output | **BUILT**, 68/68 tests, 12/12 mutants killed. The rendered picture **verifies its own theorem**: DIGIT_CRYSTAL 2.2 (complement exchanges carry with borrow) is re-checked against every `<rect fill>` re-parsed from the file. Proxy measurement only — **no human recognition-latency claim is established, and `certify_claim` rejects any INFORMATION_GAIN claim outright** |

## The trust boundary, stated plainly

Only **`Eq` (proof paths), `Iso` (round-trip normalization), and β** are
genuinely machine-checked. For `Quotient`, `Embed`, `Implies`, `Approx`,
`Refine`, `Interp`, `Dual` the checker verifies that a matching certificate
was *declared* — not that the mathematics holds. That is the real trust
boundary of the current kernel. It is a caller-supplied dictionary rather
than a global, so every widening of trust is visible at the call site.

## Known failure modes, in the order they will bite

1. ~~`explanations` enumerates simple paths exponentially and silently returns
   a subset once its `limit` is hit.~~ **FIXED** in the L4 lane. Proof paths are
   now quotiented by an explicit "distinct up to homotopy" notion — two paths
   are one proof when they consume the same **multiset of axiom
   justifications**, i.e. when reassociating congruence/symmetry/transitivity
   (and the kernel-decidable `Refl`/`Beta`) carries one to the other. Two
   independent axioms give 2 classes; the naturality square of β against
   congruence gives 2 raw paths and 1 class. `explanation_classes` returns a
   `ClassEnumeration`, **not a list**: enumeration is total up to stated bounds,
   and while `complete` is false, `len()`, iteration, `.classes` and `== ()` all
   raise `IncompleteEnumeration` — a subset can be accepted through `.partial()`
   in writing, but never mistaken for a total answer. What remains is a *cost*
   problem, not an honesty one: the class count itself can be exponential
   (6 links × 3 parallel axioms = 729 genuinely distinct transports, all
   enumerated), and the walk still enumerates raw paths before quotienting.
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

## L4: the locality and incrementality claims, in numbers

`runtime/demo/propagate_demo.py`, 45 facts / 21 derivations / full build 280:

| claim | measured |
|---|---|
| cone vs total | **7/45 facts (15%)**, 6/21 derivations, 13 index lookups, 38 facts never looked at; exact match against a full reread |
| survival through an independent proof | `THEOREM_A` **survives** (1 of its 2 homotopy classes avoids the retracted fact); `THEOREM_B`, with only that proof, **dies** — and so do its downstream consequences |
| incremental vs full | **42** exact steps vs **226** to rebuild — 81% of the rebuild avoided; the incremental result is asserted equal to a from-scratch rebuild of the post-retraction library |
| **null control** | retract a fact nothing depends on: cone **1/45**, **1** L4 step, **0** recomputation, all 44 other cache entries `is`-identical |
| locality | 38/38 outside-cone cache entries are the **same objects** (`is`, not `==`); the suite plants an equal-but-rebuilt entry to prove the check can fail |

Survival and cache validity are deliberately not conflated: `THEOREM_A` survives
*and* its cached value is garbage, because that value was computed along the
dead route. A runtime that served it because "the theorem is still true" would
be the stale-cache bug, and `verify_no_stale_reuse` is the control for it.

**The honest counterweight, kept in the table rather than omitted:**
compilation is not free. The §3.2 compile costs 23.8M steps against 122
steps saved per query — break-even at ~39,000 queries. Mathematics lowers
the cost of *further* understanding; it does not pay for itself on first
use. Any claim that it does would be measuring the wrong thing.
