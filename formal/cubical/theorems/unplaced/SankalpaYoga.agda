{-# OPTIONS --cubical --safe #-}
-- emitted by interactive/Sankalpa_… from a .sankalpa specification;
-- the laws below ARE the input spec, read as an algorithm.
module SankalpaYoga where
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.List using (List ; [] ; _∷_)

Yoga : List ℕ → ℕ
Yoga [] = zero
Yoga (x ∷ xs) = x + Yoga xs

pariksa1 : Yoga (1 ∷ 2 ∷ 3 ∷ []) ≡ 6
pariksa1 = refl
pariksa2 : Yoga [] ≡ 0
pariksa2 = refl
