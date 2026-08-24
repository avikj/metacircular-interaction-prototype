-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- अर्पण-सोपानम् — the ladder of offerings.
--
-- THE QUESTIONS, asked because their answers were not known to the
-- asker, in the stratum vocabulary this corpus has been building
-- (KramaSaha → StaraArpana → AyamaArpana → AnantaraArpana):
--
--   1. Is the charge always ℤ?  Or is "the charge" whatever the space
--      holds — a product, a NONABELIAN group?
--   2. AnantaraArpana showed the stratum above silence utters the whole
--      charge.  Does the NEXT stratum utter nothing new — or does every
--      stratum utter a NEW charge?
--
-- ANSWERED HERE.  The master law is space-generic and is TWO library
-- terms composed:
--
--   सामान्यम् :  Ωᵐ⁺¹ (∥ A ∥ (3+m))  ≃  πₘ₊₁(A)        for EVERY pointed A
--
-- the (3+m)-th stratum of ANY space, looped m+1 times, is exactly its
-- (m+1)-th homotopy group — because the loop space sits two strata
-- below the truncation ceiling and is therefore already a set, so the
-- set-truncation in π's definition peels off (setTruncIdempotent), and
-- πTruncIso finishes.  Then:
--
--   सोपानम्   Ω³(∥S²∥₅) ≃ ℤ — the SECOND rung of S²'s ladder.  Stratum 4
--            uttered π₂S² = ℤ (AnantaraArpana); stratum 5 utters ANOTHER
--            whole ℤ, and this one is the Hopf charge π₃S².  Every
--            stratum utters a new charge; the sphere is a ladder, not a
--            lamp that switches on once.
--   वलयम्    Ω(∥T²∥₃) ≃ ℤ × ℤ — the torus's charge is the PAIR, both
--            winding numbers, whole at its own first stratum above
--            silence.
--   गुच्छम्   Ω(∥Bouquet A∥₃) ≃ FreeGroup A — the bouquet's charge is
--            the free group: NONABELIAN.  The displacement law is about
--            strata, not about ℤ; the charge is whatever the space holds.
--
-- SOURCES AND SCOPE (the six rules).  The engines are the LIBRARY's:
-- isSetΩTrunc + πTruncIso (Cubical.Homotopy.Group.Base), πₙSⁿ≅ℤ and
-- π'Gr≅πGr (PinSn, Base), π₃S²≅ℤ (Pi3S2 — Brunerie's line), ΩTorus≡ℤ×ℤ
-- (HITs.Torus.Base), π₁Bouquet≡FreeGroup
-- (HITs.Bouquet.FundamentalGroupProof).  This module's content is the
-- COMPOSITION into the generic law and its three new charge readings.
-- सोपान (staircase), वलय (ring/torus), गुच्छ (bunch/bouquet) are
-- ordinary Sanskrit used as labels; अर्पित/अनर्पित is Umāsvāti,
-- Tattvārthasūtra 5.31, as the READING of stratum-graded establishment
-- (per StaraArpana); no source is claimed to grade truncations.
--
-- Derivation preceded the check: the library was read (Group/Base
-- 639–810, Pi3S2 112, Torus 52–76, Bouquet/FundamentalGroupProof
-- 289–295) and every term below was composed on paper first.
------------------------------------------------------------------------

module ArpanaSopana_EveryStratumUttersANewChargeAndTheChargeIsWhateverTheSpaceHolds where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (isoToEquiv ; invIso)
open import Cubical.Foundations.Univalence using (pathToEquiv)
open import Cubical.Foundations.Pointed using (Pointed ; typ)
open import Cubical.Foundations.HLevels using (isSet×)
open import Cubical.Data.Nat using (ℕ ; suc ; _+_)
open import Cubical.Data.Int using (ℤ ; isSetℤ)
open import Cubical.Data.Sigma using (_×_)
open import Cubical.HITs.Sn using (S₊∙)
open import Cubical.HITs.S1 using (S¹)
open import Cubical.HITs.Torus.Base using (Torus ; point ; ΩTorus ; ΩTorus≡ℤ×ℤ)
open import Cubical.HITs.Bouquet.Base using (Bouquet ; Bouquet∙ ; base)
open import Cubical.HITs.Bouquet.FundamentalGroupProof
  using (π₁Bouquet ; π₁Bouquet≡FreeGroup)
open import Cubical.HITs.FreeGroup using (FreeGroup)
open import Cubical.HITs.Truncation using (hLevelTrunc∙)
open import Cubical.HITs.SetTruncation using (∥_∥₂ ; setTruncIdempotentIso)
open import Cubical.Homotopy.Loopspace using (Ω^_ ; Ω)
open import Cubical.Homotopy.Group.Base
  using (π ; πTruncIso ; isSetΩTrunc ; π'Gr≅πGr)
open import Cubical.Homotopy.Group.Pi3S2 using (π₃S²≅ℤ)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- सामान्यम् — the master law, for EVERY pointed space: the (3+m)-th
-- stratum, looped m+1 times, IS the (m+1)-th homotopy group.  Two terms.
------------------------------------------------------------------------

सामान्यम् : (m : ℕ) (A : Pointed ℓ)
  → typ ((Ω^ suc m) (hLevelTrunc∙ (3 + m) A)) ≃ π (suc m) A
सामान्यम् m A =
  compEquiv (isoToEquiv (invIso (setTruncIdempotentIso (isSetΩTrunc m))))
            (isoToEquiv (invIso (πTruncIso (suc m))))

------------------------------------------------------------------------
-- सोपानम् — the second rung of S²'s ladder: stratum 5 utters ANOTHER
-- whole ℤ, and it is the Hopf charge π₃S².
------------------------------------------------------------------------

सोपानम् : typ ((Ω^ 3) (hLevelTrunc∙ 5 (S₊∙ 2))) ≃ ℤ
सोपानम् =
  compEquiv (सामान्यम् 2 (S₊∙ 2))
    (compEquiv (isoToEquiv (invIso (fst (π'Gr≅πGr 2 (S₊∙ 2)))))
      (fst π₃S²≅ℤ))

------------------------------------------------------------------------
-- वलयम् — the torus utters BOTH winding numbers, whole, at its first
-- stratum above silence.
------------------------------------------------------------------------

वलयम् : typ (Ω (hLevelTrunc∙ 3 (Torus , point))) ≃ (ℤ × ℤ)
वलयम् =
  compEquiv (सामान्यम् 0 (Torus , point))
    (compEquiv
      (isoToEquiv (setTruncIdempotentIso
        (subst isSet (sym ΩTorus≡ℤ×ℤ) (isSet× isSetℤ isSetℤ))))
      (pathToEquiv ΩTorus≡ℤ×ℤ))

------------------------------------------------------------------------
-- गुच्छम् — the bouquet utters the FREE GROUP on its petals: the charge
-- need not be abelian.  The law is about strata, not about ℤ.
------------------------------------------------------------------------

गुच्छम् : {A : Type ℓ}
  → typ (Ω (hLevelTrunc∙ 3 (Bouquet∙ A))) ≃ FreeGroup A
गुच्छम् {A = A} =
  compEquiv (सामान्यम् 0 (Bouquet∙ A))
            (pathToEquiv (π₁Bouquet≡FreeGroup {A = A}))
