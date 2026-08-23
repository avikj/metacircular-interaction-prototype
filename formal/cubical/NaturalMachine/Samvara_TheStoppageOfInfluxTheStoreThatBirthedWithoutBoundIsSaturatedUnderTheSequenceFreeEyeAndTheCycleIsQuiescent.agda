{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- आस्रवनिरोधः संवरः — Umāsvāti, Tattvārthasūtra 9.1 (c. 2nd–5th c.
-- CE): saṃvara is the stoppage of influx.  The classification is his;
-- the mathematics is not claimed for the source.  School named: Jaina.
--
-- THE GENERATIVE DISEASE, CURED WHERE IT AROSE.  Plain completion on
-- an AC theory generates: सिद्धि measured it outside (the naive
-- install going 387→411), and the internal store's first turn showed
-- it inside — the two-rule store birthed mirror pairs that a further
-- turn would multiply without bound.  The repair licensed there was
-- descent (install only what shrinks the gap); the repair HERE is
-- prior and cleaner: an arising whose content the body already
-- reaches is not knowledge arriving — it is influx, and it is
-- stopped at the door.  The door's eye is the sequence-free form:
-- सम-साधनम् (ArpitaAnarpita) decides reachability, so a mirror of a
-- known aggregate cannot enter dressed as news.
--
-- Exhibited on the exact store that birthed without bound: under the
-- norm-only eye, the turn on {su-left, commutativity} birthed two
-- rules (UtpadaVyayaDhrauvya, परिणाम-दृष्टम्); under the anarpita
-- eye, the same turn admits NOTHING — both births were the body's
-- own knowledge in another arpita — and the iterated cycle is
-- provably quiescent: the store is saturated, by refl.  Stoppage is
-- not blindness: a genuinely new arising still enters, because the
-- gate refuses only what it can itself re-derive.
------------------------------------------------------------------------

module NaturalMachine.Samvara_TheStoppageOfInfluxTheStoreThatBirthedWithoutBoundIsSaturatedUnderTheSequenceFreeEyeAndTheCycleIsQuiescent where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_ ; map)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.ShrutaMatipurva_TheRecordIsPrecededByCognitionAndCognitionWithTheRecordReachesWhatItAloneCouldNot
  using (अग्रिमः ; क्रम-नियमः)
open import NaturalMachine.UtpadaVyayaDhrauvya_TheStoreTurnsItselfNewRulesAriseFromItsOwnContentionsTheTrivialPassesTheProvenPersists
  using (संघट्ट-प्रसवः ; शुद्धाः ; युग्मानि)
open import NaturalMachine.ArpitaAnarpita_EveryOrderedPresentationOfOneAggregateMeetsInTheSequenceFreeFormAndTheACFrontierFallsToAJoinerSwap
  using (सम-साधनम्)

------------------------------------------------------------------------
-- §1  The stoppage.  A birth passes the door only if the body cannot
--     already re-derive it under the sequence-free eye.
------------------------------------------------------------------------

संवृत-सारः : Maybe नियमः → Maybe नियमः
संवृत-सारः nothing  = nothing
संवृत-सारः (just s) with सम-साधनम् (नियमः.lhs s , नियमः.rhs s)
... | just _  = nothing        -- reachable already: influx, stopped
... | nothing = just s         -- genuinely new: admitted

संवृत-परिणामः : List नियमः → List नियमः
संवृत-परिणामः Γ =
  शुद्धाः (map (λ pr → संवृत-सारः (संघट्ट-प्रसवः (fst pr) (snd pr)))
              (युग्मानि Γ))

-- the perpetual cycle: turn, admit what survives the stoppage, turn
-- again.  On a saturated body it is quiescent — provably, not by
-- watching it idle.
चक्रम् : ℕ → List नियमः → List नियमः
चक्रम् zero    Γ = Γ
चक्रम् (suc n) Γ = चक्रम् n (संवृत-परिणामः Γ ++ Γ)

------------------------------------------------------------------------
-- §2  The store that birthed without bound, saturated.  The same turn
--     that admitted two mirrors under the norm-only eye admits
--     nothing under the anarpita eye — and iterating the cycle
--     changes nothing, by refl.
------------------------------------------------------------------------

निरोधः : संवृत-परिणामः (अग्रिमः ∷ क्रम-नियमः ∷ []) ≡ []
निरोधः = refl

स्थैर्यम् : चक्रम् 3 (अग्रिमः ∷ क्रम-नियमः ∷ []) ≡ अग्रिमः ∷ क्रम-नियमः ∷ []
स्थैर्यम् = refl
