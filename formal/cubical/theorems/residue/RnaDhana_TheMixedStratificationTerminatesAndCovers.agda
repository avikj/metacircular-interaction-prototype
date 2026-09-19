{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RnaDhana_TheMixedStratificationTerminatesAndCovers
--
-- à‹àà§à¨ Â a-dhana â” Brahmagupta, *Brhmasphuasiddhnta* (628): one
-- magnitude read as *dhana* (asset) or *a* (debt).  The sign rules
-- are his; nothing else here is.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- A CORRECTION FIRST, AND IT IS ABOUT MY OWN INSTRUMENT, NOT A THEOREM.
--
-- Last cycle I recorded that mixed coverage was blocked because "the
-- LENGTH argument is not transported â” `nonEmptyFilterShortensThe-
-- Complement` is stated for `List (List â•)` and the mixed side needs it
-- for `List (Vec ds)`".  **I had not looked.**  That lemma, and
-- `partitionLength`, and `lengthL` itself, are all stated over a
-- `variable A : Type` â” generic in the element type since the cycle
-- they were written.  Nothing needed transporting; they apply to
-- `List (Vec ds)` unchanged.
--
-- That is the ninth wrong estimate on this branch and the second whose
-- subject was my OWN earlier work rather than a piece of mathematics.
-- The rule already written â” "do not write an estimate into a record;
-- try the proof" â” extends: **do not record an obstruction in your own
-- corpus without grepping the signature.**
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   mixedStratumIsNonEmpty     a non-empty bounded archive has a
--                              non-empty mixed layer â” the one place
--                              the caps and the flip enter
--   theMixedRemainderIsStrictlyShorter
--                              hence the mixed remainder is shorter
--   mixedLeftover / mixedFuelSuffices / theMixedStratificationTerminates
--                              the peeling stops, at fuel `lengthL vs`
--   mixedCoverageStep          every archive member is in some mixed
--                              stratum or in the leftover â” for every
--                              fuel, and WITHOUT the caps
--   theMixedStratificationCovers
--                              so at full fuel, in some mixed stratum
--
-- **THE ASYMMETRY, ONE LEVEL DEEPER THAN LAST CYCLE'S.**  Coverage's
-- INDUCTION needs nothing: it is `mixedLayerCovers` threaded through
-- the recursion, and `mixedLayerCovers` is a generic filter fact.  What
-- needs the caps â” and with them the whole a-dhana transport â” is
-- killing the leftover, because that runs on the MEASURE, and the
-- measure runs on non-emptiness of the layer, and non-emptiness is
-- `mixedMaximalExists`, which is where the flip lives.  So the caps are
-- required not by coverage but by TERMINATION.
--
-- With `theMixedStrataArePairwiseDisjoint` and
-- `theMixedStrataAreOrdered`, DARWIN Â§5.2's three output properties now
-- hold for genuinely mixed benefit/cost archives, with the single
-- hypothesis that the caps bound the archive's members.
--
-- NO NOVELTY.  Iterated non-dominated sorting terminates and partitions
-- (Goldberg 1989; Deb et al. 2002).
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module RnaDhana_TheMixedStratificationTerminatesAndCovers where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.Nat.Order
  using (_â‰¤_ ; _<_ ; â‰¤-refl ; â‰¤-trans ; pred-â‰¤-pred ; Â¬-<-zero)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_ ; _,_)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)

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
-- 1.  The layer is non-empty â” the caps and the flip enter here only
------------------------------------------------------------------------

mixedStratumIsNonEmpty :
  (ds : List Bool) (cs : Caps ds) (v : Vec ds) (vs : List (Vec ds))
  â†’ AllBounded ds cs (v âˆ· vs)
  â†’ Î£[ m âˆˆ Vec ds ] Mem m (mixedStratum ds (v âˆ· vs))
mixedStratumIsNonEmpty ds cs v vs ab with mixedMaximalExists ds cs v vs ab
... | (u , memU , maxU) =
  u , filterDecKeepsEverySatisfier (MixedMaximal ds (v âˆ· vs))
        (decMixedMaximal ds (v âˆ· vs)) (v âˆ· vs) u memU maxU

theMixedRemainderIsStrictlyShorter :
  (ds : List Bool) (cs : Caps ds) (v : Vec ds) (vs : List (Vec ds))
  â†’ AllBounded ds cs (v âˆ· vs)
  â†’ lengthL (mixedRemainder ds (v âˆ· vs)) < lengthL (v âˆ· vs)
theMixedRemainderIsStrictlyShorter ds cs v vs ab
  with mixedStratumIsNonEmpty ds cs v vs ab
... | (m , memM) =
  nonEmptyFilterShortensTheComplement (MixedMaximal ds (v âˆ· vs))
    (decMixedMaximal ds (v âˆ· vs)) (v âˆ· vs) m memM

------------------------------------------------------------------------
-- 2.  So the peeling stops
------------------------------------------------------------------------

mixedLeftover : â„• â†’ (ds : List Bool) â†’ List (Vec ds) â†’ List (Vec ds)
mixedLeftover zero    ds vs       = vs
mixedLeftover (suc n) ds []       = []
mixedLeftover (suc n) ds (v âˆ· vs) =
  mixedLeftover n ds (mixedRemainder ds (v âˆ· vs))

lengthZeroGivesNilM :
  (ds : List Bool) (vs : List (Vec ds)) â†’ lengthL vs â‰¤ 0 â†’ vs â‰¡ []
lengthZeroGivesNilM ds []       _ = refl
lengthZeroGivesNilM ds (v âˆ· vs) h = âŠ¥.rec (Â¬-<-zero h)

mixedFuelSuffices :
  (n : â„•) (ds : List Bool) (cs : Caps ds) (vs : List (Vec ds))
  â†’ AllBounded ds cs vs â†’ lengthL vs â‰¤ n â†’ mixedLeftover n ds vs â‰¡ []
mixedFuelSuffices zero    ds cs vs       _  h = lengthZeroGivesNilM ds vs h
mixedFuelSuffices (suc n) ds cs []       _  _ = refl
mixedFuelSuffices (suc n) ds cs (v âˆ· vs) ab h =
  mixedFuelSuffices n ds cs (mixedRemainder ds (v âˆ· vs))
    (allBoundedFilterOut ds cs (MixedMaximal ds (v âˆ· vs))
      (decMixedMaximal ds (v âˆ· vs)) (v âˆ· vs) ab)
    (pred-â‰¤-pred (â‰¤-trans (theMixedRemainderIsStrictlyShorter ds cs v vs ab) h))

theMixedStratificationTerminates :
  (ds : List Bool) (cs : Caps ds) (vs : List (Vec ds))
  â†’ AllBounded ds cs vs â†’ mixedLeftover (lengthL vs) ds vs â‰¡ []
theMixedStratificationTerminates ds cs vs ab =
  mixedFuelSuffices (lengthL vs) ds cs vs ab â‰¤-refl

------------------------------------------------------------------------
-- 3.  Coverage â” the induction needs no caps at all
------------------------------------------------------------------------

mixedCoverageStep :
  (n : â„•) (ds : List Bool) (vs : List (Vec ds)) (u : Vec ds)
  â†’ Mem u vs â†’ MemSomeM u (mixedStrata n ds vs) âŠŽ Mem u (mixedLeftover n ds vs)
mixedCoverageStep zero    ds vs       u m = inr m
mixedCoverageStep (suc n) ds []       u e = âŠ¥.rec e
mixedCoverageStep (suc n) ds (v âˆ· vs) u m with mixedLayerCovers ds (v âˆ· vs) u m
... | inl h = inl (inl h)
... | inr r with mixedCoverageStep n ds (mixedRemainder ds (v âˆ· vs)) u r
...   | inl k = inl (inr k)
...   | inr l = inr l

theMixedStratificationCovers :
  (ds : List Bool) (cs : Caps ds) (vs : List (Vec ds))
  â†’ AllBounded ds cs vs
  â†’ (u : Vec ds) â†’ Mem u vs â†’ MemSomeM u (mixedStrata (lengthL vs) ds vs)
theMixedStratificationCovers ds cs vs ab u m
  with mixedCoverageStep (lengthL vs) ds vs u m
... | inl k = k
... | inr l =
  âŠ¥.rec (subst (Mem u) (theMixedStratificationTerminates ds cs vs ab) l)
