{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.SymmetryCardinality where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Nat
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.FinSet
open import Cubical.Data.FinSet.Constructors using (isFinSetAut)
open import Cubical.Data.FinSet.Cardinality
open import Cubical.Data.Fin.LehmerCode using (factorial)
-- (Drift repair, cf-corner 2026-08-14: the line above restores the v0.5
-- name — `cardAut` returns `LehmerCode.factorial`, and the withdrawn-skew
-- comment that replaced this import was written against cubical 2.8, where
-- `factorial` moved to Data.Nat. Under the canonical v0.5 toolchain the
-- LehmerCode bridge IS needed, and `factorial≡!` below is that bridge.)

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
