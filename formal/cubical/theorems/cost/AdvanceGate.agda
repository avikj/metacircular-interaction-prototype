{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- Advance(◇_α) ⟺ Verify ∧ SearchSep ∧ PreserveProv ∧ UsefulEscape>0 ∧ Boundary
--
-- The gate, as a record whose fields are the five clauses, with the two
-- clauses that are not formalizable here (provenance, declared boundary)
-- carried as explicit propositions the caller must supply rather than
-- silently assumed.  Two theorems:
--
--   advance-forces-distinction   the gate implies the test set separates
--   advance-forces-progress      UsefulEscape>0 is exactly ϱ ≢ 0, and that
--                                forces a strictly cheaper presentation
--
-- and one non-theorem, exhibited:  δ = 0 ⇏ Advance.

module AdvanceGate where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Nat.Order using (_<_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Maybe using (just)
open import Cubical.Relation.Nullary using (¬_)

open import CostGeometry
open import Residual
open import ChuAdvance

record Advance (X T : Type₀) (Prov Boundary : Type₀) : Type₁ where
  constructor advance
  field
    -- SearchSep : the declared tests still tell the points apart
    tests       : List T
    obs         : Obs X T
    searchSep   : Separates obs tests
    -- UsefulEscape > 0 : the residual is nonzero, i.e. the branch is ↝
    from to     : Presentation
    bridge      : Bridge from to
    wHere wThere : Work
    usefulEscape : respond (just bridge) wHere wThere ≡ ↝
    -- Verify / PreserveProv / DeclaredBoundaryPreserved
    verified    : Prov
    boundary    : Boundary

open Advance public

advance-forces-distinction :
    {X T Prov Boundary : Type₀} (a : Advance X T Prov Boundary)
  → Separates (obs a) (tests a)
advance-forces-distinction a = searchSep a

advance-forces-progress :
    {X T Prov Boundary : Type₀} (a : Advance X T Prov Boundary)
  → wThere a < wHere a
advance-forces-progress a =
  ↝-forces-better-presentation (bridge a) (wHere a) (wThere a) (usefulEscape a)

-- δ = 0 ⇏ Advance : the empty test list gives a defect-free configuration
-- that cannot be promoted, because the gate's separation clause fails.
defect-zero-does-not-advance :
    ¬ ((e : Obs Bool Bool) (ts : List Bool)
       → ((x y : Bool) → Agree e ts x y)
       → Separates e ts)
defect-zero-does-not-advance f =
  snd (snd (snd zero-defect-is-not-truth))
      (f (fst zero-defect-is-not-truth) (fst (snd zero-defect-is-not-truth))
         (fst (snd (snd zero-defect-is-not-truth))))

-- CHECKED: Agda 2.6.3, cubical **v0.7** (/tmp/cubical), --cubical --safe,
-- 2026-08-15.  No postulates, no holes.  NOT verified against the pin in
-- formal/cubical/BUILD.md (Agda 2.8.0, cubical v0.9), nor against the v0.5
-- the rest of this lane's headers quote: three toolchain states are live in
-- this repository at once and this file has only seen one of them.
