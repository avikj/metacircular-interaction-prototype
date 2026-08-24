-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- EGB Delta-24, T24.3 as a term: the holonomy of a 3-cycle of
-- equivalences G₁ ≃ G₂ ≃ G₃ ≃ G₁ is an automorphism of G₁.  Coherent
-- triviality of the cycle is an *extra datum* (a path hol ≡ idEquiv),
-- not a default: we exhibit (a) the trivial cycle, whose holonomy is
-- idEquiv, and (b) a nontrivial cycle on Bool, whose holonomy is `not`
-- pointwise and provably not the identity.  Via univalence the
-- nontrivial witness is a non-refl loop at Bool in the universe.
--
-- Companion of formal/cubical/AchromaticToy.agda (which witnesses
-- T24.3 inside a three-perspective toy); here the statement is
-- isolated on the smallest possible carrier.

module EGBCycleHolonomy where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Univalence
open import Cubical.Data.Bool
open import Cubical.Relation.Nullary

private
  variable
    ℓ₁ ℓ₂ ℓ₃ : Level

-- (a) The holonomy of a 3-cycle of equivalences.
hol : {A : Type ℓ₁} {B : Type ℓ₂} {C : Type ℓ₃}
    → A ≃ B → B ≃ C → C ≃ A → A ≃ A
hol e12 e23 e31 = compEquiv e12 (compEquiv e23 e31)

-- (b) The trivial cycle composes to the identity automorphism.
holTrivial : (A : Type ℓ₁) → hol (idEquiv A) (idEquiv A) (idEquiv A) ≡ idEquiv A
holTrivial A = equivEq refl

-- (c) The nontrivial witness: the cycle (not, not, not) on Bool.
holBool : Bool ≃ Bool
holBool = hol notEquiv notEquiv notEquiv

-- Its underlying map is `not`, pointwise …
holBoolIsNot : ∀ b → equivFun holBool b ≡ not b
holBoolIsNot b = notnot (not b)

-- … and `not` is not the identity, so this unity cycle retains
-- nontrivial holonomy: it does not collapse to one static object.
notNotId : ¬ (∀ b → not b ≡ b)
notNotId h = true≢false (h false)

holBoolNontrivial : ¬ (∀ b → equivFun holBool b ≡ b)
holBoolNontrivial h = notNotId (λ b → sym (holBoolIsNot b) ∙ h b)

-- Univalence turns the witness into a loop at Bool in the universe …
holLoop : Bool ≡ Bool
holLoop = ua holBool

-- … and the loop is provably not refl: transport along it flips true.
holLoopNontrivial : ¬ (holLoop ≡ refl)
holLoopNontrivial p = true≢false
  (sym (sym (uaβ holBool true)
       ∙ (λ i → transport (p i) true)
       ∙ transportRefl true))
