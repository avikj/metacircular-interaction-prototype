{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- विपरीत-योग — the adjoint sum.
--
-- The adjoint receiver identity (9) is integration by parts followed by
-- duality.  DvandvaVarga did the duality; this file does the parts, on
-- the periodic grid ℤ/N with the forward difference ∇⁺g(x) = g(x+1) − g(x)
-- and the backward difference ∇⁻f(x) = f(x) − f(x−1):
--
--     Σ_x f(x) · ∇⁺g(x)  =  − Σ_x ∇⁻f(x) · g(x).
--
--   §1  THE CYCLIC SHIFT and its inverse on [0, N), and reindexing a
--       range sum by the inverse shift (peeling the first term).
--   §2  SUMMATION BY PARTS, periodic: the identity above over ℚ.
--
-- विपरीत (viparīta, reversed/adjoint) and योग (yoga, sum) are ordinary
-- Sanskrit.
------------------------------------------------------------------------

module ViparitaYoga_ThePeriodicForwardDifferenceIsMinusTheAdjointOfTheBackwardDifferenceUnderTheSumSoTheDiscreteIntegrationByPartsHalfOfTheAdjointReceiverIdentityIsATerm where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; discreteℕ ; +-suc)
open import Cubical.Data.Nat.Order using (pred-≤-pred ; ¬-<-zero ; ≤-suc ; ≤-refl ; ≤-trans ; ≤SumLeft) renaming (_<_ to _<ℕ_ ; _≤_ to _≤ℕ_)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
open import Cubical.Relation.Nullary using (¬_ ; yes ; no)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

module Sama (R : CommRing ℓ-zero) where
  open CommRingStr (snd R)
  vibhāga : (f a b : ⟨ R ⟩) → f · (a - b) ≡ f · a - f · b
  vibhāga f a b = solve! R
  vibhāga′ : (a b g : ⟨ R ⟩) → (a - b) · g ≡ a · g - b · g
  vibhāga′ a b g = solve! R
  viparīta : (P Q : ⟨ R ⟩) → P - Q ≡ - (Q - P)
  viparīta P Q = solve! R

open import Cubical.Data.Rationals

open import VrddhiSima_ADiscreteGronwallWithASummableWeightClosesWithoutExponentialsSoTheTypeIEnergyBoundIsScaleInvariantAsATerm
  using (Σ⟨_⟩)
open import DvandvaVarga_TheSquareOfTheInnerProductPlusTheSumOfPairSquaresIsTheProductOfNormsSoCauchySchwarzHoldsOverQAndTheResolvedDualityOfTheAdjointReceiverIsAttainedAtTheVectorItself
  using (Σ-ext ; Σ-sub)
open import ParimeyaRupa_TheRationalsWithTheTrivialInvolutionFormAStarRingWithAHalfAndNonnegativityExcludesMinusTwoSoTheFiniteWeilCriterionAndTheKreinSplittingHoldOverQ
  using (ℚRing)

------------------------------------------------------------------------
-- १ · The cyclic shift on [0, suc M) and reindexing.
------------------------------------------------------------------------

-- range-restricted extensionality
Σ-ext< : (n : ℕ) (f g : ℕ → ℚ) → ((i : ℕ) → i <ℕ n → f i ≡ g i) → Σ⟨ n ⟩ f ≡ Σ⟨ n ⟩ g
Σ-ext< zero    f g e = refl
Σ-ext< (suc n) f g e = cong₂ _+_ (Σ-ext< n f g (λ i lt → e i (≤-suc lt))) (e n ≤-refl)

-- peeling the first term: Σ_{x<suc M} F x = F 0 + Σ_{x<M} F (suc x)
Σ-ādi : (M : ℕ) (F : ℕ → ℚ) → Σ⟨ suc M ⟩ F ≡ F 0 + Σ⟨ M ⟩ (λ x → F (suc x))
Σ-ādi zero    F = +Comm 0 (F 0)
Σ-ādi (suc M) F = cong (_+ F (suc M)) (Σ-ādi M F) ∙ sym (+Assoc (F 0) _ (F (suc M)))

module _ (M : ℕ) where

  -- the shift and its inverse
  agra : ℕ → ℕ
  agra x with discreteℕ x M
  ... | yes _ = zero
  ... | no  _ = suc x

  pūrva : ℕ → ℕ
  pūrva zero    = M
  pūrva (suc x) = x

  agra-pūrva : (x : ℕ) → x <ℕ suc M → agra (pūrva x) ≡ x
  agra-pūrva zero    _  with discreteℕ M M
  ... | yes _ = refl
  ... | no ¬p = ⊥-elim (¬p refl)
  agra-pūrva (suc x) lt with discreteℕ x M
  ... | yes p = ⊥-elim (Cubical.Data.Nat.Order.¬m<m (subst (λ z → suc z <ℕ suc M) p lt))
  ... | no  _ = refl

  -- reindexing by the inverse shift: Σ_{x<suc M} h (pūrva x) = Σ_{x<suc M} h x
  pūrva-sama : (h : ℕ → ℚ) → Σ⟨ suc M ⟩ (λ x → h (pūrva x)) ≡ Σ⟨ suc M ⟩ h
  pūrva-sama h = Σ-ādi M (λ x → h (pūrva x)) ∙ +Comm (h M) (Σ⟨ M ⟩ h)

  ----------------------------------------------------------------------
  -- २ · Summation by parts, periodic.
  ----------------------------------------------------------------------

  -- Σ f(x) g(agra x) = Σ f(pūrva x) g(x)
  sthānāntara : (f g : ℕ → ℚ)
              → Σ⟨ suc M ⟩ (λ x → f x · g (agra x)) ≡ Σ⟨ suc M ⟩ (λ x → f (pūrva x) · g x)
  sthānāntara f g =
      sym (pūrva-sama (λ x → f x · g (agra x)))
    ∙ Σ-ext< (suc M) _ _ (λ x lt → cong (λ z → f (pūrva x) · g z) (agra-pūrva x lt))

  viparīta-yoga : (f g : ℕ → ℚ)
                → Σ⟨ suc M ⟩ (λ x → f x · (g (agra x) - g x))
                ≡ - Σ⟨ suc M ⟩ (λ x → (f x - f (pūrva x)) · g x)
  viparīta-yoga f g =
      Σ-ext (λ x → f x · (g (agra x) - g x)) (λ x → (f x · g (agra x)) - (f x · g x)) (suc M)
            (λ x → Sama.vibhāga ℚRing (f x) (g (agra x)) (g x))
    ∙ Σ-sub (λ x → f x · g (agra x)) (λ x → f x · g x) (suc M)
    ∙ cong (_- Σ⟨ suc M ⟩ (λ x → f x · g x)) (sthānāntara f g)
    ∙ Sama.viparīta ℚRing (Σ⟨ suc M ⟩ (λ x → f (pūrva x) · g x)) (Σ⟨ suc M ⟩ (λ x → f x · g x))
    ∙ cong -_ (sym (Σ-sub (λ x → f x · g x) (λ x → f (pūrva x) · g x) (suc M)))
    ∙ cong -_ (Σ-ext (λ x → (f x · g x) - (f (pūrva x) · g x)) (λ x → (f x - f (pūrva x)) · g x) (suc M)
                     (λ x → sym (Sama.vibhāga′ ℚRing (f x) (f (pūrva x)) (g x))))
