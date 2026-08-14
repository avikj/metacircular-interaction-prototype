{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.CapabilityGraph where

open import Agda.Primitive using (_⊔_)
open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (Iso)
open import Cubical.Data.Nat
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Bool using (Bool)

open import NaturalMachine.SymmetryCardinality
open import NaturalMachine.SymmetryArithmeticAction
open import NaturalMachine.SmithCapability
import NaturalMachine.AdaptiveResidualAdapter as Adaptive
import NaturalMachine.FutureBehavior as Future

-- The checked symmetry graph forks from the carrier.  Cardinality is a lossy
-- projection of that carrier; there is intentionally no count-to-action edge.
record SymmetryCapability (n : ℕ) : Type₁ where
  field
    symmetry : Fin n ≃ Fin n

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
symmetryPipeline : (n : ℕ) → (Fin n ≃ Fin n) → SymmetryCapability n
SymmetryCapability.symmetry (symmetryPipeline n e) = e

-- The open joint is named only by its required interface.  The present
-- repository has equality of response functions but no installed quotient
-- carrier satisfying this exact classification law.
record ObservationalClassCompiler (n : ℕ)
                                  (observation : Fin n → ℕ) : Type₁ where
  field
    Class : Type₀
    classOf : (Fin n ≃ Fin n) → Class
    complete : (e f : Fin n ≃ Fin n)
             → (classOf e ≡ classOf f) ≃ (e ≈[ observation ] f)

-- Smith offers a bundled consumer interface: a consumer that goes through
-- `withSmith` receives the normal matrix together with its replay,
-- invertibility, and normality witnesses in one call.  Nothing is *prevented*:
-- SmithCapability also exports the unbundled projections (`normalMatrix`,
-- `leftTransform`, `rightTransform`), so a consumer can take the normal matrix
-- witness-free.  The bundling is an offered convention, not an enforced
-- abstraction boundary.
smithPipeline = withSmith

-- Adaptive experiments are a capability edge, not a new quotient.  The
-- bridge is explicit: every finite response-conditioned tree and every
-- ordinary action word induce the same residual equality.  Costs (tree
-- depth, parallel horizon, and construction work) are deliberately absent
-- from this carrier; they are separate interfaces.
record AdaptiveResidualCapability {ℓX ℓA : Level}
                                  (X : Type ℓX) (A : Type ℓA) : Type (ℓX ⊔ ℓA) where
  field
    step : X → A → X
    observe : X → Bool
    residualBridge : (left right : X)
      → Iso (Future.FutureEq step observe left right)
              (Adaptive.AdaptiveEq step observe left right)

adaptiveResidualPipeline :
    {ℓX ℓA : Level} {X : Type ℓX} {A : Type ℓA}
    (step : X → A → X) (observe : X → Bool)
  → AdaptiveResidualCapability X A
AdaptiveResidualCapability.step (adaptiveResidualPipeline step observe) = step
AdaptiveResidualCapability.observe (adaptiveResidualPipeline step observe) = observe
AdaptiveResidualCapability.residualBridge
  (adaptiveResidualPipeline step observe) =
  Adaptive.futureEq-adaptiveIso step observe
