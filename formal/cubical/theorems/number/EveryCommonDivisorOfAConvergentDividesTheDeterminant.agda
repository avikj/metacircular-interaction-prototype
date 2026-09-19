{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- EveryCommonDivisorOfAConvergentDividesTheDeterminant
--
-- A corollary of the LOSSLESS face, not the missing third face.  Any
-- common divisor of a convergent's numerator and denominator divides the
-- determinant of that convergent and the next ‚î which, under the
-- standard seeds, is ¬1.  So a convergent carries no common factor that
-- the unit determinant does not already bound.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHERE THIS SITS, AND WHAT IT IS NOT
--
-- whether lossless / complete / stable recur for the convergents.
--
--   lossless  answered  (`TheValliConvergentDeterminantAlternates`)
--   stable    answered  (`ConvergentsAreDeterminedByThePrefixOfTheValli`)
--   complete  STILL NOT ANSWERED, and this module does not answer it
--
-- I attempted COMPLETE this cycle and it does not come from the
-- recurrence.  `Purnata.‡‡‡∞‡‡‡‡Ø‡æ-‡ó‡‡∞‡‡‡Æ‡` says enough grant always
-- resolves; at the convergents that is "the vall of a rational
-- terminates, and the last convergent cross-multiplies back to it" ‚î
-- i.e. `num K ¬ b ‚â° a ¬ den K` for the terminal index K.  Every part of
-- that except the cross-multiplication is about how the quotients are
-- PRODUCED, which is the kuaka (`Gati`, `Purnata`, `GurutamaSiddha`),
-- not about the two-step recurrence these modules study.  So the third
-- face needs those modules, and saying that is the honest report; this
-- module is what the attempt produced on the way, and it is a corollary
-- of the first face rather than progress on the third.
--
-- SOURCING LIMIT.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 ‚î NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module EveryCommonDivisorOfAConvergentDividesTheDeterminant where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; suc)
open import Cubical.Data.Int using (‚Ñ§ ; pos ; _¬∑_ ; _-_)
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing.Instances.Int using (‚Ñ§CommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

open import TheValliConvergentDeterminantAlternates
  using (num ; den ; det ; signed ; standardDeterminantIsAUnit)

------------------------------------------------------------------------
-- 1.  Divisibility over ‚, and the one ring identity the proof needs
------------------------------------------------------------------------

_divides_ : ‚Ñ§ ‚Üí ‚Ñ§ ‚Üí Type
d divides x = Œ£[ c ‚àà ‚Ñ§ ] (x ‚â° c ¬∑ d)

private
  pullOut : (x d E F y : ‚Ñ§) ‚Üí (x ¬∑ d) ¬∑ E - F ¬∑ (y ¬∑ d) ‚â° (x ¬∑ E - F ¬∑ y) ¬∑ d
  pullOut x d E F y = solve! ‚Ñ§CommRing

------------------------------------------------------------------------
-- 2.  A common divisor of a convergent divides its determinant
------------------------------------------------------------------------

module _ (a : ‚Ñï ‚Üí ‚Ñ§) (p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ : ‚Ñ§) where

  private
    N : ‚Ñï ‚Üí ‚Ñ§
    N = num a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ

    D : ‚Ñï ‚Üí ‚Ñ§
    D = den a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ

  commonDivisorDividesDet :
    (k : ‚Ñï) (d : ‚Ñ§)
    ‚Üí d divides N k ‚Üí d divides D k
    ‚Üí d divides det a p‚ÇÄ p‚ÇÅ q‚ÇÄ q‚ÇÅ k
  commonDivisorDividesDet k d (x , nx) (y , dy) =
      (x ¬∑ D (suc k) - N (suc k) ¬∑ y)
    , ( cong‚ÇÇ _-_ (cong (_¬∑ D (suc k)) nx) (cong (N (suc k) ¬∑_) dy)
      ‚àô pullOut x d (D (suc k)) (N (suc k)) y )

------------------------------------------------------------------------
-- 3.  Under the standard seeds, that determinant is a unit
------------------------------------------------------------------------

commonDivisorDividesAUnit :
  (a : ‚Ñï ‚Üí ‚Ñ§) (k : ‚Ñï) (d : ‚Ñ§)
  ‚Üí d divides num a (pos 1) (a 0) (pos 0) (pos 1) k
  ‚Üí d divides den a (pos 1) (a 0) (pos 0) (pos 1) k
  ‚Üí d divides signed k (pos 1)
commonDivisorDividesAUnit a k d dn dd =
  subst (d divides_)
    (standardDeterminantIsAUnit a k)
    (commonDivisorDividesDet a (pos 1) (a 0) (pos 0) (pos 1) k d dn dd)

------------------------------------------------------------------------
-- 4.  The report on the third face
--
-- COMPLETE is not here and is not close.  The two convergent modules
-- study a recurrence given a vall; completeness is a statement about
-- where the vall comes from and that it stops.  Anyone continuing this
-- should start from `Gati` and `Purnata`, not from these two.
------------------------------------------------------------------------
