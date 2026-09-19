{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module TheRefutingModelAlreadyGivesTheFirstConjunct where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; falseâ‰¢true)
open import Cubical.Data.Empty as Empty using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_)
open import ASmallTheoryWithAnIndependentSentence using (impB)

------------------------------------------------------------------------
-- TheRefutingModelAlreadyGivesTheFirstConjunct
--
-- The syntax-indexed semantics, attempted â” and the second route to a
-- model-theoretic Gdel closes too, for a different reason from the
-- first.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT WAS TO BE TRIED
--
-- `ATruthFunctionalProvabilityFalsifiesTheDiagonalSentence` closes the
-- truth-functional route: if `prov` is interpreted as a function of the
-- truth value of its argument, the diagonal sentence is false in every
-- model, so no model refutes its negation and the two-model criterion
-- has nothing to work with.
--
-- The repair suggested there was a semantics indexed by SYNTAX: let a
-- model carry a predicate `P : S â’ Bool` on sentences and interpret
-- `prov a` as `P a`, consulting the syntax of `a` rather than its
-- value.  That is what a real theory does.  It is built below as a
-- parameter block, and the criterion still yields nothing â” but the
-- obstruction is completely different, and is worth having.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- WHAT IS PROVED
--
-- In such a model the two soundness conditions read
--
--   HBL1:            `Der a â’ P a â‰¡ true`
--   forward diagonal: `impB w (not (P gs)) â‰¡ true`, `w` the value of g
--
-- (the backward half is recorded but unused).  Â§1: if the model REFUTES
-- `Â g` â” that is, if `w â‰¡ true` â” then `P gs â‰¡ false`, and therefore
-- `Â Der gs` outright.
--
-- Four lines, and it is the whole result: the second model that the
-- criterion needs already contains the first conjunct of Gdel I.
-- Producing it is at least as hard as proving `T âŠ G`, so the criterion
-- does not supply that conjunct â” it presupposes it.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE TWO ROUTES, AND THAT THEY CLOSE DIFFERENTLY
--
-- ààà¯à¾àà â” in the respect of truth-functional interpretations, the
--          criterion fails because the needed model does not EXIST: the
--          diagonal sentence is false everywhere.
-- ààà¯à¾àà â” in the respect of syntax-indexed interpretations, the
--          criterion fails because the needed model is not INFORMATIVE:
--          it exists exactly when the conjunct it was meant to prove
--          already holds.
--
-- These are two different failures and neither reduces to the other.
-- Collapsing them into "the model-theoretic route fails" would state a
-- verdict both share while discarding the grounds, which differ.
--
-- What survives, and it is the shape of the actual theorem:
-- `GodelSeparation.goedelHalfOne` obtains the first conjunct
-- SYNTACTICALLY, from consistency, HBL1 and the fixed point, with no
-- model at all.  The second conjunct is not obtainable from those data
-- (`noHalfTwo`) and needs Ï‰-consistency.  Neither half is
-- model-theoretic, and Â§1 is the reason the first one cannot be.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- That no model-theoretic proof of independence exists anywhere.  The
-- statement is about this class of models, and specifically about
-- models in which HBL1 holds in the form `Der a â’ P a â‰¡ true`.  A model
-- validating HBL1 some other way would evade Â§1.
--
-- That a full syntax-indexed model is constructed here.  Â§1 is a
-- parameter block: it assumes the model's data and derives the
-- consequence.  No `S`, no `Der`, no `P` is built, and the theorem is
-- about any that are.
--
-- PRIOR ART, by the conclusion type, grep run and quoted: searching
-- `formal/cubical` for `hblSound`, `syntax-indexed`, `refutingModel`
-- and `â’ Â Der` returns nothing at all.  A version phrased with `P` as
-- a `Type`-valued predicate rather than `Bool`-valued would evade that
-- grep, and would also change Â§1, whose proof uses `falseâ‰true`.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1.  A model refuting the negation of the diagonal sentence already
--     witnesses that the diagonal sentence is underivable
------------------------------------------------------------------------

module _ (S : Typeâ‚€) (Der : S â†’ Typeâ‚€) (gs : S)
         (P : S â†’ Bool)
         (hblSound : (a : S) â†’ Der a â†’ P a â‰¡ true)
         (w : Bool)
         (dfwdSound : impB w (not (P gs)) â‰¡ true)
         where

  -- `w â‰¡ true` says the model does NOT satisfy `Â g`, which is exactly
  -- what the criterion's second premise asks for.
  refutingModelForcesUnmarked : w â‰¡ true â†’ P gs â‰¡ false
  refutingModelForcesUnmarked p =
    notInjective (sym (cong (Î» z â†’ impB z (not (P gs))) p) âˆ™ dfwdSound)
    where
    notInjective : not (P gs) â‰¡ true â†’ P gs â‰¡ false
    notInjective q with P gs
    ... | false = refl
    ... | true  = Empty.rec (falseâ‰¢true q)

  refutingModelGivesFirstConjunct : w â‰¡ true â†’ Â¬ Der gs
  refutingModelGivesFirstConjunct p d =
    falseâ‰¢true (sym (refutingModelForcesUnmarked p) âˆ™ hblSound gs d)
