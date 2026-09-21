{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वृद्धि — growth.
--
-- The proof note's growth theorem: limsup log(1+|B(t)|)/t = Θ − ½, where
-- Θ is the supremum of Re ρ; hence RH ⇔ B = O(1).  A mode e^{(ρ−½)t} is
-- bounded exactly when Re ρ ≤ ½.  Its finite shadow over ℚ: the mode
-- t ↦ m^t with m > 0 is bounded exactly when m ≤ 1.
--
--   §1  ι : ℕ → ℚ, and Bernoulli's inequality: (1 + x)^t ≥ 1 + t·x for
--       x ≥ 0, by induction with one product of nonnegatives.
--   §2  THE ARCHIMEDEAN PROPERTY of ℚ: for x > 0 and any K there merely
--       exists t : ℕ with K < ι t · x — read off on representatives.
--   §3  A MODE OF RATIO > 1 GROWS PAST EVERY BOUND; a mode of ratio in
--       [0,1] stays in [0,1].
--
-- वृद्धि (vṛddhi, growth) is ordinary Sanskrit and Pāṇini's own term.
------------------------------------------------------------------------

module Vrddhi_AModeOfRatioAboveOneGrowsPastEveryBoundAndAModeOfRatioAtMostOneStaysBoundedSoTheFiniteGrowthTheoremReadsTheDominantRatio where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

-- ring identities, proved once over any commutative ring and read at ℚ
module Sama (R : CommRing ℓ-zero) where
  open CommRingStr (snd R)
  vistāra : (x u : ⟨ R ⟩) → (1r + x) · (1r + u · x) ≡ (1r + (u + 1r) · x) + (u · x) · x
  vistāra x u = solve! R
  eka-guṇa : (x : ⟨ R ⟩) → 1r + 0r · x ≡ 1r
  eka-guṇa x = solve! R


open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order
  using (_≤_ ; _<_ ; isRefl≤ ; isTrans≤ ; <Weaken≤ ; ≤-+o ; ≤-o+ ; ≤-·o ; <-·o ; <-+o ; isTrans≤< ; isTrans<≤)

open import ParimeyaRupa_TheRationalsWithTheTrivialInvolutionFormAStarRingWithAHalfAndNonnegativityExcludesMinusTwoSoTheFiniteWeilCriterionAndTheKreinSplittingHoldOverQ
  using (ℚRing ; anṛṇa-varga ; anṛṇa-yoga)

------------------------------------------------------------------------
-- १ · ι and Bernoulli.
------------------------------------------------------------------------

ι : ℕ → ℚ
ι zero    = 0
ι (suc n) = ι n + 1

_^_ : ℚ → ℕ → ℚ
m ^ zero  = 1
m ^ suc t = m · (m ^ t)

-- 0 ≤ ι n
ι-anṛṇa : (n : ℕ) → 0 ≤ ι n
ι-anṛṇa zero    = isRefl≤ 0
ι-anṛṇa (suc n) = anṛṇa-yoga {ι n} {1} (ι-anṛṇa n) (<Weaken≤ 0 1 0<1)
  where 0<1 : 0 < 1
        0<1 = 0 , refl

-- products of nonnegatives are nonnegative
anṛṇa-guṇa : (x y : ℚ) → 0 ≤ x → 0 ≤ y → 0 ≤ x · y
anṛṇa-guṇa x y 0≤x 0≤y = subst (_≤ x · y) (·AnnihilL y) (≤-·o 0 x y 0≤y 0≤x)

-- Bernoulli: (1 + x)^t ≥ 1 + ι t · x for 0 ≤ x
bernoulli : (x : ℚ) → 0 ≤ x → (t : ℕ) → 1 + ι t · x ≤ (1 + x) ^ t
bernoulli x 0≤x zero = subst (_≤ 1) (sym (Sama.eka-guṇa ℚRing x)) (isRefl≤ 1)
bernoulli x 0≤x (suc t) =
  isTrans≤ (1 + ι (suc t) · x) ((1 + x) · (1 + ι t · x)) ((1 + x) ^ suc t)
    step
    (subst2 _≤_ (·Comm (1 + ι t · x) (1 + x)) (·Comm ((1 + x) ^ t) (1 + x))
       (≤-·o (1 + ι t · x) ((1 + x) ^ t) (1 + x) 0≤1+x (bernoulli x 0≤x t)))
  where
  0≤1+x : 0 ≤ 1 + x
  0≤1+x = anṛṇa-yoga {1} {x} (<Weaken≤ 0 1 (0 , refl)) 0≤x
  step : 1 + ι (suc t) · x ≤ (1 + x) · (1 + ι t · x)
  step = subst (1 + ι (suc t) · x ≤_) (sym (Sama.vistāra ℚRing x (ι t)))
           (subst (_≤ (1 + (ι t + 1) · x) + (ι t · x) · x) (+IdR (1 + (ι t + 1) · x))
              (≤-o+ 0 ((ι t · x) · x) (1 + (ι t + 1) · x)
                 (anṛṇa-guṇa (ι t · x) x (anṛṇa-guṇa (ι t) x (ι-anṛṇa t) 0≤x) 0≤x)))
