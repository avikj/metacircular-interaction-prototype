{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡ô‡‡ï‡‡æ‡‡ ‚î ‡‡ô‡‡ï‡æ‡®‡æ‡ ‡‡æ‡‡ ‡
-- (akapa: "the net of digits" ‚î the counting of arrangements.)
--
-- THE TERM, ITS TEXT AND ITS DATE.  `‡‡ô‡‡ï‡‡æ‡` is the name of the section
-- on permutations in Bhskara II, *Llvat* (1150 CE): the arrangements
-- of n distinct digits number the product 1¬2¬‚ãØ¬n.  The metrical material is Pigala,
-- *‡‡®‡‡¶‡‡‡æ‡‡‡‡‡∞‡Æ‡* ‡Æ.‡®‡‚ì‡®‡Æ (~300 BCE): the ‡‡‡∞‡‡‡‡æ‡∞, and ‡‡ô‡‡ñ‡‡Ø‡æ, the
-- ‡‡‡∞‡‡‡Ø‡Ø that asks how many.
--
------------------------------------------------------------------------
-- WHAT THIS MODULE IS.
--
-- `machine/Setubandha_TheCheckedIdentificationsAreEdgesAndTheIsolatedNodes
-- AreTheFrontier.hs` reports `Decategorification.œ‚FinSet`
-- at degree 1: joined to the hub `‚ï` and to nothing else.  It is at
-- distance 2 from
-- `Pingala.‡‡®‡‡¶‡‡`:
--
--       Pingala.‡‡®‡‡¶‡‡  ‚î‚î[ Pingala.‡‡®‡‡¶‡‡‚â‚ï ]‚î‚î  ‚ï
--                       ‚î‚î[ Decategorification.‚ï‚âœ‚FinSet ]‚î‚î  œ‚FinSet
--
-- ONE DIFFERENCE FROM THE OTHER TWO CAUSEWAYS, and it is why this file
-- says `‚â` where they said `‚â°`.  `œ‚FinSet : Type‚` and `‡‡®‡‡¶‡‡ : Type‚`
-- live in DIFFERENT UNIVERSES, so `ua` is unavailable and there is no
-- path to transport along ‚î the graph program already records only an
-- `[equiv]` for `‚ï‚âœ‚FinSet` and no `[path]`.  The route is therefore
-- composed with `compEquiv` rather than `_‚àô_`, and what it carries is
-- carried by composition of equivalences, not by `subst`.  Naming that
-- limit is part of the result: a causeway across a universe boundary is
-- narrower than one within a universe, and reporting it as the same
-- thing would be the overstatement this corpus keeps catching.
--
-- NOTHING BELOW IS CONSTRUCTED BY HAND.  No induction over ‡‡®‡‡¶‡‡, no
-- case split on ‡≤‡ò‡/‡ó‡‡∞‡, no permutation is ever written down.  Every
-- theorem is `compEquiv` of equivalences somebody else checked, or an
-- instance of one of them.
--
-- THE THREE THINGS THE ROUTE CARRIES.
--
--   ‡ß  A metre NAMES a finite set, and Pigala's ‡‡ô‡‡ñ‡‡Ø‡æ is that set's
--      cardinality.  `card-Fin` is `refl`, so the naming map needs no
--      coherence lemma at all.
--
--   ‡®  TWO METRES ARE ONE METRE EXACTLY WHEN THE SETS THEY NAME ARE
--      MERELY EQUAL.  `Decategorification.card‚â°MereEq` is the general
--      statement; instantiated at the metres it becomes Pigala's own
--      uniqueness theorem `‡Æ‡‡≤‡‡Ø-‡‡ï‡à‡ï‡Æ‡` read one level up, and the two
--      compose into a decategorification statement about ‡‡®‡‡¶‡‡ that
--      neither file states.
--
--   ‡©  WHAT THE NUMBER FORGETS IS BHSKARA'S PRODUCT.  The loop at the
--      component a metre names is the symmetric group on its ‡‡ô‡‡ñ‡‡Ø‡æ
--      letters (`FinSetLoop‚âSym`), and that group is enumerated by
--      `SymmetryEnumeration.symmetryEnum` as `Fin (n !)`.  Composing:
--      the metre of value n has exactly n! loops ‚î Pigala's ‡‡‡∞‡‡‡‡æ‡∞
--      index on one side, the ‡‡ô‡‡ï‡‡æ‡ count on the other, and no term in
--      this file does any counting.
------------------------------------------------------------------------

module Ankapasa_TheMetreNamesAFiniteSetAndTheLoopsOfThatSetAreTheFactorial where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; compEquiv ; invEq)
open import Cubical.Data.Nat using (‚Ñï ; _!)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.FinSet using (FinSet ; card)
open import Cubical.HITs.PropositionalTruncation using (‚à•_‚à•‚ÇÅ)

open import Pingala using (‡§õ‡§®‡•ç‡§¶‡§∏‡•ç ; ‡§Æ‡•Ç‡§≤‡•ç‡§Ø ; ‡§Ö‡§®‡•Å‡§ï‡•ç‡§∞‡§Æ ; ‡§Æ‡•Ç‡§≤‡•ç‡§Ø-‡§è‡§ï‡•à‡§ï‡§Æ‡•ç ; ‡§õ‡§®‡•ç‡§¶‡§∏‡•ç‚âÉ‚Ñï)
open import Decategorification
  using (ùîΩ ; card-Fin ; card‚â°MereEq ; FinSetLoop‚âÉSym ; œÄ‚ÇÄFinSet ; ‚Ñï‚âÉœÄ‚ÇÄFinSet)
open import SymmetryEnumeration using (symmetryEnum)

------------------------------------------------------------------------
-- ‡¶ ¬ THE ROUTE.  Two checked equivalences, composed.  `compEquiv` and
--     not `_‚àô_`, because the two endpoints are in different universes
--     and there is no path to compose.
------------------------------------------------------------------------

‡§õ‡§®‡•ç‡§¶‡§∏‡•ç‚âÉœÄ‚ÇÄFinSet : ‡§õ‡§®‡•ç‡§¶‡§∏‡•ç ‚âÉ œÄ‚ÇÄFinSet
‡§õ‡§®‡•ç‡§¶‡§∏‡•ç‚âÉœÄ‚ÇÄFinSet = compEquiv ‡§õ‡§®‡•ç‡§¶‡§∏‡•ç‚âÉ‚Ñï ‚Ñï‚âÉœÄ‚ÇÄFinSet

------------------------------------------------------------------------
-- ‡ß ¬ A METRE NAMES A FINITE SET, AND ‡‡ô‡‡ñ‡‡Ø‡æ IS ITS CARDINALITY.
--
--     `card-Fin` is `refl`, so this needs no coherence lemma: the
--     cardinality of the set a metre names is its ‡‡‡∞‡‡‡‡æ‡∞-index on the
--     nose.
------------------------------------------------------------------------

‡§®‡§æ‡§Æ‡§ï‡§É : ‡§õ‡§®‡•ç‡§¶‡§∏‡•ç ‚Üí FinSet ‚Ñì-zero
‡§®‡§æ‡§Æ‡§ï‡§É ds = ùîΩ (‡§Æ‡•Ç‡§≤‡•ç‡§Ø ds)

‡§∏‡§ô‡•ç‡§ñ‡•ç‡§Ø‡§æ-‡§ï‡§æ‡§∞‡•ç‡§°‡•ç : (ds : ‡§õ‡§®‡•ç‡§¶‡§∏‡•ç) ‚Üí card (‡§®‡§æ‡§Æ‡§ï‡§É ds) ‚â° ‡§Æ‡•Ç‡§≤‡•ç‡§Ø ds
‡§∏‡§ô‡•ç‡§ñ‡•ç‡§Ø‡§æ-‡§ï‡§æ‡§∞‡•ç‡§°‡•ç ds = card-Fin (‡§Æ‡•Ç‡§≤‡•ç‡§Ø ds)

------------------------------------------------------------------------
-- ‡® ¬ DECATEGORIFICATION, READ ON PIGALA.
--
--     `card‚â°MereEq` says a numeral is a name for a connected component:
--     equality of cardinalities IS mere equality in FinSet.  At the sets
--     two metres name, that becomes a statement about metres, and
--     composing it with Pigala's own injectivity theorem gives what
--     neither file states ‚î two metres coincide exactly when the finite
--     sets they name are merely equal.
------------------------------------------------------------------------

‡§õ‡§®‡•ç‡§¶-‡§∏‡§Æ‡§§‡§æ : (d e : ‡§õ‡§®‡•ç‡§¶‡§∏‡•ç)
          ‚Üí (‡§Æ‡•Ç‡§≤‡•ç‡§Ø d ‚â° ‡§Æ‡•Ç‡§≤‡•ç‡§Ø e) ‚âÉ ‚à• ‡§®‡§æ‡§Æ‡§ï‡§É d ‚â° ‡§®‡§æ‡§Æ‡§ï‡§É e ‚à•‚ÇÅ
‡§õ‡§®‡•ç‡§¶-‡§∏‡§Æ‡§§‡§æ d e = card‚â°MereEq (‡§®‡§æ‡§Æ‡§ï‡§É d) (‡§®‡§æ‡§Æ‡§ï‡§É e)

‡§õ‡§®‡•ç‡§¶-‡§è‡§ï‡•à‡§ï‡§Æ‡•ç : (d e : ‡§õ‡§®‡•ç‡§¶‡§∏‡•ç) ‚Üí ‚à• ‡§®‡§æ‡§Æ‡§ï‡§É d ‚â° ‡§®‡§æ‡§Æ‡§ï‡§É e ‚à•‚ÇÅ ‚Üí d ‚â° e
‡§õ‡§®‡•ç‡§¶-‡§è‡§ï‡•à‡§ï‡§Æ‡•ç d e t = ‡§Æ‡•Ç‡§≤‡•ç‡§Ø-‡§è‡§ï‡•à‡§ï‡§Æ‡•ç d e (invEq (‡§õ‡§®‡•ç‡§¶-‡§∏‡§Æ‡§§‡§æ d e) t)

------------------------------------------------------------------------
-- ‡© ¬ ‡‡ô‡‡ï‡‡æ‡‡ ‚î WHAT THE NUMBER FORGETS.
--
--     `Decategorification` says the loop at a component is the symmetric
--     group; `SymmetryEnumeration` says that group has n! elements.
--     Neither mentions a metre.  Composed at `‡Æ‡‡≤‡‡Ø ds`, they say: the
--     metre of ‡‡‡∞‡‡‡‡æ‡∞-index n carries exactly n! rearrangements ‚î
--     Bhskara's product, arriving at Pigala's enumeration by
--     composition and by nothing else.
--
--     ‡‡ô‡‡ï‡‡æ‡‡ ‡‡‡∞‡‡‡‡æ‡∞‡‡‡Ø ‡‡‡‡æ‡®‡æ‡ô‡‡ï‡‡® ‡Æ‡‡Ø‡‡ ‡
------------------------------------------------------------------------

‡§õ‡§®‡•ç‡§¶‡•ã-‡§≠‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç : (ds : ‡§õ‡§®‡•ç‡§¶‡§∏‡•ç)
             ‚Üí (‡§®‡§æ‡§Æ‡§ï‡§É ds ‚â° ‡§®‡§æ‡§Æ‡§ï‡§É ds) ‚âÉ Fin ((‡§Æ‡•Ç‡§≤‡•ç‡§Ø ds) !)
‡§õ‡§®‡•ç‡§¶‡•ã-‡§≠‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç ds =
  compEquiv (FinSetLoop‚âÉSym (‡§Æ‡•Ç‡§≤‡•ç‡§Ø ds)) (symmetryEnum (‡§Æ‡•Ç‡§≤‡•ç‡§Ø ds))

-- The next row of the ‡‡‡∞‡‡‡‡æ‡∞ adds one letter, and the ‡‡ô‡‡ï‡‡æ‡ count of
-- the next row is therefore the count of this one times the new index.
-- Stated, not proved arithmetically: the equivalence below is the SAME
-- construction at the successor's value, and its codomain is where the
-- factorial recurrence lives.
‡§Ö‡§®‡•Å‡§ï‡•ç‡§∞‡§Æ‡§∏‡•ç‡§Ø-‡§≠‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç : (ds : ‡§õ‡§®‡•ç‡§¶‡§∏‡•ç)
                   ‚Üí (‡§®‡§æ‡§Æ‡§ï‡§É (‡§Ö‡§®‡•Å‡§ï‡•ç‡§∞‡§Æ ds) ‚â° ‡§®‡§æ‡§Æ‡§ï‡§É (‡§Ö‡§®‡•Å‡§ï‡•ç‡§∞‡§Æ ds))
                   ‚âÉ Fin ((‡§Æ‡•Ç‡§≤‡•ç‡§Ø (‡§Ö‡§®‡•Å‡§ï‡•ç‡§∞‡§Æ ds)) !)
‡§Ö‡§®‡•Å‡§ï‡•ç‡§∞‡§Æ‡§∏‡•ç‡§Ø-‡§≠‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç ds = ‡§õ‡§®‡•ç‡§¶‡•ã-‡§≠‡•ç‡§∞‡§Æ‡§£‡§Æ‡•ç (‡§Ö‡§®‡•Å‡§ï‡•ç‡§∞‡§Æ ds)
