{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RateOneIsExactlyTheUniversalClaim
--
-- `OneCounterexampleRefutesALabelButNotAnExistential` proved that a
-- label â” a Î  â” is refuted by one counterexample, and said in its own
-- words:
--
--   "WHAT IS NOT MODELLED, said rather than glossed: a genuine RATE
--    claim ('more than half', 'at most 25%').  That needs a measure and
--    a count, neither of which appears below.  Â§3 therefore does NOT
--    establish the comparison Â§7's list invites."
--
-- The count is here, over a finite population as a `List Bool`, and it
-- gives the comparison exactly: the universal claim IS the rate-one
-- case, and every strictly lower rate has tolerance.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   countIsAtMostLength   the rate is a rate: count â‰ length
--   allGivesFullCount     the Î  forces count â‰¡ length
--   fullCountGivesAll     and is forced by it
--
-- Together: `count xs â‰¡ length xs` and `All isTrue xs` are the same
-- claim.  So `DARWIN_GODEL_MATH.md` Â§7's label criterion is not a
-- different KIND of criterion from its thresholds â” it is the threshold
-- at 1, where the tolerance is zero.  Â§4 exhibits a population where a
-- strictly lower threshold survives a failure that kills the Î , which is
-- what "tolerable benchmark noise" means and why the label admits none.
------------------------------------------------------------------------

module RateOneIsExactlyTheUniversalClaim where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; injSuc)
open import Cubical.Data.Nat.Order using (_â‰¤_ ; _<_ ; â‰¤-refl ; â‰¤-suc ; suc-â‰¤-suc ; Â¬m<m)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

------------------------------------------------------------------------
-- 1.  A finite population, the universal claim, and the count
------------------------------------------------------------------------

All : List Bool â†’ Type
All []       = Unit
All (b âˆ· bs) = (b â‰¡ true) Ã— All bs

count : List Bool â†’ â„•
count []           = 0
count (true  âˆ· bs) = suc (count bs)
count (false âˆ· bs) = count bs

length : List Bool â†’ â„•
length []       = 0
length (_ âˆ· bs) = suc (length bs)

countIsAtMostLength : (bs : List Bool) â†’ count bs â‰¤ length bs
countIsAtMostLength []           = â‰¤-refl
countIsAtMostLength (true  âˆ· bs) = suc-â‰¤-suc (countIsAtMostLength bs)
countIsAtMostLength (false âˆ· bs) = â‰¤-suc (countIsAtMostLength bs)

------------------------------------------------------------------------
-- 2.  The universal claim and rate one are the same claim
------------------------------------------------------------------------

allGivesFullCount : (bs : List Bool) â†’ All bs â†’ count bs â‰¡ length bs
allGivesFullCount []           _        = refl
allGivesFullCount (true  âˆ· bs) (_ , as) = cong suc (allGivesFullCount bs as)
allGivesFullCount (false âˆ· bs) (e , _)  = âŠ¥.rec (falseIsNotTrue e)
  where
    isFalse : Bool â†’ Type
    isFalse false = Unit
    isFalse true  = âŠ¥

    falseIsNotTrue : Â¬ (false â‰¡ true)
    falseIsNotTrue p = transport (cong isFalse p) tt

fullCountGivesAll : (bs : List Bool) â†’ count bs â‰¡ length bs â†’ All bs
fullCountGivesAll []           _ = tt
fullCountGivesAll (true  âˆ· bs) e = refl , fullCountGivesAll bs (injSuc e)
fullCountGivesAll (false âˆ· bs) e =
  âŠ¥.rec (Â¬m<m (subst (_â‰¤ length bs) e (countIsAtMostLength bs)))

------------------------------------------------------------------------
-- 3.  So the label criterion is the threshold at 1
--
-- `count bs â‰¡ length bs` is a statement about a rate, and Â§2 says it is
-- the universal claim verbatim.  A label is therefore the degenerate
-- threshold â” the one where a single failure moves the count off the
-- length and there is nothing left to tolerate.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 4.  And a strictly lower threshold survives what kills it
------------------------------------------------------------------------

population : List Bool
population = true âˆ· false âˆ· []

theUniversalClaimFails : Â¬ All population
theUniversalClaimFails (_ , (e , _)) = transport (cong isFalse e) tt
  where
    isFalse : Bool â†’ Type
    isFalse false = Unit
    isFalse true  = âŠ¥

butOneStillPasses : 1 â‰¤ count population
butOneStillPasses = â‰¤-refl

theThresholdAtOneAndBelow :
  (Â¬ All population) Ã— (1 â‰¤ count population)
theThresholdAtOneAndBelow = theUniversalClaimFails , butOneStillPasses

------------------------------------------------------------------------
-- 5.  What this settles about the earlier module
--
-- The earlier contrast used an existential and said so.  Â§2 replaces it
-- with a count and gives the comparison the list invited: the label is
-- the rate-one case, and Â§4 exhibits a lower threshold surviving the
-- failure that kills it.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- "More than half", as `MajorityLiesStrictlyBetweenAllAndSome` states it:
--
--   Majority bs = length bs < 2 Â count bs
--
-- and it separates three claim-shapes with two populations rather than
-- one, because one population cannot exhibit strictness on both sides:
--
--   majorityWithoutAll       2 of 3: the majority holds, the Î  fails
--   positiveWithoutMajority  1 of 3: the existential holds, majority fails
--
-- So the three shapes are pairwise distinct at the thresholds shown, and
-- the rate-one case proved here (`fullCountGivesAll`) is the top of that
-- ordering, not a point on a continuum that was never exhibited.
--
------------------------------------------------------------------------
