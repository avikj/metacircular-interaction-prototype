{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- A transcript test produces an executable decoder.
--
-- Swarm.S00TranscriptComposition proves the exact kernel-pair condition
-- under which stagewise transcript preservation survives composition.
-- NaturalMachine.FiniteInformation proves that a kernel-pair invariant
-- into a set descends constructively through the image.  Their common
-- object is FiberConstant.  This file identifies the two definitions and
-- turns the compositional criterion into an actual decoder on reachable
-- terminal observations.
------------------------------------------------------------------------

module NaturalMachine.TranscriptDescent where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Foundations.HLevels using (isSetΣ)
open import Cubical.Data.Sigma using (_×_)

import Swarm.S00TranscriptComposition as Transcript
open import NaturalMachine.FiniteInformation
  using (FactorsThrough ; FiberConstant ; fiberConstant→factorsThrough)

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

