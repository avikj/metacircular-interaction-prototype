{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡®‡‡µ‡‡‡‡Æ‡ ‚î ‡Æ‡ß‡‡Ø‡Æ‡ ‡‡¶‡ ‡‡µ ‡‡®‡‡µ‡‡‡‡‡‡Ø ‡‡∞‡‡‡ : ‡‡ï‡‡‡µ‡ ‡Æ‡‡ß‡æ, ‡‡‡‡‡æ ‡‡ ‡ï‡æ‡∞‡‡Ø‡Æ‡ ‡
--
-- (searching: only at the middle grade does a search have content ‚î
--  uniqueness is free and existence is the whole of the work.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHY THIS EXISTS, AND IT IS A CORRECTION TO HOW I HAD BEEN READING THE
-- CARRIER LAW ALL DAY.
--
-- `loss/‚¶/Carrier.agda` gives `A ‚â Carrier f` for every f because
-- `singl (f a)` is CONTRACTIBLE, and I had been treating "contractible
-- fibre = free" as the whole of it.  It is one of three grades, and
-- `Bhagahara_TheExactDivisionCarriesItsWitnessAndSixTurnsReachOneAt
-- SixtyOne.agda` names the one I was missing, in the case that matters:
--
--     "For the ‡ï‡‡‡‡ the fibre is `singl` ‚î contractible ‚î because the
--      roots determine it TOTALLY: every pair has a ‡ï‡‡‡‡.  For the ‡‡æ‡ó‡‡æ‡∞
--      the fibre is a proposition and NOT in general inhabited: division
--      by k is PARTIAL, and the inhabitant is exactly the divisibility.
--      Contractible vs. merely propositional is the whole difference
--      between the ‡‡æ‡µ‡®‡æ (free) and the ‡‡ï‡‡∞‡µ‡æ‡≤ (not free)."
--
-- ¬ß‡®‚ì¬ß‡ are that as a law, and ¬ß‡ is what it says about algorithms.
--
-- THE THREE GRADES, and the middle one is not a weakening of the first:
--
--   ‡‡ï‡≤   isContr (fiber f b) ‚î the answer exists and is determined.
--                              Nothing to search for.
--   ‡‡ï‡æ‡ß‡ø‡ï isProp (fiber f b)  ‚î determined IF it exists.  Uniqueness is
--                              free; existence is the whole problem.
--   ‡‡‡   neither             ‚î the fibre has two points that are not
--                              identified.
--
-- ~~"not determined.  No search can return the answer because there is no
-- the."~~ ‚î STRUCK 2026-08-23 by its author, left standing struck.
--
-- THE H-LEVEL OF THE FIBRE DOES NOT TRACK UNDOABILITY.  `Bahupratyanayana
-- _TheObstructionToUndoingIsTwoDistinctSourcesNotTwoFibrePointsAndThe
-- CircleIsNotAnInstance.agda` exhibits it: `‡‡ï‡µ‡‡‡‡‡Æ‡ : Unit ‚í S¬`,
-- `tt ‚¶ base`, HAS a retraction, and its fibre over `base` is `Œ©S¬ ‚â ‚`.
-- So it sits at ‡‡‡ and is undoable.  Its many fibre points differ only in
-- their WITNESS; their SOURCE is one point.  A LOOP IS NOT A COLLISION.
--
-- The obstruction to undoing is TWO DISTINCT SOURCES over one target,
-- strictly stronger than ‡‡‡, and that is its ¬ß‡® ‚î four lines, no h-level,
-- no decidability, no finiteness, arbitrary A and B.  ¬ß‡ below uses
-- `Bool ‚í Unit`, whose two fibre points DO have distinct sources, so the
-- instance stands; the reading did not.  This grade says what its name
-- says and no more, and what a search can recover is answered by sources.
--
-- AND THE MIDDLE GRADE IS WHERE AN ALGORITHM HAS CONTENT.  At the top
-- there is nothing to do; at the bottom there is nothing an algorithm
-- could return.  `isProp (fiber f b)` says precisely: whatever a search
-- finds is THE answer, so the search may stop at the first hit and owes
-- no comparison ‚î and finding one is all of the work.  Bhskara's choice
-- of m is that search, and `Bhagahara` ¬ß‡ discharges six of them by
-- computation.
--
-- IT CUTS ACROSS THE CENSUS, and that is worth seeing rather than
-- reconciling.  `loss/‚¶/WholePartialDesa` grades a fibre as
-- ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡ (empty) / ‡‡ï‡≤‡æ‡¶‡‡ (contractible) / ‡µ‡ø‡ï‡≤‡æ‡¶‡‡ (two points, not
-- identified).  `isProp` is the UNION of its first two constructors ‚î at
-- most one ‚î so the h-level grading and the census are different cuts of
-- one object, not a coarser and a finer version of one cut.  ¬ß‡ is that,
-- both directions.
--
-- ‡‡®‡‡µ‡‡‡ is ordinary  for searching/seeking and no text is
-- claimed for it.  ‡‡æ‡ó‡‡æ‡∞ and ‡≤‡‡‡ß‡ø are the ‡ï‡‡ü‡‡ü‡ï vocabulary of
-- ‡‡‡∞‡æ‡‡‡Æ‡‡‡‡‡ü‡‡ø‡¶‡‡ß‡æ‡®‡‡‡ ‡ß‡Æ; the citation is carried from the module quoted
-- above, is second-hand, and is owed at verse level.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Anveshana_TheMiddleGradeIsWhereAnAlgorithmHasContentBecauseUniquenessIsFreeAndExistenceIsTheWork where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Foundations.HLevels using (isProp‚ÜíisContrPath)
open import Cubical.Data.Sigma using (Œ£-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false)
open import Cubical.Data.Unit using (Unit ; tt ; isPropUnit)
open import Cubical.Data.Empty using (‚ä•) renaming (rec to ‚ä•-rec)
open import Cubical.Relation.Nullary using (¬¨_)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ The three grades, named.
------------------------------------------------------------------------

module _ {A B : Type ‚Ñì} (f : A ‚Üí B) (b : B) where

  ‡§∏‡§ï‡§≤ ‡§è‡§ï‡§æ‡§ß‡§ø‡§ï : Type ‚Ñì
  ‡§∏‡§ï‡§≤   = isContr (fiber f b)
  ‡§è‡§ï‡§æ‡§ß‡§ø‡§ï = isProp  (fiber f b)

  ------------------------------------------------------------------------
  -- ‡® ¬ ‡‡ï‡≤ ‚í ‡‡ï‡æ‡ß‡ø‡ï, and the converse FAILS.  The middle grade is
  --     strictly weaker, which is the whole point: it does not assert
  --     that anything is there.
  ------------------------------------------------------------------------

  ‡§∏‡§ï‡§≤‚Üí‡§è‡§ï‡§æ‡§ß‡§ø‡§ï : ‡§∏‡§ï‡§≤ ‚Üí ‡§è‡§ï‡§æ‡§ß‡§ø‡§ï
  ‡§∏‡§ï‡§≤‚Üí‡§è‡§ï‡§æ‡§ß‡§ø‡§ï = isContr‚ÜíisProp

  ------------------------------------------------------------------------
  -- ‡© ¬ ‡‡ï‡‡‡µ‡ ‡Æ‡‡ß‡æ ‚î AT THE MIDDLE GRADE, A SEARCH OWES NO COMPARISON.
  --     Whatever it finds is the answer: any two hits are already equal,
  --     so it may stop at the first and never ask whether a better one
  --     exists.  That is what "uniqueness is free" means, as a term.
  ------------------------------------------------------------------------

  ‡§™‡•ç‡§∞‡§•‡§Æ-‡§è‡§µ-‡§™‡§∞‡•ç‡§Ø‡§æ‡§™‡•ç‡§§‡§Æ‡•ç : ‡§è‡§ï‡§æ‡§ß‡§ø‡§ï ‚Üí (x y : fiber f b) ‚Üí x ‚â° y
  ‡§™‡•ç‡§∞‡§•‡§Æ-‡§è‡§µ-‡§™‡§∞‡•ç‡§Ø‡§æ‡§™‡•ç‡§§‡§Æ‡•ç p = p

  -- and the datum a hit carries is then determined too
  ‡§≤‡§¨‡•ç‡§ß‡§ø-‡§®‡§ø‡§∞‡•ç‡§ß‡§æ‡§∞‡§ø‡§§‡§æ : ‡§è‡§ï‡§æ‡§ß‡§ø‡§ï ‚Üí (x y : fiber f b) ‚Üí fst x ‚â° fst y
  ‡§≤‡§¨‡•ç‡§ß‡§ø-‡§®‡§ø‡§∞‡•ç‡§ß‡§æ‡§∞‡§ø‡§§‡§æ p x y = cong fst (p x y)

------------------------------------------------------------------------
-- ‡ ¬ The empty fibre is at the middle grade, which is why `isProp` is
--     the UNION of the census's first two constructors and not a coarser
--     version of either.  An uninhabited fibre is a proposition and is
--     not contractible, so the middle grade genuinely spans them.
------------------------------------------------------------------------

‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç‚Üí‡§è‡§ï‡§æ‡§ß‡§ø‡§ï : {A B : Type ‚Ñì} (f : A ‚Üí B) (b : B)
              ‚Üí ¬¨ (fiber f b) ‚Üí ‡§è‡§ï‡§æ‡§ß‡§ø‡§ï f b
‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç‚Üí‡§è‡§ï‡§æ‡§ß‡§ø‡§ï f b e x _ = ‚ä•-rec (e x)

‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç-‡§®-‡§∏‡§ï‡§≤ : {A B : Type ‚Ñì} (f : A ‚Üí B) (b : B)
             ‚Üí ¬¨ (fiber f b) ‚Üí ¬¨ (‡§∏‡§ï‡§≤ f b)
‡§∞‡§ø‡§ï‡•ç‡§§‡§Æ‡•ç-‡§®-‡§∏‡§ï‡§≤ f b e c = e (fst c)

------------------------------------------------------------------------
-- ‡ ¬ The bottom grade, so ¬ß‡© is a distinction and not a vacuity: where
--     the fibre is crowded a search CANNOT stop at the first hit, because
--     the two hits are provably different and neither is "the" answer.
--     `Bool ‚í Unit`, the smallest collapse there is.
------------------------------------------------------------------------

‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç : Bool ‚Üí Unit
‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç _ = tt

‡§µ‡§æ‡§Æ ‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ : fiber ‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç tt
‡§µ‡§æ‡§Æ    = false , refl
‡§¶‡§ï‡•ç‡§∑‡§ø‡§£  = true  , refl

‡§¨‡§π‡•Å-‡§®-‡§è‡§ï‡§æ‡§ß‡§ø‡§ï : ¬¨ (‡§è‡§ï‡§æ‡§ß‡§ø‡§ï ‡§∏‡§∞‡•ç‡§µ‡•à‡§ï‡§Æ‡•ç tt)
‡§¨‡§π‡•Å-‡§®-‡§è‡§ï‡§æ‡§ß‡§ø‡§ï p = true‚â¢false (cong fst (p ‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ ‡§µ‡§æ‡§Æ))

------------------------------------------------------------------------
-- ‡ ¬ ‡‡‡‡ ‚î what this does not say.
--
--     `‡‡ï‡æ‡ß‡ø‡ï` does NOT say the existence question is decidable, and no
--     notion of algorithm, cost or decidability appears above.  It says
--     that uniqueness is not part of the problem ‚î which is what makes a
--     search well posed, not what makes it succeed.  Whether an m exists
--     with the three divisions exact is, at D = 61, six facts discharged
--     by computation in `Bhagahara` ¬ß‡ and no theorem at all in general;
--     that module is explicit that no decision procedure for them is
--     built and that termination of the wheel is not proved.
------------------------------------------------------------------------
