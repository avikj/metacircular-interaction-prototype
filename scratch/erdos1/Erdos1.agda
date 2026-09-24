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

-- "least lawful next value >= T" in forcing form:
-- every value below T already has a collision witness.
ForcedTo : List Nat → Nat → Set
ForcedTo as T = (d : Nat) → d < T → Covered as d

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

-- This is the exact copy law used by the proposed induction:
--
--   ForcedTo as T
--     gives coverage [0,T)
--
--   inserting K gives
--     old coverage  [0,T)
--     copied coverage [K,K+T)
--
-- Hence these two intervals cover [0,2T) exactly when K <= T.
--
-- But lawfulness from ForcedTo as T says only K >= T (up to endpoints).
-- If K > T, [T,K) is a genuine gap.  Copying [0,T) starting at K does
-- not cover it.
--
-- Therefore the proposed one-line induction closes in the K = T case,
-- but not for an overshoot K > T.  A complete Erdos #1 proof needs an
-- additional theorem showing that the inherited difference structure
-- covers [T,K), or an invariant stronger than ForcedTo as T.
--
-- No postulate or hole is used to assert that missing statement.
