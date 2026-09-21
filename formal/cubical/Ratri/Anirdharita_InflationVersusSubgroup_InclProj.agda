{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡®‡ø‡∞‡‡ß‡æ‡∞‡ø‡ ‚î incl does not section proj, and the host's own subject is
-- why.  The identity incl (proj z) ‚â° z fails: incl includes
-- the KERNEL N = {z0, z2} of proj, not a complement of it: proj z1 = e1
-- and incl e1 = z2, so the composite carries z1 to z2 ‚î one step around
-- the extension.  ‚/4 is a non-split extension of ‚/2 by ‚/2; a section
-- of proj through incl would split it.
-- Road two, witness z1.
------------------------------------------------------------------------

module Ratri.Anirdharita_InflationVersusSubgroup_InclProj where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool; true; false; true‚â¢false)
open import Cubical.Data.Empty as Empty using (‚ä•)
open import NaturalMachine.InflationVersusSubgroup using (Z4; z0; z1; z2; z3; proj; incl)

-- The composite moves z1:
composite-lands : incl (proj z1) ‚â° z2
composite-lands = refl

-- and z1, z2 are distinct, separated by a Bool-valued observable:
isZ1 : Z4 ‚Üí Bool
isZ1 z0 = false ; isZ1 z1 = true ; isZ1 z2 = false ; isZ1 z3 = false

z1‚â¢z2 : z1 ‚â° z2 ‚Üí ‚ä•
z1‚â¢z2 p = true‚â¢false (cong isZ1 p)

-- THE VERDICT.  Green here means the field is NOT determined:
-- incl ‚àò proj is not the identity ‚î the extension does not split
-- through the kernel.
NOT-DETERMINED : incl (proj z1) ‚â° z1 ‚Üí ‚ä•
NOT-DETERMINED p = z1‚â¢z2 (sym p)
