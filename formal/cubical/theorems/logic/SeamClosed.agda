{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SeamClosed â” the flagship residual, proved, from the machine's own
-- discarded work.
--
-- THE CLAIM THIS FILE SETTLES.  `interactive/Obstruction.hs` opens by quoting the
-- obligation that the whole obstruction seam was built around:
--
--     x != x + 0 Â x  of type â•   when checking that refl has type x â‰¡ 1 Â x
--
-- That residual â” `x â‰¡ x + 0 Â x` â” was harvested 27 times across 239 rounds
-- traces why: it reduces, modulo `0 Â x = 0`, to `x + 0 â‰¡ x`, which is a
-- DEFINING EQUATION of the machine's `+` (which recurses on the second
-- argument) and a non-trivial induction for Agda's (which recurses on the
-- first).  The machine drops it as an axiom; the kernel cannot proceed without
-- it.  Both are right.
--
-- AND IT WAS PROVED ALL ALONG.  `MathMachine.tryReplay` calls
-- `TraceReplay.replayWithRules`, which returns a complete Agda module; the
-- kernel checks it; the machine writes the words "trace replay" to the log and
-- DISCARDS THE SOURCE.  The
-- source is kept in `interactive/replay.traces`, and every one of
-- the 17 records a three-round run produced contains, verbatim:
--
--     addZero : (a : â•) â’ (a + zero) â‰¡ a
--     addZero zero = refl
--     addZero (suc a) = cong suc (addZero a)
--
-- So the machine has been proving the missing lemma, in Agda, by induction,
-- inside every replayed module, and throwing it away â” while a different part
-- of the same program recorded a demand for it, 27 times.
--
-- WHAT IS BELOW.  `addZero` transcribed verbatim from `interactive/replay.traces`
-- (record 1, lines 6â“8), and then the flagship residual discharged with it.
-- Nothing here is invented: the lemma is the machine's own text, and the
-- residual is the kernel's own words.
--
------------------------------------------------------------------------

module SeamClosed where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; _Â·_)

------------------------------------------------------------------------
-- 1.  Transcribed verbatim from interactive/replay.traces, record 1, lines 6â“8.
--     Not rewritten, not tidied: this is what the machine emitted and the
--     kernel accepted, 820 times.
------------------------------------------------------------------------

addZero : (a : â„•) â†’ (a + zero) â‰¡ a
addZero zero = refl
addZero (suc a) = cong suc (addZero a)

------------------------------------------------------------------------
-- 2.  THE FLAGSHIP RESIDUAL, closed.
--
-- `0 Â x` reduces to `zero` definitionally in Agda â” `_Â_` recurses on its
-- first argument, `zero Â m = zero` â” so `x + 0 Â x` is `x + zero` and the
-- residual is exactly `addZero` read backwards.  One `sym`.
------------------------------------------------------------------------

flagshipResidual : (x : â„•) â†’ x â‰¡ x + zero Â· x
flagshipResidual x = sym (addZero x)

------------------------------------------------------------------------
-- 3.  AND THE PARENT IT WAS STALLING, closed by the same lemma.
--
-- The goal the kernel handed back was `x â‰¡ 1 Â x`.  Agda unfolds `1 Â x` to
-- `x + 0 Â x`, which is where it stopped.  With the residual in hand the
-- parent is immediate â” which is the property `Obstruction.hs`'s header
-- claims for a residual ("prove `x + 0 Â x â‰¡ x` and the parent closes").
------------------------------------------------------------------------

parentClosed : (x : â„•) â†’ x â‰¡ (suc zero) Â· x
parentClosed x = flagshipResidual x

------------------------------------------------------------------------
-- 4.  The other zero-law the census demands most, from the same trace.
--     `0 = y Â 0` unblocks 18 distinct goals â” the top of the curriculum.
------------------------------------------------------------------------

mulZero : (a : â„•) â†’ (a Â· zero) â‰¡ zero
mulZero zero = refl
mulZero (suc a) = mulZero a

topOfCurriculum : (y : â„•) â†’ zero â‰¡ y Â· zero
topOfCurriculum y = sym (mulZero y)
