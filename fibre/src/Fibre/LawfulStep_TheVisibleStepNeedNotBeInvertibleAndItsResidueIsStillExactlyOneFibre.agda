{-# OPTIONS --cubical --safe --guardedness #-}

------------------------------------------------------------------------
-- Punarāgamana · LawfulStep
--
-- THE DISTINCTION THIS MODULE EXISTS TO KEEP.
--
-- `Fibre.Carrier` and `Fibre.Trace` are about a change of PRESENTATION.
-- A heartbeat is a change of STATE, and the two are not the same claim:
--
--   losslessness of re-presentation  ⇏  invertibility of the transition.
--
-- The corpus's own heartbeat (Fibre.Viveka's Φ) happens to be injective,
-- which makes it easy to forget that nothing in the machinery required it
-- to be.  A lawful step is therefore NOT "an invertible step".  It is a
-- step whose residue is typed:
--
--   next         : A → A                        the visible successor
--   Residue      : A → Type                     what the successor omits
--   materialises : A ≃ Σ[ a' ∈ A ] Residue a'   the source is the sum
--   visible      : the equivalence's first projection IS `next`
--
-- THE FOURTH FIELD IS NOT DECORATION.  Without `visible`, `next` is
-- unconstrained by the other three and the record asserts nothing about
-- the step it names — one could pair an arbitrary transition with the
-- identity's factorisation and satisfy the type.  Tying the projection to
-- `next` is what makes the residue the residue OF THIS STEP, and it is
-- what `residue-is-the-fibre` below consumes.
--
-- THE THEOREM.  Given that tie, the residue of a lawful step is exactly
-- the homotopy fibre of the step:
--
--   Residue a'  ≃  fiber next a'
--
-- and so, by Fibre.Trace's two corollaries transported along it,
--
--   contractible residue  ⟺  the step is invertible.
--
-- THE WITNESS.  `collapse` (n ↦ 0) forgets its entire input.  It is
-- provably not an equivalence; its residue over 0 is provably ℕ, hence
-- provably not contractible; and ℕ ≃ Σ[ n ] fiber collapse n all the same,
-- with the source recovered by refl.  That triple is the whole point: the
-- factorisation is lossless BECAUSE the residue is large, not despite it.
--
-- THE THIRD CASE.  Non-invertibility has two shapes, not one.  `collapse`
-- is the crowded fibre; `suc` is the EMPTY one — nothing steps to 0 — and
-- `isContr` alone cannot tell those apart.  That is exactly the census
-- point already made in
-- Fibre.SakalaVikalaDesa_TheFibreCensusIsATermAndItRefutesTheSequentialDiagnostic,
-- and it is cited here rather than re-proved.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9 (the repository pin),
-- --cubical --safe --guardedness, no postulates, no holes; reachable
-- from fibre/src/Everything.agda, so `sh check` drives it.
------------------------------------------------------------------------

module Fibre.LawfulStep_TheVisibleStepNeedNotBeInvertibleAndItsResidueIsStillExactlyOneFibre where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.HLevels
open import Cubical.Data.Sigma
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Properties
open import Cubical.Relation.Nullary using (¬_)

open import Fibre.Trace_TheTraceFamilyIsForcedToBeTheFibreAndTheCarrierIsItsContractibleCase

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- The record.
------------------------------------------------------------------------

record LawfulStep (A : Type ℓ) : Type (ℓ-suc ℓ) where
  field
    next         : A → A
    Residue      : A → Type ℓ
    materialises : A ≃ (Σ[ a' ∈ A ] Residue a')
    visible      : (a : A) → fst (equivFun materialises a) ≡ next a

  factorisation : Conservative A A
  factorisation = conserving Residue materialises

open LawfulStep public

------------------------------------------------------------------------
-- The residue of a lawful step is the fibre of the step.
------------------------------------------------------------------------

module _ {A : Type ℓ} (L : LawfulStep A) where

  private
    C : Conservative A A
    C = factorisation L

  -- the tie, as a path of functions
  run≡next : run C ≡ next L
  run≡next = funExt (visible L)

  residue-is-the-fibre : (a' : A) → Residue L a' ≃ fiber (next L) a'
  residue-is-the-fibre a' =
    compEquiv (trace-is-forced C a')
              (pathToEquiv (cong (λ h → fiber h a') run≡next))

  -- the two ends of the scale, now read as a statement about a step
  contractible-residue→invertible
    : ((a' : A) → isContr (Residue L a')) → isEquiv (next L)
  contractible-residue→invertible h =
    subst (λ h → isEquiv h) run≡next (exact-when-contractible C h)

  invertible→contractible-residue
    : isEquiv (next L) → (a' : A) → isContr (Residue L a')
  invertible→contractible-residue e =
    contractible-when-exact C (subst (λ h → isEquiv h) (sym run≡next) e)

------------------------------------------------------------------------
-- Every endomorphism has a lawful step, with no hypothesis on it.
------------------------------------------------------------------------

lawful : {A : Type ℓ} (f : A → A) → LawfulStep A
LawfulStep.next         (lawful f)   = f
LawfulStep.Residue      (lawful f)   = fiber f
LawfulStep.materialises (lawful f)   = fiberize f
LawfulStep.visible      (lawful f) a = refl

------------------------------------------------------------------------
-- The witness: a step that forgets its entire input.
------------------------------------------------------------------------

collapse : ℕ → ℕ
collapse _ = 0

collapse-step : LawfulStep ℕ
collapse-step = lawful collapse

-- 1.  It is not an equivalence, and no path between types can make it one:
--     two distinct sources land on one result, so a section would identify
--     them.
collapse-not-invertible : ¬ isEquiv collapse
collapse-not-invertible e =
  znots (sym (retEq (collapse , e) 0) ∙ retEq (collapse , e) 1)

-- 2.  Its residue over 0 is the whole of ℕ — every source is still there.
collapse-residue : fiber collapse 0 ≃ ℕ
collapse-residue = Σ-contractSnd (λ _ → refl , isSetℕ 0 0 refl)

-- 3.  …hence not contractible.  This is the same fact as (1), seen from
--     the other side, and Fibre.Trace's corollaries are what connect them.
collapse-residue-not-contractible : ¬ isContr (fiber collapse 0)
collapse-residue-not-contractible c =
  znots (isContr→isProp (isOfHLevelRespectEquiv 0 collapse-residue c) 0 1)

-- 4.  And the factorisation is exact all the same.  Losslessness holds
--     BECAUSE the residue is large.
collapse-lossless : ℕ ≃ (Σ[ n ∈ ℕ ] fiber collapse n)
collapse-lossless = fiberize collapse

-- 5.  The source is not reconstructed from the result; it was never left
--     behind.  refl.
collapse-recovers : (n : ℕ) → fst (trace (canonical collapse) n) ≡ n
collapse-recovers n = refl

------------------------------------------------------------------------
-- The other way a step can fail to be invertible: an empty fibre.
------------------------------------------------------------------------

-- Nothing steps to 0 under suc.  `isContr` merges this with (3); the
-- census in Fibre.SakalaVikalaDesa is what separates them.
suc-residue-empty : ¬ fiber suc 0
suc-residue-empty (n , p) = snotz p

suc-step : LawfulStep ℕ
suc-step = lawful suc

-- suc is not invertible either, and for the opposite reason.
suc-not-invertible : ¬ isEquiv suc
suc-not-invertible e = suc-residue-empty (equiv-proof e 0 .fst)
