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

------------------------------------------------------------------------
-- NaturalMachine.Controls
--
-- Designed annihilation (collab/PROTOCOL.md §7, msg 0073).
--
-- A claim ships with the apparatus that would destroy it.  The three
-- controls for this development are:
--
--   C1 (here)  the canonicity hypothesis is LOAD-BEARING: without it
--              `value` is not injective, so the equivalence fails.
--              Proved, not asserted.
--
--   C2 (here)  a deliberately WRONG reading of the digit chart --- the
--              big-endian misreading, `value ∘ rev` --- fails its round
--              trip.  Proved as a refutation, so the failure is itself
--              machine-checked.
--
--   C3 (separate, and deliberately NOT part of the checked build)
--              `NaturalMachine/Control/WrongEquivalence.agda` asserts
--              the equivalence ℕ ≃ Word without canonicity.  It must
--              FAIL to type-check.  See notes/NATURAL_MACHINE.md for the
--              verbatim error the checker produces.
--
-- A fourth control is the type-checker itself: every module carries
-- --safe, and the postulate/hole audit is recorded in the note.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (ℕ ; zero ; suc)

module NaturalMachine.Controls (k : ℕ) where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Fin using (fzero ; fone ; toℕ)
open import Cubical.Data.List
open import Cubical.Data.Sigma
open import Cubical.Data.Unit
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.Digits k
open import NaturalMachine.Endian k using (w01 ; w01-canonical ; v1 ; value-v1)

------------------------------------------------------------------------
-- C1.  Canonicity is load-bearing.
--
-- Drop it and `value` stops being injective: the empty word and the
-- one-digit word 0 are different words with the same value.  So the
-- specific pair (digits, value) is not an equivalence ℕ ≃ Word — the
-- bare type ℕ ≃ Word is inhabited (Word is countably infinite), but
-- not by these maps — and the CanWord equivalence is not a formality.
-- (Correction per notes/NATURALMACHINE_CLAIM_AUDIT.md: the earlier
-- wording asserted `ℕ ≃ Word` itself is false, which C1 does not prove.)
------------------------------------------------------------------------

value-not-injective-on-Word :
  Σ[ u ∈ Word ] Σ[ v ∈ Word ] ((value u ≡ value v) × (¬ (u ≡ v)))
value-not-injective-on-Word =
  [] , (fzero ∷ []) , (0≡m·0 b , λ p → znots (cong length p))

-- Equivalently: the round trip that holds on canonical words fails on
-- general words.
no-raw-round-trip : ¬ ((w : Word) → digits (value w) ≡ w)
no-raw-round-trip h = znots (cong length (sym step ∙ h (fzero ∷ [])))
  where
    step : digits (value (fzero ∷ [])) ≡ []
    step = cong digits (sym (0≡m·0 b))

------------------------------------------------------------------------
-- C2.  The big-endian misreading fails its round trip.
--
-- Reading a little-endian word as if it were big-endian is exactly
-- `value ∘ rev`.  If that were the right chart map, `digits` would
-- invert it.  It does not, and 0 ∷ 1 witnesses the failure.
------------------------------------------------------------------------

wrong-endian-round-trip-fails :
  ¬ ((w : Word) → Canonical w → digits (value (rev w)) ≡ w)
wrong-endian-round-trip-fails h = znots (injSuc (cong length chain))
  where
    -- `rev w01 = 1 ∷ 0`, whose value is 1, whose digits are the
    -- one-digit word `1`, while w01 has length 2.
    chain : (fone ∷ []) ≡ w01
    chain = sym (cong digits value-v1) ∙ h w01 w01-canonical
