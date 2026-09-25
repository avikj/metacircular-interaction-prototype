{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheUntruncatedTrichotomyOnTheRate
--
-- समच्छेद · samacchheda — "equal divisor": bringing two fractions to a
-- common denominator, which is how the  arithmetic tradition
-- compares and combines them (bhinna-parikarma — Brahmagupta,
-- *Brhmasphuasiddhnta* 628; Bhskara II, *Llvat*, c. 1150).
-- Every comparison underneath this module is that operation:
-- `p · suc q'` against `p' · suc q` is the pair of numerators once the
-- divisors are equalised.  The
-- operation is theirs, the type theory is not.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   isPropSum         `isProp` for a binary sum from the two component
--                     propositions and a separator, for ARBITRARY types
--   ⊏R-excludes-≡     `⟨ x ⊏R y ⟩ → ¬ (x ≡ y)`, on the quotient
--   isPropTriR        hence the three-way sum is a proposition
--   rateTrichotomy    `⟨ x ⊏R y ⟩ ⊎ ((x ≡ y) ⊎ ⟨ y ⊏R x ⟩)`,
--                     UNTRUNCATED
--
-- NO NOVELTY.  Trichotomy of the rationals is classical; `isPropSum` is
-- standard and cubical v0.5 happens not to export it.
------------------------------------------------------------------------

module TheUntruncatedTrichotomyOnTheRate where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩ ; str)
open import Cubical.HITs.SetQuotients as SQ using (squash/)
open import Cubical.HITs.PropositionalTruncation as PT using (∥_∥₁)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import TheRateQuotientExistsAndMinimalityCannotLiveOnIt
  using (Rate)
open import TheRatesAreDenseAndTheMediantSurvivesTheQuotient
  using (_⊏R_)
open import TheStrictRateOrderIsAnOrderAndTheClaimIsAntitoneOnIt
  using (⊏R-irrefl)
open import AsymmetryOnTheRateIsFreeAndTheWeakClaimIsAntitoneToo
  using (⊏R-asym)
open import TrichotomyIsCheapOnPairsAndTheLiftCostsATruncation
  using (rateTrichotomyTruncated)

------------------------------------------------------------------------
-- 1.  The generic lemma, where no quotient is in scope
------------------------------------------------------------------------

isPropSum :
  {A B : Type} → isProp A → isProp B → (A → B → ⊥) → isProp (A ⊎ B)
isPropSum pa pb sep (inl a) (inl a') = cong inl (pa a a')
isPropSum pa pb sep (inl a) (inr b)  = ⊥.rec (sep a b)
isPropSum pa pb sep (inr b) (inl a)  = ⊥.rec (sep a b)
isPropSum pa pb sep (inr b) (inr b') = cong inr (pb b b')

------------------------------------------------------------------------
-- 2.  The strict order excludes equality, on the quotient
------------------------------------------------------------------------

⊏R-excludes-≡ : (x y : Rate) → ⟨ x ⊏R y ⟩ → ¬ (x ≡ y)
⊏R-excludes-≡ x y h e = ⊏R-irrefl y (subst (λ z → ⟨ z ⊏R y ⟩) e h)

------------------------------------------------------------------------
-- 3.  …so the sum is a proposition and the truncation comes off
------------------------------------------------------------------------

Tri : Rate → Rate → Type
Tri x y = ⟨ x ⊏R y ⟩ ⊎ ((x ≡ y) ⊎ ⟨ y ⊏R x ⟩)

isPropTriR : (x y : Rate) → isProp (Tri x y)
isPropTriR x y =
  isPropSum (str (x ⊏R y))
    (isPropSum (squash/ x y) (str (y ⊏R x))
      (λ e k → ⊏R-excludes-≡ y x k (sym e)))
    (λ h → λ { (inl e) → ⊏R-excludes-≡ x y h e
             ; (inr k) → ⊏R-asym x y h k })

rateTrichotomy : (x y : Rate) → Tri x y
rateTrichotomy x y =
  PT.rec (isPropTriR x y) (λ t → t) (rateTrichotomyTruncated x y)
