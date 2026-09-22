{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ExcludingPerfectScorersRemovesOnlyGainlessCandidates
--
-- Seam 1 reads:
--
--   "The paper's parent-eligibility set excludes perfect-score agents.
--    The released `choose_selfimproves` function does not make that
--    exclusion; every archived node whose metadata loads becomes a
--    candidate."
--
-- Stated that way it is a discrepancy.  Its mathematical content is
-- WHY the exclusion is there and WHEN dropping it is observable, and
-- both are short.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   noStrictImprovementAtTheCap
--       under a score bound, an agent AT the bound admits no strictly
--       better agent.  So the paper's exclusion is not a heuristic or a
--       taste: it removes candidates whose possible gain is PROVABLY
--       zero, and a scheduler sampling them spends mass where no
--       improvement exists.
--   eligible / eligibleKeepsEveryImperfectAgent
--       the eligibility filter, computed â” reusing the decidable-filter
--       kit and `discreteâ•` â” together with the fact that it keeps
--       every agent below the cap
--   theSeamIsInvisibleExactlyWhenNobodyIsPerfect
--       so if no archived agent attains the cap, the two eligibility
--       sets have the same members and the seam cannot be observed
--
-- **This is the same shape seam 3 turned out to have,** and finding it
-- twice in one section is the point worth recording: a defect that is
-- undetectable exactly where it is harmless.  For seam 3 the branch
-- agreed with its comment only on a constant archive, where selection
-- carries no information.  For seam 1 the missing exclusion changes
-- nothing until some agent is perfect â” and once one is, every sample
-- drawn on it is provably gainless.  Neither seam is cosmetic and
-- neither is visible in a benign archive.
------------------------------------------------------------------------

module ExcludingPerfectScorersRemovesOnlyGainlessCandidates where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; discreteâ„•)
open import Cubical.Data.Nat.Order using (_â‰¤_ ; _<_ ; â‰¤-trans ; Â¬m<m)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (decNeg ; filterDec ; filterDecKeepsEverySatisfier)

module _ {A : Type} (score : A â†’ â„•) (cap : â„•)
         (bounded : (a : A) â†’ score a â‰¤ cap) where

  ------------------------------------------------------------------
  -- 1.  Why the exclusion is there
  ------------------------------------------------------------------

  AtCap : A â†’ Type
  AtCap a = score a â‰¡ cap

  noStrictImprovementAtTheCap :
    (a : A) â†’ AtCap a â†’ Â¬ (Î£[ b âˆˆ A ] (score a < score b))
  noStrictImprovementAtTheCap a atcap (b , lt) =
    Â¬m<m (â‰¤-trans (subst (_< score b) atcap lt) (bounded b))

  ------------------------------------------------------------------
  -- 2.  The eligibility filter, computed
  ------------------------------------------------------------------

  Imperfect : A â†’ Type
  Imperfect a = Â¬ AtCap a

  decImperfect : (a : A) â†’ Dec (Imperfect a)
  decImperfect a = decNeg (discreteâ„• (score a) cap)

  eligible : List A â†’ List A
  eligible = filterDec Imperfect decImperfect

  eligibleKeepsEveryImperfectAgent :
    (xs : List A) (a : A)
    â†’ Any (Î» y â†’ y â‰¡ a) xs â†’ Imperfect a
    â†’ Any (Î» y â†’ y â‰¡ a) (eligible xs)
  eligibleKeepsEveryImperfectAgent =
    filterDecKeepsEverySatisfier Imperfect decImperfect

  ------------------------------------------------------------------
  -- 3.  So the seam is invisible exactly when nobody is perfect
  ------------------------------------------------------------------

  theSeamIsInvisibleExactlyWhenNobodyIsPerfect :
    ((a : A) â†’ Imperfect a)
    â†’ (xs : List A) (a : A)
    â†’ Any (Î» y â†’ y â‰¡ a) xs â†’ Any (Î» y â†’ y â‰¡ a) (eligible xs)
  theSeamIsInvisibleExactlyWhenNobodyIsPerfect noneAtCap xs a mem =
    eligibleKeepsEveryImperfectAgent xs a mem (noneAtCap a)
