{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- निरपेक्ष — the absolute.
--
-- The growth theorem with signed weights needs |·| on ℚ, which the
-- library does not define.  Here it is as max(x, −x):
--
--   §1  |x| ≥ 0, x ≤ |x|, −x ≤ |x|, and |−x| = |x|.
--   §2  THE TRIANGLE INEQUALITY |x + y| ≤ |x| + |y|, by bounding both
--       arms of the max.
--   §3  |x| = x for x ≥ 0 and |x| = −x for x ≤ 0.
--
-- निरपेक्ष (nirapekṣa, absolute/independent) is ordinary Sanskrit.
------------------------------------------------------------------------

module Nirapeksa_TheAbsoluteValueOnTheRationalsIsTheMaximumOfAnElementAndItsNegativeSoItIsNonnegativeDominatesBothAndIsSubadditive where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

module Sama (R : CommRing ℓ-zero) where
  open CommRingStr (snd R)
  neg-add : (x y : ⟨ R ⟩) → - (x + y) ≡ (- x) + (- y)
  neg-add x y = solve! R
  neg-neg : (x : ⟨ R ⟩) → - (- x) ≡ x
  neg-neg x = solve! R
  śūnya-neg′ : - 0r ≡ 0r
  śūnya-neg′ = solve! R

open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order
  using (_≤_ ; _<_ ; isRefl≤ ; isTrans≤ ; ≤-+o ; ≤-o+ ; ≤max ; ≤→max ; ≤MonotoneMax ; _≟_ ; lt ; eq ; gt ; <Weaken≤)

open import ParimeyaRupa_TheRationalsWithTheTrivialInvolutionFormAStarRingWithAHalfAndNonnegativityExcludesMinusTwoSoTheFiniteWeilCriterionAndTheKreinSplittingHoldOverQ
  using (ℚRing ; ṛṇa-viparīta)

∣_∣ : ℚ → ℚ
∣ x ∣ = max x (- x)

------------------------------------------------------------------------
-- १ · Basic bounds.
------------------------------------------------------------------------

-- both arms are below the max
vāma : (x : ℚ) → x ≤ (∣ x ∣)
vāma x = ≤max x (- x)

dakṣiṇa : (x : ℚ) → - x ≤ (∣ x ∣)
dakṣiṇa x = subst (- x ≤_) (maxComm (- x) x) (≤max (- x) x)

-- the max of two things below c is below c
max-≤ : (a b c : ℚ) → a ≤ c → b ≤ c → max a b ≤ c
max-≤ a b c ac bc = subst (max a b ≤_) (maxIdem c) (≤MonotoneMax a c b c ac bc)

-- negation reverses order
neg-≤ : (x y : ℚ) → x ≤ y → - y ≤ - x
neg-≤ x y le = subst2 _≤_ (lemma₁ x y) (lemma₂ x y) (≤-+o x y ((- x) + (- y)) le)
  where
  lemma₁ : (x y : ℚ) → x + ((- x) + (- y)) ≡ - y
  lemma₁ x y = +Assoc x (- x) (- y) ∙ cong (_+ (- y)) (+InvR x) ∙ +IdL (- y)
  lemma₂ : (x y : ℚ) → y + ((- x) + (- y)) ≡ - x
  lemma₂ x y = cong (y +_) (+Comm (- x) (- y)) ∙ +Assoc y (- y) (- x) ∙ cong (_+ (- x)) (+InvR y) ∙ +IdL (- x)

-- |x| ≥ 0: whichever of x, −x is nonnegative sits below the max
anṛṇa : (x : ℚ) → 0 ≤ (∣ x ∣)
anṛṇa x with x ≟ 0
... | lt x<0 = isTrans≤ 0 (- x) (∣ x ∣) (<Weaken≤ 0 (- x) (ṛṇa-viparīta x x<0)) (dakṣiṇa x)
... | eq p   = isTrans≤ 0 x (∣ x ∣) (subst (0 ≤_) (sym p) (isRefl≤ 0)) (vāma x)
... | gt 0<x = isTrans≤ 0 x (∣ x ∣) (<Weaken≤ 0 x 0<x) (vāma x)

-- |−x| = |x|
neg-sama : (x : ℚ) → ∣ - x ∣ ≡ (∣ x ∣)
neg-sama x = cong (max (- x)) (Sama.neg-neg ℚRing x) ∙ maxComm (- x) x

------------------------------------------------------------------------
-- २ · The triangle inequality.
------------------------------------------------------------------------

≤Monotone+ : (a b c d : ℚ) → a ≤ b → c ≤ d → a + c ≤ b + d
≤Monotone+ a b c d ab cd = isTrans≤ (a + c) (b + c) (b + d) (≤-+o a b c ab) (≤-o+ c d b cd)

trikoṇa : (x y : ℚ) → ∣ x + y ∣ ≤ (∣ x ∣) + (∣ y ∣)
trikoṇa x y = max-≤ (x + y) (- (x + y)) (∣ x ∣ + (∣ y ∣))
  (≤Monotone+ x (∣ x ∣) y (∣ y ∣) (vāma x) (vāma y))
  (subst (_≤ (∣ x ∣) + (∣ y ∣)) (sym (Sama.neg-add ℚRing x y))
    (≤Monotone+ (- x) (∣ x ∣) (- y) (∣ y ∣) (dakṣiṇa x) (dakṣiṇa y)))

------------------------------------------------------------------------
-- ३ · On each side of zero the absolute value is the element or its negative.
------------------------------------------------------------------------

dhana-sama : (x : ℚ) → 0 ≤ x → (∣ x ∣) ≡ x
dhana-sama x 0≤x = maxComm x (- x) ∙ ≤→max (- x) x (isTrans≤ (- x) 0 x (subst (- x ≤_) (Sama.śūnya-neg′ ℚRing) (neg-≤ 0 x 0≤x)) 0≤x)
ṛṇa-sama : (x : ℚ) → x ≤ 0 → (∣ x ∣) ≡ - x
ṛṇa-sama x x≤0 = ≤→max x (- x) (isTrans≤ x 0 (- x) x≤0 (subst (_≤ - x) (Sama.śūnya-neg′ ℚRing) (neg-≤ x 0 x≤0)))
