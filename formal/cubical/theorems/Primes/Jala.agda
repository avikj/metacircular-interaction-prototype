{-# OPTIONS --cubical --guardedness --safe #-}
module Primes.Jala where
-- जाल: the infinite prime stream, every state carrying its certificate.

open import Primes.Prakriti
open import Primes.Anantata
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (⊥)
import Cubical.Codata.Stream.Base as S

-- Euclid with the bound explicit: the next prime is ≤ n! + 1
effectiveEuclid : (n : ℕ)
                → Σ[ p ∈ ℕ ] IsPrime p × (n < p) × (p ≤ suc (fact n))
effectiveEuclid n = p , pr , above , bound
  where
  N : ℕ
  N = suc (fact n)
  pf : Σ[ p ∈ ℕ ] IsPrime p × divides p N
  pf = primeFactor N (suc-≤-suc (fact-pos n))
  p : ℕ
  p = fst pf
  pr : IsPrime p
  pr = fst (snd pf)
  p∣N : divides p N
  p∣N = snd (snd pf)
  bound : p ≤ N
  bound = divLe p N (suc-≤-suc zero-≤) p∣N
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

Prati : Type₀
Prati = Σ[ p ∈ ℕ ] IsPrime p

-- ═══ the stream: seeded anywhere, certified forever ═══
weave : ℕ → S.Stream Prati
S.Stream.head (weave n) = fst (effectiveEuclid n) , fst (snd (effectiveEuclid n))
S.Stream.tail (weave n) = weave (fst (effectiveEuclid n))

naam : ℕ → S.Stream Prati → ℕ
naam zero s = fst (S.Stream.head s)
naam (suc k) s = naam k (S.Stream.tail s)

-- pressed: the certified stream begins 2, 3, 7
_ : naam 0 (weave 0) ≡ 2
_ = refl
_ : naam 1 (weave 0) ≡ 3
_ = refl
_ : naam 2 (weave 0) ≡ 7
_ = refl
