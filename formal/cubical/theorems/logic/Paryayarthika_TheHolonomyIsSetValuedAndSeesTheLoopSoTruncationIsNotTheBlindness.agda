{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- पर्यायार्थिकनय · paryāyārthika-naya — THE MODE-REGARDING STANDPOINT
-- ALSO LANDS IN A SET.
--
-- THE TERM, ITS TEXT AND ITS DATE.  पर्याय (paryāya) is the Jaina term
-- for a MODE of a substance, paired against द्रव्य (dravya), the
-- substance itself: `गुणपर्यायवद् द्रव्यम्` — Umāsvāti,
-- *Tattvārthasūtra* 5.37, with 5.29 (~2nd–5th c.).  The two ROOT
-- standpoints built on the pair — द्रव्यार्थिकनय (substance-regarding)
-- and पर्यायार्थिकनय (mode-regarding) — are Siddhasena Divākara,
-- *Sanmatitarka* 1.3–1.6 (~5th c.); either one asserting itself by
-- DENYING the other is a दुर्नय (Siddhasena; Akalaṅka, ~8th c.).
-- Jaina; the Naiyāyikas reject anekāntavāda outright, and the school is
-- named because the dispute is the content.
--
-- WHAT IS AND IS NOT CLAIMED OF THE SOURCE.  No Jaina logician proved
-- anything below and nothing here interprets the Tattvārthasūtra.  One
-- distinction is borrowed and only one: substance-regarding and
-- mode-regarding are two standpoints on ONE real, and neither may be
-- defined as the negation of the other.  The mathematics is cubical
-- type theory (Voevodsky's univalence).
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS REFUTES.
--
-- `Naya_TheSetValuedObservableAnnihilatesEveryLoopAndTheLoopIsStillThere`
-- proves (§१) that every SET-valued `F : A → X` has `cong F p ≡ refl`
-- for every loop `p`, and reads off (§४) the gloss
--
--       "Truncating to a set is THE WHOLE of the blindness."
--
-- further: set-truncation is offered as the type-theoretic form of
-- Theorem F's gauge-invariance, with the escape being an observable
-- that is not set-valued.
--
-- **The gloss is false, and this module is the counterexample.**  There
-- is a SET-VALUED observable that sees the loop:
--
--       होलोनोमी p  =  transport p   :   Bool → Bool
--
-- Its codomain `Bool → Bool` is a set (§१), and it separates
-- `ua notEquiv` from `refl` (§२).  So the proposition
--
--       every set-valued observable of the loop type is constant
--
-- is REFUTED (§३), by a term.
--
-- WHY `Naya` §१ IS UNTOUCHED, which is the actual content.  `Naya`
-- quantifies over `F : A → X`, observables of the CARRIER, and reports
-- `cong F`.  होलोनोमी is an observable of the PATH TYPE, `(A ≡ A) → X`.
-- The blindness is a property of non-dependent post-composition, not of
-- the h-level of the answer.  §४ shows the two live together: the same
-- loop is annihilated by every `cong F` and separated by होलोनोमी.
--
-- AND THE LOOP TYPE IS ITSELF A SET (§५).  `Bool ≡ Bool` is a set — so
-- there is no h-level obstruction whatever to observing the charged
-- sector.  A truncation argument cannot be what hides it, because the
-- thing being hidden is already 0-truncated.
--
-- THE PHYSICS READING, and it is why the correction matters.  A Wilson
-- loop is a complex number — a set-valued observable — obtained by
-- transporting around a loop, and it is the standard instrument that
-- DOES see gauge charge.  A theory on which "set-valued ⇒ blind to the
-- gauge loop" would predict Aharonov–Bohm invisible.  §२ is that
-- objection made into a term.
--
-- THE SCOPE, EXACTLY.  Nothing about KMS states, C*-algebras, Wilson
-- loops, connections, or Aharonov–Bohm.  Theorem F is neither used nor
-- formalised.  Not proved: that `Naya` §१ is wrong — it is correct as
-- stated and is applied here unchanged in §४; what is refuted is the
-- ENGLISH GLOSS in its §४ comment and in the notes downstream.
--
-- CHECKED: Agda 2.8.0 + agda/cubical, --cubical --safe, no postulates,
-- no holes.  Written 2026-08-22.
------------------------------------------------------------------------

module Paryayarthika_TheHolonomyIsSetValuedAndSeesTheLoopSoTruncationIsNotTheBlindness where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Univalence
open import Cubical.Foundations.Equiv using (_≃_; invEquiv)
open import Cubical.Foundations.HLevels using (isSetΠ; isOfHLevel≃; isOfHLevelRespectEquiv)
open import Cubical.Data.Bool using (Bool; true; false; not; notEquiv; isSetBool; false≢true)
open import Cubical.Data.Sigma using (_×_; _,_)
open import Cubical.Relation.Nullary using (¬_)

import Naya_TheSetValuedObservableAnnihilatesEveryLoopAndTheLoopIsStillThere as NAYA

------------------------------------------------------------------------
-- १ ── THE OBSERVABLE, AND THAT IT LANDS IN A SET.
------------------------------------------------------------------------

होलोनोमी : (Bool ≡ Bool) → (Bool → Bool)
होलोनोमी p = transport p

समुच्चयः : isSet (Bool → Bool)
समुच्चयः = isSetΠ (λ _ → isSetBool)

------------------------------------------------------------------------
-- २ ── AND IT SEES THE LOOP.
------------------------------------------------------------------------

पश्यति : ¬ (होलोनोमी NAYA.आवर्तः ≡ होलोनोमी refl)
पश्यति q =
  false≢true ( sym (uaβ notEquiv true)
             ∙ funExt⁻ q true
             ∙ transportRefl true )

------------------------------------------------------------------------
-- ३ ── THE REFUTED PROPOSITION, NAMED AND KILLED.
------------------------------------------------------------------------

छेदः-एव-अन्धत्वम् : Type₁
छेदः-एव-अन्धत्वम् =
  (X : Type₀) → isSet X → (G : (Bool ≡ Bool) → X) → G NAYA.आवर्तः ≡ G refl

न-छेदः : ¬ छेदः-एव-अन्धत्वम्
न-छेदः h = पश्यति (h (Bool → Bool) समुच्चयः होलोनोमी)

------------------------------------------------------------------------
-- ४ ── अनेकान्तः — both standpoints on the same loop, both set-valued.
--
-- LEFT: every set-valued observable of the CARRIER annihilates it
--       (`Naya` §१, applied and not re-proved).
-- RIGHT: one set-valued observable of the PATH TYPE separates it.
------------------------------------------------------------------------

उभयम् :
    ((X : Type₀) → isSet X → (F : Type₀ → X) → cong F NAYA.आवर्तः ≡ refl)
  × (¬ (होलोनोमी NAYA.आवर्तः ≡ होलोनोमी refl))
उभयम् = (λ X isSetX F → NAYA.नय-निरोधः isSetX F NAYA.आवर्तः) , पश्यति

------------------------------------------------------------------------
-- ५ ── THE CHARGED SECTOR IS ALREADY 0-TRUNCATED.
--
-- `Bool ≡ Bool` is a set, so nothing about h-level can be what hides
-- the charge.  Whatever hides it is not truncation.
------------------------------------------------------------------------

आवर्त-समुच्चयः : isSet (Bool ≡ Bool)
आवर्त-समुच्चयः =
  isOfHLevelRespectEquiv 2 (invEquiv univalence)
    (isOfHLevel≃ 2 isSetBool isSetBool)
