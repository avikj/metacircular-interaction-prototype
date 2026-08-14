{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.RewriteCertificate where

open import Cubical.Foundations.Prelude

data Tm : Type₀ where
  var  : Tm
  zero : Tm
  suc  : Tm → Tm
  add  : Tm → Tm → Tm

data Step : Tm → Tm → Type₀ where
  add-zero : (x : Tm) → Step (add x zero) x
  add-suc  : (x y : Tm) → Step (add x (suc y)) (suc (add x y))
  suc-step : {x y : Tm} → Step x y → Step (suc x) (suc y)
  add-left : {x y : Tm} → Step x y → (z : Tm) → Step (add x z) (add y z)
  add-right : (z : Tm) → {x y : Tm} → Step x y → Step (add z x) (add z y)

data Derivation : Tm → Tm → Type₀ where
  done : (x : Tm) → Derivation x x
  then-step : {x y z : Tm} → Step x y → Derivation y z → Derivation x z

accepted : Derivation (add var (suc zero)) (suc var)
accepted =
  then-step (add-suc var zero)
    (then-step (suc-step (add-zero var)) (done (suc var)))
