{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ज्योतिर्युग्म — the light-pair.
--
-- WHAT THIS IS.  The interferometric instance of the Parasparāśraya
-- record: over the integers as a toy amplitude line,
--
--   · INTENSITY (the magnitude) is blind to phase — the named pair is
--     (+1, −1), the fringe-sign pair, identified by every magnitude
--     detector and provably distinct;
--   · PHASE (the sign) is blind to magnitude — the named pair is
--     (+1, +2), one ray at two brightnesses;
--   · JOINTLY they are faithful: magnitude and sign reconstruct the
--     amplitude, and the reconstruction is a function exhibited by case
--     analysis, not an existence claim.
--
-- So the amplitude is an INTERDEPENDENT TYPE in the checked sense of
-- the Parasparasraya module, and the general laws land on it for free:
-- each observable provably separates every blind pair of the other
-- (dvitīya-paśyati), neither can be discarded (na-ekākin), and — by
-- UpakaranaVrddhi's na-praṇālī — NEITHER IS A FUNCTION OF THE OTHER:
-- phase is not post-processing of intensity, intensity is not
-- post-processing of phase.  A photodetector and a homodyne reference
-- are new senses of one field, each passing ApurvaIndriyam's admission
-- gate against the other.
--
-- THE PHYSICAL READING, stated as the reading it is.  |ψ|² forgetting
-- the phase is the decategorification the corpus prices everywhere
-- (weights ⇒ traces at the detector); complementarity — extract the
-- one reading and lose the other's residue — is the truncation price;
-- and interference is nature declining the quotient: the route
-- difference is physically carried.  None of that is proved here; the
-- shape of it is, and the shape is this file.
--
-- SYĀT — THE CLAIM, EXACTLY.  There is no Hilbert space, no complex field,
-- no Born rule and no interferometer in this development.  "Amplitude"
-- names an integer, "intensity" its distance from zero, "phase" its
-- sign, and the physical vocabulary is a reading offered over a
-- six-line case analysis that typechecks.
------------------------------------------------------------------------

module Jyotiryugma_IntensityIsBlindToPhaseAndPhaseToMagnitudeAndTheAmplitudeIsTheirInterdependentPair where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Nat using (ℕ ; suc ; injSuc ; snotz)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.Sigma using (_,_)
open import Cubical.Data.Empty using (⊥ ; rec)

open import Parasparasraya_TheMutualDependenceObjectionChecksWhenTheLeaningIsProductive
  using (Parasparāśraya)

------------------------------------------------------------------------
-- १ · The two senses.
------------------------------------------------------------------------

-- Intensity: distance from zero.  pos n ↦ n, negsuc n ↦ suc n.
tejas : ℤ → ℕ
tejas (pos n)    = n
tejas (negsuc n) = suc n

-- Phase: the sign.  Nonnegative ↦ true, negative ↦ false.
diś : ℤ → Bool
diś (pos _)    = true
diś (negsuc _) = false

------------------------------------------------------------------------
-- २ · Joint faithfulness: the reconstruction, by case analysis.
------------------------------------------------------------------------

saṃdhāna : (x y : ℤ) → tejas x ≡ tejas y → diś x ≡ diś y → x ≡ y
saṃdhāna (pos m)    (pos n)    t _ = cong pos t
saṃdhāna (negsuc m) (negsuc n) t _ = cong negsuc (injSuc t)
saṃdhāna (pos m)    (negsuc n) _ d = rec (true≢false d)
saṃdhāna (negsuc m) (pos n)    _ d = rec (true≢false (sym d))

------------------------------------------------------------------------
-- ३ · The interdependent pair, inhabited.
------------------------------------------------------------------------

jyotiryugma : Parasparāśraya ℤ ℕ Bool
Parasparāśraya.dṛś₁ jyotiryugma = tejas
Parasparāśraya.dṛś₂ jyotiryugma = diś
-- Intensity's blind pair: +1 and −1.  Equal magnitude by refl; distinct
-- because the sign separates them — the fringe the detector cannot see.
Parasparāśraya.andha₁ jyotiryugma =
  pos 1 , negsuc 0
  , (λ p → true≢false (cong diś p)) , refl
-- Phase's blind pair: +1 and +2.  Equal sign by refl; distinct because
-- the magnitude separates them — brightness the phase cannot see.
Parasparāśraya.andha₂ jyotiryugma =
  pos 1 , pos 2
  , (λ p → snotz (sym (injSuc (cong tejas p)))) , refl
Parasparāśraya.yugma jyotiryugma = saṃdhāna

------------------------------------------------------------------------
-- ४ · The laws, landed.  Free from the record: intensity and phase
-- each separate the other's blind pair, neither is discardable, and
-- (via UpakaranaVrddhi.na-praṇālī, applicable to this very term)
-- neither factors through the other — the two detectors are mutually
-- new senses of the amplitude.
------------------------------------------------------------------------

-- The fringe, as a term: the phase separates what intensity identifies.
vyatikaraḥ : diś (pos 1) ≡ diś (negsuc 0) → ⊥
vyatikaraḥ =
  Parasparāśraya.dvitīya-paśyati jyotiryugma (pos 1) (negsuc 0)
    (λ p → true≢false (cong diś p)) refl

-- No intensity-only interferometry: a magnitude detector alone is
-- refuted as a faithful reading of the amplitude.
na-kevala-tejaḥ : ((x y : ℤ) → tejas x ≡ tejas y → x ≡ y) → ⊥
na-kevala-tejaḥ faithful =
  true≢false (cong diś (faithful (pos 1) (negsuc 0) refl))
