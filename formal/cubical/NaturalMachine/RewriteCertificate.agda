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
  reverse : {x y : Tm} → Step x y → Step y x

data Derivation : Tm → Tm → Type₀ where
  done : (x : Tm) → Derivation x x
  then-step : {x y z : Tm} → Step x y → Derivation y z → Derivation x z

subst : Tm → Tm → Tm
subst u var = u
subst u zero = zero
subst u (suc t) = suc (subst u t)
subst u (add l r) = add (subst u l) (subst u r)

-- A rewrite system parameterized by exactly one induction hypothesis.
-- The hypothesis is conclusion-indexed and may be used under contexts.
data HypStep (ihL ihR : Tm) : Tm → Tm → Type₀ where
  lift-step : {x y : Tm} → Step x y → HypStep ihL ihR x y
  hypothesis : HypStep ihL ihR ihL ihR
  reverse-hypothesis : HypStep ihL ihR ihR ihL
  hyp-suc : {x y : Tm} → HypStep ihL ihR x y
          → HypStep ihL ihR (suc x) (suc y)
  hyp-add-left : {x y : Tm} → HypStep ihL ihR x y → (z : Tm)
               → HypStep ihL ihR (add x z) (add y z)
  hyp-add-right : (z : Tm) → {x y : Tm} → HypStep ihL ihR x y
                → HypStep ihL ihR (add z x) (add z y)

data HypDerivation (ihL ihR : Tm) : Tm → Tm → Type₀ where
  hyp-done : (x : Tm) → HypDerivation ihL ihR x x
  hyp-then : {x y z : Tm} → HypStep ihL ihR x y
           → HypDerivation ihL ihR y z → HypDerivation ihL ihR x z

record InductionCertificate (lhs rhs : Tm) : Type₀ where
  field
    base : Derivation (subst zero lhs) (subst zero rhs)
    step : HypDerivation lhs rhs
      (subst (suc var) lhs) (subst (suc var) rhs)

accepted : Derivation (add var (suc zero)) (suc var)
accepted =
  then-step (add-suc var zero)
    (then-step (suc-step (add-zero var)) (done (suc var)))
