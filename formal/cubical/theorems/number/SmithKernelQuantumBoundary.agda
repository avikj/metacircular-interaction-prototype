{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SmithKernelQuantumBoundary
--
-- Exact finite process content of the Smith-kernel comparison.
--
-- For the compatible system
--
--     2x = b₁,  2y = b₂  (mod 30),
--
-- each scalar equation has a two-element homogeneous kernel, so the joint
-- solution fiber is (Z/2)².  We model that kernel by Bool × Bool.  The map
-- from a solution state to its retained output therefore needs a four-state
-- environment, in the precise type-level sense that Bool × Bool embeds into
-- every exact certificate alphabet.  The kernel coordinate itself attains
-- the bound.
--
-- Two sequential elimination orders do not produce literally the same
-- coordinate.  x-then-y records (εx,εy), while y-then-x records (εy,εx).
-- Both coordinates complete the same map and are related by the nontrivial
-- involution `swapKernel`.  Thus the common Smith kernel fixes the memory
-- type, while reversible interoperability additionally needs the explicit
-- alignment automorphism.
--
-- This module checks the four-state control and the alignment no-go.  The
-- elementary general arithmetic formula
--
--     |ker A| = gcd(d₁,m) gcd(d₂,m),  when U A V = diag(d₁,d₂),
--
-- promoted here to a formal integer-matrix development.
------------------------------------------------------------------------

module SmithKernelQuantumBoundary where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Foundations.HLevels using (isSet×)
open import Cubical.Foundations.Isomorphism
  using (Iso ; invIso ; isoToEquiv)
open import Cubical.Data.Bool
  using (Bool ; false ; true ; false≢true ; isSetBool)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Sigma
  using (_×_ ; _,_ ; fst ; snd ; Σ≡Prop ; ΣPathP)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Functions.Embedding
  using (isEmbedding ; _↪_ ; Equiv→Embedding ; compEmbedding)

import CertificateFibration as Cert
import FiniteInformation as FI

------------------------------------------------------------------------
-- 1. The four-element Smith kernel and its solved-state projection
------------------------------------------------------------------------

Output : Type₀
Output = Bool

SmithKernel : Type₀
SmithKernel = Bool × Bool

SolvedState : Type₀
SolvedState = Output × SmithKernel

isSetSmithKernel : isSet SmithKernel
isSetSmithKernel = isSet× isSetBool isSetBool

isSetSolvedState : isSet SolvedState
isSetSolvedState = isSet× isSetBool isSetSmithKernel

solvedOutput : SolvedState → Output
solvedOutput = fst

xyCoordinate : SolvedState → SmithKernel
xyCoordinate = snd

solvedFiberIso : (output : Output)
  → Iso (fiber solvedOutput output) SmithKernel
Iso.fun      (solvedFiberIso output) ((_ , kernel) , _) = kernel
Iso.inv      (solvedFiberIso output) kernel             = (output , kernel) , refl
Iso.rightInv (solvedFiberIso output) _                  = refl
Iso.leftInv  (solvedFiberIso output) ((output' , kernel) , path) =
  Σ≡Prop (λ _ → isSetBool _ _) (ΣPathP (sym path , refl))

-- Every exact coherent certificate contains the complete four-state kernel.
smith-environment-lower : {Environment : Type₀}
  (certificate : SolvedState → Environment)
  → isEmbedding (Cert.recorded solvedOutput certificate)
  → SmithKernel ↪ Environment
smith-environment-lower certificate embedding =
  compEmbedding
    (Cert.fiber↪cert solvedOutput certificate embedding false)
    (Equiv→Embedding
      (isoToEquiv (invIso (solvedFiberIso false))))

-- Solving x before y records the ordered pair (εx,εy), and attains the bound.
xy-completes : FI.Completes solvedOutput xyCoordinate
xy-completes (_ , _) (_ , _) equality = equality

xy-environment-attains :
  isEmbedding (Cert.recorded solvedOutput xyCoordinate)
xy-environment-attains =
  Cert.Completes→isEmbedding solvedOutput xyCoordinate
    isSetBool isSetSmithKernel xy-completes

------------------------------------------------------------------------
-- 2. Reversing elimination order is a nontrivial kernel automorphism
------------------------------------------------------------------------

swapKernel : SmithKernel → SmithKernel
swapKernel (left , right) = right , left

swapKernel-involutive : (kernel : SmithKernel)
  → swapKernel (swapKernel kernel) ≡ kernel
swapKernel-involutive (_ , _) = refl

yxCoordinate : SolvedState → SmithKernel
yxCoordinate state = swapKernel (xyCoordinate state)

-- The reversed coordinate also completes exactly the same retained map.
yx-completes : FI.Completes solvedOutput yxCoordinate
yx-completes
  (output , (xKernel , yKernel))
  (output' , (xKernel' , yKernel'))
  equality =
    cong
      (λ recorded →
        fst recorded , (snd (snd recorded) , fst (snd recorded)))
      equality

yx-environment-attains :
  isEmbedding (Cert.recorded solvedOutput yxCoordinate)
yx-environment-attains =
  Cert.Completes→isEmbedding solvedOutput yxCoordinate
    isSetBool isSetSmithKernel yx-completes

-- The transition map is exact and self-inverse.
order-alignment : (state : SolvedState)
  → yxCoordinate state ≡ swapKernel (xyCoordinate state)
order-alignment _ = refl

-- It is not the identity: the two lawful records disagree on this state.
alignmentWitness : SolvedState
alignmentWitness = false , (false , true)

alignment-is-nontrivial :
  xyCoordinate alignmentWitness ≡ yxCoordinate alignmentWitness → ⊥
alignment-is-nontrivial equality = false≢true (cong fst equality)

coordinates-are-not-equal : xyCoordinate ≡ yxCoordinate → ⊥
coordinates-are-not-equal equality =
  alignment-is-nontrivial (cong (λ coordinate → coordinate alignmentWitness) equality)

------------------------------------------------------------------------
-- 3. Unit-determinant / singleton-kernel control
------------------------------------------------------------------------

UnitSolvedState : Type₀
UnitSolvedState = Output × Unit

unitOutput : UnitSolvedState → Output
unitOutput = fst

unitCoordinate : UnitSolvedState → Unit
unitCoordinate = snd

unitFiberIso : (output : Output) → Iso (fiber unitOutput output) Unit
Iso.fun      (unitFiberIso output) ((_ , tt) , _) = tt
Iso.inv      (unitFiberIso output) tt              = (output , tt) , refl
Iso.rightInv (unitFiberIso output) _               = refl
Iso.leftInv  (unitFiberIso output) ((output' , tt) , path) =
  Σ≡Prop (λ _ → isSetBool _ _) (ΣPathP (sym path , refl))

unit-environment-lower : {Environment : Type₀}
  (certificate : UnitSolvedState → Environment)
  → isEmbedding (Cert.recorded unitOutput certificate)
  → Unit ↪ Environment
unit-environment-lower certificate embedding =
  compEmbedding
    (Cert.fiber↪cert unitOutput certificate embedding false)
    (Equiv→Embedding (isoToEquiv (invIso (unitFiberIso false))))

unit-completes : FI.Completes unitOutput unitCoordinate
unit-completes (_ , _) (_ , _) equality = equality

unit-environment-attains :
  isEmbedding (Cert.recorded unitOutput unitCoordinate)
unit-environment-attains =
  Cert.Completes→isEmbedding unitOutput unitCoordinate
    isSetBool isSetUnit unit-completes

