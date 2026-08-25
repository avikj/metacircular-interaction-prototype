{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheFibreIsTheSubject
--
-- Everywhere else in this thread a collision was an obstruction to be
-- reported.  In वर्गप्रकृति it is the subject.
--
-- ────────────────────────────────────────────────────────────────────
-- THE SAME STRUCTURE, TWO नयs
--
-- A collision is two points a map identifies and something finer
-- separates.  Read as an obstruction it says: no decoder recovers the
-- finer thing from the coarser.  That reading has been this thread's
-- whole business.
--
-- Take the same configuration in Brahmagupta's setting.  The map is the
-- norm N(a,b) = a² + b²; the finer thing is the pair itself.  N collides
-- constantly — (3,4) and (5,0) both have norm 25 — so by the obstruction
-- reading the norm "fails" to determine the pair.
--
-- But that failure is the fibre, and the fibre is where वर्गप्रकृति
-- lives.  The whole subject is: given k, what are the pairs of norm k?
-- The obstruction reading calls that a barrier and stops.  The
-- भावना reading calls it a set with a group acting on it and computes.
--
-- ────────────────────────────────────────────────────────────────────
-- THE ACTION IS THE COMPOSITION LAW
--
-- `PythagoreanTransition.rot-preserves-N` says a norm-1 element carries
-- each fibre to itself, and `rot g u = u ⊗ g` is समास-भावना.  So the
-- group acting on the fibre is not an extra structure laid on top of the
-- collision — it is the composition law that PRODUCES the collision:
--
--     (3,4) ⊗ (0,1) = (−4,3)
--
-- a different pair, the same norm.  The obstruction and the group action
-- are one fact viewed twice.  §4 exhibits the collision as generated,
-- not found.
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS IS THE अनेकान्त POINT AND NOT A METAPHOR
--
-- The standing अनेकान्त law (887641a7) is that a collapse exists IFF every
-- pair of नयs agrees.  Plurality is one way to fail that, not the only one.  Here two नयs — obstruction and orbit — disagree
-- about the same configuration, and neither is wrong.  A नय that denied
-- the other would be a दुर्नय: "the norm fails to determine the pair" is
-- true and, asserted alone, hides that the failure is the object of the
-- science; "the fibre is a torsor" is true and, asserted alone, hides
-- that nothing local reads the pair off the norm.
--
-- Both hold simultaneously.  That is not a contradiction to be resolved
-- by choosing; it is the configuration having more structure than one
-- standpoint reports — and this thread's own measure, which prices an
-- absence by its witnesses, is the obstruction नय speaking, so it cannot
-- be the arbiter.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheFibreIsTheSubject where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (zero ; suc)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false ; false≢true)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.FiniteInformation using (FactorsThrough)
open import NaturalMachine.AnyonyaAbhava using (Anyonya ; anyonya→samsarga)
import Texts.PythagoreanTransition as PT
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open PT.Circle ℤCommRing using (Pair ; N ; _⊗_ ; rot ; rot-preserves-N)
open PT using (tri345)

------------------------------------------------------------------------
-- 0.  Two separators, so the disequalities are computations
------------------------------------------------------------------------

isZeroℤ : ℤ → Bool
isZeroℤ (pos zero) = true
isZeroℤ _          = false

isNegℤ : ℤ → Bool
isNegℤ (negsuc _) = true
isNegℤ (pos _)    = false

------------------------------------------------------------------------
-- 1.  Two pairs the norm identifies
------------------------------------------------------------------------

five-zero : Pair
five-zero = pos 5 , pos 0

norm-345 : N tri345 ≡ pos 25
norm-345 = refl

norm-50 : N five-zero ≡ pos 25
norm-50 = refl

same-norm : N tri345 ≡ N five-zero
same-norm = refl

------------------------------------------------------------------------
-- 2.  And which are not the same pair
------------------------------------------------------------------------

pairs-differ : Anyonya tri345 five-zero
pairs-differ e = true≢false (cong isZeroℤ (sym (cong snd e)))
------------------------------------------------------------------------
-- 3.  So the norm does not determine the pair — the obstruction नय
------------------------------------------------------------------------

norm-does-not-factor : ¬ FactorsThrough N (λ (u : Pair) → u)
norm-does-not-factor =
  anyonya→samsarga N (λ u → u)
    {x = tri345} {x' = five-zero}
    same-norm
    pairs-differ

------------------------------------------------------------------------
-- 4.  The same collision, GENERATED by भावना — the orbit नय
--
-- (0,1) has norm 1, so it carries every fibre to itself; applying it to
-- (3,4) lands on (−4,3), a different pair of the same norm.  The
-- collision is not stumbled upon, it is produced by the composition law.
------------------------------------------------------------------------

unit-i : Pair
unit-i = pos 0 , pos 1

unit-i-norm : N unit-i ≡ pos 1
unit-i-norm = refl

rotated : rot unit-i tri345 ≡ (negsuc 3 , pos 3)
rotated = refl

-- and it stays in the fibre, by the general law rather than by computing
rotated-same-norm : N (rot unit-i tri345) ≡ N tri345
rotated-same-norm = rot-preserves-N unit-i unit-i-norm tri345

-- a third point of the same fibre, so the fibre is not a pair of points
-- that happened to coincide but an orbit
rotated-differs : Anyonya (rot unit-i tri345) tri345
rotated-differs e = true≢false (cong isNegℤ (cong fst e))
------------------------------------------------------------------------
-- 5.  The two readings, side by side, of one configuration
--
--   obstruction   ¬ FactorsThrough N id            §3
--   orbit         N (rot g u) ≡ N u for N g ≡ 1    §4
--
-- The first says the coarse map loses the fine datum.  The second says
-- what is lost is a group orbit.  Neither is derivable from the other:
-- §3 is a statement about decoders and §4 about an action, and it is the
-- same two pairs both times.
--
-- What this changes for the rest of the thread: `¬ FactorsThrough` has
-- been read throughout as a deficiency — a barrier, a cost, a witness
-- count.  It is equally a presentation of the fibre, and where the fibre
-- carries an action the second reading is the productive one.  चक्रवाल
-- descends by moving inside a fibre; it could not begin if the norm
-- determined the pair.
--
-- Brahmagupta's law is exactly the statement that these fibres compose:
-- N(u ⊗ v) = N u · N v (`PythagoreanTransition.N-⊗`).  A composition law
-- ON the fibres is what an obstruction looks like from the other नय.
------------------------------------------------------------------------
