-- Root of the Lean lane.  Since 2026-08-20 this file imports EVERY module
-- under `Pairfield/` (133 of 133), so `import Pairfield` and the module tree
-- agree.  It began as "the V3 ledger root: machine-checked targets from
-- notes/VV.md" and stopped being that by accretion long before it was renamed;
-- see the note at the foot of the file for what the drift cost and what it
-- did not.  The BUILD gate is `globs` in `lakefile.toml`, not this list.
import Pairfield.SumRigidity
import Pairfield.BellmanArgminIntegration
import Pairfield.ChuArgminTransport
import Pairfield.AntiSpike
import Pairfield.BoundedPrimePair
import Pairfield.CenterBoundedPrimePair
import Pairfield.GoldbachBoundary
import Pairfield.GoldbachDecision
import Pairfield.GoldbachDecisionRange
import Pairfield.GoldbachWeightedBoundary
import Pairfield.GoldbachFixedFiberContamination
import Pairfield.RestrictedGoldbachEdge
import Pairfield.GoldbachCrossover
import Pairfield.HahnBilinearBoundary
import Pairfield.IndraFourierNetAdapter
import Pairfield.ProcessCutRankAdapter
import Pairfield.IncrementalCRTAdapter
import Pairfield.CyclotomicRoutingAdapter
import Pairfield.CyclotomicPrimitiveTransportAdapter
import Pairfield.HeadDepthBlindnessAdapter
import Pairfield.HigherArityPadicAdapter
import Pairfield.InfiniteValuationFiberAdapter
import Pairfield.PrimePairDecomposition
import Pairfield.Lorentz
import Pairfield.ReversalRigidity
import Pairfield.CharacterAnchor
import Pairfield.CarryCohomologyAdapter
import Pairfield.FiniteInformation
import Pairfield.FutureBehavior
import Pairfield.PointwiseRevision
import Pairfield.Lowenheim
import Pairfield.ResourceBalance
import Pairfield.MyhillNerodeAdapter
import Pairfield.ResidualBFS
import Pairfield.NerodeChartAdapter
import Pairfield.ChartStateBFS
import Pairfield.ObservableHorizon
import Pairfield.ChartQuotient
import Pairfield.ReachableSubDFA
import Pairfield.ExecutableMinimization
import Pairfield.ShortestReach
import Pairfield.VisitedReach
import Pairfield.VisitedReachCardinality
import Pairfield.VisitedPairHorizon
import Pairfield.VisitedPair
import Pairfield.VisitedResidual
import Pairfield.ObservableVisitedPairAdapter
import Pairfield.GlobalObservableHorizon
import Pairfield.ResidualObservableHorizon
import Pairfield.AdaptiveObservableHorizon
import Pairfield.AdaptiveResidualAdapter
import Pairfield.AdaptiveBranchResidual
import Pairfield.ReachableAdaptiveObservableHorizon
import Pairfield.AdaptiveUniformBound
import Pairfield.LinearAdaptiveGap
import Pairfield.AdaptiveDistinguishingTransport
import Pairfield.AdaptiveResidualSplitting
import Pairfield.AdaptiveResidualPartition
import Pairfield.AdaptiveSplitPotential
import Pairfield.AdaptiveResidualPotentialAdapter
import Pairfield.AdaptiveResidualConstructor
import Pairfield.AdaptiveResidualSteering
import Pairfield.AdaptiveConstantResponseSteering
import Pairfield.AdaptiveResidualPositionRank
import Pairfield.AdaptiveResidualCycleDeletion
import Pairfield.AdaptiveResidualPositionCycleAdapter
import Pairfield.AdaptiveResidualMinimalSpine
import Pairfield.AdaptiveResidualNodeMinimalSpine
import Pairfield.AdaptiveResidualNodeMinimalDepth
import Pairfield.AdaptiveResidualNonhomogeneousSpine
import Pairfield.AdaptiveResidualGlobalPartition
import Pairfield.AdaptiveResidualAnnotatedSplit
import Pairfield.AdaptiveResidualAnnotatedPartitionAdapter
import Pairfield.AdaptiveResidualStrictRefinementIff
import Pairfield.NativeCompleteWitnesses
import Pairfield.NativeCompleteWitnessPartition
import Pairfield.NativeCompleteWitnessCost
import Pairfield.NativeWitnessGreedyFormation
import Pairfield.NativeReverseSeparatorPolicy
import Pairfield.NativeReversePairTraversal
import Pairfield.NativeReverseEdgeInventory
import Pairfield.NativeIndexedReverseTraversal
import Pairfield.NativeIndexedPolicyBoundary
import Pairfield.NativeIndexedParentExtraction
import Pairfield.NativeIndexedParentRetention
import Pairfield.TernaryCancellationFormation
import Pairfield.NativeDemandRestrictedFormation
import Pairfield.NativeShortestSeparatorPolicy
import Pairfield.AdaptiveResidualBinomialBudgetNoGo
import Pairfield.SmithCertificate
import Pairfield.ComputableSmith2x2
import Pairfield.ComputableSmith2x2Adapter
import Pairfield.DirectSmith2x2
import Pairfield.SmithPresentation
import Pairfield.GeneralSmith2x2
import Pairfield.DiagonalSmithRoute
import Pairfield.EuclidCoefficientTrace
import Pairfield.EuclidCoefficientForkNoGo
import Pairfield.EuclidCoefficientCutBound
import Pairfield.EuclidFiniteTargetFormation
import Pairfield.EuclidDoublingFork
import Pairfield.SmithContent
import Pairfield.CertificateSource
import Pairfield.RankOneSmith2x2
import Pairfield.RankOneWitness
import Pairfield.LeastNonDivisor
import Pairfield.FrontierOptimality
import Pairfield.WalkFalsifier
import Pairfield.SmithMemory
import Pairfield.HaarNullProcess
-- ---------------------------------------------------------------------------
-- 2026-08-20.  The nineteen modules below were outside this root's import
-- closure.  Re-derived by running the closure, not by reading a list: 133
-- modules under `Pairfield/`, 114 reachable from here, 19 not.
--
-- They were NOT "built by nothing" — `lakefile.toml` carries
-- `globs = ["Pairfield", "Pairfield.+"]`, so every module under `Pairfield/`
-- is a build target whether or not anything imports it, and `lake build`
-- completes at 8840 jobs, exit 0, over all 133.  What the gap cost was
-- REACHABILITY: `import Pairfield` returned 114 of 133, silently.
--
-- The reason recorded here for two of the exclusions was:
--
--     "It is kept out of the default target for the same reason
--      `Pairfield.CapabilityGraph` always was: that module imports all of
--      Mathlib."
--
-- That reason is false, and checking it is one grep.  Eight modules under
-- `Pairfield/` carry a bare `import Mathlib`, and SIX of them were already in
-- this list -- `SumRigidity` is line 2 of this file.  The root's import
-- closure has been all of Mathlib since long before those exclusions were
-- written, so the stated ground did not distinguish the excluded modules from
-- the included ones.  A reason that does not discriminate is not a reason; it
-- is a concealed standpoint (`notes/AHIMSA_SUTRA_VISTARA.md` §2), and it is
-- worse than a wrong reason because it reads as diligence.
--
-- Adding them changes nothing about what is BUILT (the glob already decided
-- that; the target set is identical, derived, not measured) and everything
-- about what `import Pairfield` reaches.
-- `scripts/check-lean-root-closure.sh` keeps the two counts equal from here.
import Pairfield.ArbitrarySmithClosure
import Pairfield.Automata
import Pairfield.BuildCoverageChannel
import Pairfield.CapabilityGraph
import Pairfield.CharacterSectorClosure
import Pairfield.EuclidDoublingForkMinimal
import Pairfield.FiniteChuResidualTransport
import Pairfield.FiniteCoYonedaWeave
import Pairfield.FiniteHistoryTotalization
import Pairfield.GoldbachChebyshevAdapter
import Pairfield.HolonomyDescent
import Pairfield.InvariantCorrectiveClosure
import Pairfield.LinearCongruenceChannel
import Pairfield.Madhava
import Pairfield.ParityRigidity
import Pairfield.SieveRestriction
import Pairfield.UpwardEscape
import Pairfield.UpwardEscapeNecessity
import Pairfield.VandermondeFrequencyResponse
