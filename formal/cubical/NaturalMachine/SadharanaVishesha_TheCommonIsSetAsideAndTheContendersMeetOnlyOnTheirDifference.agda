{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- साधारण-विशेषः — the common and the distinctive: ordinary Sanskrit,
-- compound built here, 2026-08-24; no source is claimed for the
-- mathematics.
--
-- THE HEAD OF THE SEVEN, AND WHAT IT TEACHES.  max(x+y, x) = x+y —
-- absorption — survives every equational machinery because its step
-- puts su-atoms on BOTH sides of an mx whose arguments share content.
-- The closing fact is that addition distributes over the machine's
-- maximum: (a+c) ∨ (b+c) = (a∨b)+c, proven below from the machine's
-- own clauses.  So an mx-cluster canonicalizes by SETTING ASIDE the
-- common heap of its two contenders — they meet only on their
-- difference: mx(A, B) = C ⊕ mx(A∖C, B∖C), and where one difference
-- is empty the contention itself dissolves (mx(0,B') = B').  With
-- this eye, max(x+y, x) factors to x + max(y,0) = x + y and closes
-- FLAT — and so does whatever else of the seven shared its shape.
-- The counts at the end were learned by asserting them wrong.
------------------------------------------------------------------------

module NaturalMachine.SadharanaVishesha_TheCommonIsSetAsideAndTheContendersMeetOnlyOnTheirDifference where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-suc ; +-zero ; +-assoc ; +-comm)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; length)
open import Cubical.Data.Sigma using (Σ ; _×_ ; _,_ ; fst ; snd)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.Aroha_TheInternalProverClimbsWhereItsFlatVoiceIsSilentAndTheStoreAdmitsInductionThroughTheSameGate
  using (आरोहः ; _⟨_≔_⟩)
open import NaturalMachine.SvarthaAnumana_TheMachineInfersForItselfAndThePervasionIsGraspedWithinWithNoOuterCarrier
  using (अथवा ; चराः ; इन्धनम्)
open import NaturalMachine.ShrutaMatipurva_TheRecordIsPrecededByCognitionAndCognitionWithTheRecordReachesWhatItAloneCouldNot
  using (श्रुत-विनिमयः ; श्रुत-साक्षी)
open import NaturalMachine.ArpitaAnarpita_EveryOrderedPresentationOfOneAggregateMeetsInTheSequenceFreeFormAndTheACFrontierFallsToAJoinerSwap
  using (सुम् ; सुम्-++ ; क्रमणम् ; क्रमण-सत्यम् ; पुनःरचना ; पुनःरचना-सत्यम्)
open import NaturalMachine.SyatSakaladesha_TheHypothesisCompletedWithItsStandpointIsAbsoluteAndTheDoubleDescentCloses
  using (शून्य-ज्येष्ठम्)
open import NaturalMachine.AptaMimamsa_TheEldersLiveStoreCrossesAsReceivedTextAndNothingEntersOnAuthority
  using (आगमः ; अपचितम्)
open import NaturalMachine.ShrutaParampara_TheCrossedRulesBecomeTheRecordAndTheSecondPassReachesWhatTheFirstCouldNot
  using (गुरु-शेषम्)
open import NaturalMachine.AnulomaShruta_TheRecordSpeaksWithTheGrainAndTheThirdPassCrossesFurther
  using (अनुलोम-परम्परा)
open import NaturalMachine.Rashi_TheSumIsAHeapNotASequenceTheUnitIsAnAtomAndTheHypothesisSpeaksThroughTheHeap
  using (राशिः ; राशि-सत्यम् ; निष्कासः ; राशि-विनिमयः ; राशि-साक्षी ; चतुर्थ-शेषम्)

------------------------------------------------------------------------
-- §1  Addition distributes over the machine's maximum — from its own
--     clauses.
------------------------------------------------------------------------

वितरणम् : (a b c : ℕ) → mxℕ (a + c) (b + c) ≡ mxℕ a b + c
वितरणम् a b zero =
  cong₂ mxℕ (+-zero a) (+-zero b) ∙ sym (+-zero (mxℕ a b))
वितरणम् a b (suc c) =
    cong₂ mxℕ (+-suc a c) (+-suc b c)
  ∙ cong suc (वितरणम् a b c)
  ∙ sym (+-suc (mxℕ a b) c)

------------------------------------------------------------------------
-- §2  Setting the common aside: both contenders yield their shared
--     heap, each deletion carrying its debt.
------------------------------------------------------------------------

साधारणम् : (A B : List Tm)
  → Σ (List Tm) (λ C → Σ (List Tm) (λ A' → Σ (List Tm) (λ B' →
      ((ρ : ℕ → ℕ) → सुम् A ρ ≡ सुम् C ρ + सुम् A' ρ)
    × ((ρ : ℕ → ℕ) → सुम् B ρ ≡ सुम् C ρ + सुम् B' ρ))))
साधारणम् [] B = [] , [] , B , (λ ρ → refl) , (λ ρ → refl)
साधारणम् (x ∷ A) B with निष्कासः x B
... | just yw with साधारणम् A (fst yw)
...   | (C , A' , B' , pA , pB) =
        (x ∷ C) , A' , B'
      , (λ ρ → cong (eval x ρ +_) (pA ρ)
             ∙ +-assoc (eval x ρ) (सुम् C ρ) (सुम् A' ρ))
      , (λ ρ → snd yw ρ
             ∙ cong (eval x ρ +_) (pB ρ)
             ∙ +-assoc (eval x ρ) (सुम् C ρ) (सुम् B' ρ))
साधारणम् (x ∷ A) B | nothing with साधारणम् A B
...   | (C , A' , B' , pA , pB) =
        C , (x ∷ A') , B'
      , (λ ρ → cong (eval x ρ +_) (pA ρ)
             ∙ +-assoc (eval x ρ) (सुम् C ρ) (सुम् A' ρ)
             ∙ cong (_+ सुम् A' ρ) (+-comm (eval x ρ) (सुम् C ρ))
             ∙ sym (+-assoc (सुम् C ρ) (eval x ρ) (सुम् A' ρ)))
      , pB

------------------------------------------------------------------------
-- §3  The factoring eye: mx-clusters meet on their difference; sums
--     as heaps as before.
------------------------------------------------------------------------

-- rebuild a contention from its factored parts.
मेलः : List Tm → List Tm → List Tm → Tm
मेलः C []  B' = पुनःरचना (क्रमणम् (C ++ B'))
मेलः C (a ∷ A') [] = पुनःरचना (क्रमणम् (C ++ (a ∷ A')))
मेलः C (a ∷ A') (b ∷ B') =
  पुनःरचना (क्रमणम्
    (mx (पुनःरचना (क्रमणम् (a ∷ A'))) (पुनःरचना (क्रमणम् (b ∷ B'))) ∷ C))

गूढ-आम्नायः : Tm → Tm
गूढ-आम्नायः (var i)  = var i
गूढ-आम्नायः ze       = ze
गूढ-आम्नायः (su t)   = पुनःरचना (क्रमणम् (राशिः (su (गूढ-आम्नायः t))))
गूढ-आम्नायः (a ⊕ b)  =
  पुनःरचना (क्रमणम् (राशिः (गूढ-आम्नायः a) ++ राशिः (गूढ-आम्नायः b)))
गूढ-आम्नायः (a ⊗ b)  = गूढ-आम्नायः a ⊗ गूढ-आम्नायः b
गूढ-आम्नायः (a ⊖ b)  = गूढ-आम्नायः a ⊖ गूढ-आम्नायः b
गूढ-आम्नायः (mx a b) =
  मेलः (fst s) (fst (snd s)) (fst (snd (snd s)))
  where
  s = साधारणम् (राशिः (गूढ-आम्नायः a)) (राशिः (गूढ-आम्नायः b))
गूढ-आम्नायः (lq a b) = lq (गूढ-आम्नायः a) (गूढ-आम्नायः b)

-- one reusable soundness step: a sorted rebuild of a heap sums it.
शुद्ध-सुम् : (xs : List Tm) (ρ : ℕ → ℕ)
  → eval (पुनःरचना (क्रमणम् xs)) ρ ≡ सुम् xs ρ
शुद्ध-सुम् xs ρ = पुनःरचना-सत्यम् (क्रमणम् xs) ρ ∙ क्रमण-सत्यम् xs ρ

मेल-सत्यम् : (C A' B' : List Tm) (ρ : ℕ → ℕ)
  → eval (मेलः C A' B') ρ ≡ सुम् C ρ + mxℕ (सुम् A' ρ) (सुम् B' ρ)
मेल-सत्यम् C [] B' ρ =
    शुद्ध-सुम् (C ++ B') ρ
  ∙ सुम्-++ C B' ρ
  ∙ cong (सुम् C ρ +_) (sym (शून्य-ज्येष्ठम् (सुम् B' ρ)))
मेल-सत्यम् C (a ∷ A') [] ρ =
    शुद्ध-सुम् (C ++ (a ∷ A')) ρ
  ∙ सुम्-++ C (a ∷ A') ρ
मेल-सत्यम् C (a ∷ A') (b ∷ B') ρ =
    शुद्ध-सुम् (mx (पुनःरचना (क्रमणम् (a ∷ A'))) (पुनःरचना (क्रमणम् (b ∷ B'))) ∷ C) ρ
  ∙ cong₂ _+_
      (cong₂ mxℕ (शुद्ध-सुम् (a ∷ A') ρ) (शुद्ध-सुम् (b ∷ B') ρ))
      (refl {x = सुम् C ρ})
  ∙ +-comm (mxℕ (सुम् (a ∷ A') ρ) (सुम् (b ∷ B') ρ)) (सुम् C ρ)

गूढ-सत्यम् : (t : Tm) (ρ : ℕ → ℕ) → eval (गूढ-आम्नायः t) ρ ≡ eval t ρ
गूढ-सत्यम् (var i)  ρ = refl
गूढ-सत्यम् ze       ρ = refl
गूढ-सत्यम् (su t)   ρ =
    शुद्ध-सुम् (राशिः (su (गूढ-आम्नायः t))) ρ
  ∙ राशि-सत्यम् (su (गूढ-आम्नायः t)) ρ
  ∙ cong suc (गूढ-सत्यम् t ρ)
गूढ-सत्यम् (a ⊕ b)  ρ =
    शुद्ध-सुम् (राशिः (गूढ-आम्नायः a) ++ राशिः (गूढ-आम्नायः b)) ρ
  ∙ सुम्-++ (राशिः (गूढ-आम्नायः a)) (राशिः (गूढ-आम्नायः b)) ρ
  ∙ cong₂ _+_ (राशि-सत्यम् (गूढ-आम्नायः a) ρ) (राशि-सत्यम् (गूढ-आम्नायः b) ρ)
  ∙ cong₂ _+_ (गूढ-सत्यम् a ρ) (गूढ-सत्यम् b ρ)
गूढ-सत्यम् (a ⊗ b)  ρ = cong₂ _·_ (गूढ-सत्यम् a ρ) (गूढ-सत्यम् b ρ)
गूढ-सत्यम् (a ⊖ b)  ρ = cong₂ sbℕ (गूढ-सत्यम् a ρ) (गूढ-सत्यम् b ρ)
गूढ-सत्यम् (mx a b) ρ =
    मेल-सत्यम् (fst s) (fst (snd s)) (fst (snd (snd s))) ρ
  ∙ +-comm (सुम् (fst s) ρ)
           (mxℕ (सुम् (fst (snd s)) ρ) (सुम् (fst (snd (snd s))) ρ))
  ∙ sym (वितरणम् (सुम् (fst (snd s)) ρ) (सुम् (fst (snd (snd s))) ρ)
                 (सुम् (fst s) ρ))
  ∙ cong₂ mxℕ (+-comm (सुम् (fst (snd s)) ρ) (सुम् (fst s) ρ))
              (+-comm (सुम् (fst (snd (snd s))) ρ) (सुम् (fst s) ρ))
  ∙ cong₂ mxℕ (sym (fst (snd (snd (snd s))) ρ))
              (sym (snd (snd (snd (snd s))) ρ))
  ∙ cong₂ mxℕ (राशि-सत्यम् (गूढ-आम्नायः a) ρ) (राशि-सत्यम् (गूढ-आम्नायः b) ρ)
  ∙ cong₂ mxℕ (गूढ-सत्यम् a ρ) (गूढ-सत्यम् b ρ)
  where
  s = साधारणम् (राशिः (गूढ-आम्नायः a)) (राशिः (गूढ-आम्नायः b))
गूढ-सत्यम् (lq a b) ρ = cong₂ lqℕ (गूढ-सत्यम् a ρ) (गूढ-सत्यम् b ρ)

------------------------------------------------------------------------
-- §4  The fifth examination: the factoring eye over the heap-surgical
--     exchange, record and descent as ever.
------------------------------------------------------------------------

दृक्पातः : Tm → Tm
दृक्पातः t = गूढ-आम्नायः (norm t)

दृक्पात-सत्यम् : (t : Tm) (ρ : ℕ → ℕ) → eval (दृक्पातः t) ρ ≡ eval t ρ
दृक्पात-सत्यम् t ρ = गूढ-सत्यम् (norm t) ρ ∙ norm-sound t ρ

गूढ-व्याप्तिः : List नियमः → (k : ℕ) (l r : Tm)
  → Maybe ((ρ : ℕ → ℕ) → eval l ρ ≡ eval r ρ
       → eval (l ⟨ k ≔ su (var k) ⟩) ρ ≡ eval (r ⟨ k ≔ su (var k) ⟩) ρ)
गूढ-व्याप्तिः Γ k l r =
  mmap
    (λ q ρ ih →
      let h = दृक्पात-सत्यम् l ρ ∙ ih ∙ sym (दृक्पात-सत्यम् r ρ)
      in   sym (दृक्पात-सत्यम् (l ⟨ k ≔ su (var k) ⟩) ρ)
         ∙ श्रुत-साक्षी Γ ρ (दृक्पातः (l ⟨ k ≔ su (var k) ⟩))
         ∙ राशि-साक्षी (दृक्पातः l) (दृक्पातः r) ρ h
             (श्रुत-विनिमयः Γ (दृक्पातः (l ⟨ k ≔ su (var k) ⟩)))
         ∙ sym (गूढ-सत्यम् (राशि-विनिमयः (दृक्पातः l) (दृक्पातः r)
             (श्रुत-विनिमयः Γ (दृक्पातः (l ⟨ k ≔ su (var k) ⟩)))) ρ)
         ∙ cong (λ w → eval w ρ) q
         ∙ गूढ-सत्यम् (राशि-विनिमयः (दृक्पातः l) (दृक्पातः r)
             (श्रुत-विनिमयः Γ (दृक्पातः (r ⟨ k ≔ su (var k) ⟩)))) ρ
         ∙ sym (राशि-साक्षी (दृक्पातः l) (दृक्पातः r) ρ h
             (श्रुत-विनिमयः Γ (दृक्पातः (r ⟨ k ≔ su (var k) ⟩))))
         ∙ sym (श्रुत-साक्षी Γ ρ (दृक्पातः (r ⟨ k ≔ su (var k) ⟩)))
         ∙ दृक्पात-सत्यम् (r ⟨ k ≔ su (var k) ⟩) ρ)
    (  गूढ-आम्नायः (राशि-विनिमयः (दृक्पातः l) (दृक्पातः r)
         (श्रुत-विनिमयः Γ (दृक्पातः (l ⟨ k ≔ su (var k) ⟩))))
    ≟T गूढ-आम्नायः (राशि-विनिमयः (दृक्पातः l) (दृक्पातः r)
         (श्रुत-विनिमयः Γ (दृक्पातः (r ⟨ k ≔ su (var k) ⟩)))) )

गूढ-साधनम् : List नियमः → ℕ → (e : Eq') → Maybe (⊨ e)
गू-प्रयत्नः : List नियमः → ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))
गू-ऊर्ध्वम् : List नियमः → ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))

गूढ-साधनम् Γ zero e = nothing
गूढ-साधनम् Γ (suc f) (l , r) =
  अथवा (mmap (λ p ρ → sym (दृक्पात-सत्यम् l ρ) ∙ cong (λ w → eval w ρ) p ∙ दृक्पात-सत्यम् r ρ)
             (दृक्पातः l ≟T दृक्पातः r))
       (गू-प्रयत्नः Γ f (mxℕ (चराः l) (चराः r)) l r)

गू-प्रयत्नः Γ f zero    l r = nothing
गू-प्रयत्नः Γ f (suc k) l r = अथवा (गू-ऊर्ध्वम् Γ f k l r) (गू-प्रयत्नः Γ f k l r)

गू-ऊर्ध्वम् Γ f k l r =
  mmap2 (आरोहः k l r)
        (गूढ-साधनम् Γ f (l ⟨ k ≔ ze ⟩ , r ⟨ k ≔ ze ⟩))
        (गूढ-व्याप्तिः Γ k l r)

------------------------------------------------------------------------
-- §5  The fifth examination of the seven, computed.
------------------------------------------------------------------------

पञ्चम-न्यायः : List Eq' → List नियमः
पञ्चम-न्यायः [] = []
पञ्चम-न्यायः ((l , r) ∷ es) with गूढ-साधनम् अनुलोम-परम्परा इन्धनम् (l , r)
... | just pf = niyama l r pf ∷ पञ्चम-न्यायः es
... | nothing = पञ्चम-न्यायः es

पञ्चम-शेषम् : List Eq' → List Eq'
पञ्चम-शेषम् [] = []
पञ्चम-शेषम् ((l , r) ∷ es) with गूढ-साधनम् अनुलोम-परम्परा इन्धनम् (l , r)
... | just _  = पञ्चम-शेषम् es
... | nothing = (l , r) ∷ पञ्चम-शेषम् es

पञ्चम-सिद्धिः : length (पञ्चम-न्यायः (चतुर्थ-शेषम् (गुरु-शेषम् (अपचितम् आगमः)))) ≡ 4
पञ्चम-सिद्धिः = refl

पञ्चम-शेषः : length (पञ्चम-शेषम् (चतुर्थ-शेषम् (गुरु-शेषम् (अपचितम् आगमः)))) ≡ 3
पञ्चम-शेषः = refl
