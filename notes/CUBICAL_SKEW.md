# The Agda lane against Agda 2.6.3 + cubical v0.7 (this container)

**Read `notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` first.** That note is the
primary record on this subject; it measures the lane under Agda 2.6.3 +
cubical **v0.5** and under the pin (Agda 2.8.0 + cubical **v0.9**). This file
adds one thing and nothing else: **the v0.7 data point**, module by module,
for the whole lane. Nothing here contradicts it; where the two overlap
(`PathIsSymmetry`, the mandatory `LC_ALL=C.UTF-8`, the fact that an aggregate's
exit code is not evidence about modules imported after its abort point) this
file confirms it.

Nothing was fixed, edited, or worked around. Every `.agda` file is as it was.

## 0. Three toolchain states

| | Agda | cubical | where |
|---|---|---|---|
| the **pin** (`formal/cubical/BUILD.md`) | 2.8.0 | v0.9 | — |
| the other lineage's container | 2.6.3 | v0.5 | `/root/agda-libs/cubical` |
| **this container** | **2.6.3** | **v0.7** | `/tmp/cubical`, via `~/.agda/libraries` |

Installed version confirmed by reading, not assumed:

- `/tmp/cubical/cubical.agda-lib` → `name: cubical-0.7`
- `cd /tmp/cubical && git log -1 --oneline` → `d69d74c Release for agda 2.6.4.1 (#1083)`
- `agda --version` → `Agda version 2.6.3`

The second line is the whole story of category **L** below: **cubical v0.7 is
released against Agda 2.6.4.1, and the Agda here is 2.6.3.** The library does
not compile with the compiler it is paired with. This container is therefore
not merely "not the pin"; its two halves do not match each other.

Method: `cd /home/user/math/formal/cubical && LC_ALL=C.UTF-8 timeout 600 agda
+RTS -M2g -RTS <module>`, one module at a time, sequentially, exit code
recorded. `LC_ALL=C.UTF-8` was set on every invocation, so no failure below is
the `commitBuffer`/`λ` artefact documented in the other note.

## 1. Counts

| | modules |
|---|---|
| present in `formal/cubical/*.agda` + `formal/cubical/NaturalMachine/**` | **351** |
| **PASS** (exit 0) | **247** |
| FAIL | 102 |
| TIMEOUT (600 s wall clock, `-M2g`) | 2 |

Plus 2 rows in the table for `NaturalMachine/WFIScratch{1,2}.agda`, scratch
files written and deleted by a concurrently-running session during the sweep;
they are not lane modules and are excluded from the 351.

**The lane can currently verify 247 of 351 modules in this container**, plus 8
of the 9 `Control/` modules failing for their intended reason — 255 modules
behaving as designed, 72.6 %.

**No failure below is a mathematical error.** Every one is toolchain: 73 are
the library/compiler mismatch inside this container, 20 are v0.9 spellings
absent from v0.7, 8 are controls that are supposed to fail, 2 are wall-clock.

## 2. Classification

| tag | meaning | count |
|---|---|---|
| **L** | *wrong for this container, and not the repo's fault at all.* cubical v0.7 itself fails to typecheck under Agda 2.6.3. Two sites: `Cubical/Tactics/Reflection.agda:92` needs `withReduceDefs`, added to `Agda.Builtin.Reflection` in Agda 2.6.4 (2.6.3 has only `onlyReduceDefs` / `dontReduceDefs`); and `Cubical/Categories/NaturalTransformation/Properties.agda:183-194` leaves unsolved metas. Any module importing a solver/tactic macro or the category-theory instances dies here regardless of its content. | 73 |
| **S** | *wrong for this container, right for the pin.* The source uses a v0.9 name that v0.7 does not export. Three root sites, all propagated by import. | 20 |
| **A** | *wrong for this container, right for the pin.* Agda 2.6.3's `--cubical` refuses a clause 2.8.0 accepts (constructor injectivity), leaving an unsolved meta downstream. | 1 |
| **C** | *failing is the pass condition.* `NaturalMachine/Control/` holds deliberately false statements that MUST fail; each of these 8 fails at its own line, for its own stated reason. | 8 |
| **R-time** | wall-clock exhaustion at 600 s, `-M2g`. No heap-overflow message in either log, so it is time, not memory. Both are audit modules in the same DSO-nucleus family. | 2 |
| **X** | not a lane module (another session's scratch file, deleted mid-sweep). | 2 |

Nothing was classified **(c) a real error in the module**. That category is
empty.

### 2.1 The three S root sites

| site | name used | v0.7 exports instead | modules taken down |
|---|---|---|---|
| `NaturalMachine/PathIsSymmetry.agda:98,50-58` | `SymGroup` | `Sym`, `Symmetric-Group` (`Cubical/Algebra/SymmetricGroup.agda:19,25`) | 14 |
| `NaturalMachine/FiniteNonabelianHolonomy.agda:56,6-17` | `FinSymGroup` | — (absent) | 5 |
| `NaturalMachine/StabilizerSubgroup.agda:97,11-19` | `SymGroup` | as above | 1 |

`SymGroup` is the v0.9 spelling that `BUILD.md` §"Version-skew notes"
already records (`Symmetric-Group` → `SymGroup`). v0.5 had
`Symmetric-Group`; v0.7 has `Symmetric-Group` **and** the abbreviation `Sym`;
v0.9 has `SymGroup`. So v0.7 sits between the two states and satisfies
neither source spelling. These files are correct under the pin and must not
be edited to suit this container — the same reasoning the v0.5 lineage gave,
and it is correct.

### 2.2 The one A row

`NaturalMachine/PolynomialAttachmentGrowth.agda` — Agda 2.6.3 reports
`isFiller` (line 40) "relies on injectivity of the data constructor `zero`,
which is not yet supported", and the consequence is a hard
`Unsolved metas at … PolynomialAttachmentGrowth.agda:56,62-75`, at
`cong isFiller equality`. Elsewhere the same limitation is only the
`UnsupportedIndexedMatch` warning (the documented F39 boundary) — e.g.
`PayloadMorphism.agda:244`, `PMTorus.agda:241` — and does not stop the build.
Under the pin the root aggregate reaches this module and exits 0 (recorded in
`notes/TOOLCHAIN_SKEW_AND_COVERAGE.md`; second-hand here, not re-run).

### 2.3 The one Control module that is *not* a valid control here

`NaturalMachine/Control/WrongFirstStep.agda` fails, but at
`cubical:Cubical/Tactics/Reflection.agda:92` — the L failure, not its own
false statement. **It is not being tested in this container.** A control that
fails for the wrong reason is not a control. The other eight all fail at their
own line.

## 3. Modules written and checked against v0.7 only — exposure under the pin

These thirteen landed in the last hours and have been checked against
**Agda 2.6.3 + cubical v0.7 only**. All thirteen PASS here. None has been run
against the pin, and none against v0.5. That is a known, unverified exposure.

`CostGeometry`, `CostGeometryWitness`, `Residual`, `KFlow`, `EndObstruction`,
`QuestionMachine`, `ChuAdvance`, `AdvanceGate`, `TransportDiv`,
`TransportDivWitness`, `ResidualPath`, `KFlowWF`, `Lawvere` — all in
`NaturalMachine/`.

**`ResidualPath.agda` is the one to watch.** Its own comment (line 67) records
that cubical v0.7's `Cubical.Data.List` has no `Any` and no `_∈_`, so it
defines both itself at lines 72-77. If v0.9 supplies them, the definitions
clash or shadow. Two facts bound the risk, both read out of the file, neither
of them a fix:

- the import is `open import Cubical.Data.List using (List ; [] ; _∷_)`
  (line 53) — an explicit `using` list, so a v0.9 `Any`/`_∈_` in that module
  would not be brought into scope by this import;
- the remaining wholesale opens are `Cubical.Foundations.Prelude` and
  `Cubical.Data.Sigma`, neither of which is where `Any`/`_∈_` would live.

So the clash is unlikely to bite through this import path, but it has not been
run against v0.9 and that is the only thing that would settle it. Flagged, not
changed. `Residual`, `ChuAdvance`, `AdvanceGate`, `TransportDiv` and
`TransportDivWitness` import `Cubical.Data.List` with the same explicit
`using` discipline.

## 4. Caveat on the sweep itself

Another session was running `agda` in the same directory throughout (observed:
`WalkFastInstance` at `-M3g`, `TransportDivScale` at `-M3g`, the `WFIScratch`
files appearing and vanishing), and 37 modules landed in the tree while the
sweep was in progress — those 37 were swept in a second pass after the first
finished. Shared `_build` under concurrent writers is a possible source of
noise in individual rows; the four failure families are each reproduced across
many modules and do not depend on any single row.

## 5. Table

Status is the exit code of the command in §0. The error column is the **last**
diagnostic location in the log — Agda aborts at the first hard error, so
everything printed before it is warnings (`UnsupportedIndexedMatch`, F39), and
the last block is the error. Paths are shown relative to `formal/cubical/`;
`cubical:` abbreviates `/tmp/cubical/`.

| module | status | last diagnostic | class |
|---|---|---|---|
| `AchromaticToy.agda` | PASS | — | - |
| `BehavioralApartness.agda` | PASS | — | - |
| `CachePathOrder.agda` | PASS | — | - |
| `CayleyPairChart.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `CenterRelative.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `DSOCutCalibration.agda` | PASS | — | - |
| `DescentLaw.agda` | PASS | — | - |
| `DynamicDescent.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `ElsewhereCondition.agda` | PASS | — | - |
| `Everything.agda` | FAIL | `NaturalMachine/PathIsSymmetry.agda:98,50-58 Not in scope: SymGroup at /home/user/math/formal/cubical/NaturalMachine/Path…` | S |
| `ExclusionScope.agda` | PASS | — | - |
| `ExtremalDescription.agda` | PASS | — | - |
| `Gamma0Converse.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `Gamma0ConverseSharp.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `Gamma0Freeness.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `Gamma0Index.agda` | PASS | — | - |
| `Gamma0Partner.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `Gamma0PartnerRigidity.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `Gamma0Transitivity.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `GodelSeparation.agda` | PASS | — | - |
| `HeadDepthMerge.agda` | PASS | — | - |
| `HeadDepthTwo.agda` | PASS | — | - |
| `IndraNet.agda` | PASS | — | - |
| `IntegerHullMultiplicity.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `InvarianceConstant.agda` | PASS | — | - |
| `KuttakaValli.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `LawvereDiagonal.agda` | PASS | — | - |
| `LiftingFiberResidue.agda` | PASS | — | - |
| `M2Unimodular.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine.agda` | FAIL | `NaturalMachine/PathIsSymmetry.agda:98,50-58 Not in scope: SymGroup at /home/user/math/formal/cubical/NaturalMachine/Path…` | S |
| `NaturalMachine/AbstractSpinNetworkKinematics.agda` | PASS | — | - |
| `NaturalMachine/AcceptanceTest.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/ActionRefinement.agda` | PASS | — | - |
| `NaturalMachine/ActionResidual.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/ActionResidualPhase.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/AdaptiveResidualAdapter.agda` | PASS | — | - |
| `NaturalMachine/AdditionChainPredictiveMemory.agda` | PASS | — | - |
| `NaturalMachine/AdvanceGate.agda` | PASS | — | - |
| `NaturalMachine/AffineEmergenceCountedPath.agda` | PASS | — | - |
| `NaturalMachine/AffineProjectionQuantumBoundary.agda` | PASS | — | - |
| `NaturalMachine/ArithmeticPayloadCounterexample.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/ArityOfRepair.agda` | PASS | — | - |
| `NaturalMachine/AtlasResiduals.agda` | PASS | — | - |
| `NaturalMachine/AtomicSatisfaction.agda` | PASS | — | - |
| `NaturalMachine/BalanceWithoutTransitivity.agda` | PASS | — | - |
| `NaturalMachine/BatchDepthMemoryBoundary.agda` | PASS | — | - |
| `NaturalMachine/BehavioralHankel.agda` | PASS | — | - |
| `NaturalMachine/BraidCoherenceBoundary.agda` | PASS | — | - |
| `NaturalMachine/BuchstabDegree.agda` | PASS | — | - |
| `NaturalMachine/CapabilityGraph.agda` | FAIL | `NaturalMachine/PathIsSymmetry.agda:98,50-58 Not in scope: SymGroup at /home/user/math/formal/cubical/NaturalMachine/Path…` | S |
| `NaturalMachine/CarryBorrowObservation.agda` | PASS | — | - |
| `NaturalMachine/CarryChartBridge.agda` | PASS | — | - |
| `NaturalMachine/CarryClassNonzero.agda` | PASS | — | - |
| `NaturalMachine/CarryObstruction.agda` | PASS | — | - |
| `NaturalMachine/CenterRelative.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/CenterRelativeIntegral.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/CertificateFibration.agda` | PASS | — | - |
| `NaturalMachine/ChargeCriterion.agda` | PASS | — | - |
| `NaturalMachine/ChargeGradedPeeling.agda` | PASS | — | - |
| `NaturalMachine/ChargeGrading.agda` | PASS | — | - |
| `NaturalMachine/ChargeTwoHistories.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/ChenTwoChargeProjector.agda` | PASS | — | - |
| `NaturalMachine/ChuAdvance.agda` | PASS | — | - |
| `NaturalMachine/ChuDefect.agda` | PASS | — | - |
| `NaturalMachine/CoherentSurvivalDephasing.agda` | PASS | — | - |
| `NaturalMachine/ComparisonNeedNotBeInjective.agda` | PASS | — | - |
| `NaturalMachine/CompileBridge.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/CompositionalContextAdapter.agda` | PASS | — | - |
| `NaturalMachine/CompressionDefect.agda` | PASS | — | - |
| `NaturalMachine/CompressionDefectRegularWitness.agda` | PASS | — | - |
| `NaturalMachine/ConeImage.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/ConeOrder.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/ConservativePrimitiveExtension.agda` | PASS | — | - |
| `NaturalMachine/ConstantBoundNotFunctionBound.agda` | PASS | — | - |
| `NaturalMachine/ConstructiveBornNormalization.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/ContextCloneEquivalence.agda` | PASS | — | - |
| `NaturalMachine/Control/FunctionBoundFromConstant.agda` | FAIL | `NaturalMachine/Control/FunctionBoundFromConstant.agda:67,19-23 2 != 1 of type ℕ when checking that the expression refl…` | C |
| `NaturalMachine/Control/InflationFlattened.agda` | FAIL | `NaturalMachine/Control/InflationFlattened.agda:91,28-32 k0 != kι of type H2 when checking that the expression refl has …` | C |
| `NaturalMachine/Control/InjectivityNecessary.agda` | FAIL | `NaturalMachine/Control/InjectivityNecessary.agda:85,19-23 one != two of type Three when checking that the expression ref…` | C |
| `NaturalMachine/Control/MaximizerWithoutNonvanishing.agda` | FAIL | `NaturalMachine/Control/MaximizerWithoutNonvanishing.agda:84,23-34 NonVanishing W → Σ-syntax Pt (MaxAt W) !=< Σ Pt (M…` | C |
| `NaturalMachine/Control/QuantifierDrop.agda` | FAIL | `NaturalMachine/Control/QuantifierDrop.agda:80,26-41 NaturalMachine.LineWorldTransport.rollover (NaturalMachine.LineWorld…` | C |
| `NaturalMachine/Control/ReachabilityWithoutStart.agda` | FAIL | `NaturalMachine/Control/ReachabilityWithoutStart.agda:65,50-54 st != s0 of type S when checking that the expression refl …` | C |
| `NaturalMachine/Control/SatisfactionWithoutCodomainAgreement.agda` | FAIL | `NaturalMachine/Control/SatisfactionWithoutCodomainAgreement.agda:81,18-19 Y q !=< Y′ q when checking that the expressi…` | C |
| `NaturalMachine/Control/WrongEquivalence.agda` | FAIL | `NaturalMachine/Control/WrongEquivalence.agda:37,63-65 Unit !=< (Canonical w) when checking that the expression tt has ty…` | C |
| `NaturalMachine/Control/WrongFirstStep.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/ControlledGrammar.agda` | PASS | — | - |
| `NaturalMachine/Controls.agda` | PASS | — | - |
| `NaturalMachine/CoprimeSplitting.agda` | PASS | — | - |
| `NaturalMachine/CostGeometry.agda` | PASS | — | - |
| `NaturalMachine/CostGeometryWitness.agda` | PASS | — | - |
| `NaturalMachine/CountedComposition.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/CountedDigits.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/CountedExecution.agda` | PASS | — | - |
| `NaturalMachine/DSOArchitecture.agda` | PASS | — | - |
| `NaturalMachine/DSOBellmanFinite.agda` | PASS | — | - |
| `NaturalMachine/DSOContinuationFullAbstract.agda` | PASS | — | - |
| `NaturalMachine/DSOFactorRankFinite.agda` | PASS | — | - |
| `NaturalMachine/DSOFinite.agda` | PASS | — | - |
| `NaturalMachine/DSOMinPlusFinite.agda` | PASS | — | - |
| `NaturalMachine/DSONucleusExecutionCalibration.agda` | PASS | — | - |
| `NaturalMachine/DSONucleusFinite.agda` | PASS | — | - |
| `NaturalMachine/DSONucleusMiddleAssociativityAudit.agda` | TIMEOUT | `(no location) ` | R-time |
| `NaturalMachine/DSONucleusMiddleProduct.agda` | PASS | — | - |
| `NaturalMachine/DSONucleusOneSidedProduct.agda` | PASS | — | - |
| `NaturalMachine/DSONucleusResidualAudit.agda` | TIMEOUT | `(no location) ` | R-time |
| `NaturalMachine/DSOOption.agda` | PASS | — | - |
| `NaturalMachine/DatumSensitivePayload.agda` | PASS | — | - |
| `NaturalMachine/Decategorification.agda` | FAIL | `NaturalMachine/PathIsSymmetry.agda:98,50-58 Not in scope: SymGroup at /home/user/math/formal/cubical/NaturalMachine/Path…` | S |
| `NaturalMachine/DecategorifiedDefect.agda` | PASS | — | - |
| `NaturalMachine/DeclaredRootedProfiles.agda` | PASS | — | - |
| `NaturalMachine/DefectCalculus.agda` | PASS | — | - |
| `NaturalMachine/DefinitionalExtension.agda` | PASS | — | - |
| `NaturalMachine/DependentOptimizationFibration.agda` | PASS | — | - |
| `NaturalMachine/Descent.agda` | PASS | — | - |
| `NaturalMachine/DiagonalEndpoint.agda` | PASS | — | - |
| `NaturalMachine/DifferenceBasinCompiler.agda` | PASS | — | - |
| `NaturalMachine/DigitTowerFin.agda` | PASS | — | - |
| `NaturalMachine/DigitTowerFinLimit.agda` | PASS | — | - |
| `NaturalMachine/DigitTowerLimit.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/Digits.agda` | PASS | — | - |
| `NaturalMachine/DivisorHistoryDSO.agda` | PASS | — | - |
| `NaturalMachine/EffectiveDescent.agda` | PASS | — | - |
| `NaturalMachine/EndObstruction.agda` | PASS | — | - |
| `NaturalMachine/Endian.agda` | PASS | — | - |
| `NaturalMachine/EndianAtlasReplay.agda` | PASS | — | - |
| `NaturalMachine/EndogenousHorizon.agda` | PASS | — | - |
| `NaturalMachine/EvaluatorTransport.agda` | FAIL | `NaturalMachine/PathIsSymmetry.agda:98,50-58 Not in scope: SymGroup at /home/user/math/formal/cubical/NaturalMachine/Path…` | S |
| `NaturalMachine/ExactExperimentFullAbstraction.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/ExactHadamardInterference.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/ExactLocalJointSeparation.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/ExactProjectiveCircuits.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/ExactProjectivePhase.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/ExactTwoStateAmplitudes.agda` | PASS | — | - |
| `NaturalMachine/ExactTwoStateInstrument.agda` | PASS | — | - |
| `NaturalMachine/ExcursionReturn.agda` | PASS | — | - |
| `NaturalMachine/ExposureStabilizationAdapter.agda` | PASS | — | - |
| `NaturalMachine/FillabilityCertificate.agda` | PASS | — | - |
| `NaturalMachine/FinTopSplit.agda` | PASS | — | - |
| `NaturalMachine/FiniteEquivalenceBridge.agda` | PASS | — | - |
| `NaturalMachine/FiniteGraphCohomology.agda` | PASS | — | - |
| `NaturalMachine/FiniteGraphCylindricalEquivalence.agda` | PASS | — | - |
| `NaturalMachine/FiniteGraphFluxCylindrical.agda` | PASS | — | - |
| `NaturalMachine/FiniteGraphHolonomyGroupoid.agda` | PASS | — | - |
| `NaturalMachine/FiniteIndraWeave.agda` | PASS | — | - |
| `NaturalMachine/FiniteInformation.agda` | PASS | — | - |
| `NaturalMachine/FiniteNonabelianHolonomy.agda` | FAIL | `NaturalMachine/FiniteNonabelianHolonomy.agda:56,6-17 Not in scope: FinSymGroup at /home/user/math/formal/cubical/Natural…` | S |
| `NaturalMachine/FiniteOccupancyChannelNoGo.agda` | PASS | — | - |
| `NaturalMachine/FiniteWorldMaximizer.agda` | PASS | — | - |
| `NaturalMachine/FixedCarryChart.agda` | PASS | — | - |
| `NaturalMachine/FlipObservable.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/FluxCylindricalCoherence.agda` | PASS | — | - |
| `NaturalMachine/FormationDirectionIncidence.agda` | PASS | — | - |
| `NaturalMachine/FormationRelativeMinimality.agda` | PASS | — | - |
| `NaturalMachine/FreeMonoid.agda` | PASS | — | - |
| `NaturalMachine/FullSequentialTableNormalization.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/FutureBehavior.agda` | PASS | — | - |
| `NaturalMachine/FutureSeparation.agda` | PASS | — | - |
| `NaturalMachine/Gamma0.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/GaugeOrbitClasses.agda` | PASS | — | - |
| `NaturalMachine/GeneratedCapability.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/GeneratedGrammarDescentBoundary.agda` | PASS | — | - |
| `NaturalMachine/GenerativeKernel.agda` | PASS | — | - |
| `NaturalMachine/GenerativeLoop.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/GlobalSmithAtlasFlatness.agda` | PASS | — | - |
| `NaturalMachine/GroupCohomologyH2.agda` | PASS | — | - |
| `NaturalMachine/HadamardReadoutInstrument.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/HaskellDefinitionBoundary.agda` | PASS | — | - |
| `NaturalMachine/HaskellDiscoveryBoundary.agda` | PASS | — | - |
| `NaturalMachine/HolonomyDescent.agda` | PASS | — | - |
| `NaturalMachine/HolonomyFluxDerivation.agda` | PASS | — | - |
| `NaturalMachine/InflationVersusSubgroup.agda` | PASS | — | - |
| `NaturalMachine/IntrinsicProductiveInstall.agda` | PASS | — | - |
| `NaturalMachine/IntrinsicRewrite.agda` | PASS | — | - |
| `NaturalMachine/IteratedCylindricalConsistency.agda` | PASS | — | - |
| `NaturalMachine/KFlow.agda` | PASS | — | - |
| `NaturalMachine/KFlowWF.agda` | PASS | — | - |
| `NaturalMachine/KnowledgeProcess.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/LCMExists.agda` | PASS | — | - |
| `NaturalMachine/LawfulContinuationCore.agda` | PASS | — | - |
| `NaturalMachine/Lawvere.agda` | PASS | — | - |
| `NaturalMachine/LeakageCommutator.agda` | PASS | — | - |
| `NaturalMachine/LeastWitnessFactory.agda` | PASS | — | - |
| `NaturalMachine/LineWorldTransport.agda` | PASS | — | - |
| `NaturalMachine/LinearOrderFinite.agda` | PASS | — | - |
| `NaturalMachine/MeanStandardRep.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/MixedCornerTransferCompiler.agda` | PASS | — | - |
| `NaturalMachine/NormalizationInterfaceMinimality.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/NormalizedFiniteInstrument.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/NormalizedFrameCovariance.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/ObservabilityQuotient.agda` | PASS | — | - |
| `NaturalMachine/ObservableHorizon.agda` | PASS | — | - |
| `NaturalMachine/ObservableInterface.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/ObservationPresentation.agda` | PASS | — | - |
| `NaturalMachine/ObserverRevisionComposition.agda` | PASS | — | - |
| `NaturalMachine/Obstruction.agda` | PASS | — | - |
| `NaturalMachine/OperationalCoverageCounterexample.agda` | PASS | — | - |
| `NaturalMachine/OracleQueries.agda` | PASS | — | - |
| `NaturalMachine/OrderedSectorBreak.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/OrientedSurfaceFlux.agda` | PASS | — | - |
| `NaturalMachine/PMCokernel.agda` | PASS | — | - |
| `NaturalMachine/PMGaugeCohomology.agda` | PASS | — | - |
| `NaturalMachine/PMIncidenceLocalSystem.agda` | PASS | — | - |
| `NaturalMachine/PMMonodromyDerivationNoGo.agda` | PASS | — | - |
| `NaturalMachine/PMRelationalNoFit.agda` | PASS | — | - |
| `NaturalMachine/PMRelativeProcessBridge.agda` | PASS | — | - |
| `NaturalMachine/PMTorus.agda` | PASS | — | - |
| `NaturalMachine/PairCoordinates.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/PairReflectionSector.agda` | PASS | — | - |
| `NaturalMachine/PairedInterfaceMinimality.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/ParallelNetworkComposition.agda` | PASS | — | - |
| `NaturalMachine/ParetoCost.agda` | PASS | — | - |
| `NaturalMachine/ParitySeparator.agda` | PASS | — | - |
| `NaturalMachine/PathIsSymmetry.agda` | FAIL | `NaturalMachine/PathIsSymmetry.agda:98,50-58 Not in scope: SymGroup at /home/user/math/formal/cubical/NaturalMachine/Path…` | S |
| `NaturalMachine/PauliJointPhaseRealization.agda` | PASS | — | - |
| `NaturalMachine/PauliWeyl.agda` | PASS | — | - |
| `NaturalMachine/PayloadMorphism.agda` | PASS | — | - |
| `NaturalMachine/PerspectiveCore.agda` | PASS | — | - |
| `NaturalMachine/PerspectiveSymmetry.agda` | PASS | — | - |
| `NaturalMachine/PhasePredictorClosure.agda` | PASS | — | - |
| `NaturalMachine/PhysicalLearningCore.agda` | PASS | — | - |
| `NaturalMachine/PhysicalLearningQuotient.agda` | PASS | — | - |
| `NaturalMachine/PiPartialOnEveryPrime.agda` | PASS | — | - |
| `NaturalMachine/PinnedSensorForcing.agda` | PASS | — | - |
| `NaturalMachine/PolyHaythamResponseCostNoGo.agda` | PASS | — | - |
| `NaturalMachine/PolynomialAttachmentGrowth.agda` | FAIL | `NaturalMachine/PolynomialAttachmentGrowth.agda:40,1-42,36 This clause uses pattern-matching features that are not yet su… → hard error: Unsolved metas at …:56,62-75` | A |
| `NaturalMachine/PolynomialRewrite.agda` | PASS | — | - |
| `NaturalMachine/PredictorFormation.agda` | PASS | — | - |
| `NaturalMachine/PrimePairDecompositionCurvature.agda` | PASS | — | - |
| `NaturalMachine/PrimeSquareOptionalComposite.agda` | PASS | — | - |
| `NaturalMachine/PrimeSquarePinAdapter.agda` | PASS | — | - |
| `NaturalMachine/ProductiveFiberQuotientAdapter.agda` | PASS | — | - |
| `NaturalMachine/ProductiveIndraNet.agda` | PASS | — | - |
| `NaturalMachine/ProductiveObservabilityBridge.agda` | PASS | — | - |
| `NaturalMachine/ProductiveObservationFiber.agda` | PASS | — | - |
| `NaturalMachine/ProductiveTear.agda` | PASS | — | - |
| `NaturalMachine/ProgrammableActionFibers.agda` | PASS | — | - |
| `NaturalMachine/ProgressDefinition.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/ProofLabelNoGo.agda` | PASS | — | - |
| `NaturalMachine/ProstheticImageAdapter.agda` | PASS | — | - |
| `NaturalMachine/QuadraticRefinement.agda` | PASS | — | - |
| `NaturalMachine/QuestionMachine.agda` | PASS | — | - |
| `NaturalMachine/QuotientUnitSourceCutBoundary.agda` | PASS | — | - |
| `NaturalMachine/RadiusTransferCompiler.agda` | PASS | — | - |
| `NaturalMachine/RadixSymptoma.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/ReachableFromStart.agda` | PASS | — | - |
| `NaturalMachine/RealizedPayloadCapability.agda` | PASS | — | - |
| `NaturalMachine/ReflectionAttachment.agda` | PASS | — | - |
| `NaturalMachine/RelationalHolonomyInteraction.agda` | PASS | — | - |
| `NaturalMachine/RelationalHolonomyRefinement.agda` | PASS | — | - |
| `NaturalMachine/RelationalProcessCore.agda` | PASS | — | - |
| `NaturalMachine/RelationalTensorObstructionBridge.agda` | PASS | — | - |
| `NaturalMachine/RelativeFrameChange.agda` | PASS | — | - |
| `NaturalMachine/RelativeFrameObservable.agda` | FAIL | `NaturalMachine/PathIsSymmetry.agda:98,50-58 Not in scope: SymGroup at /home/user/math/formal/cubical/NaturalMachine/Path…` | S |
| `NaturalMachine/RelativeInstrument.agda` | PASS | — | - |
| `NaturalMachine/RepairTorsor.agda` | FAIL | `cubical:Cubical/Categories/Instances/Functors.agda:27,1-64 Unsolved metas at the following locations: cubical:Cubical/Ca…` | L |
| `NaturalMachine/Residual.agda` | PASS | — | - |
| `NaturalMachine/ResidualPath.agda` | PASS | — | - |
| `NaturalMachine/ResidueTransport.agda` | PASS | — | - |
| `NaturalMachine/RewriteCertificate.agda` | PASS | — | - |
| `NaturalMachine/RootWeightIndex.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/RootedGrothendieck.agda` | PASS | — | - |
| `NaturalMachine/RootedIndraTotal.agda` | PASS | — | - |
| `NaturalMachine/RoughSplit.agda` | PASS | — | - |
| `NaturalMachine/S3ConjugacyObservation.agda` | FAIL | `NaturalMachine/FiniteNonabelianHolonomy.agda:56,6-17 Not in scope: FinSymGroup at /home/user/math/formal/cubical/Natural…` | S |
| `NaturalMachine/S3EquivariantEndomorphismRigidity.agda` | FAIL | `NaturalMachine/FiniteNonabelianHolonomy.agda:56,6-17 Not in scope: FinSymGroup at /home/user/math/formal/cubical/Natural…` | S |
| `NaturalMachine/S3FiniteSpinNetwork.agda` | FAIL | `NaturalMachine/FiniteNonabelianHolonomy.agda:56,6-17 Not in scope: FinSymGroup at /home/user/math/formal/cubical/Natural…` | S |
| `NaturalMachine/S3FixedPointCharacter.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/S3IntegerPermutationModule.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/S3IntegerRelativeCoordinates.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/SelfImprovement.agda` | PASS | — | - |
| `NaturalMachine/SemanticCrystal.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/SensorNerode.agda` | PASS | — | - |
| `NaturalMachine/SequentialHadamardReadout.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/SequentialNormalizationObstruction.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/SetBaseNoMonodromy.agda` | PASS | — | - |
| `NaturalMachine/SieveFiber.agda` | PASS | — | - |
| `NaturalMachine/SieveScaleTower.agda` | PASS | — | - |
| `NaturalMachine/SingletonActionObservability.agda` | PASS | — | - |
| `NaturalMachine/SingletonWitnessStabilization.agda` | PASS | — | - |
| `NaturalMachine/SmithCapability.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/SmithKernelQuantumBoundary.agda` | PASS | — | - |
| `NaturalMachine/SmithPathCountedExecution.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/SpernerFromSl2.agda` | PASS | — | - |
| `NaturalMachine/StabilizerSubgroup.agda` | FAIL | `NaturalMachine/StabilizerSubgroup.agda:97,11-19 Not in scope: SymGroup at /home/user/math/formal/cubical/NaturalMachine/…` | S |
| `NaturalMachine/StabilizerTorsor.agda` | PASS | — | - |
| `NaturalMachine/StructuredDefect.agda` | PASS | — | - |
| `NaturalMachine/StructuredSymmetryTransport.agda` | PASS | — | - |
| `NaturalMachine/SurfaceFluxCylindricalSquare.agda` | PASS | — | - |
| `NaturalMachine/SymmetryArithmeticAction.agda` | FAIL | `NaturalMachine/PathIsSymmetry.agda:98,50-58 Not in scope: SymGroup at /home/user/math/formal/cubical/NaturalMachine/Path…` | S |
| `NaturalMachine/SymmetryCardinality.agda` | FAIL | `NaturalMachine/PathIsSymmetry.agda:98,50-58 Not in scope: SymGroup at /home/user/math/formal/cubical/NaturalMachine/Path…` | S |
| `NaturalMachine/SymmetryEnumeration.agda` | FAIL | `NaturalMachine/PathIsSymmetry.agda:98,50-58 Not in scope: SymGroup at /home/user/math/formal/cubical/NaturalMachine/Path…` | S |
| `NaturalMachine/TermFreeMonoid.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/TerminalTraceCompression.agda` | PASS | — | - |
| `NaturalMachine/TranscriptDescent.agda` | PASS | — | - |
| `NaturalMachine/TransmissionRefutations.agda` | PASS | — | - |
| `NaturalMachine/Transport.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/TransportCost.agda` | FAIL | `NaturalMachine/PathIsSymmetry.agda:98,50-58 Not in scope: SymGroup at /home/user/math/formal/cubical/NaturalMachine/Path…` | S |
| `NaturalMachine/TransportDiv.agda` | PASS | — | - |
| `NaturalMachine/TransportDivQuot.agda` | PASS | — | - |
| `NaturalMachine/TransportDivScale.agda` | PASS | — | - |
| `NaturalMachine/TransportDivWitness.agda` | PASS | — | - |
| `NaturalMachine/TransportInstance.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/TransportMul.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/TransportMulWitness.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/TwoLoopNonabelianNetwork.agda` | FAIL | `NaturalMachine/FiniteNonabelianHolonomy.agda:56,6-17 Not in scope: FinSymGroup at /home/user/math/formal/cubical/Natural…` | S |
| `NaturalMachine/TwoProjections.agda` | PASS | — | - |
| `NaturalMachine/TwoSidedExperimentInterface.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/TypedUnfold.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachine/UnivalentPhysicalProcess.agda` | FAIL | `NaturalMachine/PathIsSymmetry.agda:98,50-58 Not in scope: SymGroup at /home/user/math/formal/cubical/NaturalMachine/Path…` | S |
| `NaturalMachine/UnivalentTensorInteraction.agda` | PASS | — | - |
| `NaturalMachine/Vacuity.agda` | PASS | — | - |
| `NaturalMachine/VacuityVerdict.agda` | PASS | — | - |
| `NaturalMachine/WFIScratch1.agda` | FAIL | `(no location) agda: Heap exhausted; agda: Current maximum heap size is 2147483648 bytes (2048 MB). agda: Use `+RTS -M<si…` | X |
| `NaturalMachine/WFIScratch2.agda` | FAIL | `NaturalMachine/WFIScratch2.agda:1,1-1 Cannot read file /home/user/math/formal/cubical/NaturalMachine/WFIScratch2.agda Er…` | X |
| `NaturalMachine/WalkBridge.agda` | PASS | — | - |
| `NaturalMachine/WalkBridgeUniform.agda` | PASS | — | - |
| `NaturalMachine/WalkCapacity.agda` | PASS | — | - |
| `NaturalMachine/WalkChartedCap.agda` | PASS | — | - |
| `NaturalMachine/WalkFast.agda` | PASS | — | - |
| `NaturalMachine/WalkFastInstance.agda` | PASS | — | - |
| `NaturalMachine/WalkForcing.agda` | PASS | — | - |
| `NaturalMachine/WalkInduction.agda` | PASS | — | - |
| `NaturalMachine/WalkJumps.agda` | PASS | — | - |
| `NaturalMachine/WalkPrimePowers.agda` | PASS | — | - |
| `NaturalMachine/WalkResidueBridge.agda` | PASS | — | - |
| `NaturalMachine/WalkStream.agda` | PASS | — | - |
| `NaturalMachine/WalkUnconditional.agda` | PASS | — | - |
| `NaturalMachine/WitnessPolicy.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `NaturalMachineRun.agda` | FAIL | `NaturalMachine/PathIsSymmetry.agda:98,50-58 Not in scope: SymGroup at /home/user/math/formal/cubical/NaturalMachine/Path…` | S |
| `ObligatioOrderTrilemma.agda` | PASS | — | - |
| `OrbitSeparation.agda` | PASS | — | - |
| `PMNoSection.agda` | PASS | — | - |
| `ParityNormEliminant.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `PolarityClosure.agda` | PASS | — | - |
| `PrimePairField.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `ProjectionChargeAudit.agda` | PASS | — | - |
| `ProjectionChargeAudit2.agda` | PASS | — | - |
| `Rank1DihedralChart.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `ResponseCharacterKickback.agda` | PASS | — | - |
| `SetTruncationDescentBoundary.agda` | PASS | — | - |
| `SimplicialDefectFailure.agda` | PASS | — | - |
| `Sl2DivisorLattice.agda` | PASS | — | - |
| `Sl2TensorProduct.agda` | PASS | — | - |
| `SmithTorsorBridge.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `StagewiseComposite.agda` | PASS | — | - |
| `StagewiseCompositeB.agda` | PASS | — | - |
| `SubsetSumChartDepth.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `ThresholdGenerationDichotomy.agda` | PASS | — | - |
| `ThresholdGenerationN5Boundary.agda` | PASS | — | - |
| `TotientFibreSymmetry.agda` | FAIL | `NaturalMachine/PathIsSymmetry.agda:98,50-58 Not in scope: SymGroup at /home/user/math/formal/cubical/NaturalMachine/Path…` | S |
| `TransporterMembership.agda` | FAIL | `cubical:Cubical/Tactics/Reflection.agda:92,5-19 Not in scope: withReduceDefs at cubical:Cubical/Tactics/Reflection.agda:…` | L |
| `TransporterPortReduction.agda` | PASS | — | - |
| `Window5Walsh.agda` | PASS | — | - |
