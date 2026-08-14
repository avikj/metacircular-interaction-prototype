{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.RelationalHolonomyInteraction
--
-- Hostile bridge check: endpoint gauge covariance really can be expressed
-- as interaction-relative transport, but only after the gauge pair is
-- supplied as the interaction.  No global gauge fixing is constructed.
--
-- This is finite group-valued lattice-gauge kinematics.  It is not RQM or
-- LQG, and it adds no dynamics, amplitudes, constraints, or empirical claim.
------------------------------------------------------------------------

module NaturalMachine.RelationalHolonomyInteraction where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≣_)
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Foundations.Isomorphism
  using (Iso ; iso ; compIso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua ; uaβ)
open import Cubical.Data.Prod using (_×_ ; _,_)
open import Cubical.Algebra.Group.Base using (Group ; GroupStr)
open import Cubical.Algebra.Group.Properties using (module GroupTheory)

import NaturalMachine.RelationalHolonomyRefinement as Hol
import NaturalMachine.RelationalProcessCore as Rel

module _ {ℓ : Level} (G : Group ℓ) where

  private
    module 𝒢 = GroupStr (snd G)
    module 𝒢T = GroupTheory 𝒢

  leftMultiplyIso : (a : ⟨ G ⟩) → Iso ⟨ G ⟩ ⟨ G ⟩
  Iso.fun (leftMultiplyIso a) x = a 𝒢.· x
  Iso.inv (leftMultiplyIso a) x = 𝒢.inv a 𝒢.· x
  Iso.rightInv (leftMultiplyIso a) x =
      sym (𝒢.·Assoc a (𝒢.inv a) x)
    ∙ cong (𝒢._· x) (𝒢.·InvR a)
    ∙ 𝒢.·IdL x
  Iso.leftInv (leftMultiplyIso a) x =
      sym (𝒢.·Assoc (𝒢.inv a) a x)
    ∙ cong (𝒢._· x) (𝒢.·InvL a)
    ∙ 𝒢.·IdL x

  rightMultiplyIso : (a : ⟨ G ⟩) → Iso ⟨ G ⟩ ⟨ G ⟩
  Iso.fun (rightMultiplyIso a) x = x 𝒢.· a
  Iso.inv (rightMultiplyIso a) x = x 𝒢.· 𝒢.inv a
  Iso.rightInv (rightMultiplyIso a) x =
      𝒢.·Assoc x (𝒢.inv a) a
    ∙ cong (x 𝒢.·_) (𝒢.·InvL a)
    ∙ 𝒢.·IdR x
  Iso.leftInv (rightMultiplyIso a) x =
      𝒢.·Assoc x a (𝒢.inv a)
    ∙ cong (x 𝒢.·_) (𝒢.·InvR a)
    ∙ 𝒢.·IdR x

  -- Endpoint covariance is invertible: t acts on the left and s⁻¹ on
  -- the right.  This construction uses only the supplied endpoint pair.
  endpointGaugeIso : (⟨ G ⟩ × ⟨ G ⟩) → Iso ⟨ G ⟩ ⟨ G ⟩
  endpointGaugeIso (s , t) =
    compIso (leftMultiplyIso t) (rightMultiplyIso (𝒢.inv s))

  endpointGaugeEquiv : (⟨ G ⟩ × ⟨ G ⟩) → ⟨ G ⟩ ≣ ⟨ G ⟩
  endpointGaugeEquiv u = isoToEquiv (endpointGaugeIso u)

  endpointGaugeEquiv-computes : (u : ⟨ G ⟩ × ⟨ G ⟩) (g : ⟨ G ⟩)
    → fst (endpointGaugeEquiv u) g ≡ Hol.endpointGauge G u g
  endpointGaugeEquiv-computes (s , t) g = refl

  -- Types are loci and their elements are the relative facts available at
  -- those loci.  Univalence turns the supplied reversible endpoint change
  -- into an interaction path; it does not identify all gauges globally.
  GaugePresentationProcess : Rel.RelativeProcess
  Rel.Locus GaugePresentationProcess = Type ℓ
  Rel.Fact  GaugePresentationProcess X = X

  endpointInteraction : (u : ⟨ G ⟩ × ⟨ G ⟩) (g : ⟨ G ⟩)
    → Rel.Interaction GaugePresentationProcess ⟨ G ⟩ ⟨ G ⟩
  Rel.path   (endpointInteraction u g) = ua (endpointGaugeEquiv u)
  Rel.before (endpointInteraction u g) = g
  Rel.after  (endpointInteraction u g) = Hol.endpointGauge G u g
  Rel.lawful (endpointInteraction u g) =
    uaβ (endpointGaugeEquiv u) g ∙ endpointGaugeEquiv-computes u g

  -- The pre-existing refinement covariance theorem is exactly the statement
  -- that refined holonomy lands at the `after` fact of this interaction.
  refinement-realizes-endpoint-interaction :
    (u : ⟨ G ⟩ × ⟨ G ⟩) (x : Hol.Refined G)
    → Hol.holonomy G (Hol.refinedEndpointGauge G u x)
      ≡ Rel.after (endpointInteraction u (Hol.holonomy G x))
  refinement-realizes-endpoint-interaction = Hol.holonomy-endpointGauge G

  -- Scope boundary: `endpointInteraction` requires `u` as input.  Its type
  -- supplies no section choosing one endpoint gauge for every connection,
  -- and none is used by the covariance bridge.
