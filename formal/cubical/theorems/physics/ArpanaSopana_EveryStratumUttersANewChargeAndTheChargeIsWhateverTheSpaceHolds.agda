{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ‡‡∞‡‡‡-‡‡ã‡‡æ‡®‡Æ‡ ‚î the ladder of offerings.
--
-- THE QUESTIONS, in the stratum vocabulary this corpus has been building
-- (KramaSaha ‚í StaraArpana ‚í AyamaArpana ‚í AnantaraArpana):
--
--   1. Is the charge always ‚?  Or is "the charge" whatever the space
--      holds ‚î a product, a NONABELIAN group?
--   2. AnantaraArpana showed the stratum above silence utters the whole
--      charge.  Does the NEXT stratum utter nothing new ‚î or does every
--      stratum utter a NEW charge?
--
-- ANSWERED HERE.  The master law is space-generic and is TWO library
-- terms composed:
--
--   ‡‡æ‡Æ‡æ‡®‡‡Ø‡Æ‡ :  Œ©µê‚∫¬ (‚à A ‚à (3+m))  ‚â  œ‚ò‚ä‚(A)        for EVERY pointed A
--
-- the (3+m)-th stratum of ANY space, looped m+1 times, is exactly its
-- (m+1)-th homotopy group ‚î because the loop space sits two strata
-- below the truncation ceiling and is therefore already a set, so the
-- set-truncation in œ's definition peels off (setTruncIdempotent), and
-- œTruncIso finishes.  Then:
--
--   ‡‡ã‡‡æ‡®‡Æ‡   Œ©¬≥(‚àS¬≤‚à‚) ‚â ‚ ‚î the SECOND rung of S¬≤'s ladder.  Stratum 4
--            uttered œ‚S¬≤ = ‚ (AnantaraArpana); stratum 5 utters ANOTHER
--            whole ‚, and this one is the Hopf charge œ‚S¬≤.  Every
--            stratum utters a new charge; the sphere is a ladder, not a
--            lamp that switches on once.
--   ‡µ‡≤‡Ø‡Æ‡    Œ©(‚àT¬≤‚à‚) ‚â ‚ ó ‚ ‚î the torus's charge is the PAIR, both
--            winding numbers, whole at its own first stratum above
--            silence.
--   ‡ó‡‡‡‡‡Æ‡   Œ©(‚àBouquet A‚à‚) ‚â FreeGroup A ‚î the bouquet's charge is
--            the free group: NONABELIAN.  The displacement law is about
--            strata, not about ‚; the charge is whatever the space holds.
--
-- SOURCES.  The engines are the LIBRARY's:
-- isSetŒ©Trunc + œTruncIso (Cubical.Homotopy.Group.Base), œ‚ôS‚ø‚â‚ and
-- œ'Gr‚âœGr (PinSn, Base), œ‚S¬≤‚â‚ (Pi3S2 ‚î Brunerie's line), Œ©Torus‚â°‚ó‚
-- (HITs.Torus.Base), œ‚Bouquet‚â°FreeGroup
-- (HITs.Bouquet.FundamentalGroupProof).  This module's content is the
-- COMPOSITION into the generic law and its three new charge readings.
-- ‡‡ã‡‡æ‡® (staircase), ‡µ‡≤‡Ø (ring/torus), ‡ó‡‡‡‡ (bunch/bouquet) are
-- ordinary  used as labels; ‡‡∞‡‡‡ø‡/‡‡®‡∞‡‡‡ø‡ is Umsvti,
-- Tattvrthastra 5.31, as the READING of stratum-graded establishment
-- (per StaraArpana).
------------------------------------------------------------------------

module ArpanaSopana_EveryStratumUttersANewChargeAndTheChargeIsWhateverTheSpaceHolds where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (isoToEquiv ; invIso)
open import Cubical.Foundations.Univalence using (pathToEquiv)
open import Cubical.Foundations.Pointed using (Pointed ; typ)
open import Cubical.Foundations.HLevels using (isSet√ó)
open import Cubical.Data.Nat using (‚Ñï ; suc ; _+_)
open import Cubical.Data.Int using (‚Ñ§ ; isSet‚Ñ§)
open import Cubical.Data.Sigma using (_√ó_)
open import Cubical.HITs.Sn using (S‚Çä‚àô)
open import Cubical.HITs.S1 using (S¬π)
open import Cubical.HITs.Torus.Base using (Torus ; point ; Œ©Torus ; Œ©Torus‚â°‚Ñ§√ó‚Ñ§)
open import Cubical.HITs.Bouquet.Base using (Bouquet ; Bouquet‚àô ; base)
open import Cubical.HITs.Bouquet.FundamentalGroupProof
  using (œÄ‚ÇÅBouquet ; œÄ‚ÇÅBouquet‚â°FreeGroup)
open import Cubical.HITs.FreeGroup using (FreeGroup)
open import Cubical.HITs.Truncation using (hLevelTrunc‚àô)
open import Cubical.HITs.SetTruncation using (‚à•_‚à•‚ÇÇ ; setTruncIdempotentIso)
open import Cubical.Homotopy.Loopspace using (Œ©^_ ; Œ©)
open import Cubical.Homotopy.Group.Base
  using (œÄ ; œÄTruncIso ; isSetŒ©Trunc ; œÄ'Gr‚âÖœÄGr)
open import Cubical.Homotopy.Group.Pi3S2 using (œÄ‚ÇÉS¬≤‚âÖ‚Ñ§)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ‡‡æ‡Æ‡æ‡®‡‡Ø‡Æ‡ ‚î the master law, for EVERY pointed space: the (3+m)-th
-- stratum, looped m+1 times, IS the (m+1)-th homotopy group.  Two terms.
------------------------------------------------------------------------

‡§∏‡§æ‡§Æ‡§æ‡§®‡•ç‡§Ø‡§Æ‡•ç : (m : ‚Ñï) (A : Pointed ‚Ñì)
  ‚Üí typ ((Œ©^ suc m) (hLevelTrunc‚àô (3 + m) A)) ‚âÉ œÄ (suc m) A
‡§∏‡§æ‡§Æ‡§æ‡§®‡•ç‡§Ø‡§Æ‡•ç m A =
  compEquiv (isoToEquiv (invIso (setTruncIdempotentIso (isSetŒ©Trunc m))))
            (isoToEquiv (invIso (œÄTruncIso (suc m))))

------------------------------------------------------------------------
-- ‡‡ã‡‡æ‡®‡Æ‡ ‚î the second rung of S¬≤'s ladder: stratum 5 utters ANOTHER
-- whole ‚, and it is the Hopf charge œ‚S¬≤.
------------------------------------------------------------------------

‡§∏‡•ã‡§™‡§æ‡§®‡§Æ‡•ç : typ ((Œ©^ 3) (hLevelTrunc‚àô 5 (S‚Çä‚àô 2))) ‚âÉ ‚Ñ§
‡§∏‡•ã‡§™‡§æ‡§®‡§Æ‡•ç =
  compEquiv (‡§∏‡§æ‡§Æ‡§æ‡§®‡•ç‡§Ø‡§Æ‡•ç 2 (S‚Çä‚àô 2))
    (compEquiv (isoToEquiv (invIso (fst (œÄ'Gr‚âÖœÄGr 2 (S‚Çä‚àô 2)))))
      (fst œÄ‚ÇÉS¬≤‚âÖ‚Ñ§))

------------------------------------------------------------------------
-- ‡µ‡≤‡Ø‡Æ‡ ‚î the torus utters BOTH winding numbers, whole, at its first
-- stratum above silence.
------------------------------------------------------------------------

‡§µ‡§≤‡§Ø‡§Æ‡•ç : typ (Œ© (hLevelTrunc‚àô 3 (Torus , point))) ‚âÉ (‚Ñ§ √ó ‚Ñ§)
‡§µ‡§≤‡§Ø‡§Æ‡•ç =
  compEquiv (‡§∏‡§æ‡§Æ‡§æ‡§®‡•ç‡§Ø‡§Æ‡•ç 0 (Torus , point))
    (compEquiv
      (isoToEquiv (setTruncIdempotentIso
        (subst isSet (sym Œ©Torus‚â°‚Ñ§√ó‚Ñ§) (isSet√ó isSet‚Ñ§ isSet‚Ñ§))))
      (pathToEquiv Œ©Torus‚â°‚Ñ§√ó‚Ñ§))

------------------------------------------------------------------------
-- ‡ó‡‡‡‡‡Æ‡ ‚î the bouquet utters the FREE GROUP on its petals: the charge
-- need not be abelian.  The law is about strata, not about ‚.
------------------------------------------------------------------------

‡§ó‡•Å‡§ö‡•ç‡§õ‡§Æ‡•ç : {A : Type ‚Ñì}
  ‚Üí typ (Œ© (hLevelTrunc‚àô 3 (Bouquet‚àô A))) ‚âÉ FreeGroup A
‡§ó‡•Å‡§ö‡•ç‡§õ‡§Æ‡•ç {A = A} =
  compEquiv (‡§∏‡§æ‡§Æ‡§æ‡§®‡•ç‡§Ø‡§Æ‡•ç 0 (Bouquet‚àô A))
            (pathToEquiv (œÄ‚ÇÅBouquet‚â°FreeGroup {A = A}))
