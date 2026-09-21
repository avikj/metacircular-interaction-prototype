{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- भ्रम-मात्र — the measure of turning.
--
-- THE CURL OF A LINEAR FIELD IS THE AXIAL VECTOR OF ITS ANTISYMMETRIC
-- PART, AND IT VANISHES EXACTLY WHEN THE FIELD IS SYMMETRIC.  AND THE
-- SQUARE OF THE SPIN OPERATOR IS THE OUTER PRODUCT MINUS THE NORM.
--
-- `SahagunaVaha` proves the two production terms of an affine field
-- cancel, and says in its scope statement that the vanishing of the
-- vorticity of a SYMMETRIC affine field was a `curl` fact it did not
-- formalize.  This module supplies it, and supplies it in both
-- directions.
--
-- NO DIFFERENTIAL OPERATOR IS CONSTRUCTED, and none is needed.  A linear
-- field is its own difference quotient:
--
--   §1  M x  -  M y  ≡  M (x - y)      exactly, for every x and y.
--
--       So its Jacobian is the matrix itself at every point, with no
--       limit taken and no derivative defined.  `curlOf`, the axial
--       vector of the antisymmetric part, is therefore the curl of that
--       field in the only sense the statement requires.
--
--   §2  A SYMMETRIC MATRIX HAS VANISHING CURL — which is the missing
--       half of `SahagunaVaha`: for a symmetric affine field the
--       left-hand side of the production identity is zero, and that
--       module already shows its right-hand side is too.
--
--   §3  AND CONVERSELY: vanishing curl forces symmetry, entry by entry.
--       So `curlOf` is not merely blind to the symmetric part, it sees
--       the antisymmetric part faithfully — the fibre of `curlOf` over
--       zero is exactly the symmetric matrices.
--
--   §4  THE SPIN SQUARE.  For every w and x,
--
--         w × (w × x)  ≡  (x · w) w  -  (w · w) x ,
--
--       which is the operator identity  [w]²  ≡  w⊗w - (w·w)·I  applied
--       to a vector.  It falls out of `TiryakChihna`'s double cross
--       product and the anticommutativity of the cross product, and
--       needs neither.
--
--       WHAT IT GIVES A DEVIATORIC READING, stated as a reading and not
--       proved here: the two sides differ by a multiple of the identity,
--       which any trace-free projection deletes.  So the antisymmetric
--       part of a velocity gradient contributes to a trace-free strain
--       law only through the outer product of the vorticity with itself
--       — the `(w·w)` term never survives.  The projection is not
--       constructed in this file, so the factor of a quarter carried by
--       the half in `Ω = ½[ω]` is part of that reading and not of §4.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–4 over any commutative ring, for every
-- matrix presented by three columns and every pair of vectors.  NOT
-- claimed: that `curlOf` agrees with a differential curl on any NON-
-- linear field — §1 is exactly the reason no derivative is needed here
-- and exactly the limit of what it licenses; anything about vorticity as
-- a solution of an equation; the deviatoric reading of §4, which is
-- named as a reading above; and nothing about norms or magnitudes —
-- `w · w` is a ring element and no order relation exists in this file.
------------------------------------------------------------------------

module BhramaMatra_TheCurlOfALinearFieldIsTheAxialVectorOfItsAntisymmetricPartAndTheSpinSquareIsTheOuterProductMinusTheNorm where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

import TiryakChihna_TheTransverseSymbolIsTheAxialVorticityTimesAComplexStructureSoItsSquareIsMinusThatScalarSquared as TC
import SahagunaVaha_TheAdjugateIdentityMakesTheCofactorCurrentOfAnAffineFieldTheDeterminantDilationSoItsTwoProductionTermsCancelExactly as SV

private
  variable
    ℓ : Level

module _ (R : CommRing ℓ) where
  open CommRingStr (snd R)

  private
    A : Type ℓ
    A = ⟨ R ⟩

  V : Type ℓ
  V = TC.V R

  infixl 7 _·v_ _×v_ _*v_
  infixl 6 _+v_

  _·v_ : V → V → A
  _·v_ = TC._·v_ R

  _×v_ : V → V → V
  _×v_ = TC._×v_ R

  _*v_ : A → V → V
  _*v_ = TC._*v_ R

  _+v_ : V → V → V
  _+v_ = TC._+v_ R

  -v_ : V → V
  -v_ = TC.-v_ R

  y₁ y₂ y₃ : V → A
  y₁ = TC.x₁ R
  y₂ = TC.x₂ R
  y₃ = TC.x₃ R

  -- a matrix is its three columns, as in `SahagunaVaha`
  apply : V → V → V → V → V
  apply = SV.apply R

  ------------------------------------------------------------------
  -- १ · A LINEAR FIELD IS ITS OWN DIFFERENCE QUOTIENT.
  --
  --     No derivative is defined anywhere; this exact identity is what
  --     makes the matrix the Jacobian at every point.
  ------------------------------------------------------------------

  linear-difference : (c₁ c₂ c₃ x z : V)
    → (apply c₁ c₂ c₃ x) +v (-v (apply c₁ c₂ c₃ z))
      ≡ apply c₁ c₂ c₃ (x +v (-v z))
  linear-difference c₁ c₂ c₃ x z =
    TC.vecPath R (solve! R) (solve! R) (solve! R)

  ------------------------------------------------------------------
  -- ० · The axial vector of the antisymmetric part, and symmetry.
  ------------------------------------------------------------------

  curlOf : V → V → V → V
  curlOf c₁ c₂ c₃ =
      ((y₃ c₂) + (- (y₂ c₃)))
    , (((y₁ c₃) + (- (y₃ c₁)))
    ,  ((y₂ c₁) + (- (y₁ c₂))))

  Symmetric : V → V → V → Type ℓ
  Symmetric c₁ c₂ c₃ =
      (y₂ c₁ ≡ y₁ c₂) × ((y₃ c₁ ≡ y₁ c₃) × (y₃ c₂ ≡ y₂ c₃))

  ------------------------------------------------------------------
  -- २ · A SYMMETRIC MATRIX HAS VANISHING CURL.
  ------------------------------------------------------------------

  symmetric→no-curl : (c₁ c₂ c₃ : V)
    → Symmetric c₁ c₂ c₃ → curlOf c₁ c₂ c₃ ≡ TC.0v R
  symmetric→no-curl c₁ c₂ c₃ (s₁ , (s₂ , s₃)) =
    TC.vecPath R
      (cong (_+ (- (y₂ c₃))) s₃ ∙ +InvR (y₂ c₃))
      (cong (_+ (- (y₃ c₁))) (sym s₂) ∙ +InvR (y₃ c₁))
      (cong (_+ (- (y₁ c₂))) s₁ ∙ +InvR (y₁ c₂))

  ------------------------------------------------------------------
  -- ३ · AND CONVERSELY: vanishing curl forces symmetry.
  ------------------------------------------------------------------

  private
    fromDiff : (x z : A) → x + (- z) ≡ 0r → x ≡ z
    fromDiff x z h = sym (cancel x z) ∙ cong (_+ z) h ∙ +IdL z
      where
        cancel : (p q : A) → (p + (- q)) + q ≡ p
        cancel p q = solve! R

  no-curl→symmetric : (c₁ c₂ c₃ : V)
    → curlOf c₁ c₂ c₃ ≡ TC.0v R → Symmetric c₁ c₂ c₃
  no-curl→symmetric c₁ c₂ c₃ p =
      fromDiff (y₂ c₁) (y₁ c₂) (cong y₃ p)
    , ( sym (fromDiff (y₁ c₃) (y₃ c₁) (cong y₂ p))
      , fromDiff (y₃ c₂) (y₂ c₃) (cong y₁ p) )

  ------------------------------------------------------------------
  -- ४ · THE SPIN SQUARE IS THE OUTER PRODUCT MINUS THE NORM.
  ------------------------------------------------------------------

  cross-anticommutes : (X Y : V) → X ×v Y ≡ -v (Y ×v X)
  cross-anticommutes X Y = TC.vecPath R (solve! R) (solve! R) (solve! R)

  spin-square : (w x : V)
    → w ×v (w ×v x) ≡ ((x ·v w) *v w) +v (-v ((w ·v w) *v x))
  spin-square w x =
      cross-anticommutes w (w ×v x)
    ∙ cong -v_ (TC.cross-cross R w x w)
    ∙ TC.neg-swap R ((w ·v w) *v x) ((x ·v w) *v w)

  ------------------------------------------------------------------
  -- ५ · THE COROLLARY FOR `SahagunaVaha`.  Its production identity's
  --     right-hand side vanishes on every affine field; §2 says the
  --     left-hand side vanishes on the symmetric ones, so on a
  --     symmetric affine field BOTH sides are zero and the cancellation
  --     is not merely between two nonzero terms — it is the whole
  --     equation.
  ------------------------------------------------------------------

  symmetric-affine-produces-nothing : (c₁ c₂ c₃ : V)
    → Symmetric c₁ c₂ c₃
    → (curlOf c₁ c₂ c₃ ≡ TC.0v R)
      × ( (SV.three R · (- (SV.four R · SV.det R c₁ c₂ c₃)))
            + (SV.four R · SV.tr R
                 (SV.adj R c₁ c₂ c₃ (SV.apply R c₁ c₂ c₃ (SV.e₁ R)))
                 (SV.adj R c₁ c₂ c₃ (SV.apply R c₁ c₂ c₃ (SV.e₂ R)))
                 (SV.adj R c₁ c₂ c₃ (SV.apply R c₁ c₂ c₃ (SV.e₃ R))))
          ≡ 0r )
  symmetric-affine-produces-nothing c₁ c₂ c₃ s =
    symmetric→no-curl c₁ c₂ c₃ s , SV.production-cancels R c₁ c₂ c₃
