{-# OPTIONS --cubical --safe --guardedness #-}
module Ratri.Anirdharita_EGBDetConservation_UT_NirdharanaPthreeC where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Bool
open import Cubical.Data.Empty
open import EGB.DetConservation

censusR0 censusR1 : UT
censusR0 = record { a = 0 ; b = 0 ; d = 0 }
censusR1 = record { a = 0 ; b = 0 ; d = 1 }

censusAgree-0 : UT.a censusR0 ≡ UT.a censusR1
censusAgree-0 = refl

censusAgree-1 : UT.b censusR0 ≡ UT.b censusR1
censusAgree-1 = refl

-- THE VERDICT.  Green here means the field is NOT determined:
-- two inhabitants agree on every other field and are distinct.
NOT-DETERMINED : censusR0 ≡ censusR1 → ⊥
NOT-DETERMINED censusP = znots (cong UT.d censusP)
