{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ParetoCost
--
-- A theorem can make one later route cheaper while making another resource
-- more expensive.  Collapsing those coordinates to one permanent score is
-- an additional policy, not part of the mathematical result.  This module
-- installs the smallest checked object that can retain that fact.
--
-- The random entry that exposed the seam was a physical byte interval in
-- `notes/RESEARCH_SYSTEM.md`: it landed on the warning that scientific
-- value has no permanent scalar score and that allocation should preserve
-- Pareto improvements.  The Natural Machine already had the exact reopening
-- example in `notes/REPRESENTATION_REOPENING_CYCLE.md`:
--
--   full route       = (120 operations,  0 correction scalars)
--   compiled route   = (104 operations, 32 correction scalars).
--
-- Here that prose becomes a `--safe` term.  The two routes are incomparable
-- in the componentwise order.  Moreover TWO componentwise-monotone scalar
-- readouts select opposite routes: elapsed operations prefer compilation,
-- while the unweighted total prefers the full route.  Hence a scalarization
-- may be installed as a declared objective, but it cannot be confused with
-- the underlying resource order.
--
-- Deliberately not claimed: that these are every physical resource, that
-- addition is the right exchange rate, that either route is globally
-- optimal, or that Pareto order supplies research significance.  The checked
-- content is only the product order, its concrete antichain, and the policy
-- dependence of scalar selection.
------------------------------------------------------------------------

module NaturalMachine.ParetoCost where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; _+_)
open import Cubical.Data.Nat.Order
  using (_<_ ; _≤_ ; ≤-+-≤ ; ≤<-trans ; ¬m<m)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- The non-scalar cost object
------------------------------------------------------------------------

Cost₂ : Type₀
Cost₂ = ℕ × ℕ

infix 4 _≼_

-- Componentwise improvement/no-worsening.  No exchange rate is present.
_≼_ : Cost₂ → Cost₂ → Type₀
x ≼ y = (fst x ≤ fst y) × (snd x ≤ snd y)

Incomparable : Cost₂ → Cost₂ → Type₀
Incomparable x y = (¬ (x ≼ y)) × (¬ (y ≼ x))

-- A scalar policy is allowed, but its monotonicity must be exposed.
Scalarization : Type₀
Scalarization = Cost₂ → ℕ

Monotone : Scalarization → Type₀
Monotone s = (x y : Cost₂) → x ≼ y → s x ≤ s y

time : Scalarization
time = fst

total : Scalarization
total (t , correction) = t + correction

time-monotone : Monotone time
time-monotone x y h = fst h

total-monotone : Monotone total
total-monotone x y h = ≤-+-≤ (fst h) (snd h)

------------------------------------------------------------------------
-- The representation-reopening witness
------------------------------------------------------------------------

fullRoute compiledRoute : Cost₂
fullRoute     = 120 , 0
compiledRoute = 104 , 32

time-prefers-compiled : time compiledRoute < time fullRoute
time-prefers-compiled = 15 , refl

correction-prefers-full : snd fullRoute < snd compiledRoute
correction-prefers-full = 31 , refl

total-prefers-full : total fullRoute < total compiledRoute
total-prefers-full = 15 , refl

full-not-below-compiled : ¬ (fullRoute ≼ compiledRoute)
full-not-below-compiled h =
  ¬m<m (≤<-trans (fst h) time-prefers-compiled)

compiled-not-below-full : ¬ (compiledRoute ≼ fullRoute)
compiled-not-below-full h =
  ¬m<m (≤<-trans (snd h) correction-prefers-full)

-- The core result: reopening returns an antichain, not a silently chosen
-- winner.  A later declared objective may choose, but the cost object itself
-- preserves both live alternatives.
reopening-frontier-incomparable : Incomparable fullRoute compiledRoute
reopening-frontier-incomparable =
  full-not-below-compiled , compiled-not-below-full

-- Both scalar readouts respect every componentwise improvement, yet they
-- choose opposite points of the same frontier.  The disagreement is exact
-- evidence that scalar choice is policy data.
monotone-scalarizations-disagree :
    (Monotone time × Monotone total)
  × ((time compiledRoute < time fullRoute)
  ×  (total fullRoute < total compiledRoute))
monotone-scalarizations-disagree =
  (time-monotone , total-monotone)
  , (time-prefers-compiled , total-prefers-full)
