{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.RelativeInstrumentAssociativity
--
-- Three dependent instruments compose associatively after the canonical
-- reassociation of their proof-relevant outcome and posterior total spaces.
-- The two bracketings do not have literally the same outcome type.
--
-- This is an algebraic law for the repository's deterministic operational
-- interface.  It introduces no probability, sampling, or collapse semantics.
------------------------------------------------------------------------

module NaturalMachine.RelativeInstrumentAssociativity where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)

import NaturalMachine.RelativeInstrument as RI

private
  variable
    ℓa ℓo ℓn ℓt ℓp : Level

------------------------------------------------------------------------
-- 1. The two dependent outcome bracketings and their full result totals
------------------------------------------------------------------------

module ResultAssociator
  {O : Type ℓo}
  {Next : O → Type ℓn}
  {Third : (o : O) → Next o → Type ℓt}
  (End : (o : O) (next : Next o) → Third o next → Type ℓp)
  where

  LeftOutcome : Type _
  LeftOutcome =
    Σ[ pair ∈ (Σ[ o ∈ O ] Next o) ] Third (fst pair) (snd pair)

  RightOutcome : Type _
  RightOutcome =
    Σ[ o ∈ O ] Σ[ next ∈ Next o ] Third o next

  LeftPost : LeftOutcome → Type ℓp
  LeftPost outcome =
    End (fst (fst outcome)) (snd (fst outcome)) (snd outcome)

  RightPost : RightOutcome → Type ℓp
  RightPost outcome =
    End (fst outcome) (fst (snd outcome)) (snd (snd outcome))

  LeftResult RightResult : Type _
  LeftResult  = Σ[ outcome ∈ LeftOutcome  ] LeftPost outcome
  RightResult = Σ[ outcome ∈ RightOutcome ] RightPost outcome

  left→right : LeftResult → RightResult
  left→right (((o , next) , third) , final) =
    (o , next , third) , final

  right→left : RightResult → LeftResult
  right→left ((o , next , third) , final) =
    ((o , next) , third) , final

  left-round : (result : LeftResult)
    → right→left (left→right result) ≡ result
  left-round (((o , next) , third) , final) = refl

  right-round : (result : RightResult)
    → left→right (right→left result) ≡ result
  right-round ((o , next , third) , final) = refl

  resultIso : Iso LeftResult RightResult
  resultIso = iso left→right right→left right-round left-round

  resultEquiv : LeftResult ≃ RightResult
  resultEquiv = isoToEquiv resultIso

------------------------------------------------------------------------
-- 2. Sequential execution commutes with the canonical reassociation
------------------------------------------------------------------------

module _
  {A : Type ℓa}
  {O : Type ℓo}
  {Post : O → Type ℓp}
  {Next : O → Type ℓn}
  {Middle : (o : O) → Next o → Type ℓp}
  {Third : (o : O) (next : Next o) → Type ℓt}
  {End : (o : O) (next : Next o) → Third o next → Type ℓp}
  (first : RI.Instrument A O Post)
  (second : (o : O) → RI.Instrument (Post o) (Next o) (Middle o))
  (third : (o : O) (next : Next o)
    → RI.Instrument (Middle o next) (Third o next) (End o next))
  where

  open ResultAssociator End

  leftAssociated : RI.Instrument A LeftOutcome LeftPost
  leftAssociated =
    RI.sequential
      (RI.sequential first second)
      (λ pair → third (fst pair) (snd pair))

  rightAssociated : RI.Instrument A RightOutcome RightPost
  rightAssociated =
    RI.sequential first
      (λ o → RI.sequential (second o) (third o))

  sequential-associative : (input : A)
    → left→right (leftAssociated input) ≡ rightAssociated input
  sequential-associative input with first input
  ... | o , posterior with second o posterior
  ... | next , middle with third o next middle
  ... | finalOutcome , final = refl
