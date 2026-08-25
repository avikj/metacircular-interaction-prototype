{-# OPTIONS --cubical --guardedness --safe #-}
module Primes.Shodhita where
-- शोधित: the RH lane rebuilt on the certified factorization.
-- μ read off factor n; every branch a Dec object; the Mertens gate
-- |M(k)|² ≤ k checked at every k on the certified μ.

open import Primes.Prakriti
open import Primes.Vibhajana using (Prati; product; factor)
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.List using (List; []; _∷_; length)
open import Cubical.Data.Bool using (Bool; true; false; _and_)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary

-- value-membership and duplication, decidably
MemV : ℕ → List Prati → Type₀
MemV x [] = ⊥
MemV x ((q , _) ∷ l) = (x ≡ q) ⊎ MemV x l

decMemV : (x : ℕ) (l : List Prati) → Dec (MemV x l)
decMemV x [] = no λ ()
decMemV x ((q , _) ∷ l) with discreteℕ x q
... | yes p = yes (inl p)
... | no ¬p with decMemV x l
...   | yes m = yes (inr m)
...   | no ¬m = no λ { (inl p) → ¬p p ; (inr m) → ¬m m }

HasDup : List Prati → Type₀
HasDup [] = ⊥
HasDup ((q , _) ∷ l) = MemV q l ⊎ HasDup l

decDup : (l : List Prati) → Dec (HasDup l)
decDup [] = no λ ()
decDup ((q , _) ∷ l) with decMemV q l
... | yes m = yes (inl m)
... | no ¬m with decDup l
...   | yes d = yes (inr d)
...   | no ¬d = no λ { (inl m) → ¬m m ; (inr d) → ¬d d }

parity : ℕ → ℕ                 -- 1 even, 2 odd  (μ = +1 / −1)
parity zero = 1
parity (suc n) with parity n
... | 1 = 2
... | _ = 1

-- certified μ: every branch taken on a proof object
μ̂ : (n : ℕ) → 1 ≤ n → ℕ        -- 0 squarefull, 1 μ=+1, 2 μ=−1
μ̂ n 1≤n with decDup (fst (factor n 1≤n))
... | yes _ = 0
... | no  _ = parity (length (fst (factor n 1≤n)))

-- mertens walk on the certified μ, √-gate held at every step
leB : ℕ → ℕ → Bool
leB a b with a ≟ suc b
... | lt _ = true
... | eq _ = false
... | gt _ = false

upd : ℕ → ℕ → ℕ → ℕ
upd v t x with discreteℕ v t
... | yes _ = suc x
... | no  _ = x

mwalk : ℕ → ℕ → ℕ → ℕ → ℕ × (ℕ × Bool)
mwalk zero    k p m = (p , (m , true))
mwalk (suc f) k p m = wrap (mwalk f (suc k) p' m')
  where
  v : ℕ
  v = μ̂ (suc k) (suc-≤-suc zero-≤)
  p' : ℕ
  p' = upd v 1 p
  m' : ℕ
  m' = upd v 2 m
  gate : Bool
  gate = leB ((p' ∸ m') · (p' ∸ m')) (suc k) and leB ((m' ∸ p') · (m' ∸ p')) (suc k)
  wrap : ℕ × (ℕ × Bool) → ℕ × (ℕ × Bool)
  wrap (P , (M , ok)) = (P , (M , gate and ok))
-- pressed: certified μ agrees with the arithmetic on knowns
_ : μ̂ 30 (suc-≤-suc zero-≤) ≡ 2     -- μ(2·3·5) = −1
_ = refl
_ : μ̂ 12 (suc-≤-suc zero-≤) ≡ 0     -- μ(4·3) = 0
_ = refl
_ : μ̂ 1  (suc-≤-suc zero-≤) ≡ 1     -- μ(1) = +1
_ = refl

-- the certified mertens walk to 60: gate holds throughout, M(60) = −1
_ : snd (snd (mwalk 60 0 0 0)) ≡ true
_ = refl
_ : fst (snd (mwalk 60 0 0 0)) ∸ fst (mwalk 60 0 0 0) ≡ 1
_ = refl
