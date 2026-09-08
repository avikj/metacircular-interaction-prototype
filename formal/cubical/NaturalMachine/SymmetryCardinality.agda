{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.SymmetryCardinality where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Nat
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.FinSet
open import Cubical.Data.FinSet.Constructors using (isFinSetAut)
open import Cubical.Data.FinSet.Cardinality
-- ~~`factorial` is used unqualified below.  In cubical v0.9 it arrives
-- with this module; in the pinned v0.5 it lives in
-- Cubical.Data.Fin.LehmerCode and Cardinality only refers to it
-- qualified (LehmerCode.factorial), so the unqualified use fails with
-- "Not in scope: factorial".  Importing it by its own path names the
-- same function on both versions and picks no side of the skew --
-- the same treatment NaturalMachine/PathIsSymmetry.agda gives SymGroup.
-- open import Cubical.Data.Fin.LehmerCode using (factorial)~~
-- (v0.5 skew note withdrawn: cubical 2.8 moved `factorial` to Cubical.Data.Nat,
-- where `factorial = _!` definitionally, so no LehmerCode bridge is needed.)
--
-- AND THE WITHDRAWAL WAS NEVER APPLIED TO THE CODE.  The note above says the
-- bridge is not needed; the import stayed anyway, and at the pin it does not
-- name anything:
--
--   warning: -W[no]ModuleDoesntExport
--   The module Cubical.Data.Fin.LehmerCode doesn't export the following:
--     factorial
--
-- A `using (…)` naming something the module does not export is a WARNING, not
-- an error: the name is silently not brought into scope, and the build goes on.
-- So a correction written as prose beneath the line it corrects left the line
-- doing nothing, said so, and nothing failed.  Struck and removed 2026-09-08.
--
-- `factorial` now comes from `Cubical.Data.Nat` (line 7, already open), which
-- re-exports Cubical.Data.Nat.Properties where `_! factorial : ℕ → ℕ` and
-- `factorial = _!` -- the same function, one import, no skew to pick a side of.

open import NaturalMachine.Decategorification using (𝔽)

-- The finite carrier of the loop symmetries at the canonical n-element set.
-- Decategorification.FinSetLoop≃Sym identifies this carrier with the loop
-- space; this adapter compiles its size to the arithmetic certificate n!.
-- (No speed claim: `_!_` is the naive recursive factorial and the corpus has
-- no cost model — see CountedDigits' cost boundary.)
symmetryCarrier : ℕ → FinSet ℓ-zero
symmetryCarrier n = (Fin n ≃ Fin n) , isFinSetAut (𝔽 n)

symmetryCount : ℕ → ℕ
symmetryCount n = card (symmetryCarrier n)

-- cardAut computes the automorphism count as factorial; this and the
-- Data.Nat factorial _!_ are the same function by structural induction (they are
-- propositionally, not definitionally, equal for a variable argument).
factorial≡! : (n : ℕ) → factorial n ≡ n !
factorial≡! zero = refl
factorial≡! (suc n) = cong (suc n ·_) (factorial≡! n)

symmetryCount≡factorial : (n : ℕ) → symmetryCount n ≡ n !
symmetryCount≡factorial n = cardAut (𝔽 n) ∙ factorial≡! n
