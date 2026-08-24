-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.RnaDhana_TheMixedLayerCoversAndBeatsTheMixedRemainder
--
-- ऋणधन · ṛṇa-dhana — Brahmagupta, *Brāhmasphuṭasiddhānta* (628): one
-- magnitude read as *dhana* (asset) or *ṛṇa* (debt), which is what a
-- benefit coordinate and a cost coordinate are.  The sign rules are
-- his; nothing else here is.
--
-- ────────────────────────────────────────────────────────────────────
-- `RnaDhana_TheWholeMixedStratificationIsTheFlippedOne` proved the two
-- stratifications equal and left the output properties unstated: "the
-- transported statements are NOT written out as separate theorems".
-- Written out here, at one step — and the three do NOT cost the same,
-- which is why this is a module and not three `subst`s.
--
-- WHAT IS PROVED
--
--   mixedLayerCovers      every archive member is in the mixed layer
--                         or the mixed remainder
--   mixedLayerIsDisjoint  and never in both
--   allBoundedFilterDec   the layer is still bounded (the remainder
--                         half was proved last cycle)
--   mixedRemainderIsBeaten
--                         every member of the mixed remainder is
--                         strictly beaten IN THE MIXED ORDER by a
--                         member of the mixed layer
--
-- **COVERAGE AND DISJOINTNESS COST NOTHING AND NEVER MENTION THE
-- FLIP.**  `mixedStratum` and `mixedRemainder` are `filterDec` and
-- `filterOut` of the SAME decidable predicate, and `memberSplits` /
-- `noMemberInBoth` were proved for an arbitrary such predicate several
-- cycles ago.  They are instantiations, not transports: no caps, no
-- `AllBounded`, no flip, two lines each.  That is what proving the
-- generic lemma first buys.
--
-- **ORDER IS THE ONE THAT NEEDS THE TRANSPORT, AND THE CAPS.**  Push
-- the member through the flip (`memberMaps`), rewrite along the
-- remainder equation, call
-- `everyRemainderMemberIsBeatenByAStratumMember` on the flipped
-- archive, rewrite the layer equation backwards, and pull the dominator
-- back with `anyMapBack` — which recovers a MIXED vector whose flip is
-- the one found, the flip having no inverse on elements.  The caps
-- enter exactly once, in `flipCapsReflect`, on that recovered vector.
--
-- NO NOVELTY.  Standard output properties of non-dominated sorting
-- (Goldberg 1989; Deb et al. 2002), here for mixed benefit/cost
-- vectors.
--
-- WHAT IS NOT CLAIMED.  ONE step.  The iterated versions over
-- `mixedStrata` are not written out; they follow the same way with
-- `strataSound` in place of direct membership.  Nothing constructs
-- caps.  `Mem` is a truncation-free `Any`, so duplicates count twice,
-- and the dominator is not canonical.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.RnaDhana_TheMixedLayerCoversAndBeatsTheMixedRemainder where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List ; [] ; _∷_ ; map)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import NaturalMachine.EveryRemainderMemberIsStrictlyDominated using (anyToMember)
open import NaturalMachine.OneStepCoverageAndDisjointnessOfTheLayer
  using (Mem ; memberSplits ; noMemberInBoth)
open import NaturalMachine.TheParetoStratumIsDecidableAndTheFilterIsExact
  using (filterDec ; StrictlyDominates)
open import NaturalMachine.TheStratificationCoversAndItsStrataArePairwiseDisjoint
  using (filterDecSubset)
open import NaturalMachine.EveryRemainderMemberIsBeatenByAStratumMember
  using (everyRemainderMemberIsBeatenByAStratumMember)
open import NaturalMachine.FlippingACostCoordinateIsSoundButNotFaithful using (Vec ; Dom)
open import NaturalMachine.RnaDhana_PerCoordinateCapsAreTheHonestVersionAndOneCapIsTheSpecialCase
  using (Caps ; BoundedC ; flipWithCaps ; flipCapsIsSound ; flipCapsReflect)
open import NaturalMachine.RnaDhana_TheParetoMaximumTransfersToCostCoordinates
  using (MixedStrict ; MixedMaximal ; AllBounded ; boundedAtMember
        ; anyMapBack ; memberMaps)
open import NaturalMachine.RnaDhana_TheMixedStratumIsExactlyTheFlippedStratum
  using (decMixedMaximal ; mixedStratum ; theMixedStratumIsTheFlippedStratum)
open import NaturalMachine.RnaDhana_TheWholeMixedStratificationIsTheFlippedOne
  using (mixedRemainder ; theMixedRemainderIsTheFlippedRemainder)

------------------------------------------------------------------------
-- 1.  Coverage and disjointness: instantiations, no flip involved
------------------------------------------------------------------------

mixedLayerCovers :
  (ds : List Bool) (vs : List (Vec ds)) (u : Vec ds)
  → Mem u vs → Mem u (mixedStratum ds vs) ⊎ Mem u (mixedRemainder ds vs)
mixedLayerCovers ds vs =
  memberSplits (MixedMaximal ds vs) (decMixedMaximal ds vs) vs

mixedLayerIsDisjoint :
  (ds : List Bool) (vs : List (Vec ds)) (u : Vec ds)
  → Mem u (mixedStratum ds vs) → Mem u (mixedRemainder ds vs) → ⊥
mixedLayerIsDisjoint ds vs =
  noMemberInBoth (MixedMaximal ds vs) (decMixedMaximal ds vs) vs

------------------------------------------------------------------------
-- 2.  The layer is bounded too
------------------------------------------------------------------------

allBoundedFilterDec :
  (ds : List Bool) (cs : Caps ds)
  (P : Vec ds → Type) (d : (u : Vec ds) → Dec (P u))
  (vs : List (Vec ds))
  → AllBounded ds cs vs → AllBounded ds cs (filterDec P d vs)
allBoundedFilterDec ds cs P d []       _        = tt
allBoundedFilterDec ds cs P d (v ∷ vs) (b , bs) with d v
... | yes _ = b , allBoundedFilterDec ds cs P d vs bs
... | no  _ = allBoundedFilterDec ds cs P d vs bs

------------------------------------------------------------------------
-- 3.  Order: the one that needs the transport, and the caps
------------------------------------------------------------------------

mixedRemainderIsBeaten :
  (ds : List Bool) (cs : Caps ds) (vs : List (Vec ds))
  → AllBounded ds cs vs
  → (u : Vec ds) → Mem u (mixedRemainder ds vs)
  → Σ[ z ∈ Vec ds ] (Mem z (mixedStratum ds vs) × MixedStrict ds u z)
mixedRemainderIsBeaten ds cs vs ab u memU
  with everyRemainderMemberIsBeatenByAStratumMember
         (map (flipWithCaps ds cs) vs) (flipWithCaps ds cs u)
         (subst (Mem (flipWithCaps ds cs u))
                (theMixedRemainderIsTheFlippedRemainder ds cs vs ab)
                (memberMaps (flipWithCaps ds cs) (mixedRemainder ds vs) u memU))
... | (w , memW , sd)
      with anyToMember (λ z → flipWithCaps ds cs z ≡ w) (mixedStratum ds vs)
             (anyMapBack (flipWithCaps ds cs) (λ y → y ≡ w) (mixedStratum ds vs)
               (subst (Mem w)
                      (sym (theMixedStratumIsTheFlippedStratum ds cs vs ab))
                      memW))
...     | (z , memZ , eqz) =
          z , memZ
        , flipCapsReflect ds cs u z
            (boundedAtMember ds cs vs z ab
              (filterDecSubset (MixedMaximal ds vs) (decMixedMaximal ds vs) vs z memZ))
            (fst (subst (StrictlyDominates (flipWithCaps ds cs u)) (sym eqz) sd))
        , (λ dzu → snd (subst (StrictlyDominates (flipWithCaps ds cs u)) (sym eqz) sd)
                     (flipCapsIsSound ds cs z u dzu))
