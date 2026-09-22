{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- AscendingFirstIsTheWorstUnlessTheArchiveIsConstant
--
-- Seam 3 reads:
--
--   "The otherwise unreachable/programmatic `best` branch sorts accuracy
--    in ascending order and selects the first nodes, despite its comment
--    saying it selects the best score."
--
-- Stated that way it is a bug report.  What it is mathematically is a
-- statement about WHEN the two selections agree, and that is the thing
-- worth knowing, because it says when the seam is observable at all.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
--   lowerAndUpperForcesConstant
--       a score that is both a lower and an upper bound of the archive
--       forces EVERY score to equal it â” so "first of ascending" and
--       "best" coincide only on a constant archive
--   nonConstantMakesTheLowestStrictlyWorse
--       and as soon as one score differs from the lower bound, the
--       selection has passed over an element that is â‰ it and unequal
--   twoScoresAlreadySeparateThem
--       1 âˆ 2 âˆ [] : lower bound 1, upper bound 2, and Â (1 â‰¡ 2)
--   theSeamIsInvisibleExactlyWhereSelectionIsVacuous
--       the two halves packaged as the dichotomy they are
--
-- **The seam is invisible exactly where the selection is vacuous.**  On
-- a constant archive ascending-first and best return the same score â”
-- and on a constant archive, choosing a parent BY score carries no
-- information.  So there is no regime in which the branch is both
-- correct and doing work: it agrees with its comment only when the
-- comment describes nothing.  That is sharper than "the sort is
-- backwards", and it is why the seam is not cosmetic.
------------------------------------------------------------------------

module AscendingFirstIsTheWorstUnlessTheArchiveIsConstant where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; injSuc ; znots)
open import Cubical.Data.Nat.Order using (_â‰¤_ ; â‰¤-refl ; â‰¤-antisym ; â‰¤-suc)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_âŠŽ_ ; inl ; inr)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

------------------------------------------------------------------------
-- 1.  Bounds, as recursive families
------------------------------------------------------------------------

All : (P : â„• â†’ Type) â†’ List â„• â†’ Type
All P []       = Unit
All P (x âˆ· xs) = P x Ã— All P xs

Any : (P : â„• â†’ Type) â†’ List â„• â†’ Type
Any P []       = âŠ¥
Any P (x âˆ· xs) = P x âŠŽ Any P xs

Lower Upper : â„• â†’ List â„• â†’ Type
Lower b xs = All (b â‰¤_) xs
Upper b xs = All (_â‰¤ b) xs

------------------------------------------------------------------------
-- 2.  The two selections coincide only on a constant archive
------------------------------------------------------------------------

lowerAndUpperForcesConstant :
  (b : â„•) (xs : List â„•) â†’ Lower b xs â†’ Upper b xs â†’ All (_â‰¡ b) xs
lowerAndUpperForcesConstant b []       _          _          = tt
lowerAndUpperForcesConstant b (x âˆ· xs) (lo , los) (hi , his) =
  â‰¤-antisym hi lo , lowerAndUpperForcesConstant b xs los his

------------------------------------------------------------------------
-- 3.  And where it is not constant, the lowest is strictly passed over
------------------------------------------------------------------------

nonConstantMakesTheLowestStrictlyWorse :
  (b : â„•) (xs : List â„•) â†’ Lower b xs â†’ Any (Î» x â†’ Â¬ (b â‰¡ x)) xs
  â†’ Î£[ x âˆˆ â„• ] ((b â‰¤ x) Ã— (Â¬ (b â‰¡ x)))
nonConstantMakesTheLowestStrictlyWorse b []       _          e       = âŠ¥.rec e
nonConstantMakesTheLowestStrictlyWorse b (x âˆ· xs) (lo , _)   (inl ne) = x , (lo , ne)
nonConstantMakesTheLowestStrictlyWorse b (x âˆ· xs) (_  , los) (inr a)  =
  nonConstantMakesTheLowestStrictlyWorse b xs los a

------------------------------------------------------------------------
-- 4.  Two scores already separate them
------------------------------------------------------------------------

scores : List â„•
scores = 1 âˆ· 2 âˆ· []

lowestIsOne : Lower 1 scores
lowestIsOne = â‰¤-refl , (â‰¤-suc â‰¤-refl , tt)

bestIsTwo : Upper 2 scores
bestIsTwo = â‰¤-suc â‰¤-refl , (â‰¤-refl , tt)

oneIsNotTwo : Â¬ (1 â‰¡ 2)
oneIsNotTwo e = znots (injSuc e)

twoScoresAlreadySeparateThem :
  (Lower 1 scores) Ã— (Upper 2 scores) Ã— (Â¬ (1 â‰¡ 2))
twoScoresAlreadySeparateThem = lowestIsOne , bestIsTwo , oneIsNotTwo

------------------------------------------------------------------------
-- 5.  The dichotomy, packaged
------------------------------------------------------------------------

theSeamIsInvisibleExactlyWhereSelectionIsVacuous :
  (b : â„•) (xs : List â„•) â†’ Lower b xs
  â†’ (Upper b xs â†’ All (_â‰¡ b) xs)
  Ã— (Any (Î» x â†’ Â¬ (b â‰¡ x)) xs â†’ Î£[ x âˆˆ â„• ] ((b â‰¤ x) Ã— (Â¬ (b â‰¡ x))))
theSeamIsInvisibleExactlyWhereSelectionIsVacuous b xs lo =
    lowerAndUpperForcesConstant b xs lo
  , nonConstantMakesTheLowestStrictlyWorse b xs lo
