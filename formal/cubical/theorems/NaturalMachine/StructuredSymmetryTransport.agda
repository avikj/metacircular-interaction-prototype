{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.StructuredSymmetryTransport
--
-- A structured equivalence transports preserved symmetries by conjugation.
-- `StructuredDefect` supplies composition of transport witnesses, while
-- `PerspectiveSymmetry` identifies a diagonal defect with a stabilizer.
-- Their exact joint had not been stated: the symmetry group is an invariant
-- of the STRUCTURED object, not of its chosen carrier presentation.
--
-- Checked content:
--
--   defect-inv                    structure transport reverses
--   conjugate / conjugate-back    the two carrier-level conjugations
--   conjugate-stabilizer          preserved A-symmetries become preserved
--                                 B-symmetries
--   conjugate-stabilizer-back     the converse transport
--   bare-equivalence-insufficient the sampled pointed-Bool control
--
-- NOT claimed: novelty.  This is the standard conjugacy of stabilizers along
-- an equivariant identification, expressed using the repository's
-- proof-relevant `Defect` carrier.  No equality of whole stabilizer TYPES is
-- claimed: that stronger packaging would also have to retain the paths
-- comparing the two conjugation composites with the identity.
------------------------------------------------------------------------

module NaturalMachine.StructuredSymmetryTransport where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.Transport
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.StructuredDefect
  using (Str ; Defect ; defect-comp ; notEquiv ; witness-defect)
open import NaturalMachine.PerspectiveSymmetry using (Stab)

private
  variable
    ℓ ℓS : Level

------------------------------------------------------------------------
-- Reversing structured transport
------------------------------------------------------------------------

-- Transporting the structure along an equivalence can be reversed along its
-- inverse.  `PerspectiveSymmetry.stab-inv` is the diagonal case `sA = sB`;
-- this form is what conjugation between two presentations needs.
defect-inv : {S : Str ℓ ℓS} {A B : Type ℓ} {sA : S A} {sB : S B}
           → (e : A ≃ B) → Defect {S = S} e sA sB
           → Defect {S = S} (invEquiv e) sB sA
defect-inv {S = S} {sA = sA} e d =
    sym (cong (subst S (ua (invEquiv e))) d)
  ∙ round
  where
  collapse : ua e ∙ ua (invEquiv e) ≡ refl
  collapse = sym (uaCompEquiv e (invEquiv e))
           ∙ cong ua (invEquiv-is-rinv e)
           ∙ uaIdEquiv

  round : subst S (ua (invEquiv e)) (subst S (ua e) sA) ≡ sA
  round = sym (substComposite S (ua e) (ua (invEquiv e)) sA)
        ∙ cong (λ p → subst S p sA) collapse
        ∙ substRefl {B = S} sA

------------------------------------------------------------------------
-- Stabilizers move by conjugation
------------------------------------------------------------------------

-- Starting on B: return to A, apply `a`, and move back to B.
conjugate : {A B : Type ℓ} → (e : A ≃ B) → (a : A ≃ A) → B ≃ B
conjugate e a = compEquiv (compEquiv (invEquiv e) a) e

-- The reverse carrier-level operation.
conjugate-back : {A B : Type ℓ} → (e : A ≃ B) → (b : B ≃ B) → A ≃ A
conjugate-back e b = compEquiv (compEquiv e b) (invEquiv e)

-- A symmetry preserving `sA` remains a symmetry after conjugation into the
-- structured presentation `(B , sB)`.  The proof is exactly the three-leg
-- defect composite: reverse `e`, apply the symmetry, then follow `e`.
conjugate-stabilizer :
    {S : Str ℓ ℓS} {A B : Type ℓ} {sA : S A} {sB : S B}
  → (e : A ≃ B) → Defect {S = S} e sA sB
  → (a : A ≃ A) → Stab S sA a
  → Stab S sB (conjugate e a)
conjugate-stabilizer {S = S} e d a sa =
  defect-comp {S = S} (compEquiv (invEquiv e) a) e
    (defect-comp {S = S} (invEquiv e) a (defect-inv e d) sa)
    d

-- Conversely, a symmetry of `(B , sB)` transports back to `(A , sA)`.
-- Stating both directions avoids silently calling the result an equivalence
-- of proof-relevant stabilizer TYPES without proving the coherence paths.
conjugate-stabilizer-back :
    {S : Str ℓ ℓS} {A B : Type ℓ} {sA : S A} {sB : S B}
  → (e : A ≃ B) → Defect {S = S} e sA sB
  → (b : B ≃ B) → Stab S sB b
  → Stab S sA (conjugate-back e b)
conjugate-stabilizer-back {S = S} e d b sb =
  defect-comp {S = S} (compEquiv e b) (invEquiv e)
    (defect-comp {S = S} e b d sb)
    (defect-inv e d)

------------------------------------------------------------------------
-- Falsifier: the structured witness cannot be deleted
------------------------------------------------------------------------

-- A bare equivalence alone is insufficient.  The sampled module's `notEquiv`
-- is an equivalence Bool ≃ Bool but does not preserve the distinguished point
-- `true`.  Any theorem omitting the `Defect e sA sB` premise would already
-- fail here.
bare-equivalence-insufficient :
  Σ[ e ∈ (Bool ≃ Bool) ] ¬ (Defect {S = λ A → A} e true true)
bare-equivalence-insufficient = notEquiv , witness-defect

