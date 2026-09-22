{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- गेर्शगोरिन — the row bound.
--
-- An exact LDLᵀ of a 64×64 rational matrix has pivots with thousands of
-- digits; a machine-checkable certificate carries instead a DYADIC L, D
-- and an exact slack E = A − LDLᵀ that is small and diagonally dominant.
-- This file supplies the theorem the slack needs, over ℚ:
--
--     if 4·E_ii ≥ Σ_j |E_ij| + Σ_j |E_ji| for every i < n   (full sums)
--     then vᵀ E v ≥ 0 for every v.
--
-- (For symmetric E this is E_ii ≥ Σ_{j≠i} |E_ij|.)  The proof:
-- 2 vᵀEv = Σ_{i,j} T_ij − Σ_{i,j} |E_ij| (v_i² + v_j²), where
-- T_ij = |E_ij|(v_i² + v_j²) + 2 v_i E_ij v_j is |E_ij| (v_i ± v_j)² ≥ 0,
-- and T_ii = 4 E_ii v_i².  No i ≠ j bookkeeping is needed.
--
--   §1  THE TERM T_ij IS A SQUARE, by the sign of E_ij.
--   §2  THE DECOMPOSITION of 2 vᵀEv.
--   §3  THE THEOREM.
------------------------------------------------------------------------

module Gersgorin_ADiagonallyDominantMatrixWithNonnegativeDiagonalHasANonnegativeQuadraticFormSoASlackTermInACertificateIsAbsorbedRowByRow where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat using (discreteℕ ; +-suc)
open import Cubical.Data.Nat.Order using (≤-refl ; ≤-suc ; ≤-trans ; ¬-<-zero ; pred-≤-pred) renaming (_<_ to _<ℕ_ ; _≤_ to _≤ℕ_)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
open import Cubical.Relation.Nullary using (¬_ ; yes ; no)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

module Sama (R : CommRing ℓ-zero) where
  open CommRingStr (snd R)
  -- |e| = e:   e (a² + b²) + 2 a e b = e (a + b)²
  dhana-varga : (e a b : ⟨ R ⟩) → e · (a · a + b · b) + (1r + 1r) · ((a · e) · b) ≡ e · ((a + b) · (a + b))
  dhana-varga e a b = solve! R
  -- |e| = −e:  (−e)(a² + b²) + 2 a e b = (−e)(a − b)²
  ṛṇa-varga : (e a b : ⟨ R ⟩) → (- e) · (a · a + b · b) + (1r + 1r) · ((a · e) · b) ≡ (- e) · ((a - b) · (a - b))
  ṛṇa-varga e a b = solve! R
  -- 2 x = (m + 2x) − m
  dvi : (x m : ⟨ R ⟩) → (1r + 1r) · x ≡ (m + (1r + 1r) · x) - m
  dvi x m = solve! R
  -- m (a² + b²) = m a² + m b²
  vibhāga : (m a b : ⟨ R ⟩) → m · (a · a + b · b) ≡ m · (a · a) + m · (b · b)
  vibhāga m a b = solve! R
  -- the diagonal term: e (a² + a²) + 2 a e a = 4 e a²
  catur : (e a : ⟨ R ⟩) → e · (a · a + a · a) + (1r + 1r) · ((a · e) · a) ≡ (1r + 1r + 1r + 1r) · e · (a · a)
  catur e a = solve! R

module Sama′ (R : CommRing ℓ-zero) where
  open CommRingStr (snd R)
  lemma′ : (x p y : ⟨ R ⟩) → x · p - p · y ≡ p · (x - y)
  lemma′ x p y = solve! R

open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order
  using (_≤_ ; _<_ ; isRefl≤ ; isTrans≤ ; <Weaken≤ ; ≤-+o ; ≤-o+ ; ≤-·o ; _≟_ ; lt ; eq ; gt)

open import ParimeyaRupa_TheRationalsWithTheTrivialInvolutionFormAStarRingWithAHalfAndNonnegativityExcludesMinusTwoSoTheFiniteWeilCriterionAndTheKreinSplittingHoldOverQ
  using (ℚRing ; anṛṇa-varga ; anṛṇa-yoga ; ṛṇa-viparīta)
open import Vrddhi_AModeOfRatioAboveOneGrowsPastEveryBoundAndAModeOfRatioAtMostOneStaysBoundedSoTheFiniteGrowthTheoremReadsTheDominantRatio
  using (anṛṇa-guṇa)
open import Nirapeksa_TheAbsoluteValueOnTheRationalsIsTheMaximumOfAnElementAndItsNegativeSoItIsNonnegativeDominatesBothAndIsSubadditive
  using (∣_∣ ; dhana-sama ; ṛṇa-sama ; anṛṇa)
open import VrddhiSima_ADiscreteGronwallWithASummableWeightClosesWithoutExponentialsSoTheTypeIEnergyBoundIsScaleInvariantAsATerm
  using (Σ⟨_⟩ ; Σ-guṇa)
open import DvandvaVarga_TheSquareOfTheInnerProductPlusTheSumOfPairSquaresIsTheProductOfNormsSoCauchySchwarzHoldsOverQAndTheResolvedDualityOfTheAdjointReceiverIsAttainedAtTheVectorItself
  using (Σ-ext ; Σ-add ; Σ-sub ; Σ-anṛṇa)
import Pramanika_AnExactRationalLDLTFactorisationCertifiesThatAQuadraticFormIsNonnegativeSoAPositivityCertificateIsACheckableTerm
  as P

------------------------------------------------------------------------
-- १ · T_ij = |e|(a² + b²) + 2 a e b is nonnegative.
------------------------------------------------------------------------

T : ℚ → ℚ → ℚ → ℚ
T e a b = (∣ e ∣) · (a · a + b · b) + (1 + 1) · ((a · e) · b)

T-anṛṇa : (e a b : ℚ) → 0 ≤ T e a b
T-anṛṇa e a b with e ≟ 0
... | lt e<0 = subst (0 ≤_) (sym (cong (λ z → z · (a · a + b · b) + (1 + 1) · ((a · e) · b)) (ṛṇa-sama e (<Weaken≤ e 0 e<0)) ∙ Sama.ṛṇa-varga ℚRing e a b))
                 (anṛṇa-guṇa (- e) ((a - b) · (a - b)) (<Weaken≤ 0 (- e) (ṛṇa-viparīta e e<0)) (anṛṇa-varga (a - b)))
... | eq p   = subst (0 ≤_) (sym (cong (λ z → z · (a · a + b · b) + (1 + 1) · ((a · e) · b)) (dhana-sama e (subst (0 ≤_) (sym p) (isRefl≤ 0))) ∙ Sama.dhana-varga ℚRing e a b))
                 (anṛṇa-guṇa e ((a + b) · (a + b)) (subst (0 ≤_) (sym p) (isRefl≤ 0)) (anṛṇa-varga (a + b)))
... | gt 0<e = subst (0 ≤_) (sym (cong (λ z → z · (a · a + b · b) + (1 + 1) · ((a · e) · b)) (dhana-sama e (<Weaken≤ 0 e 0<e)) ∙ Sama.dhana-varga ℚRing e a b))
                 (anṛṇa-guṇa e ((a + b) · (a + b)) (<Weaken≤ 0 e 0<e) (anṛṇa-varga (a + b)))

------------------------------------------------------------------------
-- २ · The decomposition of 2 vᵀEv, and the diagonal below the double sum.
------------------------------------------------------------------------

-- term ≤ sum, for nonnegative terms (range form)
pada-≤ : (f : ℕ → ℚ) → ((j : ℕ) → 0 ≤ f j) → (i n : ℕ) → i <ℕ n → f i ≤ Σ⟨ n ⟩ f
pada-≤ f 0≤f i zero    i<0 = ⊥-elim (¬-<-zero i<0)
pada-≤ f 0≤f i (suc n) i<sn with discreteℕ i n
... | yes p = subst (λ z → f z ≤ Σ⟨ n ⟩ f + f n) (sym p)
        (subst (_≤ Σ⟨ n ⟩ f + f n) (+IdL (f n)) (≤-+o 0 (Σ⟨ n ⟩ f) (f n) (Σ-anṛṇa f 0≤f n)))
... | no ¬p = isTrans≤ (f i) (Σ⟨ n ⟩ f) (Σ⟨ n ⟩ f + f n)
        (pada-≤ f 0≤f i n (suc-le i n i<sn ¬p))
        (subst (_≤ Σ⟨ n ⟩ f + f n) (+IdR (Σ⟨ n ⟩ f)) (≤-o+ 0 (f n) (Σ⟨ n ⟩ f) (0≤f n)))
  where
  suc-le : (i n : ℕ) → i <ℕ suc n → ¬ (i ≡ n) → i <ℕ n
  suc-le i n i<sn′ ne with pred-≤-pred i<sn′
  ... | (zero  , q) = ⊥-elim (ne q)
  ... | (suc k , q) = k , (+-suc k i ∙ q)

Σ-anṛṇa< : (f : ℕ → ℚ) (k : ℕ) → ((i : ℕ) → i <ℕ k → 0 ≤ f i) → 0 ≤ Σ⟨ k ⟩ f
Σ-anṛṇa< f zero    _   = isRefl≤ 0
Σ-anṛṇa< f (suc k) 0≤f = anṛṇa-yoga {Σ⟨ k ⟩ f} {f k} (Σ-anṛṇa< f k (λ i lt → 0≤f i (≤-suc lt))) (0≤f k ≤-refl)

module _ (n : ℕ) (E : ℕ → ℕ → ℚ) where

  Q : (ℕ → ℚ) → ℚ
  Q v = Σ⟨ n ⟩ (λ i → Σ⟨ n ⟩ (λ j → (v i · E i j) · v j))

  -- row and column absolute sums (full, including the diagonal)
  R C : ℕ → ℚ
  R i = Σ⟨ n ⟩ (λ j → ∣ E i j ∣)
  C j = Σ⟨ n ⟩ (λ i → ∣ E i j ∣)

  -- 2 vᵀEv = Σ_i Σ_j T_ij − ( Σ_i v_i² R_i + Σ_j v_j² C_j )
  vibhāga : (v : ℕ → ℚ)
          → (1 + 1) · Q v ≡ Σ⟨ n ⟩ (λ i → Σ⟨ n ⟩ (λ j → T (E i j) (v i) (v j)))
                              - (Σ⟨ n ⟩ (λ i → (v i · v i) · R i) + Σ⟨ n ⟩ (λ j → (v j · v j) · C j))
  vibhāga v =
      sym (Σ-guṇa (1 + 1) _ n)
    ∙ Σ-ext _ _ n (λ i → sym (Σ-guṇa (1 + 1) _ n)
                       ∙ Σ-ext _ _ n (λ j → Sama.dvi ℚRing ((v i · E i j) · v j) ((∣ E i j ∣) · (v i · v i + v j · v j)))
                       ∙ Σ-sub _ _ n)
    ∙ Σ-sub _ _ n
    ∙ cong (λ z → Σ⟨ n ⟩ (λ i → Σ⟨ n ⟩ (λ j → T (E i j) (v i) (v j))) - z)
        (Σ-ext _ _ n (λ i → Σ-ext _ _ n (λ j → Sama.vibhāga ℚRing (∣ E i j ∣) (v i) (v j)) ∙ Σ-add _ _ n)
        ∙ Σ-add _ _ n
        ∙ cong₂ _+_ (Σ-ext _ _ n (λ i → Σ-ext _ _ n (λ j → ·Comm (∣ E i j ∣) (v i · v i)) ∙ Σ-guṇa (v i · v i) _ n))
                    (P.Σ-swap n n (λ i j → (∣ E i j ∣) · (v j · v j))
                     ∙ Σ-ext _ _ n (λ j → Σ-ext _ _ n (λ i → ·Comm (∣ E i j ∣) (v j · v j)) ∙ Σ-guṇa (v j · v j) _ n)))

  -- the diagonal sits below the double sum of nonnegative terms
  karṇa-≤ : (v : ℕ → ℚ) → Σ⟨ n ⟩ (λ i → T (E i i) (v i) (v i)) ≤ Σ⟨ n ⟩ (λ i → Σ⟨ n ⟩ (λ j → T (E i j) (v i) (v j)))
  karṇa-≤ v = Σ-mono′ n ≤-refl
    where
    karṇa pūrṇa : ℕ → ℚ
    karṇa i = T (E i i) (v i) (v i)
    pūrṇa i = Σ⟨ n ⟩ (λ j → T (E i j) (v i) (v j))
    Σ-mono′ : (k : ℕ) → k ≤ℕ n → Σ⟨ k ⟩ karṇa ≤ Σ⟨ k ⟩ pūrṇa
    Σ-mono′ zero    _  = isRefl≤ 0
    Σ-mono′ (suc k) le =
      isTrans≤ (Σ⟨ k ⟩ karṇa + karṇa k) (Σ⟨ k ⟩ pūrṇa + karṇa k) (Σ⟨ k ⟩ pūrṇa + pūrṇa k)
        (≤-+o (Σ⟨ k ⟩ karṇa) (Σ⟨ k ⟩ pūrṇa) (karṇa k) (Σ-mono′ k (≤-trans (≤-suc ≤-refl) le)))
        (≤-o+ (karṇa k) (pūrṇa k) (Σ⟨ k ⟩ pūrṇa)
          (pada-≤ (λ j → T (E k j) (v k) (v j)) (λ j → T-anṛṇa (E k j) (v k) (v j)) k n le))

  ----------------------------------------------------------------------
  -- ३ · The theorem: 4 E_ii ≥ R_i + C_i for all i < n ⇒ vᵀEv ≥ 0.
  ----------------------------------------------------------------------

  Prabhutva : Type₀
  Prabhutva = (i : ℕ) → i <ℕ n → R i + C i ≤ (1 + 1 + 1 + 1) · E i i

  0<4 : 0 < (1 + 1 + 1 + 1)
  0<4 = 3 , refl

  karṇa-anṛṇa : Prabhutva → (i : ℕ) → i <ℕ n → 0 ≤ E i i
  karṇa-anṛṇa dom i i<n = P.guṇa-anṛṇa (1 + 1 + 1 + 1) (E i i) 0<4
    (isTrans≤ 0 (R i + C i) ((1 + 1 + 1 + 1) · E i i)
      (anṛṇa-yoga {R i} {C i} (Σ-anṛṇa _ (λ j → anṛṇa (E i j)) n) (Σ-anṛṇa _ (λ j → anṛṇa (E j i)) n))
      (dom i i<n))

  gersgorin : Prabhutva → (v : ℕ → ℚ) → 0 ≤ Q v
  gersgorin dom v = P.guṇa-anṛṇa (1 + 1) (Q v) (1 , refl) dvi-anṛṇa
    where
    S : ℚ
    S = Σ⟨ n ⟩ (λ i → (v i · v i) · R i) + Σ⟨ n ⟩ (λ j → (v j · v j) · C j)
    S-sama : S ≡ Σ⟨ n ⟩ (λ i → (v i · v i) · (R i + C i))
    S-sama = sym (Σ-add _ _ n) ∙ Σ-ext _ _ n (λ i → sym (·DistL+ (v i · v i) (R i) (C i)))
    -- the diagonal sum minus S is termwise nonnegative
    śeṣa-anṛṇa : 0 ≤ Σ⟨ n ⟩ (λ i → T (E i i) (v i) (v i)) - S
    śeṣa-anṛṇa = subst (0 ≤_)
      (sym (cong (λ z → Σ⟨ n ⟩ (λ i → T (E i i) (v i) (v i)) - z) S-sama ∙ sym (Σ-sub _ _ n)))
      (Σ-anṛṇa< _ n (λ i i<n → pada i i<n))
      where
      pada : (i : ℕ) → i <ℕ n → 0 ≤ T (E i i) (v i) (v i) - ((v i · v i) · (R i + C i))
      pada i i<n = subst (0 ≤_) (sym (cong (λ z → z - ((v i · v i) · (R i + C i))) T-sama ∙ lemma))
                     (anṛṇa-guṇa (v i · v i) (((1 + 1 + 1 + 1) · E i i) - (R i + C i)) (anṛṇa-varga (v i)) gap)
        where
        T-sama : T (E i i) (v i) (v i) ≡ (1 + 1 + 1 + 1) · E i i · (v i · v i)
        T-sama = cong (λ z → z · (v i · v i + v i · v i) + (1 + 1) · ((v i · E i i) · v i)) (dhana-sama (E i i) (karṇa-anṛṇa dom i i<n))
               ∙ Sama.catur ℚRing (E i i) (v i)
        lemma : ((1 + 1 + 1 + 1) · E i i · (v i · v i)) - ((v i · v i) · (R i + C i)) ≡ (v i · v i) · (((1 + 1 + 1 + 1) · E i i) - (R i + C i))
        lemma = Sama′.lemma′ ℚRing ((1 + 1 + 1 + 1) · E i i) (v i · v i) (R i + C i)
        gap : 0 ≤ ((1 + 1 + 1 + 1) · E i i) - (R i + C i)
        gap = subst (_≤ ((1 + 1 + 1 + 1) · E i i) - (R i + C i)) (+InvR (R i + C i)) (≤-+o (R i + C i) ((1 + 1 + 1 + 1) · E i i) (- (R i + C i)) (dom i i<n))
    -- 2Q = ΣΣT − S ≥ ΣT_ii − S ≥ 0
    dvi-anṛṇa : 0 ≤ (1 + 1) · Q v
    dvi-anṛṇa = subst (0 ≤_) (sym (vibhāga v))
      (isTrans≤ 0 (Σ⟨ n ⟩ (λ i → T (E i i) (v i) (v i)) - S) (Σ⟨ n ⟩ (λ i → Σ⟨ n ⟩ (λ j → T (E i j) (v i) (v j))) - S)
        śeṣa-anṛṇa
        (≤-+o (Σ⟨ n ⟩ (λ i → T (E i i) (v i) (v i))) (Σ⟨ n ⟩ (λ i → Σ⟨ n ⟩ (λ j → T (E i j) (v i) (v j)))) (- S) (karṇa-≤ v)))
