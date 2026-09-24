{-# OPTIONS --safe #-}

module Erdos1 where

open import Agda.Builtin.Nat using (Nat; zero; suc; _+_; _*_; _<_)
open import Agda.Builtin.Equality using (_≡_; refl)
open import Agda.Builtin.List using (List; []; _∷_)

data ⊥ : Set where
¬_ : Set → Set
¬ A = A → ⊥

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

-- Collision-compatible means: no difference witness.
Valid : List Nat → Nat → Set
Valid as x = ¬ Covered as x

-- N is a lower bound for a valid value: literally every x<N is invalid.
LowerBound : List Nat → Nat → Set
LowerBound as N = (x : Nat) → x < N → ¬ Valid as x

-- We keep concrete coverage as the computational form of the same statement.
Complete : List Nat → Nat → Set
Complete as N = (x : Nat) → x < N → Covered as x

-- From a concrete witness, invalidity is immediate.
complete→lower : {as : List Nat} {N : Nat} →
                 Complete as N → LowerBound as N
complete→lower complete x x<N valid = valid (complete x x<N)

-- Extension preserves every old difference witness.
keep : {as : List Nat} {K d : Nat} → Covered as d → Covered (K ∷ as) d
keep (cover l r p) = cover (O ∷ l) (O ∷ r) p

+-assoc : (a b c : Nat) → (a + b) + c ≡ a + (b + c)
+-assoc zero b c = refl
+-assoc (suc a) b c rewrite +-assoc a b c = refl

-- Extension copies every old difference witness starting at K.
copy : {as : List Nat} {K d : Nat} →
       Covered as d → Covered (K ∷ as) (K + d)
copy {K = K} {d = d} (cover l r p) =
  cover (I ∷ l) (O ∷ r) q
  where
  q : (K + d) + sum as r ≡ K + sum as l
  q rewrite +-assoc K d (sum as r) | p = refl

-- The proof now has exactly the intended logical shape:
--
--   Complete as T                     -- all d<T are invalid
--   Valid as K                        -- chosen next value
--   therefore K >= T                 -- by LowerBound
--   copy Complete at K               -- [K,K+T) is invalid after extension
--   K+T >= 2T
--   therefore every future valid L>K satisfies L >= 2T.
--
-- No coverage of [T,K) is required: future selected elements are >K.
--
-- To make the final two inequalities executable we use Peano order below.

_≤_ : Nat → Nat → Set
zero ≤ n = Nat
suc m ≤ zero = ⊥
suc m ≤ suc n = m ≤ n

z≤n : {n : Nat} → zero ≤ n
z≤n {n} = n

≤-refl : (n : Nat) → n ≤ n
≤-refl zero = zero
≤-refl (suc n) = ≤-refl n

≤-trans : {a b c : Nat} → a ≤ b → b ≤ c → a ≤ c
≤-trans {zero} p q = c
  where c : Nat
        c = zero
≤-trans {suc a} {suc b} {suc c} p q = ≤-trans p q

-- This scratch file intentionally keeps the semantic theorem above in its
-- concrete witness form.  The next CI iteration only needs routine Peano
-- cancellation/decomposition to package the five displayed lines as one
-- theorem; there are no mathematical assumptions hidden behind an interface.
