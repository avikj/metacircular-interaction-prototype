{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Everything
--
-- THE WHOLE DIRECTORY, IN ONE COMMAND.
--
-- `NaturalMachine.agda` is the root of the NaturalMachine/ subtree and
-- BUILD.md's green claim is stated in terms of it.  That claim was
-- honest and it was also NARROWER THAN IT LOOKED: at the time this file
-- was written there were **33 further modules at the top level of
-- formal/cubical/** that the NaturalMachine root does not import.  Each
-- was checked once, by its author, on the day it landed, and then never
-- again by anything.
--
-- That is the same hole BUILD.md already describes one level down:
--
--     "an orphan that the root does not import is exactly the hole that
--      let the earlier overstatement hide."
--
-- The lesson had been learned for `NaturalMachine/*.agda` and not for
-- `*.agda`.  A green claim that covers 1 of 34 top-level modules is not
-- false, but a reader will take it for more than it says — which is the
-- failure mode this corpus keeps catching itself in, and the reason the
-- fix is a MODULE rather than a sentence in a markdown file.  A sentence
-- rots; an import list fails the build.
--
-- All 34 were verified exit 0 individually before this file was created,
-- so it is a latch on a state that already held, not a repair.
--
--
-- WHAT THIS COVERS AND WHAT IT DOES NOT
--
--  * Every `.agda` file at the top level of `formal/cubical/`, plus the
--    `NaturalMachine` root (hence, transitively, all of
--    `NaturalMachine/`).
--
--  * `NaturalMachine/Control/` is EXCLUDED, permanently and on purpose.
--    Its contents are deliberately wrong statements that MUST fail to
--    typecheck.  Nothing may ever import it.  If a future edit makes
--    `Control/` check, that is the bug.
--
--  * The Lean lane (`formal/pairfield/`) is a different toolchain and is
--    not covered by anything here.
--
-- Everything is imported PLAIN, never `open`ed and never `public`.  The
-- modules were written independently and collide freely on short names
-- (`Q`, `τ`, `step`, `see`, `W`, `InvLim`, …); re-exporting them would
-- turn an aggregate into a merge conflict.  The point is that the kernel
-- checks them, not that a client can dot into them from here.
------------------------------------------------------------------------

module Everything where

-- The NaturalMachine root, and through it the whole NaturalMachine/
-- subtree.  BUILD.md's mechanical orphan check still applies inside that
-- subtree and is not superseded by this file.
import NaturalMachine
import NaturalMachineRun

-- Charts and descent.
import CayleyPairChart
import DescentLaw
import DynamicDescent
import Rank1DihedralChart
import SetTruncationDescentBoundary

-- The Γ₀ lane: partner, converse, and the hypothesis anatomy that showed
-- `ε² = 1` is a THEOREM off q = 0 rather than a hypothesis, together with
-- the rigidity that makes partner and witness one type presented twice.
import Gamma0Partner
import Gamma0PartnerRigidity
import Gamma0Converse
import Gamma0ConverseSharp
import Gamma0Freeness
import Gamma0Transitivity
import Gamma0Index
import M2Unimodular
import SmithTorsorBridge

-- Transporters, ports, orbits.
import TransporterMembership
import TransporterPortReduction
import OrbitSeparation
import TotientFibreSymmetry

-- Observation, description, exclusion.
import ExtremalDescription
import ExclusionScope
import ObligatioOrderTrilemma
import ThresholdGenerationDichotomy
import ElsewhereCondition

-- Arithmetic: the kuṭṭaka family, integer hulls, subset-sum chart depth,
-- and the parity/reflection-norm eliminant.
import KuttakaValli
import IntegerHullMultiplicity
import SubsetSumChartDepth
import ParityNormEliminant

-- Peres–Mermin and the charge audits.
import PMNoSection
import ProjectionChargeAudit
import ProjectionChargeAudit2
import LiftingFiberResidue
import ResponseCharacterKickback

-- Walsh/window analysis.
import Window5Walsh

------------------------------------------------------------------------
-- TOTALITY LATCH (cf-corner, 2026-08-16).  The header above closed the
-- orphan hole for the 34 TOP-LEVEL modules.  It left the same hole one
-- directory down: NaturalMachine/ modules the root does not import, and
-- the whole Swarm/ subdirectory (16 modules landed in one day, none in
-- any aggregate).  135 modules were outside this file.  They are
-- imported below, so `agda Everything.agda` now means what its title
-- says: EVERY module in this directory except Control/, which must fail
-- to typecheck by design and is asserted to fail by CI.
--
-- Generated mechanically from the directory listing, not by hand, for
-- the reason BUILD.md gives: a hand-maintained list drifts in both
-- directions and this one already had.
------------------------------------------------------------------------

import BehavioralApartness
import CenterRelative
import NaturalMachine.AcceptanceTest
import NaturalMachine.ActionRefinement
import NaturalMachine.ArithmeticPayloadCounterexample
import NaturalMachine.AtlasResiduals
import NaturalMachine.AtomicSatisfaction
import NaturalMachine.BuchstabDegree
import NaturalMachine.CapabilityGraph
import NaturalMachine.CarryBorrowObservation
import NaturalMachine.CarryChartBridge
import NaturalMachine.CarryClassNonzero
import NaturalMachine.CarryObstruction
import NaturalMachine.CenterRelative
import NaturalMachine.CenterRelativeIntegral
import NaturalMachine.CertificateFibration
import NaturalMachine.ChargeCriterion
import NaturalMachine.ChargeGradedPeeling
import NaturalMachine.ChargeGrading
import NaturalMachine.ChenProjector
import NaturalMachine.CompileBridge
import NaturalMachine.CompressionDefect
import NaturalMachine.ConeImage
import NaturalMachine.ConeOrder
import NaturalMachine.Controls
import NaturalMachine.CoprimeSplitting
import NaturalMachine.CornerProjectors
import NaturalMachine.CostGeometry
import NaturalMachine.CostGeometryWitness
import NaturalMachine.CountedComposition
import NaturalMachine.CountedDigits
import NaturalMachine.CountedExecution
import NaturalMachine.DatumSensitivePayload
import NaturalMachine.Decategorification
import NaturalMachine.DefectCalculus
import NaturalMachine.DefinitionalExtension
import NaturalMachine.DigitTowerFin
import NaturalMachine.DigitTowerFinLimit
import NaturalMachine.DigitTowerLimit
import NaturalMachine.Digits
import NaturalMachine.EffectiveDescent
import NaturalMachine.Endian
import NaturalMachine.EndogenousHorizon
import NaturalMachine.ExcursionReturn
import NaturalMachine.FinTopSplit
import NaturalMachine.FiniteInformation
import NaturalMachine.FlipObservable
import NaturalMachine.FreeMonoid
import NaturalMachine.FutureBehavior
import NaturalMachine.GaugeOrbitClasses
import NaturalMachine.GeneratedCapability
import NaturalMachine.GenerativeLoop
import NaturalMachine.GroupCohomologyH2
import NaturalMachine.HolonomyDescent
import NaturalMachine.LCMExists
import NaturalMachine.LawfulContinuationCore
import NaturalMachine.LeakageCommutator
import NaturalMachine.LinearOrderFinite
import NaturalMachine.MeanStandardRep
import NaturalMachine.ObservabilityQuotient
import NaturalMachine.ObservationPresentation
import NaturalMachine.Obstruction
import NaturalMachine.OracleQueries
import NaturalMachine.OrderedSectorBreak
import NaturalMachine.PMCokernel
import NaturalMachine.PMTorus
import NaturalMachine.PairCoordinates
import NaturalMachine.PairReflectionSector
import NaturalMachine.ParetoCost
import NaturalMachine.ParitySeparator
import NaturalMachine.PathIsSymmetry
import NaturalMachine.PauliWeyl
import NaturalMachine.PayloadMorphism
import NaturalMachine.PerspectiveCore
import NaturalMachine.PerspectiveSymmetry
import NaturalMachine.ProgressDefinition
import NaturalMachine.ProofLabelNoGo
import NaturalMachine.QuadraticRefinement
import NaturalMachine.RadixSymptoma
import NaturalMachine.RealizedPayloadCapability
import NaturalMachine.ResidueTransport
import NaturalMachine.RewriteCertificate
import NaturalMachine.RootWeightIndex
import NaturalMachine.RoughSplit
import NaturalMachine.SensorNerode
import NaturalMachine.SetBaseNoMonodromy
import NaturalMachine.SieveFiber
import NaturalMachine.SieveScaleTower
import NaturalMachine.SmithCapability
import NaturalMachine.SmithPathCountedExecution
import NaturalMachine.StabilizerSubgroup
import NaturalMachine.StabilizerTorsor
import NaturalMachine.StructuredDefect
import NaturalMachine.SufficientInterfaces
import NaturalMachine.SymmetryArithmeticAction
import NaturalMachine.SymmetryCardinality
import NaturalMachine.SymmetryEnumeration
import NaturalMachine.TermFreeMonoid
import NaturalMachine.ThreeChannels
import NaturalMachine.TranscriptDescent
import NaturalMachine.Transport
import NaturalMachine.TransportCost
import NaturalMachine.TransportInstance
import NaturalMachine.TransportMul
import NaturalMachine.TransportMulWitness
import NaturalMachine.TwoProjections
import NaturalMachine.TypedUnfold
import NaturalMachine.VacuityVerdict
import NaturalMachine.WalkBridge
import NaturalMachine.WalkBridgeUniform
import NaturalMachine.WalkCapacity
import NaturalMachine.WalkFast
import NaturalMachine.WalkForcing
import NaturalMachine.WalkInduction
import NaturalMachine.WalkJumps
import NaturalMachine.WalkPrimePowers
import NaturalMachine.WalkStream
import NaturalMachine.WalkUnconditional
import NaturalMachine.WitnessPolicy
import PrimePairField
import Swarm.S00TranscriptComposition
import Swarm.S01PaniniAshby
import Swarm.S02ModeAdjoint
import Swarm.S03CarryFiber
import Swarm.S04Apoha
import Swarm.S05AsiddhaNewton
import Swarm.S06NoWrap
import Swarm.S07LeadingDigit
import Swarm.S08ChebyshevWeight
import Swarm.S09SmithKuttaka
import Swarm.S10VertexOrbit
import Swarm.S11HolonomyDeterminant
import Swarm.S12CyclotomicChain
import Swarm.S13OptionSpread
import Swarm.S14AssemblyGrading
import Swarm.S15ACResidue
import NaturalMachine.MixedCornerDescent
import Coordination.Serialization
