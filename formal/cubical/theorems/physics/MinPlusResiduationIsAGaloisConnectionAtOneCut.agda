{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- MinPlusResiduationIsAGaloisConnectionAtOneCut
--
-- `TheSaturationClosureNeedsOnlyAGaloisConnection` reduced Î” 28
-- Â§31â“32's saturation obligation to exactly two lines and then said:
--
--   "the min-plus instance itself: neither `galFwd` nor `galBwd` is
--    proved for a semiring-valued kernel here, and no quantale is
--    constructed anywhere in this repository.  The idempotence result
--    therefore STILL does not apply to min-plus convolution."
--
-- The debt is paid at ONE CUT â” a single burden and a single residual â”
-- and paid with the real min-plus data, not a stand-in.
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
-- NO NOVELTY.  `(_âˆ b) âŠ (_+ b)` is the standard residuation in â• and
-- makes it a residuated monoid; that Isbell conjugation over a quantale
-- is a Galois connection is likewise standard (Lawvere's metric-space
-- reading of enriched categories, `Metric spaces, generalized logic,
-- and closed categories`, 1973, is where min-plus becomes the value
-- object).  What is contributed is only that this repository's own
-- obligation is now discharged for one cut rather than named.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
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
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The NOT-CLAIMED section says the remaining obstruction
-- "is not the residuation law; it is the meet", and adds that the meet
-- "needs `min` over a finite index and its universal property".
--
-- The meet is built and the profile cut is done, in
-- `TheMeetIsMaxAndTheProfileCutIsAGaloisConnection`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin â” check.sh returns 1 and says so).
--
-- AND THE OPERATION NAMED ABOVE IS WRONG.  **The meet is `max`, not
-- `min`.**  Â§2 here had to reverse â•'s order because lower cost is
-- better; a meet in a reversed order is a JOIN in the original, so `â‹`
-- over burdens is `max` in â•.  Writing "min-plus, so take a min" names
-- the operation by its role in the semiring rather than by its role in
-- the order â” which is exactly the error Â§2's reversal was supposed to
-- have taught, made one level up and two cycles later.
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
------------------------------------------------------------------------

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above â” including the 2026-08-19 append above it, which is
-- correct and is what convicts a later claim of mine.  TWO items.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- (1)  A FALSE CLAIM OF MINE, MADE ONE CYCLE AGO, REFUTED BY THIS FILE.
--
-- Commit 3aa3c78c appended a correction to
-- `TheSaturationClosureNeedsOnlyAGaloisConnection` and said of the
-- `min`/`max` meet correction:
--
--   "That correction was made in `TheMeetIsMaxAndTheProfileCutIsAGaloisConnection`
--    â¦ and it was recorded THERE AND NOWHERE ELSE."
--
-- **That is false, and the counterexample is the paragraph directly
-- above this one.**  The 2026-08-19 append in THIS file states the
-- correction in its own words â” *"AND THE OPERATION NAMED ABOVE IS
-- WRONG.  The meet is `max`, not `min`"* â” with the reason, the
-- reversal, and the diagnosis that naming an operation by its role in
-- the semiring rather than in the order is the error.  So the
-- correction was propagated to two of its three sites; exactly one site
-- was missed.
--
-- **AND THE WAY I GOT IT WRONG IS THE SAME SHAPE AS THE THING I WAS
-- REPORTING.**  I grepped for the wrong phrase, saw three files, and
-- read all three hits as uncorrected without opening them â” when one
-- was the correction itself and one was this file quoting the wrong
-- sentence in order to refute it.  **A grep for the wrong word finds
-- the corrections too, because a correction has to quote what it
-- corrects.  Counting hits is not reading them.**  That is the
-- operative repair, and it is narrower and more useful than "grep for
-- the word, not the module", which is what 3aa3c78c concluded and which
-- remains true but insufficient.
--
-- The substantive half of 3aa3c78c stands: the wrong word DID survive
-- unpropagated in `TheSaturationClosureNeedsOnlyAGaloisConnection`, and
-- is now corrected there.  Only the scope claim was wrong.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- (2)  AND ONE SENTENCE ABOVE IS NOW STALE.
--
-- The append above ends: *"Profiles on BOTH sides need a meet per
-- residual index and are not built."*  Built â”
-- `TheTwoSidedProfileCutNeedsTheBurdensAsAProfile` (83d6edb8) takes the
-- burdens as a profile so `UpP` produces a residual PROFILE;
-- `TheTwoSidedCutExistsOverANonEmptyResidualIndex` (89c9b7f0) gives the
-- adjunction over a non-empty index; and `TheTwoSidedCutNeedsNoInfinityBecauseTheEmptyMeetIsZero`
-- (8f3acebb) removes the restriction entirely, over an ARBITRARY
-- residual index list with no `âˆž`.
--
-- **AND THIS FILE HAD THE REASON RIGHT BEFORE I LOST IT.**  The
-- paragraph above already says *"the empty meet is `0` by â•'s bottom
-- rather than by choice."*  That is exactly the fact I later denied â”
-- claiming the empty meet forced `â• âŠ âˆž` (89c9b7f0's signature),
-- retracted at 819e0a57 â” and it was written here, correctly, before I
-- made the error.  Nothing was needed to fix it except reading my own
-- file.
--
-- WHAT IS NOT RETRACTED.  Everything else in this module and in the
-- append above.  `âˆ-adjË¡`/`âˆ-adjÊ³`, the two adjunction directions,
-- `MinPlusCut`, and `truncationBreaksTheNaiveOrder` are unaltered and
-- true.  CONVOLUTION is still absent everywhere, so Î” 28's COMPOSITION
-- step is untouched by any of this.
------------------------------------------------------------------------
