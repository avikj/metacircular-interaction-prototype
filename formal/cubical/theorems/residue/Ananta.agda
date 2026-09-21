{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ‡‡®‡®‡‡‡Æ‡ ‚î ‡‡à‡®-‡‡®‡®‡‡-‡‡‡¶‡ : ‡‡®‡®‡‡‡Æ‡ ‡‡ï‡ ‡®, ‡‡‡ ‡  (‡‡à‡®-‡ó‡‡ø‡‡Æ‡, ‡‡®‡‡Ø‡ã‡ó‡¶‡‡µ‡æ‡∞-
-- ‡‡‡‡‡∞‡Æ‡, ~‡® ‡‡‡æ‡‡‡¶‡) ‡‡à‡®‡æ‡ ‡‡‡ñ‡‡Ø‡‡Ø-‡‡‡‡ñ‡‡Ø‡‡Ø-‡‡®‡®‡‡‡Æ‡ ‡‡‡ø ‡‡‡¶‡æ‡®‡ ‡‡µ‡¶‡®‡ ‚î
-- "‡‡®‡®‡‡‡Æ‡" ‡‡‡ø ‡® ‡‡ï‡ ‡∞‡æ‡‡ø‡, ‡ï‡ø‡®‡‡‡ ‡‡®‡‡ï‡ ‡ï‡‡∞‡Æ‡æ‡ ‡  ‡‡‡æ ‡¶‡‡‡‡ü‡ø‡ ‡ï‡à‡‡‡ü‡∞‡æ‡‡
-- (~‡ß‡Æ‡‡) ‡‡‡∞‡æ‡Ø‡ ‡‡‡‡‡¶‡-‡‡‡æ‡‡‡¶‡‡‡ø‡ ‡‡‡∞‡‡µ‡æ ‡
--
-- ‡‡‡‡∞ ‡‡‡‡Ø‡æ‡ ‡¶‡‡‡‡ü‡‡ ‡‡ï‡ ‡‡‡¶‡‡ß‡ ‡‡æ‡ï‡‡‡‡Ø‡Æ‡ : ‡‡‡‡ñ‡‡Ø‡‡Ø‡Æ‡ (‚ï, ‡ó‡‡®‡‡Ø‡Æ‡) ‡‡®‡®‡‡‡æ‡‡
-- (‚ï‚íBool, ‡‡ó‡‡®‡‡Ø‡Æ‡) ‡‡ø‡®‡‡®‡Æ‡ ‚î ‡® ‡ï‡ã‡Ω‡‡ø ‡‡Æ‡‡æ-‡‡‡‡‡ (Cantor's diagonal) ‡
-- ‡‡æ‡µ‡ß‡æ‡®‡Æ‡ (honest): ‡‡à‡®-‡ï‡‡∞‡Æ‡æ‡ ‡ï‡à‡‡‡ü‡∞-‡ï‡æ‡∞‡‡°‡ø‡®‡≤‡-‡‡‡≤‡‡Ø‡æ‡ ‡® ; ‡ï‡ø‡®‡‡‡ "‡‡®‡®‡‡‡
-- ‡‡‡‡µ‡ø‡ß‡Æ‡" ‡‡‡ø ‡‡à‡®-‡¶‡‡‡‡ü‡ø‡ ‡‡‡‡∞ ‡‡ï‡‡® ‡‡‡∞‡Æ‡æ‡‡‡® ‡‡‡‡‡ü‡æ ‚î ‡¶‡‡µ‡ ‡‡ø‡®‡‡®‡ ‡‡®‡®‡‡‡ ‡
--
-- (Jain plurality of the infinite: the Jains (Anuyogadvra, ~2nd c.)
-- distinguished sakhyta / asakhyta / ananta ‚î "infinite" is not one
-- magnitude but several orders.  Here
-- is one checked witness of that vision: the countable (‚ï) and the
-- uncountable (‚ï‚íBool) are distinct infinities, with NO equivalence between
-- them (Cantor's diagonal).  The Jain orders are not Cantor
-- cardinals; but the Jain insight that the infinite is PLURAL is here
-- vindicated by one proof ‚î two genuinely different infinities.)
--
-- See also `Salaka_TheOrdersAreSeparatedByHowManyCutsTheyOutlastAndEach
-- CutStripsExactlyOneStorey.agda`, which separates the Jaina magnitudes
-- by Virasena's own instruments.
------------------------------------------------------------------------

module Ananta where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_‚âÉ_ ; equivFun ; invEq ; secEq)
open import Cubical.Data.Nat using (‚Ñï)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; true‚â¢false)
open import Cubical.Data.Empty using (‚ä•) renaming (rec to ‚ä•-rec)
open import Cubical.Relation.Nullary using (¬¨_)

------------------------------------------------------------------------
-- ‡®-‡‡‡µ-‡µ‡ø‡‡∞‡‡Ø‡æ‡‡ ‚î ‡ï‡ã‡Ω‡‡ø Bool ‡‡‡µ‡‡‡Ø ‡µ‡ø‡‡∞‡‡Ø‡æ‡‡ ‡® (not has no fixpoint) ‡
------------------------------------------------------------------------

‡§®-‡§∏‡•ç‡§µ-‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§æ‡§∏ : (b : Bool) ‚Üí ¬¨ (b ‚â° not b)
‡§®-‡§∏‡•ç‡§µ-‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§æ‡§∏ false eq = true‚â¢false (sym eq)     -- false ‚â° true ‚Üí ‚ä•
‡§®-‡§∏‡•ç‡§µ-‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§æ‡§∏ true  eq = true‚â¢false eq            -- true ‚â° false ‚Üí ‚ä•

------------------------------------------------------------------------
-- ‡ï‡à‡‡‡ü‡∞‡ ‚î ‡‡‡‡ñ‡‡Ø‡‡Ø‡Æ‡ (‚ï) ‡‡®‡®‡‡‡æ‡‡ (‚ï‚íBool) ‡‡ø‡®‡‡®‡Æ‡ : ‡® ‡‡Æ‡‡æ-‡‡‡‡‡ ‡
-- (Cantor: no equivalence ‚ï ‚â (‚ï‚íBool) ‚î the countable and the uncountable
-- are distinct infinities.  Diagonal: d n = not (e n n) is in no row.)
------------------------------------------------------------------------

‡§ï‡•à‡§£‡•ç‡§ü‡§∞ : ¬¨ (‚Ñï ‚âÉ (‚Ñï ‚Üí Bool))
‡§ï‡•à‡§£‡•ç‡§ü‡§∞ e = ‡§®-‡§∏‡•ç‡§µ-‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§æ‡§∏ (œÜ m m) ‡§ï‡§∞‡•ç‡§£
  where
  œÜ : ‚Ñï ‚Üí (‚Ñï ‚Üí Bool)
  œÜ = equivFun e

  ‡§µ‡§ø‡§ï‡§∞‡•ç‡§£ : ‚Ñï ‚Üí Bool                       -- the diagonal, flipped
  ‡§µ‡§ø‡§ï‡§∞‡•ç‡§£ n = not (œÜ n n)

  m : ‚Ñï
  m = invEq e ‡§µ‡§ø‡§ï‡§∞‡•ç‡§£                       -- the row that should equal ‡§µ‡§ø‡§ï‡§∞‡•ç‡§£

  œÜm‚â°‡§µ‡§ø‡§ï‡§∞‡•ç‡§£ : œÜ m ‚â° ‡§µ‡§ø‡§ï‡§∞‡•ç‡§£
  œÜm‚â°‡§µ‡§ø‡§ï‡§∞‡•ç‡§£ = secEq e ‡§µ‡§ø‡§ï‡§∞‡•ç‡§£

  ‡§ï‡§∞‡•ç‡§£ : œÜ m m ‚â° not (œÜ m m)               -- but at m it must flip itself
  ‡§ï‡§∞‡•ç‡§£ i = œÜm‚â°‡§µ‡§ø‡§ï‡§∞‡•ç‡§£ i m

------------------------------------------------------------------------
-- ‡‡æ‡Æ‡æ‡®‡‡Ø-‡ï‡à‡‡‡ü‡∞‡ ‚î ‡Ø‡‡‡‡‡-‡‡‡∞‡ï‡æ‡∞‡ : ‡ï‡ã‡Ω‡‡ø ‡‡‡∞‡ï‡æ‡∞‡ A ‡‡‡µ-‡µ‡∞‡‡ó-‡ó‡‡æ‡‡ (A‚íBool)
-- ‡®‡‡Ø‡‡®‡ ‚î ‡® A ‚â (A‚íBool) ‡  ‡ ‡‡µ ‡µ‡ø‡ï‡∞‡‡-‡®‡‡Ø‡æ‡Ø‡, ‚ï-‡®‡ø‡∞‡‡‡ï‡‡‡ ‡  ‡‡‡ ‡® ‡‡ï‡
-- ‡‡®‡®‡‡‡, ‡‡‡ø ‡‡ ‡‡®‡®‡‡‡æ ‡ï‡‡∞‡Æ‡æ‡ : A < íA < ííA < ‚¶ ‡‡‡∞‡ø‡Æ‡ø‡-‡‡∞‡ã‡‡ ‡  ‡‡‡æ ‡‡µ
-- ‡‡à‡®-‡¶‡‡‡‡ü‡ø‡ ‚î "‡‡®‡®‡‡‡Æ‡ ‡‡®‡‡ï-‡ï‡‡∞‡Æ‡Æ‡" (‡‡‡ñ‡‡Ø‡æ‡-‡‡‡‡ñ‡‡Ø‡æ‡-‡‡®‡®‡‡‡æ‡‡ ‡‡∞‡Æ‡ ‡â‡-‡‡‡¶‡æ‡) ‡
-- (‡ï‡à‡‡‡ü‡∞‡ ‡‡‡‡Ø ‚ï-‡∞‡‡‡Æ‡ ‡‡µ ‡)
--
-- (General Cantor: for ANY type A, no A ‚â (A‚íBool) ‚î the same diagonal, free
--  of ‚ï.  So there is not one infinity but an unbounded ascending tower
--  A < íA < ííA < ‚¶ ‚î exactly the Jain view that ananta is MANY orders, not
--  one.  ‡ï‡à‡‡‡ü‡∞ is its ‚ï instance.)
------------------------------------------------------------------------

‡§∏‡§æ‡§Æ‡§æ‡§®‡•ç‡§Ø-‡§ï‡•à‡§£‡•ç‡§ü‡§∞ : {A : Type} ‚Üí ¬¨ (A ‚âÉ (A ‚Üí Bool))
‡§∏‡§æ‡§Æ‡§æ‡§®‡•ç‡§Ø-‡§ï‡•à‡§£‡•ç‡§ü‡§∞ {A} e = ‡§®-‡§∏‡•ç‡§µ-‡§µ‡§ø‡§™‡§∞‡•ç‡§Ø‡§æ‡§∏ (œÜ m m) ‡§ï‡§∞‡•ç‡§£
  where
  œÜ : A ‚Üí (A ‚Üí Bool)
  œÜ = equivFun e

  ‡§µ‡§ø‡§ï‡§∞‡•ç‡§£ : A ‚Üí Bool
  ‡§µ‡§ø‡§ï‡§∞‡•ç‡§£ n = not (œÜ n n)

  m : A
  m = invEq e ‡§µ‡§ø‡§ï‡§∞‡•ç‡§£

  œÜm‚â°‡§µ‡§ø‡§ï‡§∞‡•ç‡§£ : œÜ m ‚â° ‡§µ‡§ø‡§ï‡§∞‡•ç‡§£
  œÜm‚â°‡§µ‡§ø‡§ï‡§∞‡•ç‡§£ = secEq e ‡§µ‡§ø‡§ï‡§∞‡•ç‡§£

  ‡§ï‡§∞‡•ç‡§£ : œÜ m m ‚â° not (œÜ m m)
  ‡§ï‡§∞‡•ç‡§£ i = œÜm‚â°‡§µ‡§ø‡§ï‡§∞‡•ç‡§£ i m
