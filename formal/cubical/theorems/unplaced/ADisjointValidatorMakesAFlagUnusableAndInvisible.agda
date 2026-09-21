{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ADisjointValidatorMakesAFlagUnusableAndInvisible
--
--
--   "The command-line `choices` list contains adjacent string literals
--    `'score_child_prop' 'best'`, which Python concatenates.  The
--    default still reaches the score/child branch because `argparse`
--    does not reject the untyped default, but explicitly supplying
--    `score_child_prop` or `best` is rejected, while the accidental
--    `score_child_propbest` value falls through to random selection."
--
-- Seams 1 and 3 have the SAME SHAPE â”
-- a defect undetectable exactly where it is harmless â” and said that
-- shape is a property of the SECTION.  Seam 2 has the same
-- shape, and this is its statement.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED, for tokens with decidable equality
--
--   Accepted / Intended       membership in the validator's list and in
--                             the list of options a user means to pass
--   disjointRejectsEveryIntended
--                             if the two lists share nothing, every
--                             intended token is rejected
--   theAcceptedTokenIsNotIntended
--                             and the one token the validator accepts
--                             is not one anybody meant to write
--   concatenationIsDisjoint   the concrete instance: accepted = the
--                             concatenation alone, intended = the two
--                             literals, and the two share nothing
--   theSeamIsInvisibleWhileNobodySuppliesTheFlag
--                             so a run that never supplies the flag
--                             observes nothing
--
-- **Third instance of the section's shape.**  The
-- defect is invisible exactly to runs using the default, which is every
-- run until someone passes the flag explicitly â” at which point the
-- flag is not merely wrong but UNUSABLE, since no intended spelling is
-- accepted and the only accepted spelling is one nobody would write.
-- Seams 1, 2 and 3 are three instances of "undetectable exactly
-- where harmless", and that is a fact about Â§2 rather than three
-- coincidences.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- NO NOVELTY.  Disjointness implies rejection; this is a triviality.
-- It is written because the seam reads as a typo, and a typo whose
-- consequence is "the flag cannot be used at all, and no one will
-- notice" deserves the consequence stated.
------------------------------------------------------------------------

module ADisjointValidatorMakesAFlagUnusableAndInvisible where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (â„• ; zero ; suc ; snotz ; znots ; injSuc)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma using (_Ã—_ ; _,_)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Empty as âŠ¥ using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any)

------------------------------------------------------------------------
-- 1.  Membership, and what disjointness costs a user
------------------------------------------------------------------------

Mem : â„• â†’ List â„• â†’ Type
Mem t xs = Any (Î» y â†’ y â‰¡ t) xs

disjointRejectsEveryIntended :
  (accepted intended : List â„•)
  â†’ ((t : â„•) â†’ Mem t intended â†’ Â¬ Mem t accepted)
  â†’ (t : â„•) â†’ Mem t intended â†’ Â¬ Mem t accepted
disjointRejectsEveryIntended accepted intended dis = dis

------------------------------------------------------------------------
-- 2.  The instance: two literals meant, their concatenation accepted
--
-- 0 stands for `score_child_prop`, 1 for `best`, 2 for the
-- concatenation `score_child_propbest`.  No strings are modelled; the
-- only fact used is that the three are distinct.
------------------------------------------------------------------------

accepted intended : List â„•
accepted = 2 âˆ· []
intended = 0 âˆ· 1 âˆ· []

Â¬0â‰¡2 : Â¬ (0 â‰¡ 2)
Â¬0â‰¡2 e = znots e

Â¬1â‰¡2 : Â¬ (1 â‰¡ 2)
Â¬1â‰¡2 e = znots (injSuc e)

Â¬2â‰¡0 : Â¬ (2 â‰¡ 0)
Â¬2â‰¡0 e = snotz e

Â¬2â‰¡1 : Â¬ (2 â‰¡ 1)
Â¬2â‰¡1 e = snotz (injSuc e)

concatenationIsDisjoint :
  (t : â„•) â†’ Mem t intended â†’ Â¬ Mem t accepted
concatenationIsDisjoint t (inl e0) (inl e2) = Â¬0â‰¡2 (e0 âˆ™ sym e2)
concatenationIsDisjoint t (inl e0) (inr ())
concatenationIsDisjoint t (inr (inl e1)) (inl e2) = Â¬1â‰¡2 (e1 âˆ™ sym e2)
concatenationIsDisjoint t (inr (inl e1)) (inr ())
concatenationIsDisjoint t (inr (inr ())) _

theAcceptedTokenIsNotIntended : Â¬ Mem 2 intended
theAcceptedTokenIsNotIntended (inl e)       = Â¬2â‰¡0 (sym e)
theAcceptedTokenIsNotIntended (inr (inl e)) = Â¬2â‰¡1 (sym e)
theAcceptedTokenIsNotIntended (inr (inr ()))

------------------------------------------------------------------------
-- 3.  So the flag is unusable, and unusable invisibly
------------------------------------------------------------------------

theFlagIsUnusable :
    ((t : â„•) â†’ Mem t intended â†’ Â¬ Mem t accepted)
  Ã— (Â¬ Mem 2 intended)
theFlagIsUnusable = concatenationIsDisjoint , theAcceptedTokenIsNotIntended

-- a run that never supplies the flag never meets the validator at all,
-- so no member of `intended` is ever tested: the seam is invisible
theSeamIsInvisibleWhileNobodySuppliesTheFlag :
  (supplied : List â„•)
  â†’ ((t : â„•) â†’ Â¬ Mem t supplied)
  â†’ (t : â„•) â†’ Mem t supplied â†’ Â¬ Mem t accepted
theSeamIsInvisibleWhileNobodySuppliesTheFlag supplied none t m =
  âŠ¥.rec (none t m)
