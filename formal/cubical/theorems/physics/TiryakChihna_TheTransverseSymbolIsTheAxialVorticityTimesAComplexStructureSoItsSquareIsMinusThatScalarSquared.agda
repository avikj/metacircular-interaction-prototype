{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- तिर्यक्-चिह्न — the transverse symbol.
--
-- ON THE PLANE PERPENDICULAR TO A DIRECTION, THE CROSS PRODUCT WITH
-- THAT DIRECTION SQUARES TO MINUS ONE.  SO THE TRANSVERSE SYMBOL OF
-- `a ↦ a × ω` IS THE AXIAL COMPONENT `ω · n` TIMES A COMPLEX STRUCTURE,
-- AND ITS SQUARE IS MINUS THAT SCALAR SQUARED.
--
-- The statement usually made here is spectral: the two eigenvalues of
-- the transverse symbol are `± ω · n`, obtained by observing that
-- `a ↦ a × n` has eigenvalues `± i` on the complexified transverse
-- plane.  Complexification is a device.  What it is a device FOR is an
-- algebraic identity that needs no complex numbers, no eigenvalues, and
-- no field:
--
--     (a × n) × n  ≡  - a           whenever  a · n ≡ 0  and  n · n ≡ 1 .
--
-- An operator squaring to `-1` IS the content of "its eigenvalues are
-- ±i"; the eigenvalue language is a reading of it over ℂ.  This module
-- proves the identity, and the two facts that sit on it, over an
-- ARBITRARY commutative ring — so no order, no completeness, no
-- positivity, and in particular no analysis.
--
--   §1  THE ONE POLYNOMIAL FACT.  Everything below is a corollary of
--
--         (X × Y) × Z  ≡  (X · Z) Y  -  (Y · Z) X ,
--
--       proved componentwise by the commutative-ring solver.  There is
--       no second computation anywhere in this file.
--
--   §2  THE TRANSVERSE PLANE CARRIES A COMPLEX STRUCTURE:
--       `(a × n) × n ≡ - a` on `a · n ≡ 0`, `n · n ≡ 1`.
--
--   §3  THE TRANSVERSE SYMBOL.  With `P n x = x - (x · n) n` the
--       transverse projection at the direction `n`,
--
--         P n (a × ω)  ≡  (ω · n) (a × n) .
--
--       The part of `ω` perpendicular to `n` contributes NOTHING: it
--       crosses with `a` into the `n` line, which `P n` deletes.  Only
--       the axial component survives, and it survives as a scalar.
--
--   §4  AND THEREFORE THE SYMBOL SQUARES TO A SCALAR:
--
--         P n (P n (a × ω) × ω)  ≡  - (ω · n)² a .
--
--       That is the eigenvalue statement, stated as an identity.  It
--       needs §3 twice, and between the two applications it needs that
--       the symbol lands back in the transverse plane, which is §0's
--       `cross-perp-right`.
--
--   §5  THE SYMBOL IS ADDITIVE IN THE SOURCE, so the difference of two
--       symbols is the symbol of the difference of the two sources.
--       This is the algebraic half of the exact-distance statement: the
--       representation is affine in the source before any norm is
--       chosen, so whatever a norm then measures on symbols, it measures
--       on differences of sources unchanged.
--
-- WHAT `P n` IS AND IS NOT.  `P n` here is the SYMBOL of a transverse
-- projection at one direction `n`: a pointwise linear map on triples.
-- It is not an operator on a function space, there is no Fourier
-- transform in this file, and nothing below is a statement about a
-- projection acting on fields.  §§2–5 are exactly the pointwise
-- identities that a symbol calculation would need, and nothing more.
--
-- SYĀT — THE CLAIM, EXACTLY.  §§1–5 over any commutative ring, for all
-- triples satisfying the displayed equations.  NOT claimed: any norm —
-- no order relation occurs in this file; any spectrum, essential or
-- otherwise, and no Weyl sequence, no limit, no wave packet; nothing
-- about `‖·‖_∞`, about L², or about any continuation criterion; nothing
-- about a Leray projection as an operator; the eigenvalue reading of §2
-- and §4, which is stated above as a reading of the identities and is
-- not itself proved (there is no ℂ here to state it in); and no
-- injectivity of any representation, which needs a norm §5 does not
-- supply.
------------------------------------------------------------------------

module TiryakChihna_TheTransverseSymbolIsTheAxialVorticityTimesAComplexStructureSoItsSquareIsMinusThatScalarSquared where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Structure using (⟨_⟩)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd ; ΣPathP)
open import Cubical.Algebra.CommRing
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

private
  variable
    ℓ : Level

module _ (R : CommRing ℓ) where
  open CommRingStr (snd R)

  private
    A : Type ℓ
    A = ⟨ R ⟩

  ------------------------------------------------------------------
  -- ० · Triples, and the three products.  Nothing here is a choice:
  --     these are the usual formulas.
  ------------------------------------------------------------------

  V : Type ℓ
  V = A × (A × A)

  infixl 7 _·v_ _×v_ _*v_
  infixl 6 _+v_
  infix  8 -v_

  x₁ x₂ x₃ : V → A
  x₁ u = fst u
  x₂ u = fst (snd u)
  x₃ u = snd (snd u)

  vecPath : {u v : V} → x₁ u ≡ x₁ v → x₂ u ≡ x₂ v → x₃ u ≡ x₃ v → u ≡ v
  vecPath p q r = ΣPathP (p , ΣPathP (q , r))

  0v : V
  0v = 0r , 0r , 0r

  _+v_ : V → V → V
  u +v v = (x₁ u + x₁ v) , (x₂ u + x₂ v) , (x₃ u + x₃ v)

  -v_ : V → V
  -v u = (- x₁ u) , (- x₂ u) , (- x₃ u)

  _*v_ : A → V → V                       -- scaling
  s *v u = (s · x₁ u) , (s · x₂ u) , (s · x₃ u)

  _·v_ : V → V → A                       -- the inner product
  u ·v v = (x₁ u · x₁ v) + ((x₂ u · x₂ v) + (x₃ u · x₃ v))

  _×v_ : V → V → V                       -- the cross product
  u ×v v =   ((x₂ u · x₃ v) + (- (x₃ u · x₂ v)))
           , ((x₃ u · x₁ v) + (- (x₁ u · x₃ v)))
           , ((x₁ u · x₂ v) + (- (x₂ u · x₁ v)))

  P : V → V → V                          -- the transverse projection
  P n x = x +v (-v ((x ·v n) *v n))

  ------------------------------------------------------------------
  -- १ · THE ONE POLYNOMIAL FACT, and the small book-keeping around it.
  --     Every line in this block is closed by the ring solver; nothing
  --     below §1 computes with coordinates again.
  ------------------------------------------------------------------

  cross-cross : (X Y Z : V)
    → (X ×v Y) ×v Z ≡ ((X ·v Z) *v Y) +v (-v ((Y ·v Z) *v X))
  cross-cross X Y Z = vecPath (solve! R) (solve! R) (solve! R)

  cross-perp-right : (X Y : V) → (X ×v Y) ·v Y ≡ 0r
  cross-perp-right X Y = solve! R

  cross-neg-left : (X Y : V) → (-v X) ×v Y ≡ -v (X ×v Y)
  cross-neg-left X Y = vecPath (solve! R) (solve! R) (solve! R)

  cross-scale-left : (s : A) (X Y : V) → (s *v X) ×v Y ≡ s *v (X ×v Y)
  cross-scale-left s X Y = vecPath (solve! R) (solve! R) (solve! R)

  cross-add-right : (X Y Z : V) → X ×v (Y +v Z) ≡ (X ×v Y) +v (X ×v Z)
  cross-add-right X Y Z = vecPath (solve! R) (solve! R) (solve! R)

  P-add : (n X Y : V) → P n (X +v Y) ≡ (P n X) +v (P n Y)
  P-add n X Y = vecPath (solve! R) (solve! R) (solve! R)

  scale-dot : (s : A) (X Y : V) → (s *v X) ·v Y ≡ s · (X ·v Y)
  scale-dot s X Y = solve! R

  scale-scale : (s t : A) (X : V) → s *v (t *v X) ≡ (s · t) *v X
  scale-scale s t X = vecPath (solve! R) (solve! R) (solve! R)

  scale-neg : (s : A) (X : V) → s *v (-v X) ≡ -v (s *v X)
  scale-neg s X = vecPath (solve! R) (solve! R) (solve! R)

  scale-0 : (X : V) → 0r *v X ≡ 0v
  scale-0 X = vecPath (solve! R) (solve! R) (solve! R)

  scale-1 : (X : V) → 1r *v X ≡ X
  scale-1 X = vecPath (solve! R) (solve! R) (solve! R)

  +v-IdL : (X : V) → 0v +v X ≡ X
  +v-IdL X = vecPath (solve! R) (solve! R) (solve! R)

  neg-neg : (X : V) → -v (-v X) ≡ X
  neg-neg X = vecPath (solve! R) (solve! R) (solve! R)

  neg-swap : (X Y : V) → -v (X +v (-v Y)) ≡ Y +v (-v X)
  neg-swap X Y = vecPath (solve! R) (solve! R) (solve! R)

  zeroR : (s : A) → s · 0r ≡ 0r
  zeroR s = solve! R

  ------------------------------------------------------------------
  -- २ · THE TRANSVERSE PLANE CARRIES A COMPLEX STRUCTURE.
  --
  --     (a × n) × n  =  (a · n) n  -  (n · n) a  =  0 - a  =  - a .
  ------------------------------------------------------------------

  complex-structure : (n a : V) → (a ·v n ≡ 0r) → (n ·v n ≡ 1r)
    → (a ×v n) ×v n ≡ -v a
  complex-structure n a han hnn =
      (a ×v n) ×v n
    ≡⟨ cross-cross a n n ⟩
      ((a ·v n) *v n) +v (-v ((n ·v n) *v a))
    ≡⟨ cong₂ (λ p q → (p *v n) +v (-v (q *v a))) han hnn ⟩
      (0r *v n) +v (-v (1r *v a))
    ≡⟨ cong₂ (λ p q → p +v (-v q)) (scale-0 n) (scale-1 a) ⟩
      0v +v (-v a)
    ≡⟨ +v-IdL (-v a) ⟩
      -v a ∎

  ------------------------------------------------------------------
  -- ३ · THE TRANSVERSE SYMBOL IS THE AXIAL COMPONENT TIMES `× n`.
  --
  --     the projection, on a unit direction, is a double cross:
  --       P n X  =  - ((X × n) × n) ,
  --     and the inner one collapses because a ⊥ n:
  --       (a × ω) × n  =  (a · n) ω - (ω · n) a  =  - (ω · n) a .
  ------------------------------------------------------------------

  projection-is-double-cross : (n X : V) → (n ·v n ≡ 1r)
    → P n X ≡ -v ((X ×v n) ×v n)
  projection-is-double-cross n X hnn =
    sym (
        -v ((X ×v n) ×v n)
      ≡⟨ cong -v_ (cross-cross X n n) ⟩
        -v (((X ·v n) *v n) +v (-v ((n ·v n) *v X)))
      ≡⟨ cong (λ q → -v (((X ·v n) *v n) +v (-v (q *v X)))) hnn ⟩
        -v (((X ·v n) *v n) +v (-v (1r *v X)))
      ≡⟨ cong (λ q → -v (((X ·v n) *v n) +v (-v q))) (scale-1 X) ⟩
        -v (((X ·v n) *v n) +v (-v X))
      ≡⟨ neg-swap ((X ·v n) *v n) X ⟩
        X +v (-v ((X ·v n) *v n)) ∎)

  transverse-symbol : (n a w : V) → (a ·v n ≡ 0r) → (n ·v n ≡ 1r)
    → P n (a ×v w) ≡ (w ·v n) *v (a ×v n)
  transverse-symbol n a w han hnn =
      P n (a ×v w)
    ≡⟨ projection-is-double-cross n (a ×v w) hnn ⟩
      -v (((a ×v w) ×v n) ×v n)
    ≡⟨ cong (λ z → -v (z ×v n)) inner ⟩
      -v ((-v ((w ·v n) *v a)) ×v n)
    ≡⟨ cong -v_ (cross-neg-left ((w ·v n) *v a) n) ⟩
      -v (-v (((w ·v n) *v a) ×v n))
    ≡⟨ neg-neg (((w ·v n) *v a) ×v n) ⟩
      ((w ·v n) *v a) ×v n
    ≡⟨ cross-scale-left (w ·v n) a n ⟩
      (w ·v n) *v (a ×v n) ∎
    where
      inner : (a ×v w) ×v n ≡ -v ((w ·v n) *v a)
      inner =
          (a ×v w) ×v n
        ≡⟨ cross-cross a w n ⟩
          ((a ·v n) *v w) +v (-v ((w ·v n) *v a))
        ≡⟨ cong (λ p → (p *v w) +v (-v ((w ·v n) *v a))) han ⟩
          (0r *v w) +v (-v ((w ·v n) *v a))
        ≡⟨ cong (_+v (-v ((w ·v n) *v a))) (scale-0 w) ⟩
          0v +v (-v ((w ·v n) *v a))
        ≡⟨ +v-IdL (-v ((w ·v n) *v a)) ⟩
          -v ((w ·v n) *v a) ∎

  ------------------------------------------------------------------
  -- ४ · SO THE SYMBOL SQUARES TO MINUS THE AXIAL COMPONENT SQUARED.
  --     Between the two applications of §3 the symbol must land back
  --     in the transverse plane; it does, because a cross product is
  --     perpendicular to both its factors.
  ------------------------------------------------------------------

  symbol : V → V → V → V
  symbol n w a = P n (a ×v w)

  symbol-stays-transverse : (n a w : V)
    → ((w ·v n) *v (a ×v n)) ·v n ≡ 0r
  symbol-stays-transverse n a w =
      scale-dot (w ·v n) (a ×v n) n
    ∙ cong ((w ·v n) ·_) (cross-perp-right a n)
    ∙ zeroR (w ·v n)

  symbol-squared : (n a w : V) → (a ·v n ≡ 0r) → (n ·v n ≡ 1r)
    → symbol n w (symbol n w a) ≡ -v (((w ·v n) · (w ·v n)) *v a)
  symbol-squared n a w han hnn =
      symbol n w (symbol n w a)
    ≡⟨ cong (symbol n w) (transverse-symbol n a w han hnn) ⟩
      symbol n w ((w ·v n) *v (a ×v n))
    ≡⟨ transverse-symbol n ((w ·v n) *v (a ×v n)) w
         (symbol-stays-transverse n a w) hnn ⟩
      (w ·v n) *v (((w ·v n) *v (a ×v n)) ×v n)
    ≡⟨ cong ((w ·v n) *v_) (cross-scale-left (w ·v n) (a ×v n) n) ⟩
      (w ·v n) *v ((w ·v n) *v ((a ×v n) ×v n))
    ≡⟨ cong (λ z → (w ·v n) *v ((w ·v n) *v z))
            (complex-structure n a han hnn) ⟩
      (w ·v n) *v ((w ·v n) *v (-v a))
    ≡⟨ cong ((w ·v n) *v_) (scale-neg (w ·v n) a) ⟩
      (w ·v n) *v (-v ((w ·v n) *v a))
    ≡⟨ scale-neg (w ·v n) ((w ·v n) *v a) ⟩
      -v ((w ·v n) *v ((w ·v n) *v a))
    ≡⟨ cong -v_ (scale-scale (w ·v n) (w ·v n) a) ⟩
      -v (((w ·v n) · (w ·v n)) *v a) ∎

  ------------------------------------------------------------------
  -- ५ · THE SYMBOL IS ADDITIVE IN THE SOURCE.
  ------------------------------------------------------------------

  symbol-additive : (n a w₁ w₂ : V)
    → symbol n (w₁ +v w₂) a ≡ (symbol n w₁ a) +v (symbol n w₂ a)
  symbol-additive n a w₁ w₂ =
      P n (a ×v (w₁ +v w₂))
    ≡⟨ cong (P n) (cross-add-right a w₁ w₂) ⟩
      P n ((a ×v w₁) +v (a ×v w₂))
    ≡⟨ P-add n (a ×v w₁) (a ×v w₂) ⟩
      (P n (a ×v w₁)) +v (P n (a ×v w₂)) ∎
