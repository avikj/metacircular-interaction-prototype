{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Control.QuantifierDrop
--
-- *** THIS FILE MUST FAIL TO TYPE-CHECK. ***
--
-- Designed annihilation (collab/PROTOCOL.md §7), in the pattern of
-- `Control/WrongEquivalence.agda` and `Control/WrongFirstStep.agda`.
--
-- WHAT IT ASSERTS.  The line-world corollary of
-- `notes/ENCOUNTERED_WORLDS.md:121-124` — "`E` transports iff
-- `s != -1 (mod p)`" — QUANTIFIED OVER ALL OBSERVABLES, which is how the
-- summary message `workers/20260812T090934.276887Z--claude_ananta--0005.md`
-- §5 restates it after dropping the note's two words "For `f = X+Y`"
-- under a Theorem stated for every integral `f`
-- (`notes/FULL_READ_DRAW_5.md` §C2).
--
-- WHY IT MUST FAIL.  The corollary is a computation about `grad f`, and
-- `grad (X+Y)|_L (t) = t(1+s)` while `grad X|_L (t) = t`.  For `f = X`
-- every line world transports, at `s = -1` included, so the biconditional
-- is false there.  `LineWorldTransport.dropped-hypothesis-false` derives
-- ⊥ from precisely the type asserted below, so this file cannot compile
-- unless the model is inconsistent.
--
-- The two proofs offered are the two ways the drop actually happens in
-- prose: (a) hand the general statement the proof of the special one,
-- (b) claim the general statement computes.
--
-- This is the instrument for a defect with NO LEXICAL SIGNATURE: the
-- false sentence contains no wrong word, only a missing one, so grep
-- cannot see it and a type can.
--
-- It is NOT part of the checked build.  `NaturalMachine.agda` does not
-- import it, and nothing else may: the directory `NaturalMachine/Control/`
-- is excluded from the root aggregate exactly so its contents may fail.
--
-- OBSERVED, 2026-08-15, pinned toolchain of `formal/cubical/BUILD.md`
-- (Agda 2.6.3 + cubical v0.5),
-- `LC_ALL=C.UTF-8 agda NaturalMachine/Control/QuantifierDrop.agda`,
-- exit code 42, error verbatim (module prefixes as printed):
--
--   /home/user/math/formal/cubical/NaturalMachine/Control/QuantifierDrop.agda:80,26-41
--   NaturalMachine.LineWorldTransport.rollover
--   (NaturalMachine.LineWorldTransport.val s Agda.Builtin.Nat.+
--    (0 Agda.Builtin.Nat.* NaturalMachine.LineWorldTransport.val s))
--   (NaturalMachine.LineWorldTransport.mod5
--    (NaturalMachine.LineWorldTransport.val s Agda.Builtin.Nat.+
--     (0 Agda.Builtin.Nat.* NaturalMachine.LineWorldTransport.val s)))
--   !=
--   NaturalMachine.LineWorldTransport.mod5
--   (NaturalMachine.LineWorldTransport.c₁ f Agda.Builtin.Nat.+
--    (NaturalMachine.LineWorldTransport.c₂ f Agda.Builtin.Nat.*
--     NaturalMachine.LineWorldTransport.val s))
--   of type Agda.Builtin.Nat.Nat
--   when checking that the expression line-world-XY s has type
--   transports f s ≡ crit s
--
-- Read it: the checker refuses to identify the gradient of an ARBITRARY
-- observable, `c₁ f + c₂ f · s`, with the gradient of `X+Y`, `1 + s`.
-- That is the dropped hypothesis, named by the machine.  (Agda stops at
-- the first error, so the second assertion,
-- `quantifier-dropped-by-computation`, is not reached; it fails the same
-- way — with `f` a variable, `transports f s` does not reduce and `refl`
-- is rejected.)
--
-- If a future edit makes this file compile, the line-world corollary has
-- been silently generalized past its hypothesis and the corpus has
-- readmitted exactly the defect `FULL_READ_DRAW_5` §C2 catalogued.
------------------------------------------------------------------------

module NaturalMachine.Control.QuantifierDrop where

open import Cubical.Foundations.Prelude

open import NaturalMachine.LineWorldTransport
  using (Obs ; X ; X+Y ; Slope ; transports ; crit ; line-world-XY)

quantifier-dropped : (f : Obs) (s : Slope) → transports f s ≡ crit s
quantifier-dropped f s = line-world-XY s

quantifier-dropped-by-computation :
  (f : Obs) (s : Slope) → transports f s ≡ crit s
quantifier-dropped-by-computation f s = refl
