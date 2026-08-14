{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- When the complete rooted view is set-valued, a stabilized bounded unary
-- observation kernel is equivalent as a witness type to productive
-- bisimulation.  The existing maps become an equivalence because both sides
-- are propositions; no unproved round-trip computation is inserted.
------------------------------------------------------------------------

module NaturalMachine.SingletonStabilizedEquivalence where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_≃_ ; equivFun ; invEquiv ; propBiimpl→Equiv)
open import Cubical.Foundations.HLevels
  using (isPropΠ ; isSetΠ ; isOfHLevelRespectEquiv)
open import Cubical.Data.List using (List)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Unit using (Unit)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.FiniteIndraWeave as FIW
import NaturalMachine.FutureBehavior as FB
import NaturalMachine.ObservabilityQuotient as OQ
import NaturalMachine.ObservableHorizon as OH
import NaturalMachine.ProductiveIndraNet as PIN
import NaturalMachine.ProductiveObservabilityBridge as POB
import NaturalMachine.SingletonActionObservability as SAO

private
  variable
    Root Jewel : Type₀

------------------------------------------------------------------------
-- 1. Set-valued views make both relation witnesses propositions
------------------------------------------------------------------------

isPropProductiveBounded :
    (setView : isSet (FIW.TotalView Root Jewel))
    (fuel : ℕ) {left right : PIN.Net Root Jewel}
  → isProp
      (OH.BoundedFutureEq
        (SAO.unitStep PIN.Net.next) PIN.Net.view fuel left right)
isPropProductiveBounded setView fuel =
  isPropΠ λ word → isPropΠ λ bound → setView _ _

isPropProductiveForever :
    (setView : isSet (FIW.TotalView Root Jewel))
    {left right : PIN.Net Root Jewel}
  → isProp (OQ.ForeverEq PIN.Net.next PIN.Net.view left right)
isPropProductiveForever setView =
  isPropΠ λ depth → setView _ _

isPropProductiveBisim :
    (setView : isSet (FIW.TotalView Root Jewel))
    {left right : PIN.Net Root Jewel}
  → isProp (PIN.Bisim left right)
isPropProductiveBisim setView =
  isOfHLevelRespectEquiv 1 (invEquiv POB.bisim≃forever)
    (isPropProductiveForever setView)

------------------------------------------------------------------------
-- 2. Stabilization as an equivalence
------------------------------------------------------------------------

productiveBounded≃bisim :
    (setView : isSet (FIW.TotalView Root Jewel))
    (fuel : ℕ)
  → OH.ObservableClosesAt
      (SAO.unitStep (PIN.Net.next {Root} {Jewel})) PIN.Net.view fuel
  → {left right : PIN.Net Root Jewel}
  → OH.BoundedFutureEq
      (SAO.unitStep PIN.Net.next) PIN.Net.view fuel left right
    ≃ PIN.Bisim left right
productiveBounded≃bisim setView fuel closes =
  propBiimpl→Equiv
    (isPropProductiveBounded setView fuel)
    (isPropProductiveBisim setView)
    (SAO.productiveBounded→bisim fuel closes)
    (SAO.bisim→productiveBounded fuel)

-- A set-valued Jewel type is a convenient sufficient source of the direct
-- set-valued-view hypothesis.  Root itself need not be a set.
setJewel→setView :
  isSet Jewel → isSet (FIW.TotalView Root Jewel)
setJewel→setView setJewel =
  isSetΠ λ root → isSetΠ λ target → setJewel

productiveBounded≃bisim-setJewel :
    (setJewel : isSet Jewel)
    (fuel : ℕ)
  → OH.ObservableClosesAt
      (SAO.unitStep (PIN.Net.next {Root} {Jewel})) PIN.Net.view fuel
  → {left right : PIN.Net Root Jewel}
  → OH.BoundedFutureEq
      (SAO.unitStep PIN.Net.next) PIN.Net.view fuel left right
    ≃ PIN.Bisim left right
productiveBounded≃bisim-setJewel setJewel =
  productiveBounded≃bisim (setJewel→setView setJewel)

------------------------------------------------------------------------
-- 3. Closure is load-bearing
------------------------------------------------------------------------

-- Any uniform bounded-to-bisimulation upgrade already implies the exact
-- action-closure premise used above.  This direction needs no set hypothesis.
productiveBoundedBisim→closure :
    (fuel : ℕ)
  → ((left right : PIN.Net Root Jewel)
    → OH.BoundedFutureEq
        (SAO.unitStep PIN.Net.next) PIN.Net.view fuel left right
    → PIN.Bisim left right)
  → OH.ObservableClosesAt
      (SAO.unitStep (PIN.Net.next {Root} {Jewel})) PIN.Net.view fuel
productiveBoundedBisim→closure fuel upgrade =
  OH.boundedFuture→closure
    (SAO.unitStep PIN.Net.next) PIN.Net.view fuel
    λ left right bounded →
      equivFun SAO.productiveBisim≃singletonFuture
        (upgrade left right bounded)

-- Therefore a bounded collision separated by a later word rules out every
-- uniform bounded-to-bisimulation upgrade.  This is the retained killer for
-- silently dropping ObservableClosesAt.
bounded-collision-obstructs-bisim-upgrade :
    (fuel : ℕ) {left right : PIN.Net Root Jewel}
  → OH.BoundedFutureEq
      (SAO.unitStep PIN.Net.next) PIN.Net.view fuel left right
  → (word : List Unit)
  → ¬ (FB.behavior (SAO.unitStep PIN.Net.next) PIN.Net.view left word
      ≡ FB.behavior (SAO.unitStep PIN.Net.next) PIN.Net.view right word)
  → ¬ ((x y : PIN.Net Root Jewel)
      → OH.BoundedFutureEq
          (SAO.unitStep PIN.Net.next) PIN.Net.view fuel x y
      → PIN.Bisim x y)
bounded-collision-obstructs-bisim-upgrade fuel bounded word separates upgrade =
  OH.bounded-collision-obstructs-closure
    (SAO.unitStep PIN.Net.next) PIN.Net.view bounded word separates
    (productiveBoundedBisim→closure fuel upgrade)

------------------------------------------------------------------------
-- Boundary
--
-- `isSet TotalView` is sufficient for the proposition-level packaging; it is
-- not claimed necessary for a particular pair to admit an equivalence.  If
-- it is absent, SingletonActionObservability's maps remain checked, but maps
-- both ways between proof-relevant types do not by themselves supply inverse
-- laws.  Nothing here concerns indexed branching, a later modality, clocks,
-- a final coalgebra, or decidable/finite-state discovery of closure.
------------------------------------------------------------------------
