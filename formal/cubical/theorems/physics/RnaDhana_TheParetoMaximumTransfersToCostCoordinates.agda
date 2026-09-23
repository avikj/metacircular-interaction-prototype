{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RnaDhana_TheParetoMaximumTransfersToCostCoordinates
--
-- à‹àà§à¨ Â a-dhana â” Brahmagupta, *Brhmasphuasiddhnta* (628): the
-- same magnitude read as *dhana* (asset) or *a* (debt).  The sign
-- rules are his; the caps, the adjunction and everything below are not.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- Every module on the Pareto line has carried the same undischarged
-- obligation: its theorems are stated for a vector all of whose
-- coordinates point the same way, while DARWIN Â§5.2's objectives
-- include wall time, tokens and dollars, which are to be MINIMISED.
-- Two modules then proved the flip sound, refuted its unrestricted
-- converse, and made it faithful below per-coordinate caps.  **None of
-- them applied it.**
--
-- This one applies it: an existing Pareto theorem is USED, through the
-- flip, to prove a statement about genuinely mixed benefit/cost
-- vectors.  Nothing about maximality is re-proved.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   MixedStrict ds u z   z beats u in the MIXED order: `Dom ds u z`
--                        and not `Dom ds z u` â” `â‰` at benefit
--                        coordinates, `â‰` at cost coordinates
--   MixedMaximal         nothing in the archive beats u
--   AllBounded           every member's cost entries are below their
--                        own caps
--   anyMapBack / memberMaps
--                        the two transfers along `map` that carry
--                        membership and `Any` across the flip
--   mixedMaximalExists   **every non-empty archive of mixed vectors
--                        has a mixed-maximal member, provided the caps
--                        bound its members** â” proved by calling
--                        `maximalExists` on the flipped archive and
--                        pulling the result back
--
-- **WHAT THE PULL-BACK COSTS, AND WHERE.**  Soundness moves forward for
-- nothing; the bound is needed only in the NEGATIVE half â” to turn
-- "the flipped z does not beat the flipped u" back into "z does not
-- beat u" one needs `flipCapsReflect`, whose hypothesis is a bound on
-- u.  Since u is a member of the archive, `AllBounded` supplies it.
-- So the honest reading of the obligation the Pareto line has been
-- carrying is: **cap each cost coordinate, in its own units, above the
-- costs of the archive's members â” and then every benefit-reading
-- theorem is available.**
--
-- The flip is NOT injective (that is exactly
-- `flipIsNotFaithful`), so the pull-back cannot go through the flipped
-- element: it goes through `anyMapBack`, which recovers a member of the
-- ORIGINAL archive whose flip is the maximal element found.  That is
-- the step where a naive transfer would break.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY.  Transporting an order-theoretic existence result along
-- an order-preserving map with an order-reflecting partial inverse is
-- routine; `maximalExists` is this corpus's own, and the mixed
-- statement is the one DARWIN Â§5.2 needed all along.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module RnaDhana_TheParetoMaximumTransfersToCostCoordinates where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„•)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.List using (List ; [] ; _âˆ·_ ; map)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_ ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

open import OrderAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any ; memberToAny)
open import EveryRemainderMemberIsStrictlyDominated
  using (anyToMember)
open import OneStepCoverageAndDisjointnessOfTheLayer using (Mem)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (StrictlyDominates ; IsParetoMaximal)
open import ANonEmptyArchiveHasANonEmptyStratum using (maximalExists)
open import FlippingACostCoordinateIsSoundButNotFaithful
  using (Vec ; Dom)
open import RnaDhana_PerCoordinateCapsAreTheHonestVersionAndOneCapIsTheSpecialCase
  using (Caps ; BoundedC ; flipWithCaps ; flipCapsIsSound ; flipCapsReflect)

------------------------------------------------------------------------
-- 1.  The mixed order and the bounded archive
------------------------------------------------------------------------

MixedStrict : (ds : List Bool) â†’ Vec ds â†’ Vec ds â†’ Type
MixedStrict ds u z = Dom ds u z Ã— (Â¬ Dom ds z u)

MixedMaximal : (ds : List Bool) â†’ List (Vec ds) â†’ Vec ds â†’ Type
MixedMaximal ds vs u = Â¬ Any (MixedStrict ds u) vs

AllBounded : (ds : List Bool) â†’ Caps ds â†’ List (Vec ds) â†’ Type
AllBounded ds cs []       = Unit
AllBounded ds cs (v âˆ· vs) = BoundedC ds cs v Ã— AllBounded ds cs vs

boundedAtMember :
  (ds : List Bool) (cs : Caps ds) (vs : List (Vec ds)) (u : Vec ds)
  â†’ AllBounded ds cs vs â†’ Mem u vs â†’ BoundedC ds cs u
boundedAtMember ds cs []       u _        e       = âŠ¥.rec e
boundedAtMember ds cs (v âˆ· vs) u (b , bs) (inl q) = subst (BoundedC ds cs) q b
boundedAtMember ds cs (v âˆ· vs) u (b , bs) (inr r) =
  boundedAtMember ds cs vs u bs r

------------------------------------------------------------------------
-- 2.  Transfers along `map`
------------------------------------------------------------------------

anyMapBack :
  {A B : Type} (f : A â†’ B) (P : B â†’ Type) (xs : List A)
  â†’ Any P (map f xs) â†’ Any (Î» x â†’ P (f x)) xs
anyMapBack f P []       e       = âŠ¥.rec e
anyMapBack f P (x âˆ· xs) (inl p) = inl p
anyMapBack f P (x âˆ· xs) (inr q) = inr (anyMapBack f P xs q)

memberMaps :
  {A B : Type} (f : A â†’ B) (xs : List A) (x : A)
  â†’ Mem x xs â†’ Mem (f x) (map f xs)
memberMaps f []       x e       = âŠ¥.rec e
memberMaps f (y âˆ· xs) x (inl q) = inl (cong f q)
memberMaps f (y âˆ· xs) x (inr r) = inr (memberMaps f xs x r)

------------------------------------------------------------------------
-- 3.  The maximum transfers
------------------------------------------------------------------------

mixedMaximalExists :
  (ds : List Bool) (cs : Caps ds) (v : Vec ds) (vs : List (Vec ds))
  â†’ AllBounded ds cs (v âˆ· vs)
  â†’ Î£[ u âˆˆ Vec ds ] (Mem u (v âˆ· vs) Ã— MixedMaximal ds (v âˆ· vs) u)
mixedMaximalExists ds cs v vs ab
  with maximalExists (flipWithCaps ds cs v) (map (flipWithCaps ds cs) vs)
... | (m , memM , maxM)
      with anyToMember (Î» u â†’ flipWithCaps ds cs u â‰¡ m) (v âˆ· vs)
             (anyMapBack (flipWithCaps ds cs) (Î» y â†’ y â‰¡ m) (v âˆ· vs) memM)
...     | (u , memU , equ) = u , memU , notBeaten
  where
    notBeaten : MixedMaximal ds (v âˆ· vs) u
    notBeaten anyStrict with anyToMember (MixedStrict ds u) (v âˆ· vs) anyStrict
    ... | (z , memZ , (domUZ , notDomZU)) =
      maxM (memberToAny (StrictlyDominates m) (flipWithCaps ds cs z)
             (map (flipWithCaps ds cs) (v âˆ· vs))
             (memberMaps (flipWithCaps ds cs) (v âˆ· vs) z memZ)
             (subst (Î» t â†’ StrictlyDominates t (flipWithCaps ds cs z)) equ
               ( flipCapsIsSound ds cs u z domUZ
               , (Î» le â†’ notDomZU
                   (flipCapsReflect ds cs z u
                     (boundedAtMember ds cs (v âˆ· vs) u ab memU) le)))))

------------------------------------------------------------------------
-- APPENDED 2026-08-19, by the same identity, at the end, altering no
-- line above.  The item named above â” "the stratification is NOT
-- transferred here" â” has its FIRST LAYER done in
-- `RnaDhana_TheMixedStratumIsExactlyTheFlippedStratum`
-- (--safe, no postulates, no holes; container green under Agda 2.6.3 +
-- cubical v0.5, NOT the declared pin â” check.sh returns 1 and says so).
--
-- The result is stronger than the membership correspondence this
-- module's block predicted would be needed: under the caps,
-- `map flip (mixedStratum ds vs) â‰¡ stratum (map flip vs)` â” the two
-- layers are the SAME LIST, order and multiplicity included.  What
-- makes that possible despite the flip not being injective is that
-- both sides are filters of the same list in the same order, so
-- `filterMapCommutes` moves the map across the filter and
-- `filterRespectsOn` needs the two predicates to agree only AT
-- MEMBERS â” which is exactly where `AllBounded` gives a cap.
--
-- Still open, and now precisely: the REMAINDER half (same argument,
-- negated predicate), and then the iteration, in which the caps must
-- still bound the shrinking archive at every step.
------------------------------------------------------------------------
