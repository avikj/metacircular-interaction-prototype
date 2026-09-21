{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RHReducesToBoundedness
--
-- The RH branch, end to end, as one checked reduction.  Everything except
-- the single arithmetic estimate D is now in place:
--
--   * B (functional equation)          : ScaleTransportZ, supplied as `de`.
--   * C (positive exponent unbounded)  : ScaleTransportZ.grows, proved.
--   * receiver harmless (Prop 1)       : ReceiverExponentFaithful, proved.
--   * criticality (the FE modus tollens): ScaleTransportCriticality, proved.
--
-- Composite: if the observed RECEIVED signal is bounded on every mode — i.e.
-- B(t) = O(1), the quantity computable from the Goldbach prefix — then every
-- exponent is 0, i.e. every nontrivial zero lies on the critical line.
--
--     RH-from-received-bounded :
--         (∀ mode. received orbit bounded)  →  (∀ mode. exp ≡ 0).
--
-- The sole remaining input is the hypothesis `bo`: boundedness of the received
-- signal, proved from the arithmetic side.  That is D, and nothing else stands
-- between it and RH in this reduction.  (A, the explicit-formula bridge from
-- the arithmetic B(t) to these modes, is the classical analytic input carried
-- outside this kernel.)
------------------------------------------------------------------------

module RHReducesToBoundedness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos ; -_)

open import ScaleTransportZ using (all-critical)
open import ReceiverExponentFaithful using (BoundedOffset ; receiver-reflects)

RH-from-received-bounded :
    (Mode : Type₀) (exp : Mode → ℤ) (dual : Mode → Mode)
  → (de : (m : Mode) → exp (dual m) ≡ (- exp m))
  → (c  : Mode → ℤ)                              -- receiver log-amplitude per mode
  → ((m : Mode) → BoundedOffset (exp m) (c m))   -- D: the received signal is O(1)
  → (m : Mode) → exp m ≡ pos 0
RH-from-received-bounded Mode exp dual de c bo =
  all-critical Mode exp dual de
    (λ m → receiver-reflects (exp m) (c m) (bo m))
