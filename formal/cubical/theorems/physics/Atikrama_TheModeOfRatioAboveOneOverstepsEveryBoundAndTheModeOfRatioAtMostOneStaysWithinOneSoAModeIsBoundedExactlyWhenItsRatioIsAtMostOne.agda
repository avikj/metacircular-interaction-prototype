{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अतिक्रम — overstepping.
--
-- The proof note's growth theorem, limsup log(1+|B|)/t = Θ − ½ and hence
-- RH ⇔ B = O(1), reads at the level of one mode: e^{(ρ−½)t} is bounded
-- exactly when Re ρ ≤ ½.  Over ℚ, with the mode t ↦ m^t, m ≥ 0:
--
--   §1  RATIO ABOVE ONE OVERSTEPS EVERY BOUND: for m > 1 and any K there
--       merely exists t with K < m^t — Bernoulli (Vrddhi) on top of
--       Archimedes (Parimana).
--   §2  RATIO AT MOST ONE STAYS WITHIN [0, 1].
--   §3  THE CRITERION: a mode is bounded ⇔ its ratio is at most one.
--       The ⇒ direction is by trichotomy and §1; the truncation is
--       eliminated into ⊥.
--
-- अतिक्रम (atikrama, overstepping/transgression) is ordinary Sanskrit.
------------------------------------------------------------------------

module Atikrama_TheModeOfRatioAboveOneOverstepsEveryBoundAndTheModeOfRatioAtMostOneStaysWithinOneSoAModeIsBoundedExactlyWhenItsRatioIsAtMostOne where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim ; isProp⊥ to isProp⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver
open import Cubical.HITs.PropositionalTruncation as PT using (∥_∥₁ ; ∣_∣₁)

module Sama (R : CommRing ℓ-zero) where
  open CommRingStr (snd R)
  eka-śeṣa : (m : ⟨ R ⟩) → 1r + (m - 1r) ≡ m
  eka-śeṣa m = solve! R
  śeṣa-eka : (K : ⟨ R ⟩) → (K - 1r) + 1r ≡ K
  śeṣa-eka K = solve! R

open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order
  using (_≤_ ; _<_ ; isRefl≤ ; isTrans≤ ; <Weaken≤ ; ≤-·o ; <-+o ; isTrans<≤ ; _≟_ ; lt ; eq ; gt ; ≤→≯)

open import ParimeyaRupa_TheRationalsWithTheTrivialInvolutionFormAStarRingWithAHalfAndNonnegativityExcludesMinusTwoSoTheFiniteWeilCriterionAndTheKreinSplittingHoldOverQ
  using (ℚRing)
open import Vrddhi_AModeOfRatioAboveOneGrowsPastEveryBoundAndAModeOfRatioAtMostOneStaysBoundedSoTheFiniteGrowthTheoremReadsTheDominantRatio
  using (ι ; _^_ ; bernoulli ; anṛṇa-guṇa)
open import Parimana_EveryRationalLiesBelowANaturalAndEveryPositiveRationalHasANaturalMultipleAtLeastOneSoTheRationalsAreArchimedean
  using (archimedes)

------------------------------------------------------------------------
-- १ · Ratio above one oversteps every bound.
------------------------------------------------------------------------

atikrama : (m : ℚ) → 1 < m → (K : ℚ) → ∥ Σ[ t ∈ ℕ ] K < m ^ t ∥₁
atikrama m 1<m K = PT.map go (archimedes x 0<x (K - 1))
  where
  x : ℚ
  x = m - 1
  0<x : 0 < x
  0<x = subst (_< m - 1) (+InvR 1) (<-+o 1 m (- 1) 1<m)
  0≤x : 0 ≤ x
  0≤x = <Weaken≤ 0 x 0<x
  go : Σ[ t ∈ ℕ ] (K - 1) < ι t · x → Σ[ t ∈ ℕ ] K < m ^ t
  go (t , lt′) = t , isTrans<≤ K (1 + ι t · x) (m ^ t) K<1+tx
                        (subst (λ z → 1 + ι t · x ≤ z ^ t) (Sama.eka-śeṣa ℚRing m) (bernoulli x 0≤x t))
    where
    K<1+tx : K < 1 + ι t · x
    K<1+tx = subst2 _<_ (Sama.śeṣa-eka ℚRing K) (+Comm (ι t · x) 1) (<-+o (K - 1) (ι t · x) 1 lt′)

------------------------------------------------------------------------
-- २ · Ratio at most one stays within [0, 1].
------------------------------------------------------------------------

0≤1 : 0 ≤ 1
0≤1 = <Weaken≤ 0 1 (0 , refl)

antar : (m : ℚ) → 0 ≤ m → m ≤ 1 → (t : ℕ) → (0 ≤ m ^ t) × (m ^ t ≤ 1)
antar m 0≤m m≤1 zero    = 0≤1 , isRefl≤ 1
antar m 0≤m m≤1 (suc t) =
  anṛṇa-guṇa m (m ^ t) 0≤m (fst ih) ,
  isTrans≤ (m · m ^ t) (m · 1) 1
    (subst2 _≤_ (·Comm (m ^ t) m) (·Comm 1 m) (≤-·o (m ^ t) 1 m 0≤m (snd ih)))
    (subst (_≤ 1) (sym (·IdR m)) m≤1)
  where ih = antar m 0≤m m≤1 t

------------------------------------------------------------------------
-- ३ · The criterion: bounded ⇔ ratio at most one.
------------------------------------------------------------------------

Sīmita : ℚ → Type₀
Sīmita m = Σ[ K ∈ ℚ ] ((t : ℕ) → m ^ t ≤ K)

sīmita→eka : (m : ℚ) → Sīmita m → m ≤ 1
sīmita→eka m (K , bd) with m ≟ 1
... | lt m<1 = <Weaken≤ m 1 m<1
... | eq p   = subst (m ≤_) p (isRefl≤ m)
... | gt 1<m = ⊥-elim (PT.rec isProp⊥ (λ { (t , K<mt) → ≤→≯ (m ^ t) K (bd t) K<mt }) (atikrama m 1<m K))

eka→sīmita : (m : ℚ) → 0 ≤ m → m ≤ 1 → Sīmita m
eka→sīmita m 0≤m m≤1 = 1 , λ t → snd (antar m 0≤m m≤1 t)

-- the growth theorem at one mode: bounded exactly when the ratio is ≤ 1
vṛddhi : (m : ℚ) → 0 ≤ m → (Sīmita m → m ≤ 1) × (m ≤ 1 → Sīmita m)
vṛddhi m 0≤m = sīmita→eka m , eka→sīmita m 0≤m
