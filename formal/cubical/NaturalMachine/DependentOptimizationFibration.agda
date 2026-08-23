{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module NaturalMachine.DependentOptimizationFibration where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; snotz ; znots)
open import Cubical.Data.Nat.Order using (_≤_ ; zero-≤ ; ≤0→≡0)
open import Cubical.Data.Bool using (Bool ; false ; true ; false≢true)
open import Cubical.Data.Sigma
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.FiniteIndraWeave using (TotalView ; Tear ; tear)
open import NaturalMachine.ProductiveIndraNet using (Net ; observe)
import NaturalMachine.DSOContinuationFullAbstract as Bellman

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
left≠right equality = false≢true (cong tag equality)
  where
  tag : Architecture → Bool
  tag left-architecture = false
  tag right-architecture = true

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

------------------------------------------------------------------------
-- Repair: retain the incompatible local optima as a dependent cover.
-- Coherence is required only after projection to their common semantics.
------------------------------------------------------------------------

OptimizerCover : Type₀
OptimizerCover = (root : Architecture) → LocalOptimizer root

repairedCover : OptimizerCover
repairedCover = optimizer

selectedPoint : OptimizerCover → Architecture → SemanticFiber false
selectedPoint cover root = cover root .fst

cover-projects-to-common-semantics : (root : Architecture)
  → semantics (selectedPoint repairedCover root .fst) ≡ false
cover-projects-to-common-semantics root = selectedPoint repairedCover root .snd

cover-preserves-root-distinction :
  ¬ (selectedPoint repairedCover left-architecture .fst
      ≡ selectedPoint repairedCover right-architecture .fst)
cover-preserves-root-distinction = left≠right-configuration

CoveredPoint : Type₀
CoveredPoint = Σ[ root ∈ Architecture ] LocalOptimizer root

data RepairJewel : Type₀ where
  raw : Configuration → RepairJewel
  covered : CoveredPoint → RepairJewel

repairSemantics : RepairJewel → Bool
repairSemantics (raw configuration) = semantics configuration
repairSemantics (covered (root , choice)) = semantics (choice .fst .fst)

repairRoot : RepairJewel → Architecture
repairRoot (raw configuration) = configuration .fst
repairRoot (covered (root , choice)) = root

tearView : TotalView Architecture RepairJewel
tearView root target = raw (optimizer root .fst .fst)

coverView : TotalView Architecture RepairJewel
coverView root target = covered (root , repairedCover root)

tear-stage : Tear left-architecture tearView
tear-stage = tear right-architecture left-architecture refute
  where
  refute : ¬ (tearView left-architecture left-architecture
              ≡ tearView right-architecture left-architecture)
  refute equality = left≠right (cong repairRoot equality)

cover-semantically-coherent : (left right target : Architecture)
  → repairSemantics (coverView left target)
    ≡ repairSemantics (coverView right target)
cover-semantically-coherent left right target = refl

cover-still-distinguishes-roots : (target : Architecture)
  → ¬ (coverView left-architecture target
          ≡ coverView right-architecture target)
cover-still-distinguishes-roots target equality =
  left≠right (cong repairRoot equality)

mutual
  repairNet : Net Architecture RepairJewel
  Net.view repairNet = tearView
  Net.next repairNet = repairedNet

  repairedNet : Net Architecture RepairJewel
  Net.view repairedNet = coverView
  Net.next repairedNet = repairedNet

repair-three : observe 3 repairNet ≡
  tearView ∷ coverView ∷ coverView ∷ []
repair-three = refl

repair-next-is-covered : Net.view (Net.next repairNet) ≡ coverView
repair-next-is-covered = refl

repair-next-semantics : (left right target : Architecture)
  → repairSemantics (Net.view (Net.next repairNet) left target)
    ≡ repairSemantics (Net.view (Net.next repairNet) right target)
repair-next-semantics = cover-semantically-coherent

------------------------------------------------------------------------
-- Contextual pruning.  A covered point may be erased only when one other
-- point dominates it at every root after every finite continuation.
------------------------------------------------------------------------

record ContextualSystem
    (Root Point Action : Type₀) : Type₁ where
  field
    advance : Action → Point → Point
    immediate : Root → Point → ℕ

open ContextualSystem

runActions : {Root Point Action : Type₀}
  → ContextualSystem Root Point Action
  → List Action → Point → Point
runActions system [] point = point
runActions system (action ∷ future) point =
  runActions system future (advance system action point)

futureCost : {Root Point Action : Type₀}
  → ContextualSystem Root Point Action
  → Root → Point → List Action → ℕ
futureCost system root point future =
  immediate system root (runActions system future point)

ContextuallyDominates : {Root Point Action : Type₀}
  → ContextualSystem Root Point Action → Point → Point → Type₀
ContextuallyDominates {Root} {Action = Action} system retained removed =
  (root : Root) (future : List Action)
  → futureCost system root retained future
    ≤ futureCost system root removed future

PruningWarrant : {Root Point Action : Type₀}
  → ContextualSystem Root Point Action → Point → Point → Type₀
PruningWarrant = ContextuallyDominates

identityContext : ContextualSystem Architecture (SemanticFiber false) Unit
advance identityContext tt point = point
immediate identityContext = cost

left-local-dominance : (future : List Unit)
  → futureCost identityContext left-architecture left-point future
    ≤ futureCost identityContext left-architecture right-point future
left-local-dominance [] = zero-≤
left-local-dominance (tt ∷ future) = left-local-dominance future

one-not≤zero : ¬ (suc zero ≤ zero)
one-not≤zero bounded = snotz (≤0→≡0 bounded)

left-not-contextually-dominant :
  ¬ ContextuallyDominates identityContext left-point right-point
left-not-contextually-dominant warrant =
  one-not≤zero (warrant right-architecture [])

right-not-contextually-dominant :
  ¬ ContextuallyDominates identityContext right-point left-point
right-not-contextually-dominant warrant =
  one-not≤zero (warrant left-architecture [])

-- The full Bellman continuation theorem is consumed rather than reproved:
-- contextual equality at every continuation and root recovers the relation.
bellman-context-complete : (K L : Bellman.Relation)
  → ((V : Bellman.Continuation) (root : Bool)
      → Bellman.bellman K V root ≡ Bellman.bellman L V root)
  → K ≡ L
bellman-context-complete = Bellman.transformer-full-abstraction

coveredCostView prunedCostView : TotalView Architecture ℕ
coveredCostView root target = cost root (selectedPoint repairedCover root)
prunedCostView root target = cost root left-point

covered-cost-coherent : (left right target : Architecture)
  → coveredCostView left target ≡ coveredCostView right target
covered-cost-coherent left-architecture left-architecture target = refl
covered-cost-coherent left-architecture right-architecture target = refl
covered-cost-coherent right-architecture left-architecture target = refl
covered-cost-coherent right-architecture right-architecture target = refl

local-pruning-tear : Tear left-architecture prunedCostView
local-pruning-tear = tear right-architecture left-architecture znots

mutual
  pruningNet : Net Architecture ℕ
  Net.view pruningNet = coveredCostView
  Net.next pruningNet = locallyPrunedNet

  locallyPrunedNet : Net Architecture ℕ
  Net.view locallyPrunedNet = prunedCostView
  Net.next locallyPrunedNet = locallyPrunedNet

pruning-two : observe 2 pruningNet ≡
  coveredCostView ∷ prunedCostView ∷ []
pruning-two = refl

pruning-next-tears : Tear left-architecture (Net.view (Net.next pruningNet))
pruning-next-tears = local-pruning-tear
