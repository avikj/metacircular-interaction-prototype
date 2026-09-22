{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ResidualInvariance
--
-- WHAT `no-invariant-response-sees-ϱ` ACTUALLY PROVES, and what it was
-- named as if it proved.
--

module ResidualInvariance where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; +-zero ; +-suc)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

open import CostGeometry
open import Residual

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
