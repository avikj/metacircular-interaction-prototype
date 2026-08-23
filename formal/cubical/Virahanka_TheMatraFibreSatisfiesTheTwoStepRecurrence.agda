{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- विरहाङ्क — मात्रा-तन्तुः द्वि-पद-आवृत्तिं पालयति ।
--
-- Virahāṅka (c. 600-800 CE, Vṛttajātisamuccaya) on Piṅgala's
-- Chandaḥśāstra: mātrā-sequences of total n number those at n-1 plus
-- those at n-2.  Here as an EQUIVALENCE OF FIBRES, not a count -- the
-- fibre splits and the numbers are its shadow.  Weight is Piṅgala's,
-- laghu 1 guru 2.  No count and no closed form is proved here.
--
-- CHECKED: Agda 2.6.3 + cubical v0.5, --safe, exit 0.

module Virahanka_TheMatraFibreSatisfiesTheTwoStepRecurrence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; fiber)
open import Cubical.Foundations.Isomorphism using (iso ; isoToEquiv)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; isSetℕ ; injSuc ; znots ; snotz)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd ; Σ≡Prop)
open import Cubical.Data.Empty as Empty using (⊥)

मात्रा : Bool → ℕ
मात्रा true  = 1
मात्रा false = 2

छन्दः : List Bool → ℕ
छन्दः []       = 0
छन्दः (x ∷ xs) = मात्रा x + छन्दः xs

-- the fibre's witness is a proposition, because ℕ is a set
तन्तु-साक्षी : {n : ℕ} (l : List Bool) → isProp (छन्दः l ≡ n)
तन्तु-साक्षी _ = isSetℕ _ _

विरहाङ्क-आवृत्तिः : (n : ℕ)
  → fiber छन्दः (suc (suc n)) ≃ (fiber छन्दः (suc n) ⊎ fiber छन्दः n)
विरहाङ्क-आवृत्तिः n = isoToEquiv (iso भङ्गः सङ्घातः निवृत्तिः प्रत्यावृत्तिः)
  where
    भङ्गः : fiber छन्दः (suc (suc n)) → (fiber छन्दः (suc n) ⊎ fiber छन्दः n)
    भङ्गः ([]        , p) = Empty.rec (znots p)
    भङ्गः (true  ∷ xs , p) = inl (xs , injSuc p)
    भङ्गः (false ∷ xs , p) = inr (xs , injSuc (injSuc p))

    सङ्घातः : (fiber छन्दः (suc n) ⊎ fiber छन्दः n) → fiber छन्दः (suc (suc n))
    सङ्घातः (inl (xs , q)) = (true  ∷ xs) , cong suc q
    सङ्घातः (inr (xs , q)) = (false ∷ xs) , cong (λ k → suc (suc k)) q

    निवृत्तिः : (y : _) → भङ्गः (सङ्घातः y) ≡ y
    निवृत्तिः (inl (xs , q)) = cong inl (Σ≡Prop तन्तु-साक्षी refl)
    निवृत्तिः (inr (xs , q)) = cong inr (Σ≡Prop तन्तु-साक्षी refl)

    प्रत्यावृत्तिः : (y : fiber छन्दः (suc (suc n))) → सङ्घातः (भङ्गः y) ≡ y
    प्रत्यावृत्तिः ([]        , p) = Empty.rec (znots p)
    प्रत्यावृत्तिः (true  ∷ xs , p) = Σ≡Prop तन्तु-साक्षी refl
    प्रत्यावृत्तिः (false ∷ xs , p) = Σ≡Prop तन्तु-साक्षी refl

-- the two base cases, so the recurrence is anchored: exactly one
-- mātrā-sequence of total 0 (the empty one) and exactly one of total 1
-- (a single laghu).
शून्य-रिक्तम् : (l : List Bool) → छन्दः l ≡ 0 → l ≡ []
शून्य-रिक्तम् []            _ = refl
शून्य-रिक्तम् (true  ∷ xs) p = Empty.rec (snotz p)
शून्य-रिक्तम् (false ∷ xs) p = Empty.rec (snotz p)

आदि-शून्यम् : isContr (fiber छन्दः 0)
fst आदि-शून्यम् = [] , refl
snd आदि-शून्यम् (l , p) =
  Σ≡Prop तन्तु-साक्षी (sym (शून्य-रिक्तम् l p))

आदि-एकम् : isContr (fiber छन्दः 1)
fst आदि-एकम् = (true ∷ []) , refl
snd आदि-एकम् ([]           , p) = Empty.rec (znots p)
snd आदि-एकम् (true  ∷ xs , p) =
  Σ≡Prop तन्तु-साक्षी (cong (true ∷_) (sym (शून्य-रिक्तम् xs (injSuc p))))
snd आदि-एकम् (false ∷ xs , p) = Empty.rec (snotz (injSuc p))
