-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- A finite, checked DSO seam extracted from the random byte anchor in
-- `notes/RESEARCH_SYSTEM.md` (offset 8522): a local choice is not safe to
-- erase until its continuation has been observed.
--
-- This is deliberately a two-point natural-number model.  It does not claim
-- a quantale theorem, an infinite infimum, or an optimizer for live systems.

module NaturalMachine.DSOBellmanFinite where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Bool using (Bool ; false ; true)

-- The finite intermediate boundary.
min₂ : ℕ → ℕ → ℕ
min₂ zero    n       = zero
min₂ (suc m) zero    = zero
min₂ (suc m) (suc n) = suc (min₂ m n)

-- Bellman continuation over the two possible intermediate witnesses.
bellman : (Bool → ℕ) → ℕ
bellman V = min₂ (zero + V true) (suc (V false))

-- K is the first open subsystem: true is locally cheaper than false.
K : Bool → ℕ
K true  = zero
K false = suc zero

-- L is the continuation: true is unusable, while false is free.
L : Bool → ℕ
L true  = suc (suc zero)
L false = zero

-- The direct composite cost is infimal composition K ⋆ L, evaluated at the
-- unique input/output boundary.  The chosen intermediate false wins only
-- after continuation is included.
composite : ℕ
composite = min₂ (K true + L true) (K false + L false)

-- Bellman evaluation of the continuation relation reproduces the composite.
continuation-evaluation : bellman (λ b → L b) ≡ composite
continuation-evaluation = refl

-- The isolated local argmin (true) is not composable: its continuation cost
-- is finite here, but the general obstruction is visible as the strict cost
-- gap between the two continuation-adjusted witnesses.
true-route : K true + L true ≡ suc (suc zero)
true-route = refl

false-route : K false + L false ≡ suc zero
false-route = refl

-- The globally selected witness is false, despite K false > K true.
global-route : composite ≡ suc zero
global-route = refl

local-cheapest : K true ≡ zero
local-cheapest = refl
