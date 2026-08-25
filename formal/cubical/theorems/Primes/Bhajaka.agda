{-# OPTIONS --cubical --guardedness --safe #-}
module Primes.Bhajaka where
-- भाजक: euclid's lemma from the gcd, and a prime dividing a product
-- divides one of its factors.  The uniqueness pillar.

open import Primes.Prakriti
open import Primes.Vibhajana using (Prati; product)
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility
  using (_∣_; ∣-untrunc; ∣-left)
open import Cubical.Data.Nat.GCD
  using (gcd; gcdIsGCD; gcd-factorʳ; isCD)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.List using (List; []; _∷_)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)
open import Cubical.Relation.Nullary

-- bridge: my untruncated divides ↔ library ∣
to∣ : {d n : ℕ} → divides d n → d ∣ n
to∣ dv = ∣ dv ∣₁

from∣ : {d n : ℕ} → d ∣ n → divides d n
from∣ = ∣-untrunc

-- ═══ euclid's lemma ═══
euclidLemma : (p a b : ℕ) → IsPrime p
            → divides p (a · b) → ¬ divides p a → divides p b
euclidLemma p a b prP p∣ab ¬p∣a = result
  where
  g : ℕ
  g = gcd p a
  g∣p : divides g p
  g∣p = from∣ (fst (fst (gcdIsGCD p a)))
  g∣a : g ∣ a
  g∣a = snd (fst (gcdIsGCD p a))
  g1 : g ≡ 1
  g1 with snd prP g g∣p
  ... | inl h = h
  ... | inr h = Empty.rec (¬p∣a (from∣ (subst (_∣ a) h g∣a)))
  gPath : gcd (p · b) (a · b) ≡ b
  gPath = gcd-factorʳ p a b ∙ cong (_· b) g1 ∙ ·-identityˡ b
  pCD : isCD (p · b) (a · b) p
  pCD = ∣-left b , to∣ p∣ab
  result : divides p b
  result = from∣ (subst (p ∣_) gPath (snd (gcdIsGCD (p · b) (a · b)) p pCD))

-- membership by value
Mem : ℕ → List Prati → Type₀
Mem p [] = ⊥
Mem p ((q , _) ∷ l) = (p ≡ q) ⊎ Mem p l

-- ═══ a prime dividing a certified product divides a member ═══
pdp : (p : ℕ) → IsPrime p → (l : List Prati)
    → divides p (product l) → Mem p l
pdp p prP [] dv =
  Empty.rec (<-asym (fst prP) (divLe p 1 ≤-refl dv))
pdp p prP ((q , prq) ∷ l) dv with decDivides p q
... | yes p∣q = inl p≡q
  where
  p≡q : p ≡ q
  p≡q with snd prq p p∣q
  ... | inl p≡1 = Empty.rec (<-asym (fst prP) (subst (p ≤_) p≡1 ≤-refl))
  ... | inr h = h
... | no ¬p∣q = inr (pdp p prP l (euclidLemma p q (product l) prP dv ¬p∣q))
