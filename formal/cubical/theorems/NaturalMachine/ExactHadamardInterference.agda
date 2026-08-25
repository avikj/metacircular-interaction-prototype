{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ExactHadamardInterference
--
-- Unnormalised Hadamard interference over Gaussian integers.  Avoiding the
-- factor 1/sqrt(2) keeps the transform inside the exact scalar system: its
-- quadratic norm scales by exactly 2 and its square is scalar multiplication
-- by 2.  Equal and opposite relative phases exit through opposite ports.
------------------------------------------------------------------------

module NaturalMachine.ExactHadamardInterference where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; ΣPathP)
open import Cubical.Data.Bool using (true ; false)
open import Cubical.Data.Int using (ℤ)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

open CommRingStr (ℤCommRing .snd)
  using (0r ; 1r ; _+_ ; _·_ ; -_ ; _-_)

import NaturalMachine.ExactTwoStateAmplitudes as Amp
import NaturalMachine.UnivalentTensorInteraction as Joint

Gaussian : Type₀
Gaussian = Amp.Gaussian

State₂ : Type₀
State₂ = Amp.State₂

zeroG : Gaussian
zeroG = 0r , 0r

_+G_ _-G_ : Gaussian → Gaussian → Gaussian
(a , b) +G (c , d) = a + c , b + d
(a , b) -G (c , d) = a - c , b - d

scale₂G : Gaussian → Gaussian
scale₂G z = z +G z

scale₂State : State₂ → State₂
scale₂State (α , β) = scale₂G α , scale₂G β

-- Integer presentation of the same sum-of-squares expression whose absolute
-- magnitudes define Amp.norm².  It is used because the commutative-ring
-- identity is exact without a case split over integer signs.
quadraticWeight : Gaussian → ℤ
quadraticWeight (a , b) = a · a + b · b

quadraticNorm² : State₂ → ℤ
quadraticNorm² (α , β) = quadraticWeight α + quadraticWeight β

H : State₂ → State₂
H (α , β) = α +G β , α -G β

H-scales-norm-by-two : (state : State₂)
  → quadraticNorm² (H state) ≡ (1r + 1r) · quadraticNorm² state
H-scales-norm-by-two ((a , b) , (c , d)) = solve! ℤCommRing

gaussianPath : {x y : Gaussian}
  → fst x ≡ fst y → snd x ≡ snd y → x ≡ y
gaussianPath p q = ΣPathP (p , q)

statePath : {x y : State₂}
  → fst x ≡ fst y → snd x ≡ snd y → x ≡ y
statePath p q = ΣPathP (p , q)

H²-scales-by-two : (state : State₂) → H (H state) ≡ scale₂State state
H²-scales-by-two ((a , b) , (c , d)) =
  statePath
    (gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))
    (gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))

------------------------------------------------------------------------
-- Relative phase becomes a deterministic output port
------------------------------------------------------------------------

plusState minusState : Gaussian → State₂
plusState α = α , α
minusState α = α , Amp.negG α

plus-interferes-to-port₀ : (α : Gaussian)
  → H (plusState α) ≡ (scale₂G α , zeroG)
plus-interferes-to-port₀ (a , b) =
  statePath
    (gaussianPath refl refl)
    (gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))

minus-interferes-to-port₁ : (α : Gaussian)
  → H (minusState α) ≡ (zeroG , scale₂G α)
minus-interferes-to-port₁ (a , b) =
  statePath
    (gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))
    (gaussianPath (solve! ℤCommRing) (solve! ℤCommRing))

-- The interaction-relative compiler already proved that the joint port keeps
-- the phase which the separate-population port loses.  This map realizes that
-- reopened Bool phase as the two interference inputs above.
reopenedState : Joint.Compiled Joint.jointInterference → Gaussian → State₂
reopenedState true  = plusState
reopenedState false = minusState

reopened-plus-port : (α : Gaussian)
  → H (reopenedState (Joint.compile Joint.jointInterference Joint.plus) α)
    ≡ (scale₂G α , zeroG)
reopened-plus-port = plus-interferes-to-port₀

reopened-minus-port : (α : Gaussian)
  → H (reopenedState (Joint.compile Joint.jointInterference Joint.minus) α)
    ≡ (zeroG , scale₂G α)
reopened-minus-port = minus-interferes-to-port₁

------------------------------------------------------------------------
-- Rigor boundary
--
-- Checked: the Gaussian-integer Hadamard formula, its exact quadratic norm
-- factor 2, H² = 2I, and opposite deterministic ports for equal/opposite
-- phase inputs, including the existing reopened joint-phase compiler.
--
-- Not claimed: unitary normalization.  H/sqrt(2) is not an endomorphism of
-- Gaussian-integer states.  `quadraticNorm²` is the ring presentation of the
-- sum of four integer squares; this file does not rebuild the order-theoretic
-- bridge to Amp's natural-number weights or divide those weights into
-- probabilities.
------------------------------------------------------------------------
