{-# OPTIONS --cubical --safe --guardedness #-}
module Ratri.Anirdharita_VivekaPramana_TheUpadhiIsCarriedAsAFieldSoTheEquivalenceIsReal_विवेक_NirdharanaPthreeAD where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Bool
open import Cubical.Data.Empty
open import VivekaPramana_TheUpadhiIsCarriedAsAFieldSoTheEquivalenceIsReal

censusR0 censusR1 : विवेक
censusR0 = record { सम = 0 ; वाम = 0 ; दक्षिण = 0 }
censusR1 = record { सम = 0 ; वाम = 1 ; दक्षिण = 0 }

censusAgree-0 : विवेक.सम censusR0 ≡ विवेक.सम censusR1
censusAgree-0 = refl

censusAgree-1 : विवेक.दक्षिण censusR0 ≡ विवेक.दक्षिण censusR1
censusAgree-1 = refl

-- THE VERDICT.  Green here means the field is NOT determined:
-- two inhabitants agree on every other field and are distinct.
NOT-DETERMINED : censusR0 ≡ censusR1 → ⊥
NOT-DETERMINED censusP = znots (cong विवेक.वाम censusP)
