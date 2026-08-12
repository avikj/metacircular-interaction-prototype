{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.PathIsSymmetry
--
-- The thesis in one line.
--
-- For a type X, the identity type (X ≡ X) *is* the automorphism group
-- of X.  Not "corresponds to", not "is isomorphic to by an asserted
-- dictionary": univalence supplies the equivalence, and path
-- composition is transported to composition of equivalences, so the
-- correspondence is a group isomorphism, checked.
--
-- A name for X is a point of π₀; the geometry of X lives in its
-- identity type.  Univalence is what makes symbol and geometry say the
-- same thing.
--
-- Contrast, also proved here: as a bare type ℕ has many automorphisms
-- (swap 0 and 1); as an algebra for X ↦ 1 + X it has exactly one.
-- Structure is what cuts the automorphism group down --- which is the
-- whole content of the structure identity principle.
------------------------------------------------------------------------

module NaturalMachine.PathIsSymmetry where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Function
open import Cubical.Foundations.HLevels
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.GroupoidLaws
open import Cubical.Data.Nat
open import Cubical.Data.Fin using (Fin ; isSetFin)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.Group
open import Cubical.Algebra.Group.Morphisms
open import Cubical.Algebra.Group.MorphismProperties
open import Cubical.Algebra.SymmetricGroup

private
  variable
    ℓ : Level
    A B C : Type ℓ

------------------------------------------------------------------------
-- 1.  The statement, in one line.
------------------------------------------------------------------------

-- Univalence, read as: the loop type at X in the universe is the type
-- of symmetries of X.
pathIsSymmetry : (X : Type ℓ) → (X ≡ X) ≃ (X ≃ X)
pathIsSymmetry X = univalence

-- Specialised to the standard finite types.  The right-hand side is the
-- underlying type of the symmetric group Sₙ.
finPathIsSymmetry : (n : ℕ) → (Fin n ≡ Fin n) ≃ (Fin n ≃ Fin n)
finPathIsSymmetry n = pathIsSymmetry (Fin n)

------------------------------------------------------------------------
-- 2.  It is a group isomorphism, not merely a bijection.
--
-- pathToEquiv is multiplicative: it sends path composition to
-- composition of equivalences.  Proved by path induction on the second
-- path, so nothing is asserted.
------------------------------------------------------------------------

pathToEquiv-∙ : (p : A ≡ B) (q : B ≡ C)
              → pathToEquiv (p ∙ q) ≡ compEquiv (pathToEquiv p) (pathToEquiv q)
pathToEquiv-∙ {A = A} p =
  J (λ _ q → pathToEquiv (p ∙ q) ≡ compEquiv (pathToEquiv p) (pathToEquiv q))
    ( cong pathToEquiv (sym (rUnit p))
    ∙ sym (compEquivEquivId (pathToEquiv p))
    ∙ cong (compEquiv (pathToEquiv p)) (sym pathToEquivRefl) )

-- The loop group of the universe at a set X.  Note the universe level:
-- (X ≡ X) lives one level above X, so this is a Group (ℓ-suc ℓ) while
-- SymGroup X is a Group ℓ.  The two are isomorphic but not
-- literally equal --- an honest universe-level fact, not a defect.
ΩGroup : (X : Type ℓ) → isSet X → Group (ℓ-suc ℓ)
ΩGroup X isSetX =
  makeGroup (refl {x = X}) _∙_ sym isSetΩ
    (λ p q r → assoc p q r)
    (λ p → sym (rUnit p))
    (λ p → sym (lUnit p))
    rCancel
    lCancel
  where
    isSetΩ : isSet (X ≡ X)
    isSetΩ = isOfHLevelRespectEquiv 2 (invEquiv univalence)
               (isOfHLevel≃ 2 isSetX isSetX)

-- THE PUNCHLINE OF §1: the loop group of the universe at X is the
-- symmetric group of X, as groups.
ΩGroup≃Symmetric : (X : Type ℓ) (isSetX : isSet X)
                 → GroupEquiv (ΩGroup X isSetX) (SymGroup X isSetX)
ΩGroup≃Symmetric X isSetX =
  univalence , makeIsGroupHom (λ p q → pathToEquiv-∙ p q)

-- Ω(Type, Fin n) ≅ Sₙ.
ΩFin≃Sym : (n : ℕ) → GroupEquiv (ΩGroup (Fin n) isSetFin) (SymGroup (Fin n) isSetFin)
ΩFin≃Sym n = ΩGroup≃Symmetric (Fin n) isSetFin

------------------------------------------------------------------------
-- 3.  Structure cuts down symmetry: ℕ as a type versus ℕ as an algebra.
------------------------------------------------------------------------

-- (a) As a bare type, ℕ has a nonidentity automorphism.
swap01 : ℕ → ℕ
swap01 zero                = suc zero
swap01 (suc zero)          = zero
swap01 (suc (suc n))       = suc (suc n)

swap01-involutive : (n : ℕ) → swap01 (swap01 n) ≡ n
swap01-involutive zero          = refl
swap01-involutive (suc zero)    = refl
swap01-involutive (suc (suc n)) = refl

swap01-Equiv : ℕ ≃ ℕ
swap01-Equiv = isoToEquiv (iso swap01 swap01 swap01-involutive swap01-involutive)

-- ... and it is not the identity, so Aut(ℕ as a bare type) is nontrivial.
swap01-≢-id : ¬ (swap01-Equiv ≡ idEquiv ℕ)
swap01-≢-id p = snotz (funExt⁻ (cong (λ e → equivFun e) p) zero)

-- (b) As an algebra for X ↦ 1 + X, ℕ is rigid: any endomorphism
--     commuting with zero and successor is the identity.  No
--     equivalence hypothesis is needed; a bare map suffices.
ℕ-algebra-rigid : (f : ℕ → ℕ)
                → f zero ≡ zero
                → ((n : ℕ) → f (suc n) ≡ suc (f n))
                → (n : ℕ) → f n ≡ n
ℕ-algebra-rigid f p q zero    = p
ℕ-algebra-rigid f p q (suc n) = q n ∙ cong suc (ℕ-algebra-rigid f p q n)

-- Consequence: the automorphism group of the initial (1 + X)-algebra is
-- trivial.  Every self-equivalence respecting the structure is refl.
ℕ-algebra-Aut-trivial :
    (e : ℕ ≃ ℕ)
  → equivFun e zero ≡ zero
  → ((n : ℕ) → equivFun e (suc n) ≡ suc (equivFun e n))
  → e ≡ idEquiv ℕ
ℕ-algebra-Aut-trivial e p q =
  equivEq (funExt (ℕ-algebra-rigid (equivFun e) p q))

-- swap01 witnesses the gap: it is an automorphism of the type that is
-- not an automorphism of the algebra.
swap01-breaks-zero : ¬ (swap01 zero ≡ zero)
swap01-breaks-zero = snotz
