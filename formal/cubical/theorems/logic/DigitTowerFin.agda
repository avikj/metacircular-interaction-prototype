{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- Diagnostic companion to `DigitTowerLimit`.
--
-- That module carries an explicit implementation boundary: Agda 2.8 warns
-- that its definitions "will not compute when applied to transports",
-- because matching on `Vec Digit (suc n)` relies on injectivity of `suc`
-- and `zero` as index constructors, which Cubical Agda does not support.
-- `codex-catuskoti` retained the warning rather than suppressing it (F39),
-- which was right.
--
-- This module tests whether that boundary belongs to the *mathematics* or
-- to the *vocabulary*.  It restates the same carry obstruction with digit
-- words presented as functions `Fin n → Digit` instead of as an indexed
-- inductive `Vec`.  A function type has no index to match on, so if the
-- warning is a Vec artefact it must disappear here while the statements
-- proved stay the same.
--
-- Result: it disappears.  This file typechecks under `--safe` with **zero**
-- `UnsupportedIndexedMatch` warnings, and proves the same two facts:
-- deleting the least-significant digit is not additive at base two, while
-- the same deletion is exactly a homomorphism for carry-free XOR.
--
-- Scope, stated so this is not over-read: this is a diagnosis of one
-- warning, not a port of `DigitTowerLimit`.  The inverse limit, the
-- reversal equivalence `MSDLimit ≃ LSDLimit`, and the transported law are
-- NOT reproduced here, and the interesting question — whether the full
-- equivalence also becomes transport-computable in this presentation — is
-- open.  See §"What this does not show" in the accompanying message.

module DigitTowerFin where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (Bool ; false ; true ; _⊕_)
open import Cubical.Data.Bool.Properties using (true≢false)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Fin using (Fin ; fzero ; fsuc ; fone)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- Digit words as functions out of a finite index.
------------------------------------------------------------------------

-- Little-endian: index 0 is the least significant digit.
W : Type ℓ → ℕ → Type ℓ
W A n = Fin n → A

-- Deleting the least-significant digit is precomposition with `fsuc`.
-- No pattern match on any index occurs, here or anywhere below.
dropLSD : {A : Type ℓ} (n : ℕ) → W A (suc n) → W A n
dropLSD n w i = w (fsuc i)

------------------------------------------------------------------------
-- Base two, two digits.
------------------------------------------------------------------------

and : Bool → Bool → Bool
and false _ = false
and true  b = b

-- Little-endian addition modulo four: the second digit receives the carry.
add₂ : W Bool 2 → W Bool 2 → W Bool 2
add₂ x y i = ((x i) ⊕ (y i)) ⊕ carryInto i
  where
    carryInto : Fin 2 → Bool
    carryInto j = and (and (x fzero) (y fzero)) (isSecond j)
      where
        -- `isSecond` is decided by the underlying natural number, never by
        -- matching on the index of a family.
        isSecond : Fin 2 → Bool
        isSecond (0 , _) = false
        isSecond (suc _ , _) = true

xor₂ : W Bool 2 → W Bool 2 → W Bool 2
xor₂ x y i = (x i) ⊕ (y i)

one₂ : W Bool 2
one₂ (0 , _) = true
one₂ (suc _ , _) = false

------------------------------------------------------------------------
-- The obstruction, and its control.
------------------------------------------------------------------------

-- One digit of output; addition on it is bare XOR, with no room for carry.
addBit : W Bool 1 → W Bool 1 → W Bool 1
addBit x y i = (x i) ⊕ (y i)

-- At base two, 1 + 1 = 2.  Deleting the least-significant digit *after*
-- adding returns 1; deleting first returns 0 ⊕ 0 = 0.
dropLSD-not-additive-base2
  : ¬ (dropLSD 1 (add₂ one₂ one₂) ≡ addBit (dropLSD 1 one₂) (dropLSD 1 one₂))
dropLSD-not-additive-base2 p = true≢false (λ i → p i fzero)

-- Planted opposite: end deletion is not itself the obstruction.  Without
-- carry the same projection is exactly a homomorphism.
dropLSD-xor-hom-base2
  : (x y : W Bool 2)
  → dropLSD 1 (xor₂ x y) ≡ addBit (dropLSD 1 x) (dropLSD 1 y)
dropLSD-xor-hom-base2 x y = refl
