{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheArithmeticCircleIsFourPeriodic
--
-- Pythagoras and Voevodsky in one statement, with the arithmetic doing
-- the work and univalence saying what it means.
--
-- ────────────────────────────────────────────────────────────────────
-- THE OBJECT
--
-- `PythagoreanTransition` builds the circle `x² + y² = 1` over any
-- commutative ring and turns each norm-one point into an EQUIVALENCE of
-- the pair-type, hence — by `ua` — into a PATH `Pair ≡ Pair`.  Over ℤ the
-- norm-one points are the four units, and the interesting one is
-- `i = (0,1)`.
--
-- Rotation by `i` is `(a,b) ↦ (−b,a)`, the quarter turn.  Four of them
-- are the identity, and the identity's path is `refl`:
--
--     rot-i-order-4  :  (u : Pair) → rot i (rot i (rot i (rot i u))) ≡ u
--     loop⁴-is-refl  :  rotPath i ∙ rotPath i ∙ rotPath i ∙ rotPath i ≡ refl
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THE SECOND LINE SAYS
--
-- `ΩS¹ ≃ ℤ` — the topological circle's loop space is the integers, and
-- `loopⁿ` is never `refl` for `n ≠ 0`.  The ARITHMETIC circle over ℤ has
-- the same generator-and-loop shape and the loop is **4-periodic**: the
-- map `ℤ → (Pair ≡ Pair)`, `n ↦ rotPath i` composed `n` times, factors
-- through `ℤ/4`.
--
--     the topological circle    π₁ = ℤ
--     the arithmetic circle /ℤ  four rotations, and the loop closes at 4
--
-- The gap between them is exactly the gap `DescentCostsTheIntegers`
-- charts: over ℤ the norm-one points are four, and it is only on passing
-- to ratios — every Pythagorean triple becoming a rotation,
-- `EveryTripleIsARotation` — that the family becomes infinite.  The
-- arithmetic circle over ℤ is a four-point approximation to a circle, and
-- its loop group says so.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED
--
-- That `Pair ≡ Pair` over ℤ is `ℤ/4` — the loop space of the universe at
-- `Pair` contains far more than these four paths, and nothing here
-- computes it.  What is proved is that THESE paths close at four.  Nor is
-- any comparison with `Cubical.HITs.S1` formalised: `ΩS¹ ≃ ℤ` is quoted,
-- not used, and the two circles are not connected by any map here.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module TheArithmeticCircleIsFourPeriodic where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; compEquiv ; idEquiv ; equivEq)
open import Cubical.Foundations.Univalence using (ua ; uaCompEquiv ; uaIdEquiv)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Int.Properties using (negsucNotpos)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

open import PythagoreanTransition using (module Circle)

open Circle ℤCommRing using (Pair ; N ; one ; _⊗_ ; rot ; rotEquiv ; rotPath ; ⊗-assoc ; ⊗-idʳ)

------------------------------------------------------------------------
-- 1.  The quarter turn
------------------------------------------------------------------------

i : Pair
i = pos 0 , pos 1

i-norm-one : N i ≡ pos 1
i-norm-one = refl

-- rotation by i is the quarter turn: the four units cycle, by refl
quarter-1  : rot i (pos 1 , pos 0) ≡ (pos 0 , pos 1)
quarter-1  = refl

quarter-i  : rot i (pos 0 , pos 1) ≡ (negsuc 0 , pos 0)
quarter-i  = refl

quarter--1 : rot i (negsuc 0 , pos 0) ≡ (pos 0 , negsuc 0)
quarter--1 = refl

quarter--i : rot i (pos 0 , negsuc 0) ≡ (pos 1 , pos 0)
quarter--i = refl

------------------------------------------------------------------------
-- 2.  Four quarter turns are the identity
------------------------------------------------------------------------

rot-i-order-4 : (u : Pair) → rot i (rot i (rot i (rot i u))) ≡ u
rot-i-order-4 u =
    ⊗-assoc ((u ⊗ i) ⊗ i) i i
  ∙ ⊗-assoc (u ⊗ i) i (i ⊗ i)
  ∙ ⊗-assoc u i (i ⊗ (i ⊗ i))
  ∙ ⊗-idʳ u

------------------------------------------------------------------------
-- 3.  So the ua-loop closes at four
------------------------------------------------------------------------

e : Pair ≃ Pair
e = rotEquiv i i-norm-one

e⁴-is-id : compEquiv e (compEquiv e (compEquiv e e)) ≡ idEquiv Pair
e⁴-is-id = equivEq (funExt rot-i-order-4)

loop : Pair ≡ Pair
loop = rotPath i i-norm-one

loop⁴-is-refl : loop ∙ (loop ∙ (loop ∙ loop)) ≡ refl
loop⁴-is-refl =
    cong (loop ∙_) (cong (loop ∙_) (sym (uaCompEquiv e e)))
  ∙ cong (loop ∙_) (sym (uaCompEquiv e (compEquiv e e)))
  ∙ sym (uaCompEquiv e (compEquiv e (compEquiv e e)))
  ∙ cong ua e⁴-is-id
  ∙ uaIdEquiv

------------------------------------------------------------------------
-- 4.  And the loop does not close earlier: i² is not the unit
------------------------------------------------------------------------

i² : Pair
i² = i ⊗ i

i²-is-minus-one : i² ≡ (negsuc 0 , pos 0)
i²-is-minus-one = refl

i²≢one : ¬ (i² ≡ one)
i²≢one p = negsucNotpos 0 1 (cong fst p)

------------------------------------------------------------------------
-- 5.  The reading, with its boundary.
--
-- `ΩS¹ ≃ ℤ`: the topological circle's loop never closes.  The arithmetic
-- circle over ℤ has four norm-one points, its quarter turn generates
-- them, and `loop⁴-is-refl` says the corresponding path in the universe
-- closes at four.
--
-- The difference is the one `DescentCostsTheIntegers` charts: over ℤ the
-- norm-one points are the units, four of them; on passing to ratios every
-- Pythagorean triple becomes a rotation (`EveryTripleIsARotation`) and
-- the family is infinite.  A four-point circle has a 4-periodic loop, and
-- that is what the arithmetic over ℤ is.
--
-- NOT claimed: that `Pair ≡ Pair` is `ℤ/4` — the universe's loop space at
-- `Pair` holds far more than these paths.  Only that THESE close at four.
------------------------------------------------------------------------
