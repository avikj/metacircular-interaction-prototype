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

-- Flux evaluation transported across the finite-network cylindrical path.
-- Only the subdivided stem is differentiated; no surface/intersection model,
-- operator domain, Hilbert tensor product, or LQG geometric spectrum is claimed.

module NaturalMachine.FiniteGraphFluxCylindrical where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
import Cubical.Data.Prod as P
open import Cubical.Algebra.Group.Base using (Group ; GroupStr)

open import NaturalMachine.FiniteGraphCylindricalEquivalence
open import NaturalMachine.HolonomyFluxDerivation
  using (FluxDerivation ; flux-subdivision)
open import NaturalMachine.RelationalHolonomyRefinement using (holonomy)
open FluxDerivation

private variable ℓg ℓa : Level

module _ (G : Group ℓg) (F : FluxDerivation ℓa)
    (ρ : ⟨ G ⟩ → Carrier F)
    (ρ-mul : (g h : ⟨ G ⟩)
      → ρ (GroupStr._·_ (snd G) g h) ≡ _⋆_ F (ρ g) (ρ h))
  where

  coarseStemFlux : CoarseNetwork G → Carrier F
  coarseStemFlux x = flux F (ρ (P.proj₁ x))

  refinedStemFlux : RefinedNetwork G → Carrier F
  refinedStemFlux x = coarseStemFlux (collapseNetwork G x)

  collapse-stem : (x : RefinedNetwork G)
    → P.proj₁ (collapseNetwork G x) ≡ holonomy G (P.proj₁ x)
  collapse-stem (P._,_ (P._,_ a b) (P._,_ branch loop)) = refl

  -- Evaluating after univalent transport out of the quotient is exactly
  -- evaluation on the collapsed coarse assignment.
  flux-cylindrical-transport : (x : RefinedNetwork G)
    → coarseStemFlux
        (subst (λ X → X) (networkCylindricalPath G) (networkClass G x))
      ≡ refinedStemFlux x
  flux-cylindrical-transport x =
    cong coarseStemFlux (networkCylindricalTransport G x)

  -- Combining transport with the declared derivation law expands the result
  -- into the two segment contributions.  This is the exact compatibility
  -- required before a concrete holonomy--flux realization may inhabit it.
  flux-cylindrical-leibniz : (x : RefinedNetwork G)
    → coarseStemFlux
        (subst (λ X → X) (networkCylindricalPath G) (networkClass G x))
      ≡ _⊕_ F
          (_⋆_ F (flux F (ρ (P.proj₂ (P.proj₁ x))))
            (ρ (P.proj₁ (P.proj₁ x))))
          (_⋆_ F (ρ (P.proj₂ (P.proj₁ x)))
            (flux F (ρ (P.proj₁ (P.proj₁ x)))))
  flux-cylindrical-leibniz x@(P._,_ (P._,_ a b) (P._,_ branch loop)) =
      flux-cylindrical-transport x
    ∙ cong (λ g → flux F (ρ g)) (collapse-stem x)
    ∙ flux-subdivision G F ρ ρ-mul (P._,_ a b)
