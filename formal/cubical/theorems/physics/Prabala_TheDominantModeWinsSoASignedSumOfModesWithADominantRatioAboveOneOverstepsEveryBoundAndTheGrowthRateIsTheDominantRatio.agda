{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रबल — the dominant.
--
-- The growth theorem with signed weights: B(t) = Σ c_i m_i^t with a
-- dominant mode m_0 > m_i (i ≥ 1) and c_0 ≠ 0.  If m_0 > 1 then B
-- oversteps every bound.  The engine is the two-term binomial bound
--
--     (m + x)^{t+1} ≥ m^{t+1} + (t+1) · x · m^t      (m, x ≥ 0),
--
-- which makes the dominant mode beat the tail by an Archimedean margin.
--
--   §1  THE TWO-TERM BINOMIAL BOUND, by induction as for Bernoulli.
--   §2  THE TAIL IS AT MOST (Σ|c_i|) · M^t when every tail ratio is ≤ M.
--   §3  THE DOMINANT MODE OVERSTEPS: for M < m_0, |c_0| m_0^t exceeds
--       K + (Σ|c_i|) M^t for some t, so |B(t)| > K.
--
-- प्रबल (prabala, dominant/strong) is ordinary Sanskrit.
------------------------------------------------------------------------

module Prabala_TheDominantModeWinsSoASignedSumOfModesWithADominantRatioAboveOneOverstepsEveryBoundAndTheGrowthRateIsTheDominantRatio where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

module Sama (R : CommRing ℓ-zero) where
  open CommRingStr (snd R)
  -- (m + x)(m^{t+1} + u x m^t) = m^{t+2} + (u+1) x m^{t+1} + u x² m^t
  vistāra : (m x u p : ⟨ R ⟩)
          → (m + x) · (m · p + (u · x) · p) ≡ (m · (m · p) + ((u + 1r) · x) · (m · p)) + (u · x · x) · p
  vistāra m x u p = solve! R
  ādi : (m x : ⟨ R ⟩) → m · 1r + ((0r + 1r) · x) · 1r ≡ (m + x) · 1r
  ādi m x = solve! R

open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order
  using (_≤_ ; _<_ ; isRefl≤ ; isTrans≤ ; <Weaken≤ ; ≤-+o ; ≤-o+ ; ≤-·o)

open import ParimeyaRupa_TheRationalsWithTheTrivialInvolutionFormAStarRingWithAHalfAndNonnegativityExcludesMinusTwoSoTheFiniteWeilCriterionAndTheKreinSplittingHoldOverQ
  using (ℚRing ; anṛṇa-yoga)
open import Vrddhi_AModeOfRatioAboveOneGrowsPastEveryBoundAndAModeOfRatioAtMostOneStaysBoundedSoTheFiniteGrowthTheoremReadsTheDominantRatio
  using (ι ; _^_ ; anṛṇa-guṇa ; ι-anṛṇa)

------------------------------------------------------------------------
-- १ · The two-term binomial bound.
------------------------------------------------------------------------

anṛṇa-ghāta : (m : ℚ) → 0 ≤ m → (t : ℕ) → 0 ≤ m ^ t
anṛṇa-ghāta m 0≤m zero    = <Weaken≤ 0 1 (0 , refl)
anṛṇa-ghāta m 0≤m (suc t) = anṛṇa-guṇa m (m ^ t) 0≤m (anṛṇa-ghāta m 0≤m t)

dvipada : (m x : ℚ) → 0 ≤ m → 0 ≤ x → (t : ℕ)
        → (m ^ suc t) + ((ι (suc t) · x) · (m ^ t)) ≤ (m + x) ^ suc t
dvipada m x 0≤m 0≤x zero = subst (_≤ (m + x) · 1) (sym (Sama.ādi ℚRing m x)) (isRefl≤ ((m + x) · 1))
dvipada m x 0≤m 0≤x (suc t) =
  isTrans≤ (m ^ suc (suc t) + ((ι (suc (suc t)) · x) · (m ^ suc t)))
           ((m + x) · (m ^ suc t + ((ι (suc t) · x) · (m ^ t))))
           ((m + x) ^ suc (suc t))
    step
    (subst2 _≤_ (·Comm (m ^ suc t + ((ι (suc t) · x) · (m ^ t))) (m + x)) (·Comm ((m + x) ^ suc t) (m + x))
      (≤-·o (m ^ suc t + ((ι (suc t) · x) · (m ^ t))) ((m + x) ^ suc t) (m + x)
            (anṛṇa-yoga {m} {x} 0≤m 0≤x) (dvipada m x 0≤m 0≤x t)))
  where
  -- drop the nonnegative u x² m^t term
  step : m ^ suc (suc t) + ((ι (suc (suc t)) · x) · (m ^ suc t))
       ≤ (m + x) · (m ^ suc t + ((ι (suc t) · x) · (m ^ t)))
  step = subst (m ^ suc (suc t) + ((ι (suc (suc t)) · x) · (m ^ suc t)) ≤_)
               (sym (Sama.vistāra ℚRing m x (ι (suc t)) (m ^ t)))
           (subst (_≤ (m · (m · (m ^ t)) + (((ι (suc t) + 1) · x) · (m · (m ^ t)))) + ((ι (suc t) · x · x) · (m ^ t)))
                  (+IdR (m · (m · (m ^ t)) + (((ι (suc t) + 1) · x) · (m · (m ^ t)))))
                  (≤-o+ 0 ((ι (suc t) · x · x) · (m ^ t)) (m · (m · (m ^ t)) + (((ι (suc t) + 1) · x) · (m · (m ^ t))))
                     (anṛṇa-guṇa (ι (suc t) · x · x) (m ^ t)
                        (anṛṇa-guṇa (ι (suc t) · x) x (anṛṇa-guṇa (ι (suc t)) x (ι-anṛṇa (suc t)) 0≤x) 0≤x)
                        (anṛṇa-ghāta m 0≤m t))))
