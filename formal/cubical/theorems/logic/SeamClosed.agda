{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SeamClosed — the flagship residual, proved, from the machine's own
-- discarded work.
--
-- THE CLAIM THIS FILE SETTLES.  `interactive/Obstruction.hs` opens by quoting the
-- refusal that the whole obstruction seam was built around:
--
--     x != x + 0 · x  of type ℕ   when checking that refl has type x ≡ 1 · x
--
-- That residual — `x ≡ x + 0 · x` — was harvested 27 times across 239 rounds
-- traces why: it reduces, modulo `0 · x = 0`, to `x + 0 ≡ x`, which is a
-- DEFINING EQUATION of the machine's `+` (which recurses on the second
-- argument) and a non-trivial induction for Agda's (which recurses on the
-- first).  The machine drops it as an axiom; the kernel cannot proceed without
-- it.  Both are right.  The lemma sat unproved in the seam for the machine's
-- entire recorded history.
--
-- AND IT WAS PROVED ALL ALONG.  `MathMachine.tryReplay` calls
-- `TraceReplay.replayWithRules`, which returns a complete Agda module; the
-- kernel checks it; the machine writes the words "trace replay" to the log and
-- DISCARDS THE SOURCE.  That path is 820 of 2362 `KERNEL-ACCEPT` lines.  As of
-- 2026-08-18 the source is kept (`historical/machine-runs/replay.traces`), and every one of
-- the 17 records a three-round run produced contains, verbatim:
--
--     addZero : (a : ℕ) → (a + zero) ≡ a
--     addZero zero = refl
--     addZero (suc a) = cong suc (addZero a)
--
-- So the machine has been proving the missing lemma, in Agda, by induction,
-- inside every replayed module, and throwing it away — while a different part
-- of the same program recorded a demand for it, 27 times.
--
-- WHAT IS BELOW.  `addZero` transcribed verbatim from `historical/machine-runs/replay.traces`
-- (record 1, lines 6–8), and then the flagship residual discharged with it.
-- Nothing here is invented: the lemma is the machine's own text, and the
-- residual is the kernel's own words.
--
-- WHAT THIS IS NOT.  It is not the seam repaired.  Repairing it means wiring
-- `interactive/KernelContext.hs` to read `replay.traces` so that EVERY goal can
-- cite these lemmas, and that is not done here.  This file shows the gap is
-- one of plumbing rather than of mathematics: the proof exists, on disk, in
-- the machine's own hand.
------------------------------------------------------------------------

module SeamClosed where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_)

------------------------------------------------------------------------
-- 1.  Transcribed verbatim from historical/machine-runs/replay.traces, record 1, lines 6–8.
--     Not rewritten, not tidied: this is what the machine emitted and the
--     kernel accepted, 820 times, before anyone kept a copy.
------------------------------------------------------------------------

addZero : (a : ℕ) → (a + zero) ≡ a
addZero zero = refl
addZero (suc a) = cong suc (addZero a)

------------------------------------------------------------------------
-- 2.  THE FLAGSHIP RESIDUAL, closed.
--
-- `0 · x` reduces to `zero` definitionally in Agda — `_·_` recurses on its
-- first argument, `zero · m = zero` — so `x + 0 · x` is `x + zero` and the
-- residual is exactly `addZero` read backwards.  One `sym`.
--
-- That is the whole of what the seam was missing for 239 rounds.
------------------------------------------------------------------------

flagshipResidual : (x : ℕ) → x ≡ x + zero · x
flagshipResidual x = sym (addZero x)

------------------------------------------------------------------------
-- 3.  AND THE PARENT IT WAS STALLING, closed by the same lemma.
--
-- The goal the kernel refused was `x ≡ 1 · x`.  Agda unfolds `1 · x` to
-- `x + 0 · x`, which is where it stopped.  With the residual in hand the
-- parent is immediate — which is the property `Obstruction.hs`'s header
-- claims for a residual ("prove `x + 0 · x ≡ x` and the parent closes") and
-- which nothing in the corpus had ever exhibited.
------------------------------------------------------------------------

parentClosed : (x : ℕ) → x ≡ (suc zero) · x
parentClosed x = flagshipResidual x

------------------------------------------------------------------------
-- 4.  The other zero-law the census demands most, from the same trace.
--     `0 = y · 0` unblocks 18 distinct goals — the top of the curriculum.
------------------------------------------------------------------------

mulZero : (a : ℕ) → (a · zero) ≡ zero
mulZero zero = refl
mulZero (suc a) = mulZero a

topOfCurriculum : (y : ℕ) → zero ≡ y · zero
topOfCurriculum y = sym (mulZero y)
