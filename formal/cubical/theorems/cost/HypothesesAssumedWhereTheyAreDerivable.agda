{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- HypothesesAssumedWhereTheyAreDerivable
--
-- The live remainder left by `TheDeflationaryTestIsVacuous`, applied
-- first to the modules this thread itself wrote.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE QUESTION THAT REPLACED THE OLD ONE
--
-- Thread (2) asked whether the corpus's absences are stable and turned
-- out to admit no failing instance, which is what made it worth
-- closing.  What replaced it: at each site that ASSUMES a hypothesis â”
-- `isSet T`, `Discrete T`, stable paths, `Answerable`, `Dec` â” is the
-- hypothesis derivable there?  That question has failing instances,
-- and the first one it finds is in this thread's own work.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE FINDING
--
-- `ExclusionRecoversGroundAtAPrice` Â§6 assumes BOTH
--
--     (isSetT : isSet T) (discT : Discrete T)
--
-- and `Discreteâ’isSet` is in the library.  The first hypothesis is
-- derivable from the second at that site: it is redundant.  It entered
-- at `984a26b0` (found with `git log -S`, not recalled) and survived
-- every cycle since, because the two hypotheses were written down
-- together and neither was ever checked against the other.
--
-- `WhereTheTowerCanStillBeThree` Â§3 assumes `isSet T` alongside
-- POINTWISE path-stability along `t`.  That one is NOT redundant, and
-- the reason is exact: Hedberg's argument needs stability at ALL pairs
-- of the type, and stability along the image of a particular `t` does
-- not give it.  Strengthening the hypothesis to `Separated T` makes
-- `isSet T` derivable there too â” at the cost of assuming stability
-- where none was needed.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- SO THERE ARE TWO FORMS AND NEITHER DOMINATES
--
-- ààà¯à¾àà â” in the respect of path-stability demanded, the pointwise
--          form asks less: only the pairs `t` actually compares;
-- ààà¯à¾àà â” in the respect of hypothesis COUNT, the separated form asks
--          less: one hypothesis instead of two, since Hedberg supplies
--          the other.
--
-- These are two à¨à¯s and the collision between them is not a defect to
-- be resolved by picking one.  Aneknta licenses a collapse only where
-- there is agreement; here the two forms disagree about which
-- hypothesis is cheap, and a module that shipped only one of them
-- would be asserting a standpoint by denying the other.  Both are
-- proved below.
--
-- What is NOT said: that either form is better.  There is no scale
-- here on which to say it, and inventing one to rank them would be the
-- move this thread has been correcting all session.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   Â§1  the derivability chain, quoted from the library so the claim
--       is checkable at a glance rather than asserted;
--   Â§2  the Â§6 statement with `isSet T` DROPPED â” same conclusion,
--       one fewer hypothesis;
--   Â§3  the Â§3 statement in separated form, `isSet T` dropped, and the
--       pointwise form beside it with `isSet T` retained, so the two
--       nayas stand together;
--   Â§4  and the one thing that makes this a finding rather than a
--       tidy-up: `Discrete T` is strictly more than `isSet T` needs,
--       and Â§4 records what is NOT shown â” that no weaker hypothesis
--       than separatedness yields isSet.  Hedberg's argument is not
--       proved optimal here and nothing below claims it is.
--
------------------------------------------------------------------------

module HypothesesAssumedWhereTheyAreDerivable where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (Â¬_ ; Discrete ; Stable ; Separated)
open import Cubical.Relation.Nullary.Properties
  using (Discreteâ†’Separated ; Separatedâ†’isSet ; Discreteâ†’isSet)

open import FiniteInformation
  using (FiberConstant ; FactorsThrough
        ; fiberConstantâ†’factorsThrough ; factorsThroughâ†’fiberConstant)
open import ExclusionRecoversGroundAtAPrice
  using (CoExclude ; fiberConstant-transfer-stableTarget)
open import WhereTheTowerCanStillBeThree
  using (stableFiberConstant ; Stable-â†”)

private
  variable
    â„“x â„“y â„“y' â„“t : Level

------------------------------------------------------------------------
-- 1.  The chain, quoted rather than asserted
------------------------------------------------------------------------

discreteâ†’separated : {T : Type â„“t} â†’ Discrete T â†’ Separated T
discreteâ†’separated = Discreteâ†’Separated

separatedâ†’set : {T : Type â„“t} â†’ Separated T â†’ isSet T
separatedâ†’set = Separatedâ†’isSet

discreteâ†’set : {T : Type â„“t} â†’ Discrete T â†’ isSet T
discreteâ†’set = Discreteâ†’isSet

------------------------------------------------------------------------
-- 2.  The transfer theorem with `isSet T` dropped
--
-- Identical conclusion to `ExclusionRecoversGroundAtAPrice`
-- Â§6/Â§9, with the redundant hypothesis removed and Hedberg supplying
-- it from the one that remains.
------------------------------------------------------------------------

factorsThrough-transfer-discreteTargetâ€² :
  {X : Type â„“x} {Y : Type â„“y} {Y' : Type â„“y'} {T : Type â„“t}
  (discT : Discrete T)
  (q : X â†’ Y) (q' : X â†’ Y') (t : X â†’ T)
  â†’ CoExclude q q' â†’ FactorsThrough q t â†’ FactorsThrough q' t
factorsThrough-transfer-discreteTargetâ€² discT q q' t ce ft =
  fiberConstantâ†’factorsThrough (Discreteâ†’isSet discT) q' t
    (fiberConstant-transfer-stableTarget q q' t
      (Î» x x' â†’ Discreteâ†’Separated discT (t x) (t x'))
      ce (factorsThroughâ†’fiberConstant q t ft))

------------------------------------------------------------------------
-- 3.  The two nayas on stability of factoring, standing together
--
-- 3a asks less of the type and keeps `isSet T`.
-- 3b asks stability everywhere and derives `isSet T`.
-- Neither is an instance of the other.
------------------------------------------------------------------------

stableFactorsThrough-pointwise :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (isSetT : isSet T) (q : X â†’ Y) (t : X â†’ T)
  â†’ ((x x' : X) â†’ Stable (t x â‰¡ t x'))
  â†’ Stable (FactorsThrough q t)
stableFactorsThrough-pointwise isSetT q t st =
  Stable-â†” (fiberConstantâ†’factorsThrough isSetT q t)
           (factorsThroughâ†’fiberConstant q t)
           (stableFiberConstant q t st)

stableFactorsThrough-separated :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (sepT : Separated T) (q : X â†’ Y) (t : X â†’ T)
  â†’ Stable (FactorsThrough q t)
stableFactorsThrough-separated sepT q t =
  stableFactorsThrough-pointwise (Separatedâ†’isSet sepT) q t
    (Î» x x' â†’ sepT (t x) (t x'))

------------------------------------------------------------------------
-- 4.  What is not shown
--
-- Â§1 gives `Discrete â’ Separated â’ isSet`.  Nothing here shows the
-- converse of either step, nothing shows that separatedness is the
-- weakest hypothesis yielding `isSet`, and nothing shows that
-- pointwise stability along a single `t` fails to yield it.  Those are
-- three separate open statements and none is claimed in either
-- direction.  What IS established is only this: at two sites in this
-- thread a hypothesis was assumed that the site could derive, and one
-- of the two was genuinely redundant.
------------------------------------------------------------------------

-- recorded as an object so the redundancy cannot quietly return: the
-- old hypothesis is recoverable from the new one, at the same site.
redundantHypothesis :
  {T : Type â„“t} â†’ Discrete T â†’ isSet T
redundantHypothesis = Discreteâ†’isSet
