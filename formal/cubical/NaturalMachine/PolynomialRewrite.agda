{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.PolynomialRewrite where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Vec.Base using (Vec ; [] ; _∷_ ; _++_)

record Signature : Type₁ where
  field
    Op : ℕ → Type₀

open Signature

data Term (S : Signature) : Type₀ where
  var : Term S
  node : {n : ℕ} → Op S n → Vec (Term S) n → Term S

module _ (S : Signature) where

  data Context : Type₀ where
    hole : Context
    frame : {m n : ℕ} → Op S (m + suc n)
          → Vec (Term S) m → Context → Vec (Term S) n → Context

  plug : Context → Term S → Term S
  plug hole term = term
  plug (frame operation left focus right) term =
    node operation (left ++ plug focus term ∷ right)

  module _ (Motion : Term S → Term S → Type₀) where

    -- `under` is the derivative of every supplied polynomial constructor.
    -- No constructor-specific congruence cases occur below this line.
    data Step : Term S → Term S → Type₀ where
      lift-motion : {from to : Term S} → Motion from to → Step from to
      under : {m n : ℕ} (operation : Op S (m + suc n))
            (left : Vec (Term S) m) (right : Vec (Term S) n)
            {from to : Term S} → Step from to
            → Step (node operation (left ++ from ∷ right))
                   (node operation (left ++ to ∷ right))

    weave-step : (context : Context) {from to : Term S}
      → Step from to → Step (plug context from) (plug context to)
    weave-step hole step = step
    weave-step (frame operation left focus right) step =
      under operation left right (weave-step focus step)

    data Run : Term S → Type₀ where
      halt : {term : Term S} → Run term
      advance : {from to : Term S} → Step from to → Run to → Run from

    result : {term : Term S} → Run term → Term S
    result {term} halt = term
    result (advance step rest) = result rest

    reweave : (context : Context) {term : Term S}
      → Run term → Run (plug context term)
    reweave context halt = halt
    reweave context (advance step rest) =
      advance (weave-step context step) (reweave context rest)

    reweave-result : (context : Context) {term : Term S} (run : Run term)
      → result (reweave context run) ≡ plug context (result run)
    reweave-result context halt = refl
    reweave-result context (advance step rest) =
      reweave-result context rest

------------------------------------------------------------------------
-- Arithmetic is an instance, not a privileged syntax.
------------------------------------------------------------------------

data ArithmeticOp : ℕ → Type₀ where
  zero-op : ArithmeticOp 0
  suc-op : ArithmeticOp 1
  add-op : ArithmeticOp 2

Arithmetic : Signature
Op Arithmetic = ArithmeticOp

aVar aZero : Term Arithmetic
aVar = var
aZero = node zero-op []

aSuc : Term Arithmetic → Term Arithmetic
aSuc term = node suc-op (term ∷ [])

aAdd : Term Arithmetic → Term Arithmetic → Term Arithmetic
aAdd left right = node add-op (left ∷ right ∷ [])

data ArithmeticMotion : Term Arithmetic → Term Arithmetic → Type₀ where
  add-zero : (term : Term Arithmetic) → ArithmeticMotion (aAdd term aZero) term
  add-suc : (left right : Term Arithmetic)
          → ArithmeticMotion (aAdd left (aSuc right)) (aSuc (aAdd left right))

add-one : Run Arithmetic ArithmeticMotion (aAdd aVar (aSuc aZero))
add-one =
  advance (lift-motion (add-suc aVar aZero))
    (advance
      (under suc-op [] [] (lift-motion (add-zero aVar)))
      halt)

add-one-result : result Arithmetic ArithmeticMotion add-one ≡ aSuc aVar
add-one-result = refl

right-root : Context Arithmetic
right-root = frame add-op (aVar ∷ []) hole []

add-one-under-right :
  result Arithmetic ArithmeticMotion
    (reweave Arithmetic ArithmeticMotion right-root add-one)
    ≡ aAdd aVar (aSuc aVar)
add-one-under-right = refl
