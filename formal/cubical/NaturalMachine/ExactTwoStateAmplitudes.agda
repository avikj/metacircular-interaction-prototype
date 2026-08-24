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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ExactTwoStateAmplitudes
--
-- The smallest exact amplitude realization used by the Natural Machine:
-- two-component vectors over Gaussian integers, unnormalized Born weights,
-- and norm-preserving Pauli X/Z and central Z4 phase actions.
--
-- There is no floating point and no square root.  Consequently the checked
-- observable quantities here are integer weights, not normalized
-- probabilities.  Dividing by total weight belongs to a later rational
-- interface and normalized state vectors would require a larger scalar type.
------------------------------------------------------------------------

module NaturalMachine.ExactTwoStateAmplitudes where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Nat
  using (ℕ) renaming (_+_ to _+ℕ_ ; _·_ to _·ℕ_ ; +-comm to +ℕ-comm)
open import Cubical.Data.Int
  using (ℤ ; pos ; negsuc ; abs ; -_ ; abs-)

import NaturalMachine.PauliWeyl as Weyl
import NaturalMachine.PauliJointPhaseRealization as Phase
import NaturalMachine.UnivalentTensorInteraction as Joint

------------------------------------------------------------------------
-- 1. Gaussian-integer amplitudes and exact weights
------------------------------------------------------------------------

Gaussian : Type₀
Gaussian = ℤ × ℤ

zeroG oneG : Gaussian
zeroG = pos 0 , pos 0
oneG  = pos 1 , pos 0

negG : Gaussian → Gaussian
negG (a , b) = - a , - b

iG : Gaussian → Gaussian
iG (a , b) = - b , a

squareMagnitude : ℤ → ℕ
squareMagnitude z = abs z ·ℕ abs z

amplitudeWeight : Gaussian → ℕ
amplitudeWeight (a , b) = squareMagnitude a +ℕ squareMagnitude b

squareMagnitude-neg : (z : ℤ) → squareMagnitude (- z) ≡ squareMagnitude z
squareMagnitude-neg z = cong₂ _·ℕ_ (abs- z) (abs- z)

weight-neg : (z : Gaussian) → amplitudeWeight (negG z) ≡ amplitudeWeight z
weight-neg (a , b) =
  cong₂ _+ℕ_ (squareMagnitude-neg a) (squareMagnitude-neg b)

weight-i : (z : Gaussian) → amplitudeWeight (iG z) ≡ amplitudeWeight z
weight-i (a , b) =
  cong₂ _+ℕ_ (squareMagnitude-neg b) refl
  ∙ +ℕ-comm (squareMagnitude b) (squareMagnitude a)

------------------------------------------------------------------------
-- 2. Two-state amplitudes and Pauli X/Z
------------------------------------------------------------------------

State₂ : Type₀
State₂ = Gaussian × Gaussian

weight₀ weight₁ : State₂ → ℕ
weight₀ (α , β) = amplitudeWeight α
weight₁ (α , β) = amplitudeWeight β

norm² : State₂ → ℕ
norm² state = weight₀ state +ℕ weight₁ state

X Z : State₂ → State₂
X (α , β) = β , α
Z (α , β) = α , negG β

X-preserves-norm² : (state : State₂) → norm² (X state) ≡ norm² state
X-preserves-norm² (α , β) =
  +ℕ-comm (amplitudeWeight β) (amplitudeWeight α)

Z-preserves-norm² : (state : State₂) → norm² (Z state) ≡ norm² state
Z-preserves-norm² (α , β) =
  cong (amplitudeWeight α +ℕ_) (weight-neg β)

X-swaps-Born-weights : (state : State₂)
  → (weight₀ (X state) ≡ weight₁ state)
    × (weight₁ (X state) ≡ weight₀ state)
X-swaps-Born-weights state = refl , refl

Z-preserves-Born-weights : (state : State₂)
  → (weight₀ (Z state) ≡ weight₀ state)
    × (weight₁ (Z state) ≡ weight₁ state)
Z-preserves-Born-weights (α , β) = refl , weight-neg β

------------------------------------------------------------------------
-- 3. The checked Pauli Z4 phase chart acts on amplitudes
------------------------------------------------------------------------

phaseActionG : Weyl.Z4 → Gaussian → Gaussian
phaseActionG Weyl.ph0 z = z
phaseActionG Weyl.ph1 z = iG z
phaseActionG Weyl.ph2 z = negG z
phaseActionG Weyl.ph3 (a , b) = b , - a

phaseActionG-preserves-weight : (phase : Weyl.Z4) (z : Gaussian)
  → amplitudeWeight (phaseActionG phase z) ≡ amplitudeWeight z
phaseActionG-preserves-weight Weyl.ph0 z = refl
phaseActionG-preserves-weight Weyl.ph1 z = weight-i z
phaseActionG-preserves-weight Weyl.ph2 z = weight-neg z
phaseActionG-preserves-weight Weyl.ph3 (a , b) =
  cong (squareMagnitude b +ℕ_) (squareMagnitude-neg a)
  ∙ +ℕ-comm (squareMagnitude b) (squareMagnitude a)

phaseAction : Weyl.Z4 → State₂ → State₂
phaseAction phase (α , β) =
  phaseActionG phase α , phaseActionG phase β

phaseAction-preserves-norm² : (phase : Weyl.Z4) (state : State₂)
  → norm² (phaseAction phase state) ≡ norm² state
phaseAction-preserves-norm² phase (α , β) =
  cong₂ _+ℕ_ (phaseActionG-preserves-weight phase α)
               (phaseActionG-preserves-weight phase β)

-- Pull the already checked central Pauli chart through its phase coordinate.
jointPhaseAction : Joint.JointCoherence → State₂ → State₂
jointPhaseAction joint = phaseAction (Phase.phaseCoordinate (Phase.realizePhase joint))

plus-acts-identically : (state : State₂)
  → jointPhaseAction Joint.plus state ≡ state
plus-acts-identically state = refl

minus-acts-by-global-negation : (α β : Gaussian)
  → jointPhaseAction Joint.minus (α , β) ≡ (negG α , negG β)
minus-acts-by-global-negation α β = refl

joint-phase-preserves-norm² : (joint : Joint.JointCoherence) (state : State₂)
  → norm² (jointPhaseAction joint state) ≡ norm² state
joint-phase-preserves-norm² joint state =
  phaseAction-preserves-norm²
    (Phase.phaseCoordinate (Phase.realizePhase joint)) state

-- These two phases are not merely labels: PauliJointPhaseRealization proves
-- that the R0 and C2 commuting products are respectively the central Pauli
-- operators whose coordinates act here as identity and global negation.
r0-amplitude-action : (state : State₂)
  → phaseAction (Phase.phaseCoordinate
      (Weyl.XI Weyl.·P Weyl.IX Weyl.·P Weyl.XX)) state
    ≡ state
r0-amplitude-action state = refl

c2-amplitude-action : (α β : Gaussian)
  → phaseAction (Phase.phaseCoordinate
      (Weyl.XX Weyl.·P Weyl.YY Weyl.·P Weyl.ZZ)) (α , β)
    ≡ (negG α , negG β)
c2-amplitude-action α β = refl

------------------------------------------------------------------------
-- Rigor boundary
--
-- Checked: exact Gaussian-integer two-state amplitudes; natural-number
-- squared weights; norm-preserving X, Z, and Z4 global phases; and the state
-- action of the already checked R0/C2 central Pauli products.
--
-- Not claimed: normalized probabilities, completeness of ℂ, a Hilbert-space
-- model, measurement dynamics, or a faithful action of every PauliWeyl datum.
-- The two weights become Born probabilities only after division by a nonzero
-- total norm, an intentionally absent rational/normalization layer.
------------------------------------------------------------------------
