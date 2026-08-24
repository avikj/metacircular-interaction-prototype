-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ATextPredicateExistsExactlyWhenTheSemanticPropertyIsDecidable
--
-- `notes/SEED83_COMPLETENESS_IS_A_MATERIALIZED_VIEW.md` §6 states an
-- open question and invites the next block to close it:
--
--   "Is there a mechanizable predicate on a note's *text* that decides
--    whether its principal object is outside arithmetic, and hence
--    whether a `SEARCH` flag is mandatory — one that would have fired on
--    SEED-05 and SEED-09 and not on the 47 declared-classical files?"
--
-- This does not close it.  It relocates it, exactly: a text predicate
-- meeting that description exists **iff** the semantic property is
-- decidable of the text's denotation.  So no amount of work on the
-- FEATURES can produce one, and the question is not about text.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT §2 SAYS, AND WHY IT IS NOT A RESTATEMENT
--
-- Set-theoretically the question has a trivial affirmative answer — the
-- composite `Outside ∘ denotes` IS a predicate on texts.  The word doing
-- the work in §6 is MECHANIZABLE, and §2 is that word made exact in the
-- one form this substrate has for it: `Dec`.  The two directions are
-- both cheap and both needed, and together they say the reduction is an
-- equivalence and not merely a sufficient condition.
--
-- WHAT IT DOES NOT DO, said plainly because §6 asked for something else.
-- §6 licenses "a finite exhaustive check against a fixed, stated corpus
-- snapshot — provided the checker states the snapshot and does not
-- report the result as a property of the corpus".  I did NOT run that
-- check.  Nothing below is evidence about SEED-05, SEED-09, or the 47
-- declared-classical files; no corpus was scanned and no snapshot is
-- stated because none was taken.  §2 is a reduction, and a reduction is
-- not an answer.
--
-- Nor does it say the property IS or IS NOT decidable.  It says where to
-- look: at `Outside ∘ denotes`, not at the text.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.ATextPredicateExistsExactlyWhenTheSemanticPropertyIsDecidable where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false ; false≢true)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

------------------------------------------------------------------------
-- 1.  Texts, what they denote, and the semantic property
------------------------------------------------------------------------

module _
  (Text Object : Type)
  (denotes : Text → Object)
  (Outside : Object → Type)   -- "the principal object is outside arithmetic"
  where

  -- a Boolean predicate on TEXT that is correct about the DENOTATION
  Correct : (Text → Bool) → Type
  Correct p =
    (t : Text) → ((Outside (denotes t) → p t ≡ true)
                × (p t ≡ true → Outside (denotes t)))

  --------------------------------------------------------------------
  -- 2.  Such a predicate exists exactly when the semantic property is
  --     decidable of the denotation
  --------------------------------------------------------------------

  decisionGivesPredicate :
    ((t : Text) → Dec (Outside (denotes t)))
    → Σ[ p ∈ (Text → Bool) ] Correct p
  decisionGivesPredicate d = pOf , correct
    where
      pOf : Text → Bool
      pOf t with d t
      ... | yes _ = true
      ... | no  _ = false

      correct : Correct pOf
      correct t with d t
      ... | yes o = (λ _ → refl) , (λ _ → o)
      ... | no ¬o = (λ o → ⊥.rec (¬o o)) , (λ e → ⊥.rec (false≢true e))

  predicateGivesDecision :
    Σ[ p ∈ (Text → Bool) ] Correct p
    → (t : Text) → Dec (Outside (denotes t))
  predicateGivesDecision (p , c) t = go (p t) refl
    where
      go : (b : Bool) → p t ≡ b → Dec (Outside (denotes t))
      go true  e = yes (c t .snd e)
      go false e = no (λ o → true≢false (sym (c t .fst o) ∙ e))

------------------------------------------------------------------------
-- 3.  The reading, and what remains open
--
-- §2 is an equivalence, so "is there a mechanizable text predicate?" and
-- "is the semantic property decidable of the denotation?" are the same
-- question.  Feature engineering on the text cannot answer it: the text
-- enters only through `denotes`, and every candidate predicate is
-- `Outside ∘ denotes` with a decision attached.
--
-- SEED-83's question therefore stands, relocated.  What would settle it
-- is a decision procedure for `Outside` on the denotations, or a proof
-- there is none — and, separately, the finite exhaustive check §6
-- licenses against a stated snapshot, which is an empirical question
-- about this corpus and is NOT what §2 addresses.
--
-- KEPT SEPARATE.  This is not the session's collision result in another
-- costume: nothing here says a coarse observation fails to determine a
-- fine one.  It says two QUESTIONS coincide.  The obstruction, if there
-- is one, lives in `Outside`, which is a parameter here and is not
-- examined.
------------------------------------------------------------------------
