{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.RadiusTransferCompiler where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Data.Nat.Order using (_<_ ; _≤_ ; <-trans)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)

-- The prime-pair predicate is a parameter.  This module proves the transfer
-- compiler, not a new prime theorem and not an inhabitant of any edge.
module _ (PP : ℕ → ℕ → Type₀) where

  Unbounded : ℕ → Type₀
  Unbounded radius =
    (threshold : ℕ) → Σ[ center ∈ ℕ ] (threshold < center) × PP center radius

  record BoundedEdge (source target : ℕ) : Type₀ where
    field
      bound : ℕ → ℕ
      advances : (center : ℕ) → PP center source
        → Σ[ later ∈ ℕ ]
            (center < later) × (later ≤ bound center) × PP later target

  open BoundedEdge

  -- Factory III, Theorem 41: a bounded edge transports recurrence.  The
  -- finite window is retained in the edge even though unboundedness itself
  -- only consumes strict forward progress.
  edge-transports-unbounded : {source target : ℕ}
    → BoundedEdge source target → Unbounded source → Unbounded target
  edge-transports-unbounded edge recurrent threshold =
    later , <-trans threshold<center center<later , target-pair
    where
      source-witness = recurrent threshold
      center = fst source-witness
      threshold<center = fst (snd source-witness)
      source-pair = snd (snd source-witness)

      transferred = advances edge center source-pair
      later = fst transferred
      center<later = fst (snd transferred)
      target-pair = snd (snd (snd transferred))

  -- A path is proof-relevant: every hop contains its independently checked
  -- bound and arithmetic transfer theorem.
  data TransferPath : ℕ → ℕ → Type₀ where
    at-target : {radius : ℕ} → TransferPath radius radius
    _then_ : {source middle target : ℕ}
      → BoundedEdge source middle
      → TransferPath middle target
      → TransferPath source target

  infixr 20 _then_

  path-transports-unbounded : {source target : ℕ}
    → TransferPath source target → Unbounded source → Unbounded target
  path-transports-unbounded at-target recurrent = recurrent
  path-transports-unbounded (edge then rest) recurrent =
    path-transports-unbounded rest
      (edge-transports-unbounded edge recurrent)

  -- Published bounded gaps is consumed only through this exact interface:
  -- some recurrent radius in the closed band 1..123.  No particular seed
  -- radius is assumed or selected by the compiler.
  BoundedGapSeed₁₂₃ : Type₀
  BoundedGapSeed₁₂₃ =
    Σ[ radius ∈ ℕ ] (1 ≤ radius) × (radius ≤ 123) × Unbounded radius

  -- The nontrivial Theta-fiber: not reachability as a Boolean, but an actual
  -- bounded proof path from every admissible seed radius to radius one.
  RadiusTransferFabric₁₂₃ : Type₀
  RadiusTransferFabric₁₂₃ =
    (radius : ℕ) → 1 ≤ radius → radius ≤ 123
    → TransferPath radius 1

  -- Factory III, Theorems 42 and 48.  Once the bounded-gap seed and the
  -- proof-relevant fabric are supplied, the compiler produces recurrence of
  -- radius one.  With PP instantiated as prime-pair witnesses, this is the
  -- twin-prime consequence.  This file supplies neither input.
  compile-radius-transfer :
    BoundedGapSeed₁₂₃ → RadiusTransferFabric₁₂₃ → Unbounded 1
  compile-radius-transfer (radius , lower , upper , recurrent) fabric =
    path-transports-unbounded (fabric radius lower upper) recurrent

