{-# OPTIONS --cubical --safe #-}

-- The three components of AssemblyGrading really are multiplicative
-- characters of word concatenation.  Their product controls determinant but
-- is not faithful to matrix execution: the quotient carried by a pulverizer
-- letter is invisible to all three components.

module AssemblyCharacterNonfaithfulness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using ([] ; _∷_ ; _++_)
open import Cubical.Data.Sigma using (_×_ ; Σ-syntax ; _,_ ; fst)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Relation.Nullary using (¬_)

open import Gamma0Partner using (R ; M)
import M2Unimodular as M2
import AssemblyGrading as AG

open CommRingStr (ℤCommRing .snd)
open AG using
  (Step ; Word ; pulv ; scal ; heck ; run ; eps ; cont ; prim ; assemblyGrading)

------------------------------------------------------------------------
-- The componentwise grading and its append law
------------------------------------------------------------------------

Grade : Type
Grade = R × R × R

_gradeMul_ : Grade → Grade → Grade
(e , c , n) gradeMul (e′ , c′ , n′) = e · e′ , c · c′ , n · n′

gradeUnit : Grade
gradeUnit = 1r , 1r , 1r

grade : Word → Grade
grade word = eps word , cont word , prim word

eps-++ : (left right : Word)
  → eps (left ++ right) ≡ eps left · eps right
eps-++ [] right = sym (·IdL (eps right))
eps-++ (pulv q ∷ left) right =
  cong ((- 1r) ·_) (eps-++ left right)
  ∙ ·Assoc (- 1r) (eps left) (eps right)
eps-++ (scal c ∷ left) right = eps-++ left right
eps-++ (heck n ∷ left) right = eps-++ left right

cont-++ : (left right : Word)
  → cont (left ++ right) ≡ cont left · cont right
cont-++ [] right = sym (·IdL (cont right))
cont-++ (pulv q ∷ left) right = cont-++ left right
cont-++ (scal c ∷ left) right =
  cong (c ·_) (cont-++ left right)
  ∙ ·Assoc c (cont left) (cont right)
cont-++ (heck n ∷ left) right = cont-++ left right

prim-++ : (left right : Word)
  → prim (left ++ right) ≡ prim left · prim right
prim-++ [] right = sym (·IdL (prim right))
prim-++ (pulv q ∷ left) right = prim-++ left right
prim-++ (scal c ∷ left) right = prim-++ left right
prim-++ (heck n ∷ left) right =
  cong (n ·_) (prim-++ left right)
  ∙ ·Assoc n (prim left) (prim right)

grade-empty : grade [] ≡ gradeUnit
grade-empty = refl

grade-++ : (left right : Word)
  → grade (left ++ right) ≡ grade left gradeMul grade right
grade-++ left right i =
  eps-++ left right i , cont-++ left right i , prim-++ left right i

------------------------------------------------------------------------
-- Each generator occupies its declared component
------------------------------------------------------------------------

grade-pulv : (q : R) → grade (pulv q ∷ []) ≡ ((- 1r) , 1r , 1r)
grade-pulv q i = ·IdR (- 1r) i , 1r , 1r

grade-scal : (c : R) → grade (scal c ∷ []) ≡ (1r , c , 1r)
grade-scal c i = 1r , ·IdR c i , 1r

grade-heck : (n : R) → grade (heck n ∷ []) ≡ (1r , 1r , n)
grade-heck n i = 1r , 1r , ·IdR n i

------------------------------------------------------------------------
-- The determinant factors through Grade, but execution does not
------------------------------------------------------------------------

gradeWeight : Grade → R
gradeWeight (e , c , n) = e · ((c · c) · n)

det-via-grade : (word : Word)
  → M2.det (run word) ≡ gradeWeight (grade word)
det-via-grade word = assemblyGrading word .fst

pulv0 pulv1 : Word
pulv0 = pulv 0r ∷ []
pulv1 = pulv 1r ∷ []

pulv-grade-collision : grade pulv0 ≡ grade pulv1
pulv-grade-collision = grade-pulv 0r ∙ sym (grade-pulv 1r)

pulv-determinant-collision : M2.det (run pulv0) ≡ M2.det (run pulv1)
pulv-determinant-collision =
  det-via-grade pulv0
  ∙ cong gradeWeight pulv-grade-collision
  ∙ sym (det-via-grade pulv1)

topLeft : M → R
topLeft = fst

topLeft-pulv-singleton : (q : R)
  → topLeft (run (pulv q ∷ [])) ≡ q
topLeft-pulv-singleton q =
  cong₂ _+_ (·IdR q) (·Comm 1r 0r)

pulv-run-distinct : ¬ (run pulv0 ≡ run pulv1)
pulv-run-distinct equal =
  M2.oneNotZero
    ( sym (topLeft-pulv-singleton 1r)
    ∙ cong topLeft (sym equal)
    ∙ topLeft-pulv-singleton 0r )

same-grade-different-execution :
  (grade pulv0 ≡ grade pulv1)
  × (M2.det (run pulv0) ≡ M2.det (run pulv1))
  × (¬ (run pulv0 ≡ run pulv1))
same-grade-different-execution =
  pulv-grade-collision , pulv-determinant-collision , pulv-run-distinct

-- No consumer of the three-character grade can reconstruct all evaluated
-- matrices.  Such a decoder would identify the two executions above.
no-grade-decoder :
  ¬ (Σ[ decode ∈ (Grade → M) ]
       ((word : Word) → decode (grade word) ≡ run word))
no-grade-decoder (decode , replays) =
  pulv-run-distinct
    ( sym (replays pulv0)
    ∙ cong decode pulv-grade-collision
    ∙ replays pulv1 )
