{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RnaDhana_TheWholeMixedStratificationIsTheFlippedOne
--
-- à‹àà§à¨ Â a-dhana â” Brahmagupta, *Brhmasphuasiddhnta* (628): one
-- magnitude read as *dhana* (asset) or *a* (debt).  The sign rules
-- are his; the caps, the filters and the induction below are not.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- `RnaDhana_TheMixedStratumIsExactlyTheFlippedStratum` transferred ONE
-- layer and named the rest:
--
--   "the REMAINDER half (same argument, negated predicate), then the
--    iteration, in which the caps must still bound the shrinking
--    archive at every step."
--
-- Both are done here, and the shrinking-archive worry was unfounded:
-- `allBoundedFilterOut` is four lines, because a filtered list is a
-- sublist and `AllBounded` is pointwise.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   mixedRemainder      the mixed complement of the mixed layer
--   filterOutMapCommutes / filterOutRespectsOn
--                       the two list lemmas again, negated branch
--   allBoundedFilterOut a filtered archive is still bounded â” for an
--                       ARBITRARY decidable predicate, so it covers
--                       the layer as well as the remainder
--   theMixedRemainderIsTheFlippedRemainder
--                       `map flip (mixedRemainder ds vs) â‰¡
--                        remainder (map flip vs)`
--   mixedStrata         the mixed stratification, same fuel recursion
--                       as `strata`
--   theMixedStrataAreTheFlippedStrata
--                       `map (map flip) (mixedStrata n ds vs) â‰¡
--                        strata n (map flip vs)`, for every fuel
--
-- **SO THE WHOLE Â§5.2 OUTPUT-PROPERTY BLOCK IS AVAILABLE IN THE COST
-- READING.**  Coverage, disjointness and order were proved for
-- `strata`; the equation above says the mixed stratification IS that
-- stratification, flipped, so each of those statements transports by
-- rewriting along one path â” no re-proof, and no new hypothesis beyond
-- `AllBounded` on the initial archive.  The obligation every module on
-- the Pareto line has carried in its header since the line began is
-- discharged.
--
-- **WHAT THE INDUCTION ACTUALLY NEEDED**, since I predicted otherwise:
-- not injectivity, not a rank, not a measure â” only that the caps
-- survive peeling, and they do trivially.  The recursion then goes
-- through because `map flip (v âˆ vs)` reduces to `flip v âˆ map flip vs`
-- definitionally, so the flipped archive is already in the cons form
-- `strata` matches on.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY.  Everything here is filter/map bookkeeping over
-- Goldberg/Deb non-dominated sorting.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module RnaDhana_TheWholeMixedStratificationIsTheFlippedOne where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List ; [] ; _âˆ·_ ; map)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)

open import OneStepCoverageAndDisjointnessOfTheLayer using (Mem)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (IsParetoMaximal ; decIsParetoMaximal ; stratum)
open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (filterOut ; remainder)
open import TheStratificationTerminatesOnItsOwnLength using (strata)
open import FlippingACostCoordinateIsSoundButNotFaithful using (Vec)
open import RnaDhana_PerCoordinateCapsAreTheHonestVersionAndOneCapIsTheSpecialCase
  using (Caps ; BoundedC ; flipWithCaps)
open import RnaDhana_TheParetoMaximumTransfersToCostCoordinates
  using (MixedMaximal ; AllBounded ; boundedAtMember)
open import RnaDhana_TheMixedStratumIsExactlyTheFlippedStratum
  using (decMixedMaximal ; mixedStratum ; mixedMaximalIff
        ; theMixedStratumIsTheFlippedStratum)

private
  variable
    A : Type

------------------------------------------------------------------------
-- 1.  The negated branch of the two list lemmas
------------------------------------------------------------------------

filterOutMapCommutes :
  {B : Type} (f : A â†’ B) (Q : B â†’ Type) (dq : (b : B) â†’ Dec (Q b))
  (xs : List A)
  â†’ filterOut Q dq (map f xs)
    â‰¡ map f (filterOut (Î» a â†’ Q (f a)) (Î» a â†’ dq (f a)) xs)
filterOutMapCommutes f Q dq []       = refl
filterOutMapCommutes f Q dq (x âˆ· xs) with dq (f x)
... | yes _ = filterOutMapCommutes f Q dq xs
... | no  _ = cong (f x âˆ·_) (filterOutMapCommutes f Q dq xs)

filterOutRespectsOn :
  (P Q : A â†’ Type) (dp : (a : A) â†’ Dec (P a)) (dq : (a : A) â†’ Dec (Q a))
  (xs : List A)
  â†’ ((a : A) â†’ Mem a xs â†’ (P a â†’ Q a) Ã— (Q a â†’ P a))
  â†’ filterOut P dp xs â‰¡ filterOut Q dq xs
filterOutRespectsOn P Q dp dq []       iff = refl
filterOutRespectsOn P Q dp dq (x âˆ· xs) iff with dp x | dq x
... | yes _ | yes _ =
  filterOutRespectsOn P Q dp dq xs (Î» a m â†’ iff a (inr m))
... | yes p | no Â¬q = âŠ¥.rec (Â¬q (fst (iff x (inl refl)) p))
... | no Â¬p | yes q = âŠ¥.rec (Â¬p (snd (iff x (inl refl)) q))
... | no  _ | no  _ =
  cong (x âˆ·_) (filterOutRespectsOn P Q dp dq xs (Î» a m â†’ iff a (inr m)))

------------------------------------------------------------------------
-- 2.  Caps survive peeling
------------------------------------------------------------------------

allBoundedFilterOut :
  (ds : List Bool) (cs : Caps ds)
  (P : Vec ds â†’ Type) (d : (u : Vec ds) â†’ Dec (P u))
  (vs : List (Vec ds))
  â†’ AllBounded ds cs vs â†’ AllBounded ds cs (filterOut P d vs)
allBoundedFilterOut ds cs P d []       _        = tt
allBoundedFilterOut ds cs P d (v âˆ· vs) (b , bs) with d v
... | yes _ = allBoundedFilterOut ds cs P d vs bs
... | no  _ = b , allBoundedFilterOut ds cs P d vs bs

------------------------------------------------------------------------
-- 3.  The remainder transfers
------------------------------------------------------------------------

mixedRemainder : (ds : List Bool) â†’ List (Vec ds) â†’ List (Vec ds)
mixedRemainder ds vs =
  filterOut (MixedMaximal ds vs) (decMixedMaximal ds vs) vs

theMixedRemainderIsTheFlippedRemainder :
  (ds : List Bool) (cs : Caps ds) (vs : List (Vec ds))
  â†’ AllBounded ds cs vs
  â†’ map (flipWithCaps ds cs) (mixedRemainder ds vs)
    â‰¡ remainder (map (flipWithCaps ds cs) vs)
theMixedRemainderIsTheFlippedRemainder ds cs vs ab =
    cong (map (flipWithCaps ds cs))
      (filterOutRespectsOn (MixedMaximal ds vs)
        (Î» u â†’ IsParetoMaximal (flipWithCaps ds cs u)
                               (map (flipWithCaps ds cs) vs))
        (decMixedMaximal ds vs)
        (Î» u â†’ decIsParetoMaximal (flipWithCaps ds cs u)
                                  (map (flipWithCaps ds cs) vs))
        vs
        (Î» a m â†’ mixedMaximalIff ds cs vs ab a (boundedAtMember ds cs vs a ab m)))
  âˆ™ sym (filterOutMapCommutes (flipWithCaps ds cs)
          (Î» y â†’ IsParetoMaximal y (map (flipWithCaps ds cs) vs))
          (Î» y â†’ decIsParetoMaximal y (map (flipWithCaps ds cs) vs))
          vs)

------------------------------------------------------------------------
-- 4.  â¦and so does the whole stratification
------------------------------------------------------------------------

mixedStrata : â„• â†’ (ds : List Bool) â†’ List (Vec ds) â†’ List (List (Vec ds))
mixedStrata zero    ds vs       = []
mixedStrata (suc n) ds []       = []
mixedStrata (suc n) ds (v âˆ· vs) =
  mixedStratum ds (v âˆ· vs) âˆ· mixedStrata n ds (mixedRemainder ds (v âˆ· vs))

theMixedStrataAreTheFlippedStrata :
  (n : â„•) (ds : List Bool) (cs : Caps ds) (vs : List (Vec ds))
  â†’ AllBounded ds cs vs
  â†’ map (map (flipWithCaps ds cs)) (mixedStrata n ds vs)
    â‰¡ strata n (map (flipWithCaps ds cs) vs)
theMixedStrataAreTheFlippedStrata zero    ds cs vs       _  = refl
theMixedStrataAreTheFlippedStrata (suc n) ds cs []       _  = refl
theMixedStrataAreTheFlippedStrata (suc n) ds cs (v âˆ· vs) ab =
  congâ‚‚ _âˆ·_
    (theMixedStratumIsTheFlippedStratum ds cs (v âˆ· vs) ab)
    ( theMixedStrataAreTheFlippedStrata n ds cs (mixedRemainder ds (v âˆ· vs))
        (allBoundedFilterOut ds cs (MixedMaximal ds (v âˆ· vs))
          (decMixedMaximal ds (v âˆ· vs)) (v âˆ· vs) ab)
    âˆ™ cong (strata n)
        (theMixedRemainderIsTheFlippedRemainder ds cs (v âˆ· vs) ab) )
