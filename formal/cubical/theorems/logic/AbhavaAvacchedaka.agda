{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AbhavaAvacchedaka ‚î Navya-Nyya absence, with the limitor as a genuine
-- dependent binder (not an optional field).
--
-- SOURCE.  In Navya-Nyya (Gagea, Tattvacintmai, 14th c.; Raghuntha)
-- an absence (abhva) is not a property a thing lacks; it is a relational
-- entity with named slots:
--   pratiyogin  ‚î the counterpositive: the thing that is absent;
--   anuyogin    ‚î the locus: where it is absent;
--   avacchedaka ‚î the LIMITOR: the mode/aspect under which the
--                 counterpositive is taken.
-- The operative doctrine (ABHAVA.md ¬ß1): CHANGE THE LIMITOR AND YOU CHANGE
-- THE ABSENCE.  "The absence of THIS pot" and "the absence of POTS AS SUCH"
-- are different absences with different truth conditions.
--
-- THE POINT, per this repository's own naming audit
-- (INDIC_FORMAL_TRADITIONS_MAP.md ¬ß3.3, ¬ß6.3): the tradition's own
-- formalizers ‚î Ganeri, Bhattacharyya, and Panday‚ìGhosh (Cubical Type
-- Theoretic Navya-Nyya) ‚î establish that the avacchedaka delimiting a
-- pratiyogin is a TYPE-LEVEL BINDER, not a free variable, which is exactly
-- why higher-order logic cannot hold it and a dependent Œ† can.  The repo's
-- existing "index" lane runs the WEAK version (the limitor as an optional
-- field, its audit reporting zero live originating sites).  This file
-- supplies the core of the strong version in the declared substrate: the
-- limitor as a genuine dependent parameter, and the theorem that it is
-- LOAD-BEARING ‚î the absence is a real function of the limitor, so any
-- account that drops it conflates distinct absences.
--
-- Contents (no postulates, no holes, --safe):
--
--   Absence          the abhva as a dependent record: an anuyogin (locus),
--                    a pratiyogin indexed by the avacchedaka (limitor), and
--                    the holding of the absence under a given limitor
--   holds            the absence-under-Œ: nothing in the locus bears the
--                    counterpositive under limitor Œ  ((x : ‚ì) ‚í ¬ P Œ x)
--   limitor-load-bearing
--                    a concrete abhva whose absence HOLDS under one limitor
--                    and FAILS under another ‚î so the limitor cannot be
--                    dropped; "change the limitor, change the absence",
--                    exhibited, refuting the limitor-free reading
------------------------------------------------------------------------

module AbhavaAvacchedaka where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false)
open import Cubical.Relation.Nullary using (¬¨_)

private
  variable
    ‚Ñì : Level

------------------------------------------------------------------------
-- The abhva, with the avacchedaka as a genuine dependent binder.
------------------------------------------------------------------------

-- An absence structure: a locus (anuyogin), a set of limitors
-- (avacchedaka), and the counterpositive (pratiyogin) as a family DEPENDENT
-- on the limitor ‚î "x bears the counterpositive, taken under limitor Œ".
record Abhava : Type‚ÇÅ where
  field
    anuyogin    : Type                       -- the locus
    avacchedaka : Type                       -- the limitors (modes)
    pratiyogin  : avacchedaka ‚Üí anuyogin ‚Üí Type
                                             -- x bears the counterpositive
                                             -- UNDER limitor Œ  (dependent)

open Abhava public

-- the absence, taken under a given limitor: nothing in the locus bears the
-- counterpositive under Œ.  The limitor Œ is a real parameter here ‚î a
-- dependent binder over the pratiyogin, not a discardable tag.
holds : (A : Abhava) ‚Üí A .avacchedaka ‚Üí Type
holds A Œ± = (x : A .anuyogin) ‚Üí ¬¨ (A .pratiyogin Œ± x)

------------------------------------------------------------------------
-- The limitor is load-bearing.  A concrete abhva on the two-point locus
-- with two limitors, where the SAME locus and SAME counterpositive-family
-- give an absence that HOLDS under one limitor and FAILS under the other.
-- So the absence is a genuine function of the avacchedaka: drop it and you
-- conflate two distinct absences.  This is "change the limitor, change the
-- absence", as a theorem ‚î and the exact thing a limitor-free ¬ cannot see.
------------------------------------------------------------------------

-- locus = Bool, limitors = Bool.  Counterpositive under Œ at x: holds iff
-- Œ is `true` and x is `true`.  So under limitor `false` nothing bears it
-- (absence holds); under limitor `true` the point `true` bears it (absence
-- fails).
example : Abhava
example .anuyogin    = Bool
example .avacchedaka = Bool
example .pratiyogin Œ± x = (Œ± ‚â° true) √ó (x ‚â° true)

limitor-load-bearing :
    (holds example false)              -- absence HOLDS under limitor `false`
  √ó (¬¨ (holds example true))           -- absence FAILS under limitor `true`
limitor-load-bearing =
    (Œª x aŒ± ‚Üí true‚â¢false (sym (aŒ± .fst)))   -- Œ±‚â°true is false when Œ±=false
  , (Œª h ‚Üí h true (refl , refl))            -- at Œ±=true, x=true bears it

------------------------------------------------------------------------
-- This record delimits the pratiyogin and leaves the anuyogin bare.
-- `INDIC_FORMAL_TRADITIONS_MAP.md` ¬ß3.3 names that as half of a gap: in
-- Navya-Nyya the pratiyogit and the anuyogit carry DISTINCT
-- avacchedakas.  The second slot is added, and proved not derivable from
-- the first, in
-- `TheAnuyogitaAvacchedakaIsADistinctSlot`, whose
-- `reduct : Abhava‚ ‚í Abhava` lands exactly in this record.
--
-- That module's `oneSlot‚ítwoSlot` shows `holds` here implies the
-- two-slot verdict at every locus limitor, with no hypothesis; the
-- converse needs the locus limitor to be total, i.e. inert.  So this
-- module's `holds` is not a weaker notion ‚î it is the stronger demand,
-- and what it lacks is the ability to state the delimited one.
------------------------------------------------------------------------
