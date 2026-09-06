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

------------------------------------------------------------------------
-- २ · The tail is at most (Σ|c_i|) · M^t.
------------------------------------------------------------------------

open import Cubical.Data.Rationals.Order using (_≟_ ; lt ; eq ; gt ; ≤max ; ≤→max)
open import Nirapeksa_TheAbsoluteValueOnTheRationalsIsTheMaximumOfAnElementAndItsNegativeSoItIsNonnegativeDominatesBothAndIsSubadditive
  using (∣_∣ ; vāma ; dakṣiṇa ; anṛṇa ; trikoṇa ; dhana-sama ; ṛṇa-sama ; max-≤ ; ≤Monotone+)
open import VrddhiSima_ADiscreteGronwallWithASummableWeightClosesWithoutExponentialsSoTheTypeIEnergyBoundIsScaleInvariantAsATerm
  using (Σ⟨_⟩ ; Σ-guṇa)
open import DvandvaVarga_TheSquareOfTheInnerProductPlusTheSumOfPairSquaresIsTheProductOfNormsSoCauchySchwarzHoldsOverQAndTheResolvedDualityOfTheAdjointReceiverIsAttainedAtTheVectorItself
  using (Σ-ext)
open import ParimeyaRupa_TheRationalsWithTheTrivialInvolutionFormAStarRingWithAHalfAndNonnegativityExcludesMinusTwoSoTheFiniteWeilCriterionAndTheKreinSplittingHoldOverQ
  using (ṛṇa-viparīta)
open import Cubical.Data.Nat.Order using (≤-refl ; ≤-suc) renaming (_<_ to _<ℕ_)

-- (−a)·p = −(a·p)
neg-guṇa : (a p : ℚ) → (- a) · p ≡ - (a · p)
neg-guṇa a p = sym (·Assoc (-1) a p)

-- |0| = 0
śūnya-sama : (∣ 0 ∣) ≡ 0
śūnya-sama = cong (max 0) (·AnnihilR (-1)) ∙ maxIdem 0

-- |a · p| = |a| · p for p ≥ 0
guṇa-sama : (a p : ℚ) → 0 ≤ p → ∣ a · p ∣ ≡ (∣ a ∣) · p
guṇa-sama a p 0≤p with a ≟ 0
... | lt a<0 = cong (max (a · p)) (sym (neg-guṇa a p))
             ∙ ≤→max (a · p) ((- a) · p) (≤-·o a (- a) p 0≤p a≤-a)
             ∙ cong (_· p) (sym (ṛṇa-sama a (<Weaken≤ a 0 a<0)))
  where
  a≤-a : a ≤ - a
  a≤-a = isTrans≤ a 0 (- a) (<Weaken≤ a 0 a<0) (<Weaken≤ 0 (- a) (ṛṇa-viparīta a a<0))
... | eq q   = cong (λ z → ∣ z · p ∣) q ∙ cong ∣_∣ (·AnnihilL p) ∙ śūnya-sama
             ∙ sym (·AnnihilL p) ∙ cong (_· p) (sym śūnya-sama) ∙ cong (λ z → (∣ z ∣) · p) (sym q)
... | gt 0<a = maxComm (a · p) (- (a · p))
             ∙ ≤→max (- (a · p)) (a · p) (isTrans≤ (- (a · p)) 0 (a · p) neg≤0 0≤ap)
             ∙ cong (_· p) (sym (dhana-sama a (<Weaken≤ 0 a 0<a)))
  where
  0≤ap : 0 ≤ a · p
  0≤ap = anṛṇa-guṇa a p (<Weaken≤ 0 a 0<a) 0≤p
  neg≤0 : - (a · p) ≤ 0
  neg≤0 = subst2 _≤_ (+IdL (- (a · p))) (+InvR (a · p)) (≤-+o 0 (a · p) (- (a · p)) 0≤ap)

-- |Σ f| ≤ Σ |f|
Σ-trikoṇa : (f : ℕ → ℚ) (n : ℕ) → ∣ Σ⟨ n ⟩ f ∣ ≤ Σ⟨ n ⟩ (λ i → ∣ f i ∣)
Σ-trikoṇa f zero    = subst (_≤ 0) (sym śūnya-sama) (isRefl≤ 0)
Σ-trikoṇa f (suc n) = isTrans≤ (∣ Σ⟨ n ⟩ f + f n ∣) ((∣ Σ⟨ n ⟩ f ∣) + (∣ f n ∣)) (Σ⟨ n ⟩ (λ i → ∣ f i ∣) + (∣ f n ∣))
  (trikoṇa (Σ⟨ n ⟩ f) (f n))
  (≤-+o (∣ Σ⟨ n ⟩ f ∣) (Σ⟨ n ⟩ (λ i → ∣ f i ∣)) (∣ f n ∣) (Σ-trikoṇa f n))

-- range-restricted monotonicity of sums
Σ-mono : (f g : ℕ → ℚ) (k : ℕ) → ((i : ℕ) → i <ℕ k → f i ≤ g i) → Σ⟨ k ⟩ f ≤ Σ⟨ k ⟩ g
Σ-mono f g zero    _  = isRefl≤ 0
Σ-mono f g (suc k) le =
  isTrans≤ (Σ⟨ k ⟩ f + f k) (Σ⟨ k ⟩ g + f k) (Σ⟨ k ⟩ g + g k)
    (≤-+o (Σ⟨ k ⟩ f) (Σ⟨ k ⟩ g) (f k) (Σ-mono f g k (λ i i<k → le i (≤-suc i<k))))
    (≤-o+ (f k) (g k) (Σ⟨ k ⟩ g) (le k ≤-refl))

-- powers are monotone on [0, ∞)
ghāta-mono : (a b : ℚ) → 0 ≤ a → a ≤ b → (t : ℕ) → a ^ t ≤ b ^ t
ghāta-mono a b 0≤a a≤b zero    = isRefl≤ 1
ghāta-mono a b 0≤a a≤b (suc t) =
  isTrans≤ (a · (a ^ t)) (a · (b ^ t)) (b · (b ^ t))
    (subst2 _≤_ (·Comm (a ^ t) a) (·Comm (b ^ t) a) (≤-·o (a ^ t) (b ^ t) a 0≤a (ghāta-mono a b 0≤a a≤b t)))
    (≤-·o a b (b ^ t) (anṛṇa-ghāta b (isTrans≤ 0 a b 0≤a a≤b) t) a≤b)

module Tail (n : ℕ) (c m : ℕ → ℚ) (M : ℚ) (0≤M : 0 ≤ M)
            (0≤m : (i : ℕ) → 0 ≤ m i) (m≤M : (i : ℕ) → i <ℕ n → m i ≤ M) where

  T : ℕ → ℚ
  T t = Σ⟨ n ⟩ (λ i → c i · (m i ^ t))

  C : ℚ
  C = Σ⟨ n ⟩ (λ i → ∣ c i ∣)

  pucchā : (t : ℕ) → ∣ T t ∣ ≤ C · (M ^ t)
  pucchā t =
    isTrans≤ (∣ T t ∣) (Σ⟨ n ⟩ (λ i → ∣ c i · (m i ^ t) ∣)) (C · (M ^ t))
      (Σ-trikoṇa (λ i → c i · (m i ^ t)) n)
      (subst (Σ⟨ n ⟩ (λ i → ∣ c i · (m i ^ t) ∣) ≤_)
             (Σ-guṇa (M ^ t) (λ i → ∣ c i ∣) n ∙ ·Comm (M ^ t) C)
        (Σ-mono (λ i → ∣ c i · (m i ^ t) ∣) (λ i → (M ^ t) · (∣ c i ∣)) n
          (λ i i<n → subst (_≤ (M ^ t) · (∣ c i ∣)) (sym (guṇa-sama (c i) (m i ^ t) (anṛṇa-ghāta (m i) (0≤m i) t)))
                       (subst (_≤ (M ^ t) · (∣ c i ∣)) (·Comm (m i ^ t) (∣ c i ∣))
                         (≤-·o (m i ^ t) (M ^ t) (∣ c i ∣) (anṛṇa (c i)) (ghāta-mono (m i) M (0≤m i) (m≤M i i<n) t))))))
