# Runtime status: what is built vs designed

Per `CRYSTAL.md` §6 — anything not listed as BUILT is designed, not built.
Updated by the integration lane as components land.

| layer | component | status |
|---|---|---|
| L0 exact identity | `kernel/term.py` — hash-consed de Bruijn STLC, address = blake2b of (head ‖ sort ‖ child addresses), names as a separate view table, ill-sorted construction impossible | **BUILT**, 33/33 tests, byte-identical under varied `PYTHONHASHSEED` |
| L1 typed edges | `kernel/edges.py` — 10 kinds, total composition (39/100 ordered pairs licensed, 61 `None`), exact `Fraction` ε, preservation as an intersection lattice over 9 tags | **BUILT** |
| L2 proof-relevant e-graph | `kernel/egraph.py` — union-find + congruence closure + genuine Nieuwenhuis–Oliveras proof forest (path reversed on union, NCA explain); directed edges never merge classes; retraction rebuilds only the cone | **BUILT** |
| L5 trusted heart | `kernel/check.py` — 189 statements, trust assumptions T1–T4 stated, recomputes every address from scratch, normalizes β-witnesses itself, verifies `Iso` by running the round trip on fresh probes, imports nothing from `egraph` | **BUILT** |
| §3.1 crystallization | `crystallize/` — derivation DAGs, contiguity-windowed sub-DAG mining, Plotkin/Reynolds anti-unification, 7-gate lemma install | **BUILT**, 30/30 tests, **seed criterion MET**: independent P4 29→12 steps, null control bit-identical at 29 |
| §3.2 distinction compilation | `distinguish/` — collision finder, exact minimum-cardinality channel search, Moore refinement | **BUILT**, 51/51 tests, **seed criterion MET**: 46656 states → 216 blocks, independent queries 91551→28672 steps, null control +616 and removed |
| L3 execution | `execute/` — checked rewriting, e-matching against e-classes, budget-honest saturation, Pareto extraction under a 4-component cost vector | **BUILT**, 59/59 tests, 13/13 mutants killed (the 12 newest tests are not yet mutation-tested). **Mathematics changed the geometry**: a theorem the runtime proved itself shortened 4 geodesics (24→15 steps on one target over the retained records — **20→15 over the class DAG, see the note below**), made 2 routes appear on the frontier and 4 vanish; null control bit-identical with 0 applications. Extraction over the class DAG (`extract_class_frontier`) widens the frontier to 16/14 routes, 4/3 of them to terms the e-graph never built |
| L4 consequence propagation | `propagate/` — both indices, exact forward cone, survival by homotopy class, stale-vs-dead caches, route deltas, obligation triage | **BUILT**, 32/32 tests (19 capabilities, 13 controls), 12/12 mutants dead; cone 7/45 facts, incremental 42 vs full rebuild 226, null control 1 step / 0 cost |
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


| education | `curriculum/` — dependency graph where every edge cites the theorem forcing it, choice metric in `ATLAS_OF_N`'s exact sense, order derived by sort on computed integers | **BUILT**, 55/55 tests, 15/16 mutants killed (survivor proved equivalent, recorded rather than counted as a kill). Derived order puts **group action 3rd of 13 and positional notation 13th of 13**, with 0/23 dependency violations and 0 choice debt against the conventional sequence's 11/23 and 7. Empirical learning claims are structurally rejected by the same guard `render/` uses |

## Cross-lane defect reports

1. ~~**`explanations`/homotopy DFS aborts globally on `max_depth` instead of
   backtracking.** On a 533-record graph it returns a single 240-step class
   where the geodesic is 15 — so it cannot currently be used to find short
   routes. Filed by the L3 lane against the L4/Part-A lane. Not a soundness
   bug (the guarded `ClassEnumeration` still refuses to pass off a partial
   answer as complete), but the enumeration is far from complete in practice.~~
   **FIXED** by the repair lane. The depth bound now prunes the *branch* and
   backtracks; rounds go shortest-first (iterative deepening with a
   breadth-first distance cut), so a budget buys the short classes. On the same
   533-record graph, same bounds: smallest class found **64 → 11 axioms**,
   classes found in the same 4096-path budget **104 → 523**, nodes explored
   **252,202 → 26,346**. On a synthetic worst case (a 301-record chain hiding a
   15-axiom route) it went from **0 classes** to finding the 15-axiom one.
   Completeness semantics are untouched: a run that pruned anything still
   reports `complete=False`, with the pruned-branch count in `reason`. Pinned by
   `A7`, `A8` and the control `x_depth_pruned_not_complete` in
   `tests/test_propagate.py`; numbers in `SCALE.md` §5.
2. ~~**`kernel/README.md` still documents the old `explanations(x,y,limit=8)
   -> tuple` signature**, which Part A replaced with the guarded
   `ClassEnumeration`. The contract other lanes code against is stale.~~
   **FIXED**. `kernel/README.md` now documents the real API and carries a
   **Contract changes** section (C1 the `ClassEnumeration` replacement, C2 the
   backtracking fix, C3 the shortest-realisation representative) so a later
   lane can read the history instead of trusting a silently-edited document.
3. ~~**`propagate/invalidate.py`'s derivation-tree walk aborts globally on
   `max_depth` exactly as `egraph.py` used to.** Filed by the repair lane
   against itself rather than fixed.~~ **FIXED.** Same defect, same repair,
   and now the *same code*: the discipline lives in the new
   `runtime/kernel/bounded.py` (prune the branch, deepen shortest-first over an
   admissible lower bound, report which bound bound) and both
   `egraph.explanation_classes` and `invalidate.justification_classes` call it.
   On a 60-link chain hiding a 2-fact independent survivor: **0 classes →
   1 class of size 2**, and the verdict **`UNDECIDED` → `SURVIVES`** — the old
   behaviour could not certify survival for a consequence that plainly
   survived, and `recompute.apply` refuses to act on `UNDECIDED`. Nodes
   explored 33 → 96 (it now explores instead of dying). **No published number
   moved**: `runtime/demo/propagate_demo.py` is byte-identical, including 344
   L4 steps for `P00` against 1 for the null control. Pinned by `B10`, `B11`
   and the control `x_l4_depth_pruned_not_complete` in
   `tests/test_propagate.py`; contract entry in `propagate/README.md` §7 C1–C3
   and `kernel/README.md` C4.
4. ~~**The materialisation cliff.** `execute/README.md` §10 item 2: with
   `max_exhaustive_vars = 1`, multi-variable rules bind canonically and build
   their right-hand sides at one representative per class, so the Pareto
   frontier only ever contains terms someone materialised and a better route to
   an unbuilt term is invisible.~~ **FIXED** by the named fix — Pareto
   extraction over the class DAG (`execute.extract_class_frontier`, a vector
   fixpoint with a Pareto set of realisations per e-class, assembling terms that
   need never have been built). On `demo/geodesic_demo.py`'s task the frontier
   goes **11 → 16** nondominated routes before the theorem and **9 → 14** after,
   with **4 (before) and 3 (after) frontier routes landing on terms the e-graph
   never built**; 0 routes rejected by the checker, all 208 destinations
   evaluated to the single value 6561, the null control still bit-identical, and
   the class fixpoint converging in 4 rounds / 3 rounds rather than hitting a
   bound. Demo §13; contract entry in `execute/README.md` §12 C3–C4.
   **One published number is now known to be an extraction artifact — see the
   note below.**
5. **`EGraph.explain` is not a metric and must not be used as one.** Its
   length is proof-forest route length, which depends on merge order: in an
   early L3 draft, adding a theorem made a target go 28 → 36 steps while
   genuinely getting *closer*. L3 added `RouteFinder` (Dijkstra over the
   retained justification graph, congruence edges weighted by the recursive
   geodesic between their arguments). Any future distance claim must use it.

## The number the class-DAG extractor moved, stated loudly

The L3 row in the table above, and `execute/README.md` §7, report that the
`pow4` theorem took the geodesic to `sqr(sqr(sqr #3))` from **24 to 15** steps,
a change of **−9**. That is a correct statement about `RouteFinder`: 24 is the
shortest route through the **retained merge records** before the theorem.

It is *not* the shortest checkable proof. Extraction over the class DAG finds a
**20-step** checked proof of the same target in the same before-theorem book,
because a congruence proof assembled from freely chosen sub-geodesics need not
correspond to any single retained congruence record. Measured over the class
DAG the theorem's effect on that target is **20 → 15, i.e. −5**.

Both numbers are checked proofs and both are reproduced by
`runtime/demo/geodesic_demo.py` (§7 and §13 respectively). **The direction of
every claim is unchanged**: the theorem strictly shortens the target, no route
gets longer, the frontier moves, and the null control changes nothing. What is
no longer defensible is the magnitude −9 as a claim about *proofs* rather than
about *record-graph routes*. Anything quoting "24 → 15" or "−9" should quote it
that way round.

## A note on the cost vector

L3 reports that on its demo task `verify` is near-collinear with `steps`:
*a four-component vector with two near-parallel components is a
three-component vector wearing a hat.* Recorded rather than fixed — the
Pareto machinery is correct, but the claim "four independent costs" is not
established on this task.

## Scale: the "measured on toy tasks only" objection, answered in numbers

Full curves, method and caveats: **`runtime/SCALE.md`**. Headlines:

| what was tested | prediction | measured |
|---|---|---|
| §3.1 lemma book (`crystallize/README.md` §6.1: *"at a few hundred lemmas the search cost overtakes the step savings"*) | a few hundred | **break-even at 22 lemmas, net loss from 23** — right in kind, ~15× optimistic in degree. Step count never decays: **12 steps at a 1-lemma book and at a 3000-lemma book**, null book 29 at every size |
| the fix that lane named (discrimination net on lemma LHSs) | "the first thing that must change" | **built** (`crystallize.derivation.LemmaIndex`, off by default). Per-query index: crossover 22 → **477**. Index built once per book: query work is **constant at 1,623 from N=10 to N=3000** — no crossover at any size measured, and 3.3× cheaper than the empty book |
| L3 e-matching (*"only postpones the wall"*) | — | **e-matching automaton built** (compile once, register machine, candidates deduplicated by e-node signature). Demo saturation **33,630 → 16,962 visits**; on an AC-saturated 6,549-node graph **3.1× fewer total lookups** and 2.7×–4.7× faster on search-dominated patterns — but **3–10% slower on two match-heavy patterns**, which are in the table, not a footnote. Identical matches in identical order, held by a differential test and re-asserted by `demo/ematch_bench.py` on every run; the recursive matcher is retained and selectable. It removes constant factors, **not** the exponential in pattern size |

**Seed criterion at scale (§3.1): survives.** At the largest book measured
(3,000 checked lemmas) P4 still solves in 12 steps against the null book's 29,
with the answer independently re-verified. The criterion is durable because it
is a statement about *steps* — but a step claim stops being an operational
claim once search cost dominates, and with the linear scan that happens at 22
lemmas. With the net amortised, cost stops growing with the book at all.

**Two counters that must not be compared across engines.** `ematch`'s
`max_visits` is a *budget*, not a metric: the recursive matcher charges nothing
for a memo hit and the automaton charges nothing for an entry-cache hit, so
their `visits` are not the same unit. Counting every lookup either engine
performs, the automaton does 2.6× less work on the hardest graph measured;
counting raw `visits` it looks worse there and better on the demo. `SCALE.md`
§4.4 states this in full.

**Still open after the repair lane:** `merge`'s O(n²) duplicate-id scan;
retraction cone width; `recompute_addr` tree recursion; class enumeration is
still exponential in *work* on dense justification graphs (the fix is dominance
pruning on the partial multiset during the walk, not more bounds); L4's
iterative deepening re-expands once per tree height and `expand` is not memoised
across rounds; the class-DAG fixpoint's per-class Pareto filter is exact in
`(steps, size, width)` and **silent in `verify`**; the class-DAG fixpoint is
bounded rather than convergent on a *cyclic* class graph and nothing measured so
far exercises that case; saturation still fires rules only at canonical
representatives, so extraction over classes does not make e-matching see unbuilt
terms; and the twelve tests added for the e-match automaton and the class-DAG
extractor have **not** been mutation-tested, so those two components carry a
weaker guarantee than the rest of the runtime.

**The two stale documents are no longer stale.** `execute/README.md` now
documents both e-match engines (§3.4, automaton by default) and class-DAG
extraction (§5.1), and carries a **Contract changes** section (§12, C1–C5);
`crystallize/README.md` now records the measured crossover at 22 lemmas and the
built `LemmaIndex` (§6.1) and carries its own **Contract changes** section (§7,
C1–C3). `propagate/README.md` gained §7 C1–C3 for the backtracking repair, and
`kernel/README.md` gained C4 for the shared `kernel/bounded.py`.

## Correction, and its retraction: the plateau is in the OBJECT

**The check has now been run** (`runtime/demo/plateau_check.py`), and it
refutes the correction below. Same runs, four observables of the same
derivations, eight rounds:

| bench | steps | route | #terms | lemma fires | verdict |
|---|---|---|---|---|---|
| B1 | 12, flat | **identical every round** | flat | 1 | plateau is in the object |
| B3 | 80, flat | **identical every round** | flat | 0 | plateau is in the object |
| B2 | 24→14 once | changes once, then flat | — | 1 | steps moved |
| B4 | 41→28 once | changes once, then flat | — | 2 | steps moved (and B4 is leakage-disqualified) |

For B1 and B3 the derivation is **bit-identical across rounds** — same route,
same rule set, same intermediate terms. Only `work` shifts, and only by the
few units that a longer book costs to scan. Nothing is moving underneath a
flat counter. The lane's original reading was right and the ceiling claim
stands as filed.

**The meta-lesson, which is the part worth keeping.** `CARRY_SHUFFLE.md` §4
says a flat observable is not *evidence* of a flat process — it does not say
the observable is lying. I treated it as a trump card rather than as a
question, and wrote a correction on the strength of an analogy. That is the
same error as the thing it was correcting, one level up: substituting a
general principle for a measurement. The principle earns its keep by
prompting the check, not by pre-empting it.

---

*(retained for the record: the correction as originally filed)*

## ~~Correction: the plateau is unresolved between object and observable~~

The vocabulary self-extension lane (`runtime/vocabulary/`) reported that
twelve mined constructors moved no benchmark, and located the cause as an
architectural ceiling — the proposal mechanism being closed under the shape
space of the schema that produced it.

That plateau was measured in **step counts**, which are a lumping of the
process. `notes/CARRY_SHUFFLE.md` §4 shows, in exact arithmetic, a lumped
statistic equilibrating in $O(1)$ where the object it shadows needs
$\Theta(\log n)$ — a flat observable is not evidence of a flat process.

So the ceiling claim should be read as **located in the counter, and not yet
shown to be in the machine.** The distinguishing check — whether a different
observable of the same runs still shows a plateau — was never run. The
lane's own data is suggestive against it: benchmark B3 sits flat at 80 steps
with zero lemma fires, while the *same polynomial* regrouped goes 54 → 37 and
fires. Structure the statistic could not see.

Reasoning: `notes/NO_PRIVILEGED_CHART.md` §5.

## Quarantine: three modules present in the tree but NOT landed

`runtime/nerve/`, `runtime/capability/` and `runtime/panini/` import cleanly
but have **no test files and no demo output**. They were swept into commits by
the integration lane's `git add -A` while their authoring lanes were still
running, and those lanes did not report. `runtime/capability/` and
`runtime/panini/` are also incomplete by their own briefs (2 files each where
the brief specified 4–6).

**They are not landed and must not be cited.** Every other row in this file is
backed by a passing suite with planted-false controls; these are backed by
nothing. Do not import them from a lane that makes claims, do not count them as
implementing the layers they are named for (§8 duality crystals; the
theorem→capability compiler; rule-conflict resolution), and do not read their
presence as evidence those layers exist.

Correct dispositions, in order of preference: an authoring lane finishes them
with tests; or an integrator writes the tests; or they are deleted. Leaving
untested modules in the tree that *look* landed is the failure mode this file
exists to prevent, and it happened here through my own `git add -A`.

Provenance for whoever picks them up: the nerve lane was to compute the Čech
cohomology of the four views (truth / action / cost / residual) and hunt the
gluing obstruction — with the Fermat case predicted to obstruct. The
capability lane was to build the six-part proved-capability record and the
executable-content classification, with `ExistenceOnly` required to yield zero
speedup. The panini lane was to implement Pāṇinian rule-conflict resolution and
cakravāla, and to attribute `runtime/distinguish/` to apoha. Briefs are
recoverable from this session's transcript.
