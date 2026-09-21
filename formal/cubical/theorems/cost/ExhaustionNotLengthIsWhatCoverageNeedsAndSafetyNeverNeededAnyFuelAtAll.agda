{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ExhaustionNotLengthIsWhatCoverageNeedsAndSafetyNeverNeededAnyFuelAtAll
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- Pareto stratification and fuelled recursion are not objects I can
-- trace to an Indian source, and a fabricated  label would
-- assert a provenance nobody checked.  Checked before naming:
-- `.claude/hooks/priority-ledger.txt` (CURRENT header) and
-- `.claude/hooks/european-frame.txt`; no row applies, and the frame
-- check's scope requires Indian material, of which this module has
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- 1.  THE ASYMMETRY IS THE REAL STATEMENT
--
-- Quoting the three signatures on this line, all read from the source:
--
--   theStrataAreOrdered          : (n : â•) (xs â¦) â’ Ordered (strata n xs)
--   theStrataArePairwiseDisjoint : (n : â•) (xs â¦) â’ Pairwise (strata n xs)
--   theStratificationCovers      : (xs â¦) â’ Mem v xs
--                                  â’ MemSome v (strata (lengthL xs) xs)
--
-- **The two SAFETY properties â” nothing in the output is wrong â” hold
-- at every fuel.  The one COMPLETENESS property â” nothing is missing
-- from the output â” does not.**  That is not an accident of who proved
-- what: under-fuelling truncates the recursion, and a truncated list of
-- correct layers is still correct and still ordered.  It is only
-- shorter.  Â§4 of 4e2a577d exhibits the extreme case at fuel `0`, and
-- the classification says why that case is the only kind of damage
-- possible.
--
-- 2.  WHAT COVERAGE ACTUALLY DEPENDS ON
--
-- `theStratificationCovers` is proved from `coverageStep` â” which is
-- itself stated at every fuel â”
--
--   coverageStep : (n xs v) â’ Mem v xs
--                â’ MemSome v (strata n xs) âŠ Mem v (leftover n xs)
--
-- by killing the right disjunct with `theStratificationTerminates`.
-- So the hypothesis coverage needs is not `lengthL xs â‰ n`; it is
-- **`leftover n xs â‰¡ []`** â” that the fuel EXHAUSTED, not that it was
-- large.  Â§3 below states it that way, and 4e2a577d's
-- `theStratificationCoversAtEverySufficientFuel` becomes the corollary
-- at `fuelSuffices`.
--
-- **THIS IS STRICTLY MORE GENERAL, AND THE GAP IS NOT EMPTY.**
-- `lengthL xs â‰ n` is sufficient for exhaustion and NOT necessary: one
-- layer may remove many members, so an archive of length 2 whose whole
-- content is one antichain exhausts at fuel 1.  Â§4 exhibits exactly
-- that, by `refl`.
--
-- WHAT IS PROVED
--
--   coverageFromExhaustion   `leftover n xs â‰¡ []` â’ coverage at fuel `n`
--   coverageAtTheLength      the old statement, now a corollary
--   antichainOfTwo / exhaustsAtOne / lengthIsTwo
--                            a two-member archive that exhausts at fuel
--                            `1`, so the length bound is not necessary
--   coversAtOne              and coverage does hold there, at a fuel
--                            strictly below `lengthL`
------------------------------------------------------------------------

module ExhaustionNotLengthIsWhatCoverageNeedsAndSafetyNeverNeededAnyFuelAtAll where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)

open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (lengthL)
open import TheStratificationTerminatesOnItsOwnLength
  using (strata ; leftover ; theStratificationTerminates)
open import OneStepCoverageAndDisjointnessOfTheLayer
  using (Mem)
open import TheStratificationCoversAndItsStrataArePairwiseDisjoint
  using (MemSome ; coverageStep)

------------------------------------------------------------------------
-- 3.  Coverage needs exhaustion, not length
------------------------------------------------------------------------

coverageFromExhaustion :
  (n : â„•) (xs : List (List â„•)) (v : List â„•)
  â†’ leftover n xs â‰¡ []
  â†’ Mem v xs â†’ MemSome v (strata n xs)
coverageFromExhaustion n xs v ex m with coverageStep n xs v m
... | inl k = k
... | inr l = âŠ¥.rec (subst (Mem v) ex l)

-- the line's original statement, now a corollary rather than a theorem
coverageAtTheLength :
  (xs : List (List â„•)) (v : List â„•)
  â†’ Mem v xs â†’ MemSome v (strata (lengthL xs) xs)
coverageAtTheLength xs v =
  coverageFromExhaustion (lengthL xs) xs v (theStratificationTerminates xs)

------------------------------------------------------------------------
-- 4.  And the length bound is not necessary
--
-- Two incomparable vectors: neither dominates the other, so the first
-- stratum is the whole archive and the remainder is empty.  The fuel
-- that exhausts is `1`; the length is `2`.  Both facts are `refl`, so
-- the separation costs no argument at all â” which is the point, since
-- 4e2a577d's hypothesis would have demanded fuel `2`.
------------------------------------------------------------------------

antichainOfTwo : List (List â„•)
antichainOfTwo = (1 âˆ· 0 âˆ· []) âˆ· (0 âˆ· 1 âˆ· []) âˆ· []

exhaustsAtOne : leftover 1 antichainOfTwo â‰¡ []
exhaustsAtOne = refl

lengthIsTwo : lengthL antichainOfTwo â‰¡ 2
lengthIsTwo = refl

coversAtOne :
  (v : List â„•) â†’ Mem v antichainOfTwo â†’ MemSome v (strata 1 antichainOfTwo)
coversAtOne v = coverageFromExhaustion 1 antichainOfTwo v exhaustsAtOne
