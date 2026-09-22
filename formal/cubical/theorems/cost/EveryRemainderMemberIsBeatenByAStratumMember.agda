{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- EveryRemainderMemberIsBeatenByAStratumMember
--
-- DARWIN ¬ß5.2's ORDER property, second half.  `EveryRemainderMember-
-- IsStrictlyDominated` proved that a member of the remainder is beaten
-- by SOMETHING in the archive.  That is not the ordering statement: the
-- something might itself be in the remainder, and then the strata are
-- not ordered by domination at all.  What is needed, and proved here:
--
--   every member of the remainder is beaten by a member of the
--   STRATUM.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- THE ARGUMENT.
--
-- No well-founded measure on ‚Ñï over a finite list is needed.  The
-- chain-climbing argument ‚î v is beaten by u, u may be beaten by u‚≤,
-- iterate and hope it stops ‚î is not the only route; the shorter one:
--
--   apply `maximalExists` to the SUBLIST of elements that beat v.
--
-- `maximalExists` performs the finite induction, once, for the
-- non-empty-stratum theorem; it costs nothing to point it at a
-- different list.  The maximal element OF THAT SUBLIST is maximal in
-- the whole archive ‚î because anything beating it would, by
-- transitivity, also beat v and hence lie in the sublist.  That is the
-- whole proof.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   above v xs        the elements of xs that strictly dominate v
--   memberIntoFilter  the converse of `memberOfFilterSatisfies`: a
--                     member satisfying the predicate is a member of
--                     the filtrate (arbitrary decidable predicate)
--   maximalOfNonEmpty `maximalExists` with the non-emptiness supplied
--                     by a membership rather than by a cons pattern
--   aboveMaximalIsGloballyMaximal
--                     maximal in `above v xs` ‚í maximal in xs
--   theDominatorCanBeChosenMaximal
--                     any dominator of v can be replaced by one in the
--                     stratum
--   everyRemainderMemberIsBeatenByAStratumMember
--                     hence the ordering statement
--
-- The ordering statement is the ONE-STEP ordering:
-- stratum 1 beats every member of the remainder, and since the next
-- stratum is computed from that remainder, each stratum beats
-- everything below it AT ITS OWN LEVEL.  The transitive statement over
-- `strata` ‚î that stratum i beats every member of stratum j for every
-- j > i ‚î is `theStrataAreOrdered` in
-- `TheStrataAreOrderedByDominationAndTheProofNeedsNoNewLemma`, which
-- composes `strataSound` with the theorem here.
--
-- This is the standard fact that the non-dominated front
-- of a finite set dominates everything else in it (Goldberg 1989; Deb
-- et al. 2002), and the sublist argument is the usual one.
------------------------------------------------------------------------

module EveryRemainderMemberIsBeatenByAStratumMember where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï)
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Sigma using (Œ£-syntax ; _√ó_ ; _,_)
open import Cubical.Data.Empty as ‚ä• using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_ ; Dec ; yes ; no)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any ; memberToAny)
open import TheParetoStratumIsDecidableAndTheFilterIsExact
  using (filterDec ; StrictlyDominates ; decStrictlyDominates
        ; IsParetoMaximal ; stratum ; stratumKeepsEveryMaximal)
open import TheRemainderIsStrictlyShorterSoTheStratificationHasAMeasure
  using (remainder)
open import ANonEmptyArchiveHasANonEmptyStratum
  using (maximalExists ; ‚äè-trans)
open import EveryRemainderMemberIsStrictlyDominated
  using (anyToMember ; everyRemainderMemberIsStrictlyDominated)
open import OneStepCoverageAndDisjointnessOfTheLayer
  using (Mem ; memberOfFilterSatisfies)
open import TheStratificationCoversAndItsStrataArePairwiseDisjoint
  using (filterDecSubset)

private
  variable
    A : Type

------------------------------------------------------------------------
-- 1.  Into the filtrate ‚î the converse of memberOfFilterSatisfies
------------------------------------------------------------------------

memberIntoFilter :
  (P : A ‚Üí Type) (d : (a : A) ‚Üí Dec (P a)) (xs : List A) (a : A)
  ‚Üí Mem a xs ‚Üí P a ‚Üí Mem a (filterDec P d xs)
memberIntoFilter P d []       a e p = ‚ä•.rec e
memberIntoFilter P d (x ‚à∑ xs) a m p with d x
memberIntoFilter P d (x ‚à∑ xs) a (inl q) p | yes _ = inl q
memberIntoFilter P d (x ‚à∑ xs) a (inr r) p | yes _ =
  inr (memberIntoFilter P d xs a r p)
memberIntoFilter P d (x ‚à∑ xs) a (inl q) p | no ¬¨px =
  ‚ä•.rec (¬¨px (subst P (sym q) p))
memberIntoFilter P d (x ‚à∑ xs) a (inr r) p | no _ =
  memberIntoFilter P d xs a r p

------------------------------------------------------------------------
-- 2.  The elements that beat v, and a maximal one among them
------------------------------------------------------------------------

above : List ‚Ñï ‚Üí List (List ‚Ñï) ‚Üí List (List ‚Ñï)
above v xs = filterDec (StrictlyDominates v) (decStrictlyDominates v) xs

maximalOfNonEmpty :
  (ys : List (List ‚Ñï)) (a : List ‚Ñï) ‚Üí Mem a ys
  ‚Üí Œ£[ m ‚àà List ‚Ñï ] (Mem m ys √ó IsParetoMaximal m ys)
maximalOfNonEmpty []       a e = ‚ä•.rec e
maximalOfNonEmpty (y ‚à∑ ys) a _ = maximalExists y ys

------------------------------------------------------------------------
-- 3.  Maximal in the sublist is maximal in the archive
------------------------------------------------------------------------

aboveMaximalIsGloballyMaximal :
  (v : List ‚Ñï) (xs : List (List ‚Ñï)) (w : List ‚Ñï)
  ‚Üí StrictlyDominates v w
  ‚Üí IsParetoMaximal w (above v xs) ‚Üí IsParetoMaximal w xs
aboveMaximalIsGloballyMaximal v xs w vw maxA anyxs
  with anyToMember (StrictlyDominates w) xs anyxs
... | (z , mz , wz) =
  maxA (memberToAny (StrictlyDominates w) z (above v xs)
         (memberIntoFilter (StrictlyDominates v) (decStrictlyDominates v)
                           xs z mz (‚äè-trans v w z vw wz))
         wz)

------------------------------------------------------------------------
-- 4.  So the dominator can always be taken from the stratum
------------------------------------------------------------------------

theDominatorCanBeChosenMaximal :
  (xs : List (List ‚Ñï)) (v u : List ‚Ñï)
  ‚Üí Mem u xs ‚Üí StrictlyDominates v u
  ‚Üí Œ£[ w ‚àà List ‚Ñï ] (Mem w (stratum xs) √ó StrictlyDominates v w)
theDominatorCanBeChosenMaximal xs v u mu vu
  with maximalOfNonEmpty (above v xs) u
         (memberIntoFilter (StrictlyDominates v) (decStrictlyDominates v)
                           xs u mu vu)
... | (w , mw , maxw) =
    w
  , stratumKeepsEveryMaximal xs w
      (filterDecSubset (StrictlyDominates v) (decStrictlyDominates v) xs w mw)
      (aboveMaximalIsGloballyMaximal v xs w
        (memberOfFilterSatisfies (StrictlyDominates v)
                                 (decStrictlyDominates v) xs w mw)
        maxw)
  , memberOfFilterSatisfies (StrictlyDominates v)
                            (decStrictlyDominates v) xs w mw

------------------------------------------------------------------------
-- 5.  ORDER, one step
------------------------------------------------------------------------

everyRemainderMemberIsBeatenByAStratumMember :
  (xs : List (List ‚Ñï)) (v : List ‚Ñï)
  ‚Üí Mem v (remainder xs)
  ‚Üí Œ£[ w ‚àà List ‚Ñï ] (Mem w (stratum xs) √ó StrictlyDominates v w)
everyRemainderMemberIsBeatenByAStratumMember xs v mem
  with everyRemainderMemberIsStrictlyDominated xs v mem
... | (u , mu , vu) = theDominatorCanBeChosenMaximal xs v u mu vu
