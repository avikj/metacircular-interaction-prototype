{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Control.WrongFirstStep
--
-- *** THIS FILE MUST FAIL TO TYPE-CHECK. ***
--
-- Designed annihilation (collab/PROTOCOL.md §7), in the pattern of
-- `NaturalMachine/Control/WrongEquivalence.agda`: the statement below is
-- FALSE, and the point of the file is to exhibit that the type-checker
-- catches it rather than waving it through.
--
-- WHAT IT ASSERTS.  `CompileBridge.first-step-names-resume` is `refl`:
-- on the concrete task `taskTm` over the concrete `baseVocab`, the
-- loop's own step function reduces to an obstruction whose residual is
-- `resumeCap`.  This file asserts the same thing at `tickCap` — a
-- capability that IS installed in `baseVocab`, so the first step cannot
-- name it.
--
-- WHY IT MUST FAIL.  `ResidualIs s V t (generative-step V t)` unfolds,
-- on this instance, to the equation `resumeCap ≡ s`, i.e. `0 ≡ 1` for
-- `s = tickCap`.  If `refl` inhabited `ResidualIs` for an ARBITRARY
-- capability, then G1's `refl` would be the empty kind of `refl` and
-- would certify nothing about which head the step named.  This control
-- is what rules that reading out: G1 is a computation with a specific
-- answer, not a type that any `refl` satisfies.
--
-- It is NOT part of the checked build.  `NaturalMachine.agda` does not
-- import it, and nothing else may: the directory
-- `NaturalMachine/Control/` is excluded from the root aggregate exactly
-- so that its contents are allowed to fail.
--
-- OBSERVED, 2026-08-13, pinned toolchain of `formal/cubical/BUILD.md`
-- (Agda 2.6.3 + cubical v0.5), `agda NaturalMachine/Control/WrongFirstStep.agda`,
-- exit code 42, error verbatim (preceded only by the pre-existing
-- `PayloadMorphism` pattern-matching warnings, which are unrelated):
--
--   /home/user/math/formal/cubical/NaturalMachine/Control/WrongFirstStep.agda:59,25-29
--   0 != 1 of type Agda.Builtin.Nat.Nat
--   when checking that the expression refl has type
--   ResidualIs tickCap baseVocab taskTm
--   (generative-step baseVocab taskTm)
--
-- If a future edit makes this file compile, `CompileBridge`'s §G1 is
-- vacuous and its claim that the FIRST step names the missing capability
-- is broken.
------------------------------------------------------------------------

module NaturalMachine.Control.WrongFirstStep where

open import Cubical.Foundations.Prelude

open import NaturalMachine.GenerativeLoop using (generative-step)
open import NaturalMachine.CompileBridge
  using (ResidualIs ; tickCap ; baseVocab ; taskTm)

wrong-step-names-tick :
  ResidualIs tickCap baseVocab taskTm (generative-step baseVocab taskTm)
wrong-step-names-tick = refl
