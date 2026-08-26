{-# OPTIONS --cubical --safe #-}

-- The exact algebraic boundary before a holonomy--flux representation.
--
-- LQG fluxes act as derivations on cylindrical holonomy observables, with
-- geometry-dependent left/right insertions at edge/surface intersections.
-- This file checks only the representation-independent Leibniz seam.  It does
-- not supply a surface, intersection sign, Lie algebra, SU(2), Hilbert-space
-- operator, commutator, domain, or geometric spectrum.

module HolonomyFluxDerivation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Prod using (_,_)
open import Cubical.Algebra.Group.Base using (Group ; GroupStr)

open import RelationalHolonomyRefinement
  using (Refined ; holonomy ; subdivide ; holonomy-subdivide)

private
  variable
    ℓg ℓa : Level

-- A deliberately minimal observable algebra carrying one flux derivation.
-- No ring laws are silently assumed: the subdivision theorem below consumes
-- exactly representation multiplicativity and the displayed Leibniz law.
record FluxDerivation (ℓ : Level) : Type (ℓ-suc ℓ) where
  field
    Carrier : Type ℓ
    _⋆_ : Carrier → Carrier → Carrier
    _⊕_ : Carrier → Carrier → Carrier
    flux : Carrier → Carrier
    leibniz : (x y : Carrier)
      → flux (x ⋆ y) ≡ (flux x ⋆ y) ⊕ (x ⋆ flux y)

open FluxDerivation

module _ (G : Group ℓg) (F : FluxDerivation ℓa)
    (represent : ⟨ G ⟩ → Carrier F)
    (represent-mul : (g h : ⟨ G ⟩)
      → represent (GroupStr._·_ (snd G) g h)
        ≡ _⋆_ F (represent g) (represent h))
  where

  firstEdge : Refined G → ⟨ G ⟩
  firstEdge (a , b) = a

  secondEdge : Refined G → ⟨ G ⟩
  secondEdge (a , b) = b

  representedComposite : Refined G → Carrier F
  representedComposite edge = represent (holonomy G edge)

  -- A flux insertion on a subdivided edge is forced to split into its two
  -- edge insertions.  This is the exact finite derivation compatibility;
  -- orientation and intersection data must later choose which concrete
  -- derivation inhabits `F`.
  flux-subdivision : (edge : Refined G)
    → flux F (representedComposite edge)
      ≡ _⊕_ F
          (_⋆_ F (flux F (represent (secondEdge edge)))
                   (represent (firstEdge edge)))
          (_⋆_ F (represent (secondEdge edge))
                   (flux F (represent (firstEdge edge))))
  flux-subdivision (a , b) =
      cong (flux F) (represent-mul b a)
    ∙ leibniz F (represent b) (represent a)

  -- Canonical edge insertion from the holonomy/refinement module commutes
  -- with flux evaluation before any Leibniz expansion.  This needs no
  -- invented unit/zero laws: it is transport along the already checked
  -- coarse/refined holonomy path.
  flux-canonical-refinement : (g : ⟨ G ⟩)
    → flux F (representedComposite (subdivide G g))
      ≡ flux F (represent g)
  flux-canonical-refinement g =
    cong (λ h → flux F (represent h)) (holonomy-subdivide G g)

