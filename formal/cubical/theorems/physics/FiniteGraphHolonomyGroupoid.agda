{-# OPTIONS --cubical --safe #-}

-- A finite branching/loop graph realized as a Cubical higher inductive type.
-- Its identity paths supply composition, reversal, cancellation and all
-- higher coherence.  This is combinatorial gauge kinematics, not an LQG
-- Hilbert space or a claim about SU(2) representation theory.

module FiniteGraphHolonomyGroupoid where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.GroupoidLaws using
  (assoc ; lUnit ; rUnit ; rCancel ; lCancel ; cong-∙)
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Algebra.Group.Base using (Group ; GroupStr)

private variable ℓg ℓv : Level

-- The nontrivial test graph: a fork and a loop at its root.
data BranchLoop : Type where
  root left right : BranchLoop
  stem   : root ≡ left
  branch : root ≡ right
  loop   : root ≡ root

-- Subdivide the stem by a new bivalent vertex.
data RefinedBranchLoop : Type where
  root′ mid′ left′ right′ : RefinedBranchLoop
  stem₀ : root′ ≡ mid′
  stem₁ : mid′ ≡ left′
  branch′ : root′ ≡ right′
  loop′ : root′ ≡ root′

-- Contracting the first half is a graph map.  Consequently `cong contract`
-- is automatically a functor on every path, including composite loop paths.
contractGraph : RefinedBranchLoop → BranchLoop
contractGraph root′ = root
contractGraph mid′ = root
contractGraph left′ = left
contractGraph right′ = right
contractGraph (stem₀ i) = root
contractGraph (stem₁ i) = stem i
contractGraph (branch′ i) = branch i
contractGraph (loop′ i) = loop i

PathGroupoid : (V : Type ℓv) → V → V → Type ℓv
PathGroupoid V x y = x ≡ y

reverse : {V : Type ℓv} {x y : V} → PathGroupoid V x y → PathGroupoid V y x
reverse = sym

_then_ : {V : Type ℓv} {x y z : V}
  → PathGroupoid V x y → PathGroupoid V y z → PathGroupoid V x z
p then q = p ∙ q

-- These are the reduction rules for an edge followed by its reversal.  Since
-- paths are used rather than words, the reductions are witnessed equalities,
-- and composition coherence is inherited from the ambient ∞-groupoid.
reduce-right : {V : Type ℓv} {x y : V} (p : x ≡ y)
  → p then reverse p ≡ refl
reduce-right = rCancel

reduce-left : {V : Type ℓv} {x y : V} (p : x ≡ y)
  → reverse p then p ≡ refl
reduce-left = lCancel

reduced-compose-assoc : {V : Type ℓv} {w x y z : V}
  (p : w ≡ x) (q : x ≡ y) (r : y ≡ z)
  → (p then q) then r ≡ p then (q then r)
reduced-compose-assoc p q r = sym (assoc p q r)

-- An abstract connection is exactly a functor out of the path groupoid into
-- the one-object groupoid of G.  No freeness theorem is assumed here: this
-- record states the functor laws that a concrete edge assignment must prove.
record Connection (G : Group ℓg) (V : Type ℓv)
  : Type (ℓ-max ℓg ℓv) where
  private module G = GroupStr (snd G)
  field
    hol : {x y : V} → x ≡ y → ⟨ G ⟩
    hol-id : (x : V) → hol (refl {x = x}) ≡ G.1g
    hol-comp : {x y z : V} (p : x ≡ y) (q : y ≡ z)
      → hol (p ∙ q) ≡ hol q G.· hol p
    hol-reverse : {x y : V} (p : x ≡ y)
      → hol (sym p) ≡ G.inv (hol p)

open Connection

-- Pullback along a graph map is strictly functorial on holonomy.
pullConnection : (G : Group ℓg) {V W : Type ℓv}
  → (f : V → W) → Connection G W → Connection G V
hol (pullConnection G f A) p = hol A (cong f p)
hol-id (pullConnection G f A) x = hol-id A (f x)
hol-comp (pullConnection G f A) p q =
  cong (hol A) (cong-∙ f p q) ∙ hol-comp A (cong f p) (cong f q)
hol-reverse (pullConnection G f A) p = hol-reverse A (cong f p)

-- Cylindrical refinement on the fork/loop graph is therefore executable:
-- the refined stem and loop are transported to their contracted coarse paths.
refinement-holonomy : (G : Group ℓg) (A : Connection G BranchLoop)
  {x y : RefinedBranchLoop} (p : x ≡ y)
  → hol (pullConnection G contractGraph A) p ≡ hol A (cong contractGraph p)
refinement-holonomy G A p = refl

contract-stem₀ : cong contractGraph stem₀ ≡ refl
contract-stem₀ = refl

contract-stem₁ : cong contractGraph stem₁ ≡ stem
contract-stem₁ = refl

stem-refinement : (G : Group ℓg) (A : Connection G BranchLoop)
  → hol (pullConnection G contractGraph A) (stem₀ ∙ stem₁) ≡ hol A stem
stem-refinement G A = cong (hol A)
  (cong-∙ contractGraph stem₀ stem₁
    ∙ (cong₂ _∙_ contract-stem₀ contract-stem₁
      ∙ sym (lUnit stem)))

loop-refinement : (G : Group ℓg) (A : Connection G BranchLoop)
  → hol (pullConnection G contractGraph A) loop′ ≡ hol A loop
loop-refinement G A = refl

-- A gauge transformation is a natural transformation between connection
-- functors.  The equation is retained as proof-relevant structure.
record GaugeNatural {G : Group ℓg} {V : Type ℓv}
    (A B : Connection G V) : Type (ℓ-max ℓg ℓv) where
  private module G = GroupStr (snd G)
  field
    gauge : V → ⟨ G ⟩
    natural : {x y : V} (p : x ≡ y)
      → hol B p G.· gauge x ≡ gauge y G.· hol A p

open GaugeNatural

-- On a loop, naturality is exactly endpoint conjugacy before any trace-like
-- quotient is taken.
loop-gauge-square : {G : Group ℓg} {V : Type ℓv}
  {A B : Connection G V} (η : GaugeNatural A B)
  {x : V} (p : x ≡ x)
  → GroupStr._·_ (snd G) (hol B p) (gauge η x)
    ≡ GroupStr._·_ (snd G) (gauge η x) (hol A p)
loop-gauge-square η p = natural η p
