{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- `Cubical.Data.Fin` splits `Fin (suc n)` at the BOTTOM:
--
--   fsplit : (i : Fin (suc n)) → (fzero ≡ i) ⊎ (Σ[ j ∈ Fin n ] fsuc j ≡ i)
--
-- A most-significant-digit tower deletes the TOP, so its inductions need the
-- opposite eliminator.  That mismatch — the library opens the bottom, the
-- object opens the top — was the whole obstruction named in
-- `NaturalMachine.DigitTowerFinLimit`.  It is one lemma, with no digits in it.

module NaturalMachine.FinTopSplit where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order using (_<_ ; _≤_ ; ≤-split ; ≤-refl ; pred-≤-pred ; <-trans)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Data.Fin using (Fin ; toℕ ; toℕ-injective ; inject< ; flast)

------------------------------------------------------------------------
-- v0.5 skew (BUILD.md): the bottom-preserving injection `Fin n → Fin (suc n)`
-- is named `injectSuc` only in later cubical.  v0.5 offers the general
-- `inject< : m < n → Fin m → Fin n`; the instance at `n < suc n` is `≤-refl`
-- (recall `m < n` unfolds to `suc m ≤ n`).  Defined here so the rest of this
-- module and `DigitTowerFinLimit` read as written.
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
