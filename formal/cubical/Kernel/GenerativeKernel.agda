{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module Kernel.GenerativeKernel where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _∷_ ; map ; length)
open import Cubical.Data.Nat using (ℕ)

open import NaturalMachine.RewriteCertificate
open import NaturalMachine.ControlledGrammar

-- This is both formation state and executable branch. No certificate is
-- exported to a second language: operation, applicability, result, and the
-- derivation that computes it remain one typed object.
record Branch (seed : Tm) : Type₁ where
  field
    operation : NativeOperation
    control : NativeOperation.Control operation seed

  target : Tm
  target = NativeOperation.apply operation seed control

  history : Derivation seed target
  history = NativeOperation.apply-checked operation seed control

form-one : {seed : Tm} → EnabledFuture seed → Branch seed
Branch.operation (form-one f) = EnabledFuture.operation f
Branch.control (form-one f) = EnabledFuture.control f

-- The generative transformation is the checked program itself. Mapping keeps
-- order and multiplicity; no behavioral quotient is applied during search.
form : {seed : Tm} → List (EnabledFuture seed) → List (Branch seed)
form = map form-one

form-preserves-futures : {seed : Tm} (fs : List (EnabledFuture seed))
  → length (form fs) ≡ length fs
form-preserves-futures [] = refl
form-preserves-futures (f ∷ fs) = cong ℕ.suc (form-preserves-futures fs)

seed : Tm
seed = add var (suc zero)

target₀ : Tm
target₀ = suc var

direct-history : Derivation seed target₀
direct-history =
  then-step (add-suc var zero)
    (then-step (suc-step (add-zero var)) (done target₀))

-- Same endpoints, different computational history: move forward, reverse
-- that step, then take the direct derivation. Formation retains this route.
detour-history : Derivation seed target₀
detour-history =
  then-step (add-suc var zero)
    (then-step (reverse (add-suc var zero)) direct-history)

direct-operation detour-operation : NativeOperation
direct-operation = install direct-history
detour-operation = install detour-history

direct-future detour-future : EnabledFuture seed
EnabledFuture.operation direct-future = direct-operation
EnabledFuture.control direct-future = refl
EnabledFuture.operation detour-future = detour-operation
EnabledFuture.control detour-future = refl

run : List (Branch seed)
run = form (direct-future ∷ detour-future ∷ [])

-- Kernel execution exposes both futures and computes both targets, while
-- their proof-relevant histories remain fields of the two branch objects.
run-count : length run ≡ 2
run-count = refl

run-targets : map Branch.target run ≡ target₀ ∷ target₀ ∷ []
run-targets = refl
