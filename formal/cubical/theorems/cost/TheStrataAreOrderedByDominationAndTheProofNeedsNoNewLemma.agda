{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheStrataAreOrderedByDominationAndTheProofNeedsNoNewLemma
--
-- DARWIN Â§5.2's ORDER property, in full: every member of a later
-- stratum is strictly dominated by a member of an earlier one.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- **The argument never needs
-- the later strata's MAXIMALITY.**  It needs only their MEMBERSHIP in
-- the remainder, and `strataSound` â” proved for
-- coverage â” already gives exactly that.  Membership in the peeled
-- archive is all the one-step theorem asks of its input.  So no new
-- lemma exists in this module: the whole content is `strataSound`
-- composed with `everyRemainderMemberIsBeatenByAStratumMember`, plus
-- the same recursive bookkeeping already used for pairwise
-- disjointness.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Beats ys zs        every member of zs is strictly dominated by
--                      some member of ys
--   AllBeaten / Ordered
--                      recursive families over the list of strata, no
--                      indices, matching the shape of `Pairwise`
--   headBeatsEveryLaterStratum
--                      the head stratum beats every member of every
--                      later one
--   theStrataAreOrdered
--                      `Ordered (strata n xs)` for every fuel and
--                      archive
--
-- With `theStratificationCovers` and `theStrataArePairwiseDisjoint`,
-- DARWIN Â§5.2's three output properties â” COVERAGE, DISJOINTNESS,
-- ORDER â” are now all checked over this corpus's own
-- `stratum`/`remainder`.
--
-- NO NOVELTY.  This is the defining property of non-dominated sorting
-- (Goldberg 1989; Deb et al. 2002's fast-non-dominated-sort).
------------------------------------------------------------------------

module TheStrataAreOrderedByDominationAndTheProofNeedsNoNewLemma where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_ ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)

open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (StrictlyDominates ; stratum)
open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (remainder)
open import TheStratificationTerminatesOnItsOwnLength
  using (strata)
open import OneStepCoverageAndDisjointnessOfTheLayer
  using (Mem)
open import TheStratificationCoversAndItsStrataArePairwiseDisjoint
  using (MemSome ; strataSound)
open import EveryRemainderMemberIsBeatenByAStratumMember
  using (everyRemainderMemberIsBeatenByAStratumMember)

------------------------------------------------------------------------
-- 1.  The families
------------------------------------------------------------------------

Beats : List (List â„•) â†’ List (List â„•) â†’ Type
Beats ys zs =
  (v : List â„•) â†’ Mem v zs
  â†’ Î£[ w âˆˆ List â„• ] (Mem w ys Ã— StrictlyDominates v w)

AllBeaten : List (List â„•) â†’ List (List (List â„•)) â†’ Type
AllBeaten ys []         = Unit
AllBeaten ys (zs âˆ· sss) = Beats ys zs Ã— AllBeaten ys sss

Ordered : List (List (List â„•)) â†’ Type
Ordered []         = Unit
Ordered (ys âˆ· sss) = AllBeaten ys sss Ã— Ordered sss

------------------------------------------------------------------------
-- 2.  The head stratum beats every member of every later one
------------------------------------------------------------------------

headBeatsEveryLaterStratum :
  (n : â„•) (xs : List (List â„•)) (v : List â„•)
  â†’ MemSome v (strata n (remainder xs))
  â†’ Î£[ w âˆˆ List â„• ] (Mem w (stratum xs) Ã— StrictlyDominates v w)
headBeatsEveryLaterStratum n xs v k =
  everyRemainderMemberIsBeatenByAStratumMember xs v
    (strataSound n (remainder xs) v k)

beatsFromTheUnion :
  (ys : List (List â„•)) (sss : List (List (List â„•)))
  â†’ ((v : List â„•) â†’ MemSome v sss
       â†’ Î£[ w âˆˆ List â„• ] (Mem w ys Ã— StrictlyDominates v w))
  â†’ AllBeaten ys sss
beatsFromTheUnion ys []         h = tt
beatsFromTheUnion ys (zs âˆ· sss) h =
    (Î» v m â†’ h v (inl m))
  , beatsFromTheUnion ys sss (Î» v k â†’ h v (inr k))

------------------------------------------------------------------------
-- 3.  ORDER, over the whole stratification
------------------------------------------------------------------------

theStrataAreOrdered : (n : â„•) (xs : List (List â„•)) â†’ Ordered (strata n xs)
theStrataAreOrdered zero    xs       = tt
theStrataAreOrdered (suc n) []       = tt
theStrataAreOrdered (suc n) (x âˆ· xs) =
    beatsFromTheUnion (stratum (x âˆ· xs)) (strata n (remainder (x âˆ· xs)))
      (headBeatsEveryLaterStratum n (x âˆ· xs))
  , theStrataAreOrdered n (remainder (x âˆ· xs))
