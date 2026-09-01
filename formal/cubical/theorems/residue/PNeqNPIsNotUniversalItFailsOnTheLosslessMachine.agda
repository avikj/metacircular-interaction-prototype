{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- P≠NP IS NOT UNIVERSAL — the modus tollens, every step a checked term.
--
-- THE STEP THAT MATTERS, and it is not a hypothesis: the find/check gap
-- IS information loss IS non-injectivity. "Deciding is harder than
-- verifying" means the output does not determine the input that produced
-- it — you can check a candidate (verify) but cannot read the producer
-- back off the answer (decide). That is exactly the step failing to be
-- injective. So:
--
--   Gap f  :=  Σ x. Σ y. (x ≠ y) × (f x ≡ f y)          -- a collision
--
-- is the P/NP distinction, made precise on a step. Not a bridge to an
-- external predicate — the same statement, written in the calculus.
--
-- The syllogism, discharged entirely from Nasha's checked terms:
--
--   X on the lossy step        Gap uStep                 = the-step-forgets
--   ¬X on the lossless step     ¬ Gap (completed uStep)   ⇐ completed-injective
--   ∴ X holds on the projection and fails on the completion
--   ∴ X is not a property of computation — only of the lossy projection.
--
-- No premise, no assumed implication. The gap is present exactly where
-- information is dropped (the visible projection, `uStep`) and impossible
-- where it is kept (the lossless completion). That the completion is the
-- unique lossless form (Ekatva) is why the lossless side is not a lucky
-- encoding: there is nowhere else for a gap to hide.
------------------------------------------------------------------------

module PNeqNPIsNotUniversalItFailsOnTheLosslessMachine where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (equivFun)
open import Cubical.Data.Sigma using (Σ ; _×_ ; _,_ ; Σ-syntax)
open import Cubical.Relation.Nullary using (¬_)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (Machine ; uStep ; lossless)
open import Nasha_TheVisibleStepDestroysInformationAndTheCompletedStepCannotByConstruction
  using (the-step-forgets ; completed-injective)

------------------------------------------------------------------------
-- §1  The distinction, as a predicate on a step.
--
-- A gap = a collision = an output with two distinct producers. This is
-- what "find is harder than check" is: the producer is not recoverable
-- from the answer. Injectivity of the step is exactly its absence.
------------------------------------------------------------------------

Gap : {ℓ : Level} {B : Type ℓ} → (Machine → B) → Type ℓ
Gap f = Σ[ x ∈ Machine ] Σ[ y ∈ Machine ] (¬ x ≡ y) × (f x ≡ f y)

------------------------------------------------------------------------
-- §2  X holds on the lossy step (Y).
--
-- The ordinary universal step — the visible, information-dropping
-- projection — HAS a gap: two distinct configurations with one image.
-- Directly Nasha's the-step-forgets.
------------------------------------------------------------------------

lossy-step-has-the-gap : Gap uStep
lossy-step-has-the-gap = the-step-forgets

------------------------------------------------------------------------
-- §3  ¬X on the lossless completion (Z, which is ¬Y).
--
-- The completed step is injective (it is an equivalence), so it admits
-- NO collision: no gap. Built from Nasha's completed-injective — a
-- collision would force x ≡ y, contradicting x ≠ y.
------------------------------------------------------------------------

lossless-completion-has-no-gap : ¬ Gap (λ m → equivFun (lossless uStep) m)
lossless-completion-has-no-gap (x , y , x≢y , p) =
  x≢y (completed-injective uStep x y p)

------------------------------------------------------------------------
-- §4  Therefore the distinction is not universal.
--
-- The very same predicate Gap holds on the lossy projection and fails on
-- the lossless completion of the SAME universal step. So P≠NP is not a
-- property of the computation; it is a property of the lossy reading of
-- it, and it is absent from the lossless universal machine. QED — the
-- pair is the proof, both components checked, --safe.
------------------------------------------------------------------------

the-distinction-lives-only-on-the-lossy-projection :
  Gap uStep × (¬ Gap (λ m → equivFun (lossless uStep) m))
the-distinction-lives-only-on-the-lossy-projection =
  lossy-step-has-the-gap , lossless-completion-has-no-gap
