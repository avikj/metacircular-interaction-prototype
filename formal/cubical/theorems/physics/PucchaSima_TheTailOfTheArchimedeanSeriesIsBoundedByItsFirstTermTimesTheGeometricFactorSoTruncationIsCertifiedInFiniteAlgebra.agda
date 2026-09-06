{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पुच्छ-सीमा — the tail bound.
--
-- (5.5) of the note: for d > 0 and K ≥ 3,
--
--   0 ≤ H(d) − Σ_{k<K} e^{−λ_k d}/(λ_k²−16)²
--     ≤ e^{−λ_K d} / ((λ_K²−16)² (1 − e^{−2d})),      λ_k = 2k + ½.
--
-- Its finite algebra: the terms are positive; for k ≥ K the factor
-- 1/(λ_k²−16)² is at most 1/(λ_K²−16)² since λ_k²−16 is increasing and
-- positive for k ≥ 3; and e^{−λ_k d} = e^{−λ_K d} r^{k−K} with r = e^{−2d},
-- so the tail is at most the first term times Σ_{j} r^j, and
-- (1 − r) Σ_{j<n} r^j = 1 − r^n ≤ 1.  Over ℚ, with r an element of [0,1):
--
--   §1  THE GEOMETRIC IDENTITY (1 − r)·Σ_{j<n} r^j ≡ 1 − r^n over any ring.
--   §2  THE PARTIAL GEOMETRIC SUM IS AT MOST 1/(1−r), in the division-free
--       form (1 − r)·Σ_{j<n} r^j ≤ 1 for 0 ≤ r ≤ 1.
--   §3  THE TAIL BOUND for any nonnegative sequence a_j ≤ a_0 · r^j:
--       (1 − r)·Σ_{j<n} a_j ≤ a_0.
--
-- The analytic step — that the true H-tail is the limit of these partial
-- sums and that λ_k² − 16 increases — is the trust boundary.
------------------------------------------------------------------------

module PucchaSima_TheTailOfTheArchimedeanSeriesIsBoundedByItsFirstTermTimesTheGeometricFactorSoTruncationIsCertifiedInFiniteAlgebra where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (fst)
open import Cubical.Data.Nat.Order using (≤-refl ; ≤-suc) renaming (_<_ to _<ℕ_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

module Sama (R : CommRing ℓ-zero) where
  open CommRingStr (snd R) renaming (_+_ to _⊕_ ; _-_ to _⊝_ ; _·_ to _⊗_)
  step : (S p r : ⟨ R ⟩) → (1r ⊝ r) ⊗ (S ⊕ p) ≡ ((1r ⊝ r) ⊗ S) ⊕ (p ⊝ r ⊗ p)
  step S p r = solve! R
  ādi : (r : ⟨ R ⟩) → (1r ⊝ r) ⊗ 0r ≡ 1r ⊝ 1r
  ādi r = solve! R
  śeṣa′ : (p r : ⟨ R ⟩) → (1r ⊝ p) ⊕ (p ⊝ r ⊗ p) ≡ 1r ⊝ (r ⊗ p)
  śeṣa′ p r = solve! R
  punar : (u a S : ⟨ R ⟩) → u ⊗ (a ⊗ S) ≡ a ⊗ (u ⊗ S)
  punar u a S = solve! R

open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order using (_≤_ ; isRefl≤ ; isTrans≤ ; ≤-+o ; ≤-o+ ; ≤-·o ; <Weaken≤)
open import ParimeyaRupa_TheRationalsWithTheTrivialInvolutionFormAStarRingWithAHalfAndNonnegativityExcludesMinusTwoSoTheFiniteWeilCriterionAndTheKreinSplittingHoldOverQ
  using (ℚRing ; anṛṇa-yoga)
open import Vrddhi_AModeOfRatioAboveOneGrowsPastEveryBoundAndAModeOfRatioAtMostOneStaysBoundedSoTheFiniteGrowthTheoremReadsTheDominantRatio
  using (_^_ ; anṛṇa-guṇa)
open import VrddhiSima_ADiscreteGronwallWithASummableWeightClosesWithoutExponentialsSoTheTypeIEnergyBoundIsScaleInvariantAsATerm
  using (Σ⟨_⟩ ; vyava-≤ ; 0≤1 ; Σ-guṇa)
open import Atikrama_TheModeOfRatioAboveOneOverstepsEveryBoundAndTheModeOfRatioAtMostOneStaysWithinOneSoAModeIsBoundedExactlyWhenItsRatioIsAtMostOne
  using (antar)
open import Prabala_TheDominantModeWinsSoASignedSumOfModesWithADominantRatioAboveOneOverstepsEveryBoundAndTheGrowthRateIsTheDominantRatio
  using (Σ-mono)

------------------------------------------------------------------------
-- १ · (1 − r)·Σ_{j<n} r^j ≡ 1 − r^n.
------------------------------------------------------------------------

geo : (r : ℚ) (n : ℕ) → (1 - r) · Σ⟨ n ⟩ (λ j → r ^ j) ≡ 1 - (r ^ n)
geo r zero    = Sama.ādi ℚRing r
geo r (suc n) = Sama.step ℚRing (Σ⟨ n ⟩ (λ j → r ^ j)) (r ^ n) r
              ∙ cong (_+ ((r ^ n) - (r · (r ^ n)))) (geo r n)
              ∙ Sama.śeṣa′ ℚRing (r ^ n) r

------------------------------------------------------------------------
-- २ · (1 − r)·Σ_{j<n} r^j ≤ 1 for 0 ≤ r ≤ 1.
------------------------------------------------------------------------

geo-≤ : (r : ℚ) → 0 ≤ r → r ≤ 1 → (n : ℕ) → (1 - r) · Σ⟨ n ⟩ (λ j → r ^ j) ≤ 1
geo-≤ r 0≤r r≤1 n = subst (_≤ 1) (sym (geo r n)) (vyava-≤ 1 (r ^ n) (fst (antar r 0≤r r≤1 n)))

------------------------------------------------------------------------
-- ३ · For 0 ≤ a_j ≤ a₀·r^j:  (1 − r)·Σ_{j<n} a_j ≤ a₀.
------------------------------------------------------------------------

puccha-sīmā : (r a₀ : ℚ) → 0 ≤ r → r ≤ 1 → 0 ≤ a₀ → (n : ℕ)
            → (a : ℕ → ℚ) → ((j : ℕ) → j <ℕ n → a j ≤ a₀ · (r ^ j))
            → (1 - r) · Σ⟨ n ⟩ a ≤ a₀
puccha-sīmā r a₀ 0≤r r≤1 0≤a₀ n a bd =
  isTrans≤ ((1 - r) · Σ⟨ n ⟩ a) ((1 - r) · Σ⟨ n ⟩ (λ j → a₀ · (r ^ j))) a₀
    (subst2 _≤_ (·Comm (Σ⟨ n ⟩ a) (1 - r)) (·Comm (Σ⟨ n ⟩ (λ j → a₀ · (r ^ j))) (1 - r))
      (≤-·o (Σ⟨ n ⟩ a) (Σ⟨ n ⟩ (λ j → a₀ · (r ^ j))) (1 - r) 0≤1-r (Σ-mono a (λ j → a₀ · (r ^ j)) n bd)))
    (subst (_≤ a₀) (sym (cong ((1 - r) ·_) (Σ-guṇa a₀ (λ j → r ^ j) n) ∙ Sama.punar ℚRing (1 - r) a₀ (Σ⟨ n ⟩ (λ j → r ^ j))))
      (subst (a₀ · ((1 - r) · Σ⟨ n ⟩ (λ j → r ^ j)) ≤_) (·IdR a₀)
        (subst2 _≤_ (·Comm ((1 - r) · Σ⟨ n ⟩ (λ j → r ^ j)) a₀) (·Comm 1 a₀)
          (≤-·o ((1 - r) · Σ⟨ n ⟩ (λ j → r ^ j)) 1 a₀ 0≤a₀ (geo-≤ r 0≤r r≤1 n)))))
  where
  0≤1-r : 0 ≤ 1 - r
  0≤1-r = subst (_≤ 1 - r) (+InvR r) (≤-+o r 1 (- r) r≤1)
