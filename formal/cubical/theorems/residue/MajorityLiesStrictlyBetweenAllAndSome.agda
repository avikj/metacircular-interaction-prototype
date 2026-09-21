{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MajorityLiesStrictlyBetweenAllAndSome
--
-- Majority is stated here, and the three claim-shapes are separated by two
-- populations: majority holds where the universal claim fails, and
-- fails where the existential holds.  So the tolerances are strictly
-- ordered and `DARWIN_GODEL_MATH.md` Â§7's mixture of a label criterion
-- with rate thresholds is a mixture of genuinely different strengths,
-- not a stylistic one.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   majorityWithoutAll        `true âˆ true âˆ false âˆ []`
--                             â” 2 of 3, so `3 < 4`; the Î  fails
--   positiveWithoutMajority   `true âˆ false âˆ false âˆ []`
--                             â” 1 of 3, so `3 < 2` is refuted; the
--                             existential still holds
--
-- With `RateOneIsExactlyTheUniversalClaim`'s equivalence (rate one IS
-- the Î ), the three sit in order and each separation is witnessed.
------------------------------------------------------------------------

module MajorityLiesStrictlyBetweenAllAndSome where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; _Â·_ ; +-comm ; injSuc ; snotz)
open import Cubical.Data.Nat.Order using (_â‰¤_ ; _<_)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

open import RateOneIsExactlyTheUniversalClaim
  using (All ; count ; length)

------------------------------------------------------------------------
-- 1.  The middle threshold, written without division
------------------------------------------------------------------------

Majority : List Bool â†’ Type
Majority bs = length bs < 2 Â· count bs

Some : List Bool â†’ Type
Some bs = 1 â‰¤ count bs

private
  isFalse : Bool â†’ Type
  isFalse false = Unit
  isFalse true  = âŠ¥

  falseIsNotTrue : Â¬ (false â‰¡ true)
  falseIsNotTrue p = transport (cong isFalse p) tt

------------------------------------------------------------------------
-- 2.  Majority holds where the universal claim fails
------------------------------------------------------------------------

twoOfThree : List Bool
twoOfThree = true âˆ· true âˆ· false âˆ· []

majorityHolds : Majority twoOfThree
majorityHolds = 0 , refl

universalFails : Â¬ All twoOfThree
universalFails (_ , (_ , (e , _))) = falseIsNotTrue e

majorityWithoutAll : (Majority twoOfThree) Ã— (Â¬ All twoOfThree)
majorityWithoutAll = majorityHolds , universalFails

------------------------------------------------------------------------
-- 3.  The existential holds where majority fails
------------------------------------------------------------------------

oneOfThree : List Bool
oneOfThree = true âˆ· false âˆ· false âˆ· []

someHolds : Some oneOfThree
someHolds = 0 , refl

majorityFails : Â¬ Majority oneOfThree
majorityFails (k , p) = snotz (injSuc (injSuc (sym (+-comm k 4) âˆ™ p)))

positiveWithoutMajority : (Some oneOfThree) Ã— (Â¬ Majority oneOfThree)
positiveWithoutMajority = someHolds , majorityFails

------------------------------------------------------------------------
-- 4.  The reading
--
-- `RateOneIsExactlyTheUniversalClaim` showed the label criterion is the
-- threshold at 1.  Â§2 and Â§3 show the thresholds below it are not all
-- the same: majority separates from the universal claim, and the bare
-- existential separates from majority.  So Â§7's list mixes at least
-- three strengths, and calling a label-failure "noise" would be reading
-- the strongest of them as the weakest.
--
-- Two populations are two populations; the general theorem over all
-- thresholds is `TheThresholdOrderIsTotalAndTheClaimIsAntitone`, below.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- The general family is in `TheThresholdOrderIsTotalAndTheClaimIsAntitone`.
-- The move was to stop exhibiting populations and state the family:
--
--   AtLeast p q bs        = p Â length bs â‰ suc q Â count bs
--   (p , q) âŠ (p' , q')   = p Â suc q' â‰ p' Â suc q
--
--   âŠ-total          ANY two thresholds are comparable -- the chain,
--                    proved with no population in sight
--   atLeastAntitone  higher threshold â’ lower threshold, for EVERY
--                    population at once
--   allIsThresholdOne / thresholdOneFromAll
--                    the Î  is exactly the top element (1 , 0)
--
-- so every fraction is analysed, by one theorem, and Â§2 and Â§4 above
-- become two instances of it rather than the evidence for it.
--
-- RELATION to the module above.  `Majority` here is
-- STRICT (length < 2 Â count); `AtLeast 1 1` there is the non-strict
-- "at least half", which is weaker.  `â‰¤` is a total PREORDER and not an
-- order: (1,1) and (2,3) name one rate and stay two pairs.
-- And the converse of antitone fails -- `majorityWithoutAll` above
-- is the witness that it fails -- so the chain orders the CLAIMS, not
-- the populations.
------------------------------------------------------------------------
