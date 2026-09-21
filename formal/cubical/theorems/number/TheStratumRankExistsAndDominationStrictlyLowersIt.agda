{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheStratumRankExistsAndDominationStrictlyLowersIt
--
-- ON THE NAME, since this repository's rule (CLAUDE.md, "File naming",
-- owner, 2026-08-19) is to lead with the tradition's term.  **There is
-- no Indian source term for this object and none is invented.**  The
-- object is the rank of a candidate in iterated non-dominated sorting
-- â” Goldberg 1989, and the fast-non-dominated-sort of Deb, Pratap,
-- Agarwal & Meyarivan 2002 â” and that is where it comes from.  The
-- naming rule's own guard says to say so rather than to attach a
--  label to material that is not Indian; this file is an
-- instance of that guard, and the English name is a decision, not a
-- default.  (Where the same corpus DOES have the term â” a-dhana for
-- the debt/asset reading, samacchheda for equalising divisors â” the
-- files carry it.)
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- Every ordering statement on this line so far says "some earlier
-- stratum": `Beats`, `theStrataAreOrdered`, `OrderedM`.  That is
-- weaker than a rank, and the corpus has recorded the gap for several
-- cycles without closing it.  Closed here.
--
-- WHAT IS PROVED
--
--   rank n xs v       the index of v's stratum: 0 if v is maximal in
--                     the archive, else one more than its rank in the
--                     remainder.  Fuel-recursive, no `Fin`, no
--                     well-founded recursion
--   memberIntoFilterOut
--                     a member failing the predicate is a member of the
--                     complement (arbitrary decidable predicate)
--   rankDominatorIsSmaller
--                     **if w strictly dominates v and both are in the
--                     archive, then `rank w < rank v`** â” given enough
--                     fuel, which is `lengthL xs â‰ n`
--
-- **WHY THE FUEL HYPOTHESIS IS NOT A BLEMISH.**  At `n = 0` the rank of
-- everything is 0 and the statement would be false; the hypothesis
-- `lengthL xs â‰ n` makes that case VACUOUS rather than excluded,
-- because a list of length â‰ 0 is empty and has no members.  The same
-- hypothesis is what `fuelSuffices` already needed for termination, so
-- the rank costs no new assumption.
--
-- **WHAT THE RANK BUYS OVER "SOME EARLIER STRATUM".**  A number, hence
-- a comparison that composes: from `rank w < rank v` and
-- `rank z < rank w` one gets `rank z < rank v` by transitivity on â•,
-- whereas "beaten by a member of an earlier stratum" needs the whole
-- stratification to chain.  It is also the form in which selection
-- pressure is usually stated.
------------------------------------------------------------------------

module TheStratumRankExistsAndDominationStrictlyLowersIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.Nat.Order
  using (_â‰¤_ ; _<_ ; zero-â‰¤ ; suc-â‰¤-suc ; pred-â‰¤-pred ; â‰¤-trans)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (memberToAny)
open import OneStepCoverageAndDisjointnessOfTheLayer using (Mem)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (StrictlyDominates ; IsParetoMaximal ; decIsParetoMaximal)
open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (lengthL ; filterOut ; remainder ; theRemainderIsStrictlyShorter)
open import TheStratificationTerminatesOnItsOwnLength
  using (lengthZeroGivesNil)

private
  variable
    A : Type

------------------------------------------------------------------------
-- 1.  Into the complement
------------------------------------------------------------------------

memberIntoFilterOut :
  (P : A â†’ Type) (d : (a : A) â†’ Dec (P a)) (xs : List A) (a : A)
  â†’ Mem a xs â†’ Â¬ P a â†’ Mem a (filterOut P d xs)
memberIntoFilterOut P d []       a e       Â¬p = âŠ¥.rec e
memberIntoFilterOut P d (x âˆ· xs) a m       Â¬p with d x
memberIntoFilterOut P d (x âˆ· xs) a (inl q) Â¬p | yes px =
  âŠ¥.rec (Â¬p (subst P q px))
memberIntoFilterOut P d (x âˆ· xs) a (inr r) Â¬p | yes _ =
  memberIntoFilterOut P d xs a r Â¬p
memberIntoFilterOut P d (x âˆ· xs) a (inl q) Â¬p | no _ = inl q
memberIntoFilterOut P d (x âˆ· xs) a (inr r) Â¬p | no _ =
  inr (memberIntoFilterOut P d xs a r Â¬p)

------------------------------------------------------------------------
-- 2.  The rank
------------------------------------------------------------------------

rank : â„• â†’ List (List â„•) â†’ List â„• â†’ â„•
rank zero    xs       v = 0
rank (suc n) []       v = 0
rank (suc n) (x âˆ· xs) v with decIsParetoMaximal v (x âˆ· xs)
... | yes _ = 0
... | no  _ = suc (rank n (remainder (x âˆ· xs)) v)

------------------------------------------------------------------------
-- 3.  A dominator has strictly smaller rank
------------------------------------------------------------------------

rankDominatorIsSmaller :
  (n : â„•) (xs : List (List â„•)) (v w : List â„•)
  â†’ lengthL xs â‰¤ n
  â†’ Mem v xs â†’ Mem w xs â†’ StrictlyDominates v w
  â†’ rank n xs w < rank n xs v
rankDominatorIsSmaller zero    xs       v w h memV memW sd =
  âŠ¥.rec (subst (Mem v) (lengthZeroGivesNil xs h) memV)
rankDominatorIsSmaller (suc n) []       v w h memV memW sd = âŠ¥.rec memV
rankDominatorIsSmaller (suc n) (x âˆ· xs) v w h memV memW sd
  with decIsParetoMaximal v (x âˆ· xs)
... | yes vmax =
  âŠ¥.rec (vmax (memberToAny (StrictlyDominates v) w (x âˆ· xs) memW sd))
... | no Â¬vmax with decIsParetoMaximal w (x âˆ· xs)
...   | yes _    = suc-â‰¤-suc zero-â‰¤
...   | no Â¬wmax =
  suc-â‰¤-suc
    (rankDominatorIsSmaller n (remainder (x âˆ· xs)) v w
      (pred-â‰¤-pred (â‰¤-trans (theRemainderIsStrictlyShorter x xs) h))
      (memberIntoFilterOut (Î» u â†’ IsParetoMaximal u (x âˆ· xs))
        (Î» u â†’ decIsParetoMaximal u (x âˆ· xs)) (x âˆ· xs) v memV Â¬vmax)
      (memberIntoFilterOut (Î» u â†’ IsParetoMaximal u (x âˆ· xs))
        (Î» u â†’ decIsParetoMaximal u (x âˆ· xs)) (x âˆ· xs) w memW Â¬wmax)
      sd)
