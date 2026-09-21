{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheAnuyogitaAvacchedakaIsADistinctSlot
--
-- An absence carries TWO limitors, not one, and neither is derivable
-- from the other.  Checked: with the counterpositive's limitor held
-- fixed, moving the locus's limitor flips the verdict; with the locus's
-- limitor held fixed, moving the counterpositive's limitor flips it.
-- And the one-limitor presentation loses absences: there is an absence
-- that HOLDS under a delimited locus and FAILS on the whole one.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT PROVOKED THIS
--
--
--   "the limitor is a *dependent binder over the relatum* ‚î and,
--    separately, that the avacchedaka of the `pratiyogit` and the
--    avacchedaka of the `anuyogit` are distinct slots.  Neither of
--    these is used anywhere in the repo."
--
-- The first part: `AbhavaAvacchedaka` makes the limitor a
-- dependent binder and proves it load-bearing, and
-- `ExclusionInstantiatesAbhavaWithALoadBearingLimitor`
-- uses it.  Its
-- record has ONE limitor field, delimiting `pratiyogin` only, and
-- `holds A Œ = (x : A .anuyogin) ‚í ¬ (A .pratiyogin Œ x)` quantifies
-- over the whole locus with nothing delimiting it.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE SCHOOL, AND ITS TERMS, NAMED BEFORE USE
--
-- Navya-Nyya (Gagea, *Tattvacintmai*, 14th c.; Raghuntha).  An
-- abhva is specified by its relata and by the modes under which each
-- relatum is taken:
--
--   pratiyogin              the counterpositive ‚î what is absent
--   pratiyogitvacchedaka   the mode under which the counterpositive is
--                           taken (pot-absence *qua pot-ness*, not qua
--                           blue-pot-ness)
--   anuyogin                the locus
--   anuyogitvacchedaka     the mode under which the LOCUS is taken
--
-- SOURCING.
-- The slot doctrine is carried from this repository's own exactly as
-- `AbhavaAvacchedaka.agda`'s own header records for itself. The concrete
-- example in
-- ¬ß3 is this module's ‚î a two-point locus, not a tradition example ‚î and it is
-- offered as a separating instance, not as an exegesis.
--
-- WHAT RIVAL SCHOOLS WOULD SAY TO EACH OTHER, unadjudicated.  The
-- Prbhkara Mmsakas deny that abhva is a distinct padrtha at all:
-- for them what is reported as apprehending an absence is apprehending
-- the bare locus, so the whole slot apparatus is machinery for an entity
-- they do not admit ‚î and on that view ¬ß3 below separates two readings
-- of one bare floor, not two absences.  The Buddhist apoha theorists
-- (Dignga, Dharmakrti) take exclusion as primitive rather than
-- built from a positive relatum, so the question "which limitor
-- delimits the counterpositive" does not arise in their terms at all.
-- Nothing here adjudicates any of that; the theorems are about the
-- Naiyyika apparatus as the Naiyyikas state it.  (Related and already
-- settled elsewhere in this corpus: MAP ¬ß2.3 refutes the reading of
-- apoha as Boolean complementation.)
--
------------------------------------------------------------------------

module TheAnuyogitaAvacchedakaIsADistinctSlot where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; true‚â¢false ; false‚â¢true)
open import Cubical.Data.Empty as ‚ä• using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

open import AbhavaAvacchedaka using (Abhava ; anuyogin ; avacchedaka ; pratiyogin ; holds)

------------------------------------------------------------------------
-- 1.  The two-slot absence
--
-- `AbhavaAvacchedaka.Abhava` delimits the counterpositive and leaves the
-- locus bare.  Here the locus carries its own limitor: `locus ŒΩ x` is
-- "x belongs to the anuyogin, taken under mode ŒΩ".
------------------------------------------------------------------------

record Abhava‚ÇÇ : Type‚ÇÅ where
  field
    anuyogin‚ÇÇ             : Type
    pratiyogitavacchedaka : Type
    anuyogitavacchedaka   : Type
    pratiyogin‚ÇÇ : pratiyogitavacchedaka ‚Üí anuyogin‚ÇÇ ‚Üí Type
    locus       : anuyogitavacchedaka   ‚Üí anuyogin‚ÇÇ ‚Üí Type

open Abhava‚ÇÇ public

-- the absence, taken under BOTH modes: nothing in the locus-under-ŒΩ
-- bears the counterpositive-under-œ.
holds‚ÇÇ : (A : Abhava‚ÇÇ) ‚Üí A .pratiyogitavacchedaka ‚Üí A .anuyogitavacchedaka ‚Üí Type
holds‚ÇÇ A œÄ ŒΩ = (x : A .anuyogin‚ÇÇ) ‚Üí A .locus ŒΩ x ‚Üí ¬¨ (A .pratiyogin‚ÇÇ œÄ x)

-- forgetting the locus limitor lands exactly in the one-slot record
reduct : Abhava‚ÇÇ ‚Üí Abhava
reduct A .anuyogin    = A .anuyogin‚ÇÇ
reduct A .avacchedaka = A .pratiyogitavacchedaka
reduct A .pratiyogin  = A .pratiyogin‚ÇÇ

------------------------------------------------------------------------
-- 2.  How the two verdicts stand to each other ‚î both directions, so
--     neither is called simply stronger
--
-- The one-slot verdict demands more: it quantifies over the bare locus,
-- so it implies the two-slot verdict at EVERY ŒΩ, with no hypothesis.
-- The two-slot verdict returns the one-slot one only when the locus
-- limitor is total ‚î i.e. exactly when the limitor was doing nothing.
------------------------------------------------------------------------

oneSlot‚ÜítwoSlot :
  (A : Abhava‚ÇÇ) (œÄ : A .pratiyogitavacchedaka) (ŒΩ : A .anuyogitavacchedaka)
  ‚Üí holds (reduct A) œÄ ‚Üí holds‚ÇÇ A œÄ ŒΩ
oneSlot‚ÜítwoSlot A œÄ ŒΩ h x _ = h x

twoSlot‚ÜíoneSlot-when-the-limitor-is-inert :
  (A : Abhava‚ÇÇ) (œÄ : A .pratiyogitavacchedaka) (ŒΩ : A .anuyogitavacchedaka)
  ‚Üí ((x : A .anuyogin‚ÇÇ) ‚Üí A .locus ŒΩ x)
  ‚Üí holds‚ÇÇ A œÄ ŒΩ ‚Üí holds (reduct A) œÄ
twoSlot‚ÜíoneSlot-when-the-limitor-is-inert A œÄ ŒΩ total h x = h x (total x)

------------------------------------------------------------------------
-- 3.  A separating absence, and both slots load-bearing on it
--
-- Locus = Bool (two points).  The counterpositive under œ at x holds iff
-- œ is `true` and x is `true`.  The locus under ŒΩ contains x iff, should
-- ŒΩ be `true`, x is `false` ‚î so ŒΩ = `true` keeps only the point
-- `false`, and ŒΩ = `false` keeps both.
------------------------------------------------------------------------

separating : Abhava‚ÇÇ
separating .anuyogin‚ÇÇ             = Bool
separating .pratiyogitavacchedaka = Bool
separating .anuyogitavacchedaka   = Bool
separating .pratiyogin‚ÇÇ œÄ x = (œÄ ‚â° true) √ó (x ‚â° true)
separating .locus       ŒΩ x = (ŒΩ ‚â° true) ‚Üí (x ‚â° false)

-- under ŒΩ = false the locus limitor is inert: every point is in
locusFalseIsTotal : (x : Bool) ‚Üí separating .locus false x
locusFalseIsTotal x p = ‚ä•.rec (false‚â¢true p)

-- ‚î‚î the LOCUS limitor is load-bearing: œ fixed at `true`, ŒΩ moves ‚î‚î‚î‚î‚î

absenceHoldsOnTheDelimitedLocus : holds‚ÇÇ separating true true
absenceHoldsOnTheDelimitedLocus x inLocus bears =
  false‚â¢true (sym (inLocus refl) ‚àô bears .snd)

absenceFailsOnTheWholeLocus : ¬¨ (holds‚ÇÇ separating true false)
absenceFailsOnTheWholeLocus h = h true (locusFalseIsTotal true) (refl , refl)

-- ‚î‚î the COUNTERPOSITIVE limitor is load-bearing: ŒΩ fixed at `false`,
--    œ moves.  This half is the one `AbhavaAvacchedaka` already had; it
--    is redone here only so both slots are separated on ONE object.

absenceHoldsUnderTheOtherCounterpositiveLimitor : holds‚ÇÇ separating false false
absenceHoldsUnderTheOtherCounterpositiveLimitor x _ bears =
  false‚â¢true (bears .fst)

------------------------------------------------------------------------
-- 4.  THE STATEMENT.  One limitor slot loses an absence.
--
-- The very same locus and the very same counterpositive family ‚î that
-- is, identical one-slot data ‚î give an absence that holds under a
-- delimited locus and fails on the bare one.  So the anuyogit's
-- limitor is not recoverable from the one-slot record, and dropping it
-- is not a simplification but a change of subject.
------------------------------------------------------------------------

oneSlotLosesAnAbsence :
    (holds‚ÇÇ separating true true)          -- holds, locus taken under `true`
  √ó (¬¨ (holds (reduct separating) true))   -- fails, locus taken bare
oneSlotLosesAnAbsence =
    absenceHoldsOnTheDelimitedLocus
  , Œª h ‚Üí absenceFailsOnTheWholeLocus
            (oneSlot‚ÜítwoSlot separating true false h)

bothSlotsAreLoadBearing :
    ((holds‚ÇÇ separating true true) √ó (¬¨ (holds‚ÇÇ separating true false)))
  √ó ((holds‚ÇÇ separating false false) √ó (¬¨ (holds‚ÇÇ separating true false)))
bothSlotsAreLoadBearing =
    (absenceHoldsOnTheDelimitedLocus , absenceFailsOnTheWholeLocus)
  , (absenceHoldsUnderTheOtherCounterpositiveLimitor , absenceFailsOnTheWholeLocus)

------------------------------------------------------------------------
-- 5.  What this closes
--
-- MAP ¬ß3.3's second clause ‚î "the avacchedaka of the pratiyogit and the
-- avacchedaka of the anuyogit are distinct slots ‚¶ not used anywhere in
-- the repo" ‚î is now used, and the distinctness is a theorem rather than
-- a report of the doctrine.
------------------------------------------------------------------------
