{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TheLeastRefutingListIsNotUniqueSoTheMeasureIsANumberAndNotACanonicalWitness
--
-- ON THE NAME.  **No tradition term is claimed and none is invented.**
-- The audited module belongs to the standing à²à¾à˜àµ (lghava) thread and
-- names its sites ààµà•àààµàà¯ (avaktavya â” Jaina) and àà¨ààµààààà¿ /
-- ààà°ààà¯à¾àà¾à° / àààµà¾à¦ (anuvtti / pratyhra / apavda â” Pinian);
-- **the school is named before the term**, as the naming rule requires.
-- This module touches none of that material â” its subject is whether a
-- minimiser is unique â” and **makes no claim whatever about avaktavya,
-- anuvtti, pratyhra or apavda.**  Checked before naming:
-- `.claude/hooks/priority-ledger.txt` (CURRENT header) and
-- first.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE ITEM.  At 78a82d16 I completed the range below 2 for
-- `WitnessNumberIsTwo`'s measure â” the least list of points on which no
-- decoder survives â” and left open, in my own words: *"is the least
-- refuting list UNIQUE at a site?"*
--
-- **It is not, and the counterexample is the site's own pair reversed.**
-- A collision is symmetric: `q x â‰¡ q x'` gives `q x' â‰¡ q x`, and
-- `Â (t x â‰¡ t x')` gives `Â (t x' â‰¡ t x)`.  So `collisionâ’refutes`
-- applies to `x' âˆ x âˆ []` exactly as it applies to `x âˆ x' âˆ []`, and
-- the two lists are distinct because the collision forces `x â‰ x'`.
--
-- WHAT IS PROVED
--
--   theReversedPairAlsoRefutes   the same collision, read the other way
--   theTwoPointsDiffer           `x â‰ x'`, from `differ` by `cong t` â”
--                                the hypothesis that makes it a
--                                collision is exactly what separates
--                                the points
--   theTwoListsDiffer            hence the two refuting lists are not
--                                equal, by `cong (hd x)`
--   theLeastRefutingListIsNotUnique
--                                all three together: two distinct lists,
--                                both refuting, both of length 2, which
--                                78a82d16 and `singleton-never-refutes`
--                                show is least
--
-- **WHAT THIS SETTLES ABOUT THE MEASURE, AND IT IS THE POINT.**
-- `WitnessNumberIsInvariant` records that this thread found "a measure
-- that DOES survive" where `size` did not.  It survives as a **NUMBER**.
-- The minimiser is not canonical, so there is no such thing as *the*
-- least refuting list to transport, quotient by, or read a further
-- invariant off â” only its length.  That is not a defect: a measure is
-- allowed to be a number.  It does mean any future construction that
-- says "take the least refuting list" is under-specified, and the
-- audited line does not make that mistake anywhere I have read.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 â” NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module TheLeastRefutingListIsNotUniqueSoTheMeasureIsANumberAndNotACanonicalWitness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Relation.Nullary using (Â¬_)

open import WitnessNumberIsTwo
  using (Refutes ; factorLaw ; collisionâ†’refutes ; singleton-never-refutes)

private
  variable
    â„“x â„“y â„“t : Level

------------------------------------------------------------------------
-- 1.  A head with a default â” the only list surgery needed
------------------------------------------------------------------------

hd : {â„“ : Level} {A : Type â„“} â†’ A â†’ List A â†’ A
hd d []      = d
hd _ (a âˆ· _) = a

------------------------------------------------------------------------
-- 2.  The reversed pair refutes just as well, and is a different list
------------------------------------------------------------------------

module _ {X : Type â„“x} {Y : Type â„“y} {T : Type â„“t}
         (q : X â†’ Y) (t : X â†’ T) {x x' : X}
         (same : q x â‰¡ q x') (differ : Â¬ (t x â‰¡ t x'))
  where

  theReversedPairAlsoRefutes : Refutes (factorLaw q t) (x' âˆ· x âˆ· [])
  theReversedPairAlsoRefutes =
    collisionâ†’refutes q t (sym same) (Î» p â†’ differ (sym p))

  theTwoPointsDiffer : Â¬ (x â‰¡ x')
  theTwoPointsDiffer p = differ (cong t p)

  theTwoListsDiffer : Â¬ ((x âˆ· x' âˆ· []) â‰¡ (x' âˆ· x âˆ· []))
  theTwoListsDiffer p = theTwoPointsDiffer (cong (hd x) p)

  ----------------------------------------------------------------------
  -- 3.  So the minimiser is not canonical
  ----------------------------------------------------------------------

  theLeastRefutingListIsNotUnique :
      Refutes (factorLaw q t) (x âˆ· x' âˆ· [])
    Ã— Refutes (factorLaw q t) (x' âˆ· x âˆ· [])
    Ã— (Â¬ ((x âˆ· x' âˆ· []) â‰¡ (x' âˆ· x âˆ· [])))
    Ã— ((z : X) â†’ Â¬ Refutes (factorLaw q t) (z âˆ· []))
  theLeastRefutingListIsNotUnique =
      collisionâ†’refutes q t same differ
    , theReversedPairAlsoRefutes
    , theTwoListsDiffer
    , singleton-never-refutes q t
