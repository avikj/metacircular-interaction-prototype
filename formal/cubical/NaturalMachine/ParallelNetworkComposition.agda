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

-- Parallel/disjoint composition for the abstract spin-network seam.
-- This is a cartesian product of actions, not a Hilbert tensor product.

module NaturalMachine.ParallelNetworkComposition where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma using (_×_ ; _,_)
import Cubical.Data.Prod as P
open import Cubical.Algebra.Group.Base using (Group ; GroupStr)

open import NaturalMachine.StabilizerTorsor using (Action)
open import TransporterPortReduction using (prodAction)
open import NaturalMachine.AbstractSpinNetworkKinematics
  using (Intertwiner ; idIntertwiner ; _∘I_
        ; RefinedIntertwiner ; contract ; subdivideIntertwiner)
open Intertwiner
open import NaturalMachine.HolonomyFluxDerivation
  using (FluxDerivation ; flux-subdivision)
open FluxDerivation
open import NaturalMachine.RelationalHolonomyRefinement using (Refined ; holonomy)

private
  variable
    ℓg ℓx ℓy ℓz ℓw ℓa ℓb : Level

module _ (G : Group ℓg) where

  parallelIntertwiner :
    {X : Type ℓx} {Y : Type ℓy} {Z : Type ℓz} {W : Type ℓw}
    {AX : Action G X} {AY : Action G Y}
    {AZ : Action G Z} {AW : Action G W}
    → Intertwiner G AX AY → Intertwiner G AZ AW
    → Intertwiner G (prodAction G AX AZ) (prodAction G AY AW)
  map (parallelIntertwiner f g) (x , z) = map f x , map g z
  equivariant (parallelIntertwiner f g) h (x , z) i =
    equivariant f h x i , equivariant g h z i

  -- Parallel identity and serial/parallel interchange are computational.
  parallel-id : {X : Type ℓx} {Y : Type ℓy}
    (AX : Action G X) (AY : Action G Y) (p : X × Y)
    → map (parallelIntertwiner (idIntertwiner G AX) (idIntertwiner G AY)) p ≡ p
  parallel-id AX AY (x , y) = refl

  interchange :
    {X₀ : Type ℓx} {X₁ : Type ℓy} {X₂ : Type ℓz}
    {Y₀ : Type ℓx} {Y₁ : Type ℓy} {Y₂ : Type ℓz}
    {A₀ : Action G X₀} {A₁ : Action G X₁} {A₂ : Action G X₂}
    {B₀ : Action G Y₀} {B₁ : Action G Y₁} {B₂ : Action G Y₂}
    (f₀ : Intertwiner G A₀ A₁) (f₁ : Intertwiner G A₁ A₂)
    (g₀ : Intertwiner G B₀ B₁) (g₁ : Intertwiner G B₁ B₂)
    (p : X₀ × Y₀)
    → map (parallelIntertwiner (_∘I_ G f₁ f₀) (_∘I_ G g₁ g₀)) p
      ≡ map (_∘I_ G (parallelIntertwiner f₁ g₁)
          (parallelIntertwiner f₀ g₀)) p
  interchange f₀ f₁ g₀ g₁ (x , y) = refl

  parallelRefinement :
    {X₀ : Type ℓx} {X₁ : Type ℓy} {X₂ : Type ℓz}
    {Y₀ : Type ℓx} {Y₁ : Type ℓy} {Y₂ : Type ℓz}
    {A₀ : Action G X₀} {A₁ : Action G X₁} {A₂ : Action G X₂}
    {B₀ : Action G Y₀} {B₁ : Action G Y₁} {B₂ : Action G Y₂}
    → RefinedIntertwiner G A₀ A₁ A₂
    → RefinedIntertwiner G B₀ B₁ B₂
    → RefinedIntertwiner G
        (prodAction G A₀ B₀) (prodAction G A₁ B₁) (prodAction G A₂ B₂)
  parallelRefinement f g =
    P._,_ (parallelIntertwiner (P.proj₁ f) (P.proj₁ g))
          (parallelIntertwiner (P.proj₂ f) (P.proj₂ g))

  -- Contracting after parallel refinement equals parallel composition after
  -- contracting each component.  This is the refinement/interchange square.
  contract-parallel :
    {X₀ : Type ℓx} {X₁ : Type ℓy} {X₂ : Type ℓz}
    {Y₀ : Type ℓx} {Y₁ : Type ℓy} {Y₂ : Type ℓz}
    {A₀ : Action G X₀} {A₁ : Action G X₁} {A₂ : Action G X₂}
    {B₀ : Action G Y₀} {B₁ : Action G Y₁} {B₂ : Action G Y₂}
    (f : RefinedIntertwiner G A₀ A₁ A₂)
    (g : RefinedIntertwiner G B₀ B₁ B₂)
    (p : X₀ × Y₀)
    → map (contract G (parallelRefinement f g)) p
      ≡ map (parallelIntertwiner (contract G f) (contract G g)) p
  contract-parallel (P._,_ f₀ f₁) (P._,_ g₀ g₁) (x , y) = refl

  canonical-refinement-parallel :
    {X Z : Type ℓx} {Y W : Type ℓy}
    {AX : Action G X} {AY : Action G Y}
    {AZ : Action G Z} {AW : Action G W}
    (f : Intertwiner G AX AY) (g : Intertwiner G AZ AW)
    (p : X × Z)
    → map (contract G
        (parallelRefinement
          (subdivideIntertwiner G f) (subdivideIntertwiner G g))) p
      ≡ map (parallelIntertwiner f g) p
  canonical-refinement-parallel f g (x , z) = refl

------------------------------------------------------------------------
-- Flux is monoidal for the cartesian product semantics, componentwise.
------------------------------------------------------------------------

productFlux : FluxDerivation ℓa → FluxDerivation ℓb
  → FluxDerivation (ℓ-max ℓa ℓb)
Carrier (productFlux F H) = Carrier F × Carrier H
_⋆_ (productFlux F H) (x , y) (x' , y') = (_⋆_ F x x') , (_⋆_ H y y')
_⊕_ (productFlux F H) (x , y) (x' , y') = (_⊕_ F x x') , (_⊕_ H y y')
flux (productFlux F H) (x , y) = flux F x , flux H y
leibniz (productFlux F H) (x , y) (x' , y') i =
  leibniz F x x' i , leibniz H y y' i

module _ (G : Group ℓg)
    (F : FluxDerivation ℓa) (H : FluxDerivation ℓb)
    (ρ : ⟨ G ⟩ → Carrier F) (σ : ⟨ G ⟩ → Carrier H)
    (ρ-mul : (g h : ⟨ G ⟩)
      → ρ (GroupStr._·_ (snd G) g h) ≡ _⋆_ F (ρ g) (ρ h))
    (σ-mul : (g h : ⟨ G ⟩)
      → σ (GroupStr._·_ (snd G) g h) ≡ _⋆_ H (σ g) (σ h))
  where

  parallelRepresent : ⟨ G ⟩ → Carrier (productFlux F H)
  parallelRepresent g = ρ g , σ g

  parallelRepresent-mul : (g h : ⟨ G ⟩)
    → parallelRepresent (GroupStr._·_ (snd G) g h)
      ≡ _⋆_ (productFlux F H) (parallelRepresent g) (parallelRepresent h)
  parallelRepresent-mul g h i = ρ-mul g h i , σ-mul g h i

  -- The product-network flux subdivision theorem is exactly the pair of the
  -- component theorems.  Thus cartesian parallel composition preserves the
  -- checked holonomy--flux seam.
  parallel-flux-subdivision-left : (edge : Refined G)
    → fst (flux (productFlux F H)
        (parallelRepresent (holonomy G edge)))
      ≡ fst
        (_⊕_ (productFlux F H)
          (_⋆_ (productFlux F H)
            (flux (productFlux F H)
              (parallelRepresent
                (NaturalMachine.HolonomyFluxDerivation.secondEdge
                  G (productFlux F H) parallelRepresent parallelRepresent-mul edge)))
            (parallelRepresent
              (NaturalMachine.HolonomyFluxDerivation.firstEdge
                G (productFlux F H) parallelRepresent parallelRepresent-mul edge)))
          (_⋆_ (productFlux F H)
            (parallelRepresent
              (NaturalMachine.HolonomyFluxDerivation.secondEdge
                G (productFlux F H) parallelRepresent parallelRepresent-mul edge))
            (flux (productFlux F H)
              (parallelRepresent
                (NaturalMachine.HolonomyFluxDerivation.firstEdge
                  G (productFlux F H) parallelRepresent parallelRepresent-mul edge)))))
  parallel-flux-subdivision-left edge =
    cong fst (flux-subdivision G (productFlux F H)
      parallelRepresent parallelRepresent-mul edge)

  parallel-flux-subdivision-right : (edge : Refined G)
    → snd (flux (productFlux F H)
        (parallelRepresent (holonomy G edge)))
      ≡ snd
        (_⊕_ (productFlux F H)
          (_⋆_ (productFlux F H)
            (flux (productFlux F H)
              (parallelRepresent
                (NaturalMachine.HolonomyFluxDerivation.secondEdge
                  G (productFlux F H) parallelRepresent parallelRepresent-mul edge)))
            (parallelRepresent
              (NaturalMachine.HolonomyFluxDerivation.firstEdge
                G (productFlux F H) parallelRepresent parallelRepresent-mul edge)))
          (_⋆_ (productFlux F H)
            (parallelRepresent
              (NaturalMachine.HolonomyFluxDerivation.secondEdge
                G (productFlux F H) parallelRepresent parallelRepresent-mul edge))
            (flux (productFlux F H)
              (parallelRepresent
                (NaturalMachine.HolonomyFluxDerivation.firstEdge
                  G (productFlux F H) parallelRepresent parallelRepresent-mul edge)))))
  parallel-flux-subdivision-right edge =
    cong snd (flux-subdivision G (productFlux F H)
      parallelRepresent parallelRepresent-mul edge)
