{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ProductiveObservabilityBridge
--
-- For the linear productive Net, coinductive bisimulation is equivalent to
-- equality of every future rooted view when the step is `Net.next` and the
-- observation is `Net.view`.
--
-- The Bisim-side inverse law is a guarded path through the coinductive
-- record, not definitional eta.  This result is specific to
-- `ProductiveIndraNet.Net`; it is not transferred to the indexed, branching
-- `IndraNet.Coinductive.Net`.
------------------------------------------------------------------------

module ProductiveObservabilityBridge where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Isomorphism using (iso ; isoToEquiv)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)

import ObservabilityQuotient as OQ
import ProductiveIndraNet as PIN

private
  variable
    Root Jewel : Type₀

-- Bisimilar productive Nets have the same rooted view at every future depth.
bisim→forever : {left right : PIN.Net Root Jewel}
  → PIN.Bisim left right
  → OQ.ForeverEq PIN.Net.next PIN.Net.view left right
bisim→forever related zero = PIN.Bisim.now related
bisim→forever related (suc depth) =
  bisim→forever (PIN.Bisim.later related) depth

-- Conversely, equality of every future rooted view unfolds coinductively to
-- a bisimulation.  The successor clause shifts the equality family by one.
forever→bisim : {left right : PIN.Net Root Jewel}
  → OQ.ForeverEq PIN.Net.next PIN.Net.view left right
  → PIN.Bisim left right
PIN.Bisim.now (forever→bisim equal) = equal zero
PIN.Bisim.later (forever→bisim equal) =
  forever→bisim (λ depth → equal (suc depth))

-- The observation-side round trip needs induction on the requested depth:
-- guarded projections do not reduce the arbitrary-depth term in one step.
forever-round : {left right : PIN.Net Root Jewel}
  → (equal : OQ.ForeverEq PIN.Net.next PIN.Net.view left right)
  → bisim→forever (forever→bisim equal) ≡ equal
forever-round equal = funExt (point equal)
  where
  point : {left right : PIN.Net Root Jewel}
    → (equal : OQ.ForeverEq PIN.Net.next PIN.Net.view left right)
    → (depth : ℕ)
    → bisim→forever (forever→bisim equal) depth ≡ equal depth
  point equal zero = refl
  point equal (suc depth) = point (λ later → equal (suc later)) depth

-- Coinductive records have no definitional eta here, but a guarded path
-- supplies the Bisim-side round trip field by field.
bisim-round : {left right : PIN.Net Root Jewel}
  → (related : PIN.Bisim left right)
  → forever→bisim (bisim→forever related) ≡ related
PIN.Bisim.now (bisim-round related i) = PIN.Bisim.now related
PIN.Bisim.later (bisim-round related i) =
  bisim-round (PIN.Bisim.later related) i

bisim≃forever : {left right : PIN.Net Root Jewel}
  → PIN.Bisim left right
    ≃ OQ.ForeverEq PIN.Net.next PIN.Net.view left right
bisim≃forever =
  isoToEquiv (iso bisim→forever forever→bisim forever-round bisim-round)
