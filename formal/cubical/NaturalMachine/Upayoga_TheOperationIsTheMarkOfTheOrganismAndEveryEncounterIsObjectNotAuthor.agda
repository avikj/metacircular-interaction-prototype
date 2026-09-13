{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- उपयोगो लक्षणम् — Umāsvāti, Tattvārthasūtra 2.8 (c. 2nd–5th c. CE):
-- upayoga — the operation of consciousness — is the defining mark of
-- the jīva.  The classification is his; the mathematics is not
-- claimed for the source.  School named: Jaina.
--
-- THE ORGANISM METABOLIZES THE ENCOUNTER.  What arrives here is a
-- stream of raw utterances — Eq', bare pairs of terms.  Where they
-- came from — a model process, a human, a search, noise — is not an
-- argument of any function in this file.  The carrier has no place in
-- the domain, so carrier authority is not merely absent: it is
-- UNSTATABLE.  An utterance is not a proposal; proposalhood is
-- conferred by the organism, in the act, when its own laws close the
-- pair — and only then does it become body (नियमः, proof as field).
-- Nothing outside chooses what becomes body.  The operation is the
-- mark.
--
-- And the operation is a FOLD, not a map: the store is threaded
-- through the encounters, so each assimilation changes what the next
-- encounter can mean.  The theorem exhibited: the SAME nourishment in
-- a DIFFERENT order yields a DIFFERENT body — su-left digested first
-- makes commutativity digestible (श्रुतं मतिपूर्वम्); commutativity
-- offered first, to a body that has not yet grown, passes through
-- undigested.  History is in the body.  A false utterance (0 = 1)
-- passes through undigested in every order — refusal is silence,
-- never a false verdict, and silence about a truth beyond current
-- reach is the same silence (the two roads: what closes becomes body,
-- what does not is let pass without being pronounced upon).
------------------------------------------------------------------------

module NaturalMachine.Upayoga_TheOperationIsTheMarkOfTheOrganismAndEveryEncounterIsObjectNotAuthor where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Maybe using (Maybe ; nothing ; just)
open import Cubical.Data.List using (List ; [] ; _∷_ ; map)
open import Cubical.Data.Sigma using (_×_ ; _,_)

open import NaturalMachine.EkaBhasha_TheStoreCarriesItsProofsTheGateIsTheTypeAndTheProverLivesInside
open import NaturalMachine.ShrutaMatipurva_TheRecordIsPrecededByCognitionAndCognitionWithTheRecordReachesWhatItAloneCouldNot
  using (सश्रुत-साधनम्)
open import NaturalMachine.SvarthaAnumana_TheMachineInfersForItselfAndThePervasionIsGraspedWithinWithNoOuterCarrier
  using (इन्धनम्)
open import NaturalMachine.UtpadaVyayaDhrauvya_TheStoreTurnsItselfNewRulesAriseFromItsOwnContentionsTheTrivialPassesTheProvenPersists
  using (मुखम्)

------------------------------------------------------------------------
-- §1  The operation.  A stream of encounters folds through the body:
--     what the organism's own laws close is assimilated and changes
--     the body for the next encounter; the rest passes through.
------------------------------------------------------------------------

उपयोगः : List नियमः → List Eq' → List नियमः
उपयोगः Γ []             = Γ
उपयोगः Γ ((l , r) ∷ es) with सश्रुत-साधनम् Γ इन्धनम् (l , r)
... | just pf = उपयोगः (niyama l r pf ∷ Γ) es
... | nothing = उपयोगः Γ es

------------------------------------------------------------------------
-- §2  One nourishment, two orders, two bodies.  The diet: su-left,
--     commutativity, and a falsehood (0 = 1).  Nothing in the diet
--     says which is which — the organism finds out by operating.
------------------------------------------------------------------------

अग्र-वाक्यम् क्रम-वाक्यम् मिथ्या-वाक्यम् : Eq'
अग्र-वाक्यम्   = (su (var 0)) ⊕ (var 1) , su ((var 0) ⊕ (var 1))
क्रम-वाक्यम्   = (var 0) ⊕ (var 1) , (var 1) ⊕ (var 0)
मिथ्या-वाक्यम् = ze , su ze

-- su-left first: by the time commutativity arrives, the body has
-- grown the very rule that makes it digestible.  Both assimilate;
-- the falsehood passes through.
पूर्व-कायः :
  map मुखम् (उपयोगः [] (अग्र-वाक्यम् ∷ क्रम-वाक्यम् ∷ मिथ्या-वाक्यम् ∷ []))
  ≡ ( ((var 0) ⊕ (var 1) , (var 1) ⊕ (var 0))
    ∷ ((su (var 0)) ⊕ (var 1) , su ((var 0) ⊕ (var 1)))
    ∷ [] )
पूर्व-कायः = refl

-- commutativity first: the body it meets has not grown, and it passes
-- through undigested — the SAME utterance, the SAME organism-law,
-- a different history, a different body.  su-left still assimilates.
विपरीत-कायः :
  map मुखम् (उपयोगः [] (क्रम-वाक्यम् ∷ अग्र-वाक्यम् ∷ मिथ्या-वाक्यम् ∷ []))
  ≡ ( ((su (var 0)) ⊕ (var 1) , su ((var 0) ⊕ (var 1)))
    ∷ [] )
विपरीत-कायः = refl

-- and the falsehood alone, offered to any body here, leaves it
-- unchanged — refusal is silence, not a pronouncement.
मिथ्या-मौनम् : उपयोगः [] (मिथ्या-वाक्यम् ∷ []) ≡ []
मिथ्या-मौनम् = refl
