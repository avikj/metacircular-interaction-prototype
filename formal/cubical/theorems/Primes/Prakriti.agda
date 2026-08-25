{-# OPTIONS --cubical --guardedness --safe #-}
module Primes.Prakriti where
-- प्रकृति: EVERY n > 1 has a prime divisor.  Universal, no fuel, no sweep.

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary
open import Cubical.Induction.WellFounded

divides : ℕ → ℕ → Type₀
divides d n = Σ[ c ∈ ℕ ] c · d ≡ n

-- generic bounded decidable search
boundedDec : (P : ℕ → Type₀) → ((d : ℕ) → Dec (P d))
           → (b : ℕ) → Dec (Σ[ d ∈ ℕ ] (d ≤ b) × P d)
boundedDec P dP zero with dP zero
... | yes p = yes (zero , ≤-refl , p)
... | no ¬p = no λ { (d , d≤0 , pd) →
                 ¬p (subst P (≤0→≡0 d≤0) pd) }
boundedDec P dP (suc b) with boundedDec P dP b
... | yes (d , d≤b , pd) = yes (d , ≤-suc d≤b , pd)
... | no ¬prev with dP (suc b)
...   | yes p = yes (suc b , ≤-refl , p)
...   | no ¬here = no λ { (d , d≤sb , pd) → split d d≤sb pd }
  where
  split : (d : ℕ) → d ≤ suc b → P d → ⊥
  split d d≤sb pd with d ≟ suc b
  ... | lt d<sb = ¬prev (d , pred-≤-pred d<sb , pd)
  ... | eq d≡sb = ¬here (subst P d≡sb pd)
  ... | gt sb<d = <-asym sb<d d≤sb

-- c · suc d ≡ n forces c ≤ n
divBound : (d c n : ℕ) → c · suc d ≡ n → c ≤ n
divBound d c n e = subst (c ≤_) e (subst (c ≤_) (sym (·-suc c d)) ≤SumLeft)

decDivides : (d n : ℕ) → Dec (divides d n)
decDivides zero n with discreteℕ zero n
... | yes p = yes (zero , p)
... | no ¬p = no λ { (c , e) → ¬p (0≡m·0 c ∙ e) }
decDivides (suc d) n with boundedDec (λ c → c · suc d ≡ n) (λ c → discreteℕ (c · suc d) n) n
... | yes (c , _ , e) = yes (c , e)
... | no ¬s = no λ { (c , e) → ¬s (c , divBound d c n e , e) }

divTrans : (p d n : ℕ) → divides p d → divides d n → divides p n
divTrans p d n (c₁ , e₁) (c₂ , e₂) =
  (c₂ · c₁ , sym (·-assoc c₂ c₁ p) ∙ cong (c₂ ·_) e₁ ∙ e₂)

IsPrime : ℕ → Type₀
IsPrime p = (1 < p) × ((d : ℕ) → divides d p → (d ≡ 1) ⊎ (d ≡ p))

-- nontrivial divisor: 1 < d < n with d ∣ n
NTD : ℕ → Type₀
NTD n = Σ[ d ∈ ℕ ] ((1 < d) × (d < n)) × divides d n

decNTD : (n : ℕ) → Dec (NTD n)
decNTD n with boundedDec (λ d → ((1 < d) × (d < n)) × divides d n)
                (λ d → decΣ×× d) n
  where
  decΣ×× : (d : ℕ) → Dec (((1 < d) × (d < n)) × divides d n)
  decΣ×× d with 1 ≟ d | d ≟ n | decDivides d n
  ... | lt 1<d | lt d<n | yes dv = yes ((1<d , d<n) , dv)
  ... | lt _   | lt _   | no ¬dv = no λ { (_ , dv) → ¬dv dv }
  ... | lt _   | eq d≡n | _ = no λ { ((_ , d<n) , _) → <-asym d<n (subst (n ≤_) (sym d≡n) ≤-refl) }
  ... | lt _   | gt n<d | _ = no λ { ((_ , d<n) , _) → <-asym d<n (<-weaken n<d) }
  ... | eq 1≡d | _ | _ = no λ { ((1<d , _) , _) → <-asym 1<d (subst (_≤ 1) 1≡d ≤-refl) }
  ... | gt d<1 | _ | _ = no λ { ((1<d , _) , _) → <-asym 1<d (<-weaken d<1) }
... | yes (d , _ , w) = yes (d , w)
... | no ¬s = no λ { (d , (o , d<n) , dv) → ¬s (d , <-weaken d<n , (o , d<n) , dv) }

-- divisor of n is ≤ n when n ≥ 1
divLe : (d n : ℕ) → 0 < n → divides d n → d ≤ n
divLe d n 0<n (zero , e) = Empty.rec (<-asym 0<n (subst (_≤ 0) e ≤-refl))
divLe d n 0<n (suc c , e) =
  subst (d ≤_) e (subst (d ≤_) (sym eq') ≤SumLeft)
  where
  eq' : suc c · d ≡ d + c · d
  eq' = refl

-- ═══ the theorem ═══
module _ where
  open WFI (<-wellfounded)

  Goal : ℕ → Type₀
  Goal n = 1 < n → Σ[ p ∈ ℕ ] IsPrime p × divides p n

  step : (n : ℕ) → ((m : ℕ) → m < n → Goal m) → Goal n
  step n rec 1<n with decNTD n
  ... | yes (d , (1<d , d<n) , dv) =
        let (p , pr , p∣d) = rec d d<n 1<d
        in p , pr , divTrans p d n p∣d dv
  ... | no ¬ntd = n , (1<n , everyDiv) , (1 , ·-identityˡ n)
    where
    everyDiv : (d : ℕ) → divides d n → (d ≡ 1) ⊎ (d ≡ n)
    everyDiv zero (c , e) =
      Empty.rec (<-asym (<-trans ≤-refl 1<n) (subst (_≤ 0) (0≡m·0 c ∙ e) ≤-refl))
    everyDiv (suc zero) _ = inl refl
    everyDiv (suc (suc k)) dv with (suc (suc k)) ≟ n
    ... | lt d<n = Empty.rec (¬ntd (suc (suc k) , (suc-≤-suc (suc-≤-suc zero-≤) , d<n) , dv))
    ... | eq d≡n = inr d≡n
    ... | gt n<d = Empty.rec (<-asym n<d (divLe (suc (suc k)) n (<-trans ≤-refl 1<n) dv))

  primeFactor : (n : ℕ) → 1 < n → Σ[ p ∈ ℕ ] IsPrime p × divides p n
  primeFactor = induction step

-- run it: the proof COMPUTES.  prime factor of 91, of 97, of 2026.
_ : fst (primeFactor 91 (suc-≤-suc (suc-≤-suc zero-≤))) ≡ 7
_ = refl

_ : fst (primeFactor 97 (suc-≤-suc (suc-≤-suc zero-≤))) ≡ 97
_ = refl

_ : fst (primeFactor 2026 (suc-≤-suc (suc-≤-suc zero-≤))) ≡ 2
_ = refl
