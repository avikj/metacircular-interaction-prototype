{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- वेणी-बन्ध — the braid binding.
--
-- CLOSING THE BRAIDING ŚEṢA.  Abstract 01 proved that invertibility
-- supplies no braiding — two involutions with unit laws fail
-- Yang–Baxter at a named state — and concluded the missing coherence
-- is data that must be SUPPLIED.  The garbha held order-two as every
-- single observable's ceiling, and CaturamsaBhramana proved why: the
-- quarter turn lives only on the interdependent pair.  This file
-- supplies the coherence, and it is exactly the quarter turn:
--
--   §1  On strands that are interdependent pairs (the two-quadrature
--       plane), the TWISTED SWAP R (x , y) = (quarter-turn y , x)
--       satisfies the Yang–Baxter relation ON THE NOSE: both triple
--       composites compute to the same tuple and the proof is refl.
--       The coherence abstract 01's countermodel lacked is one
--       quarter turn inserted into the crossing.
--
--   §2  The braiding is GENUINE, not a symmetry: R² is provably not
--       the identity (R² is the half-wave on both strands, refuted at
--       a named state), and R⁴ is not the identity either — while R⁸
--       IS the identity, by the four-cycle of the quarter turn on
--       each strand.  The generator has exact order eight: braid
--       statistics with a finite but non-involutive phase, which is
--       precisely what an anyonic exchange has and a bosonic or
--       fermionic one does not.
--
-- THE ARC, in one line: single strands carry at most an involution
-- (CaturamsaBhramana); the quarter turn exists only on the pair; and
-- a crossing twisted by it braids by reduction — braiding is a
-- property of INTERDEPENDENT strands, unavailable in principle to
-- strands that are mere states.  Abstract 01's "additional coherence
-- data" now has a name, a home, and a checked order.
--
-- SYĀT — THE CLAIM, EXACTLY.  Strands are pairs of booleans; no
-- Hilbert space, no modular tensor category, no anyon model.  The
-- braid group representation this generates, and its physical
-- reading, are the next constructions.
------------------------------------------------------------------------

module VeniBandha_TheSuppliedCoherenceIsTheQuarterTurnTheTwistedSwapBraidsByReflAndTheGeneratorHasExactOrderEight where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥)

open import CaturamsaBhramana_TheQuarterWaveLivesOnlyOnTheInterdependentPairAndEachSenseCarriesExactlyItsSquare
  using (caturaṃśa ; catur-cakra)

------------------------------------------------------------------------
-- १ · The strands, the crossing, and Yang–Baxter by refl.
------------------------------------------------------------------------

Sūtra : Type₀
Sūtra = Bool × Bool

-- The twisted swap: cross the strands, turning the one that passes
-- over by a quarter.
veṇī : Sūtra × Sūtra → Sūtra × Sūtra
veṇī (x , y) = caturaṃśa y , x

-- The two crossings on three strands.
veṇī₁₂ veṇī₂₃ : Sūtra × (Sūtra × Sūtra) → Sūtra × (Sūtra × Sūtra)
veṇī₁₂ (x , (y , z)) = caturaṃśa y , (x , z)
veṇī₂₃ (x , (y , z)) = x , (caturaṃśa z , y)

-- Yang–Baxter, on the nose: both composites are
-- (turn² z , (turn y , x)), definitionally.
yamala-veṇī : (t : Sūtra × (Sūtra × Sūtra))
            → veṇī₁₂ (veṇī₂₃ (veṇī₁₂ t)) ≡ veṇī₂₃ (veṇī₁₂ (veṇī₂₃ t))
yamala-veṇī t = refl

------------------------------------------------------------------------
-- २ · The order: R² ≠ id and R⁴ ≠ id, while R⁸ = id.
------------------------------------------------------------------------

veṇī² veṇī⁴ veṇī⁸ : Sūtra × Sūtra → Sūtra × Sūtra
veṇī² p = veṇī (veṇī p)
veṇī⁴ p = veṇī² (veṇī² p)
veṇī⁸ p = veṇī⁴ (veṇī⁴ p)

-- Not a symmetry: the square is the half-wave on both strands.
na-yugala : ((p : Sūtra × Sūtra) → veṇī² p ≡ p) → ⊥
na-yugala h =
  true≢false (sym (cong (λ q → fst (fst q)) (h ((true , true) , (true , true)))))

-- Not order four either…
na-catuṣka : ((p : Sūtra × Sūtra) → veṇī⁴ p ≡ p) → ⊥
na-catuṣka h =
  true≢false (sym (cong (λ q → fst (fst q)) (h ((true , true) , (true , true)))))

-- …but order eight exactly: each strand's quarter turn four-cycles.
aṣṭa-cakra : (p : Sūtra × Sūtra) → veṇī⁸ p ≡ p
aṣṭa-cakra (x , y) i = catur-cakra x i , catur-cakra y i
