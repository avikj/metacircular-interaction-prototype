{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.PolynomialRewrite where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using
  (ℕ ; zero ; suc ; _+_ ; +-zero ; +-suc ; +-assoc ; +-comm)
open import Cubical.Data.Vec.Base using (Vec ; [] ; _∷_ ; _++_ ; map)

record Signature : Type₁ where
  field
    Op : ℕ → Type₀

open Signature

data Term (S : Signature) : Type₀ where
  var : Term S
  node : {n : ℕ} → Op S n → Vec (Term S) n → Term S

record Algebra (S : Signature) (Carrier : Type₀) : Type₀ where
  field
    operation : {n : ℕ} → Op S n → Vec Carrier n → Carrier

open Algebra

mutual
  evaluate : {S : Signature} {Carrier : Type₀}
    → Algebra S Carrier → Carrier → Term S → Carrier
  evaluate algebra environment var = environment
  evaluate algebra environment (node operation terms) =
    Algebra.operation algebra operation (evaluateVec algebra environment terms)

  evaluateVec : {S : Signature} {Carrier : Type₀} {n : ℕ}
    → Algebra S Carrier → Carrier → Vec (Term S) n → Vec Carrier n
  evaluateVec algebra environment [] = []
  evaluateVec algebra environment (term ∷ terms) =
    evaluate algebra environment term ∷ evaluateVec algebra environment terms

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

    PrimitiveLaw : {Carrier : Type₀} → Algebra S Carrier → Type₀
    PrimitiveLaw {Carrier} algebra =
      {from to : Term S} → Motion from to → (environment : Carrier)
      → evaluate algebra environment from ≡ evaluate algebra environment to

    focus-values : {Carrier : Type₀} (algebra : Algebra S Carrier)
      (environment : Carrier) {m n : ℕ}
      (left : Vec (Term S) m) (right : Vec (Term S) n)
      {from to : Term S}
      → evaluate algebra environment from ≡ evaluate algebra environment to
      → evaluateVec algebra environment (left ++ from ∷ right)
        ≡ evaluateVec algebra environment (left ++ to ∷ right)
    focus-values algebra environment [] right equality =
      cong (_∷ evaluateVec algebra environment right) equality
    focus-values algebra environment (term ∷ left) right equality =
      cong (evaluate algebra environment term ∷_)
        (focus-values algebra environment left right equality)

    step-sound : {Carrier : Type₀} (algebra : Algebra S Carrier)
      → PrimitiveLaw algebra → {from to : Term S}
      → Step from to → (environment : Carrier)
      → evaluate algebra environment from ≡ evaluate algebra environment to
    step-sound algebra law (lift-motion motion) environment =
      law motion environment
    step-sound algebra law (under operation left right step) environment =
      cong (Algebra.operation algebra operation)
        (focus-values algebra environment left right
          (step-sound algebra law step environment))

    run-sound : {Carrier : Type₀} (algebra : Algebra S Carrier)
      → PrimitiveLaw algebra → {term : Term S} (run : Run term)
      → (environment : Carrier)
      → evaluate algebra environment term
        ≡ evaluate algebra environment (result run)
    run-sound algebra law halt environment = refl
    run-sound algebra law (advance step rest) environment =
      step-sound algebra law step environment
      ∙ run-sound algebra law rest environment

    reweave-sound : {Carrier : Type₀} (algebra : Algebra S Carrier)
      → PrimitiveLaw algebra → (context : Context)
      → {term : Term S} (run : Run term) (environment : Carrier)
      → evaluate algebra environment (plug context term)
        ≡ evaluate algebra environment (plug context (result run))
    reweave-sound algebra law context run environment =
      run-sound algebra law (reweave context run) environment
      ∙ cong (evaluate algebra environment) (reweave-result context run)

mutual
  nodeCount : {S : Signature} → Term S → ℕ
  nodeCount var = 1
  nodeCount (node operation terms) = suc (counts terms)

  counts : {S : Signature} {n : ℕ} → Vec (Term S) n → ℕ
  counts [] = zero
  counts (term ∷ terms) = nodeCount term + counts terms

module _ (S : Signature) where

  focus-count-strict : {m n : ℕ}
    (left : Vec (Term S) m) (right : Vec (Term S) n)
    {from to : Term S} → nodeCount from ≡ suc (nodeCount to)
    → counts (left ++ from ∷ right) ≡ suc (counts (left ++ to ∷ right))
  focus-count-strict [] right {to = to} strict =
    cong (_+ counts right) strict
  focus-count-strict (term ∷ left) right {to = to} strict =
    cong (nodeCount term +_) (focus-count-strict left right strict)
    ∙ +-suc (nodeCount term) (counts (left ++ to ∷ right))

  plug-count-strict : (context : Context S) {from to : Term S}
    → nodeCount from ≡ suc (nodeCount to)
    → nodeCount (plug S context from) ≡ suc (nodeCount (plug S context to))
  plug-count-strict hole strict = strict
  plug-count-strict (frame operation left focus right) strict =
    cong suc (focus-count-strict left right (plug-count-strict focus strict))

  focus-count-gap : {m n : ℕ}
    (left : Vec (Term S) m) (right : Vec (Term S) n) (gap : ℕ)
    {from to : Term S} → nodeCount from ≡ gap + nodeCount to
    → counts (left ++ from ∷ right)
      ≡ gap + counts (left ++ to ∷ right)
  focus-count-gap [] right gap {to = to} equality =
    cong (_+ counts right) equality
    ∙ sym (+-assoc gap (nodeCount to) (counts right))
  focus-count-gap (term ∷ left) right gap {to = to} equality =
    cong (nodeCount term +_) (focus-count-gap left right gap equality)
    ∙ +-assoc (nodeCount term) gap
        (counts (left ++ to ∷ right))
    ∙ cong (_+ counts (left ++ to ∷ right))
        (+-comm (nodeCount term) gap)
    ∙ sym (+-assoc gap (nodeCount term)
        (counts (left ++ to ∷ right)))

  plug-count-gap : (context : Context S) (gap : ℕ) {from to : Term S}
    → nodeCount from ≡ gap + nodeCount to
    → nodeCount (plug S context from)
      ≡ gap + nodeCount (plug S context to)
  plug-count-gap hole gap equality = equality
  plug-count-gap (frame operation left focus right) gap {to = to} equality =
    cong suc (focus-count-gap left right gap
      (plug-count-gap focus gap equality))
    ∙ sym (+-suc gap (counts (left ++ plug S focus to ∷ right)))

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

NatAlgebra : Algebra Arithmetic ℕ
Algebra.operation NatAlgebra zero-op [] = zero
Algebra.operation NatAlgebra suc-op (value ∷ []) = suc value
Algebra.operation NatAlgebra add-op (left ∷ right ∷ []) = left + right

arithmetic-law : PrimitiveLaw Arithmetic ArithmeticMotion NatAlgebra
arithmetic-law (add-zero term) environment =
  +-zero (evaluate NatAlgebra environment term)
arithmetic-law (add-suc left right) environment =
  +-suc (evaluate NatAlgebra environment left)
    (evaluate NatAlgebra environment right)

add-one : Run Arithmetic ArithmeticMotion (aAdd aVar (aSuc aZero))
add-one =
  advance (lift-motion (add-suc aVar aZero))
    (advance
      (under suc-op [] [] (lift-motion (add-zero aVar)))
      halt)

add-one-result : result Arithmetic ArithmeticMotion add-one ≡ aSuc aVar
add-one-result = refl

add-one-semantic : (environment : ℕ)
  → evaluate NatAlgebra environment (aAdd aVar (aSuc aZero))
    ≡ evaluate NatAlgebra environment (aSuc aVar)
add-one-semantic = run-sound Arithmetic ArithmeticMotion
  NatAlgebra arithmetic-law add-one

add-one-strict : nodeCount (aAdd aVar (aSuc aZero))
  ≡ 2 + nodeCount (aSuc aVar)
add-one-strict = refl

right-root : Context Arithmetic
right-root = frame add-op (aVar ∷ []) hole []

add-one-under-right :
  result Arithmetic ArithmeticMotion
    (reweave Arithmetic ArithmeticMotion right-root add-one)
    ≡ aAdd aVar (aSuc aVar)
add-one-under-right = refl

add-one-under-right-semantic : (environment : ℕ)
  → evaluate NatAlgebra environment
      (plug Arithmetic right-root (aAdd aVar (aSuc aZero)))
    ≡ evaluate NatAlgebra environment
      (plug Arithmetic right-root (aSuc aVar))
add-one-under-right-semantic =
  reweave-sound Arithmetic ArithmeticMotion NatAlgebra arithmetic-law
    right-root add-one

add-one-under-right-strict :
  nodeCount (plug Arithmetic right-root (aAdd aVar (aSuc aZero)))
    ≡ 2 + nodeCount (plug Arithmetic right-root (aSuc aVar))
add-one-under-right-strict =
  plug-count-gap Arithmetic right-root 2
    {from = aAdd aVar (aSuc aZero)} {to = aSuc aVar} add-one-strict
