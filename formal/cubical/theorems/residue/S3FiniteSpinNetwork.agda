{-# OPTIONS --cubical --safe #-}

-- Concrete finite-set calibration of AbstractSpinNetworkKinematics using the
-- natural S₃-action on Fin 3.  This is only equivariant finite-set data: no
-- linear carrier, tensor product, Hilbert space, SU(2), or spin label.

module S3FiniteSpinNetwork where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Data.SumFin using (fzero ; isSetFin)
open import Cubical.Algebra.Group.Properties using (module GroupTheory)
import Cubical.Data.Prod as P

open import StabilizerTorsor using (Action)
open Action
open import AbstractSpinNetworkKinematics
open Intertwiner
open import ParallelNetworkComposition
  using (parallelIntertwiner ; parallelRefinement ; contract-parallel
        ; canonical-refinement-parallel)
open import FiniteNonabelianHolonomy
open import S3ConjugacyObservation using (mulApply)

-- The library symmetric-group multiplication is composition in the order
-- opposite to the Action record's convention.  Acting by the inverse gives
-- the honest left action required by that record.
naturalFin3Action : Action S₃ Fin3
isSetX naturalFin3Action = isSetFin
_▸_ naturalFin3Action g x = (S.inv g) .fst x
▸-1g naturalFin3Action x =
  cong (λ e → e .fst x) (ST.inv1g)
▸-· naturalFin3Action g h x =
    cong (λ e → e .fst x) (ST.invDistr g h)
  ∙ mulApply (S.inv h) (S.inv g) x

unitAction : Action S₃ Unit
isSetX unitAction = isSetUnit
_▸_ unitAction g x = tt
▸-1g unitAction x = refl
▸-· unitAction g h x = refl

identityVertex : Intertwiner S₃ naturalFin3Action naturalFin3Action
identityVertex = idIntertwiner S₃ naturalFin3Action

-- A genuinely non-identity equivariant vertex: forget the transitive S₃-set
-- to the terminal S₃-set.  Equivariance is computational.
terminalVertex : Intertwiner S₃ naturalFin3Action unitAction
map terminalVertex x = tt
equivariant terminalVertex g x = refl

terminalVertex-nonidentity : map terminalVertex fzero ≡ tt
terminalVertex-nonidentity = refl

-- Canonical bivalent subdivision contracts back to the same concrete map.
terminalSubdivision = subdivideIntertwiner S₃ terminalVertex

terminalSubdivision-contract : (x : Fin3)
  → map (contract S₃ terminalSubdivision) x ≡ map terminalVertex x
terminalSubdivision-contract = contract-subdivide S₃ terminalVertex

-- Two disjoint copies use the already checked cartesian parallel semantics.
-- The parallel map forgets both Fin3 coordinates, with no tensor claim.
parallelTerminal = parallelIntertwiner S₃ terminalVertex terminalVertex

parallelTerminal-computes : (x y : Fin3)
  → map parallelTerminal (x , y) ≡ (tt , tt)
parallelTerminal-computes x y = refl

parallelTerminalSubdivision =
  parallelRefinement S₃ terminalSubdivision terminalSubdivision

parallel-contracts-componentwise : (x y : Fin3)
  → map (contract S₃ parallelTerminalSubdivision) (x , y)
    ≡ map parallelTerminal (x , y)
parallel-contracts-componentwise x y =
  contract-parallel S₃ terminalSubdivision terminalSubdivision (x , y)

parallel-canonical-refinement : (x y : Fin3)
  → map (contract S₃
      (parallelRefinement S₃
        (subdivideIntertwiner S₃ terminalVertex)
        (subdivideIntertwiner S₃ terminalVertex))) (x , y)
    ≡ map parallelTerminal (x , y)
parallel-canonical-refinement x y =
  canonical-refinement-parallel S₃ terminalVertex terminalVertex (x , y)
