{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module ProofLabelNoGo where

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
