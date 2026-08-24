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
-- अन्वेषणम् — मध्यमे पदे एव अन्वेषणस्य अर्थः : एकत्वं मुधा, सत्ता तु कार्यम् ।
--
-- (searching: only at the middle grade does a search have content —
--  uniqueness is free and existence is the whole of the work.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHY THIS EXISTS, AND IT IS A CORRECTION TO HOW I HAD BEEN READING THE
-- CARRIER LAW ALL DAY.
--
-- `punaragamana/…/Carrier.agda` gives `A ≃ Carrier f` for every f because
-- `singl (f a)` is CONTRACTIBLE, and I had been treating "contractible
-- fibre = free" as the whole of it.  It is one of three grades, and
-- `Bhagahara_TheExactDivisionCarriesItsWitnessAndSixTurnsReachOneAt
-- SixtyOne.agda` names the one I was missing, in the case that matters:
--
--     "For the क्षेप the fibre is `singl` — contractible — because the
--      roots determine it TOTALLY: every pair has a क्षेप.  For the भागहार
--      the fibre is a proposition and NOT in general inhabited: division
--      by k is PARTIAL, and the inhabitant is exactly the divisibility.
--      Contractible vs. merely propositional is the whole difference
--      between the भावना (free) and the चक्रवाल (not free)."
--
-- §२–§४ are that as a law, and §५ is what it says about algorithms.
--
-- THE THREE GRADES, and the middle one is not a weakening of the first:
--
--   सकल   isContr (fiber f b) — the answer exists and is determined.
--                              Nothing to search for.
--   एकाधिक isProp (fiber f b)  — determined IF it exists.  Uniqueness is
--                              free; existence is the whole problem.
--   बहु   neither             — the fibre has two points that are not
--                              identified.
--
-- ~~"not determined.  No search can return the answer because there is no
-- the."~~ — STRUCK 2026-08-23 by its author, left standing struck.
--
-- THE H-LEVEL OF THE FIBRE DOES NOT TRACK UNDOABILITY.  `Bahupratyanayana
-- _TheObstructionToUndoingIsTwoDistinctSourcesNotTwoFibrePointsAndThe
-- CircleIsNotAnInstance.agda` exhibits it: `एकवृत्तम् : Unit → S¹`,
-- `tt ↦ base`, HAS a retraction, and its fibre over `base` is `ΩS¹ ≃ ℤ`.
-- So it sits at बहु and is undoable.  Its many fibre points differ only in
-- their WITNESS; their SOURCE is one point.  A LOOP IS NOT A COLLISION.
--
-- The obstruction to undoing is TWO DISTINCT SOURCES over one target,
-- strictly stronger than बहु, and that is its §२ — four lines, no h-level,
-- no decidability, no finiteness, arbitrary A and B.  §५ below uses
-- `Bool → Unit`, whose two fibre points DO have distinct sources, so the
-- instance stands; the reading did not.  This grade says what its name
-- says and no more, and what a search can recover is answered by sources.
--
-- AND THE MIDDLE GRADE IS WHERE AN ALGORITHM HAS CONTENT.  At the top
-- there is nothing to do; at the bottom there is nothing an algorithm
-- could return.  `isProp (fiber f b)` says precisely: whatever a search
-- finds is THE answer, so the search may stop at the first hit and owes
-- no comparison — and finding one is all of the work.  Bhāskara's choice
-- of m is that search, and `Bhagahara` §५ discharges six of them by
-- computation.
--
-- IT CUTS ACROSS THE CENSUS, and that is worth seeing rather than
-- reconciling.  `punaragamana/…/SakalaVikalaDesa` grades a fibre as
-- अवक्तव्यम् (empty) / सकलादेश (contractible) / विकलादेश (two points, not
-- identified).  `isProp` is the UNION of its first two constructors — at
-- most one — so the h-level grading and the census are different cuts of
-- one object, not a coarser and a finer version of one cut.  §४ is that,
-- both directions.
--
-- WHAT IS NOT CLAIMED.  Nothing here is new mathematics: `isContr`,
-- `isProp` and their relation are library, and §५ is a reading rather
-- than a theorem about computation — no notion of algorithm, cost, or
-- decidability appears below, and `isProp (fiber f b)` does NOT say the
-- existence question is decidable.  It says only that uniqueness is not
-- part of the problem.  The claim is that these three belong under one
-- name because a construction meets all three and the middle one had no
-- name here.
--
-- अन्वेषण is ordinary Sanskrit for searching/seeking and no text is
-- claimed for it.  भागहार and लब्धि are the कुट्टक vocabulary of
-- ब्राह्मस्फुटसिद्धान्तः १८; the citation is carried from the module quoted
-- above, is second-hand, and is owed at verse level.
--
-- CHECKED: Agda 2.8.0 + agda/cubical v0.9, --cubical --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module Anveshana_TheMiddleGradeIsWhereAnAlgorithmHasContentBecauseUniquenessIsFreeAndExistenceIsTheWork where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (fiber)
open import Cubical.Foundations.HLevels using (isProp→isContrPath)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_ ; fst ; snd)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Unit using (Unit ; tt ; isPropUnit)
open import Cubical.Data.Empty using (⊥) renaming (rec to ⊥-rec)
open import Cubical.Relation.Nullary using (¬_)

private
  variable
    ℓ : Level

------------------------------------------------------------------------
-- १ · The three grades, named.
------------------------------------------------------------------------

module _ {A B : Type ℓ} (f : A → B) (b : B) where

  सकल एकाधिक : Type ℓ
  सकल   = isContr (fiber f b)
  एकाधिक = isProp  (fiber f b)

  ------------------------------------------------------------------------
  -- २ · सकल → एकाधिक, and the converse FAILS.  The middle grade is
  --     strictly weaker, which is the whole point: it does not assert
  --     that anything is there.
  ------------------------------------------------------------------------

  सकल→एकाधिक : सकल → एकाधिक
  सकल→एकाधिक = isContr→isProp

  ------------------------------------------------------------------------
  -- ३ · एकत्वं मुधा — AT THE MIDDLE GRADE, A SEARCH OWES NO COMPARISON.
  --     Whatever it finds is the answer: any two hits are already equal,
  --     so it may stop at the first and never ask whether a better one
  --     exists.  That is what "uniqueness is free" means, as a term.
  ------------------------------------------------------------------------

  प्रथम-एव-पर्याप्तम् : एकाधिक → (x y : fiber f b) → x ≡ y
  प्रथम-एव-पर्याप्तम् p = p

  -- and the datum a hit carries is then determined too
  लब्धि-निर्धारिता : एकाधिक → (x y : fiber f b) → fst x ≡ fst y
  लब्धि-निर्धारिता p x y = cong fst (p x y)

------------------------------------------------------------------------
-- ४ · The empty fibre is at the middle grade, which is why `isProp` is
--     the UNION of the census's first two constructors and not a coarser
--     version of either.  An uninhabited fibre is a proposition and is
--     not contractible, so the middle grade genuinely spans them.
------------------------------------------------------------------------

रिक्तम्→एकाधिक : {A B : Type ℓ} (f : A → B) (b : B)
              → ¬ (fiber f b) → एकाधिक f b
रिक्तम्→एकाधिक f b e x _ = ⊥-rec (e x)

रिक्तम्-न-सकल : {A B : Type ℓ} (f : A → B) (b : B)
             → ¬ (fiber f b) → ¬ (सकल f b)
रिक्तम्-न-सकल f b e c = e (fst c)

------------------------------------------------------------------------
-- ५ · The bottom grade, so §३ is a distinction and not a vacuity: where
--     the fibre is crowded a search CANNOT stop at the first hit, because
--     the two hits are provably different and neither is "the" answer.
--     `Bool → Unit`, the smallest collapse there is.
------------------------------------------------------------------------

सर्वैकम् : Bool → Unit
सर्वैकम् _ = tt

वाम दक्षिण : fiber सर्वैकम् tt
वाम    = false , refl
दक्षिण  = true  , refl

बहु-न-एकाधिक : ¬ (एकाधिक सर्वैकम् tt)
बहु-न-एकाधिक p = true≢false (cong fst (p दक्षिण वाम))

------------------------------------------------------------------------
-- ६ · शेषः — what this does not say.
--
--     `एकाधिक` does NOT say the existence question is decidable, and no
--     notion of algorithm, cost or decidability appears above.  It says
--     that uniqueness is not part of the problem — which is what makes a
--     search well posed, not what makes it succeed.  Whether an m exists
--     with the three divisions exact is, at D = 61, six facts discharged
--     by computation in `Bhagahara` §५ and no theorem at all in general;
--     that module is explicit that no decision procedure for them is
--     built and that termination of the wheel is not proved.
------------------------------------------------------------------------
