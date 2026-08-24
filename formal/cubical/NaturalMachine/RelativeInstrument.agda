-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.RelativeInstrument
--
-- Finite, observer-indexed instruments.  An instrument is an operational
-- dependent map: from a fact at a locus it returns an outcome together with
-- a posterior fact indexed by that outcome.  Sequential composition retains
-- both outcomes and feeds the first posterior to the second instrument.
--
-- Frame covariance transports inputs and posteriors through fibrewise
-- equivalences while leaving the outcome label explicit.  No probabilities,
-- amplitudes, collapse law, or claim of a complete RQM model is made here.
------------------------------------------------------------------------

module NaturalMachine.RelativeInstrument where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun ; invEq ; retEq)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma
  using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)

import NaturalMachine.RelativeFrameChange as RFC

private
  variable
    ℓ ℓa ℓo ℓp ℓq : Level

------------------------------------------------------------------------
-- 1. Outcome-indexed posterior facts
------------------------------------------------------------------------

Instrument : (A : Type ℓa) (O : Type ℓo)
           → (Post : O → Type ℓp) → Type _
Instrument A O Post = A → Σ[ outcome ∈ O ] Post outcome

-- A finite instrument has an explicitly bounded outcome type.  The posterior
-- may still retain arbitrarily rich proof-relevant structure.
FiniteInstrument : (A : Type ℓa) (n : ℕ)
                 → (Post : Fin n → Type ℓp) → Type _
FiniteInstrument A n Post = Instrument A (Fin n) Post

InstrumentFamily : (L : Type ℓ) (F : L → Type ℓa)
  (O : L → Type ℓo) (Post : (l : L) → O l → Type ℓp)
  → Type _
InstrumentFamily L F O Post =
  (l : L) → Instrument (F l) (O l) (Post l)

------------------------------------------------------------------------
-- 2. Sequential composition is dependent Kleisli composition
------------------------------------------------------------------------

sequential : {A : Type ℓa} {O : Type ℓo}
  {Post : O → Type ℓp}
  {Next : O → Type ℓq}
  {Final : (o : O) → Next o → Type ℓp}
  → Instrument A O Post
  → ((o : O) → Instrument (Post o) (Next o) (Final o))
  → Instrument A (Σ[ o ∈ O ] Next o) (λ pair → Final (fst pair) (snd pair))
sequential first second input with first input
... | outcome , posterior with second outcome posterior
... | next , final = (outcome , next) , final

-- The first projection records that sequential execution cannot erase the
-- earlier outcome merely because a later interaction has occurred.
sequential-first-outcome : {A : Type ℓa} {O : Type ℓo}
  {Post : O → Type ℓp}
  {Next : O → Type ℓq}
  {Final : (o : O) → Next o → Type ℓp}
  (first : Instrument A O Post)
  (second : (o : O) → Instrument (Post o) (Next o) (Final o))
  (input : A)
  → fst (fst (sequential first second input)) ≡ fst (first input)
sequential-first-outcome first second input with first input
... | outcome , posterior with second outcome posterior
... | next , final = refl

------------------------------------------------------------------------
-- 3. Frame covariance
------------------------------------------------------------------------

mapInstrumentResult : {O : Type ℓo} {Post : O → Type ℓp}
  {Post′ : O → Type ℓp}
  → ((o : O) → Post o ≃ Post′ o)
  → Σ[ o ∈ O ] Post o → Σ[ o ∈ O ] Post′ o
mapInstrumentResult postChange (outcome , posterior) =
  outcome , equivFun (postChange outcome) posterior

transportInstrument : {A B : Type ℓa} {O : Type ℓo}
  {Post Post′ : O → Type ℓp}
  → A ≃ B → ((o : O) → Post o ≃ Post′ o)
  → Instrument A O Post → Instrument B O Post′
transportInstrument inputChange postChange instrument input =
  mapInstrumentResult postChange (instrument (invEq inputChange input))

-- Running the transported instrument on the transported input gives exactly
-- the transported original result.  This is covariance, not equality of the
-- observer-relative input or posterior facts.
transportInstrument-covariant : {A B : Type ℓa} {O : Type ℓo}
  {Post Post′ : O → Type ℓp}
  (inputChange : A ≃ B) (postChange : (o : O) → Post o ≃ Post′ o)
  (instrument : Instrument A O Post) (input : A)
  → transportInstrument inputChange postChange instrument
      (equivFun inputChange input)
    ≡ mapInstrumentResult postChange (instrument input)
transportInstrument-covariant inputChange postChange instrument input =
  cong (mapInstrumentResult postChange)
    (cong instrument (retEq inputChange input))

transportInstrumentFamily : {L : Type ℓ}
  {F G : L → Type ℓa} {O : L → Type ℓo}
  {Post Post′ : (l : L) → O l → Type ℓp}
  → RFC.FrameChange F G
  → ((l : L) (o : O l) → Post l o ≃ Post′ l o)
  → InstrumentFamily L F O Post → InstrumentFamily L G O Post′
transportInstrumentFamily inputChange postChange instrument l =
  transportInstrument (RFC.at inputChange l) (postChange l) (instrument l)

instrument-family-covariant : {L : Type ℓ}
  {F G : L → Type ℓa} {O : L → Type ℓo}
  {Post Post′ : (l : L) → O l → Type ℓp}
  (inputChange : RFC.FrameChange F G)
  (postChange : (l : L) (o : O l) → Post l o ≃ Post′ l o)
  (instrument : InstrumentFamily L F O Post)
  (l : L) (input : F l)
  → transportInstrumentFamily inputChange postChange instrument l
      (RFC.changeFact inputChange l input)
    ≡ mapInstrumentResult (postChange l) (instrument l input)
instrument-family-covariant inputChange postChange instrument l =
  transportInstrument-covariant
    (RFC.at inputChange l) (postChange l) (instrument l)

