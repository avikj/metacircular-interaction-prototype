{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Ananta
--
-- The obstruction-calculus stratum of the machine, as one gate.
--
-- WHY THIS FILE EXISTS.  Six modules were landed over two days and none of
-- them was imported by anything.  They typechecked individually and sat beside
-- the machine rather than inside it -- which is the exact pathology those
-- modules were written to diagnose: a gate that exists and is never fired.
-- Committing it while writing about it is worse, not better, so this is the
-- correction rather than a note about the correction.
--
-- `NaturalMachine.agda` also imports these now.  This file additionally exists
-- because the root gate does not currently check under the toolchain
-- `BUILD.md` pins (msg 0467, unresolved), so the root cannot serve as the
-- replay gate for this stratum.  Running
--
--     agda NaturalMachine/Ananta.agda
--
-- checks the whole stratum in one command, today, under Agda 2.6.3 + cubical
-- v0.5, with zero warnings and no postulates.
--
-- THE STRATUM, in dependency order:
--
--   SmithSignNormal     the sign-normalization functor: a Smith normal matrix
--                       is carried to its nonnegative representative by one
--                       involutive matrix of units.
--   SmithSignControl    the evaluations that found the defect, and the
--                       machine-checked refutation of nonnegativity.
--   ObstructionCalculus observation fields; Φ as widening; `Obs_𝒪 = 0 ⇏
--                       Obs_𝒪⁺ = 0`; no field is final; classify-then-repair;
--                       generability ≢ reconstructibility.
--   RepairGrading       Γ⇑ ≠ Γ↺ via S¹; χ = 1 for the sign defect, as a
--                       biconditional rather than a ratio.
--   AnswerGrading       Class is extra data; existence < universality, with
--                       the sign repair proved universal.
--   InabilityTower      ∂→δ→Γ on ℕ⊂ℤ; apoha closure; anekāntavāda.
------------------------------------------------------------------------

module NaturalMachine.Ananta where

open import NaturalMachine.SmithSignNormal public
open import NaturalMachine.SmithSignControl public
open import NaturalMachine.ObstructionCalculus public
open import NaturalMachine.RepairGrading public
open import NaturalMachine.AnswerGrading public
open import NaturalMachine.InabilityTower public
