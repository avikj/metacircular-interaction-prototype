{-# OPTIONS --cubical --safe #-}

-- Finite character calibration for the integer permutation representation.
-- Trace of three explicit matrices agrees with the cardinality represented by
-- the corresponding fixed-point type.  This is not Peter--Weyl theory, SU(2),
-- or a general character library.

module S3FixedPointCharacter where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Int using (ℤ ; pos ; _+_)
open import Cubical.Data.Sigma using (Σ≡Prop)
open import Cubical.Data.SumFin using (Fin ; fzero ; fsuc ; isSetFin)

open import S3IntegerPermutationModule
open ℤ³
open import FiniteNonabelianHolonomy
open import S3ConjugacyObservation
open import FiniteGraphCylindricalEquivalence

record Matrix3ℤ : Type₀ where
  constructor matrix3
  field row₀ row₁ row₂ : ℤ³
open Matrix3ℤ

identityMatrix : Matrix3ℤ
identityMatrix = matrix3
  (vec3 one zeroℤ zeroℤ)
  (vec3 zeroℤ one zeroℤ)
  (vec3 zeroℤ zeroℤ one)

transpositionMatrix : Matrix3ℤ
transpositionMatrix = matrix3
  (vec3 zeroℤ one zeroℤ)
  (vec3 one zeroℤ zeroℤ)
  (vec3 zeroℤ zeroℤ one)

cycleMatrix : Matrix3ℤ
cycleMatrix = matrix3
  (vec3 zeroℤ one zeroℤ)
  (vec3 zeroℤ zeroℤ one)
  (vec3 one zeroℤ zeroℤ)

trace : Matrix3ℤ → ℤ
trace M = c₀ (row₀ M) + (c₁ (row₁ M) + c₂ (row₂ M))

trace-identity : trace identityMatrix ≡ pos 3
trace-identity = refl

trace-transposition : trace transpositionMatrix ≡ pos 1
trace-transposition = refl

trace-cycle : trace cycleMatrix ≡ pos 0
trace-cycle = refl

-- Fixed points of identity are exactly the three underlying vertices.
identityFixedIso : Iso (Fixed S.1g) Fin3
Iso.fun identityFixedIso = fst
Iso.inv identityFixedIso x = x , refl
Iso.rightInv identityFixedIso x = refl
Iso.leftInv identityFixedIso (x , p) =
  Σ≡Prop (λ _ → isSetFin _ _) refl

identityFixedCardinality : Fixed S.1g ≃ Fin 3
identityFixedCardinality = isoToEquiv identityFixedIso

-- The transposition fixed type is contractible, hence a one-element type.
swapFixedIso : Iso (Fixed s₀₁) (Fin 1)
Iso.fun swapFixedIso x = fzero
Iso.inv swapFixedIso fzero = swap-fixed
Iso.rightInv swapFixedIso fzero = refl
Iso.leftInv swapFixedIso x = snd swap-fixed-contractible x

swapFixedCardinality : Fixed s₀₁ ≃ Fin 1
swapFixedCardinality = isoToEquiv swapFixedIso

-- A three-cycle has no fixed point, hence cardinality zero.
cycleFixedIso : Iso (Fixed cycle₀₁₂) (Fin 0)
Iso.fun cycleFixedIso x = Empty.rec (cycle-no-fixed x)
Iso.inv cycleFixedIso ()
Iso.rightInv cycleFixedIso ()
Iso.leftInv cycleFixedIso x = Empty.rec (cycle-no-fixed x)

cycleFixedCardinality : Fixed cycle₀₁₂ ≃ Fin 0
cycleFixedCardinality = isoToEquiv cycleFixedIso

-- The three checked trace values and the three finite equivalences constitute
-- the exact equality of matrix trace with fixed-profile cardinality here.
record CharacterCalibration : Type₀ where
  field
    identityTrace : trace identityMatrix ≡ pos 3
    identityFixed : Fixed S.1g ≃ Fin 3
    swapTrace : trace transpositionMatrix ≡ pos 1
    swapFixed : Fixed s₀₁ ≃ Fin 1
    cycleTrace : trace cycleMatrix ≡ pos 0
    cycleFixed : Fixed cycle₀₁₂ ≃ Fin 0

s₃CharacterCalibration : CharacterCalibration
CharacterCalibration.identityTrace s₃CharacterCalibration = trace-identity
CharacterCalibration.identityFixed s₃CharacterCalibration = identityFixedCardinality
CharacterCalibration.swapTrace s₃CharacterCalibration = trace-transposition
CharacterCalibration.swapFixed s₃CharacterCalibration = swapFixedCardinality
CharacterCalibration.cycleTrace s₃CharacterCalibration = trace-cycle
CharacterCalibration.cycleFixed s₃CharacterCalibration = cycleFixedCardinality

-- Gauge conjugation preserves the Type-valued character by univalence.
character-gauge-invariant : (h g : ⟨ S₃ ⟩)
  → Fixed ((h S.· g) S.· S.inv h) ≡ Fixed g
character-gauge-invariant = fixedProfile-conjugation

-- Stem refinement leaves the loop character unchanged across the actual
-- univalent cylindrical path.
character-refinement-invariant : (x : RefinedNetwork S₃)
  → coarseLoopProfile
      (subst (λ X → X) (networkCylindricalPath S₃) (networkClass S₃ x))
    ≡ refinedLoopProfile x
character-refinement-invariant = fixedProfile-refinement
