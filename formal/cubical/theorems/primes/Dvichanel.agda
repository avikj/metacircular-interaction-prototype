{-# OPTIONS --cubical --guardedness --safe #-}
module Dvichanel where
-- द्विचैनल: every prime beyond 3 lives in channel 1 or 5 mod 6,
-- and the channel of a sum of two such primes is determined by the pair.

open import Prakriti
open import Bhaga using (eucl; ¬2≡1; ¬3≡1)
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.Empty as Empty using (⊥)

3<p→¬p≡2 : (p : ℕ) → 3 < p → p ≡ 2 → ⊥
3<p→¬p≡2 p 3<p p≡2 = ¬-<-zero (pred-≤-pred (pred-≤-pred (subst (3 <_) p≡2 3<p)))

3<p→¬p≡3 : (p : ℕ) → 3 < p → p ≡ 3 → ⊥
3<p→¬p≡3 p 3<p p≡3 = ¬-<-zero (pred-≤-pred (pred-≤-pred (pred-≤-pred (subst (3 <_) p≡3 3<p))))

kill2 : (p : ℕ) → 3 < p → (2 ≡ 1) ⊎ (2 ≡ p) → ⊥
kill2 p 3<p (inl h) = ¬2≡1 h
kill2 p 3<p (inr h) = 3<p→¬p≡2 p 3<p (sym h)

kill3 : (p : ℕ) → 3 < p → (3 ≡ 1) ⊎ (3 ≡ p) → ⊥
kill3 p 3<p (inl h) = ¬3≡1 h
kill3 p 3<p (inr h) = 3<p→¬p≡3 p 3<p (sym h)

primeShape : (p : ℕ) → IsPrime p → 3 < p
           → Σ[ k ∈ ℕ ] ((p ≡ 6 · k + 1) ⊎ (p ≡ 6 · k + 5))
primeShape p (1<p , ev) 3<p with eucl p 6 (suc-≤-suc zero-≤)
... | q , 0 , _ , e = Empty.rec (kill2 p 3<p (ev 2
        (q · 3 , sym (·-assoc q 3 2) ∙ sym (+-zero (q · 6)) ∙ e)))
... | q , 1 , _ , e = q , inl (sym e ∙ cong (_+ 1) (·-comm q 6))
... | q , 2 , _ , e = Empty.rec (kill2 p 3<p (ev 2
        (q · 3 + 1 , sym (·-distribʳ (q · 3) 1 2) ∙ cong (_+ 2) (sym (·-assoc q 3 2)) ∙ e)))
... | q , 3 , _ , e = Empty.rec (kill3 p 3<p (ev 3
        (q · 2 + 1 , sym (·-distribʳ (q · 2) 1 3) ∙ cong (_+ 3) (sym (·-assoc q 2 3)) ∙ e)))
... | q , 4 , _ , e = Empty.rec (kill2 p 3<p (ev 2
        (q · 3 + 2 , sym (·-distribʳ (q · 3) 2 2) ∙ cong (_+ 4) (sym (·-assoc q 3 2)) ∙ e)))
... | q , 5 , _ , e = q , inr (sym e ∙ cong (_+ 5) (·-comm q 6))
... | q , suc (suc (suc (suc (suc (suc r))))) , r<6 , e =
      Empty.rec (¬-<-zero (pred-≤-pred (pred-≤-pred (pred-≤-pred
                 (pred-≤-pred (pred-≤-pred (pred-≤-pred r<6)))))))

join6 : (a b r s : ℕ) → (6 · a + r) + (6 · b + s) ≡ 6 · (a + b) + (r + s)
join6 a b r s =
  sym (+-assoc (6 · a) r (6 · b + s))
  ∙ cong (6 · a +_) (+-assoc r (6 · b) s
                     ∙ cong (_+ s) (+-comm r (6 · b))
                     ∙ sym (+-assoc (6 · b) r s))
  ∙ +-assoc (6 · a) (6 · b) (r + s)
  ∙ cong (_+ (r + s)) (·-distribˡ 6 a b)

sumChannel : (p q : ℕ) → IsPrime p → IsPrime q → 3 < p → 3 < q
           → Σ[ a ∈ ℕ ] Σ[ b ∈ ℕ ]
             ((p + q ≡ 6 · (a + b) + 2)
            ⊎ ((p + q ≡ 6 · (a + b) + 6)
            ⊎ (p + q ≡ 6 · (a + b) + 10)))
sumChannel p q prP prQ 3<p 3<q with primeShape p prP 3<p | primeShape q prQ 3<q
... | (a , inl ea) | (b , inl eb) = a , b , inl
      ((λ i → ea i + eb i) ∙ join6 a b 1 1)
... | (a , inl ea) | (b , inr eb) = a , b , inr (inl
      ((λ i → ea i + eb i) ∙ join6 a b 1 5))
... | (a , inr ea) | (b , inl eb) = a , b , inr (inl
      ((λ i → ea i + eb i) ∙ +-comm (6 · a + 5) (6 · b + 1) ∙ join6 b a 1 5 ∙ cong (λ z → 6 · z + 6) (+-comm b a)))
... | (a , inr ea) | (b , inr eb) = a , b , inr (inr
      ((λ i → ea i + eb i) ∙ join6 a b 5 5))
