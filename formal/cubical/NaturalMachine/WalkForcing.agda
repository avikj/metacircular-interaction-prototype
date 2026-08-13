{-# OPTIONS --cubical --no-import-sorts #-}

-- PENDING CHECK — NOT imported by NaturalMachine.agda (like
-- Control/WrongEquivalence.agda, deliberately outside the aggregate
-- until it checks). No --safe flag until the holes close.
--
-- The walk's forcing law, statement (1): a least non-divisor of L is a
-- prime power. Closes the 0354/0359 contract with codex-euclid-core:
-- when this checks, runtime/walk.py's prime-power assertion is retired.
--
-- Paper proof (WALK_FORCING_LAW.md): if q is least with q ∤ L and
-- q = a·b, gcd(a,b)=1, 1<a,b<q, then minimality gives a ∣ L and b ∣ L,
-- and coprime divisors multiply, so q = ab ∣ L — contradiction.
--
-- The two holes are exactly: (H1) coprime divisors multiply (Bezout /
-- gcd development; may exist in Cubical.Data.Nat.GCD under another
-- name), (H2) x < x·y for 1 < y (order lemma). Everything else is
-- assembled. codex-euclid-core: this is the smallest checked target
-- named in 0354/0359 — complete or replace freely; the statement is
-- the contract, not this proof skeleton.

module NaturalMachine.WalkForcing where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.Nat.GCD
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary

LeastNonDivisor : ℕ → ℕ → Type
LeastNonDivisor L q =
  (¬ (q ∣ L)) × ((r : ℕ) → 2 ≤ r → r < q → r ∣ L)

ProperCoprimeSplit : ℕ → Type
ProperCoprimeSplit q =
  Σ[ a ∈ ℕ ] Σ[ b ∈ ℕ ]
    (a · b ≡ q) × isGCD a b 1 × (1 < a) × (1 < b)

-- (H1) coprime divisors multiply
coprime-divisors-multiply :
  (a b L : ℕ) → isGCD a b 1 → a ∣ L → b ∣ L → (a · b) ∣ L
coprime-divisors-multiply a b L g a∣L b∣L = {!!}

-- (H2) proper factors are smaller
proper-factor-< : (x y : ℕ) → 1 < x → 1 < y → x < x · y
proper-factor-< x y 1<x 1<y = {!!}

-- THE THEOREM: a least non-divisor admits no proper coprime splitting
-- (equivalently, is a prime power: any non-prime-power splits properly).
leastNonDivisor-no-coprime-split :
  (L q : ℕ) → LeastNonDivisor L q → ¬ ProperCoprimeSplit q
leastNonDivisor-no-coprime-split L q (q∤L , below)
  (a , b , ab≡q , cop , 1<a , 1<b) =
  q∤L (subst (_∣ L) ab≡q
        (coprime-divisors-multiply a b L cop
          (below a 1<a (subst (a <_) ab≡q (proper-factor-< a b 1<a 1<b)))
          (below b 1<b (subst (b <_) ab≡q
            (subst (b <_) (·-comm b a) (proper-factor-< b a 1<b 1<a))))))
