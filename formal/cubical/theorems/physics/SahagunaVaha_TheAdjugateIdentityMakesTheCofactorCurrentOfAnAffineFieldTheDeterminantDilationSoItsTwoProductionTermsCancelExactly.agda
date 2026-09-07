{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सहगुण-वाह — the cofactor current.
--
-- THE COFACTOR CURRENT OF AN AFFINE FIELD IS THE DETERMINANT DILATION,
-- SO THE TWO PRODUCTION TERMS CANCEL EXACTLY — NOT APPROXIMATELY, AND
-- NOT UP TO A BOUNDARY TERM ONE MAY DROP.
--
-- A localized production identity of the form
--
--     ω·Sω  =  -4 det S  +  (4/3) ∇·𝒥 ,      𝒥 = (cof ∇u)ᵀ u ,
--
-- has a boundary current on its right.  Dropping that current would
-- assign a nonzero cubic production to a field whose vorticity is
-- identically zero — an affine field u(x) = A x with A symmetric.  This
-- module shows the two terms cancel, and shows it is the ADJUGATE
-- IDENTITY that makes them cancel, so the harmonic completion and the
-- localized residual are not two separate pieces of bookkeeping: they
-- meet in one equation.
--
-- `TiryakChihna` already carries triples over a commutative ring, the
-- cross and inner products, and the fact that a cross product is
-- perpendicular to a factor.  That is exactly the material the adjugate
-- needs, and it is imported rather than rebuilt.
--
--   §1  THE SCALAR TRIPLE PRODUCT IS CYCLIC.  Two solver lines, and the
--       only coordinate computation about determinants in this file.
--
--   §2  THE ADJUGATE IDENTITY.  With a matrix presented by its three
--       columns and `adj` presented by the three cross products of
--       column pairs,
--
--         adj A (A x)  ≡  (det A) · x       for every x.
--
--       Diagonal entries are §1; off-diagonal entries are perpendicularity
--       of the cross product to its own factors.  Nothing else enters,
--       and in particular the matrix is arbitrary — no symmetry, no
--       trace condition, no invertibility.
--
--   §3  SO THE COFACTOR CURRENT OF AN AFFINE FIELD IS A DILATION.  For
--       u(x) = A x the current 𝒥(x) = adj A (A x) is exactly (det A) x,
--       whose matrix has trace det A + det A + det A.
--
--   §4  AND THE TWO PRODUCTION TERMS CANCEL, integrally: clearing the
--       3 in the coefficient once and for all,
--
--         3 · (-4 · det A)  +  4 · (∇·𝒥)  ≡  0 ,
--
--       because ∇·𝒥 is three times det A and no more.  The vorticity of
--       a symmetric affine field vanishes, so the left-hand side of the
--       production identity vanishes too; §4 says the right-hand side
--       does as well, with the two terms killing each other exactly.
--       Neither term is zero on its own.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–4 over any commutative ring, for every
-- matrix presented by three columns and every vector.  NOT claimed: the
-- production identity itself, which is a differential identity about a
-- vector field and is assumed nowhere and proved nowhere below — what is
-- proved is that ITS TWO RIGHT-HAND TERMS cancel on an affine field;
-- that the vorticity of a symmetric affine field vanishes, which is a
-- statement about `curl` and is not formalized here; anything about
-- integration, boundaries, or Green's identity; anything about `S` being
-- a strain, symmetric, or trace-free — §§1–4 hold for every matrix; and
-- no division anywhere: the 4/3 is cleared by multiplying through by 3,
-- which is why §4 reads as it does.
------------------------------------------------------------------------

module SahagunaVaha_TheAdjugateIdentityMakesTheCofactorCurrentOfAnAffineFieldTheDeterminantDilationSoItsTwoProductionTermsCancelExactly where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma using (_,_)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

import TiryakChihna_TheTransverseSymbolIsTheAxialVorticityTimesAComplexStructureSoItsSquareIsMinusThatScalarSquared as TC

private
  variable
    ℓ : Level

module _ (R : CommRing ℓ) where
  open CommRingStr (snd R)

  private
    A : Type ℓ
    A = ⟨ R ⟩

  -- everything vectorial comes from `TiryakChihna`
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

  --------------------------------------------------------------------
  -- ० · A matrix is its three columns; the determinant is the triple
  --     product; the adjugate is the three cross products.
  --------------------------------------------------------------------

  det : V → V → V → A
  det c₁ c₂ c₃ = (c₂ ×v c₃) ·v c₁

  adj : V → V → V → V → V
  adj c₁ c₂ c₃ y =
    ((c₂ ×v c₃) ·v y) , (((c₃ ×v c₁) ·v y) , ((c₁ ×v c₂) ·v y))

  apply : V → V → V → V → V
  apply c₁ c₂ c₃ x =
    (TC.x₁ R x *v c₁) +v ((TC.x₂ R x *v c₂) +v (TC.x₃ R x *v c₃))

  --------------------------------------------------------------------
  -- १ · THE TRIPLE PRODUCT IS CYCLIC.
  --------------------------------------------------------------------

  triple-cyclic₁ : (c₁ c₂ c₃ : V) → (c₃ ×v c₁) ·v c₂ ≡ det c₁ c₂ c₃
  triple-cyclic₁ c₁ c₂ c₃ = solve! R

  triple-cyclic₂ : (c₁ c₂ c₃ : V) → (c₁ ×v c₂) ·v c₃ ≡ det c₁ c₂ c₃
  triple-cyclic₂ c₁ c₂ c₃ = solve! R

  --------------------------------------------------------------------
  -- २ · THE ADJUGATE IDENTITY, on an arbitrary matrix.
  --------------------------------------------------------------------

  adjugate : (c₁ c₂ c₃ x : V)
    → adj c₁ c₂ c₃ (apply c₁ c₂ c₃ x) ≡ (det c₁ c₂ c₃) *v x
  adjugate c₁ c₂ c₃ x =
    TC.vecPath R (solve! R) (solve! R) (solve! R)

  --------------------------------------------------------------------
  -- ३ · SO THE COFACTOR CURRENT OF AN AFFINE FIELD IS A DILATION, and
  --     the trace of a dilation is three copies of its factor.
  --------------------------------------------------------------------

  e₁ e₂ e₃ : V
  e₁ = 1r , (0r , 0r)
  e₂ = 0r , (1r , 0r)
  e₃ = 0r , (0r , 1r)

  tr : V → V → V → A
  tr m₁ m₂ m₃ = TC.x₁ R m₁ + (TC.x₂ R m₂ + TC.x₃ R m₃)

  dilation-trace : (s : A) → tr (s *v e₁) (s *v e₂) (s *v e₃) ≡ s + (s + s)
  dilation-trace s = solve! R

  current-trace : (c₁ c₂ c₃ : V)
    → tr (adj c₁ c₂ c₃ (apply c₁ c₂ c₃ e₁))
         (adj c₁ c₂ c₃ (apply c₁ c₂ c₃ e₂))
         (adj c₁ c₂ c₃ (apply c₁ c₂ c₃ e₃))
      ≡ det c₁ c₂ c₃ + (det c₁ c₂ c₃ + det c₁ c₂ c₃)
  current-trace c₁ c₂ c₃ =
      congTr tr (adjugate c₁ c₂ c₃ e₁)
               (adjugate c₁ c₂ c₃ e₂)
               (adjugate c₁ c₂ c₃ e₃)
    ∙ dilation-trace (det c₁ c₂ c₃)
    where
      congTr : {a₁ a₂ a₃ b₁ b₂ b₃ : V} (f : V → V → V → A)
        → a₁ ≡ b₁ → a₂ ≡ b₂ → a₃ ≡ b₃ → f a₁ a₂ a₃ ≡ f b₁ b₂ b₃
      congTr f p q r i = f (p i) (q i) (r i)

  --------------------------------------------------------------------
  -- ४ · AND THE TWO PRODUCTION TERMS CANCEL EXACTLY.
  --------------------------------------------------------------------

  private
    three four : A
    three = 1r + (1r + 1r)
    four  = 1r + (1r + (1r + 1r))

  production-cancels : (c₁ c₂ c₃ : V)
    → (three · (- (four · det c₁ c₂ c₃)))
        + (four · tr (adj c₁ c₂ c₃ (apply c₁ c₂ c₃ e₁))
                     (adj c₁ c₂ c₃ (apply c₁ c₂ c₃ e₂))
                     (adj c₁ c₂ c₃ (apply c₁ c₂ c₃ e₃)))
      ≡ 0r
  production-cancels c₁ c₂ c₃ =
      cong (λ z → (three · (- (four · det c₁ c₂ c₃))) + (four · z))
           (current-trace c₁ c₂ c₃)
    ∙ cancels (det c₁ c₂ c₃)
    where
      cancels : (d : A)
        → (three · (- (four · d))) + (four · (d + (d + d))) ≡ 0r
      cancels d = solve! R
