{-# OPTIONS --safe #-}

module ConsequenceFiber where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat
open import Agda.Builtin.Bool
open import Agda.Builtin.Sigma
import BoundedMinimization as BM

data ⊥ : Set where

Not : Set → Set
Not A = A → ⊥

-- Extensional consequence and intensional derivation are separate coordinates.
-- The fiber may change future motion even when Output is contractible.
record FiberedState (Output : Set) (Fiber : Output → Set) : Set where
  constructor fibered
  field
    output : Output
    derivation : Fiber output

open FiberedState

forgetFiber : {O : Set} {F : O → Set} → FiberedState O F → O
forgetFiber = output

-- The canonical theorem output has exactly one constructor.
data LeastThree : Set where
  leastThree : LeastThree

leastThree-contractible : (x : LeastThree) → x ≡ leastThree
leastThree-contractible leastThree = refl

three : Nat
three = suc (suc (suc zero))

-- A replay route retains the bounded total derivation.  An installed route
-- additionally retains a lawful one-step reuse/transport operation.  Both
-- inhabit the same consequence fiber; the extra map is mathematical state.
record ReuseLaw : Set where
  constructor reuseLaw
  field
    reuseResult : Nat
    reuse-is-three : reuseResult ≡ three

open ReuseLaw

data ThreeFiber : LeastThree → Set where
  replayRoute : BM.CompiledMu BM.atLeastThree
    (suc (suc (suc (suc (suc zero))))) → ThreeFiber leastThree
  installedRoute : BM.CompiledMu BM.atLeastThree
    (suc (suc (suc (suc (suc zero))))) → ReuseLaw → ThreeFiber leastThree

replay≠installed : (C : BM.CompiledMu BM.atLeastThree
  (suc (suc (suc (suc (suc zero)))))) (R : ReuseLaw)
  → Not (replayRoute C ≡ installedRoute C R)
replay≠installed C R ()

replayState installedState : FiberedState LeastThree ThreeFiber
replayState = fibered leastThree (replayRoute BM.compiledThree)
installedState = fibered leastThree
  (installedRoute BM.compiledThree (reuseLaw three refl))

same-canonical-output : forgetFiber replayState ≡ forgetFiber installedState
same-canonical-output = refl

canonicalValue : FiberedState LeastThree ThreeFiber → Nat
canonicalValue S = three

-- The next machine operation consumes the fiber, not merely the consequence.
-- Replay executes the certified bound again; installed transport reuses its
-- retained result.  Values agree while exact counted costs differ.
record NextCapability : Set where
  constructor capability
  field
    nextValue : Nat
    nextCost : Nat
    hasInstalledReuse : Bool

open NextCapability

next : FiberedState LeastThree ThreeFiber → NextCapability
next (fibered leastThree (replayRoute C)) = capability
  (BM.CompiledMu.result C) (BM.CompiledMu.exact-budget C) false
next (fibered leastThree (installedRoute C R)) = capability
  (reuseResult R) (suc zero) true

next-values-agree : nextValue (next replayState) ≡ nextValue (next installedState)
next-values-agree = refl

data Less : Nat → Nat → Set where
  z<s : {n : Nat} → Less zero (suc n)
  s<s : {m n : Nat} → Less m n → Less (suc m) (suc n)

installed-strictly-cheaper : Less (nextCost (next installedState))
  (nextCost (next replayState))
installed-strictly-cheaper = s<s z<s

capabilities-differ : Not
  (hasInstalledReuse (next replayState) ≡ hasInstalledReuse (next installedState))
capabilities-differ ()

-- Extracted controls.
replayOutput installedOutput replayNextValue installedNextValue : Nat
replayOutput = canonicalValue replayState
installedOutput = canonicalValue installedState
replayNextValue = nextValue (next replayState)
installedNextValue = nextValue (next installedState)

replayNextCost installedNextCost : Nat
replayNextCost = nextCost (next replayState)
installedNextCost = nextCost (next installedState)
