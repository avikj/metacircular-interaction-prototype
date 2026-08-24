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
-- NaturalMachine.ProductiveObservationFiber
--
-- The complete future-view encoder of the linear productive Net has an
-- exact fibre: the states in its fibre over a chosen centre, together with
-- their equality to that centre's code, are equivalent to candidates
-- equipped with a coinductive bisimulation to the centre.
--
-- This is a fibre-level composition of the already checked
-- `ProductiveObservabilityBridge.bisim≃forever` and function
-- extensionality.  It does not transfer to the indexed branching Net of
-- `IndraNet.Coinductive`, and it supplies neither finality nor an explicit
-- later/clock modality.
------------------------------------------------------------------------

module NaturalMachine.ProductiveObservationFiber where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; compEquiv ; fiber)
open import Cubical.Functions.FunExtEquiv using (funExtEquiv)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (Σ-syntax)
open import Cubical.Data.Sigma.Properties using (Σ-cong-equiv-snd)

import NaturalMachine.FiniteIndraWeave as FIW
import NaturalMachine.ObservabilityQuotient as OQ
import NaturalMachine.ProductiveIndraNet as PIN
import NaturalMachine.ProductiveObservabilityBridge as POB

private
  variable
    Root Jewel : Type₀

-- Name the encoder demanded by the information lens: the whole linear
-- future of rooted views, not only the present `Net.view`.
futureView : PIN.Net Root Jewel → ℕ → FIW.TotalView Root Jewel
futureView net depth =
  OQ.obsAt PIN.Net.next PIN.Net.view depth net

-- Bisimulation is exactly equality under the complete future-view encoder.
-- `bisim≃forever` provides the coinductive content; `funExtEquiv` changes
-- pointwise future equality into one path between complete codes.
bisim≃futureViewPath : {left right : PIN.Net Root Jewel}
  → PIN.Bisim left right ≃ (futureView left ≡ futureView right)
bisim≃futureViewPath =
  compEquiv POB.bisim≃forever funExtEquiv

BisimClass : PIN.Net Root Jewel → Type₀
BisimClass {Root = Root} {Jewel = Jewel} center =
  Σ[ candidate ∈ PIN.Net Root Jewel ] PIN.Bisim candidate center

FutureViewFiber : PIN.Net Root Jewel → Type₀
FutureViewFiber center = fiber futureView (futureView center)

-- The rooted class and the actual encoder fibre agree, without quotienting
-- either side or erasing the proof of observational equality.
bisimClass≃futureViewFiber : (center : PIN.Net Root Jewel)
  → BisimClass center ≃ FutureViewFiber center
bisimClass≃futureViewFiber center =
  Σ-cong-equiv-snd (λ candidate → bisim≃futureViewPath)
