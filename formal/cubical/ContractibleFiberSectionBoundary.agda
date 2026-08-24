-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ContractibleFiberSectionBoundary
--
-- A section of the dependent path-fibre bundle
--
--     a ↦ Σ[ x ∈ A ] (a ≡ x)
--
-- is not a retraction of the set-truncation unit A → ∥ A ∥₂.  The former
-- section space is contractible for every A; the latter exists exactly when
-- A is a set.  S¹ separates the two types.
------------------------------------------------------------------------

module ContractibleFiberSectionBoundary where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun)
open import Cubical.Foundations.HLevels using (isContrΠ)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Data.Empty using (⊥)
open import Cubical.HITs.S1 using (S¹)
open import Cubical.Relation.Nullary using (¬_)

import SetTruncationDescentBoundary as Descent

private
  variable
    ℓ : Level

-- The path fibre rooted at a.  This is the sampled module's `insideView`
-- carrier, exposed here so that its actual section type is unambiguous.
InsideFiber : (A : Type ℓ) → A → Type ℓ
InsideFiber A a = Σ[ x ∈ A ] (a ≡ x)

-- A dependent section chooses a point and a path from the root in every
-- rooted fibre.  No truncation appears in this type.
InsideSections : Type ℓ → Type ℓ
InsideSections A = (a : A) → InsideFiber A a

-- Every root supplies its canonical centre.
canonicalInsideSection : {A : Type ℓ} → InsideSections A
canonicalInsideSection a = a , refl

-- More strongly, there is only one such section up to path: products of
-- contractible path fibres are contractible.
insideSectionsContr : {A : Type ℓ} → isContr (InsideSections A)
insideSectionsContr = isContrΠ Descent.insideView

-- The circle therefore has an inside section even though it is not a set.
insideSectionS¹ : InsideSections S¹
insideSectionS¹ = canonicalInsideSection

insideSectionsS¹Contr : isContr (InsideSections S¹)
insideSectionsS¹Contr = insideSectionsContr

-- Put the two facts side by side.  The right component is the existing
-- checked no-go for a retraction of S¹ → ∥ S¹ ∥₂.
inside-section-versus-truncation-retraction-S¹ :
  InsideSections S¹ × (¬ Descent.Retracts₀ S¹)
inside-section-versus-truncation-retraction-S¹ =
  insideSectionS¹ , Descent.noDescentS¹

-- Consequently the two candidate data types cannot be equivalent.  This is
-- the hostile control against identifying a dependent inside section with a
-- retraction of the set-truncation unit.
insideSections≄descentS¹ :
  ¬ (InsideSections S¹ ≃ Descent.Retracts₀ S¹)
insideSections≄descentS¹ e =
  Descent.noDescentS¹ (equivFun e insideSectionS¹)
