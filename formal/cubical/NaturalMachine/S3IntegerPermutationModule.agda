-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe #-}

-- Integer linear seam for the natural Fin3 permutation action.  We check the
-- two adjacent transposition generators explicitly; no field, inner product,
-- irreducibility, Hilbert completion, or SU(2) structure is claimed.

module NaturalMachine.S3IntegerPermutationModule where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int
  using (ℤ ; pos ; _+_ ; +Assoc ; +Comm ; isSetℤ)
open import Cubical.Data.SumFin using (fzero ; fsuc)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

open import NaturalMachine.FiniteNonabelianHolonomy using (Fin3)
open import NaturalMachine.AbstractSpinNetworkKinematics using (Intertwiner)
open Intertwiner
open import NaturalMachine.S3FiniteSpinNetwork using (terminalVertex)

record ℤ³ : Type₀ where
  constructor vec3
  field c₀ c₁ c₂ : ℤ
open ℤ³

_+³_ : ℤ³ → ℤ³ → ℤ³
vec3 a b c +³ vec3 x y z = vec3 (a + x) (b + y) (c + z)

swap₀₁ : ℤ³ → ℤ³
swap₀₁ (vec3 a b c) = vec3 b a c

swap₁₂ : ℤ³ → ℤ³
swap₁₂ (vec3 a b c) = vec3 a c b

-- The generator actions are ℤ-linear under coordinatewise addition.
swap₀₁-linear : (u v : ℤ³) → swap₀₁ (u +³ v) ≡ swap₀₁ u +³ swap₀₁ v
swap₀₁-linear (vec3 a b c) (vec3 x y z) = refl

swap₁₂-linear : (u v : ℤ³) → swap₁₂ (u +³ v) ≡ swap₁₂ u +³ swap₁₂ v
swap₁₂-linear (vec3 a b c) (vec3 x y z) = refl

one : ℤ
one = pos 1

radial : ℤ³
radial = vec3 one one one

radial-fixed-₀₁ : swap₀₁ radial ≡ radial
radial-fixed-₀₁ = refl

radial-fixed-₁₂ : swap₁₂ radial ≡ radial
radial-fixed-₁₂ = refl

-- Augmentation is the coordinate sum.  Parentheses are fixed as a+(b+c).
augmentation : ℤ³ → ℤ
augmentation (vec3 a b c) = a + (b + c)

augmentation-additive : (u v : ℤ³)
  → augmentation (u +³ v) ≡ augmentation u + augmentation v
augmentation-additive (vec3 a b c) (vec3 x y z) = solve! ℤCommRing

augmentation-swap₀₁ : (v : ℤ³) → augmentation (swap₀₁ v) ≡ augmentation v
augmentation-swap₀₁ (vec3 a b c) = solve! ℤCommRing

augmentation-swap₁₂ : (v : ℤ³) → augmentation (swap₁₂ v) ≡ augmentation v
augmentation-swap₁₂ (vec3 a b c) = solve! ℤCommRing

zeroℤ : ℤ
zeroℤ = pos 0

Relative : ℤ³ → Type₀
Relative v = augmentation v ≡ zeroℤ

relative-preserved-₀₁ : (v : ℤ³) → Relative v → Relative (swap₀₁ v)
relative-preserved-₀₁ v p = augmentation-swap₀₁ v ∙ p

relative-preserved-₁₂ : (v : ℤ³) → Relative v → Relative (swap₁₂ v)
relative-preserved-₁₂ v p = augmentation-swap₁₂ v ∙ p

-- Linearization of the three point interface: each point becomes a basis
-- vector, and augmentation sends every basis vector to the same scalar one.
basis : Fin3 → ℤ³
basis fzero = vec3 one zeroℤ zeroℤ
basis (fsuc fzero) = vec3 zeroℤ one zeroℤ
basis (fsuc (fsuc fzero)) = vec3 zeroℤ zeroℤ one

augmentation-basis : (x : Fin3) → augmentation (basis x) ≡ one
augmentation-basis fzero = refl
augmentation-basis (fsuc fzero) = refl
augmentation-basis (fsuc (fsuc fzero)) = refl

-- Thus the finite equivariant collapse Fin3→Unit has this exact additive
-- shadow: all three distinguishable basis states share augmentation one.
augmentation-collapses-basis : (x y : Fin3)
  → augmentation (basis x) ≡ augmentation (basis y)
augmentation-collapses-basis x y = augmentation-basis x ∙ sym (augmentation-basis y)

scalarCollapse : ℤ → Unit
scalarCollapse z = tt

collapse-augmentation-square : (x : Fin3)
  → scalarCollapse (augmentation (basis x)) ≡ map terminalVertex x
collapse-augmentation-square x = refl
