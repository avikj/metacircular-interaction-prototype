{-# OPTIONS --cubical --safe #-}
-- uttered by the checked proposer (formal/executable/Prastava.agda),
-- judged by the kernel before landing; the source pair is a Sanghatta
-- non-joining critical pair — a theorem the rewriter said it needs.
module Prastuta.P225 where
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)

_∸'_ : ℕ → ℕ → ℕ
n ∸' zero = n
zero ∸' suc _ = zero
suc n ∸' suc m = n ∸' m

le : ℕ → ℕ → ℕ
le zero _ = suc zero
le (suc _) zero = zero
le (suc a) (suc b) = le a b

max' : ℕ → ℕ → ℕ
max' zero n = n
max' (suc m) zero = suc m
max' (suc m) (suc n) = suc (max' m n)

prastava : (a : ℕ) → le (a) (zero) ≡ le ((a + (a · a))) (le (a) (zero))
prastava zero = refl
prastava (suc a) = refl
