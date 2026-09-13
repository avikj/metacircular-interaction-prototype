{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- द्वन्द्व-वर्ग — the pair squares.
--
-- The proof note's adjoint receiver identity (9):
--
--     sup_{w ∈ H_K, ‖w‖ ≤ 1} |∫ R : ∇w|  =  ‖ℙ P_{≤K} ∇·R‖₂,
--
-- is integration by parts followed by Hilbert-space duality on a
-- finite-dimensional space.  The duality is Cauchy–Schwarz with its
-- equality case, and over ℚ, where there is no square root, it reads
-- in squares: ⟨v,w⟩² ≤ ⟨v,v⟩⟨w,w⟩ for all w, with equality at w = v.
-- Behind it is Lagrange's identity, exact over any commutative ring:
--
--     (Σ v_i w_i)² + Σ_{i<j} (v_i w_j − v_j w_i)²  =  (Σ v_i²)(Σ w_i²).
--
--   §1  SUM ALGEBRA over ℚ for right-recursive range sums.
--   §2  LAGRANGE'S IDENTITY, by induction on the range, the new index
--       entering through Σ_i (v_i w − v w_i)² = w²V + v²W − 2vwS.
--   §3  CAUCHY–SCHWARZ: the pair-square sum is nonnegative.
--   §4  THE DUALITY ATTAINED: at w = v the inequality is an equality, so
--       the supremum of ⟨v,w⟩²/⟨w,w⟩ is ⟨v,v⟩ — the receiver reads the
--       full resolved force, not a fraction of it.
--
-- द्वन्द्व (dvandva, pair) and वर्ग (varga, square) are ordinary Sanskrit.
------------------------------------------------------------------------

module DvandvaVarga_TheSquareOfTheInnerProductPlusTheSumOfPairSquaresIsTheProductOfNormsSoCauchySchwarzHoldsOverQAndTheResolvedDualityOfTheAdjointReceiverIsAttainedAtTheVectorItself where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

module Sama (R : CommRing ℓ-zero) where
  open CommRingStr (snd R)
  -- the new index's pair squares, termwise
  pada : (a b v w : ⟨ R ⟩)
       → (a · w - v · b) · (a · w - v · b) ≡ ((w · w) · (a · a) + (v · v) · (b · b)) - ((1r + 1r) · (v · w)) · (a · b)
  pada a b v w = solve! R
  -- the induction step, given S² + D = V W as the atom VW
  krama : (S D V W v w : ⟨ R ⟩)
        → (S + v · w) · (S + v · w) + (D + (((w · w) · V + (v · v) · W) - ((1r + 1r) · (v · w)) · S))
        ≡ (S · S + D) + ((w · w) · V + (v · v) · W + (v · v) · (w · w))
  krama S D V W v w = solve! R
  antya : (V W v w : ⟨ R ⟩) → V · W + ((w · w) · V + (v · v) · W + (v · v) · (w · w)) ≡ (V + v · v) · (W + w · w)
  antya V W v w = solve! R
  śūnya : 0r · 0r + 0r ≡ 0r · 0r
  śūnya = solve! R

open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order using (_≤_ ; isRefl≤ ; isTrans≤ ; ≤-o+)

open import ParimeyaRupa_TheRationalsWithTheTrivialInvolutionFormAStarRingWithAHalfAndNonnegativityExcludesMinusTwoSoTheFiniteWeilCriterionAndTheKreinSplittingHoldOverQ
  using (ℚRing ; anṛṇa-varga ; anṛṇa-yoga)
open import VrddhiSima_ADiscreteGronwallWithASummableWeightClosesWithoutExponentialsSoTheTypeIEnergyBoundIsScaleInvariantAsATerm
  using (Σ⟨_⟩ ; Σ-guṇa)

------------------------------------------------------------------------
-- १ · Sum algebra.
------------------------------------------------------------------------

Σ-ext : (f g : ℕ → ℚ) (n : ℕ) → ((i : ℕ) → f i ≡ g i) → Σ⟨ n ⟩ f ≡ Σ⟨ n ⟩ g
Σ-ext f g zero    e = refl
Σ-ext f g (suc n) e = cong₂ _+_ (Σ-ext f g n e) (e n)

Σ-add : (f g : ℕ → ℚ) (n : ℕ) → Σ⟨ n ⟩ (λ i → f i + g i) ≡ Σ⟨ n ⟩ f + Σ⟨ n ⟩ g
Σ-add f g zero    = sym (+IdR 0)
Σ-add f g (suc n) = cong (_+ (f n + g n)) (Σ-add f g n) ∙ punar (Σ⟨ n ⟩ f) (Σ⟨ n ⟩ g) (f n) (g n)
  where punar : (a b x y : ℚ) → (a + b) + (x + y) ≡ (a + x) + (b + y)
        punar a b x y = sym (+Assoc a b (x + y)) ∙ cong (a +_) (+Assoc b x y ∙ cong (_+ y) (+Comm b x) ∙ sym (+Assoc x b y)) ∙ +Assoc a x (b + y)

Σ-sub : (f g : ℕ → ℚ) (n : ℕ) → Σ⟨ n ⟩ (λ i → f i - g i) ≡ Σ⟨ n ⟩ f - Σ⟨ n ⟩ g
Σ-sub f g n = Σ-ext (λ i → f i - g i) (λ i → f i + (- g i)) n (λ i → refl)
            ∙ Σ-add f (λ i → - g i) n
            ∙ cong (Σ⟨ n ⟩ f +_) (Σ-neg g n)
  where
  Σ-neg : (g : ℕ → ℚ) (n : ℕ) → Σ⟨ n ⟩ (λ i → - g i) ≡ - Σ⟨ n ⟩ g
  Σ-neg g n = Σ-guṇa (-1) g n

Σ-anṛṇa : (f : ℕ → ℚ) → ((i : ℕ) → 0 ≤ f i) → (n : ℕ) → 0 ≤ Σ⟨ n ⟩ f
Σ-anṛṇa f 0≤f zero    = isRefl≤ 0
Σ-anṛṇa f 0≤f (suc n) = anṛṇa-yoga {Σ⟨ n ⟩ f} {f n} (Σ-anṛṇa f 0≤f n) (0≤f n)

------------------------------------------------------------------------
-- २ · Lagrange's identity.
------------------------------------------------------------------------

module _ (v w : ℕ → ℚ) where

  S V W : ℕ → ℚ
  S n = Σ⟨ n ⟩ (λ i → v i · w i)
  V n = Σ⟨ n ⟩ (λ i → v i · v i)
  W n = Σ⟨ n ⟩ (λ i → w i · w i)

  -- the pair squares below n
  D : ℕ → ℚ
  D n = Σ⟨ n ⟩ (λ j → Σ⟨ j ⟩ (λ i → ((v i · w j) - (v j · w i)) · ((v i · w j) - (v j · w i))))

  -- the new index's pair squares: Σ_i (v_i w − v w_i)² = w² V + v² W − 2 v w S
  nava : (n : ℕ) → Σ⟨ n ⟩ (λ i → ((v i · w n) - (v n · w i)) · ((v i · w n) - (v n · w i)))
                 ≡ ((w n · w n) · V n + (v n · v n) · W n) - (((1 + 1) · (v n · w n)) · S n)
  nava n =
      Σ-ext _ _ n (λ i → Sama.pada ℚRing (v i) (w i) (v n) (w n))
    ∙ Σ-sub _ _ n
    ∙ cong₂ _-_ (Σ-add _ _ n ∙ cong₂ _+_ (Σ-guṇa (w n · w n) _ n) (Σ-guṇa (v n · v n) _ n))
                (Σ-guṇa ((1 + 1) · (v n · w n)) _ n)

  lagrange : (n : ℕ) → S n · S n + D n ≡ V n · W n
  lagrange zero    = Sama.śūnya ℚRing
  lagrange (suc n) =
      cong (λ z → (S n + v n · w n) · (S n + v n · w n) + (D n + z)) (nava n)
    ∙ Sama.krama ℚRing (S n) (D n) (V n) (W n) (v n) (w n)
    ∙ cong (_+ ((w n · w n) · V n + (v n · v n) · W n + (v n · v n) · (w n · w n))) (lagrange n)
    ∙ Sama.antya ℚRing (V n) (W n) (v n) (w n)

  ----------------------------------------------------------------------
  -- ३ · Cauchy–Schwarz.
  ----------------------------------------------------------------------

  D-anṛṇa : (n : ℕ) → 0 ≤ D n
  D-anṛṇa n = Σ-anṛṇa _ (λ j → Σ-anṛṇa _ (λ i → anṛṇa-varga ((v i · w j) - (v j · w i))) j) n

  cauchy-schwarz : (n : ℕ) → S n · S n ≤ V n · W n
  cauchy-schwarz n = subst (S n · S n ≤_) (lagrange n)
    (subst (_≤ S n · S n + D n) (+IdR (S n · S n)) (≤-o+ 0 (D n) (S n · S n) (D-anṛṇa n)))

------------------------------------------------------------------------
-- ४ · The duality attained at w = v: ⟨v,v⟩² = ⟨v,v⟩ ⟨v,v⟩.
------------------------------------------------------------------------

sama-sīmā : (v : ℕ → ℚ) (n : ℕ) → S v v n · S v v n ≡ V v v n · W v v n
sama-sīmā v n = refl

-- the finite adjoint receiver identity (9), in squares: for every test w
-- the reading is at most the norm product, and the reading at w = v is it.
grāhaka-dvaya : (v : ℕ → ℚ) (n : ℕ)
              → ((w : ℕ → ℚ) → S v w n · S v w n ≤ V v w n · W v w n)
              × (S v v n · S v v n ≡ V v v n · W v v n)
grāhaka-dvaya v n = (λ w → cauchy-schwarz v w n) , sama-sīmā v n
