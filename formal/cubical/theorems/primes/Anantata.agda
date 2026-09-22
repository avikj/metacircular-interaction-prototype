{-# OPTIONS --cubical --guardedness --safe #-}
module Anantata where
-- अनन्तता: there is no largest prime.  ∀ n, a prime above n.

open import Prakriti
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.Empty as Empty using (⊥)

fact : ℕ → ℕ
fact zero = 1
fact (suc n) = suc n · fact n

fact-pos : (n : ℕ) → 0 < fact n
fact-pos zero = ≤-refl
fact-pos (suc n) =
  ≤-trans (fact-pos n)
          (subst (_≤ suc n · fact n) (·-identityˡ (fact n))
                 (≤-·k {1} {suc n} {fact n} (suc-≤-suc zero-≤)))

factDiv : (k n : ℕ) → 0 < k → k ≤ n → divides k (fact n)
factDiv k zero 0<k k≤0 = Empty.rec (<-asym 0<k (subst (k ≤_) (≤0→≡0 k≤0) ≤-refl))
factDiv k (suc n) 0<k k≤sn with k ≟ suc n
... | eq k≡sn = (fact n , (·-comm (fact n) k ∙ cong (_· fact n) k≡sn))
... | lt k<sn =
      let (c , e) = factDiv k n 0<k (pred-≤-pred k<sn)
      in (suc n · c , sym (·-assoc (suc n) c k) ∙ cong (suc n ·_) e)
... | gt sn<k = Empty.rec (<-asym sn<k k≤sn)

-- p ∣ a and p ∣ a+1 forces p ∣ 1
divStep : (p a : ℕ) → divides p a → divides p (a + 1) → divides p 1
divStep p a (c₁ , e₁) (c₂ , e₂) = pull c₁<c₂
  where
  strict : c₁ · p < c₂ · p
  strict = subst2 _<_ (sym e₁) (sym (e₂ ∙ +-comm a 1)) ≤-refl
  c₁<c₂ : c₁ < c₂
  c₁<c₂ with c₁ ≟ c₂
  ... | lt h = h
  ... | eq h = Empty.rec (<-asym strict (subst (_≤ c₁ · p) (cong (_· p) h) ≤-refl))
  ... | gt h = Empty.rec (<-asym strict (≤-·k (<-weaken h)))
  pull : c₁ < c₂ → divides p 1
  pull (k , kp) = (suc k , +-comm p (k · p) ∙ sym one)
    where
    E : 1 + a ≡ (k · p + p) + a
    E = sym (+-comm a 1)
        ∙ sym e₂
        ∙ cong (_· p) (sym kp)
        ∙ sym (·-distribʳ k (suc c₁) p)
        ∙ +-assoc (k · p) p (c₁ · p)
        ∙ cong ((k · p + p) +_) e₁
    one : 1 ≡ k · p + p
    one = inj-+m E

-- ═══ the theorem ═══
euclid : (n : ℕ) → Σ[ p ∈ ℕ ] IsPrime p × (n < p)
euclid n = p , pr , above
  where
  N : ℕ
  N = suc (fact n)
  1<N : 1 < N
  1<N = suc-≤-suc (fact-pos n)
  pf : Σ[ p ∈ ℕ ] IsPrime p × divides p N
  pf = primeFactor N 1<N
  p : ℕ
  p = fst pf
  pr : IsPrime p
  pr = fst (snd pf)
  p∣N : divides p N
  p∣N = snd (snd pf)
  0<p : 0 < p
  0<p = ≤-trans ≤-refl (<-weaken (fst pr))
  contra : p ≤ n → ⊥
  contra p≤n = <-asym (fst pr) p≤1
    where
    p∣1 : divides p 1
    p∣1 = divStep p (fact n) (factDiv p n 0<p p≤n)
                   (subst (divides p) (+-comm 1 (fact n)) p∣N)
    p≤1 : p ≤ 1
    p≤1 = divLe p 1 ≤-refl p∣1
  above : n < p
  above with n ≟ p
  ... | lt h = h
  ... | eq h = Empty.rec (contra (subst (p ≤_) (sym h) ≤-refl))
  ... | gt h = Empty.rec (contra (<-weaken h))

-- it computes: the prime the proof finds above 4 is 5 (from 4!+1 = 25 → 5)
_ : fst (euclid 4) ≡ 5
_ = refl
