{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- रामानुजन्, त्रिक — BELOW 720 THE ODD EXCEPTIONS ARE EXACTLY HIS
-- SEVENTEEN: A KERNEL WITNESS FOR THE OPEN LIST.
--
-- Ramanujan (1916) asserted that the odd numbers NOT of the form
-- x² + y² + 10z² are exactly
--
--   3, 7, 21, 31, 33, 43, 67, 79, 87, 133, 217, 219, 223, 253,
--   307, 391, 679, 2719.
--
-- The full assertion remains unproved without GRH.  This file makes
-- the kernel a witness for the list below 720, both directions:
--
--   `represented-or-listed` — every odd n < 720 either sits in the
--     seventeen-entry prefix or carries an explicit representation
--     (x, y, z) with its equation, produced by the scan itself and
--     handed out as data.
--
--   `listed-not-represented` — none of the seventeen is represented
--     by ANY x, y, z, unbounded: square growth confines candidates
--     to x, y ≤ 26 and z ≤ 8 (27² = 729 and 10·9² = 810 overshoot
--     everything below 720), and the kernel refutes every triple in
--     the box.
--
-- Standing in the campaign: the machine's verdict organs hold the
-- full conjecture as śeṣa and its fitness discipline demanded a
-- fitter witness than an external scan; this file is that witness,
-- from the kernel itself.  2719 stands beyond this bound, next in
-- the queue.
------------------------------------------------------------------------

module RamanujanTernary_BelowSevenTwentyTheOddExceptionsAreExactlyHisSeventeenTowardTheOpenList where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; zero-≤ ; suc-≤-suc ; pred-≤-pred ; ¬-<-zero ; ¬m<m ;
         ≤-trans ; ≤<-trans ; <≤-trans ; splitℕ-≤ ; ≤SumLeft ; ≤SumRight)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Maybe
  using (Maybe ; nothing ; just ; rec ; map-Maybe ; ¬nothing≡just)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (eq?)
open import Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection
  using (le? ; eq?-complete ; mand ; mand-just ; loop ; loop-sound ; ≤-k·)
open import RamanujanNagell_TheFiveSolutionsAndNoSixthBelowTwoToTheFifteen
  using (sq-mono)


open import RamanujanTernaryGate_TheKernelScansBelowSevenTwentyOnceAndCachesTheVerdict public

-- Square growth confines any representation of e < 720 to the box.
xy-bound : (t e : ℕ) → e < 720 → t · t ≤ e → t ≤ 26
xy-bound t e elt hle = go (splitℕ-≤ t 26)
  where
  go : (t ≤ 26) ⊎ (26 < t) → t ≤ 26
  go (inl h)   = h
  go (inr h27) =
    Empty.rec (¬m<m
      (<≤-trans (≤<-trans (≤-trans (sq-mono h27) hle) elt) (9 , refl)))

z-bound : (z e : ℕ) → e < 720 → 10 · (z · z) ≤ e → z ≤ 8
z-bound z e elt hle = go (splitℕ-≤ z 8)
  where
  go : (z ≤ 8) ⊎ (8 < z) → z ≤ 8
  go (inl h)  = h
  go (inr h9) =
    Empty.rec (¬m<m
      (<≤-trans (≤<-trans (≤-trans (≤-k· 10 (sq-mono h9)) hle) elt)
                (90 , refl)))

exc-small : (i : ℕ) → i ≤ 16 → exc i < 720
exc-small i hi = g (le? (suc (exc i)) 720) refl
  where
  g : (w : Maybe (suc (exc i) ≤ 720)) → le? (suc (exc i)) 720 ≡ w →
      exc i < 720
  g (just w) _  = w
  g nothing  pw =
    Empty.rec (¬nothing≡just
      (sym (cong (rec nothing (λ _ → just tt)) pw)
       ∙ loop-sound leafSm 16 scanSm-ok i hi))

-- THE SECOND DIRECTION.  For each listed index, no triple at all:
-- the bounds fold any candidate into the box, and the box is empty.
listed-not-represented : (i : ℕ) → i ≤ 16 →
  (x y z : ℕ) → ¬ Q x y z ≡ exc i
listed-not-represented i hi x y z hq =
  noHit-sound e x y z step3 hq
  where
  e : ℕ
  e = exc i

  e< : e < 720
  e< = exc-small i hi

  xb : x ≤ 26
  xb = xy-bound x e e<
    (subst (x · x ≤_) hq
      (≤-trans (≤SumLeft {n = x · x} {k = y · y})
               (≤SumLeft {n = x · x + y · y} {k = 10 · (z · z)})))

  yb : y ≤ 26
  yb = xy-bound y e e<
    (subst (y · y ≤_) hq
      (≤-trans (≤SumRight {n = y · y} {k = x · x})
               (≤SumLeft {n = x · x + y · y} {k = 10 · (z · z)})))

  zb : z ≤ 8
  zb = z-bound z e e<
    (subst (10 · (z · z) ≤_) hq
      (≤SumRight {n = 10 · (z · z)} {k = x · x + y · y}))

  step0 : scanBox e ≡ just tt
  step0 = loop-sound (λ i' → scanBox (exc i')) 16 scanExc-ok i hi

  step1 : loop (λ y' → loop (λ z' → noHit e x y' z') 8) 26 ≡ just tt
  step1 =
    loop-sound
      (λ x' → loop (λ y' → loop (λ z' → noHit e x' y' z') 8) 26) 26
      step0 x xb

  step2 : loop (λ z' → noHit e x y z') 8 ≡ just tt
  step2 = loop-sound (λ y' → loop (λ z' → noHit e x y' z') 8) 26 step1 y yb

  step3 : noHit e x y z ≡ just tt
  step3 = loop-sound (λ z' → noHit e x y z') 8 step2 z zb
