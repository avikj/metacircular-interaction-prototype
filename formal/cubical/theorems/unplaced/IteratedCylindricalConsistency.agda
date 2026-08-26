{-# OPTIONS --cubical --safe #-}

-- Iterated cylindrical consistency for a three-edge refinement history.

module IteratedCylindricalConsistency where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Foundations.Equiv
  using (_≃_ ; compEquiv ; invEquiv ; invEquiv-is-linv
        ; compEquiv-assoc ; compEquivEquivId)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua ; uaβ ; uaCompEquiv)
open import Cubical.Data.Sigma using (Σ≡Prop)
open import Cubical.Data.Prod using (_×_ ; _,_)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/ ; squash/)
open import Cubical.Algebra.Group.Base using (Group ; GroupStr)
open import Cubical.Algebra.Group.Properties using (module GroupTheory)

open import RelationalHolonomyRefinement
  using (RefinedModuloInternalGauge ; cylindricalEquiv)

module _ {ℓ : Level} (G : Group ℓ) where

  private
    module G = GroupStr (snd G)
    module GT = GroupTheory G

  Triple : Type ℓ
  Triple = ⟨ G ⟩ × (⟨ G ⟩ × ⟨ G ⟩)

  holonomy₃ : Triple → ⟨ G ⟩
  holonomy₃ (a , b , c) = c G.· (b G.· a)

  internalGauge₃ : (⟨ G ⟩ × ⟨ G ⟩) → Triple → Triple
  internalGauge₃ (h , k) (a , b , c) =
    (h G.· a) , (((k G.· b) G.· G.inv h) , (c G.· G.inv k))

  cancel-middle : (x h y : ⟨ G ⟩)
    → (x G.· G.inv h) G.· (h G.· y) ≡ x G.· y
  cancel-middle x h y =
      sym (G.·Assoc x (G.inv h) (h G.· y))
    ∙ cong (x G.·_) (G.·Assoc (G.inv h) h y)
    ∙ cong (λ z → x G.· (z G.· y)) (G.·InvL h)
    ∙ cong (x G.·_) (G.·IdL y)

  holonomy₃-invariant : (u : ⟨ G ⟩ × ⟨ G ⟩) (x : Triple)
    → holonomy₃ (internalGauge₃ u x) ≡ holonomy₃ x
  holonomy₃-invariant (h , k) (a , b , c) =
      cong ((c G.· G.inv k) G.·_)
        ( cancel-middle (k G.· b) h a
        ∙ sym (G.·Assoc k b a))
    ∙ cancel-middle c k (b G.· a)

  TripleRel : Triple → Triple → Type ℓ
  TripleRel x y =
    Σ[ u ∈ (⟨ G ⟩ × ⟨ G ⟩) ] (internalGauge₃ u x ≡ y)

  TripleGaugeClass : Type ℓ
  TripleGaugeClass = Triple / TripleRel

  tripleClass : Triple → TripleGaugeClass
  tripleClass = [_]

  quotientHolonomy₃ : TripleGaugeClass → ⟨ G ⟩
  quotientHolonomy₃ = SQ.rec G.is-set holonomy₃
    (λ x y r → sym (holonomy₃-invariant (fst r) x)
               ∙ cong holonomy₃ (snd r))

  coarseClass₃ : ⟨ G ⟩ → TripleGaugeClass
  coarseClass₃ g = tripleClass (G.1g , G.1g , g)

  quotientHolonomy₃-coarse : (g : ⟨ G ⟩)
    → quotientHolonomy₃ (coarseClass₃ g) ≡ g
  quotientHolonomy₃-coarse g =
      cong (g G.·_) (G.·IdL G.1g)
    ∙ G.·IdR g

  canonicalize₃ : (x : Triple)
    → tripleClass x ≡ coarseClass₃ (holonomy₃ x)
  canonicalize₃ (a , b , c) =
    eq/ _ _ ((G.inv a , G.inv (b G.· a)) , triplePath)
    where
    p₁ : G.inv a G.· a ≡ G.1g
    p₁ = G.·InvL a

    p₂ : (G.inv (b G.· a) G.· b) G.· G.inv (G.inv a) ≡ G.1g
    p₂ =
        cong ((G.inv (b G.· a) G.· b) G.·_) (GT.invInv a)
      ∙ sym (G.·Assoc (G.inv (b G.· a)) b a)
      ∙ G.·InvL (b G.· a)

    p₃ : c G.· G.inv (G.inv (b G.· a)) ≡ c G.· (b G.· a)
    p₃ = cong (c G.·_) (GT.invInv (b G.· a))

    triplePath :
      internalGauge₃ (G.inv a , G.inv (b G.· a)) (a , b , c)
      ≡ (G.1g , G.1g , holonomy₃ (a , b , c))
    triplePath i = p₁ i , p₂ i , p₃ i

  coarse-triple : (q : TripleGaugeClass)
    → coarseClass₃ (quotientHolonomy₃ q) ≡ q
  coarse-triple =
    SQ.elimProp (λ _ → squash/ _ _) (λ x → sym (canonicalize₃ x))

  tripleIso : Iso TripleGaugeClass ⟨ G ⟩
  Iso.fun tripleIso = quotientHolonomy₃
  Iso.inv tripleIso = coarseClass₃
  Iso.rightInv tripleIso = quotientHolonomy₃-coarse
  Iso.leftInv tripleIso = coarse-triple

  tripleEquiv : TripleGaugeClass ≃ ⟨ G ⟩
  tripleEquiv = isoToEquiv tripleIso

  triplePath : TripleGaugeClass ≡ ⟨ G ⟩
  triplePath = ua tripleEquiv

  tripleTransport : (x : Triple)
    → subst (λ X → X) triplePath (tripleClass x) ≡ holonomy₃ x
  tripleTransport x = uaβ tripleEquiv (tripleClass x)

  -- The two possible binary contractions of three consecutive edges differ
  -- by precisely the group associator.
  leftHolonomy rightHolonomy : Triple → ⟨ G ⟩
  leftHolonomy  (a , b , c) = c G.· (b G.· a)
  rightHolonomy (a , b , c) = (c G.· b) G.· a

  contractionAssociator : (x : Triple) → leftHolonomy x ≡ rightHolonomy x
  contractionAssociator (a , b , c) = G.·Assoc c b a

  -- A staged history first transports the three-edge quotient to the
  -- two-edge quotient, then uses the already checked two-edge cylindrical
  -- equivalence.  Its composite equivalence is the direct triple one.
  tripleToDouble : TripleGaugeClass ≃ RefinedModuloInternalGauge G
  tripleToDouble = compEquiv tripleEquiv (invEquiv (cylindricalEquiv G))

  stagedComposite :
    compEquiv tripleToDouble (cylindricalEquiv G) ≡ tripleEquiv
  stagedComposite =
      sym (compEquiv-assoc tripleEquiv (invEquiv (cylindricalEquiv G))
        (cylindricalEquiv G))
    ∙ cong (compEquiv tripleEquiv)
        (invEquiv-is-linv (cylindricalEquiv G))
    ∙ compEquivEquivId tripleEquiv

  -- Univalent coherence: direct coarse transport is the same universe path
  -- as the two-stage refinement history.
  cylindricalHistoryCoherent :
    ua tripleEquiv ≡ ua tripleToDouble ∙ ua (cylindricalEquiv G)
  cylindricalHistoryCoherent =
      cong ua (sym stagedComposite)
    ∙ uaCompEquiv tripleToDouble (cylindricalEquiv G)
