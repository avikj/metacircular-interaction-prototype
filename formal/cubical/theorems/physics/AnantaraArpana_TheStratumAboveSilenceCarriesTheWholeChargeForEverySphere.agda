{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ‡‡®‡®‡‡‡∞-‡‡∞‡‡‡ ‚î the offering at the stratum WITHOUT INTERVAL.
--
-- THE QUESTION.
-- The displacement law this corpus keeps meeting says truncation never
-- destroys a charge; it withholds it.  The checked instances:
--
--   OrderSaha    S¬: the set-level kills the winding (Path ‚àS¬‚à‚
--                contractible) while ‚àŒ©S¬‚à‚ ‚â ‚ ‚î order IS the charge.
--   StaraArpana  S¬: one stratum up the charge is uttered whole,
--                Œ©(‚àS¬‚à‚) ‚â ‚.
--   AyamaArpana  S¬≤: the sphere withholds one stratum deeper per
--                dimension ‚î ‚àS¬≤‚à‚ is contractible, all of it.
--
-- Is there an intermediate regime?  A stratum at which the sphere
-- utters SOMETHING but not the whole ‚ ‚î a partial charge between the
-- silence and the full utterance?
--
-- ANSWERED HERE, for EVERY sphere, by composition of library terms and
-- with no new machinery: NO.  The adjacency is perfect ‚î
--
--   ‡Æ‡‡®‡Æ‡    :  ‚à S‚ø‚∫¬ ‚à (2+n)  is contractible          (total silence)
--   ‡‡®‡®‡‡‡∞‡Æ‡ :  Œ©‚ø‚∫¬ (‚à S‚ø‚∫¬ ‚à (3+n))  ‚â  ‚              (whole charge)
--
-- The FIRST stratum above the last silent one already carries every
-- winding number.  There is no stratum of partial speech: the charge
-- arrives whole or not at all.  (At strata BELOW the silence boundary
-- the truncation is contractible a fortiori by the same connectivity.)
--
-- SOURCES AND SCOPE (the six rules).  The engines are the LIBRARY's:
-- sphereConnected (Cubical.HITs.Sn.Properties) for the silence;
-- œTruncIso and isSetŒ©Trunc (Cubical.Homotopy.Group.Base) and
-- œ‚ôS‚ø‚â‚ (Cubical.Homotopy.Group.PinSn) for the utterance.  This
-- module's content is their COMPOSITION into the adjacency statement.
-- The reading-word ‡‡∞‡‡‡ø‡/‡‡®‡∞‡‡‡ø‡ is Umsvti, Tattvrthastra 5.31
-- (‡‡∞‡‡‡ø‡‡æ‡®‡∞‡‡‡ø‡‡‡ø‡¶‡‡ß‡‡), as in StaraArpana: the stra names
-- establishment from the emphasized and the non-emphasized aspect and
-- is NOT claimed to grade truncations by h-level.  ‡‡®‡®‡‡‡∞ (without
-- interval, immediately adjacent) is ordinary ; the compound
-- ‡‡®‡®‡‡‡∞-‡‡∞‡‡‡ is built here and claimed of no source.
------------------------------------------------------------------------

module AnantaraArpana_TheStratumAboveSilenceCarriesTheWholeChargeForEverySphere where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Isomorphism using (isoToEquiv ; invIso)
open import Cubical.Foundations.Pointed using (typ)
open import Cubical.Data.Nat using (‚Ñï ; suc ; _+_)
open import Cubical.Data.Int using (‚Ñ§)
open import Cubical.HITs.Sn using (S‚Çä ; S‚Çä‚àô)
open import Cubical.HITs.Sn.Properties using (sphereConnected)
open import Cubical.HITs.Truncation using (hLevelTrunc ; hLevelTrunc‚àô)
open import Cubical.HITs.SetTruncation using (setTruncIdempotentIso)
open import Cubical.Homotopy.Loopspace using (Œ©^_)
open import Cubical.Homotopy.Group.Base using (œÄ ; œÄTruncIso ; isSetŒ©Trunc)
open import Cubical.Homotopy.Group.PinSn using (œÄ‚ÇôS‚Åø‚âÖ‚Ñ§)

------------------------------------------------------------------------
-- ‡Æ‡‡®‡Æ‡ ‚î the silence: through stratum 2+n the (n+1)-sphere utters
-- nothing at all.  (AyamaArpana's ‚àS¬≤‚à‚, for every dimension.)
------------------------------------------------------------------------

‡§Æ‡•å‡§®‡§Æ‡•ç : (n : ‚Ñï) ‚Üí isContr (hLevelTrunc (2 + n) (S‚Çä (suc n)))
‡§Æ‡•å‡§®‡§Æ‡•ç n = sphereConnected (suc n)

------------------------------------------------------------------------
-- ‡‡®‡®‡‡‡∞‡Æ‡ ‚î the very next stratum utters the charge WHOLE.  The loop
-- space Œ©‚ø‚∫¬ of the (3+n)-truncated (n+1)-sphere is a set (it sits two
-- strata below the truncation level), its set-truncation is therefore
-- itself, and œTruncIso carries it to œ‚ô‚ä‚(S‚ø‚∫¬) ‚â ‚.
------------------------------------------------------------------------

‡§Ö‡§®‡§®‡•ç‡§§‡§∞‡§Æ‡•ç : (n : ‚Ñï)
  ‚Üí typ ((Œ©^ suc n) (hLevelTrunc‚àô (3 + n) (S‚Çä‚àô (suc n)))) ‚âÉ ‚Ñ§
‡§Ö‡§®‡§®‡•ç‡§§‡§∞‡§Æ‡•ç n =
  compEquiv (isoToEquiv (invIso (setTruncIdempotentIso (isSetŒ©Trunc n))))
    (compEquiv (isoToEquiv (invIso (œÄTruncIso (suc n))))
      (isoToEquiv (fst (œÄ‚ÇôS‚Åø‚âÖ‚Ñ§ n))))

------------------------------------------------------------------------
-- the S¬≤ instance by name, adjacent to AyamaArpana's silence: the
-- charge withheld two strata (‚àS¬≤‚à‚ contractible) is uttered whole at
-- the fourth.
------------------------------------------------------------------------

‡§ö‡§ï‡•ç‡§∞‡§¶‡•ç‡§µ‡§Ø‡•á-‡§ö‡§§‡•Å‡§∞‡•ç‡§•-‡§∏‡•ç‡§§‡§∞‡•á :
  typ ((Œ©^ 2) (hLevelTrunc‚àô 4 (S‚Çä‚àô 2))) ‚âÉ ‚Ñ§
‡§ö‡§ï‡•ç‡§∞‡§¶‡•ç‡§µ‡§Ø‡•á-‡§ö‡§§‡•Å‡§∞‡•ç‡§•-‡§∏‡•ç‡§§‡§∞‡•á = ‡§Ö‡§®‡§®‡•ç‡§§‡§∞‡§Æ‡•ç 1
