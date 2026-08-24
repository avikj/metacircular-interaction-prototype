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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.ProofLabelNoGo where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬_)

-- A validation boundary must recover which claim its accepted certificate
-- certifies. If two distinct claims receive the same emitted label, no such
-- round trip exists. This is the exact obstruction for MathMachine's current
-- `Maybe String`: the string records only the induction variable, not a
-- derivation whose conclusion contains the candidate equation.
module _ {Claim Label : Type₀} (emit : Claim → Label) where

  FaithfulValidator : Type₀
  FaithfulValidator = Σ[ validate ∈ (Label → Claim) ]
    ((claim : Claim) → validate (emit claim) ≡ claim)

  collision-blocks-faithful-validation :
    (c₁ c₂ : Claim) → emit c₁ ≡ emit c₂ → ¬ (c₁ ≡ c₂)
    → ¬ FaithfulValidator
  collision-blocks-faithful-validation c₁ c₂ same distinct
    (validate , roundtrip) =
      distinct
        (sym (roundtrip c₁)
        ∙ cong validate same
        ∙ roundtrip c₂)
