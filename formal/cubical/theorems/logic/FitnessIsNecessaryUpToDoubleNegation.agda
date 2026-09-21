{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FitnessIsNecessaryUpToDoubleNegation
--
-- à¯à‹ à—àà¯à¾à¨ààà²ààà§à¿ (yogya-anupalabdhi) as a theorem, and â” the part that is
-- new â” its CONVERSE, which lands exactly where it must: the fitness
-- condition is necessary only up to double negation, and closing that
-- last gap is precisely the stability of the searched domain.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE SCHOOL, NAMED BEFORE ITS TERM, AND THE DISPUTE LEFT OPEN
--
-- àà¨ààà²ààà§à¿ â” non-apprehension as a means of knowing â” is admitted as a
-- separate prama by the Bha Mmsakas (Kumrila Bhaa,
-- *lokavrttika*, Abhvapariccheda, c. 7th c.) and by Advaita, and is
-- REFUSED as separate by the Prbhkaras, who fold it into perception.
-- The Naiyyikas differ again.  That dispute is live and nothing below
-- takes a side: the theorems are about the CONDITION both sides accept,
-- namely that an absence may be inferred only when the thing is such
-- that it WOULD have been apprehended had it been there.
--
-- `interactive/Yogyata.hs` states it, sources it, names the dispute, and applies
-- it to this repository's own import graph â” every inertness verdict
-- there carries the domain searched.  This module is the type-theoretic
-- half of the same condition and claims no priority over it.
--
-- SOURCING.  The attribution
-- above is carried from `interactive/Yogyata.hs`, which carries it from its
-- own sources.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHY THIS IS NOT A FIFTH RESTATEMENT OF THE Î/Â AXIS
--
-- Four modules here have now arrived independently at "the negative pole
-- is free, the positive pole is a search".  Four instances with nothing
-- computed downstream is four instances, and the standing discipline is
-- to compute something downstream or leave it alone.
--
-- Â§3 is that computation.  It says what the freeness of the negative
-- pole COSTS when the domain widens: exactly a fitness Î , and the
-- converse recovers that Î  only under ÂÂ â” so the residue is a
-- stability hypothesis on the domain, not on the thing sought.  That is
-- a consequence OF the pattern, not another sighting of it.
------------------------------------------------------------------------

module FitnessIsNecessaryUpToDoubleNegation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; trueâ‰¢false)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Relation.Nullary using (Â¬_)

private
  variable
    â„“ : Level

Stable : Type â„“ â†’ Type â„“
Stable A = Â¬ Â¬ A â†’ A

------------------------------------------------------------------------
-- 1.  An absence carries its domain, and fitness is what makes it
--     absolute
------------------------------------------------------------------------

-- the search: nothing IN THE DOMAIN bears P
AbsenceOn : {X : Type} (D P : X â†’ Type) â†’ Type
AbsenceOn {X} D P = (x : X) â†’ D x â†’ Â¬ P x

-- à¯à‹à—àà¯àà¾: anything bearing P would have been in the domain searched
Yogya : {X : Type} (D P : X â†’ Type) â†’ Type
Yogya {X} D P = (x : X) â†’ P x â†’ D x

-- à¯à‹ à—àà¯à¾à¨ààà²ààà§à¿: a FIT non-apprehension licenses the absolute absence
fitAbsenceIsAbsolute :
  {X : Type} (D P : X â†’ Type)
  â†’ Yogya D P â†’ AbsenceOn D P â†’ (x : X) â†’ Â¬ P x
fitAbsenceIsAbsolute D P fit abs x p = abs x (fit x p) p

------------------------------------------------------------------------
-- 2.  Without fitness the inference is unwarranted, exhibited
--
-- Domain = {false}, sought = being `true`.  The search over the domain
-- is clean, `P` is inhabited, and the domain-absence licenses nothing.
------------------------------------------------------------------------

Dom Sought : Bool â†’ Type
Dom    x = x â‰¡ false
Sought x = x â‰¡ true

cleanSearch : AbsenceOn Dom Sought
cleanSearch x dx px = trueâ‰¢false (sym px âˆ™ dx)

soughtIsThere : Î£[ x âˆˆ Bool ] Sought x
soughtIsThere = true , refl

searchWasNotFit : Â¬ Yogya Dom Sought
searchWasNotFit fit = trueâ‰¢false (fit true refl)

-- so a clean search plus an unfit domain gives a FALSE absence verdict
unfitAbsenceIsUnwarranted :
  (AbsenceOn Dom Sought) Ã— (Â¬ Yogya Dom Sought)
                         Ã— (Î£[ x âˆˆ Bool ] Sought x)
unfitAbsenceIsUnwarranted = cleanSearch , searchWasNotFit , soughtIsThere

------------------------------------------------------------------------
-- 3.  THE CONVERSE, and where it stops
--
-- Suppose a domain D is such that a clean search over it licenses the
-- absolute absence FOR EVERY sought property.  Then D is everything â”
-- but only under double negation.  Taking the sought property to be
-- `Â D` itself is what forces it, and that instance is exactly `ÂÂ`.
------------------------------------------------------------------------

fitnessIsNecessaryUpToDoubleNegation :
  {X : Type} (D : X â†’ Type)
  â†’ ((P : X â†’ Type) â†’ AbsenceOn D P â†’ ((x : X) â†’ Â¬ P x))
  â†’ (x : X) â†’ Â¬ Â¬ D x
fitnessIsNecessaryUpToDoubleNegation D licenses x =
  licenses (Î» y â†’ Â¬ D y) (Î» y dy ndy â†’ ndy dy) x

-- and the residue is a stability hypothesis on the DOMAIN â” not on the
-- thing sought, which is the asymmetry worth having
stableDomainMakesItTotal :
  {X : Type} (D : X â†’ Type)
  â†’ ((x : X) â†’ Stable (D x))
  â†’ ((P : X â†’ Type) â†’ AbsenceOn D P â†’ ((x : X) â†’ Â¬ P x))
  â†’ (x : X) â†’ D x
stableDomainMakesItTotal D stab licenses x =
  stab x (fitnessIsNecessaryUpToDoubleNegation D licenses x)

------------------------------------------------------------------------
-- 4.  What this says, and its exact scope
--
-- An absence is knowledge to the extent the looking was fit to find it
-- (Â§1), an unfit looking licenses a false verdict (Â§2), and a domain
-- that licenses every absence is total up to ÂÂ (Â§3).  The last gap â”
-- ÂÂ D x to D x â” is a stability hypothesis on the domain.
--
-- NOT a position in the Bha / Prbhkara dispute over whether
-- anupalabdhi is a separate prama.  Both sides accept the fitness
-- condition; only that is used.
------------------------------------------------------------------------
