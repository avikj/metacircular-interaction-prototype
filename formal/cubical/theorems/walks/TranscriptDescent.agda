{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- A transcript test produces an executable decoder.
--
-- Swarm.S00TranscriptComposition proves the exact kernel-pair condition
-- under which stagewise transcript preservation survives composition.
-- FiniteInformation proves that a kernel-pair invariant
-- into a set descends constructively through the image.  Their common
-- object is FiberConstant.  This file identifies the two definitions and
-- turns the compositional criterion into an actual decoder on reachable
-- terminal observations.
------------------------------------------------------------------------

module TranscriptDescent where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Foundations.HLevels using (isSetΣ)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)

import Swarm.S00TranscriptComposition as Transcript
open import FiniteInformation
  using
    ( FactorsThrough
    ; FiberConstant
    ; factorsThrough→fiberConstant
    ; fiberConstant→factorsThrough
    )

private
  variable
    ℓx ℓy ℓz ℓ₁ ℓ₂ : Level

-- The transcript predicate is exactly the Natural Machine's descent law,
-- not a second notion requiring a translation theorem.
transcriptFactors→fiberConstant :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓ₁}
  (q : X → Y) (t : X → T)
  → Transcript.Factors q t → FiberConstant q t
transcriptFactors→fiberConstant q t h = h

fiberConstant→transcriptFactors :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓ₁}
  (q : X → Y) (t : X → T)
  → FiberConstant q t → Transcript.Factors q t
fiberConstant→transcriptFactors q t h = h

-- A successful transcript test is executable: it constructs a function
-- on the reachable image of the endpoint, with definitional replay on
-- every originating state.
transcriptDecoder :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓ₁}
  (isSetT : isSet T) (q : X → Y) (t : X → T)
  → Transcript.Factors q t → FactorsThrough q t
transcriptDecoder isSetT q t h =
  fiberConstant→factorsThrough isSetT q t h

-- A physical observation boundary need not be an operational boundary.
-- One collision whose transcript values differ is already an obstruction
-- to every decoder on the reachable image; no set or choice hypothesis is
-- needed for this negative direction.
collisionObstructsDecoder :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓ₁}
  (q : X → Y) (t : X → T) {x x' : X}
  → q x ≡ q x'
  → ¬ (t x ≡ t x')
  → ¬ FactorsThrough q t
collisionObstructsDecoder q t {x} {x'} sameObservation differentTranscript through =
  differentTranscript
    (factorsThrough→fiberConstant q t through x x' sameObservation)

-- A retained record repairs such a collision only by carrying the missing
-- distinction.  This is the pointwise obstruction underlying record lower
-- bounds: if endpoint plus record determines the transcript, then colliding
-- endpoint states with different transcripts cannot also share a record.
soundRecordSeparatesCollision :
  {X : Type ℓx} {Y : Type ℓy} {A : Type ℓz} {T : Type ℓ₁}
  (q : X → Y) (r : X → A) (t : X → T) {x x' : X}
  → Transcript.Determines q r t
  → q x ≡ q x'
  → ¬ (t x ≡ t x')
  → ¬ (r x ≡ r x')
soundRecordSeparatesCollision q r t {x} {x'} determines sameObservation
  differentTranscript sameRecord =
  differentTranscript (determines x x' sameObservation sameRecord)

-- A retained side record is not extra-logical metadata.  It is exactly a
-- second observable paired with the endpoint, hence it too constructs a
-- decoder on the reachable image of that pair.
sideRecordDecoder :
  {X : Type ℓx} {Y : Type ℓy} {A : Type ℓz} {T : Type ℓ₁}
  (isSetT : isSet T) (q : X → Y) (r : X → A) (t : X → T)
  → Transcript.Determines q r t
  → FactorsThrough (λ x → q x , r x) t
sideRecordDecoder isSetT q r t h =
  fiberConstant→factorsThrough isSetT (λ x → q x , r x) t
    (λ x x' p → h x x' (cong fst p) (cong snd p))

-- If the endpoint already determines the retained record, then the record
-- is eliminable: endpoint plus record determines no more transcript than
-- the endpoint alone.  The conclusion is again an installed decoder.
eraseDeterminedRecord :
  {X : Type ℓx} {Y : Type ℓy} {A : Type ℓz} {T : Type ℓ₁}
  (isSetT : isSet T) (q : X → Y) (r : X → A) (t : X → T)
  → Transcript.Factors q r
  → Transcript.Determines q r t
  → FactorsThrough q t
eraseDeterminedRecord isSetT q r t endpointDeterminesRecord together =
  transcriptDecoder isSetT q t
    (λ x x' p → together x x' p (endpointDeterminesRecord x x' p))

module TwoStage
  {X : Type ℓx} {Y : Type ℓy} {Z : Type ℓz}
  {T₁ : Type ℓ₁} {T₂ : Type ℓ₂}
  (w₁ : X → Y) (t₁ : X → T₁)
  (w₂ : Y → Z) (t₂ : Y → T₂)
  where

  open Transcript.TwoStage w₁ t₁ w₂ t₂
    using (W ; total ; injectiveSuffices)

  -- The sharp stagewise condition no longer ends as a certificate string:
  -- it installs the composite transcript as a function of the reachable
  -- terminal endpoint.
  stagewiseDecoder :
    isSet T₁ → isSet T₂
    → Transcript.isInj w₂
    → Transcript.Factors w₁ t₁
    → Transcript.Factors w₂ t₂
    → FactorsThrough W total
  stagewiseDecoder set₁ set₂ inj first second =
    transcriptDecoder (isSetΣ set₁ (λ _ → set₂)) W total
      (injectiveSuffices inj first second)
