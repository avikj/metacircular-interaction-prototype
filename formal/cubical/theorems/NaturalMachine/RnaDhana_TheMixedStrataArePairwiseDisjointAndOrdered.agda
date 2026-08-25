{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.RnaDhana_TheMixedStrataArePairwiseDisjointAndOrdered
--
-- ऋणधन · ṛṇa-dhana — Brahmagupta, *Brāhmasphuṭasiddhānta* (628): one
-- magnitude read as *dhana* (asset) or *ṛṇa* (debt).  The sign rules
-- are his; nothing else here is.
--
-- ────────────────────────────────────────────────────────────────────
-- The one-step mixed output properties were proved last cycle.  Here
-- they are iterated over the whole mixed stratification — two of the
-- three.
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
--                           member of an earlier one — for every fuel,
--                           given caps bounding the archive
--
-- **DISJOINTNESS NEEDS NO CAPS AND NO FLIP AT ALL**, exactly as at one
-- step: `mixedStratum` and `mixedRemainder` are the two halves of one
-- decidable filter, and `mixedStrataSound` puts every later stratum
-- inside the remainder.  ORDER needs both, and only through
-- `mixedRemainderIsBeaten`, whose cap requirement survives peeling by
-- `allBoundedFilterOut`.  The asymmetry first seen in the unflipped
-- stratification — coverage needs the measure, disjointness does not —
-- reappears here in a sharper form: **disjointness and order differ not
-- only in what they need but in WHOSE machinery they need. One is
-- generic list surgery; the other is the whole ṛṇa-dhana transport.**
--
-- COVERAGE IS DELIBERATELY ABSENT.  It needs the mixed measure —
-- non-empty archive ⇒ non-empty mixed stratum ⇒ strictly shorter mixed
-- remainder ⇒ fuel suffices — and the first link is
-- `mixedMaximalExists`, which is available, while the length argument
-- is not yet transported.  That is the next cycle on this line and it
-- is named rather than guessed at.
--
-- NO NOVELTY.  Standard properties of iterated non-dominated sorting
-- (Goldberg 1989; Deb et al. 2002).
--
-- WHAT IS NOT CLAIMED.  No coverage, as above.  Nothing constructs
-- caps.  `Mem` is a truncation-free `Any`; duplicates count twice; the
-- dominator is not canonical.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.RnaDhana_TheMixedStrataArePairwiseDisjointAndOrdered where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as ⊥ using (⊥)

open import NaturalMachine.KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any)
open import NaturalMachine.OneStepCoverageAndDisjointnessOfTheLayer using (Mem)
open import NaturalMachine.TheStratificationCoversAndItsStrataArePairwiseDisjoint
  using (filterDecSubset ; filterOutSubset)
open import NaturalMachine.TheParetoStratumIsDecidableAndTheFilterIsExact using (filterDec)
open import NaturalMachine.FlippingACostCoordinateIsSoundButNotFaithful using (Vec)
open import NaturalMachine.RnaDhana_PerCoordinateCapsAreTheHonestVersionAndOneCapIsTheSpecialCase
  using (Caps)
open import NaturalMachine.RnaDhana_TheParetoMaximumTransfersToCostCoordinates
  using (MixedStrict ; MixedMaximal ; AllBounded)
open import NaturalMachine.RnaDhana_TheMixedStratumIsExactlyTheFlippedStratum
  using (decMixedMaximal ; mixedStratum)
open import NaturalMachine.RnaDhana_TheWholeMixedStratificationIsTheFlippedOne
  using (mixedRemainder ; mixedStrata ; allBoundedFilterOut)
open import NaturalMachine.RnaDhana_TheMixedLayerCoversAndBeatsTheMixedRemainder
  using (mixedLayerIsDisjoint ; mixedRemainderIsBeaten)

------------------------------------------------------------------------
-- 1.  The mixed stratification invents nothing
------------------------------------------------------------------------

MemSomeM : {ds : List Bool} → Vec ds → List (List (Vec ds)) → Type
MemSomeM u sss = Any (λ ys → Mem u ys) sss

mixedStrataSound :
  (n : ℕ) (ds : List Bool) (vs : List (Vec ds)) (u : Vec ds)
  → MemSomeM u (mixedStrata n ds vs) → Mem u vs
mixedStrataSound zero    ds vs       u e = ⊥.rec e
mixedStrataSound (suc n) ds []       u e = ⊥.rec e
mixedStrataSound (suc n) ds (v ∷ vs) u (inl h) =
  filterDecSubset (MixedMaximal ds (v ∷ vs)) (decMixedMaximal ds (v ∷ vs))
    (v ∷ vs) u h
mixedStrataSound (suc n) ds (v ∷ vs) u (inr k) =
  filterOutSubset (MixedMaximal ds (v ∷ vs)) (decMixedMaximal ds (v ∷ vs))
    (v ∷ vs) u
    (mixedStrataSound n ds (mixedRemainder ds (v ∷ vs)) u k)

------------------------------------------------------------------------
-- 2.  Pairwise disjointness — generic list surgery, no caps
------------------------------------------------------------------------

DisjointM : {ds : List Bool} → List (Vec ds) → List (Vec ds) → Type
DisjointM {ds} ys zs = (u : Vec ds) → Mem u ys → Mem u zs → ⊥

AllDisjointFromM :
  {ds : List Bool} → List (Vec ds) → List (List (Vec ds)) → Type
AllDisjointFromM ys []         = Unit
AllDisjointFromM ys (zs ∷ sss) = DisjointM ys zs × AllDisjointFromM ys sss

PairwiseM : {ds : List Bool} → List (List (Vec ds)) → Type
PairwiseM []         = Unit
PairwiseM (ys ∷ sss) = AllDisjointFromM ys sss × PairwiseM sss

disjointFromTheUnionM :
  {ds : List Bool} (ys : List (Vec ds)) (sss : List (List (Vec ds)))
  → ((u : Vec ds) → Mem u ys → MemSomeM u sss → ⊥)
  → AllDisjointFromM ys sss
disjointFromTheUnionM ys []         h = tt
disjointFromTheUnionM ys (zs ∷ sss) h =
    (λ u mu mz → h u mu (inl mz))
  , disjointFromTheUnionM ys sss (λ u mu k → h u mu (inr k))

theMixedStrataArePairwiseDisjoint :
  (n : ℕ) (ds : List Bool) (vs : List (Vec ds))
  → PairwiseM (mixedStrata n ds vs)
theMixedStrataArePairwiseDisjoint zero    ds vs       = tt
theMixedStrataArePairwiseDisjoint (suc n) ds []       = tt
theMixedStrataArePairwiseDisjoint (suc n) ds (v ∷ vs) =
    disjointFromTheUnionM (mixedStratum ds (v ∷ vs))
      (mixedStrata n ds (mixedRemainder ds (v ∷ vs)))
      (λ u mu k →
        mixedLayerIsDisjoint ds (v ∷ vs) u mu
          (mixedStrataSound n ds (mixedRemainder ds (v ∷ vs)) u k))
  , theMixedStrataArePairwiseDisjoint n ds (mixedRemainder ds (v ∷ vs))

------------------------------------------------------------------------
-- 3.  Order — the caps enter, through the one-step theorem
------------------------------------------------------------------------

BeatsM : {ds : List Bool} → List (Vec ds) → List (Vec ds) → Type
BeatsM {ds} ys zs =
  (u : Vec ds) → Mem u zs
  → Σ[ z ∈ Vec ds ] (Mem z ys × MixedStrict ds u z)

AllBeatenM : {ds : List Bool} → List (Vec ds) → List (List (Vec ds)) → Type
AllBeatenM ys []         = Unit
AllBeatenM ys (zs ∷ sss) = BeatsM ys zs × AllBeatenM ys sss

OrderedM : {ds : List Bool} → List (List (Vec ds)) → Type
OrderedM []         = Unit
OrderedM (ys ∷ sss) = AllBeatenM ys sss × OrderedM sss

beatsFromTheUnionM :
  {ds : List Bool} (ys : List (Vec ds)) (sss : List (List (Vec ds)))
  → ((u : Vec ds) → MemSomeM u sss
       → Σ[ z ∈ Vec ds ] (Mem z ys × MixedStrict ds u z))
  → AllBeatenM ys sss
beatsFromTheUnionM ys []         h = tt
beatsFromTheUnionM ys (zs ∷ sss) h =
    (λ u mu → h u (inl mu))
  , beatsFromTheUnionM ys sss (λ u k → h u (inr k))

theMixedStrataAreOrdered :
  (n : ℕ) (ds : List Bool) (cs : Caps ds) (vs : List (Vec ds))
  → AllBounded ds cs vs → OrderedM (mixedStrata n ds vs)
theMixedStrataAreOrdered zero    ds cs vs       _  = tt
theMixedStrataAreOrdered (suc n) ds cs []       _  = tt
theMixedStrataAreOrdered (suc n) ds cs (v ∷ vs) ab =
    beatsFromTheUnionM (mixedStratum ds (v ∷ vs))
      (mixedStrata n ds (mixedRemainder ds (v ∷ vs)))
      (λ u k →
        mixedRemainderIsBeaten ds cs (v ∷ vs) ab u
          (mixedStrataSound n ds (mixedRemainder ds (v ∷ vs)) u k))
  , theMixedStrataAreOrdered n ds cs (mixedRemainder ds (v ∷ vs))
      (allBoundedFilterOut ds cs (MixedMaximal ds (v ∷ vs))
        (decMixedMaximal ds (v ∷ vs)) (v ∷ vs) ab)
