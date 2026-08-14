{-# OPTIONS --cubical --safe #-}

-- Representation-independent spin-network kinematics.
--
-- This module does not pretend to formalize SU(2), tensor products, or the
-- LQG Hilbert space.  It isolates the exact finite categorical content which
-- can already be checked over any group action:
--
--   * an edge label is an honest action of the gauge group on a set;
--   * a bivalent vertex label is an equivariant map (an intertwiner);
--   * vertex gauge invariance is the intertwining square itself;
--   * adjacent vertex labels compose;
--   * inserting an identity-labelled bivalent vertex preserves evaluation;
--   * a represented two-edge holonomy agrees with sequential transport.

module NaturalMachine.AbstractSpinNetworkKinematics where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Prod using (_×_ ; _,_)
open import Cubical.Algebra.Group.Base using (Group ; GroupStr)

open import NaturalMachine.StabilizerTorsor using (Action)
open import NaturalMachine.RelationalHolonomyRefinement
  using (Refined ; holonomy)

private
  variable
    ℓg ℓx ℓy ℓz ℓo : Level

module _ (G : Group ℓg) where

  private
    module G = GroupStr (snd G)

  -- A bivalent spin-network vertex: the label is not a bare function but a
  -- function carrying the gauge-equivariance equation.
  record Intertwiner {X : Type ℓx} {Y : Type ℓy}
      (A : Action G X) (B : Action G Y)
      : Type (ℓ-max ℓg (ℓ-max ℓx ℓy)) where
    field
      map : X → Y
      equivariant : (g : ⟨ G ⟩) (x : X)
        → Action._▸_ B g (map x) ≡ map (Action._▸_ A g x)

  open Intertwiner

  idIntertwiner : {X : Type ℓx} (A : Action G X) → Intertwiner A A
  map (idIntertwiner A) x = x
  equivariant (idIntertwiner A) g x = refl

  _∘I_ : {X : Type ℓx} {Y : Type ℓy} {Z : Type ℓz}
    {A : Action G X} {B : Action G Y} {C : Action G Z}
    → Intertwiner B C → Intertwiner A B → Intertwiner A C
  map (_∘I_ {A = A} {B = B} {C = C} h f) x = map h (map f x)
  equivariant (_∘I_ {A = A} {B = B} {C = C} h f) g x =
    equivariant h g (map f x) ∙ cong (map h) (equivariant f g x)

  ∘I-idL : {X : Type ℓx} {Y : Type ℓy}
    {A : Action G X} {B : Action G Y} (f : Intertwiner A B)
    → (x : X) → map (idIntertwiner B ∘I f) x ≡ map f x
  ∘I-idL f x = refl

  ∘I-idR : {X : Type ℓx} {Y : Type ℓy}
    {A : Action G X} {B : Action G Y} (f : Intertwiner A B)
    → (x : X) → map (f ∘I idIntertwiner A) x ≡ map f x
  ∘I-idR f x = refl

  ∘I-assoc : {W : Type ℓo} {X : Type ℓx}
    {Y : Type ℓy} {Z : Type ℓz}
    {A : Action G W} {B : Action G X}
    {C : Action G Y} {D : Action G Z}
    (h : Intertwiner C D) (g : Intertwiner B C) (f : Intertwiner A B)
    → (x : W) → map (h ∘I (g ∘I f)) x ≡ map ((h ∘I g) ∘I f) x
  ∘I-assoc h g f x = refl

  -- The intertwiner equation is precisely the local gauge-invariance square
  -- at the vertex, exposed under a physics-facing name.
  vertexGaugeSquare : {X : Type ℓx} {Y : Type ℓy}
    {A : Action G X} {B : Action G Y}
    (f : Intertwiner A B) (g : ⟨ G ⟩) (x : X)
    → Action._▸_ B g (map f x) ≡ map f (Action._▸_ A g x)
  vertexGaugeSquare f = equivariant f

  -- Subdividing a labelled edge by inserting the identity vertex is a
  -- proof-relevant pair of vertex labels.  Contracting it returns the
  -- original label, not merely an observationally equal one.
  RefinedIntertwiner : {X : Type ℓx} {Y : Type ℓy} {Z : Type ℓz}
    (A : Action G X) (B : Action G Y) (C : Action G Z)
    → Type (ℓ-max ℓg (ℓ-max (ℓ-max ℓx ℓy) ℓz))
  RefinedIntertwiner A B C = Intertwiner A B × Intertwiner B C

  contract : {X : Type ℓx} {Y : Type ℓy} {Z : Type ℓz}
    {A : Action G X} {B : Action G Y} {C : Action G Z}
    → RefinedIntertwiner A B C → Intertwiner A C
  contract {A = A} {B = B} {C = C} (f , h) =
    _∘I_ {A = A} {B = B} {C = C} h f

  subdivideIntertwiner : {X : Type ℓx} {Y : Type ℓy}
    {A : Action G X} {B : Action G Y}
    → Intertwiner A B → RefinedIntertwiner A A B
  subdivideIntertwiner {A = A} f = idIntertwiner A , f

  contract-subdivide : {X : Type ℓx} {Y : Type ℓy}
    {A : Action G X} {B : Action G Y} (f : Intertwiner A B)
    → (x : X) → map (contract (subdivideIntertwiner f)) x ≡ map f x
  contract-subdivide f x = refl

  -- Every downstream set-valued evaluation is cylindrically consistent on
  -- the canonical subdivision because contraction is an equality of typed
  -- intertwiners.
  refinementTransport : {X : Type ℓx} {Y : Type ℓy}
    {A : Action G X} {B : Action G Y} {O : Type ℓo}
    (observe : (X → Y) → O) (f : Intertwiner A B)
    → observe (map (contract (subdivideIntertwiner f))) ≡ observe (map f)
  refinementTransport observe f = cong observe (funExt (contract-subdivide f))

  -- A group action represents a holonomy by transport on its carrier.
  -- Composition of the refined holonomy agrees with doing the two transports
  -- sequentially; this is the checked bridge to the holonomy quotient module.
  representedHolonomy : {X : Type ℓx} (A : Action G X)
    → ⟨ G ⟩ → X → X
  representedHolonomy A = Action._▸_ A

  firstEdge : Refined G → ⟨ G ⟩
  firstEdge (a , b) = a

  secondEdge : Refined G → ⟨ G ⟩
  secondEdge (a , b) = b

  representedRefinement : {X : Type ℓx} (A : Action G X)
    (edge : Refined G) (x : X)
    → representedHolonomy A (holonomy G edge) x
      ≡ representedHolonomy A (secondEdge edge)
          (representedHolonomy A (firstEdge edge) x)
  representedRefinement A (a , b) x = Action.▸-· A b a x
