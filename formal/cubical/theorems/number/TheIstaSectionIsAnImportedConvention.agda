{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module TheIstaSectionIsAnImportedConvention where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (â„¤ ; pos ; _Â·_ ; _+_ ; -_)
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Algebra.CommRing.Instances.Int using (â„¤CommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)
open import Kuttaka using (solutionFamily)

------------------------------------------------------------------------
-- TheIstaSectionIsAnImportedConvention
--
-- The one item `INDIC_FORMAL_TRADITIONS_MAP.md` Â§5.2 leaves open after its
-- 2026-08-18 DISCHARGED block, quoted from the note:
--
--     "Still NOT done, named there: only the ia least-non-negative
--      section (needs a mod/section convention)."
--
-- and from `formal/cubical/Kuttaka.agda`'s own header, line 47: the ia
-- section "needs a mod/section convention and is not supplied here."
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED, AND WHAT IS STILL NOT
--
-- Â§5.2(ii) asked for "the ia reduction as an explicitly IMPORTED
-- section".  Â§1 below takes that literally: a section is a PARAMETER â”
-- any function on the solution index that lands in the family â” and Â§2
-- proves that importing one costs nothing, since the reduced solution
-- still solves the equation.
--
-- That is the *convention* half, and it is the half
-- "the section is a declared convention".  Declared, not derived â” so the
-- honest formalisation makes it a parameter and proves the equation is
-- indifferent to it.
--
-- STILL NOT DONE, and narrowed rather than closed: the LEAST-NON-NEGATIVE
-- property.  Nothing below says the section lands in `[0, b)`; that needs
-- an order and a division algorithm on `â`, neither of which `Kuttaka`
-- carries.  So Â§5.2's remaining item is now two items, one discharged and
-- one open, and the open one is minimality, not the section.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- That the section is unique or canonical.  Â§1's type admits many
-- sections, and that multiplicity is the point: the equation does not pick
-- one.
--
-- PRIOR ART, grep run and quoted: `grep -rn "IstaSection\|ista\|ia"
-- formal/cubical/` returns only the two lines of `Kuttaka.agda`'s header
-- that name it as not done.  No section exists in the formal tree.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1.  A section, as an imported convention
--
-- `sec` moves a solution's x-component somewhere in the family: for each
-- `x` there is a shift `t` with `sec x â‰¡ x + t Â b`.  Nothing else is
-- required, and in particular no minimality.
------------------------------------------------------------------------

private
  shiftByZero : (x b : â„¤) â†’ x â‰¡ x + pos 0 Â· b
  shiftByZero x b = solve! â„¤CommRing

IstaSection : â„¤ â†’ Type
IstaSection b =
  Î£[ sec âˆˆ (â„¤ â†’ â„¤) ] ((x : â„¤) â†’ Î£[ t âˆˆ â„¤ ] (sec x â‰¡ x + t Â· b))

-- the trivial section: take the solution you were given.  Present so the
-- type is visibly inhabited and Â§2 is not vacuous.
identitySection : (b : â„¤) â†’ IstaSection b
identitySection b = (Î» x â†’ x) , (Î» x â†’ pos 0 , shiftByZero x b)

------------------------------------------------------------------------
-- 2.  Importing a section costs nothing: the reduced solution still solves
------------------------------------------------------------------------

sectionPreservesSolving :
  (a b g xâ‚€ yâ‚€ : â„¤) â†’ a Â· xâ‚€ + b Â· yâ‚€ â‰¡ g
  â†’ (S : IstaSection b)
  â†’ Î£[ y âˆˆ â„¤ ] (a Â· (fst S xâ‚€) + b Â· y â‰¡ g)
sectionPreservesSolving a b g xâ‚€ yâ‚€ sol (sec , wit) =
  (yâ‚€ + (- (t Â· a)))
  , cong (Î» z â†’ a Â· z + b Â· (yâ‚€ + (- (t Â· a)))) p
    âˆ™ solutionFamily a b g xâ‚€ yâ‚€ sol t
  where
  t : â„¤
  t = fst (wit xâ‚€)
  p : sec xâ‚€ â‰¡ xâ‚€ + t Â· b
  p = snd (wit xâ‚€)
