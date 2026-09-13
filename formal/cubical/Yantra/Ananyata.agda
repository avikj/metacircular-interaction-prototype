{-# OPTIONS --cubical --guardedness --safe #-}
module Yantra.Ananyata where
-- अनन्यता: uniqueness.  The multiplicity of every prime in every
-- certified factorization equals the p-adic valuation — so any two
-- factorizations of n agree at every prime.  FTA, whole.

open import Yantra.Prakriti
open import Yantra.Vibhajana using (Prati; product)
open import Yantra.Bhajaka using (euclidLemma)
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.List using (List; []; _∷_)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary

-- v is THE p-valuation of n
Val : ℕ → ℕ → ℕ → Type₀
Val p n v = Σ[ c ∈ ℕ ] (c · (p ^ v) ≡ n) × (¬ divides p c)

-- occurrences of p in a list, by value
countP : ℕ → List Prati → ℕ
countP p [] = 0
countP p ((q , _) ∷ l) with discreteℕ p q
... | yes _ = suc (countP p l)
... | no  _ = countP p l

-- p ∤ 1 for a prime
p∤1 : (p : ℕ) → IsPrime p → ¬ divides p 1
p∤1 p prP dv = <-asym (fst prP) (divLe p 1 ≤-refl dv)

-- ═══ every certified list realizes the valuation of its product ═══
countVal : (p : ℕ) → IsPrime p → (l : List Prati)
         → Val p (product l) (countP p l)
countVal p prP [] = 1 , ·-identityˡ 1 , p∤1 p prP
countVal p prP ((q , prq) ∷ l) with discreteℕ p q | countVal p prP l
... | yes p≡q | (c , e , nd) =
      c ,
      (·-assoc c p (p ^ countP p l)
        ∙ cong (_· (p ^ countP p l)) (·-comm c p)
        ∙ sym (·-assoc p c (p ^ countP p l))
        ∙ cong (p ·_) e
        ∙ cong (_· product l) p≡q) ,
      nd
... | no ¬p≡q | (c , e , nd) = (q · c) , prodeq , ndqc
  where
  prodeq : (q · c) · (p ^ countP p l) ≡ q · product l
  prodeq = sym (·-assoc q c (p ^ countP p l)) ∙ cong (q ·_) e
  ¬p∣q : ¬ divides p q
  ¬p∣q dv with snd prq p dv
  ... | inl p≡1 = <-asym (fst prP) (subst (p ≤_) p≡1 ≤-refl)
  ... | inr p≡q = ¬p≡q p≡q
  ndqc : ¬ divides p (q · c)
  ndqc dv = nd (euclidLemma p q c prP dv ¬p∣q)

-- ═══ the valuation is unique ═══
p∣c·p^ : (p c k : ℕ) → divides p (c · (p ^ suc k))
p∣c·p^ p c k = c · (p ^ k) ,
  (sym (·-assoc c (p ^ k) p)
   ∙ cong (c ·_) (·-comm (p ^ k) p))

valUnique : (p : ℕ) → IsPrime p → (n v v' : ℕ)
          → Val p n v → Val p n v' → v ≡ v'
valUnique p prP n zero zero _ _ = refl
valUnique p prP n zero (suc v') (c , e , nd) (c' , e' , nd') =
  Empty.rec (nd (subst (divides p)
    (e' ∙ sym e ∙ ·-comm c 1 ∙ ·-identityˡ c) (p∣c·p^ p c' v')))
valUnique p prP n (suc v) zero (c , e , nd) (c' , e' , nd') =
  Empty.rec (nd' (subst (divides p)
    (e ∙ sym e' ∙ ·-comm c' 1 ∙ ·-identityˡ c') (p∣c·p^ p c v)))
valUnique p prP n (suc v) (suc v') (c , e , nd) (c' , e' , nd') =
  cong suc (valUnique p prP (c · (p ^ v)) v v'
    (c , refl , nd)
    (c' , inj , nd'))
  where
  shape : (x : ℕ) → 1 < x → Σ[ k ∈ ℕ ] x ≡ suc k
  shape zero hx = Empty.rec (¬-<-zero hx)
  shape (suc k) _ = k , refl
  rearr : (a w : ℕ) → a · (p ^ suc w) ≡ p · (a · (p ^ w))
  rearr a w = ·-assoc a p (p ^ w)
            ∙ cong (_· (p ^ w)) (·-comm a p)
            ∙ sym (·-assoc p a (p ^ w))
  pe : p · (c · (p ^ v)) ≡ p · (c' · (p ^ v'))
  pe = sym (rearr c v) ∙ e ∙ sym e' ∙ rearr c' v'
  inj : c' · (p ^ v') ≡ c · (p ^ v)
  inj = sym (inj-sm· {m = fst (shape p (fst prP))}
          (subst (λ z → z · (c · (p ^ v)) ≡ z · (c' · (p ^ v')))
                 (snd (shape p (fst prP))) pe))

-- ═══ FTA, whole: any two certified factorizations agree everywhere ═══
sameCount : (l₁ l₂ : List Prati) → product l₁ ≡ product l₂
          → (p : ℕ) → IsPrime p → countP p l₁ ≡ countP p l₂
sameCount l₁ l₂ pq p prP =
  valUnique p prP (product l₂) (countP p l₁) (countP p l₂)
    (subst (λ z → Val p z (countP p l₁)) pq (countVal p prP l₁))
    (countVal p prP l₂)
