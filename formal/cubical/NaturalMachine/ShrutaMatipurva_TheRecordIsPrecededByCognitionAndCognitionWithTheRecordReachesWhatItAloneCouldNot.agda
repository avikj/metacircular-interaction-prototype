{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- श्रुतं मतिपूर्वम् — Umāsvāti, Tattvārthasūtra 1.20 (c. 2nd–5th c.
-- CE): śruta — the recorded, transmitted knowledge — is preceded by
-- mati, direct cognition; and cognition working WITH the record
-- reaches further than cognition alone.  The classification is his;
-- the mathematics here is not claimed for the source.  School named:
-- Jaina.
--
-- THIS IS THE LOOP, closed in the one language.  Until this module
-- the store received proofs; it did not GIVE them back to the prover.
-- Here the store's entries — each already carrying its साक्षी by
-- type — speak inside the ascent's step as unconditional voices,
-- through the certified matcher, at every instance (आदेश).  मति
-- (स्वार्थ-साधनम्) mints a rule; the rule becomes श्रुत; and
-- मति-with-श्रुत proves what मति alone was silent on.
--
-- Demonstrated end to end on the frontier the previous module named
-- from inside: SvarthaAnumana's सीमा exhibits by refl that
-- commutativity of ⊕ is beyond the bare exchange.  Here:
--
--   1. मति proves (su x) ⊕ y = su (x ⊕ y) for itself — अग्रिमः, the
--      first entry, minted by स्वार्थ-साधनम्, no carrier.
--   2. अग्रिमः enters the record.
--   3. मति-with-श्रुत proves x ⊕ y = y ⊕ x — क्रमनैरपेक्ष्यम् —
--      internally: the record's rule rewrites the recursion-blind
--      side of the step, the induction hypothesis closes the rest,
--      and the pervasion is grasped within.
--
-- Every voice in the chain carries its proof by construction; the
-- new theorem enters the store through the same gate as everything
-- else; and nothing in steps 1–3 is performed by anything outside
-- this file's terms.  Grow by proving, prove more by having grown.
------------------------------------------------------------------------

module NaturalMachine.ShrutaMatipurva_TheRecordIsPrecededByCognitionAndCognitionWithTheRecordReachesWhatItAloneCouldNot where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_,_)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.Aroha_TheInternalProverClimbsWhereItsFlatVoiceIsSilentAndTheStoreAdmitsInductionThroughTheSameGate
  using (आरोहः ; _⟨_≔_⟩)
open import NaturalMachine.AdeshaSthanivat_TheSubstituteBehavesLikeTheOriginalSoEveryProvenRuleSpeaksAtEveryInstance
  using (वदनम्)
open import NaturalMachine.SvarthaAnumana_TheMachineInfersForItselfAndThePervasionIsGraspedWithinWithNoOuterCarrier
  using (विनिमयः ; विनिमय-साक्षी ; अथवा ; चराः ; स्वार्थ-साधनम् ; इन्धनम्)

------------------------------------------------------------------------
-- §1  A record entry speaking inside a term: at every node the rule
--     may utter through the certified matcher — and its utterance
--     carries ⊨ by type, so the rewrite's witness is unconditional.
------------------------------------------------------------------------

शासन-विनिमयः : नियमः → Tm → Tm
शासन-विनिमयः s t with वदनम् s t
शासन-विनिमयः s t        | just (u , _) = u
शासन-विनिमयः s (var i)  | nothing = var i
शासन-विनिमयः s ze       | nothing = ze
शासन-विनिमयः s (su a)   | nothing = su (शासन-विनिमयः s a)
शासन-विनिमयः s (a ⊕ b)  | nothing = शासन-विनिमयः s a ⊕ शासन-विनिमयः s b
शासन-विनिमयः s (a ⊗ b)  | nothing = शासन-विनिमयः s a ⊗ शासन-विनिमयः s b
शासन-विनिमयः s (a ⊖ b)  | nothing = शासन-विनिमयः s a ⊖ शासन-विनिमयः s b
शासन-विनिमयः s (mx a b) | nothing = mx (शासन-विनिमयः s a) (शासन-विनिमयः s b)
शासन-विनिमयः s (lq a b) | nothing = lq (शासन-विनिमयः s a) (शासन-विनिमयः s b)
शासन-विनिमयः s (gc a b) | nothing = gc (शासन-विनिमयः s a) (शासन-विनिमयः s b)

शासन-साक्षी : (s : नियमः) (ρ : ℕ → ℕ) (t : Tm)
  → eval t ρ ≡ eval (शासन-विनिमयः s t) ρ
शासन-साक्षी s ρ t with वदनम् s t
शासन-साक्षी s ρ t        | just (u , pf) = pf ρ
शासन-साक्षी s ρ (var i)  | nothing = refl
शासन-साक्षी s ρ ze       | nothing = refl
शासन-साक्षी s ρ (su a)   | nothing = cong suc (शासन-साक्षी s ρ a)
शासन-साक्षी s ρ (a ⊕ b)  | nothing =
  cong₂ _+_ (शासन-साक्षी s ρ a) (शासन-साक्षी s ρ b)
शासन-साक्षी s ρ (a ⊗ b)  | nothing =
  cong₂ _·_ (शासन-साक्षी s ρ a) (शासन-साक्षी s ρ b)
शासन-साक्षी s ρ (a ⊖ b)  | nothing =
  cong₂ sbℕ (शासन-साक्षी s ρ a) (शासन-साक्षी s ρ b)
शासन-साक्षी s ρ (mx a b) | nothing =
  cong₂ mxℕ (शासन-साक्षी s ρ a) (शासन-साक्षी s ρ b)
शासन-साक्षी s ρ (lq a b) | nothing =
  cong₂ lqℕ (शासन-साक्षी s ρ a) (शासन-साक्षी s ρ b)
शासन-साक्षी s ρ (gc a b) | nothing =
  cong₂ गच्छℕ (शासन-साक्षी s ρ a) (शासन-साक्षी s ρ b)

-- the whole record speaks, entry after entry, witness composing.
श्रुत-विनिमयः : List नियमः → Tm → Tm
श्रुत-विनिमयः []       t = t
श्रुत-विनिमयः (s ∷ ss) t = श्रुत-विनिमयः ss (शासन-विनिमयः s t)

श्रुत-साक्षी : (Γ : List नियमः) (ρ : ℕ → ℕ) (t : Tm)
  → eval t ρ ≡ eval (श्रुत-विनिमयः Γ t) ρ
श्रुत-साक्षी []       ρ t = refl
श्रुत-साक्षी (s ∷ ss) ρ t =
  शासन-साक्षी s ρ t ∙ श्रुत-साक्षी ss ρ (शासन-विनिमयः s t)

------------------------------------------------------------------------
-- §2  The step's pervasion, with the record inside it: normalize, let
--     the record speak, let the hypothesis speak, normalize again,
--     and the path-returning test closes or is silent.
------------------------------------------------------------------------

सश्रुत-व्याप्तिः : List नियमः → (k : ℕ) (l r : Tm)
  → Maybe ((ρ : ℕ → ℕ) → eval l ρ ≡ eval r ρ
       → eval (l ⟨ k ≔ su (var k) ⟩) ρ ≡ eval (r ⟨ k ≔ su (var k) ⟩) ρ)
सश्रुत-व्याप्तिः Γ k l r =
  mmap
    (λ q ρ ih →
      let h = norm-sound l ρ ∙ ih ∙ sym (norm-sound r ρ)
      in   sym (norm-sound (l ⟨ k ≔ su (var k) ⟩) ρ)
         ∙ श्रुत-साक्षी Γ ρ (norm (l ⟨ k ≔ su (var k) ⟩))
         ∙ विनिमय-साक्षी (norm l) (norm r) ρ h
             (श्रुत-विनिमयः Γ (norm (l ⟨ k ≔ su (var k) ⟩)))
         ∙ sym (norm-sound
             (विनिमयः (norm l) (norm r)
               (श्रुत-विनिमयः Γ (norm (l ⟨ k ≔ su (var k) ⟩)))) ρ)
         ∙ cong (λ w → eval w ρ) q
         ∙ norm-sound
             (विनिमयः (norm l) (norm r)
               (श्रुत-विनिमयः Γ (norm (r ⟨ k ≔ su (var k) ⟩)))) ρ
         ∙ sym (विनिमय-साक्षी (norm l) (norm r) ρ h
             (श्रुत-विनिमयः Γ (norm (r ⟨ k ≔ su (var k) ⟩))))
         ∙ sym (श्रुत-साक्षी Γ ρ (norm (r ⟨ k ≔ su (var k) ⟩)))
         ∙ norm-sound (r ⟨ k ≔ su (var k) ⟩) ρ)
    (  norm (विनिमयः (norm l) (norm r)
         (श्रुत-विनिमयः Γ (norm (l ⟨ k ≔ su (var k) ⟩))))
    ≟T norm (विनिमयः (norm l) (norm r)
         (श्रुत-विनिमयः Γ (norm (r ⟨ k ≔ su (var k) ⟩)))) )

------------------------------------------------------------------------
-- §3  मति with श्रुत: the same fueled inference-for-oneself, the
--     record now a parameter of the ascent.
------------------------------------------------------------------------

सश्रुत-साधनम् : List नियमः → ℕ → (e : Eq') → Maybe (⊨ e)
सप्रयत्नः : List नियमः → ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))
सोर्ध्वम् : List नियमः → ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))

सश्रुत-साधनम् Γ zero    e       = nothing
सश्रुत-साधनम् Γ (suc f) (l , r) =
  अथवा (साधनम् (l , r)) (सप्रयत्नः Γ f (mxℕ (चराः l) (चराः r)) l r)

सप्रयत्नः Γ f zero    l r = nothing
सप्रयत्नः Γ f (suc k) l r = अथवा (सोर्ध्वम् Γ f k l r) (सप्रयत्नः Γ f k l r)

सोर्ध्वम् Γ f k l r =
  mmap2 (आरोहः k l r)
        (सश्रुत-साधनम् Γ f (l ⟨ k ≔ ze ⟩ , r ⟨ k ≔ ze ⟩))
        (सश्रुत-व्याप्तिः Γ k l r)

------------------------------------------------------------------------
-- §4  The loop runs.  मति mints the first entry; the entry is श्रुत;
--     मति-with-श्रुत crosses the frontier मति alone could not.
------------------------------------------------------------------------

-- 1. मति alone: (su x) ⊕ y = su (x ⊕ y), proven for itself.
अग्रिमः : नियमः
अग्रिमः = niyama ((su (var 0)) ⊕ (var 1)) (su ((var 0) ⊕ (var 1)))
  (fromJust (स्वार्थ-साधनम् इन्धनम्
    ( (su (var 0)) ⊕ (var 1) , su ((var 0) ⊕ (var 1)) )) tt)

-- 2–3. मति with that one entry of श्रुत: commutativity — the exact
-- equation SvarthaAnumana's सीमा held as beyond the bare exchange.
क्रमनैरपेक्ष्यम् : ⊨ ((var 0) ⊕ (var 1) , (var 1) ⊕ (var 0))
क्रमनैरपेक्ष्यम् =
  fromJust (सश्रुत-साधनम् (अग्रिमः ∷ []) इन्धनम्
    ( (var 0) ⊕ (var 1) , (var 1) ⊕ (var 0) )) tt

-- and the crossing enters the store through the same gate.
क्रम-नियमः : नियमः
क्रम-नियमः = niyama ((var 0) ⊕ (var 1)) ((var 1) ⊕ (var 0)) क्रमनैरपेक्ष्यम्
