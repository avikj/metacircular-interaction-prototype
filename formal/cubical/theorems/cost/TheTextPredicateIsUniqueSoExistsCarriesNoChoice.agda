{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheTextPredicateIsUniqueSoExistsCarriesNoChoice
--
-- ON THE NAME.  Checked before naming: `.claude/hooks/priority-ledger.txt`
-- (CURRENT header) and `.claude/hooks/european-frame.txt`; `formal/` and
-- invented.**  The subject is SEED-83 ¬ß6's question, i.e. this corpus's
-- own, and the h-level step is the declared substrate.  I have
-- established no Indian source for either.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE AUDIT.  Target:
-- `ATextPredicateExistsExactlyWhenTheSemanticPropertyIsDecidable`, an
-- `ExistsExactlyWhen`.
--
-- **THE BICONDITIONAL IS EARNED.**  `decisionGivesPredicate` and
-- `predicateGivesDecision` are both there, both cheap, and the module
-- says in its own ¬ß2 that both are needed and why.  It also states
-- plainly that it did NOT run the finite check ¬ß6 licenses, and that a
-- reduction is not an answer.
--
-- **THE WORD CARRYING THE CLAIM IS `EXISTS`, AND IT HAS THE USUAL TWO
-- READINGS.**  The statement is `Œ[ p ‚àà (Text ‚í Bool) ] Correct p` ‚î
-- STRUCTURE, a predicate together with a proof ‚î where "a mechanizable
-- predicate exists" reads as a PROPERTY.  Over a general type those
-- differ, and the difference is exactly whether the claim carries a
-- choice: which correct predicate did you get?
--
-- **HERE IT CARRIES NONE, AND THAT IS STRONGER THAN THE TRUNCATION
-- QUESTION.**  `Correct p` pins `p t ‚â° true` to `Outside (denotes t)` in
-- both directions, and `Bool` has two elements, so any two correct
-- predicates agree at every text: `correctIsUnique`.  There is nothing
-- to choose.  So the untruncated `Œ` is not an overstatement of the
-- truncated `‚à Œ ‚à‚` ‚î it is the same claim, and ¬ß2's use of `Œ` was
-- right for a reason it did not give.
--
-- **AND THE Œ IS A PROPOSITION OUTRIGHT WHEN `Outside` IS.**  Uniqueness
-- gives the first component; `Correct p`'s second half lands in
-- `Outside (denotes t)`, which is an arbitrary type in the audited
-- module, so the h-level of the pair needs `Outside` pointwise
-- propositional and gets it no cheaper.  **That hypothesis is the
-- price, it is real, and it is not free** ‚î which is the honest
-- difference from d3963e51 and b716cfee, where both sides were
-- propositions already.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   correctIsUnique      any two correct text predicates are equal, by
--                        `funExt` over a four-case analysis with the
--                        Boolean values passed as ARGUMENTS, not `with`
--   isPropCorrect        `Correct p` is a proposition when `Outside` is
--                        pointwise one
--   theTextPredicateIsUnique
--                        hence the whole `Œ` is a proposition, by
--                        `ŒPathP` and `isProp‚íPathP`
------------------------------------------------------------------------

module TheTextPredicateIsUniqueSoExistsCarriesNoChoice where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isPropŒ† ; isProp√ó)
open import Cubical.Data.Bool using (Bool ; true ; false ; isSetBool ; true‚â¢false)
open import Cubical.Data.Sigma using (Œ£-syntax ; Œ£PathP ; _,_ ; fst ; snd)
open import Cubical.Data.Empty as ‚ä• using (‚ä•)

open import ATextPredicateExistsExactlyWhenTheSemanticPropertyIsDecidable
  using (Correct)

module _
  (Text Object : Type)
  (denotes : Text ‚Üí Object)
  (Outside : Object ‚Üí Type)
  where

  private
    Corr : (Text ‚Üí Bool) ‚Üí Type
    Corr = Correct Text Object denotes Outside

  ------------------------------------------------------------------
  -- 1.  Correctness determines the predicate
  ------------------------------------------------------------------

  correctIsUnique :
    (p q : Text ‚Üí Bool) ‚Üí Corr p ‚Üí Corr q ‚Üí p ‚â° q
  correctIsUnique p q cp cq = funExt pointwise
    where
      go : (t : Text) (b c : Bool) ‚Üí p t ‚â° b ‚Üí q t ‚â° c ‚Üí p t ‚â° q t
      go t true  true  e‚ÇÅ e‚ÇÇ = e‚ÇÅ ‚àô sym e‚ÇÇ
      go t false false e‚ÇÅ e‚ÇÇ = e‚ÇÅ ‚àô sym e‚ÇÇ
      go t true  false e‚ÇÅ e‚ÇÇ =
        ‚ä•.rec (true‚â¢false (sym (cq t .fst (cp t .snd e‚ÇÅ)) ‚àô e‚ÇÇ))
      go t false true  e‚ÇÅ e‚ÇÇ =
        ‚ä•.rec (true‚â¢false (sym (cp t .fst (cq t .snd e‚ÇÇ)) ‚àô e‚ÇÅ))

      pointwise : (t : Text) ‚Üí p t ‚â° q t
      pointwise t = go t (p t) (q t) refl refl

  ------------------------------------------------------------------
  -- 2.  And with `Outside` pointwise propositional, so is the whole Œ
  ------------------------------------------------------------------

  isPropCorrect :
    ((o : Object) ‚Üí isProp (Outside o))
    ‚Üí (p : Text ‚Üí Bool) ‚Üí isProp (Corr p)
  isPropCorrect po p =
    isPropŒ† (Œª t ‚Üí
      isProp√ó (isPropŒ† (Œª _ ‚Üí isSetBool (p t) true))
              (isPropŒ† (Œª _ ‚Üí po (denotes t))))

  theTextPredicateIsUnique :
    ((o : Object) ‚Üí isProp (Outside o))
    ‚Üí isProp (Œ£[ p ‚àà (Text ‚Üí Bool) ] Corr p)
  theTextPredicateIsUnique po (p , cp) (q , cq) =
    Œ£PathP ( correctIsUnique p q cp cq
           , isProp‚ÜíPathP
               (Œª i ‚Üí isPropCorrect po (correctIsUnique p q cp cq i))
               cp cq )
