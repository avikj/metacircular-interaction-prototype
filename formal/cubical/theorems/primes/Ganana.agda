{-# OPTIONS --cubical --guardedness --safe #-}
module Ganana where

open import Cubical.Foundations.Prelude using (Type; _≡_; refl)
open import Cubical.Data.Nat using (ℕ; zero; suc; _+_; _∸_; _·_)
open import Cubical.Data.Bool using (Bool; true; false; _and_)

_<ᵇ_ : ℕ → ℕ → Bool
m <ᵇ zero = false
zero <ᵇ suc n = true
suc m <ᵇ suc n = m <ᵇ n

_==_ : ℕ → ℕ → Bool
zero == zero = true
zero == suc _ = false
suc _ == zero = false
suc m == suc n = m == n

if_then_else_ : {A : Type} → Bool → A → A → A
if true  then x else y = x
if false then x else y = y

mod : ℕ → ℕ → ℕ
mod m n = go m m
  where
  go : ℕ → ℕ → ℕ
  go zero    r = r
  go (suc f) r = if (r <ᵇ n) then r else go f (r ∸ n)

-- trial division to √n only: stop when d·d > n
prime : ℕ → Bool
prime zero = false
prime (suc zero) = false
prime n = go n 2
  where
  go : ℕ → ℕ → Bool
  go zero    _ = true
  go (suc f) d = if (n <ᵇ (d · d)) then true
                 else (if (mod n d == zero) then false else go f (suc d))

-- गणना: the SIZE of the goldbach fiber, not one witness.
-- unordered pairs p ≤ n∸p, both prime, p + (n∸p) = n.
gcount : ℕ → ℕ
gcount n = go n 2
  where
  go : ℕ → ℕ → ℕ
  go zero    _ = zero
  go (suc f) p = if ((n <ᵇ (p + p)) and true) then zero else
                 (if (prime p and prime (n ∸ p)) then suc (go f (suc p)) else go f (suc p))

-- twin pair counter below N: count p with p, p+2 both prime, p+2 < N
tcount : ℕ → ℕ
tcount N = go N 2
  where
  go : ℕ → ℕ → ℕ
  go zero    _ = zero
  go (suc f) p = if (N <ᵇ suc (suc p)) then zero else
                 (if (prime p and prime (suc (suc p))) then suc (go f (suc p)) else go f (suc p))

-- RUNS: fiber sizes, checked against the literature's values.
_ : gcount 10 ≡ 2      -- {3,7},{5,5}
_ = refl
_ : gcount 100 ≡ 6     -- {3,97},{11,89},{17,83},{29,71},{41,59},{47,53}
_ = refl
_ : gcount 202 ≡ 9
_ = refl
_ : tcount 200 ≡ 15    -- fifteen twin pairs below 200
_ = refl

-- witness-only sweep with the √-bounded primality: first p with both prime
gok : ℕ → Bool
gok n = go n 2
  where
  go : ℕ → ℕ → Bool
  go zero    _ = false
  go (suc f) p = if (n <ᵇ (p + p)) then false else
                 (if (prime p and prime (n ∸ p)) then true else go f (suc p))

fastsweep : ℕ → ℕ → Bool
fastsweep zero    _ = true
fastsweep (suc f) n = gok n and fastsweep f (suc (suc n))

_ : fastsweep 500 4 ≡ true     -- every even 4..1002 witnessed
_ = refl

_ : fastsweep 2500 4 ≡ true    -- every even 4..5002 witnessed
_ = refl

_ : tcount 1000 ≡ 35           -- thirty-five twin pairs below 1000
_ = refl
