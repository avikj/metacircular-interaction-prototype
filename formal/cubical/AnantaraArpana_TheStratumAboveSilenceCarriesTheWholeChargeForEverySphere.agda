-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- अनन्तर-अर्पण — the offering at the stratum WITHOUT INTERVAL.
--
-- THE QUESTION, asked because its answer was not known to the asker.
-- The displacement law this corpus keeps meeting says truncation never
-- destroys a charge; it withholds it.  The checked instances so far:
--
--   KramaSaha    S¹: the set-level kills the winding (Path ∥S¹∥₂
--                contractible) while ∥ΩS¹∥₂ ≃ ℤ — order IS the charge.
--   StaraArpana  S¹: one stratum up the charge is uttered whole,
--                Ω(∥S¹∥₃) ≃ ℤ.
--   AyamaArpana  S²: the sphere withholds one stratum deeper per
--                dimension — ∥S²∥₃ is contractible, all of it.
--
-- Open: is there an intermediate regime?  A stratum at which the sphere
-- utters SOMETHING but not the whole ℤ — a partial charge between the
-- silence and the full utterance?
--
-- ANSWERED HERE, for EVERY sphere, by composition of library terms and
-- with no new machinery: NO.  The adjacency is perfect —
--
--   मौनम्    :  ∥ Sⁿ⁺¹ ∥ (2+n)  is contractible          (total silence)
--   अनन्तरम् :  Ωⁿ⁺¹ (∥ Sⁿ⁺¹ ∥ (3+n))  ≃  ℤ              (whole charge)
--
-- The FIRST stratum above the last silent one already carries every
-- winding number.  There is no stratum of partial speech: the charge
-- arrives whole or not at all.  (At strata BELOW the silence boundary
-- the truncation is contractible a fortiori by the same connectivity.)
--
-- SOURCES AND SCOPE (the six rules).  The engines are the LIBRARY's:
-- sphereConnected (Cubical.HITs.Sn.Properties) for the silence;
-- πTruncIso and isSetΩTrunc (Cubical.Homotopy.Group.Base) and
-- πₙSⁿ≅ℤ (Cubical.Homotopy.Group.PinSn) for the utterance.  This
-- module's content is their COMPOSITION into the adjacency statement,
-- closing the question the corpus's own doctrine left open.  The
-- reading-word अर्पित/अनर्पित is Umāsvāti, Tattvārthasūtra 5.31
-- (अर्पितानर्पितसिद्धेः), as in StaraArpana: the sūtra names
-- establishment from the emphasized and the non-emphasized aspect and
-- is NOT claimed to grade truncations by h-level.  अनन्तर (without
-- interval, immediately adjacent) is ordinary Sanskrit; the compound
-- अनन्तर-अर्पण is built here and claimed of no source.
--
-- Composed against the warm kernel; the library was read first
-- (Group/Base 655–810, PinSn 116–186) and the terms fit on the first
-- assembly — the derivation preceded the check, per the protocol.
------------------------------------------------------------------------

module AnantaraArpana_TheStratumAboveSilenceCarriesTheWholeChargeForEverySphere where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (isoToEquiv ; invIso)
open import Cubical.Foundations.Pointed using (typ)
open import Cubical.Data.Nat using (ℕ ; suc ; _+_)
open import Cubical.Data.Int using (ℤ)
open import Cubical.HITs.Sn using (S₊ ; S₊∙)
open import Cubical.HITs.Sn.Properties using (sphereConnected)
open import Cubical.HITs.Truncation using (hLevelTrunc ; hLevelTrunc∙)
open import Cubical.HITs.SetTruncation using (setTruncIdempotentIso)
open import Cubical.Homotopy.Loopspace using (Ω^_)
open import Cubical.Homotopy.Group.Base using (π ; πTruncIso ; isSetΩTrunc)
open import Cubical.Homotopy.Group.PinSn using (πₙSⁿ≅ℤ)

------------------------------------------------------------------------
-- मौनम् — the silence: through stratum 2+n the (n+1)-sphere utters
-- nothing at all.  (AyamaArpana's ∥S²∥₃, for every dimension.)
------------------------------------------------------------------------

मौनम् : (n : ℕ) → isContr (hLevelTrunc (2 + n) (S₊ (suc n)))
मौनम् n = sphereConnected (suc n)

------------------------------------------------------------------------
-- अनन्तरम् — the very next stratum utters the charge WHOLE.  The loop
-- space Ωⁿ⁺¹ of the (3+n)-truncated (n+1)-sphere is a set (it sits two
-- strata below the truncation level), its set-truncation is therefore
-- itself, and πTruncIso carries it to πₙ₊₁(Sⁿ⁺¹) ≅ ℤ.
------------------------------------------------------------------------

अनन्तरम् : (n : ℕ)
  → typ ((Ω^ suc n) (hLevelTrunc∙ (3 + n) (S₊∙ (suc n)))) ≃ ℤ
अनन्तरम् n =
  compEquiv (isoToEquiv (invIso (setTruncIdempotentIso (isSetΩTrunc n))))
    (compEquiv (isoToEquiv (invIso (πTruncIso (suc n))))
      (isoToEquiv (fst (πₙSⁿ≅ℤ n))))

------------------------------------------------------------------------
-- the S² instance by name, adjacent to AyamaArpana's silence: the
-- charge withheld two strata (∥S²∥₃ contractible) is uttered whole at
-- the fourth.
------------------------------------------------------------------------

चक्रद्वये-चतुर्थ-स्तरे :
  typ ((Ω^ 2) (hLevelTrunc∙ 4 (S₊∙ 2))) ≃ ℤ
चक्रद्वये-चतुर्थ-स्तरे = अनन्तरम् 1
