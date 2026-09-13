{-# OPTIONS --cubical --safe #-}
-- uttered by the checked proposer (formal/executable/Prastava.agda),
-- judged by the kernel before landing; the source pair is a Sanghatta
-- non-joining critical pair — a theorem the rewriter said it needs.
module Prastuta.P1449 where
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

-- Euclidean gcd by subtraction, fuel-typed (the close SanghattaSamapti
-- named as owed): fuel a + b bounds the descent, since each step
-- strictly shrinks the sum while both sides are positive.
mutual
  gcdGo : ℕ → ℕ → ℕ → ℕ → ℕ
  gcdGo f (suc zero) a b = gcdF f a (b ∸' a)
  gcdGo f _ a b = gcdF f (a ∸' b) b

  gcdF : ℕ → ℕ → ℕ → ℕ
  gcdF zero a _ = a
  gcdF (suc f) a zero = a
  gcdF (suc f) zero b = b
  gcdF (suc f) (suc a) (suc b) = gcdGo f (le (suc a) (suc b)) (suc a) (suc b)

gcd' : ℕ → ℕ → ℕ
gcd' a b = gcdF (a + b) a b

prastava : (a : ℕ) → max' (le (suc (zero)) (a)) (suc (zero)) ≡ gcd' (le (a) (zero)) (le (suc (zero)) (a))
prastava zero = refl
prastava (suc a) = refl
