{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheStratificationCoversAndItsStrataArePairwiseDisjoint
--
-- `OneStepCoverageAndDisjointnessOfTheLayer` proved the two output
-- properties of the DARWIN Â§5.2 stratification AT ONE STEP â” the layer
-- and the remainder cover the archive and do not overlap.
-- Here the one-step facts are threaded through `strata`,
-- and the termination theorem is what turns the induction's leftover
-- branch into nothing.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   MemSome v sss        v is a member of SOME list in sss
--   filterDecSubset      a member of a filtered list was a member
--   filterOutSubset      likewise for the complement
--   strataSound          a member of ANY stratum of `strata n xs` was a
--                        member of xs â” the stratification invents
--                        nothing
--   coverageStep         `Mem v xs â’ MemSome v (strata n xs) âŠ
--                         Mem v (leftover n xs)` for every fuel n
--   theStratificationCovers
--                        at fuel `lengthL xs` the leftover is empty
--                        (`theStratificationTerminates`), so EVERY
--                        member of the archive lies in some stratum
--   Disjoint / AllDisjointFrom / Pairwise
--                        recursive families, no Fin, no indices
--   theStrataArePairwiseDisjoint
--                        `Pairwise (strata n xs)` for every n and xs
--
-- **THE TWO HALVES ARE NOT SYMMETRIC, and that is the content.**
-- Coverage needs the MEASURE: the induction leaves a leftover at every
-- fuel, and only `theStratificationTerminates` â” proved separately,
-- for its own reasons â” kills it.  Disjointness needs NO measure: it
-- holds at every fuel, including fuels too small to exhaust the
-- archive, because it is inherited step by step from
-- `layerIsDisjoint` plus `strataSound`.  So a truncated stratification
-- is still a partition of what it has reached; it is only COVERAGE
-- that can fail for want of fuel.
--
-- The joint is `strataSound`: pairwise disjointness of the head from
-- ALL later strata is not a one-step fact, and becomes one only once
-- every later stratum is known to sit inside the remainder.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY.  That iterated non-dominated sorting partitions its
-- input is the property it is named for (Goldberg 1989; the
-- fast-non-dominated-sort of Deb et al. 2002 is the standard
-- reference).  What is here is only the checked version of it over
-- this corpus's own `stratum`/`remainder`.
------------------------------------------------------------------------

module TheStratificationCoversAndItsStrataArePairwiseDisjoint where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (filterDec ; stratum)
open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (filterOut ; remainder ; lengthL)
open import TheStratificationTerminatesOnItsOwnLength
  using (leftover ; strata ; theStratificationTerminates)
open import OneStepCoverageAndDisjointnessOfTheLayer
  using (Mem ; layerCovers ; layerIsDisjoint)

private
  variable
    A : Type

------------------------------------------------------------------------
-- 0.  Membership in one of a list of lists
------------------------------------------------------------------------

MemSome : A â†’ List (List A) â†’ Type
MemSome a sss = Any (Î» ys â†’ Mem a ys) sss

------------------------------------------------------------------------
-- 1.  Filtering invents nothing
------------------------------------------------------------------------

filterDecSubset :
  (P : A â†’ Type) (d : (a : A) â†’ Dec (P a)) (xs : List A) (a : A)
  â†’ Mem a (filterDec P d xs) â†’ Mem a xs
filterDecSubset P d []       a e = âŠ¥.rec e
filterDecSubset P d (x âˆ· xs) a m with d x
filterDecSubset P d (x âˆ· xs) a (inl q) | yes _ = inl q
filterDecSubset P d (x âˆ· xs) a (inr r) | yes _ =
  inr (filterDecSubset P d xs a r)
filterDecSubset P d (x âˆ· xs) a m       | no  _ =
  inr (filterDecSubset P d xs a m)

filterOutSubset :
  (P : A â†’ Type) (d : (a : A) â†’ Dec (P a)) (xs : List A) (a : A)
  â†’ Mem a (filterOut P d xs) â†’ Mem a xs
filterOutSubset P d []       a e = âŠ¥.rec e
filterOutSubset P d (x âˆ· xs) a m with d x
filterOutSubset P d (x âˆ· xs) a m       | yes _ =
  inr (filterOutSubset P d xs a m)
filterOutSubset P d (x âˆ· xs) a (inl q) | no  _ = inl q
filterOutSubset P d (x âˆ· xs) a (inr r) | no  _ =
  inr (filterOutSubset P d xs a r)

stratumSubset :
  (xs : List (List â„•)) (v : List â„•) â†’ Mem v (stratum xs) â†’ Mem v xs
stratumSubset xs v = filterDecSubset _ _ xs v

remainderSubset :
  (xs : List (List â„•)) (v : List â„•) â†’ Mem v (remainder xs) â†’ Mem v xs
remainderSubset xs v = filterOutSubset _ _ xs v

------------------------------------------------------------------------
-- 2.  The stratification invents nothing either
------------------------------------------------------------------------

strataSound :
  (n : â„•) (xs : List (List â„•)) (v : List â„•)
  â†’ MemSome v (strata n xs) â†’ Mem v xs
strataSound zero    xs       v e = âŠ¥.rec e
strataSound (suc n) []       v e = âŠ¥.rec e
strataSound (suc n) (x âˆ· xs) v (inl h) = stratumSubset (x âˆ· xs) v h
strataSound (suc n) (x âˆ· xs) v (inr k) =
  remainderSubset (x âˆ· xs) v (strataSound n (remainder (x âˆ· xs)) v k)

------------------------------------------------------------------------
-- 3.  Coverage, with the leftover, at every fuel
------------------------------------------------------------------------

coverageStep :
  (n : â„•) (xs : List (List â„•)) (v : List â„•)
  â†’ Mem v xs â†’ MemSome v (strata n xs) âŠŽ Mem v (leftover n xs)
coverageStep zero    xs       v m = inr m
coverageStep (suc n) []       v e = âŠ¥.rec e
coverageStep (suc n) (x âˆ· xs) v m with layerCovers (x âˆ· xs) v m
... | inl h = inl (inl h)
... | inr r with coverageStep n (remainder (x âˆ· xs)) v r
...   | inl k = inl (inr k)
...   | inr l = inr l

------------------------------------------------------------------------
-- 4.  â¦and the measure removes the leftover
------------------------------------------------------------------------

theStratificationCovers :
  (xs : List (List â„•)) (v : List â„•)
  â†’ Mem v xs â†’ MemSome v (strata (lengthL xs) xs)
theStratificationCovers xs v m with coverageStep (lengthL xs) xs v m
... | inl k = k
... | inr l = âŠ¥.rec (subst (Mem v) (theStratificationTerminates xs) l)

------------------------------------------------------------------------
-- 5.  Pairwise disjointness â” no measure needed
------------------------------------------------------------------------

Disjoint : List (List â„•) â†’ List (List â„•) â†’ Type
Disjoint ys zs = (v : List â„•) â†’ Mem v ys â†’ Mem v zs â†’ âŠ¥

AllDisjointFrom : List (List â„•) â†’ List (List (List â„•)) â†’ Type
AllDisjointFrom ys []         = Unit
AllDisjointFrom ys (zs âˆ· sss) = Disjoint ys zs Ã— AllDisjointFrom ys sss

Pairwise : List (List (List â„•)) â†’ Type
Pairwise []         = Unit
Pairwise (ys âˆ· sss) = AllDisjointFrom ys sss Ã— Pairwise sss

disjointFromTheUnion :
  (ys : List (List â„•)) (sss : List (List (List â„•)))
  â†’ ((v : List â„•) â†’ Mem v ys â†’ MemSome v sss â†’ âŠ¥)
  â†’ AllDisjointFrom ys sss
disjointFromTheUnion ys []         h = tt
disjointFromTheUnion ys (zs âˆ· sss) h =
    (Î» v mv mz â†’ h v mv (inl mz))
  , disjointFromTheUnion ys sss (Î» v mv k â†’ h v mv (inr k))

theStrataArePairwiseDisjoint :
  (n : â„•) (xs : List (List â„•)) â†’ Pairwise (strata n xs)
theStrataArePairwiseDisjoint zero    xs       = tt
theStrataArePairwiseDisjoint (suc n) []       = tt
theStrataArePairwiseDisjoint (suc n) (x âˆ· xs) =
    disjointFromTheUnion (stratum (x âˆ· xs)) (strata n (remainder (x âˆ· xs)))
      (Î» v h k â†’
        layerIsDisjoint (x âˆ· xs) v h
          (strataSound n (remainder (x âˆ· xs)) v k))
  , theStrataArePairwiseDisjoint n (remainder (x âˆ· xs))
