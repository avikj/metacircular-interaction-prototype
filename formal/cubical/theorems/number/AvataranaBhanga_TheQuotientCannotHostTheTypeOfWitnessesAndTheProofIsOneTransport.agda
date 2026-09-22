{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- अवतरणभङ्गः — the quotient cannot host the type of witnesses, and the
-- proof is one transport.
--
-- TERM.  अवतरण (descent — this library's own word for it, from
-- LosslessReturn) and भङ्ग (break, and the word the saptabhaṅgī uses for
-- its positions).  The compound अवतरण-भङ्ग, "the break of descent", is
-- built here.
--
-- The "dependent novelty" generalization �����-������-��������� — the
-- inhabited/empty contrast weakened to mere non-equivalence of the
-- fibres, via pathToEquiv.  The inhabited/empty theorem becomes the
-- cheapest instance of it.
--
-- KramaNiyama: two laws live on
-- the same carrier ℤ × ℤ; one admits the generator-commutation filler and the
-- other refutes it; no Bool-valued succession receptor factors through the
-- carrier-only transcript.
--
-- This probe asks for the stronger dependent statement.  The target is not a
-- Boolean report ABOUT a filler.  It is the TYPE OF FILLERS itself:
--
--     Filler μ = μ g₁ g₂ ≡ μ g₂ g₁.
--
-- If this family factored through the carrier transcript, equal transcripts
-- would identify the two filler types.  Cubical transport would then carry
-- the torus filler into the Klein filler, contradicting the checked denial.
--
-- So the no-go proof is transport itself.  This is the exact join of
-- QuotientFiberLaw and the cubical filler receipt: no post-processing of a
-- carrier transcript can manufacture not merely the right answer, but the
-- missing higher cell.
------------------------------------------------------------------------

module AvataranaBhanga_TheQuotientCannotHostTheTypeOfWitnessesAndTheProofIsOneTransport where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Data.List using (List)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Relation.Nullary using (¬_)

import KramaNiyama_TheLawOfSuccessionDoesNotFactorThroughTheCarrier as K
import QuotientFiberLaw as QFL

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- 1. Dependent factorization through an observation.
------------------------------------------------------------------------

DependentFactorsThrough :
  {ℓ ℓ' ℓ'' : Level} {X : Type ℓ} {O : Type ℓ'}
  → (X → O) → (X → Type ℓ'')
  → Type (ℓ-max (ℓ-max ℓ ℓ') (ℓ-suc ℓ''))
DependentFactorsThrough {ℓ'' = ℓ''} {X = X} {O = O} observe Family =
  Σ[ Descended ∈ (O → Type ℓ'') ]
    ((x : X) → Family x ≡ Descended (observe x))

-- A collision in the observation together with an inhabited fibre on one
-- side and an empty fibre on the other obstructs dependent factorization.
-- The contradiction is obtained by transporting the inhabitant across the
-- type path that factorization would force.
dependent-collision-obstructs :
  {X : Type ℓ} {O : Type ℓ'}
  (observe : X → O) (Family : X → Type ℓ'')
  (x y : X)
  → observe x ≡ observe y
  → Family x
  → ¬ Family y
  → ¬ DependentFactorsThrough observe Family
dependent-collision-obstructs observe Family x y same seen absent
  (Descended , commutes) =
    absent
      (transport
        (commutes x ∙ cong Descended same ∙ sym (commutes y))
        seen)

------------------------------------------------------------------------
-- 2. The filler family on the two succession laws.
------------------------------------------------------------------------

module CarrierLaw = QFL.Law K.नियमः

Filler : K.नियमः → Type
Filler μ = μ K.g₁ K.g₂ ≡ μ K.g₂ K.g₁

carrierTranscript : K.नियमः → List Bool
carrierTranscript = CarrierLaw.obs K.वाहक-दृष्टिः

sameCarrierTranscript : carrierTranscript K.μT ≡ carrierTranscript K.μK
sameCarrierTranscript =
  CarrierLaw.obs-agree K.वाहक-दृष्टिः K.μT K.μK K.अन्धयुग्मम्

-- THE DEPENDENT NO-GO.  The type of commutation fillers does not descend to
-- the carrier-only transcript.  Were it to descend, transport would turn
-- K.समम् into an inhabitant forbidden by K.विषमम्.
fillerDoesNotFactorThroughCarrier :
  ¬ DependentFactorsThrough carrierTranscript Filler
fillerDoesNotFactorThroughCarrier =
  dependent-collision-obstructs
    carrierTranscript Filler K.μT K.μK
    sameCarrierTranscript K.समम् K.विषमम्

------------------------------------------------------------------------
-- 3. �����-������-��������� — the generalization:
-- the fibres need not be inhabited/empty; MERE NON-EQUIVALENCE of the
-- two fibres over a collision already refutes descent, because a
-- factorization forces a path of types and pathToEquiv turns it into
-- the equivalence that was refuted.  The inhabited/empty theorem above
-- is the cheapest way to refute that equivalence, not the content.
------------------------------------------------------------------------

open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Univalence using (pathToEquiv)

अवतरण-भङ्ग-सामान्यम् :
  {ℓ ℓ' ℓ'' : Level} {X : Type ℓ} {O : Type ℓ'}
  (observe : X → O) (Family : X → Type ℓ'')
  (x y : X)
  → observe x ≡ observe y
  → ¬ (Family x ≃ Family y)
  → ¬ DependentFactorsThrough observe Family
अवतरण-भङ्ग-सामान्यम् observe Family x y same noEquiv
  (Descended , commutes) =
    noEquiv
      (pathToEquiv
        (commutes x ∙ cong Descended same ∙ sym (commutes y)))
