{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AsymmetryOnTheRateIsFreeAndTheWeakClaimIsAntitoneToo
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   âŠR-asym                    asymmetry of the strict rate order
--   atLeastIsAntitoneOnRates   the weak claim is antitone along the
--                              strict order
--
-- **ASYMMETRY NEEDED NO TRANSPORT AT ALL**, and that is worth saying
-- rather than just doing.  It is `âŠR-irrefl x (âŠR-trans x y x h k)` â”
-- a theorem about ANY irreflexive transitive relation, which never
-- mentions the quotient, never eliminates, never touches a
-- representative or `â‰ˆ`.  Once the two order laws were lifted,
-- asymmetry was already present.
--
-- The second half is genuinely a lift and is the same shape as
-- `aboveIsAntitoneOnRates`: `elimProp2` with `atLeastAntitone` at
-- representatives and `<-weaken` to move from the strict order to the
-- weak one the pair-level lemma wants.
--
-- NO NOVELTY.  Asymmetry from irreflexivity and transitivity is the
-- textbook fact about strict orders; the antitonicity lift is the same
-- one already performed for the strict claim.
------------------------------------------------------------------------

module AsymmetryOnTheRateIsFreeAndTheWeakClaimIsAntitoneToo where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (âŸ¨_âŸ© ; str)
open import Cubical.Foundations.HLevels using (isPropÎ  ; isPropâ†’)
open import Cubical.HITs.SetQuotients as SQ using (elimProp2)
open import Cubical.Data.Nat using (â„•)
open import Cubical.Data.Nat.Order using (<-weaken)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Relation.Nullary using (Â¬_)

open import TheThresholdOrderIsTotalAndTheClaimIsAntitone
  using (atLeastAntitone)
open import TheRateQuotientExistsAndMinimalityCannotLiveOnIt
  using (Rate ; AtLeastOnRate)
open import TheRatesAreDenseAndTheMediantSurvivesTheQuotient
  using (_âŠR_)
open import TheStrictRateOrderIsAnOrderAndTheClaimIsAntitoneOnIt
  using (âŠR-irrefl ; âŠR-trans)

------------------------------------------------------------------------
-- 1.  Asymmetry, for nothing
------------------------------------------------------------------------

âŠR-asym : (x y : Rate) â†’ âŸ¨ x âŠR y âŸ© â†’ Â¬ âŸ¨ y âŠR x âŸ©
âŠR-asym x y h k = âŠR-irrefl x (âŠR-trans x y x h k)

------------------------------------------------------------------------
-- 2.  The weak claim is antitone along the strict order
------------------------------------------------------------------------

atLeastIsAntitoneOnRates :
  (x y : Rate) â†’ âŸ¨ x âŠR y âŸ©
  â†’ (bs : List Bool) â†’ âŸ¨ AtLeastOnRate y bs âŸ© â†’ âŸ¨ AtLeastOnRate x bs âŸ©
atLeastIsAntitoneOnRates =
  elimProp2
    (Î» x y â†’ isPropâ†’ (isPropÎ  (Î» bs â†’ isPropâ†’ (str (AtLeastOnRate x bs)))))
    (Î» where (p , q) (p' , q') h bs â†’
               atLeastAntitone p q p' q' bs (<-weaken h))
