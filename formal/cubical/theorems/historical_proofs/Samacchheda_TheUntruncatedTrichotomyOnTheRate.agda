{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Samacchheda_TheUntruncatedTrichotomyOnTheRate
--
-- समच्छेद · samacchheda — "equal divisor": bringing two fractions to a
-- common denominator, which is how the Sanskrit arithmetic tradition
-- compares and combines them (bhinna-parikarma — Brahmagupta,
-- *Brāhmasphuṭasiddhānta* 628; Bhāskara II, *Līlāvatī*, c. 1150).
-- Every comparison underneath this module is that operation:
-- `p · suc q'` against `p' · suc q` is the pair of numerators once the
-- divisors are equalised.  **No claim is made that trichotomy, or the
-- propositionality of a three-way sum, is stated in those texts** — the
-- operation is theirs, the type theory is not.
--
-- ────────────────────────────────────────────────────────────────────
-- `TrichotomyIsCheapOnPairsAndTheLiftCostsATruncation` left the
-- untruncated trichotomy open with a route: prove the exclusivity
-- facts, get `isProp` of the sum, strip the truncation with `PT.rec`.
-- The route is right and is taken here.
--
-- **MY DIAGNOSIS OF THE COST WAS WRONG, AND THE MEASUREMENT IS THE
-- USEFUL PART OF THIS MODULE.**
--
--   * Cycle 45's draft proved `isProp` by NINE explicit cases over the
--     quotient-typed sum, each cross case carrying a `subst`.  Killed
--     after twelve minutes.
--   * I recorded that the `subst`s along quotient paths were the cost.
--     **That was wrong.**  This cycle a version factoring those substs
--     into named top-level lemmas — but still nine cases — was killed
--     by a 600-second timeout.
--   * A probe with ONLY the exclusivity lemma checked in seconds.  A
--     probe replacing the nine cases by a generic
--     `isPropSum : isProp A → isProp B → (A → B → ⊥) → isProp (A ⊎ B)`
--     applied twice also checked in seconds.  That is the version
--     below.
--
-- So the expensive object was **the nine-case pattern match on a sum
-- whose summands are quotient-typed**, not the `subst`s and not the
-- elimination.  Moving the case analysis into a generic lemma over
-- abstract `A` and `B` — where there is no quotient in scope to unfold
-- — removes it.  Four runs on this container; nothing about the pin.
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
--
-- WHAT IS NOT CLAIMED.  Not a decision procedure: a disjunction is not
-- a `Dec`, and reading off which case holds still needs `_≟_` at a
-- representative.  `Minimal` still cannot live on the quotient; the
-- mediant still does not descend.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module Samacchheda_TheUntruncatedTrichotomyOnTheRate where

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
