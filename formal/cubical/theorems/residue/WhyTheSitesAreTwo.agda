{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WhyTheSitesAreTwo
--
-- The uniform 2 across this corpus is a fact about the DECODER SPACE, and here is the
-- theorem.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE STATEMENT
--
--     collisionFreeâ’notRefuting :
--       Discrete Y
--       â’ (no two points of the list collide with different values)
--       â’ Â Refutes (factorLaw q t) (xâ âˆ xs)
--
-- Contrapositively: over an UNCONSTRAINED decoder space `Image q â’ T`,
-- a list can only refute by containing a collision.  And a collision is
-- already a refuting pair (`WitnessNumberIsTwo` Â§4).  So no refuting
-- list is ever essentially longer than 2 â” the extra points are inert.
--
-- That is why every site in this corpus is 2, and it is not luck and
-- not a choice of examples: every one of them has a function space as
-- its decoders and a discrete Y (â•, Bool, lists of â•).  The three-way
-- example of `WitnessNumberIsUnbounded` escapes precisely because its
-- decoders are three atoms rather than all functions â” the survivor it
-- relies on is a function the unconstrained space would have contained.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- HOW IT GOES
--
-- If the list has no collision, build the decoder by table lookup:
-- walk the list, return the first entry whose observation matches.
-- Collision-freeness says every matching entry has the same value, so
-- the table is consistent; discreteness of Y is what lets the walk
-- compare observations at all.  Then the table answers every point of
-- the list, so the list does not refute.
--
-- Discreteness is the only hypothesis and it is doing real work â” it is
-- what makes "the first matching entry" a computation rather than a
-- choice.  Nothing is assumed about T beyond having the values the
-- table stores.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- FOR THE DEFLATIONARY READING
--
-- This is the strongest form of the deflation.  It is not that
-- the obstructions here happen to be cheap; over discrete observations
-- and unconstrained decoders they CANNOT be expensive.  Any barrier
-- stated in this shape is a two-point statement, and calling it a
-- barrier is the language exceeding the object â” now with a theorem
-- saying by how much, rather than a survey saying "so far".
------------------------------------------------------------------------

module WhyTheSitesAreTwo where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit* ; tt*)
open import Cubical.Data.Empty as Empty using (âŠ¥ ; âŠ¥*)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no ; Discrete)
open import Cubical.Functions.Image using (Image ; restrictToImage)

open import WitnessNumberIsTwo
  using (AllHold ; Refutes ; factorLaw ; collisionâ†’refutes)

private
  variable
    â„“x â„“y â„“t : Level

------------------------------------------------------------------------
-- 1.  Membership, level-polymorphic
------------------------------------------------------------------------

Mem : {A : Type â„“x} â†’ A â†’ List A â†’ Type â„“x
Mem x []       = âŠ¥*
Mem x (y âˆ· ys) = (x â‰¡ y) âŠŽ Mem x ys

------------------------------------------------------------------------
-- 2.  A list with no collision
------------------------------------------------------------------------

CollisionFree : {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
              â†’ (X â†’ Y) â†’ (X â†’ T) â†’ List X â†’ Type (â„“-max â„“x (â„“-max â„“y â„“t))
CollisionFree {X = X} q t ys =
  (a b : X) â†’ Mem a ys â†’ Mem b ys â†’ q a â‰¡ q b â†’ t a â‰¡ t b

------------------------------------------------------------------------
-- 3.  The table, and that it is correct on the list
------------------------------------------------------------------------

module _ {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
         (dY : Discrete Y) (q : X â†’ Y) (t : X â†’ T) (fb : T) where

  table : Y â†’ List X â†’ T
  table y []       = fb
  table y (x âˆ· xs) with dY (q x) y
  ... | yes _ = t x
  ... | no  _ = table y xs

  -- the walk returns the value of SOME matching entry; collision
  -- freeness makes that the value of the entry asked about
  table-correct :
    (ys : List X) â†’ CollisionFree q t ys
    â†’ (x : X) â†’ Mem x ys â†’ table (q x) ys â‰¡ t x
  table-correct []       cf x m = Empty.rec* m
  table-correct (y âˆ· ys) cf x m with dY (q y) (q x)
  ... | yes e = cf y x (inl refl) m e
  ... | no Â¬e = table-correct ys cf' x (later m)
    where
    cf' : CollisionFree q t ys
    cf' a b ma mb = cf a b (inr ma) (inr mb)

    later : Mem x (y âˆ· ys) â†’ Mem x ys
    later (inl xâ‰¡y) = Empty.rec (Â¬e (sym (cong q xâ‰¡y)))
    later (inr r)   = r

------------------------------------------------------------------------
-- 4.  THE THEOREM: without a collision, a list cannot refute
------------------------------------------------------------------------

module _ {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
         (dY : Discrete Y) (q : X â†’ Y) (t : X â†’ T) where

  collisionFreeâ†’notRefuting :
    (xâ‚€ : X) (xs : List X)
    â†’ CollisionFree q t (xâ‚€ âˆ· xs)
    â†’ Â¬ Refutes (factorLaw q t) (xâ‚€ âˆ· xs)
  collisionFreeâ†’notRefuting xâ‚€ xs cf ref =
    ref decode (holds (xâ‚€ âˆ· xs) (Î» _ m â†’ m))
    where
    decode : Image q â†’ T
    decode p = table dY q t (t xâ‚€) (fst p) (xâ‚€ âˆ· xs)

    holds : (ys : List X) â†’ ((x : X) â†’ Mem x ys â†’ Mem x (xâ‚€ âˆ· xs))
          â†’ AllHold (factorLaw q t) decode ys
    holds []       _   = tt*
    holds (y âˆ· ys) inc =
        table-correct dY q t (t xâ‚€) (xâ‚€ âˆ· xs) cf y (inc y (inl refl))
      , holds ys (Î» z m â†’ inc z (inr m))

------------------------------------------------------------------------
-- 5.  So a refuting list is never essentially longer than two
--
-- A list refutes only by containing a collision, and a collision is
-- already a refuting pair.  Stated as the contrapositive it is
-- constructive; stated as "extract the pair" it would not be, because
-- `Refutes` is a negation and Ââˆ does not give âˆÂ.  The theorem below
-- is the honest form: refutation and collision-freeness are
-- incompatible.
------------------------------------------------------------------------

  refuting-lists-collide :
    (xâ‚€ : X) (xs : List X)
    â†’ Refutes (factorLaw q t) (xâ‚€ âˆ· xs)
    â†’ Â¬ CollisionFree q t (xâ‚€ âˆ· xs)
  refuting-lists-collide xâ‚€ xs ref cf = collisionFreeâ†’notRefuting xâ‚€ xs cf ref

  -- and where the collision is in hand, two points are the whole list
  collision-is-enough :
    {x x' : X} â†’ q x â‰¡ q x' â†’ Â¬ (t x â‰¡ t x')
    â†’ Refutes (factorLaw q t) (x âˆ· x' âˆ· [])
  collision-is-enough = collisionâ†’refutes q t

------------------------------------------------------------------------
-- 6.  What this settles.
--
-- SETTLED.  The uniform 2 across this corpus is neither luck nor a
-- choice of examples.  Every site here has an unconstrained decoder
-- space `Image q â’ T` and a discrete Y, and under exactly those two
-- conditions a list refutes only by containing a collision â” so the
-- witness number is 2 whenever it is finite at all.
--
-- The three-way example of `WitnessNumberIsUnbounded` is consistent
-- with this and shows where the hypothesis bites: its decoders are
-- three atoms, not all functions, so the table this module builds is
-- not among them.  Constrain the decoders and the number can rise;
-- leave them unconstrained over discrete observations and it cannot.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 7.  DISCRETENESS CAN BE WEAKENED TO LOCATABILITY.
--
-- Discreteness of Y can be weakened, and `LocatingIsEnough` gives exactly
-- how far: this proof never compares two arbitrary observations.  It
-- compares the LIST'S observations against an incoming one, and there
-- are finitely many of those.  The hypothesis it consumes is
--
--     Locates q []       = Unit
--     Locates q (x âˆ xs) = ((y : Y) â’ Dec (q x â‰¡ y)) — Locates q xs
--
-- and `collisionFreeâ’notRefuting` above is the corollary at
-- `Discrete Y`, rederived there as `discrete-corollary`.
--
-- The shift is from an EQUALITY problem on the whole observation space
-- to a LOCATION problem on the witnesses: the decoder is handed an
-- observation and must find which listed point produced it.  That is
-- all it ever needed.  The measure was already local to the witnesses;
-- its hypothesis now is too.
--
-- So a site whose Y is not discrete is not automatically outside the
-- deflation â” only one whose witnesses cannot be located, which is a
-- smaller class and a checkable condition.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 8.  WHERE THE HYPOTHESIS FAILS: `SiteAudit`.
--
-- The ceiling needs discreteness or locatability.
-- `SiteAudit` enumerates the sites.  Two are not covered by this theorem:
--
--   * `Laghava` observes into `Denotation = â• â’ â•`, which is neither
--     discrete nor (as far as anything here shows) locatable â” so
--     neither this theorem nor `LocatingIsEnough` applies at the site
--     the whole à²à¾à˜àµ line is about;
--   * `AvaktavyaDoesNotFactor` has six atoms as its decoders, not a
--     function space.
--
-- Both are nonetheless exactly 2, proved individually â” `Laghava` in
-- `SiteAudit` Â§3, avaktavya in `WitnessNumberIsTwo` Â§5.
--
-- The distinction:
--
--   achievability (â‰ 2)  from an exhibited collision; no hypothesis;
--   the floor (â‰ 2)      from the constant decoder; needs only that the
--                        decoder space contain constants;
--   the CEILING          this theorem; needs discreteness or
--                        locatability, and is what fails at `Laghava`.
--
-- So "2 was never contingent here" holds at the discrete sites and not
-- at `Laghava`, where nothing rules out a costlier absence over
-- the same `eval`.
--
-- Also: two sites quantify over decoders on the WHOLE
-- codomain (`Denotation â’ â•`, `List Bool â’ Bool`) rather than over
-- `Image q â’ T`, so this theorem did not literally cover their shape.
-- `SiteAudit` Â§1 gives that variant, and it is simpler than this one.
------------------------------------------------------------------------
