{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheCanonicalFuelIsTheArchivesOwnLengthAndOverFuellingIsInert
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- Pareto stratification and fuelled recursion are not objects I can
-- trace to an Indian source, and a fabricated  label would
-- assert a provenance nobody checked.  Checked before naming:
-- `.claude/hooks/priority-ledger.txt` (CURRENT header) and
-- `.claude/hooks/european-frame.txt`; no row applies, and the frame
-- check's scope requires Indian material, of which this module has
-- `overFuel`, `over-fuel` and `moreFuel` return nothing anywhere.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE GAP, NAMED BY THE LINE ITSELF AND LEFT OPEN
--
-- `TheStratificationTerminatesOnItsOwnLength` closes with:
--
--   "`strata` takes the fuel as an argument, so **a caller may
--    under-fuel it**; only `lengthL xs` is proved sufficient, and
--    nothing forces a caller to pass it."
--
-- That is accurate and it is only one side.  `fuelSuffices` proves
-- `lengthL xs` is ENOUGH.  Nothing on the line proves it is not TOO
-- MUCH â” i.e. that two callers passing different sufficient fuels get
-- the same stratification.  Until that is proved, `strata n xs` is a
-- FAMILY indexed by a caller's choice, and no theorem stated at one
-- fuel transfers to another.
--
-- **AND ONE THEOREM ON THIS LINE IS STATED AT EXACTLY ONE FUEL.**
-- Checked by reading the signatures, not the headers:
--
--   theStrataAreOrdered : (n : â•) (xs : â¦) â’ Ordered (strata n xs)
--        â” every fuel.  Ordering is a property of the output's shape.
--   theStratificationCovers : (xs â¦) â’ Mem v xs
--        â’ MemSome v (strata (lengthL xs) xs)
--        â” **`lengthL xs` and nothing else.**
--
-- So coverage was, until Â§2 below, a statement about one point of the
-- family.  Â§3 extends it to every sufficient fuel, and that extension
-- is the reason this module exists rather than being a tidying-up.
--
-- WHAT IS PROVED
--
--   strataNil        `strata n [] â‰¡ []` at every fuel
--   fuelIrrelevant   above the threshold the fuel does not matter:
--                    `lengthL xs â‰ n â’ n â‰ m â’ strata n xs â‰¡ strata m xs`
--   canonicalFuel    hence every sufficient fuel agrees with `lengthL xs`
--   theStratificationCoversAtEverySufficientFuel
--                    coverage, transported off its single point
--   underFuellingIsARealFailureMode
--                    and the caution the line raised is not hypothetical:
--                    at fuel `0` a NON-EMPTY archive produces NO layers
--                    and is left over entire.  Both halves are `refl` â”
--                    the failure needs no arithmetic to exhibit, which
--                    is why "may under-fuel" deserved a witness
--
-- **WHAT THE TWO SIDES TOGETHER SAY, AND IT IS THE POINT.**  The fuel
-- has exactly one degree of freedom that matters: whether it reaches
-- `lengthL xs`.  Below the threshold the output is genuinely wrong (Â§4);
-- at or above it, every choice gives the same list (Â§2).  So
-- `strata (lengthL xs) xs` is not *a* stratification, it is *the* one,
-- and the fuel argument is an implementation detail rather than a
-- parameter of the object â” which is what the line has been assuming in
-- prose since `strata` was written.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheCanonicalFuelIsTheArchivesOwnLengthAndOverFuellingIsInert where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.Nat.Order
  using (_â‰¤_ ; â‰¤-refl ; â‰¤-trans ; pred-â‰¤-pred ; Â¬-<-zero)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)

open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (stratum)
open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (lengthL ; remainder ; theRemainderIsStrictlyShorter)
open import TheStratificationTerminatesOnItsOwnLength
  using (strata ; leftover)
open import OneStepCoverageAndDisjointnessOfTheLayer
  using (Mem)
open import TheStratificationCoversAndItsStrataArePairwiseDisjoint
  using (MemSome ; theStratificationCovers)

------------------------------------------------------------------------
-- 1.  The empty archive, at any fuel
------------------------------------------------------------------------

strataNil : (n : â„•) â†’ strata n [] â‰¡ []
strataNil zero    = refl
strataNil (suc n) = refl

------------------------------------------------------------------------
-- 2.  Above the threshold, the fuel does not matter
--
-- The recursion consumes one unit of fuel per layer and the remainder
-- strictly shortens, so a sufficient fuel is exhausted exactly when the
-- archive is.  The two `âŠ.rec`s are the cases a sufficient fuel makes
-- impossible: fuel `0` on a non-empty archive, and `m` below `n`.
------------------------------------------------------------------------

fuelIrrelevant :
  (n m : â„•) (xs : List (List â„•))
  â†’ lengthL xs â‰¤ n â†’ n â‰¤ m â†’ strata n xs â‰¡ strata m xs
fuelIrrelevant n m [] _ _ = strataNil n âˆ™ sym (strataNil m)
fuelIrrelevant zero    m       (x âˆ· xs) h _   = âŠ¥.rec (Â¬-<-zero h)
fuelIrrelevant (suc n) zero    (x âˆ· xs) _ nâ‰¤m = âŠ¥.rec (Â¬-<-zero nâ‰¤m)
fuelIrrelevant (suc n) (suc m) (x âˆ· xs) h nâ‰¤m =
  cong (stratum (x âˆ· xs) âˆ·_)
    (fuelIrrelevant n m (remainder (x âˆ· xs))
      (pred-â‰¤-pred (â‰¤-trans (theRemainderIsStrictlyShorter x xs) h))
      (pred-â‰¤-pred nâ‰¤m))

canonicalFuel :
  (m : â„•) (xs : List (List â„•))
  â†’ lengthL xs â‰¤ m â†’ strata m xs â‰¡ strata (lengthL xs) xs
canonicalFuel m xs h = sym (fuelIrrelevant (lengthL xs) m xs â‰¤-refl h)

------------------------------------------------------------------------
-- 3.  Coverage, off its single point
------------------------------------------------------------------------

theStratificationCoversAtEverySufficientFuel :
  (m : â„•) (xs : List (List â„•)) (v : List â„•)
  â†’ lengthL xs â‰¤ m â†’ Mem v xs â†’ MemSome v (strata m xs)
theStratificationCoversAtEverySufficientFuel m xs v h mem =
  subst (MemSome v) (sym (canonicalFuel m xs h))
    (theStratificationCovers xs v mem)

------------------------------------------------------------------------
-- 4.  And under-fuelling is not hypothetical
--
-- Both are `refl`: `strata 0` returns no layers whatever it is given,
-- and `leftover 0` returns its input untouched.  So on any non-empty
-- archive the caller gets an empty stratification and the entire
-- archive as remainder, with no error and no indication.
------------------------------------------------------------------------

underFuellingProducesNoLayers :
  (x : List â„•) (xs : List (List â„•)) â†’ strata 0 (x âˆ· xs) â‰¡ []
underFuellingProducesNoLayers x xs = refl

underFuellingLeavesEverything :
  (x : List â„•) (xs : List (List â„•)) â†’ leftover 0 (x âˆ· xs) â‰¡ x âˆ· xs
underFuellingLeavesEverything x xs = refl
