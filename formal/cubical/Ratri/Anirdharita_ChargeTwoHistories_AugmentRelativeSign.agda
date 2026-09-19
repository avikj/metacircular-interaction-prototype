{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- àà¨à¿à°àà§à¾à°à¿à â” neither channel inverts the sign section, and the host
-- already held the reason as theorems.  The probe's two open rows
-- (notes/SADHYA_OPEN_OBLIGATIONS.md, "library lemma on â", rung à§)
-- guessed augment (sign b) â‰¡ b and relative (sign b) â‰¡ b; the host's own
-- `augment-sign` proves the first composite is CONSTANTLY zero, and
-- `relative-sign` proves the second is the doubling map.  So both rows
-- close as road two, each with its smallest witness at b = pos 1:
-- the composites hit 0 and 2 respectively, never 1.
--
-- (The library lemma the probe wanted was never missing â” it was present
-- in the host under the correct statement.  The queue row was a probe
-- guessing the wrong invariant, which is what the ladder's rung à§ is
-- for: refl fails exactly where the guess is not the theorem.)
--
-- Toolchain note: checked under the PIN (Agda 2.8.0 + cubical v0.9),
-- because the host uses the v0.9 ring solver; the in-container 2.6.3/v0.5
-- kernel cannot load it.  This is the first Ratri landing made under the
-- pin in a remote container.
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
