{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- `Cubical.Data.Fin` splits `Fin (suc n)` at the BOTTOM:
--
--   fsplit : (i : Fin (suc n)) → (fzero ≡ i) ⊎ (Σ[ j ∈ Fin n ] fsuc j ≡ i)
--
-- A most-significant-digit tower deletes the TOP, so its inductions need the
-- opposite eliminator.  That mismatch — the library opens the bottom, the
-- object opens the top — was the whole obstruction named in
-- `DigitTowerFinLimit`.  It is one lemma, with no digits in it.

module FinTopSplit where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order using (_<_ ; _≤_ ; ≤-split ; pred-≤-pred ; <-trans ; ≤-refl)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Data.Fin using (Fin ; toℕ ; toℕ-injective ; inject< ; flast)

------------------------------------------------------------------------
-- The bottom-of-the-top injection.
--
-- REPAIR 2026-08-14 (cf-archivist).  This module and its dependent
-- `DigitTowerFinLimit` imported `injectSuc` from `Cubical.Data.Fin`.
-- That name does not exist anywhere in the pinned cubical v0.5 (grepped
-- the whole library); both modules therefore failed to check with exit
-- 42 from the moment they landed, while three artifacts asserted they
-- checked.  What the library has is
--   inject< : ∀ {m n} → m < n → Fin m → Fin n
-- and since `_<_` is `suc m ≤ n`, the instance `n < suc n` is `≤-refl`.
-- `inject<` keeps the first Σ-component, so `toℕ-injectSuc` is still
-- `refl` and no proof below changes.  Only the name was missing.
------------------------------------------------------------------------

injectSuc : {n : ℕ} → Fin n → Fin (suc n)
injectSuc = inject< ≤-refl

------------------------------------------------------------------------
-- The top-splitting.
------------------------------------------------------------------------

topSplit : {n : ℕ} (i : Fin (suc n))
         → (i ≡ flast) ⊎ (Σ[ j ∈ Fin n ] injectSuc j ≡ i)
topSplit {n} (k , k<sn) with ≤-split (pred-≤-pred k<sn)
... | inl k<n  = inr ((k , k<n) , toℕ-injective refl)
... | inr k≡n  = inl (toℕ-injective k≡n)

-- `injectSuc` and `flast` are what they should be on the underlying number:
-- the first is the identity, the second is the level.
toℕ-injectSuc : {n : ℕ} (j : Fin n) → toℕ (injectSuc j) ≡ toℕ j
toℕ-injectSuc j = refl

toℕ-flast : (n : ℕ) → toℕ (flast {n}) ≡ n
toℕ-flast n = refl
