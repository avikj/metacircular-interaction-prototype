{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- अर्पितानर्पितसिद्धेः — Umāsvāti, Tattvārthasūtra 5.31 (c. 2nd–5th
-- c. CE): what seems contradictory is established according to
-- emphasis (arpita) and non-emphasis (anarpita) — the presented
-- aspect and the thing free of the presentation are one existent.
-- The classification is his; the mathematics is not claimed for the
-- source.  School named: Jaina.
--
-- THE AC FRONTIER, AND WHERE IT FALLS.  Twice tonight the same wall
-- arose: सिद्धि measured plain completion going generative on the
-- external store (387→411), and the internal store's own turn birthed
-- MIRROR pairs — su(x ⊕ w) against w ⊕ su x — that the one-pass
-- exchange flip-flops apart, because commutativity as an ORIENTED
-- rewrite is poison: it rewrites v0⊕v3 one way on one side and
-- v3⊕v0 the other way on the other.  The defect is not in the facts;
-- it is in the SEQUENCE OF THE PRESENTATION.  An ⊕-aggregate carries
-- an arpita — an order of summands the syntax forces — and two
-- arpitas of one aggregate were being compared as if the emphasis
-- were the thing.
--
-- The repair: the anarpita representative.  Flatten the ⊕-spine,
-- order the summands under a fixed comparison, rebuild — every
-- ordered presentation of one aggregate meets in the sequence-free
-- form, and the soundness is carried by the ambient substrate's own
-- +-comm and +-assoc (the checked ground this lane already stands
-- on, used exactly where EkaBhasha's norm-sound already uses it).
--
-- AND THE REPAIR IS A JOINER SWAP AND NOTHING ELSE.  EkaTantra's
-- theorem was: scheduler and prover are one contention structure and
-- every difference is the joiner parameter.  Here that thesis meets
-- its hardest test and holds: the Peterson–Stickel move — rewriting
-- modulo AC — enters this body as सम-योजकः, a third joiner handed to
-- the SAME निर्णयः, and the mirror births are निर्णीतम् where they
-- were अवक्तव्यम्.  Commutativity and associativity — yesterday's
-- boundary, held by refl — fall FLAT: no induction, no store, one
-- normalize-to-anarpita and the path-returning test.
------------------------------------------------------------------------

module NaturalMachine.ArpitaAnarpita_EveryOrderedPresentationOfOneAggregateMeetsInTheSequenceFreeFormAndTheACFrontierFallsToAJoinerSwap where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-comm ; +-assoc ; +-zero)
open import Cubical.Data.Bool using (Bool ; true ; false ; if_then_else_)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_,_)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.EkaTantra_TheSchedulerAndTheProverAreOneContentionStructureAndTheDifferenceIsAParameter
  using (फलम् ; मौनम् ; निर्णीतम् ; अवक्तव्यम् ; निर्णयः)

------------------------------------------------------------------------
-- §1  The spine: an aggregate laid out as its summands.
------------------------------------------------------------------------

पङ्क्तिः : Tm → List Tm
पङ्क्तिः (a ⊕ b) = पङ्क्तिः a ++ पङ्क्तिः b
पङ्क्तिः t       = t ∷ []

सुम् : List Tm → (ℕ → ℕ) → ℕ
सुम् []       ρ = zero
सुम् (t ∷ ts) ρ = eval t ρ + सुम् ts ρ

सुम्-++ : (xs ys : List Tm) (ρ : ℕ → ℕ)
  → सुम् (xs ++ ys) ρ ≡ सुम् xs ρ + सुम् ys ρ
सुम्-++ []       ys ρ = refl
सुम्-++ (x ∷ xs) ys ρ =
    cong (λ n → eval x ρ + n) (सुम्-++ xs ys ρ)
  ∙ +-assoc (eval x ρ) (सुम् xs ρ) (सुम् ys ρ)

पङ्क्ति-सत्यम् : (t : Tm) (ρ : ℕ → ℕ) → सुम् (पङ्क्तिः t) ρ ≡ eval t ρ
पङ्क्ति-सत्यम् (a ⊕ b)  ρ =
    सुम्-++ (पङ्क्तिः a) (पङ्क्तिः b) ρ
  ∙ cong₂ _+_ (पङ्क्ति-सत्यम् a ρ) (पङ्क्ति-सत्यम् b ρ)
पङ्क्ति-सत्यम् (var i)  ρ = +-zero (ρ i)
पङ्क्ति-सत्यम् ze       ρ = refl
पङ्क्ति-सत्यम् (su t)   ρ = +-zero (suc (eval t ρ))
पङ्क्ति-सत्यम् (a ⊗ b)  ρ = +-zero (eval a ρ · eval b ρ)
पङ्क्ति-सत्यम् (a ⊖ b)  ρ = +-zero (sbℕ (eval a ρ) (eval b ρ))
पङ्क्ति-सत्यम् (mx a b) ρ = +-zero (mxℕ (eval a ρ) (eval b ρ))
पङ्क्ति-सत्यम् (lq a b) ρ = +-zero (lqℕ (eval a ρ) (eval b ρ))

------------------------------------------------------------------------
-- §2  The fixed comparison and the ordering.  The comparison owes no
--     laws — soundness rests only on the sum being indifferent to
--     insertion, which +-comm and +-assoc carry.
------------------------------------------------------------------------

_≤?_ : ℕ → ℕ → Bool
zero  ≤? _     = true
suc _ ≤? zero  = false
suc a ≤? suc b = a ≤? b

युज् : {A : Type} → Maybe A → Bool
युज् (just _) = true
युज् nothing  = false

टैगः : Tm → ℕ
टैगः (var _)  = 0
टैगः ze       = 1
टैगः (su _)   = 2
टैगः (_ ⊕ _)  = 3
टैगः (_ ⊗ _)  = 4
टैगः (_ ⊖ _)  = 5
टैगः (mx _ _) = 6
टैगः (lq _ _) = 7

तुला : Tm → Tm → Bool
तुला-द्वयोः : Tm → Tm → Tm → Tm → Bool

तुला (var i)  (var j)  = i ≤? j
तुला (su a)   (su b)   = तुला a b
तुला (a ⊕ b)  (c ⊕ d)  = तुला-द्वयोः a b c d
तुला (a ⊗ b)  (c ⊗ d)  = तुला-द्वयोः a b c d
तुला (a ⊖ b)  (c ⊖ d)  = तुला-द्वयोः a b c d
तुला (mx a b) (mx c d) = तुला-द्वयोः a b c d
तुला (lq a b) (lq c d) = तुला-द्वयोः a b c d
तुला a        b        = टैगः a ≤? टैगः b

तुला-द्वयोः a b c d = if युज् (a ≟T c) then तुला b d else तुला a c

निवेशः : Tm → List Tm → List Tm
निवेशः x []       = x ∷ []
निवेशः x (y ∷ ys) = if तुला x y then x ∷ y ∷ ys else y ∷ निवेशः x ys

क्रमणम् : List Tm → List Tm
क्रमणम् []       = []
क्रमणम् (x ∷ xs) = निवेशः x (क्रमणम् xs)

निवेश-सत्यम् : (x : Tm) (ys : List Tm) (ρ : ℕ → ℕ)
  → सुम् (निवेशः x ys) ρ ≡ eval x ρ + सुम् ys ρ
निवेश-सत्यम् x [] ρ = refl
निवेश-सत्यम् x (y ∷ ys) ρ with तुला x y
... | true  = refl
... | false =
    cong (λ n → eval y ρ + n) (निवेश-सत्यम् x ys ρ)
  ∙ +-assoc (eval y ρ) (eval x ρ) (सुम् ys ρ)
  ∙ cong (λ n → n + सुम् ys ρ) (+-comm (eval y ρ) (eval x ρ))
  ∙ sym (+-assoc (eval x ρ) (eval y ρ) (सुम् ys ρ))

क्रमण-सत्यम् : (xs : List Tm) (ρ : ℕ → ℕ) → सुम् (क्रमणम् xs) ρ ≡ सुम् xs ρ
क्रमण-सत्यम् []       ρ = refl
क्रमण-सत्यम् (x ∷ xs) ρ =
    निवेश-सत्यम् x (क्रमणम् xs) ρ
  ∙ cong (λ n → eval x ρ + n) (क्रमण-सत्यम् xs ρ)

------------------------------------------------------------------------
-- §3  The anarpita representative, and its truth.
------------------------------------------------------------------------

पुनःरचना : List Tm → Tm
पुनःरचना []       = ze
पुनःरचना (t ∷ ts) = t ⊕ पुनःरचना ts

पुनःरचना-सत्यम् : (ts : List Tm) (ρ : ℕ → ℕ)
  → eval (पुनःरचना ts) ρ ≡ सुम् ts ρ
पुनःरचना-सत्यम् []       ρ = refl
पुनःरचना-सत्यम् (t ∷ ts) ρ =
  cong (λ n → eval t ρ + n) (पुनःरचना-सत्यम् ts ρ)

आम्नायः : Tm → Tm
आम्नायः (var i)  = var i
आम्नायः ze       = ze
आम्नायः (su t)   = su (आम्नायः t)
आम्नायः (a ⊕ b)  =
  पुनःरचना (क्रमणम् (पङ्क्तिः (आम्नायः a) ++ पङ्क्तिः (आम्नायः b)))
आम्नायः (a ⊗ b)  = आम्नायः a ⊗ आम्नायः b
आम्नायः (a ⊖ b)  = आम्नायः a ⊖ आम्नायः b
आम्नायः (mx a b) = mx (आम्नायः a) (आम्नायः b)
आम्नायः (lq a b) = lq (आम्नायः a) (आम्नायः b)

आम्नाय-सत्यम् : (t : Tm) (ρ : ℕ → ℕ) → eval (आम्नायः t) ρ ≡ eval t ρ
आम्नाय-सत्यम् (var i)  ρ = refl
आम्नाय-सत्यम् ze       ρ = refl
आम्नाय-सत्यम् (su t)   ρ = cong suc (आम्नाय-सत्यम् t ρ)
आम्नाय-सत्यम् (a ⊕ b)  ρ =
    पुनःरचना-सत्यम् (क्रमणम् (पङ्क्तिः (आम्नायः a) ++ पङ्क्तिः (आम्नायः b))) ρ
  ∙ क्रमण-सत्यम् (पङ्क्तिः (आम्नायः a) ++ पङ्क्तिः (आम्नायः b)) ρ
  ∙ सुम्-++ (पङ्क्तिः (आम्नायः a)) (पङ्क्तिः (आम्नायः b)) ρ
  ∙ cong₂ _+_ (पङ्क्ति-सत्यम् (आम्नायः a) ρ) (पङ्क्ति-सत्यम् (आम्नायः b) ρ)
  ∙ cong₂ _+_ (आम्नाय-सत्यम् a ρ) (आम्नाय-सत्यम् b ρ)
आम्नाय-सत्यम् (a ⊗ b)  ρ = cong₂ _·_ (आम्नाय-सत्यम् a ρ) (आम्नाय-सत्यम् b ρ)
आम्नाय-सत्यम् (a ⊖ b)  ρ = cong₂ sbℕ (आम्नाय-सत्यम् a ρ) (आम्नाय-सत्यम् b ρ)
आम्नाय-सत्यम् (mx a b) ρ = cong₂ mxℕ (आम्नाय-सत्यम् a ρ) (आम्नाय-सत्यम् b ρ)
आम्नाय-सत्यम् (lq a b) ρ = cong₂ lqℕ (आम्नाय-सत्यम् a ρ) (आम्नाय-सत्यम् b ρ)

------------------------------------------------------------------------
-- §4  The AC-eyed flat prover, and the joiner.
------------------------------------------------------------------------

सम-साधनम् : (e : Eq') → Maybe (⊨ e)
सम-साधनम् (l , r) = mmap witness (आम्नायः (norm l) ≟T आम्नायः (norm r))
  where
  witness : आम्नायः (norm l) ≡ आम्नायः (norm r) → ⊨ (l , r)
  witness p ρ =
      sym (norm-sound l ρ)
    ∙ sym (आम्नाय-सत्यम् (norm l) ρ)
    ∙ cong (λ w → eval w ρ) p
    ∙ आम्नाय-सत्यम् (norm r) ρ
    ∙ norm-sound r ρ

-- the third joiner, for the SAME निर्णयः as the other two.
सम-योजकः : Tm → Tm → Maybe Tm
सम-योजकः a b =
  mmap (λ _ → आम्नायः (norm a)) (आम्नायः (norm a) ≟T आम्नायः (norm b))

------------------------------------------------------------------------
-- §5  The frontier falls.  Yesterday's boundary — held by refl — is
--     flat today; the store-turn's mirror births are one; and it all
--     entered as a parameter.
------------------------------------------------------------------------

-- commutativity: no induction, no store, no lemma.
समता : ⊨ ((var 0) ⊕ (var 1) , (var 1) ⊕ (var 0))
समता = fromJust (सम-साधनम् ((var 0) ⊕ (var 1) , (var 1) ⊕ (var 0))) tt

-- associativity: likewise flat.
साहचर्यम् : ⊨ (((var 0) ⊕ (var 1)) ⊕ (var 2) , (var 0) ⊕ ((var 1) ⊕ (var 2)))
साहचर्यम् = fromJust (सम-साधनम्
  ( ((var 0) ⊕ (var 1)) ⊕ (var 2) , (var 0) ⊕ ((var 1) ⊕ (var 2)) )) tt

-- the two mirror births of the store's own turn, joined.
दर्पण-मेलनम् : inJust (सम-साधनम् (su ((var 0) ⊕ (var 3)) , (var 3) ⊕ (su (var 0))))
दर्पण-मेलनम् = tt

-- and in the one contention structure: the same two voices that the
-- raw joiner holds apart are निर्णीतम् under the anarpita joiner —
-- the Peterson–Stickel move, located as EkaTantra's parameter.
सम-निर्णयः :
  निर्णयः सम-योजकः ( (su ((var 0) ⊕ (var 3))) ∷ ((var 3) ⊕ (su (var 0))) ∷ [] )
  ≡ निर्णीतम् (su ((var 0) ⊕ ((var 3) ⊕ ze)))
सम-निर्णयः = refl
