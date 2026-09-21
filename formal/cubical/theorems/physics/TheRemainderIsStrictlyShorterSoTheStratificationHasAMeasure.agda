{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
--
-- `TheParetoStratumIsDecidableAndTheFilterIsExact` and
-- `ANonEmptyArchiveHasANonEmptyStratum` give one STRATUM; a
-- STRATIFICATION removes the layer and repeats, which needs a
-- termination argument on the archive's length.
--
-- The termination argument is the DECREASING MEASURE, and it is built
-- here.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   filterOut                 the complement of `filterDec`, keeping
--                             exactly what the filter drops
--   partitionLength           `length (filterDec â¦) + length
--                             (filterOut â¦) â‰¡ length xs` â” the two
--                             halves partition, so nothing is lost or
--                             double-counted
--   memberMakesItNonEmpty     a list with a member has length â‰ 1
--   nonEmptyFilterShortensTheComplement
--                             hence if the kept part is non-empty the
--                             dropped part is STRICTLY shorter
--   theRemainderIsStrictlyShorter
--                             instantiated at the Pareto stratum, using
--                             `stratumIsNonEmpty`: peeling the maximal layer off a
--                             non-empty archive strictly shrinks it
--
-- The dependency chain is worth naming because each step was needed by
-- the next: DECIDABILITY of the order gave
-- a computable stratum; the computable stratum plus a decision gave
-- NON-EMPTINESS constructively; non-emptiness gives the STRICT
-- DECREASE.  None of the three could have been taken first.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY.  A filter and its complement partition a list, and a
-- non-empty part forces the other to be shorter; both are elementary.
-- They are proved because the missing piece for the stratification was
-- never the recursion â” it was the measure the recursion decreases.
------------------------------------------------------------------------

module TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; +-suc ; +-comm)
open import Cubical.Data.Nat.Order using (_â‰¤_ ; _<_ ; â‰¤-refl ; â‰¤-k+ ; suc-â‰¤-suc ; zero-â‰¤)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (filterDec ; IsParetoMaximal ; decIsParetoMaximal ; stratum)
open import ANonEmptyArchiveHasANonEmptyStratum
  using (stratumIsNonEmpty)

private
  variable
    A : Type

------------------------------------------------------------------------
-- 1.  The complement of a decidable filter, and the partition
------------------------------------------------------------------------

lengthL : List A â†’ â„•
lengthL []       = zero
lengthL (_ âˆ· xs) = suc (lengthL xs)

filterOut : (P : A â†’ Type) â†’ ((a : A) â†’ Dec (P a)) â†’ List A â†’ List A
filterOut P d []       = []
filterOut P d (x âˆ· xs) with d x
... | yes _ = filterOut P d xs
... | no  _ = x âˆ· filterOut P d xs

partitionLength :
  (P : A â†’ Type) (d : (a : A) â†’ Dec (P a)) (xs : List A)
  â†’ lengthL (filterDec P d xs) + lengthL (filterOut P d xs) â‰¡ lengthL xs
partitionLength P d []       = refl
partitionLength P d (x âˆ· xs) with d x
... | yes _ = cong suc (partitionLength P d xs)
... | no  _ = +-suc (lengthL (filterDec P d xs)) (lengthL (filterOut P d xs))
            âˆ™ cong suc (partitionLength P d xs)

------------------------------------------------------------------------
-- 2.  A list with a member is non-empty
------------------------------------------------------------------------

memberMakesItNonEmpty :
  (xs : List A) (a : A) â†’ Any (Î» y â†’ y â‰¡ a) xs â†’ 1 â‰¤ lengthL xs
memberMakesItNonEmpty []       a e       = âŠ¥.rec e
memberMakesItNonEmpty (x âˆ· xs) a (inl _) = suc-â‰¤-suc zero-â‰¤
memberMakesItNonEmpty (x âˆ· xs) a (inr _) = suc-â‰¤-suc zero-â‰¤

------------------------------------------------------------------------
-- 3.  So a non-empty kept part shortens the dropped part
------------------------------------------------------------------------

nonEmptyFilterShortensTheComplement :
  (P : A â†’ Type) (d : (a : A) â†’ Dec (P a)) (xs : List A) (a : A)
  â†’ Any (Î» y â†’ y â‰¡ a) (filterDec P d xs)
  â†’ lengthL (filterOut P d xs) < lengthL xs
nonEmptyFilterShortensTheComplement P d xs a mem =
  subst (lengthL (filterOut P d xs) <_) (partitionLength P d xs) shifted
  where
    kept : 1 â‰¤ lengthL (filterDec P d xs)
    kept = memberMakesItNonEmpty (filterDec P d xs) a mem

    -- 1 + |out| â‰ |kept| + |out|
    shifted : lengthL (filterOut P d xs)
            < lengthL (filterDec P d xs) + lengthL (filterOut P d xs)
    shifted =
      subst2 _â‰¤_
        (+-comm (lengthL (filterOut P d xs)) 1)
        (+-comm (lengthL (filterOut P d xs)) (lengthL (filterDec P d xs)))
        (â‰¤-k+ {k = lengthL (filterOut P d xs)} kept)

------------------------------------------------------------------------
-- 4.  Instantiated: peeling the maximal layer strictly shrinks the archive
------------------------------------------------------------------------

remainder : List (List â„•) â†’ List (List â„•)
remainder xs =
  filterOut (Î» v â†’ IsParetoMaximal v xs) (Î» v â†’ decIsParetoMaximal v xs) xs

theRemainderIsStrictlyShorter :
  (x : List â„•) (xs : List (List â„•))
  â†’ lengthL (remainder (x âˆ· xs)) < lengthL (x âˆ· xs)
theRemainderIsStrictlyShorter x xs with stratumIsNonEmpty x xs
... | (m , mem) =
  nonEmptyFilterShortensTheComplement
    (Î» v â†’ IsParetoMaximal v (x âˆ· xs))
    (Î» v â†’ decIsParetoMaximal v (x âˆ· xs))
    (x âˆ· xs) m mem

------------------------------------------------------------------------
-- The iteration is written in
-- `TheStratificationTerminatesOnItsOwnLength`:
-- the recursion is four lines and its termination is one induction:
--
--   leftover / strata     peel the maximal layer, recurse on the
--                         remainder, fuelled
--   fuelSuffices          fuel â‰ length â’ the iteration exhausts
--   theStratificationTerminates
--                         `leftover (lengthL xs) xs â‰¡ []` â” the
--                         archive's OWN LENGTH is enough fuel
--
-- The induction applies `theRemainderIsStrictlyShorter` exactly once
-- per step, to turn `lengthL (x âˆ xs) â‰ suc n` into
-- `lengthL (remainder (x âˆ xs)) â‰ n`, which is precisely the recursive
-- call's obligation.  Nothing else is used.
------------------------------------------------------------------------
