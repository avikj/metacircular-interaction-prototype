{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- ‡‡‡‡∞‡ï‡‡‡æ ‚î keep the remainder.  The Kerala chapter's essence, stated
-- exactly where Madhava.agda fenced it: "‡‡‡-‡‡¶‡Æ‡ ‡‡µ ‡‡æ‡∞‡; ‡‡‡ ‡‡ ‡‡®‡‡ï‡‡‡Æ‡,
-- ‡® ‡Æ‡ø‡‡‡Ø‡æ-‡‡ø‡¶‡‡ß‡Æ‡" ‚î the remainder term is the essence, there unstated.
-- Its ‚-native form IS statable, and it is DIVISION WITH REMAINDER at
-- every finite stage, the remainder first-class:
--
--     pos 1  ‚â°  (pos 1 ‚àí r) ¬ ‡‡ô‡‡ï‡≤‡ø‡‡Æ‡ r n  +  ‡ò‡æ‡ r n
--
-- one = divisor ¬ quotient + remainder, for every n ‚î the exact identity
-- the Yuktibh's iterated division (1/(1+x) = 1 ‚àí x¬(1/(1+x)))
-- unrolls, with no limit taken and nothing false at any stage.  And the
-- remainder RECURSES: ‡ò‡æ‡ r (suc n) ‚â° ‡ò‡æ‡ r n ¬ r, definitionally ‚î each
-- stage's remainder is the previous remainder carried once more.
--
-- What this module adds is that the FINITE essence needs no
-- limit at all.
------------------------------------------------------------------------

module SesaRaksa_TheSeriesIsDivisionWithRemainderAtEveryStageAndTheRemainderRecurses where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Int using (‚Ñ§ ; pos)
  renaming (_+_ to _+‚Ñ§_ ; _¬∑_ to _¬∑‚Ñ§_ ; _-_ to _-‚Ñ§_)
open import Cubical.Data.Int.Properties using (minusPlus)

open import Madhava using (‡§ò‡§æ‡§§ ; ‡§∏‡§ô‡•ç‡§ï‡§≤‡§ø‡§§‡§Æ‡•ç ; ‡§ó‡•Å‡§£‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä-‡§Ø‡•ã‡§ó‡§É)

------------------------------------------------------------------------
-- ‡µ‡ø‡‡æ‡‡®‡Æ‡ ‚î one is divisor times quotient plus remainder, at EVERY
-- stage.  The remainder ‡ò‡æ‡ r n is first-class: kept, not discarded.
------------------------------------------------------------------------

‡§µ‡§ø‡§≠‡§æ‡§ú‡§®‡§Æ‡•ç : (r : ‚Ñ§) (n : ‚Ñï)
  ‚Üí pos 1 ‚â° ((pos 1 -‚Ñ§ r) ¬∑‚Ñ§ ‡§∏‡§ô‡•ç‡§ï‡§≤‡§ø‡§§‡§Æ‡•ç r n) +‚Ñ§ ‡§ò‡§æ‡§§ r n
‡§µ‡§ø‡§≠‡§æ‡§ú‡§®‡§Æ‡•ç r n =
  sym (cong (_+‚Ñ§ ‡§ò‡§æ‡§§ r n) (‡§ó‡•Å‡§£‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä-‡§Ø‡•ã‡§ó‡§É r n) ‚àô minusPlus (‡§ò‡§æ‡§§ r n) (pos 1))

------------------------------------------------------------------------
-- ‡‡‡-‡‡∞‡Æ‡‡‡∞‡æ ‚î the remainder recurses: each stage's remainder is the
-- previous one carried once more.  Definitional, pinned by name so the
-- recursion is a stated fact and not an accident of the definition.
------------------------------------------------------------------------

‡§∂‡•á‡§∑-‡§™‡§∞‡§Æ‡•ç‡§™‡§∞‡§æ : (r : ‚Ñ§) (n : ‚Ñï) ‚Üí ‡§ò‡§æ‡§§ r (suc n) ‚â° ‡§ò‡§æ‡§§ r n ¬∑‚Ñ§ r
‡§∂‡•á‡§∑-‡§™‡§∞‡§Æ‡•ç‡§™‡§∞‡§æ r n = refl
