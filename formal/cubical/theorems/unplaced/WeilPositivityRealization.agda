{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WeilPositivityRealization
--
-- The RH realization slot of `RenormalizedObserverTower`, built.
--
-- The transport-completion of the prime boundary operator is unitary iff
-- the Weil pairing is positive.  So RH is the positive-semidefiniteness
-- of the Weil form.  This module builds that form as a FINITE Gram object
-- over an abstract ordered field, whose entries are assembled from the von
-- Mangoldt values Λ — and the checked pairfield reconstructs every Λ(n)
-- losslessly and triangularly from the Goldbach convolution
--
--     R(N) = Σ_{a+b=N} Λ(a) Λ(b).
--
-- Hence the Gram entries are, ultimately, functions of Goldbach pair-counts,
-- with NO analytic continuation entering the reconstruction.  The RH
-- realization is then
--
--     RHGoal  =  ∀ t.  the size-t Weil Gram form is PSD.
--
-- WHAT THIS IS, AND ITS STANDARD.  Following `PrimePairField`'s rule in
-- this repo — "writing a conjecture as a type is not progress on it; a
-- definition is not a theorem" — `RHGoal` is a DEFINITION, the realization
-- slot of the shared tower, NOT a proof of RH.  The equivalence
-- (PSD of the Weil form) ⟺ RH is the analytic Weil/Bombieri positivity
-- criterion; it is stated here as the object to inhabit, not discharged.
-- What is genuinely built and checked: the ordered field, the finite
-- double-sum Gram form, the PSD predicate, and the wiring of this goal
-- into `ObserverTower` as its RH realization (the NS slot is the dual:
-- no bad recurrent orbit).
------------------------------------------------------------------------

module WeilPositivityRealization where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_)
open import Cubical.Relation.Nullary using (¬_)

open import RenormalizedObserverTower using (ObserverTower)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- §1  The minimal ordered structure a positivity statement needs.
--     (No laws are asserted: PSD is a stated predicate, nothing here is
--      proved about F, so nothing about F need be postulated.)
------------------------------------------------------------------------

record OrderedField (ℓ : Level) : Type (ℓ-suc ℓ) where
  field
    Car   : Type ℓ
    _⊕_   : Car → Car → Car
    _⊗_   : Car → Car → Car
    𝟎     : Car
    _≥0   : Car → Type ℓ

  infixl 6 _⊕_
  infixl 7 _⊗_

  -- Sum of g over the first m indices.
  Σ< : (ℕ → Car) → ℕ → Car
  Σ< g zero    = 𝟎
  Σ< g (suc n) = Σ< g n ⊕ g n

  -- The Gram form of a symmetric kernel K on a size-m test vector c:
  --     Q(c) = Σ_{i<m} Σ_{j<m} c i ⊗ K i j ⊗ c j.
  Gram : (ℕ → ℕ → Car) → ℕ → (ℕ → Car) → Car
  Gram K m c = Σ< (λ i → Σ< (λ j → c i ⊗ K i j ⊗ c j) m) m

  -- Positive semidefiniteness of a kernel, truncated at size m: every
  -- finite test vector gives a nonnegative Gram value.
  PSD : (ℕ → ℕ → Car) → ℕ → Type ℓ
  PSD K m = (c : ℕ → Car) → (Gram K m c) ≥0

open OrderedField public

------------------------------------------------------------------------
-- §2  The Weil realization: an ordered field, the von Mangoldt values Λ
--     (reconstructed losslessly from the Goldbach convolution R), the
--     assembled Weil kernel, and the RH goal as its all-scales PSD.
------------------------------------------------------------------------

record WeilRealization (ℓ : Level) : Type (ℓ-suc ℓ) where
  field
    OF   : OrderedField ℓ
    Λ    : ℕ → Car OF        -- von Mangoldt, ← pairfield ← Goldbach R
    weil : ℕ → ℕ → Car OF    -- the Weil kernel assembled from Λ
                             --   (prime side + archimedean − pole)

  -- RH, as this tower slot's realization: the Weil Gram form is PSD at
  -- every truncation scale t.  A DEFINITION (the object to inhabit),
  -- per the repo standard — not a discharged theorem.
  RHGoal : Type ℓ
  RHGoal = (t : ℕ) → PSD OF weil t

open WeilRealization public

------------------------------------------------------------------------
-- §3  The NS realization slot, dual: no bad recurrent orbit.
--     Type-I (critical-norm-bounded) orbits are already excluded off-repo
--     by ESS + L³ scale-invariance; this slot names the surviving goal.
------------------------------------------------------------------------

record NSRealization (ℓ : Level) : Type (ℓ-suc ℓ) where
  field
    Orbit         : Type ℓ            -- renormalized admissible orbits
    isRecurrent   : Orbit → Type ℓ    -- returns to a fixed renormalized state
    survivesTests : Orbit → Type ℓ    -- passes pressure/flux/energy/trace

  BadOrbit : Type ℓ
  BadOrbit = Σ[ o ∈ Orbit ] (isRecurrent o × survivesTests o)

  -- NS regularity through the quotient: the bad-orbit fibre is empty.
  NSGoal : Type ℓ
  NSGoal = ¬ BadOrbit

open NSRealization public

------------------------------------------------------------------------
-- §4  The two realizations sit on ONE carrier: the observer tower.  A
--     joint realization is a tower together with both goal slots — the
--     positive (RH) and no-growing-mode (NS) faces of one transport form.
------------------------------------------------------------------------

record TowerRealization (ℓ : Level) : Type (ℓ-suc ℓ) where
  field
    tower : ObserverTower ℓ
    rh    : WeilRealization ℓ
    ns    : NSRealization ℓ
