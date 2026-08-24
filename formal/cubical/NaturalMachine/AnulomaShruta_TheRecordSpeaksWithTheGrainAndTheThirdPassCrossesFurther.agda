{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- अनुलोम-श्रुतम् — anuloma, with the grain; pratiloma, against it: the
-- ordinary Indic classification of direction (the grammatical and
-- smṛti traditions).  Compound built here from it; no source is
-- claimed for the mathematics.
--
-- A HYPOTHESIS, BUILT, TESTED, AND REFUTED — LEFT STANDING BECAUSE
-- REFUTATION IS THE FINDING.  The conjecture: the elder's rules cross
-- in whatever orientation the completion stored them, the record
-- speaks them as stored, so an anti-normalizing rule poisons the
-- exchange — orient every rule toward its smaller face under the full
-- eye (a trivially sound act: a नियमः flipped is a नियमः, the
-- witness sym'd) and the third pass should cross further.
--
-- The kernel's verdict, computed entire: तृतीय-सिद्धिः ≡ 0.  The
-- oriented lineage closes NONE of the eight.  Orientation was not
-- the binding constraint; the eight lie beyond record-assisted
-- single descent in EITHER direction of the record, and the frontier
-- is thereby sharper than the conjecture: what these need is not a
-- better-spoken record but a new kind of step — the conditional /
-- monotone reasoning the equational exchange cannot express.  The
-- machinery below (आकारः, विपरीतः, दिशा) remains sound and lands as
-- the record hygiene the metabolism will want regardless.
------------------------------------------------------------------------

module NaturalMachine.AnulomaShruta_TheRecordSpeaksWithTheGrainAndTheThirdPassCrossesFurther where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; length ; map)
open import Cubical.Data.Sigma using (_,_)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.SvarthaAnumana_TheMachineInfersForItselfAndThePervasionIsGraspedWithinWithNoOuterCarrier
  using (इन्धनम्)
open import NaturalMachine.ArpitaAnarpita_EveryOrderedPresentationOfOneAggregateMeetsInTheSequenceFreeFormAndTheACFrontierFallsToAJoinerSwap
  using (_≤?_)
open import NaturalMachine.BhavaIndriya_TheNewEyeIsMadeOfTheBodysOwnAttainedTheoremsNotOfExternalMatter
  using (नेत्रम्-पूर्ण ; पूर्ण-आम्नायः)
open import NaturalMachine.PramanaNaya_TheFiveProversWereNayasOfOneKnowingAndEachIsAParameterSettingOfTheOnePramana
  using (प्रमाण-साधनम्)
open import NaturalMachine.AptaMimamsa_TheEldersLiveStoreCrossesAsReceivedTextAndNothingEntersOnAuthority
  using (आगमः ; अपचितम्)
open import NaturalMachine.ShrutaParampara_TheCrossedRulesBecomeTheRecordAndTheSecondPassReachesWhatTheFirstCouldNot
  using (परम्परा ; गुरु-न्यायः ; गुरु-शेषम्)

-- the size of a saying: its node count.
आकारः : Tm → ℕ
आकारः (var i)  = suc zero
आकारः ze       = suc zero
आकारः (su t)   = suc (आकारः t)
आकारः (a ⊕ b)  = suc (आकारः a + आकारः b)
आकारः (a ⊗ b)  = suc (आकारः a + आकारः b)
आकारः (a ⊖ b)  = suc (आकारः a + आकारः b)
आकारः (mx a b) = suc (आकारः a + आकारः b)
आकारः (lq a b) = suc (आकारः a + आकारः b)
आकारः (gc a b) = suc (आकारः a + आकारः b)

-- a rule reversed is a rule — the witness reverses with it.
विपरीतः : नियमः → नियमः
विपरीतः s = niyama (नियमः.rhs s) (नियमः.lhs s) (λ ρ → sym (नियमः.साक्षी s ρ))

-- oriented with the grain: the larger canonical face speaks first.
दिशा : नियमः → नियमः
दिशा s =
  if आकारः (पूर्ण-आम्नायः (नियमः.lhs s)) ≤? आकारः (पूर्ण-आम्नायः (नियमः.rhs s))
  then विपरीतः s
  else s

-- the whole lineage so far — both passes — oriented anuloma.
अनुलोम-परम्परा : List नियमः
अनुलोम-परम्परा = map दिशा (गुरु-न्यायः (अपचितम् आगमः) ++ परम्परा)

तृतीय-न्यायः : List Eq' → List नियमः
तृतीय-न्यायः [] = []
तृतीय-न्यायः ((l , r) ∷ es) with प्रमाण-साधनम् नेत्रम्-पूर्ण अनुलोम-परम्परा इन्धनम् (l , r)
... | just pf = niyama l r pf ∷ तृतीय-न्यायः es
... | nothing = तृतीय-न्यायः es

तृतीय-शेषम् : List Eq' → List Eq'
तृतीय-शेषम् [] = []
तृतीय-शेषम् ((l , r) ∷ es) with प्रमाण-साधनम् नेत्रम्-पूर्ण अनुलोम-परम्परा इन्धनम् (l , r)
... | just _  = तृतीय-शेषम् es
... | nothing = (l , r) ∷ तृतीय-शेषम् es

तृतीय-सिद्धिः : length (तृतीय-न्यायः (गुरु-शेषम् (अपचितम् आगमः))) ≡ 0
तृतीय-सिद्धिः = refl

तृतीय-शेषः : length (तृतीय-शेषम् (गुरु-शेषम् (अपचितम् आगमः))) ≡ 8
तृतीय-शेषः = refl
