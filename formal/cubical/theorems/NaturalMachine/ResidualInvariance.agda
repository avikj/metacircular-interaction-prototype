{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ResidualInvariance
--
-- WHAT `no-invariant-response-sees-ϱ` ACTUALLY PROVES, and what it was
-- named as if it proved.
--
-- `Residual.no-invariant-response-sees-ϱ : ¬ Invariant respondB` is about
-- ONE response.  Its name says "no invariant response sees ϱ", which is a
-- statement about all of them, and a breaker audit (2026-08-15,
-- notes/BREAKER_R0079_R0081.md) pointed out that the universal reading is
-- FALSE as stated: a constant response factors through ϱ and is
-- `Invariant`, so "no invariant response reads the residual" cannot be
-- right.  What is true, and what the name was reaching for, is that an
-- invariant response reading ϱ can only read it CONSTANTLY -- it may look,
-- and it may not distinguish.
--
-- That statement is four lines and is proved below.  `Residual`'s theorem
-- then comes back as the instance g = branchOf, which is not constant.
-- The counterexample family is due to the audit; it is reproduced here so
-- the sharp statement lives in the checked corpus rather than in a note.
------------------------------------------------------------------------

module NaturalMachine.ResidualInvariance where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-zero ; +-suc)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.CostGeometry
open import NaturalMachine.Residual

-- ϱ cancels the detour it is measured against.
⊖-cancel : (m n : ℕ) → (m + n) ⊖ n ≡ m
⊖-cancel m zero = +-zero m
⊖-cancel m (suc n) = cong (_⊖ suc n) (+-suc m n) ∙ ⊖-cancel m n

-- Every response that reads only the residual, in the only way there is
-- to read a number: through some function of it.
read : (ℕ → Branch) → {A B : Presentation} → Bridge A B → Work → Work → Branch
read g b wHere wThere = g (ϱ b wHere wThere)

-- THE SHARP STATEMENT.  Invariance does not forbid reading ϱ; it forbids
-- reading it to any effect.  Two bridges with the same maps and different
-- weights realise ANY pair of residuals, so an invariant reader must give
-- them the same answer -- i.e. it is constant.
invariant-read-is-constant :
    (g : ℕ → Branch) → Invariant (read g) → (m n : ℕ) → g m ≡ g n
invariant-read-is-constant g inv m n =
    sym (cong g lhs)
  ∙ inv {A = U} {B = U}
        (edge (λ x → x) 0) (edge (λ x → x) 0)
        (edge (λ x → x) n) (edge (λ x → x) m)
        refl refl (m + n) 0
  ∙ cong g rhs
  where
    U : Presentation
    U = pres Unit (λ _ _ → tt)

    lhs : (m + n) ⊖ ((0 + 0) + (n + 0)) ≡ m
    lhs = cong (λ z → (m + n) ⊖ z) (+-zero n) ∙ ⊖-cancel m n

    rhs : (m + n) ⊖ ((0 + 0) + (m + 0)) ≡ n
    rhs = cong (λ z → (m + n) ⊖ z) (+-zero m)
        ∙ cong (_⊖ m) (+-comm m n)
        ∙ ⊖-cancel n m
      where
        +-comm : (a b : ℕ) → a + b ≡ b + a
        +-comm zero b = sym (+-zero b)
        +-comm (suc a) b = cong suc (+-comm a b) ∙ sym (+-suc b a)

-- and the branch reader is not constant, which is Residual's theorem.
branchOf-nonconstant : ¬ (branchOf 0 ≡ branchOf 1)
branchOf-nonconstant p = subst is↻ p tt

recover : ¬ Invariant respondB
recover inv = branchOf-nonconstant (invariant-read-is-constant branchOf inv 0 1)

-- CHECKED: Agda 2.6.3, cubical v0.7 (/tmp/cubical, with the 2.6.3
-- back-port of Cubical.Tactics.Reflection recorded in
-- notes/CUBICAL_PATCH.md), --cubical --safe, 2026-08-15.  No postulates,
-- no holes.  NOT verified against the pin (Agda 2.8.0, cubical v0.9).
