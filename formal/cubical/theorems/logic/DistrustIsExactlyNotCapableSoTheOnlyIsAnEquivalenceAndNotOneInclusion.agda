{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DistrustIsExactlyNotCapableSoTheOnlyIsAnEquivalenceAndNotOneInclusion
--
-- ON THE NAME.  Checked before naming: `.claude/hooks/priority-ledger.txt`
-- (CURRENT header) and `.claude/hooks/european-frame.txt`; `formal/` and
-- invented.**  The subject is the verdict semantics of a Haskell shelf
-- in this repository (`interactive/KernelProbe.hs`) and the h-level step is
-- the declared substrate.  I have established no Indian source for
-- either and will not attach a label I cannot defend.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE AUDIT.  Target: `FailClosedForgetsOnlyTheReasonForDistrust`, an
-- `Only` â” and a NEW shape for this sweep: a claim about what is LOST.
-- The others counted what is needed (`NeedsOnly`), what holds
-- (`Exactly`), or where something cannot be (`Cannot`).
--
-- **THE TRUSTING HALF IS FULLY EARNED.**  `trustDeterminesTheState`
-- shows the verdict `true` pins the state to `capable` exactly â” the
-- map is injective over `true`, and Â§4's reading of that is right.
--
-- **THE DISTRUSTING HALF IS ONE INCLUSION OF TWO.**
-- `distrustDeterminesOnlyNotCapable` proves
--
--     trusted s â‰¡ false  â’  Â (s â‰¡ capable)
--
-- and its name says ONLY. But "the verdict determines only `Â capable`" is a
-- claim about EXACT information content, and one implication gives an upper
-- bound on what distrust tells you in one direction alone. What is missing is
-- the converse â” that every non-`capable` state is actually graded `false`,
-- so the `false` fibre is EXACTLY the complement of `capable` and not merely
-- contained in it â” and the constancy of the verdict across that fibre, which
-- is what "forgets the reason" asserts.
--
-- **BOTH ARE FREE, AND DIAGNOSTIC (1) SAYS WHY BEFORE THEY ARE
-- WRITTEN.**  The two sides are joined by a CASE ANALYSIS on a
-- three-constructor type â” not by an implication assumed, not by a path
-- given, not by a truncation â” so neither direction can be more
-- expensive than the other, and neither is.
--
-- **AND `Only` UPGRADES THE SAME WAY `the same claim` DID AT d3963e51.**
-- `trusted s â‰¡ false` is a path in `Bool`, a set; `Â (s â‰¡ capable)` is a
-- negation.  Both are propositions, so the two implications are an
-- EQUIVALENCE, not a pair â” `distrustIsExactlyNotCapable`.  That is what
-- makes `Only` mean what its name says: the fibre is not just contained
-- in the complement, it IS the complement.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- ONE READING NOTE, NOT A FAULT.  The title says "the reason", and the
-- model has exactly two reasons â” `absent` and `incapable`.  The audited
-- module states plainly that a real kernel could be present,
-- refl-capable and cubical-incapable, which its own shelf records on the
-- verdict line and the model does not carry.  So the `Only` is exact for
-- a three-state model that the module itself says is not the real one.
-- Everything below inherits that limit and nothing here widens it.
--
-- WHAT IS PROVED
--
--   notCapableGivesDistrust    the missing converse, by case analysis
--   distrustIsExactlyNotCapable
--                              hence `(trusted s â‰¡ false) â‰ Â (s â‰¡ capable)`,
--                              REUSING the audited implication rather
--                              than restating it
--   verdictIsConstantOnTheDistrustFibre
--                              any two non-`capable` states get the same
--                              verdict â” one line from the converse, no
--                              case analysis at all, which is the
--                              precise form of "forgets the reason"
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
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
-- 1.  The converse the audited module did not state
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
