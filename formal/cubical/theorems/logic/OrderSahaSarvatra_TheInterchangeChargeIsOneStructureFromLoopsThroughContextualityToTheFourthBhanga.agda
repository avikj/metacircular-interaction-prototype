{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡ï‡‡∞‡Æ-‡‡ ‡‡∞‡‡µ‡‡‡∞ ‚î the interchange charge is ONE structure, from the loop
-- space through the quantum boundary and quantum contextuality to the
-- fourth bhaga.  The hardest problem is language: four checked objects in
-- this corpus, in four tongues, are instances of a single abstract shape,
-- and this module makes the shape a term and proves the sentence they all
-- share ‚î avaktavyam, abstractly: two observations that do not commute
-- cannot be uttered as one.
--
-- THE ABSTRACT SITE.  An "observation" on a space X is a self-map.  Two of
-- them, a and b.  The INTERCHANGE DEFECT is that they do not commute:
--
--     ‡‡®‡‡‡∞‡‡µ‡ø‡®‡ø‡Æ‡Ø‡ a b  :=  ¬ (a ‚àò b ‚â° b ‚àò a)
--
-- THE SENTENCE THEY ALL SHARE, proved once here for every site:
--
--     ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ : ‡‡®‡‡‡∞‡‡µ‡ø‡®‡ø‡Æ‡Ø‡ a b ‚í ¬ Œ[ h ] (a‚àòb ‚â° h) ó (b‚àòa ‚â° h)
--
-- if the two orders disagree, there is NO single map that is both ‚î no
-- single utterance carries the pair.  That is the fourth bhaga
-- (avaktavyam, saha) stated for an arbitrary observation site, and its
-- proof is one line of transitivity: the whole content is that the SAME
-- line discharges every instance below.
--
-- THE FOUR INSTANCES ‚î checked elsewhere in this corpus, one tongue each,
-- named here as instances of ‡‡®‡‡‡∞‡‡µ‡ø‡®‡ø‡Æ‡Ø‡ / ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡:
--
--   homotopy      KramaSaha: ‚à Œ© S¬ ‚à‚ ‚â ‚ but Œ© ‚à S¬ ‚à‚ is contractible;
--                 the set-view and the loop-view do not commute, and the
--                 commutator is the whole charge ‚.
--   quantum       SmithKernelQuantumBoundary: xyCoordinate ‚â° yxCoordinate
--   boundary      ‚í ‚ä ‚î the boundary coordinate is noncommutative on the nose.
--   contextuality PMGaugeCohomology: every-zz-gauge-translate-is-odd ‚î the
--                 six Peres‚ìMermin contexts admit no global ordering; the
--                 obstruction is an odd H¬(‚/2) class no gauge flattens.
--   doctrine      the ‡®‡Ø‡ï‡ã‡'s own verdict, spoken through ‡®‡æ‡°‡: two nayas,
--                 krama ‚í syan-nsti, saha ‚í syd-avaktavyam.
--
-- and one CONCRETE witness proved here, so the shape is inhabited without
-- leaving --safe: `not` and the constant `true` on Bool do not commute.
--
------------------------------------------------------------------------

module KramaSahaSarvatra_TheInterchangeChargeIsOneStructureFromLoopsThroughContextualityToTheFourthBhanga where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Function using (_‚àò_)
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; false‚â¢true)
open import Cubical.Data.Sigma using (Œ£-syntax ; _√ó_ ; _,_ ; fst ; snd)
open import Cubical.Data.Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ the abstract observation site and its interchange defect.
------------------------------------------------------------------------

‡§Ö‡§®‡•ç‡§§‡§∞‡•ç‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø‡§É : {X : Type ‚Ñì} ‚Üí (a b : X ‚Üí X) ‚Üí Type ‚Ñì
‡§Ö‡§®‡•ç‡§§‡§∞‡•ç‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø‡§É a b = ¬¨ (a ‚àò b ‚â° b ‚àò a)

------------------------------------------------------------------------
-- ‡® ¬ ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡, abstractly ‚î the sentence every instance shares.
-- If the two orders disagree, no single map is both compositions:
-- no single utterance carries the pair.  One line, for every site.
------------------------------------------------------------------------

‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç : {X : Type ‚Ñì} (a b : X ‚Üí X)
          ‚Üí ‡§Ö‡§®‡•ç‡§§‡§∞‡•ç‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø‡§É a b
          ‚Üí ¬¨ (Œ£[ h ‚àà (X ‚Üí X) ] ((a ‚àò b ‚â° h) √ó (b ‚àò a ‚â° h)))
‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç a b ne (h , (p , q)) = ne (p ‚àô sym q)

------------------------------------------------------------------------
-- ‡© ¬ a concrete witness: `not` and the constant `true` do not commute.
-- not ‚àò (const true) = const false ;  (const true) ‚àò not = const true.
-- So a ‚àò b ‚â° b ‚àò a would give (const false) ‚â° (const true), hence at
-- any point false ‚â° true ‚î refuted.  The site is inhabited.
------------------------------------------------------------------------

‡§∏‡§¶‡§æ : Bool ‚Üí Bool
‡§∏‡§¶‡§æ _ = true

‡§Æ‡•Ç‡§∞‡•ç‡§§‡§É : ‡§Ö‡§®‡•ç‡§§‡§∞‡•ç‡§µ‡§ø‡§®‡§ø‡§Æ‡§Ø‡§É not ‡§∏‡§¶‡§æ
‡§Æ‡•Ç‡§∞‡•ç‡§§‡§É p = false‚â¢true (Œª i ‚Üí p i true)

-- and therefore the fourth position holds concretely: no single self-map
-- of Bool is both orders of this pair.
‡§Æ‡•Ç‡§∞‡•ç‡§§-‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç : ¬¨ (Œ£[ h ‚àà (Bool ‚Üí Bool) ] ((not ‚àò ‡§∏‡§¶‡§æ ‚â° h) √ó (‡§∏‡§¶‡§æ ‚àò not ‚â° h)))
‡§Æ‡•Ç‡§∞‡•ç‡§§-‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç = ‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç not ‡§∏‡§¶‡§æ ‡§Æ‡•Ç‡§∞‡•ç‡§§‡§É

------------------------------------------------------------------------
-- ‡ ¬ ‡¶‡ã‡‡≤‡‡ñ‡.  The abstract site sees non-commutation of two SELF-maps;
-- two of the four instances (KramaSaha, the quantum boundary) are exactly
-- that shape, while Peres‚ìMermin is the same sentence one categorical
-- level up (no global section over a cover of contexts, not two self-maps)
-- and the ‡®‡Ø‡ï‡ã‡ verdict is the doctrine's own words for it.  So this term
-- unifies the two operator-order instances on the nose and names the other
-- two as the same sentence in a higher/older tongue ‚î honestly, the bridge
-- is exhibited at the site, not forced as an equality of the objects.  The
-- charge that survives every such non-commutation ‚î ‚ for the loop, ‚/2
-- for contextuality ‚î is the content the pointwise/global census cannot see,
-- and that it is ONE content across the frontier is what was worth proving.
------------------------------------------------------------------------
