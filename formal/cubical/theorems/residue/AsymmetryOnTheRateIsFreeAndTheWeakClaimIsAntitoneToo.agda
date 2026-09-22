{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AsymmetryOnTheRateIsFreeAndTheWeakClaimIsAntitoneToo
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   ⊏R-asym                    asymmetry of the strict rate order
--   atLeastIsAntitoneOnRates   the weak claim is antitone along the
--                              strict order
--
-- **ASYMMETRY NEEDED NO TRANSPORT AT ALL**, and that is worth saying
-- rather than just doing.  It is `⊏R-irrefl x (⊏R-trans x y x h k)` —
-- a theorem about ANY irreflexive transitive relation, which never
-- mentions the quotient, never eliminates, never touches a
-- representative or `≈`.  Once the two order laws were lifted,
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
open import Cubical.Foundations.Structure using (⟨_⟩ ; str)
open import Cubical.Foundations.HLevels using (isPropΠ ; isProp→)
open import Cubical.HITs.SetQuotients as SQ using (elimProp2)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Nat.Order using (<-weaken)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

open import TheThresholdOrderIsTotalAndTheClaimIsAntitone
  using (atLeastAntitone)
open import TheRateQuotientExistsAndMinimalityCannotLiveOnIt
  using (Rate ; AtLeastOnRate)
open import TheRatesAreDenseAndTheMediantSurvivesTheQuotient
  using (_⊏R_)
open import TheStrictRateOrderIsAnOrderAndTheClaimIsAntitoneOnIt
  using (⊏R-irrefl ; ⊏R-trans)

------------------------------------------------------------------------
-- 1.  Asymmetry, for nothing
------------------------------------------------------------------------

⊏R-asym : (x y : Rate) → ⟨ x ⊏R y ⟩ → ¬ ⟨ y ⊏R x ⟩
⊏R-asym x y h k = ⊏R-irrefl x (⊏R-trans x y x h k)

------------------------------------------------------------------------
-- 2.  The weak claim is antitone along the strict order
------------------------------------------------------------------------

atLeastIsAntitoneOnRates :
  (x y : Rate) → ⟨ x ⊏R y ⟩
  → (bs : List Bool) → ⟨ AtLeastOnRate y bs ⟩ → ⟨ AtLeastOnRate x bs ⟩
atLeastIsAntitoneOnRates =
  elimProp2
    (λ x y → isProp→ (isPropΠ (λ bs → isProp→ (str (AtLeastOnRate x bs)))))
    (λ where (p , q) (p' , q') h bs →
               atLeastAntitone p q p' q' bs (<-weaken h))
