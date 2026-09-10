{-# OPTIONS --cubical --guardedness --safe #-}
module Yantra.Bhaga where
-- भाग: proven euclidean division, then the SHAPE of every twin pair:
-- beyond (3,5), twins are (6k+5, 6k+7).  Universal theorem, not census.

open import Yantra.Prakriti
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Induction.WellFounded

-- n ∸ d < n when 0 < d ≤ n
∸-< : (n d : ℕ) → 0 < d → d ≤ n → n ∸ d < n
∸-< n d 0<d d≤n =
  subst (_≤ n) (+-comm (n ∸ d) 1)
        (subst ((n ∸ d) + 1 ≤_) (≤-∸-+-cancel d≤n) (≤-k+ {k = n ∸ d} 0<d))

-- euclidean division, with proof
eucl : (n d : ℕ) → 0 < d → Σ[ q ∈ ℕ ] Σ[ r ∈ ℕ ] (r < d) × (q · d + r ≡ n)
eucl n d 0<d = WFI.induction <-wellfounded {P = DGoal} dstep n
  where
  DGoal : ℕ → Type₀
  DGoal n = Σ[ q ∈ ℕ ] Σ[ r ∈ ℕ ] (r < d) × (q · d + r ≡ n)
  dstep : (n : ℕ) → ((m : ℕ) → m < n → DGoal m) → DGoal n
  dstep n rec with n ≟ d
  ... | lt n<d = zero , n , n<d , refl
  ... | eq n≡d = 1 , 0 , 0<d ,
                 (+-zero (d + 0) ∙ +-zero d ∙ sym n≡d)
  ... | gt d<n =
        let (q , r , r<d , e) = rec (n ∸ d) (∸-< n d 0<d (<-weaken d<n))
        in suc q , r , r<d ,
           (sym (+-assoc d (q · d) r)
            ∙ cong (d +_) e
            ∙ +-comm d (n ∸ d)
            ∙ ≤-∸-+-cancel (<-weaken d<n))

-- helpers to kill impossible orders
4<p→¬p≡1 : (p : ℕ) → 4 < p → p ≡ 1 → ⊥
4<p→¬p≡1 p 4<p p≡1 = ¬-<-zero (pred-≤-pred (subst (4 <_) p≡1 4<p))

4<p→¬p≡2 : (p : ℕ) → 4 < p → p ≡ 2 → ⊥
4<p→¬p≡2 p 4<p p≡2 = ¬-<-zero (pred-≤-pred (pred-≤-pred (subst (4 <_) p≡2 4<p)))

4<p→¬p≡3 : (p : ℕ) → 4 < p → p ≡ 3 → ⊥
4<p→¬p≡3 p 4<p p≡3 = ¬-<-zero (pred-≤-pred (pred-≤-pred (pred-≤-pred (subst (4 <_) p≡3 4<p))))

¬2≡1 : 2 ≡ 1 → ⊥
¬2≡1 h = snotz (injSuc h)

¬3≡1 : 3 ≡ 1 → ⊥
¬3≡1 h = snotz (injSuc h)

-- ═══ the theorem: twin pairs beyond (3,5) sit at 6k+5 ═══
twinShape : (p : ℕ) → IsPrime p → IsPrime (suc (suc p)) → 4 < p
          → Σ[ k ∈ ℕ ] p ≡ 6 · k + 5
twinShape p (1<p , evP) (1<p2 , evP2) 4<p with eucl p 6 (suc-≤-suc zero-≤)
... | q , 0 , _ , e =
      Empty.rec (rec2 (evP 2 (q · 3 , sym (·-assoc q 3 2) ∙ sym (+-zero (q · 6)) ∙ e)))
  where
  rec2 : (2 ≡ 1) ⊎ (2 ≡ p) → ⊥
  rec2 (inl h) = ¬2≡1 h
  rec2 (inr h) = 4<p→¬p≡2 p 4<p (sym h)
... | q , 1 , _ , e =
      Empty.rec (rec3 (evP2 3 (q · 2 + 1 ,
        sym (·-distribʳ (q · 2) 1 3)
        ∙ cong (_+ 3) (sym (·-assoc q 2 3))
        ∙ +-assoc (q · 6) 1 2
        ∙ cong (_+ 2) e
        ∙ +-comm p 2)))
  where
  rec3 : (3 ≡ 1) ⊎ (3 ≡ suc (suc p)) → ⊥
  rec3 (inl h) = ¬3≡1 h
  rec3 (inr h) = 4<p→¬p≡1 p 4<p (sym (injSuc (injSuc h)))
... | q , 2 , _ , e =
      Empty.rec (rec2 (evP 2 (q · 3 + 1 ,
        sym (·-distribʳ (q · 3) 1 2)
        ∙ cong (_+ 2) (sym (·-assoc q 3 2))
        ∙ e)))
  where
  rec2 : (2 ≡ 1) ⊎ (2 ≡ p) → ⊥
  rec2 (inl h) = ¬2≡1 h
  rec2 (inr h) = 4<p→¬p≡2 p 4<p (sym h)
... | q , 3 , _ , e =
      Empty.rec (rec3 (evP 3 (q · 2 + 1 ,
        sym (·-distribʳ (q · 2) 1 3)
        ∙ cong (_+ 3) (sym (·-assoc q 2 3))
        ∙ e)))
  where
  rec3 : (3 ≡ 1) ⊎ (3 ≡ p) → ⊥
  rec3 (inl h) = ¬3≡1 h
  rec3 (inr h) = 4<p→¬p≡3 p 4<p (sym h)
... | q , 4 , _ , e =
      Empty.rec (rec2 (evP 2 (q · 3 + 2 ,
        sym (·-distribʳ (q · 3) 2 2)
        ∙ cong (_+ 4) (sym (·-assoc q 3 2))
        ∙ e)))
  where
  rec2 : (2 ≡ 1) ⊎ (2 ≡ p) → ⊥
  rec2 (inl h) = ¬2≡1 h
  rec2 (inr h) = 4<p→¬p≡2 p 4<p (sym h)
... | q , 5 , _ , e = q , (sym e ∙ cong (_+ 5) (·-comm q 6))
... | q , suc (suc (suc (suc (suc (suc r))))) , r<6 , e =
      Empty.rec (¬-<-zero (pred-≤-pred (pred-≤-pred (pred-≤-pred
                 (pred-≤-pred (pred-≤-pred (pred-≤-pred r<6)))))))

