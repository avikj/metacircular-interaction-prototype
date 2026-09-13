{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रस्थ-खण्ड — the boundary block.
--
-- ParaSima gave the crossing identity for one shift.  The finite
-- prime-translation operator is a weighted sum of shifts,
--
--     P_t f  =  Σ_{a < n} w(a) · S_a f,
--
-- with w(a) = Λ(e^a)/e^{a/2} at a = log n on the arithmetic side.  Its
-- cross-boundary block — the left profile f paired against the right
-- profile g — is therefore the weighted sum of the boundary
-- convolutions at the shifted times:
--
--     ⟨J⁺g , P_t f⟩  =  Σ_{a < n} w(a) · h_{f,g}(t − a).
--
-- This is B_h(t), the centred boundary reading, as a matrix
-- coefficient, on the discrete window, exactly.
--
--   §1  LINEARITY of offset sums: constants pull out, sums of summands
--       split.
--   §2  THE DOUBLE SUM INTERCHANGES for offset sums, by induction on the
--       outer count.
--   §3  THE CROSSING IDENTITY AT ANY t ≥ a, from ParaSima's t = a + u.
--   §4  THE BLOCK IDENTITY.  Distribute the right profile through the
--       weighted sum, interchange, pull each weight out, and read each
--       inner pairing by §3.
--
-- प्रस्थ (prastha, a measure/plateau) and खण्ड (khaṇḍa, block) are
-- ordinary Sanskrit.
------------------------------------------------------------------------

module PrasthaKhanda_TheCrossBoundaryBlockOfTheWeightedShiftOperatorIsTheWeightedSumOfBoundaryConvolutionsAtTheShiftedTimes where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_,_)
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_ ; +-assoc ; +-comm ; +-zero
       ; ·-distribˡ ; ·-assoc ; ·-comm ; 0≡m·0)
open import Cubical.Data.Nat.Order using (_≤_ ; ≤-∸-+-cancel)

open import ParaSima_TheCrossBoundaryCoefficientOfATruncatedShiftIsTheConvolutionOfTheBoundaryProfilesAtTheShiftedTime
  using (Σ⟨_,_⟩ ; ⟨_∣_⟩ ; h ; pāra-sīmā)
open import SimaSesa_OnAFiniteWindowTheTwoNetZeroShiftWordsAgreeInTheBulkAndDifferOnTheBoundaryStripsSoDisplacementDescendsAndBoundaryHistoryDoesNot
  using (S)

------------------------------------------------------------------------
-- १ · Linearity of offset sums.
------------------------------------------------------------------------

-- a constant factor pulls out
Σ-scale : (s n c : ℕ) (F : ℕ → ℕ)
        → Σ⟨ s , n ⟩ (λ x → c · F x) ≡ c · Σ⟨ s , n ⟩ F
Σ-scale s zero    c F = 0≡m·0 c
Σ-scale s (suc n) c F =
    cong (c · F s +_) (Σ-scale (suc s) n c F)
  ∙ ·-distribˡ c (F s) (Σ⟨ suc s , n ⟩ F)

-- a sum of summands splits
Σ-add : (s n : ℕ) (F G : ℕ → ℕ)
      → Σ⟨ s , n ⟩ (λ x → F x + G x) ≡ Σ⟨ s , n ⟩ F + Σ⟨ s , n ⟩ G
Σ-add s zero    F G = refl
Σ-add s (suc n) F G =
    cong ((F s + G s) +_) (Σ-add (suc s) n F G)
  ∙ vinimaya (F s) (G s) (Σ⟨ suc s , n ⟩ F) (Σ⟨ suc s , n ⟩ G)
  where
  -- (p + q) + (r + u) ≡ (p + r) + (q + u)
  vinimaya : (p q r u : ℕ) → (p + q) + (r + u) ≡ (p + r) + (q + u)
  vinimaya p q r u =
      sym (+-assoc p q (r + u))
    ∙ cong (p +_) (+-assoc q r u ∙ cong (_+ u) (+-comm q r) ∙ sym (+-assoc r q u))
    ∙ +-assoc p r (q + u)

------------------------------------------------------------------------
-- २ · The double sum interchanges.
------------------------------------------------------------------------

Σ-parivarta : (s m n : ℕ) (W : ℕ → ℕ → ℕ)
            → Σ⟨ s , m ⟩ (λ a → Σ⟨ zero , n ⟩ (λ x → W a x))
            ≡ Σ⟨ zero , n ⟩ (λ x → Σ⟨ s , m ⟩ (λ a → W a x))
Σ-parivarta s zero    n W = sym (Σ-vanish′ n)
  where
  Σ-vanish′ : (n : ℕ) → Σ⟨ zero , n ⟩ (λ _ → zero) ≡ zero
  Σ-vanish′ = go zero
    where
    go : (s n : ℕ) → Σ⟨ s , n ⟩ (λ _ → zero) ≡ zero
    go s zero    = refl
    go s (suc n) = go (suc s) n
Σ-parivarta s (suc m) n W =
    cong (Σ⟨ zero , n ⟩ (λ x → W s x) +_) (Σ-parivarta (suc s) m n W)
  ∙ sym (Σ-add zero n (λ x → W s x) (λ x → Σ⟨ suc s , m ⟩ (λ a → W a x)))

------------------------------------------------------------------------
-- ३ · The crossing identity at any t ≥ a.
------------------------------------------------------------------------

pāra-sīmā′ : (t a : ℕ) (f g : ℕ → ℕ) → a ≤ t
           → ⟨_∣_⟩ t a g (S t a f) ≡ h f g (t ∸ a)
pāra-sīmā′ t a f g le =
  subst (λ z → ⟨_∣_⟩ z a g (S z a f) ≡ h f g (t ∸ a))
        (+-comm a (t ∸ a) ∙ ≤-∸-+-cancel le)
        (pāra-sīmā a (t ∸ a) f g)

------------------------------------------------------------------------
-- ४ · The block identity.
------------------------------------------------------------------------

-- the weighted shift operator, shifts a < n with weights w
P : (t n : ℕ) (w : ℕ → ℕ) → (ℕ → ℕ) → ℕ → ℕ
P t n w f x = Σ⟨ zero , n ⟩ (λ a → w a · S t a f x)

-- every shift a < n is at most t: the window contains the shifts
prastha-khaṇḍa : (t n : ℕ) (w : ℕ → ℕ) (f g : ℕ → ℕ)
               → ((a : ℕ) → a ≤ t)
               → ⟨_∣_⟩ t zero g (P t n w f)
               ≡ Σ⟨ zero , n ⟩ (λ a → w a · h f g (t ∸ a))
prastha-khaṇḍa t n w f g bounded =
    -- distribute g(t ∸ x) into the weighted sum, per x
    cong (Σ⟨ zero , t ⟩) (funExt λ x →
        sym (Σ-scale zero n (g (t ∸ x)) (λ a → w a · S t a f x)))
    -- interchange: Σ_x Σ_a  ⇒  Σ_a Σ_x
  ∙ sym (Σ-parivarta zero n t (λ a x → g (t ∸ x) · (w a · S t a f x)))
    -- pull each weight out of its inner pairing and read it
  ∙ cong (Σ⟨ zero , n ⟩) (funExt λ a →
        cong (Σ⟨ zero , t ⟩) (funExt λ x → vyatyāsa (g (t ∸ x)) (w a) (S t a f x))
      ∙ Σ-scale zero t (w a) (λ x → g (t ∸ x) · S t a f x)
      ∙ cong (w a ·_) (pāra-sīmā′ t a f g (bounded a)))
  where
  -- p · (q · r) ≡ q · (p · r)
  vyatyāsa : (p q r : ℕ) → p · (q · r) ≡ q · (p · r)
  vyatyāsa p q r = ·-assoc p q r ∙ cong (_· r) (·-comm p q) ∙ sym (·-assoc q p r)
