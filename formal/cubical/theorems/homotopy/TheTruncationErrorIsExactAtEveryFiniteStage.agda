{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTruncationErrorIsExactAtEveryFiniteStage
--
-- The error of a truncated geometric series is not un-said in this
-- corpus: it is exactly r‚ø, at every finite n, over ‚, with no limit and
-- no analysis.  What needs analysis is only its asymptotics.
--
-- And the truncated sum alone does not carry it: at n = 1 the partial
-- sum is `1` for EVERY ratio, while the error is the ratio itself.  So
-- the error term separates exactly what the truncation identifies ‚î
-- `CLAUDE.md`'s own sentence, "a correlation coefficient has no content;
-- the content is the error term", as a theorem, on the object the Kerala
-- school used it on.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT `Madhava.agda` SAYS, READ IN FULL, AND WHERE I NARROW IT
--
-- `Madhava.‡ó‡‡‡‡‡∞‡‡‡-‡Ø‡ã‡ó‡ : (1 ‚àí r) ¬ ‚à_{k<n} rµ ‚â° 1 ‚àí r‚ø` over ‚, by
-- induction ‚î I read the signature and the proof body before importing.
-- Its honesty ledger then says, in its own words (lines 17‚ì20):
--
--   "‡‡‡-‡‡¶‡Æ‡ ‡‡µ ‡‡æ‡∞‡ ; ‡‡‡ ‡‡ ‡‡®‡‡ï‡‡‡Æ‡, ‡® ‡Æ‡ø‡‡‡Ø‡æ-‡‡ø‡¶‡‡ß‡Æ‡"
--   ‚î the remainder term is the essence; here it is UN-SAID, not
--     falsely proved
--
-- because r‚ø/(1‚àír) ‚í 0 needs ‚/‚ analysis that lane does not have.
--
-- The convergence claim is indeed un-said and stays un-said.  But the
-- REMAINDER ITSELF is not: ¬ß1 below is that module's own theorem plus
-- `minusPlus`, and it says the error is exactly r‚ø.  So the ledger's
-- "the remainder term is un-said" is wider than what it needs to be; the
-- statement that survives is "the remainder's *asymptotics* are un-said".
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
------------------------------------------------------------------------

module TheTruncationErrorIsExactAtEveryFiniteStage where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; znots ; injSuc)
open import Cubical.Data.Int using (‚Ñ§ ; pos ; _+_ ; _¬∑_ ; _-_ ; injPos)
open import Cubical.Data.Int.Properties using (minusPlus ; ¬∑Comm ; ¬∑IdR)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (¬¨_)

open import Madhava using (‡§ò‡§æ‡§§ ; ‡§∏‡§ô‡•ç‡§ï‡§≤‡§ø‡§§‡§Æ‡•ç ; ‡§ó‡•Å‡§£‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä-‡§Ø‡•ã‡§ó‡§É)

open import FiniteInformation using (FactorsThrough)
open import TranscriptDescent using (collisionObstructsDecoder)

------------------------------------------------------------------------
-- 1.  The remainder, exactly, at every finite n
--
-- Reading `Madhava.‡ó‡‡‡‡‡∞‡‡‡-‡Ø‡ã‡ó‡` as a statement about error rather than
-- about the sum: the scaled partial sum plus r‚ø is exactly 1.  No limit,
-- no convergence, no ‚ ‚î the same induction, rearranged.
------------------------------------------------------------------------

exactRemainder :
  (r : ‚Ñ§) (n : ‚Ñï)
  ‚Üí (pos 1 - r) ¬∑ ‡§∏‡§ô‡•ç‡§ï‡§≤‡§ø‡§§‡§Æ‡•ç r n + ‡§ò‡§æ‡§§ r n ‚â° pos 1
exactRemainder r n =
    cong (_+ ‡§ò‡§æ‡§§ r n) (‡§ó‡•Å‡§£‡§∂‡•ç‡§∞‡•á‡§¢‡•Ä-‡§Ø‡•ã‡§ó‡§É r n)
  ‚àô minusPlus (‡§ò‡§æ‡§§ r n) (pos 1)

------------------------------------------------------------------------
-- 2.  The partial sum, and what it forgets
--
-- At n = 1 the sum is `1` whatever the ratio; the error at n = 1 IS the
-- ratio.  So one step of truncation already discards everything the
-- error carries.
------------------------------------------------------------------------

sumAtOneIsOne : (r : ‚Ñ§) ‚Üí ‡§∏‡§ô‡•ç‡§ï‡§≤‡§ø‡§§‡§Æ‡•ç r 1 ‚â° pos 1
sumAtOneIsOne r = refl

errorAtOneIsTheRatio : (r : ‚Ñ§) ‚Üí ‡§ò‡§æ‡§§ r 1 ‚â° r
errorAtOneIsTheRatio r = ¬∑Comm (pos 1) r ‚àô ¬∑IdR r

------------------------------------------------------------------------
-- 3.  The error's own step, and the exact point where analysis begins
------------------------------------------------------------------------

errorStep : (r : ‚Ñ§) (n : ‚Ñï) ‚Üí ‡§ò‡§æ‡§§ r (suc n) ‚â° ‡§ò‡§æ‡§§ r n ¬∑ r
errorStep r n = refl

sumStep : (r : ‚Ñ§) (n : ‚Ñï) ‚Üí ‡§∏‡§ô‡•ç‡§ï‡§≤‡§ø‡§§‡§Æ‡•ç r (suc n) ‚â° ‡§∏‡§ô‡•ç‡§ï‡§≤‡§ø‡§§‡§Æ‡•ç r n + ‡§ò‡§æ‡§§ r n
sumStep r n = refl

-- What ¬ß3 does NOT say: that `‡ò‡æ‡ r n ¬ r` is smaller than `‡ò‡æ‡ r n`.
-- That is an order statement, it is where ‚/‚ analysis would be needed,
-- and it is exactly the part `Madhava.agda`'s ledger is right to leave
-- un-said.  Nothing above or below uses an order on ‚.

------------------------------------------------------------------------
-- 4.  THE COLLISION.  The error separates what the truncation identifies.
--
-- Isolated in the corpus's standing shape, so the general lemma applies
-- rather than a fresh argument being written.  Seventh site of
-- `TranscriptDescent.collisionObstructsDecoder`.
------------------------------------------------------------------------

private
  2‚â¢3 : ¬¨ (pos 2 ‚â° pos 3)
  2‚â¢3 p = znots (injSuc (injSuc (injPos p)))

truncate error : ‚Ñ§ ‚Üí ‚Ñ§
truncate r = ‡§∏‡§ô‡•ç‡§ï‡§≤‡§ø‡§§‡§Æ‡•ç r 1
error    r = ‡§ò‡§æ‡§§ r 1

truncationCollision :
  Œ£[ a ‚àà ‚Ñ§ ] Œ£[ b ‚àà ‚Ñ§ ] ((truncate a ‚â° truncate b) √ó (¬¨ (error a ‚â° error b)))
truncationCollision =
  pos 2 , pos 3 , refl ,
  Œª h ‚Üí 2‚â¢3 (sym (errorAtOneIsTheRatio (pos 2)) ‚àô h ‚àô errorAtOneIsTheRatio (pos 3))

errorDoesNotFactorThroughTheTruncation :
  ¬¨ FactorsThrough truncate error
errorDoesNotFactorThroughTheTruncation =
  collisionObstructsDecoder truncate error {pos 2} {pos 3}
    refl
    (Œª h ‚Üí 2‚â¢3 (sym (errorAtOneIsTheRatio (pos 2)) ‚àô h ‚àô errorAtOneIsTheRatio (pos 3)))

------------------------------------------------------------------------
-- 5.  The sentence this earns, and its exact scope
--
-- `CLAUDE.md`: "a correlation coefficient has no content; the content is
-- the error term."  ¬ß4 is that, on Mdhava's own object and at one step:
-- the truncation is constant in the ratio, the error is the identity in
-- it, and no invariant of the former reports the latter.
--
------------------------------------------------------------------------
