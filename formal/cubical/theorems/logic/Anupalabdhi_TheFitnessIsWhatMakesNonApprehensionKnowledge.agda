{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Anupalabdhi — अनुपलब्धि, non-apprehension: the fitness condition is what
-- separates "search found nothing" from a negative result, and here it is a
-- hypothesis of the theorem rather than a remark in a header.
--
-- SOURCE.  Kumārila Bhaṭṭa, Ślokavārttika, Abhāvapariccheda (c. 7th c.),
-- admits anupalabdhi as a means of knowing absence; Prabhākara refuses it as
-- separate and folds it into perception.  BOTH impose the same condition, and
-- the condition is the content of this file:
--
--   yogyānupalabdhi — non-apprehension counts only where the counterpositive
--   WOULD HAVE BEEN apprehended had it been present.  There is no pot on the
--   floor: you would have seen it.  There is no ghost in the room: you would
--   not have, so your not seeing one establishes nothing about ghosts.
--
-- The slots of the absence itself — pratiyogin (what is absent), anuyogin
-- (the locus), avacchedaka (the limitor under which the counterpositive is
-- taken) — are Nyāya-Vaiśeṣika's, and are already in this corpus as a
-- dependent record: `AbhavaAvacchedaka`, with the second limitor slot in
-- `TheAnuyogitaAvacchedakaIsADistinctSlot`.  This file adds the
-- FITNESS, which is not in either, and which is Mīmāṃsā's rather than Nyāya's.
--
-- GRADE.  No critical edition was opened.  The attributions above are carried
-- from this repository's own `ANEKANTA.md` §4 and `interactive/Yogyata.hs`, and
-- are śabda at that grade, stated as such.  What is NOT carried from anywhere
-- is the formalisation; it is argued here.
--
-- WHOSE SCHOOL, SO THE TOOLKIT DOES NOT GET BLENDED.  This is the
-- Nyāya-Mīmāṃsā analysis of absence and nothing here is Jaina.  A Jaina
-- logician does not accept absence-as-entity at all: syād-nāsti is the same
-- object denied under a standpoint, on a fourfold ground (dravya, kṣetra,
-- kāla, bhāva), and the Naiyāyika's seventh padārtha is on that reading a
-- durnaya — a standpoint mistaken for a thing.  The two constructions and the
-- exchange between them are kept apart, and the collision is exhibited rather
-- than settled, in
-- `interactive/Abhava_TheAbsenceCarriesItsPratiyoginAndItsSearchedDomain.hs`.
--
-- WHY IT MATTERS HERE, with instances that are not hypothetical.
-- `interactive/Yogyata.hs` was written because a module nothing imported reported
-- the same as a module that did not exist.  `notes/INDIC_FORMAL_TRADITIONS_MAP.md`
-- §2.2 published NOT FOUND and had to be narrowed by a later reader.
-- `Obstruction.Aviruddha` carries the assignments searched precisely so that
-- "unrefuted" cannot be read as "true".  Each is the same defect: a negative
-- whose extent was not stated, and therefore had nothing to be wrong about.
--
-- CONTENTS.  No postulates, no holes, --safe.
--
--   Anvesana        a search: a locus, a counterpositive on it, and the
--                   region actually examined
--   Clean           nothing examined bore the counterpositive
--   Yogya           the fitness: every point of the locus was examined
--   Abhava          the absence itself: nothing in the locus bears it
--   yogyanupalabdhi Clean → Yogya → Abhava.  The theorem, and it is one line,
--                   which is the point: what was missing was never the proof,
--                   it was the second hypothesis.
--   abhava→clean    the absence always makes any search clean — so Clean is
--                   the weaker notion in general
--   clean-without-yogyata-is-not-abhava
--                   a search that is Clean while the Abhava FAILS.  This is
--                   the load-bearing half: it shows the second hypothesis
--                   cannot be dropped, so "I looked and did not find it" does
--                   not imply "it is not there" and no amount of care in
--                   phrasing repairs that.
--   extent-load-bearing
--                   the SAME locus and SAME counterpositive, two extents: one
--                   clean, one not.  The extent is part of the claim, exactly
--                   as the avacchedaka is part of the absence in
--                   `AbhavaAvacchedaka.limitor-load-bearing`.
--
-- WHAT IS NOT CLAIMED.  That fitness is decidable, or checkable, or that this
-- file can tell you whether YOUR search had it.  `Yogya` is a proof obligation
-- on whoever ran the search.  In the Haskell layer it necessarily degrades to
-- testimony carrying its reason (`Fitness = Yogya String | Ayogya String`),
-- and that degradation is stated at both ends rather than hidden at one.
------------------------------------------------------------------------

module Anupalabdhi_TheFitnessIsWhatMakesNonApprehensionKnowledge where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Relation.Nullary using (¬_)

------------------------------------------------------------------------
-- The search.  Three slots: where you looked, what you were looking for, and
-- HOW MUCH OF IT you actually examined.  The third is the one every failing
-- instance above was missing.
------------------------------------------------------------------------

record Anvesana : Type₁ where
  field
    anuyogin   : Type              -- the locus: where the search ran
    pratiyogin : anuyogin → Type   -- the counterpositive: what was sought
    drsta      : anuyogin → Type   -- दृष्ट, the examined region: this point
                                   -- was actually looked at

open Anvesana public

-- The search came back empty: no EXAMINED point bore the counterpositive.
-- This is what a grep, a sweep, a 40-assignment poll actually delivers.
Clean : Anvesana → Type
Clean A = (x : A .anuyogin) → A .drsta x → ¬ (A .pratiyogin x)

-- The fitness.  Every point of the locus was examined — so anything present
-- would have been met.  This is yogyatā, and it is a claim about the SEARCH,
-- not about the counterpositive.
Yogya : Anvesana → Type
Yogya A = (x : A .anuyogin) → A .drsta x

-- The absence itself: nothing in the locus bears the counterpositive.  This is
-- what people say when they report a negative result, and it is strictly more
-- than Clean.
Abhava : Anvesana → Type
Abhava A = (x : A .anuyogin) → ¬ (A .pratiyogin x)

------------------------------------------------------------------------
-- The theorem.  One line, deliberately: nothing here was ever hard, and
-- claiming otherwise would be a second error.  What was missing in every
-- instance in the header is the second argument.
------------------------------------------------------------------------

yogyanupalabdhi : (A : Anvesana) → Clean A → Yogya A → Abhava A
yogyanupalabdhi _ clean yogya x = clean x (yogya x)

-- And the easy direction, stated so the asymmetry is visible: an absence makes
-- every search clean, with no fitness required.  So Clean is the weaker
-- notion, and the gap between them is exactly what fitness closes.
abhava→clean : (A : Anvesana) → Abhava A → Clean A
abhava→clean _ abs x _ = abs x

------------------------------------------------------------------------
-- The load-bearing half.  A search that came back clean, over a real and
-- non-empty examined region, where the absence is FALSE.
--
-- locus = Bool.  The counterpositive is borne by `true` only.  The search
-- examined `false` only.  It found nothing, honestly, over a region it really
-- did examine — and the thing was there the whole time, at the point the
-- search did not reach.
------------------------------------------------------------------------

ghost : Anvesana
ghost .anuyogin     = Bool
ghost .pratiyogin x = x ≡ true
ghost .drsta      x = x ≡ false

-- the search is clean: at an examined point x (so x ≡ false), x ≡ true would
-- give true ≡ false.
ghost-clean : Clean ghost
ghost-clean _ x≡false x≡true = true≢false (sym x≡true ∙ x≡false)

-- and the region examined is not empty: `false` was genuinely looked at.
ghost-looked-somewhere : Σ[ x ∈ ghost .anuyogin ] (ghost .drsta x)
ghost-looked-somewhere = false , refl

-- and the absence is FALSE: `true` bears the counterpositive.
ghost-abhava-fails : ¬ (Abhava ghost)
ghost-abhava-fails abs = abs true refl

-- Put together: Clean, non-empty extent, and no absence.  So the fitness
-- hypothesis in `yogyanupalabdhi` cannot be dropped, and cannot be weakened to
-- "something was examined" either.
clean-without-yogyata-is-not-abhava :
    (Clean ghost)
  × (Σ[ x ∈ ghost .anuyogin ] (ghost .drsta x))
  × (¬ (Abhava ghost))
clean-without-yogyata-is-not-abhava =
  ghost-clean , ghost-looked-somewhere , ghost-abhava-fails

-- Consequently the fitness itself fails for this search — which is the
-- diagnosis, and it is derived rather than asserted: had it held, the theorem
-- would have delivered an absence that is refutable.
ghost-is-not-yogya : ¬ (Yogya ghost)
ghost-is-not-yogya y = ghost-abhava-fails (yogyanupalabdhi ghost ghost-clean y)

------------------------------------------------------------------------
-- The extent is part of the claim.  Same locus, same counterpositive, two
-- searches differing only in how far they looked: one is clean and the other
-- is not.  So "not found" is a function of the extent, and a negative reported
-- without it has not said which of these two happened.
--
-- This is `AbhavaAvacchedaka.limitor-load-bearing` for the third slot: change
-- the limitor and you change the absence; change the extent and you change
-- what the search establishes.
------------------------------------------------------------------------

sarva : Anvesana                    -- the same search, run over everything
sarva .anuyogin     = Bool
sarva .pratiyogin x = x ≡ true
sarva .drsta      _ = Bool          -- every point examined (any inhabitant)

sarva-is-yogya : Yogya sarva
sarva-is-yogya _ = true

sarva-not-clean : ¬ (Clean sarva)
sarva-not-clean c = c true true refl

extent-load-bearing :
    (Clean ghost)          -- clean, over the narrow extent
  × (¬ (Clean sarva))      -- not clean, over the whole locus
extent-load-bearing = ghost-clean , sarva-not-clean

------------------------------------------------------------------------
-- APPENDED, so the reading is not left to a later reader's charity.
--
-- What this file licenses: reporting an absence when the extent examined
-- covers the locus, and reporting a CLEAN SEARCH OVER A STATED EXTENT
-- otherwise.  Those are two different sentences with two different types, and
-- until today this repository's engine could only say the second while its
-- notes said the first.
--
-- What it does not license: treating `Yogya` as something the machine can
-- check for itself.  Nothing here decides whether a grep would have caught a
-- differently-spelled name, or whether 84 assignments cover a term of arity
-- four (they cover 0.61% of the box — `ANEKANTA.md` §12).  The fitness is a
-- claim someone makes and can be wrong about.  The gain is that it is now a
-- claim that has to be MADE.
------------------------------------------------------------------------
