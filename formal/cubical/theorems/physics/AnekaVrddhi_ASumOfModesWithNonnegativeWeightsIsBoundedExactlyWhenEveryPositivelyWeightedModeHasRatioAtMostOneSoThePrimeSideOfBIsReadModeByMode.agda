{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अनेक-वृद्धि — growth of many.
--
-- B(t) = Σ Λ(n)/√n · h(t − log n) − e^{t/2} H(½): the prime side of the
-- proof note's signal carries POSITIVE weights Λ(n)/√n.  Atikrama read
-- one mode; this file reads a finite positively weighted sum of modes
-- B(t) = Σ_{i<n} c_i m_i^t with c_i ≥ 0, m_i ≥ 0:
--
--   §1  A TERM IS AT MOST THE SUM when every term is nonnegative.
--   §2  BOUNDED ⇒ EVERY POSITIVELY WEIGHTED MODE HAS RATIO ≤ 1: if some
--       c_i > 0 had m_i > 1, Archimedes supplies q with 1 ≤ q c_i, and
--       Atikrama a t with q K < m_i^t, so c_i m_i^t > K — cancelling the
--       positive q — against the bound.
--   §3  EVERY POSITIVELY WEIGHTED MODE HAS RATIO ≤ 1 ⇒ BOUNDED by Σ c_i.
--   §4  THE CRITERION, both directions.
--
-- अनेक (aneka, many) is ordinary Sanskrit.
------------------------------------------------------------------------

module AnekaVrddhi_ASumOfModesWithNonnegativeWeightsIsBoundedExactlyWhenEveryPositivelyWeightedModeHasRatioAtMostOneSoThePrimeSideOfBIsReadModeByMode where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; discreteℕ ; +-suc)
open import Cubical.Data.Nat.Order using (pred-≤-pred ; <-weaken) renaming (_<_ to _<ℕ_ ; _≤_ to _≤ℕ_)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim ; isProp⊥ to isProp⊥)
open import Cubical.Relation.Nullary using (¬_ ; yes ; no)
open import Cubical.HITs.PropositionalTruncation as PT using (∥_∥₁ ; ∣_∣₁)

open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order
  using (_≤_ ; _<_ ; isRefl≤ ; isTrans≤ ; <Weaken≤ ; ≤-·o ; <-·o ; ≤-+o ; ≤-o+ ; isTrans<≤ ; isTrans≤<
        ; <-·o-cancel ; <-+o ; _≟_ ; lt ; eq ; gt ; ≤→≯)

open import ParimeyaRupa_TheRationalsWithTheTrivialInvolutionFormAStarRingWithAHalfAndNonnegativityExcludesMinusTwoSoTheFiniteWeilCriterionAndTheKreinSplittingHoldOverQ
  using (anṛṇa-yoga)
open import Vrddhi_AModeOfRatioAboveOneGrowsPastEveryBoundAndAModeOfRatioAtMostOneStaysBoundedSoTheFiniteGrowthTheoremReadsTheDominantRatio
  using (ι ; _^_ ; anṛṇa-guṇa ; ι-anṛṇa)
open import Parimana_EveryRationalLiesBelowANaturalAndEveryPositiveRationalHasANaturalMultipleAtLeastOneSoTheRationalsAreArchimedean
  using (guṇaka)
open import Atikrama_TheModeOfRatioAboveOneOverstepsEveryBoundAndTheModeOfRatioAtMostOneStaysWithinOneSoAModeIsBoundedExactlyWhenItsRatioIsAtMostOne
  using (atikrama ; antar ; 0≤1)
open import VrddhiSima_ADiscreteGronwallWithASummableWeightClosesWithoutExponentialsSoTheTypeIEnergyBoundIsScaleInvariantAsATerm
  using (Σ⟨_⟩ ; ≤-yoga)

------------------------------------------------------------------------
-- १ · A term is at most the sum, for nonnegative terms.
------------------------------------------------------------------------

Σ-anṛṇa : (f : ℕ → ℚ) → ((i : ℕ) → 0 ≤ f i) → (n : ℕ) → 0 ≤ Σ⟨ n ⟩ f
Σ-anṛṇa f 0≤f zero    = isRefl≤ 0
Σ-anṛṇa f 0≤f (suc n) = anṛṇa-yoga {Σ⟨ n ⟩ f} {f n} (Σ-anṛṇa f 0≤f n) (0≤f n)

-- i < suc n and i ≢ n give i < n
suc-le : (i n : ℕ) → i <ℕ suc n → ¬ (i ≡ n) → i <ℕ n
suc-le i n i<sn ne with pred-≤-pred i<sn
... | (zero  , e) = ⊥-elim (ne e)
... | (suc k , e) = k , (+-suc k i ∙ e)

pada-≤ : (f : ℕ → ℚ) → ((i : ℕ) → 0 ≤ f i) → (i n : ℕ) → i <ℕ n → f i ≤ Σ⟨ n ⟩ f
pada-≤ f 0≤f i zero    i<0 = ⊥-elim (Cubical.Data.Nat.Order.¬-<-zero i<0)
pada-≤ f 0≤f i (suc n) i<sn with discreteℕ i n
... | yes p = subst (λ z → f z ≤ Σ⟨ n ⟩ f + f n) (sym p)
                (subst (_≤ Σ⟨ n ⟩ f + f n) (+IdL (f n)) (≤-+o 0 (Σ⟨ n ⟩ f) (f n) (Σ-anṛṇa f 0≤f n)))
... | no ¬p = ≤-yoga (f i) (Σ⟨ n ⟩ f) (f n) (pada-≤ f 0≤f i n (suc-le i n i<sn ¬p)) (0≤f n)

------------------------------------------------------------------------
-- The signal.
------------------------------------------------------------------------

module _ (n : ℕ) (c m : ℕ → ℚ) (0≤c : (i : ℕ) → 0 ≤ c i) (0≤m : (i : ℕ) → 0 ≤ m i) where

  B : ℕ → ℚ
  B t = Σ⟨ n ⟩ (λ i → c i · (m i ^ t))

  -- powers of a nonnegative are nonnegative
  anṛṇa-ghāta : (i t : ℕ) → 0 ≤ m i ^ t
  anṛṇa-ghāta i zero    = 0≤1
  anṛṇa-ghāta i (suc t) = anṛṇa-guṇa (m i) (m i ^ t) (0≤m i) (anṛṇa-ghāta i t)

  pada-anṛṇa : (t i : ℕ) → 0 ≤ c i · (m i ^ t)
  pada-anṛṇa t i = anṛṇa-guṇa (c i) (m i ^ t) (0≤c i) (anṛṇa-ghāta i t)

  Sīmita : Type₀
  Sīmita = Σ[ K ∈ ℚ ] ((t : ℕ) → B t ≤ K)

  --------------------------------------------------------------------
  -- २ · Bounded ⇒ every positively weighted mode has ratio ≤ 1.
  --------------------------------------------------------------------

  -- a natural q with 1 ≤ q · c is positive
  dhana-ι : (q : ℕ) (x : ℚ) → 1 ≤ ι q · x → 0 < ι q
  dhana-ι zero    x le = ⊥-elim (≤→≯ 1 0 (subst (1 ≤_) (·AnnihilL x) le) (0 , refl))
  dhana-ι (suc q) x _  = isTrans≤< 0 (ι q) (ι q + 1) (ι-anṛṇa q)
                           (subst2 _<_ (+IdL (ι q)) (+Comm 1 (ι q)) (<-+o 0 1 (ι q) (0 , refl)))

  sīmita→eka : Sīmita → (i : ℕ) → i <ℕ n → 0 < c i → m i ≤ 1
  sīmita→eka (K , bd) i i<n 0<ci with m i ≟ 1
  ... | lt m<1 = <Weaken≤ (m i) 1 m<1
  ... | eq p   = subst (m i ≤_) p (isRefl≤ (m i))
  ... | gt 1<m = ⊥-elim (PT.rec isProp⊥ go (guṇaka (c i) 0<ci))
    where
    go : Σ[ q ∈ ℕ ] 1 ≤ ι q · c i → ⊥
    go (q , 1≤qc) = PT.rec isProp⊥ go′ (atikrama (m i) 1<m (ι q · K))
      where
      0<q : 0 < ι q
      0<q = dhana-ι q (c i) 1≤qc
      go′ : Σ[ t ∈ ℕ ] ι q · K < m i ^ t → ⊥
      go′ (t , qK<mt) = ≤→≯ (c i · (m i ^ t)) K
                          (isTrans≤ (c i · (m i ^ t)) (B t) K (pada-≤ (λ j → c j · (m j ^ t)) (pada-anṛṇa t) i n i<n) (bd t))
                          K<cmt
        where
        -- m^t ≤ (q c) m^t = q (c m^t)
        mt≤ : m i ^ t ≤ ι q · (c i · (m i ^ t))
        mt≤ = subst2 _≤_ (·IdL (m i ^ t)) (sym (·Assoc (ι q) (c i) (m i ^ t)))
                (≤-·o 1 (ι q · c i) (m i ^ t) (anṛṇa-ghāta i t) 1≤qc)
        -- q K < q (c m^t), cancel q
        K<cmt : K < c i · (m i ^ t)
        K<cmt = <-·o-cancel K (c i · (m i ^ t)) (ι q) 0<q
                  (subst2 _<_ (·Comm (ι q) K) (·Comm (ι q) (c i · (m i ^ t)))
                    (isTrans<≤ (ι q · K) (m i ^ t) (ι q · (c i · (m i ^ t))) qK<mt mt≤))

  --------------------------------------------------------------------
  -- ३ · Every positively weighted mode has ratio ≤ 1 ⇒ bounded by Σ c.
  --------------------------------------------------------------------

  Σ-mono : (f g : ℕ → ℚ) (k : ℕ) → ((i : ℕ) → i <ℕ k → f i ≤ g i) → Σ⟨ k ⟩ f ≤ Σ⟨ k ⟩ g
  Σ-mono f g zero    _  = isRefl≤ 0
  Σ-mono f g (suc k) le =
    isTrans≤ (Σ⟨ k ⟩ f + f k) (Σ⟨ k ⟩ g + f k) (Σ⟨ k ⟩ g + g k)
      (≤-+o (Σ⟨ k ⟩ f) (Σ⟨ k ⟩ g) (f k) (Σ-mono f g k (λ i i<k → le i (Cubical.Data.Nat.Order.≤-suc i<k))))
      (≤-o+ (f k) (g k) (Σ⟨ k ⟩ g) (le k Cubical.Data.Nat.Order.≤-refl))

  -- each term is at most its weight
  pada-sīmā : (crit : (i : ℕ) → i <ℕ n → 0 < c i → m i ≤ 1) (t i : ℕ) → i <ℕ n → c i · (m i ^ t) ≤ c i
  pada-sīmā crit t i i<n with c i ≟ 0
  ... | lt c<0 = ⊥-elim (≤→≯ 0 (c i) (0≤c i) c<0)
  ... | eq p   = subst (λ z → z · (m i ^ t) ≤ z) (sym p) (subst (_≤ 0) (sym (·AnnihilL (m i ^ t))) (isRefl≤ 0))
  ... | gt 0<c = subst (c i · (m i ^ t) ≤_) (·IdR (c i))
                   (subst2 _≤_ (·Comm (m i ^ t) (c i)) (·Comm 1 (c i))
                     (≤-·o (m i ^ t) 1 (c i) (0≤c i) (snd (antar (m i) (0≤m i) (crit i i<n 0<c) t))))

  eka→sīmita : ((i : ℕ) → i <ℕ n → 0 < c i → m i ≤ 1) → Sīmita
  eka→sīmita crit = Σ⟨ n ⟩ c , λ t → Σ-mono (λ i → c i · (m i ^ t)) c n (λ i i<n → pada-sīmā crit t i i<n)

  --------------------------------------------------------------------
  -- ४ · The criterion.
  --------------------------------------------------------------------

  aneka-vṛddhi : (Sīmita → (i : ℕ) → i <ℕ n → 0 < c i → m i ≤ 1)
               × (((i : ℕ) → i <ℕ n → 0 < c i → m i ≤ 1) → Sīmita)
  aneka-vṛddhi = sīmita→eka , eka→sīmita
