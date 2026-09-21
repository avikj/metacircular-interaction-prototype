{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- àà•à¾à—àà°-ààà°ààà â” the tower with one head.
--
-- A COMPATIBLE HISTORY IS A CHAIN OF SINGLETONS, SO THE TOWER IS ITS
-- TOP, AND THE AMBIENT PRODUCT OF READINGS COUNTS SOMETHING ELSE.
--
-- Given stages `O : â• â’ Type` and reductions `r n : O (suc n) â’ O n`,
-- there are two different objects that get called "the histories":
--
--   the AMBIENT PRODUCT   â” one reading chosen at each stage, with no
--                           equations imposed between them;
--   the COMPATIBLE TOWER  â” readings that agree under reduction.
--
-- They are not the same size, and the gap is exactly the equations.
-- This module proves the compatible side is equivalent to its top
-- stage alone:
--
--     (Î[ t âˆˆ O n ] Chain n t)  â‰  O n .
--
-- THE REASON IS THE FIBRE LAW, and that is the point of writing it this
-- way.  One rung of the tower is
--
--     Chain (suc n) t = Î[ p âˆˆ singl (r n t) ] Chain n (fst p) ,
--
-- and `singl (r n t)` â” the fibre of the IDENTITY at `r n t` â” is
-- contractible with NO hypothesis on anything (`isContrSingl`).  So each
-- rung contributes nothing once the rung above it is fixed: a compatible
-- past is not extra data, it is determined.  Binding the output is free;
-- that is the whole of Â§1, iterated `n` times.
--
--   Â§1  every chain is contractible, at every stage and every top
--   Â§2  hence the tower of compatible histories is its top stage
--
-- CONSEQUENCE FOR COUNTING, stated as the reason a product is the wrong
-- ambient object: the compatible histories over a top stage `O n` are
-- in bijection with `O n` itself â” not with the product of the stages
-- below it.  A cardinality computed from the product is counting
-- arbitrary reading records, before the compatibility equations are
-- imposed; the equations are precisely what `isContrSingl` then
-- collapses.
--
-- SYT â” THE CLAIM, EXACTLY.  Â§Â§1â“3 for any family of stages and any
-- reductions between them: no group structure, no finiteness, no
-- decidability, and no arithmetic.
------------------------------------------------------------------------

module EkagraSreni_ACompatibleHistoryIsAChainOfSinglesSoTheTowerContractsToItsTopAndTheAmbientProductOverCounts where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_â‰ƒ_)
open import Cubical.Foundations.HLevels using (isOfHLevelÎ£)
open import Cubical.Data.Nat using (â„• ; zero ; suc)
open import Cubical.Data.Sigma using (Î£-syntax ; _,_ ; fst ; Î£-contractSnd)
open import Cubical.Data.Unit using (Unit* ; isContrUnit*)

private
  variable
    â„“ : Level

module _ (O : â„• â†’ Type â„“) (r : (n : â„•) â†’ O (suc n) â†’ O n) where

  ------------------------------------------------------------------
  -- à¦ Â A compatible past below a given top.  Each rung records the
  --     stage below and the equation tying it to the stage above.
  ------------------------------------------------------------------

  Chain : (n : â„•) â†’ O n â†’ Type â„“
  Chain zero    _ = Unit*
  Chain (suc n) t = Î£[ p âˆˆ singl (r n t) ] Chain n (fst p)

  ------------------------------------------------------------------
  -- à§ Â EVERY COMPATIBLE PAST IS CONTRACTIBLE: there is exactly one,
  --     for each top, and it carries no information of its own.  The
  --     base of each rung is `singl`, contractible with no hypothesis;
  --     the fibre is the chain below, contractible by induction.
  ------------------------------------------------------------------

  Chain-isContr : (n : â„•) (t : O n) â†’ isContr (Chain n t)
  Chain-isContr zero    _ = isContrUnit*
  Chain-isContr (suc n) t =
    isOfHLevelÎ£ 0 (isContrSingl (r n t)) (Î» p â†’ Chain-isContr n (fst p))

  ------------------------------------------------------------------
  -- à¨ Â SO THE TOWER OF COMPATIBLE HISTORIES IS ITS TOP STAGE.
  ------------------------------------------------------------------

  Tower : â„• â†’ Type â„“
  Tower n = Î£[ t âˆˆ O n ] Chain n t

  tower-is-its-top : (n : â„•) â†’ Tower n â‰ƒ O n
  tower-is-its-top n = Î£-contractSnd (Chain-isContr n)
