{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- Chu(X,ð’¯,e) and the Advance guard.
--
--   Shrink(ð’¯) â’ Î´â“        ààà  ààà¨àà¯àµà•àà°àà¾ â‰  àààà¯
--   Î´ = 0 â Advance
--   Î´_Ï = 0 â Î´_Ï^base = 0   (à—àààà¯àµà•àà°àà¾: the base can be flat while the
--                             fibre is not, so a base-only test is not a test)
--
-- The defect of a Chu space is monotone in the test list: dropping tests can
-- only merge points.  Hence a vanishing defect is a statement about ð’¯, never
-- about X â” the empty test list makes every pair agree, and separation is the
-- side condition that keeps Î´ = 0 informative.

module NaturalMachine.ChuAdvance where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Nat using (â„• ; zero ; suc ; snotz)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Data.Sigma
open import Cubical.Data.List using (List ; [] ; _âˆ·_ ; _++_)
open import Cubical.Relation.Nullary using (Â¬_)

private
  BoolCode : Bool â†’ Typeâ‚€
  BoolCode true = Unit
  BoolCode false = âŠ¥

  trueâ‰¢false : Â¬ (true â‰¡ false)
  trueâ‰¢false p = subst BoolCode p tt

--------------------------------------------------------------------------
-- e : X — ð’¯ â’ Q,  and agreement on a finite test list
--------------------------------------------------------------------------

Obs : Typeâ‚€ â†’ Typeâ‚€ â†’ Typeâ‚€
Obs X T = X â†’ T â†’ Bool

Agree : {X T : Typeâ‚€} â†’ Obs X T â†’ List T â†’ X â†’ X â†’ Typeâ‚€
Agree e [] x y = Unit
Agree e (t âˆ· ts) x y = (e x t â‰¡ e y t) Ã— Agree e ts x y

Separates : {X T : Typeâ‚€} â†’ Obs X T â†’ List T â†’ Typeâ‚€
Separates {X} e ts = (x y : X) â†’ Agree e ts x y â†’ x â‰¡ y

--------------------------------------------------------------------------
-- Shrink(ð’¯) â’ Î´â“
--------------------------------------------------------------------------

-- Dropping tests never creates a distinction.
agree-drop :
    {X T : Typeâ‚€} (e : Obs X T) (ts ss : List T) (x y : X)
  â†’ Agree e (ts ++ ss) x y
  â†’ Agree e ts x y Ã— Agree e ss x y
agree-drop e [] ss x y a = tt , a
agree-drop e (t âˆ· ts) ss x y (p , a) =
  (p , fst (agree-drop e ts ss x y a)) , snd (agree-drop e ts ss x y a)

-- The extreme case: no tests, no defect, for any space whatever.
no-tests-no-defect :
    {X T : Typeâ‚€} (e : Obs X T) (x y : X) â†’ Agree e [] x y
no-tests-no-defect e x y = tt

--------------------------------------------------------------------------
-- ààà¨àà¯àµà•àà°àà¾ â‰  àààà¯
--------------------------------------------------------------------------

private
  read : Obs Bool Bool
  read x _ = x

-- A Chu space with Î´ = 0 on its declared tests whose points are not equal:
-- vanishing defect is a property of ð’¯, and Separates is what makes it a
-- property of X.
zero-defect-is-not-truth :
    Î£[ e âˆˆ Obs Bool Bool ] Î£[ ts âˆˆ List Bool ]
      (((x y : Bool) â†’ Agree e ts x y) Ã— (Â¬ Separates e ts))
zero-defect-is-not-truth = read , [] , (Î» x y â†’ tt) , Î» sep â†’ trueâ‰¢false (sep true false tt)

-- The same space separates as soon as one honest test is declared.
one-test-separates : Separates read (true âˆ· [])
one-test-separates x y (p , _) = p

--------------------------------------------------------------------------
-- à—àààà¯àµà•àà°àà¾ : Î´^base = 0 does not lift
--------------------------------------------------------------------------

Hol : Typeâ‚€
Hol = â„• Ã— â„•

unit : Hol
unit = 0 , 0

base : Hol â†’ â„•
base = fst

-- Ïð”_Ï = 1 âˆ§ ð”Ì_Ï â‰  1 : the base loop closes, the total loop does not.
hidden-curvature : Î£[ h âˆˆ Hol ] (base h â‰¡ base unit) Ã— (Â¬ (h â‰¡ unit))
hidden-curvature = (0 , 1) , refl , Î» p â†’ snotz (cong snd p)

-- CHECKED: Agda 2.6.3, cubical **v0.7** (/tmp/cubical), --cubical --safe,
-- 2026-08-15.  No postulates, no holes.  NOT verified against the pin in
-- formal/cubical/BUILD.md (Agda 2.8.0, cubical v0.9), nor against the v0.5
-- the rest of this lane's headers quote: three toolchain states are live in
-- this repository at once and this file has only seen one of them.
