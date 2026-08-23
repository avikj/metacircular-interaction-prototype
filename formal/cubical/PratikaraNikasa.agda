{-# OPTIONS --cubical --safe --no-import-sorts #-}
module PratikaraNikasa where
open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
twice : {A : Type} → (A → A) → A → A
twice f = f ∘ f
