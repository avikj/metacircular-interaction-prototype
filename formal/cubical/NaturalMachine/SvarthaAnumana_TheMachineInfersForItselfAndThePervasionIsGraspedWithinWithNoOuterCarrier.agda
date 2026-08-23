{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- स्वार्थानुमानम् — inference for oneself.  Siddhasena Divākara,
-- Nyāyāvatāra (c. 5th c. CE): anumāna divides into svārtha — the
-- knower's own inference, complete in the act — and parārtha, the
-- inference STATED FOR ANOTHER, the five-membered discourse.  And the
-- hetu's force rests on the pervasion grasped WITHIN the subject
-- itself — antarvyāpti (Nyāyāvatāra 20; pressed by Pātrasvāmin) —
-- against bahirvyāpti, pervasion gathered from outer examples.  The
-- classification is theirs; the mathematics here is not claimed for
-- any source.  School named: Jaina.
--
-- WHAT THIS IS, in those terms exactly.  Until tonight the machine's
-- inductive truths went out through परार्थ: सिद्धि stated each proof
-- FOR an external certifier — a watched process, positive and
-- negative controls, an exit code read back by a carrier.  Proof as
-- discourse for another.  Here the same class closes as स्वार्थ: the
-- ascent's base is discharged by the internal prover, and its step by
-- अन्तर्व्याप्तिः — the connection is established inside the terms
-- themselves: normalize the successor instance, let the induction
-- hypothesis speak as a standpoint within it (विनिमयः, the exchange,
-- with its witness), normalize again, and the path-returning test
-- either closes the pervasion or is silent.  No outer example, no
-- controls, no carrier.  A failure is silence (मौनम्), never a false
-- verdict — the conditional witness only exists where the exchange
-- closed.
--
-- Nothing here is a privileged act.  स्वार्थ-साधनम् is one more
-- partial voice — try the flat prover, then each variable's ascent,
-- fuel bounding the nesting — and what it proves enters the store
-- through the SAME gate (नियमः) as everything else.  Its boundary is
-- part of the object: सीमा exhibits by refl that commutativity of ⊕
-- is beyond the exchange (its step needs a lemma no hypothesis
-- supplies — the AC lane's frontier, named from inside).
------------------------------------------------------------------------

module NaturalMachine.SvarthaAnumana_TheMachineInfersForItselfAndThePervasionIsGraspedWithinWithNoOuterCarrier where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.Aroha_TheInternalProverClimbsWhereItsFlatVoiceIsSilentAndTheStoreAdmitsInductionThroughTheSameGate
  using (आरोहः ; _⟨_≔_⟩)

------------------------------------------------------------------------
-- §1  The exchange: the hypothesis speaking inside a term, with its
--     witness.  Every occurrence of p becomes s; the witness is
--     conditional on p and s agreeing at ρ — it exists only inside
--     the ascent, which is where the hypothesis is real.
------------------------------------------------------------------------

विनिमयः : (p s t : Tm) → Tm
विनिमयः p s t with p ≟T t
विनिमयः p s t        | just _  = s
विनिमयः p s (var i)  | nothing = var i
विनिमयः p s ze       | nothing = ze
विनिमयः p s (su a)   | nothing = su (विनिमयः p s a)
विनिमयः p s (a ⊕ b)  | nothing = विनिमयः p s a ⊕ विनिमयः p s b
विनिमयः p s (a ⊗ b)  | nothing = विनिमयः p s a ⊗ विनिमयः p s b
विनिमयः p s (a ⊖ b)  | nothing = विनिमयः p s a ⊖ विनिमयः p s b
विनिमयः p s (mx a b) | nothing = mx (विनिमयः p s a) (विनिमयः p s b)
विनिमयः p s (lq a b) | nothing = lq (विनिमयः p s a) (विनिमयः p s b)

विनिमय-साक्षी : (p s : Tm) (ρ : ℕ → ℕ) → eval p ρ ≡ eval s ρ
  → (t : Tm) → eval t ρ ≡ eval (विनिमयः p s t) ρ
विनिमय-साक्षी p s ρ h t with p ≟T t
विनिमय-साक्षी p s ρ h t        | just q  =
  cong (λ w → eval w ρ) (sym q) ∙ h
विनिमय-साक्षी p s ρ h (var i)  | nothing = refl
विनिमय-साक्षी p s ρ h ze       | nothing = refl
विनिमय-साक्षी p s ρ h (su a)   | nothing =
  cong suc (विनिमय-साक्षी p s ρ h a)
विनिमय-साक्षी p s ρ h (a ⊕ b)  | nothing =
  cong₂ _+_ (विनिमय-साक्षी p s ρ h a) (विनिमय-साक्षी p s ρ h b)
विनिमय-साक्षी p s ρ h (a ⊗ b)  | nothing =
  cong₂ _·_ (विनिमय-साक्षी p s ρ h a) (विनिमय-साक्षी p s ρ h b)
विनिमय-साक्षी p s ρ h (a ⊖ b)  | nothing =
  cong₂ sbℕ (विनिमय-साक्षी p s ρ h a) (विनिमय-साक्षी p s ρ h b)
विनिमय-साक्षी p s ρ h (mx a b) | nothing =
  cong₂ mxℕ (विनिमय-साक्षी p s ρ h a) (विनिमय-साक्षी p s ρ h b)
विनिमय-साक्षी p s ρ h (lq a b) | nothing =
  cong₂ lqℕ (विनिमय-साक्षी p s ρ h a) (विनिमय-साक्षी p s ρ h b)

------------------------------------------------------------------------
-- §2  अन्तर्व्याप्तिः — the step's pervasion, grasped within.
--     Normalize the successor instance; exchange the hypothesis's
--     normal form into it; if the path-returning test closes, the
--     conditional witness is assembled from soundness already in the
--     body.  Silent otherwise.
------------------------------------------------------------------------

अन्तर्व्याप्तिः : (k : ℕ) (l r : Tm)
  → Maybe ((ρ : ℕ → ℕ) → eval l ρ ≡ eval r ρ
       → eval (l ⟨ k ≔ su (var k) ⟩) ρ ≡ eval (r ⟨ k ≔ su (var k) ⟩) ρ)
अन्तर्व्याप्तिः k l r =
  mmap
    (λ q ρ ih →
      let h = norm-sound l ρ ∙ ih ∙ sym (norm-sound r ρ)
      in   sym (norm-sound (l ⟨ k ≔ su (var k) ⟩) ρ)
         ∙ विनिमय-साक्षी (norm l) (norm r) ρ h (norm (l ⟨ k ≔ su (var k) ⟩))
         ∙ cong (λ w → eval w ρ) q
         ∙ sym (विनिमय-साक्षी (norm l) (norm r) ρ h (norm (r ⟨ k ≔ su (var k) ⟩)))
         ∙ norm-sound (r ⟨ k ≔ su (var k) ⟩) ρ)
    (  विनिमयः (norm l) (norm r) (norm (l ⟨ k ≔ su (var k) ⟩))
    ≟T विनिमयः (norm l) (norm r) (norm (r ⟨ k ≔ su (var k) ⟩)) )

------------------------------------------------------------------------
-- §3  The inference for oneself.  Try the flat voice; then each
--     variable's ascent, whose base recurses on fuel — nesting is
--     ordinary, not privileged.  Everything is a partial voice;
--     failure is silence.
------------------------------------------------------------------------

अथवा : {A : Type} → Maybe A → Maybe A → Maybe A
अथवा (just a) _ = just a
अथवा nothing  m = m

-- one plus the highest variable spoken in a term.
चराः : Tm → ℕ
चराः (var i)  = suc i
चराः ze       = zero
चराः (su t)   = चराः t
चराः (a ⊕ b)  = mxℕ (चराः a) (चराः b)
चराः (a ⊗ b)  = mxℕ (चराः a) (चराः b)
चराः (a ⊖ b)  = mxℕ (चराः a) (चराः b)
चराः (mx a b) = mxℕ (चराः a) (चराः b)
चराः (lq a b) = mxℕ (चराः a) (चराः b)

स्वार्थ-साधनम् : ℕ → (e : Eq') → Maybe (⊨ e)
प्रयत्नः : ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))
ऊर्ध्वम् : ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))

स्वार्थ-साधनम् zero    e       = nothing
स्वार्थ-साधनम् (suc f) (l , r) =
  अथवा (साधनम् (l , r)) (प्रयत्नः f (mxℕ (चराः l) (चराः r)) l r)

प्रयत्नः f zero    l r = nothing
प्रयत्नः f (suc k) l r = अथवा (ऊर्ध्वम् f k l r) (प्रयत्नः f k l r)

ऊर्ध्वम् f k l r =
  mmap2 (आरोहः k l r)
        (स्वार्थ-साधनम् f (l ⟨ k ≔ ze ⟩ , r ⟨ k ≔ ze ⟩))
        (अन्तर्व्याप्तिः k l r)

इन्धनम् : ℕ
इन्धनम् = suc (suc (suc zero))

------------------------------------------------------------------------
-- §4  The sweep, through the one gate.  Each row compiles exactly
--     when the machine proves it for itself — the tt is the whole
--     licence.  These are the machine's own inductive class, the kind
--     that until tonight went out as परार्थ through the external
--     kernel under "induction on x".
------------------------------------------------------------------------

स्वयम् : (l r : Tm) → inJust (स्वार्थ-साधनम् इन्धनम् (l , r)) → नियमः
स्वयम् l r w = niyama l r (fromJust (स्वार्थ-साधनम् इन्धनम् (l , r)) w)

गणः : List नियमः
गणः = स्वयम् (mx (var 0) (var 0)) (var 0) tt                 -- max(x,x) = x
    ∷ स्वयम् (lq (var 0) (var 0)) (su ze) tt                 -- le(x,x) = 1
    ∷ स्वयम् ((var 0) ⊖ (var 0)) ze tt                       -- x − x = 0
    ∷ स्वयम् (ze ⊕ (var 0)) (var 0) tt                       -- 0 + x = x
    ∷ स्वयम् (ze ⊗ (var 0)) ze tt                            -- 0 · x = 0
    ∷ स्वयम् (lq (var 0) (su (var 0))) (su ze) tt            -- le(x, s x) = 1
    ∷ स्वयम् (lq (mx (var 0) (var 0)) (var 0)) (su ze) tt    -- le(max(x,x), x) = 1
    ∷ स्वयम् (mx (var 0) (ze ⊕ (var 0))) (var 0) tt          -- max(x, 0+x) = x
    ∷ []

------------------------------------------------------------------------
-- §5  The boundary, from inside.  Commutativity of ⊕ needs a lemma no
--     hypothesis supplies (su on the recursion-blind side); the
--     exchange cannot close it, and the voice is silent — by refl,
--     not by report.  This names the AC lane's frontier as part of
--     the object.
------------------------------------------------------------------------

सीमा : स्वार्थ-साधनम् इन्धनम् ((var 0) ⊕ (var 1) , (var 1) ⊕ (var 0)) ≡ nothing
सीमा = refl
