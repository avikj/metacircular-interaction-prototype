{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Trivarṇa — the two three-letter alphabets are one type
--
-- Source term.  त्रिवर्ण (tri-varṇa), "three-lettered / three-syllabled":
-- Piṅgala's *Chandaḥśāstra* (~300 BCE) enumerates metres by the varṇas of
-- a foot, and the gaṇa of three syllables — the eight trikas — is exactly
-- an alphabet of three distinct letters read as one object.  The term is
-- used here for the object "a bare set of three distinguishable points",
-- which is what Piṅgala's combinatorics ranges over; no claim is made that
-- Piṅgala proved the equivalence below.
--
-- SCOPE.  This module closes an edge on the machine's frontier.  Two
-- modules of this corpus each privately define a data type named `Three`,
-- for unrelated purposes:
--
--   * DisclosureDimension.Three  (constructors a b c) — the three-letter
--     alphabet witnessing that set-level disclosure has no dimension.
--   * StagewiseComposite.Three   (constructors t0 t1 t2) — the three
--     response values witnessing that the stagewise family fails to
--     determine the composite defect.
--
-- The machine's reader (Setubandha) lists both as ISOLATED NODES: types
-- the corpus defines that nothing identifies with anything.  They are, in
-- fact, the SAME type — each is a bare enumeration of three distinct
-- points — so the identification is real, not forced.  We build the
-- explicit isomorphism, hence an equivalence and (by univalence) a path.
--
-- Nothing else is assumed: no Discrete, no ordering, no field.  The only
-- content is that a→t0, b→t1, c→t2 is a bijection, checked by the kernel
-- on all six round-trip cases by refl.
------------------------------------------------------------------------

module SourcedProofs.Trivarna_TheTwoThreeLetterAlphabetsAreOneType where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Univalence using (ua)

open import DisclosureDimension using (Three)
open import StagewiseComposite  using (Three)

-- Disambiguated local names for the two `Three`s.
open DisclosureDimension using () renaming (Three to Alpha)
open StagewiseComposite  using () renaming (Three to Resp)

private
  -- Constructors, brought in under distinct names.
  open DisclosureDimension renaming (a to A ; b to B ; c to C)
  open StagewiseComposite  renaming (t0 to T0 ; t1 to T1 ; t2 to T2)

  toResp : Alpha → Resp
  toResp A = T0
  toResp B = T1
  toResp C = T2

  toAlpha : Resp → Alpha
  toAlpha T0 = A
  toAlpha T1 = B
  toAlpha T2 = C

  to-from : (r : Resp) → toResp (toAlpha r) ≡ r
  to-from T0 = refl
  to-from T1 = refl
  to-from T2 = refl

  from-to : (x : Alpha) → toAlpha (toResp x) ≡ x
  from-to A = refl
  from-to B = refl
  from-to C = refl

-- The isomorphism, the equivalence, and the path.

Alpha-Iso-Resp : Iso Alpha Resp
Alpha-Iso-Resp = iso toResp toAlpha to-from from-to

Alpha≃Resp : Alpha ≃ Resp
Alpha≃Resp = isoToEquiv Alpha-Iso-Resp

Alpha≡Resp : Alpha ≡ Resp
Alpha≡Resp = ua Alpha≃Resp
