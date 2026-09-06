{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वृद्धि-सीमा — the growth bound.
--
-- The NS Type I verdict (ORACLE_NS_typeI, Theorem C): under the Type I
-- bound the cubic and pressure terms of the local energy identity become
-- LINEAR in the uniformly-local energy with an integrable weight
-- (T−s)^{−1/2}, and Gronwall closes with a scale-invariant constant.
-- The finite core of that closure is a discrete Gronwall lemma with a
-- summable weight, and it needs no exponential:
--
--   §1  SUMS AND PRODUCTS over [0, n) of rational sequences; the product
--       Π (1 + w_k) is ≥ 1 for nonnegative weights.
--   §2  DISCRETE GRONWALL.  If a_{k+1} ≤ a_k (1 + w_k) + c_k with a, w, c
--       nonnegative, then a_n ≤ (a_0 + Σ_{k<n} c_k) · Π_{k<n} (1 + w_k).
--   §3  THE PRODUCT IS CONTROLLED BY THE SUM, WITHOUT exp:
--       Π (1 + w_k) · (1 − Σ w_k) ≤ 1 whenever Σ w_k ≤ 1.
--   §4  THE CLOSURE.  a_n · (1 − S_n) ≤ a_0 + Σ c_k: when the weights sum
--       to at most ½ this is a_n ≤ 2 (a_0 + Σ c) — a bound independent
--       of n, i.e. of the scale.  This is the exact shape of Theorem C's
--       K(C_*), with the dyadic weight 2^{−k/2} C_* in the role of w.
--
-- सीमा (sīmā, bound/limit) is ordinary Sanskrit.
------------------------------------------------------------------------

module VrddhiSima_ADiscreteGronwallWithASummableWeightClosesWithoutExponentialsSoTheTypeIEnergyBoundIsScaleInvariantAsATerm where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (_,_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

-- ring identities, once, over any commutative ring
module Sama (R : CommRing ℓ-zero) where
  open CommRingStr (snd R)
  ādi     : (a : ⟨ R ⟩) → a ≡ (a + 0r) · 1r
  ādi a = solve! R
  vistāra : (a p c s w : ⟨ R ⟩) → (a + s) · p · (1r + w) + c · (p · (1r + w)) ≡ (a + (s + c)) · (p · (1r + w))
  vistāra a p c s w = solve! R
  dvi     : (p s w : ⟨ R ⟩) → p · (1r + w) · (1r - (s + w)) ≡ p · (1r - s) - p · (w · (s + w))
  dvi p s w = solve! R
  guṇa-eka : (p : ⟨ R ⟩) → 1r · p ≡ p
  guṇa-eka p = solve! R

open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order
  using (_≤_ ; _<_ ; isRefl≤ ; isTrans≤ ; <Weaken≤ ; ≤-+o ; ≤-o+ ; ≤-·o)

open import ParimeyaRupa_TheRationalsWithTheTrivialInvolutionFormAStarRingWithAHalfAndNonnegativityExcludesMinusTwoSoTheFiniteWeilCriterionAndTheKreinSplittingHoldOverQ
  using (ℚRing ; anṛṇa-yoga)
open import Vrddhi_AModeOfRatioAboveOneGrowsPastEveryBoundAndAModeOfRatioAtMostOneStaysBoundedSoTheFiniteGrowthTheoremReadsTheDominantRatio
  using (anṛṇa-guṇa)

------------------------------------------------------------------------
-- १ · Sums and products.
------------------------------------------------------------------------

Σ⟨_⟩ : ℕ → (ℕ → ℚ) → ℚ
Σ⟨ zero ⟩  f = 0
Σ⟨ suc n ⟩ f = Σ⟨ n ⟩ f + f n

-- Π_{k<n} (1 + w k)
Π⟨_⟩ : ℕ → (ℕ → ℚ) → ℚ
Π⟨ zero ⟩  w = 1
Π⟨ suc n ⟩ w = Π⟨ n ⟩ w · (1 + w n)

0≤1 : 0 ≤ 1
0≤1 = <Weaken≤ 0 1 (0 , refl)

-- x ≤ y  ⇒  x ≤ y + z for 0 ≤ z
≤-yoga : (x y z : ℚ) → x ≤ y → 0 ≤ z → x ≤ y + z
≤-yoga x y z le 0≤z = isTrans≤ x y (y + z) le (subst (_≤ y + z) (+IdR y) (≤-o+ 0 z y 0≤z))

-- x − y ≤ x for 0 ≤ y
vyava-≤ : (x y : ℚ) → 0 ≤ y → x - y ≤ x
vyava-≤ x y 0≤y = subst (x - y ≤_) (+IdR x)
  (≤-o+ (- y) 0 x (subst2 _≤_ (+IdL (- y)) (+InvR y) (≤-+o 0 y (- y) 0≤y)))

module _ (w : ℕ → ℚ) (0≤w : (k : ℕ) → 0 ≤ w k) where

  Σ-anṛṇa : (n : ℕ) → 0 ≤ Σ⟨ n ⟩ w
  Σ-anṛṇa zero    = isRefl≤ 0
  Σ-anṛṇa (suc n) = anṛṇa-yoga {Σ⟨ n ⟩ w} {w n} (Σ-anṛṇa n) (0≤w n)

  -- 1 ≤ Π (1 + w)
  Π-eka : (n : ℕ) → 1 ≤ Π⟨ n ⟩ w
  Π-eka zero    = isRefl≤ 1
  Π-eka (suc n) =
    isTrans≤ 1 (Π⟨ n ⟩ w) (Π⟨ n ⟩ w · (1 + w n)) (Π-eka n)
      (subst (_≤ Π⟨ n ⟩ w · (1 + w n)) (·IdR (Π⟨ n ⟩ w))
        (subst2 _≤_ (·Comm 1 (Π⟨ n ⟩ w)) (·Comm (1 + w n) (Π⟨ n ⟩ w))
          (≤-·o 1 (1 + w n) (Π⟨ n ⟩ w) (Π-anṛṇa n) (≤-yoga 1 1 (w n) (isRefl≤ 1) (0≤w n)))))
    where
    Π-anṛṇa : (n : ℕ) → 0 ≤ Π⟨ n ⟩ w
    Π-anṛṇa n = isTrans≤ 0 1 (Π⟨ n ⟩ w) 0≤1 (Π-eka n)

  Π-anṛṇa : (n : ℕ) → 0 ≤ Π⟨ n ⟩ w
  Π-anṛṇa n = isTrans≤ 0 1 (Π⟨ n ⟩ w) 0≤1 (Π-eka n)

  ----------------------------------------------------------------------
  -- २ · Discrete Gronwall.
  ----------------------------------------------------------------------

  module _ (a c : ℕ → ℚ) (0≤c : (k : ℕ) → 0 ≤ c k)
           (pada : (k : ℕ) → a (suc k) ≤ a k · (1 + w k) + c k) where

    gronwall : (n : ℕ) → a n ≤ (a 0 + Σ⟨ n ⟩ c) · Π⟨ n ⟩ w
    gronwall zero    = subst (a 0 ≤_) (Sama.ādi ℚRing (a 0)) (isRefl≤ (a 0))
    gronwall (suc n) =
      isTrans≤ (a (suc n)) (a n · (1 + w n) + c n) _ (pada n)
        (subst (a n · (1 + w n) + c n ≤_) (Sama.vistāra ℚRing (a 0) (Π⟨ n ⟩ w) (c n) (Σ⟨ n ⟩ c) (w n))
          (≤Monotone+ (a n · (1 + w n)) ((a 0 + Σ⟨ n ⟩ c) · Π⟨ n ⟩ w · (1 + w n))
                      (c n) (c n · (Π⟨ n ⟩ w · (1 + w n)))
             (≤-·o (a n) ((a 0 + Σ⟨ n ⟩ c) · Π⟨ n ⟩ w) (1 + w n) (≤-yoga 0 1 (w n) 0≤1 (0≤w n)) (gronwall n))
             (subst (_≤ c n · (Π⟨ n ⟩ w · (1 + w n))) (·IdR (c n))
                (subst2 _≤_ (·Comm 1 (c n)) (·Comm (Π⟨ suc n ⟩ w) (c n))
                   (≤-·o 1 (Π⟨ suc n ⟩ w) (c n) (0≤c n) (Π-eka (suc n)))))))
      where
      ≤Monotone+ : (x y u v : ℚ) → x ≤ y → u ≤ v → x + u ≤ y + v
      ≤Monotone+ x y u v xy uv = isTrans≤ (x + u) (y + u) (y + v) (≤-+o x y u xy) (≤-o+ u v y uv)

  ----------------------------------------------------------------------
  -- ३ · The product is controlled by the sum, without exp.
  ----------------------------------------------------------------------

  saṃhāra : (n : ℕ) → Σ⟨ n ⟩ w ≤ 1 → Π⟨ n ⟩ w · (1 - Σ⟨ n ⟩ w) ≤ 1
  saṃhāra zero    _ = subst (_≤ 1) (sym lemma) (isRefl≤ 1)
    where lemma : 1 · (1 - 0) ≡ 1
          lemma = Sama.guṇa-eka ℚRing (1 - 0) ∙ cong (1 +_) (·AnnihilL (- 1) ∙ refl) ∙ +IdR 1
  saṃhāra (suc n) le =
    isTrans≤ (Π⟨ suc n ⟩ w · (1 - Σ⟨ suc n ⟩ w)) (Π⟨ n ⟩ w · (1 - Σ⟨ n ⟩ w)) 1
      (subst (_≤ Π⟨ n ⟩ w · (1 - Σ⟨ n ⟩ w)) (sym (Sama.dvi ℚRing (Π⟨ n ⟩ w) (Σ⟨ n ⟩ w) (w n)))
        (vyava-≤ (Π⟨ n ⟩ w · (1 - Σ⟨ n ⟩ w)) (Π⟨ n ⟩ w · (w n · (Σ⟨ n ⟩ w + w n)))
          (anṛṇa-guṇa (Π⟨ n ⟩ w) (w n · (Σ⟨ n ⟩ w + w n)) (Π-anṛṇa n)
            (anṛṇa-guṇa (w n) (Σ⟨ n ⟩ w + w n) (0≤w n) (anṛṇa-yoga {Σ⟨ n ⟩ w} {w n} (Σ-anṛṇa n) (0≤w n))))))
      (saṃhāra n (isTrans≤ (Σ⟨ n ⟩ w) (Σ⟨ suc n ⟩ w) 1 (≤-yoga (Σ⟨ n ⟩ w) (Σ⟨ n ⟩ w) (w n) (isRefl≤ (Σ⟨ n ⟩ w)) (0≤w n)) le))

  ----------------------------------------------------------------------
  -- ४ · The closure: a_n (1 − S_n) ≤ a_0 + Σ c, independent of n.
  ----------------------------------------------------------------------

  module _ (a c : ℕ → ℚ) (0≤a : (k : ℕ) → 0 ≤ a k) (0≤c : (k : ℕ) → 0 ≤ c k)
           (pada : (k : ℕ) → a (suc k) ≤ a k · (1 + w k) + c k) where

    Σc-anṛṇa : (n : ℕ) → 0 ≤ Σ⟨ n ⟩ c
    Σc-anṛṇa zero    = isRefl≤ 0
    Σc-anṛṇa (suc n) = anṛṇa-yoga {Σ⟨ n ⟩ c} {c n} (Σc-anṛṇa n) (0≤c n)

    saṃvṛta : (n : ℕ) → Σ⟨ n ⟩ w ≤ 1 → a n · (1 - Σ⟨ n ⟩ w) ≤ a 0 + Σ⟨ n ⟩ c
    saṃvṛta n le =
      isTrans≤ (a n · (1 - Σ⟨ n ⟩ w)) ((a 0 + Σ⟨ n ⟩ c) · Π⟨ n ⟩ w · (1 - Σ⟨ n ⟩ w)) (a 0 + Σ⟨ n ⟩ c)
        (≤-·o (a n) ((a 0 + Σ⟨ n ⟩ c) · Π⟨ n ⟩ w) (1 - Σ⟨ n ⟩ w) 0≤1-S (gronwall a c 0≤c pada n))
        (subst (_≤ a 0 + Σ⟨ n ⟩ c) (·Assoc (a 0 + Σ⟨ n ⟩ c) (Π⟨ n ⟩ w) (1 - Σ⟨ n ⟩ w))
          (subst ((a 0 + Σ⟨ n ⟩ c) · (Π⟨ n ⟩ w · (1 - Σ⟨ n ⟩ w)) ≤_) (·IdR (a 0 + Σ⟨ n ⟩ c))
            (subst2 _≤_ (·Comm _ (a 0 + Σ⟨ n ⟩ c)) (·Comm 1 (a 0 + Σ⟨ n ⟩ c))
              (≤-·o (Π⟨ n ⟩ w · (1 - Σ⟨ n ⟩ w)) 1 (a 0 + Σ⟨ n ⟩ c)
                    (anṛṇa-yoga {a 0} {Σ⟨ n ⟩ c} (0≤a 0) (Σc-anṛṇa n)) (saṃhāra n le)))))
      where
      0≤1-S : 0 ≤ 1 - Σ⟨ n ⟩ w
      0≤1-S = subst2 _≤_ (+InvR (Σ⟨ n ⟩ w)) refl (≤-+o (Σ⟨ n ⟩ w) 1 (- Σ⟨ n ⟩ w) le)
