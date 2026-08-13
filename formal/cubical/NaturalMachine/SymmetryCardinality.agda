{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.SymmetryCardinality where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Nat
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.FinSet
open import Cubical.Data.FinSet.Constructors using (isFinSetAut)
open import Cubical.Data.FinSet.Cardinality
import Cubical.Data.Fin.LehmerCode as LehmerCode

open import NaturalMachine.Decategorification using (𝔽)

-- The finite carrier of the loop symmetries at the canonical n-element set.
-- Decategorification.FinSetLoop≃Sym identifies this carrier with the loop
-- space; this adapter compiles its size to the fast arithmetic certificate n!.
symmetryCarrier : ℕ → FinSet ℓ-zero
symmetryCarrier n = (Fin n ≃ Fin n) , isFinSetAut (𝔽 n)

symmetryCount : ℕ → ℕ
symmetryCount n = card (symmetryCarrier n)

-- cardAut computes the automorphism count as LehmerCode.factorial; this and the
-- Data.Nat factorial _!_ are the same function by structural induction (they are
-- propositionally, not definitionally, equal for a variable argument).
factorial≡! : (n : ℕ) → LehmerCode.factorial n ≡ n !
factorial≡! zero = refl
factorial≡! (suc n) = cong (suc n ·_) (factorial≡! n)

symmetryCount≡factorial : (n : ℕ) → symmetryCount n ≡ n !
symmetryCount≡factorial n = cardAut (𝔽 n) ∙ factorial≡! n
