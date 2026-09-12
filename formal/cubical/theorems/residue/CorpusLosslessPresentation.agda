{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CorpusLosslessPresentation
--
-- CorpusCalculus already gives the universal interactive carrier
--
--   Point ℓ               = Σ[ A ∈ Type ℓ ] A
--   Question (A , a)      = Σ[ B ∈ Type ℓ ] (A → B)
--   target (A , a) (B,f) = (B , f a).
--
-- This module adds no new semantic machine.  It reads every question by the
-- corpus's existing fibre/compression law.  A question f : A → B presents A
-- exactly as
--
--   A ≃ Σ[ b ∈ B ] fiber f b.
--
-- The visible answer is b = f a; the second coordinate is exactly the
-- residual the question did not see.  A further observable contributes no
-- new independent information precisely when it is constant on those fibres
-- (`FiniteInformation.FactorsThrough ≃ FiberConstant`).
--
-- Two consecutive questions compose to one question definitionally at the
-- observed endpoint.  Hence an interaction can be contracted without losing
-- the fibre that witnesses which source realization produced the answer.
------------------------------------------------------------------------

module CorpusLosslessPresentation where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber ; _≃_ ; equivFun)
open import Cubical.Foundations.Isomorphism using (Iso)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)

import CorpusCalculus as C
import CompressionIsTransportSoTheOnlyCostIsTheNonContractibleFibre as Compression
import FiniteInformation as FI

private
  variable
    ℓ ℓt : Level

Source : C.Point ℓ → Type ℓ
Source s = fst s

source : (s : C.Point ℓ) → Source s
source = snd

Codomain : {s : C.Point ℓ} → C.Question s → Type ℓ
Codomain q = fst q

query : {s : C.Point ℓ} (q : C.Question s) → Source s → Codomain q
query = snd

------------------------------------------------------------------------
-- One question, losslessly.
------------------------------------------------------------------------

Residual : (s : C.Point ℓ) (q : C.Question s) → Type ℓ
Residual s q = fiber (query q) (query q (source s))

Presentation : (s : C.Point ℓ) (q : C.Question s) → Type ℓ
Presentation s q = Σ[ b ∈ Codomain q ] fiber (query q) b

lossless : (s : C.Point ℓ) (q : C.Question s)
         → Source s ≃ Presentation s q
lossless s q = Compression.lossless (query q)

encode : (s : C.Point ℓ) (q : C.Question s)
       → Source s → Presentation s q
encode s q = equivFun (lossless s q)

-- The actual corpus point is encoded by its visible answer plus the exact
-- fibre witness locating the source realization over that answer.
current : (s : C.Point ℓ) (q : C.Question s) → Presentation s q
current s q = encode s q (source s)

current-visible : (s : C.Point ℓ) (q : C.Question s)
                → fst (current s q) ≡ query q (source s)
current-visible s q = refl

current-residual : (s : C.Point ℓ) (q : C.Question s)
                 → fiber (query q) (query q (source s))
current-residual s q = source s , refl

------------------------------------------------------------------------
-- Exactly when another read adds information.
------------------------------------------------------------------------

Descends : (s : C.Point ℓ) (q : C.Question s)
         {T : Type ℓt} → (Source s → T) → Type _
Descends s q t = FI.FactorsThrough (query q) t

ConstantOnResidual : (s : C.Point ℓ) (q : C.Question s)
                   {T : Type ℓt} → (Source s → T) → Type _
ConstantOnResidual s q t = FI.FiberConstant (query q) t

descends-iff-constant-on-residual :
    (s : C.Point ℓ) (q : C.Question s)
    {T : Type ℓt} (isSetT : isSet T) (t : Source s → T)
  → Iso (Descends s q t) (ConstantOnResidual s q t)
descends-iff-constant-on-residual s q isSetT t =
  FI.factorsThroughIsoFiberConstant isSetT (query q) t

------------------------------------------------------------------------
-- Composition is compression of successive interaction.
------------------------------------------------------------------------

compose : (s : C.Point ℓ)
        → (q : C.Question s)
        → C.Question (C.target s q)
        → C.Question s
compose s q r = fst r , λ a → snd r (query q a)

compose-target : (s : C.Point ℓ)
               → (q : C.Question s)
               → (r : C.Question (C.target s q))
               → C.target s (compose s q r)
                 ≡ C.target (C.target s q) r
compose-target s q r = refl

compose-evaluation : (s : C.Point ℓ)
                   → (q : C.Question s)
                   → (r : C.Question (C.target s q))
                   → (a : Source s)
                   → query (compose s q r) a ≡ snd r (query q a)
compose-evaluation s q r a = refl

-- The composite question is itself immediately covered by the same fibre
-- law, so contraction of two interactions does not throw away their exact
-- realization residue.
composite-lossless :
    (s : C.Point ℓ)
    (q : C.Question s)
    (r : C.Question (C.target s q))
  → Source s ≃ Presentation s (compose s q r)
composite-lossless s q r = lossless s (compose s q r)
