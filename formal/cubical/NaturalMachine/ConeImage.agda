{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ConeImage
--
-- Delta 17 T17.13, the half that has content: the parity constraint on
-- the cone is not a side condition attached to the cone, it is EXACTLY
-- the image of the pair map.
--
-- Delta 17 states the cone coordinates (s,d) = (p+q, q−p) together with
-- a congruence s ≡ d (mod 2), and presents the congruence as a
-- constraint the cone must satisfy.  `PairCoordinates.sumIsDouble`
-- already checked the easy direction (the constraint is necessary).
-- What was OPEN was the equivalence.  Here it is, both ways, over an
-- ARBITRARY commutative ring:
--
--   (s,d) is hit by the pair map  ⟺  s + d is a double.
--
-- Two remarks on why this is the right statement.
--
-- 1. It needs no halving, no cancellation, and no order.  The naive
--    formulation — "the pair map is an isomorphism onto the even
--    sublocus" — needs doubling to be injective, which is a property of
--    ℤ and not of the algebra; stating surjectivity onto the sublocus
--    instead isolates the part that is actually about the coordinates.
--    Over a ring where 2 is a zero divisor the equivalence below still
--    holds and the isomorphism does not, which is evidence that this is
--    the invariant content.
--
-- 2. The witness is explicit and constructive in both directions, so the
--    proof is a decoding algorithm: given the parity certificate k with
--    s + d ≡ k + k, the pair is (s − k, k).  Delta 17's congruence is
--    thus the DATA that reconstructs the pair, not a predicate that
--    filters it.
--
-- Contents (no holes, no postulates, --safe):
--
--   Double, InImage             the two sides
--   image→double                T17.13 ⇒  (= sumIsDouble, restated for
--                               this formulation)
--   double→image                T17.13 ⇐  (the new half)
--   cone-image                  the equivalence of the two
--   decode-roundtrip            the decoder really does invert: the pair
--                               produced from (s,d) has sum s and gap d
--
-- NOT covered, and named so the ledger stays honest: the INEQUALITY half
-- of Delta 17's cone (|d| ≤ s, i.e. both legs nonnegative) is an order
-- statement, has no meaning over an arbitrary commutative ring, and is
-- not touched here.
------------------------------------------------------------------------

module NaturalMachine.ConeImage where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection

open import NaturalMachine.PairCoordinates using (module Pair)

private
  variable
    ℓ : Level

module Cone (R : CommRing ℓ) where
  open CommRingStr (snd R)
  open Pair R

  -- The parity certificate: n is a double, witnessed by its half.
  Double : fst R → Type ℓ
  Double n = Σ[ k ∈ fst R ] (n ≡ k + k)

  -- (s,d) is in the image of the pair map: some centre/half-gap pair has
  -- sum s and gap d.  Written with the legs rather than (w,r) because
  -- that is the form Delta 17 uses.
  InImage : fst R → fst R → Type ℓ
  InImage s d =
    Σ[ p ∈ fst R ] Σ[ q ∈ fst R ] ((p + q ≡ s) × (q - p ≡ d))

  ----------------------------------------------------------------------
  -- ⇒  The constraint is necessary.  s + d = (p+q) + (q−p) = 2q.
  ----------------------------------------------------------------------

  sum-gap-doubles : (p q : fst R) → (p + q) + (q - p) ≡ q + q
  sum-gap-doubles p q = solve! R

  image→double : (s d : fst R) → InImage s d → Double (s + d)
  image→double s d (p , q , hs , hd) =
    q , (cong₂ (λ a b → a + b) (sym hs) (sym hd) ∙ sum-gap-doubles p q)

  ----------------------------------------------------------------------
  -- ⇐  The constraint is sufficient, and the certificate decodes.
  --
  -- Given s + d ≡ k + k, take q = k and p = s − k.  Then
  --   p + q = (s − k) + k = s
  --   q − p = k − (s − k)  = (k + k) − s = (s + d) − s = d.
  ----------------------------------------------------------------------

  decode-sum : (s k : fst R) → (s - k) + k ≡ s
  decode-sum s k = solve! R

  decode-gap : (s k : fst R) → k - (s - k) ≡ (k + k) - s
  decode-gap s k = solve! R

  cancel-s : (s d : fst R) → (s + d) - s ≡ d
  cancel-s s d = solve! R

  double→image : (s d : fst R) → Double (s + d) → InImage s d
  double→image s d (k , hk) =
    (s - k) , k , decode-sum s k ,
    (decode-gap s k
      ∙ cong (λ z → z - s) (sym hk)
      ∙ cancel-s s d)

  ----------------------------------------------------------------------
  -- T17.13, the equivalence.  Delta 17's congruence s ≡ d (mod 2) — here
  -- in the equivalent additive form "s + d is a double", which avoids
  -- needing subtraction to be a parity-preserving operation as a lemma —
  -- characterises the cone exactly.
  ----------------------------------------------------------------------

  cone-image : (s d : fst R) → (InImage s d → Double (s + d))
                             × (Double (s + d) → InImage s d)
  cone-image s d = image→double s d , double→image s d

  ----------------------------------------------------------------------
  -- The decoder is a decoder: the pair it produces really has the
  -- prescribed sum and gap.  This is the content of `double→image`
  -- restated as a round-trip, so that a reader who wants the algorithm
  -- rather than the logical equivalence can take it directly.
  ----------------------------------------------------------------------

  decode : (s d : fst R) → Double (s + d) → fst R × fst R
  decode s d (k , _) = (s - k) , k

  decode-roundtrip : (s d : fst R) (h : Double (s + d))
                   → ((fst (decode s d h)) + (snd (decode s d h)) ≡ s)
                   × ((snd (decode s d h)) - (fst (decode s d h)) ≡ d)
  decode-roundtrip s d (k , hk) =
    decode-sum s k ,
    (decode-gap s k ∙ cong (λ z → z - s) (sym hk) ∙ cancel-s s d)

  ----------------------------------------------------------------------
  -- Consistency with §1 of PairCoordinates: the legs of a centre/half-gap
  -- pair are always in the image, with the centre as the certificate.
  -- This is `sumIsDouble` seen through the new formulation, and it is the
  -- reason the two modules are not saying different things.
  ----------------------------------------------------------------------

  legs-sum : (w r : fst R) → leg₁ w r + leg₂ w r ≡ w + w
  legs-sum w r = solve! R

  legs-gap : (w r : fst R) → leg₂ w r - leg₁ w r ≡ r + r
  legs-gap w r = solve! R

  legs-in-image : (w r : fst R)
                → InImage (leg₁ w r + leg₂ w r) (leg₂ w r - leg₁ w r)
  legs-in-image w r = leg₁ w r , leg₂ w r , refl , refl
