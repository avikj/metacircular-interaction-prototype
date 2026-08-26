{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- TwoFibrations: the pair field's shape as ONE total space with TWO
-- structure maps.
--
-- For an abstract predicate P : ℕ → ℕ → Type (one day "both legs of the
-- pair (w - r , w + r) are prime"; here deliberately abstract — no
-- primality, no arithmetic, no conjecture is claimed), the total space
--
--   Total P = Σ[ w ∈ ℕ ] Σ[ r ∈ ℕ ] P w r
--
-- carries two projections: the center map π₊ (w , r , p) = w and the
-- radius map π₋ (w , r , p) = r.  The two famous conjecture SHAPES are
-- statements about the fibers of these two maps over the SAME space:
--
--   * Goldbach-shape  = every fiber of π₊ is inhabited (Coverage);
--   * twin-prime-shape = the r = 1 fiber of π₋ is unbounded (Recurrence).
--
-- Everything below is checked; nothing about primes is asserted.

module TwoFibrations where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Functions.Fibration using (fiberEquiv)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order using (_≤_)
open import Cubical.HITs.PropositionalTruncation using (∥_∥₁; ∣_∣₁)

module _ (P : ℕ → ℕ → Type) where

  -- The one total space.
  Total : Type
  Total = Σ ℕ (λ w → Σ ℕ (λ r → P w r))

  -- The two structure maps.
  π₊ : Total → ℕ            -- center
  π₊ t = fst t

  π₋ : Total → ℕ            -- radius
  π₋ t = fst (snd t)

  -- The named fibers.
  CenterFiber : ℕ → Type
  CenterFiber w = Σ ℕ (λ r → P w r)

  RadiusFiber : ℕ → Type
  RadiusFiber r = Σ ℕ (λ w → P w r)

  ------------------------------------------------------------------
  -- (a) The fiber of π₊ over w is CenterFiber w, and dually for π₋.
  ------------------------------------------------------------------

  -- π₊ is definitionally fst on Total = Σ ℕ CenterFiber, so the
  -- library's HoTT Lemma 4.8.1 applies verbatim.
  centerFiberChar : (w : ℕ) → fiber π₊ w ≃ CenterFiber w
  centerFiberChar w = fiberEquiv CenterFiber w

  -- The Σ-swap putting the radius coordinate first.
  swapIso : Iso Total (Σ ℕ (λ r → RadiusFiber r))
  Iso.fun swapIso (w , r , p) = (r , w , p)
  Iso.inv swapIso (r , w , p) = (w , r , p)
  Iso.rightInv swapIso _ = refl
  Iso.leftInv swapIso _ = refl

  swapEquiv : Total ≃ Σ ℕ (λ r → RadiusFiber r)
  swapEquiv = isoToEquiv swapIso

  -- Under the swap, π₋ becomes fst (definitionally, by Σ-eta), so the
  -- fiber of π₋ over r is the fiber of fst over r, which is RadiusFiber r.
  radiusFiberChar : (r : ℕ) → fiber π₋ r ≃ RadiusFiber r
  radiusFiberChar r =
    compEquiv
      (Σ-cong-equiv-fst {B = λ s → fst s ≡ r} swapEquiv)
      (fiberEquiv RadiusFiber r)

  ------------------------------------------------------------------
  -- (b) The two fibrations have the SAME total space.
  ------------------------------------------------------------------

  totalSpaceAgree : Σ ℕ (λ w → CenterFiber w) ≃ Σ ℕ (λ r → RadiusFiber r)
  totalSpaceAgree = swapEquiv

  ------------------------------------------------------------------
  -- (c) The two conjecture SHAPES, as types.  These are DEFINITIONS
  -- of shapes over the abstract P; no inhabitant is claimed, and none
  -- could be, since P is arbitrary.
  ------------------------------------------------------------------

  -- Goldbach-shape: every center fiber is (merely) inhabited — i.e.
  -- π₊ is surjective.  Stated propositionally (∥_∥₁: witness-free)
  -- and structurally (a choice of witness for every w).
  Coverage : Type
  Coverage = (w : ℕ) → ∥ CenterFiber w ∥₁

  CoverageStr : Type
  CoverageStr = (w : ℕ) → CenterFiber w

  -- twin-prime-shape: the r = 1 fiber of π₋ meets every tail of ℕ —
  -- i.e. RadiusFiber 1 is unbounded.
  Recurrence : Type
  Recurrence = (N : ℕ) → Σ ℕ (λ w → (N ≤ w) × P w 1)

  -- Sanity: the structural coverage yields the propositional one.
  coverageStr→Coverage : CoverageStr → Coverage
  coverageStr→Coverage c w = ∣ c w ∣₁
