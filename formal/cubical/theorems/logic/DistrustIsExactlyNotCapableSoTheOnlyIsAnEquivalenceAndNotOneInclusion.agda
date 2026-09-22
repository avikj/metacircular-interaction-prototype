{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DistrustIsExactlyNotCapableSoTheOnlyIsAnEquivalenceAndNotOneInclusion
--
-- ────────────────────────────────────────────────────────────────────
-- `trustDeterminesTheState`
-- shows the verdict `true` pins the state to `capable` exactly — the
-- map is injective over `true`.
--
-- `distrustDeterminesOnlyNotCapable` proves
--
--     trusted s ≡ false  →  ¬ (s ≡ capable)
--
-- This module adds the converse: every non-`capable` state is actually graded `false`,
-- so the `false` fibre is EXACTLY the complement of `capable` and not merely
-- contained in it — and the constancy of the verdict across that fibre, which
-- is what "forgets the reason" asserts.
--
-- The two sides are joined by a CASE ANALYSIS on a
-- three-constructor type — not by an implication assumed, not by a path
-- given, not by a truncation — so neither direction can be more
-- expensive than the other, and neither is.
--
-- `trusted s ≡ false` is a path in `Bool`, a set; `¬ (s ≡ capable)` is a
-- negation.  Both are propositions, so the two implications are an
-- EQUIVALENCE, not a pair — `distrustIsExactlyNotCapable`.  That is what
-- makes `Only` mean what its name says: the fibre is not just contained
-- in the complement, it IS the complement.
--
-- ────────────────────────────────────────────────────────────────────
-- The title says "the reason", and the
-- model has exactly two reasons — `absent` and `incapable`.  That
-- module states that a real kernel could be present,
-- refl-capable and cubical-incapable, which its own shelf records on the
-- verdict line and the model does not carry.  So the `Only` is exact for
-- a three-state model that the module itself says is not the real one.
--
-- WHAT IS PROVED
--
--   notCapableGivesDistrust    the converse, by case analysis
--   distrustIsExactlyNotCapable
--                              hence `(trusted s ≡ false) � � (s ≡ capable)`
--   verdictIsConstantOnTheDistrustFibre
--                              any two non-`capable` states get the same
--                              verdict — one line from the converse, no
--                              case analysis at all, which is the
--                              precise form of "forgets the reason"
------------------------------------------------------------------------

module DistrustIsExactlyNotCapableSoTheOnlyIsAnEquivalenceAndNotOneInclusion where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; propBiimpl→Equiv)
open import Cubical.Data.Bool using (Bool ; true ; false ; isSetBool)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; isProp¬)

open import FailClosedForgetsOnlyTheReasonForDistrust
  using (KernelState ; absent ; incapable ; capable ; trusted
        ; distrustDeterminesOnlyNotCapable)

------------------------------------------------------------------------
-- 1.  The converse
------------------------------------------------------------------------

notCapableGivesDistrust :
  (s : KernelState) → ¬ (s ≡ capable) → trusted s ≡ false
notCapableGivesDistrust absent    _ = refl
notCapableGivesDistrust incapable _ = refl
notCapableGivesDistrust capable   h = ⊥.rec (h refl)

------------------------------------------------------------------------
-- 2.  So `Only` is an equivalence, both sides being propositions
------------------------------------------------------------------------

distrustIsExactlyNotCapable :
  (s : KernelState) → (trusted s ≡ false) ≃ (¬ (s ≡ capable))
distrustIsExactlyNotCapable s =
  propBiimpl→Equiv
    (isSetBool (trusted s) false)
    (isProp¬ (s ≡ capable))
    (distrustDeterminesOnlyNotCapable s)
    (notCapableGivesDistrust s)

------------------------------------------------------------------------
-- 3.  And "forgets the reason", stated for every pair rather than one
------------------------------------------------------------------------

verdictIsConstantOnTheDistrustFibre :
  (s t : KernelState)
  → ¬ (s ≡ capable) → ¬ (t ≡ capable)
  → trusted s ≡ trusted t
verdictIsConstantOnTheDistrustFibre s t hs ht =
  notCapableGivesDistrust s hs ∙ sym (notCapableGivesDistrust t ht)
