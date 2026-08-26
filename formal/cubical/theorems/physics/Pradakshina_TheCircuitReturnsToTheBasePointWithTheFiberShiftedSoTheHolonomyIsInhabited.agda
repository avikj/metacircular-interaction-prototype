{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- प्रदक्षिणा — the circuit returns to the base point with the fiber
-- shifted: the holonomy is inhabited.
--
-- THE LOOP QUESTION, ANSWERED AFFIRMATIVELY AS A TERM.  A loop in the
-- base is not a graph cycle: it asks whether transporting around it
-- returns identically or produces holonomy.  `KramaSaha_…` priced the
-- square-level curvature (the commutator of two standpoint operators is
-- ℤ); this module prices the LOOP-level curvature on the same space and
-- gets the same charge, one rung down in machinery: no truncations, no
-- operator algebra — one bundle, one loop, one transport.
--
--     the bundle    helix : S¹ → Type      (the library's, over the circle)
--     the circuit   loop  : base ≡ base
--     the action    प्रदक्षिणा = subst helix loop : ℤ → ℤ
--
--   सरणिः        :  प्रदक्षिणा x ≡ sucℤ x       the action is the successor —
--                                            computed, by uaβ, not posited
--   अ-पुनरागमः    :  प्रदक्षिणा 0 ≢ 0            Hol(loop) ≠ id, witnessed
--   ध्रुव-वलयः    :  the constant bundle returns identically — the holonomy
--                                            lives in the FAMILY, not in
--                                            the loop alone
--
-- The base point is the same point before and after.  What has changed is
-- carried ABOVE it — which is the exact literal content of the ritual
-- word: प्रदक्षिणा, the circumambulation of a shrine, ends where it began
-- and does not leave the walker unchanged.  The word is used here for
-- that literal content and nothing else; no claim that any source states
-- a holonomy theorem.  The compound usage is built here, 2026-08-23.
-- helix, sucPathℤ and uaβ are the library's (Voevodsky's univalence,
-- CCHM's computation of it — the shift is DEFINITIONAL cash, not an
-- axiom's IOU).
------------------------------------------------------------------------

module Pradakshina_TheCircuitReturnsToTheBasePointWithTheFiberShiftedSoTheHolonomyIsInhabited where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (iso ; isoToIsEquiv)
open import Cubical.Foundations.Univalence using (uaβ)
open import Cubical.Data.Int
  using (ℤ ; pos ; sucℤ ; predℤ ; sucPred ; predSuc)
open import Cubical.Data.Nat using (zero ; suc ; znots)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.HITs.S1 using (S¹ ; base ; loop ; helix)

------------------------------------------------------------------------
-- १ · the action of the circuit on the fiber over the base point.
------------------------------------------------------------------------

प्रदक्षिणा : ℤ → ℤ
प्रदक्षिणा = subst helix loop

------------------------------------------------------------------------
-- २ · सरणिः — the action computes: it is the successor.  helix carries
-- loop to sucPathℤ = ua (sucℤ , …), and uaβ discharges the transport.
------------------------------------------------------------------------

सरणिः : (x : ℤ) → प्रदक्षिणा x ≡ sucℤ x
सरणिः = uaβ (sucℤ , isoToIsEquiv (iso sucℤ predℤ sucPred predSuc))

------------------------------------------------------------------------
-- ३ · अ-पुनरागमः — no return: the holonomy is inhabited.  Around once,
-- and 0 has become 1; the two are exhibitably distinct.
------------------------------------------------------------------------

एक≢शून्य : ¬ (pos (suc zero) ≡ pos zero)
एक≢शून्य p = znots (sym (cong अङ्क p))
  where
    अङ्क : ℤ → _
    अङ्क (pos n) = n
    अङ्क _       = zero

अ-पुनरागमः : ¬ (प्रदक्षिणा (pos zero) ≡ pos zero)
अ-पुनरागमः p = एक≢शून्य (sym (सरणिः (pos zero)) ∙ p)

------------------------------------------------------------------------
-- ४ · ध्रुव-वलयः — the flat contrast: over the SAME loop, the constant
-- bundle returns every fiber element identically.  The curvature is a
-- property of the family over the circuit, not of the circuit; a cycle
-- in the declaration graph is silent until its bundle is named.
------------------------------------------------------------------------

ध्रुव-वलयः : {A : Type} (x : A) → subst (λ _ → A) loop x ≡ x
ध्रुव-वलयः x = transportRefl x

------------------------------------------------------------------------
-- ५ · दोषलेखः.  One loop, one bundle, holonomy in ℤ — the smallest
-- inhabited instance, not a theory: no curvature form, no general
-- holonomy group, no claim about which cycles of the corpus's transport
-- graph carry nontrivial bundles (that question is the open one this
-- module makes precise: a cycle's charge is the प्रदक्षिणा of the family
-- it bounds, and it must be computed per family, as here, never read
-- off the cycle).
------------------------------------------------------------------------
