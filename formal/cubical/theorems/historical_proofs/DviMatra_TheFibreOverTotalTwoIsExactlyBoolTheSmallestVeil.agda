{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡¶‡‡µ‡ø-‡Æ‡æ‡‡‡∞‡æ ‚î the fibre over total two is exactly Bool, the smallest veil.
--
-- Virahka (c. 600-800 CE, Vttajtisamuccaya) on Pigala's
-- Chandastra: the mtr-fibre over n splits as the fibre over n-1
-- with the fibre over n-2 (that is ‡µ‡ø‡∞‡‡æ‡ô‡‡ï-‡‡µ‡‡‡‡‡ø‡, already proved).
-- Pigala's map keeps only the TOTAL and forgets the sequence, and the
-- FIRST total at which it forgets anything is 2: below 2 the fibre is a
-- point (‡‡¶‡ø-‡‡‡®‡‡Ø‡Æ‡, ‡‡¶‡ø-‡‡ï‡Æ‡), and at exactly 2 there are precisely two
-- sequences ‚î laghu-laghu and guru.  This composes the recurrence at n=0
-- with the two contractible base fibres and Bool ‚â Unit ‚ä Unit, giving
--
--        fiber ‡‡®‡‡¶‡ 2  ‚â  Bool
--
-- on the nose: the first loss is exactly one bit.  This is Dvayam's
-- "two is the smallest veil there is" made concrete at the boundary of
-- prosody, and it is the exact numerical statement that the Virahka
-- count at 2 equals 1 + 1, seen as an identification of fibres rather
-- than an equality of numbers.
--
-- No new mathematics: every part is consumed, not reproved ‚î the fibre
-- recurrence and both base contractions are Virahanka's own; ‚ä-equiv,
-- isContr‚í‚âUnit and Iso-‚ä‚ä‚ä-Bool are the cubical library's.  TERM ‡¶‡‡µ‡ø-‡Æ‡æ‡‡‡∞‡æ (two morae), Chandastra
-- vocabulary; substrate cubical (Voevodsky).
------------------------------------------------------------------------

module DviMatra_TheFibreOverTotalTwoIsExactlyBoolTheSmallestVeil where

open import Cubical.Foundations.Equiv using (_‚âÉ_ ; compEquiv ; fiber)
open import Cubical.Foundations.Isomorphism using (isoToEquiv)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Bool.Properties using (Iso-‚ä§‚äé‚ä§-Bool)
open import Cubical.Data.Sum using (‚äé-equiv)
open import Cubical.Data.Unit using (Unit)
open import Cubical.Data.Unit.Properties using (isContr‚Üí‚âÉUnit)

import Virahanka_TheMatraFibreSatisfiesTheTwoStepRecurrence as V

-- fiber ‡‡®‡‡¶‡ 2 ‚â (fiber ‡‡®‡‡¶‡ 1 ‚ä fiber ‡‡®‡‡¶‡ 0)      -- the recurrence at 0
--             ‚â (Unit ‚ä Unit)                           -- both bases a point
--             ‚â Bool                                    -- the bi-point type
‡§¶‡•ç‡§µ‡§ø-‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§µ‡§∞‡§£‡§Æ‡•ç : fiber V.‡§õ‡§®‡•ç‡§¶‡§É 2 ‚âÉ Bool
‡§¶‡•ç‡§µ‡§ø-‡§Æ‡§æ‡§§‡•ç‡§∞‡§æ-‡§µ‡§∞‡§£‡§Æ‡•ç =
  compEquiv (V.‡§µ‡§ø‡§∞‡§π‡§æ‡§ô‡•ç‡§ï-‡§Ü‡§µ‡•É‡§§‡•ç‡§§‡§ø‡§É 0)
    (compEquiv
      (‚äé-equiv (isContr‚Üí‚âÉUnit V.‡§Ü‡§¶‡§ø-‡§è‡§ï‡§Æ‡•ç) (isContr‚Üí‚âÉUnit V.‡§Ü‡§¶‡§ø-‡§∂‡•Ç‡§®‡•ç‡§Ø‡§Æ‡•ç))
      (isoToEquiv Iso-‚ä§‚äé‚ä§-Bool))
