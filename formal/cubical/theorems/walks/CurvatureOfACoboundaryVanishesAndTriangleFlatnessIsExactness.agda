{-# OPTIONS --safe --cubical --guardedness #-}

------------------------------------------------------------------------
-- CurvatureOfACoboundaryVanishesAndTriangleFlatnessIsExactness — the
-- degree-two rung of the walk cochain complex, over an arbitrary
-- (nonabelian) group of values W:
--
--   curvature      F ω a b c = (ω a b ⊕ ω b c) ⊕ ⊖ ω a c, the
--                  triangle defect of a 1-cochain — the discrete
--                  curvature 2-cochain.
--   d²-vanishes    F (d f) ≡ ε for EVERY value-function f and EVERY
--                  group W — no commutativity: the coboundary's
--                  triangle telescopes by associativity and inverse
--                  cancellation alone.  The square of the coboundary
--                  is zero one degree up from where the corpus had it.
--   curvatureIsTriangleHolonomy
--                  for a signed cochain, F ω a b c is EXACTLY the
--                  pairing of ω against the triangle loop a→b→c→a.
--                  Curvature is not an analogue of holonomy; on the
--                  smallest loops it is the same term.
--   exactFromFlat / flatFromExact
--                  the iff: ω is a coboundary exactly when every
--                  triangle is flat (V inhabited for the forward
--                  direction; the potential is f v = ω u₀ v, one edge,
--                  no walk machinery consumed).
--
-- WHAT THIS ADDS.  The full read of the corpus (all 20 theorem
-- directories) found degree-two cochain structure only in isolated
-- instances (the Klein/torus H² separation, the Peres–Mermin coker δ);
-- the walk lane itself stopped at degree one
-- (HolonomyCriterionForExactness: stokes, descent, the loop criterion,
-- TestBasis).  This module opens degree two on the same carrier with
-- the same GroupOn interface, and ties it back down: flatness of the
-- 2-skeleton is equivalent to exactness, which is the precise sense in
-- which the complete relation is simply connected one level up — the
-- triangles at a basepoint are already a spanning test family, and
-- exactFromFlat consumes exactly one triangle per edge.
--
-- WHAT IS NOT CLAIMED.  No Bianchi identity (the nonabelian dF needs
-- conjugation-twisted degree-three structure not built here); no
-- statement about restricted (non-complete) edge relations, where
-- flatness on triangles is weaker than flatness on loops; no homology
-- of any specific graph.
------------------------------------------------------------------------

module CurvatureOfACoboundaryVanishesAndTriangleFlatnessIsExactness where

open import Cubical.Foundations.Prelude

open import HolonomyCriterionForExactness using (GroupOn)
import HolonomyCriterionForExactness as H

private
  variable
    ℓ ℓ' : Level

module Curvature (V : Type ℓ) {W : Type ℓ'} (G : GroupOn W) where
  open GroupOn G
  open H.Traces V G using (Walk ; done ; step ; Cochain ; ⟨_,_⟩ ; d ; Signed)

  ----------------------------------------------------------------------
  -- 0.  Two group-algebra moves, used repeatedly.
  ----------------------------------------------------------------------

  private
    -- (x ⊕ y) ⊕ ⊖ z ≡ ε   ⟹   x ⊕ y ≡ z
    unInv : (x y z : W) → (x ⊕ y) ⊕ (⊖ z) ≡ ε → x ⊕ y ≡ z
    unInv x y z p =
        sym (gIdR (x ⊕ y))
      ∙ cong ((x ⊕ y) ⊕_) (sym (gInvL z))
      ∙ gAssoc (x ⊕ y) (⊖ z) z
      ∙ cong (_⊕ z) p
      ∙ gIdL z

    -- x ⊕ y ≡ z   ⟹   y ≡ ⊖ x ⊕ z
    unL : (x y z : W) → x ⊕ y ≡ z → y ≡ (⊖ x) ⊕ z
    unL x y z p =
        sym (gIdL y)
      ∙ cong (_⊕ y) (sym (gInvL x))
      ∙ sym (gAssoc (⊖ x) x y)
      ∙ cong ((⊖ x) ⊕_) p

    -- the telescoping of adjacent coboundary legs
    telescope : (p q r : W) → ((⊖ p) ⊕ q) ⊕ ((⊖ q) ⊕ r) ≡ (⊖ p) ⊕ r
    telescope p q r =
        sym (gAssoc (⊖ p) q ((⊖ q) ⊕ r))
      ∙ cong ((⊖ p) ⊕_)
          (gAssoc q (⊖ q) r ∙ cong (_⊕ r) (gInvR q) ∙ gIdL r)

  ----------------------------------------------------------------------
  -- 1.  The curvature 2-cochain.
  ----------------------------------------------------------------------

  F : Cochain → V → V → V → W
  F ω a b c = (ω a b ⊕ ω b c) ⊕ (⊖ ω a c)

  Flat : Cochain → Type (ℓ-max ℓ ℓ')
  Flat ω = ∀ a b c → F ω a b c ≡ ε

  ----------------------------------------------------------------------
  -- 2.  THEOREM (d²-vanishes).  The curvature of a coboundary is ε,
  --     over every group W — no commutativity anywhere.
  ----------------------------------------------------------------------

  d²-vanishes : (f : V → W) → Flat (d f)
  d²-vanishes f a b c =
      cong (_⊕ (⊖ (((⊖ f a) ⊕ f c)))) (telescope (f a) (f b) (f c))
    ∙ gInvR ((⊖ f a) ⊕ f c)

  ----------------------------------------------------------------------
  -- 3.  THEOREM (curvatureIsTriangleHolonomy).  For a signed cochain,
  --     the curvature at (a,b,c) is the holonomy of the triangle loop
  --     a → b → c → a.
  ----------------------------------------------------------------------

  triangle : (a b c : V) → Walk a a
  triangle a b c = step (step (step done b) c) a

  curvatureIsTriangleHolonomy :
    (ω : Cochain) (sg : Signed ω) (a b c : V)
    → ⟨ ω , triangle a b c ⟩ ≡ F ω a b c
  curvatureIsTriangleHolonomy ω sg a b c =
      cong (λ z → (z ⊕ ω b c) ⊕ ω c a) (gIdL (ω a b))
    ∙ cong ((ω a b ⊕ ω b c) ⊕_) (sg a c)

  ----------------------------------------------------------------------
  -- 4.  THEOREM (exactFromFlat / flatFromExact).  Triangle flatness is
  --     exactness — the iff, with the potential a single edge from the
  --     basepoint.
  ----------------------------------------------------------------------

  module _ (u₀ : V) where

    potential : Cochain → V → W
    potential ω v = ω u₀ v

    exactFromFlat : (ω : Cochain) → Flat ω
                  → ∀ a b → ω a b ≡ d (potential ω) a b
    exactFromFlat ω flat a b =
      unL (ω u₀ a) (ω a b) (ω u₀ b)
          (unInv (ω u₀ a) (ω a b) (ω u₀ b) (flat u₀ a b))

  flatFromExact : (ω : Cochain) (f : V → W)
                → (∀ a b → ω a b ≡ d f a b) → Flat ω
  flatFromExact ω f e a b c =
      cong₂ (λ x y → (x ⊕ y) ⊕ (⊖ ω a c)) (e a b) (e b c)
    ∙ cong (λ z → (d f a b ⊕ d f b c) ⊕ (⊖ z)) (e a c)
    ∙ d²-vanishes f a b c
