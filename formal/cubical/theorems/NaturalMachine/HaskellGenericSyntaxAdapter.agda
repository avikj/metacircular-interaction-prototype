{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- The bounded Haskell discovery bridge and the generic primitive-extension
-- syntax describe the same four-operation arithmetic language.
--
-- This module supplies the missing typed adapter.  It does not certify a
-- Haskell search trace or enlarge the set of admitted primitive symbols.
-- Its payoff is narrower and exact: discovery equations can reuse the
-- generic substitution theorem without a second substitution development.
------------------------------------------------------------------------

module NaturalMachine.HaskellGenericSyntaxAdapter where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; znots)
open import Cubical.Data.Empty as Empty using ()
open import Cubical.Data.Fin using (Fin ; fzero ; fsuc ; fsplit ; ¬Fin0)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.HaskellDiscoveryBoundary as HD
import NaturalMachine.ConservativePrimitiveExtension as CP

------------------------------------------------------------------------
-- A generic arity-indexed presentation of the Haskell bridge language.
------------------------------------------------------------------------

data HaskellOp : Type₀ where
  zero-op suc-op add-op mul-op : HaskellOp

HaskellSignature : CP.Signature
CP.Signature.Op HaskellSignature = HaskellOp
CP.Signature.arity HaskellSignature zero-op = 0
CP.Signature.arity HaskellSignature suc-op  = 1
CP.Signature.arity HaskellSignature add-op  = 2
CP.Signature.arity HaskellSignature mul-op  = 2

HaskellNatAlgebra : CP.Algebra HaskellSignature ℕ
CP.Algebra.operation HaskellNatAlgebra zero-op values = zero
CP.Algebra.operation HaskellNatAlgebra suc-op  values = suc (values fzero)
CP.Algebra.operation HaskellNatAlgebra add-op  values =
  values fzero + values (fsuc fzero)
CP.Algebra.operation HaskellNatAlgebra mul-op  values =
  values fzero · values (fsuc fzero)

GenericTerm : Type₀
GenericTerm = CP.Term HaskellSignature ℕ

zeroChildren : Fin 0 → GenericTerm
zeroChildren index = Empty.rec (¬Fin0 index)

unaryChildren : GenericTerm → Fin 1 → GenericTerm
unaryChildren term _ = term

binaryChildren : GenericTerm → GenericTerm → Fin 2 → GenericTerm
binaryChildren left right (zero , bound) = left
binaryChildren left right (suc n , bound) = right

toGeneric : HD.HaskellTerm → GenericTerm
toGeneric (HD.var n) = CP.var n
toGeneric HD.zeroT = CP.node zero-op zeroChildren
toGeneric (HD.sucT term) =
  CP.node suc-op (unaryChildren (toGeneric term))
toGeneric (left HD.+T right) =
  CP.node add-op (binaryChildren (toGeneric left) (toGeneric right))
toGeneric (left HD.·T right) =
  CP.node mul-op (binaryChildren (toGeneric left) (toGeneric right))

fromGeneric : GenericTerm → HD.HaskellTerm
fromGeneric (CP.var n) = HD.var n
fromGeneric (CP.node zero-op children) = HD.zeroT
fromGeneric (CP.node suc-op children) = HD.sucT (fromGeneric (children fzero))
fromGeneric (CP.node add-op children) =
  fromGeneric (children fzero) HD.+T fromGeneric (children (fsuc fzero))
fromGeneric (CP.node mul-op children) =
  fromGeneric (children fzero) HD.·T fromGeneric (children (fsuc fzero))

from-to : (term : HD.HaskellTerm) → fromGeneric (toGeneric term) ≡ term
from-to (HD.var n) = refl
from-to HD.zeroT = refl
from-to (HD.sucT term) = cong HD.sucT (from-to term)
from-to (left HD.+T right) =
  cong₂ HD._+T_ (from-to left) (from-to right)
from-to (left HD.·T right) =
  cong₂ HD._·T_ (from-to left) (from-to right)

fin1-zero : (index : Fin 1) → fzero ≡ index
fin1-zero index with fsplit index
... | inl path = path
... | inr (smaller , path) = Empty.rec (¬Fin0 smaller)

binaryChildren-eta : (children : Fin 2 → GenericTerm)
  → binaryChildren (children fzero) (children (fsuc fzero)) ≡ children
binaryChildren-eta children = funExt pointwise
  where
  rebuilt : Fin 2 → GenericTerm
  rebuilt = binaryChildren (children fzero) (children (fsuc fzero))

  pointwise : (index : Fin 2) → rebuilt index ≡ children index
  pointwise index with fsplit index
  ... | inl path =
    sym (cong rebuilt path) ∙ cong children path
  ... | inr (smaller , path) =
    sym (cong rebuilt stepPath) ∙ cong children stepPath
    where
    stepPath : fsuc fzero ≡ index
    stepPath = cong fsuc (fin1-zero smaller) ∙ path

to-from : (term : GenericTerm) → toGeneric (fromGeneric term) ≡ term
to-from (CP.var n) = refl
to-from (CP.node zero-op children) =
  cong (CP.node zero-op)
    (funExt λ index → Empty.rec (¬Fin0 index))
to-from (CP.node suc-op children) =
  cong (CP.node suc-op)
    (funExt λ index →
      to-from (children fzero) ∙ cong children (fin1-zero index))
to-from (CP.node add-op children) =
  cong (CP.node add-op)
    (cong₂ binaryChildren
      (to-from (children fzero))
      (to-from (children (fsuc fzero)))
    ∙ binaryChildren-eta children)
to-from (CP.node mul-op children) =
  cong (CP.node mul-op)
    (cong₂ binaryChildren
      (to-from (children fzero))
      (to-from (children (fsuc fzero)))
    ∙ binaryChildren-eta children)

haskellTermIso : Iso HD.HaskellTerm GenericTerm
haskellTermIso = iso toGeneric fromGeneric to-from from-to

haskellTermEquiv : HD.HaskellTerm ≃ GenericTerm
haskellTermEquiv = isoToEquiv haskellTermIso

------------------------------------------------------------------------
-- The equivalence commutes with the two evaluators.
------------------------------------------------------------------------

evaluate-to : (environment : HD.Environment) (term : HD.HaskellTerm)
  → CP.evaluate HaskellNatAlgebra environment (toGeneric term)
    ≡ HD.evaluate environment term
evaluate-to environment (HD.var n) = refl
evaluate-to environment HD.zeroT = refl
evaluate-to environment (HD.sucT term) =
  cong suc (evaluate-to environment term)
evaluate-to environment (left HD.+T right) =
  cong₂ _+_ (evaluate-to environment left) (evaluate-to environment right)
evaluate-to environment (left HD.·T right) =
  cong₂ _·_ (evaluate-to environment left) (evaluate-to environment right)

evaluate-from : (environment : HD.Environment) (term : GenericTerm)
  → HD.evaluate environment (fromGeneric term)
    ≡ CP.evaluate HaskellNatAlgebra environment term
evaluate-from environment term =
  sym (evaluate-to environment (fromGeneric term))
  ∙ cong (CP.evaluate HaskellNatAlgebra environment) (to-from term)

GenericEquation : Type₀
GenericEquation = GenericTerm × GenericTerm

GenericSound : GenericEquation → Type₀
GenericSound (left , right) = (environment : HD.Environment)
  → CP.evaluate HaskellNatAlgebra environment left
    ≡ CP.evaluate HaskellNatAlgebra environment right

toGenericEquation : HD.Equation → GenericEquation
toGenericEquation (left , right) = toGeneric left , toGeneric right

sound-to-generic : (equation : HD.Equation)
  → HD.Sound equation → GenericSound (toGenericEquation equation)
sound-to-generic (left , right) sound environment =
  evaluate-to environment left
  ∙ sound environment
  ∙ sym (evaluate-to environment right)

generic-to-sound : (equation : HD.Equation)
  → GenericSound (toGenericEquation equation) → HD.Sound equation
generic-to-sound (left , right) sound environment =
  sym (evaluate-to environment left)
  ∙ sound environment
  ∙ evaluate-to environment right

------------------------------------------------------------------------
-- Reuse the generic substitution theorem through the adapter.
------------------------------------------------------------------------

Substitution : Type₀
Substitution = ℕ → HD.HaskellTerm

substitute : HD.HaskellTerm → Substitution → HD.HaskellTerm
substitute term substitution =
  fromGeneric (CP.bind (toGeneric term) (λ n → toGeneric (substitution n)))

evaluate-substitute : (environment : HD.Environment)
  (term : HD.HaskellTerm) (substitution : Substitution)
  → HD.evaluate environment (substitute term substitution)
    ≡ HD.evaluate
        (λ n → HD.evaluate environment (substitution n)) term
evaluate-substitute environment term substitution =
  evaluate-from environment
    (CP.bind (toGeneric term) (λ n → toGeneric (substitution n)))
  ∙ CP.evaluate-bind HaskellNatAlgebra environment (toGeneric term)
      (λ n → toGeneric (substitution n))
  ∙ cong (λ ρ → CP.evaluate HaskellNatAlgebra ρ (toGeneric term))
      (funExt λ n → evaluate-to environment (substitution n))
  ∙ evaluate-to
      (λ n → HD.evaluate environment (substitution n)) term

substituteEquation : HD.Equation → Substitution → HD.Equation
substituteEquation (left , right) substitution =
  substitute left substitution , substitute right substitution

sound-substitute : (equation : HD.Equation) → HD.Sound equation
  → (substitution : Substitution) → HD.Sound (substituteEquation equation substitution)
sound-substitute (left , right) sound substitution environment =
  evaluate-substitute environment left substitution
  ∙ sound (λ n → HD.evaluate environment (substitution n))
  ∙ sym (evaluate-substitute environment right substitution)

------------------------------------------------------------------------
-- Hostile control: the adapter does not make an unsound equation derivable.
------------------------------------------------------------------------

zeroEnvironment : HD.Environment
zeroEnvironment _ = zero

x-not-successor-sound : ¬ HD.Sound (HD.x , HD.sucT HD.x)
x-not-successor-sound sound = znots (sound zeroEnvironment)
