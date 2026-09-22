{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RnaDhana_TheMixedStrataArePairwiseDisjointAndOrdered
--
-- à‹àà§à¨ Â a-dhana â” Brahmagupta, *Brhmasphuasiddhnta* (628): one
-- magnitude read as *dhana* (asset) or *a* (debt).  The sign rules
-- are his; nothing else here is.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- The one-step mixed output properties are iterated here over the whole
-- mixed stratification: disjointness and order.
--
-- WHAT IS PROVED
--
--   mixedStrataSound        a member of ANY mixed stratum was a member
--                           of the archive
--   PairwiseM / OrderedM    the two recursive families over the list of
--                           mixed strata, no indices
--   theMixedStrataArePairwiseDisjoint
--                           for every fuel
--   theMixedStrataAreOrdered
--                           every member of a later mixed stratum is
--                           strictly beaten, in the MIXED order, by a
--                           member of an earlier one â” for every fuel,
--                           given caps bounding the archive
--
-- **DISJOINTNESS NEEDS NO CAPS AND NO FLIP AT ALL**, exactly as at one
-- step: `mixedStratum` and `mixedRemainder` are the two halves of one
-- decidable filter, and `mixedStrataSound` puts every later stratum
-- inside the remainder.  ORDER needs both, and only through
-- `mixedRemainderIsBeaten`, whose cap requirement survives peeling by
-- `allBoundedFilterOut`.  The asymmetry first seen in the unflipped
-- stratification â” coverage needs the measure, disjointness does not â”
-- reappears here in a sharper form: **disjointness and order differ not
-- only in what they need but in WHOSE machinery they need. One is
-- generic list surgery; the other is the whole a-dhana transport.**
--
-- COVERAGE is in `RnaDhana_TheMixedStratificationTerminatesAndCovers`.
--
-- NO NOVELTY.  Standard properties of iterated non-dominated sorting
-- (Goldberg 1989; Deb et al. 2002).
------------------------------------------------------------------------

module RnaDhana_TheMixedStrataArePairwiseDisjointAndOrdered where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_ ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)

open import OrderAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any)
open import OneStepCoverageAndDisjointnessOfTheLayer using (Mem)
open import TheStratificationCoversAndItsStrataArePairwiseDisjoint
  using (filterDecSubset ; filterOutSubset)
open import TheParetoStratumIsDecidableAndTheFilterIsExact using (filterDec)
open import FlippingACostCoordinateIsSoundButNotFaithful using (Vec)
open import RnaDhana_PerCoordinateCapsAreTheHonestVersionAndOneCapIsTheSpecialCase
  using (Caps)
open import RnaDhana_TheParetoMaximumTransfersToCostCoordinates
  using (MixedStrict ; MixedMaximal ; AllBounded)
open import RnaDhana_TheMixedStratumIsExactlyTheFlippedStratum
  using (decMixedMaximal ; mixedStratum)
open import RnaDhana_TheWholeMixedStratificationIsTheFlippedOne
  using (mixedRemainder ; mixedStrata ; allBoundedFilterOut)
open import RnaDhana_TheMixedLayerCoversAndBeatsTheMixedRemainder
  using (mixedLayerIsDisjoint ; mixedRemainderIsBeaten)

------------------------------------------------------------------------
-- 1.  The mixed stratification invents nothing
------------------------------------------------------------------------

MemSomeM : {ds : List Bool} â†’ Vec ds â†’ List (List (Vec ds)) â†’ Type
MemSomeM u sss = Any (Î» ys â†’ Mem u ys) sss

mixedStrataSound :
  (n : â„•) (ds : List Bool) (vs : List (Vec ds)) (u : Vec ds)
  â†’ MemSomeM u (mixedStrata n ds vs) â†’ Mem u vs
mixedStrataSound zero    ds vs       u e = âŠ¥.rec e
mixedStrataSound (suc n) ds []       u e = âŠ¥.rec e
mixedStrataSound (suc n) ds (v âˆ· vs) u (inl h) =
  filterDecSubset (MixedMaximal ds (v âˆ· vs)) (decMixedMaximal ds (v âˆ· vs))
    (v âˆ· vs) u h
mixedStrataSound (suc n) ds (v âˆ· vs) u (inr k) =
  filterOutSubset (MixedMaximal ds (v âˆ· vs)) (decMixedMaximal ds (v âˆ· vs))
    (v âˆ· vs) u
    (mixedStrataSound n ds (mixedRemainder ds (v âˆ· vs)) u k)

------------------------------------------------------------------------
-- 2.  Pairwise disjointness â” generic list surgery, no caps
------------------------------------------------------------------------

DisjointM : {ds : List Bool} â†’ List (Vec ds) â†’ List (Vec ds) â†’ Type
DisjointM {ds} ys zs = (u : Vec ds) â†’ Mem u ys â†’ Mem u zs â†’ âŠ¥

AllDisjointFromM :
  {ds : List Bool} â†’ List (Vec ds) â†’ List (List (Vec ds)) â†’ Type
AllDisjointFromM ys []         = Unit
AllDisjointFromM ys (zs âˆ· sss) = DisjointM ys zs Ã— AllDisjointFromM ys sss

PairwiseM : {ds : List Bool} â†’ List (List (Vec ds)) â†’ Type
PairwiseM []         = Unit
PairwiseM (ys âˆ· sss) = AllDisjointFromM ys sss Ã— PairwiseM sss

disjointFromTheUnionM :
  {ds : List Bool} (ys : List (Vec ds)) (sss : List (List (Vec ds)))
  â†’ ((u : Vec ds) â†’ Mem u ys â†’ MemSomeM u sss â†’ âŠ¥)
  â†’ AllDisjointFromM ys sss
disjointFromTheUnionM ys []         h = tt
disjointFromTheUnionM ys (zs âˆ· sss) h =
    (Î» u mu mz â†’ h u mu (inl mz))
  , disjointFromTheUnionM ys sss (Î» u mu k â†’ h u mu (inr k))

theMixedStrataArePairwiseDisjoint :
  (n : â„•) (ds : List Bool) (vs : List (Vec ds))
  â†’ PairwiseM (mixedStrata n ds vs)
theMixedStrataArePairwiseDisjoint zero    ds vs       = tt
theMixedStrataArePairwiseDisjoint (suc n) ds []       = tt
theMixedStrataArePairwiseDisjoint (suc n) ds (v âˆ· vs) =
    disjointFromTheUnionM (mixedStratum ds (v âˆ· vs))
      (mixedStrata n ds (mixedRemainder ds (v âˆ· vs)))
      (Î» u mu k â†’
        mixedLayerIsDisjoint ds (v âˆ· vs) u mu
          (mixedStrataSound n ds (mixedRemainder ds (v âˆ· vs)) u k))
  , theMixedStrataArePairwiseDisjoint n ds (mixedRemainder ds (v âˆ· vs))

------------------------------------------------------------------------
-- 3.  Order â” the caps enter, through the one-step theorem
------------------------------------------------------------------------

BeatsM : {ds : List Bool} â†’ List (Vec ds) â†’ List (Vec ds) â†’ Type
BeatsM {ds} ys zs =
  (u : Vec ds) â†’ Mem u zs
  â†’ Î£[ z âˆˆ Vec ds ] (Mem z ys Ã— MixedStrict ds u z)

AllBeatenM : {ds : List Bool} â†’ List (Vec ds) â†’ List (List (Vec ds)) â†’ Type
AllBeatenM ys []         = Unit
AllBeatenM ys (zs âˆ· sss) = BeatsM ys zs Ã— AllBeatenM ys sss

OrderedM : {ds : List Bool} â†’ List (List (Vec ds)) â†’ Type
OrderedM []         = Unit
OrderedM (ys âˆ· sss) = AllBeatenM ys sss Ã— OrderedM sss

beatsFromTheUnionM :
  {ds : List Bool} (ys : List (Vec ds)) (sss : List (List (Vec ds)))
  â†’ ((u : Vec ds) â†’ MemSomeM u sss
       â†’ Î£[ z âˆˆ Vec ds ] (Mem z ys Ã— MixedStrict ds u z))
  â†’ AllBeatenM ys sss
beatsFromTheUnionM ys []         h = tt
beatsFromTheUnionM ys (zs âˆ· sss) h =
    (Î» u mu â†’ h u (inl mu))
  , beatsFromTheUnionM ys sss (Î» u k â†’ h u (inr k))

theMixedStrataAreOrdered :
  (n : â„•) (ds : List Bool) (cs : Caps ds) (vs : List (Vec ds))
  â†’ AllBounded ds cs vs â†’ OrderedM (mixedStrata n ds vs)
theMixedStrataAreOrdered zero    ds cs vs       _  = tt
theMixedStrataAreOrdered (suc n) ds cs []       _  = tt
theMixedStrataAreOrdered (suc n) ds cs (v âˆ· vs) ab =
    beatsFromTheUnionM (mixedStratum ds (v âˆ· vs))
      (mixedStrata n ds (mixedRemainder ds (v âˆ· vs)))
      (Î» u k â†’
        mixedRemainderIsBeaten ds cs (v âˆ· vs) ab u
          (mixedStrataSound n ds (mixedRemainder ds (v âˆ· vs)) u k))
  , theMixedStrataAreOrdered n ds cs (mixedRemainder ds (v âˆ· vs))
      (allBoundedFilterOut ds cs (MixedMaximal ds (v âˆ· vs))
        (decMixedMaximal ds (v âˆ· vs)) (v âˆ· vs) ab)
