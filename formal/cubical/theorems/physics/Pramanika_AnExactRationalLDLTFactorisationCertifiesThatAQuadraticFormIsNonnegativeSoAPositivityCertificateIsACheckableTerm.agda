{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रामाणिक — the certified.
--
-- The Weil positivity oracle reduces positivity on a support length to
-- the positivity of a FINITE quadratic form, verified numerically.  For
-- that verification to enter the corpus it must be a term.  This file
-- makes the certificate shape a theorem over ℚ:
--
--     A = L · D · Lᵀ with every D_k ≥ 0   ⇒   vᵀ A v ≥ 0 for every v,
--
-- because vᵀ L D Lᵀ v = Σ_k D_k (Lᵀv)_k².  Over ℚ the equation A = L D Lᵀ
-- is decidable entry by entry, so a concrete certificate (L, D) is
-- checked by computation and the theorem hands back positivity.
--
--   §1  DOUBLE SUMS over ℚ: interchange, and pulling factors out.
--   §2  THE QUADRATIC FORM and its diagonalisation through the factors.
--   §3  POSITIVITY from a nonnegative diagonal.
--
-- प्रामाणिक (prāmāṇika, authoritative/certified) is ordinary Sanskrit.
------------------------------------------------------------------------

module Pramanika_AnExactRationalLDLTFactorisationCertifiesThatAQuadraticFormIsNonnegativeSoAPositivityCertificateIsACheckableTerm where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order using (≤-refl ; ≤-suc) renaming (_<_ to _<ℕ_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

module Sama (R : CommRing ℓ-zero) where
  open CommRingStr (snd R)
  pada : (v l d l′ v′ : ⟨ R ⟩) → (v · ((l · d) · l′)) · v′ ≡ d · ((v · l) · (v′ · l′))
  pada v l d l′ v′ = solve! R

open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order using (_≤_ ; isRefl≤ ; isTrans≤)

open import ParimeyaRupa_TheRationalsWithTheTrivialInvolutionFormAStarRingWithAHalfAndNonnegativityExcludesMinusTwoSoTheFiniteWeilCriterionAndTheKreinSplittingHoldOverQ
  using (ℚRing ; anṛṇa-varga ; anṛṇa-yoga)
open import VrddhiSima_ADiscreteGronwallWithASummableWeightClosesWithoutExponentialsSoTheTypeIEnergyBoundIsScaleInvariantAsATerm
  using (Σ⟨_⟩ ; Σ-guṇa)
open import DvandvaVarga_TheSquareOfTheInnerProductPlusTheSumOfPairSquaresIsTheProductOfNormsSoCauchySchwarzHoldsOverQAndTheResolvedDualityOfTheAdjointReceiverIsAttainedAtTheVectorItself
  using (Σ-ext ; Σ-add ; Σ-anṛṇa)
open import Vrddhi_AModeOfRatioAboveOneGrowsPastEveryBoundAndAModeOfRatioAtMostOneStaysBoundedSoTheFiniteGrowthTheoremReadsTheDominantRatio
  using (anṛṇa-guṇa)

------------------------------------------------------------------------
-- १ · Double sums.
------------------------------------------------------------------------

Σ-śūnya : (n : ℕ) → Σ⟨ n ⟩ (λ _ → 0) ≡ 0
Σ-śūnya zero    = refl
Σ-śūnya (suc n) = +IdR _ ∙ Σ-śūnya n

Σ-ext< : (n : ℕ) (f g : ℕ → ℚ) → ((i : ℕ) → i <ℕ n → f i ≡ g i) → Σ⟨ n ⟩ f ≡ Σ⟨ n ⟩ g
Σ-ext< zero    f g e = refl
Σ-ext< (suc n) f g e = cong₂ _+_ (Σ-ext< n f g (λ i lt → e i (≤-suc lt))) (e n ≤-refl)

Σ-swap : (n m : ℕ) (F : ℕ → ℕ → ℚ)
       → Σ⟨ n ⟩ (λ i → Σ⟨ m ⟩ (λ j → F i j)) ≡ Σ⟨ m ⟩ (λ j → Σ⟨ n ⟩ (λ i → F i j))
Σ-swap zero    m F = sym (Σ-śūnya m)
Σ-swap (suc n) m F = cong (_+ Σ⟨ m ⟩ (λ j → F n j)) (Σ-swap n m F)
                   ∙ sym (Σ-add (λ j → Σ⟨ n ⟩ (λ i → F i j)) (λ j → F n j) m)

-- pulling a right factor out
Σ-guṇaʳ : (f : ℕ → ℚ) (q : ℚ) (n : ℕ) → Σ⟨ n ⟩ (λ i → f i · q) ≡ Σ⟨ n ⟩ f · q
Σ-guṇaʳ f q n = Σ-ext (λ i → f i · q) (λ i → q · f i) n (λ i → ·Comm (f i) q) ∙ Σ-guṇa q f n ∙ ·Comm q (Σ⟨ n ⟩ f)

------------------------------------------------------------------------
-- २ · The quadratic form and its diagonalisation.
------------------------------------------------------------------------

module _ (n : ℕ) (A L : ℕ → ℕ → ℚ) (D : ℕ → ℚ)
         (ldl : (i j : ℕ) → i <ℕ n → j <ℕ n → A i j ≡ Σ⟨ n ⟩ (λ k → (L i k · D k) · L j k)) where

  -- vᵀ A v
  Q : (ℕ → ℚ) → ℚ
  Q v = Σ⟨ n ⟩ (λ i → Σ⟨ n ⟩ (λ j → (v i · A i j) · v j))

  -- (Lᵀ v)_k
  w : (ℕ → ℚ) → ℕ → ℚ
  w v k = Σ⟨ n ⟩ (λ i → v i · L i k)

  -- the diagonalisation: vᵀ A v = Σ_k D_k (Lᵀv)_k²
  vibhāga : (v : ℕ → ℚ) → Q v ≡ Σ⟨ n ⟩ (λ k → D k · (w v k · w v k))
  vibhāga v =
      Σ-ext< n _ _ (λ i i<n → Σ-ext< n _ _ (λ j j<n →
          cong (λ z → (v i · z) · v j) (ldl i j i<n j<n)
        ∙ cong (_· v j) (sym (Σ-guṇa (v i) _ n))
        ∙ sym (Σ-guṇaʳ _ (v j) n)
        ∙ Σ-ext _ _ n (λ k → Sama.pada ℚRing (v i) (L i k) (D k) (L j k) (v j))))
    -- now Σ_i Σ_j Σ_k D_k ((v_i L_ik)(v_j L_jk)); swap j,k inside, then i,k outside
    ∙ Σ-extₙ n _ _ (λ i → Σ-swap n n (λ j k → D k · ((v i · L i k) · (v j · L j k))))
    ∙ Σ-swap n n (λ i k → Σ⟨ n ⟩ (λ j → D k · ((v i · L i k) · (v j · L j k))))
    -- and factor: Σ_i Σ_j D_k (a_i b_j) = D_k (Σ a_i)(Σ b_j)
    ∙ Σ-extₙ n _ _ (λ k →
          Σ-extₙ n _ _ (λ i → Σ-guṇa (D k) _ n ∙ cong (D k ·_) (Σ-guṇa (v i · L i k) _ n))
        ∙ Σ-guṇa (D k) _ n
        ∙ cong (D k ·_) (Σ-guṇaʳ (λ i → v i · L i k) (w v k) n))
    where
    Σ-extₙ : (n : ℕ) (f g : ℕ → ℚ) → ((i : ℕ) → f i ≡ g i) → Σ⟨ n ⟩ f ≡ Σ⟨ n ⟩ g
    Σ-extₙ n f g e = Σ-ext< n f g (λ i _ → e i)

  ----------------------------------------------------------------------
  -- ३ · Positivity from a nonnegative diagonal.
  ----------------------------------------------------------------------

  prāmāṇika : ((k : ℕ) → 0 ≤ D k) → (v : ℕ → ℚ) → 0 ≤ Q v
  prāmāṇika 0≤D v = subst (0 ≤_) (sym (vibhāga v))
    (Σ-anṛṇa (λ k → D k · (w v k · w v k)) (λ k → anṛṇa-guṇa (D k) (w v k · w v k) (0≤D k) (anṛṇa-varga (w v k))) n)
