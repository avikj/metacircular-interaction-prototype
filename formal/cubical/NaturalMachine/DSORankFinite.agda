{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.DSORankFinite
--
-- A finite rank lower-bound seam for Delta 27.  A rank-one min-plus factor
-- has vanishing additive 2x2 minors.  One violating minor is therefore an
-- exact certificate that a one-state dependency interface is impossible.
------------------------------------------------------------------------

module NaturalMachine.DSORankFinite where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; false ; true)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; znots ; +-assoc ; +-comm)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

Matrix₂ : Type₀
Matrix₂ = Bool → Bool → ℕ

RankOne : Matrix₂ → Type₀
RankOne K = Σ[ x ∈ (Bool → ℕ) ] Σ[ y ∈ (Bool → ℕ) ]
  ((a c : Bool) → K a c ≡ x a + y c)

four-swap : (a b c d : ℕ)
  → (a + b) + (c + d) ≡ (a + c) + (b + d)
four-swap a b c d =
  +-assoc a b (c + d)
  ∙ cong (a +_) (sym (+-assoc b c d))
  ∙ cong (a +_) (cong (_+ d) (+-comm b c))
  ∙ sym (+-assoc a (c + b) d)
  ∙ cong (_+ d) (sym (+-assoc a c b))
  ∙ +-assoc a c (b + d)

rankOne-minor : {K : Matrix₂} → RankOne K
  → K false false + K true true ≡ K false true + K true false
rankOne-minor (x , y , factor) =
  cong₂ _+_ (factor false false) (factor true true)
  ∙ four-swap (x false) (y false) (x true) (y true)
  ∙ sym (cong₂ _+_ (factor false true) (factor true false))

checker : Matrix₂
checker false false = zero
checker false true  = zero
checker true false  = zero
checker true true   = suc zero

checker-minor-fails :
  ¬ (checker false false + checker true true
     ≡ checker false true + checker true false)
checker-minor-fails p = znots (sym p)

checker-not-rank-one : ¬ RankOne checker
checker-not-rank-one h = checker-minor-fails (rankOne-minor h)

-- The checker has a concrete two-mode upper bound: one mode per true cell.
-- The lower-bound term above is the load-bearing fact; no claim is made that
-- two is globally minimal for arbitrary matrices beyond this witness.
