{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AsymmetryOnTheRateIsFreeAndTheWeakClaimIsAntitoneToo
--
-- `TheStrictRateOrderIsAnOrderAndTheClaimIsAntitoneOnIt` lifted `⊏` to
-- the rates and left two things open in its own words: ASYMMETRY and
-- TRICHOTOMY were "untransported", and antitonicity was proved for
-- `AboveOnRate` only — the WEAK claim `AtLeastOnRate` along the STRICT
-- order was unstated.  Two of those three are closed here.
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
-- asymmetry was already present; listing it as "untransported" listed
-- a consequence as an obligation.  The corpus has now made this
-- mistake in both directions on the same line — an item recorded as
-- needing machinery it did not need, next to an item whose difficulty
-- was underestimated.
--
-- The second half is genuinely a lift and is the same shape as
-- `aboveIsAntitoneOnRates`: `elimProp2` with `atLeastAntitone` at
-- representatives and `<-weaken` to move from the strict order to the
-- weak one the pair-level lemma wants.
--
-- ────────────────────────────────────────────────────────────────────
-- TRICHOTOMY IS DELIBERATELY NOT HERE, and the reason is a measured
-- fact about this container rather than a mathematical obstruction.
-- A draft carrying it — `Tri x y = ⟨ x ⊏R y ⟩ ⊎ ((x ≡ y) ⊎ ⟨ y ⊏R x ⟩)`
-- with `isPropTri` by nine cases and `elimProp2` over `_≟_` at the two
-- cross products — was typechecking for OVER TWELVE MINUTES of CPU on
-- Agda 2.6.3 + cubical v0.5 with every imported interface already
-- built, and was stopped rather than left running.  That is a
-- statement about a single unfinished run on this container and NOT a
-- claim that the module is wrong, that it does not terminate, or that
-- it would be slow under the declared pin (Agda 2.8.0 + cubical v0.9),
-- which has different `SetQuotients` internals.  The draft is kept out
-- of the tree.  What the next cycle should try, in order: state `Tri`
-- with `⊏R` UNFOLDED to the pair level under the eliminator rather
-- than substituting along quotient paths; or prove trichotomy at the
-- pair level and lift only the resulting proposition.
--
-- NO NOVELTY.  Asymmetry from irreflexivity and transitivity is the
-- textbook fact about strict orders; the antitonicity lift is the same
-- one already performed for the strict claim.
--
-- SYĀT — THE CLAIM, EXACTLY.  Trichotomy, as above.  Nothing here makes
-- `Rate` decidable or total.  `Minimal` still cannot live on the
-- quotient (`noMinimalityOnTheRate`) and the mediant still does not
-- descend (`TheMediantDoesNotDescendToTheRate`).
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
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
