{-# OPTIONS --cubical --safe --guardedness #-}
module Ratri.Anirdharita_NaturalMachine-FiniteOccupancyChannelNoGo_Occupancy₄_NirdharanaPthreeL where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Bool
open import Cubical.Data.Empty
open import NaturalMachine.FiniteOccupancyChannelNoGo

censusR0 censusR1 : Occupancy₄
censusR0 = record { site₀ = true ; site₁ = true ; site₂ = true ; site₃ = true }
censusR1 = record { site₀ = true ; site₁ = true ; site₂ = false ; site₃ = true }

censusAgree-0 : Occupancy₄.site₀ censusR0 ≡ Occupancy₄.site₀ censusR1
censusAgree-0 = refl

censusAgree-1 : Occupancy₄.site₁ censusR0 ≡ Occupancy₄.site₁ censusR1
censusAgree-1 = refl

censusAgree-2 : Occupancy₄.site₃ censusR0 ≡ Occupancy₄.site₃ censusR1
censusAgree-2 = refl

-- THE VERDICT.  Green here means the field is NOT determined:
-- two inhabitants agree on every other field and are distinct.
NOT-DETERMINED : censusR0 ≡ censusR1 → ⊥
NOT-DETERMINED censusP = true≢false (cong Occupancy₄.site₂ censusP)
