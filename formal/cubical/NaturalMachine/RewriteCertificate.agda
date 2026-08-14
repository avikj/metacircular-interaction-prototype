{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.RewriteCertificate where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-zero ; +-suc)

data Tm : Type₀ where
  var yvar zvar uvar vvar wvar : Tm
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

subVar : Tm → Tm → Tm
subVar u var = u
subVar u yvar = yvar
subVar u zvar = zvar
subVar u uvar = uvar
subVar u vvar = vvar
subVar u wvar = wvar
subVar u zero = zero
subVar u (suc t) = suc (subVar u t)
subVar u (add l r) = add (subVar u l) (subVar u r)

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
    base : Derivation (subVar zero lhs) (subVar zero rhs)
    step : HypDerivation lhs rhs
      (subVar (suc var) lhs) (subVar (suc var) rhs)

-- The executable meaning of the syntax.  `var` is interpreted by one
-- environment; the remaining constructors are the actual natural zero,
-- successor, and addition.  Keeping all six coordinates distinct matters:
-- identifying them would prove only equality on the diagonal.
record Env : Type₀ where
  constructor env
  field x y z u v w : ℕ

open Env

eval : Tm → Env → ℕ
eval var       ρ = x ρ
eval yvar      ρ = y ρ
eval zvar      ρ = z ρ
eval uvar      ρ = u ρ
eval vvar      ρ = v ρ
eval wvar      ρ = w ρ
eval zero      ρ = 0
eval (suc t)   ρ = suc (eval t ρ)
eval (add l r) ρ = eval l ρ + eval r ρ

-- Every certificate step preserves that meaning.  Therefore the Haskell
-- gate cannot install a rule merely because it inhabits an uninterpreted
-- rewrite calculus: its exact checked endpoints are pointwise equal on ℕ.
step-sound : {a b : Tm} → Step a b → (ρ : Env) → eval a ρ ≡ eval b ρ
step-sound (add-zero t)    ρ = +-zero (eval t ρ)
step-sound (add-suc l r)   ρ = +-suc (eval l ρ) (eval r ρ)
step-sound (suc-step p)    ρ = cong suc (step-sound p ρ)
step-sound (add-left p t)  ρ = cong (_+ eval t ρ) (step-sound p ρ)
step-sound (add-right t p) ρ = cong (eval t ρ +_) (step-sound p ρ)
step-sound (reverse p)     ρ = sym (step-sound p ρ)

derivation-sound : {a b : Tm} → Derivation a b → (ρ : Env) → eval a ρ ≡ eval b ρ
derivation-sound (done t)        ρ = refl
derivation-sound (then-step p d) ρ = step-sound p ρ ∙ derivation-sound d ρ

accepted : Derivation (add var (suc zero)) (suc var)
accepted =
  then-step (add-suc var zero)
    (then-step (suc-step (add-zero var)) (done (suc var)))

accepted-sound : (ρ : Env) → eval (add var (suc zero)) ρ ≡ eval (suc var) ρ
accepted-sound = derivation-sound accepted
