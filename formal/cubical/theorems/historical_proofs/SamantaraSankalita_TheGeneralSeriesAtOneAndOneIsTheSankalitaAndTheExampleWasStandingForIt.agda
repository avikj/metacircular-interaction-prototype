{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡Æ‡æ‡®‡‡‡∞-‡‡ô‡‡ï‡≤‡ø‡‡Æ‡ ‚î ‡‡Æ‡æ‡®‡‡‡∞-‡‡‡∞‡‡‡ a=1, d=1 ‡‡‡ø ‡‡ô‡‡ï‡≤‡ø‡‡Æ‡ ‡‡µ ‡
--
-- (the arithmetic progression at first term one and common difference one
--  IS the sakalita ‚î proved, where the corpus had an example at n = 4.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE COLLISION.  Two modules of this corpus carry the same series under
-- two definitions, each cites ryabhaa, and NEITHER imports the other.
--
--   `Shredhi.agda`  (‡‡∞‡‡Ø‡‡ü‡‡Ø‡Æ‡ ‡ó‡‡ø‡‡‡æ‡¶‡ ‡ß‡Ø) defines
--       ‡‡‡∞‡‡‡ a d zero    = zero
--       ‡‡‡∞‡‡‡ a d (suc n) = a + ‡‡‡∞‡‡‡ (a + d) d n
--     ‚î the progression walked FORWARD, advancing the first term.
--
--   `Sankalita.agda` (‡‡∞‡‡Ø‡‡ü‡‡Ø‡Æ‡ ‡ó‡‡ø‡‡‡æ‡¶‡ ‡®‡ß‚ì‡®‡®) defines
--       ‚à zero    = zero
--       ‚à (suc n) = suc n + ‚à n
--     ‚î the same numbers walked BACKWARD, descending from n.
--
-- `Shredhi`'s own header says it: *"‚àk (Sankalita) ‡‡‡‡Ø‡æ‡ a=1,d=1
-- ‡µ‡ø‡‡‡‡"* ‚î ‚àk is the a=1, d=1 case of this.  That sentence is true and
-- it was never a theorem.  What stood in for it is `Shredhi.‡â‡¶‡æ‡‡∞‡‡Æ‡-‚à :
-- ‡‡‡∞‡‡‡ 1 1 4 ‚â° 10`, a `refl` at ONE value of n, with the comment
-- *"‚à1..4, the a=1 d=1 special case"*.  `Shredhi` has no
-- `open import Sankalita`; the two lanes never meet in a type.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS CHECKED
--
--   ¬ß1  `‡‡Æ‡æ‡®‡‡‡∞‡-‡‡ô‡‡ï‡≤‡ø‡‡Æ‡ : (n : ‚ï) ‚í ‡‡‡∞‡‡‡ 1 1 n ‚â° ‚à n`
--       for every n, by doubling both sides onto `n ¬ suc n` ‚î the one
--       closed form both lanes already reached from their own ends ‚î
--       and cancelling the 2 with `inj-sm¬`.  Nothing new is proved
--       about either series: the whole content is that the two closed
--       forms already in the corpus MEET, and nobody had joined them.
--
--   ¬ß2  `‡â‡¶‡æ‡‡∞‡‡Æ‡-‡‡‡®‡` ‚î `Shredhi.‡â‡¶‡æ‡‡∞‡‡Æ‡-‚à` demoted from a claim to
--       an instantiation of ¬ß1 at n = 4.
--
--   ¬ß3  `‡‡‡∞‡‡-‡µ‡ø‡®‡ø‡Æ‡Ø‡ : ‡‡‡∞‡‡‡ 1 1 (suc n) ‚â° suc n + ‡‡‡∞‡‡‡ 1 1 n` ‚î
--       the head/tail swap.  By definition `‡‡‡∞‡‡‡ 1 1 (suc n)` peels
--       the SMALLEST term (`1 + ‡‡‡∞‡‡‡ 2 1 n`); this says it may be
--       peeled from the LARGEST instead, which is `‚à`'s clause.  Not
--       definitional in either module ‚î it is the exact statement of
--       what the two recursions disagree about, and it falls out of ¬ß1
--       in one line.
------------------------------------------------------------------------

module SamantaraSankalita_TheGeneralSeriesAtOneAndOneIsTheSankalitaAndTheExampleWasStandingForIt where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_ ; _¬∑_ ; _‚à∏_)
open import Cubical.Data.Nat.Properties using (¬∑-comm ; ¬∑-identity ≥ ; inj-sm¬∑)

open import Sankalita_AryabhatasSeriesSumsAndTheCubeSumIsTheSquareOfTheSum using (‚àë ; ‡§¶‡•ç‡§µ‡§ø‡§ó‡•Å‡§£-‡§∏‡§ô‡•ç‡§ï‡§≤‡§ø‡§§‡§Æ‡•ç)
open import Shredhi   using (‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä ; ‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä-‡§´‡§≤‡§Æ‡•ç ; ‡§¶‡•ç‡§µ‡§ø-‡§Ø‡•ã‡§ó‡§É ; ‡§¶‡•ç‡§µ‡§ø¬∑)

------------------------------------------------------------------------
-- ‡ß ¬ ‡¶‡‡µ‡ø‡ó‡‡‡ ‡Æ‡‡≤‡®‡Æ‡ ‚î the two lanes meet after doubling.
--
-- LEFT   `‡‡‡∞‡‡‡-‡‡≤‡Æ‡ 1 1 n` : 2¬S ‚â° n¬(2¬1) + (n¬(n‚à1))¬1, then
--        `¬-identity ≥` and `¬-comm` put it in `‡¶‡‡µ‡ø-‡Ø‡ã‡ó‡`'s shape, and
--        `‡¶‡‡µ‡ø-‡Ø‡ã‡ó‡` (Shredhi's own lemma) closes it on n¬(n+1).
-- RIGHT  `‡¶‡‡µ‡ø‡ó‡‡-‡‡ô‡‡ï‡≤‡ø‡‡Æ‡` (Sankalita's own lemma) is n¬(n+1) again.
-- Neither lemma is new here.  Only the composite is.
------------------------------------------------------------------------

‡§¶‡•ç‡§µ‡§ø‡§ó‡•Å‡§£‡•á-‡§Æ‡•á‡§≤‡§®‡§Æ‡•ç : (n : ‚Ñï) ‚Üí 2 ¬∑ ‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä 1 1 n ‚â° 2 ¬∑ ‚àë n
‡§¶‡•ç‡§µ‡§ø‡§ó‡•Å‡§£‡•á-‡§Æ‡•á‡§≤‡§®‡§Æ‡•ç n =
    ‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä-‡§´‡§≤‡§Æ‡•ç 1 1 n
  ‚àô cong (n ¬∑ 2 +_) (¬∑-identity ≥ (n ¬∑ (n ‚à∏ 1)))
  ‚àô cong (_+ n ¬∑ (n ‚à∏ 1)) (¬∑-comm n 2)
  ‚àô ‡§¶‡•ç‡§µ‡§ø-‡§Ø‡•ã‡§ó‡§É n
  ‚àô sym (‡§¶‡•ç‡§µ‡§ø‡§ó‡•Å‡§£-‡§∏‡§ô‡•ç‡§ï‡§≤‡§ø‡§§‡§Æ‡•ç n)
  ‚àô sym (‡§¶‡•ç‡§µ‡§ø¬∑ (‚àë n))

------------------------------------------------------------------------
-- ‡Æ‡‡ñ‡‡Ø-‡‡ø‡¶‡‡ß‡ø‡ ‚î the specialisation, for every n.
------------------------------------------------------------------------

‡§∏‡§Æ‡§æ‡§®‡•ç‡§§‡§∞‡§Ç-‡§∏‡§ô‡•ç‡§ï‡§≤‡§ø‡§§‡§Æ‡•ç : (n : ‚Ñï) ‚Üí ‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä 1 1 n ‚â° ‚àë n
‡§∏‡§Æ‡§æ‡§®‡•ç‡§§‡§∞‡§Ç-‡§∏‡§ô‡•ç‡§ï‡§≤‡§ø‡§§‡§Æ‡•ç n = inj-sm¬∑ {m = 1} (‡§¶‡•ç‡§µ‡§ø‡§ó‡•Å‡§£‡•á-‡§Æ‡•á‡§≤‡§®‡§Æ‡•ç n)

------------------------------------------------------------------------
-- ‡® ¬ ‡â‡¶‡æ‡‡∞‡‡Æ‡ ‡‡‡®‡ ‚î Shredhi.‡â‡¶‡æ‡‡∞‡‡Æ‡-‚à as a corollary, not a claim.
------------------------------------------------------------------------

‡§â‡§¶‡§æ‡§π‡§∞‡§£‡§Æ‡•ç-‡§™‡•Å‡§®‡§É : ‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä 1 1 4 ‚â° ‚àë 4
‡§â‡§¶‡§æ‡§π‡§∞‡§£‡§Æ‡•ç-‡§™‡•Å‡§®‡§É = ‡§∏‡§Æ‡§æ‡§®‡•ç‡§§‡§∞‡§Ç-‡§∏‡§ô‡•ç‡§ï‡§≤‡§ø‡§§‡§Æ‡•ç 4

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡∞‡‡-‡µ‡ø‡®‡ø‡Æ‡Ø‡ ‚î either end may be peeled.
--
-- `‡‡‡∞‡‡‡` peels the smallest term and advances a; `‚à` peels the largest
-- and descends n.  This is the statement that the two are interchangeable,
-- which neither definition gives and ¬ß1 does.
------------------------------------------------------------------------

‡§∂‡•Ä‡§∞‡•ç‡§∑-‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø‡§É : (n : ‚Ñï) ‚Üí ‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä 1 1 (suc n) ‚â° suc n + ‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä 1 1 n
‡§∂‡•Ä‡§∞‡•ç‡§∑-‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø‡§É n =
    ‡§∏‡§Æ‡§æ‡§®‡•ç‡§§‡§∞‡§Ç-‡§∏‡§ô‡•ç‡§ï‡§≤‡§ø‡§§‡§Æ‡•ç (suc n)
  ‚àô cong (suc n +_) (sym (‡§∏‡§Æ‡§æ‡§®‡•ç‡§§‡§∞‡§Ç-‡§∏‡§ô‡•ç‡§ï‡§≤‡§ø‡§§‡§Æ‡•ç n))
