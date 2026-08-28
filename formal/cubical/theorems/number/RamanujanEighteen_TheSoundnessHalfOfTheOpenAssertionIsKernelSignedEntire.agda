{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- रामानुजन्, अष्टादश — THE SOUNDNESS HALF OF THE OPEN ASSERTION IS
-- KERNEL-SIGNED, ENTIRE.
--
-- Ramanujan's 1916 assertion has two halves.  The COMPLETENESS half —
-- nothing odd beyond the eighteen escapes the form — is the open one,
-- proved only under GRH.  The SOUNDNESS half — each of the eighteen
-- escapes — is finite in principle but unbounded in statement: for
-- every listed value, NO triple (x, y, z) whatsoever represents it.
-- This file signs that half entire:
--
--   `no-2719` — the last and largest: square growth confines any
--     candidate to the 53 × 53 × 17 box (53² = 2809 and 10·17² = 2890
--     overshoot), and the kernel emptied the box in the cached gate.
--
--   `the-eighteen-are-exceptions` — all eighteen at once, i ≤ 17,
--     every x, y, z: the seventeen by the 720-window theorem, 2719 by
--     the new gate.  This inhabits, exactly, the second conjunct of
--     `RamanujanAssertion` — half of the open statement is now a
--     checked term, and the type system knows which half.
------------------------------------------------------------------------

module RamanujanEighteen_TheSoundnessHalfOfTheOpenAssertionIsKernelSignedEntire where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ¬m<m ; ≤-trans ; ≤<-trans ; <≤-trans ; splitℕ-≤ ;
         ≤-antisym ; ≤SumLeft ; ≤SumRight)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Maybe using (Maybe ; just)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

open import Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection
  using (loop ; loop-sound ; ≤-k·)
open import RamanujanNagell_TheFiveSolutionsAndNoSixthBelowTwoToTheFifteen
  using (sq-mono)
open import RamanujanTernaryGate_TheKernelScansBelowSevenTwentyOnceAndCachesTheVerdict
  using (Q ; Rep ; exc)
open import RamanujanTernary_BelowSevenTwentyTheOddExceptionsAreExactlyHisSeventeenTowardTheOpenList
  using (noHit ; noHit-sound ; listed-not-represented)
open import RamanujanTernaryUpadhi_TheUniversalClaimIsATypeTheGateRestrictsItAndNoTermRunsBackwards
  using (exc18 ; exc18-prefix ; RamanujanAssertion)
open import Ramanujan2719Gate_TheKernelEmptiesTheLargeBoxOnceAndCachesIt
  using (scan2719-ok)

------------------------------------------------------------------------
-- §1  The 2719 bounds, and the emptiness of the large box.
------------------------------------------------------------------------

xy-bound-2719 : (t : ℕ) → t · t ≤ 2719 → t ≤ 52
xy-bound-2719 t hle = go (splitℕ-≤ t 52)
  where
  go : (t ≤ 52) ⊎ (52 < t) → t ≤ 52
  go (inl h)   = h
  go (inr h53) =
    Empty.rec (¬m<m (≤<-trans (≤-trans (sq-mono h53) hle) (89 , refl)))

z-bound-2719 : (z : ℕ) → 10 · (z · z) ≤ 2719 → z ≤ 16
z-bound-2719 z hle = go (splitℕ-≤ z 16)
  where
  go : (z ≤ 16) ⊎ (16 < z) → z ≤ 16
  go (inl h)   = h
  go (inr h17) =
    Empty.rec (¬m<m
      (≤<-trans (≤-trans (≤-k· 10 (sq-mono h17)) hle) (170 , refl)))

no-2719 : (x y z : ℕ) → ¬ Q x y z ≡ 2719
no-2719 x y z hq =
  noHit-sound 2719 x y z step3 hq
  where
  xb : x ≤ 52
  xb = xy-bound-2719 x (subst (x · x ≤_) hq
        (≤-trans (≤SumLeft {n = x · x} {k = y · y})
                 (≤SumLeft {n = x · x + y · y} {k = 10 · (z · z)})))

  yb : y ≤ 52
  yb = xy-bound-2719 y (subst (y · y ≤_) hq
        (≤-trans (≤SumRight {n = y · y} {k = x · x})
                 (≤SumLeft {n = x · x + y · y} {k = 10 · (z · z)})))

  zb : z ≤ 16
  zb = z-bound-2719 z (subst (10 · (z · z) ≤_) hq
        (≤SumRight {n = 10 · (z · z)} {k = x · x + y · y}))

  step1 : loop (λ y' → loop (λ z' → noHit 2719 x y' z') 16) 52 ≡ just tt
  step1 =
    loop-sound
      (λ x' → loop (λ y' → loop (λ z' → noHit 2719 x' y' z') 16) 52) 52
      scan2719-ok x xb

  step2 : loop (λ z' → noHit 2719 x y z') 16 ≡ just tt
  step2 = loop-sound (λ y' → loop (λ z' → noHit 2719 x y' z') 16) 52 step1 y yb

  step3 : noHit 2719 x y z ≡ just tt
  step3 = loop-sound (λ z' → noHit 2719 x y z') 16 step2 z zb

------------------------------------------------------------------------
-- §2  THE SOUNDNESS HALF, ENTIRE.
------------------------------------------------------------------------

the-eighteen-are-exceptions : (i : ℕ) → i ≤ 17 → ¬ Rep (exc18 i)
the-eighteen-are-exceptions i hi (x , y , z , hq) =
  go (splitℕ-≤ i 16)
  where
  go : (i ≤ 16) ⊎ (16 < i) → ⊥
  go (inl h16) =
    listed-not-represented i h16 x y z
      (hq ∙ exc18-prefix i h16)
  go (inr h17) =
    no-2719 x y z (hq ∙ cong exc18 (≤-antisym hi h17))

-- This term inhabits, verbatim, the second conjunct of
-- RamanujanAssertion: half the open statement is checked, and the
-- type system knows which half.
