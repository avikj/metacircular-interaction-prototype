-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- A finite semantic-width obstruction extracted from random batch-02 anchor
-- #4 (the coordination-graph delta).  The source discusses information cuts;
-- this module records the exact min-plus analogue: one latent mode forces a
-- rectangular/additive minor identity.  No information-theoretic or tropical
-- rank claim is imported here.
module NaturalMachine.DSOFactorRankFinite where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; false ; true)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Properties using (+-comm ; +-assoc)

-- The crossed finite cost matrix: diagonal entries are cheap, off-diagonal
-- entries carry one unit of boundary cost.
crossed : Bool → Bool → ℕ
crossed false false = zero
crossed false true  = suc zero
crossed true false  = suc zero
crossed true true    = zero

-- A single latent dependency mode is a separable min-plus matrix x+y.
RankOne : (Bool → ℕ) → (Bool → ℕ) → Type₀
RankOne x y = (a c : Bool) → crossed a c ≡ x a + y c

-- Every rank-one matrix obeys the additive 2x2 minor identity.  This is the
-- exact finite theorem used as a semantic-width lower-bound seam.
rearrange : (a b c d : ℕ) →
  (a + b) + (c + d) ≡ (a + c) + (b + d)
rearrange a b c d =
  sym (+-assoc a b (c + d))
  ∙ cong (λ q → a + q) (+-assoc b c d)
  ∙ cong (λ q → a + (q + d)) (+-comm b c)
  ∙ +-assoc a (c + b) d
  ∙ cong (λ q → q + d) (+-assoc a c b)
  ∙ sym (+-assoc (a + c) b d)

additive-minor : (x y : Bool → ℕ) → RankOne x y →
  crossed false false + crossed true true ≡
  crossed false true + crossed true false
additive-minor x y r =
  cong₂ _+_ (r false false) (r true true)
  ∙ cong (λ q → (x false + y false) + q) (+-comm (x true) (y true))
  ∙ rearrange (x false) (y false) (y true) (x true)
  ∙ cong (λ q → (x false + y true) + q) (+-comm (y false) (x true))
  ∙ sym (cong₂ _+_ (r false true) (r true false))

-- The crossed matrix violates the identity, hence it cannot pass through a
-- one-state exact interface.  The conclusion is intentionally stated only
-- as non-factorability through one separable mode.
crossed-not-rank-one :
  (x y : Bool → ℕ) → RankOne x y → suc (suc zero) ≡ zero
crossed-not-rank-one x y r =
  sym (additive-minor x y r) ∙ refl
