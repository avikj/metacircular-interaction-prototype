{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.DependentOptimizationFibration where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; snotz)
open import Cubical.Data.Bool using (Bool ; false)
open import Cubical.Data.Sigma
open import Cubical.Data.List using ([] ; _∷_)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.FiniteIndraWeave using (TotalView ; Tear ; tear)
open import NaturalMachine.ProductiveIndraNet using (Net ; observe)

data Architecture : Type₀ where
  left-architecture right-architecture : Architecture

data Realization : Architecture → Type₀ where
  left-realization : Realization left-architecture
  right-realization : Realization right-architecture

Configuration : Type₀
Configuration = Σ Architecture Realization

left-configuration right-configuration : Configuration
left-configuration = left-architecture , left-realization
right-configuration = right-architecture , right-realization

semantics : Configuration → Bool
semantics _ = false

SemanticFiber : Bool → Type₀
SemanticFiber output = Σ[ configuration ∈ Configuration ]
  semantics configuration ≡ output

left-point right-point : SemanticFiber false
left-point = left-configuration , refl
right-point = right-configuration , refl

architectureOf : SemanticFiber false → Architecture
architectureOf point = point .fst .fst

cost : Architecture → SemanticFiber false → ℕ
cost left-architecture point with architectureOf point
... | left-architecture = 0
... | right-architecture = 1
cost right-architecture point with architectureOf point
... | left-architecture = 1
... | right-architecture = 0

OptimalAt : Architecture → SemanticFiber false → Type₀
OptimalAt root point = cost root point ≡ 0

LocalOptimizer : Architecture → Type₀
LocalOptimizer root = Σ[ point ∈ SemanticFiber false ] OptimalAt root point

left-optimizer : LocalOptimizer left-architecture
left-optimizer = left-point , refl

right-optimizer : LocalOptimizer right-architecture
right-optimizer = right-point , refl

optimizer : (root : Architecture) → LocalOptimizer root
optimizer left-architecture = left-optimizer
optimizer right-architecture = right-optimizer

left-optimal-architecture : (choice : LocalOptimizer left-architecture)
  → architectureOf (choice .fst) ≡ left-architecture
left-optimal-architecture (((left-architecture , left-realization) , proof) , optimal) = refl
left-optimal-architecture (((right-architecture , right-realization) , proof) , optimal) =
  Empty.rec (snotz optimal)

right-optimal-architecture : (choice : LocalOptimizer right-architecture)
  → architectureOf (choice .fst) ≡ right-architecture
right-optimal-architecture (((left-architecture , left-realization) , proof) , optimal) =
  Empty.rec (snotz optimal)
right-optimal-architecture (((right-architecture , right-realization) , proof) , optimal) = refl

left≠right : ¬ (left-architecture ≡ right-architecture)
left≠right ()

-- Local optimizer sections glue only if their selected semantic-fiber
-- points agree.  The two zero-cost sections cannot satisfy that overlap.
CoherentGlobalOptimizer : Type₀
CoherentGlobalOptimizer =
  Σ[ choices ∈ ((root : Architecture) → LocalOptimizer root) ]
    (choices left-architecture .fst ≡ choices right-architecture .fst)

no-coherent-global-optimizer : ¬ CoherentGlobalOptimizer
no-coherent-global-optimizer (choices , coherent) =
  left≠right
    (sym (left-optimal-architecture (choices left-architecture))
      ∙ cong architectureOf coherent
      ∙ right-optimal-architecture (choices right-architecture))

------------------------------------------------------------------------
-- The optimizer section is itself the rooted productive view.  Its gluing
-- obstruction is therefore an executable tear at every future depth.
------------------------------------------------------------------------

optimizerView : TotalView Architecture Configuration
optimizerView root target = optimizer root .fst .fst

left≠right-configuration : ¬ (left-configuration ≡ right-configuration)
left≠right-configuration equality = left≠right (cong fst equality)

optimizer-tear : Tear left-architecture optimizerView
optimizer-tear =
  tear right-architecture left-architecture left≠right-configuration

optimizerNet : Net Architecture Configuration
Net.view optimizerNet = optimizerView
Net.next optimizerNet = optimizerNet

optimizer-two : observe 2 optimizerNet ≡ optimizerView ∷ optimizerView ∷ []
optimizer-two = refl

left-view-optimal : cost left-architecture
  (left-point) ≡ 0
left-view-optimal = refl

right-view-optimal : cost right-architecture
  (right-point) ≡ 0
right-view-optimal = refl

iterate : ℕ → Net Architecture Configuration
  → Net Architecture Configuration
iterate zero net = net
iterate (suc n) net = iterate n (Net.next net)

tear-persists : (depth : ℕ)
  → Tear left-architecture (Net.view (iterate depth optimizerNet))
tear-persists zero = optimizer-tear
tear-persists (suc depth) = tear-persists depth
