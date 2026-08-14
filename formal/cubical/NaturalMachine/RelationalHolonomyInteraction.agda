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
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Foundations.Isomorphism
  using (Iso ; iso ; compIso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua ; uaβ)
open import Cubical.Data.Prod using (_×_ ; _,_)
open import Cubical.Algebra.Group.Base using (Group ; GroupStr)

import NaturalMachine.RelationalHolonomyRefinement as Hol
import NaturalMachine.RelationalProcessCore as Rel

module _ {ℓ : Level} (G : Group ℓ) where

  private
    module GS = GroupStr (snd G)

  leftMultiplyIso : (a : ⟨ G ⟩) → Iso ⟨ G ⟩ ⟨ G ⟩
  Iso.fun (leftMultiplyIso a) x = a GS.· x
  Iso.inv (leftMultiplyIso a) x = GS.inv a GS.· x
  Iso.rightInv (leftMultiplyIso a) x =
      sym (GS.·Assoc (GS.inv a) a x)
    ∙ cong₂ GS._·_ (GS.·InvL a) refl
    ∙ GS.·IdL x
  Iso.leftInv (leftMultiplyIso a) x =
      sym (GS.·Assoc a (GS.inv a) x)
    ∙ cong₂ GS._·_ (GS.·InvR a) refl
    ∙ GS.·IdL x

  rightMultiplyIso : (a : ⟨ G ⟩) → Iso ⟨ G ⟩ ⟨ G ⟩
  Iso.fun (rightMultiplyIso a) x = x GS.· a
  Iso.inv (rightMultiplyIso a) x = x GS.· GS.inv a
  Iso.rightInv (rightMultiplyIso a) x =
      GS.·Assoc x (GS.inv a) a
    ∙ cong₂ GS._·_ refl (GS.·InvL a)
    ∙ GS.·IdR x
  Iso.leftInv (rightMultiplyIso a) x =
      GS.·Assoc x a (GS.inv a)
    ∙ cong₂ GS._·_ refl (GS.·InvR a)
    ∙ GS.·IdR x

  -- Endpoint covariance is invertible: t acts on the left and s⁻¹ on
  -- the right.  This construction uses only the supplied endpoint pair.
  endpointGaugeIso : (⟨ G ⟩ × ⟨ G ⟩) → Iso ⟨ G ⟩ ⟨ G ⟩
  endpointGaugeIso (s , t) =
    compIso (leftMultiplyIso t) (rightMultiplyIso (GS.inv s))

  endpointGaugeEquiv-computes : (u : ⟨ G ⟩ × ⟨ G ⟩) (g : ⟨ G ⟩)
    → Iso.fun (endpointGaugeIso u) g ≡ Hol.endpointGauge G u g
  endpointGaugeEquiv-computes (s , t) g = refl

  -- Types are loci and their elements are the relative facts available at
  -- those loci.  Univalence turns the supplied reversible endpoint change
  -- into an interaction path; it does not identify all gauges globally.
  GaugePresentationProcess : Rel.RelativeProcess
  Rel.Locus GaugePresentationProcess = Type ℓ
  Rel.Fact  GaugePresentationProcess X = X

  endpointInteraction : (u : ⟨ G ⟩ × ⟨ G ⟩) (g : ⟨ G ⟩)
    → Rel.Interaction GaugePresentationProcess ⟨ G ⟩ ⟨ G ⟩
  Rel.path   (endpointInteraction u g) = ua (isoToEquiv (endpointGaugeIso u))
  Rel.before (endpointInteraction u g) = g
  Rel.after  (endpointInteraction u g) = Hol.endpointGauge G u g
  Rel.lawful (endpointInteraction u g) =
    uaβ (isoToEquiv (endpointGaugeIso u)) g
      ∙ endpointGaugeEquiv-computes u g

  -- The pre-existing refinement covariance theorem is exactly the statement
  -- that refined holonomy lands at the `after` fact of this interaction.
  refinement-realizes-endpoint-interaction :
    (u : ⟨ G ⟩ × ⟨ G ⟩) (x : Hol.Refined G)
    → Hol.holonomy G (Hol.refinedEndpointGauge G u x)
      ≡ Rel.after (endpointInteraction u (Hol.holonomy G x))
  refinement-realizes-endpoint-interaction = Hol.holonomy-endpointGauge G

  -- Successive endpoint changes use the process core's composition.  The
  -- seam is definitional because the second interaction starts from the
  -- first interaction's transported result; no global representative or
  -- gauge-fixing function is selected.
  successiveEndpointInteractions :
    (u₁ u₂ : ⟨ G ⟩ × ⟨ G ⟩) (g : ⟨ G ⟩)
    → Rel.Interaction GaugePresentationProcess ⟨ G ⟩ ⟨ G ⟩
  successiveEndpointInteractions u₁ u₂ g =
    Rel.composeInteraction GaugePresentationProcess
      (endpointInteraction u₁ g)
      (endpointInteraction u₂ (Hol.endpointGauge G u₁ g))
      refl

  successive-endpoint :
    (u₁ u₂ : ⟨ G ⟩ × ⟨ G ⟩) (g : ⟨ G ⟩)
    → Rel.after (successiveEndpointInteractions u₁ u₂ g)
      ≡ Hol.endpointGauge G u₂ (Hol.endpointGauge G u₁ g)
  successive-endpoint u₁ u₂ g = refl

  -- Scope boundary: `endpointInteraction` requires `u` as input.  Its type
  -- supplies no section choosing one endpoint gauge for every connection,
  -- and none is used by the covariance bridge.
