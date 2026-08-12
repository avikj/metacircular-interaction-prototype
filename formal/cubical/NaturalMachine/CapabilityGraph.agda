{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.CapabilityGraph where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Nat
open import Cubical.Data.Fin using (Fin)

open import NaturalMachine.SymmetryCardinality
open import NaturalMachine.SymmetryArithmeticAction
open import NaturalMachine.SmithCapability

-- The checked symmetry graph forks from the carrier.  Cardinality is a lossy
-- projection of that carrier; there is intentionally no count-to-action edge.
record SymmetryCapability (n : ℕ) : Type₁ where
  field
    symmetry : Fin n ≣ Fin n

  count-certificate : symmetryCount n ≡ n !
  count-certificate = symmetryCount≡factorial n

  act : (Fin n → ℕ) → Fin n → ℕ
  act = permuteRegisters symmetry

  response : (Fin n → ℕ) → Fin n → ℕ
  response = fixedPortRead symmetry

  in-stabilizer : (observation : Fin n → ℕ) → Type₀
  in-stabilizer observation = Stabilizes observation symmetry

-- A carrier element supplies the whole checked fork without reconstructing a
-- permutation from the factorial count.
symmetryPipeline : (n : ℕ) → (Fin n ≣ Fin n) → SymmetryCapability n
SymmetryCapability.symmetry (symmetryPipeline n e) = e

-- The open joint is named only by its required interface.  The present
-- repository has equality of response functions but no installed quotient
-- carrier satisfying this exact classification law.
record ObservationalClassCompiler (n : ℕ)
                                  (observation : Fin n → ℕ) : Type₁ where
  field
    Class : Type₀
    classOf : (Fin n ≣ Fin n) → Class
    complete : (e f : Fin n ≣ Fin n)
             → (classOf e ≡ classOf f) ≣ (e ≈[ observation ] f)

-- Smith is already a closed native producer/consumer joint: the dependent
-- eliminator prevents a consumer from receiving a normal matrix without its
-- replay, invertibility, and normality witnesses.
smithPipeline = withSmith
