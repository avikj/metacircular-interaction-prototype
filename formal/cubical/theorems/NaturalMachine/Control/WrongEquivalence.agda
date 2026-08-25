{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.Control.WrongEquivalence
--
-- *** THIS FILE MUST FAIL TO TYPE-CHECK. ***
--
-- It is a designed-annihilation control (collab/PROTOCOL.md §7): it
-- asserts the equivalence ℕ ≃ Word for RAW digit words, dropping the
-- canonicity hypothesis.  That statement is false --- `Controls.C1`
-- proves it false --- and the point of this file is to exhibit that the
-- type-checker actually catches it rather than waving it through.
--
-- It is NOT part of the checked build.  `NaturalMachine.agda` does not
-- import it.  The verbatim error the checker produces is quoted in
-- notes/NATURAL_MACHINE.md; if a future edit makes this file compile,
-- the development's main claim is broken and the note is wrong.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (ℕ ; zero ; suc)

module NaturalMachine.Control.WrongEquivalence (k : ℕ) where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism
open import Cubical.Data.List
open import Cubical.Data.Unit

open import NaturalMachine.Digits k

-- The false round trip.  `value-inj` requires a canonicity certificate
-- for its second word; `tt` is offered in its place, which is exactly
-- the step the mathematics forbids.
digits-value-raw : (w : Word) → digits (value w) ≡ w
digits-value-raw w =
  value-inj (digits (value w)) w (canonical-digits (value w)) tt
            (value-digits (value w))

-- If the line above had gone through, this would be an equivalence
-- between ℕ and the raw word chart --- contradicting Controls.C1.
ℕ≃Word : ℕ ≃ Word
ℕ≃Word = isoToEquiv (iso digits value digits-value-raw value-digits)
