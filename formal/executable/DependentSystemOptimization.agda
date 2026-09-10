{-# OPTIONS --safe #-}

module DependentSystemOptimization where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat
open import Agda.Builtin.Sigma

data ⊥ : Set where

data Cost : Set where
  finite : Nat → Cost
  infinity : Cost

minNat : Nat → Nat → Nat
minNat zero n = zero
minNat (suc m) zero = zero
minNat (suc m) (suc n) = suc (minNat m n)

minCost : Cost → Cost → Cost
minCost infinity c = c
minCost c infinity = c
minCost (finite m) (finite n) = finite (minNat m n)

addCost : Cost → Cost → Cost
addCost infinity c = infinity
addCost c infinity = infinity
addCost (finite m) (finite n) = finite (m + n)

data One : Set where
  one : One

data Branch : Set where
  b0 b1 : Branch

infOne : (One → Cost) → Cost
infOne f = f one

infBranch : (Branch → Cost) → Cost
infBranch f = minCost (f b0) (f b1)

K : One → Branch → Cost
K one b0 = finite zero
K one b1 = finite (suc zero)

L : Branch → One → Cost
L b0 one = infinity
L b1 one = finite zero

TerminalValue : One → Cost
TerminalValue one = finite zero

bellmanAB : (One → Branch → Cost) → (Branch → Cost) → One → Cost
bellmanAB R V a = infBranch (λ b → addCost (R a b) (V b))

bellmanBC : (Branch → One → Cost) → (One → Cost) → Branch → Cost
bellmanBC R V b = infOne (λ c → addCost (R b c) (V c))

composeRelation : (Branch → One → Cost) → (One → Branch → Cost)
  → One → One → Cost
composeRelation S R a c = infBranch (λ b → addCost (R a b) (S b c))

bellmanAC : (One → One → Cost) → (One → Cost) → One → Cost
bellmanAC R V a = infOne (λ c → addCost (R a c) (V c))

branchCompositeCost : Branch → Cost
branchCompositeCost b = addCost (K one b) (L b one)

globalCompositeCost : Cost
globalCompositeCost = infBranch branchCompositeCost

bellman-composition-instance :
  bellmanAC (composeRelation L K) TerminalValue one
  ≡ bellmanAB K (bellmanBC L TerminalValue) one
bellman-composition-instance = refl

localMinimum : Cost
localMinimum = infBranch (K one)

LocalArgmin : Set
LocalArgmin = Σ Branch (λ b → K one b ≡ localMinimum)

localArgmin : LocalArgmin
localArgmin = b0 , refl

GlobalArgmin : Set
GlobalArgmin = Σ Branch (λ b → branchCompositeCost b ≡ globalCompositeCost)

globalArgmin : GlobalArgmin
globalArgmin = b1 , refl

greedyCompositeCost : Cost
greedyCompositeCost = branchCompositeCost (fst localArgmin)

greedy-is-infeasible : greedyCompositeCost ≡ infinity
greedy-is-infeasible = refl

global-is-one : globalCompositeCost ≡ finite (suc zero)
global-is-one = refl

data Feasible : Cost → Set where
  finite-feasible : (n : Nat) → Feasible (finite n)

global-feasible : Feasible globalCompositeCost
global-feasible = finite-feasible (suc zero)

greedy-not-feasible : Feasible greedyCompositeCost → ⊥
greedy-not-feasible ()

dirac : Branch → Branch → Cost
dirac b0 b0 = finite zero
dirac b0 b1 = infinity
dirac b1 b0 = infinity
dirac b1 b1 = finite zero

dirac-reconstruct-b0 : bellmanAB K (dirac b0) one ≡ K one b0
dirac-reconstruct-b0 = refl

dirac-reconstruct-b1 : bellmanAB K (dirac b1) one ≡ K one b1
dirac-reconstruct-b1 = refl

branchTag : Branch → Nat
branchTag b0 = zero
branchTag b1 = suc zero

costValue : Cost → Nat
costValue (finite n) = n
costValue infinity = zero

proofTag : {A : Set} {x y : A} → x ≡ y → Nat
proofTag refl = suc zero

localChoiceTag : Nat
localChoiceTag = branchTag (fst localArgmin)

localCompositeInfiniteTag : Nat
localCompositeInfiniteTag = proofTag greedy-is-infeasible

globalChoiceTag : Nat
globalChoiceTag = branchTag (fst globalArgmin)

globalCompositeValue : Nat
globalCompositeValue = costValue globalCompositeCost

bellmanCompositionTag : Nat
bellmanCompositionTag = proofTag bellman-composition-instance

diracB0Tag : Nat
diracB0Tag = proofTag dirac-reconstruct-b0

diracB1Tag : Nat
diracB1Tag = proofTag dirac-reconstruct-b1
