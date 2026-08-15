{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Control.MaximizerWithoutNonvanishing
--
-- *** THIS FILE MUST FAIL TO TYPE-CHECK. ***
--
-- Designed annihilation (collab/PROTOCOL.md §7), in the pattern of
-- `Control/WrongEquivalence.agda`, `Control/WrongFirstStep.agda`,
-- `Control/QuantifierDrop.agda` and `Control/InflationFlattened.agda`.
--
-- WHAT IT ASSERTS.  The finite no-go of `notes/ENCOUNTERED_WORLDS.md`
-- §2 — "every finite `E` **with `f != 0` on `E`** has a point that
-- fails to transport: any point maximizing `v_p(f)`" — WITHOUT the
-- nonvanishing clause, which is how the summary message
-- `workers/20260812T090934.276887Z--claude_ananta--0005.md` §3 restates
-- it: "every finite `E` has a point that cannot transport — any
-- maximizer of `v_p(f)`" (`notes/FULL_READ_DRAW_5.md` §C1).
--
-- WHY IT MUST FAIL.  The dropped clause is what makes "the maximizer"
-- denote.  On the model of `NaturalMachine.FiniteWorldMaximizer` the
-- maximizer is produced from a world AND a certificate that the
-- observable is nowhere zero on it; the degenerate world `f ≡ 0` has no
-- such certificate (`vanishing-has-no-certificate`), so a maximizer
-- taking the world alone cannot be built.  Note the difference from
-- `Control/QuantifierDrop.agda`: THERE the dropped hypothesis leaves a
-- false statement, HERE it leaves an ill-formed one, and the checker
-- catches ill-formedness as a missing argument rather than as a refuted
-- equation.  That is the honest strength of this control and no more.
--
-- The two assertions are the two ways the drop happens in prose:
-- (a) invoke the theorem at a world with no nonvanishing hypothesis,
-- (b) claim the hypothesis is free — that every world satisfies it.
--
-- This is the instrument for a defect with NO LEXICAL SIGNATURE: the
-- shortened sentence contains no wrong word, only a missing clause, so
-- grep cannot see it and a type can.
--
-- It is NOT part of the checked build.  `NaturalMachine.agda` does not
-- import it, and nothing else may: the directory `NaturalMachine/Control/`
-- is excluded from the root aggregate exactly so its contents may fail.
--
-- OBSERVED, 2026-08-15, container toolchain (Agda 2.6.3 + cubical v0.5;
-- `formal/cubical/BUILD.md` pins 2.8.0 + v0.9, check OUTSTANDING),
-- `LC_ALL=C.UTF-8 agda NaturalMachine/Control/MaximizerWithoutNonvanishing.agda`,
-- exit code 42, error verbatim:
--
--   /home/user/math/formal/cubical/NaturalMachine/Control/MaximizerWithoutNonvanishing.agda:70,26-39
--   (q : Pt) → IsFin (W q) !=< Σ-syntax Pt (IsMax W ?h)
--   when checking that the expression maximizer W has type
--   Σ-syntax Pt (IsMax W ?h)
--
-- Read it: the checker reports that what `maximizer W` still wants is
-- `(q : Pt) → IsFin (W q)` — the dropped clause "`f != 0` on `E`",
-- written out, and it cannot even guess it (`?h`).  The machine names
-- the missing hypothesis literally.
--
-- (Agda stops at the first error, so the second assertion,
-- `every-world-nonvanishing`, is not reached.  Checked separately by
-- commenting out the first (same file, two lines commented out, then
-- restored): it fails at 76,32-34 with
--   ⊥ !=< Unit
--   when checking that the expression tt has type
--   IsFin (vanishing-world q)
-- — the world where the observable vanishes identically cannot be
-- given the certificate, which is exactly the case the clause excludes.)
--
-- If a future edit makes this file compile, the finite no-go has been
-- silently extended past its nonvanishing hypothesis and the corpus has
-- readmitted exactly the defect `FULL_READ_DRAW_5` §C1 catalogued.
------------------------------------------------------------------------

module NaturalMachine.Control.MaximizerWithoutNonvanishing where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax)
open import Cubical.Data.Unit using (tt)

open import NaturalMachine.FiniteWorldMaximizer
  using (World ; Pt ; IsFin ; IsMax ; NonVanishing ; maximizer
        ; vanishing-world)

-- (a) The theorem invoked with the clause dropped.
maximizer-dropped : (W : World) → Σ[ m ∈ Pt ] IsMax W {!!} m
maximizer-dropped W = maximizer W

-- (b) The clause claimed to be free.
every-world-nonvanishing : NonVanishing vanishing-world
every-world-nonvanishing q = tt
