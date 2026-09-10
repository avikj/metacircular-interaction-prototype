{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PrecisionIsARepresentation — a defect of SantataDhara found by
-- building on it.  Its closeness relation u ∼⟨ε⟩ v is indexed by ε as a
-- REPRESENTATION (1+a)/(1+b), not by its value, and the two constructors
-- that reach a limit, ∼rat-lim and ∼lim-lim, only produce closeness at
-- an index of the form ε +⁺ δ — whose numerator is a successor by
-- construction.  Therefore:
--
--   §1  at a precision whose numerator field is 0 (e.g. quarter⁺ = 1/4),
--       closeness holds only between two rationals: a proposition-valued
--       family F on ℝ with F (rat q) = ⊤ and F (lim y) = ⊥ respects the
--       path constructor because eq's hypothesis at quarter⁺ can only be
--       ∼rat-rat;
--   §2  hence rat q ≢ lim y for every q and y: no limit is ever equal to
--       a rational.  In particular the limit of the constant
--       approximation at q is not rat q — the type is not the completion
--       it says it is.
--
-- WHAT THIS MEANS.  The module's stated completeness — "limits are
-- constructors, so the type is Cauchy complete" — is not usable: a limit
-- is a fresh point that nothing can be equal to.  The HoTT book's
-- construction (§11.3) avoids this because its ℚ⁺ is a set of values,
-- so ε +⁺ δ and any equal-valued precision index the same type.
--
-- THE FIX, named, not done here.  Either index the relation by the
-- quotient of ℚ⁺ by cross-multiplication equality, or add to the
-- relation a constructor
--     ∼val : ⟨ε⟩ =ℚ ⟨ε'⟩ → u ∼⟨ε⟩ v → u ∼⟨ε'⟩ v.
-- Either restores value-invariance of the index, after which
-- monotonicity in ε and the triangle inequality can be proved by the
-- book's induction, and the analysis tower can continue.  Changing the
-- base module is the owner's call.
--
-- SYĀT.  A negative theorem about the module's constructors, proved by
-- induction on the closeness relation; nothing about real numbers as
-- such.
------------------------------------------------------------------------

module PrecisionIsARepresentation_NoLimitIsEverCloseAtANonSumPrecisionSoTheContinuumsPathConstructorNeverIdentifiesALimit where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-suc ; snotz)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Foundations.HLevels using (hProp ; isSetHProp)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Foundations.Isomorphism using ()
open import Cubical.Data.Empty using (isProp⊥)

import SantataDhara_TheContinuumBuiltFromTheAxiomsWithItsLimitsAsConstructors as S
open S using (ℝ ; rat ; lim ; eq ; _∼⟨_⟩_ ; ∼rat-rat ; ∼rat-lim ; ∼lim-rat ; ∼lim-lim ; ∼squash ; CauchyApprox)
open S.ℚ⁺ using (num⁺ ; den⁺)

------------------------------------------------------------------------
-- §0  the numerator of a sum of precisions is a successor
------------------------------------------------------------------------

-- x + suc y is never zero
+suc≢0 : (x y : ℕ) → x + suc y ≡ 0 → ⊥
+suc≢0 x y e = snotz (sym (+-suc x y) ∙ e)

sum-num⁺≢0 : (ε δ : S.ℚ⁺) → num⁺ (ε S.+⁺ δ) ≡ 0 → ⊥
sum-num⁺≢0 (a S.⁺/1+ b) (c S.⁺/1+ d) e = +suc≢0 _ _ e

------------------------------------------------------------------------
-- §1  a family separating rationals from limits, respecting eq
------------------------------------------------------------------------

⊤ ⊥ₚ : hProp ℓ-zero
⊤ = Unit , (λ _ _ → refl)
⊥ₚ = ⊥ , isProp⊥

-- F, and the fact that closeness at a zero-numerator precision preserves F
F : ℝ → hProp ℓ-zero
F-eq : {u v : ℝ} {ε : S.ℚ⁺} → u ∼⟨ ε ⟩ v → num⁺ ε ≡ 0 → F u ≡ F v

F (rat q) = ⊤
F (lim y) = ⊥ₚ
F (eq u v h i) = F-eq (h S.quarter⁺) refl i

F-eq (∼rat-rat _) _ = refl
F-eq (∼rat-lim {ε = ε} {δ = δ} _) z = ⊥-rec (sum-num⁺≢0 ε δ z)
F-eq (∼lim-rat {ε = ε} {δ = δ} _) z = ⊥-rec (sum-num⁺≢0 ε δ z)
F-eq (∼lim-lim {ε = ε} {δ = δ} {η = η} _) z = ⊥-rec (sum-num⁺≢0 (δ S.+⁺ ε) η z)
F-eq (∼squash p p' i) z = isSetHProp _ _ (F-eq p z) (F-eq p' z) i

------------------------------------------------------------------------
-- §2  no limit is a rational
------------------------------------------------------------------------

rat≢lim : (q : S.ℚ) (y : CauchyApprox) → ¬ (rat q ≡ lim y)
rat≢lim q y e = transport (cong fst (cong F e)) tt

-- closeness at a quarter to a limit is impossible for a rational
no-rat-lim-at-quarter : (q : S.ℚ) (y : CauchyApprox) → ¬ (rat q ∼⟨ S.quarter⁺ ⟩ lim y)
no-rat-lim-at-quarter q y h = transport (cong fst (F-eq h refl)) tt

-- the constant approximation at q, a Cauchy approximation by ∼rat-rat …
constApprox : (q : S.ℚ) → ((ε : S.ℚ⁺) → S.Close ε q q) → CauchyApprox
constApprox q c = (λ _ → rat q) , λ δ ε → ∼rat-rat (c (δ S.+⁺ ε))

-- … whose limit is not rat q
limit-of-constant-is-not-its-value : (q : S.ℚ) (c : (ε : S.ℚ⁺) → S.Close ε q q)
                                   → ¬ (rat q ≡ lim (constApprox q c))
limit-of-constant-is-not-its-value q c = rat≢lim q (constApprox q c)
