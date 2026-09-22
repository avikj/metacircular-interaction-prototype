{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ATextPredicateExistsExactlyWhenTheSemanticPropertyIsDecidable
--
-- The question:
--
--   "Is there a mechanizable predicate on a note's *text* that decides
--    whether its principal object is outside arithmetic, and hence
--    whether a `SEARCH` flag is mandatory — one that would have fired on
--    SEED-05 and SEED-09 and not on the 47 declared-classical files?"
--
-- It is relocated, exactly: a text predicate
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
-- §2 says where to look: at `Outside ∘ denotes`, not at the text.
------------------------------------------------------------------------

module ATextPredicateExistsExactlyWhenTheSemanticPropertyIsDecidable where

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
-- 3.  The reading
--
-- §2 is an equivalence, so "is there a mechanizable text predicate?" and
-- "is the semantic property decidable of the denotation?" are the same
-- question.  Feature engineering on the text cannot answer it: the text
-- enters only through `denotes`, and every candidate predicate is
-- `Outside ∘ denotes` with a decision attached.
------------------------------------------------------------------------
