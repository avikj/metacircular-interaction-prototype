{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ReceiverExponentFaithful
--
-- Prop 1 of the receiver derivation, structurally: the receiver H is
-- nonvanishing on the shifted strip, so it multiplies each mode by a
-- nonzero bounded factor.  In the additive log-amplitude picture that is a
-- CONSTANT OFFSET of the scale orbit.  A constant offset changes amplitudes
-- but not the growth exponent, so it neither creates nor hides boundedness:
--
--     BoundedOrbit e  ⟺  BoundedOffset e c        (for every offset c).
--
-- Hence the receiver is harmless — the observed boundedness of B(t) reflects
-- exactly the mode exponents, not the receiver's damping.  "The damping is in
-- the receiver; it changes modal amplitudes, not the scale-growth exponent."
------------------------------------------------------------------------

module ReceiverExponentFaithful where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Int using (ℤ ; -_ ; _+_ ; _-_)
open import Cubical.Data.Int.Order using (_≤_ ; ≤-+o)
open import Cubical.Data.Int.Properties using (plusMinus)
open import Cubical.Data.Sigma

open import ScaleTransportZ using (orbit ; BoundedOrbit)

-- the received orbit: the scale orbit shifted by the (log-)amplitude c.
offsetOrbit : ℤ → ℤ → ℕ → ℤ
offsetOrbit e c n = orbit e n + c

BoundedOffset : ℤ → ℤ → Type₀
BoundedOffset e c = Σ[ B ∈ ℤ ] ((n : ℕ) → offsetOrbit e c n ≤ B)

-- a nonzero bounded receiver keeps a bounded orbit bounded (amplitude shift).
receiver-preserves : (e c : ℤ) → BoundedOrbit e → BoundedOffset e c
receiver-preserves e c (B , bnd) = (B + c) , λ n → ≤-+o {o = c} (bnd n)

-- and it hides nothing: a bounded received orbit had a bounded orbit.
receiver-reflects : (e c : ℤ) → BoundedOffset e c → BoundedOrbit e
receiver-reflects e c (B , bnd) = (B + (- c)) , λ n →
  subst (_≤ B + (- c)) (plusMinus c (orbit e n)) (≤-+o {o = - c} (bnd n))
