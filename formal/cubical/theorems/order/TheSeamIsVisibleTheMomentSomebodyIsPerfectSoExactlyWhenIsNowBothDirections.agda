{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheSeamIsVisibleTheMomentSomebodyIsPerfectSoExactlyWhenIsNowBothDirections
--
-- What is checked is the order-theoretic content of Â§2's sentence, on the
-- assumption that the sentence describes the released function
-- correctly.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE AUDIT.  Target: `ExcludingPerfectScorersRemovesOnlyGainlessCandidates`.
--
-- **THE MODULE TITLE IS EARNED, AND THE DANGEROUS CONVERSE IS ALREADY
-- DISCLAIMED.**  `Only` here is the direction REMOVED âŸ GAINLESS, which
-- is exactly `noStrictImprovementAtTheCap`.  The reverse reading â”
-- every gainless candidate is removed â” is false in general, and that
-- module's Â§"SYT â” THE CLAIM, EXACTLY" says so in its own words: the cap
-- bounds the score, it does not populate it.
--
-- **THE FAULT IS ONE LEVEL DOWN, IN A THEOREM NAME.**  Â§3 is called
-- `theSeamIsInvisibleExactlyWhenNobodyIsPerfect` and proves ONE
-- direction: if no agent attains the cap, eligibility keeps every
-- member.  The converse â” if eligibility keeps every member of every
-- list, then no agent attains the cap â” is not there, and the module's
--
-- **AND THE CONVERSE IS SHORT, WITH A ONE-ELEMENT LIST.**  If `a`
-- attains the cap, feed the invisibility statement `a âˆ []`.  It
-- returns `a` as a member of `eligible (a âˆ [])`; every member of a
-- filtered list satisfies the predicate (`filterDecOnlyKeepsSatisfiers`);
-- so `Imperfect a`, which contradicts `AtCap a`.
-- The two sides are joined by a FILTER whose
-- exactness lemmas both already exist, so neither direction is a search.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   memberOfAnAllList   `All P ys` and membership give `P a` â” the
--                       bridge between the two recursive families, by
--                       induction, since the filter kit ships `All`-
--                       and `Any`-shaped lemmas that never meet
--   theSeamIsVisibleWhenSomebodyIsPerfect
--                       the missing direction, refuting invisibility
--                       from a single at-cap agent
------------------------------------------------------------------------

module TheSeamIsVisibleTheMomentSomebodyIsPerfectSoExactlyWhenIsNowBothDirections where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„•)
open import Cubical.Data.Nat.Order using (_â‰¤_)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (All ; filterDecOnlyKeepsSatisfiers)
open import ExcludingPerfectScorersRemovesOnlyGainlessCandidates
  using (AtCap ; Imperfect ; decImperfect ; eligible)

------------------------------------------------------------------------
-- 1.  The bridge the filter kit does not ship
--
-- `filterDecOnlyKeepsSatisfiers` lands in `All`; membership is stated
-- with `Any`.  The two families never meet in the kit, so the step is
-- written here once.
------------------------------------------------------------------------

memberOfAnAllList :
  {A : Type} (P : A â†’ Type) (a : A) (ys : List A)
  â†’ All P ys â†’ Any (Î» y â†’ y â‰¡ a) ys â†’ P a
memberOfAnAllList P a []       _          e       = âŠ¥.rec e
memberOfAnAllList P a (y âˆ· ys) (py , pys) (inl q) = subst P q py
memberOfAnAllList P a (y âˆ· ys) (py , pys) (inr m) =
  memberOfAnAllList P a ys pys m

------------------------------------------------------------------------
-- 2.  The missing direction: one perfect agent makes the seam visible
------------------------------------------------------------------------

module _ {A : Type} (score : A â†’ â„•) (cap : â„•)
         (bounded : (a : A) â†’ score a â‰¤ cap) where

  private
    Imp : A â†’ Type
    Imp = Imperfect score cap bounded

    elig : List A â†’ List A
    elig = eligible score cap bounded

  theSeamIsVisibleWhenSomebodyIsPerfect :
    (a : A) â†’ AtCap score cap bounded a
    â†’ Â¬ ( (xs : List A) (b : A)
          â†’ Any (Î» y â†’ y â‰¡ b) xs â†’ Any (Î» y â†’ y â‰¡ b) (elig xs) )
  theSeamIsVisibleWhenSomebodyIsPerfect a atcap invisible =
    memberOfAnAllList Imp a (elig (a âˆ· []))
      (filterDecOnlyKeepsSatisfiers Imp (decImperfect score cap bounded) (a âˆ· []))
      (invisible (a âˆ· []) a (inl refl))
      atcap
