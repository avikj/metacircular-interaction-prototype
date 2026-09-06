{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- परिमेय-रूप — the rational form.
--
-- TauRupa, WeilDhanatva and KreinSucika are stated over any commutative
-- *-ring with a half and any positivity predicate closed under squares
-- and sums, containing 0 and excluding −(1+1).  This file inhabits all
-- of it: the rationals with the trivial involution, ½ = [1/2], and the
-- positivity "0 ≤ x".
--
--   §1  ℚ AS A COMMUTATIVE RING, from the library's ring laws on the
--       preferred rationals (which carry the order).
--   §2  THE *-RING: x* = x, ½ + ½ = 1 by the quotient's own equation.
--   §3  NONNEGATIVITY IS A POSITIVITY: 0 ≤ x·x for every x (by
--       trichotomy), sums of nonnegatives are nonnegative, 0 ≤ 0, and
--       ¬ (0 ≤ −2) — the last read off on representatives in ℤ.
--   §4  THE THEOREMS AT ℚ: the finite Weil criterion and the Krein
--       splitting, with every parameter concrete; and the smallest
--       configuration with an off-line mode, n = 2 with τ the swap,
--       whose negative vector δ₀ − δ₁ has τ-form −2.
--
-- परिमेय (parimeya, measurable/rational) is the ordinary Sanskrit word.
------------------------------------------------------------------------

module ParimeyaRupa_TheRationalsWithTheTrivialInvolutionFormAStarRingWithAHalfAndNonnegativityExcludesMinusTwoSoTheFiniteWeilCriterionAndTheKreinSplittingHoldOverQ where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; snotz)
import Cubical.Data.Nat.Order as NO
open import Cubical.Data.NatPlusOne using (ℕ₊₁ ; 1+_)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc ; sucℤ ; _+pos_ ; posNotnegsuc)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-elim)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)
open import Cubical.Data.Rationals
open import Cubical.Data.Rationals.Order
  using (_≤_ ; _<_ ; isRefl≤ ; isTrans≤ ; <Weaken≤ ; <-+o ; ≤-o+ ; ≤-·o ; _≟_ ; lt ; eq ; gt)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver

open import TauRupa_TheCriticalReflectionFormIsPreservedByEveryConfigurationsTransportAndThePlainFormExactlyWhenEveryModeHasUnitModulusSoRHSitsAtTheModulus
  using (StarRing)
import TauRupa_TheCriticalReflectionFormIsPreservedByEveryConfigurationsTransportAndThePlainFormExactlyWhenEveryModeHasUnitModulusSoRHSitsAtTheModulus
  as T
import WeilDhanatva_TheReflectionFormIsPositiveOnEveryVectorExactlyWhenEveryModeIsFixedByTheReflectionSoFiniteWeilPositivityIsFiniteRH
  as W
import KreinSucika_TheDoubledReflectionFormSplitsIntoAPositiveSumOfSquaresMinusASumOfSquaresSupportedExactlyOnTheMovedModesSoTheNegativeIndexCountsTheOffLineModes
  as K

------------------------------------------------------------------------
-- १ · ℚ as a commutative ring.
------------------------------------------------------------------------

ℚRing : CommRing ℓ-zero
ℚRing = makeCommRing 0 1 _+_ _·_ -_ isSetℚ +Assoc +IdR +InvR +Comm ·Assoc ·IdR ·DistL+ ·Comm

------------------------------------------------------------------------
-- २ · The *-ring: trivial involution, ½ = [1/2].
------------------------------------------------------------------------

ardha : ℚ
ardha = [ pos 1 / 1+ 1 ]

ardha-dvi : ardha + ardha ≡ 1
ardha-dvi = eq/ _ _ refl

ℚ✶ : StarRing ℓ-zero
StarRing.R     ℚ✶ = ℚRing
StarRing._✶    ℚ✶ = λ x → x
StarRing.✶-inv ℚ✶ = λ _ → refl
StarRing.✶-add ℚ✶ = λ _ _ → refl
StarRing.✶-mul ℚ✶ = λ _ _ → refl
StarRing.✶-neg ℚ✶ = λ _ → refl
StarRing.✶-one ℚ✶ = refl
StarRing.half  ℚ✶ = ardha
StarRing.half2 ℚ✶ = ardha-dvi

------------------------------------------------------------------------
-- ३ · Nonnegativity is a positivity.
------------------------------------------------------------------------

Anṛṇa : ℚ → Type₀
Anṛṇa x = 0 ≤ x

-- 0 ≤ x → 0 ≤ x·x
anṛṇa-varga′ : (x : ℚ) → 0 ≤ x → 0 ≤ x · x
anṛṇa-varga′ x 0≤x = subst (_≤ x · x) (·AnnihilL x) (≤-·o 0 x x 0≤x 0≤x)

-- x < 0 → 0 < −x
ṛṇa-viparīta : (x : ℚ) → x < 0 → 0 < - x
ṛṇa-viparīta x x<0 = subst2 _<_ (+InvR x) (+IdL (- x)) (<-+o x 0 (- x) x<0)

-- every square is nonnegative
anṛṇa-varga : (x : ℚ) → Anṛṇa (x · x)
anṛṇa-varga x with x ≟ 0
... | lt x<0 = subst (0 ≤_) (vipa x) (anṛṇa-varga′ (- x) (<Weaken≤ 0 (- x) (ṛṇa-viparīta x x<0)))
  where vipa : (x : ℚ) → (- x) · (- x) ≡ x · x
        vipa x = ·Assoc (- x) (- 1) x ∙ cong (_· x) (·Comm (- x) (- 1) ∙ -Invol x)
... | eq p   = subst (0 ≤_) (sym (cong (λ z → z · z) p ∙ ·AnnihilL 0)) (isRefl≤ 0)
... | gt 0<x = anṛṇa-varga′ x (<Weaken≤ 0 x 0<x)

anṛṇa-yoga : {x y : ℚ} → Anṛṇa x → Anṛṇa y → Anṛṇa (x + y)
anṛṇa-yoga {x} {y} 0≤x 0≤y = isTrans≤ 0 x (x + y) 0≤x (subst (_≤ x + y) (+IdR x) (≤-o+ 0 y x 0≤y))

anṛṇa-śūnya : Anṛṇa 0
anṛṇa-śūnya = isRefl≤ 0

-- ¬ (0 ≤ −2): on representatives this is pos 0 +pos k ≡ negsuc 1 in ℤ.
pos0+pos : (k : ℕ) → pos 0 +pos k ≡ pos k
pos0+pos zero    = refl
pos0+pos (suc k) = cong sucℤ (pos0+pos k)

anṛṇa-na-ṛṇa : ¬ Anṛṇa (- (1 + 1))
anṛṇa-na-ṛṇa (k , p) = posNotnegsuc k 1 (sym (pos0+pos k) ∙ p)

------------------------------------------------------------------------
-- ४ · The theorems at ℚ.
------------------------------------------------------------------------

-- the finite Weil criterion over ℚ, every parameter concrete
ℚ-weil : (n : ℕ) (τ : ℕ → ℕ) (cl : W.Antaḥ ℚ✶ n τ) (inv : W.Parivartana ℚ✶ n τ)
       → (W.Dhanatva ℚ✶ n τ Anṛṇa anṛṇa-varga (λ {x} {y} → anṛṇa-yoga {x} {y}) anṛṇa-śūnya anṛṇa-na-ṛṇa cl inv → W.Sthira ℚ✶ n τ)
       × (W.Sthira ℚ✶ n τ → W.Dhanatva ℚ✶ n τ Anṛṇa anṛṇa-varga (λ {x} {y} → anṛṇa-yoga {x} {y}) anṛṇa-śūnya anṛṇa-na-ṛṇa cl inv)
ℚ-weil n τ cl inv = W.weil-dhanatva ℚ✶ n τ Anṛṇa anṛṇa-varga (λ {x} {y} → anṛṇa-yoga {x} {y}) anṛṇa-śūnya anṛṇa-na-ṛṇa cl inv

-- the Krein splitting over ℚ
ℚ-krein : (n : ℕ) (τ : ℕ → ℕ) (cl : W.Antaḥ ℚ✶ n τ) (inv : W.Parivartana ℚ✶ n τ) (c : ℕ → ℚ)
        → (1 + 1) · T.τ-rūpa ℚ✶ n τ c c ≡ K.dhana ℚ✶ n τ cl inv c - K.ṛṇa ℚ✶ n τ cl inv c
ℚ-krein n τ cl inv c = K.krein-sūcikā ℚ✶ n τ cl inv c

-- the smallest configuration with an off-line mode: two modes, swapped
viparyaya : ℕ → ℕ
viparyaya zero          = suc zero
viparyaya (suc zero)    = zero
viparyaya (suc (suc k)) = suc (suc k)

viparyaya-antaḥ : W.Antaḥ ℚ✶ 2 viparyaya
viparyaya-antaḥ zero          _ = NO.≤-refl
viparyaya-antaḥ (suc zero)    _ = NO.suc-≤-suc NO.zero-≤
viparyaya-antaḥ (suc (suc k)) p = p

viparyaya-parivartana : W.Parivartana ℚ✶ 2 viparyaya
viparyaya-parivartana zero          _ = refl
viparyaya-parivartana (suc zero)    _ = refl
viparyaya-parivartana (suc (suc k)) _ = refl

-- the vector δ₀ − δ₁ has τ-form −2: the configuration is not positive
dvi-ṛṇa : T.τ-rūpa ℚ✶ 2 viparyaya (W.bheda ℚ✶ 2 viparyaya 0) (W.bheda ℚ✶ 2 viparyaya 0) ≡ - (1 + 1)
dvi-ṛṇa = W.calita-ṛṇa ℚ✶ 2 viparyaya 0 (NO.suc-≤-suc NO.zero-≤) NO.≤-refl (λ p → snotz p) refl

-- and the identity configuration on two modes is positive
sthira-dvi : (c : ℕ → ℚ) → Anṛṇa (T.τ-rūpa ℚ✶ 2 (λ i → i) c c)
sthira-dvi = W.sthira→dhana ℚ✶ 2 (λ i → i) Anṛṇa anṛṇa-varga (λ {x} {y} → anṛṇa-yoga {x} {y}) anṛṇa-śūnya (λ _ _ → refl)
