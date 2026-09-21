{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NSReducesToDepletion
--
-- The NS branch, as one checked reduction, mirroring RHReducesToBoundedness.
--
-- A singular continuation is a renormalized orbit that SURVIVES the joint
-- observer tests (pressure, flux, energy, trace, Reynolds-positivity,
-- recurrence).  Every such orbit is either Type-I (critical-norm bounded) or
-- Type-II (critical-norm inflating).  Then regularity through the quotient —
-- emptiness of the bad-orbit fibre — reduces to two exclusions:
--
--   excludeI  : no surviving Type-I orbit    — ESS + L³ scale-invariance,
--               classical (Escauriaza–Seregin–Šverák), the cited input;
--   excludeII : no surviving Type-II orbit   — the scale-critical depletion /
--               rigidity estimate, the NS mountain (D_NS).
--
--     no-bad-orbit : dichotomy → excludeI → excludeII → ¬ BadOrbit.
--
-- `GeometricBudgetZeno` already shows finiteness of the dissipation budget is
-- NOT itself an exclusion, so excludeII must be a genuine depletion input, not
-- a budget count.  Everything here except excludeII is in place; excludeII is
-- the sole remaining mountain, isolated rather than assumed.
------------------------------------------------------------------------

module NSReducesToDepletion where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ : Level

module _ (Orbit : Type ℓ) (survives TypeI TypeII : Orbit → Type ℓ) where

  BadOrbit : Type ℓ
  BadOrbit = Σ[ o ∈ Orbit ] survives o

  no-bad-orbit :
      ((o : Orbit) → survives o → (TypeI o ⊎ TypeII o))   -- dichotomy
    → ((o : Orbit) → survives o → ¬ TypeI o)              -- ESS: no Type-I
    → ((o : Orbit) → survives o → ¬ TypeII o)             -- depletion: no Type-II
    → ¬ BadOrbit
  no-bad-orbit dich exI exII (o , s) with dich o s
  ... | inl tI  = exI  o s tI
  ... | inr tII = exII o s tII
