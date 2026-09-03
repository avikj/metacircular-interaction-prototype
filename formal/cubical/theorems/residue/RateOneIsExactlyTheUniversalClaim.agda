{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RateOneIsExactlyTheUniversalClaim
--
-- Closes the item I left open one cycle ago.
-- `OneCounterexampleRefutesALabelButNotAnExistential` proved that a
-- label — a Π — is refuted by one counterexample, and said in its own
-- words:
--
--   "WHAT IS NOT MODELLED, said rather than glossed: a genuine RATE
--    claim ('more than half', 'at most 25%').  That needs a measure and
--    a count, neither of which appears below.  §3 therefore does NOT
--    establish the comparison §7's list invites."
--
-- The count is here, over a finite population as a `List Bool`, and it
-- gives the comparison exactly: the universal claim IS the rate-one
-- case, and every strictly lower rate has tolerance.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   countIsAtMostLength   the rate is a rate: count ≤ length
--   allGivesFullCount     the Π forces count ≡ length
--   fullCountGivesAll     and is forced by it
--
-- Together: `count xs ≡ length xs` and `All isTrue xs` are the same
-- claim.  So `DARWIN_GODEL_MATH.md` §7's label criterion is not a
-- different KIND of criterion from its thresholds — it is the threshold
-- at 1, where the tolerance is zero.  §4 exhibits a population where a
-- strictly lower threshold survives a failure that kills the Π, which is
-- what "tolerable benchmark noise" means and why the label admits none.
--
-- THE SCOPE, EXACTLY.  Percentages.  `count` and `length` are ℕ
-- and no division appears; "more than half" would be `length xs < 2 ·
-- count xs`, which is stateable but is NOT stated or used below, and no
-- threshold other than 1 is analysed.  The population is a LIST, so
-- multiplicity is counted and order is carried — neither matters to §2
-- and both would matter to any finer measure.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module RateOneIsExactlyTheUniversalClaim where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; injSuc)
open import Cubical.Data.Nat.Order using (_≤_ ; _<_ ; ≤-refl ; ≤-suc ; suc-≤-suc ; ¬m<m)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- 1.  A finite population, the universal claim, and the count
------------------------------------------------------------------------

All : List Bool → Type
All []       = Unit
All (b ∷ bs) = (b ≡ true) × All bs

count : List Bool → ℕ
count []           = 0
count (true  ∷ bs) = suc (count bs)
count (false ∷ bs) = count bs

length : List Bool → ℕ
length []       = 0
length (_ ∷ bs) = suc (length bs)

countIsAtMostLength : (bs : List Bool) → count bs ≤ length bs
countIsAtMostLength []           = ≤-refl
countIsAtMostLength (true  ∷ bs) = suc-≤-suc (countIsAtMostLength bs)
countIsAtMostLength (false ∷ bs) = ≤-suc (countIsAtMostLength bs)

------------------------------------------------------------------------
-- 2.  The universal claim and rate one are the same claim
------------------------------------------------------------------------

allGivesFullCount : (bs : List Bool) → All bs → count bs ≡ length bs
allGivesFullCount []           _        = refl
allGivesFullCount (true  ∷ bs) (_ , as) = cong suc (allGivesFullCount bs as)
allGivesFullCount (false ∷ bs) (e , _)  = ⊥.rec (falseIsNotTrue e)
  where
    isFalse : Bool → Type
    isFalse false = Unit
    isFalse true  = ⊥

    falseIsNotTrue : ¬ (false ≡ true)
    falseIsNotTrue p = transport (cong isFalse p) tt

fullCountGivesAll : (bs : List Bool) → count bs ≡ length bs → All bs
fullCountGivesAll []           _ = tt
fullCountGivesAll (true  ∷ bs) e = refl , fullCountGivesAll bs (injSuc e)
fullCountGivesAll (false ∷ bs) e =
  ⊥.rec (¬m<m (subst (_≤ length bs) e (countIsAtMostLength bs)))

------------------------------------------------------------------------
-- 3.  So the label criterion is the threshold at 1
--
-- `count bs ≡ length bs` is a statement about a rate, and §2 says it is
-- the universal claim verbatim.  A label is therefore the degenerate
-- threshold — the one where a single failure moves the count off the
-- length and there is nothing left to tolerate.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 4.  And a strictly lower threshold survives what kills it
------------------------------------------------------------------------

population : List Bool
population = true ∷ false ∷ []

theUniversalClaimFails : ¬ All population
theUniversalClaimFails (_ , (e , _)) = transport (cong isFalse e) tt
  where
    isFalse : Bool → Type
    isFalse false = Unit
    isFalse true  = ⊥

butOneStillPasses : 1 ≤ count population
butOneStillPasses = ≤-refl

theThresholdAtOneAndBelow :
  (¬ All population) × (1 ≤ count population)
theThresholdAtOneAndBelow = theUniversalClaimFails , butOneStillPasses

------------------------------------------------------------------------
-- 5.  What this settles about the earlier module
--
-- The earlier contrast used an existential and said so.  §2 replaces it
-- with a count and gives the comparison the list invited: the label is
-- the rate-one case, and §4 exhibits a lower threshold surviving the
-- failure that kills it.
--
-- Percentages are still absent.  "More than half" is stateable as
-- `length xs < 2 · count xs`; it is not stated, and no threshold other
-- than 1 is analysed.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  §5's last paragraph named an item and left it open; this
-- closes it.  Recording the closure here rather than editing §5 keeps
-- the earlier statement readable as what was true when it was written.
--
--   `MajorityLiesStrictlyBetweenAllAndSome`
--   (--safe, no postulates, no holes; container green under
--    Agda 2.6.3 + cubical v0.5, NOT the declared pin — check.sh itself
--    returns 1 and prints that the toolchain is not the pin)
--
-- states exactly the sentence §5 said was stateable and unstated:
--
--   Majority bs = length bs < 2 · count bs
--
-- and it separates three claim-shapes with two populations rather than
-- one, because one population cannot exhibit strictness on both sides:
--
--   majorityWithoutAll       2 of 3: the majority holds, the Π fails
--   positiveWithoutMajority  1 of 3: the existential holds, majority fails
--
-- So the three shapes are pairwise distinct at the thresholds shown, and
-- the rate-one case proved here (`fullCountGivesAll`) is the top of that
-- ordering, not a point on a continuum that was never exhibited.
--
-- STILL NOT CLAIMED, there and therefore here: no threshold order is
-- shown TOTAL over all fractions -- two populations are two populations,
-- not a chain -- and no fraction other than 1/2 and 1 is analysed.  The
-- population remains a LIST, so multiplicity is counted and order is
-- carried even though no claim here uses the order.
------------------------------------------------------------------------
