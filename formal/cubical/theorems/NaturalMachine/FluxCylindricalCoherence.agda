{-# OPTIONS --cubical --safe #-}

-- Flux evaluation is coherent across the first nontrivial refinement history.

module NaturalMachine.FluxCylindricalCoherence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Prod using (_,_)
open import Cubical.Algebra.Group.Base using (Group ; GroupStr)

open import NaturalMachine.HolonomyFluxDerivation
  using (FluxDerivation)
open FluxDerivation
open import NaturalMachine.IteratedCylindricalConsistency
  using (Triple ; leftHolonomy ; rightHolonomy ; contractionAssociator)

private
  variable
    ℓg ℓa : Level

module _ (G : Group ℓg) (F : FluxDerivation ℓa)
    (represent : ⟨ G ⟩ → Carrier F)
    (represent-mul : (g h : ⟨ G ⟩)
      → represent (GroupStr._·_ (snd G) g h)
        ≡ _⋆_ F (represent g) (represent h))
  where

  D : Carrier F → Carrier F
  D = flux F

  infixl 7 _·A_
  _·A_ : Carrier F → Carrier F → Carrier F
  _·A_ = _⋆_ F

  infixl 6 _+A_
  _+A_ : Carrier F → Carrier F → Carrier F
  _+A_ = _⊕_ F

  directFlux stagedFlux : Triple G → Carrier F
  directFlux x = D (represent (leftHolonomy G x))
  stagedFlux x = D (represent (rightHolonomy G x))

  -- Before expansion, path independence is transport along the group
  -- associator already exposed by the iterated cylindrical module.
  flux-contraction-path : (x : Triple G) → directFlux x ≡ stagedFlux x
  flux-contraction-path x =
    cong (λ g → D (represent g)) (contractionAssociator G x)

  DirectNormal StagedNormal : Triple G → Carrier F
  DirectNormal (a , b , c) =
      (D (represent c) ·A (represent b ·A represent a))
    +A
      (represent c ·A
        ((D (represent b) ·A represent a)
          +A (represent b ·A D (represent a))))

  StagedNormal (a , b , c) =
      (((D (represent c) ·A represent b)
          +A (represent c ·A D (represent b))) ·A represent a)
    +A
      ((represent c ·A represent b) ·A D (represent a))

  expandDirect : (x : Triple G) → directFlux x ≡ DirectNormal x
  expandDirect (a , b , c) =
      cong D (represent-mul c (GroupStr._·_ (snd G) b a))
    ∙ leibniz F (represent c)
        (represent (GroupStr._·_ (snd G) b a))
    ∙ cong₂ _+A_
        (cong (D (represent c) ·A_) innerRep)
        (cong₂ _·A_ refl innerFlux)
    where
    innerRep : represent (GroupStr._·_ (snd G) b a)
             ≡ represent b ·A represent a
    innerRep = represent-mul b a

    innerFlux : D (represent (GroupStr._·_ (snd G) b a))
              ≡ (D (represent b) ·A represent a)
                +A (represent b ·A D (represent a))
    innerFlux = cong D innerRep ∙ leibniz F (represent b) (represent a)

  expandStaged : (x : Triple G) → stagedFlux x ≡ StagedNormal x
  expandStaged (a , b , c) =
      cong D (represent-mul (GroupStr._·_ (snd G) c b) a)
    ∙ leibniz F
        (represent (GroupStr._·_ (snd G) c b)) (represent a)
    ∙ cong₂ _+A_
        (cong₂ _·A_ outerFlux refl)
        (cong (_·A D (represent a)) outerRep)
    where
    outerRep : represent (GroupStr._·_ (snd G) c b)
             ≡ represent c ·A represent b
    outerRep = represent-mul c b

    outerFlux : D (represent (GroupStr._·_ (snd G) c b))
              ≡ (D (represent c) ·A represent b)
                +A (represent c ·A D (represent b))
    outerFlux = cong D outerRep ∙ leibniz F (represent c) (represent b)

  -- The apparent coherence defect between the two Leibniz expansion trees
  -- vanishes.  No distributivity or associativity law was added by hand:
  -- both normal forms are forced equal because they expand the same flux
  -- evaluation along the represented holonomy associator.
  flux-expansion-coherent : (x : Triple G)
    → DirectNormal x ≡ StagedNormal x
  flux-expansion-coherent x =
      sym (expandDirect x)
    ∙ flux-contraction-path x
    ∙ expandStaged x
