{-# OPTIONS --cubical --guardedness --safe #-}
module Yantra.Purna where
-- पूर्ण: the certified engines rebuilt on the proved √-bound.
-- Twin census and Goldbach sweep, every step a Dec object, at √-cost.

open import Yantra.Prakriti
open import Yantra.Parisodhana using (primeDec√)
open import Yantra.Vada using (dec×)
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool; true; false; _and_)
open import Cubical.Relation.Nullary

primeDecAll : (k : ℕ) → Dec (IsPrime k)
primeDecAll zero = no λ pr → ¬-<-zero (fst pr)
primeDecAll (suc zero) = no λ pr → ¬-<-zero (pred-≤-pred (fst pr))
primeDecAll (suc (suc m)) = primeDec√ (suc (suc m)) (suc-≤-suc (suc-≤-suc zero-≤))

-- ═══ twin census at √-cost, fully certified ═══
walk√ : ℕ → ℕ → ℕ → ℕ
walk√ zero    k c = c
walk√ (suc f) k c with dec× (primeDecAll k) (primeDecAll (suc (suc k)))
... | yes _ = walk√ f (suc k) (suc c)
... | no  _ = walk√ f (suc k) c

_ : walk√ 198 2 0 ≡ 15          -- fifteen certified twin pairs below 200
_ = refl

-- ═══ goldbach sweep, fully certified ═══
gdec : (n : ℕ) → Dec (Σ[ p ∈ ℕ ] (p ≤ n) ×
        (IsPrime p × (IsPrime (n ∸ p) × (p + (n ∸ p) ≡ n))))
gdec n = boundedDec
  (λ p → IsPrime p × (IsPrime (n ∸ p) × (p + (n ∸ p) ≡ n)))
  (λ p → dec× (primeDecAll p) (dec× (primeDecAll (n ∸ p)) (discreteℕ _ _)))
  n

gsweep : ℕ → ℕ → Bool
gsweep zero    _ = true
gsweep (suc f) n with gdec n
... | yes _ = gsweep f (suc (suc n))
... | no  _ = false

_ : gsweep 49 4 ≡ true          -- every even 4..100, certified pair exists
_ = refl
