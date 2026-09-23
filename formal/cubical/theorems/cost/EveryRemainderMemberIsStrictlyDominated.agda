{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- EveryRemainderMemberIsStrictlyDominated
--
-- `TheStratificationTerminatesOnItsOwnLength` reduced the Pareto line's
-- whole remainder to three properties of the OUTPUT:
--
--   "(1) COVERAGE â¦ (2) DISJOINTNESS â¦ (3) ORDER: nothing says a member
--    of an earlier layer relates by domination to a member of a later
--    one â” which is the property that would make 'stratification' mean
--    what Â§5.2 wants."
--
-- (3) is the one that matters, and this is its first half.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   filterOutOnlyKeepsNonSatisfiers
--                the complement of the filter keeps exactly what fails
--                the predicate â” the mirror of the soundness lemma the
--                measure module already had
--   anyToMember  an `Any` yields a witness TOGETHER WITH its membership,
--                which plain `anyToÎ` discards
--   everyRemainderMemberIsStrictlyDominated
--                every member of `remainder xs` is strictly dominated
--                by a member OF `xs`
--
-- **The double negation is the whole difficulty and it is decidable
-- away.**  `IsParetoMaximal v xs` is `Â Any (StrictlyDominates v) xs`,
-- so failing it gives `Â Â Any â¦`, not `Any â¦`.  The dominator is
-- recovered only because `decAny decStrictlyDominates` makes that `Any`
-- DECIDABLE, hence stable.  This is the fourth cycle on this line to
-- turn on the same decision, and it is the reason the decision was
-- worth proving first.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY.  A filter's complement keeps the non-satisfiers, and a
-- decidable proposition is stable; both elementary.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module EveryRemainderMemberIsStrictlyDominated where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„•)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no ; Decâ†’Stable)

open import OrderAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any ; decAny)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (StrictlyDominates ; decStrictlyDominates ; IsParetoMaximal
        ; decIsParetoMaximal)
open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (filterOut ; remainder)

private
  variable
    A : Type

------------------------------------------------------------------------
-- 1.  The complement keeps exactly the non-satisfiers
------------------------------------------------------------------------

AllL : (P : A â†’ Type) â†’ List A â†’ Type
AllL P []       = Unit
AllL P (x âˆ· xs) = P x Ã— AllL P xs

filterOutOnlyKeepsNonSatisfiers :
  (P : A â†’ Type) (d : (a : A) â†’ Dec (P a)) (xs : List A)
  â†’ AllL (Î» a â†’ Â¬ P a) (filterOut P d xs)
filterOutOnlyKeepsNonSatisfiers P d []       = tt
filterOutOnlyKeepsNonSatisfiers P d (x âˆ· xs) with d x
... | yes _ = filterOutOnlyKeepsNonSatisfiers P d xs
... | no Â¬p = Â¬p , filterOutOnlyKeepsNonSatisfiers P d xs

allAtMemberL :
  (P : A â†’ Type) (xs : List A) (a : A)
  â†’ AllL P xs â†’ Any (Î» y â†’ y â‰¡ a) xs â†’ P a
allAtMemberL P []       a _          e       = âŠ¥.rec e
allAtMemberL P (x âˆ· xs) a (p , _)    (inl q) = subst P q p
allAtMemberL P (x âˆ· xs) a (_ , rest) (inr m) = allAtMemberL P xs a rest m

------------------------------------------------------------------------
-- 2.  An Any yields its witness together with the membership
------------------------------------------------------------------------

anyToMember :
  (P : A â†’ Type) (xs : List A)
  â†’ Any P xs â†’ Î£[ x âˆˆ A ] ((Any (Î» y â†’ y â‰¡ x) xs) Ã— P x)
anyToMember P []       e       = âŠ¥.rec e
anyToMember P (x âˆ· xs) (inl p) = x , (inl refl , p)
anyToMember P (x âˆ· xs) (inr a) with anyToMember P xs a
... | (w , (mem , p)) = w , (inr mem , p)

------------------------------------------------------------------------
-- 3.  So nothing dropped from a layer was undominated
------------------------------------------------------------------------

everyRemainderMemberIsStrictlyDominated :
  (xs : List (List â„•)) (v : List â„•)
  â†’ Any (Î» y â†’ y â‰¡ v) (remainder xs)
  â†’ Î£[ w âˆˆ List â„• ]
      ((Any (Î» y â†’ y â‰¡ w) xs) Ã— StrictlyDominates v w)
everyRemainderMemberIsStrictlyDominated xs v mem =
  anyToMember (StrictlyDominates v) xs dominated
  where
    notMaximal : Â¬ IsParetoMaximal v xs
    notMaximal =
      allAtMemberL (Î» u â†’ Â¬ IsParetoMaximal u xs)
        (filterOut (Î» u â†’ IsParetoMaximal u xs)
                   (Î» u â†’ decIsParetoMaximal u xs) xs)
        v
        (filterOutOnlyKeepsNonSatisfiers (Î» u â†’ IsParetoMaximal u xs)
                                         (Î» u â†’ decIsParetoMaximal u xs) xs)
        mem

    dominated : Any (StrictlyDominates v) xs
    dominated =
      Decâ†’Stable (decAny (StrictlyDominates v) (decStrictlyDominates v) xs)
                 notMaximal
