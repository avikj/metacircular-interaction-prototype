{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheStratificationTerminatesOnItsOwnLength
--
-- With the measure of `TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure`
-- in hand the recursion is four lines and its termination is one
-- induction.  The LAYER properties are in the modules cited at the end.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   leftover / strata     the fuelled iteration: peel the maximal
--                         layer, recurse on the remainder
--   lengthZeroGivesNil    a list of length â‰ 0 is empty
--   fuelSuffices          if the fuel is at least the length, the
--                         iteration exhausts the archive
--   theStratificationTerminates
--                         hence `leftover (lengthL xs) xs â‰¡ []` â” the
--                         archive's OWN LENGTH is enough fuel
--
-- The induction is that measure applied once per step:
-- `theRemainderIsStrictlyShorter` turns `lengthL (x âˆ xs) â‰ suc n` into
-- `lengthL (remainder (x âˆ xs)) â‰ n`, which is exactly the recursive
-- call's obligation.  Nothing else is needed.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY.  Fuelled recursion with the fuel bounded by a decreasing
-- measure is the standard way to write a well-founded loop without
-- well-founded machinery.
------------------------------------------------------------------------

module TheStratificationTerminatesOnItsOwnLength where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.Nat.Order
  using (_â‰¤_ ; _<_ ; â‰¤-refl ; â‰¤-trans ; pred-â‰¤-pred ; Â¬-<-zero)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)

open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (stratum)
open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (lengthL ; remainder ; theRemainderIsStrictlyShorter)

------------------------------------------------------------------------
-- 1.  The iteration
------------------------------------------------------------------------

leftover : â„• â†’ List (List â„•) â†’ List (List â„•)
leftover zero    xs       = xs
leftover (suc n) []       = []
leftover (suc n) (x âˆ· xs) = leftover n (remainder (x âˆ· xs))

strata : â„• â†’ List (List â„•) â†’ List (List (List â„•))
strata zero    xs       = []
strata (suc n) []       = []
strata (suc n) (x âˆ· xs) = stratum (x âˆ· xs) âˆ· strata n (remainder (x âˆ· xs))

------------------------------------------------------------------------
-- 2.  Its own length is enough fuel
------------------------------------------------------------------------

lengthZeroGivesNil : (xs : List (List â„•)) â†’ lengthL xs â‰¤ 0 â†’ xs â‰¡ []
lengthZeroGivesNil []       _ = refl
lengthZeroGivesNil (x âˆ· xs) h = âŠ¥.rec (Â¬-<-zero h)

fuelSuffices :
  (n : â„•) (xs : List (List â„•)) â†’ lengthL xs â‰¤ n â†’ leftover n xs â‰¡ []
fuelSuffices zero    xs       h = lengthZeroGivesNil xs h
fuelSuffices (suc n) []       _ = refl
fuelSuffices (suc n) (x âˆ· xs) h =
  fuelSuffices n (remainder (x âˆ· xs))
    (pred-â‰¤-pred (â‰¤-trans (theRemainderIsStrictlyShorter x xs) h))

theStratificationTerminates :
  (xs : List (List â„•)) â†’ leftover (lengthL xs) xs â‰¡ []
theStratificationTerminates xs = fuelSuffices (lengthL xs) xs â‰¤-refl

------------------------------------------------------------------------
-- ORDER, first half: every remainder member is strictly dominated, in
-- `EveryRemainderMemberIsStrictlyDominated`:
--
--   filterOutOnlyKeepsNonSatisfiers   the complement keeps exactly what
--                                     fails the predicate
--   anyToMember                       an `Any` yields its witness WITH
--                                     the membership `anyToÎ` discards
--   everyRemainderMemberIsStrictlyDominated
--                                     every member of `remainder xs` is
--                                     strictly dominated by a member OF
--                                     `xs`
--
-- THE DOUBLE NEGATION IS THE WHOLE DIFFICULTY AND IT IS DECIDED AWAY.
-- `IsParetoMaximal v xs` is `Â Any (StrictlyDominates v) xs`, so failing
-- it gives `Â Â Any â¦`.  The dominator is recovered only because
-- `decAny decStrictlyDominates` makes that `Any` decidable, hence
-- stable.
--
------------------------------------------------------------------------

------------------------------------------------------------------------
-- COVERAGE and DISJOINTNESS AT ONE STEP, in
-- `OneStepCoverageAndDisjointnessOfTheLayer`:
--
--   memberOfFilterSatisfies / memberOfFilterOutFails
--   memberSplits       every member of `xs` is in the filter or its
--                      complement
--   noMemberInBoth     and never in both
--   layerCovers / layerIsDisjoint   the same at `stratum` / `remainder`
--
-- One step is the right unit here, because `strata` peels a layer and
-- recurses on EXACTLY the complement these two are about.  Both are
-- proved for an arbitrary decidable predicate and instantiated once â”
-- nothing about Pareto maximality is used, only that the two filters
-- are complementary, which is why each is three lines.
--
------------------------------------------------------------------------
