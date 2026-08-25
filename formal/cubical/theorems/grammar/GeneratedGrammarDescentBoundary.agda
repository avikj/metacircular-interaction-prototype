{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- GeneratedGrammarDescentBoundary
--
-- Two named productions in a declared support table can share a semantic
-- observation while depending on different grammar rules.  Survival after
-- withdrawing a rule therefore need not descend through the observation map.
--
-- This is the smallest named instance of the generated-grammar distinction
-- needed here.  The general finite derivation-hypergraph deletion law is
-- prior mathematics in the repository's prose; weighted minimax selection,
-- shortest-witness DAGs, multiple deletion, and repair are not formalized by
-- this module.
------------------------------------------------------------------------

module GeneratedGrammarDescentBoundary where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; false ; true ; not ; false≢true)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

import FiniteInformation as FI

------------------------------------------------------------------------
-- The sampled two-derivation support table
------------------------------------------------------------------------

data Rule : Type₀ where
  quotient modulus directRule : Rule

data Production : Type₀ where
  sharedDerivation directDerivation : Production

data Observation : Type₀ where
  q3 : Observation

-- Both productions compute the same mod-three observation.
semantic : Production → Observation
semantic sharedDerivation = q3
semantic directDerivation = q3

-- The shared derivation uses the generic quotient and modulus rules; the
-- direct derivation instead uses its dedicated divisibility rule.
uses : Production → Rule → Bool
uses sharedDerivation quotient   = true
uses sharedDerivation modulus    = true
uses sharedDerivation directRule = false
uses directDerivation quotient   = false
uses directDerivation modulus    = false
uses directDerivation directRule = true

survives : Rule → Production → Bool
survives withdrawn production = not (uses production withdrawn)

same-semantic-observation :
  semantic sharedDerivation ≡ semantic directDerivation
same-semantic-observation = refl

-- Withdrawing the shared quotient rule kills the shared derivation while the
-- direct derivation survives, despite their equal semantic observations.
quotient-withdrawal-separates :
  ¬ (survives quotient sharedDerivation
      ≡ survives quotient directDerivation)
quotient-withdrawal-separates = false≢true

semantic-fiber-splits-withdrawal :
  (semantic sharedDerivation ≡ semantic directDerivation)
  × (¬ (survives quotient sharedDerivation
        ≡ survives quotient directDerivation))
semantic-fiber-splits-withdrawal =
  same-semantic-observation , quotient-withdrawal-separates

------------------------------------------------------------------------
-- Exact descent obstruction
------------------------------------------------------------------------

-- A decoder from semantic observations would make withdrawal survival
-- constant on every semantic fibre.  The named pair above refutes that
-- necessary condition through the existing constructive descent theorem.
withdrawal-survival-does-not-descend :
  ¬ FI.FactorsThrough semantic (survives quotient)
withdrawal-survival-does-not-descend factors =
  quotient-withdrawal-separates
    (FI.factorsThrough→fiberConstant
      semantic (survives quotient) factors
      sharedDerivation directDerivation same-semantic-observation)
