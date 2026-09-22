{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सह-सममिति — the co-isometry.
--
-- Theorem 2 of the note gives T T* = 2 P_K; PurnaDhruvana checks the
-- scaled Gram matrix Π̃ = T̃*T̃ is Hermitian with Π̃² = 576·Π̃.  The
-- consequences (2.2)–(2.3) — the operator bound |T x|² ≤ 2|x|² and the
-- source/output/residual decomposition — rest on one algebraic fact
-- about any Hermitian M with M² = m·M over a *-ring:
--
--     m · (c* M c) = (M c)* (M c)          for every vector c,
--
-- so c*Mc is m⁻¹ times a norm, nonnegative for any positivity that
-- contains norms; and with M = T*T, m = 2 (unscaled) this is
-- |Tc|² = c*(T*T)c and 2|c|² − |Tc|² = |(I − T*T/2)c|²·2 ≥ 0.  Proved here
-- over any StarRing with finite sums, by the double-sum interchange.
------------------------------------------------------------------------

module SahaSamamiti_AHermitianMatrixThatIsIdempotentUpToAScalarSquaresItsFormIntoANormSoTheCoisometrysOperatorBoundAndResidualDecompositionAreExact where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

open import TauRupa_TheCriticalReflectionFormIsPreservedByEveryConfigurationsTransportAndThePlainFormExactlyWhenEveryModeHasUnitModulusSoRHSitsAtTheModulus
  using (StarRing)
import TauRupa_TheCriticalReflectionFormIsPreservedByEveryConfigurationsTransportAndThePlainFormExactlyWhenEveryModeHasUnitModulusSoRHSitsAtTheModulus as T
import KreinSucika_TheDoubledReflectionFormSplitsIntoAPositiveSumOfSquaresMinusASumOfSquaresSupportedExactlyOnTheMovedModesSoTheNegativeIndexCountsTheOffLineModes as K
import WeilDhanatva_TheReflectionFormIsPositiveOnEveryVectorExactlyWhenEveryModeIsFixedByTheReflectionSoFiniteWeilPositivityIsFiniteRH as W

private
  variable
    ℓ : Level

module _ (S : StarRing ℓ) where
  open StarRing S

  Σ⟨_⟩ : ℕ → (ℕ → ⟨ R ⟩) → ⟨ R ⟩
  Σ⟨ n ⟩ f = T.Σᵣ⟨_,_⟩ S zero n f

  Σ-ext : (n : ℕ) (f g : ℕ → ⟨ R ⟩) → ((i : ℕ) → f i ≡ g i) → Σ⟨ n ⟩ f ≡ Σ⟨ n ⟩ g
  Σ-ext n = T.Σᵣ-ext S zero n
  Σ-scale : (n : ℕ) (k : ⟨ R ⟩) (f : ℕ → ⟨ R ⟩) → Σ⟨ n ⟩ (λ i → k · f i) ≡ k · Σ⟨ n ⟩ f
  Σ-scale n = K.Σᵣ-scale S zero n
  Σ-swap : (n m : ℕ) (F : ℕ → ℕ → ⟨ R ⟩) → Σ⟨ n ⟩ (λ i → Σ⟨ m ⟩ (λ j → F i j)) ≡ Σ⟨ m ⟩ (λ j → Σ⟨ n ⟩ (λ i → F i j))
  Σ-swap = K.Σᵣ-swap S

  -- star passes through sums
  Σ-✶ : (n : ℕ) (f : ℕ → ⟨ R ⟩) → (Σ⟨ n ⟩ f) ✶ ≡ Σ⟨ n ⟩ (λ i → (f i) ✶)
  Σ-✶ n f = go zero n
    where
    go : (s m : ℕ) → (T.Σᵣ⟨_,_⟩ S s m f) ✶ ≡ T.Σᵣ⟨_,_⟩ S s m (λ i → (f i) ✶)
    go s zero    = W.✶-zero S
    go s (suc m) = ✶-add (f s) _ ∙ cong ((f s) ✶ +_) (go (suc s) m)

  -- a right scalar out of a sum
  Σ-scaleʳ : (n : ℕ) (f : ℕ → ⟨ R ⟩) (k : ⟨ R ⟩) → Σ⟨ n ⟩ (λ i → f i · k) ≡ Σ⟨ n ⟩ f · k
  Σ-scaleʳ n f k = Σ-ext n _ _ (λ i → ·Comm (f i) k) ∙ Σ-scale n k f ∙ ·Comm k (Σ⟨ n ⟩ f)

  module _ (n : ℕ) (M : ℕ → ℕ → ⟨ R ⟩) (m : ⟨ R ⟩)
           (herm : (i j : ℕ) → (M i j) ✶ ≡ M j i)
           (idem : (j k : ℕ) → Σ⟨ n ⟩ (λ i → M j i · M i k) ≡ m · M j k) where

    -- (M c)_i
    Mc : (ℕ → ⟨ R ⟩) → ℕ → ⟨ R ⟩
    Mc c i = Σ⟨ n ⟩ (λ j → M i j · c j)

    -- c* M c
    form : (ℕ → ⟨ R ⟩) → ⟨ R ⟩
    form c = Σ⟨ n ⟩ (λ j → (c j) ✶ · Mc c j)

    -- (Mc)*(Mc)
    norm² : (ℕ → ⟨ R ⟩) → ⟨ R ⟩
    norm² c = Σ⟨ n ⟩ (λ i → (Mc c i) ✶ · Mc c i)

    saha-samamiti : (c : ℕ → ⟨ R ⟩) → m · form c ≡ norm² c
    saha-samamiti c = sym (step₁ ∙ step₂ ∙ step₃ ∙ step₄)
      where
      punar : (a b x y : ⟨ R ⟩) → (a · b) · (x · y) ≡ b · ((a · x) · y)
      punar a b x y = solve! R
      punar′ : (b m x y : ⟨ R ⟩) → b · ((m · x) · y) ≡ m · (b · (x · y))
      punar′ b m x y = solve! R
      -- summands at each stage
      A₀ : ℕ → ⟨ R ⟩
      A₀ i = (Mc c i) ✶ · Mc c i
      A₁ : ℕ → ℕ → ℕ → ⟨ R ⟩
      A₁ i j k = (M j i · (c j) ✶) · (M i k · c k)
      A₂ : ℕ → ℕ → ℕ → ⟨ R ⟩
      A₂ j i k = (c j) ✶ · ((M j i · M i k) · c k)
      B₁ B₂ B₃ F₁ F₂ F₃ : ℕ → ⟨ R ⟩
      B₁ i = Σ⟨ n ⟩ (λ j → Σ⟨ n ⟩ (λ k → A₁ i j k))
      B₂ j = Σ⟨ n ⟩ (λ i → Σ⟨ n ⟩ (λ k → A₁ i j k))
      B₃ j = Σ⟨ n ⟩ (λ k → (c j) ✶ · (Σ⟨ n ⟩ (λ i → M j i · M i k) · c k))
      F₁ j = Σ⟨ n ⟩ (λ k → m · ((c j) ✶ · (M j k · c k)))
      F₂ j = m · ((c j) ✶ · Mc c j)
      F₃ j = (c j) ✶ · Mc c j
      -- step 1: expand the norm into the triple sum
      e₁ : (i : ℕ) → A₀ i ≡ B₁ i
      e₁ i = cong (_· Mc c i) (Σ-✶ n (λ j → M i j · c j)
                               ∙ Σ-ext n (λ j → (M i j · c j) ✶) (λ j → M j i · (c j) ✶)
                                       (λ j → ✶-mul (M i j) (c j) ∙ cong (_· (c j) ✶) (herm i j)))
           ∙ sym (Σ-scaleʳ n (λ j → M j i · (c j) ✶) (Mc c i))
           ∙ Σ-ext n (λ j → (M j i · (c j) ✶) · Mc c i) (λ j → Σ⟨ n ⟩ (λ k → A₁ i j k))
                   (λ j → sym (Σ-scale n (M j i · (c j) ✶) (λ k → M i k · c k)))
      step₁ : norm² c ≡ Σ⟨ n ⟩ B₁
      step₁ = Σ-ext n A₀ B₁ e₁
      -- step 2: swap, rearrange, swap, pull c_j* and c_k out
      e₂ : (j : ℕ) → B₂ j ≡ B₃ j
      e₂ j = Σ-ext n (λ i → Σ⟨ n ⟩ (λ k → A₁ i j k)) (λ i → Σ⟨ n ⟩ (λ k → A₂ j i k))
                     (λ i → Σ-ext n (λ k → A₁ i j k) (λ k → A₂ j i k) (λ k → punar (M j i) ((c j) ✶) (M i k) (c k)))
           ∙ Σ-swap n n (λ i k → A₂ j i k)
           ∙ Σ-ext n (λ k → Σ⟨ n ⟩ (λ i → A₂ j i k)) (λ k → (c j) ✶ · (Σ⟨ n ⟩ (λ i → M j i · M i k) · c k))
                   (λ k → Σ-scale n ((c j) ✶) (λ i → (M j i · M i k) · c k)
                        ∙ cong ((c j) ✶ ·_) (Σ-scaleʳ n (λ i → M j i · M i k) (c k)))
      step₂ : Σ⟨ n ⟩ B₁ ≡ Σ⟨ n ⟩ B₃
      step₂ = Σ-swap n n (λ i j → Σ⟨ n ⟩ (λ k → A₁ i j k)) ∙ Σ-ext n B₂ B₃ e₂
      -- step 3: the inner sum is m · M_jk
      e₃ : (j : ℕ) → B₃ j ≡ F₁ j
      e₃ j = Σ-ext n (λ k → (c j) ✶ · (Σ⟨ n ⟩ (λ i → M j i · M i k) · c k)) (λ k → m · ((c j) ✶ · (M j k · c k)))
                     (λ k → cong (λ z → (c j) ✶ · (z · c k)) (idem j k) ∙ punar′ ((c j) ✶) m (M j k) (c k))
      step₃ : Σ⟨ n ⟩ B₃ ≡ Σ⟨ n ⟩ F₁
      step₃ = Σ-ext n B₃ F₁ e₃
      -- step 4: pull m out
      e₄ : (j : ℕ) → F₁ j ≡ F₂ j
      e₄ j = Σ-scale n m (λ k → (c j) ✶ · (M j k · c k))
           ∙ cong (m ·_) (Σ-scale n ((c j) ✶) (λ k → M j k · c k))
      step₄ : Σ⟨ n ⟩ F₁ ≡ m · form c
      step₄ = Σ-ext n F₁ F₂ e₄ ∙ Σ-scale n m F₃
