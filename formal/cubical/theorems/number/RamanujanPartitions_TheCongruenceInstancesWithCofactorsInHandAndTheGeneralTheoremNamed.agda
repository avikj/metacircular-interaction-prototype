{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- रामानुजन्, विभाजन — THE PARTITION CONGRUENCES: INSTANCES WITH
-- COFACTORS IN HAND, AND THE GENERAL THEOREM NAMED.
--
-- Ramanujan (1919): p(5n+4) ≡ 0 (mod 5), p(7n+5) ≡ 0 (mod 7),
-- p(11n+6) ≡ 0 (mod 11) — read off MacMahon's table and then proved
-- with the theta calculus.  This file defines the partition function
-- and checks the congruences where exact computation reaches:
--
--   THE DEFINITION.  Pf m n counts partitions of n into parts ≤ m by
--   the multiplicity of the largest allowed part — the standard
--   grouping, total by a lexicographic descent, using truncated
--   subtraction only where the guard has already paid for it.
--   p n = Pf n n.  This IS the partition function, as a counting
--   recursion; there is no generating function cited and no table
--   trusted: MacMahon's values fall out as refls (`the-table`).
--
--   THE INSTANCES.  For each congruence family, three instances with
--   the COFACTOR EXHIBITED — divisibility is Σ q (q · d ≡ p n), the
--   witness in the pair, nothing merely asserted:
--
--     5  ∣ p 4 = 5,    5 ∣ p 9 = 30,    5 ∣ p 14 = 135
--     7  ∣ p 5 = 7,    7 ∣ p 12 = 77,   7 ∣ p 19 = 490
--     11 ∣ p 6 = 11,   11 ∣ p 17 = 297, 11 ∣ p 28 = 3718
--
--   The general theorems, for all n at once, are Ramanujan's theta
--   identities and Atkin's completion for 11 — analytic instruments
--   outside this file's exact discipline.  They are named, and what
--   is proved here is exactly what the kernel computed.
------------------------------------------------------------------------

module RamanujanPartitions_TheCongruenceInstancesWithCofactorsInHandAndTheGeneralTheoremNamed where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; _∸_)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just ; rec)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (eq?)
open import Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection
  using (le?)

------------------------------------------------------------------------
-- §1  The partition function, as a counting recursion.
------------------------------------------------------------------------

-- Contribution of using the part (suc m) exactly j times, for j from
-- a countdown: when (suc m)·j still fits inside n, count the
-- partitions of the remainder into parts ≤ m; sum over all j.
mutual
  -- Partitions of n into parts ≤ m, grouped by the multiplicity j of
  -- the largest allowed part.
  Pf : ℕ → ℕ → ℕ
  Pf m zero          = 1
  Pf zero (suc n)    = 0
  Pf (suc m) (suc n) = sumJ m (suc n) (suc n)

  -- Sum over j = countdown .. 0: the part (suc m) used exactly j
  -- times, the remainder partitioned into parts ≤ m.
  sumJ : ℕ → ℕ → ℕ → ℕ
  sumJ m n zero    = Pf m n
  sumJ m n (suc j) = contrib m n (suc j) + sumJ m n j

  -- Guarded: only when (suc m)·j still fits inside n.
  contrib : ℕ → ℕ → ℕ → ℕ
  contrib m n j =
    rec 0 (λ _ → Pf m (n ∸ (suc m · j))) (le? (suc m · j) n)

p : ℕ → ℕ
p n = Pf n n

------------------------------------------------------------------------
-- §2  MacMahon's values fall out.
------------------------------------------------------------------------

the-table :
  (p 4 ≡ 5) × (p 5 ≡ 7) × (p 6 ≡ 11) × (p 9 ≡ 30) × (p 12 ≡ 77)
  × (p 14 ≡ 135) × (p 17 ≡ 297) × (p 19 ≡ 490) × (p 28 ≡ 3718)
the-table = refl , refl , refl , refl , refl , refl , refl , refl , refl

------------------------------------------------------------------------
-- §3  The congruences, cofactors in hand.
------------------------------------------------------------------------

_∣_ : ℕ → ℕ → Type
d ∣ m = Σ ℕ (λ q → q · d ≡ m)

mod5-instances : (5 ∣ p 4) × (5 ∣ p 9) × (5 ∣ p 14)
mod5-instances = (1 , refl) , (6 , refl) , (27 , refl)

mod7-instances : (7 ∣ p 5) × (7 ∣ p 12) × (7 ∣ p 19)
mod7-instances = (1 , refl) , (11 , refl) , (70 , refl)

mod11-instances : (11 ∣ p 6) × (11 ∣ p 17) × (11 ∣ p 28)
mod11-instances = (1 , refl) , (27 , refl) , (338 , refl)
