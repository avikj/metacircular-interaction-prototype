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
open import Cubical.Data.Sigma using (Σ≡Prop)
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
  Intertwiner : {X : Type ℓx} {Y : Type ℓy}
    → Action G X → Action G Y → Type (ℓ-max ℓg (ℓ-max ℓx ℓy))
  Intertwiner {X = X} {Y = Y} A B =
    Σ[ f ∈ (X → Y) ]
      ((g : ⟨ G ⟩) (x : X)
        → Action._▸_ B g (f x) ≡ f (Action._▸_ A g x))

  intertwinerPath : {X : Type ℓx} {Y : Type ℓy}
    {A : Action G X} {B : Action G Y}
    {f h : Intertwiner A B}
    → fst f ≡ fst h → f ≡ h
  intertwinerPath {B = B} =
    Σ≡Prop (λ _ → isPropΠ λ _ → isPropΠ λ _ → Action.isSetX B _ _)

  idIntertwiner : {X : Type ℓx} (A : Action G X) → Intertwiner A A
  idIntertwiner A = (λ x → x) , (λ g x → refl)

  _∘I_ : {X : Type ℓx} {Y : Type ℓy} {Z : Type ℓz}
    {A : Action G X} {B : Action G Y} {C : Action G Z}
    → Intertwiner B C → Intertwiner A B → Intertwiner A C
  (h , h-equiv) ∘I (f , f-equiv) =
    (h ∘ f) , λ g x → h-equiv g (f x) ∙ cong h (f-equiv g x)

  ∘I-idL : {X : Type ℓx} {Y : Type ℓy}
    {A : Action G X} {B : Action G Y} (f : Intertwiner A B)
    → idIntertwiner B ∘I f ≡ f
  ∘I-idL f = intertwinerPath refl

  ∘I-idR : {X : Type ℓx} {Y : Type ℓy}
    {A : Action G X} {B : Action G Y} (f : Intertwiner A B)
    → f ∘I idIntertwiner A ≡ f
  ∘I-idR f = intertwinerPath refl

  ∘I-assoc : {W : Type ℓo} {X : Type ℓx}
    {Y : Type ℓy} {Z : Type ℓz}
    {A : Action G W} {B : Action G X}
    {C : Action G Y} {D : Action G Z}
    (h : Intertwiner C D) (g : Intertwiner B C) (f : Intertwiner A B)
    → h ∘I (g ∘I f) ≡ (h ∘I g) ∘I f
  ∘I-assoc h g f = intertwinerPath refl

  -- The intertwiner equation is precisely the local gauge-invariance square
  -- at the vertex, exposed under a physics-facing name.
  vertexGaugeSquare : {X : Type ℓx} {Y : Type ℓy}
    {A : Action G X} {B : Action G Y}
    (f : Intertwiner A B) (g : ⟨ G ⟩) (x : X)
    → Action._▸_ B g (fst f x) ≡ fst f (Action._▸_ A g x)
  vertexGaugeSquare f = snd f

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
  contract (f , h) = h ∘I f

  subdivideIntertwiner : {X : Type ℓx} {Y : Type ℓy}
    {A : Action G X} {B : Action G Y}
    → Intertwiner A B → RefinedIntertwiner A A B
  subdivideIntertwiner f = idIntertwiner _ , f

  contract-subdivide : {X : Type ℓx} {Y : Type ℓy}
    {A : Action G X} {B : Action G Y} (f : Intertwiner A B)
    → contract (subdivideIntertwiner f) ≡ f
  contract-subdivide = ∘I-idR

  -- Every downstream set-valued evaluation is cylindrically consistent on
  -- the canonical subdivision because contraction is an equality of typed
  -- intertwiners.
  refinementTransport : {X : Type ℓx} {Y : Type ℓy}
    {A : Action G X} {B : Action G Y} {O : Type ℓo}
    (observe : Intertwiner A B → O) (f : Intertwiner A B)
    → observe (contract (subdivideIntertwiner f)) ≡ observe f
  refinementTransport observe f = cong observe (contract-subdivide f)

  -- A group action represents a holonomy by transport on its carrier.
  -- Composition of the refined holonomy agrees with doing the two transports
  -- sequentially; this is the checked bridge to the holonomy quotient module.
  representedHolonomy : {X : Type ℓx} (A : Action G X)
    → ⟨ G ⟩ → X → X
  representedHolonomy A = Action._▸_ A

  representedRefinement : {X : Type ℓx} (A : Action G X)
    (edge : Refined G) (x : X)
    → representedHolonomy A (holonomy G edge) x
      ≡ representedHolonomy A (snd edge)
          (representedHolonomy A (fst edge) x)
  representedRefinement A (a , b) x = Action.▸-· A b a x
