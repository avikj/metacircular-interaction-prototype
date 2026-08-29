{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- सङ्क्रमण — the crossing.  THE MACHINE IS ITS COMPLETED SELF, AS AN
-- IDENTIFICATION IN THE UNIVERSE — AND THE IDENTIFICATION COMPUTES.
--
-- Univalence turns the lossless completion into a PATH between types:
--
--     machine≡completed : Machine ≡ Σ Machine (fiber uStep)
--
-- The space of machines and the space of completed one-step histories
-- are not merely equivalent; in cubical type theory they are EQUAL,
-- and — this is the point of doing it cubically — the equality is not
-- an axiom to cite but an operation that runs.  Transporting a
-- machine across the identification COMPUTES its completed step
-- (`crossing-computes`, by the computation rule for ua, evaluating,
-- not cited); transporting back reads the source out of the fibre
-- (`crossing-back-computes`).  The same holds at every depth n for
-- the n-step run.  On a concrete machine the whole crossing
-- evaluates to a closed normal form (`spin-crosses`).
--
-- This is the corpus's saṃkramaṇa discipline applied to the machine
-- itself: every transport carries an object, an exhibited
-- identification, and the identification is priced by what it
-- forgets — here, nothing, which is Ekatva's theorem.  The visible
-- machine and the proof-carrying machine are one type in two
-- presentations, and univalence is the vehicle that carries
-- computation between them without loss.
------------------------------------------------------------------------

module Sankramana_TheMachineIsItsCompletedSelfAsAnIdentificationInTheUniverseAndTheIdentificationComputes where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber ; equivFun ; invEq)
open import Cubical.Foundations.Univalence using (ua ; uaβ ; ~uaβ)
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource

------------------------------------------------------------------------
-- §1  The identification.
------------------------------------------------------------------------

machine≡completed : Machine ≡ Σ Machine (fiber uStep)
machine≡completed = ua (lossless uStep)

-- Crossing forward computes the completed step: the stepped machine,
-- the source, and the receipt, produced by transport.
crossing-computes : (mc : Machine) →
  transport machine≡completed mc ≡ (uStep mc , mc , refl)
crossing-computes mc = uaβ (lossless uStep) mc

-- Crossing back reads the source out of the fibre: reverse transport
-- is the projection Ekatva forces it to be.
crossing-back-computes : (w : Σ Machine (fiber uStep)) →
  transport (sym machine≡completed) w ≡ fst (snd w)
crossing-back-computes w = ~uaβ (lossless uStep) w

------------------------------------------------------------------------
-- §2  At every depth.
------------------------------------------------------------------------

machine≡run-completed : (n : ℕ) → Machine ≡ Σ Machine (fiber (run n))
machine≡run-completed n = ua (run-lossless n)

deep-crossing-computes : (n : ℕ) (mc : Machine) →
  transport (machine≡run-completed n) mc ≡ (run n mc , mc , refl)
deep-crossing-computes n mc = uaβ (run-lossless n) mc

------------------------------------------------------------------------
-- §3  A closed crossing.
------------------------------------------------------------------------

-- The one-rule spinner crosses to its own completed fixed point: the
-- computation rule evaluates on a closed machine to a closed normal
-- form.
spin-crosses :
  transport machine≡completed (spin , start)
    ≡ ((spin , start) , (spin , start) , refl)
spin-crosses = crossing-computes (spin , start)
