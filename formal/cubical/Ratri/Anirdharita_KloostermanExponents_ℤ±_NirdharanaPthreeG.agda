{-# OPTIONS --cubical --safe --guardedness #-}
module Ratri.Anirdharita_KloostermanExponents_ℤ±_NirdharanaPthreeG where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Bool
open import Cubical.Data.Empty
open import KloostermanExponents

censusR0 censusR1 : ℤ±
censusR0 = record { up = 0 ; dn = 0 }
censusR1 = record { up = 0 ; dn = 1 }

censusAgree-0 : ℤ±.up censusR0 ≡ ℤ±.up censusR1
censusAgree-0 = refl

-- THE VERDICT.  Green here means the field is NOT determined:
-- two inhabitants agree on every other field and are distinct.
NOT-DETERMINED : censusR0 ≡ censusR1 → ⊥
NOT-DETERMINED censusP = znots (cong ℤ±.dn censusP)
