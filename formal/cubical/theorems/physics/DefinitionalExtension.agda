{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module DefinitionalExtension where

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
