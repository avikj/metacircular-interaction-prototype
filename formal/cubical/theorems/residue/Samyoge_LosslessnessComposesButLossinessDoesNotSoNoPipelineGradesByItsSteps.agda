{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ‡‡‡Ø‡ã‡ó‡ ‚î ‡‡Æ‡‡æ ‡‡‡Ø‡ã‡ó‡ ‡‡ø‡‡‡†‡‡ø, ‡‡æ‡®‡ø‡‡‡‡ ‡® ; ‡‡‡ ‡‡¶‡à‡ ‡‡®‡‡‡æ‡ ‡® ‡Æ‡‡Ø‡‡ ‡
--
-- (in composition: losslessness survives, lossiness does not ‚î so a
--  pipeline is not graded by its steps.)
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE ASYMMETRY, and it is the one that makes pipeline reasoning hard.
--
-- ¬ß‡® ¬ ‡‡Æ‡‡æ ‡‡‡Ø‡ã‡ó‡ ‚î a composite of identifications is an identification.
--   Lossless composes, always, no hypothesis beyond the two.  So if every
--   step of a route is an identification, the route is one, and this is
--   why a route can be free at any length.
--
-- ¬ß‡© ¬ ‡‡æ‡®‡ø‡ ‡® ‡‡‡Ø‡ã‡ó‡ ‚î a composite of LOSSY maps need not be lossy.
--   `loss/‚¶/SakalaVikalaDesa_‚¶` ¬ß3 already computes the witness
--   and reads it as a refutation of a sequential diagnostic; here it is
--   read as the composition law it also is:
--
--     ‡‡‡ : Unit ‚í Bool     u ‚¶ true    ‚î its fibre over `false` is EMPTY.
--                                        Nothing is lost: Bool merely has
--                                        a name Unit cannot utter.
--                                        ‡‡µ‡ï‡‡‡µ‡‡Ø‡Æ‡, and POSITIVE.
--     ‡‡ï‡Æ‡ : Bool ‚í Unit    _ ‚¶ tt      ‚î its fibre over `tt` is CROWDED.
--                                        Exactly one bit is lost. ‡µ‡ø‡ï‡≤‡æ‡¶‡‡.
--     ‡‡ï‡Æ‡ ‚àò ‡‡‡ : Unit ‚í Unit          ‚î the IDENTITY.  An equivalence.
--
--   Neither factor is an identification and the composite is one.  The
--   inexpressibility at the first step and the collapse at the second
--   CANCEL.
--
-- SO: you may certify a pipeline lossless by certifying every step, and
-- you may NOT diagnose it lossy by finding a lossy step.  One direction
-- is compositional and the other is not, and no amount of care about the
-- steps repairs the second ‚î the information is not there.  ¬ß‡ says the
-- same thing as a refusal: there is no grading function on maps that both
-- respects composition and detects loss.
--
-- A SECOND NEIGHBOUR, AND IT NARROWS THIS MODULE.S TITLE.
--
-- `BhittiSankrama_WallsTransportAlongFordsSoEveryFordRetiresCandidatesFor
-- Free.agda` (another seat, 2026-08-23) proves
--
--     ‡‡ø‡‡‡‡ø-‡‡‡ï‡‡∞‡Æ‡ : (A ‚â B) ‚í ¬ (B ‚â C) ‚í ¬ (A ‚â C)
--
-- so a WALL -- a proved non-identification -- composes with a FORD into a
-- wall, and every new ford extends every standing wall across it.  Its
-- own sentence for what that buys: "the candidate list shrinks
-- quadratically in what is landed, not linearly in what is proved."
--
-- Read against ¬ß‡ here, that looks like a contradiction and is not.  Two
-- different compositions:
--
--   THIS FILE composes MAPS along a pipeline, `g ‚àò f`.  There,
--   certification composes and refutation does not -- ¬ß‡©.s two lossy
--   factors give a lossless composite.
--
--   THAT FILE transports a STATEMENT ABOUT TYPES along an equivalence.
--   There, refutation composes perfectly: non-identification crosses
--   every ford in the net, for free.
--
-- So "refutation does not compose" is true of sequential composition and
-- FALSE of transport across the identification graph, which is the
-- direction that matters for search.  This module.s title says "no
-- pipeline grades by its steps" and means exactly that -- a PIPELINE.  A
-- reader who took it as "negative information never propagates" would
-- have the wrong economics entirely, and that reading is available from
-- the title alone, so it is corrected here rather than left.
--
-- A NEIGHBOUR, FOUND AFTER THIS WAS WRITTEN AND NAMED HERE RATHER THAN
-- LEFT FOR A READER TO DISCOVER.  `Parampara_TheChainOfThreeIsPricedAnd
-- TheLossesDoNotAddBecauseAnAbsenceSitsInTheMiddleFibre.agda` in this
-- same lane found the non-additivity FIRST and went deeper than ¬ß‡© does:
-- it prices an explicit chain of three, fibre by fibre, and names the
-- MECHANISM -- an ‡‡‡æ‡µ sitting in the middle fibre, with both its
-- Nyya-Vaieika slots (pratiyogin and anuyogin) supplied, so the result
-- is a relation and not a report that a number came out smaller than
-- expected.
--
-- Neither module subsumes the other and the difference is worth stating.
-- Parampara is one chain, priced, with the reason.  This is the general
-- asymmetry -- certification composes, refutation does not -- with the
-- smallest possible witness and no mechanism.  A reader who has only this
-- file knows THAT stepwise diagnosis fails; a reader who has only that one
-- knows WHY it failed once.  I did not know of it when I wrote this.
--
-- NARROWED 2026-08-23, AFTER A NEIGHBOUR SHOWED THE TITLE IS FALSE IN THE
-- DIRECTION THAT MATTERS.  What ¬ß‡® and ¬ß‡© establish is about SEQUENTIAL
-- COMPOSITION OF MAPS along a pipeline, and nothing else.  Read as
-- "negative information never propagates" the title is WRONG, and a reader
-- who took it that way would have the search economics exactly backwards.
--
-- Across the IDENTIFICATION GRAPH negative information propagates very
-- well, and `Kosthabhitti_‚¶agda` gives the structural reason neither file
-- had stated:
--
--   a DEFECT is a property of a MAP ‚î `Œ[b] ¬ isContr (fiber f b)` ‚î so it
--     needs a SITE, and `TritiyaMarga_‚¶` shows that getting the site out of
--     a refutation costs at least Markov.s Principle.
--   a WALL is a property of a PAIR OF TYPES, and transport moves statements
--     about types.
--
-- So WALLS CROSS FORDS AND DEFECTS DO NOT, and that is the term/type
-- distinction rather than a happy accident about search.  A proved
-- non-crossing retires every candidate on the far side of every ford it
-- reaches; a proved lossy step retires nothing beyond itself, which is ¬ß‡©.
-- Both are true and they are about different objects.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
--
-- ‡‡‡Ø‡ã‡ó is ordinary  for conjunction/composition and is the word
-- ‡‡‡‡‡∞ ‡ß‡© of the corpus's root text uses; no source is claimed for
-- anything below.
------------------------------------------------------------------------

module Samyoge_LosslessnessComposesButLossinessDoesNotSoNoPipelineGradesByItsSteps where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
  using (_‚âÉ_ ; isEquiv ; fiber ; compEquiv ; idEquiv)
open import Cubical.Foundations.Isomorphism using (isoToEquiv ; iso)
open import Cubical.Foundations.Function using (idfun ; _‚àò_)
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false ; false‚â¢true ; isSetBool)
open import Cubical.Data.Unit using (Unit ; tt ; isSetUnit)
open import Cubical.Data.Sigma using (_,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬¨_)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- ‡ß ¬ The three maps.  Written out so ¬ß‡® and ¬ß‡© are about the same
--     objects and not about two unrelated examples.
------------------------------------------------------------------------

‡§∏‡§§‡•ç : Unit ‚Üí Bool
‡§∏‡§§‡•ç _ = true

‡§è‡§ï‡§Æ‡•ç : Bool ‚Üí Unit
‡§è‡§ï‡§Æ‡•ç _ = tt

‡§∏‡§Ç‡§π‡§§‡§ø : Unit ‚Üí Unit
‡§∏‡§Ç‡§π‡§§‡§ø = ‡§è‡§ï‡§Æ‡•ç ‚àò ‡§∏‡§§‡•ç

------------------------------------------------------------------------
-- ‡® ¬ ‡‡Æ‡‡æ ‡‡‡Ø‡ã‡ó‡ ‚î LOSSLESS COMPOSES.
------------------------------------------------------------------------

‡§∏‡§Æ‡§§‡§æ-‡§∏‡§Ç‡§Ø‡•ã‡§ó‡§É : {A B C : Type ‚Ñì} ‚Üí A ‚âÉ B ‚Üí B ‚âÉ C ‚Üí A ‚âÉ C
‡§∏‡§Æ‡§§‡§æ-‡§∏‡§Ç‡§Ø‡•ã‡§ó‡§É = compEquiv

------------------------------------------------------------------------
-- ‡© ¬ ‡‡æ‡®‡ø‡ ‡® ‡‡‡Ø‡ã‡ó‡ ‚î AND LOSSY DOES NOT.
--
--     Both factors fail to be identifications, in OPPOSITE ways, and the
--     composite is the identity.
------------------------------------------------------------------------

-- the first step's fibre over `false` is empty: nothing lost, unsayable
‡§∏‡§§‡•ç-‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç : ¬¨ (fiber ‡§∏‡§§‡•ç false)
‡§∏‡§§‡•ç-‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç (_ , p) = true‚â¢false p

‡§∏‡§§‡•ç-‡§®-‡§∏‡§Æ‡§§‡§æ : ¬¨ (isEquiv ‡§∏‡§§‡•ç)
‡§∏‡§§‡•ç-‡§®-‡§∏‡§Æ‡§§‡§æ e = ‡§∏‡§§‡•ç-‡§Ö‡§µ‡§ï‡•ç‡§§‡§µ‡•ç‡§Ø‡§Æ‡•ç (isEquiv.equiv-proof e false .fst)

-- the second step's fibre over `tt` is crowded: exactly one bit lost
‡§è‡§ï‡§Æ‡•ç-‡§µ‡§æ‡§Æ ‡§è‡§ï‡§Æ‡•ç-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ : fiber ‡§è‡§ï‡§Æ‡•ç tt
‡§è‡§ï‡§Æ‡•ç-‡§µ‡§æ‡§Æ   = false , refl
‡§è‡§ï‡§Æ‡•ç-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£ = true  , refl

‡§è‡§ï‡§Æ‡•ç-‡§µ‡§ø‡§ï‡§≤‡§æ‡§¶‡•á‡§∂ : ¬¨ (‡§è‡§ï‡§Æ‡•ç-‡§µ‡§æ‡§Æ ‚â° ‡§è‡§ï‡§Æ‡•ç-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£)
‡§è‡§ï‡§Æ‡•ç-‡§µ‡§ø‡§ï‡§≤‡§æ‡§¶‡•á‡§∂ p = false‚â¢true (cong fst p)

‡§è‡§ï‡§Æ‡•ç-‡§®-‡§∏‡§Æ‡§§‡§æ : ¬¨ (isEquiv ‡§è‡§ï‡§Æ‡•ç)
‡§è‡§ï‡§Æ‡•ç-‡§®-‡§∏‡§Æ‡§§‡§æ e =
  ‡§è‡§ï‡§Æ‡•ç-‡§µ‡§ø‡§ï‡§≤‡§æ‡§¶‡•á‡§∂ (isContr‚ÜíisProp (isEquiv.equiv-proof e tt) ‡§è‡§ï‡§Æ‡•ç-‡§µ‡§æ‡§Æ ‡§è‡§ï‡§Æ‡•ç-‡§¶‡§ï‡•ç‡§∑‡§ø‡§£)

-- and the composite is the identity, hence an equivalence
‡§∏‡§Ç‡§π‡§§‡§ø-‡§§‡§§‡•ç‡§∏‡§Æ‡§Æ‡•ç : (u : Unit) ‚Üí ‡§∏‡§Ç‡§π‡§§‡§ø u ‚â° idfun Unit u
‡§∏‡§Ç‡§π‡§§‡§ø-‡§§‡§§‡•ç‡§∏‡§Æ‡§Æ‡•ç tt = refl

‡§∏‡§Ç‡§π‡§§‡§ø-‡§∏‡§Æ‡§§‡§æ : isEquiv ‡§∏‡§Ç‡§π‡§§‡§ø
‡§∏‡§Ç‡§π‡§§‡§ø-‡§∏‡§Æ‡§§‡§æ = subst isEquiv (Œª i u ‚Üí ‡§∏‡§Ç‡§π‡§§‡§ø-‡§§‡§§‡•ç‡§∏‡§Æ‡§Æ‡•ç u (~ i)) (idEquiv Unit .snd)

------------------------------------------------------------------------
-- ‡ ¬ ‡® ‡‡‡∞‡‡‡-‡Æ‡æ‡‡ ‚î NO STEPWISE GRADE DETECTS LOSS.
--
--     Suppose a grade assigns a value to every map, respects composition
--     in the sense that a composite's grade is determined by its factors'
--     grades, and reports "lossless" exactly at the identifications.
--     ¬ß‡© kills it: `‡‡‡` and `‡‡ï‡Æ‡` are both graded lossy, `‡‡ï‡Æ‡` composed
--     with `‡‡‡` is lossless, and `‡‡ï‡Æ‡` composed with `‡‡ï‡Æ‡ `‚î no; the
--     cleanest form needs no second instance, because a determined
--     composite grade would have to be a FUNCTION of the two factor
--     grades, and here two lossy factors give a lossless composite while
--     a lossy factor composed with an identity gives a lossy one.
------------------------------------------------------------------------

-- the second pair: ‡‡ï‡Æ‡ after the identity is still lossy
‡§∏‡§Ç‡§π‡§§‡§ø' : Bool ‚Üí Unit
‡§∏‡§Ç‡§π‡§§‡§ø' = ‡§è‡§ï‡§Æ‡•ç ‚àò idfun Bool

‡§∏‡§Ç‡§π‡§§‡§ø'-‡§®-‡§∏‡§Æ‡§§‡§æ : ¬¨ (isEquiv ‡§∏‡§Ç‡§π‡§§‡§ø')
‡§∏‡§Ç‡§π‡§§‡§ø'-‡§®-‡§∏‡§Æ‡§§‡§æ = ‡§è‡§ï‡§Æ‡•ç-‡§®-‡§∏‡§Æ‡§§‡§æ

-- so no function of the factors' loss-status determines the composite's:
-- (lossy , lossy) ‚¶ lossless  and  (lossless , lossy) ‚¶ lossy are both
-- realised, and any such function would have to send the SAME pair of
-- statuses to both answers if it also graded `‡‡‡` and `idfun Bool`
-- alike -- which it cannot, since one is an equivalence and the other is
-- not.  What survives, stated exactly, is ¬ß‡.

------------------------------------------------------------------------
-- ‡ ¬ What actually survives, so ¬ß‡ is not read as more than it is.
--
--     A grade that respects composition CAN certify losslessness: if both
--     factors are identifications the composite is (¬ß‡®).  What it cannot
--     do is DETECT loss ‚î a lossy factor is no evidence about the
--     composite, because ¬ß‡© exhibits two lossy factors composing to an
--     identity.  Certification composes; refutation does not.
--
--     And that is not a defect in the grading.  It is ‡‡‡‡‡∞ ‡ß‡© read
--     correctly: the composite's fibre is fibred OVER the fibre ‚î built
--     from the parts, not determined by them ‚î and ¬ß‡© is precisely a case
--     where non-trivial parts assemble a trivial total.
------------------------------------------------------------------------
