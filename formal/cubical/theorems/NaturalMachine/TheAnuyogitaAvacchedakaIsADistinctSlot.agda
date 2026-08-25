{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.TheAnuyogitaAvacchedakaIsADistinctSlot
--
-- An absence carries TWO limitors, not one, and neither is derivable
-- from the other.  Checked: with the counterpositive's limitor held
-- fixed, moving the locus's limitor flips the verdict; with the locus's
-- limitor held fixed, moving the counterpositive's limitor flips it.
-- And the one-limitor presentation loses absences: there is an absence
-- that HOLDS under a delimited locus and FAILS on the whole one.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT PROVOKED THIS, AND THE GREP THAT CONFIRMED IT WAS STILL OPEN
--
-- `notes/INDIC_FORMAL_TRADITIONS_MAP.md` §3.3 states a two-part gap:
--
--   "the limitor is a *dependent binder over the relatum* — and,
--    separately, that the avacchedaka of the `pratiyogitā` and the
--    avacchedaka of the `anuyogitā` are distinct slots.  Neither of
--    these is used anywhere in the repo."
--
-- The first part is closed: `AbhavaAvacchedaka` makes the limitor a
-- dependent binder and proves it load-bearing, and
-- `NaturalMachine.ExclusionInstantiatesAbhavaWithALoadBearingLimitor`
-- uses it.  I READ `AbhavaAvacchedaka.agda` before writing this: its
-- record has ONE limitor field, delimiting `pratiyogin` only, and
-- `holds A α = (x : A .anuyogin) → ¬ (A .pratiyogin α x)` quantifies
-- over the whole locus with nothing delimiting it.
--
-- The second part was still open, and I checked rather than assumed:
--
--   grep -rn 'pratiyogitā\|anuyogitā' --include=*.agda --include=*.md
--            --include=*.hs .        (excluding .git)
--
-- returned exactly two lines, BOTH prose, NEITHER formal —
-- `INDIC_FORMAL_TRADITIONS_MAP.md:292` (the sentence above) and
-- `SEED53_PRATIYOGIN_OF_THE_PRIMITIVE_PROJECTOR.md:22`.  Zero `.agda`
-- files.  Output not truncated.
--
-- ────────────────────────────────────────────────────────────────────
-- THE SCHOOL, AND ITS TERMS, NAMED BEFORE USE
--
-- Navya-Nyāya (Gaṅgeśa, *Tattvacintāmaṇi*, 14th c.; Raghunātha).  An
-- abhāva is specified by its relata and by the modes under which each
-- relatum is taken:
--
--   pratiyogin              the counterpositive — what is absent
--   pratiyogitāvacchedaka   the mode under which the counterpositive is
--                           taken (pot-absence *qua pot-ness*, not qua
--                           blue-pot-ness)
--   anuyogin                the locus
--   anuyogitāvacchedaka     the mode under which the LOCUS is taken
--
-- SOURCING LIMIT, stated and not evaded.  No primary Sanskrit text was
-- opened.  The slot doctrine is carried from this repository's own
-- `notes/ABHAVA.md` and from `INDIC_FORMAL_TRADITIONS_MAP.md` §3.1,
-- exactly as `AbhavaAvacchedaka.agda`'s own header records for itself.
-- Verse-level sourcing is OWED AND NOT CLAIMED.  The concrete example in
-- §3 is MINE — a two-point locus, not a tradition example — and it is
-- offered as a separating instance, not as an exegesis.
--
-- WHAT RIVAL SCHOOLS WOULD SAY TO EACH OTHER, unadjudicated.  The
-- Prābhākara Mīmāṃsakas deny that abhāva is a distinct padārtha at all:
-- for them what is reported as apprehending an absence is apprehending
-- the bare locus, so the whole slot apparatus is machinery for an entity
-- they do not admit — and on that view §3 below separates two readings
-- of one bare floor, not two absences.  The Buddhist apoha theorists
-- (Dignāga, Dharmakīrti) take exclusion as primitive rather than
-- built from a positive relatum, so the question "which limitor
-- delimits the counterpositive" does not arise in their terms at all.
-- Nothing here adjudicates any of that; the theorems are about the
-- Naiyāyika apparatus as the Naiyāyikas state it.  (Related and already
-- settled elsewhere in this corpus: MAP §2.3 refutes the reading of
-- apoha as Boolean complementation.)
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED
--
-- * NOT the Panday–Ghosh treatment.  arXiv:2605.12548 claims typed
--   abhāva, dependent delimitation, tādātmya AND paramparā-sambandha
--   together; arxiv.org is unreachable from here, so NO NOVELTY is
--   claimed for anything below until someone who can read it compares.
--   `notes/ABHAVA.md` A6 carries that obligation and it stays open.
-- * NOT tādātmya, NOT paramparā-sambandha.  Two slots only.
-- * NOT that two slots are the tradition's final count.  Navya-Nyāya
--   iterates `-tva`/`-tā` abstraction and chains sambandhas without a
--   stated bound; two is what §3.3 named as missing, not a ceiling, and
--   nothing below is evidence about the third.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — container pin.  --safe, no
-- postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.TheAnuyogitaAvacchedakaIsADistinctSlot where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false ; false≢true)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import AbhavaAvacchedaka using (Abhava ; anuyogin ; avacchedaka ; pratiyogin ; holds)

------------------------------------------------------------------------
-- 1.  The two-slot absence
--
-- `AbhavaAvacchedaka.Abhava` delimits the counterpositive and leaves the
-- locus bare.  Here the locus carries its own limitor: `locus ν x` is
-- "x belongs to the anuyogin, taken under mode ν".
------------------------------------------------------------------------

record Abhava₂ : Type₁ where
  field
    anuyogin₂             : Type
    pratiyogitavacchedaka : Type
    anuyogitavacchedaka   : Type
    pratiyogin₂ : pratiyogitavacchedaka → anuyogin₂ → Type
    locus       : anuyogitavacchedaka   → anuyogin₂ → Type

open Abhava₂ public

-- the absence, taken under BOTH modes: nothing in the locus-under-ν
-- bears the counterpositive-under-π.
holds₂ : (A : Abhava₂) → A .pratiyogitavacchedaka → A .anuyogitavacchedaka → Type
holds₂ A π ν = (x : A .anuyogin₂) → A .locus ν x → ¬ (A .pratiyogin₂ π x)

-- forgetting the locus limitor lands exactly in the one-slot record
reduct : Abhava₂ → Abhava
reduct A .anuyogin    = A .anuyogin₂
reduct A .avacchedaka = A .pratiyogitavacchedaka
reduct A .pratiyogin  = A .pratiyogin₂

------------------------------------------------------------------------
-- 2.  How the two verdicts stand to each other — both directions, so
--     neither is called simply stronger
--
-- The one-slot verdict demands more: it quantifies over the bare locus,
-- so it implies the two-slot verdict at EVERY ν, with no hypothesis.
-- The two-slot verdict returns the one-slot one only when the locus
-- limitor is total — i.e. exactly when the limitor was doing nothing.
------------------------------------------------------------------------

oneSlot→twoSlot :
  (A : Abhava₂) (π : A .pratiyogitavacchedaka) (ν : A .anuyogitavacchedaka)
  → holds (reduct A) π → holds₂ A π ν
oneSlot→twoSlot A π ν h x _ = h x

twoSlot→oneSlot-when-the-limitor-is-inert :
  (A : Abhava₂) (π : A .pratiyogitavacchedaka) (ν : A .anuyogitavacchedaka)
  → ((x : A .anuyogin₂) → A .locus ν x)
  → holds₂ A π ν → holds (reduct A) π
twoSlot→oneSlot-when-the-limitor-is-inert A π ν total h x = h x (total x)

------------------------------------------------------------------------
-- 3.  A separating absence, and both slots load-bearing on it
--
-- Locus = Bool (two points).  The counterpositive under π at x holds iff
-- π is `true` and x is `true`.  The locus under ν contains x iff, should
-- ν be `true`, x is `false` — so ν = `true` keeps only the point
-- `false`, and ν = `false` keeps both.
------------------------------------------------------------------------

separating : Abhava₂
separating .anuyogin₂             = Bool
separating .pratiyogitavacchedaka = Bool
separating .anuyogitavacchedaka   = Bool
separating .pratiyogin₂ π x = (π ≡ true) × (x ≡ true)
separating .locus       ν x = (ν ≡ true) → (x ≡ false)

-- under ν = false the locus limitor is inert: every point is in
locusFalseIsTotal : (x : Bool) → separating .locus false x
locusFalseIsTotal x p = ⊥.rec (false≢true p)

-- ── the LOCUS limitor is load-bearing: π fixed at `true`, ν moves ─────

absenceHoldsOnTheDelimitedLocus : holds₂ separating true true
absenceHoldsOnTheDelimitedLocus x inLocus bears =
  false≢true (sym (inLocus refl) ∙ bears .snd)

absenceFailsOnTheWholeLocus : ¬ (holds₂ separating true false)
absenceFailsOnTheWholeLocus h = h true (locusFalseIsTotal true) (refl , refl)

-- ── the COUNTERPOSITIVE limitor is load-bearing: ν fixed at `false`,
--    π moves.  This half is the one `AbhavaAvacchedaka` already had; it
--    is redone here only so both slots are separated on ONE object.

absenceHoldsUnderTheOtherCounterpositiveLimitor : holds₂ separating false false
absenceHoldsUnderTheOtherCounterpositiveLimitor x _ bears =
  false≢true (bears .fst)

------------------------------------------------------------------------
-- 4.  THE STATEMENT.  One limitor slot loses an absence.
--
-- The very same locus and the very same counterpositive family — that
-- is, identical one-slot data — give an absence that holds under a
-- delimited locus and fails on the bare one.  So the anuyogitā's
-- limitor is not recoverable from the one-slot record, and dropping it
-- is not a simplification but a change of subject.
------------------------------------------------------------------------

oneSlotLosesAnAbsence :
    (holds₂ separating true true)          -- holds, locus taken under `true`
  × (¬ (holds (reduct separating) true))   -- fails, locus taken bare
oneSlotLosesAnAbsence =
    absenceHoldsOnTheDelimitedLocus
  , λ h → absenceFailsOnTheWholeLocus
            (oneSlot→twoSlot separating true false h)

bothSlotsAreLoadBearing :
    ((holds₂ separating true true) × (¬ (holds₂ separating true false)))
  × ((holds₂ separating false false) × (¬ (holds₂ separating true false)))
bothSlotsAreLoadBearing =
    (absenceHoldsOnTheDelimitedLocus , absenceFailsOnTheWholeLocus)
  , (absenceHoldsUnderTheOtherCounterpositiveLimitor , absenceFailsOnTheWholeLocus)

------------------------------------------------------------------------
-- 5.  What this closes, and what it does not
--
-- MAP §3.3's second clause — "the avacchedaka of the pratiyogitā and the
-- avacchedaka of the anuyogitā are distinct slots … not used anywhere in
-- the repo" — is now used, and the distinctness is a theorem rather than
-- a report of the doctrine.
--
-- What it does NOT close is §3.3's recommendation, which was about the
-- `weaver` lane's own limitor layer (its audit reporting 0 originating
-- sites, 12 propagating, 39 unlimited).  Nothing here touches that lane
-- or that audit; a second slot existing in `formal/cubical/` does not
-- fill a slot in `runtime/kernel/`.  Those are different files and the
-- finding stands where it was made.
------------------------------------------------------------------------
