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
-- Execute the already-checked positional-numeral machine by counting.
--
-- This module adds no second evaluator and no scheduler.  `digitsC` is the
-- existing encoder, `sucC` is the existing schoolbook carry transition, and
-- `valueC` is the existing decoder.  The equations below close their native
-- execution triangle over literal successor on ℕ.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (ℕ ; zero ; suc)

module NaturalMachine.CountedDigits (k : ℕ) where

open import Cubical.Foundations.Prelude
open import NaturalMachine.Digits k
open import NaturalMachine.Transport k using (sucC)
import NaturalMachine.CountedExecution as Counted

-- The complete state includes both the digit word and its canonicity proof.
run : ℕ → CanWord
run = Counted.run (digitsC zero) sucC

-- Counting once executes one native carry transition.  This is definitional:
-- `digits` itself was defined by iteration of the checked odometer `sucw`.
run-suc : (n : ℕ) → run (suc n) ≡ sucC (run n)
run-suc = Counted.run-suc (digitsC zero) sucC

-- The generic counted execution is exactly the pre-existing digit generator;
-- this is an instantiation theorem, not an alternative implementation.
run-is-digitsC : (n : ℕ) → run n ≡ digitsC n
run-is-digitsC zero = refl
run-is-digitsC (suc n) = cong sucC (run-is-digitsC n)

-- Decoding an executed state returns exactly the count that produced it.
observe-run : (n : ℕ) → valueC (run n) ≡ n
observe-run n = cong valueC (run-is-digitsC n) ∙ value-digits n

-- The operational square: one native digit transition is observed as literal
-- successor.  This reuses `value-sucw`; there is no external branch choice.
observe-step : (state : CanWord) → valueC (sucC state) ≡ suc (valueC state)
observe-step (word , canonical) = value-sucw word

-- Hence the encoded successor orbit and the native carry orbit coincide.
counting-executes-carry : (n : ℕ) →
  valueC (sucC (run n)) ≡ suc n
counting-executes-carry n = observe-step (run n) ∙ cong suc (observe-run n)

-- Cost boundary.  `sucw` performs real recursive carry propagation, but the
-- imported development proves semantic equations, not a work measure for that
-- recursion.  This module therefore makes no constant-cost claim and does not
-- hide digit encoding/decoding work inside the equivalence.  A costed execution
-- edge remains open until a native carry-cost theorem is installed.
