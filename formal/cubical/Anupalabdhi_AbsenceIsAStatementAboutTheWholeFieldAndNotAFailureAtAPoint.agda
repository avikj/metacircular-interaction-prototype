-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अनुपलब्धि — अभावः क्षेत्रस्य वचनम्, न तु स्थाने असिद्धिः ।
--
-- (absence is a statement about the field, not a failure at a point.)
--
-- ────────────────────────────────────────────────────────────────────
-- THE ASYMMETRY THIS FILE IS ABOUT.  Every other verdict in this corpus
-- is witnessed by EXHIBITING something: बहु by two points of a fibre,
-- एकम् by a centre, an edge by an equivalence, a receipt by an
-- identification.  रिक्तम् is the one that cannot be.  There is no
-- element of an empty fibre to show, so the witness has to be of a
-- different kind — and §१ says which kind, exactly.
--
-- §१ · अभावः पर्याप्तिः — "nothing in the field has this property" IS
-- "every member of the field lacks it".  The equivalence is free, both
-- directions, no hypothesis.  So a claim of absence is a Π over the WHOLE
-- domain, and cannot be less than that.
--
-- §२ · WHICH IS THE योग्यता CONDITION, and why the invalid form of
-- anupalabdhi is not merely weak but INEXPRESSIBLE.  Kumārila's
-- yogyānupalabdhi requires non-perception OF WHAT WOULD HAVE BEEN
-- PERCEIVED HAD IT BEEN PRESENT (Ślokavārttika, abhāva-pariccheda,
-- c. 7th c.): you know the pot is absent because you would have seen it;
-- you do not know a ghost is absent by not seeing one.  §१ is that
-- condition as a type — the Π ranges over the whole field, so producing
-- it IS having covered the field.  And the invalid form, "I searched and
-- did not find", has no internal statement at all: it is a fact about a
-- search, not about the domain, which is precisely why it licenses
-- nothing.
--
-- `machine/Nirdharana_…hs` reaches the same wall from the engineering
-- side and says so: EMPTY "is a case this instrument cannot certify at
-- all".  It cannot, because certifying it is §१'s Π and a census only
-- visits points.  `machine/Lopa_…hs` therefore reports UNDECIDED by count
-- rather than guessing, on the stated ground that a verdict guessed is
-- worse than a verdict withheld.
--
-- WHAT IS NOT CLAIMED.  §१ is the standard `¬Σ ≃ Π¬` and is library-grade
-- mathematics; nothing here is new.  What is claimed is the reading: that
-- this equivalence is the yogyatā condition, that it explains why रिक्तम्
-- is the only verdict without an exhibiting witness, and that the invalid
-- form of anupalabdhi is inexpressible rather than merely unsound.  No
-- Sanskrit source states §१, and Kumārila is credited for the condition
-- and for nothing below.
--
-- CHECKED: Agda 2.6.3 + agda/cubical v0.5, --cubical --safe, no
-- postulates, no holes, exit 0.
------------------------------------------------------------------------

module Anupalabdhi_AbsenceIsAStatementAboutTheWholeFieldAndNotAFailureAtAPoint where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_ ; fiber)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

private variable ℓ ℓ' : Level

------------------------------------------------------------------------
-- १ · अभावः पर्याप्तिः — absence is exactly universal lack.
--
-- Forward: if nothing in the field has P, then each member lacks it.
-- Backward: if each member lacks it, nothing in the field has it.
-- Both free.  The point is the SHAPE of the right-hand side: a Π over the
-- whole domain.  There is no smaller statement that means absence.
------------------------------------------------------------------------

क्षेत्र-वचनम् : {A : Type ℓ} (P : A → Type ℓ')
             → Iso (¬ (Σ[ a ∈ A ] P a)) ((a : A) → ¬ P a)
Iso.fun      (क्षेत्र-वचनम् P) ¬σ a p = ¬σ (a , p)
Iso.inv      (क्षेत्र-वचनम् P) f  σ   = f (σ .fst) (σ .snd)
Iso.rightInv (क्षेत्र-वचनम् P) _      = refl
Iso.leftInv  (क्षेत्र-वचनम् P) _      = refl

अभावः≃पर्याप्तिः : {A : Type ℓ} (P : A → Type ℓ')
                 → (¬ (Σ[ a ∈ A ] P a)) ≃ ((a : A) → ¬ P a)
अभावः≃पर्याप्तिः P = isoToEquiv (क्षेत्र-वचनम् P)

------------------------------------------------------------------------
-- २ · रिक्तम् has no exhibiting witness — read off §१ at a fibre.
--
-- A claim that the fibre over `b` is empty is, exactly, a rule covering
-- every point of the domain.  Not a point, not a finite check, not a
-- search that came back empty: a statement about the whole field.
------------------------------------------------------------------------

रिक्त-प्रमाणम् : {A B : Type ℓ} (f : A → B) (b : B)
              → (¬ (fiber f b)) ≃ ((a : A) → ¬ (f a ≡ b))
रिक्त-प्रमाणम् f b = अभावः≃पर्याप्तिः (λ a → f a ≡ b)

------------------------------------------------------------------------
-- ३ · and the contrast, so the asymmetry is on the page.
--
-- बहु and एकम् are witnessed by handing over inhabitants.  रिक्तम् cannot
-- be, and §२ says what stands in its place.
------------------------------------------------------------------------

उपलब्धिः : {A B : Type ℓ} (f : A → B) (a : A) → fiber f (f a)
उपलब्धिः f a = a , refl        -- a verdict you can hand someone

-- the empty fibre offers nothing to hand over, by construction
अनुपलब्धिः : (b : Unit) → ¬ (fiber (λ (x : ⊥) → tt) b)
अनुपलब्धिः _ (x , _) = Empty.rec x
