{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- राशिः — the heap, the quantity: the standard term of the
-- gaṇita tradition for a quantity under operation (Bhāskara II,
-- Līlāvatī and Bījagaṇita, c. 1150, where rāśi names the quantity
-- worked upon).  The classification — a sum as a heap of atoms, not a
-- sequence — is the tradition's; the mathematics here is not claimed
-- for the source.
--
-- WHY THE EIGHT SURVIVED EVERYTHING.  The head of the residue is
-- y + x·y = (sx)·y, and its inductive step dies in every prior
-- machinery for one reason: after the step substitution the
-- hypothesis's atoms sit INSIDE su-nodes and BETWEEN other summands,
-- so neither syntactic subterm exchange nor the sequence-free eye can
-- see the hypothesis in the goal.  The sum must be read as a HEAP:
-- su is the unit atom (+1), ze is the empty heap, ⊕ is heap union —
-- and the hypothesis speaks by SUB-MULTISET surgery: its own heap is
-- removed from the goal's heap and its other face's heap is put in
-- its place, each deletion carrying its arithmetic witness.  This is
-- rewriting modulo the commutative monoid (ℕ, +, 0) with successor
-- absorbed — the move completion theory knows is required, arrived at
-- here from the machine's own residue.
--
--   राशिः        the heap of a term (⊕ flattened, su a unit, ze gone)
--   गाढ-आम्नायः  the deep eye: every sum-cluster rebuilt from its
--                sorted heap, everything else by congruence
--   निष्कासः     deletion of one atom, with the sum-path it owes
--   शस्त्रम्     the surgery: hypothesis-heap out, other-face-heap in
--   राशि-साधनम्  the examination with the deep eye and the surgical
--                exchange, record and descent as ever
--
-- The verdict on the eight, computed by the kernel at the end of this
-- file, is whatever it is — the numbers were learned by asserting
-- them wrong and reading the refusal.
------------------------------------------------------------------------

module NaturalMachine.Rashi_TheSumIsAHeapNotASequenceTheUnitIsAnAtomAndTheHypothesisSpeaksThroughTheHeap where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-suc ; +-zero ; +-assoc ; +-comm)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; length)
open import Cubical.Data.Sigma using (Σ ; _,_ ; fst ; snd)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.AdeshaSthanivat_TheSubstituteBehavesLikeTheOriginalSoEveryProvenRuleSpeaksAtEveryInstance
  using (_≫=_)
open import NaturalMachine.Aroha_TheInternalProverClimbsWhereItsFlatVoiceIsSilentAndTheStoreAdmitsInductionThroughTheSameGate
  using (आरोहः ; _⟨_≔_⟩)
open import NaturalMachine.SvarthaAnumana_TheMachineInfersForItselfAndThePervasionIsGraspedWithinWithNoOuterCarrier
  using (अथवा ; चराः ; इन्धनम्)
open import NaturalMachine.ShrutaMatipurva_TheRecordIsPrecededByCognitionAndCognitionWithTheRecordReachesWhatItAloneCouldNot
  using (श्रुत-विनिमयः ; श्रुत-साक्षी)
open import NaturalMachine.ArpitaAnarpita_EveryOrderedPresentationOfOneAggregateMeetsInTheSequenceFreeFormAndTheACFrontierFallsToAJoinerSwap
  using (सुम् ; सुम्-++ ; क्रमणम् ; क्रमण-सत्यम् ; पुनःरचना ; पुनःरचना-सत्यम्)
open import NaturalMachine.AptaMimamsa_TheEldersLiveStoreCrossesAsReceivedTextAndNothingEntersOnAuthority
  using (आगमः ; अपचितम्)
open import NaturalMachine.ShrutaParampara_TheCrossedRulesBecomeTheRecordAndTheSecondPassReachesWhatTheFirstCouldNot
  using (गुरु-शेषम्)
open import NaturalMachine.AnulomaShruta_TheRecordSpeaksWithTheGrainAndTheThirdPassCrossesFurther
  using (अनुलोम-परम्परा)

------------------------------------------------------------------------
-- §1  The heap, and its truth.
------------------------------------------------------------------------

राशिः : Tm → List Tm
राशिः (a ⊕ b) = राशिः a ++ राशिः b
राशिः (su t)  = राशिः t ++ ((su ze) ∷ [])
राशिः ze      = []
राशिः t       = t ∷ []

राशि-सत्यम् : (t : Tm) (ρ : ℕ → ℕ) → सुम् (राशिः t) ρ ≡ eval t ρ
राशि-सत्यम् (a ⊕ b)  ρ =
    सुम्-++ (राशिः a) (राशिः b) ρ
  ∙ cong₂ _+_ (राशि-सत्यम् a ρ) (राशि-सत्यम् b ρ)
राशि-सत्यम् (su t)   ρ =
    सुम्-++ (राशिः t) ((su ze) ∷ []) ρ
  ∙ +-suc (सुम् (राशिः t) ρ) zero
  ∙ cong suc (+-zero (सुम् (राशिः t) ρ))
  ∙ cong suc (राशि-सत्यम् t ρ)
राशि-सत्यम् ze       ρ = refl
राशि-सत्यम् (var i)  ρ = +-zero (ρ i)
राशि-सत्यम् (a ⊗ b)  ρ = +-zero (eval a ρ · eval b ρ)
राशि-सत्यम् (a ⊖ b)  ρ = +-zero (sbℕ (eval a ρ) (eval b ρ))
राशि-सत्यम् (mx a b) ρ = +-zero (mxℕ (eval a ρ) (eval b ρ))
राशि-सत्यम् (lq a b) ρ = +-zero (lqℕ (eval a ρ) (eval b ρ))

------------------------------------------------------------------------
-- §2  The deep eye: every sum-cluster rebuilt from its sorted heap.
------------------------------------------------------------------------

गाढ-आम्नायः : Tm → Tm
गाढ-आम्नायः (var i)  = var i
गाढ-आम्नायः ze       = ze
गाढ-आम्नायः (su t)   = पुनःरचना (क्रमणम् (राशिः (su (गाढ-आम्नायः t))))
गाढ-आम्नायः (a ⊕ b)  =
  पुनःरचना (क्रमणम् (राशिः (गाढ-आम्नायः a) ++ राशिः (गाढ-आम्नायः b)))
गाढ-आम्नायः (a ⊗ b)  = गाढ-आम्नायः a ⊗ गाढ-आम्नायः b
गाढ-आम्नायः (a ⊖ b)  = गाढ-आम्नायः a ⊖ गाढ-आम्नायः b
गाढ-आम्नायः (mx a b) = mx (गाढ-आम्नायः a) (गाढ-आम्नायः b)
गाढ-आम्नायः (lq a b) = lq (गाढ-आम्नायः a) (गाढ-आम्नायः b)

गाढ-सत्यम् : (t : Tm) (ρ : ℕ → ℕ) → eval (गाढ-आम्नायः t) ρ ≡ eval t ρ
गाढ-सत्यम् (var i)  ρ = refl
गाढ-सत्यम् ze       ρ = refl
गाढ-सत्यम् (su t)   ρ =
    पुनःरचना-सत्यम् (क्रमणम् (राशिः (su (गाढ-आम्नायः t)))) ρ
  ∙ क्रमण-सत्यम् (राशिः (su (गाढ-आम्नायः t))) ρ
  ∙ राशि-सत्यम् (su (गाढ-आम्नायः t)) ρ
  ∙ cong suc (गाढ-सत्यम् t ρ)
गाढ-सत्यम् (a ⊕ b)  ρ =
    पुनःरचना-सत्यम् (क्रमणम् (राशिः (गाढ-आम्नायः a) ++ राशिः (गाढ-आम्नायः b))) ρ
  ∙ क्रमण-सत्यम् (राशिः (गाढ-आम्नायः a) ++ राशिः (गाढ-आम्नायः b)) ρ
  ∙ सुम्-++ (राशिः (गाढ-आम्नायः a)) (राशिः (गाढ-आम्नायः b)) ρ
  ∙ cong₂ _+_ (राशि-सत्यम् (गाढ-आम्नायः a) ρ) (राशि-सत्यम् (गाढ-आम्नायः b) ρ)
  ∙ cong₂ _+_ (गाढ-सत्यम् a ρ) (गाढ-सत्यम् b ρ)
गाढ-सत्यम् (a ⊗ b)  ρ = cong₂ _·_ (गाढ-सत्यम् a ρ) (गाढ-सत्यम् b ρ)
गाढ-सत्यम् (a ⊖ b)  ρ = cong₂ sbℕ (गाढ-सत्यम् a ρ) (गाढ-सत्यम् b ρ)
गाढ-सत्यम् (mx a b) ρ = cong₂ mxℕ (गाढ-सत्यम् a ρ) (गाढ-सत्यम् b ρ)
गाढ-सत्यम् (lq a b) ρ = cong₂ lqℕ (गाढ-सत्यम् a ρ) (गाढ-सत्यम् b ρ)

------------------------------------------------------------------------
-- §3  Deletion with its debt, and the surgery.
------------------------------------------------------------------------

निष्कासः : (t : Tm) (xs : List Tm)
  → Maybe (Σ (List Tm) (λ ys → (ρ : ℕ → ℕ) → सुम् xs ρ ≡ eval t ρ + सुम् ys ρ))
निष्कासः t [] = nothing
निष्कासः t (x ∷ xs) with t ≟T x
... | just p  = just (xs , λ ρ → cong (λ w → eval w ρ + सुम् xs ρ) (sym p))
... | nothing =
  mmap (λ yq → (x ∷ fst yq
             , λ ρ → cong (eval x ρ +_) (snd yq ρ)
                   ∙ +-assoc (eval x ρ) (eval t ρ) (सुम् (fst yq) ρ)
                   ∙ cong (_+ सुम् (fst yq) ρ) (+-comm (eval x ρ) (eval t ρ))
                   ∙ sym (+-assoc (eval t ρ) (eval x ρ) (सुम् (fst yq) ρ))))
       (निष्कासः t xs)

बहु-निष्कासः : (ts xs : List Tm)
  → Maybe (Σ (List Tm) (λ ys → (ρ : ℕ → ℕ) → सुम् xs ρ ≡ सुम् ts ρ + सुम् ys ρ))
बहु-निष्कासः [] xs = just (xs , λ ρ → refl)
बहु-निष्कासः (t ∷ ts) xs =
  निष्कासः t xs ≫= λ yq →
  mmap (λ zw → (fst zw
             , λ ρ → snd yq ρ
                   ∙ cong (eval t ρ +_) (snd zw ρ)
                   ∙ +-assoc (eval t ρ) (सुम् ts ρ) (सुम् (fst zw) ρ)))
       (बहु-निष्कासः ts (fst yq))

शस्त्रम् : (p s t : Tm) → Tm
शस्त्रम् p s t with बहु-निष्कासः (राशिः p) (राशिः t)
... | just yw = पुनःरचना (क्रमणम् (राशिः s ++ fst yw))
... | nothing = t

शस्त्र-साक्षी : (p s : Tm) (ρ : ℕ → ℕ) → eval p ρ ≡ eval s ρ
  → (t : Tm) → eval t ρ ≡ eval (शस्त्रम् p s t) ρ
शस्त्र-साक्षी p s ρ h t with बहु-निष्कासः (राशिः p) (राशिः t)
... | nothing = refl
... | just yw =
    sym (राशि-सत्यम् t ρ)
  ∙ snd yw ρ
  ∙ cong (_+ सुम् (fst yw) ρ) (राशि-सत्यम् p ρ ∙ h ∙ sym (राशि-सत्यम् s ρ))
  ∙ sym (सुम्-++ (राशिः s) (fst yw) ρ)
  ∙ sym (क्रमण-सत्यम् (राशिः s ++ fst yw) ρ)
  ∙ sym (पुनःरचना-सत्यम् (क्रमणम् (राशिः s ++ fst yw)) ρ)

-- the exchange: root identity, heap surgery at sum-clusters,
-- congruence into the atoms elsewhere.
राशि-विनिमयः : (p s t : Tm) → Tm
राशि-विनिमयः p s t with p ≟T t
राशि-विनिमयः p s t        | just _  = s
राशि-विनिमयः p s (a ⊕ b)  | nothing = शस्त्रम् p s (a ⊕ b)
राशि-विनिमयः p s (su a)   | nothing = शस्त्रम् p s (su a)
राशि-विनिमयः p s (var i)  | nothing = var i
राशि-विनिमयः p s ze       | nothing = ze
राशि-विनिमयः p s (a ⊗ b)  | nothing = राशि-विनिमयः p s a ⊗ राशि-विनिमयः p s b
राशि-विनिमयः p s (a ⊖ b)  | nothing = राशि-विनिमयः p s a ⊖ राशि-विनिमयः p s b
राशि-विनिमयः p s (mx a b) | nothing = mx (राशि-विनिमयः p s a) (राशि-विनिमयः p s b)
राशि-विनिमयः p s (lq a b) | nothing = lq (राशि-विनिमयः p s a) (राशि-विनिमयः p s b)

राशि-साक्षी : (p s : Tm) (ρ : ℕ → ℕ) → eval p ρ ≡ eval s ρ
  → (t : Tm) → eval t ρ ≡ eval (राशि-विनिमयः p s t) ρ
राशि-साक्षी p s ρ h t with p ≟T t
राशि-साक्षी p s ρ h t        | just q  = cong (λ w → eval w ρ) (sym q) ∙ h
राशि-साक्षी p s ρ h (a ⊕ b)  | nothing = शस्त्र-साक्षी p s ρ h (a ⊕ b)
राशि-साक्षी p s ρ h (su a)   | nothing = शस्त्र-साक्षी p s ρ h (su a)
राशि-साक्षी p s ρ h (var i)  | nothing = refl
राशि-साक्षी p s ρ h ze       | nothing = refl
राशि-साक्षी p s ρ h (a ⊗ b)  | nothing =
  cong₂ _·_ (राशि-साक्षी p s ρ h a) (राशि-साक्षी p s ρ h b)
राशि-साक्षी p s ρ h (a ⊖ b)  | nothing =
  cong₂ sbℕ (राशि-साक्षी p s ρ h a) (राशि-साक्षी p s ρ h b)
राशि-साक्षी p s ρ h (mx a b) | nothing =
  cong₂ mxℕ (राशि-साक्षी p s ρ h a) (राशि-साक्षी p s ρ h b)
राशि-साक्षी p s ρ h (lq a b) | nothing =
  cong₂ lqℕ (राशि-साक्षी p s ρ h a) (राशि-साक्षी p s ρ h b)

------------------------------------------------------------------------
-- §4  The examination with the deep eye and the surgical exchange.
------------------------------------------------------------------------

दृष्टिः : Tm → Tm
दृष्टिः t = गाढ-आम्नायः (norm t)

दृष्टि-सत्यम् : (t : Tm) (ρ : ℕ → ℕ) → eval (दृष्टिः t) ρ ≡ eval t ρ
दृष्टि-सत्यम् t ρ = गाढ-सत्यम् (norm t) ρ ∙ norm-sound t ρ

राशि-व्याप्तिः : List नियमः → (k : ℕ) (l r : Tm)
  → Maybe ((ρ : ℕ → ℕ) → eval l ρ ≡ eval r ρ
       → eval (l ⟨ k ≔ su (var k) ⟩) ρ ≡ eval (r ⟨ k ≔ su (var k) ⟩) ρ)
राशि-व्याप्तिः Γ k l r =
  mmap
    (λ q ρ ih →
      let h = दृष्टि-सत्यम् l ρ ∙ ih ∙ sym (दृष्टि-सत्यम् r ρ)
      in   sym (दृष्टि-सत्यम् (l ⟨ k ≔ su (var k) ⟩) ρ)
         ∙ श्रुत-साक्षी Γ ρ (दृष्टिः (l ⟨ k ≔ su (var k) ⟩))
         ∙ राशि-साक्षी (दृष्टिः l) (दृष्टिः r) ρ h
             (श्रुत-विनिमयः Γ (दृष्टिः (l ⟨ k ≔ su (var k) ⟩)))
         ∙ sym (गाढ-सत्यम् (राशि-विनिमयः (दृष्टिः l) (दृष्टिः r)
             (श्रुत-विनिमयः Γ (दृष्टिः (l ⟨ k ≔ su (var k) ⟩)))) ρ)
         ∙ cong (λ w → eval w ρ) q
         ∙ गाढ-सत्यम् (राशि-विनिमयः (दृष्टिः l) (दृष्टिः r)
             (श्रुत-विनिमयः Γ (दृष्टिः (r ⟨ k ≔ su (var k) ⟩)))) ρ
         ∙ sym (राशि-साक्षी (दृष्टिः l) (दृष्टिः r) ρ h
             (श्रुत-विनिमयः Γ (दृष्टिः (r ⟨ k ≔ su (var k) ⟩))))
         ∙ sym (श्रुत-साक्षी Γ ρ (दृष्टिः (r ⟨ k ≔ su (var k) ⟩)))
         ∙ दृष्टि-सत्यम् (r ⟨ k ≔ su (var k) ⟩) ρ)
    (  गाढ-आम्नायः (राशि-विनिमयः (दृष्टिः l) (दृष्टिः r)
         (श्रुत-विनिमयः Γ (दृष्टिः (l ⟨ k ≔ su (var k) ⟩))))
    ≟T गाढ-आम्नायः (राशि-विनिमयः (दृष्टिः l) (दृष्टिः r)
         (श्रुत-विनिमयः Γ (दृष्टिः (r ⟨ k ≔ su (var k) ⟩)))) )

राशि-साधनम् : List नियमः → ℕ → (e : Eq') → Maybe (⊨ e)
रा-प्रयत्नः : List नियमः → ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))
रा-ऊर्ध्वम् : List नियमः → ℕ → ℕ → (l r : Tm) → Maybe (⊨ (l , r))

राशि-साधनम् Γ zero e = nothing
राशि-साधनम् Γ (suc f) (l , r) =
  अथवा (mmap (λ p ρ → sym (दृष्टि-सत्यम् l ρ) ∙ cong (λ w → eval w ρ) p ∙ दृष्टि-सत्यम् r ρ)
             (दृष्टिः l ≟T दृष्टिः r))
       (रा-प्रयत्नः Γ f (mxℕ (चराः l) (चराः r)) l r)

रा-प्रयत्नः Γ f zero    l r = nothing
रा-प्रयत्नः Γ f (suc k) l r = अथवा (रा-ऊर्ध्वम् Γ f k l r) (रा-प्रयत्नः Γ f k l r)

रा-ऊर्ध्वम् Γ f k l r =
  mmap2 (आरोहः k l r)
        (राशि-साधनम् Γ f (l ⟨ k ≔ ze ⟩ , r ⟨ k ≔ ze ⟩))
        (राशि-व्याप्तिः Γ k l r)

------------------------------------------------------------------------
-- §5  The fourth examination of the eight, computed.
------------------------------------------------------------------------

चतुर्थ-न्यायः : List Eq' → List नियमः
चतुर्थ-न्यायः [] = []
चतुर्थ-न्यायः ((l , r) ∷ es) with राशि-साधनम् अनुलोम-परम्परा इन्धनम् (l , r)
... | just pf = niyama l r pf ∷ चतुर्थ-न्यायः es
... | nothing = चतुर्थ-न्यायः es

चतुर्थ-शेषम् : List Eq' → List Eq'
चतुर्थ-शेषम् [] = []
चतुर्थ-शेषम् ((l , r) ∷ es) with राशि-साधनम् अनुलोम-परम्परा इन्धनम् (l , r)
... | just _  = चतुर्थ-शेषम् es
... | nothing = (l , r) ∷ चतुर्थ-शेषम् es

चतुर्थ-सिद्धिः : length (चतुर्थ-न्यायः (गुरु-शेषम् (अपचितम् आगमः))) ≡ 1
चतुर्थ-सिद्धिः = refl

चतुर्थ-शेषः : length (चतुर्थ-शेषम् (गुरु-शेषम् (अपचितम् आगमः))) ≡ 7
चतुर्थ-शेषः = refl
