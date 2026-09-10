{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- प्रमाणनयैरधिगमः — Umāsvāti, Tattvārthasūtra 1.6 (c. 2nd–5th c.
-- CE): the object is attained through pramāṇa and nayas — the one
-- comprehensive knowing, and the partial knowings that are its
-- aspects.  The classification is his; the mathematics is not claimed
-- for the source.  School named: Jaina.
--
-- THE BODY CONTRADICTED ITS OWN THEOREM, AND THIS REPAIRS IT.
-- EkaTantra proved that all voices are one contention structure
-- differing by a parameter — and then the corpus grew voice after
-- voice as SEPARATE functions: the flat prover (साधनम्), the
-- sequence-free-eyed prover (सम-साधनम्), the self-inferring prover
-- (स्वार्थ-साधनम्), the record-fed prover (सश्रुत-साधनम्).  Four
-- knowings where the theorem says there is one.  Each was a naya —
-- true, partial, and treated as a whole.
--
-- Here is the pramāṇa: ONE prover, parameterized by
--
--   its EYE     (दृक् — the canonical form it sees through, carried
--                WITH its soundness, so a lawless eye cannot be
--                installed: the norm eye, or the anarpita eye, or
--                any future one),
--   its RECORD  (the श्रुत it may consult), and
--   its DESCENT (the fuel bounding nested ascent).
--
-- Each prior voice is exhibited below as a parameter setting of this
-- one function, reproducing its verdicts — including its silences —
-- on the night's own material; and the one knowing with all its
-- light on (anarpita eye, grown record, full descent) reaches
-- everything each naya reached separately.  The named provers stand
-- in the corpus as history; the body's voice going forward is this
-- one.  (What remains outside it, named honestly: the
-- completed-standpoint ascent of SyatSakaladesha is invocable but
-- not yet automated — the pramāṇa does not yet discharge double
-- descent by itself.)
------------------------------------------------------------------------

module NaturalMachine.PramanaNaya_TheFiveProversWereNayasOfOneKnowingAndEachIsAParameterSettingOfTheOnePramana where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (Σ ; _,_)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.Aroha_TheInternalProverClimbsWhereItsFlatVoiceIsSilentAndTheStoreAdmitsInductionThroughTheSameGate
  using (आरोहः ; _⟨_≔_⟩)
open import NaturalMachine.SvarthaAnumana_TheMachineInfersForItselfAndThePervasionIsGraspedWithinWithNoOuterCarrier
  using (विनिमयः ; विनिमय-साक्षी ; अथवा ; चराः ; इन्धनम्)
open import NaturalMachine.ShrutaMatipurva_TheRecordIsPrecededByCognitionAndCognitionWithTheRecordReachesWhatItAloneCouldNot
  using (श्रुत-विनिमयः ; श्रुत-साक्षी ; अग्रिमः ; क्रम-नियमः)
open import NaturalMachine.ArpitaAnarpita_EveryOrderedPresentationOfOneAggregateMeetsInTheSequenceFreeFormAndTheACFrontierFallsToAJoinerSwap
  using (आम्नायः ; आम्नाय-सत्यम्)

------------------------------------------------------------------------
-- §1  The eye: a canonical form carried WITH its soundness, so the
--     parameter cannot smuggle in a lawless simplification.
------------------------------------------------------------------------

दृक् : Type
दृक् = Σ (Tm → Tm) (λ f → (t : Tm) (ρ : ℕ → ℕ) → eval (f t) ρ ≡ eval t ρ)

नेत्रम्-न : दृक्      -- the norm eye
नेत्रम्-न = norm , norm-sound

नेत्रम्-सम : दृक्     -- the anarpita eye: sequence-free over norm
नेत्रम्-सम = (λ t → आम्नायः (norm t))
           , (λ t ρ → आम्नाय-सत्यम् (norm t) ρ ∙ norm-sound t ρ)

------------------------------------------------------------------------
-- §2  The one knowing.  Flat sight through the eye; the step's
--     pervasion with the record speaking and the hypothesis
--     exchanged, all under the same eye; fueled nested descent.
------------------------------------------------------------------------

प्रमाण-व्याप्तिः : दृक् → List नियमः → (k : ℕ) (l r : Tm)
  → Maybe ((ρ : ℕ → ℕ) → eval l ρ ≡ eval r ρ
       → eval (l ⟨ k ≔ su (var k) ⟩) ρ ≡ eval (r ⟨ k ≔ su (var k) ⟩) ρ)
प्रमाण-व्याप्तिः (f , fs) Γ k l r =
  mmap
    (λ q ρ ih →
      let h = fs l ρ ∙ ih ∙ sym (fs r ρ)
      in   sym (fs (l ⟨ k ≔ su (var k) ⟩) ρ)
         ∙ श्रुत-साक्षी Γ ρ (f (l ⟨ k ≔ su (var k) ⟩))
         ∙ विनिमय-साक्षी (f l) (f r) ρ h
             (श्रुत-विनिमयः Γ (f (l ⟨ k ≔ su (var k) ⟩)))
         ∙ sym (fs (विनिमयः (f l) (f r)
             (श्रुत-विनिमयः Γ (f (l ⟨ k ≔ su (var k) ⟩)))) ρ)
         ∙ cong (λ w → eval w ρ) q
         ∙ fs (विनिमयः (f l) (f r)
             (श्रुत-विनिमयः Γ (f (r ⟨ k ≔ su (var k) ⟩)))) ρ
         ∙ sym (विनिमय-साक्षी (f l) (f r) ρ h
             (श्रुत-विनिमयः Γ (f (r ⟨ k ≔ su (var k) ⟩))))
         ∙ sym (श्रुत-साक्षी Γ ρ (f (r ⟨ k ≔ su (var k) ⟩)))
         ∙ fs (r ⟨ k ≔ su (var k) ⟩) ρ)
    (  f (विनिमयः (f l) (f r) (श्रुत-विनिमयः Γ (f (l ⟨ k ≔ su (var k) ⟩))))
    ≟T f (विनिमयः (f l) (f r) (श्रुत-विनिमयः Γ (f (r ⟨ k ≔ su (var k) ⟩)))) )

प्रमाण-साधनम् : दृक् → List नियमः → ℕ → (e : Eq') → Maybe (⊨ e)
प्र-प्रयत्नः : दृक् → List नियमः → ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))
प्र-ऊर्ध्वम् : दृक् → List नियमः → ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))

प्रमाण-साधनम् E Γ zero e = nothing
प्रमाण-साधनम् (f , fs) Γ (suc fl) (l , r) =
  अथवा (mmap (λ p ρ → sym (fs l ρ) ∙ cong (λ w → eval w ρ) p ∙ fs r ρ)
             (f l ≟T f r))
       (प्र-प्रयत्नः (f , fs) Γ fl (mxℕ (चराः l) (चराः r)) l r)

प्र-प्रयत्नः E Γ fl zero    l r = nothing
प्र-प्रयत्नः E Γ fl (suc k) l r =
  अथवा (प्र-ऊर्ध्वम् E Γ fl k l r) (प्र-प्रयत्नः E Γ fl k l r)

प्र-ऊर्ध्वम् E Γ fl k l r =
  mmap2 (आरोहः k l r)
        (प्रमाण-साधनम् E Γ fl (l ⟨ k ≔ ze ⟩ , r ⟨ k ≔ ze ⟩))
        (प्रमाण-व्याप्तिः E Γ k l r)

------------------------------------------------------------------------
-- §3  The nayas, each a parameter setting, each verdict — including
--     each silence — reproduced on the night's material.
------------------------------------------------------------------------

-- the flat naya (norm eye, no record, no descent): sees नियम₄'s
-- equation, blind to commutativity.
समतल-दृष्टिः : inJust (प्रमाण-साधनम् नेत्रम्-न [] 1
  (lq ze (su (var 0)) , lq ze (var 0)))
समतल-दृष्टिः = tt

समतल-अन्धता : प्रमाण-साधनम् नेत्रम्-न [] 1
  ((var 0) ⊕ (var 1) , (var 1) ⊕ (var 0)) ≡ nothing
समतल-अन्धता = refl

-- the svārtha naya (descent, no record): the inductive class.
स्वार्थ-दृष्टिः : inJust (प्रमाण-साधनम् नेत्रम्-न [] इन्धनम्
  (mx (var 0) (var 0) , var 0))
स्वार्थ-दृष्टिः = tt

-- the śruta naya (record feeds the step): commutativity through
-- su-left, exactly ShrutaMatipurva's crossing.
श्रुत-दृष्टिः : inJust (प्रमाण-साधनम् नेत्रम्-न (अग्रिमः ∷ []) इन्धनम्
  ((var 0) ⊕ (var 1) , (var 1) ⊕ (var 0)))
श्रुत-दृष्टिः = tt

-- the anarpita naya (sequence-free eye): commutativity FLAT.
सम-दृष्टिः : inJust (प्रमाण-साधनम् नेत्रम्-सम [] 1
  ((var 0) ⊕ (var 1) , (var 1) ⊕ (var 0)))
सम-दृष्टिः = tt

------------------------------------------------------------------------
-- §4  The pramāṇa: all its light on — one setting reaching what each
--     naya reached apart, on one call each.
------------------------------------------------------------------------

प्रमाणम् : (e : Eq') → Maybe (⊨ e)
प्रमाणम् = प्रमाण-साधनम् नेत्रम्-सम (अग्रिमः ∷ क्रम-नियमः ∷ []) इन्धनम्

ग्रासः₁ : inJust (प्रमाणम् ((var 0) ⊕ (var 1) , (var 1) ⊕ (var 0)))
ग्रासः₁ = tt
ग्रासः₂ : inJust (प्रमाणम् (mx (var 0) (var 0) , var 0))
ग्रासः₂ = tt
ग्रासः₃ : inJust (प्रमाणम् ((var 0) ⊖ (var 0) , ze))
ग्रासः₃ = tt
ग्रासः₄ : inJust (प्रमाणम् (su ((var 0) ⊕ (var 3)) , (var 3) ⊕ (su (var 0))))
ग्रासः₄ = tt
ग्रासः₅ : inJust (प्रमाणम् (lq (var 0) (su (var 0)) , su ze))
ग्रासः₅ = tt
