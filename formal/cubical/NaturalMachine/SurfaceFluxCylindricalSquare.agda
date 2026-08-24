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

-- Bridge from oriented surface signs to the finite-network univalent
-- cylindrical theorem.  The sole geometric hypothesis is an explicit
-- SignedSplit witness: the inserted bivalent vertex lies off the surface, so
-- a transverse coarse crossing belongs to at most one child segment.

module NaturalMachine.SurfaceFluxCylindricalSquare where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
import Cubical.Data.Prod as P
open import Cubical.Algebra.Group.Base using (Group)

open import NaturalMachine.FiniteGraphCylindricalEquivalence
open import NaturalMachine.OrientedSurfaceFlux

private variable ℓg ℓo : Level

module _ (G : Group ℓg) (S : SignedFluxTarget ℓo)
    (represent : ⟨ G ⟩ → SignedFluxTarget.Carrier S)
  where

  representedStem : CoarseNetwork G → SignedFluxTarget.Carrier S
  representedStem x = represent (P.proj₁ x)

  coarseSurfaceFlux : Sign → CoarseNetwork G
    → SignedFluxTarget.Carrier S
  coarseSurfaceFlux sign x = signedFlux S sign (representedStem x)

  refinedSurfaceFlux : Sign → RefinedNetwork G
    → SignedFluxTarget.Carrier S
  refinedSurfaceFlux sign x =
    coarseSurfaceFlux sign (collapseNetwork G x)

  -- The cylindrical square commutes: quotient, univalent transport, and then
  -- signed surface evaluation equals collapse followed by evaluation.
  surface-flux-cylindrical : (sign : Sign) (x : RefinedNetwork G)
    → coarseSurfaceFlux sign
        (subst (λ X → X) (networkCylindricalPath G) (networkClass G x))
      ≡ refinedSurfaceFlux sign x
  surface-flux-cylindrical sign x =
    cong (coarseSurfaceFlux sign) (networkCylindricalTransport G x)

  -- Orientation reversal may be taken before or after cylindrical transport.
  -- The resulting square lands at negation of the original signed insertion.
  reversal-cylindrical-square : (sign : Sign) (x : RefinedNetwork G)
    → coarseSurfaceFlux (reverseSign sign)
        (subst (λ X → X) (networkCylindricalPath G) (networkClass G x))
      ≡ SignedFluxTarget.negate S (refinedSurfaceFlux sign x)
  reversal-cylindrical-square sign x =
      surface-flux-cylindrical (reverseSign sign) x
    ∙ orientation-reversal S sign (representedStem (collapseNetwork G x))

  -- Exact off-surface-vertex theorem.  The witness is data, not an implicit
  -- regularity slogan: it records which child inherits the coarse sign.
  signed-sum-cylindrical : {sign sign₀ sign₁ : Sign}
    → SignedSplit sign sign₀ sign₁
    → (x : RefinedNetwork G)
    → coarseSurfaceFlux sign
        (subst (λ X → X) (networkCylindricalPath G) (networkClass G x))
      ≡ SignedFluxTarget._⊕_ S
          (refinedSurfaceFlux sign₀ x) (refinedSurfaceFlux sign₁ x)
  signed-sum-cylindrical {sign = sign} split x =
      surface-flux-cylindrical sign x
    ∙ signed-subdivision S split (representedStem (collapseNetwork G x))

  -- The same statement after reversing every edge orientation follows by
  -- transforming the split witness, rather than assuming another law.
  reversed-signed-sum-cylindrical : {sign sign₀ sign₁ : Sign}
    → SignedSplit sign sign₀ sign₁
    → (x : RefinedNetwork G)
    → coarseSurfaceFlux (reverseSign sign)
        (subst (λ X → X) (networkCylindricalPath G) (networkClass G x))
      ≡ SignedFluxTarget._⊕_ S
          (refinedSurfaceFlux (reverseSign sign₀) x)
          (refinedSurfaceFlux (reverseSign sign₁) x)
  reversed-signed-sum-cylindrical {sign = sign} split x =
      surface-flux-cylindrical (reverseSign sign) x
    ∙ reversed-subdivision S split (representedStem (collapseNetwork G x))
