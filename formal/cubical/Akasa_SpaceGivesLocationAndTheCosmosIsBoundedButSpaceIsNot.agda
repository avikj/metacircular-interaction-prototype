{-# OPTIONS --cubical --safe --no-import-sorts #-}
-- आकाश — space (Umāsvāti, Tattvārthasūtra 5.18 avagāha; 5.12 lokākāśa). The
-- sixth dravya, whose upakāra is avagāhana: it gives every other substance its
-- location. ākāśa is infinite; loka-ākāśa (occupied, bounded by dharma/adharma
-- as the media of motion/rest) is finite; aloka (the empty remainder, only
-- ākāśa) is infinite and nonempty — so the COSMOS is bounded but SPACE is not.
-- Completes the six dravyas: jīva, pudgala, dharma, adharma, kāla, ākāśa.
module Akasa_SpaceGivesLocationAndTheCosmosIsBoundedButSpaceIsNot where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Nat.Order using (_<_ ; _≤_ ; ≤-refl ; ≤-trans ; ¬m<m)
open import Cubical.Data.Sigma using (Σ ; _,_)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

आकाश : Type
आकाश = ℕ                        -- pradeśas, infinite

अवगाहन : Type → Type
अवगाहन D = D → आकाश             -- avagāhana: every substance gets a location

लोकः अलोकः : (L : ℕ) → आकाश → Type
लोकः  L p = p < L                -- within the cosmic bound
अलोकः L p = L ≤ p                -- beyond it

-- aloka is nonempty: space runs past the bound (L itself lies beyond loka)
अलोकः-अस्ति : (L : ℕ) → Σ आकाश (अलोकः L)
अलोकः-अस्ति L = L , ≤-refl

-- loka and aloka do not overlap: nothing is both within and beyond
न-उभयम् : (L : ℕ) (p : आकाश) → लोकः L p → अलोकः L p → ⊥
न-उभयम् L p lo alo = ¬m<m (≤-trans lo alo)
