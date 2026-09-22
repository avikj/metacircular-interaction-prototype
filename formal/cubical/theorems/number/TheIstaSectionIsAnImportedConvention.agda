{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module TheIstaSectionIsAnImportedConvention where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos ; _·_ ; _+_ ; -_)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)
open import Kuttaka using (solutionFamily)

------------------------------------------------------------------------
-- TheIstaSectionIsAnImportedConvention
--
-- WHAT IS PROVED
--
-- The ia reduction as an explicitly IMPORTED
-- section: §1 takes that literally: a section is a PARAMETER �
-- any function on the solution index that lands in the family � and §2
-- proves that importing one costs nothing, since the reduced solution
-- still solves the equation.
--
-- The section is a declared convention.  Declared, not derived: the
-- formalisation makes it a parameter and proves the equation is
-- indifferent to it.
--
-- §1's type admits many sections, and that multiplicity is the point: the
-- equation does not pick one.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1.  A section, as an imported convention
--
-- `sec` moves a solution's x-component somewhere in the family: for each
-- `x` there is a shift `t` with `sec x ≡ x + t � b`.  Nothing else is
-- required, and in particular no minimality.
------------------------------------------------------------------------

private
  shiftByZero : (x b : ℤ) → x ≡ x + pos 0 · b
  shiftByZero x b = solve! ℤCommRing

IstaSection : ℤ → Type
IstaSection b =
  Σ[ sec ∈ (ℤ → ℤ) ] ((x : ℤ) → Σ[ t ∈ ℤ ] (sec x ≡ x + t · b))

-- the trivial section: take the solution you were given.  Present so the
-- type is visibly inhabited and §2 is not vacuous.
identitySection : (b : ℤ) → IstaSection b
identitySection b = (λ x → x) , (λ x → pos 0 , shiftByZero x b)

------------------------------------------------------------------------
-- 2.  Importing a section costs nothing: the reduced solution still solves
------------------------------------------------------------------------

sectionPreservesSolving :
  (a b g x₀ y₀ : ℤ) → a · x₀ + b · y₀ ≡ g
  → (S : IstaSection b)
  → Σ[ y ∈ ℤ ] (a · (fst S x₀) + b · y ≡ g)
sectionPreservesSolving a b g x₀ y₀ sol (sec , wit) =
  (y₀ + (- (t · a)))
  , cong (λ z → a · z + b · (y₀ + (- (t · a)))) p
    ∙ solutionFamily a b g x₀ y₀ sol t
  where
  t : ℤ
  t = fst (wit x₀)
  p : sec x₀ ≡ x₀ + t · b
  p = snd (wit x₀)
