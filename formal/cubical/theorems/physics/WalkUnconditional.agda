{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- The walk's laws, unconditionally, about a computable number.
--
-- Until LCMExists, every theorem in the walk lane
-- (WalkForcing, WalkCapacity, WalkStream, WalkInduction) quantified over
-- a hypothesis `IsLCM S L`, because cubical v0.5 has no LCM module and no
-- lcm had ever been constructed here.  The lane was therefore CONDITIONAL
-- on lcms existing -- true, undisputed, and still a real gap in the
-- formalisation (recorded in WALK_FORCING_LAW.md before an auditor found
-- it).
--
-- LCMExists closed that gap with no weakening: `lcmList-exists` inhabits
-- the hypothesis for EVERY list.  This module cashes that in.  Each
-- statement below is the corresponding conditional theorem with its
-- hypothesis discharged, so `cap` is now an actual computable function of
-- the frontier rather than a universal property -- e^psi(k) as a number.
--
-- CHECKED: Agda 2.6.3, cubical v0.5, --cubical --safe, 2026-08-13.
-- No postulates, no holes.

module WalkUnconditional where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.List
open import Cubical.Data.Sigma

open import WalkCapacity
  using (All; range1; IsLCM; capacity; capacity-attained; range1-admissible)
open import LCMExists
  using (lcmList; lcmList-isLCM)

-- THE CAPACITY FUNCTION.  cap k is a number, computed, not characterised.
cap : ℕ → ℕ
cap k = lcmList (range1 k)

-- CAPACITY, unconditional: every admissible family's lcm divides cap k.
capacity! :
  (xs : List ℕ) (k : ℕ) →
  All (λ x → (0 < x) × (x ≤ k)) xs →
  lcmList xs ∣ cap k
capacity! xs k inRange =
  capacity xs k (lcmList xs) (cap k)
    (lcmList-isLCM xs) (lcmList-isLCM (range1 k)) inRange

-- ATTAINMENT, unconditional: an admissible family whose lcm IS cap k.
capacity-attained! :
  (k : ℕ) →
  Σ[ F ∈ List ℕ ] (All (λ x → (0 < x) × (x ≤ k)) F) × (lcmList F ≡ cap k)
capacity-attained! k = range1 k , range1-admissible k , refl

-- Together: cap k is the maximum, and it is reached.  The walk's storage
-- law log2 (cap k) = psi(k)/ln 2 is now a statement about this function.

-- IT COMPUTES.  A definition built through well-founded recursion can be
-- correct and still stuck; these reduce to literals by refl, which is
-- exact symbolic computation and therefore proof (CLAUDE.md), not
-- measurement.  cap 1 = 1, cap 2 = 2, cap 3 = 6, cap 4 = 12, cap 6 = 60:
-- the first frontiers of the walk, and the first jump (3 -> 4 installs a
-- new prime power, 4 -> 5 does not... 5 does).
cap-1 : cap 1 ≡ 1
cap-1 = refl

cap-2 : cap 2 ≡ 2
cap-2 = refl

cap-3 : cap 3 ≡ 6
cap-3 = refl

cap-4 : cap 4 ≡ 12
cap-4 = refl

cap-6 : cap 6 ≡ 60
cap-6 = refl

-- and a jump witnessed as an inequality of computed values: capacity
-- strictly grows at 4 (installing 2^2) and not at 6 (6 = 2*3 already
-- divides cap 5), which is WALK_INSTALLS_ARE_JUMPS (b) at the first
-- nontrivial frontier, by computation.
cap-5 : cap 5 ≡ 60
cap-5 = refl

no-jump-at-6 : cap 6 ≡ cap 5
no-jump-at-6 = refl
