{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DifferenceBasinCompiler
--
-- A proof-relevant compiler for the Factory IV difference-basin route.
-- The inherited 721-point / Delta-star theorem is represented only by an
-- input record returning a positive recurrent pair difference.  No inhabitant
-- of that record, no proof of Huang--Wu, and no prime theorem occurs here.
------------------------------------------------------------------------

module DifferenceBasinCompiler where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Nat using (ℕ)

open import RadiusTransferCompiler

-- `difference i j` is the declared positive-difference coordinate attached
-- to an ordered pair of the 721 finite points.  Positivity is kept as a
-- separate witness relation: the compiler never infers it from indices.
module _
  (PairWitness : ℕ → ℕ → Type₀)
  (difference : Fin 721 → Fin 721 → ℕ)
  (PositiveDifference : ℕ → Type₀)
  where

  open Compiler PairWitness

  -- Exact interface consumed from the inherited Delta-star result: some
  -- ordered pair supplies a positive difference whose witness column recurs.
  -- This record is intentionally uninhabited in this module.
  record InheritedΔ⋆ : Type₀ where
    constructor delta-star
    field
      left right : Fin 721
      positive : PositiveDifference (difference left right)
      recurrent : Recurrence (difference left right)

  open InheritedΔ⋆ public

  -- A basin is proof-relevant membership of a difference in the declared
  -- finite transfer domain.  The pair-coverage input states that every
  -- positive pair difference returned from the 721-point chart lies in it.
  Basin : Type₁
  Basin = ℕ → Type₀

  PairDifferenceBasinCoverage : Basin → Type₀
  PairDifferenceBasinCoverage basin =
    (i j : Fin 721)
    → PositiveDifference (difference i j)
    → basin (difference i j)

  -- Each basin witness must carry an actual recurrence-transfer path, not a
  -- Boolean reachability assertion.  Every edge inside the path retains the
  -- bound and forward witness required by RadiusTransferCompiler.
  BasinTransferFabric : Basin → Type₀
  BasinTransferFabric basin =
    (d : ℕ) → basin d → ComposedPath d 1

  -- Factory IV consequence.  Delta-star recurrence enters the basin through
  -- the supplied membership proof and is transported along the supplied
  -- proof-relevant path to radius one.
  compile-difference-basin :
    (basin : Basin)
    → InheritedΔ⋆
    → PairDifferenceBasinCoverage basin
    → BasinTransferFabric basin
    → Recurrence 1
  compile-difference-basin basin seed covers fabric =
    path-recurrence route (recurrent seed)
    where
    d : ℕ
    d = difference (left seed) (right seed)

    membership : basin d
    membership = covers (left seed) (right seed) (positive seed)

    route : ComposedPath d 1
    route = fabric d membership

-- The only checked content is the consequence compiler.  In particular,
-- `InheritedΔ⋆`, basin coverage, and the transfer fabric remain explicit
-- obligations for analytic number theory.
