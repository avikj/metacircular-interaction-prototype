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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.DefinitionalExtension where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat

-- A1 of notes/RUNTIME_TO_CUBICAL_MIGRATION.md: in the proof language,
-- definitional extension is judgmental.  Introducing a named definition
-- and unfolding it is δ-reduction, so the "unfold and recheck" theorem
-- is refl and conservativity is the theory's construction — there is no
-- separate re-verifier to trust.  This module is the entire content of
-- runtime/vocabulary's seven-gate apparatus on the checked side.

sqr : ℕ → ℕ
sqr n = n · n

-- Elimination: the new vocabulary unfolds to the base signature, at
-- every argument, judgmentally.
unfold-sqr : (n : ℕ) → sqr n ≡ n · n
unfold-sqr n = refl

-- Use-then-eliminate: any theorem stated through the new name is a
-- theorem of the base signature by the same reduction.
sqr-suc : (n : ℕ) → sqr (suc n) ≡ suc (n + n · suc n)
sqr-suc n = refl
