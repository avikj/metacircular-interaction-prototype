{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.DSOFinite
--
-- A finite, checked core for Dependent System Optimization.  The point is
-- not a general extended-real library: it is the exact counterexample that
-- local argmin selection can destroy a cheaper composed continuation.
------------------------------------------------------------------------

module NaturalMachine.DSOFinite where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; false ; true)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Order using (_<_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma

Architecture : Type₀
Architecture = Bool

Realization : Architecture → Type₀
Realization false = Unit
Realization true  = Unit

Design : Type₀
Design = Σ[ architecture ∈ Architecture ] Realization architecture

-- A finite cost relation and its continuation transformer.
CostRelation : Type₀
CostRelation = Bool → Bool → ℕ

Continuation : Type₀
Continuation = Bool → ℕ

min₂ : ℕ → ℕ → ℕ
min₂ zero n = zero
min₂ (suc m) zero = zero
min₂ (suc m) (suc n) = suc (min₂ m n)

bellman : CostRelation → Continuation → Bool → ℕ
bellman K V a =
  min₂ (K a false + V false) (K a true + V true)

compose : CostRelation → CostRelation → CostRelation
compose K L a c =
  min₂ (K a false + L false c) (K a true + L true c)

-- The first subsystem locally prefers false: 0 < 1.
K : CostRelation
K false false = 0
K false true  = 1
K true  false = 3
K true  true  = 3

-- The continuation makes true the globally useful interface.
L : CostRelation
L false false = 2
L false true  = 2
L true  false = 0
L true  true  = 0

target : Continuation
target false = 0
target true  = 0

local-prefers-false : K false false < K false true
local-prefers-false = zero , refl

composite-via-false : K false false + L false false ≡ 2
composite-via-false = refl

composite-via-true : K false true + L true false ≡ 1
composite-via-true = refl

composite-value : compose K L false false ≡ 1
composite-value = refl

-- The exact DSO lesson: the isolated argmin is false, but the composed
-- continuation is strictly improved by retaining the locally nonminimal true
-- interface.  Replacing K by its isolated argmin loses the optimum.
premature-argmin-unsound : compose K L false false < 2
premature-argmin-unsound = zero , refl

continuation-value : bellman K target false ≡ 0
continuation-value = refl

-- A dependent architecture point carries both the architecture and its
-- realization; flattening it would erase the fiber boundary.
design-false : Design
design-false = false , tt

design-true : Design
design-true = true , tt
