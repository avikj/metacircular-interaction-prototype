{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡µ‡∞‡‡Æ‡ ‚î ‡‡æ‡‡‡ï‡∞‡‡‡Ø m-‡µ‡∞‡‡‡‡Ø ‡ó‡µ‡æ‡ï‡‡‡, ‡‡æ‡ß‡ø‡‡, ‡® ‡Æ‡æ‡‡ø‡‡ ‡
-- Varaa ‚î the width of Bhskara's m-choice window, DERIVED.
--
-- SOURCE AND DATE.  The ‡µ‡∞‡ ‚î the choice rule ‚î is BHSKARA II's contribution
-- to the ‡‡ï‡‡∞‡µ‡æ‡≤‡Æ‡ over Jayadeva: among the m satisfying the one congruence
-- k | (a + b¬m), take one minimising |m¬≤ ‚àí D|.  ‡‡‡‡ó‡‡ø‡‡Æ‡, 1150 CE; the cycle
-- itself is Jayadeva's, ~950, surviving through Udayadivkara's ‡‡‡®‡‡¶‡∞‡, 1073.
-- The congruence whose solutions m form the class is solved by RYABHAA's
-- ‡ï‡‡ü‡‡ü‡ï, ‡‡∞‡‡Ø‡‡ü‡‡Ø‡Æ‡ ‡ó‡‡ø‡‡‡æ‡¶‡ ‡©‡®‚ì‡©‡©, 499.  Nothing below claims Bhskara stated
-- the theorem in this file; he stated the rule, and this is what the rule
-- costs to execute.
--
-- WHY THIS FILE EXISTS.  `machine/Nalanda.hs`, `chooseM`, enumerates the
-- residue class m = r + t¬n only over
--
--     t ‚àà [t‚ ‚àí 2 .. t‚ + 2],       t‚ = (‚ä‚àD‚ã ‚àí r) div n
--
-- and its comment justifies the truncation like this, verbatim:
--
--     "the minimiser is adjacent to sqrt D, so a short window around it is
--      exhaustive rather than sampled -- the window is checked in `selfTest`
--      by re-running with a wider one and comparing."
--
-- The first clause is the theorem and the second is a measurement standing
-- in for it.  `CLAUDE.md`: *"a correlation coefficient has no content; the
-- content is the error term"*, and a comparison of two runs over six values
-- of D is the same object with the same emptiness ‚î it reports that nothing
-- went wrong on six inputs, which is not the claim.  Worse, the comparison
-- was not even testing the window: `cakravalaWide` still carried the |k| = 1
-- special case that `CakravalaBound.agda` ¬ß7 refuted, so the two functions
-- differed in their CHOICE RULE and not only in their window width, and both
-- rules reach the fundamental solution because any m satisfying the
-- ¬ß6.
--
-- So: the theorem, which is shorter than the experiment, as it has been every
-- time in this corpus.
--
-- WHAT IS PROVED.  No postulates, no holes, --safe, pin-green under Agda 2.8.0
-- + cubical v0.9.  No ring solver, no square roots, no absolute value, no
-- subtraction: every "distance from D" is carried as an explicit witness E on
-- the correct side of the equation, in the style `CakravalaBound.agda` uses
-- and for the same reason.
--
--   ‡µ‡∞‡-‡‡ß‡      BELOW THE ROOT, LARGER IS BETTER.  If c ‚â lo and both sit
--                below D (c¬≤ + E_c ‚â° D, lo¬≤ + E_lo ‚â° D) then E_lo ‚â E_c.
--   ‡µ‡∞‡-‡ä‡∞‡‡ß‡‡µ‡Æ‡   ABOVE THE ROOT, SMALLER IS BETTER.  If hi ‚â c and both sit
--                above D (D + E_hi ‚â° hi¬≤, D + E_c ‚â° c¬≤) then E_hi ‚â E_c.
--   ‡‡‡∞‡‡‡-‡‡®‡‡‡∞‡Æ‡  THE CLASS HAS NO MEMBER STRICTLY INSIDE THE BRACKET.  The
--                class members are r + t¬n; from t‚ < t follows
--                (r + t‚¬n) + n ‚â r + t¬n.  So between the last member at or
--                below ‚ä‚àD‚ã and the next one there is nothing.
--   ‡ó‡µ‡æ‡ï‡‡‡       THE WINDOW IS ¬1.  Given a bracketing pair lo ‚â ‚àD ‚â hi with
--                hi ‚â° lo + n, EVERY candidate outside {lo, hi} has cost at
--                least one of E_lo, E_hi.  Two candidates are therefore
--                exhaustive, and `chooseM`'s five are three more than the
--                argument needs ‚î which is fine, and is now a stated margin
--                rather than an unexamined one.
--
--   * That `t‚ = (‚ä‚àD‚ã ‚àí r) div n` DOES bracket, i.e. that
--     (r + t‚¬n)¬≤ ‚â D ‚â (r + (t‚+1)¬n)¬≤.  That is a fact about `div` and
--     `isqrt` in `machine/Nalanda.hs`, not about the choice rule, and it is
--     taken here as the hypothesis `lo ‚â hi`-with-costs rather than derived.
--     Naming it is the point: the window argument is complete GIVEN a
--     bracket, and producing the bracket is a separate obligation on the
--     Haskell side.
--   * Minimality of Bhskara's rule as a rule ‚î that minimising |m¬≤ ‚àí D| is
--     the right thing to do at all ‚î which is `CakravalaBound.cakravalaKBound`'s
--     hypothesis and is not this file's subject.
--   * Termination of the cycle, open in `CakravalaBound.agda`.
------------------------------------------------------------------------

module Varana_TheChoiceWindowIsDerivedNotFitted where

open import Cubical.Foundations.Prelude

open import Cubical.Data.Nat
  using (‚Ñï ; zero ; suc ; _+_ ; _¬∑_ ; +-comm ; +-assoc ; ¬∑-comm ; inj-m+)
open import Cubical.Data.Nat.Order
  using (_<_ ; _‚â§_ ; ‚â§-trans ; ‚â§-¬∑k ; ‚â§-k+ ; suc-‚â§-suc ; ‚â§-refl ; ‚â§-k+-cancel)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Sigma using (_√ó_ ; _,_)

------------------------------------------------------------------------
-- ‡¶ ¬ two order facts cubical does not ship in this shape.
------------------------------------------------------------------------

private
  ‚â§-k¬∑' : {m n : ‚Ñï} (k : ‚Ñï) ‚Üí m ‚â§ n ‚Üí k ¬∑ m ‚â§ k ¬∑ n
  ‚â§-k¬∑' {m} {n} k h = subst2 _‚â§_ (¬∑-comm m k) (¬∑-comm n k) (‚â§-¬∑k {k = k} h)

  -- squaring is monotone.
  ‡§µ‡§∞‡•ç‡§ó-‡§ï‡•ç‡§∞‡§Æ‡§É : {m n : ‚Ñï} ‚Üí m ‚â§ n ‚Üí m ¬∑ m ‚â§ n ¬∑ n
  ‡§µ‡§∞‡•ç‡§ó-‡§ï‡•ç‡§∞‡§Æ‡§É {m} {n} h = ‚â§-trans (‚â§-¬∑k {k = m} h) (‚â§-k¬∑' n h)

  -- from P ‚â Q and Q + X ‚â° P + Y conclude X ‚â Y.  (The same lemma
  -- `CakravalaBound.agda` builds; that module is not imported because it is
  -- pinned to the v0.5 solver spelling and does not check under the pin.)
  ‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø‡§É : (P Q X Y : ‚Ñï) ‚Üí P ‚â§ Q ‚Üí Q + X ‚â° P + Y ‚Üí X ‚â§ Y
  ‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø‡§É P Q X Y (c , hc) e = c , inj-m+ {m = P} step
    where
    assoc1 : P + (c + X) ‚â° Q + X
    assoc1 = +-assoc P c X ‚àô cong (_+ X) (+-comm P c) ‚àô cong (_+ X) hc

    step : P + (c + X) ‚â° P + Y
    step = assoc1 ‚àô e

------------------------------------------------------------------------
-- ‡ß ¬ ‡µ‡∞‡-‡‡ß‡ ‚î below the root, the larger candidate is the better one.
--
-- lo¬≤ + E_lo ‚â° D and c¬≤ + E_c ‚â° D with c ‚â lo.  Then c¬≤ ‚â lo¬≤, and the two
-- equations shift the inequality onto the costs the other way round.
------------------------------------------------------------------------

‡§µ‡§∞‡§£-‡§Ö‡§ß‡§É : (D lo c Elo Ec : ‚Ñï)
        ‚Üí c ‚â§ lo
        ‚Üí lo ¬∑ lo + Elo ‚â° D
        ‚Üí c ¬∑ c + Ec ‚â° D
        ‚Üí Elo ‚â§ Ec
‡§µ‡§∞‡§£-‡§Ö‡§ß‡§É D lo c Elo Ec c‚â§lo hlo hc =
  ‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø‡§É (c ¬∑ c) (lo ¬∑ lo) Elo Ec (‡§µ‡§∞‡•ç‡§ó-‡§ï‡•ç‡§∞‡§Æ‡§É c‚â§lo) (hlo ‚àô sym hc)

------------------------------------------------------------------------
-- ‡® ¬ ‡µ‡∞‡-‡ä‡∞‡‡ß‡‡µ‡Æ‡ ‚î above the root, the smaller candidate is the better one.
--
-- D + E_hi ‚â° hi¬≤ and D + E_c ‚â° c¬≤ with hi ‚â c.  Then hi¬≤ ‚â c¬≤, so
-- D + E_hi ‚â D + E_c, and D cancels.
------------------------------------------------------------------------

‡§µ‡§∞‡§£-‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§Æ‡•ç : (D hi c Ehi Ec : ‚Ñï)
          ‚Üí hi ‚â§ c
          ‚Üí D + Ehi ‚â° hi ¬∑ hi
          ‚Üí D + Ec  ‚â° c ¬∑ c
          ‚Üí Ehi ‚â§ Ec
‡§µ‡§∞‡§£-‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§Æ‡•ç D hi c Ehi Ec hi‚â§c hhi hcc =
  ‚â§-k+-cancel {k = D} (subst2 _‚â§_ (sym hhi) (sym hcc) (‡§µ‡§∞‡•ç‡§ó-‡§ï‡•ç‡§∞‡§Æ‡§É hi‚â§c))

------------------------------------------------------------------------
-- ‡© ¬ ‡‡‡∞‡‡‡-‡‡®‡‡‡∞‡Æ‡ ‚î the class has no member strictly inside the bracket.
------------------------------------------------------------------------

‡§∂‡•ç‡§∞‡•á‡§£‡•Ä-‡§Ö‡§®‡•ç‡§§‡§∞‡§Æ‡•ç : (r n t‚ÇÄ t : ‚Ñï) ‚Üí suc t‚ÇÄ ‚â§ t ‚Üí r + (suc t‚ÇÄ) ¬∑ n ‚â§ r + t ¬∑ n
‡§∂‡•ç‡§∞‡•á‡§£‡•Ä-‡§Ö‡§®‡•ç‡§§‡§∞‡§Æ‡•ç r n t‚ÇÄ t h = ‚â§-k+ (‚â§-¬∑k {k = n} h)

-- and the next class member after `r + t‚¬n` is exactly `n` further on.
‡§∂‡•ç‡§∞‡•á‡§£‡•Ä-‡§™‡§¶‡§Æ‡•ç : (r n t‚ÇÄ : ‚Ñï) ‚Üí r + (suc t‚ÇÄ) ¬∑ n ‚â° (r + t‚ÇÄ ¬∑ n) + n
‡§∂‡•ç‡§∞‡•á‡§£‡•Ä-‡§™‡§¶‡§Æ‡•ç r n t‚ÇÄ =
    cong (r +_) (+-comm n (t‚ÇÄ ¬∑ n))
  ‚àô +-assoc r (t‚ÇÄ ¬∑ n) n

------------------------------------------------------------------------
-- ‡ ¬ ‡ó‡µ‡æ‡ï‡‡‡ ‚î THE WINDOW IS ¬1.
--
-- Given a bracketing pair ‚î lo at or below ‚àD with cost E_lo, hi at or above
-- ‚àD with cost E_hi ‚î every candidate c outside {lo, hi}, on whichever side,
-- with its cost stated on the correct side of D, is beaten by one of them.
--
-- Read as the statement about `chooseM`: enumerating t‚ and t‚+1 loses
-- nothing, so the ¬2 in the source is a margin of three and not a hope.
------------------------------------------------------------------------

‡§ó‡§µ‡§æ‡§ï‡•ç‡§∑‡§É : (D lo hi c Elo Ehi Ec : ‚Ñï)
       ‚Üí lo ¬∑ lo + Elo ‚â° D
       ‚Üí D + Ehi ‚â° hi ¬∑ hi
       ‚Üí ((c ‚â§ lo) √ó (c ¬∑ c + Ec ‚â° D)) ‚äé ((hi ‚â§ c) √ó (D + Ec ‚â° c ¬∑ c))
       ‚Üí (Elo ‚â§ Ec) ‚äé (Ehi ‚â§ Ec)
‡§ó‡§µ‡§æ‡§ï‡•ç‡§∑‡§É D lo hi c Elo Ehi Ec hlo hhi (inl (c‚â§lo , hc)) =
  inl (‡§µ‡§∞‡§£-‡§Ö‡§ß‡§É D lo c Elo Ec c‚â§lo hlo hc)
‡§ó‡§µ‡§æ‡§ï‡•ç‡§∑‡§É D lo hi c Elo Ehi Ec hlo hhi (inr (hi‚â§c , hc)) =
  inr (‡§µ‡§∞‡§£-‡§ä‡§∞‡•ç‡§ß‡•ç‡§µ‡§Æ‡•ç D hi c Ehi Ec hi‚â§c hhi hc)
