# Machine Self-Architecture — Delta 28 applied to the machine's own graph

Date: 2026-08-16
Status: exact finite computation on a concrete finite object (the import DAG),
plus one small proved lemma; no fitted quantity anywhere.
Depends on: `notes/DEPENDENT_SYSTEM_OPTIMIZATION_DELTA_28.md` (§16–25, §46),
`formal/cubical/DSOCutCalibration.agda` (the width-convention calibration),
`machine/SelfArchitecture.hs` (the computation), `machine/self_architecture.tsv`
(the emitted order and widths).
Sibling lane, same day: `machine/DSOSchedule.hs` runs the §46 meta-Bellman on
the *conjecture-mask lattice* (32→28 steps, certified). This note is the other
self-application: the widths of Delta 28 §20–25 on the *module import DAG* the
machine itself is made of.

## 0. What theorem does the computation replace?

Per the repository protocol, first the theorem, then the run. The run here is
of the protocol's allowed kind — a finite exhaustive computation producing a
mathematical object (a DAG, its cuts, and integer invariants of them), not a
measurement. The two general statements it instantiates are already theorems:

- **Thm 28.5 / 28.7** (r ≤ d ≤ raw): the deterministic semantic width of a cut
  is at most its raw separator width; both can be strict. The calibration
  instance is kernel-checked in `DSOCutCalibration.agda` (4 > 3 > 2).
- **Terminal-cut lemma** (proved below, §5): on any finite DAG, every
  topological checking order ends at a module with no dependents, and the cut
  just before it has deterministic semantic width exactly 1, whatever its raw
  width.

What only computation can supply is the *value* of these invariants on one
specific object — the machine's own dependency graph — and that computation is
exact: Boolean carrier, bitset reachability, distinct-row counting. No
floating point, no fitting, no sampling.

## 1. The object

Snapshot: git-tracked corpus of `formal/cubical/` at HEAD `fb404ce4`
(2026-08-16). The checkout is shared and had untracked in-flight files from
concurrent sessions; the analysis is pinned to the tracked file list
(`git ls-files 'formal/cubical/*.agda'`) so it is reproducible from the
commit. Regeneration:

    ghc -O2 machine/SelfArchitecture.hs
    git ls-files 'formal/cubical/*.agda' | sed 's|^formal/cubical/||' > /tmp/tracked.txt
    ./SelfArchitecture formal/cubical machine/self_architecture.tsv /tmp/tracked.txt

Exact facts of the graph:

- **387 modules, 946 internal import edges** (imports of `Cubical.*`/`Agda.*`
  excluded; comments stripped with correct `{- -}` nesting before parsing).
- **16 modules with no dependents** (sinks): `Everything`, `R0021FlipOrbit`,
  `HeadDepthMergeBreaker`, `CyclotomicMined`, `FactoryVICore`,
  `NaturalMachine.OracleSeparation`, and the ten
  `NaturalMachine.Control.*` counterexample modules.
- `Everything` directly imports 76 modules and transitively imports 371 of
  the other 386 — the 15 it misses are exactly the other sinks (a sink that
  imports the corpus is invisible to a latch made of imports; this is the
  drift `Everything.agda`'s own header predicted).
- **The `NaturalMachine` root is a second aggregator**: it plain-imports its
  subtree the way `Everything` does (long `import M` list, not just the 11
  `open import … public` re-exports). Consequently
  `NaturalMachine.TransportCost` and `NaturalMachineRun`, which import the
  root, sit *above* almost the whole corpus: while they are unchecked, every
  checked module below the root is inside their future cone.

## 2. Definitions (fixed by the calibration, not invented here)

A checking order `o` (topological: imports before importers) induces a path
decomposition: cut `i` separates the checked prefix from the unchecked
suffix. At each cut:

- **separator** `S_i` = checked modules with at least one direct unchecked
  importer;
- **cut matrix** `K_i : S_i × U_i → Bool`, `K_i(s,u) = true` iff `u`
  transitively imports `s` — the reachability cut matrix, Boolean carrier;
- **raw separator width** = `|S_i|` (count of separator states, the
  calibration's "4");
- **deterministic semantic width** = number of distinct rows of `K_i` (the
  future-behavior classes of Delta 28 §16–17 at Boolean weights — the
  Myhill–Nerode quotient of the corpus's own `FutureBehavior` lane; the
  calibration's "3").

Widths are reported as counts, not `log₂` (Delta 28 §20 uses bits; the
conversion is notational). The **latent width** `r` (Boolean factor rank /
minimum rectangle cover) is deliberately **not computed**: minimum cover is
NP-hard, and a heuristic cover presented as a width is exactly what the
protocol forbids. Thm 28.7 gives `r ≤ d ≤ raw`, so every collapse reported
below is a lower bound on the latent collapse.

## 3. Candidate decompositions, exact widths

Five candidate orders were evaluated (the *choice* of candidates is where the
only heuristics live, and they are labelled as such; every width below is
exact for its order):

| candidate | peak raw (at cut) | peak det (at cut) | Σ raw | Σ det |
|---|---|---|---|---|
| alphabetical-kahn | 358 (381) | 49 (182: `NM.ProductiveTear`) | 68342 | 10914 |
| everything-dfs (the real `agda Everything.agda` order) | 294 (302: `NM.StructuredSymmetryTransport`) | 54 (211: `NM.IteratedCylindricalConsistency`) | 49633 | 11063 |
| by-depth (stratified) | 359 (383) | 82 (225: `NM.WalkStream`) | 70216 | 18596 |
| greedy-min-raw | 358 (381) | 49 (182) | 68163 | 10782 |
| **greedy-min-det** (myopic §46 policy) | 358 (381) | **29** (243: `NM.CompileBridge`) | 69088 | **5357** |

**Emitted order** (`machine/self_architecture.tsv`, 387 rows, one per cut):
`greedy-min-det`, the one-step meta-Bellman policy on deterministic semantic
width. It is **optimal among these candidates** — global optimality over all
topological orders is *not claimed* (minimum-width linear arrangement is
NP-hard in general; an exact branch-and-bound for this 387-vertex instance is
queued below, not asserted).

Reading of the table, in Delta 28 §22's own terms: the raw peaks (294–359)
are architecture artifacts — they measure how many interfaces a table-passing
builder would hold. The semantic peak of the best candidate is **29**: at no
cut of that order do more than 29 future-distinct dependency modes cross.
The myopic semantic policy nearly halves the peak of the best raw-driven
order (29 vs 49) and halves its total semantic traffic (5357 vs 10782),
while leaving the raw peak essentially unchanged — semantic and raw width
are optimized by *different* orders, which is §22's inequality made concrete.

## 4. Where semantic width beats raw width — the collapse points, named

Collapse (`det < raw`) is not exceptional on this graph; it is the generic
state: **382 of 387 cuts** of the emitted order collapse (383/387
alphabetical, 379/387 everything-dfs, 384/387 by-depth, 381/387 greedy-min-
raw). 61 of the emitted order's cuts have det ≤ 4, and 36 have det = 1. The
mechanisms are the ones Delta 28 §23 predicts, and each has a name here:

**(a) Aggregate dependence I — the `Everything` latch.**
At the emitted order's peak-raw cut (381): raw 358, det **3**. One class of
**294** separator modules (`Gamma0Partner`, `LawvereDiagonal`,
`M2Unimodular`, `NaturalMachine.AbstractSpinNetworkKinematics`, …) shares the
identical future row `{Everything, NaturalMachine,
NaturalMachine.TransportCost, NaturalMachineRun}`; one class of **61**
top-level modules (`AchromaticToy`, `BehavioralApartness`, `CachePathOrder`,
`DSOCutCalibration`, …) shares the row `{Everything}`; three modules
(`Gamma0Freeness`, `KuttakaValli`, `Rank1DihedralChart`) share
`{Everything, NaturalMachineRun}`. 358 raw interfaces, three semantic modes.
In the real aggregate build (everything-dfs), the cut just before
`Everything` is checked has raw 91, det **13**: 74 modules are one mode
(future = `{Everything}` exactly), and the remaining twelve modes are the
twelve other unfinished sinks' fibres. §23 name: *aggregate dependence* —
a latch whose whole downstream question is "does the aggregate still need
you", which is one bit, not 74.

**(b) Aggregate dependence II — the `NaturalMachine` root as a hidden
second latch.** The 294-class above exists because `NaturalMachine.agda`
plain-imports its subtree, and `TransportCost`/`NaturalMachineRun` import the
root. While those two-plus-two aggregators are unchecked, the *entire
checked interior of the subtree is one dependency mode*. This is the
machine's own §44 statement: the journals/BOARD junction tree only needs the
modes a future continuation can distinguish, and below the root there is —
exactly — one.

**(c) Conditional independence — the counterexample fibrations.** Groups
whose futures factor through a single named consumer in the control lane:
`{NM.ChargeCriterion, NM.GaugeOrbitClasses, NM.OracleQueries,
NM.ParitySeparator}` → row `{Everything, NM.OracleSeparation}`;
`{NM.AtomicSatisfaction, NM.ComparisonNeedNotBeInjective}` →
`{Everything, NM.Control.InjectivityNecessary}`;
`{NM.CompileBridge, NM.GenerativeLoop}` →
`{Everything, NM.Control.WrongFirstStep}`;
`{NM.ConstantBoundNotFunctionBound}` →
`{Everything, NM.Control.FunctionBoundFromConstant}`. Four interfaces, one
mode each: the counterexample module is a sufficient statistic for its whole
input group.

**(d) Tower symmetry — families with a shared future cone.** At
everything-dfs's peak-det cut (211): `{NM.FiniteNonabelianHolonomy,
NM.OrientedSurfaceFlux, NM.S3ConjugacyObservation,
NM.SurfaceFluxCylindricalSquare}` share one 10-dependent row (the S3/flux
tower); `{NM.CoprimeSplitting, NM.WalkCapacity, NM.WalkForcing,
NM.WalkJumps}` share one 12-dependent row (the Walk/sieve tower); at cut 182
of the raw-driven orders, `{NM.DSONucleusExecutionCalibration,
NM.DSONucleusMiddleProduct, NM.DSONucleusOneSidedProduct}` share one row
through `NM.SemanticCrystal` (the DSO nucleus tower itself collapses). §23
names: *symmetry / sufficient statistics*.

**(e) The terminal cut** — see the lemma below; visible in the emitted
order's endgame as cuts 382–386: raw 73, 74, 75, 76, 1 against det 3, 2, 1,
2, 1.

## 5. The terminal-cut lemma (the proof the endgame numbers replace)

**Lemma.** Let `G` be a finite DAG of modules and `o` any topological
checking order. Let `m` be the last module of `o`. Then (i) `m` has no
dependents in `G`; (ii) at the cut before `m`, the separator is exactly the
set of direct imports of `m`, so the raw width is `|imports(m)|`; (iii) the
deterministic semantic width of that cut is exactly `min(1, |imports(m)|)`.

*Proof.* (i) A dependent of `m` would have to be checked after `m`. (ii) The
unchecked set is `{m}`; a checked `s` is in the separator iff it has a direct
unchecked importer, i.e. iff `m` imports `s`. (iii) For every separator `s`,
the row of the cut matrix is `{u ∈ {m} : u →* s} = {m}`, since a direct
import is a fortiori a transitive one. All rows are equal, so there is one
row class (zero if the separator is empty). ∎

Consequence for this corpus: the aggregate build must end at a sink, and
whichever sink it is — `Everything` with its 76 direct imports, or the
1-import sinks — the final interface carries **one** semantic mode. No
order can avoid paying `|imports(m)|` raw at that cut; every order gets it
for one mode of actual content. That is the sharpest possible local instance
of "raw separators are architecture artifacts" (Delta 28 §19).

## 6. What is claimed, and what is not

Claimed (exact): the graph facts of §1; every width in the table of §3 for
its stated order; the class structures of §4 at the stated cuts; the lemma
of §5; `det ≤ raw` at every one of the 5 × 387 evaluated cuts (checked, zero
violations).

Not claimed: global optimality of the emitted order (best-of-candidates
only); any value of the latent width `r` beyond `r ≤ det`; anything about
the untracked in-flight modules that entered and left the shared checkout
during the run (two of them, `CyclotomicMined` and `FactoryVICore`, were
committed mid-session and are included; the snapshot is the tracked set at
`fb404ce4`); any timing/cost model — this note counts interface modes, not
seconds.

## 7. Queue

- `PROVE` — exact minimum peak deterministic semantic width of this DAG:
  branch-and-bound over topological orders with the §5 lemma and the
  aggregate-cut structure as pruning; 29 is an upper bound, and a matching
  lower bound would certify the emitted order globally. (The sibling
  `DSOSchedule.hs` already did exactly this on its 5-conjecture instance;
  the question is whether the aggregator structure keeps it feasible at 387.)
- `PROVE` — closed form for the det width of any cut of an
  "aggregator-latch" graph (a DAG plus a vertex plain-importing a downward-
  closed set): §4(a)–(b) suggest det at such cuts is `#unfinished sinks
  whose cones differ` + small; the observed 3, 13 should be corollaries.
- `SEARCH` — prior art before "continuation cut width" is used as a named
  parameter of build graphs: vertex separation number / pathwidth vs
  Boolean-width and trellis complexity on *reachability* (not adjacency)
  cut matrices; Delta 28 §22 already flags this comparison as REQUIRED.
- `DEMONSTRATE` — a semantic junction-tree build driver: check in the
  emitted order but pass only row-class representatives (≤ 29 modes at any
  cut) instead of raw interface tables; Thm 28.9/28.10 say this is exact and
  that merging any two distinct rows is not.
