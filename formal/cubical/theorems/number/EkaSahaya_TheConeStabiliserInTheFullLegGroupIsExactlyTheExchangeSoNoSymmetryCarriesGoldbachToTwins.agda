{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- एक-सहाय · EkaSahaya — "one companion."
--
-- THE QUESTION, inherited as a śeṣa from the yantra session of
-- 2026-08-27: classify ALL cone-preserving involutions of the pair
-- field.  PrimePairField.noSelfDualPair shows the ONE map that exchanges
-- the Goldbach foliation (fixed centre) with the twin foliation (fixed
-- gap) exits the positivity cone.  That refutes one candidate.  This
-- module closes the family: over the whole finite symmetry group the
-- legs naturally carry, the cone has EXACTLY ONE nontrivial symmetry,
-- and it is the exchange τ — which FIXES each foliation instead of
-- swapping them.  So within this group there is no self-duality of the
-- pair field at all, and the split of the one symmetric-plane statement
-- into two conjectures is exhaustive, not an artifact of testing one map.
--
-- THE GROUP.  A pair of legs (p , q) carries sign change on each leg
-- and the leg swap: the hyperoctahedral group of the square, order 8
-- (Klein four-group of signs, extended by the swap).  Its eight
-- elements, in leg form and — computed through Φraw, each equality
-- discharged by the ring solver — in centre-relative form:
--
--     legs (p , q)        (W , R) form          cone verdict
--   1 ( p ,  q)   id      ( W ,  R)             PRESERVES (trivially)
--   2 ( q ,  p)   τ       ( W , -R)             PRESERVES  ← the companion
--   3 (-p ,  q)   J₁      ( R ,  W)             breaks
--   4 ( p , -q)   J₂      (-R , -W)             breaks
--   5 (-p , -q)   -id     (-W , -R)             breaks
--   6 (-q , -p)   τ∘-id   (-W ,  R)             breaks
--   7 ( q , -p)   rot     ( R , -W)             breaks
--   8 (-q ,  p)   rot⁻    (-R ,  W)             breaks
--
-- Row 3 is the finding that prompted this module: negating the FIRST
-- leg is the PURE SWAP (W , R) ↦ (R , W) — the naked Goldbach↔twin
-- exchange, no signs — and it breaks the cone exactly as J₂ does.
-- Rows 3, 4, 7, 8 are the four maps carrying the fixed-centre foliation
-- to the fixed-gap foliation; all four break.  Rows 5 and 6 preserve
-- each foliation but break the cone anyway.  Only row 2 survives, and
-- it fixes the foliations.  Hence:
--
--   EVERY element of the leg group either preserves both foliations or
--   breaks the cone.  No symmetry in the group carries Goldbach to
--   twins.  (ekaSahaya plus the breakage theorems, packaged in §3.)
--
-- WHAT THIS IS NOT.  The group is the natural finite one, not all of
-- GL₂(ℤ); a cone-preserving non-involutive map (a shear) is not
-- excluded here and does not exchange the foliations.  The claim proved
-- is exhaustiveness over the hyperoctahedral group, which is where a
-- candidate duality must live: a duality normalises the two foliations
-- (so it permutes the axes up to sign) and fixes the origin.
--
-- Proof economy: every breakage is the one lemma posAnti — a nonzero
-- integer and its negation are never both positive — applied to the
-- cone coordinate the element negates, after a ring-solver identity.
-- The cone is killed by polarity alone, which is the arithmetic
-- content: the obstruction to self-duality of the prime-pair field
-- is (-1).
------------------------------------------------------------------------

module EkaSahaya_TheConeStabiliserInTheFullLegGroupIsExactlyTheExchangeSoNoSymmetryCarriesGoldbachToTwins where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _-_ ; -_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

open import CenterRelative
  using ( Pair ; Φraw ; τ ; τCR ; J₂CR ; Pos ; InCone ; posAnti
        ; exchangePreservesCone ; thm16-4 )

------------------------------------------------------------------------
-- 1.  The remaining elements of the leg group, in both presentations.
--     (id, τ, J₂ already live in CenterRelative.)
------------------------------------------------------------------------

J₁ neg τneg rot rot⁻ : Pair → Pair
J₁   (p , q) = (- p ,   q)     -- row 3
neg  (p , q) = (- p , - q)     -- row 5
τneg (p , q) = (- q , - p)     -- row 6
rot  (p , q) = (  q , - p)     -- row 7
rot⁻ (p , q) = (- q ,   p)     -- row 8

J₁CR negCR τnegCR rotCR rot⁻CR : ℤ × ℤ → ℤ × ℤ
J₁CR   (W , R) = (  R ,   W)   -- the pure swap: the naked foliation exchange
negCR  (W , R) = (- W , - R)
τnegCR (W , R) = (- W ,   R)
rotCR  (W , R) = (  R , - W)
rot⁻CR (W , R) = (- R ,   W)

private
  -- Φraw intertwines each leg form with its centre-relative form.
  eJ₁f : (p q : ℤ) → (- p) + q ≡ q - p
  eJ₁f _ _ = solve! ℤCommRing
  eJ₁s : (p q : ℤ) → q - (- p) ≡ p + q
  eJ₁s _ _ = solve! ℤCommRing
  enf  : (p q : ℤ) → (- p) + (- q) ≡ - (p + q)
  enf  _ _ = solve! ℤCommRing
  ens  : (p q : ℤ) → (- q) - (- p) ≡ - (q - p)
  ens  _ _ = solve! ℤCommRing
  etnf : (p q : ℤ) → (- q) + (- p) ≡ - (p + q)
  etnf _ _ = solve! ℤCommRing
  etns : (p q : ℤ) → (- p) - (- q) ≡ q - p
  etns _ _ = solve! ℤCommRing
  erf  : (p q : ℤ) → q + (- p) ≡ q - p
  erf  _ _ = solve! ℤCommRing
  ers  : (p q : ℤ) → (- p) - q ≡ - (p + q)
  ers  _ _ = solve! ℤCommRing
  er⁻f : (p q : ℤ) → (- q) + p ≡ - (q - p)
  er⁻f _ _ = solve! ℤCommRing
  er⁻s : (p q : ℤ) → p - (- q) ≡ p + q
  er⁻s _ _ = solve! ℤCommRing

intertwineJ₁ : (x : Pair) → Φraw (J₁ x) ≡ J₁CR (Φraw x)
intertwineJ₁ (p , q) i = eJ₁f p q i , eJ₁s p q i

intertwineNeg : (x : Pair) → Φraw (neg x) ≡ negCR (Φraw x)
intertwineNeg (p , q) i = enf p q i , ens p q i

intertwineτneg : (x : Pair) → Φraw (τneg x) ≡ τnegCR (Φraw x)
intertwineτneg (p , q) i = etnf p q i , etns p q i

intertwineRot : (x : Pair) → Φraw (rot x) ≡ rotCR (Φraw x)
intertwineRot (p , q) i = erf p q i , ers p q i

intertwineRot⁻ : (x : Pair) → Φraw (rot⁻ x) ≡ rot⁻CR (Φraw x)
intertwineRot⁻ (p , q) i = er⁻f p q i , er⁻s p q i

------------------------------------------------------------------------
-- 2.  The breakage theorems.  One lemma each: posAnti on the cone
--     coordinate the element negates.
--     InCone (a , b) = Pos (a - b) × Pos (a + b).
------------------------------------------------------------------------

private
  cJ₁ : (W R : ℤ) → R - W ≡ - (W - R)
  cJ₁ _ _ = solve! ℤCommRing
  cNeg : (W R : ℤ) → (- W) - (- R) ≡ - (W - R)
  cNeg _ _ = solve! ℤCommRing
  cτneg : (W R : ℤ) → (- W) - R ≡ - (W + R)
  cτneg _ _ = solve! ℤCommRing
  cRot : (W R : ℤ) → R + (- W) ≡ - (W - R)
  cRot _ _ = solve! ℤCommRing
  cRot⁻ : (W R : ℤ) → (- R) - W ≡ - (W + R)
  cRot⁻ _ _ = solve! ℤCommRing

-- Row 3: the pure swap breaks the cone.  This is the sharpest form of
-- the obstruction: the foliation exchange with NO signs still fails,
-- because it turns the positive coordinate W - R into its negation.
pureSwapBreaksCone : (x : ℤ × ℤ) → InCone x → ¬ InCone (J₁CR x)
pureSwapBreaksCone (W , R) (d , _) (d' , _) =
  posAnti (W - R) d (subst Pos (cJ₁ W R) d')

-- Row 5: total negation breaks the cone (the cone is not centrally
-- symmetric — it has an arrow).
negBreaksCone : (x : ℤ × ℤ) → InCone x → ¬ InCone (negCR x)
negBreaksCone (W , R) (d , _) (d' , _) =
  posAnti (W - R) d (subst Pos (cNeg W R) d')

-- Row 6: exchange composed with total negation still breaks it.
τnegBreaksCone : (x : ℤ × ℤ) → InCone x → ¬ InCone (τnegCR x)
τnegBreaksCone (W , R) (_ , s) (d' , _) =
  posAnti (W + R) s (subst Pos (cτneg W R) d')

-- Rows 7 and 8: the quarter-turn rotations break it.  For rot the
-- SECOND cone coordinate of the image is the negated first coordinate
-- of the source; for rot⁻ the first is the negated second.
rotBreaksCone : (x : ℤ × ℤ) → InCone x → ¬ InCone (rotCR x)
rotBreaksCone (W , R) (d , _) (_ , s') =
  posAnti (W - R) d (subst Pos (cRot W R) s')

rot⁻BreaksCone : (x : ℤ × ℤ) → InCone x → ¬ InCone (rot⁻CR x)
rot⁻BreaksCone (W , R) (_ , s) (d' , _) =
  posAnti (W + R) s (subst Pos (cRot⁻ W R) d')

-- Row 4 is CenterRelative.thm16-4, imported, not reproved.

------------------------------------------------------------------------
-- 3.  The stabiliser statement, as data.
------------------------------------------------------------------------

-- The one companion: τ preserves (CenterRelative.exchangePreservesCone),
-- re-exported under the name the classification gives it.
ekaSahaya : (x : ℤ × ℤ) → InCone x → InCone (τCR x)
ekaSahaya = exchangePreservesCone

-- Every foliation-exchanging element of the leg group breaks the cone.
-- The four exchanging elements are rows 3, 4, 7, 8; one clause each.
noDualityInTheLegGroup :
    ((x : ℤ × ℤ) → InCone x → ¬ InCone (J₁CR  x))
  × ((x : ℤ × ℤ) → InCone x → ¬ InCone (J₂CR  x))
  × ((x : ℤ × ℤ) → InCone x → ¬ InCone (rotCR x))
  × ((x : ℤ × ℤ) → InCone x → ¬ InCone (rot⁻CR x))
noDualityInTheLegGroup =
  pureSwapBreaksCone , thm16-4 , rotBreaksCone , rot⁻BreaksCone

-- And the two non-exchanging nontrivial sign elements break it too, so
-- the full stabiliser is {id , τ}: the cone has exactly one companion.
stabiliserIsIdAndτ :
    ((x : ℤ × ℤ) → InCone x → InCone (τCR x))
  × ((x : ℤ × ℤ) → InCone x → ¬ InCone (negCR  x))
  × ((x : ℤ × ℤ) → InCone x → ¬ InCone (τnegCR x))
stabiliserIsIdAndτ = ekaSahaya , negBreaksCone , τnegBreaksCone

------------------------------------------------------------------------
-- 4.  Control: the theorems are about something inhabited.  The twin
--     pair (3,5) of PrimePairField's control sits at (W , R) = (8 , 2);
--     it is in the cone, and the breakage theorems bite on it.
------------------------------------------------------------------------

private
  x₀ : ℤ × ℤ
  x₀ = (pos 8 , pos 2)

  x₀InCone : InCone x₀
  x₀InCone = (5 , refl) , (9 , refl)

  control-swap : ¬ InCone (J₁CR x₀)
  control-swap = pureSwapBreaksCone x₀ x₀InCone

  control-neg : ¬ InCone (negCR x₀)
  control-neg = negBreaksCone x₀ x₀InCone
