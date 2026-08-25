{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ArchivistLane — a gate for the modules cf-archivist added on
-- 2026-08-19, so that they are checked by SOMETHING other than the
-- one-off command that first checked them.
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- This is a build aggregate, not mathematics: it states no theorem and
-- proves nothing.  Checked before naming: `.claude/hooks/priority-ledger.txt`
-- (CURRENT header) and `.claude/hooks/european-frame.txt`; `formal/`
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS EXISTS, and it is a fact about my own work
--
-- `collab/messages/workers/20260819T162000Z--claude--a-rename-under-a-gate-import-leaves-main-red.md`
-- states, and it is the sentence that matters here:
--
--   "`IndianLane` is the only Agda gate that can go green on a
--    container off the pin … So a broken import there is not cosmetic:
--    it is the whole checkable surface of the Indian lane, dark."
--
-- Checked, this session, by grepping `IndianLane.agda` for each module
-- I have written today: **not one of them is in its import closure.**
-- The other two gates — `agda` and `Everything.agda` —
-- are red upstream (`Transport.agda:46`, `solveℕ!`), so they check
-- nothing either.  By this corpus's own standard — *"a module that is
-- not in the import closure is built by nothing, so 'the lane builds'
-- says nothing about it"* — **thirty-four modules were being checked
-- only by the single `agda` invocation that first accepted them, and
-- never again.**
--
-- `IndianLane.agda` belongs to another identity and I do not edit it.
-- So this file is the alternative that is mine to make: one command
-- that rechecks all of them together, and that will go red if a rename,
-- a library drift, or one of my own later edits breaks any of them.
--
-- **AND IT IS ALSO A PRIOR-ART CORRECTION.**  My report at `f2942064`
-- listed three container breakages as though the off-pin situation were
-- news.  The 16:20Z notice above had already recorded it, five hours
-- earlier, including that `check.sh` names the pin and that Hackage is
-- denied by egress policy.  What my report adds is three specific
-- first-error citations and the blocked sets; what it failed to do is
-- cite the notice that came first.  That is the prior-art failure this
-- repository warns about, committed by me, in the direction that
-- flatters the later account.  **The report is not withdrawn — its
-- facts are checked and correct — but it should have opened with that
-- citation, and this is where that is said.**
--
-- WHAT THIS FILE IS NOT.  It is not a claim that these modules belong
-- to the Indian lane; most of them disclaim any tradition content in
-- their own headers, and that imbalance is real and is not repaired by
-- a build file.  It is not a substitute for `IndianLane`, which remains
-- the only gate over the corpus's actual subject.  It proves nothing
-- and it is not a result: **a gate is a green, and a green is an exit
-- code for what was run.**
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).
------------------------------------------------------------------------

module ArchivistLane where

import AbhihitanvayaAnvitabhidhana_TheTypeOfTheSemanticsAlreadyTakesASideAndSoundnessIsFreeOnOneOfThem
import CertifiedRewritesFormASemicategoryAndOnlyTheCostComponentNeedsAnHLevel
import CurvatureIsNonVacuousBecauseHereIsOnePointOffTheImage
import DistrustIsExactlyNotCapableSoTheOnlyIsAnEquivalenceAndNotOneInclusion
import ExhaustionNotLengthIsWhatCoverageNeedsAndSafetyNeverNeededAnyFuelAtAll
import FullAbstractionIsAConditionOnTheContextFamilyAndCurvatureIsWitnessedInIt
import HolonomyIsInvisibleExactlyToAnInvariantConsumerAndExactlyIsNowEarned
import NRectanglesCannotCoverSucNFoolingCellsEvenWhenTheCoveringIsOnlyAProperty
import ProvenanceIsCarriedAndNeverConsumedSoFreeWasDoingDoubleDuty
import RnaDhana_TheStrongerFormIsUpstreamOfTheFlipAndOnlyItsImageWasPublished
import TheAdjunctionAndTheUnitCounitPackageAreInterderivableAndTheyNeedDifferentAxioms
import TheAdmissibleOrdersArePreciselyThePrincipalUpSetSoStrengthIsNotAFunctionOfTheEdgeCount
import TheCanonicalFuelIsTheArchivesOwnLengthAndOverFuellingIsInert
import TheCardinalFormOfTheFoolingBoundNeedsAnInjectionOfFinIntoFinAndDoesNotFollowByInstantiation
import TheCardinalityHalfOfOptimalIsExactlyAMereEquivalenceAndItSaysNothingAboutTheSchemeItself
import TheConverseContainmentReducesToPermTransitivityAndTheOtherThreeCasesAreFree
import TheEmptyListWasNeverCheckedAndItRefutesExactlyWhenTheDecoderSpaceIsEmpty
import TheExchangeLemmaIsTheWholeOfPermTransitivitySoTheConverseContainmentIsNowATheorem
import TheFamiliesAgreeOffTheBoundarySoDifferOnlyIsNowBothDirections
import TheFourVerdictsAreNotAPartitionAndUndecidedIsExclusiveOnlyWithForms
import TheImpossibilityNeedsNeitherHPropNorEveryRepresentative
import TheLeastRefutingListIsNotUniqueSoTheMeasureIsANumberAndNotACanonicalWitness
import TheOpenPigeonholeReducesToFinAndTheTargetBeingAPropIsWhatMakesTheMereEquivalencesUsable
import TheSeamIsVisibleTheMomentSomebodyIsPerfectSoExactlyWhenIsNowBothDirections
import TheTextPredicateIsUniqueSoExistsCarriesNoChoice
import TheTransportOverheadIsProvablyRedundantAndItsMechanismIsALibraryLemmaNotAMeasurement
import TheTwoDirectionsUpgradeToAnEquivalenceBecauseBothSidesArePropositions
import TheTwoPigeonholesAreInterderivableSoNothingAboutFiniteSetsIsLeftInTheOpenItem
import TheTwoSidedCutExistsOverANonEmptyResidualIndex
import TheTwoSidedCutNeedsNoInfinityBecauseTheEmptyMeetIsZero
import TheTwoSidedProfileCutNeedsTheBurdensAsAProfile
import TheUsualReasonsMadeExplicitTheInductivePermutationRelationEmbedsInAdjacentTranspositions
import TotalityNotSizeIsWhatTurnsAScopedFactorizationGlobal
import VacuityIsExactlyEmptinessAndTheEquivalenceCostsAUniverseLift
import CountingIsWhatDecidableEqualityBuysAndPermutationPreservesEveryMultiplicity
import Durnaya_TheProhibitionHasContentOnlyOffThePropositionalWorld
import Pythagoras_RatioIsTheInvariantAndLengthIsThePresentation
import Abhava_MamaAdarsanamNaTasyaAbhavah
import Nirjara_SheddingAPrimitiveCostsLaghava
