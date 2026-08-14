{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.BehavioralHankel
--
-- A finite past/future cut for DSO.  The random walk anchor was a long
-- decimal stream; its exact content is used only as a reminder that a
-- boundary can have many observations.  The checked core below deliberately
-- keeps the cut finite: past and future are Bool, and the matrix is the
-- identity Cost relation.  The point is the semantic seam, not a census of
-- the stream.
------------------------------------------------------------------------

module NaturalMachine.BehavioralHankel where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; false ; true)
open import Cubical.Data.Nat using (zero)
open import Cubical.Data.Sigma using (Σ ; _,_)
open import Cubical.Data.Empty using (⊥)
open import NaturalMachine.DSOContinuationFullAbstract

Past Future : Type₀
Past = Bool
Future = Bool

-- Finite behavioral Hankel cut: entry is the cost of matching the future
-- continuation at this cut.  Off-diagonal entries are unreachable (∞).
behavioralHankel : Past → Future → Cost
behavioralHankel = identity

-- The cut has an exact two-state realization: the intermediate state is the
-- future boundary itself.  This is the finite rank upper bound witnessed by
-- the identity factorization.
hankel-factor : (a : Past) (c : Future)
  → (identity ⋆ identity) a c ≡ behavioralHankel a c
hankel-factor a c = cong (λ r → r a c) (⋆-identity-right identity) ∙ refl

-- Dirac continuations expose each behavioral entry; hence a contextual
-- transformer cannot silently identify the two future states.
hankel-context-separates : (a c : Bool)
  → bellman behavioralHankel (dirac c) a ≡ behavioralHankel a c
hankel-context-separates = dirac-reconstruct behavioralHankel

-- Context changes the active dependency.  Under the zero-at-false terminal,
-- false is the local choice, while the continuation-aware value selects the
-- true branch for the planted finite control.
contextual-active-false : Argmin Kᵉ (λ _ → fin zero) false
contextual-active-false = local-active

contextual-active-true : Argmin Kᵉ (bellman Lᵉ terminalFalse) false
contextual-active-true = global-active

active-mode-changes :
  (Argmin.witness contextual-active-false
    ≡ Argmin.witness contextual-active-true) → ⊥
active-mode-changes = active-witnesses-differ

-- A finite observation therefore certifies only the selected cut semantics;
-- it does not assert a converse for arbitrary weighted automata.
