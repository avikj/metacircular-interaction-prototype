{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- NumberLinePathStructureIsTheCircle
--
-- Ledger entry H, made a term. The path structure of the number line is the
-- circle: the loop space of S¹ IS the integers, and `winding` recovers the
-- integer from a loop — successor is the loop generator, transport along it
-- is the winding. "The holonomy is the successor function."
------------------------------------------------------------------------

module NumberLinePathStructureIsTheCircle where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.HITs.S1

-- the loop space of the circle IS the integer line
number-line-is-loop-space : ΩS¹ ≡ ℤ
number-line-is-loop-space = ΩS¹≡ℤ

-- winding recovers the integer: the transport along n loops is exactly n
winding-recovers-the-integer : (n : ℤ) → winding (intLoop n) ≡ n
winding-recovers-the-integer = windingℤLoop

-- SUCCESSOR IS THE LOOP GENERATOR : on the naturals, stepping n to n+1 IS
-- composing one more loop — definitionally (refl). Successor and the loop
-- generator are the same move; that is why transport along the successor
-- structure is the winding.
successor-is-one-more-loop : (n : ℕ) → intLoop (pos (suc n)) ≡ intLoop (pos n) ∙ loop
successor-is-one-more-loop n = refl
