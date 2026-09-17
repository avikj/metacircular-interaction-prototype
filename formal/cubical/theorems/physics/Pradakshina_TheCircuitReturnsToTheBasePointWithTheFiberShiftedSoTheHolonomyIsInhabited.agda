{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡∞‡¶‡ï‡‡‡ø‡‡æ ‚î the circuit returns to the base point with the fiber
-- shifted: the holonomy is inhabited.
--
-- THE LOOP QUESTION, ANSWERED AFFIRMATIVELY AS A TERM.  A loop in the
-- base is not a graph cycle: it asks whether transporting around it
-- returns identically or produces holonomy.  `KramaSaha_‚¶` priced the
-- square-level curvature (the commutator of two standpoint operators is
-- ‚); this module prices the LOOP-level curvature on the same space and
-- gets the same charge, one rung down in machinery: no truncations, no
-- operator algebra ‚î one bundle, one loop, one transport.
--
--     the bundle    helix : S¬ ‚í Type      (the library's, over the circle)
--     the circuit   loop  : base ‚â° base
--     the action    ‡‡‡∞‡¶‡ï‡‡‡ø‡‡æ = subst helix loop : ‚ ‚í ‚
--
--   ‡‡∞‡‡ø‡        :  ‡‡‡∞‡¶‡ï‡‡‡ø‡‡æ x ‚â° suc‚ x       the action is the successor ‚î
--                                            computed, by uaŒ≤, not posited
--   ‡-‡‡‡®‡∞‡æ‡ó‡Æ‡    :  ‡‡‡∞‡¶‡ï‡‡‡ø‡‡æ 0 ‚â 0            Hol(loop) ‚â† id, witnessed
--   ‡ß‡‡∞‡‡µ-‡µ‡≤‡Ø‡    :  the constant bundle returns identically ‚î the holonomy
--                                            lives in the FAMILY, not in
--                                            the loop alone
--
-- The base point is the same point before and after.  What has changed is
-- carried ABOVE it ‚î which is the exact literal content of the ritual
-- word: ‡‡‡∞‡¶‡ï‡‡‡ø‡‡æ, the circumambulation of a shrine, ends where it began
-- and does not leave the walker unchanged.  The word is used here for
-- that literal content and nothing else; no claim that any source states
-- a holonomy theorem.  The compound usage is built here, 2026-08-23.
-- helix, sucPath‚ and uaŒ≤ are the library's (Voevodsky's univalence,
-- CCHM's computation of it ‚î the shift is DEFINITIONAL cash, not an
-- axiom's IOU).
------------------------------------------------------------------------

module Pradakshina_TheCircuitReturnsToTheBasePointWithTheFiberShiftedSoTheHolonomyIsInhabited where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism using (iso ; isoToIsEquiv)
open import Cubical.Foundations.Univalence using (uaŒ≤)
open import Cubical.Data.Int
  using (‚Ñ§ ; pos ; suc‚Ñ§ ; pred‚Ñ§ ; sucPred ; predSuc)
open import Cubical.Data.Nat using (zero ; suc ; znots)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.HITs.S1 using (S¬π ; base ; loop ; helix)

------------------------------------------------------------------------
-- ‡ß ¬ the action of the circuit on the fiber over the base point.
------------------------------------------------------------------------

‡§™‡•ç‡§∞‡§¶‡§ï‡•ç‡§∑‡§ø‡§£‡§æ : ‚Ñ§ ‚Üí ‚Ñ§
‡§™‡•ç‡§∞‡§¶‡§ï‡•ç‡§∑‡§ø‡§£‡§æ = subst helix loop

------------------------------------------------------------------------
-- ‡® ¬ ‡‡∞‡‡ø‡ ‚î the action computes: it is the successor.  helix carries
-- loop to sucPath‚ = ua (suc‚ , ‚¶), and uaŒ≤ discharges the transport.
------------------------------------------------------------------------

‡§∏‡§∞‡§£‡§ø‡§É : (x : ‚Ñ§) ‚Üí ‡§™‡•ç‡§∞‡§¶‡§ï‡•ç‡§∑‡§ø‡§£‡§æ x ‚â° suc‚Ñ§ x
‡§∏‡§∞‡§£‡§ø‡§É = uaŒ≤ (suc‚Ñ§ , isoToIsEquiv (iso suc‚Ñ§ pred‚Ñ§ sucPred predSuc))

------------------------------------------------------------------------
-- ‡© ¬ ‡-‡‡‡®‡∞‡æ‡ó‡Æ‡ ‚î no return: the holonomy is inhabited.  Around once,
-- and 0 has become 1; the two are exhibitably distinct.
------------------------------------------------------------------------

‡§è‡§ï‚â¢‡§∂‡•Ç‡§®‡•ç‡§Ø : ¬¨ (pos (suc zero) ‚â° pos zero)
‡§è‡§ï‚â¢‡§∂‡•Ç‡§®‡•ç‡§Ø p = znots (sym (cong ‡§Ö‡§ô‡•ç‡§ï p))
  where
    ‡§Ö‡§ô‡•ç‡§ï : ‚Ñ§ ‚Üí _
    ‡§Ö‡§ô‡•ç‡§ï (pos n) = n
    ‡§Ö‡§ô‡•ç‡§ï _       = zero

‡§Ö-‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§É : ¬¨ (‡§™‡•ç‡§∞‡§¶‡§ï‡•ç‡§∑‡§ø‡§£‡§æ (pos zero) ‚â° pos zero)
‡§Ö-‡§™‡•Å‡§®‡§∞‡§æ‡§ó‡§Æ‡§É p = ‡§è‡§ï‚â¢‡§∂‡•Ç‡§®‡•ç‡§Ø (sym (‡§∏‡§∞‡§£‡§ø‡§É (pos zero)) ‚àô p)

------------------------------------------------------------------------
-- ‡ ¬ ‡ß‡‡∞‡‡µ-‡µ‡≤‡Ø‡ ‚î the flat contrast: over the SAME loop, the constant
-- bundle returns every fiber element identically.  The curvature is a
-- property of the family over the circuit, not of the circuit; a cycle
-- in the declaration graph is silent until its bundle is named.
------------------------------------------------------------------------

‡§ß‡•ç‡§∞‡•Å‡§µ-‡§µ‡§≤‡§Ø‡§É : {A : Type} (x : A) ‚Üí subst (Œª _ ‚Üí A) loop x ‚â° x
‡§ß‡•ç‡§∞‡•Å‡§µ-‡§µ‡§≤‡§Ø‡§É x = transportRefl x

------------------------------------------------------------------------
-- ‡ ¬ ‡¶‡ã‡‡≤‡‡ñ‡.  One loop, one bundle, holonomy in ‚ ‚î the smallest
-- inhabited instance, not a theory: no curvature form, no general
-- holonomy group, no claim about which cycles of the corpus's transport
-- graph carry nontrivial bundles (that question is the open one this
-- module makes precise: a cycle's charge is the ‡‡‡∞‡¶‡ï‡‡‡ø‡‡æ of the family
-- it bounds, and it must be computed per family, as here, never read
-- off the cycle).
------------------------------------------------------------------------
