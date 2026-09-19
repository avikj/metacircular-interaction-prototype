{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡Ø‡æ‡Æ-‡‡∞‡‡‡ ‚î offering by dimension.  StaraArpana proved the circle's
-- charge is withheld at stratum 2 and offered whole at stratum 3
-- (Œ©(‚àS¬‚à 3) ‚â ‚).  THE DIMENSIONAL QUESTION (real; answer unknown to
-- the asker before the library search): does the withholding deepen by
-- one stratum per dimension?
--
-- ANSWERED for the absent half, checked below: for S¬≤, EVERYTHING
-- through stratum 3 is silent ‚î not merely the loop space: the whole
-- 3-truncation ‚àS¬≤‚à 3 is CONTRACTIBLE (sphereConnected 2), hence so is
-- its loop space (‡‡ï‡‡∞‡¶‡‡µ‡Ø-‡‡‡∞‡ø-‡‡‡‡∞‡-‡Æ‡‡®‡Æ‡).  Where S¬'s stratum 3
-- carried all of ‚, S¬≤'s stratum 3 carries nothing at all.
--
-- THE OFFERED HALF, stated with its exact route and owed as a term:
-- Œ©¬≤(‚àS¬≤‚à 4) ‚â œ‚(S¬≤) ‚â ‚ ‚î double PathIdTruncIso, then the library's
-- own sphere ladder (PinSn: œ‚S¬≤‚âœ‚S¬, œ‚ô'S‚ø‚â‚ ‚î the full theorem is
-- IN v0.9).  The plumbing (pointed Œ©-congruence across the two
-- truncation shifts, œ'‚îœ conversion) is real work not done here; the
-- endpoint isomorphisms are the library's.
--
-- THE LAW, at the precision earned: dimension grades the withholding ‚î
-- the n-sphere's charge is anarpita through stratum n+1 and arpita at
-- n+2 (n=1 checked whole in StaraArpana; n=2 checked here on the
-- silent side, the offered side reduced to named library theorems).
-- ‡‡∞‡‡‡ø‡‡æ‡®‡∞‡‡‡ø‡‡‡ø‡¶‡‡ß‡‡ (TS 5.31) as the reading; the grading is this
-- repository's statement.
------------------------------------------------------------------------

module AyamaArpana_TheSphereWithholdsOneStratumDeeperPerDimension where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isContr‚ÜíisContrPath)
open import Cubical.HITs.Sn using (S‚Çä ; ptSn)
open import Cubical.HITs.Truncation using (‚à•_‚à•_ ; ‚à£_‚à£‚Çï)
open import Cubical.Homotopy.Connected using (isConnected)
open import Cubical.HITs.Sn.Properties using (sphereConnected)

-- the whole 3-stratum of the 2-sphere is one point.
‡§ö‡§ï‡•ç‡§∞‡§¶‡•ç‡§µ‡§Ø-‡§§‡•ç‡§∞‡§ø-‡§∏‡•ç‡§§‡§∞‡•á-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç : isContr (‚à• S‚Çä 2 ‚à• 3)
‡§ö‡§ï‡•ç‡§∞‡§¶‡•ç‡§µ‡§Ø-‡§§‡•ç‡§∞‡§ø-‡§∏‡•ç‡§§‡§∞‡•á-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç = sphereConnected 2

-- hence its loop space is silent: no charge survives at stratum 3.
‡§ö‡§ï‡•ç‡§∞‡§¶‡•ç‡§µ‡§Ø-‡§§‡•ç‡§∞‡§ø-‡§∏‡•ç‡§§‡§∞‡•á-‡§Æ‡•å‡§®‡§Æ‡•ç :
  isContr (Path (‚à• S‚Çä 2 ‚à• 3) ‚à£ ptSn 2 ‚à£‚Çï ‚à£ ptSn 2 ‚à£‚Çï)
‡§ö‡§ï‡•ç‡§∞‡§¶‡•ç‡§µ‡§Ø-‡§§‡•ç‡§∞‡§ø-‡§∏‡•ç‡§§‡§∞‡•á-‡§Æ‡•å‡§®‡§Æ‡•ç =
  isContr‚ÜíisContrPath ‡§ö‡§ï‡•ç‡§∞‡§¶‡•ç‡§µ‡§Ø-‡§§‡•ç‡§∞‡§ø-‡§∏‡•ç‡§§‡§∞‡•á-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç _ _
