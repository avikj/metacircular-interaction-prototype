{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheParetoStratumIsDecidableAndTheFilterIsExact
--
-- A Pareto stratification EXISTS constructively for an arbitrary
-- archive: the decision on `â‰¼` exists, and with it the stratum is not
-- merely a specification but a computed list.  That matters for
-- `DARWIN_GODEL_MATH.md` Â§5.2 in a way
-- `AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision` could not
-- say: Â§5.2's controller "first selects a Pareto stratum S" and samples
-- inside it, and a controller cannot select what it cannot compute.
-- That module proves there is no best to pick; this one proves
-- the thing Â§5.2 picks INSTEAD is constructible.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   decâ‰ / decâ‰¼             the product order on fitness vectors is
--                           decidable, from `splitâ•-â‰` alone
--   decStrictlyDominates    hence so is strict domination
--   decIsParetoMaximal      hence so is Pareto-maximality against a
--                           finite archive, reusing `decAny`
--   filterDec               the stratum, as a list
--   stratumOnlyKeepsMaximal    soundness â” everything kept is maximal
--   stratumKeepsEveryMaximal   completeness â” nothing maximal is dropped
--
-- Soundness and completeness together are why "the filter is exact":
-- the computed stratum and the specified stratum have the same members,
-- so Â§5.2's first stage denotes.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY.  Decidability of a product order from decidability of its
-- factors, and the soundness/completeness of a decidable filter, are
-- elementary.
------------------------------------------------------------------------

module TheParetoStratumIsDecidableAndTheFilterIsExact where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.Nat.Order using (_â‰¤_ ; _<_ ; <-asym ; splitâ„•-â‰¤)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any ; decAny)
open import AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision
  using (_â‰¼_)

private
  variable
    A : Type

------------------------------------------------------------------------
-- 1.  The order is decidable
------------------------------------------------------------------------

decâ‰¤ : (m n : â„•) â†’ Dec (m â‰¤ n)
decâ‰¤ m n with splitâ„•-â‰¤ m n
... | inl p = yes p
... | inr q = no (<-asym q)

decâ‰¼ : (v w : List â„•) â†’ Dec (v â‰¼ w)
decâ‰¼ []       []       = yes tt
decâ‰¼ []       (_ âˆ· _)  = no (Î» z â†’ z)
decâ‰¼ (_ âˆ· _)  []       = no (Î» z â†’ z)
decâ‰¼ (x âˆ· xs) (y âˆ· ys) with decâ‰¤ x y
... | no Â¬p = no (Î» r â†’ Â¬p (fst r))
... | yes p with decâ‰¼ xs ys
...   | yes q = yes (p , q)
...   | no Â¬q = no (Î» r â†’ Â¬q (snd r))

decNeg : {B : Type} â†’ Dec B â†’ Dec (Â¬ B)
decNeg (yes b) = no (Î» n â†’ n b)
decNeg (no Â¬b) = yes Â¬b

------------------------------------------------------------------------
-- 2.  Hence Pareto-maximality against a finite archive is decidable
------------------------------------------------------------------------

StrictlyDominates : List â„• â†’ List â„• â†’ Type
StrictlyDominates v w = (v â‰¼ w) Ã— (Â¬ (w â‰¼ v))

decStrictlyDominates : (v w : List â„•) â†’ Dec (StrictlyDominates v w)
decStrictlyDominates v w with decâ‰¼ v w
... | no Â¬p = no (Î» r â†’ Â¬p (fst r))
... | yes p with decNeg (decâ‰¼ w v)
...   | yes Â¬q = yes (p , Â¬q)
...   | no Â¬Â¬q = no (Î» r â†’ Â¬Â¬q (snd r))

IsParetoMaximal : List â„• â†’ List (List â„•) â†’ Type
IsParetoMaximal v xs = Â¬ Any (StrictlyDominates v) xs

decIsParetoMaximal :
  (v : List â„•) (xs : List (List â„•)) â†’ Dec (IsParetoMaximal v xs)
decIsParetoMaximal v xs =
  decNeg (decAny (StrictlyDominates v) (decStrictlyDominates v) xs)

------------------------------------------------------------------------
-- 3.  The stratum, as a computed list
------------------------------------------------------------------------

All : (P : A â†’ Type) â†’ List A â†’ Type
All P []       = Unit
All P (x âˆ· xs) = P x Ã— All P xs

filterDec :
  (P : A â†’ Type) â†’ ((a : A) â†’ Dec (P a)) â†’ List A â†’ List A
filterDec P d []       = []
filterDec P d (x âˆ· xs) with d x
... | yes _ = x âˆ· filterDec P d xs
... | no  _ = filterDec P d xs

filterDecOnlyKeepsSatisfiers :
  (P : A â†’ Type) (d : (a : A) â†’ Dec (P a)) (xs : List A)
  â†’ All P (filterDec P d xs)
filterDecOnlyKeepsSatisfiers P d []       = tt
filterDecOnlyKeepsSatisfiers P d (x âˆ· xs) with d x
... | yes p = p , filterDecOnlyKeepsSatisfiers P d xs
... | no  _ = filterDecOnlyKeepsSatisfiers P d xs

filterDecKeepsEverySatisfier :
  (P : A â†’ Type) (d : (a : A) â†’ Dec (P a)) (xs : List A) (a : A)
  â†’ Any (Î» y â†’ y â‰¡ a) xs â†’ P a â†’ Any (Î» y â†’ y â‰¡ a) (filterDec P d xs)
filterDecKeepsEverySatisfier P d []       a e        pa = âŠ¥.rec e
filterDecKeepsEverySatisfier P d (x âˆ· xs) a (inl q)  pa with d x
... | yes _ = inl q
... | no Â¬p = âŠ¥.rec (Â¬p (subst P (sym q) pa))
filterDecKeepsEverySatisfier P d (x âˆ· xs) a (inr m)  pa with d x
... | yes _ = inr (filterDecKeepsEverySatisfier P d xs a m pa)
... | no  _ = filterDecKeepsEverySatisfier P d xs a m pa

------------------------------------------------------------------------
-- 4.  So Â§5.2's first stage denotes
------------------------------------------------------------------------

stratum : List (List â„•) â†’ List (List â„•)
stratum xs = filterDec (Î» v â†’ IsParetoMaximal v xs) (Î» v â†’ decIsParetoMaximal v xs) xs

stratumOnlyKeepsMaximal :
  (xs : List (List â„•)) â†’ All (Î» v â†’ IsParetoMaximal v xs) (stratum xs)
stratumOnlyKeepsMaximal xs =
  filterDecOnlyKeepsSatisfiers (Î» v â†’ IsParetoMaximal v xs)
                               (Î» v â†’ decIsParetoMaximal v xs) xs

stratumKeepsEveryMaximal :
  (xs : List (List â„•)) (v : List â„•)
  â†’ Any (Î» y â†’ y â‰¡ v) xs â†’ IsParetoMaximal v xs
  â†’ Any (Î» y â†’ y â‰¡ v) (stratum xs)
stratumKeepsEveryMaximal xs v =
  filterDecKeepsEverySatisfier (Î» u â†’ IsParetoMaximal u xs)
                               (Î» u â†’ decIsParetoMaximal u xs) xs v

------------------------------------------------------------------------
-- Non-emptiness of the stratum for a non-empty archive is proved in
-- `ANonEmptyArchiveHasANonEmptyStratum`:
--
--   âŠ-irrefl / âŠ-trans   strict domination; transitivity is NOT
--                        inherited from `â‰¼-trans`, the negative half
--                        has to be argued
--   anyMap               `Any` is functorial in its predicate
--   maximalExists        every non-empty archive has a member maximal
--                        in it â” list induction, DECIDING at each step
--                        whether the tail's maximum beats the head; if
--                        it does, the HEAD is maximal, because anything
--                        beating the head would beat it by transitivity
--   stratumIsNonEmpty    hence `stratum (x âˆ xs)` has a member
--
-- The decision that makes the induction constructive is
-- `decStrictlyDominates` above; without it this would need excluded
-- middle, which is the point of having proved decidability first.
------------------------------------------------------------------------
