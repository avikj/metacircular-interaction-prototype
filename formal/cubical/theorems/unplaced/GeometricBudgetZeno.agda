{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- GeometricBudgetZeno
--
-- The NS-face companion to `RenormalizedObserverTower.no-infinite-descent`.
--
-- Under parabolic rescaling a fixed normalized observation at scale
-- r_j = 2^{-j} costs order r_j in the physical dissipation budget (§6 of the
-- receiver/NS derivation).  The total cost of one event on every scale is
-- therefore Σ_j 2^{-j}, which is FINITE.  So merely detecting a nonzero
-- normalized event on every scale cannot contradict finite dissipation:
-- finiteness of the budget is not, by itself, an obstruction.
--
-- The exact arithmetic behind Σ_j 2^{-j} < ∞ is the finite geometric
-- telescback, here with no subtraction and no rationals:
--
--     suc (Σ_{i<n} 2^i)  ≡  2^n .            (geo)
--
-- Equivalently the partial budget stays strictly below the finest-scale unit,
-- Σ_{i<n} 2^i < 2^n (boundedBudget).  Scaled by 2^{-(n-1)} this is
-- Σ_j 2^{-j} < 2: bounded, exactly the Zeno-accessibility of the UV boundary
-- under the ordinary dissipation metric.
--
-- The moral, checked: a finite conserved budget does NOT forbid a per-scale
-- cascade.  What a regularity proof needs beyond finiteness is the additional
-- scale-critical depletion/rigidity input (Type-II exclusion) -- the NS
-- mountain, isolated here rather than assumed away.
------------------------------------------------------------------------

module GeometricBudgetZeno where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Order using (_<_)

------------------------------------------------------------------------
-- §1  Powers of two and the geometric partial sum, by doubling (no ·).
------------------------------------------------------------------------

pow2 : ℕ → ℕ
pow2 zero    = suc zero
pow2 (suc n) = pow2 n + pow2 n

sumPow2 : ℕ → ℕ            -- Σ_{i=0}^{n-1} 2^i
sumPow2 zero    = zero
sumPow2 (suc n) = sumPow2 n + pow2 n

------------------------------------------------------------------------
-- §2  The telescope: the partial budget plus one is exactly the unit at
--     the next scale.  Two lines, because `+` recurses on its first
--     argument, so suc (a + b) is definitionally suc a + b.
------------------------------------------------------------------------

geo : (n : ℕ) → suc (sumPow2 n) ≡ pow2 n
geo zero    = refl
geo (suc n) = cong (_+ pow2 n) (geo n)

-- Hence the partial budget is strictly below the finest-scale unit.
boundedBudget : (n : ℕ) → sumPow2 n < pow2 n
boundedBudget n = zero , geo n
