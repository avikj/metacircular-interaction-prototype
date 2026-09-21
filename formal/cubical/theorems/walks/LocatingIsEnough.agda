{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- LocatingIsEnough
--
-- `WhyTheSitesAreTwo` Â§6 asks whether discreteness of Y can be weakened.
--
-- It can, and this is exactly how far.  The theorem never compares two
-- arbitrary observations.  It compares the LIST'S observations against
-- an incoming one, and there are only finitely many of those.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE HYPOTHESIS THE PROOF ACTUALLY USES
--
--     Locates q []       = Unit
--     Locates q (x âˆ xs) = ((y : Y) â’ Dec (q x â‰¡ y)) — Locates q xs
--
-- "each listed point's observation is decidable against an arbitrary
-- one".  `Discrete Y` gives this for every list (Â§4) and is strictly
-- more than needed: it decides equality of any two observations
-- whatever, including the ones the walk never looks at.
--
--     locatingFreeâ’notRefuting :
--       Locates q (xâ âˆ xs) â’ CollisionFree q t (xâ âˆ xs)
--       â’ Â Refutes (factorLaw q t) (xâ âˆ xs)
--
-- and `WhyTheSitesAreTwo.collisionFreeâ’notRefuting` is the corollary at
-- `Discrete Y`.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHY THE WEAKENING IS THE RIGHT ONE, NOT MERELY A WEAKER ONE
--
-- Because it is the hypothesis of a LOCATION problem rather than of an
-- equality problem.  The decoder is handed an observation and must find
-- which listed point produced it â” that is all it ever needs, and it is
-- what `Locates` says is possible.  Deciding equality throughout Y is a
-- statement about the whole observation space; deciding location is a
-- statement about the finitely many points the absence is witnessed at.
--
-- The measure was already local to the witnesses (`WitnessNumberIsTwo`).
-- This makes its hypothesis local too, which is the natural place for
-- it to have been.
------------------------------------------------------------------------

module LocatingIsEnough where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Empty as Empty using (âŠ¥ ; âŠ¥*)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no ; Discrete)
open import Cubical.Functions.Image using (Image ; restrictToImage)

open import WitnessNumberIsTwo
  using (AllHold ; Refutes ; factorLaw)
open import WhyTheSitesAreTwo using (Mem ; CollisionFree)

private
  variable
    â„“x â„“y â„“t : Level

------------------------------------------------------------------------
-- 1.  Locating a listed observation, as a recursive family
------------------------------------------------------------------------

Locates : {X : Type â„“x} {Y : Type â„“y} â†’ (X â†’ Y) â†’ List X â†’ Type (â„“-max â„“x â„“y)
Locates {Y = Y} q []       = Unit*
Locates {Y = Y} q (x âˆ· xs) = ((y : Y) â†’ Dec (q x â‰¡ y)) Ã— Locates q xs

------------------------------------------------------------------------
-- 2.  The table, now walking with its own decisions
------------------------------------------------------------------------

module _ {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
         (q : X â†’ Y) (t : X â†’ T) (fb : T) where

  table : (ys : List X) â†’ Locates q ys â†’ Y â†’ T
  table []       _        y = fb
  table (x âˆ· xs) (d , ds) y with d y
  ... | yes _ = t x
  ... | no  _ = table xs ds y

  table-correct :
    (ys : List X) (loc : Locates q ys) â†’ CollisionFree q t ys
    â†’ (x : X) â†’ Mem x ys â†’ table ys loc (q x) â‰¡ t x
  table-correct []       _        cf x m = Empty.rec* m
  table-correct (y âˆ· ys) (d , ds) cf x m with d (q x)
  ... | yes e = cf y x (inl refl) m e
  ... | no Â¬e = table-correct ys ds cf' x (later m)
    where
    cf' : CollisionFree q t ys
    cf' a b ma mb = cf a b (inr ma) (inr mb)

    later : Mem x (y âˆ· ys) â†’ Mem x ys
    later (inl xâ‰¡y) = Empty.rec (Â¬e (sym (cong q xâ‰¡y)))
    later (inr r)   = r

------------------------------------------------------------------------
-- 3.  THE THEOREM, under the located hypothesis
------------------------------------------------------------------------

module _ {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
         (q : X â†’ Y) (t : X â†’ T) where

  locatingFreeâ†’notRefuting :
    (xâ‚€ : X) (xs : List X)
    â†’ Locates q (xâ‚€ âˆ· xs)
    â†’ CollisionFree q t (xâ‚€ âˆ· xs)
    â†’ Â¬ Refutes (factorLaw q t) (xâ‚€ âˆ· xs)
  locatingFreeâ†’notRefuting xâ‚€ xs loc cf ref =
    ref decode (holds (xâ‚€ âˆ· xs) (Î» _ m â†’ m))
    where
    decode : Image q â†’ T
    decode p = table q t (t xâ‚€) (xâ‚€ âˆ· xs) loc (fst p)

    holds : (ys : List X) â†’ ((x : X) â†’ Mem x ys â†’ Mem x (xâ‚€ âˆ· xs))
          â†’ AllHold (factorLaw q t) decode ys
    holds []       _   = tt*
    holds (y âˆ· ys) inc =
        table-correct q t (t xâ‚€) (xâ‚€ âˆ· xs) loc cf y (inc y (inl refl))
      , holds ys (Î» z m â†’ inc z (inr m))

------------------------------------------------------------------------
-- 4.  `Discrete Y` is the special case
------------------------------------------------------------------------

discreteâ†’locates :
  {X : Type â„“x} {Y : Type â„“y} (dY : Discrete Y) (q : X â†’ Y)
  â†’ (ys : List X) â†’ Locates q ys
discreteâ†’locates dY q []       = tt*
discreteâ†’locates dY q (x âˆ· xs) = (Î» y â†’ dY (q x) y) , discreteâ†’locates dY q xs

-- `WhyTheSitesAreTwo.collisionFreeâ’notRefuting`, rederived
discrete-corollary :
  {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
  (dY : Discrete Y) (q : X â†’ Y) (t : X â†’ T)
  (xâ‚€ : X) (xs : List X)
  â†’ CollisionFree q t (xâ‚€ âˆ· xs)
  â†’ Â¬ Refutes (factorLaw q t) (xâ‚€ âˆ· xs)
discrete-corollary dY q t xâ‚€ xs =
  locatingFreeâ†’notRefuting q t xâ‚€ xs (discreteâ†’locates dY q (xâ‚€ âˆ· xs))

------------------------------------------------------------------------
-- 5.  What moved.
--
-- The ceiling theorem no longer asks anything about the observation
-- space as a whole.  It asks that the finitely many observations the
-- absence is witnessed at can be recognised â” a location problem, not
-- an equality problem â” and under exactly that, a list still refutes
-- only by containing a collision, so the witness number is still 2.
--
-- A site whose Y is not discrete is therefore not automatically outside
-- the deflation.  It is outside only if its witnesses cannot be
-- located, which is a much smaller class and a checkable condition.
------------------------------------------------------------------------
