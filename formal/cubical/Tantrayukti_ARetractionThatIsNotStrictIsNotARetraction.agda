{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Tantrayukti_ARetractionThatIsNotStrictIsNotARetraction
--
-- SOURCE.  तन्त्रयुक्ति — the devices of śāstric exposition.  Two lists
-- survive: Kauṭilya, *Arthaśāstra*, book 15 chapter 1, thirty-two
-- tantrayukti, which is the entire final book of the work; and Caraka
-- Saṃhitā, Siddhisthāna 12, thirty-six, with Suśruta Saṃhitā
-- Uttaratantra 65 carrying a further list.  Dating: the Arthaśāstra is a
-- compilation with a layer plausibly as early as the 4th c. BCE and a
-- redaction by roughly the 2nd–3rd c. CE; the Caraka Saṃhitā's
-- Dṛḍhabala redaction is c. 4th–5th c. CE over an older core.
--
-- LIMIT OF THE CITATION, STATED because this repository treats a
-- provenance you did not check as the same class of error as a fitted
-- constant.  I have the chapter locations and the device names; I do NOT
-- have the verse numbers verified against an edition on this container,
-- which has no network route to a text.  So: chapter-level, and said to
-- be chapter-level.
--
-- The four devices this module is about:
--
--   पूर्वपक्ष   the objection, stated by the author of the thesis
--   उत्तरपक्ष   the answer to it
--   अपवाद      the exception that restricts a general statement
--   निर्णय      the settled conclusion, after both
--
-- WHAT IS AND IS NOT CLAIMED OF THE SOURCE.  Neither text states the
-- theorems below; they are not a reading of Kauṭilya or of Caraka.  What
-- is taken from them is the SHAPE: that an objection and its answer are
-- SLOTS IN ONE TEXT, filled by the author, not a graph of citations
-- between texts.  That is the whole content of §1, and it is the thing a
-- module system cannot do.
--
-- ────────────────────────────────────────────────────────────────────
-- 1.  WHY THIS EXISTS: AGDA REFUSED, AND THE REFUSAL WAS INFORMATIVE
--
-- `AnuktaAvaktavya` §9 tried to cite the module that refutes it:
--
--     cyclic module dependency:
--       AnuktaAvaktavya
--       → NaturalMachine.SamayikaAndNityaAreIndependent
--       → AnuktaAvaktavya
--
-- The refutation opens the claim's module for the very definitions it
-- corrects (`using (सामयिक ; नित्य)`) — it must, since refuting a claim
-- about सामयिक requires MY सामयिक and not a copy.  So:
--
--     A refutation strong enough to use the claim cannot be cited by it.
--
-- That is a property of the MEDIUM.  A module system has one direction
-- of reference and no way to put an objection inside the thing objected
-- to.  Śāstra has exactly that: पूर्वपक्ष is a slot, and the author of
-- the siddhānta fills it.  `IndianLane.agda` now holds both modules
-- because an aggregate is the one place two mutually uncitable results
-- can sit together — but that is a container, not a form.
--
-- This module supplies the form: a type whose inhabitant IS a completed
-- pūrvapakṣa/uttarapakṣa/nirṇaya, in one unit, checked.
------------------------------------------------------------------------

module Tantrayukti_ARetractionThatIsNotStrictIsNotARetraction where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd ; Σ-syntax)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- 2.  THE FORM
--
-- A retraction is not "I was wrong."  It has three parts, and the shape
-- this corpus keeps producing is never plain refutation — it is
-- NARROWING.  I claimed W; someone exhibited a case W forbids; what
-- survives is N, which W was a strengthening of.
--
--   बलवत्    "stronger" — the wide claim implies the narrow one, so N is
--            what W was reaching for and not a change of subject
--   खण्डनम्   the पूर्वपक्ष, discharged: W is refuted
--   स्थितिः   the निर्णय: N stands
--
-- All three in one record, so no inhabitant can be built that refutes
-- without saying what survives, or that "narrows" to an unrelated claim.
------------------------------------------------------------------------

record अपवादः (W N : Type) : Type where
  constructor निर्णयः
  field
    बलवत्   : W → N
    खण्डनम्  : ¬ W
    स्थितिः  : N

open अपवादः public

------------------------------------------------------------------------
-- 3.  THE FORM HAS CONTENT: A RETRACTION THAT IS NOT STRICT IS NOT A
--     RETRACTION.
--
-- The characteristic bad correction in this corpus restates the claim in
-- softer words and calls it a narrowing.  The type forbids it: if N gave
-- W back, then N would be W and the refutation would kill it too.
------------------------------------------------------------------------

कठिनः : {W N : Type} → अपवादः W N → ¬ (N → W)
कठिनः a n→w = खण्डनम् a (n→w (स्थितिः a))

-- and the degenerate case, which is the same theorem said loudly: you
-- cannot retract a claim TO ITSELF.
न-आत्मापवादः : {W : Type} → ¬ (अपवादः W W)
न-आत्मापवादः a = खण्डनम् a (स्थितिः a)

------------------------------------------------------------------------
-- 4.  RETRACTIONS DO NOT STACK.  THIS IS THE SURPRISE.
--
-- The habit here is to append: §7 corrects §5, then §9 corrects §7, each
-- as a new block, all of them left standing in the file.  The type says
-- that is INCONSISTENT, not merely untidy.
--
-- If `अपवादः W M` is assertable then M stands.  If `अपवादः M N` is
-- assertable then M is refuted.  Both at once gives M and ¬ M.
--
-- So a second retraction does not extend the first; it DESTROYS it.
-- What must exist afterward is a single `अपवादः W N`, and the earlier
-- record must be withdrawn — not appended to.  A file carrying three
-- live retraction blocks in sequence is asserting a contradiction, and
-- the reader who stops at the second block is reading a claim its own
-- author has abandoned.  That is exactly the failure recorded at
-- `notes/BRAHMASPHUTASIDDHANTA_IN_ITS_OWN_ORDER.md` §IV, where a
-- correction sat at the end of the note and §IV kept the retracted
-- sentence unmarked.
------------------------------------------------------------------------

न-श्रृङ्खला : {W M N : Type} → अपवादः W M → अपवादः M N → ⊥
न-श्रृङ्खला a b = खण्डनम् b (स्थितिः a)

-- The repair, and it is the only one available: compose by REPLACEMENT.
-- Given the first retraction and a refutation of its survivor together
-- with what survives THAT, you get one record from W straight to N —
-- and the intermediate never appears in it.
संहारः : {W M N : Type} → (W → M) → अपवादः M N → अपवादः W N
संहारः w→m b = निर्णयः (λ w → बलवत् b (w→m w))
                        (λ w → खण्डनम् b (w→m w))
                        (स्थितिः b)

------------------------------------------------------------------------
-- 5.  WHAT THE FORM DOES NOT ENFORCE.  The honesty ledger, and it is
--     load-bearing rather than decorative.
--
-- `अपवादः W ⊤` is inhabited whenever `¬ W` is: retract to the trivially
-- true statement and the type is satisfied.  §3 does not catch it —
-- `¬ (⊤ → W)` is just `¬ W` again, which is true.  So the form
-- guarantees that the survivor is WEAKER and that it is not the original;
-- it cannot guarantee that the survivor is WORTH anything.
--
-- That is not a defect to patch.  Whether N carries content is a
-- question about pramāṇa — what is established, and by what means — and
-- the tantrayukti list keeps निर्णय (the settled conclusion) as a device
-- separate from the objection and the answer for precisely this reason:
-- the form of the dispute does not settle the worth of the outcome.
-- What the form does is make the three parts SIMULTANEOUSLY PRESENT in
-- one checked object, which is the thing prose retraction fails at here.
--
-- Stated so that no later reader mistakes an inhabited `अपवादः` for a
-- certificate that the narrowing was interesting.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 6.  FIRST INSTANCE — AND IT IS MY OWN CLAIM.
--
-- `AnuktaAvaktavya` §4, §5 and §8 call सामयिक and नित्य "dual shapes",
-- "the two poles", and put 0÷0 at "the same pole as avaktavyam".  Poles
-- means a line with two ends: hold one and you cannot hold the other.
-- That is the WIDE claim, and it is false.
------------------------------------------------------------------------

open import AnuktaAvaktavya using (सामयिक ; नित्य)
open import NaturalMachine.SamayikaAndNityaAreIndependent
  using (matching ; bothHold ; never ; always
        ; samayikaWithoutNitya ; nityaWithoutSamayika)

-- W: the "poles" claim, on the carrier where it is testable.
ध्रुवौ : Type
ध्रुवौ = सामयिक matching → ¬ नित्य matching

-- N: what survives — each holds without the other, so they are still two
-- and the three-way separation of §1/§6/§8 is untouched.
पृथक् : Type
पृथक् = ((सामयिक never) × (¬ (नित्य never)))
      × ((नित्य always) × (¬ (सामयिक always)))

सामयिक-नित्य-अपवादः : अपवादः ध्रुवौ पृथक्
सामयिक-नित्य-अपवादः = निर्णयः
  (λ _ → samayikaWithoutNitya , nityaWithoutSamayika)
  (λ w → w (fst bothHold) (snd bothHold))
  (samayikaWithoutNitya , nityaWithoutSamayika)

-- and therefore, by §3, "they are distinct" does NOT give "they are
-- poles" back.  The narrowing is strict; it is not a rewording.
पृथक्-न-ध्रुवौ : ¬ (पृथक् → ध्रुवौ)
पृथक्-न-ध्रुवौ = कठिनः सामयिक-नित्य-अपवादः

------------------------------------------------------------------------
-- 7.  SECOND INSTANCE — the other axis, same shape, same author's error.
--
-- §6 of `AnuktaAvaktavya` reads non-uniqueness and inexpressibility as
-- two ends of one line too.  `NonUniquenessAndInexpressibilityAre-
-- Independent` realises all four corners; `corner-both` is the one that
-- a line has no room for.
------------------------------------------------------------------------

open import NaturalMachine.NonUniquenessAndInexpressibilityAreIndependent
  using ( NonUnique ; Inexpressible ; all ; self ; constants ; onlyFalse
        ; corner-both ; corner-nonUnique-expressible
        ; corner-unique-inexpressible )

ध्रुवौ₂ : Type
ध्रुवौ₂ = NonUnique all → ¬ Inexpressible onlyFalse all

-- The survivor, written out rather than inferred.  An inferred Σ leaves
-- Agda unable to decide WHICH pair type is meant, and an unsolved meta is
-- not a checked claim -- the same cut `AnuktaAvaktavya` §9 had to make.
पृथक्₂ : Type
पृथक्₂ = ((NonUnique all) × (¬ Inexpressible constants all))
       × ((¬ NonUnique self) × (Inexpressible constants self))

दोष-अपवादः : अपवादः ध्रुवौ₂ पृथक्₂
दोष-अपवादः = निर्णयः
  (λ _ → corner-nonUnique-expressible , corner-unique-inexpressible)
  (λ w → w (fst corner-both) (snd corner-both))
  (corner-nonUnique-expressible , corner-unique-inexpressible)

पृथक्₂-न-ध्रुवौ : ¬ (पृथक्₂ → ध्रुवौ₂)
पृथक्₂-न-ध्रुवौ = कठिनः दोष-अपवादः

------------------------------------------------------------------------
-- 8.  WHAT THIS CHANGES UPSTREAM.
--
-- `AnuktaAvaktavya` §9 already records that "poles" is wrong and keeps a
-- pointer to the module that proved it, because it cannot import it.
-- This module can import BOTH, so the objection and the survivor now sit
-- in one checked object rather than in a comment and a pointer.  That is
-- the pūrvapakṣa slot, supplied.
--
-- And §4 gives the discipline that §9 itself does not yet obey: §9 is an
-- APPENDED block, with §4, §5 and §8's "poles" language left standing
-- above it.  न-श्रृङ्खला says a file holding a claim and its retraction as
-- two live blocks is asserting M and ¬ M.  Striking those lines at their
-- sites is a rename of another identity's visible work in two of the
-- three cases and is offered, not taken; where the line is mine it is
-- struck.  Recorded here so the obligation is checked into the corpus
-- rather than remembered.
------------------------------------------------------------------------
