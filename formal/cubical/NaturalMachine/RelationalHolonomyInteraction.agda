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

module _ {ℓ : Level} (Γ : Group ℓ) where

  private
    module G = GroupStr (snd Γ)

  leftMultiplyIso : (a : ⟨ Γ ⟩) → Iso ⟨ Γ ⟩ ⟨ Γ ⟩
  leftMultiplyIso a = iso (a G.·_) (G.inv a G.·_) right left
    where
    right : (x : ⟨ Γ ⟩) → a G.· (G.inv a G.· x) ≡ x
    right x =
      a G.· (G.inv a G.· x)
        ≡⟨ G.·Assoc a (G.inv a) x ⟩
      (a G.· G.inv a) G.· x
        ≡⟨ cong (λ z → z G.· x) (G.·InvR a) ⟩
      G.1g G.· x
        ≡⟨ G.·IdL x ⟩
      x ∎

    left : (x : ⟨ Γ ⟩) → G.inv a G.· (a G.· x) ≡ x
    left x =
      G.inv a G.· (a G.· x)
        ≡⟨ G.·Assoc (G.inv a) a x ⟩
      (G.inv a G.· a) G.· x
        ≡⟨ cong (λ z → z G.· x) (G.·InvL a) ⟩
      G.1g G.· x
        ≡⟨ G.·IdL x ⟩
      x ∎

  rightMultiplyIso : (a : ⟨ Γ ⟩) → Iso ⟨ Γ ⟩ ⟨ Γ ⟩
  rightMultiplyIso a =
    iso (λ x → x G.· a) (λ x → x G.· G.inv a) right left
    where
    right : (x : ⟨ Γ ⟩) → (x G.· G.inv a) G.· a ≡ x
    right x =
      (x G.· G.inv a) G.· a
        ≡⟨ sym (G.·Assoc x (G.inv a) a) ⟩
      x G.· (G.inv a G.· a)
        ≡⟨ cong (λ z → x G.· z) (G.·InvL a) ⟩
      x G.· G.1g
        ≡⟨ G.·IdR x ⟩
      x ∎

    left : (x : ⟨ Γ ⟩) → (x G.· a) G.· G.inv a ≡ x
    left x =
      (x G.· a) G.· G.inv a
        ≡⟨ sym (G.·Assoc x a (G.inv a)) ⟩
      x G.· (a G.· G.inv a)
        ≡⟨ cong (λ z → x G.· z) (G.·InvR a) ⟩
      x G.· G.1g
        ≡⟨ G.·IdR x ⟩
      x ∎

  -- Endpoint covariance is invertible: t acts on the left and s⁻¹ on
  -- the right.  This construction uses only the supplied endpoint pair.
  endpointGaugeIso : (⟨ Γ ⟩ × ⟨ Γ ⟩) → Iso ⟨ Γ ⟩ ⟨ Γ ⟩
  endpointGaugeIso (s , t) =
    compIso (leftMultiplyIso t) (rightMultiplyIso (G.inv s))

  endpointGaugeEquiv-computes : (u : ⟨ Γ ⟩ × ⟨ Γ ⟩) (g : ⟨ Γ ⟩)
    → Iso.fun (endpointGaugeIso u) g ≡ Hol.endpointGauge Γ u g
  endpointGaugeEquiv-computes (s , t) g = refl

  -- Types are loci and their elements are the relative facts available at
  -- those loci.  Univalence turns the supplied reversible endpoint change
  -- into an interaction path; it does not identify all gauges globally.
  GaugePresentationProcess : Rel.RelativeProcess
  Rel.Locus GaugePresentationProcess = Type ℓ
  Rel.Fact  GaugePresentationProcess X = X

  endpointInteraction : (u : ⟨ Γ ⟩ × ⟨ Γ ⟩) (g : ⟨ Γ ⟩)
    → Rel.Interaction GaugePresentationProcess ⟨ Γ ⟩ ⟨ Γ ⟩
  Rel.path   (endpointInteraction u g) = ua (isoToEquiv (endpointGaugeIso u))
  Rel.before (endpointInteraction u g) = g
  Rel.after  (endpointInteraction u g) = Hol.endpointGauge Γ u g
  Rel.lawful (endpointInteraction u g) =
    uaβ (isoToEquiv (endpointGaugeIso u)) g
      ∙ endpointGaugeEquiv-computes u g

  -- The pre-existing refinement covariance theorem is exactly the statement
  -- that refined holonomy lands at the `after` fact of this interaction.
  refinement-realizes-endpoint-interaction :
    (u : ⟨ Γ ⟩ × ⟨ Γ ⟩) (x : Hol.Refined Γ)
    → Hol.holonomy Γ (Hol.refinedEndpointGauge Γ u x)
      ≡ Rel.after (endpointInteraction u (Hol.holonomy Γ x))
  refinement-realizes-endpoint-interaction = Hol.holonomy-endpointGauge Γ

  -- Successive endpoint changes use the process core's composition.  The
  -- seam is definitional because the second interaction starts from the
  -- first interaction's transported result; no global representative or
  -- gauge-fixing function is selected.
  successiveEndpointInteractions :
    (u₁ u₂ : ⟨ Γ ⟩ × ⟨ Γ ⟩) (g : ⟨ Γ ⟩)
    → Rel.Interaction GaugePresentationProcess ⟨ Γ ⟩ ⟨ Γ ⟩
  successiveEndpointInteractions u₁ u₂ g =
    Rel.composeInteraction GaugePresentationProcess
      (endpointInteraction u₁ g)
      (endpointInteraction u₂ (Hol.endpointGauge Γ u₁ g))
      refl

  successive-endpoint :
    (u₁ u₂ : ⟨ Γ ⟩ × ⟨ Γ ⟩) (g : ⟨ Γ ⟩)
    → Rel.after (successiveEndpointInteractions u₁ u₂ g)
      ≡ Hol.endpointGauge Γ u₂ (Hol.endpointGauge Γ u₁ g)
  successive-endpoint u₁ u₂ g = refl

  -- Scope boundary: `endpointInteraction` requires `u` as input.  Its type
  -- supplies no section choosing one endpoint gauge for every connection,
  -- and none is used by the covariance bridge.
