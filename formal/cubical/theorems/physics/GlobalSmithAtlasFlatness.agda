{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- GlobalSmithAtlasFlatness
--
-- A global coordinate chart on a Smith kernel is an isomorphism from one
-- common kernel type into a chart type.  The transition from chart i to chart
-- j is therefore c_j ∘ c_i⁻¹.  Such transitions obey the cocycle law by
-- inverse cancellation, and every closed triangle is the identity.
--
-- This closes the holonomy seed of SMITH_KERNEL_QUANTUM_BOUNDARY negatively:
-- global Smith relabellings can be individually nontrivial, but cannot create
-- nontrivial loop holonomy.  A genuine residual needs local/partial charts,
-- path-dependent transport, or a process that changes the fiber.
------------------------------------------------------------------------

module GlobalSmithAtlasFlatness where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isSet×)
open import Cubical.Foundations.Isomorphism
  using (Iso ; isoToEquiv)
open import Cubical.Data.Bool
  using (Bool ; false ; true ; not ; true≢false ; isSetBool)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Functions.Embedding using (isEmbedding)

import CertificateFibration as Cert
import FiniteInformation as FI

private
  variable
    ℓk ℓi ℓj ℓl : Level
    K : Type ℓk
    Cᵢ : Type ℓi
    Cⱼ : Type ℓj
    Cₗ : Type ℓl

------------------------------------------------------------------------
-- 1. Global charts generate their transition maps
------------------------------------------------------------------------

transition : Iso K Cᵢ → Iso K Cⱼ → Cᵢ → Cⱼ
transition from to coordinate = Iso.fun to (Iso.inv from coordinate)

transitionIso : (from : Iso K Cᵢ) (to : Iso K Cⱼ) → Iso Cᵢ Cⱼ
Iso.fun      (transitionIso from to) = transition from to
Iso.inv      (transitionIso from to) coordinate =
  Iso.fun from (Iso.inv to coordinate)
Iso.rightInv (transitionIso from to) coordinate =
  cong (Iso.fun to) (Iso.leftInv from (Iso.inv to coordinate))
  ∙ Iso.rightInv to coordinate
Iso.leftInv  (transitionIso from to) coordinate =
  cong (Iso.fun from) (Iso.leftInv to (Iso.inv from coordinate))
  ∙ Iso.rightInv from coordinate

-- Pairwise route changes are closed reversible processes: a singleton side
-- record completes them exactly.
unitCertificate : {X : Type ℓi} → X → Unit
unitCertificate _ = tt

transition-unit-completes :
  (from : Iso K Cᵢ) (to : Iso K Cⱼ)
  → FI.Completes (transition from to) unitCertificate
transition-unit-completes from to left right equality =
  sym (Iso.leftInv (transitionIso from to) left)
  ∙ cong (Iso.inv (transitionIso from to)) (cong fst equality)
  ∙ Iso.leftInv (transitionIso from to) right

transition-unit-attains :
  (from : Iso K Cᵢ) (to : Iso K Cⱼ)
  → isSet Cⱼ
  → isEmbedding
      (Cert.recorded (transition from to) unitCertificate)
transition-unit-attains from to isSetTarget =
  Cert.Completes→isEmbedding (transition from to) unitCertificate
    isSetTarget isSetUnit (transition-unit-completes from to)

------------------------------------------------------------------------
-- 2. The cocycle and triangle-flatness no-go
------------------------------------------------------------------------

transition-cocycle :
  (chart₀ : Iso K Cᵢ)
  (chart₁ : Iso K Cⱼ)
  (chart₂ : Iso K Cₗ)
  (coordinate : Cᵢ)
  → transition chart₁ chart₂ (transition chart₀ chart₁ coordinate)
    ≡ transition chart₀ chart₂ coordinate
transition-cocycle chart₀ chart₁ chart₂ coordinate =
  cong (Iso.fun chart₂)
    (Iso.leftInv chart₁ (Iso.inv chart₀ coordinate))

triangle-flat :
  (chart₀ : Iso K Cᵢ)
  (chart₁ : Iso K Cⱼ)
  (chart₂ : Iso K Cₗ)
  (coordinate : Cᵢ)
  → transition chart₂ chart₀
      (transition chart₁ chart₂
        (transition chart₀ chart₁ coordinate))
    ≡ coordinate
triangle-flat chart₀ chart₁ chart₂ coordinate =
  cong (transition chart₂ chart₀)
    (transition-cocycle chart₀ chart₁ chart₂ coordinate)
  ∙ cong (Iso.fun chart₀)
      (Iso.leftInv chart₂ (Iso.inv chart₀ coordinate))
  ∙ Iso.rightInv chart₀ coordinate

-- Any claimed nonidentity witness for a loop of global charts is impossible.
global-holonomy-no-go :
  (chart₀ : Iso K Cᵢ)
  (chart₁ : Iso K Cⱼ)
  (chart₂ : Iso K Cₗ)
  (coordinate : Cᵢ)
  → (transition chart₂ chart₀
       (transition chart₁ chart₂
         (transition chart₀ chart₁ coordinate))
       ≡ coordinate → ⊥)
  → ⊥
global-holonomy-no-go chart₀ chart₁ chart₂ coordinate nonidentity =
  nonidentity (triangle-flat chart₀ chart₁ chart₂ coordinate)

------------------------------------------------------------------------
-- 3. Non-vacuous (Z/2)² atlas: nonidentity edges, identity loop
------------------------------------------------------------------------

Kernel : Type₀
Kernel = Bool × Bool

isSetKernel : isSet Kernel
isSetKernel = isSet× isSetBool isSetBool

identityChart : Iso Kernel Kernel
Iso.fun      identityChart kernel = kernel
Iso.inv      identityChart kernel = kernel
Iso.rightInv identityChart _ = refl
Iso.leftInv  identityChart _ = refl

swapKernel : Kernel → Kernel
swapKernel (left , right) = right , left

swap-involutive : (kernel : Kernel) → swapKernel (swapKernel kernel) ≡ kernel
swap-involutive (_ , _) = refl

swapChart : Iso Kernel Kernel
Iso.fun      swapChart = swapKernel
Iso.inv      swapChart = swapKernel
Iso.rightInv swapChart = swap-involutive
Iso.leftInv  swapChart = swap-involutive

flipFirst : Kernel → Kernel
flipFirst (left , right) = not left , right

flipFirst-involutive : (kernel : Kernel)
  → flipFirst (flipFirst kernel) ≡ kernel
flipFirst-involutive (false , _) = refl
flipFirst-involutive (true  , _) = refl

flipChart : Iso Kernel Kernel
Iso.fun      flipChart = flipFirst
Iso.inv      flipChart = flipFirst
Iso.rightInv flipChart = flipFirst-involutive
Iso.leftInv  flipChart = flipFirst-involutive

edgeWitness : Kernel
edgeWitness = false , true

-- The first chart change is genuinely nonidentity.
identity-to-swap-is-nontrivial :
  transition identityChart swapChart edgeWitness ≡ edgeWitness → ⊥
identity-to-swap-is-nontrivial equality = true≢false (cong fst equality)

-- So is the direct identity-to-flip transition.
identity-to-flip-is-nontrivial :
  transition identityChart flipChart edgeWitness ≡ edgeWitness → ⊥
identity-to-flip-is-nontrivial equality = true≢false (cong fst equality)

-- Nevertheless the three-edge loop is exactly flat.
concrete-triangle-flat :
  transition flipChart identityChart
    (transition swapChart flipChart
      (transition identityChart swapChart edgeWitness))
  ≡ edgeWitness
concrete-triangle-flat =
  triangle-flat identityChart swapChart flipChart edgeWitness

-- Every concrete edge is a zero-garbage (Unit-environment) process.
identity-swap-unit-attains :
  isEmbedding
    (Cert.recorded (transition identityChart swapChart) unitCertificate)
identity-swap-unit-attains =
  transition-unit-attains identityChart swapChart isSetKernel

swap-flip-unit-attains :
  isEmbedding
    (Cert.recorded (transition swapChart flipChart) unitCertificate)
swap-flip-unit-attains =
  transition-unit-attains swapChart flipChart isSetKernel

flip-identity-unit-attains :
  isEmbedding
    (Cert.recorded (transition flipChart identityChart) unitCertificate)
flip-identity-unit-attains =
  transition-unit-attains flipChart identityChart isSetKernel

