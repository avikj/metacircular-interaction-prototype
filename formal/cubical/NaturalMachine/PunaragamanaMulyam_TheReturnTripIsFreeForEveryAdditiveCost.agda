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

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.PunaragamanaMulyam
--
-- पुनरागमनस्य मूल्यं शून्यम् — न केवलम् अस्मिन् यन्त्रे, सर्वस्मिन् योग्ये
-- मूल्ये ।
--
-- (the price of the return is zero — not for this machine, for EVERY
-- additive cost.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS CONNECTS
--
-- The owner's specification (2026-08-21) makes the machine's step a
-- CONJUGATION and not an action:
--
--     पुनः (बुन v) = बुन (अवतरण (Φ (उत्थान v)))
--
-- descend, act below, ascend.  `Punaragamanam_TheStepIsAConjugation…`
-- and `VivekaPramana_TheRemainderIsLawful…` establish that the ascent
-- and descent are an equivalence and that a remainder carried through
-- the step survives — `अलोपः` there proves it for all n by structural
-- recursion on that particular machine.
--
-- `NaturalMachine.TransportPrice` already proved the general fact, and
-- it is strictly stronger.  For ANY cost `c` on transports between
-- standpoints subject only to additivity,
--
--     loop-is-free : c p q + c q p ≡ pos 0.
--
-- The descent-then-ascent of the owner's step is exactly such a round
-- trip.  So the step is free of charge under EVERY additive cost, and
-- the survival of the remainder is not a fact about ℕ, about +, or
-- about this Φ — it is forced by the cost structure before any of those
-- are chosen.  §1 below is that instantiation.
--
-- The direction of the debt is worth stating: `अलोपः` is the semantic
-- shadow of `loop-is-free`, not an independent result.  It was proved
-- second and it proves less.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS *NOT* CLAIMED
--
-- Not that the two standpoints below are the nayas TransportPrice was
-- written about; `Anekanta`'s standpoints are charts on a structure and
-- these are two presentations of one pair-type.  The theorem is
-- parametric in X and applies to both, which is the whole reason it can
-- be reused — that is not an argument that the two are the same thing.
--
-- Not that Φ is free: Φ acts BELOW, and nothing here prices it.  Only
-- the descent and the ascent are round-tripped.  A machine whose Φ is
-- expensive is expensive; the claim is that the CONJUGATION adds
-- nothing to it.
--
-- Not any verdict on `laghavaPrice` as the right potential for this
-- machine — TransportPrice §2 supplies it for presentations and that is
-- its result, untouched here.
--
-- CHECKED: Agda 2.8.0, agda/cubical v0.9 (b150186), --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.PunaragamanaMulyam_TheReturnTripIsFreeForEveryAdditiveCost where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _-_ ; -_)

open import NaturalMachine.TransportPrice using (Additive ; self-is-free ; loop-is-free ; cocycle→coboundary ; reverse)

------------------------------------------------------------------------
-- 1.  The two standpoints of the owner's machine, and the price of the
--     return trip between them.
------------------------------------------------------------------------

-- युग्म is the pair presentation; विवेक is the descended presentation.
data दृष्टि : Type where
  युग्म विवेक : दृष्टि

module _ (मूल्य : दृष्टि → दृष्टि → ℤ) (योग्य : Additive मूल्य) where

  -- अवतरणम् then उत्थानम्: the machine's conjugation, priced.
  पुनरागमन-मूल्यम्-शून्यम् :
    मूल्य युग्म विवेक + मूल्य विवेक युग्म ≡ pos 0
  पुनरागमन-मूल्यम्-शून्यम् = loop-is-free मूल्य योग्य युग्म विवेक

  -- and the ascent is exactly the negation of the descent, so the two
  -- are a bonded pair in the cost as well as in the types.
  उत्थानम्-प्रतिलोमम्-अवतरणस्य :
    मूल्य विवेक युग्म ≡ - (मूल्य युग्म विवेक)
  उत्थानम्-प्रतिलोमम्-अवतरणस्य = reverse मूल्य योग्य युग्म विवेक

  -- staying in one presentation is free, and this is forced, not assumed
  स्थितिः-निर्मूल्या : (d : दृष्टि) → मूल्य d d ≡ pos 0
  स्थितिः-निर्मूल्या = self-is-free मूल्य योग्य

  -- all the content is in a potential on standpoints alone
  मूल्यं-पदार्थभेदः : (b p q : दृष्टि) → मूल्य p q ≡ (मूल्य b q) - (मूल्य b p)
  मूल्यं-पदार्थभेदः = cocycle→coboundary मूल्य योग्य
