{-# OPTIONS --safe #-}

module Erdos1 where

open import Agda.Builtin.Nat using (Nat; zero; suc; _+_; _*_; _<_)
open import Agda.Builtin.Equality using (_≡_; refl)
open import Agda.Builtin.List using (List; []; _∷_)

data Bit : Set where O I : Bit

bit : Bit → Nat
bit O = 0
bit I = 1

sum : List Nat → List Bit → Nat
sum [] bs = 0
sum (a ∷ as) [] = 0
sum (a ∷ as) (b ∷ bs) = bit b * a + sum as bs

record Covered (as : List Nat) (d : Nat) : Set where
  constructor cover
  field
    lhs rhs : List Bit
    eq : d + sum as rhs ≡ sum as lhs
open Covered public

-- Full induction hypothesis, exactly in the requested forcing form.
-- "The next element is forced to be >= T" means every candidate below T
-- that is above the current frontier is already a subset-sum difference.
Forced : List Nat → Nat → Nat → Set
Forced as frontier T =
  (x : Nat) → frontier < x → x < T → Covered as x

-- The stronger "complete coverage 0..T" statement used by the copy step.
Complete : List Nat → Nat → Set
Complete as T =
  (d : Nat) → d < T → Covered as d

keep : {as : List Nat} {K d : Nat} → Covered as d → Covered (K ∷ as) d
keep (cover l r p) = cover (O ∷ l) (O ∷ r) p

+-assoc : (a b c : Nat) → (a + b) + c ≡ a + (b + c)
+-assoc zero b c = refl
+-assoc (suc a) b c rewrite +-assoc a b c = refl

copy : {as : List Nat} {K d : Nat} →
       Covered as d → Covered (K ∷ as) (K + d)
copy {K = K} {d = d} (cover l r p) =
  cover (I ∷ l) (O ∷ r) q
  where
  q : (K + d) + sum as r ≡ K + sum as l
  q rewrite +-assoc K d (sum as r) | p = refl

-- This is the exact five-line induction once Complete as T is available:
--
--   K >= T
--   Complete as T
--   => [K,K+T) is covered by copy
--   => K+T >= 2T
--   => the next lawful element is >= 2T.
--
-- The only conversion still required by the proposed proof is:
--
--   all prefix forcing facts up to stage k
--          ==> Complete as (c * 2^k).
--
-- That implication is NOT definitionally the same as Forced:
--
--   Forced as frontier T
--     contains witnesses only for frontier < x < T,
--
-- whereas
--
--   Complete as T
--     additionally requires witnesses for every x <= frontier.
--
-- Prefix heredity preserves old Covered witnesses, so an induction over the
-- complete *history* may establish those missing witnesses.  The formal
-- theorem therefore has to carry that history, rather than erase it to the
-- final Forced predicate.  This file now states the distinction directly;
-- there is no postulate, hole, or assumed conversion.
