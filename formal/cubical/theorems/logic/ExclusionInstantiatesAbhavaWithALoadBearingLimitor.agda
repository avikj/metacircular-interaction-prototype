{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module ExclusionInstantiatesAbhavaWithALoadBearingLimitor where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)
open import AbhavaAvacchedaka using (Abhava ; anuyogin ; avacchedaka ; pratiyogin ; holds)

------------------------------------------------------------------------
-- ExclusionInstantiatesAbhavaWithALoadBearingLimitor
--
-- weak version of its own organizing concept in the strong substrate: an
-- avacchedaka is a type-level BINDER, not an optional field, and the
-- `weaver` lane's limitor layer is inert.  Its 2026-08-18 CORE SUPPLIED
-- block records `formal/cubical/AbhavaAvacchedaka.agda` (cf-sakshi), where
-- `Abhava` is a dependent record with `pratiyogin : avacchedaka → anuyogin
-- → Type` and `limitor-load-bearing` proves an absence that holds under one
-- limitor and fails under another.
--
-- Read after this thread's absence modules were written, and it bears on
-- them directly.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED, AND WHY IT IS THE SHORT VERSION
--
-- §1 exhibits this thread's exclusion as an `Abhava`: the locus is the one
-- distinguishable pair of states, the LIMITORS ARE THE OBSERVABLES, and the
-- counterpositive under limitor α is "the pair is identified by α".  §2 is
-- the `limitor-load-bearing` statement in that instance: the same pair and
-- the same counterpositive-family give an absence that HOLDS under one
-- observable and FAILS under another.
--
-- The proof is two lines because the content was already there.  That is
-- the finding, not a shortcut — see below.
--
-- ────────────────────────────────────────────────────────────────────
-- THE WEAK-VERSION CRITIQUE DOES NOT APPLY TO THESE MODULES, AND HERE IS
-- THE CHECK
--
-- §6.3's critique is of a limitor carried as an *optional field* with no
-- originating sites.  In `ExclusionRecoversGroundAtAPrice`
-- the observable `q` is a PARAMETER of the absence:
--
--     Ground   q x x'  =  q x ≡ q x'
--     Excludes q x x'  =  ¬ (Ground q x x')
--
-- so the absence is a family dependent on `q`, which is what §6.3 asks
-- for — and every transfer theorem in that module (`coIdentify→coExclude`,
-- `coExclude→coIdentify-stable`, the shadow necessities) is a
-- change-the-limitor statement, relating the absence under `q` to the
-- absence under `q'`.  That is the same shape as `limitor-load-bearing`,
-- proved for arbitrary observables rather than for two.
--
-- **Not claimed:** that this thread reached that shape by reading the
-- avacchedaka literature.  It did not; the parametrisation came from
-- `FiniteInformation`, and §6.3 was read afterwards.  Arriving at a shape
-- independently is not the same as having consulted the tradition, and the
-- standing rule in that note's §7 — a handle is never a citation — has the
-- same force for a coincidence of structure.
--
-- ────────────────────────────────────────────────────────────────────
-- LIMITS
--
-- `avacchedaka` here is `Bool`: two observables, chosen. That is a
-- hypothesis of §2, not a claim that limitors form a two-element type. The
-- locus is `Unit`: the single pair that can be separated on two points.
--
-- Inherited from `AbhavaAvacchedaka` and repeated: this is the
-- avacchedaka/abhāva core only. The full Panday–Ghosh simultaneous
-- treatment adds tādātmya and paramparā-sambandha and is not here.
--
-- arXiv:2605.12548 is the located prior art for typed abhāva in cubical
-- type theory, arxiv.org is EGRESS_BLOCKED from this environment, and NO
-- NOVELTY IS CLAIMED for anything below until someone who can read it
-- compares them.
--
-- PRIOR ART, grep run and quoted -- and the first draft of this paragraph
-- was wrong.  `grep -rn AbhavaAvacchedaka formal/cubical/` outside the
-- file itself returns TWO lines: `Everything.agda:592` and
-- `IndianLane.agda:114`, both plain `import` lines in aggregator modules,
-- plus one mention in `IndianLane`'s header comment.  So it has importers;
-- what I could not locate is any module that USES its record.  That is a
-- weaker statement and it is the one made here.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1.  The two observables, and the exclusion as an Abhava
------------------------------------------------------------------------

-- limitor `false`: the identity observable, which separates the two states.
-- limitor `true` : the constant observable, which identifies them.
obs : Bool → Bool → Bool
obs false x = x
obs true  _ = true

-- locus: the one pair of states a two-point space can separate, so a
-- single point suffices to name it.
-- counterpositive under α: "α identifies the pair".
exclusionAbhava : Abhava
exclusionAbhava .anuyogin      = Unit
exclusionAbhava .avacchedaka   = Bool
exclusionAbhava .pratiyogin α _ = obs α true ≡ obs α false

------------------------------------------------------------------------
-- 2.  The limitor is load-bearing here too
--
-- Under the identity observable the pair is not identified, so the absence
-- HOLDS.  Under the constant observable it is, so the absence FAILS.  Same
-- locus, same counterpositive family, different limitor.
------------------------------------------------------------------------

exclusionLimitorLoadBearing :
    (holds exclusionAbhava false)
  × (¬ (holds exclusionAbhava true))
exclusionLimitorLoadBearing =
    (λ _ p → true≢false p)
  , (λ h → h tt refl)
