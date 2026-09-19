{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RnaDhana_TheMixedStratumIsExactlyTheFlippedStratum
--
-- à‹àà§à¨ Â a-dhana â” Brahmagupta, *Brhmasphuasiddhnta* (628): one
-- magnitude read as *dhana* (asset) or *a* (debt).  His are the sign
-- rules; the caps, the filters and the transfer below are not.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- `RnaDhana_TheParetoMaximumTransfersToCostCoordinates` transferred
-- maximal EXISTENCE and named what it could not:
--
--   "the stratification is NOT transferred here â” that needs the whole
--    peeling to be run on flipped vectors and pulled back layer by
--    layer, and it is a separate cycle."
--
-- The first layer is transferred here, and the result is stronger than
-- the membership correspondence I expected to have to settle for: the
-- two layers are the SAME LIST.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   decDom              mixed dominance is decidable
--   decMixedMaximal     hence so is mixed maximality against a finite
--                       archive
--   mixedStratum        the mixed layer, as a computed list of vectors
--   filterMapCommutes   filtering a mapped list is mapping a filtered
--                       one, for the pulled-back predicate
--   filterRespectsOn    two decidable predicates agreeing ON THE
--                       MEMBERS of a list filter it identically â” the
--                       restriction to members is what makes it usable
--                       here, since the bound only holds for members
--   mixedMaximalIff     under the caps, `MixedMaximal ds vs u` and
--                       `IsParetoMaximal (flip u) (map flip vs)` are
--                       interderivable, for any bounded u
--   theMixedStratumIsTheFlippedStratum
--                       `map flip (mixedStratum ds vs) â‰¡
--                        stratum (map flip vs)`
--
-- **WHY LIST EQUALITY AND NOT JUST MEMBERSHIP.**  The flip is not
-- injective, so nothing about individual elements would give the lists.
-- What gives them is that both sides are FILTERS OF THE SAME LIST in
-- the same order â” `filterMapCommutes` moves the map across the
-- filter, and `filterRespectsOn` then only needs the two predicates to
-- agree at members.  Order and multiplicity are preserved for free
-- because neither side reorders; a `Mem`-level statement would have
-- thrown that away.
--
-- **AND THE BOUND IS NEEDED EXACTLY ONCE PER DIRECTION.**  Going from
-- the flipped world back to the mixed one needs `flipCapsReflect`,
-- whose hypothesis is a cap on the vector claimed to dominate; in one
-- direction that is the archive member z (supplied by `AllBounded`),
-- in the other it is u itself (supplied by the caller).  Soundness
-- needs nothing.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY.  Filter/map commutation and "equal filters from
-- pointwise-equivalent predicates" are standard list lemmas; the
-- Pareto layer is Goldberg/Deb non-dominated sorting.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module RnaDhana_TheMixedStratumIsExactlyTheFlippedStratum where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„•)
open import Cubical.Data.Nat.Order using (_â‰¤_)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.List using (List ; [] ; _âˆ·_ ; map)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any ; decAny ; memberToAny)
open import EveryRemainderMemberIsStrictlyDominated using (anyToMember)
open import OneStepCoverageAndDisjointnessOfTheLayer using (Mem)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (decâ‰¤ ; decNeg ; filterDec ; StrictlyDominates ; IsParetoMaximal
        ; decIsParetoMaximal ; stratum)
open import FlippingACostCoordinateIsSoundButNotFaithful
  using (Vec ; Dom)
open import RnaDhana_PerCoordinateCapsAreTheHonestVersionAndOneCapIsTheSpecialCase
  using (Caps ; BoundedC ; flipWithCaps ; flipCapsIsSound ; flipCapsReflect)
open import RnaDhana_TheParetoMaximumTransfersToCostCoordinates
  using (MixedStrict ; MixedMaximal ; AllBounded ; boundedAtMember
        ; anyMapBack ; memberMaps)

private
  variable
    A : Type

------------------------------------------------------------------------
-- 1.  The mixed order is decidable, so the mixed layer is computable
------------------------------------------------------------------------

decDom : (ds : List Bool) (v w : Vec ds) â†’ Dec (Dom ds v w)
decDom []           _        _        = yes tt
decDom (true  âˆ· ds) (x , xs) (y , ys) with decâ‰¤ x y
... | no Â¬p = no (Î» z â†’ Â¬p (fst z))
... | yes p with decDom ds xs ys
...   | yes q = yes (p , q)
...   | no Â¬q = no (Î» z â†’ Â¬q (snd z))
decDom (false âˆ· ds) (x , xs) (y , ys) with decâ‰¤ y x
... | no Â¬p = no (Î» z â†’ Â¬p (fst z))
... | yes p with decDom ds xs ys
...   | yes q = yes (p , q)
...   | no Â¬q = no (Î» z â†’ Â¬q (snd z))

decMixedStrict :
  (ds : List Bool) (u z : Vec ds) â†’ Dec (MixedStrict ds u z)
decMixedStrict ds u z with decDom ds u z
... | no Â¬p = no (Î» w â†’ Â¬p (fst w))
... | yes p with decNeg (decDom ds z u)
...   | yes q = yes (p , q)
...   | no Â¬q = no (Î» w â†’ Â¬q (snd w))

decMixedMaximal :
  (ds : List Bool) (vs : List (Vec ds)) (u : Vec ds)
  â†’ Dec (MixedMaximal ds vs u)
decMixedMaximal ds vs u =
  decNeg (decAny (MixedStrict ds u) (decMixedStrict ds u) vs)

mixedStratum : (ds : List Bool) â†’ List (Vec ds) â†’ List (Vec ds)
mixedStratum ds vs =
  filterDec (MixedMaximal ds vs) (decMixedMaximal ds vs) vs

------------------------------------------------------------------------
-- 2.  Two list lemmas
------------------------------------------------------------------------

filterMapCommutes :
  {B : Type} (f : A â†’ B) (Q : B â†’ Type) (dq : (b : B) â†’ Dec (Q b))
  (xs : List A)
  â†’ filterDec Q dq (map f xs)
    â‰¡ map f (filterDec (Î» a â†’ Q (f a)) (Î» a â†’ dq (f a)) xs)
filterMapCommutes f Q dq []       = refl
filterMapCommutes f Q dq (x âˆ· xs) with dq (f x)
... | yes _ = cong (f x âˆ·_) (filterMapCommutes f Q dq xs)
... | no  _ = filterMapCommutes f Q dq xs

filterRespectsOn :
  (P Q : A â†’ Type) (dp : (a : A) â†’ Dec (P a)) (dq : (a : A) â†’ Dec (Q a))
  (xs : List A)
  â†’ ((a : A) â†’ Mem a xs â†’ (P a â†’ Q a) Ã— (Q a â†’ P a))
  â†’ filterDec P dp xs â‰¡ filterDec Q dq xs
filterRespectsOn P Q dp dq []       iff = refl
filterRespectsOn P Q dp dq (x âˆ· xs) iff with dp x | dq x
... | yes _ | yes _ =
  cong (x âˆ·_) (filterRespectsOn P Q dp dq xs (Î» a m â†’ iff a (inr m)))
... | yes p | no Â¬q = âŠ¥.rec (Â¬q (fst (iff x (inl refl)) p))
... | no Â¬p | yes q = âŠ¥.rec (Â¬p (snd (iff x (inl refl)) q))
... | no  _ | no  _ =
  filterRespectsOn P Q dp dq xs (Î» a m â†’ iff a (inr m))

------------------------------------------------------------------------
-- 3.  Under the caps the two maximalities agree
------------------------------------------------------------------------

mixedMaximalIff :
  (ds : List Bool) (cs : Caps ds) (vs : List (Vec ds))
  â†’ AllBounded ds cs vs
  â†’ (u : Vec ds) â†’ BoundedC ds cs u
  â†’ (MixedMaximal ds vs u
       â†’ IsParetoMaximal (flipWithCaps ds cs u) (map (flipWithCaps ds cs) vs))
  Ã— (IsParetoMaximal (flipWithCaps ds cs u) (map (flipWithCaps ds cs) vs)
       â†’ MixedMaximal ds vs u)
mixedMaximalIff ds cs vs ab u ub = fwd , bwd
  where
    f : Vec ds â†’ List â„•
    f = flipWithCaps ds cs

    fwd : MixedMaximal ds vs u â†’ IsParetoMaximal (f u) (map f vs)
    fwd mm anyP
      with anyToMember (Î» z â†’ StrictlyDominates (f u) (f z)) vs
             (anyMapBack f (StrictlyDominates (f u)) vs anyP)
    ... | (z , memZ , (le , Â¬le)) =
      mm (memberToAny (MixedStrict ds u) z vs memZ
           ( flipCapsReflect ds cs u z (boundedAtMember ds cs vs z ab memZ) le
           , (Î» dzu â†’ Â¬le (flipCapsIsSound ds cs z u dzu))))

    bwd : IsParetoMaximal (f u) (map f vs) â†’ MixedMaximal ds vs u
    bwd pm anyM with anyToMember (MixedStrict ds u) vs anyM
    ... | (z , memZ , (duz , Â¬dzu)) =
      pm (memberToAny (StrictlyDominates (f u)) (f z) (map f vs)
           (memberMaps f vs z memZ)
           ( flipCapsIsSound ds cs u z duz
           , (Î» le â†’ Â¬dzu (flipCapsReflect ds cs z u ub le))))

------------------------------------------------------------------------
-- 4.  â¦so the layers are the same list
------------------------------------------------------------------------

theMixedStratumIsTheFlippedStratum :
  (ds : List Bool) (cs : Caps ds) (vs : List (Vec ds))
  â†’ AllBounded ds cs vs
  â†’ map (flipWithCaps ds cs) (mixedStratum ds vs)
    â‰¡ stratum (map (flipWithCaps ds cs) vs)
theMixedStratumIsTheFlippedStratum ds cs vs ab =
    cong (map (flipWithCaps ds cs))
      (filterRespectsOn (MixedMaximal ds vs)
        (Î» u â†’ IsParetoMaximal (flipWithCaps ds cs u)
                               (map (flipWithCaps ds cs) vs))
        (decMixedMaximal ds vs)
        (Î» u â†’ decIsParetoMaximal (flipWithCaps ds cs u)
                                  (map (flipWithCaps ds cs) vs))
        vs
        (Î» a m â†’ mixedMaximalIff ds cs vs ab a (boundedAtMember ds cs vs a ab m)))
  âˆ™ sym (filterMapCommutes (flipWithCaps ds cs)
          (Î» y â†’ IsParetoMaximal y (map (flipWithCaps ds cs) vs))
          (Î» y â†’ decIsParetoMaximal y (map (flipWithCaps ds cs) vs))
          vs)
