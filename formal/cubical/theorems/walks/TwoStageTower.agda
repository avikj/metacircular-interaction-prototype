{-# OPTIONS --safe --cubical --guardedness #-}

------------------------------------------------------------------------
-- TwoStageTower — the interaction code, the extension channel, and the
-- bottom rung of the Postnikov ladder, as one development.  These are
-- not three imports: an extension of a group Q by an abelian value
-- group W IS the two-stage tower, its gluing code IS the 2-cocycle,
-- and the extension channel of the stimulus IS the question of whether
-- that code is trivial.  Everything below is universal (every Q, every
-- abelian W, every candidate code c) and --safe at the pin.
--
-- THEOREMS.
--   1. assocFromCocycle — the twisted product on Q × W is associative
--      GIVEN the cocycle identity: a lawful code glues a lawful tower.
--   2. cocycleFromAssoc — conversely, associativity of the twisted
--      product FORCES the cocycle identity: the gluing code is exactly
--      the associativity defect, nothing else.  (1)+(2): "interaction
--      code" is not a metaphor — it is the unique obstruction-shaped
--      datum a two-stage composite can carry.
--   3. Split.φ / φHom / φSection / φRetract — when the code is a
--      coboundary (class zero), the tower IS the direct product: an
--      explicit multiplication-preserving isomorphism, both inverse
--      laws checked.  Class zero ⟺ no interaction, and the corpus
--      already holds the converse instance where the class is NONZERO
--      and the tower provably does not split: the carry of positional
--      notation (GroupCohomologyH2 / CarryObstruction).  This file is
--      the general channel; the corpus's carry theorem is its first
--      inhabited transmission.
------------------------------------------------------------------------

module TwoStageTower where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import ValueIsThePairing using (GroupOn)

private
  variable
    ℓ ℓ' : Level

module Extension {Q : Type ℓ} {W : Type ℓ'}
                 (QG : GroupOn Q) (WG : GroupOn W)
                 (comm : ∀ a b → GroupOn._⊕_ WG a b ≡ GroupOn._⊕_ WG b a)
                 (c : Q → Q → W) where

  open GroupOn QG renaming
    ( _⊕_ to _*_ ; ε to e ; ⊖_ to qInv
    ; gAssoc to qAssoc ; gIdL to qIdL ; gIdR to qIdR
    ; gInvL to qInvL ; gInvR to qInvR )
  open GroupOn WG

  -- the gluing law a code must satisfy
  Cocycle : Type (ℓ-max ℓ ℓ')
  Cocycle = ∀ x y z → c x y ⊕ c (x * y) z ≡ c y z ⊕ c x (y * z)

  -- the tower: base Q, fibre W, composite glued by c
  Tot : Type (ℓ-max ℓ ℓ')
  Tot = Q × W

  _⊗_ : Tot → Tot → Tot
  (x , w) ⊗ (y , v) = (x * y) , ((w ⊕ v) ⊕ c x y)

  -- abelian interchange, used throughout
  exch : ∀ a b x y → (a ⊕ b) ⊕ (x ⊕ y) ≡ (a ⊕ x) ⊕ (b ⊕ y)
  exch a b x y =
      sym (gAssoc a b (x ⊕ y))
    ∙ cong (a ⊕_) (gAssoc b x y
                   ∙ cong (_⊕ y) (comm b x)
                   ∙ sym (gAssoc x b y))
    ∙ gAssoc a x (b ⊕ y)

  ----------------------------------------------------------------------
  -- THEOREM 1: a lawful code glues a lawful tower.
  ----------------------------------------------------------------------
  assocFromCocycle : Cocycle
                   → ∀ s t r → s ⊗ (t ⊗ r) ≡ (s ⊗ t) ⊗ r
  assocFromCocycle coc (x , w) (y , v) (z , u) =
    cong₂ _,_ (qAssoc x y z) wEq
    where
    lhsToCommon : (w ⊕ ((v ⊕ u) ⊕ c y z)) ⊕ c x (y * z)
                ≡ ((w ⊕ v) ⊕ u) ⊕ (c y z ⊕ c x (y * z))
    lhsToCommon =
        cong (_⊕ c x (y * z)) (gAssoc w (v ⊕ u) (c y z))
      ∙ sym (gAssoc (w ⊕ (v ⊕ u)) (c y z) (c x (y * z)))
      ∙ cong (_⊕ (c y z ⊕ c x (y * z))) (gAssoc w v u)

    moveU : ((w ⊕ v) ⊕ c x y) ⊕ u ≡ ((w ⊕ v) ⊕ u) ⊕ c x y
    moveU =
        sym (gAssoc (w ⊕ v) (c x y) u)
      ∙ cong ((w ⊕ v) ⊕_) (comm (c x y) u)
      ∙ gAssoc (w ⊕ v) u (c x y)

    rhsToCommon : (((w ⊕ v) ⊕ c x y) ⊕ u) ⊕ c (x * y) z
                ≡ ((w ⊕ v) ⊕ u) ⊕ (c y z ⊕ c x (y * z))
    rhsToCommon =
        cong (_⊕ c (x * y) z) moveU
      ∙ sym (gAssoc ((w ⊕ v) ⊕ u) (c x y) (c (x * y) z))
      ∙ cong (((w ⊕ v) ⊕ u) ⊕_) (coc x y z)

    wEq : (w ⊕ ((v ⊕ u) ⊕ c y z)) ⊕ c x (y * z)
        ≡ (((w ⊕ v) ⊕ c x y) ⊕ u) ⊕ c (x * y) z
    wEq = lhsToCommon ∙ sym rhsToCommon

  ----------------------------------------------------------------------
  -- THEOREM 2: the code IS the associativity defect — a lawful tower
  -- forces a lawful code.  Evaluate the associator at fibre identity.
  ----------------------------------------------------------------------
  cocycleFromAssoc : (∀ s t r → s ⊗ (t ⊗ r) ≡ (s ⊗ t) ⊗ r)
                   → Cocycle
  cocycleFromAssoc assoc x y z =
      sym simpR
    ∙ sym (cong snd (assoc (x , ε) (y , ε) (z , ε)))
    ∙ simpL
    where
    simpL : (ε ⊕ ((ε ⊕ ε) ⊕ c y z)) ⊕ c x (y * z)
          ≡ c y z ⊕ c x (y * z)
    simpL = cong (_⊕ c x (y * z))
              (gIdL ((ε ⊕ ε) ⊕ c y z)
               ∙ cong (_⊕ c y z) (gIdL ε)
               ∙ gIdL (c y z))

    simpR : (((ε ⊕ ε) ⊕ c x y) ⊕ ε) ⊕ c (x * y) z
          ≡ c x y ⊕ c (x * y) z
    simpR = cong (_⊕ c (x * y) z)
              (gIdR ((ε ⊕ ε) ⊕ c x y)
               ∙ cong (_⊕ c x y) (gIdL ε)
               ∙ gIdL (c x y))

  ----------------------------------------------------------------------
  -- THEOREM 3: class zero ⇒ the tower is the direct product.  The
  -- shear by the bounding function is an explicit isomorphism carrying
  -- the twisted product to the untwisted one.
  ----------------------------------------------------------------------
  module Split (h : Q → W)
               (isCob : ∀ x y → c x y ≡ (h x ⊕ h y) ⊕ (⊖ h (x * y))) where

    _⊗₀_ : Tot → Tot → Tot
    (x , w) ⊗₀ (y , v) = (x * y) , (w ⊕ v)

    φ : Tot → Tot
    φ (x , w) = x , (w ⊕ h x)

    φ⁻ : Tot → Tot
    φ⁻ (x , w) = x , (w ⊕ (⊖ h x))

    φSection : ∀ s → φ (φ⁻ s) ≡ s
    φSection (x , w) =
      cong₂ _,_ refl
        (sym (gAssoc w (⊖ h x) (h x))
         ∙ cong (w ⊕_) (gInvL (h x))
         ∙ gIdR w)

    φRetract : ∀ s → φ⁻ (φ s) ≡ s
    φRetract (x , w) =
      cong₂ _,_ refl
        (sym (gAssoc w (h x) (⊖ h x))
         ∙ cong (w ⊕_) (gInvR (h x))
         ∙ gIdR w)

    φHom : ∀ s t → φ (s ⊗ t) ≡ φ s ⊗₀ φ t
    φHom (x , w) (y , v) =
      cong₂ _,_ refl
        (   sym (gAssoc (w ⊕ v) (c x y) (h (x * y)))
          ∙ cong ((w ⊕ v) ⊕_)
              (   cong (_⊕ h (x * y)) (isCob x y)
                ∙ sym (gAssoc (h x ⊕ h y) (⊖ h (x * y)) (h (x * y)))
                ∙ cong ((h x ⊕ h y) ⊕_) (gInvL (h (x * y)))
                ∙ gIdR (h x ⊕ h y))
          ∙ exch w v (h x) (h y))
