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
-- In `formal/cubical/AbhavaAvacchedaka.agda`,
-- `Abhava` is a dependent record with `pratiyogin : avacchedaka → anuyogin
-- → Type` and `limitor-load-bearing` proves an absence that holds under one
-- limitor and fails under another.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED, AND WHY IT IS THE SHORT VERSION
--
-- §1 exhibits the exclusion as an `Abhava`: the locus is the one
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
-- ────────────────────────────────────────────────────────────────────
-- THE INSTANCE
--
-- `avacchedaka` here is `Bool`: two observables, chosen. That is a
-- hypothesis of §2.  The
-- locus is `Unit`: the single pair that can be separated on two points.
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
