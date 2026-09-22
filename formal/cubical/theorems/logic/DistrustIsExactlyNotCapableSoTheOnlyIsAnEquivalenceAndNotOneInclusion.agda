{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DistrustIsExactlyNotCapableSoTheOnlyIsAnEquivalenceAndNotOneInclusion
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- `trustDeterminesTheState`
-- shows the verdict `true` pins the state to `capable` exactly â” the
-- map is injective over `true`.
--
-- `distrustDeterminesOnlyNotCapable` proves
--
--     trusted s â‰¡ false  â’  Â (s â‰¡ capable)
--
-- This module adds the converse: every non-`capable` state is actually graded `false`,
-- so the `false` fibre is EXACTLY the complement of `capable` and not merely
-- contained in it â” and the constancy of the verdict across that fibre, which
-- is what "forgets the reason" asserts.
--
-- The two sides are joined by a CASE ANALYSIS on a
-- three-constructor type â” not by an implication assumed, not by a path
-- given, not by a truncation â” so neither direction can be more
-- expensive than the other, and neither is.
--
-- `trusted s â‰¡ false` is a path in `Bool`, a set; `Â (s â‰¡ capable)` is a
-- negation.  Both are propositions, so the two implications are an
-- EQUIVALENCE, not a pair â” `distrustIsExactlyNotCapable`.  That is what
-- makes `Only` mean what its name says: the fibre is not just contained
-- in the complement, it IS the complement.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- The title says "the reason", and the
-- model has exactly two reasons â” `absent` and `incapable`.  That
-- module states that a real kernel could be present,
-- refl-capable and cubical-incapable, which its own shelf records on the
-- verdict line and the model does not carry.  So the `Only` is exact for
-- a three-state model that the module itself says is not the real one.
--
-- WHAT IS PROVED
--
--   notCapableGivesDistrust    the converse, by case analysis
--   distrustIsExactlyNotCapable
--                              hence `(trusted s â‰¡ false) â‰ Â (s â‰¡ capable)`
--   verdictIsConstantOnTheDistrustFibre
--                              any two non-`capable` states get the same
--                              verdict â” one line from the converse, no
--                              case analysis at all, which is the
--                              precise form of "forgets the reason"
------------------------------------------------------------------------

module DistrustIsExactlyNotCapableSoTheOnlyIsAnEquivalenceAndNotOneInclusion where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_â‰ƒ_ ; propBiimplâ†’Equiv)
open import Cubical.Data.Bool using (Bool ; true ; false ; isSetBool)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; isPropÂ¬)

open import FailClosedForgetsOnlyTheReasonForDistrust
  using (KernelState ; absent ; incapable ; capable ; trusted
        ; distrustDeterminesOnlyNotCapable)

------------------------------------------------------------------------
-- 1.  The converse
------------------------------------------------------------------------

notCapableGivesDistrust :
  (s : KernelState) â†’ Â¬ (s â‰¡ capable) â†’ trusted s â‰¡ false
notCapableGivesDistrust absent    _ = refl
notCapableGivesDistrust incapable _ = refl
notCapableGivesDistrust capable   h = âŠ¥.rec (h refl)

------------------------------------------------------------------------
-- 2.  So `Only` is an equivalence, both sides being propositions
------------------------------------------------------------------------

distrustIsExactlyNotCapable :
  (s : KernelState) â†’ (trusted s â‰¡ false) â‰ƒ (Â¬ (s â‰¡ capable))
distrustIsExactlyNotCapable s =
  propBiimplâ†’Equiv
    (isSetBool (trusted s) false)
    (isPropÂ¬ (s â‰¡ capable))
    (distrustDeterminesOnlyNotCapable s)
    (notCapableGivesDistrust s)

------------------------------------------------------------------------
-- 3.  And "forgets the reason", stated for every pair rather than one
------------------------------------------------------------------------

verdictIsConstantOnTheDistrustFibre :
  (s t : KernelState)
  â†’ Â¬ (s â‰¡ capable) â†’ Â¬ (t â‰¡ capable)
  â†’ trusted s â‰¡ trusted t
verdictIsConstantOnTheDistrustFibre s t hs ht =
  notCapableGivesDistrust s hs âˆ™ sym (notCapableGivesDistrust t ht)
