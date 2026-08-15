{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.FiniteOccupancyChannelNoGo
--
-- A four-site calibration for the difference between a symmetric occupancy
-- summary and a distinguished local channel.  The two configurations 1010
-- and 1100 have the same Hamming weight and the same total number of occupied
-- unordered pairs, but only the latter occupies an adjacent pair.
--
-- This is finite-information geometry only.  It makes no statement about
-- Maynard weights, primes, or an analytic transfer estimate.
------------------------------------------------------------------------

module NaturalMachine.FiniteOccupancyChannelNoGo where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; false ; true ; false≢true)
open import Cubical.Data.Nat using (ℕ ; _+_)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.FiniteInformation
  using (FactorsThrough ; FiberConstant ; factorsThrough→fiberConstant)

record Occupancy₄ : Type₀ where
  constructor occupancy
  field
    site₀ site₁ site₂ site₃ : Bool

open Occupancy₄ public

asNat : Bool → ℕ
asNat false = 0
asNat true  = 1

bothNat : Bool → Bool → ℕ
bothNat true true = 1
bothNat _    _    = 0

both : Bool → Bool → Bool
both true true = true
both _    _    = false

or : Bool → Bool → Bool
or false false = false
or _     _     = true

hammingWeight : Occupancy₄ → ℕ
hammingWeight x =
  asNat (site₀ x) + asNat (site₁ x)
    + asNat (site₂ x) + asNat (site₃ x)

-- The symmetric two-body energy: the number of occupied unordered pairs.
totalPairEnergy : Occupancy₄ → ℕ
totalPairEnergy x =
  bothNat (site₀ x) (site₁ x) +
  bothNat (site₀ x) (site₂ x) +
  bothNat (site₀ x) (site₃ x) +
  bothNat (site₁ x) (site₂ x) +
  bothNat (site₁ x) (site₃ x) +
  bothNat (site₂ x) (site₃ x)

-- The distinguished channel asks whether any consecutive sites are jointly
-- occupied.  It is intentionally not permutation invariant.
adjacentGapChannel : Occupancy₄ → Bool
adjacentGapChannel x =
  or (both (site₀ x) (site₁ x))
    (or (both (site₁ x) (site₂ x))
        (both (site₂ x) (site₃ x)))

pattern1010 pattern1100 : Occupancy₄
pattern1010 = occupancy true false true false
pattern1100 = occupancy true true false false

same-weight : hammingWeight pattern1010 ≡ hammingWeight pattern1100
same-weight = refl

same-total-pair-energy :
  totalPairEnergy pattern1010 ≡ totalPairEnergy pattern1100
same-total-pair-energy = refl

different-adjacent-channel :
  ¬ (adjacentGapChannel pattern1010 ≡ adjacentGapChannel pattern1100)
different-adjacent-channel = false≢true

SymmetricSummary : Type₀
SymmetricSummary = ℕ × ℕ

symmetricSummary : Occupancy₄ → SymmetricSummary
symmetricSummary x = hammingWeight x , totalPairEnergy x

same-symmetric-summary :
  symmetricSummary pattern1010 ≡ symmetricSummary pattern1100
same-symmetric-summary = refl

-- FiniteInformation's descent criterion says a decoder exists only if the
-- target is constant on every summary fiber.  The displayed collision is an
-- exact obstruction to that constancy.
adjacent-not-weight-fiber-constant :
  ¬ FiberConstant hammingWeight adjacentGapChannel
adjacent-not-weight-fiber-constant constant =
  different-adjacent-channel (constant pattern1010 pattern1100 same-weight)

no-adjacent-decoder-from-weight :
  ¬ FactorsThrough hammingWeight adjacentGapChannel
no-adjacent-decoder-from-weight factors =
  adjacent-not-weight-fiber-constant
    (factorsThrough→fiberConstant hammingWeight adjacentGapChannel factors)

adjacent-not-symmetric-summary-fiber-constant :
  ¬ FiberConstant symmetricSummary adjacentGapChannel
adjacent-not-symmetric-summary-fiber-constant constant =
  different-adjacent-channel
    (constant pattern1010 pattern1100 same-symmetric-summary)

no-adjacent-decoder-from-weight-and-total-pair-energy :
  ¬ FactorsThrough symmetricSummary adjacentGapChannel
no-adjacent-decoder-from-weight-and-total-pair-energy factors =
  adjacent-not-symmetric-summary-fiber-constant
    (factorsThrough→fiberConstant
      symmetricSummary adjacentGapChannel factors)
