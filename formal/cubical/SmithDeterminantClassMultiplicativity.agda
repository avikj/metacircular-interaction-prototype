{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SmithDeterminantClassMultiplicativity
--
-- S11HolonomyDeterminant checks that changing a 2x2 representative by
-- D E, for D = diag(d, q d), changes its determinant by a multiple of d.
-- Here the missing multiplicative step is checked at witness level:
-- congruences multiply, hence determinant classes multiply under matrix
-- composition.  No quotient of matrices or automorphism group is built.
--
-- The d = 5 control is deliberately hostile.  The class 2 has no integral
-- square-root-of-one lift, but 2 * 2 = 4 does have the lift -1 modulo 5.
-- Thus the allowed sign classes are multiplicatively closed, while their
-- complement need not be.  This is not a nontrivial holonomy loop.
------------------------------------------------------------------------

module SmithDeterminantClassMultiplicativity where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Int using (ℤ ; pos)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

import M2Unimodular as M2
import Gamma0Partner as G0
import Swarm.S11HolonomyDeterminant as S11

open CommRingStr (ℤCommRing .snd)

R : Type
R = fst ℤCommRing

------------------------------------------------------------------------
-- 1. Explicit congruence witnesses and their multiplication law.
------------------------------------------------------------------------

Modulo : R → R → R → Type
Modulo d x y = Σ[ t ∈ R ] (x ≡ y + d · t)

modulo-refl : (d x : R) → Modulo d x x
modulo-refl d x = 0r , solve! ℤCommRing

private
  multiply-expansion : (d x y s t : R)
    → (x + d · s) · (y + d · t)
      ≡ x · y + d · (x · t + y · s + d · (s · t))
  multiply-expansion _ _ _ _ _ = solve! ℤCommRing

modulo-mul : (d x y x′ y′ : R)
  → Modulo d x y
  → Modulo d x′ y′
  → Modulo d (x · x′) (y · y′)
modulo-mul d x y x′ y′ (s , px) (t , px′) =
  ( y · t + y′ · s + d · (s · t)
  , cong₂ _·_ px px′ ∙ multiply-expansion d y y′ s t )

-- The representative-change polynomial from S11, packaged in Modulo.
det-shift-class : (d q c11 c12 c21 c22 e11 e12 e21 e22 : R)
  → Modulo d
      ((c11 + d · e11) · (c22 + (q · d) · e22)
        - (c12 + d · e12) · (c21 + (q · d) · e21))
      (c11 · c22 - c12 · c21)
det-shift-class d q c11 c12 c21 c22 e11 e12 e21 e22 =
  ( (e11 · c22 + q · (c11 · e22) + (q · d) · (e11 · e22))
    - (e12 · c21 + q · (c12 · e21) + (q · d) · (e12 · e21))
  , S11.detShift d q c11 c12 c21 c22 e11 e12 e21 e22 )

------------------------------------------------------------------------
-- 2. Determinant classes multiply under matrix composition.
------------------------------------------------------------------------

determinant-product-class :
    (d : R) (H C K B : G0.M)
  → Modulo d (M2.det H) (M2.det C)
  → Modulo d (M2.det K) (M2.det B)
  → Modulo d (M2.det (G0.mul H K)) (M2.det (G0.mul C B))
determinant-product-class d H C K B hHC hKB =
  ( productClass .fst
  , M2.detMul H K
    ∙ productClass .snd
    ∙ cong (λ z → z + d · productClass .fst) (sym (M2.detMul C B)) )
  where
    productClass :
      Modulo d (M2.det H · M2.det K) (M2.det C · M2.det B)
    productClass =
      modulo-mul d (M2.det H) (M2.det C) (M2.det K) (M2.det B) hHC hKB

------------------------------------------------------------------------
-- 3. Sign classes are closed, but their complement need not be.
------------------------------------------------------------------------

SignClass : R → R → Type
SignClass d δ =
  Σ[ ε ∈ R ] Σ[ t ∈ R ]
    ((ε ≡ δ + d · t) × (ε · ε ≡ 1r))

private
  product-square : (x y : R)
    → (x · y) · (x · y) ≡ (x · x) · (y · y)
  product-square _ _ = solve! ℤCommRing

sign-class-mul : (d δ η : R)
  → SignClass d δ
  → SignClass d η
  → SignClass d (δ · η)
sign-class-mul d δ η (ε , s , pε , sqε) (θ , t , pθ , sqθ) =
  ( ε · θ
  , productClass .fst
  , productClass .snd
  , product-square ε θ ∙ cong₂ _·_ sqε sqθ ∙ ·IdR 1r )
  where
    productClass : Modulo d (ε · θ) (δ · η)
    productClass = modulo-mul d ε δ θ η (s , pε) (t , pθ)

-- Existing S11 arithmetic rules out an integral square root of one in the
-- determinant class 2 modulo 5.
five-two-excluded : ¬ SignClass (pos 5) (pos 2)
five-two-excluded (ε , t , pε , sqε) =
  S11.¬5∣3 ∣ (obstruction .fst , obstruction .snd ∙ S11.deltaSq) ∣₁
  where
    obstruction : Σ[ c ∈ R ]
      (c · pos 5 ≡ pos 2 · pos 2 - 1r)
    obstruction = S11.squareObstruction (pos 5) (pos 2) ε t pε sqε

-- Nevertheless 2·2 = 4 is the -1 class modulo 5.
private
  minus-one-square : (- 1r) · (- 1r) ≡ 1r
  minus-one-square = sym (lem 1r)
    where
      lem : (x : R) → x ≡ (- 1r) · (- x)
      lem _ = solve! ℤCommRing

five-two-square-allowed : SignClass (pos 5) (pos 2 · pos 2)
five-two-square-allowed =
  (- 1r) , (- 1r) , solve! ℤCommRing , minus-one-square

-- Literal two-way control: each factor is excluded, while their product is
-- allowed.  The complement of the sign classes is therefore not closed.
excluded-times-excluded-can-be-allowed :
  (¬ SignClass (pos 5) (pos 2))
  × (¬ SignClass (pos 5) (pos 2))
  × SignClass (pos 5) (pos 2 · pos 2)
excluded-times-excluded-can-be-allowed =
  five-two-excluded , five-two-excluded , five-two-square-allowed
