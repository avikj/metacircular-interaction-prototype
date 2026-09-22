{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision
--
-- Â§5.2 lists eight objectives, and says the
-- controller "maintains Pareto strata" and samples WITHIN a stratum.
-- The design is stated; the reason it must be that shape is not.
--
-- It is forced, and the two halves are checked here.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   â‰¼-refl / â‰¼-trans / â‰¼-antisym
--       the pointwise (product) order on fitness vectors is a partial
--       order â” antisymmetry included, so it really is an order and not
--       merely a preorder, unlike the threshold âŠ elsewhere in this
--       corpus
--   incomparable
--       (2,0) and (0,3) dominate each other in neither direction, so
--       the order is NOT total and "the best node" does not denote
--   sumIsMonotone
--       a scalarisation cannot CONTRADICT dominance â¦
--   scalarisationDecidesAnIncomparablePair
--       â¦ but it does DECIDE the incomparable pair above: sum says
--       2 < 3 where the objectives say nothing
--   monotoneStrictnessRefutesDominance
--       and generally, for any monotone f, `f v < f w` refutes `w â‰¼ v`
--       â” which is exactly the strength a scalarisation has and no more
--
-- **So a scalar fitness is a strict extension of the objective order,
-- and every such extension is a CHOICE that the objectives do not
-- license.**  That is why Â§5.2's two-stage shape â” pick a stratum, then
-- sample inside it â” is not a refinement of "pick the best": there is
-- no best to pick, and any rule that produces one has smuggled in a
-- preference ordering under the name of a measurement.
--
-- Â§2's seam 3, checked in
-- `AscendingFirstIsTheWorstUnlessTheArchiveIsConstant`, is a bug in a
-- branch that assumes a TOTAL order on accuracy.  Â§5.2 says the fitness
-- is a vector.  Those two facts sit in one note: the seam is in code
-- selecting by a scalar, and the design section says the scalar does not
-- exist.  The two sections are about the same missing total order.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- The product order, its failure of totality, and the fact
-- that monotone scalarisations are strict extensions are standard
-- multi-objective optimisation, going back to Pareto (`Cours
-- d'©conomie politique`, 1896) and Edgeworth before him.
------------------------------------------------------------------------

module AParetoFitnessHasNoBestAndEveryScalarisationAddsADecision where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; +-comm ; snotz)
open import Cubical.Data.Nat.Order
  using (_â‰¤_ ; _<_ ; â‰¤-refl ; â‰¤-trans ; â‰¤-antisym ; â‰¤-+-â‰¤ ; Â¬m<m)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

------------------------------------------------------------------------
-- 1.  The product order on fitness vectors
------------------------------------------------------------------------

_â‰¼_ : List â„• â†’ List â„• â†’ Type
[]       â‰¼ []       = Unit
[]       â‰¼ (_ âˆ· _)  = âŠ¥
(_ âˆ· _)  â‰¼ []       = âŠ¥
(x âˆ· xs) â‰¼ (y âˆ· ys) = (x â‰¤ y) Ã— (xs â‰¼ ys)

â‰¼-refl : (v : List â„•) â†’ v â‰¼ v
â‰¼-refl []       = tt
â‰¼-refl (x âˆ· xs) = â‰¤-refl , â‰¼-refl xs

â‰¼-trans : (u v w : List â„•) â†’ u â‰¼ v â†’ v â‰¼ w â†’ u â‰¼ w
â‰¼-trans []       []       []       _          _          = tt
â‰¼-trans (x âˆ· xs) (y âˆ· ys) (z âˆ· zs) (le , les) (le' , les') =
  â‰¤-trans le le' , â‰¼-trans xs ys zs les les'

â‰¼-antisym : (v w : List â„•) â†’ v â‰¼ w â†’ w â‰¼ v â†’ v â‰¡ w
â‰¼-antisym []       []       _          _          = refl
â‰¼-antisym (x âˆ· xs) (y âˆ· ys) (le , les) (ge , ges) =
  congâ‚‚ _âˆ·_ (â‰¤-antisym le ge) (â‰¼-antisym xs ys les ges)

------------------------------------------------------------------------
-- 2.  It is not total, so "the best node" does not denote
------------------------------------------------------------------------

yieldFirst costFirst : List â„•
yieldFirst = 2 âˆ· 0 âˆ· []
costFirst  = 0 âˆ· 3 âˆ· []

Â¬2â‰¤0 : Â¬ (2 â‰¤ 0)
Â¬2â‰¤0 (k , e) = snotz (sym (+-comm k 2) âˆ™ e)

Â¬3â‰¤0 : Â¬ (3 â‰¤ 0)
Â¬3â‰¤0 (k , e) = snotz (sym (+-comm k 3) âˆ™ e)

incomparable : (Â¬ (yieldFirst â‰¼ costFirst)) Ã— (Â¬ (costFirst â‰¼ yieldFirst))
incomparable = (Î» p â†’ Â¬2â‰¤0 (fst p)) , (Î» p â†’ Â¬3â‰¤0 (fst (snd p)))

------------------------------------------------------------------------
-- 3.  A scalarisation cannot contradict dominance
------------------------------------------------------------------------

sum : List â„• â†’ â„•
sum []       = 0
sum (x âˆ· xs) = x + sum xs

sumIsMonotone : (v w : List â„•) â†’ v â‰¼ w â†’ sum v â‰¤ sum w
sumIsMonotone []       []       _          = â‰¤-refl
sumIsMonotone (x âˆ· xs) (y âˆ· ys) (le , les) =
  â‰¤-+-â‰¤ le (sumIsMonotone xs ys les)

-- the general strength of ANY monotone scalarisation, and its limit
monotoneStrictnessRefutesDominance :
  (f : List â„• â†’ â„•)
  â†’ ((v w : List â„•) â†’ v â‰¼ w â†’ f v â‰¤ f w)
  â†’ (v w : List â„•) â†’ f v < f w â†’ Â¬ (w â‰¼ v)
monotoneStrictnessRefutesDominance f mono v w lt dom =
  Â¬m<m (â‰¤-trans lt (mono w v dom))

------------------------------------------------------------------------
-- 4.  But it decides a pair the objectives leave undecided
------------------------------------------------------------------------

sumOrdersThem : sum yieldFirst < sum costFirst
sumOrdersThem = 0 , refl

scalarisationDecidesAnIncomparablePair :
    (Â¬ (yieldFirst â‰¼ costFirst))
  Ã— (Â¬ (costFirst â‰¼ yieldFirst))
  Ã— (sum yieldFirst < sum costFirst)
scalarisationDecidesAnIncomparablePair =
  fst incomparable , snd incomparable , sumOrdersThem

------------------------------------------------------------------------
-- The decision on `â‰¼`, and the constructive existence of a Pareto
-- stratification for an arbitrary archive, are proved in
-- `TheParetoStratumIsDecidableAndTheFilterIsExact`:
--
--   decâ‰ / decâ‰¼           from `splitâ•-â‰` alone
--   decStrictlyDominates
--   decIsParetoMaximal     against a finite archive, reusing `decAny`
--   stratum                the maximal layer, as a COMPUTED list
--   stratumOnlyKeepsMaximal / stratumKeepsEveryMaximal
--                          sound and complete, so the computed stratum
--                          and the specified one have the same members
--
-- Here: there is no best to pick.  There: the thing Â§5.2 picks INSTEAD â” "the
-- controller first selects a Pareto stratum S" â” is constructible, and
-- a controller cannot select what it cannot compute.
--
------------------------------------------------------------------------

------------------------------------------------------------------------
-- Â§5.2's objectives include wall time, tokens, and dollar cost, which
-- are to be MINIMISED; nothing above flips any coordinate, so the
-- theorems are about a vector all of whose coordinates point the same
-- way, and applying them needs the costs negated first.  The min-plus
-- line shows twice that reversing an order is load-bearing, so the flip
-- has its own theorem, in
-- `FlippingACostCoordinateIsSoundButNotFaithful`.
--
--   Vec ds / Dom ds   vectors over a DIRECTION list, and MIXED
--                     dominance: `â‰` at a benefit coordinate, `â‰` at a
--                     cost coordinate â” what Â§5.2 actually means
--   âˆ-antitone        from the monus adjunction on the min-plus line
--   flipWith cap      `cap âˆ x` at a cost coordinate
--   flipIsSound       mixed dominance IMPLIES ordinary `â‰¼` of the
--                     flipped vectors, so Â§Â§1â“4 above transfer
--   flipIsNotFaithful and the CONVERSE FAILS: at `cap = 3` the costs
--                     `5` and `7` both flip to `0`
--
-- **"Negated first" is half true.**  Flipping suffices to
-- APPLY these theorems â” soundness is the only direction that needs.
-- It does NOT suffice to transport a conclusion back, because the cap
-- identifies every cost above it.  The honest form is "negate the
-- costs, and pick a cap above every cost you will ever compare", which
-- is a modelling obligation and not a rewriting step.
--
------------------------------------------------------------------------
