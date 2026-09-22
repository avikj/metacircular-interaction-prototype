{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- रामानुजन्, उच्चभाजक — 120 IS HIGHLY COMPOSITE, AND THE MEMOIR'S
-- COLUMN CHECKS.
--
-- Ramanujan's 1915 memoir "Highly Composite Numbers" — the paper so
-- long the London Mathematical Society trimmed it — opens with the
-- numbers whose divisor count beats every predecessor.  This file
-- proves the property, not instances of belief:
--
--   The divisor counter DEFINES itself: dCount m sums, over
--   k = 1..m, an indicator that holds exactly when a multiplication
--   witness q with q·k ≡ m exists — found by scan, carried as a
--   witness, never a boolean.  There is no separate specification to
--   trust: the function IS "the number of divisors".
--
--   `the-memoir's-column` — Ramanujan's first ten highly composite
--   numbers 1, 2, 4, 6, 12, 24, 36, 48, 60, 120 carry divisor counts
--   1, 2, 3, 4, 6, 8, 9, 10, 12, 16: ten refls.
--
--   `highly-composite-120` — THE THEOREM: every m < 120 has
--   dCount m < dCount 120.  The kernel scans all 120 predecessors,
--   counting the divisors of each by its own definition, in one refl;
--   the soundness lemmas of the taxicab engine convert the scan.
--
-- Hardy said Ramanujan knew the divisors of numbers like personal
-- friends.  Here the friendship is checked: 119 acquaintances, each
-- interrogated completely, none reaching sixteen.
------------------------------------------------------------------------

module RamanujanHCN_OneHundredTwentyIsHighlyCompositeAndTheMemoirsColumnChecks where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; pred-≤-pred)
open import Cubical.Data.Maybe
  using (Maybe ; nothing ; just ; rec ; map-Maybe ; ¬nothing≡just)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (eq?)
open import Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection
  using (le? ; loop ; loop-sound)

------------------------------------------------------------------------
-- §1  The divisor counter, self-defining.
------------------------------------------------------------------------

-- Search for the cofactor, witness in hand: q with q · k ≡ m, q ≤ b.
find-q : (b k m : ℕ) → Maybe (Σ ℕ (λ q → q · k ≡ m))
find-q zero    k m = map-Maybe (λ p → zero , p) (eq? zero m)
find-q (suc b) k m =
  rec (find-q b k m) (λ p → just (suc b , p)) (eq? (suc b · k) m)

-- k divides m: a cofactor exists at or below m.
dvd? : (k m : ℕ) → Maybe (Σ ℕ (λ q → q · k ≡ m))
dvd? k m = find-q m k m

-- The indicator: one exactly when the witness was found.
ind : ℕ → ℕ → ℕ
ind k m = rec 0 (λ _ → 1) (dvd? k m)

-- The divisor count: the sum of indicators over k = 1..m.  This IS
-- the definition of d(m); there is no separate spec to trust.
dsum : ℕ → ℕ → ℕ
dsum m zero    = 0
dsum m (suc k) = ind (suc k) m + dsum m k

dCount : ℕ → ℕ
dCount m = dsum m m

------------------------------------------------------------------------
-- §2  The memoir's column: ten refls.
------------------------------------------------------------------------

the-memoirs-column :
  (dCount 1 ≡ 1) × (dCount 2 ≡ 2) × (dCount 4 ≡ 3) × (dCount 6 ≡ 4)
  × (dCount 12 ≡ 6) × (dCount 24 ≡ 8) × (dCount 36 ≡ 9)
  × (dCount 48 ≡ 10) × (dCount 60 ≡ 12) × (dCount 120 ≡ 16)
the-memoirs-column =
  refl , refl , refl , refl , refl , refl , refl , refl , refl , refl

------------------------------------------------------------------------
-- §3  The scan, and the theorem.
------------------------------------------------------------------------

leafHC : ℕ → Maybe Unit
leafHC m = rec nothing (λ _ → just tt) (le? (suc (dCount m)) 16)

scanHC : Maybe Unit
scanHC = loop leafHC 119

scan-ok : scanHC ≡ just tt
scan-ok = refl

leafHC-sound : (m : ℕ) → leafHC m ≡ just tt → dCount m < 16
leafHC-sound m h = g (le? (suc (dCount m)) 16) refl
  where
  g : (w : Maybe (suc (dCount m) ≤ 16)) → le? (suc (dCount m)) 16 ≡ w →
      dCount m < 16
  g (just w) _  = w
  g nothing  pw =
    Empty.rec (¬nothing≡just
      (sym (cong (rec nothing (λ _ → just tt)) pw) ∙ h))

-- THE THEOREM.  Every number below 120 has strictly fewer divisors:
-- 120 is highly composite, as Ramanujan tabulated it.
highly-composite-120 : (m : ℕ) → m < 120 → dCount m < dCount 120
highly-composite-120 m hm =
  leafHC-sound m (loop-sound leafHC 119 scan-ok m (pred-≤-pred hm))
