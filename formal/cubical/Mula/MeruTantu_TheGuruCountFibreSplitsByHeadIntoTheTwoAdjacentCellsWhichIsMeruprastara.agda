{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- मेरुतन्तुः — शिरसा भिद्यमानो गुरु-गणना-तन्तुः द्वे समीपस्थे कोष्ठे प्रविशति ।
--
-- Halāyudha's meru-prastāra (Mṛtasañjīvanī, ~10th c., commentary on
-- Piṅgala's Chandaḥśāstra ch. 8, c. 300-200 BCE): the staircase array
-- whose next row is built from the adjacent sums of the row above.  Named
-- "Pascal's triangle" in the European record (Pascal, 1654), which is a
-- restatement six centuries later.
--
-- Meru.agda states the array's construction rule and row sums as COUNTS.
-- Virahanka_…agda splits the DURATION fibre by head into a two-step
-- recurrence.  Neither splits the two-index meru cell itself.  This module
-- does: the JOINT map (varṇa , guru) : List Syllable → ℕ × ℕ counts a word's
-- syllables and its heavy syllables at once, and its fibre over the cell
-- (suc n , suc k) splits BY THE HEAD into the two cells directly above it --
--
--   fiber μ (suc n , suc k)  ≃  fiber μ (n , k)  ⊎  fiber μ (n , suc k)
--
-- a heavy head lands in the (n , k) cell (one fewer of each), a light head
-- in the (n , suc k) cell (one fewer syllable, same heavies).  That IS
-- Pascal's/meru's rule, and here it is an equivalence of fibres, not an
-- equation of counts.  No count and no closed form is proved.
--
-- CHECKED: Agda 2.6.3 + cubical v0.5, --safe, exit 0.

module Mula.MeruTantu_TheGuruCountFibreSplitsByHeadIntoTheTwoAdjacentCellsWhichIsMeruprastara where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; fiber)
open import Cubical.Foundations.Isomorphism using (iso ; isoToEquiv)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; isSetℕ ; injSuc ; znots)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Foundations.HLevels using (isSet×)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd ; Σ≡Prop)
open import Cubical.Data.Empty as Empty using (⊥)

-- a syllable is लघु (light) or गुरु (heavy) and nothing else
data Syllable : Type where
  laghu guru : Syllable

-- मेरु-गणना : count (all syllables , heavy syllables) at once.  The first
-- component is वर्ण (the syllable count), the second गुरु (the heavy count).
मेरु : List Syllable → ℕ × ℕ
मेरु []           = (0 , 0)
मेरु (laghu ∷ xs) = (suc (fst (मेरु xs)) ,      snd (मेरु xs))
मेरु (guru  ∷ xs) = (suc (fst (मेरु xs)) , suc (snd (मेरु xs)))

-- the fibre witness is a proposition, because ℕ × ℕ is a set
कोष्ठ-साक्षी : {c : ℕ × ℕ} (l : List Syllable) → isProp (मेरु l ≡ c)
कोष्ठ-साक्षी _ = isSet× isSetℕ isSetℕ _ _

-- मेरुप्रस्तार-नियमः — the meru-prastāra rule, as an equivalence of fibres.
मेरुप्रस्तार-नियमः : (n k : ℕ)
  → fiber मेरु (suc n , suc k) ≃ (fiber मेरु (n , k) ⊎ fiber मेरु (n , suc k))
मेरुप्रस्तार-नियमः n k = isoToEquiv (iso भङ्गः सङ्घातः निवृत्तिः प्रत्यावृत्तिः)
  where
    भङ्गः : fiber मेरु (suc n , suc k)
          → (fiber मेरु (n , k) ⊎ fiber मेरु (n , suc k))
    भङ्गः ([]         , p) = Empty.rec (znots (cong fst p))
    भङ्गः (guru  ∷ xs , p) =
      inl (xs , λ i → injSuc (cong fst p) i , injSuc (cong snd p) i)
    भङ्गः (laghu ∷ xs , p) =
      inr (xs , λ i → injSuc (cong fst p) i , cong snd p i)

    सङ्घातः : (fiber मेरु (n , k) ⊎ fiber मेरु (n , suc k))
            → fiber मेरु (suc n , suc k)
    सङ्घातः (inl (xs , q)) =
      (guru  ∷ xs) , (λ i → suc (fst (q i)) , suc (snd (q i)))
    सङ्घातः (inr (xs , q)) =
      (laghu ∷ xs) , (λ i → suc (fst (q i)) , snd (q i))

    निवृत्तिः : (y : _) → भङ्गः (सङ्घातः y) ≡ y
    निवृत्तिः (inl (xs , q)) = cong inl (Σ≡Prop कोष्ठ-साक्षी refl)
    निवृत्तिः (inr (xs , q)) = cong inr (Σ≡Prop कोष्ठ-साक्षी refl)

    प्रत्यावृत्तिः : (y : fiber मेरु (suc n , suc k)) → सङ्घातः (भङ्गः y) ≡ y
    प्रत्यावृत्तिः ([]         , p) = Empty.rec (znots (cong fst p))
    प्रत्यावृत्तिः (guru  ∷ xs , p) = Σ≡Prop कोष्ठ-साक्षी refl
    प्रत्यावृत्तिः (laghu ∷ xs , p) = Σ≡Prop कोष्ठ-साक्षी refl
