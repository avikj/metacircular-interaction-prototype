{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.SymmetryCardinality where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Nat
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.FinSet
open import Cubical.Data.FinSet.Constructors using (isFinSetAut)
open import Cubical.Data.FinSet.Cardinality
-- (v0.5 skew note withdrawn: cubical 2.8 moved `factorial` to Cubical.Data.Nat,
-- where `factorial = _!` definitionally, so no LehmerCode bridge is needed.)

open import NaturalMachine.Decategorification using (𝔽)

-- The finite carrier of the loop symmetries at the canonical n-element set.
-- Decategorification.FinSetLoop≃Sym identifies this carrier with the loop
-- space; this adapter compiles its size to the arithmetic certificate n!.
-- (No speed claim: `_!_` is the naive recursive factorial and the corpus has
-- no cost model — see CountedDigits' cost boundary.)
symmetryCarrier : ℕ → FinSet ℓ-zero
symmetryCarrier n = (Fin n ≃ Fin n) , isFinSetAut (𝔽 n)

symmetryCount : ℕ → ℕ
symmetryCount n = card (symmetryCarrier n)

-- cardAut computes the automorphism count as factorial; this and the
-- Data.Nat factorial _!_ are the same function by structural induction (they are
-- propositionally, not definitionally, equal for a variable argument).
factorial≡! : (n : ℕ) → factorial n ≡ n !
factorial≡! zero = refl
factorial≡! (suc n) = cong (suc n ·_) (factorial≡! n)

symmetryCount≡factorial : (n : ℕ) → symmetryCount n ≡ n !
symmetryCount≡factorial n = cardAut (𝔽 n) ∙ factorial≡! n
