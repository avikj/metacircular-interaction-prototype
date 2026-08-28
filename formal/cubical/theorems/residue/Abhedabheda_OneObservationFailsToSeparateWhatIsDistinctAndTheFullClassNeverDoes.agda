{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अभेद-भेदः — दृष्ट्या अभिन्नं वस्तुतो भिन्नम् ।
--
-- (indistinguishable to the view, distinct in fact.)
--
-- ────────────────────────────────────────────────────────────────────
-- LEIBNIZ, BOTH WAYS, IN ONE FILE — and the fibre is the gap between them.
--
-- §१ · `cong` is the indiscernibility of identicals and it is FREE: apply
-- any function to equal things and get equal results.  It carries no
-- hypothesis because it is not a theorem about anything — it is
-- constitutive of what equality is.  That is why the fibre law transports
-- everywhere and why it is the SHALLOWEST available statement rather than
-- a deep one.
--
-- §२ · Its contrapositive is every barrier in every science, exhibited
-- here at the minimum: an observation under which two distinct things
-- agree.  `बहुदर्शनम्` cannot separate `true` from `false`, and they are
-- not equal.  Nothing about the observation is weak, small, or
-- improvable: no post-processing of `tt` recovers the bit.
--
-- §३ · And univalence is Leibniz's OTHER law — identity of indiscernibles
-- — which does not fail: when the class is everything, indistinguishable
-- IS identical, and in cubical it computes.
--
-- SO THE FIBRE IS EXACTLY THE GAP between "indistinguishable by THIS
-- observation" (§२, and it is a real gap) and "indistinguishable by ALL
-- structure" (§३, and there the gap is zero).  A barrier is the report
-- that one is not at the limit — misfiled, in every field that has one,
-- as a report about the terrain.
--
-- SYĀT — THE CLAIM, EXACTLY.  `cong`, `ua` and `false≢true` are library, and the
-- witness is the smallest there is.  Nothing here is new mathematics.
-- What is claimed is that the three stand together: the free direction,
-- an exhibited failure of its converse under a restricted class, and the
-- converse holding when the class is complete.  The readings — that this
-- is why barriers are properties of observation classes rather than of
-- objects, and why the only operation that changes what a mind can see is
-- acquiring a predicate it did not have — are in
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5, --cubical --safe, no
-- postulates, no holes, exit 0.
------------------------------------------------------------------------

module Abhedabheda_OneObservationFailsToSeparateWhatIsDistinctAndTheFullClassNeverDoes where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Sigma using (_×_ ; _,_)

private variable ℓ : Level

------------------------------------------------------------------------
-- १ · तादात्म्यस्य अभेदः — indiscernibility of identicals, free.
------------------------------------------------------------------------

अभेदः : {A B : Type ℓ} (F : A → B) {x y : A} → x ≡ y → F x ≡ F y
अभेदः F = cong F

------------------------------------------------------------------------
-- २ · दृष्टि-सीमा — an observation under which two distinct things agree.
--
-- The witness is minimal on purpose: nothing about this observation is
-- weak or small, and no amount of work on its output recovers the bit.
------------------------------------------------------------------------

बहुदर्शनम् : Bool → Unit
बहुदर्शनम् _ = tt

-- the observation cannot separate them ...
अभिन्नं-दर्शने : बहुदर्शनम् true ≡ बहुदर्शनम् false
अभिन्नं-दर्शने = refl

-- ... and they are not the same
भिन्नं-वस्तुतः : ¬ (true ≡ false)
भिन्नं-वस्तुतः p = false≢true (sym p)

-- so: indistinguishable to this view, distinct in fact.  The pair IS the
-- fibre, and there is nothing else to it.
अभेद-भेदः : (बहुदर्शनम् true ≡ बहुदर्शनम् false) × (¬ (true ≡ false))
अभेद-भेदः = अभिन्नं-दर्शने , भिन्नं-वस्तुतः

------------------------------------------------------------------------
-- ३ · पूर्ण-दृष्टौ न भेदः — and when the class is everything, it does not
--     fail: an exhibited equivalence IS an identity, and it computes.
------------------------------------------------------------------------

अभिन्नानां-तादात्म्यम् : {A B : Type ℓ} → A ≃ B → A ≡ B
अभिन्नानां-तादात्म्यम् = ua
