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
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-assoc ; +-comm ; zero≢suc)
open import Cubical.Data.Sigma

Matrix₂ : Type₀
Matrix₂ = Bool → Bool → ℕ

RankOne : Matrix₂ → Type₀
RankOne K = Σ[ x ∈ (Bool → ℕ) ] Σ[ y ∈ (Bool → ℕ) ]
  ((a c : Bool) → K a c ≡ x a + y c)

rankOne-minor : {K : Matrix₂} → RankOne K
  → K false false + K true true ≡ K false true + K true false
rankOne-minor (x , y , factor) =
  factor false false
  ∙ cong₂ _+_ (factor true true) (refl)
  ∙ +-assoc (x false) (y false) (x true + y true)
  ∙ cong (x false +_) (+-comm (y false) (x true))
  ∙ sym (+-assoc (x false) (x true) (y false + y true))
  ∙ cong₂ _+_ (refl) (sym (+-assoc (y false) (x true) (y true)))
  ∙ cong (x false +_)
      (cong (y false +_) (+-comm (x true) (y true)))
  ∙ sym (cong₂ _+_ (factor false true) (factor true false))

checker : Matrix₂
checker false false = zero
checker false true  = zero
checker true false  = zero
checker true true   = suc zero

checker-minor-fails :
  ¬ (checker false false + checker true true
     ≡ checker false true + checker true false)
checker-minor-fails p = zero≢suc (sym p)

checker-not-rank-one : ¬ RankOne checker
checker-not-rank-one h = checker-minor-fails (rankOne-minor h)

-- The checker has a concrete two-mode upper bound: one mode per true cell.
-- The lower-bound term above is the load-bearing fact; no claim is made that
-- two is globally minimal for arbitrary matrices beyond this witness.
