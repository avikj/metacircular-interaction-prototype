{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- àà¨à¿à°àà§à¾à°à¿à â” neither channel inverts the sign section, and the host
-- already held the reason as theorems.  The two conjectured identities
-- augment (sign b) â‰¡ b and relative (sign b) â‰¡ b fail; the host's own
-- `augment-sign` proves the first composite is CONSTANTLY zero, and
-- `relative-sign` proves the second is the doubling map.  So both
-- close as road two, each with its smallest witness at b = pos 1:
-- the composites hit 0 and 2 respectively, never 1.
------------------------------------------------------------------------

module Ratri.Anirdharita_ChargeTwoHistories_AugmentRelativeSign where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„•; suc; snotz; znots)
open import Cubical.Data.Int using (â„¤; pos; injPos)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import NaturalMachine.ChargeTwoHistories
  using (augment; relative; sign; augment-sign; relative-sign)

one : â„¤
one = pos 1

-- augment âˆ˜ sign is constantly zero (host theorem), and 0 â‰ 1 in â:
augment-NOT-DETERMINED : augment (sign one) â‰¡ one â†’ âŠ¥
augment-NOT-DETERMINED p = znots (injPos (sym (augment-sign one) âˆ™ p))

-- relative âˆ˜ sign doubles (host theorem), and 2 â‰ 1 in â:
predâ„• : â„• â†’ â„•
predâ„• 0 = 0
predâ„• (suc n) = n

relative-NOT-DETERMINED : relative (sign one) â‰¡ one â†’ âŠ¥
relative-NOT-DETERMINED p =
  snotz (cong predâ„• (injPos (sym (relative-sign one) âˆ™ p)))
