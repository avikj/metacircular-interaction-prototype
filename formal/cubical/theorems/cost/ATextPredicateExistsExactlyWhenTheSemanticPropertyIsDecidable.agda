{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ATextPredicateExistsExactlyWhenTheSemanticPropertyIsDecidable
--
-- open question and invites the next block to close it:
--
--   "Is there a mechanizable predicate on a note's *text* that decides
--    whether its principal object is outside arithmetic, and hence
--    whether a `SEARCH` flag is mandatory â” one that would have fired on
--    SEED-05 and SEED-09 and not on the 47 declared-classical files?"
--
-- This does not close it.  It relocates it, exactly: a text predicate
-- meeting that description exists **iff** the semantic property is
-- decidable of the text's denotation.  So no amount of work on the
-- FEATURES can produce one, and the question is not about text.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT Â§2 SAYS, AND WHY IT IS NOT A RESTATEMENT
--
-- Set-theoretically the question has a trivial affirmative answer â” the
-- composite `Outside âˆ˜ denotes` IS a predicate on texts.  The word doing
-- the work in Â§6 is MECHANIZABLE, and Â§2 is that word made exact in the
-- one form this substrate has for it: `Dec`.  The two directions are
-- both cheap and both needed, and together they say the reduction is an
-- equivalence and not merely a sufficient condition.
--
-- WHAT IT DOES NOT DO, said plainly because Â§6 asked for something else.
-- Â§6 licenses "a finite exhaustive check against a fixed, stated corpus
-- snapshot â” provided the checker states the snapshot and does not
-- report the result as a property of the corpus".  I did NOT run that
-- check.  Nothing below is evidence about SEED-05, SEED-09, or the 47
-- declared-classical files; no corpus was scanned and no snapshot is
-- stated because none was taken.  Â§2 is a reduction, and a reduction is
-- not an answer.
--
-- Nor does it say the property IS or IS NOT decidable.  It says where to
-- look: at `Outside âˆ˜ denotes`, not at the text.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module ATextPredicateExistsExactlyWhenTheSemanticPropertyIsDecidable where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; trueâ‰¢false ; falseâ‰¢true)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)

------------------------------------------------------------------------
-- 1.  Texts, what they denote, and the semantic property
------------------------------------------------------------------------

module _
  (Text Object : Type)
  (denotes : Text â†’ Object)
  (Outside : Object â†’ Type)   -- "the principal object is outside arithmetic"
  where

  -- a Boolean predicate on TEXT that is correct about the DENOTATION
  Correct : (Text â†’ Bool) â†’ Type
  Correct p =
    (t : Text) â†’ ((Outside (denotes t) â†’ p t â‰¡ true)
                Ã— (p t â‰¡ true â†’ Outside (denotes t)))

  --------------------------------------------------------------------
  -- 2.  Such a predicate exists exactly when the semantic property is
  --     decidable of the denotation
  --------------------------------------------------------------------

  decisionGivesPredicate :
    ((t : Text) â†’ Dec (Outside (denotes t)))
    â†’ Î£[ p âˆˆ (Text â†’ Bool) ] Correct p
  decisionGivesPredicate d = pOf , correct
    where
      pOf : Text â†’ Bool
      pOf t with d t
      ... | yes _ = true
      ... | no  _ = false

      correct : Correct pOf
      correct t with d t
      ... | yes o = (Î» _ â†’ refl) , (Î» _ â†’ o)
      ... | no Â¬o = (Î» o â†’ âŠ¥.rec (Â¬o o)) , (Î» e â†’ âŠ¥.rec (falseâ‰¢true e))

  predicateGivesDecision :
    Î£[ p âˆˆ (Text â†’ Bool) ] Correct p
    â†’ (t : Text) â†’ Dec (Outside (denotes t))
  predicateGivesDecision (p , c) t = go (p t) refl
    where
      go : (b : Bool) â†’ p t â‰¡ b â†’ Dec (Outside (denotes t))
      go true  e = yes (c t .snd e)
      go false e = no (Î» o â†’ trueâ‰¢false (sym (c t .fst o) âˆ™ e))

------------------------------------------------------------------------
-- 3.  The reading, and what remains open
--
-- Â§2 is an equivalence, so "is there a mechanizable text predicate?" and
-- "is the semantic property decidable of the denotation?" are the same
-- question.  Feature engineering on the text cannot answer it: the text
-- enters only through `denotes`, and every candidate predicate is
-- `Outside âˆ˜ denotes` with a decision attached.
--
-- SEED-83's question therefore stands, relocated.  What would settle it
-- is a decision procedure for `Outside` on the denotations, or a proof
-- there is none â” and, separately, the finite exhaustive check Â§6
-- licenses against a stated snapshot, which is an empirical question
-- about this corpus and is NOT what Â§2 addresses.
--
-- KEPT SEPARATE.  This is not the session's collision result in another
-- costume: nothing here says a coarse observation fails to determine a
-- fine one.  It says two QUESTIONS coincide.  The obstruction, if there
-- is one, lives in `Outside`, which is a parameter here and is not
-- examined.
------------------------------------------------------------------------
