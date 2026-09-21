{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- रामानुजन्, अभाज्य — THE FIVE THRESHOLDS HOLD TO 50, AND EACH
-- MINIMALITY IS ONE REFUTATION.
--
-- Ramanujan's proof of Bertrand's postulate (1919) ends with a
-- sharpening Hardy called characteristic: π(x) − π(x/2) ≥ 1, 2, 3,
-- 4, 5, … as soon as x ≥ 2, 11, 17, 29, 41, … — the Ramanujan
-- primes.  This file verifies the five thresholds on 1..50:
--
--   THE COUNTER.  A prime is a number whose divisor counter — the
--   self-defining dCount of the highly-composite file — answers
--   exactly 2.  π is the sum of that indicator.  No primality is
--   asserted; each is counted by interrogation.
--
--   `ramanujan-thresholds` — for every x ≤ 50 and each k ≤ 5: once
--   x reaches the k-th threshold, π(⌊x/2⌋) + k ≤ π(x),
--   subtraction-free.  One scan, five guarded leaves per point,
--   soundness by the taxicab engine.  The k = 1 row is Bertrand's
--   postulate on the range: between half of x and x there is always
--   a prime.
--
--   `minimal-2 … minimal-41` — each threshold is exact: one step
--   earlier the count falls short, and each refutation is literally
--   ¬m<m — the failed inequality normalizes to a strict
--   self-precedence, which the order refuses.
--
-- The unbounded statements are the 1919 paper's Chebyshev estimates;
-- beyond 50 they are named, not claimed.  Within 50 nothing is
-- sampled: every x is checked, every prime is counted by its
-- divisors.
------------------------------------------------------------------------

module RamanujanPrimes_TheFiveThresholdsHoldTo50AndEachMinimalityIsOneRefutation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; pred-≤-pred ; ¬m<m ; ≤<-trans)
open import Cubical.Data.Maybe
  using (Maybe ; nothing ; just ; rec ; ¬nothing≡just)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (eq?)
open import Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection
  using (le? ; mand ; mand-just ; loop ; loop-sound)
open import RamanujanHCN_OneHundredTwentyIsHighlyCompositeAndTheMemoirsColumnChecks
  using (dCount)

------------------------------------------------------------------------
-- §1  Counting primes by interrogation.
------------------------------------------------------------------------

primeInd : ℕ → ℕ
primeInd m = rec 0 (λ _ → 1) (eq? (dCount m) 2)

πsum : ℕ → ℕ
πsum zero    = 0
πsum (suc m) = primeInd (suc m) + πsum m

πC : ℕ → ℕ
πC x = πsum x

half : ℕ → ℕ
half zero          = zero
half (suc zero)    = zero
half (suc (suc n)) = suc (half n)

------------------------------------------------------------------------
-- §2  The scan: five guarded leaves per point.
------------------------------------------------------------------------

-- Once x reaches R, demand π(half x) + k ≤ π(x); before R, vacuous.
leafK : ℕ → ℕ → ℕ → Maybe Unit
leafK k R x =
  rec (rec nothing (λ _ → just tt) (le? (πC (half x) + k) (πC x)))
      (λ _ → just tt)
      (le? (suc x) R)

leafAll : ℕ → Maybe Unit
leafAll x =
  mand (leafK 1 2 x) (mand (leafK 2 11 x) (mand (leafK 3 17 x)
    (mand (leafK 4 29 x) (leafK 5 41 x))))

scan : Maybe Unit
scan = loop leafAll 50

scan-ok : scan ≡ just tt
scan-ok = refl

------------------------------------------------------------------------
-- §3  Soundness.
------------------------------------------------------------------------

leafK-sound : (k R x : ℕ) → leafK k R x ≡ just tt →
              R ≤ x → πC (half x) + k ≤ πC x
leafK-sound k R x h Rx = g (le? (suc x) R) refl
  where
  inner : rec nothing (λ _ → just tt) (le? (πC (half x) + k) (πC x))
            ≡ just tt →
          πC (half x) + k ≤ πC x
  inner h2 = g2 (le? (πC (half x) + k) (πC x)) refl
    where
    g2 : (w : Maybe (πC (half x) + k ≤ πC x)) →
         le? (πC (half x) + k) (πC x) ≡ w →
         πC (half x) + k ≤ πC x
    g2 (just w) _  = w
    g2 nothing  pw =
      Empty.rec (¬nothing≡just
        (sym (cong (rec nothing (λ _ → just tt)) pw) ∙ h2))

  g : (w : Maybe (suc x ≤ R)) → le? (suc x) R ≡ w →
      πC (half x) + k ≤ πC x
  g (just w) _  = Empty.rec (¬m<m (≤<-trans Rx w))
  g nothing  pw =
    inner
      (sym (cong (rec (rec nothing (λ _ → just tt)
                        (le? (πC (half x) + k) (πC x)))
                      (λ _ → just tt)) pw)
       ∙ h)

------------------------------------------------------------------------
-- §4  THE THEOREM, and the five exactness refutations.
------------------------------------------------------------------------

ramanujan-thresholds : (x : ℕ) → x ≤ 50 →
    (2 ≤ x → πC (half x) + 1 ≤ πC x)
  × (11 ≤ x → πC (half x) + 2 ≤ πC x)
  × (17 ≤ x → πC (half x) + 3 ≤ πC x)
  × (29 ≤ x → πC (half x) + 4 ≤ πC x)
  × (41 ≤ x → πC (half x) + 5 ≤ πC x)
ramanujan-thresholds x hx =
  (λ r → leafK-sound 1 2 x (fst parts) r) ,
  (λ r → leafK-sound 2 11 x (fst (snd parts)) r) ,
  (λ r → leafK-sound 3 17 x (fst (snd (snd parts))) r) ,
  (λ r → leafK-sound 4 29 x (fst (snd (snd (snd parts)))) r) ,
  (λ r → leafK-sound 5 41 x (snd (snd (snd (snd parts)))) r)
  where
  all≡ : leafAll x ≡ just tt
  all≡ = loop-sound leafAll 50 scan-ok x hx

  parts : (leafK 1 2 x ≡ just tt) × ((leafK 2 11 x ≡ just tt)
          × ((leafK 3 17 x ≡ just tt) × ((leafK 4 29 x ≡ just tt)
          × (leafK 5 41 x ≡ just tt))))
  parts =
    let p1 = mand-just (leafK 1 2 x) _ all≡
        p2 = mand-just (leafK 2 11 x) _ (snd p1)
        p3 = mand-just (leafK 3 17 x) _ (snd p2)
        p4 = mand-just (leafK 4 29 x) _ (snd p3)
    in fst p1 , fst p2 , fst p3 , fst p4 , snd p4

-- Each threshold is exact: one step earlier, the demanded count is a
-- strict self-precedence, and the order refuses it.
minimal-2 : ¬ (πC (half 1) + 1 ≤ πC 1)
minimal-2 = ¬m<m

minimal-11 : ¬ (πC (half 10) + 2 ≤ πC 10)
minimal-11 = ¬m<m

minimal-17 : ¬ (πC (half 16) + 3 ≤ πC 16)
minimal-17 = ¬m<m

minimal-29 : ¬ (πC (half 28) + 4 ≤ πC 28)
minimal-29 = ¬m<m

minimal-41 : ¬ (πC (half 40) + 5 ≤ πC 40)
minimal-41 = ¬m<m
