{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision
--
-- 'number of exciting claims'", lists eight objectives, and says the
-- controller "maintains Pareto strata" and samples WITHIN a stratum.
-- The design is stated; the reason it must be that shape is not.
--
-- It is forced, and the two halves are checked here.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT IS PROVED
--
--   ‚âº-refl / ‚âº-trans / ‚âº-antisym
--       the pointwise (product) order on fitness vectors is a partial
--       order ‚î antisymmetry included, so it really is an order and not
--       merely a preorder, unlike the threshold ‚ä elsewhere in this
--       corpus
--   incomparable
--       (2,0) and (0,3) dominate each other in neither direction, so
--       the order is NOT total and "the best node" does not denote
--   sumIsMonotone
--       a scalarisation cannot CONTRADICT dominance ‚¶
--   scalarisationDecidesAnIncomparablePair
--       ‚¶ but it does DECIDE the incomparable pair above: sum says
--       2 < 3 where the objectives say nothing
--   monotoneStrictnessRefutesDominance
--       and generally, for any monotone f, `f v < f w` refutes `w ‚âº v`
--       ‚î which is exactly the strength a scalarisation has and no more
--
-- **So a scalar fitness is a strict extension of the objective order,
-- and every such extension is a CHOICE that the objectives do not
-- license.**  That is why ¬ß5.2's two-stage shape ‚î pick a stratum, then
-- sample inside it ‚î is not a refinement of "pick the best": there is
-- no best to pick, and any rule that produces one has smuggled in a
-- preference ordering under the name of a measurement.
--
-- ¬ß2's seam 3, checked in
-- `AscendingFirstIsTheWorstUnlessTheArchiveIsConstant`, is a bug in a
-- branch that assumes a TOTAL order on accuracy.  ¬ß5.2 says the fitness
-- is a vector.  Those two facts sit in one note: the seam is in code
-- selecting by a scalar, and the design section says the scalar does not
-- exist.  Nothing here claims the released code implements ¬ß5.2 ‚î it
-- does not, ¬ß5.2 is this repository's proposed controller ‚î only that
-- the two sections are about the same missing total order.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- NO NOVELTY.  The product order, its failure of totality, and the fact
-- that monotone scalarisations are strict extensions are standard
-- multi-objective optimisation, going back to Pareto (`Cours
-- d'©conomie politique`, 1896) and Edgeworth before him; the Agda is
-- attached to ¬ß5.2, not discovered.
------------------------------------------------------------------------

module AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _+_ ; +-comm ; snotz)
open import Cubical.Data.Nat.Order
  using (_‚â§_ ; _<_ ; ‚â§-refl ; ‚â§-trans ; ‚â§-antisym ; ‚â§-+-‚â§ ; ¬¨m<m)
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as ‚ä• using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_)

------------------------------------------------------------------------
-- 1.  The product order on fitness vectors
------------------------------------------------------------------------

_‚âº_ : List ‚Ñï ‚Üí List ‚Ñï ‚Üí Type
[]       ‚âº []       = Unit
[]       ‚âº (_ ‚à∑ _)  = ‚ä•
(_ ‚à∑ _)  ‚âº []       = ‚ä•
(x ‚à∑ xs) ‚âº (y ‚à∑ ys) = (x ‚â§ y) √ó (xs ‚âº ys)

‚âº-refl : (v : List ‚Ñï) ‚Üí v ‚âº v
‚âº-refl []       = tt
‚âº-refl (x ‚à∑ xs) = ‚â§-refl , ‚âº-refl xs

‚âº-trans : (u v w : List ‚Ñï) ‚Üí u ‚âº v ‚Üí v ‚âº w ‚Üí u ‚âº w
‚âº-trans []       []       []       _          _          = tt
‚âº-trans (x ‚à∑ xs) (y ‚à∑ ys) (z ‚à∑ zs) (le , les) (le' , les') =
  ‚â§-trans le le' , ‚âº-trans xs ys zs les les'

‚âº-antisym : (v w : List ‚Ñï) ‚Üí v ‚âº w ‚Üí w ‚âº v ‚Üí v ‚â° w
‚âº-antisym []       []       _          _          = refl
‚âº-antisym (x ‚à∑ xs) (y ‚à∑ ys) (le , les) (ge , ges) =
  cong‚ÇÇ _‚à∑_ (‚â§-antisym le ge) (‚âº-antisym xs ys les ges)

------------------------------------------------------------------------
-- 2.  It is not total, so "the best node" does not denote
------------------------------------------------------------------------

yieldFirst costFirst : List ‚Ñï
yieldFirst = 2 ‚à∑ 0 ‚à∑ []
costFirst  = 0 ‚à∑ 3 ‚à∑ []

¬¨2‚â§0 : ¬¨ (2 ‚â§ 0)
¬¨2‚â§0 (k , e) = snotz (sym (+-comm k 2) ‚àô e)

¬¨3‚â§0 : ¬¨ (3 ‚â§ 0)
¬¨3‚â§0 (k , e) = snotz (sym (+-comm k 3) ‚àô e)

incomparable : (¬¨ (yieldFirst ‚âº costFirst)) √ó (¬¨ (costFirst ‚âº yieldFirst))
incomparable = (Œª p ‚Üí ¬¨2‚â§0 (fst p)) , (Œª p ‚Üí ¬¨3‚â§0 (fst (snd p)))

------------------------------------------------------------------------
-- 3.  A scalarisation cannot contradict dominance
------------------------------------------------------------------------

sum : List ‚Ñï ‚Üí ‚Ñï
sum []       = 0
sum (x ‚à∑ xs) = x + sum xs

sumIsMonotone : (v w : List ‚Ñï) ‚Üí v ‚âº w ‚Üí sum v ‚â§ sum w
sumIsMonotone []       []       _          = ‚â§-refl
sumIsMonotone (x ‚à∑ xs) (y ‚à∑ ys) (le , les) =
  ‚â§-+-‚â§ le (sumIsMonotone xs ys les)

-- the general strength of ANY monotone scalarisation, and its limit
monotoneStrictnessRefutesDominance :
  (f : List ‚Ñï ‚Üí ‚Ñï)
  ‚Üí ((v w : List ‚Ñï) ‚Üí v ‚âº w ‚Üí f v ‚â§ f w)
  ‚Üí (v w : List ‚Ñï) ‚Üí f v < f w ‚Üí ¬¨ (w ‚âº v)
monotoneStrictnessRefutesDominance f mono v w lt dom =
  ¬¨m<m (‚â§-trans lt (mono w v dom))

------------------------------------------------------------------------
-- 4.  But it decides a pair the objectives leave undecided
------------------------------------------------------------------------

sumOrdersThem : sum yieldFirst < sum costFirst
sumOrdersThem = 0 , refl

scalarisationDecidesAnIncomparablePair :
    (¬¨ (yieldFirst ‚âº costFirst))
  √ó (¬¨ (costFirst ‚âº yieldFirst))
  √ó (sum yieldFirst < sum costFirst)
scalarisationDecidesAnIncomparablePair =
  fst incomparable , snd incomparable , sumOrdersThem

------------------------------------------------------------------------
-- The decision on `‚âº`, and the constructive existence of a Pareto
-- stratification for an arbitrary archive, are proved in
-- `TheParetoStratumIsDecidableAndTheFilterIsExact`:
--
--   dec‚â / dec‚âº           from `split‚ï-‚â` alone
--   decStrictlyDominates
--   decIsParetoMaximal     against a finite archive, reusing `decAny`
--   stratum                the maximal layer, as a COMPUTED list
--   stratumOnlyKeepsMaximal / stratumKeepsEveryMaximal
--                          sound and complete, so the computed stratum
--                          and the specified one have the same members
--
-- What that adds to ¬ß5.2 is the half this module could not say.  Here:
-- there is no best to pick.  There: the thing ¬ß5.2 picks INSTEAD ‚î "the
-- controller first selects a Pareto stratum S" ‚î is constructible, and
-- a controller cannot select what it cannot compute.
--
------------------------------------------------------------------------

------------------------------------------------------------------------
-- ¬ß5.2's objectives include wall time, tokens, and dollar cost, which
-- are to be MINIMISED; nothing above flips any coordinate, so the
-- theorems are about a vector all of whose coordinates point the same
-- way, and applying them needs the costs negated first.  The min-plus
-- line shows twice that reversing an order is load-bearing, so the flip
-- has its own theorem, in
-- `FlippingACostCoordinateIsSoundButNotFaithful`.
--
--   Vec ds / Dom ds   vectors over a DIRECTION list, and MIXED
--                     dominance: `‚â` at a benefit coordinate, `‚â` at a
--                     cost coordinate ‚î what ¬ß5.2 actually means
--   ‚à-antitone        from the monus adjunction on the min-plus line
--   flipWith cap      `cap ‚à x` at a cost coordinate
--   flipIsSound       mixed dominance IMPLIES ordinary `‚âº` of the
--                     flipped vectors, so ¬ß¬ß1‚ì4 above transfer
--   flipIsNotFaithful and the CONVERSE FAILS: at `cap = 3` the costs
--                     `5` and `7` both flip to `0`
--
-- **"Negated first" is half true.**  Flipping suffices to
-- APPLY these theorems ‚î soundness is the only direction that needs.
-- It does NOT suffice to transport a conclusion back, because the cap
-- identifies every cost above it.  The honest form is "negate the
-- costs, and pick a cap above every cost you will ever compare", which
-- is a modelling obligation and not a rewriting step.
--
------------------------------------------------------------------------
