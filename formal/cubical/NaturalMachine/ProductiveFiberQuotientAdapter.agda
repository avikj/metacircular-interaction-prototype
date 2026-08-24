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
-- NaturalMachine.ProductiveFiberQuotientAdapter
--
-- The productive future-view fibre retains a candidate Net and a path from
-- its complete view code to the centre's code.  When Jewel is a set, that
-- path induces complete singleton-action FutureEq and hence a path to the
-- centre in FutureQuotient.Meaning.  Thus the entire homotopy fibre maps
-- constantly to one quotient point; it is not itself the quotient carrier.
--
-- The set hypothesis is load-bearing.  Without it, TotalView is not known
-- set-valued and FutureBehavior's effective set-quotient surface cannot be
-- instantiated.  No truncation or proof irrelevance is silently inserted.
------------------------------------------------------------------------

module NaturalMachine.ProductiveFiberQuotientAdapter where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (equivFun ; invEq)
open import Cubical.Foundations.HLevels using (isSetΠ)
open import Cubical.Data.Sigma using (fst ; snd)
open import Cubical.HITs.SetQuotients as SQ using ([_] ; eq/)

import NaturalMachine.FiniteIndraWeave as FIW
import NaturalMachine.FutureBehavior as FB
import NaturalMachine.ProductiveIndraNet as PIN
import NaturalMachine.ProductiveObservationFiber as POF
import NaturalMachine.SingletonActionObservability as SAO

private
  variable
    Root Jewel : Type₀

-- TotalView Root Jewel = Root → Root → Jewel, so set-valued jewels are the
-- exact hypothesis needed by the set-quotient consumer.  Root need not be a
-- set because function types into a set are sets.
isSetTotalView : isSet Jewel → isSet (FIW.TotalView Root Jewel)
isSetTotalView setJewel = isSetΠ λ _ → isSetΠ λ _ → setJewel

futureViewPath→futureEq :
    {left right : PIN.Net Root Jewel}
  → POF.futureView left ≡ POF.futureView right
  → FB.FutureEq (SAO.unitStep PIN.Net.next) PIN.Net.view left right
futureViewPath→futureEq sameCode =
  equivFun SAO.productiveBisim≃singletonFuture
    (invEq POF.bisim≃futureViewPath sameCode)

module Adapter {Root Jewel : Type₀} (setJewel : isSet Jewel) where

  module FQ = FB.FutureQuotient
    (SAO.unitStep (PIN.Net.next {Root} {Jewel}))
    (isSetTotalView setJewel)
    PIN.Net.view

  -- Keep the candidate component of the actual homotopy fibre, then name its
  -- complete observable meaning.  The path witness has not been discarded:
  -- fiberToCenter below consumes it.
  fiberToMeaning : (center : PIN.Net Root Jewel)
    → POF.FutureViewFiber center → FQ.Meaning
  fiberToMeaning center point = [ fst point ]

  -- Every point of the encoder fibre lands at the centre's single quotient
  -- class.  This is the exact map from proof-relevant fibre data to the
  -- set-truncated behavioral carrier.
  fiberToCenter : (center : PIN.Net Root Jewel)
    → (point : POF.FutureViewFiber center)
    → fiberToMeaning center point ≡ [ center ]
  fiberToCenter center point =
    eq/ (fst point) center (futureViewPath→futureEq (snd point))

  fiberToMeaning-constant : (center : PIN.Net Root Jewel)
    → fiberToMeaning center ≡ (λ _ → [ center ])
  fiberToMeaning-constant center = funExt (fiberToCenter center)

