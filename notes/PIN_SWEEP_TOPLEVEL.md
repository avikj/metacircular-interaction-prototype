# The top-level sweep under the pin: 55 modules, error rate 0

2026-08-15, Claude (Hamming lane, pin sweep A — `formal/cubical/*.agda`,
top level only; `NaturalMachine/` is a sibling agent's scope).

This discharges the outstanding item in
`notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §6.5.3: *"Only the twelve modules in
6.2 were run against the pin. The rest of the corpus is unswept under
2.8.0/v0.9, and given the `·Rid` finding, the prior expectation should now be
that other untouched modules are red under the pin too."*

**That expectation is falsified.** Every top-level module checks under the
pin. The number is the deliverable, so here it is first:

| | count |
|---|---|
| top-level `.agda` modules at `formal/cubical/` | **55** |
| red under the pin (Agda 2.8.0 + cubical v0.9), current tree | **0** |
| red for toolchain skew | 0 |
| red for substance | 0 |
| intentional-failure controls at top level | 0 (they all live in `NaturalMachine/Control/`) |
| source files I edited | **0** |

Against the tree as it stood when I started (commit `3b72a475`, the state §6
describes), **2 of 53 were red — 3.8% — and both were one root cause**, the
`·Rid` → `·IdR` rename §6.4 found. Both had been repaired by another agent's
commit before my sweep reached them; I verified the repair by running it, not
by reading the message that announced it.

## 1. Toolchain — the pin, verified in this container

The §6.1 pin survived in the session scratchpad and I re-verified each half
rather than assuming it:

- `agda --version` → `Agda version 2.8.0`, the binary built by §6.1 from the
  Hackage tarball against GHC 9.4.7, at
  `…/scratchpad/Agda-2.8.0/dist-newstyle/…/agda`. `/usr/bin/agda` is still
  2.6.3 and I did not touch it.
- cubical **v0.9** at `/root/agda-libs/cubical-v0.9`, selected per-run with
  `--library-file`. Its `cubical.agda-lib` reads `name: cubical` — §6.1's
  stated deviation from upstream's `cubical-0.9`, still in place, still
  needed by `natural-machine.agda-lib`'s `depend: cubical`. The v0.5 clone at
  `/root/agda-libs/cubical` was not touched.
- `LC_ALL=C.UTF-8` was exported for **every** run. §0's warning is not
  cosmetic and I did not test what happens without it.
- Runs were made in `tar`-copies of `formal/cubical` under the scratchpad, so
  no v0.9 interface file entered the repository's `_build`.

Command, for every row below:

```sh
LC_ALL=C.UTF-8 <pinned-agda> --library-file=<v0.9 libraries file> <file>; echo $?
```

## 2. The table

Two sweeps. **Sweep A** ran all 53 modules present at start, on a copy taken
at commit `3b72a475`. **Sweep B** ran the same list on a copy taken ~20
minutes later, after another agent's `·Rid`/`Sub` repairs landed. **Sweep C**
re-ran the five files that changed again while B was running, plus the two
modules that were added (`GodelSeparation`, `InvarianceConstant`), against
`587113ed`. Where B or C ran a module, its number supersedes A's.

| module | A (`3b72a475`) | B/C (current) |
|---|---|---|
| `AchromaticToy` | 0 | — |
| `BehavioralApartness` | 0 | — |
| `CachePathOrder` | 0 | — |
| `CayleyPairChart` | 0 | — |
| `CenterRelative` | 0 | — |
| `DSOCutCalibration` | 0 | — |
| `DescentLaw` | 0 | — |
| `DynamicDescent` | 0 | — |
| `ElsewhereCondition` | 0 | — |
| `Everything` (aggregate) | **42** | **0** |
| `ExclusionScope` | 0 | 0 |
| `ExtremalDescription` | 0 | 0 |
| `Gamma0Converse` | 0 | 0 |
| `Gamma0ConverseSharp` | 0 | 0 |
| `Gamma0Freeness` | 0 | 0 |
| `Gamma0Index` | 0 | 0 |
| `Gamma0Partner` | 0 | 0 |
| `Gamma0PartnerRigidity` | 0 | 0 |
| `Gamma0Transitivity` | 0 | 0 |
| `GodelSeparation` (new) | — | 0 |
| `HeadDepthMerge` | 0 | 0 |
| `HeadDepthTwo` | 0 | 0 |
| `IndraNet` | 0 | 0 |
| `IntegerHullMultiplicity` | 0 | 0 |
| `InvarianceConstant` (new) | — | 0 |
| `KuttakaValli` | 0 | 0 |
| `LawvereDiagonal` | 0 | 0 |
| `LiftingFiberResidue` | 0 | 0 |
| `M2Unimodular` | 0 | 0 |
| `NaturalMachine` (root aggregate) | 0 | 0 |
| `NaturalMachineRun` | 0 | 0 |
| `ObligatioOrderTrilemma` | 0 | 0 |
| `OrbitSeparation` | 0 | 0 |
| `PMNoSection` | 0 | 0 |
| `ParityNormEliminant` | 0 | 0 |
| `PolarityClosure` | 0 | 0 |
| `PrimePairField` | 0 | 0 |
| `ProjectionChargeAudit` | 0 | 0 |
| `ProjectionChargeAudit2` | 0 | 0 |
| `Rank1DihedralChart` | 0 | 0 |
| `ResponseCharacterKickback` | 0 | 0 |
| `SetTruncationDescentBoundary` | 0 | 0 |
| `SimplicialDefectFailure` | 0 | 0 |
| `Sl2DivisorLattice` | 0 | 0 |
| `Sl2TensorProduct` | **42** | **0** |
| `SmithTorsorBridge` | 0 | 0 |
| `StagewiseComposite` | 0 | 0 |
| `StagewiseCompositeB` | 0 | 0 |
| `SubsetSumChartDepth` | 0 | 0 |
| `ThresholdGenerationDichotomy` | 0 | 0 |
| `ThresholdGenerationN5Boundary` | 0 | 0 |
| `TotientFibreSymmetry` | 0 | 0 |
| `TransporterMembership` | 0 | 0 |
| `TransporterPortReduction` | 0 | 0 |
| `Window5Walsh` | 0 | 0 |

`Everything.agda` under the pin: **0 errors, 194 `UnsupportedIndexedMatch`
warnings** — the documented F39 boundary, same phenomenon §6.2 recorded for
the root (186 there; the count grew because the corpus did).

## 3. Classification of the two reds, and who fixed them

Both are **category (a), a v0.5-vs-v0.9 rename**, and both were already
repaired when I got there. Category (b) — genuine mathematical or scope
error — is **empty at the top level**. Category (c) — intentional failure —
is empty at the top level by construction: the controls live in
`NaturalMachine/Control/`, outside my scope.

1. **`Sl2TensorProduct.agda:115`**, `·Rid` → `·IdR`. The name is
   `Cubical.Data.Int.Properties.·Rid` in v0.5, `·IdR` in v0.9. Sweep A
   reproduced §6.4's error verbatim (`[NotInScope] Not in scope: ·Rid`).
   The repair is in commit `0c1950fb`, by another agent, not by me — I read
   the diff before running it. Sweep B on the repaired file: exit 0.
2. **`Everything.agda`** was red *only* through (1): it aborts at
   `Sl2TensorProduct` and so checked nothing after it. With (1) fixed it is
   green. This is exactly the caveat §6.4 attached to it, now discharged.
3. **`PolarityClosure.agda`** deserves its own line because §6.3 recorded it
   as a genuine, non-toolchain defect (`[ClashingDefinition] Multiple
   definitions of Sub`, clashing with Agda's builtin
   `Agda.Builtin.Cubical.Sub`). It is **fixed** — another agent renamed the
   local `Sub` to `Pow` throughout, and I confirm exit 0 under the pin in
   both sweeps. §6.3's "still exits 42" is superseded. That was a category
   (b)-looking defect with a category (a)-shaped repair, and the credit is
   not mine.

**I changed no source file.** The owner's decision that sources track the pin
was already carried out for both names by the time my runs reached them; the
correct act was to verify, not to re-edit. Every rename reported here is
reported as someone else's, with the commit that carries it.

## 4. Aggregate coverage, since a green aggregate is only worth its imports

`Everything.agda` imports 52 of the 54 non-self top-level modules. Three are
**not** imported and are therefore not covered by its exit 0 — they are
covered here only because I ran them standalone:

- `CenterRelative`, `PrimePairField`, `SimplicialDefectFailure`.

(`PolarityClosure` was on this orphan list in the earlier note; it is now
imported. `GodelSeparation` and `InvarianceConstant`, both new, are imported.)
Folding the remaining three in would make "`Everything.agda` exits 0" and
"the top level checks" the same claim. They are not folded in here because
that is an import-list decision belonging to their owners and to the
`[CORRECTED, SEED-81]` block in `Everything.agda`, not to a sweep.

## 5. Scope limits

1. **Top level only.** `formal/cubical/NaturalMachine/*.agda` was not swept
   per-module by me — a sibling agent has it. It is covered here only
   transitively, through `NaturalMachine.agda` exiting 0.
2. **The tree moved under the sweep, three times.** Two modules were added
   and five changed while I was running. I chased each delta (sweep C) and
   the table's right-hand column is the state at commit `587113ed` plus a
   `notes/` working change. A module landed after that is unswept, and the
   next sweep should be a `cmp` against `…/scratchpad/sweepB`, not a rerun.
3. **Exit 0 is typechecking, not truth.** Unchanged from §5.5: it says the
   terms check, not that a module states what its comments claim. I verified
   no mathematical content.
4. **The pin is still not installed.** `/usr/bin/agda` is 2.6.3. What
   survives this pass is the table and §6.1's recipe, not an environment.
5. **Wall-clock honesty.** This container suspends between tool calls, so a
   backgrounded sweep makes almost no progress; the sweep only ran while a
   foreground call was blocking. Anyone reproducing this should expect the
   run to take as long as they are willing to sit in the foreground, not the
   ~3 CPU-hours it actually cost. Four other Agda processes from sibling
   agents shared the four cores throughout.
6. **Concurrency caveat, stated because it could have produced a false
   green.** A sibling agent ran Agda inside my `sweepB` copy at the same
   time. Concurrent writes to a shared `_build` can in principle corrupt an
   interface file, and a corrupt interface produces a *red*, not a green, so
   the direction of the risk is safe: it can manufacture a spurious failure,
   not a spurious success. No such failure occurred — every module in B was
   0 on the first run.
