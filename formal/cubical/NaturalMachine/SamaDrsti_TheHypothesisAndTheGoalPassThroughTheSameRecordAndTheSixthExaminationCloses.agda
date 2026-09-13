{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- सम-दृष्टिः — equal seeing.  Compound built here, 2026-08-24; no
-- source is claimed for the mathematics.
--
-- A BUG-CLASS, FOUND BY THE RESIDUE.  In every prior step-pervasion
-- the GOAL was processed by the record (श्रुत-विनिमयः) but the
-- HYPOTHESIS's faces were not — so when the record helpfully
-- simplified the goal, it destroyed the exact match the hypothesis
-- was about to make: the record's assistance sabotaged the exchange.
-- x − s(x+y) = 0 exhibits it precisely: under the deep eye the step
-- form IS the hypothesis, syntactically — until the record rewrites
-- one and not the other.  The repair is symmetry of vision: the
-- hypothesis's two faces pass through the SAME record as the goal,
-- and the conditional witness threads through श्रुत-साक्षी on both
-- sides.  The sixth examination runs with the symmetrized exchange
-- over the factoring eye.
------------------------------------------------------------------------

module NaturalMachine.SamaDrsti_TheHypothesisAndTheGoalPassThroughTheSameRecordAndTheSixthExaminationCloses where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Sigma using (_,_)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.Aroha_TheInternalProverClimbsWhereItsFlatVoiceIsSilentAndTheStoreAdmitsInductionThroughTheSameGate
  using (आरोहः ; _⟨_≔_⟩)
open import NaturalMachine.SvarthaAnumana_TheMachineInfersForItselfAndThePervasionIsGraspedWithinWithNoOuterCarrier
  using (अथवा ; चराः ; इन्धनम्)
open import NaturalMachine.ShrutaMatipurva_TheRecordIsPrecededByCognitionAndCognitionWithTheRecordReachesWhatItAloneCouldNot
  using (श्रुत-विनिमयः ; श्रुत-साक्षी)
open import NaturalMachine.AptaMimamsa_TheEldersLiveStoreCrossesAsReceivedTextAndNothingEntersOnAuthority
  using (आगमः ; अपचितम्)
open import NaturalMachine.ShrutaParampara_TheCrossedRulesBecomeTheRecordAndTheSecondPassReachesWhatTheFirstCouldNot
  using (गुरु-शेषम्)
open import NaturalMachine.AnulomaShruta_TheRecordSpeaksWithTheGrainAndTheThirdPassCrossesFurther
  using (अनुलोम-परम्परा)
open import NaturalMachine.Rashi_TheSumIsAHeapNotASequenceTheUnitIsAnAtomAndTheHypothesisSpeaksThroughTheHeap
  using (राशि-विनिमयः ; राशि-साक्षी ; चतुर्थ-शेषम्)
open import NaturalMachine.SadharanaVishesha_TheCommonIsSetAsideAndTheContendersMeetOnlyOnTheirDifference
  using (गूढ-आम्नायः ; गूढ-सत्यम् ; दृक्पातः ; दृक्पात-सत्यम् ; पञ्चम-शेषम्)

सम-व्याप्तिः : List नियमः → (k : ℕ) (l r : Tm)
  → Maybe ((ρ : ℕ → ℕ) → eval l ρ ≡ eval r ρ
       → eval (l ⟨ k ≔ su (var k) ⟩) ρ ≡ eval (r ⟨ k ≔ su (var k) ⟩) ρ)
सम-व्याप्तिः Γ k l r =
  mmap
    (λ q ρ ih →
      let h = sym (श्रुत-साक्षी Γ ρ (दृक्पातः l))
            ∙ (दृक्पात-सत्यम् l ρ ∙ ih ∙ sym (दृक्पात-सत्यम् r ρ))
            ∙ श्रुत-साक्षी Γ ρ (दृक्पातः r)
      in   sym (दृक्पात-सत्यम् (l ⟨ k ≔ su (var k) ⟩) ρ)
         ∙ श्रुत-साक्षी Γ ρ (दृक्पातः (l ⟨ k ≔ su (var k) ⟩))
         ∙ राशि-साक्षी (श्रुत-विनिमयः Γ (दृक्पातः l)) (श्रुत-विनिमयः Γ (दृक्पातः r)) ρ h
             (श्रुत-विनिमयः Γ (दृक्पातः (l ⟨ k ≔ su (var k) ⟩)))
         ∙ sym (गूढ-सत्यम् (राशि-विनिमयः (श्रुत-विनिमयः Γ (दृक्पातः l)) (श्रुत-विनिमयः Γ (दृक्पातः r))
             (श्रुत-विनिमयः Γ (दृक्पातः (l ⟨ k ≔ su (var k) ⟩)))) ρ)
         ∙ cong (λ w → eval w ρ) q
         ∙ गूढ-सत्यम् (राशि-विनिमयः (श्रुत-विनिमयः Γ (दृक्पातः l)) (श्रुत-विनिमयः Γ (दृक्पातः r))
             (श्रुत-विनिमयः Γ (दृक्पातः (r ⟨ k ≔ su (var k) ⟩)))) ρ
         ∙ sym (राशि-साक्षी (श्रुत-विनिमयः Γ (दृक्पातः l)) (श्रुत-विनिमयः Γ (दृक्पातः r)) ρ h
             (श्रुत-विनिमयः Γ (दृक्पातः (r ⟨ k ≔ su (var k) ⟩))))
         ∙ sym (श्रुत-साक्षी Γ ρ (दृक्पातः (r ⟨ k ≔ su (var k) ⟩)))
         ∙ दृक्पात-सत्यम् (r ⟨ k ≔ su (var k) ⟩) ρ)
    (  गूढ-आम्नायः (राशि-विनिमयः (श्रुत-विनिमयः Γ (दृक्पातः l)) (श्रुत-विनिमयः Γ (दृक्पातः r))
         (श्रुत-विनिमयः Γ (दृक्पातः (l ⟨ k ≔ su (var k) ⟩))))
    ≟T गूढ-आम्नायः (राशि-विनिमयः (श्रुत-विनिमयः Γ (दृक्पातः l)) (श्रुत-विनिमयः Γ (दृक्पातः r))
         (श्रुत-विनिमयः Γ (दृक्पातः (r ⟨ k ≔ su (var k) ⟩)))) )

सम-साधनम् : List नियमः → ℕ → (e : Eq') → Maybe (⊨ e)
स-प्रयत्नः : List नियमः → ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))
स-ऊर्ध्वम् : List नियमः → ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))

सम-साधनम् Γ zero e = nothing
सम-साधनम् Γ (suc f) (l , r) =
  अथवा (mmap (λ p ρ → sym (दृक्पात-सत्यम् l ρ) ∙ cong (λ w → eval w ρ) p ∙ दृक्पात-सत्यम् r ρ)
             (दृक्पातः l ≟T दृक्पातः r))
       (स-प्रयत्नः Γ f (mxℕ (चराः l) (चराः r)) l r)

स-प्रयत्नः Γ f zero    l r = nothing
स-प्रयत्नः Γ f (suc k) l r = अथवा (स-ऊर्ध्वम् Γ f k l r) (स-प्रयत्नः Γ f k l r)

स-ऊर्ध्वम् Γ f k l r =
  mmap2 (आरोहः k l r)
        (सम-साधनम् Γ f (l ⟨ k ≔ ze ⟩ , r ⟨ k ≔ ze ⟩))
        (सम-व्याप्तिः Γ k l r)

षष्ठ-न्यायः : List Eq' → List नियमः
षष्ठ-न्यायः [] = []
षष्ठ-न्यायः ((l , r) ∷ es) with सम-साधनम् अनुलोम-परम्परा इन्धनम् (l , r)
... | just pf = niyama l r pf ∷ षष्ठ-न्यायः es
... | nothing = षष्ठ-न्यायः es

षष्ठ-शेषम् : List Eq' → List Eq'
षष्ठ-शेषम् [] = []
षष्ठ-शेषम् ((l , r) ∷ es) with सम-साधनम् अनुलोम-परम्परा इन्धनम् (l , r)
... | just _  = षष्ठ-शेषम् es
... | nothing = (l , r) ∷ षष्ठ-शेषम् es

षष्ठ-सिद्धिः : length (षष्ठ-न्यायः (पञ्चम-शेषम् (चतुर्थ-शेषम् (गुरु-शेषम् (अपचितम् आगमः))))) ≡ 3
षष्ठ-सिद्धिः = refl

षष्ठ-शेषः : length (षष्ठ-शेषम् (पञ्चम-शेषम् (चतुर्थ-शेषम् (गुरु-शेषम् (अपचितम् आगमः))))) ≡ 0
षष्ठ-शेषः = refl
