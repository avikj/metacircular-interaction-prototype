-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वरणम् — यत्र न किञ्चित् गूढं तत्र वरणं न अस्ति ।
--
-- (where nothing is hidden there is no choosing.)
--
-- ────────────────────────────────────────────────────────────────────
-- A SECTION IS A CHOICE OF RECEIPT AT EVERY POINT.  Given `f : A → B`, a
-- section picks, for each `b`, an inhabitant of the fibre over it — a
-- preimage together with the witness that it IS one.  That is exactly
-- "choose a receipt everywhere", and this file prices the space of such
-- choices.
--
-- §२ · WHEN NOTHING IS HIDDEN, THERE IS NOTHING TO CHOOSE.  If `f` is an
-- equivalence, every fibre is contractible, so the space of sections is
-- contractible: the choice exists and is unique, which is to say it is
-- not a choice.
--
-- §३ · WHEN SOMETHING IS HIDDEN, THE CHOICE IS REAL.  `Bool → Unit` has
-- two sections and they are distinct.  Nothing decides between them and
-- nothing in the codomain can see which was taken.
--
-- READ AT MOVEMENT 22.  Spontaneous symmetry breaking is the vacuum
-- choosing a point in a formerly free fibre, and mass is the coupling to
-- that paid receipt.  §३ is that at the smallest scale: a two-point
-- vacuum manifold, two sections, no ground for preferring either, and the
-- observable blind to the choice.  §२ is the other half and it is
-- `Dhruva`'s sentence from the section side — a lossless world has
-- nothing to choose, exactly as it has nothing to conserve and nowhere to
-- move.
--
-- WHAT IS NOT CLAIMED.  No physics.  No Higgs field, no potential, no
-- degeneracy of a ground state, no mass: those are read in the notes and
-- are not here.  Nor is any general classification of section spaces
-- claimed — §३ is one witness, the smallest available.  And note that
-- sections need not exist at all when a fibre is empty, which this file
-- does not treat (`Anupalabdhi_…agda` is where that verdict lives).
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5, --cubical --safe, no
-- postulates, no holes, exit 0.
------------------------------------------------------------------------

module Varanam_ASectionIsAChoiceOfReceiptEverywhereAndForALossyMapTheChoiceIsReal where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isContrΠ)
open import Cubical.Foundations.Equiv using (isEquiv ; fiber ; idIsEquiv ; equiv-proof)
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

private variable ℓ : Level

------------------------------------------------------------------------
-- १ · वरणम् — a choice of receipt at every point of the codomain.
------------------------------------------------------------------------

वरणम् : {A B : Type ℓ} → (A → B) → Type ℓ
वरणम् {B = B} f = (b : B) → fiber f b

------------------------------------------------------------------------
-- २ · अक्षये वरणं न — no loss, no choosing.
--
-- Every fibre contractible makes the whole space of sections
-- contractible: there is a choice, it is unique, and therefore it is not
-- a choice at all.
------------------------------------------------------------------------

अक्षये-वरणं-न : {A B : Type ℓ} (f : A → B) → isEquiv f → isContr (वरणम् f)
अक्षये-वरणं-न f e = isContrΠ (λ b → equiv-proof e b)

------------------------------------------------------------------------
-- ३ · क्षये वरणं सत् — where a bit is hidden, the choice is real.
--
-- Two sections of `Bool → Unit`, distinct, with nothing to decide between
-- them and nothing downstream able to see which was taken.
------------------------------------------------------------------------

लोपः : Bool → Unit
लोपः _ = tt

सद्-वरणम् असद्-वरणम् : वरणम् लोपः
सद्-वरणम्  _ = true  , refl
असद्-वरणम् _ = false , refl

वरणे-भेदः : ¬ (सद्-वरणम् ≡ असद्-वरणम्)
वरणे-भेदः p = false≢true (cong (λ s → s tt .fst) (sym p))

-- and therefore the space of choices is not a point: something was
-- genuinely selected, and the codomain cannot say what.
वरण-स्थानं-न-एकम् : ¬ (isContr (वरणम् लोपः))
वरण-स्थानं-न-एकम् c = वरणे-भेदः (sym (c .snd सद्-वरणम्) ∙ c .snd असद्-वरणम्)
