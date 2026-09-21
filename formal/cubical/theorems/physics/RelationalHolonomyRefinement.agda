{-# OPTIONS --cubical --safe #-}

-- A smallest exact holonomy/refinement organ.
--
-- This module isolates one finite presentation of the
-- holonomy/refinement law: subdividing one oriented edge into two introduces
-- an internal gauge coordinate; quotienting that coordinate is equivalent
-- (as a Cubical path-level object) to the original coarse holonomy.  Endpoint
-- gauge transformations remain visible, while a conjugation-invariant
-- closed-loop observation descends through them.

module RelationalHolonomyRefinement where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Foundations.Isomorphism using (Iso ; isoToEquiv)
open import Cubical.Foundations.Univalence using (ua ; uaβ)
open import Cubical.Data.Sigma using (Σ≡Prop)
open import Cubical.Data.Prod using (_×_ ; _,_)
open import Cubical.HITs.SetQuotients as SQ using (_/_ ; [_] ; eq/ ; squash/)
open import Cubical.Algebra.Group.Base using (Group ; GroupStr)
open import Cubical.Algebra.Group.Properties using (module GroupTheory)

module _ {ℓ : Level} (G : Group ℓ) where

  private
    module G = GroupStr (snd G)
    module GT = GroupTheory G

  -- One oriented coarse edge and its two-edge subdivision.
  Coarse : Type ℓ
  Coarse = ⟨ G ⟩

  Refined : Type ℓ
  Refined = ⟨ G ⟩ × ⟨ G ⟩

  -- Path order: (a , b) traverses a first and b second.
  holonomy : Refined → Coarse
  holonomy (a , b) = b G.· a

  subdivide : Coarse → Refined
  subdivide g = G.1g , g

  holonomy-subdivide : (g : Coarse) → holonomy (subdivide g) ≡ g
  holonomy-subdivide g = G.·IdR g

  -- Gauge at the new internal vertex.  It changes the two edge labels but
  -- cannot change their composite transport.
  internalGauge : ⟨ G ⟩ → Refined → Refined
  internalGauge h (a , b) = (h G.· a) , (b G.· G.inv h)

  holonomy-internalGauge : (h : ⟨ G ⟩) (x : Refined)
    → holonomy (internalGauge h x) ≡ holonomy x
  holonomy-internalGauge h (a , b) =
      G.·Assoc (b G.· G.inv h) h a
    ∙ cong (G._· a) (sym (G.·Assoc b (G.inv h) h))
    ∙ cong (λ z → (b G.· z) G.· a) (G.·InvL h)

  -- Internal gauge equivalence relation.
  _≈_ : Refined → Refined → Type ℓ
  x ≈ y = Σ[ h ∈ ⟨ G ⟩ ] internalGauge h x ≡ y

  ≈-refl : (x : Refined) → x ≈ x
  ≈-refl x = G.1g , refl

  ≈-sym : {x y : Refined} → x ≈ y → y ≈ x
  ≈-sym {x} {y} (h , p) = G.inv h , sym (cong (internalGauge (G.inv h)) p) ∙ cancel h x
    where
    cancel : (h : ⟨ G ⟩) (x : Refined) → internalGauge (G.inv h) (internalGauge h x) ≡ x
    cancel h (a , b) = cong₂ _,_
      (G.·Assoc (G.inv h) h a ∙ cong (G._· a) (G.·InvL h) ∙ G.·IdL a)
      (G.·Assoc b (G.inv h) (G.inv (G.inv h))
       ∙ cong (G._·_ b) (cong G.inv (G.invInvol h) ∙ G.·InvR h)
       ∙ G.·IdR b)

  ≈-trans : {x y z : Refined} → x ≈ y → y ≈ z → x ≈ z
  ≈-trans {x} {y} {z} (h , p) (k , q) = (k G.· h) , step
    where
    composeGauge : (h k : ⟨ G ⟩) (x : Refined)
      → internalGauge k (internalGauge h x) ≡ internalGauge (k G.· h) x
    composeGauge h k (a , b) = cong₂ _,_
      (sym (G.·Assoc k h a))
      (G.·Assoc b (G.inv h) (G.inv k)
       ∙ cong (G._·_ b) (sym (G.invDistr k h)))
    step : internalGauge (k G.· h) x ≡ z
    step = sym (composeGauge h k x) ∙ cong (internalGauge k) p ∙ q

  ≈-isProp : (x y : Refined) → isProp (x ≈ y)
  ≈-isProp x y u v = Σ≡Prop (λ _ → isSet→isGroupoid (G.is-set _ _)) (GT.cancelL _ _ _ (cong fst (snd u ∙ sym (snd v))))

  ≈-equiv : isEquivRel _≈_
  ≈-equiv = ≈-refl , ≈-sym , ≈-trans

  Quot : Type ℓ
  Quot = Refined SQ./ _≈_

  -- Holonomy descends because it is invariant under internal gauge.
  holonomyQ : Quot → Coarse
  holonomyQ = SQ.rec G.is-set holonomy λ x y r → holonomy-rel x y r
    where
    holonomy-rel : (x y : Refined) → x ≈ y → holonomy x ≡ holonomy y
    holonomy-rel x y (h , p) = holonomy-internalGauge h x ∙ cong holonomy p

  subdivideQ : Coarse → Quot
  subdivideQ g = [ subdivide g ]

  holonomyQ-subdivideQ : (g : Coarse) → holonomyQ (subdivideQ g) ≡ g
  holonomyQ-subdivideQ = holonomy-subdivide

  -- Every refined pair is gauge-equivalent to the canonical subdivision of
  -- its composite holonomy.
  normalize : (x : Refined) → x ≈ subdivide (holonomy x)
  normalize (a , b) = G.inv a , cong₂ _,_ (G.·InvL a) (sym (G.·Assoc b a (G.inv a)) ∙ cong (G._·_ (b G.· a)) (G.·InvR a))

  quotient-normalize : (x : Refined) → [ x ] ≡ subdivideQ (holonomy x)
  quotient-normalize x = eq/ (normalize x)

  subdivideQ-holonomyQ : (q : Quot) → subdivideQ (holonomyQ q) ≡ q
  subdivideQ-holonomyQ = SQ.elimProp (λ q → G.is-set _ _) λ x → sym (quotient-normalize x)

  quotientIso : Iso Quot Coarse
  quotientIso = iso holonomyQ subdivideQ holonomyQ-subdivideQ subdivideQ-holonomyQ

  quotientEquiv : Quot ≃ Coarse
  quotientEquiv = isoToEquiv quotientIso

  quotientPath : Quot ≡ Coarse
  quotientPath = ua quotientEquiv

  quotientTransportComputes : (q : Quot) → transport quotientPath q ≡ holonomyQ q
  quotientTransportComputes q = uaβ quotientEquiv q
