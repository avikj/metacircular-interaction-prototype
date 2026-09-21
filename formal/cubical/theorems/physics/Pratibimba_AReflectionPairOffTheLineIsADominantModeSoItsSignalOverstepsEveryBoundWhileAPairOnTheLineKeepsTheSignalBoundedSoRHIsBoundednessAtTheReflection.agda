{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रतिबिम्ब — the reflection pair.
--
-- TauRupa's transport law E i · E (τ i) = 1 pairs each mode with its
-- reflection.  Over the positive rationals the pair is (m, m′) with
-- m · m′ = 1; the pair is ON the line exactly when m = m′ = 1, and OFF
-- it when one of them exceeds one.  The proof note's RH ⇔ B = O(1) at
-- one reflection pair:
--
--   §1  IF m > 1 THEN m′ ≤ 1: the partner of a large mode is small.
--   §2  OFF THE LINE ⇒ UNBOUNDED: with any nonzero weight on m, the
--       signal c m^t + c′ m′^t oversteps every bound (Prabala, with the
--       tail ratio m′ ≤ 1 < m).
--   §3  ON THE LINE ⇒ BOUNDED: with m = m′ = 1 the signal is at most
--       |c| + |c′| (Prabala §5).
--
-- प्रतिबिम्ब (pratibimba, reflection/mirror image) is ordinary Sanskrit.
------------------------------------------------------------------------

module Pratibimba_AReflectionPairOffTheLineIsADominantModeSoItsSignalOverstepsEveryBoundWhileAPairOnTheLineKeepsTheSignalBoundedSoRHIsBoundednessAtTheReflection where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order using (¬-<-zero ; ≤-refl) renaming (_<_ to _<ℕ_)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
open import Cubical.HITs.PropositionalTruncation using (∥_∥₁)

open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order
  using (_≤_ ; _<_ ; isRefl≤ ; isTrans≤ ; <Weaken≤ ; <-·o ; isIrrefl< ; _≟_ ; lt ; eq ; gt ; isTrans<≤ ; ≤→≯)

open import Nirapeksa_TheAbsoluteValueOnTheRationalsIsTheMaximumOfAnElementAndItsNegativeSoItIsNonnegativeDominatesBothAndIsSubadditive
  using (∣_∣)
open import Vrddhi_AModeOfRatioAboveOneGrowsPastEveryBoundAndAModeOfRatioAtMostOneStaysBoundedSoTheFiniteGrowthTheoremReadsTheDominantRatio
  using (_^_)
open import Prabala_TheDominantModeWinsSoASignedSumOfModesWithADominantRatioAboveOneOverstepsEveryBoundAndTheGrowthRateIsTheDominantRatio
  using (module Prabala ; module Sīmita ; module Tail ; 0≤1′)

------------------------------------------------------------------------
-- १ · The partner of a large mode is small.
------------------------------------------------------------------------

saṅgī-laghu : (m m′ : ℚ) → 0 ≤ m′ → m · m′ ≡ 1 → 1 < m → m′ ≤ 1
saṅgī-laghu m m′ 0≤m′ law 1<m with m′ ≟ 1
... | lt m′<1 = <Weaken≤ m′ 1 m′<1
... | eq p    = subst (m′ ≤_) p (isRefl≤ m′)
... | gt 1<m′ = ⊥-elim (isIrrefl< 1 (subst (1 <_) law
                  (isTrans<≤ 1 m (m · m′) 1<m (subst (_≤ m · m′) (·IdR m) (≤-·o′ 1 m′ 1<m′)))))
  where
  -- m · 1 ≤ m · m′ for 1 ≤ m′, m ≥ 0
  ≤-·o′ : (b c : ℚ) → b < c → m · b ≤ m · c
  ≤-·o′ b c b<c = subst2 _≤_ (·Comm b m) (·Comm c m)
    (Cubical.Data.Rationals.Order.≤-·o b c m (<Weaken≤ 0 m (isTrans<≤ 0 1 m (zero , refl) (<Weaken≤ 1 m 1<m))) (<Weaken≤ b c b<c))

------------------------------------------------------------------------
-- २ · Off the line: the pair's signal oversteps every bound.
------------------------------------------------------------------------

module _ (m m′ c c′ : ℚ) (0≤m′ : 0 ≤ m′) (law : m · m′ ≡ 1) (0<∣c∣ : 0 < ∣ c ∣) where

  -- the configuration: mode 0 is m with weight c, mode 1 is m′ with weight c′
  yugma-m : ℕ → ℚ
  yugma-m zero    = m
  yugma-m (suc _) = m′

  yugma-c : ℕ → ℚ
  yugma-c zero    = c
  yugma-c (suc _) = c′

  -- the signal c m^t + c′ m′^t
  yugma-B : ℕ → ℚ
  yugma-B t = c · (m ^ t) + (c′ · (m′ ^ t) + 0)

  module _ (1<m : 1 < m) where
    0≤m : (i : ℕ) → 0 ≤ yugma-m i
    0≤m zero    = <Weaken≤ 0 m (isTrans<≤ 0 1 m (zero , refl) (<Weaken≤ 1 m 1<m))
    0≤m (suc _) = 0≤m′

    pucchā-≤1 : (i : ℕ) → i <ℕ 1 → yugma-m (suc i) ≤ 1
    pucchā-≤1 _ _ = saṅgī-laghu m m′ 0≤m′ law 1<m

    open Prabala 1 yugma-c yugma-m 1 (isRefl≤ 1) 1<m 0≤m pucchā-≤1 0<∣c∣

    -- B as Prabala builds it is the pair's signal
    B-sama : (t : ℕ) → B t ≡ yugma-B t
    B-sama t = cong (c · (m ^ t) +_) (+Comm 0 (c′ · (m′ ^ t)))

    pratibimba-atikrama : (K : ℚ) → ∥ Σ[ t ∈ ℕ ] K < ∣ yugma-B t ∣ ∥₁
    pratibimba-atikrama K = subst (λ f → ∥ Σ[ t ∈ ℕ ] K < ∣ f t ∣ ∥₁) (funExt B-sama) (prabala K)

------------------------------------------------------------------------
-- ३ · On the line: the pair's signal is bounded by |c| + |c′|.
------------------------------------------------------------------------

module _ (c c′ : ℚ) where

  rekhā-m : ℕ → ℚ
  rekhā-m _ = 1

  rekhā-c : ℕ → ℚ
  rekhā-c zero    = c
  rekhā-c (suc _) = c′

  open Tail 2 rekhā-c rekhā-m 1 0≤1′ (λ _ → 0≤1′) (λ _ _ → isRefl≤ 1)

  rekhā-sīmita : (t : ℕ) → ∣ T t ∣ ≤ C
  rekhā-sīmita = Sīmita.sīmita 2 rekhā-c rekhā-m (λ _ → 0≤1′) (λ _ _ → isRefl≤ 1)
