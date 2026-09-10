{-# OPTIONS --safe --guardedness #-}

module FiberJewelNet where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat
open import Agda.Builtin.Sigma
open import Agda.Builtin.Bool
import ConsequenceFiber as CF

data ⊥ : Set where

Not : Set → Set
Not A = A → ⊥

data Root : Set where replayRoot installedRoot : Root

-- Fibers are root-indexed.  They are not coerced into one undifferentiated
-- payload merely because their canonical theorem output agrees.
data RootFiber : Root → Set where
  replayFiber : RootFiber replayRoot
  installedFiber : RootFiber installedRoot

Jewel : Set
Jewel = Σ Root RootFiber

replayJewel installedJewel : Jewel
replayJewel = replayRoot , replayFiber
installedJewel = installedRoot , installedFiber

canonical : Jewel → Nat
canonical (replayRoot , replayFiber) = CF.replayOutput
canonical (installedRoot , installedFiber) = CF.installedOutput

canonical-across-roots : canonical replayJewel ≡ canonical installedJewel
canonical-across-roots = refl

capabilityCost : (r : Root) → RootFiber r → Nat
capabilityCost replayRoot replayFiber = CF.replayNextCost
capabilityCost installedRoot installedFiber = CF.installedNextCost

rootedCost : Jewel → Nat
rootedCost (r , f) = capabilityCost r f

rooted-profile-nonconstant : CF.Less (rootedCost installedJewel) (rootedCost replayJewel)
rooted-profile-nonconstant = CF.installed-strictly-cheaper

replay≠installedRoot : Not (replayRoot ≡ installedRoot)
replay≠installedRoot ()

replay≠installedJewel : Not (replayJewel ≡ installedJewel)
replay≠installedJewel ()

-- An imported fiber equivalence is the exact warrant for cross-root
-- transport.  It acts between native fibers; it does not identify their roots.
record FiberEquiv (r s : Root) : Set where
  constructor fiberEquiv
  field
    to : RootFiber r → RootFiber s
    from : RootFiber s → RootFiber r
    to-from : (y : RootFiber s) → to (from y) ≡ y
    from-to : (x : RootFiber r) → from (to x) ≡ x

open FiberEquiv

replay-installed-equiv : FiberEquiv replayRoot installedRoot
replay-installed-equiv = fiberEquiv
  (λ { replayFiber → installedFiber })
  (λ { installedFiber → replayFiber })
  (λ { installedFiber → refl })
  (λ { replayFiber → refl })

transportJewel : {r s : Root} → FiberEquiv r s → RootFiber r → Jewel
transportJewel {s = s} e f = s , to e f

transport-preserves-canonical :
  canonical (transportJewel replay-installed-equiv replayFiber)
    ≡ canonical replayJewel
transport-preserves-canonical = refl

transport-reduces-cost : CF.Less
  (rootedCost (transportJewel replay-installed-equiv replayFiber))
  (rootedCost replayJewel)
transport-reduces-cost = CF.installed-strictly-cheaper

transport-does-not-collapse-roots : Not
  (transportJewel replay-installed-equiv replayFiber ≡ replayJewel)
transport-does-not-collapse-roots ()

-- Productive rooted Net: every stage exposes the same two rooted fiber
-- profiles and unfolds again.  Canonical observation is constant across the
-- Net, while cost/capability remains root-sensitive at every depth.
record ProductiveFiberNet : Set where
  coinductive
  field
    view : (r : Root) → RootFiber r
    next : ProductiveFiberNet

open ProductiveFiberNet

fiberNet : ProductiveFiberNet
view fiberNet replayRoot = replayFiber
view fiberNet installedRoot = installedFiber
next fiberNet = fiberNet

viewCanonical : ProductiveFiberNet → Root → Nat
viewCanonical N r = canonical (r , view N r)

viewCost : ProductiveFiberNet → (r : Root) → Nat
viewCost N r = capabilityCost r (view N r)

iterateNet : Nat → ProductiveFiberNet → ProductiveFiberNet
iterateNet zero N = N
iterateNet (suc n) N = iterateNet n (next N)

all-depth-canonical : (depth : Nat)
  → viewCanonical (iterateNet depth fiberNet) replayRoot
    ≡ viewCanonical (iterateNet depth fiberNet) installedRoot
all-depth-canonical zero = refl
all-depth-canonical (suc n) = all-depth-canonical n

netReplayCost netInstalledCost transportedCost : Nat
netReplayCost = viewCost fiberNet replayRoot
netInstalledCost = viewCost fiberNet installedRoot
transportedCost = rootedCost (transportJewel replay-installed-equiv replayFiber)

netReplayOutput netInstalledOutput : Nat
netReplayOutput = viewCanonical fiberNet replayRoot
netInstalledOutput = viewCanonical fiberNet installedRoot
