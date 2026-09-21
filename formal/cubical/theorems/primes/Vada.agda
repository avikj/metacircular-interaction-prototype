{-# OPTIONS --cubical --guardedness --safe #-}
module Vada where
-- वाद: the disputed propositions stated INSIDE the machine, with
-- per-instance deciders.  The ∀ is open; every instance is closable.

open import Prakriti
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary

-- ═══ the three statements, verbatim, as types ═══

TwinPrimes : Type₀
TwinPrimes = (n : ℕ) → Σ[ p ∈ ℕ ] IsPrime p × IsPrime (suc (suc p)) × (n < p)

Goldbach : Type₀
Goldbach = (m : ℕ) → 2 ≤ m →
           Σ[ p ∈ ℕ ] Σ[ q ∈ ℕ ] IsPrime p × IsPrime q × (p + q ≡ m + m)

-- ═══ deciding primality of the Σ-definition itself ═══

noNTD→prime : (n : ℕ) → 1 < n → ¬ NTD n → IsPrime n
noNTD→prime n 1<n ¬ntd = 1<n , everyDiv
  where
  everyDiv : (d : ℕ) → divides d n → (d ≡ 1) ⊎ (d ≡ n)
  everyDiv zero (c , e) =
    Empty.rec (<-asym (<-trans ≤-refl 1<n) (subst (_≤ 0) (0≡m·0 c ∙ e) ≤-refl))
  everyDiv (suc zero) _ = inl refl
  everyDiv (suc (suc k)) dv with (suc (suc k)) ≟ n
  ... | lt d<n = Empty.rec (¬ntd (suc (suc k) , (suc-≤-suc (suc-≤-suc zero-≤) , d<n) , dv))
  ... | eq d≡n = inr d≡n
  ... | gt n<d = Empty.rec (<-asym n<d (divLe (suc (suc k)) n (<-trans ≤-refl 1<n) dv))

prime→noNTD : (n : ℕ) → IsPrime n → ¬ NTD n
prime→noNTD n (1<n , ev) (d , (1<d , d<n) , dv) with ev d dv
... | inl d≡1 = <-asym 1<d (subst (_≤ 1) (sym d≡1) ≤-refl)
... | inr d≡n = <-asym d<n (subst (n ≤_) (sym d≡n) ≤-refl)

primeDec : (p : ℕ) → Dec (IsPrime p)
primeDec p with 1 ≟ p
... | eq 1≡p = no λ pr → <-asym (fst pr) (subst (_≤ 1) 1≡p ≤-refl)
... | gt p<1 = no λ pr → <-asym (fst pr) (<-weaken p<1)
... | lt 1<p with decNTD p
...   | yes ntd = no λ pr → prime→noNTD p pr ntd
...   | no ¬ntd = yes (noNTD→prime p 1<p ¬ntd)

dec× : {A B : Type₀} → Dec A → Dec B → Dec (A × B)
dec× (yes a) (yes b) = yes (a , b)
dec× (no ¬a) _ = no λ ab → ¬a (fst ab)
dec× _ (no ¬b) = no λ ab → ¬b (snd ab)

dec< : (m n : ℕ) → Dec (m < n)
dec< m n with m ≟ n
... | lt h = yes h
... | eq h = no λ m<n → <-asym m<n (subst (n ≤_) (sym h) ≤-refl)
... | gt h = no λ m<n → <-asym m<n (<-weaken h)

-- ═══ per-instance deciders ═══

-- twins: is there a twin pair with n < p ≤ bound?
twinAt : (n bound : ℕ)
       → Dec (Σ[ p ∈ ℕ ] (p ≤ bound) × (IsPrime p × IsPrime (suc (suc p)) × (n < p)))
twinAt n bound =
  boundedDec (λ p → IsPrime p × IsPrime (suc (suc p)) × (n < p))
             (λ p → dec× (primeDec p) (dec× (primeDec (suc (suc p))) (dec< n p)))
             bound

-- goldbach at even 2m: primes p, q with p + q = 2m, p searched to bound
goldbachAt : (m bound : ℕ)
           → Dec (Σ[ p ∈ ℕ ] (p ≤ bound) × (IsPrime p × IsPrime ((m + m) ∸ p) × (p + ((m + m) ∸ p) ≡ m + m)))
goldbachAt m bound =
  boundedDec (λ p → IsPrime p × IsPrime ((m + m) ∸ p) × (p + ((m + m) ∸ p) ≡ m + m))
             (λ p → dec× (primeDec p) (dec× (primeDec ((m + m) ∸ p)) (discreteℕ _ _)))
             bound

-- ═══ pressed ═══

extract : {P : ℕ → Type₀} {b : ℕ} → Dec (Σ[ d ∈ ℕ ] (d ≤ b) × P d) → ℕ
extract (yes (d , _)) = d
extract (no _) = zero

-- smallest twin pair beyond 100 is (101,103): a Σ-PROOF, not a boolean
_ : extract (twinAt 100 110) ≡ 101
_ = refl

-- goldbach witness for 60: 60 = 7 + 53, with IsPrime proofs on both
_ : extract (goldbachAt 30 60) ≡ 7
_ = refl
