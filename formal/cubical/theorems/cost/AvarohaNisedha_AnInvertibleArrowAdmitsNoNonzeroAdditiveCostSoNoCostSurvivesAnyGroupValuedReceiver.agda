{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अवरोह-निषेध — the descent refused.
--
-- THE CLAIM, in the language of the moduli conversation (2026-09-03):
-- every layer of the motivic tower above the implementation stack
-- demands invertibility somewhere — a groupoid completion, a Morita
-- localization, a stabilization.  Cost is additive along composition
-- and valued in ℕ.  These two demands cannot meet: an arrow that has
-- become invertible in ANY receiver of an additive ℕ-valued cost has
-- cost zero there, so the cost functional that was faithful upstream
-- is killed by the very passage the semantic column requires.  The
-- implementation fiber must therefore remain attached beside the
-- motive — not as a design preference but as arithmetic.
--
--   §1  An element with an inverse admits no nonzero additive cost:
--       h g + h g⁻¹ = h 0 = 0 in ℕ forces h g = 0.  (In ℕ a sum is
--       zero only when both summands are; there is the whole proof.)
--
--   §2  The receipt, stated as the impossibility it is: there is NO
--       triple (a receiver G, a hom ι : ℕ → G, a hom h : G → ℕ) with
--       ι 1 invertible and h ∘ ι ≡ id.  For then 1 = h (ι 1) = 0.
--       Group completion is one such receiver; so is every other.
--
-- Nothing here mentions categories: the one-object case carries the
-- whole obstruction, and transport to a graded category is precomposition
-- with "read off the grade".  Cf. Laghava (cost and inverse cannot
-- coexist), of which this is the receiver-side form: not merely that
-- a graded arrow has no inverse, but that the completion which FORCES
-- the inverse refunds every cost to zero, with the refund computed.
--
-- SYĀT — THE CLAIM, EXACTLY.  §1 and §2 for additive costs valued in
-- (ℕ, +, 0), over any magma-with-zero receiver; monoid laws are not
-- even needed, so nothing weaker than stated is being assumed.
------------------------------------------------------------------------

module AvarohaNisedha_AnInvertibleArrowAdmitsNoNonzeroAdditiveCostSoNoCostSurvivesAnyGroupValuedReceiver where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; snotz)
open import Cubical.Data.Sigma using (Σ ; _,_)
open import Cubical.Data.Empty as Empty using (⊥)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- ० · In ℕ a vanishing sum has vanishing summands.
------------------------------------------------------------------------

sum≡0→left≡0 : (m n : ℕ) → m + n ≡ 0 → m ≡ 0
sum≡0→left≡0 zero    n p = refl
sum≡0→left≡0 (suc m) n p = Empty.rec (snotz p)

------------------------------------------------------------------------
-- १ · An invertible element admits no nonzero additive cost.
--
-- G is any type with an operation and a zero; h is additive and sends
-- the zero to zero.  No associativity, no commutativity, no laws on G
-- at all: the obstruction is cheaper than the structures it blocks.
------------------------------------------------------------------------

module _ (G : Type ℓ) (_⊕_ : G → G → G) (0g : G)
         (h : G → ℕ)
         (h-add : (x y : G) → h (x ⊕ y) ≡ h x + h y)
         (h-zero : h 0g ≡ 0) where

  costOfInvertible≡0 : (g g' : G) → g ⊕ g' ≡ 0g → h g ≡ 0
  costOfInvertible≡0 g g' inv =
    sum≡0→left≡0 (h g) (h g')
      (sym (h-add g g') ∙ cong h inv ∙ h-zero)

------------------------------------------------------------------------
-- २ · Therefore no additive ℕ-cost factors through any receiver that
--     inverts the generator.  The unit cost of one step upstream is 1;
--     any factorization computes it to 0; suc ≢ zero closes the door.
------------------------------------------------------------------------

-- A receiver through which the cost of steps would descend: a carrier,
-- an interpretation of step-counts, a read-back, additivity of the
-- read-back, an inverse for the image of the single step, and the
-- factorization h ∘ ι ≡ id on the generator 1.
Receiver : Type (ℓ-suc ℓ-zero)
Receiver =
  Σ (Type ℓ-zero) λ G →
  Σ (G → G → G)   λ _⊕_ →
  Σ G             λ 0g →
  Σ (ℕ → G)       λ ι →
  Σ (G → ℕ)       λ h →
  Σ ((x y : G) → h (x ⊕ y) ≡ h x + h y) λ _ →
  Σ (h 0g ≡ 0)    λ _ →
  Σ G             λ inv1 →
  Σ (ι 1 ⊕ inv1 ≡ 0g) λ _ →
  h (ι 1) ≡ 1

noCostSurvives : Receiver → ⊥
noCostSurvives (G , _⊕_ , 0g , ι , h , h-add , h-zero , inv1 , isInv , reads1) =
  snotz (sym reads1 ∙ costOfInvertible≡0 G _⊕_ 0g h h-add h-zero (ι 1) inv1 isInv)
