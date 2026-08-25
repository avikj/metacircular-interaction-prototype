{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RnaDhana_TheMixedStratificationTerminatesAndCovers
--
-- ऋणधन · ṛṇa-dhana — Brahmagupta, *Brāhmasphuṭasiddhānta* (628): one
-- magnitude read as *dhana* (asset) or *ṛṇa* (debt).  The sign rules
-- are his; nothing else here is.
--
-- ────────────────────────────────────────────────────────────────────
-- A CORRECTION FIRST, AND IT IS ABOUT MY OWN INSTRUMENT, NOT A THEOREM.
--
-- Last cycle I recorded that mixed coverage was blocked because "the
-- LENGTH argument is not transported — `nonEmptyFilterShortensThe-
-- Complement` is stated for `List (List ℕ)` and the mixed side needs it
-- for `List (Vec ds)`".  **I had not looked.**  That lemma, and
-- `partitionLength`, and `lengthL` itself, are all stated over a
-- `variable A : Type` — generic in the element type since the cycle
-- they were written.  Nothing needed transporting; they apply to
-- `List (Vec ds)` unchanged.
--
-- That is the ninth wrong estimate on this branch and the second whose
-- subject was my OWN earlier work rather than a piece of mathematics.
-- The rule already written — "do not write an estimate into a record;
-- try the proof" — extends: **do not record an obstruction in your own
-- corpus without grepping the signature.**
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   mixedStratumIsNonEmpty     a non-empty bounded archive has a
--                              non-empty mixed layer — the one place
--                              the caps and the flip enter
--   theMixedRemainderIsStrictlyShorter
--                              hence the mixed remainder is shorter
--   mixedLeftover / mixedFuelSuffices / theMixedStratificationTerminates
--                              the peeling stops, at fuel `lengthL vs`
--   mixedCoverageStep          every archive member is in some mixed
--                              stratum or in the leftover — for every
--                              fuel, and WITHOUT the caps
--   theMixedStratificationCovers
--                              so at full fuel, in some mixed stratum
--
-- **THE ASYMMETRY, ONE LEVEL DEEPER THAN LAST CYCLE'S.**  Coverage's
-- INDUCTION needs nothing: it is `mixedLayerCovers` threaded through
-- the recursion, and `mixedLayerCovers` is a generic filter fact.  What
-- needs the caps — and with them the whole ṛṇa-dhana transport — is
-- killing the leftover, because that runs on the MEASURE, and the
-- measure runs on non-emptiness of the layer, and non-emptiness is
-- `mixedMaximalExists`, which is where the flip lives.  So the caps are
-- required not by coverage but by TERMINATION.
--
-- With `theMixedStrataArePairwiseDisjoint` and
-- `theMixedStrataAreOrdered`, DARWIN §5.2's three output properties now
-- hold for genuinely mixed benefit/cost archives, with the single
-- hypothesis that the caps bound the archive's members.
--
-- NO NOVELTY.  Iterated non-dominated sorting terminates and partitions
-- (Goldberg 1989; Deb et al. 2002).
--
-- WHAT IS NOT CLAIMED.  Nothing constructs caps.  `Mem` is a
-- truncation-free `Any`; duplicates count twice.  No rank function:
-- `OrderedM` still says "some earlier stratum".  And the whole §5.2
-- block remains conditional on the DARWIN note describing its code
-- correctly — I have never read that code.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module RnaDhana_TheMixedStratificationTerminatesAndCovers where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ≤-refl ; ≤-trans ; pred-≤-pred ; ¬-<-zero)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Data.Empty as ⊥ using (⊥)

open import OneStepCoverageAndDisjointnessOfTheLayer using (Mem)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (filterDecKeepsEverySatisfier)
open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (lengthL ; nonEmptyFilterShortensTheComplement)
open import FlippingACostCoordinateIsSoundButNotFaithful using (Vec)
open import RnaDhana_PerCoordinateCapsAreTheHonestVersionAndOneCapIsTheSpecialCase
  using (Caps)
open import RnaDhana_TheParetoMaximumTransfersToCostCoordinates
  using (MixedMaximal ; AllBounded ; mixedMaximalExists)
open import RnaDhana_TheMixedStratumIsExactlyTheFlippedStratum
  using (decMixedMaximal ; mixedStratum)
open import RnaDhana_TheWholeMixedStratificationIsTheFlippedOne
  using (mixedRemainder ; mixedStrata ; allBoundedFilterOut)
open import RnaDhana_TheMixedLayerCoversAndBeatsTheMixedRemainder
  using (mixedLayerCovers)
open import RnaDhana_TheMixedStrataArePairwiseDisjointAndOrdered
  using (MemSomeM)

------------------------------------------------------------------------
-- 1.  The layer is non-empty — the caps and the flip enter here only
------------------------------------------------------------------------

mixedStratumIsNonEmpty :
  (ds : List Bool) (cs : Caps ds) (v : Vec ds) (vs : List (Vec ds))
  → AllBounded ds cs (v ∷ vs)
  → Σ[ m ∈ Vec ds ] Mem m (mixedStratum ds (v ∷ vs))
mixedStratumIsNonEmpty ds cs v vs ab with mixedMaximalExists ds cs v vs ab
... | (u , memU , maxU) =
  u , filterDecKeepsEverySatisfier (MixedMaximal ds (v ∷ vs))
        (decMixedMaximal ds (v ∷ vs)) (v ∷ vs) u memU maxU

theMixedRemainderIsStrictlyShorter :
  (ds : List Bool) (cs : Caps ds) (v : Vec ds) (vs : List (Vec ds))
  → AllBounded ds cs (v ∷ vs)
  → lengthL (mixedRemainder ds (v ∷ vs)) < lengthL (v ∷ vs)
theMixedRemainderIsStrictlyShorter ds cs v vs ab
  with mixedStratumIsNonEmpty ds cs v vs ab
... | (m , memM) =
  nonEmptyFilterShortensTheComplement (MixedMaximal ds (v ∷ vs))
    (decMixedMaximal ds (v ∷ vs)) (v ∷ vs) m memM

------------------------------------------------------------------------
-- 2.  So the peeling stops
------------------------------------------------------------------------

mixedLeftover : ℕ → (ds : List Bool) → List (Vec ds) → List (Vec ds)
mixedLeftover zero    ds vs       = vs
mixedLeftover (suc n) ds []       = []
mixedLeftover (suc n) ds (v ∷ vs) =
  mixedLeftover n ds (mixedRemainder ds (v ∷ vs))

lengthZeroGivesNilM :
  (ds : List Bool) (vs : List (Vec ds)) → lengthL vs ≤ 0 → vs ≡ []
lengthZeroGivesNilM ds []       _ = refl
lengthZeroGivesNilM ds (v ∷ vs) h = ⊥.rec (¬-<-zero h)

mixedFuelSuffices :
  (n : ℕ) (ds : List Bool) (cs : Caps ds) (vs : List (Vec ds))
  → AllBounded ds cs vs → lengthL vs ≤ n → mixedLeftover n ds vs ≡ []
mixedFuelSuffices zero    ds cs vs       _  h = lengthZeroGivesNilM ds vs h
mixedFuelSuffices (suc n) ds cs []       _  _ = refl
mixedFuelSuffices (suc n) ds cs (v ∷ vs) ab h =
  mixedFuelSuffices n ds cs (mixedRemainder ds (v ∷ vs))
    (allBoundedFilterOut ds cs (MixedMaximal ds (v ∷ vs))
      (decMixedMaximal ds (v ∷ vs)) (v ∷ vs) ab)
    (pred-≤-pred (≤-trans (theMixedRemainderIsStrictlyShorter ds cs v vs ab) h))

theMixedStratificationTerminates :
  (ds : List Bool) (cs : Caps ds) (vs : List (Vec ds))
  → AllBounded ds cs vs → mixedLeftover (lengthL vs) ds vs ≡ []
theMixedStratificationTerminates ds cs vs ab =
  mixedFuelSuffices (lengthL vs) ds cs vs ab ≤-refl

------------------------------------------------------------------------
-- 3.  Coverage — the induction needs no caps at all
------------------------------------------------------------------------

mixedCoverageStep :
  (n : ℕ) (ds : List Bool) (vs : List (Vec ds)) (u : Vec ds)
  → Mem u vs → MemSomeM u (mixedStrata n ds vs) ⊎ Mem u (mixedLeftover n ds vs)
mixedCoverageStep zero    ds vs       u m = inr m
mixedCoverageStep (suc n) ds []       u e = ⊥.rec e
mixedCoverageStep (suc n) ds (v ∷ vs) u m with mixedLayerCovers ds (v ∷ vs) u m
... | inl h = inl (inl h)
... | inr r with mixedCoverageStep n ds (mixedRemainder ds (v ∷ vs)) u r
...   | inl k = inl (inr k)
...   | inr l = inr l

theMixedStratificationCovers :
  (ds : List Bool) (cs : Caps ds) (vs : List (Vec ds))
  → AllBounded ds cs vs
  → (u : Vec ds) → Mem u vs → MemSomeM u (mixedStrata (lengthL vs) ds vs)
theMixedStratificationCovers ds cs vs ab u m
  with mixedCoverageStep (lengthL vs) ds vs u m
... | inl k = k
... | inr l =
  ⊥.rec (subst (Mem u) (theMixedStratificationTerminates ds cs vs ab) l)
