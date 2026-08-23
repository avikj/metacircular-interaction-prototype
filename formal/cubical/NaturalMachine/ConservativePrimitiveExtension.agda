{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.ConservativePrimitiveExtension where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Fin using (Fin ; fzero ; fsuc)

-- A language is an arity-indexed family of operations.  Terms use a
-- function of children rather than a list, so the arity is intrinsic.
record Signature : Type₁ where
  field
    Op : Type₀
    arity : Op → ℕ

open Signature

data Term (S : Signature) (Variable : Type₀) : Type₀ where
  var  : Variable → Term S Variable
  node : (operation : Op S)
       → (Fin (arity S operation) → Term S Variable)
       → Term S Variable

record Algebra (S : Signature) (Carrier : Type₀) : Type₀ where
  field
    operation : (symbol : Op S)
      → (Fin (arity S symbol) → Carrier) → Carrier

open Algebra

evaluate : {S : Signature} {Variable Carrier : Type₀}
  → Algebra S Carrier → (Variable → Carrier)
  → Term S Variable → Carrier
evaluate algebra environment (var x) = environment x
evaluate algebra environment (node symbol children) =
  operation algebra symbol (λ position →
    evaluate algebra environment (children position))

bind : {S : Signature} {A B : Type₀}
  → Term S A → (A → Term S B) → Term S B
bind (var x) substitution = substitution x
bind (node symbol children) substitution =
  node symbol (λ position → bind (children position) substitution)

evaluate-bind : {S : Signature} {A B Carrier : Type₀}
  (algebra : Algebra S Carrier) (environment : B → Carrier)
  (term : Term S A) (substitution : A → Term S B)
  → evaluate algebra environment (bind term substitution)
    ≡ evaluate algebra
        (λ x → evaluate algebra environment (substitution x)) term
evaluate-bind algebra environment (var x) substitution = refl
evaluate-bind algebra environment (node symbol children) substitution =
  cong (operation algebra symbol)
    (funExt (λ position →
      evaluate-bind algebra environment (children position) substitution))

-- A generated primitive is not an opaque oracle.  It is a fresh constructor
-- together with an old-language body of the same arity.
record Definition (S : Signature) : Type₀ where
  field
    freshArity : ℕ
    body : Term S (Fin freshArity)

open Definition

data ExtendedOp (S : Signature) (definition : Definition S) : Type₀ where
  old : Op S → ExtendedOp S definition
  fresh : ExtendedOp S definition

Extended : (S : Signature) → Definition S → Signature
Op (Extended S definition) = ExtendedOp S definition
arity (Extended S definition) (old symbol) = arity S symbol
arity (Extended S definition) fresh = freshArity definition

unfold : {S : Signature} (definition : Definition S) {Variable : Type₀}
  → Term (Extended S definition) Variable → Term S Variable
unfold definition (var x) = var x
unfold definition (node (old symbol) children) =
  node symbol (λ position → unfold definition (children position))
unfold definition (node fresh children) =
  bind (body definition)
    (λ position → unfold definition (children position))

extendAlgebra : {S : Signature} (definition : Definition S)
  {Carrier : Type₀} → Algebra S Carrier
  → Algebra (Extended S definition) Carrier
operation (extendAlgebra definition algebra) (old symbol) values =
  operation algebra symbol values
operation (extendAlgebra definition algebra) fresh values =
  evaluate algebra values (body definition)

-- This is the admission theorem for an invented primitive: evaluation in
-- the enlarged language is exactly evaluation after eliminating the new
-- constructor back into its generated definition.
unfold-preserves-evaluation : {S : Signature} (definition : Definition S)
  {Variable Carrier : Type₀} (algebra : Algebra S Carrier)
  (environment : Variable → Carrier)
  (term : Term (Extended S definition) Variable)
  → evaluate (extendAlgebra definition algebra) environment term
    ≡ evaluate algebra environment (unfold definition term)
unfold-preserves-evaluation definition algebra environment (var x) = refl
unfold-preserves-evaluation definition algebra environment
  (node (old symbol) children) =
  cong (operation algebra symbol)
    (funExt (λ position →
      unfold-preserves-evaluation definition algebra environment
        (children position)))
unfold-preserves-evaluation definition algebra environment
  (node fresh children) =
  cong (λ values → evaluate algebra values (body definition))
    (funExt (λ position →
      unfold-preserves-evaluation definition algebra environment
        (children position)))
  ∙ sym (evaluate-bind algebra environment (body definition)
      (λ position → unfold definition (children position)))

------------------------------------------------------------------------
-- Executing control: arithmetic invents a unary `double` primitive.
------------------------------------------------------------------------

data ArithmeticOp : Type₀ where
  zero-op suc-op add-op : ArithmeticOp

Arithmetic : Signature
Op Arithmetic = ArithmeticOp
arity Arithmetic zero-op = 0
arity Arithmetic suc-op = 1
arity Arithmetic add-op = 2

NatAlgebra : Algebra Arithmetic ℕ
operation NatAlgebra zero-op values = zero
operation NatAlgebra suc-op values = suc (values fzero)
operation NatAlgebra add-op values = values fzero + values (fsuc fzero)

doubleDefinition : Definition Arithmetic
freshArity doubleDefinition = 1
body doubleDefinition = node add-op doubleBody
  where
    doubleBody : Fin 2 → Term Arithmetic (Fin 1)
    doubleBody _ = var fzero

double : {Variable : Type₀}
  → Term (Extended Arithmetic doubleDefinition) Variable
  → Term (Extended Arithmetic doubleDefinition) Variable
double term = node fresh child
  where
    child : Fin 1 → Term (Extended Arithmetic doubleDefinition) _
    child _ = term

doubleTerm : Term (Extended Arithmetic doubleDefinition) (Fin 1)
doubleTerm = double (var fzero)

double-computes : (n : ℕ)
  → evaluate (extendAlgebra doubleDefinition NatAlgebra) (λ _ → n)
      doubleTerm
    ≡ n + n
double-computes n = refl

double-is-conservative : (n : ℕ)
  → evaluate (extendAlgebra doubleDefinition NatAlgebra) (λ _ → n)
      doubleTerm
    ≡ evaluate NatAlgebra (λ _ → n)
        (unfold doubleDefinition doubleTerm)
double-is-conservative n =
  unfold-preserves-evaluation doubleDefinition NatAlgebra (λ _ → n)
    doubleTerm
