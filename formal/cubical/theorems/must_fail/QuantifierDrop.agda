{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- QuantifierDrop
--
-- *** THIS FILE MUST FAIL TO TYPE-CHECK. ***
--
-- Designed annihilation (collab/PROTOCOL.md §7), in the pattern of
-- `Control/WrongEquivalence.agda` and `Control/WrongFirstStep.agda`.
--
-- WHAT IT ASSERTS.  The line-world corollary of
-- `s != -1 (mod p)`" — QUANTIFIED OVER ALL OBSERVABLES, which is how the
-- summary message `workers/20260812T090934.276887Z--claude_ananta--0005.md`
-- §5 restates it after dropping the note's two words "For `f = X+Y`"
-- under a Theorem stated for every integral `f`
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
-- It is NOT part of the checked build.  `agda` does not
-- import it, and nothing else may: the directory `NaturalMachine/Control/`
-- is excluded from the root aggregate exactly so its contents may fail.
--
-- OBSERVED, 2026-08-15, pinned toolchain of `formal/cubical/BUILD.md`
-- (Agda 2.6.3 + cubical v0.5),
--
-- [CORRECTION ADDED 2026-08-15, Claude (header-claim audit); the line
--  above stands as the dated record and this is appended to it.  THAT
--  ATTRIBUTION IS WRONG, and wrong in the direction that matters:
--  `formal/cubical/BUILD.md` does NOT pin 2.6.3 + v0.5.  It pins
--  **Agda 2.8.0 + cubical v0.9** (BUILD.md:116-117, 125-129), and its
--  §"Version-skew notes (v0.9 migration, 2026-08-14)" records 2.6.3 +
--  v0.5 as the FORMER pin, migrated away from.  2.6.3 + v0.5 is the
--  CONTAINER toolchain, which BUILD.md itself flags as skewed from the
--  pin (BUILD.md:242).  Its three sibling controls
--  (`InflationFlattened`, `MaximizerWithoutNonvanishing`,
--  `ReachabilityWithoutStart`) each label the same numbers correctly —
--  as "container toolchain … BUILD.md pins 2.8.0 + v0.9, check
--  OUTSTANDING" or as "THE PIN (2.8.0 + v0.9)".  So: the exit-42
--  observation below is real and was made on the CONTAINER; it is NOT a
--  pin observation, and this file's designed failure remains
--  **unverified under Agda 2.8.0 + cubical v0.9**.  That matters for a
--  control specifically: a file that must fail could fail here for a
--  version-skew reason and compile under the pin, which is the one
--  outcome the control exists to detect.
--
--  PIN CHECK: NOT OUTSTANDING — it was already done, by someone else,
--  before I wrote this block, and I found it only by looking.
--  2026-08-15, Agda 2.8.0 + cubical v0.9, LC_ALL=C.UTF-8, exit codes
--  produced in-container by that author) records this file at EXIT=42
--  failing at **80.26-41** with `rollover (val s + 0 · val s) != mod5 …`
--  — the same line and the same [UnequalTerms] site as the container
--  run quoted above.  So the control is sound under BOTH toolchains and
--  fails for the intended mathematical reason under each.  Only the
--  ATTRIBUTION above was wrong; the observation was right and the
--  conclusion it supports is now doubly grounded.  I did not re-run
--  either toolchain: this container is 2.6.3 and I am quoting that
--  note, with its author named, not verifying it.
--
--  No term or assertion in this file is changed.
--
-- `LC_ALL=C.UTF-8 agda NaturalMachine/Control/QuantifierDrop.agda`,
-- exit code 42, error verbatim (module prefixes as printed):
--
--   /home/user/math/formal/cubical/NaturalMachine/Control/QuantifierDrop.agda:80,26-41
--   LineWorldTransport.rollover
--   (LineWorldTransport.val s Agda.Builtin.Nat.+
--    (0 Agda.Builtin.Nat.* LineWorldTransport.val s))
--   (LineWorldTransport.mod5
--    (LineWorldTransport.val s Agda.Builtin.Nat.+
--     (0 Agda.Builtin.Nat.* LineWorldTransport.val s)))
--   !=
--   LineWorldTransport.mod5
--   (LineWorldTransport.c₁ f Agda.Builtin.Nat.+
--    (LineWorldTransport.c₂ f Agda.Builtin.Nat.*
--     LineWorldTransport.val s))
--   of type Agda.Builtin.Nat.Nat
--   when checking that the expression line-world-XY s has type
--   transports f s ≡ crit s
--
-- Read it: the checker holds the gradient of an ARBITRARY observable,
-- `c₁ f + c₂ f · s`, apart from the gradient of `X+Y`, `1 + s`.
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

module QuantifierDrop where

open import Cubical.Foundations.Prelude

open import LineWorldTransport
  using (Obs ; X ; X+Y ; Slope ; transports ; crit ; line-world-XY)

quantifier-dropped : (f : Obs) (s : Slope) → transports f s ≡ crit s
quantifier-dropped f s = line-world-XY s

quantifier-dropped-by-computation :
  (f : Obs) (s : Slope) → transports f s ≡ crit s
quantifier-dropped-by-computation f s = refl
