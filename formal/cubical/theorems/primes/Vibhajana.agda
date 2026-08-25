{-# OPTIONS --cubical --guardedness --safe #-}
module Vibhajana where
-- विभाजन: every positive number is a product of primes, with certificates.
-- The existence half of the fundamental theorem, as a running machine.

open import Prakriti
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.List using (List; []; _∷_; map)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Induction.WellFounded

Prati : Type₀
Prati = Σ[ p ∈ ℕ ] IsPrime p

product : List Prati → ℕ
product [] = 1
product ((p , _) ∷ l) = p · product l

-- c with c·p ≡ n, n ≥ 1: c is positive and, when p ≥ 2, strictly below n
cPos : (c p n : ℕ) → c · p ≡ n → 1 ≤ n → 1 ≤ c
cPos zero p n e 1≤n = Empty.rec (¬-<-zero (subst (0 <_) (sym e) 1≤n))
cPos (suc k) _ _ _ _ = suc-≤-suc zero-≤

cBelow : (c p n : ℕ) → c · p ≡ n → 1 ≤ c → 1 < p → c < n
cBelow c p n e 1≤c 1<p =
  subst (c <_) e
    (≤-trans (subst (_≤ c + (c + 0)) (+-comm c 1) (≤-k+ {k = c} one≤))
             (subst (2 · c ≤_) (·-comm p c) (≤-·k {2} {p} {c} 1<p)))
  where
  one≤ : 1 ≤ c + 0
  one≤ = subst (1 ≤_) (sym (+-zero c)) 1≤c
-- ═══ the machine ═══
module _ where
  open WFI (<-wellfounded)

  FGoal : ℕ → Type₀
  FGoal n = 1 ≤ n → Σ[ l ∈ List Prati ] product l ≡ n

  fstep : (n : ℕ) → ((m : ℕ) → m < n → FGoal m) → FGoal n
  fstep zero _ 1≤n = Empty.rec (¬-<-zero 1≤n)
  fstep (suc zero) _ _ = [] , refl
  fstep n@(suc (suc m)) rec _ =
    let (p , pr , (c , e)) = primeFactor n 1<n
        1≤c = cPos c p n e (suc-≤-suc zero-≤)
        (l , el) = rec c (cBelow c p n e 1≤c (fst pr)) 1≤c
    in (p , pr) ∷ l ,
       (cong (p ·_) el ∙ ·-comm p c ∙ e)
    where
    1<n : 1 < n
    1<n = suc-≤-suc (suc-≤-suc zero-≤)

  factor : (n : ℕ) → 1 ≤ n → Σ[ l ∈ List Prati ] product l ≡ n
  factor = induction fstep

-- pressed: 60 factors as 2·2·3·5, each factor carrying IsPrime
_ : map fst (fst (factor 60 (suc-≤-suc zero-≤))) ≡ 2 ∷ 2 ∷ 3 ∷ 5 ∷ []
_ = refl

-- and 97, prime, factors as itself
_ : map fst (fst (factor 97 (suc-≤-suc zero-≤))) ≡ 97 ∷ []
_ = refl
