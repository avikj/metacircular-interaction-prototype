{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- भङ्गि — the breaking, the split.
--
-- WHY THIS FILE EXISTS.  The abstract "THE DISCRETE LOGARITHM IS ONE
-- NON-EQUIVALENCE" says, under WHAT IS NOT CLAIMED, that the factoring
-- literature is not addressed, that the classical reduction of factoring
-- to a zero-divisor split appears elsewhere in the development, and that
-- THE ORDER-FINDING STEP DOES NOT.
--
-- The order-finding step is proved here, and so is the split it feeds.
--
--   §२  `order→sqrt1`   if a has order dividing 2s modulo N, then a^s is
--                       a square root of 1 modulo N.  That is the
--                       order-finding step, and it is two rewrites: the
--                       power law and 2s = s + s.
--
--   §३  `sqrt1-splits`  a square root of 1 that is neither 1 nor −1
--                       modulo N yields a NONTRIVIAL DIVISOR of N — one
--                       that divides N and is neither 1 nor N.  The
--                       proof is Euclid's lemma applied to the two ways
--                       the greatest common divisor can be trivial, and
--                       each way is one of the two excluded values.
--
--   §४  `fifteen-splits`  and it is not vacuous: N = 15, a = 2, whose
--                       order is 4, giving the square root 4 and the
--                       factor 3, all computed rather than asserted.
--
-- WHAT IS STILL NOT PROVED, and it is not a gap in the above: nothing
-- here says the order is easy or hard to FIND, on any machine.  That is
-- a statement about cost, and the corpus's cost results live in
-- theorems/cost; this file supplies the arithmetic the reduction needs
-- and nothing about the price of running it.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9 — the repository pin.
-- --cubical --safe --guardedness, no postulates, no holes.
------------------------------------------------------------------------

module Bhangi_TheOrderFindingStepIsProvedAndANontrivialSquareRootOfOneSplitsTheModulus where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order using (_<_ ; _≤_)
open import Cubical.Data.Nat.Divisibility using (_∣_ ; ∣-refl ; ∣-trans ; ∣-left ; ∣-right ; ∣-untrunc)
open import Cubical.Data.Nat.GCD using (isGCD ; gcd ; gcdIsGCD ; isGCD→gcd≡ ; gcd≡→isGCD ; symGCD)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import WalkJumps using (coprime-cancel)

------------------------------------------------------------------------
-- १ · the arithmetic the step needs.
------------------------------------------------------------------------

pow-+ : (a m n : ℕ) → a ^ (m + n) ≡ (a ^ m) · (a ^ n)
pow-+ a zero    n = sym (·-identityˡ (a ^ n))
pow-+ a (suc m) n = cong (a ·_) (pow-+ a m n) ∙ ·-assoc a (a ^ m) (a ^ n)

double : (s : ℕ) → 2 · s ≡ s + s
double s = cong (s +_) (·-identityˡ s)

-- (y+1)² − 1 = y · (y+2), inside ℕ, with no subtraction on the right.
sq∸1 : (y : ℕ) → (suc y · suc y) ∸ 1 ≡ y · (y + 2)
sq∸1 y = cong (_∸ 1) step₁ ∙ step₂
  where
    step₁ : suc y · suc y ≡ suc (y + y · suc y)
    step₁ = refl
    y+2 : y + 2 ≡ suc (suc y)
    y+2 = +-suc y 1 ∙ cong suc (+-suc y 0) ∙ cong (λ z → suc (suc z)) (+-zero y)
    step₂ : (y + y · suc y) ≡ y · (y + 2)
    step₂ = sym (·-suc y (suc y)) ∙ cong (y ·_) (sym y+2)

------------------------------------------------------------------------
-- २ · THE ORDER-FINDING STEP.
--
-- An exponent that returns a to 1 and is even hands you a square root of
-- 1: halve it.  Nothing here is about how the exponent was obtained.
------------------------------------------------------------------------

order→sqrt1 : (N a s : ℕ)
            → N ∣ ((a ^ (2 · s)) ∸ 1)
            → N ∣ (((a ^ s) · (a ^ s)) ∸ 1)
order→sqrt1 N a s h =
  subst (λ z → N ∣ (z ∸ 1)) (cong (a ^_) (double s) ∙ pow-+ a s s) h

------------------------------------------------------------------------
-- ३ · A NONTRIVIAL SQUARE ROOT OF ONE SPLITS THE MODULUS.
--
-- The greatest common divisor of x−1 with N can be trivial in exactly
-- two ways, and each of them is one of the two values the hypothesis
-- excludes: if it is N then N divides x−1, so x ≡ 1; if it is 1 then
-- Euclid's lemma pushes N onto the other factor, so x ≡ −1.  Anything
-- else is a proper factor.
------------------------------------------------------------------------

NontrivialFactor : ℕ → ℕ → Type
NontrivialFactor N d = (d ∣ N) × (¬ (d ≡ 1)) × (¬ (d ≡ N))

sqrt1-splits :
  (N y : ℕ)
  → N ∣ ((suc y · suc y) ∸ 1)          -- x = suc y is a square root of 1
  → ¬ (N ∣ y)                           -- … and x ≢ 1  (mod N)
  → ¬ (N ∣ (y + 2))                     -- … and x ≢ −1 (mod N)
  → NontrivialFactor N (gcd y N)
sqrt1-splits N y sq notOne notMinusOne =
    gcdIsGCD y N .fst .snd
  , (λ d≡1 → notMinusOne
       (coprime-cancel N y (y + 2)
         (symGCD (gcd≡→isGCD d≡1))
         (subst (N ∣_) (sq∸1 y) sq)))
  , (λ d≡N → notOne (subst (_∣ y) d≡N (gcdIsGCD y N .fst .fst)))

------------------------------------------------------------------------
-- ४ · AND IT IS NOT VACUOUS.
--
-- N = 15, a = 2.  Two has order four modulo fifteen, so s = 2 and the
-- square root is 4; 4 is neither 1 nor −1 modulo 15, and the greatest
-- common divisor of 3 with 15 is 3.  Every step below is computed.
------------------------------------------------------------------------

two-to-the-fourth : (2 ^ (2 · 2)) ∸ 1 ≡ 15
two-to-the-fourth = refl

fifteen-order : 15 ∣ ((2 ^ (2 · 2)) ∸ 1)
fifteen-order = ∣-refl (sym two-to-the-fourth)

fifteen-sqrt1 : 15 ∣ (((2 ^ 2) · (2 ^ 2)) ∸ 1)
fifteen-sqrt1 = order→sqrt1 15 2 2 fifteen-order

-- 4 is not 1 mod 15: 15 does not divide 3.
notOne15 : ¬ (15 ∣ 3)
notOne15 d = fifteen∤three (∣-untrunc d)
  where
    fifteen∤three : Σ[ c ∈ ℕ ] c · 15 ≡ 3 → ⊥
    fifteen∤three (zero  , p) = znots p
    fifteen∤three (suc c , p) = snotz (cong (λ z → z ∸ 3) p)

-- 4 is not −1 mod 15: 15 does not divide 5.
notMinusOne15 : ¬ (15 ∣ 5)
notMinusOne15 d = fifteen∤five (∣-untrunc d)
  where
    fifteen∤five : Σ[ c ∈ ℕ ] c · 15 ≡ 5 → ⊥
    fifteen∤five (zero  , p) = znots p
    fifteen∤five (suc c , p) = snotz (cong (λ z → z ∸ 5) p)

fifteen-splits : NontrivialFactor 15 (gcd 3 15)
fifteen-splits = sqrt1-splits 15 3 fifteen-sqrt1 notOne15 notMinusOne15

gcd-3-15 : gcd 3 15 ≡ 3
gcd-3-15 = refl
