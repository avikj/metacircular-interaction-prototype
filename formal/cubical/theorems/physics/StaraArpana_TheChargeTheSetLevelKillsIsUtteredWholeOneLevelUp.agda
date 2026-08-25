{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- स्तर-अर्पण — offering by stratum.  A REAL question, asked because its
-- answer was not known to the asker: KramaSaha proves the set-level
-- kills the circle's charge (its क्रमः-सेट्-प्रथमम्: Path ∥S¹∥₂ is
-- contractible) while the other order keeps it (क्रमः-लूप-प्रथमम्:
-- ∥ΩS¹∥₂ ≃ ℤ).  Is the charge DESTROYED — or WITHHELD, and uttered
-- whole one level up?
--
-- ANSWERED HERE, by composition of library and corpus terms:
--
--     Ω (∥ S¹ ∥ 3)  ≃  ℤ
--
-- the same truncation FAMILY that annihilated the charge at h-level 2
-- carries it in full at h-level 3.  Truncation did not destroy the
-- charge; it withheld it for one stratum.  So the doctrine refines:
-- "the order of standpoints is the charge" (KramaSaha) grades into
-- "the charge the simultaneous assertion cannot utter at level n is
-- uttered whole at level n+1" — अर्पित / अनर्पित: what one stratum
-- withholds (anarpita), the next offers (arpita).
--
-- SOURCES AND SCOPE (the six rules).  The level-shift engine is the
-- LIBRARY's PathIdTruncIso (Cubical.HITs.Truncation.Properties; the
-- shift Ω∥X∥ₙ₊₁ ≃ ∥ΩX∥ₙ is standard HoTT — this module's content is
-- its INSTANTIATION at the corpus's own charge, against KramaSaha's
-- checked pair, closing a question the corpus's doctrine left open).
-- The word-pair arpita/anarpita is Umāsvāti, Tattvārthasūtra 5.31
-- (अर्पितानर्पितसिद्धेः — establishment from the emphasized and the
-- non-emphasized), taken as the READING of standpoint-graded
-- establishment; the sūtra is not claimed to grade truncations by
-- h-level.  The stratum grading is this repository's statement.
--
-- Composed through नाडी against the warm kernel.
------------------------------------------------------------------------

module StaraArpana_TheChargeTheSetLevelKillsIsUtteredWholeOneLevelUp where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (isoToEquiv)
open import Cubical.Data.Int using (ℤ)
open import Cubical.HITs.S1 using (S¹ ; base)
open import Cubical.HITs.Truncation
  using (∥_∥_ ; ∣_∣ₕ ; PathIdTruncIso)
open import Cubical.HITs.SetTruncation using (∥_∥₂)
open import Cubical.HITs.Truncation.Properties using (setTrunc≃Trunc2)

open import KramaSaha_TheOrderOfStandpointsIsTheChargeItself
  using (क्रमः-लूप-प्रथमम्)

------------------------------------------------------------------------
-- the charge, one level up: the loop space of the 3-truncated circle
-- is the whole of ℤ.  Where ∥S¹∥₂'s loop space was a point, ∥S¹∥ 3's
-- carries every winding number.
------------------------------------------------------------------------

चक्र-त्रि-स्तरे : (Path (∥ S¹ ∥ 3) ∣ base ∣ₕ ∣ base ∣ₕ) ≃ ℤ
चक्र-त्रि-स्तरे =
  compEquiv (isoToEquiv (PathIdTruncIso 2))
    (compEquiv (invEquiv setTrunc≃Trunc2) क्रमः-लूप-प्रथमम्)
