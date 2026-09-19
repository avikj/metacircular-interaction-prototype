{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module ATruthFunctionalProvabilityFalsifiesTheDiagonalSentence where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; falseâ‰¢true)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Data.Sigma using (Î£-syntax ; _Ã—_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (Â¬_)
open import ASmallTheoryWithAnIndependentSentence using (impB)

------------------------------------------------------------------------
-- ATruthFunctionalProvabilityFalsifiesTheDiagonalSentence
--
-- The open question from last cycle, answered on the negative side.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE QUESTION
--
-- `ASmallTheoryWithAnIndependentSentence` builds a theory with an
-- independent sentence by generating derivability from rules and
-- proving soundness for every Boolean valuation.  Its stated limit is
-- that the sentence is independent because the rules never mention it:
-- no diagonal, no provability predicate.  The question left open was
-- whether adding the diagonal machinery preserves independence.
--
-- With a TRUTH-FUNCTIONAL provability predicate, it does not, and the
-- reason is two lines.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
-- Suppose the semantics interprets `prov` by some `f : Bool â’ Bool`
-- applied to the value of its argument â” that is what "truth-
-- functional" means and it is what every valuation semantics in this
-- thread has done.  Suppose two soundness conditions the rules force:
--
--   HBL1 at the level of values:  `f true â‰¡ true`
--       (if `a` is true it must not make `prov a` false, since `a`
--        derivable forces `prov a` derivable);
--
--   the forward diagonal axiom `g â’ Â prov g` is valid:
--       `impB x (not (f x)) â‰¡ true`, where `x` is the value of `g`.
--
-- Then `x â‰¡ false`: the diagonal sentence is FALSE in every such model
-- (Â§1).  Hence `Â g` is true in every such model (Â§2), so no model
-- refutes it, and the second premise of the two-model criterion is
-- unavailable at `g` (Â§3).  Independence of the diagonal sentence
-- cannot be obtained this way at all.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IT SAYS ABOUT WHERE THE DIFFICULTY ACTUALLY IS
--
-- The obstruction is not about which rules are chosen.  Â§1 uses only
-- the forward half of the diagonal and the value-level form of HBL1;
-- consistency, Ï‰-consistency, contraposition, transitivity and the
-- backward half are all unused.  What it uses is that `prov` is
-- interpreted as a function of a TRUTH VALUE.
--
-- In a real theory it is not.  `Prov(âsâ)` is a statement about the
-- syntax of `s`, and two sentences with the same truth value in a model
-- can have different provability status.  That is the exact property
-- this thread's semantics has been unable to express, and Â§1 is the
-- proof that no amount of rule-choosing repairs it while the
-- interpretation stays truth-functional.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- That `f true â‰¡ true` is the only value-level reading of HBL1; it is
-- the one forced if `prov` is truth-functional and derivable sentences
-- are true, and Â§1 assumes exactly it.
--
-- That the small theory of the previous module is affected: it has no
-- `prov` worth the name and its independence result stands untouched.
--
-- PRIOR ART, by the conclusion type â” and the first draft of this
-- paragraph was wrong, which is why it is stated as a checked result.
-- A grep of `formal/cubical` for `truth-functional` returns ONE hit:
-- `RepresentabilityIsNotEnoughForIndependence` line 32, a sentence of
-- prose describing `wimp`, not a theorem.  A grep for `impB` outside
-- the previous module returns nothing.  A version phrased over a valuation into a larger algebra
-- than `Bool` would evade that grep â” and would also evade Â§1, which
-- is a fact about two-valued semantics.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1.  The diagonal sentence is false in every truth-functional model
------------------------------------------------------------------------

diagonalValueIsFalse :
  (f : Bool â†’ Bool) (x : Bool)
  â†’ f true â‰¡ true
  â†’ impB x (not (f x)) â‰¡ true
  â†’ x â‰¡ false
diagonalValueIsFalse f false _   _ = refl
diagonalValueIsFalse f true  hbl dfwd =
  Empty.rec (falseâ‰¢true (sym (cong not hbl) âˆ™ dfwd))

------------------------------------------------------------------------
-- 2.  Hence its negation is true in every such model
------------------------------------------------------------------------

negDiagonalValueIsTrue :
  (f : Bool â†’ Bool) (x : Bool)
  â†’ f true â‰¡ true
  â†’ impB x (not (f x)) â‰¡ true
  â†’ not x â‰¡ true
negDiagonalValueIsTrue f x hbl dfwd =
  cong not (diagonalValueIsFalse f x hbl dfwd)

------------------------------------------------------------------------
-- 3.  So the second premise of the two-model criterion is unavailable
--
-- The criterion needs a model in which `Â g` FAILS.  Â§2 says every
-- model of this kind makes `Â g` hold, so no such model exists.
------------------------------------------------------------------------

noModelRefutesNegDiagonal :
  (f : Bool â†’ Bool)
  â†’ f true â‰¡ true
  â†’ Â¬ (Î£[ x âˆˆ Bool ] ((impB x (not (f x)) â‰¡ true) Ã— (Â¬ (not x â‰¡ true))))
noModelRefutesNegDiagonal f hbl (x , dfwd , refuted) =
  refuted (negDiagonalValueIsTrue f x hbl dfwd)
