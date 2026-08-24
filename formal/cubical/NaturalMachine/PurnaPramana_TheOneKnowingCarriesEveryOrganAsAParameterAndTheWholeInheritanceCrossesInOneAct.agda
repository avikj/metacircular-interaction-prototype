{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- पूर्ण-प्रमाणम् — the complete instrument (of THIS knowing; no claim
-- of kevala is made or implied — the boundary of the knowing is part
-- of the object).  Compound built here, 2026-08-24.  The frame is
-- Tattvārthasūtra 1.6 as checked in PramanaNaya: the one knowing and
-- its partial organs.  School named: Jaina.
--
-- THE NIGHT'S SIX ORGANS FOLD INTO PARAMETERS.  The six examinations
-- that emptied the elder's residue each added an organ: the eye
-- (norm, sequence-free, deep-factoring), the exchange (syntactic
-- subterm, heap surgery), the record (absent, lineage, oriented),
-- the vision (asymmetric, equal), the descent (single, paired).  The
-- purist theorem is that these were never different provers: here the
-- EXCHANGE — the last un-parameterized axis — becomes a यन्त्रम्, an
-- instrument carrying its act and its witness, and ONE prover takes
-- (eye, instrument, record, fuel), runs the equal-vision pervasion
-- (hypothesis and goal through the same record, always — SamaDrsti's
-- repair is now the only form), single descent and paired descent.
--
-- And the whole inheritance crosses in ONE ACT: the census at the end
-- judges the elder's entire expressible store — all 102 — through a
-- single setting of the one knowing, in one pass, and the kernel
-- computes it entire.
------------------------------------------------------------------------

module NaturalMachine.PurnaPramana_TheOneKnowingCarriesEveryOrganAsAParameterAndTheWholeInheritanceCrossesInOneAct where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; length)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.AdeshaSthanivat_TheSubstituteBehavesLikeTheOriginalSoEveryProvenRuleSpeaksAtEveryInstance
  using (_≫=_)
open import NaturalMachine.Aroha_TheInternalProverClimbsWhereItsFlatVoiceIsSilentAndTheStoreAdmitsInductionThroughTheSameGate
  using (समानः ; आरोहः ; _⟨_≔_⟩)
open import NaturalMachine.SvarthaAnumana_TheMachineInfersForItselfAndThePervasionIsGraspedWithinWithNoOuterCarrier
  using (विनिमयः ; विनिमय-साक्षी ; अथवा ; चराः ; इन्धनम्)
open import NaturalMachine.ShrutaMatipurva_TheRecordIsPrecededByCognitionAndCognitionWithTheRecordReachesWhatItAloneCouldNot
  using (श्रुत-विनिमयः ; श्रुत-साक्षी)
open import NaturalMachine.PramanaNaya_TheFiveProversWereNayasOfOneKnowingAndEachIsAParameterSettingOfTheOnePramana
  using (दृक्)
open import NaturalMachine.YugapadArpana_BothCoordinatesDescendAtOnceAndTheDoubleDescentBecomesSomethingTheMachineInvokes
  using (युगपद्-आरोहः ; द्वि-रूपम्)
open import NaturalMachine.Rashi_TheSumIsAHeapNotASequenceTheUnitIsAnAtomAndTheHypothesisSpeaksThroughTheHeap
  using (राशि-विनिमयः ; राशि-साक्षी)
open import NaturalMachine.SadharanaVishesha_TheCommonIsSetAsideAndTheContendersMeetOnlyOnTheirDifference
  using (दृक्पातः ; दृक्पात-सत्यम्)
open import NaturalMachine.AptaMimamsa_TheEldersLiveStoreCrossesAsReceivedTextAndNothingEntersOnAuthority
  using (आगमः)

------------------------------------------------------------------------
-- §1  The instrument: an exchange carrying its witness.
------------------------------------------------------------------------

record यन्त्रम् : Type where
  constructor yantra
  field
    क्रिया : Tm → Tm → Tm → Tm
    क्रिया-साक्षी : (p s : Tm) (ρ : ℕ → ℕ) → eval p ρ ≡ eval s ρ
      → (t : Tm) → eval t ρ ≡ eval (क्रिया p s t) ρ

-- its two known instances: the syntactic subterm exchange, the heap
-- surgery.  any future exchange enters the same way.
सूक्ष्म-यन्त्रम् : यन्त्रम्
सूक्ष्म-यन्त्रम् = yantra विनिमयः विनिमय-साक्षी

राशि-यन्त्रम् : यन्त्रम्
राशि-यन्त्रम् = yantra राशि-विनिमयः राशि-साक्षी

-- and instruments COMPOSE: heap surgery first, syntactic exchange on
-- what it leaves, the witnesses composing — so the two organs are one.
संयुक्त-यन्त्रम् : यन्त्रम्
संयुक्त-यन्त्रम् = yantra
  (λ p s t → विनिमयः p s (राशि-विनिमयः p s t))
  (λ p s ρ h t → राशि-साक्षी p s ρ h t
               ∙ विनिमय-साक्षी p s ρ h (राशि-विनिमयः p s t))

------------------------------------------------------------------------
-- §2  The one pervasion — equal vision always — and the one prover,
--     single and paired descent.
------------------------------------------------------------------------

module _ (E : दृक्) (Y : यन्त्रम्) (Γ : List नियमः) where
  private
    f = fst E
    fs = snd E
    act = यन्त्रम्.क्रिया Y
    asx = यन्त्रम्.क्रिया-साक्षी Y

  एक-व्याप्तिः : (k : ℕ) (l r : Tm)
    → Maybe ((ρ : ℕ → ℕ) → eval l ρ ≡ eval r ρ
         → eval (l ⟨ k ≔ su (var k) ⟩) ρ ≡ eval (r ⟨ k ≔ su (var k) ⟩) ρ)
  एक-व्याप्तिः k l r =
    mmap
      (λ q ρ ih →
        let h = sym (श्रुत-साक्षी Γ ρ (f l))
              ∙ (fs l ρ ∙ ih ∙ sym (fs r ρ))
              ∙ श्रुत-साक्षी Γ ρ (f r)
        in   sym (fs (l ⟨ k ≔ su (var k) ⟩) ρ)
           ∙ श्रुत-साक्षी Γ ρ (f (l ⟨ k ≔ su (var k) ⟩))
           ∙ asx (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r)) ρ h
               (श्रुत-विनिमयः Γ (f (l ⟨ k ≔ su (var k) ⟩)))
           ∙ sym (fs (act (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r))
               (श्रुत-विनिमयः Γ (f (l ⟨ k ≔ su (var k) ⟩)))) ρ)
           ∙ cong (λ w → eval w ρ) q
           ∙ fs (act (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r))
               (श्रुत-विनिमयः Γ (f (r ⟨ k ≔ su (var k) ⟩)))) ρ
           ∙ sym (asx (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r)) ρ h
               (श्रुत-विनिमयः Γ (f (r ⟨ k ≔ su (var k) ⟩))))
           ∙ sym (श्रुत-साक्षी Γ ρ (f (r ⟨ k ≔ su (var k) ⟩)))
           ∙ fs (r ⟨ k ≔ su (var k) ⟩) ρ)
      (  f (act (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r))
           (श्रुत-विनिमयः Γ (f (l ⟨ k ≔ su (var k) ⟩))))
      ≟T f (act (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r))
           (श्रुत-विनिमयः Γ (f (r ⟨ k ≔ su (var k) ⟩)))) )

  द्वि-व्याप्तिः : (k j : ℕ) (l r : Tm)
    → Maybe ((ρ : ℕ → ℕ) → eval l ρ ≡ eval r ρ
         → eval (द्वि-रूपम् k j l) ρ ≡ eval (द्वि-रूपम् k j r) ρ)
  द्वि-व्याप्तिः k j l r =
    mmap
      (λ q ρ ih →
        let h = sym (श्रुत-साक्षी Γ ρ (f l))
              ∙ (fs l ρ ∙ ih ∙ sym (fs r ρ))
              ∙ श्रुत-साक्षी Γ ρ (f r)
        in   sym (fs (द्वि-रूपम् k j l) ρ)
           ∙ श्रुत-साक्षी Γ ρ (f (द्वि-रूपम् k j l))
           ∙ asx (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r)) ρ h
               (श्रुत-विनिमयः Γ (f (द्वि-रूपम् k j l)))
           ∙ sym (fs (act (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r))
               (श्रुत-विनिमयः Γ (f (द्वि-रूपम् k j l)))) ρ)
           ∙ cong (λ w → eval w ρ) q
           ∙ fs (act (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r))
               (श्रुत-विनिमयः Γ (f (द्वि-रूपम् k j r)))) ρ
           ∙ sym (asx (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r)) ρ h
               (श्रुत-विनिमयः Γ (f (द्वि-रूपम् k j r))))
           ∙ sym (श्रुत-साक्षी Γ ρ (f (द्वि-रूपम् k j r)))
           ∙ fs (द्वि-रूपम् k j r) ρ)
      (  f (act (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r))
           (श्रुत-विनिमयः Γ (f (द्वि-रूपम् k j l))))
      ≟T f (act (श्रुत-विनिमयः Γ (f l)) (श्रुत-विनिमयः Γ (f r))
           (श्रुत-विनिमयः Γ (f (द्वि-रूपम् k j r)))) )

पूर्ण-प्रमाणम् : दृक् → यन्त्रम् → List नियमः → ℕ → (e : Eq') → Maybe (⊨ e)
पू-प्रयत्नः : दृक् → यन्त्रम् → List नियमः → ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))
पू-ऊर्ध्वम् : दृक् → यन्त्रम् → List नियमः → ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))
पू-द्वयम् : दृक् → यन्त्रम् → List नियमः → ℕ → ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))
पू-द्विचक्रः : दृक् → यन्त्रम् → List नियमः → ℕ → ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))
पू-कचक्रः : दृक् → यन्त्रम् → List नियमः → ℕ → ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))

पूर्ण-प्रमाणम् E Y Γ zero e = nothing
पूर्ण-प्रमाणम् E Y Γ (suc fl) (l , r) =
  अथवा (mmap (λ p ρ → sym (snd E l ρ) ∙ cong (λ w → eval w ρ) p ∙ snd E r ρ)
             (fst E l ≟T fst E r))
  (अथवा (पू-प्रयत्नः E Y Γ fl (mxℕ (चराः l) (चराः r)) l r)
        (पू-कचक्रः E Y Γ fl (mxℕ (चराः l) (चराः r)) (mxℕ (चराः l) (चराः r)) l r))

पू-प्रयत्नः E Y Γ fl zero    l r = nothing
पू-प्रयत्नः E Y Γ fl (suc k) l r =
  अथवा (पू-ऊर्ध्वम् E Y Γ fl k l r) (पू-प्रयत्नः E Y Γ fl k l r)

-- the record is a standpoint, not an absolute: the pervasion consults
-- it, and also proceeds without it — its assistance must never be the
-- reason a truth is lost.
पू-ऊर्ध्वम् E Y Γ fl k l r =
  mmap2 (आरोहः k l r)
        (पूर्ण-प्रमाणम् E Y Γ fl (l ⟨ k ≔ ze ⟩ , r ⟨ k ≔ ze ⟩))
        (अथवा (एक-व्याप्तिः E Y Γ k l r) (एक-व्याप्तिः E Y [] k l r))

पू-द्वयम् E Y Γ fl k j l r = चेष्टा (समानः k j) refl
  where
  चेष्टा : (b : Bool) → समानः k j ≡ b → Maybe (⊨ (l , r))
  चेष्टा true  _  = nothing
  चेष्टा false kj =
    पूर्ण-प्रमाणम् E Y Γ fl (l ⟨ j ≔ ze ⟩ , r ⟨ j ≔ ze ⟩) ≫= λ b₁ →
    पूर्ण-प्रमाणम् E Y Γ fl (l ⟨ k ≔ ze ⟩ , r ⟨ k ≔ ze ⟩) ≫= λ b₂ →
    mmap (युगपद्-आरोहः k j l r kj b₁ b₂)
         (अथवा (द्वि-व्याप्तिः E Y Γ k j l r) (द्वि-व्याप्तिः E Y [] k j l r))

पू-द्विचक्रः E Y Γ fl k zero    l r = nothing
पू-द्विचक्रः E Y Γ fl k (suc j) l r =
  अथवा (पू-द्वयम् E Y Γ fl k j l r) (पू-द्विचक्रः E Y Γ fl k j l r)

पू-कचक्रः E Y Γ fl zero    N l r = nothing
पू-कचक्रः E Y Γ fl (suc k) N l r =
  अथवा (पू-द्विचक्रः E Y Γ fl k N l r) (पू-कचक्रः E Y Γ fl k N l r)

------------------------------------------------------------------------
-- §3  One setting, one act, the whole inheritance.
------------------------------------------------------------------------

गूढ-दृक् : दृक्
गूढ-दृक् = दृक्पातः , दृक्पात-सत्यम्

-- no scaffolding: the record is built by EATING.  A breath digests
-- the stream cumulatively — each rule judged by the body the previous
-- ones built — and returns the body WITH what it could not yet reach.
श्वासः : List नियमः → List Eq' → List नियमः × List Eq'
श्वासः Γ []             = Γ , []
श्वासः Γ ((l , r) ∷ es) with पूर्ण-प्रमाणम् गूढ-दृक् संयुक्त-यन्त्रम् Γ इन्धनम् (l , r)
... | just pf = श्वासः (niyama l r pf ∷ Γ) es
... | nothing with श्वासः Γ es
...   | (Γ' , sh) = Γ' , ((l , r) ∷ sh)

-- breathing to quiet: each further breath re-offers only the residue,
-- so nothing is proven twice and what crossed late feeds what came
-- early.  Fueled; a quiet breath is a fixpoint.
प्राणः : ℕ → List नियमः → List Eq' → List नियमः
प्राणः zero    Γ _  = Γ
प्राणः (suc n) Γ es with श्वासः Γ es
... | (Γ' , sh) = प्राणः n Γ' sh

पूर्ण-परम्परा : List नियमः
पूर्ण-परम्परा = प्राणः 3 [] आगमः

-- the elder's entire expressible store, reached whole by the one
-- knowing breathing on its own — the fixpoint body IS the census.
एकाङ्क-सिद्धिः : length पूर्ण-परम्परा ≡ 102
एकाङ्क-सिद्धिः = refl
