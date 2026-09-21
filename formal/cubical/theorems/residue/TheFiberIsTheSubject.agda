{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheFiberIsTheSubject
--
-- Everywhere else on this line a collision was an obstruction to be
-- reported.  In àµà°àà—ààà°à•ààà¿ it is the subject.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE SAME STRUCTURE, TWO à¨à¯s
--
-- A collision is two points a map identifies and something finer
-- separates.  Read as an obstruction it says: no decoder recovers the
-- finer thing from the coarser.  That reading has been this line's
-- whole business.
--
-- Take the same configuration in Brahmagupta's setting.  The map is the
-- norm N(a,b) = aÂ² + bÂ²; the finer thing is the pair itself.  N collides
-- constantly â” (3,4) and (5,0) both have norm 25 â” so by the obstruction
-- reading the norm "fails" to determine the pair.
--
-- But that failure is the fiber, and the fiber is where àµà°àà—ààà°à•ààà¿
-- lives.  The whole subject is: given k, what are the pairs of norm k?
-- The obstruction reading calls that a barrier and stops.  The
-- àà¾àµà¨à¾ reading calls it a set with a group acting on it and computes.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE ACTION IS THE COMPOSITION LAW
--
-- `PythagoreanTransition.rot-preserves-N` says a norm-1 element carries
-- each fiber to itself, and `rot g u = u âŠ— g` is àà®à¾à-àà¾àµà¨à¾.  So the
-- group acting on the fiber is not an extra structure laid on top of the
-- collision â” it is the composition law that PRODUCES the collision:
--
--     (3,4) âŠ— (0,1) = (âˆ’4,3)
--
-- a different pair, the same norm.  The obstruction and the group action
-- are one fact viewed twice.  Â§4 exhibits the collision as generated,
-- not found.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHY THIS IS THE àà¨àà•à¾à¨àà POINT AND NOT A METAPHOR
--
-- The standing àà¨àà•à¾à¨àà law is that a collapse exists IFF every
-- pair of à¨à¯s agrees.  Plurality is one way to fail that, not the only one.  Here two à¨à¯s â” obstruction and orbit â” disagree
-- about the same configuration, and neither is wrong.  A à¨à¯ that denied
-- the other would be a à¦àà°àà¨à¯: "the norm fails to determine the pair" is
-- true and, asserted alone, hides that the failure is the object of the
-- science; "the fiber is a torsor" is true and, asserted alone, hides
-- that nothing local reads the pair off the norm.
--
-- Both hold simultaneously.  That is not a contradiction to be resolved
-- by choosing; it is the configuration having more structure than one
-- standpoint reports â” and this line's own measure, which prices an
-- absence by its witnesses, is the obstruction à¨à¯ speaking, so it cannot
-- be the arbiter.
------------------------------------------------------------------------

module TheFiberIsTheSubject where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (zero ; suc)
open import Cubical.Data.Int using (â„¤ ; pos ; negsuc)
open import Cubical.Data.Bool using (Bool ; true ; false ; trueâ‰¢false ; falseâ‰¢true)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

open import FiniteInformation using (FactorsThrough)
open import AnyonyaAbhava using (Anyonya ; anyonyaâ†’samsarga)
import PythagoreanTransition as PT
open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)
open PT.Circle â„¤CommRing using (Pair ; N ; _âŠ—_ ; rot ; rot-preserves-N)
open PT using (tri345)

------------------------------------------------------------------------
-- 0.  Two separators, so the disequalities are computations
------------------------------------------------------------------------

isZeroâ„¤ : â„¤ â†’ Bool
isZeroâ„¤ (pos zero) = true
isZeroâ„¤ _          = false

isNegâ„¤ : â„¤ â†’ Bool
isNegâ„¤ (negsuc _) = true
isNegâ„¤ (pos _)    = false

------------------------------------------------------------------------
-- 1.  Two pairs the norm identifies
------------------------------------------------------------------------

five-zero : Pair
five-zero = pos 5 , pos 0

norm-345 : N tri345 â‰¡ pos 25
norm-345 = refl

norm-50 : N five-zero â‰¡ pos 25
norm-50 = refl

same-norm : N tri345 â‰¡ N five-zero
same-norm = refl

------------------------------------------------------------------------
-- 2.  And which are not the same pair
------------------------------------------------------------------------

pairs-differ : Anyonya tri345 five-zero
pairs-differ e = trueâ‰¢false (cong isZeroâ„¤ (sym (cong snd e)))
------------------------------------------------------------------------
-- 3.  So the norm does not determine the pair â” the obstruction à¨à¯
------------------------------------------------------------------------

norm-does-not-factor : Â¬ FactorsThrough N (Î» (u : Pair) â†’ u)
norm-does-not-factor =
  anyonyaâ†’samsarga N (Î» u â†’ u)
    {x = tri345} {x' = five-zero}
    same-norm
    pairs-differ

------------------------------------------------------------------------
-- 4.  The same collision, GENERATED by àà¾àµà¨à¾ â” the orbit à¨à¯
--
-- (0,1) has norm 1, so it carries every fiber to itself; applying it to
-- (3,4) lands on (âˆ’4,3), a different pair of the same norm.  The
-- collision is not stumbled upon, it is produced by the composition law.
------------------------------------------------------------------------

unit-i : Pair
unit-i = pos 0 , pos 1

unit-i-norm : N unit-i â‰¡ pos 1
unit-i-norm = refl

rotated : rot unit-i tri345 â‰¡ (negsuc 3 , pos 3)
rotated = refl

-- and it stays in the fiber, by the general law rather than by computing
rotated-same-norm : N (rot unit-i tri345) â‰¡ N tri345
rotated-same-norm = rot-preserves-N unit-i unit-i-norm tri345

-- a third point of the same fiber, so the fiber is not a pair of points
-- that happened to coincide but an orbit
rotated-differs : Anyonya (rot unit-i tri345) tri345
rotated-differs e = trueâ‰¢false (cong isNegâ„¤ (cong fst e))
------------------------------------------------------------------------
-- 5.  The two readings, side by side, of one configuration
--
--   obstruction   Â FactorsThrough N id            Â§3
--   orbit         N (rot g u) â‰¡ N u for N g â‰¡ 1    Â§4
--
-- The first says the coarse map loses the fine datum.  The second says
-- what is lost is a group orbit.  Neither is derivable from the other:
-- Â§3 is a statement about decoders and Â§4 about an action, and it is the
-- same two pairs both times.
--
-- What this changes for the rest of the line: `Â FactorsThrough` has
-- been read throughout as a deficiency â” a barrier, a cost, a witness
-- count.  It is equally a presentation of the fiber, and where the fiber
-- carries an action the second reading is the productive one.  àà•àà°àµà¾à²
-- descends by moving inside a fiber; it could not begin if the norm
-- determined the pair.
--
-- Brahmagupta's law is exactly the statement that these fibers compose:
-- N(u âŠ— v) = N u Â N v (`PythagoreanTransition.N-âŠ—`).  A composition law
-- ON the fibers is what an obstruction looks like from the other à¨à¯.
------------------------------------------------------------------------
