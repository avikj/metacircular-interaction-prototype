{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RootsThreadLatch
--
-- A LATCH, not a narrative.  `agda` is the curated root
-- and `Everything.agda` is the whole-directory latch; neither reaches the
-- modules below, so by `Everything.agda`'s own header they are orphans —
-- *"checked once, by its author, on the day it landed, and then never
-- again by anything."*
--
-- The proper fix is to add them to `Everything.agda`.  That cannot be
-- done from this container: `Everything.agda` imports `NaturalMachine` at
-- line 85, and `NaturalMachine` fails here at
-- `NaturalMachine/PathIsSymmetry.agda:98` — `SymGroup` is the cubical
-- **v0.9** name for what v0.5 calls `Symmetric-Group`, and `BUILD.md`
-- pins the repository at Agda 2.8.0 / cubical v0.9 while this container
-- runs 2.6.3 / v0.5.  The root is not broken; it is unbuildable *here*.
-- Adding forty-five imports to a latch I cannot run would put unverified
-- edits in another identity's file.
--
-- So this file latches the subtree that CAN be built here, and it fails
-- the build the moment any of them rots.  When someone runs the pin,
-- these imports move into `Everything.agda` and this file is deleted.
--
-- Two of the modules below are not mine — `EquivalenceHasNoFloor` and
-- `TwoTruthsCompute`, landed by other minds in the same window.  They are
-- included because a latch is defined by what needs latching, not by
-- authorship, and they were orphans too.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  Every import below was independently rebuilt from a deleted
-- `_build` before this file was written, so this is a latch on a state
-- that already held, not a repair.  (That phrasing is `Everything.agda`'s
-- and is used deliberately: same situation, one level down.)
------------------------------------------------------------------------

module RootsThreadLatch where

-- the conic: Brahmagupta's composition, and what the line does not have
import SourcedProofs.PythagoreanTransition
import WhereTheCircleSplits
import SourcedProofs.EveryTripleIsARotation
import TheArithmeticCircleIsFourPeriodic
import SourcedProofs.IdempotenceForbidsDescent
import DescentIsNotInversion
import DescentCostsTheIntegers
import BoundedStateNeedsAGroup
import SourcedProofs.Cakravala
import SourcedProofs.CakravalaNeedsKuttaka

-- the deflation, and the tower of description
import DeflationaryTest
import Apavada
import Laghava
import Anuvrtti
import Pratyahara
import TransportPrice
import TheTower
import SourcedProofs.UnivalenceErasesTheAlgorithm
import SignIsNotAccumulable

-- the magnitude sub-thread, every claim of which was corrected or
-- dissolved; `TheGapWasAUnitsError` is the retraction and is why the
-- others are kept rather than deleted
import NoNormOnAJoin
import OverlapIsTheCost
import JoinSavesTheMeet
import TheTrajectoryIsAChain
import NumberIsExponentialInDerivation
import TheDerivationIsDenseToo
import TheGapWasAUnitsError

-- optimality, and the arithmetic chain from the kuṭṭaka to the count
import LosslessLowerBound
import SourcedProofs.OptimalObservation
import SourcedProofs.PingalaIsOptimal
import WalkObservationCount
import CRTChain
import SourcedProofs.CoprimePowers
import BezoutIsGCD
import DistinctPrimesAreCoprime
import CoprimePowersN
import FrontierCount
import FrontierList
import FrontierDivides
import Factorisation
import PFreePart
import ExponentBound
import FuelAdequacyIsACollision
import PowModHasTheSameShape
import ExhaustionIsSystematic
import FrontierMember
import PrimeCofactorCoprime
import FrontierDividesHard
import FrontierIsWellFormed
import TwoProfilesSuffice
import WitnessNumberIsTwo
import WitnessNumberIsInvariant
import WitnessNumberIsUnbounded
import WhyTheSitesAreTwo
import WitnessNumberIsThePotential
import LocatingIsEnough
import WitnessNumberCanBeInfinite
import SiteAudit
import TheCeilingIsAboutReading
import BarrierIsTwoWitnesses
import TheFloorIsAnswerability
import WitnessDichotomy
import AnyonyaAbhava
import AsiddhatvaBreaksFactoring
import AnuvrttiIsTheSameTrade
import PratyaharaBuysTotalityWithLocality
import TheSecondNaIsTheCollision
import MeruDiagonalIsVirahanka
import TheFibreIsTheSubject
import SourcedProofs.AntyaSamskaraSthaulya
import ExclusionRecoversGroundAtAPrice
import TheAbsenceTowerIsThreeUnconditionally
import WhereTheTowerCanStillBeThree
import RefutingLaghavaIsASearch
import TheUnstableGroundCannotBeExhibited
import TheDomainThatIsAnAbsence
import TheDeflationaryTestIsVacuous
import HypothesesAssumedWhereTheyAreDerivable
import AnswerabilityIsFreeAtTheFactoringLaw
import TheDelimitorNeedsOnlyStability
import WhyTheSamePriceKeepsAppearing
import TheDeflationaryTestWasAlreadyRun
import WhatTheSubstrateArgumentCovers
import TheTwoCollisionsAreOneInstantiation
import TheUniformFormIsNotRefuted
import IndependenceNeedsAnInternalImplication
import TheDiagonalLemmaDischargesGoedelFix
import RepresentabilityIsNotEnoughForIndependence
import WitSatisfiesEveryHypothesisButOmegaConsistency
import AProvabilityDeterminedImplicationForbidsIndependence
import NegationCompletenessForbidsIndependence
import ASmallTheoryWithAnIndependentSentence
import ATruthFunctionalProvabilityFalsifiesTheDiagonalSentence
import TheRefutingModelAlreadyGivesTheFirstConjunct
import ADiagonalSentenceIndependentInAConcreteTheory
import ExclusionInstantiatesAbhavaWithALoadBearingLimitor
import TheIstaSectionIsAnImportedConvention
import NonInitialPratyaharasAndOneIntersectionInstance
import PermanentUnsaidIsStableAndTemporaryIsASearch
import TheInternalRulesPreserveIndependenceInThisCalculus
import TheOmegaInconsistentExtensionDerivesTheNegation

-- Piṅgala, Virahāṅka, and the Kerala school
import SourcedProofs.Sankalita
import DurationIsSyllablesPlusGuru
import PairsSummingTo
import SourcedProofs.DiagonalIsMatra

-- the Jain fourth bhaṅga, in the same shape as लाघव and the barrier
import SourcedProofs.AvaktavyaDoesNotFactor

-- and the sites derived from the corpus's own lemma rather than beside it
import OneLemmaFiveSites

-- orphans from the same window, not mine, latched because they were
-- orphans
import EquivalenceHasNoFloor
import TwoTruthsCompute
