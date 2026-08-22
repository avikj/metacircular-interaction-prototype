# Cubical Agda coverage inventory

**Regenerated 2026-08-16** (D0026 build queue Q8, the latch; build worker,
no local Agda — see the honesty section). This supersedes the 2026-08-14
report, which is retained below with its stale numbers struck, per house
norms. It remains what its predecessor was: a coverage report, not a claim
that an unimported module is false or unusable — and, this revision adds,
not a claim that an imported module is green (that is an exit code or it is
a rumour).

## The counts, recomputed 2026-08-16

Method: mechanical, shell-only (`find`/`grep`/`sed`/`awk`, no Python).
Every `import`/`open import` line was extracted after stripping BOTH
comment forms (`--` to end of line and `{- -}` blocks, nesting handled), so
commented-out imports do not count — verified by diffing against the naive
extraction: identical edge sets, i.e. no import in this tree hides in a
comment. Reachability is breadth-first from `Everything.agda` over edges
into local modules only.

* **385** local `.agda` modules under `formal/cubical/` (384 excluding
  `Everything.agda` itself).
* **Aggregate root: `Everything.agda`.** The five-root scheme of the
  2026-08-14 report is superseded; `formal/cubical/check.sh` now runs
  `NaturalMachine.agda` and `Everything.agda` under the BUILD.md pin
  (Agda 2.8.0 + cubical v0.9, LC_ALL=C.UTF-8) and is the gate.
* **Before this pass:** 372 of 385 modules reachable from
  `Everything.agda`; 13 unreachable, of which
  * **10** are `NaturalMachine/Control/` — deliberately wrong statements
    that MUST fail to typecheck; their unreachability is re-verified
    correct this pass (no non-Control module imports any of them; the
    only edges touching `Control/` point *out* of it, into modules it
    deliberately contrasts with), and
  * **3** were genuine orphans, all landed 2026-08-16 in commit
    `cf2c6f76` ("WIP salvage … UNVERIFIED, no green claim"):
    `HeadDepthMergeBreaker`, `NaturalMachine.OracleSeparation`,
    `R0021FlipOrbit`.
* **After this pass:** all 3 are imported at the bottom of
  `Everything.agda` (section "ORPHAN SWEEP, 2026-08-16"), so the intended
  state is 375 of 385 reachable and the unreachable set is exactly
  `NaturalMachine/Control/` — **0 non-Control orphans**.

## Why Q8 said ~37 and this report says 3

The queue item's figure described the tree before the 2026-08-15 fold-in
passes recorded inside `Everything.agda` itself ("ORPHAN FOLD-IN,
2026-08-15") and at the bottom of `NaturalMachine.agda`. Every module Q8
names — `CarryClassNonzero`, `Gamma0`, `QuadraticRefinement`,
`TransportCost`, `FutureSeparation`, `OracleQueries`,
`RootedGrothendieck`, `CostGeometryWitness`, `BehavioralApartness`,
`CenterRelative`, `PrimePairField`, all sixteen `Swarm/` modules — was
verified reachable by this pass's scan (each has a live, uncommented
import edge from `NaturalMachine` or `Everything`). The orphan set had
been latched and then drifted by exactly one commit: the three modules
above are the drift, observed and closed within a day of landing. This is
the failure mode `Everything.agda`'s own header predicts ("a module nobody
names is invisible to a latch made of names"); the durable repair remains
a check that regenerates the list from the filesystem and fails on the
diff, not a longer hand-written list.

## Honesty: what this pass did NOT do

This container has **no Agda binary**. Nothing here was typechecked.
Specifically:

* The three newly latched modules carry NO individual `EXIT=0` record —
  their salvage commit says UNVERIFIED and this pass could not upgrade
  that. The new `Everything.agda` section is marked **AWAITING KERNEL —
  authored without local toolchain**. If any of the three is red under
  the pin, `Everything.agda` goes red on the next toolchain-bearing run
  of `check.sh`; that adjudication is the point of the latch.
* All "reachable" claims are source-level import-closure facts, exact and
  reproducible, but they certify naming, not greenness.

## Cannot be latched without owner decision

None. The one duplicate-basename pair found — `CenterRelative.agda` at top
level and `NaturalMachine/CenterRelative.agda` — is not a collision: the
qualified module names (`CenterRelative`, `NaturalMachine.CenterRelative`)
are distinct, each file declares the module matching its own path, both
are already imported, and Agda resolves each qualified name against its
own file. No orphan in this sweep presented a genuine joint-build hazard.

## Rigor boundary

This revision certifies only: the file count, the comment-stripped import
edge set, the reachability accounting before and after the sweep, and the
non-importation of `Control/`. It certifies no theorem, no toolchain
compatibility, and no historical `CHECKED` annotation.

---

## SUPERSEDED — the 2026-08-14 report (retained, stale numbers struck)

This is a source-level inventory made 2026-08-14. It is deliberately a
coverage report, not a claim that an unimported module is false or unusable.
~~The repository contains 229 local `.agda` modules under `formal/cubical/`.~~
*(2026-08-16: 385.)*

### Aggregate build

~~`formal/check.sh` names five aggregate roots:~~

* ~~`NaturalMachine`~~
* ~~`ProjectionChargeAudit`~~
* ~~`ProjectionChargeAudit2`~~
* ~~`NaturalMachine/CapabilityGraph`~~
* ~~`NaturalMachine/LawfulContinuationCore`~~

*(2026-08-16: the aggregate root is `Everything.agda`;
`formal/cubical/check.sh` runs `NaturalMachine.agda` and `Everything.agda`
under the pin.)*

~~A shell-only transitive scan of local `open import`/`import` edges reaches
151 of the 229 local modules (66.0%). The remaining 78 modules are not in
that aggregate import closure.~~ *(2026-08-16: 372 of 385 before this
pass's sweep, 375 of 385 intended after it; the 10 unreached modules are
`Control/`, by design.)* The scan does not count modules from the
installed Cubical library, and does not treat comments as imports.

### Standalone-checkable

~~The five roots above are the only modules guaranteed by the repository's
aggregate command.~~ Individual modules may also be checked directly with:

```sh
agda -i formal/cubical formal/cubical/<Module>.agda
```

Source annotations are evidence of historical standalone checks, not a
current run record. In particular, modules containing `CHECKED` annotations
should be treated as candidates for a direct check; they are not silently
promoted into the aggregate build. `formal/check.sh` was running during this
inventory and emitted warnings but no failure before this report was written;
its final exit should be recorded separately if a CI-grade result is needed.

### Intentionally excluded

Exclusion is explicit where a module says `NOT imported`, `not part of the
checked build`, or identifies itself as a negative/control example. Examples
include:

* `NaturalMachine/Control/WrongEquivalence.agda`
* `NaturalMachine/Control/WrongFirstStep.agda`
* ~~`TransporterPortReduction.agda`~~
* ~~`SubsetSumChartDepth.agda`~~
* ~~`TotientFibreSymmetry.agda`~~

*(2026-08-16: only `NaturalMachine/Control/` remains excluded; the three
struck modules are imported by `Everything.agda`.)*

These are not "missing" coverage: their exclusion is part of the mathematical
boundary (counterexamples, controls, or separate experiments).

### Untested / uncovered

~~The other 78 local modules are currently outside the five-root closure and
do not have enough machine-readable evidence here to call them
aggregate-tested.~~ *(2026-08-16: 0 non-Control modules outside the
`Everything.agda` closure after the sweep.)* They should be labelled
**untested by the aggregate build**, even when their comments report a
historical check. A future revision should add a manifest with one of
`aggregate`, `standalone`, `excluded-control`, or `untested`, and replace
this count with a checked manifest rather than inferring status from prose.
*(2026-08-16: still a good idea; not done in this pass either.)*

Rigor boundary: this report certifies only the root list, file count, and
import-closure accounting. It does not certify theorem correctness, library
compatibility outside the invoked command, or the truth of historical
`CHECKED` annotations.
