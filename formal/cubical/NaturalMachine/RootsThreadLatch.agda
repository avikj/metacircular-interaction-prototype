{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.RootsThreadLatch
--
-- A LATCH, not a narrative.  `NaturalMachine.agda` is the curated root
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

module NaturalMachine.RootsThreadLatch where

-- the conic: Brahmagupta's composition, and what the line does not have
import NaturalMachine.PythagoreanTransition
import NaturalMachine.WhereTheCircleSplits
import NaturalMachine.EveryTripleIsARotation
import NaturalMachine.TheArithmeticCircleIsFourPeriodic
import NaturalMachine.IdempotenceForbidsDescent
import NaturalMachine.DescentIsNotInversion
import NaturalMachine.DescentCostsTheIntegers
import NaturalMachine.BoundedStateNeedsAGroup
import NaturalMachine.Cakravala
import NaturalMachine.CakravalaNeedsKuttaka

-- the deflation, and the tower of description
import NaturalMachine.DeflationaryTest
import NaturalMachine.Apavada
import NaturalMachine.Laghava
import NaturalMachine.Anuvrtti
import NaturalMachine.Pratyahara
import NaturalMachine.TransportPrice
import NaturalMachine.TheTower
import NaturalMachine.UnivalenceErasesTheAlgorithm
import NaturalMachine.SignIsNotAccumulable

-- the magnitude sub-thread, every claim of which was corrected or
-- dissolved; `TheGapWasAUnitsError` is the retraction and is why the
-- others are kept rather than deleted
import NaturalMachine.NoNormOnAJoin
import NaturalMachine.OverlapIsTheCost
import NaturalMachine.JoinSavesTheMeet
import NaturalMachine.TheTrajectoryIsAChain
import NaturalMachine.NumberIsExponentialInDerivation
import NaturalMachine.TheDerivationIsDenseToo
import NaturalMachine.TheGapWasAUnitsError

-- optimality, and the arithmetic chain from the kuṭṭaka to the count
import NaturalMachine.LosslessLowerBound
import NaturalMachine.OptimalObservation
import NaturalMachine.PingalaIsOptimal
import NaturalMachine.WalkObservationCount
import NaturalMachine.CRTChain
import NaturalMachine.CoprimePowers
import NaturalMachine.BezoutIsGCD
import NaturalMachine.DistinctPrimesAreCoprime
import NaturalMachine.CoprimePowersN
import NaturalMachine.FrontierCount
import NaturalMachine.FrontierList
import NaturalMachine.FrontierDivides
import NaturalMachine.Factorisation
import NaturalMachine.PFreePart
import NaturalMachine.ExponentBound
import NaturalMachine.FuelAdequacyIsACollision
import NaturalMachine.PowModHasTheSameShape
import NaturalMachine.ExhaustionIsSystematic
import NaturalMachine.FrontierMember
import NaturalMachine.PrimeCofactorCoprime
import NaturalMachine.FrontierDividesHard
import NaturalMachine.FrontierIsWellFormed
import NaturalMachine.TwoProfilesSuffice
import NaturalMachine.WitnessNumberIsTwo
import NaturalMachine.WitnessNumberIsInvariant
import NaturalMachine.WitnessNumberIsUnbounded
import NaturalMachine.WhyTheSitesAreTwo
import NaturalMachine.WitnessNumberIsThePotential
import NaturalMachine.LocatingIsEnough
import NaturalMachine.WitnessNumberCanBeInfinite
import NaturalMachine.SiteAudit
import NaturalMachine.TheCeilingIsAboutReading
import NaturalMachine.BarrierIsTwoWitnesses
import NaturalMachine.TheFloorIsAnswerability
import NaturalMachine.WitnessDichotomy
import NaturalMachine.AnyonyaAbhava
import NaturalMachine.AsiddhatvaBreaksFactoring
import NaturalMachine.AnuvrttiIsTheSameTrade
import NaturalMachine.PratyaharaBuysTotalityWithLocality
import NaturalMachine.TheSecondNaIsTheCollision
import NaturalMachine.MeruDiagonalIsVirahanka
import NaturalMachine.TheFibreIsTheSubject
import NaturalMachine.AntyaSamskaraSthaulya
import NaturalMachine.ExclusionRecoversGroundAtAPrice
import NaturalMachine.TheAbsenceTowerIsThreeUnconditionally
import NaturalMachine.WhereTheTowerCanStillBeThree
import NaturalMachine.RefutingLaghavaIsASearch
import NaturalMachine.TheUnstableGroundCannotBeExhibited
import NaturalMachine.TheDomainThatIsAnAbsence
import NaturalMachine.TheDeflationaryTestIsVacuous
import NaturalMachine.HypothesesAssumedWhereTheyAreDerivable
import NaturalMachine.AnswerabilityIsFreeAtTheFactoringLaw
import NaturalMachine.TheDelimitorNeedsOnlyStability
import NaturalMachine.WhyTheSamePriceKeepsAppearing
import NaturalMachine.TheDeflationaryTestWasAlreadyRun
import NaturalMachine.WhatTheSubstrateArgumentCovers
import NaturalMachine.TheTwoCollisionsAreOneInstantiation
import NaturalMachine.TheUniformFormIsNotRefuted
import NaturalMachine.IndependenceNeedsAnInternalImplication
import NaturalMachine.TheDiagonalLemmaDischargesGoedelFix
import NaturalMachine.RepresentabilityIsNotEnoughForIndependence
import NaturalMachine.WitSatisfiesEveryHypothesisButOmegaConsistency
import NaturalMachine.AProvabilityDeterminedImplicationForbidsIndependence
import NaturalMachine.NegationCompletenessForbidsIndependence
import NaturalMachine.ASmallTheoryWithAnIndependentSentence
import NaturalMachine.ATruthFunctionalProvabilityFalsifiesTheDiagonalSentence
import NaturalMachine.TheRefutingModelAlreadyGivesTheFirstConjunct
import NaturalMachine.ADiagonalSentenceIndependentInAConcreteTheory
import NaturalMachine.ExclusionInstantiatesAbhavaWithALoadBearingLimitor
import NaturalMachine.TheIstaSectionIsAnImportedConvention
import NaturalMachine.NonInitialPratyaharasAndOneIntersectionInstance
import NaturalMachine.PermanentUnsaidIsStableAndTemporaryIsASearch
import NaturalMachine.TheInternalRulesPreserveIndependenceInThisCalculus
import NaturalMachine.TheOmegaInconsistentExtensionDerivesTheNegation

-- Piṅgala, Virahāṅka, and the Kerala school
import NaturalMachine.Sankalita
import NaturalMachine.DurationIsSyllablesPlusGuru
import NaturalMachine.PairsSummingTo
import NaturalMachine.DiagonalIsMatra

-- the Jain fourth bhaṅga, in the same shape as लाघव and the barrier
import NaturalMachine.AvaktavyaDoesNotFactor

-- and the sites derived from the corpus's own lemma rather than beside it
import NaturalMachine.OneLemmaFiveSites

-- orphans from the same window, not mine, latched because they were
-- orphans
import NaturalMachine.EquivalenceHasNoFloor
import NaturalMachine.TwoTruthsCompute
