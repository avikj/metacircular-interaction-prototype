{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Trivara â” the two three-letter alphabets are one type
--
-- Source term.  ààà°à¿àµà°àà (tri-vara), "three-lettered / three-syllabled":
-- Pigala's *Chandastra* (~300 BCE) enumerates metres by the varas of
-- a foot, and the gaa of three syllables â” the eight trikas â” is exactly
-- an alphabet of three distinct letters read as one object.  The term is
-- used here for the object "a bare set of three distinguishable points",
-- which is what Pigala's combinatorics ranges over; no claim is made that
-- Pigala proved the equivalence below.
--
--   * DisclosureDimension.Three  (constructors a b c) â” the three-letter
--     alphabet witnessing that set-level disclosure has no dimension.
--   * StagewiseComposite.Three   (constructors t0 t1 t2) â” the three
--     response values witnessing that the stagewise family fails to
--     determine the composite defect.
--
-- The machine's reader (Setubandha) lists both as ISOLATED NODES: types
-- the corpus defines that nothing identifies with anything.  They are, in
-- fact, the SAME type â” each is a bare enumeration of three distinct
-- points â” so the identification is real, not forced.  We build the
-- explicit isomorphism, hence an equivalence and (by univalence) a path.
--
-- Nothing else is assumed: no Discrete, no ordering, no field.  The only
-- content is that aâ’t0, bâ’t1, câ’t2 is a bijection, checked by the kernel
-- on all six round-trip cases by refl.
------------------------------------------------------------------------

module Trivarna_TheTwoThreeLetterAlphabetsAreOneType where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (Iso ; iso ; isoToEquiv)
open import Cubical.Foundations.Equiv using (_â‰ƒ_)
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

  toResp : Alpha â†’ Resp
  toResp A = T0
  toResp B = T1
  toResp C = T2

  toAlpha : Resp â†’ Alpha
  toAlpha T0 = A
  toAlpha T1 = B
  toAlpha T2 = C

  to-from : (r : Resp) â†’ toResp (toAlpha r) â‰¡ r
  to-from T0 = refl
  to-from T1 = refl
  to-from T2 = refl

  from-to : (x : Alpha) â†’ toAlpha (toResp x) â‰¡ x
  from-to A = refl
  from-to B = refl
  from-to C = refl

-- The isomorphism, the equivalence, and the path.

Alpha-Iso-Resp : Iso Alpha Resp
Alpha-Iso-Resp = iso toResp toAlpha to-from from-to

Alphaâ‰ƒResp : Alpha â‰ƒ Resp
Alphaâ‰ƒResp = isoToEquiv Alpha-Iso-Resp

Alphaâ‰¡Resp : Alpha â‰¡ Resp
Alphaâ‰¡Resp = ua Alphaâ‰ƒResp
