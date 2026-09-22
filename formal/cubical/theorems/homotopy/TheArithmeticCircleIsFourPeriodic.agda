{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheArithmeticCircleIsFourPeriodic
--
-- Pythagoras and Voevodsky in one statement, with the arithmetic doing
-- the work and univalence saying what it means.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE OBJECT
--
-- `PythagoreanTransition` builds the circle `x¬≤ + y¬≤ = 1` over any
-- commutative ring and turns each norm-one point into an EQUIVALENCE of
-- the pair-type, hence ‚î by `ua` ‚î into a PATH `Pair ‚â° Pair`.  Over ‚ the
-- norm-one points are the four units, and the interesting one is
-- `i = (0,1)`.
--
-- Rotation by `i` is `(a,b) ‚¶ (‚àíb,a)`, the quarter turn.  Four of them
-- are the identity, and the identity's path is `refl`:
--
--     rot-i-order-4  :  (u : Pair) ‚í rot i (rot i (rot i (rot i u))) ‚â° u
--     loop‚¥-is-refl  :  rotPath i ‚àô rotPath i ‚àô rotPath i ‚àô rotPath i ‚â° refl
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THE SECOND LINE SAYS
--
-- `Œ©S¬ ‚â ‚` ‚î the topological circle's loop space is the integers, and
-- `loop‚ø` is never `refl` for `n ‚â† 0`.  The ARITHMETIC circle over ‚ has
-- the same generator-and-loop shape and the loop is **4-periodic**: the
-- map `‚ ‚í (Pair ‚â° Pair)`, `n ‚¶ rotPath i` composed `n` times, factors
-- through `‚/4`.
--
--     the topological circle    œ‚ = ‚
--     the arithmetic circle /‚  four rotations, and the loop closes at 4
--
-- The gap between them is exactly the gap `DescentCostsTheIntegers`
-- charts: over ‚ the norm-one points are four, and it is only on passing
-- to ratios ‚î every Pythagorean triple becoming a rotation,
-- `EveryTripleIsARotation` ‚î that the family becomes infinite.  The
-- arithmetic circle over ‚ is a four-point approximation to a circle, and
-- its loop group says so.
------------------------------------------------------------------------

module TheArithmeticCircleIsFourPeriodic where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; compEquiv ; idEquiv ; equivEq)
open import Cubical.Foundations.Univalence using (ua ; uaCompEquiv ; uaIdEquiv)
open import Cubical.Data.Int using (‚Ñ§ ; pos ; negsuc)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.Data.Int.Properties using (negsucNotpos)
open import Cubical.Algebra.CommRing.Instances.Int using (‚Ñ§CommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

open import PythagoreanTransition using (module Circle)

open Circle ‚Ñ§CommRing using (Pair ; N ; one ; _‚äó_ ; rot ; rotEquiv ; rotPath ; ‚äó-assoc ; ‚äó-id ≥)

------------------------------------------------------------------------
-- 1.  The quarter turn
------------------------------------------------------------------------

i : Pair
i = pos 0 , pos 1

i-norm-one : N i ‚â° pos 1
i-norm-one = refl

-- rotation by i is the quarter turn: the four units cycle, by refl
quarter-1  : rot i (pos 1 , pos 0) ‚â° (pos 0 , pos 1)
quarter-1  = refl

quarter-i  : rot i (pos 0 , pos 1) ‚â° (negsuc 0 , pos 0)
quarter-i  = refl

quarter--1 : rot i (negsuc 0 , pos 0) ‚â° (pos 0 , negsuc 0)
quarter--1 = refl

quarter--i : rot i (pos 0 , negsuc 0) ‚â° (pos 1 , pos 0)
quarter--i = refl

------------------------------------------------------------------------
-- 2.  Four quarter turns are the identity
------------------------------------------------------------------------

rot-i-order-4 : (u : Pair) ‚Üí rot i (rot i (rot i (rot i u))) ‚â° u
rot-i-order-4 u =
    ‚äó-assoc ((u ‚äó i) ‚äó i) i i
  ‚àô ‚äó-assoc (u ‚äó i) i (i ‚äó i)
  ‚àô ‚äó-assoc u i (i ‚äó (i ‚äó i))
  ‚àô ‚äó-id ≥ u

------------------------------------------------------------------------
-- 3.  So the ua-loop closes at four
------------------------------------------------------------------------

e : Pair ‚âÉ Pair
e = rotEquiv i i-norm-one

e‚Å¥-is-id : compEquiv e (compEquiv e (compEquiv e e)) ‚â° idEquiv Pair
e‚Å¥-is-id = equivEq (funExt rot-i-order-4)

loop : Pair ‚â° Pair
loop = rotPath i i-norm-one

loop‚Å¥-is-refl : loop ‚àô (loop ‚àô (loop ‚àô loop)) ‚â° refl
loop‚Å¥-is-refl =
    cong (loop ‚àô_) (cong (loop ‚àô_) (sym (uaCompEquiv e e)))
  ‚àô cong (loop ‚àô_) (sym (uaCompEquiv e (compEquiv e e)))
  ‚àô sym (uaCompEquiv e (compEquiv e (compEquiv e e)))
  ‚àô cong ua e‚Å¥-is-id
  ‚àô uaIdEquiv

------------------------------------------------------------------------
-- 4.  And the loop does not close earlier: i¬≤ is not the unit
------------------------------------------------------------------------

i¬≤ : Pair
i¬≤ = i ‚äó i

i¬≤-is-minus-one : i¬≤ ‚â° (negsuc 0 , pos 0)
i¬≤-is-minus-one = refl

i¬≤‚â¢one : ¬¨ (i¬≤ ‚â° one)
i¬≤‚â¢one p = negsucNotpos 0 1 (cong fst p)

------------------------------------------------------------------------
-- 5.  The reading, with its boundary.
--
-- `Œ©S¬ ‚â ‚`: the topological circle's loop never closes.  The arithmetic
-- circle over ‚ has four norm-one points, its quarter turn generates
-- them, and `loop‚¥-is-refl` says the corresponding path in the universe
-- closes at four.
--
-- The difference is the one `DescentCostsTheIntegers` charts: over ‚ the
-- norm-one points are the units, four of them; on passing to ratios every
-- Pythagorean triple becomes a rotation (`EveryTripleIsARotation`) and
-- the family is infinite.  A four-point circle has a 4-periodic loop, and
-- that is what the arithmetic over ‚ is.
------------------------------------------------------------------------
