{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MinPlusResiduationIsAGaloisConnectionAtOneCut
--
-- `TheSaturationClosureNeedsOnlyAGaloisConnection` reduced Î” 28
-- Â§31â“32's saturation obligation to exactly two lines, `galFwd` and
-- `galBwd`, for an abstract Galois connection.
--
-- Here they are proved at ONE CUT â” a single burden and a single
-- residual â” with the real min-plus data, not a stand-in.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE ORDER IS REVERSED, AND THAT IS THE WHOLE POINT.  In min-plus,
-- lower cost is better, so the quantale order is `a âŠ b = b â‰ â•-a`.
-- With â•'s own `â‰` the residuation is NOT a Galois connection and the
-- failure is not subtle: `âˆ` truncates, and `truncationBreaksTheNaiveOrder`
-- below exhibits `K = 0, Ï = 0, Ïˆ = 5` where one side holds and the
-- other does not.  Getting the direction right is not bookkeeping; it
-- is the difference between the obligation being dischargeable and
-- being false.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   âˆ-adjË¡ / âˆ-adjÊ³     the monus adjunction, K âˆ Ïˆ â‰ Ï  âŸº  K â‰ Ï + Ïˆ,
--                       which cubical v0.5 does not ship
--   galFwd / galBwd     both directions of the contravariant adjunction
--                       for `u = d = (K âˆ_)` under the reversed order â”
--                       and both are the SAME statement, since the two
--                       sides are `K â‰ Ï + Ïˆ` and `K â‰ Ïˆ + Ï`
--   MinPlusCut          the instantiation of `module Galois`, from which
--                       antitonicity, unit, counit, the triangles,
--                       idempotence of `c a = K âˆ (K âˆ a)`, and the
--                       fixed-point characterisation all follow with
--                       NOTHING re-proved
--   truncationBreakstheNaiveOrder
--                       the same maps under â•'s own order fail
--
-- So Î” 28 Â§31â“32's "re-saturate" is, at one cut, a checked closure over
-- genuine min-plus data: saturate once and stop.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- `(_âˆ b) âŠ (_+ b)` is the standard residuation in â• and
-- makes it a residuated monoid; that Isbell conjugation over a quantale
-- is a Galois connection is likewise standard (Lawvere's metric-space
-- reading of enriched categories, `Metric spaces, generalized logic,
-- and closed categories`, 1973, is where min-plus becomes the value
-- object).
------------------------------------------------------------------------

module MinPlusResiduationIsAGaloisConnectionAtOneCut where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
  using (â„• ; zero ; suc ; _+_ ; _âˆ¸_ ; +-zero ; +-suc ; +-comm ; snotz)
open import Cubical.Data.Nat.Order
  using (_â‰¤_ ; â‰¤-refl ; â‰¤-trans ; zero-â‰¤ ; suc-â‰¤-suc ; pred-â‰¤-pred)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Relation.Nullary using (Â¬_)

open import TheSaturationClosureNeedsOnlyAGaloisConnection
  using (module Galois)

------------------------------------------------------------------------
-- 1.  The monus adjunction, which v0.5 does not ship
------------------------------------------------------------------------

âˆ¸-adjË¡ : (K Ïˆ Ï† : â„•) â†’ K âˆ¸ Ïˆ â‰¤ Ï† â†’ K â‰¤ Ï† + Ïˆ
âˆ¸-adjË¡ K       zero     Ï† h = subst (K â‰¤_) (sym (+-zero Ï†)) h
âˆ¸-adjË¡ zero    (suc Ïˆ)  Ï† _ = zero-â‰¤
âˆ¸-adjË¡ (suc K) (suc Ïˆ)  Ï† h =
  subst (suc K â‰¤_) (sym (+-suc Ï† Ïˆ)) (suc-â‰¤-suc (âˆ¸-adjË¡ K Ïˆ Ï† h))

âˆ¸-adjÊ³ : (K Ïˆ Ï† : â„•) â†’ K â‰¤ Ï† + Ïˆ â†’ K âˆ¸ Ïˆ â‰¤ Ï†
âˆ¸-adjÊ³ K       zero     Ï† h = subst (K â‰¤_) (+-zero Ï†) h
âˆ¸-adjÊ³ zero    (suc Ïˆ)  Ï† _ = zero-â‰¤
âˆ¸-adjÊ³ (suc K) (suc Ïˆ)  Ï† h =
  âˆ¸-adjÊ³ K Ïˆ Ï† (pred-â‰¤-pred (subst (suc K â‰¤_) (+-suc Ï† Ïˆ) h))

------------------------------------------------------------------------
-- 2.  The min-plus order: lower cost is better, so â•'s â‰ is reversed
------------------------------------------------------------------------

module _ (K : â„•) where

  _âŠ‘_ : â„• â†’ â„• â†’ Type
  a âŠ‘ b = b â‰¤ a

  âŠ‘-refl : (a : â„•) â†’ a âŠ‘ a
  âŠ‘-refl a = â‰¤-refl

  âŠ‘-trans : (a b c : â„•) â†’ a âŠ‘ b â†’ b âŠ‘ c â†’ a âŠ‘ c
  âŠ‘-trans a b c ab bc = â‰¤-trans bc ab

  res : â„• â†’ â„•
  res Ï† = K âˆ¸ Ï†

  -- both directions are the same statement, once `+` is commuted
  galFwd : (a b : â„•) â†’ a âŠ‘ res b â†’ b âŠ‘ res a
  galFwd a b h =
    âˆ¸-adjÊ³ K a b (subst (K â‰¤_) (+-comm a b) (âˆ¸-adjË¡ K b a h))

  galBwd : (a b : â„•) â†’ b âŠ‘ res a â†’ a âŠ‘ res b
  galBwd a b h =
    âˆ¸-adjÊ³ K b a (subst (K â‰¤_) (+-comm b a) (âˆ¸-adjË¡ K a b h))

  -- and the whole closure theory follows with nothing re-proved
  open Galois _âŠ‘_ _âŠ‘_ âŠ‘-refl âŠ‘-trans âŠ‘-refl âŠ‘-trans res res galFwd galBwd
    public

------------------------------------------------------------------------
-- 3.  Under â•'s own order it is false, and truncation is why
--
-- With `K = 0`, `Ï = 0`, `Ïˆ = 5`: `Ï â‰ K âˆ Ïˆ` holds (both are 0) and
-- `Ïˆ â‰ K âˆ Ï` does not.  So the naive reading â” costs ordered upward â”
-- does not even give one direction of the adjunction.
------------------------------------------------------------------------

naiveHolds : 0 â‰¤ (0 âˆ¸ 5)
naiveHolds = zero-â‰¤

naiveFails : Â¬ (5 â‰¤ (0 âˆ¸ 0))
naiveFails (k , e) = snotz (sym (+-comm k 5) âˆ™ e)

truncationBreaksTheNaiveOrder :
  (0 â‰¤ (0 âˆ¸ 5)) Ã— (Â¬ (5 â‰¤ (0 âˆ¸ 0)))
truncationBreaksTheNaiveOrder = naiveHolds , naiveFails

------------------------------------------------------------------------
-- THE MEET, AND THE PROFILE CUT.  Both are in
-- `TheMeetIsMaxAndTheProfileCutIsAGaloisConnection`.
--
-- **The meet is `max`, not `min`.**  Â§2 here reverses â•'s order because
-- lower cost is better; a meet in a reversed order is a JOIN in the
-- original, so `â‰` over burdens is `max` in â•.  Writing "min-plus, so
-- take a min" names the operation by its role in the semiring rather
-- than by its role in the order â” the same error Â§2's reversal guards
-- against, one level up.
--
--   max / max-â‰Ë¡ / max-â‰Ê³ / max-least   the meet, with its universal
--                                       property
--   Profile ks                          profiles as a RECURSIVE FAMILY
--                                       over the kernel, so a length
--                                       mismatch is not representable
--   up ks Ï = â‹µ (kµ âˆ Ïµ) ,  dn ks Ïˆ = (kµ âˆ Ïˆ)µ
--   goFwd / goBwd                       both directions
--   ProfileCut                          `module Galois` instantiated
--
-- Profiles on BOTH sides:
-- `TheTwoSidedProfileCutNeedsTheBurdensAsAProfile` takes the
-- burdens as a profile so `UpP` produces a residual PROFILE;
-- `TheTwoSidedCutExistsOverANonEmptyResidualIndex` gives the
-- adjunction over a non-empty index; and
-- `TheTwoSidedCutNeedsNoInfinityBecauseTheEmptyMeetIsZero` removes the
-- restriction entirely, over an ARBITRARY residual index list with no
-- `âˆž` â” the empty meet is `0` by â•'s bottom rather than by choice.
------------------------------------------------------------------------
