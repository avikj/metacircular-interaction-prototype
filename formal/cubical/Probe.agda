{-# OPTIONS --cubical --safe --no-import-sorts #-}
module Probe where
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Vec.Base using (Vec; []; _∷_)

vhead : {m : ℕ} → Vec ℕ (suc m) → ℕ
vhead (a ∷ _) = a

vtail : {m : ℕ} → Vec ℕ (suc m) → Vec ℕ m
vtail (_ ∷ v) = v

single : {m : ℕ} → Vec ℕ m → ℕ
single [] = 0
single (a ∷ v) = a + single v
