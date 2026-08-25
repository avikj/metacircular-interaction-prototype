{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module TheRefutingModelAlreadyGivesTheFirstConjunct where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; false≢true)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import ASmallTheoryWithAnIndependentSentence using (impB)

------------------------------------------------------------------------
-- TheRefutingModelAlreadyGivesTheFirstConjunct
--
-- The syntax-indexed semantics, attempted — and the second route to a
-- model-theoretic Gödel closes too, for a different reason from the
-- first.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT WAS TO BE TRIED
--
-- `ATruthFunctionalProvabilityFalsifiesTheDiagonalSentence` closes the
-- truth-functional route: if `prov` is interpreted as a function of the
-- truth value of its argument, the diagonal sentence is false in every
-- model, so no model refutes its negation and the two-model criterion
-- has nothing to work with.
--
-- The repair suggested there was a semantics indexed by SYNTAX: let a
-- model carry a predicate `P : S → Bool` on sentences and interpret
-- `prov a` as `P a`, consulting the syntax of `a` rather than its
-- value.  That is what a real theory does.  It is built below as a
-- parameter block, and the criterion still yields nothing — but the
-- obstruction is completely different, and is worth having.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
-- In such a model the two soundness conditions read
--
--   HBL1:            `Der a → P a ≡ true`
--   forward diagonal: `impB w (not (P gs)) ≡ true`, `w` the value of g
--
-- (the backward half is recorded but unused).  §1: if the model REFUTES
-- `¬ g` — that is, if `w ≡ true` — then `P gs ≡ false`, and therefore
-- `¬ Der gs` outright.
--
-- Four lines, and it is the whole result: the second model that the
-- criterion needs already contains the first conjunct of Gödel I.
-- Producing it is at least as hard as proving `T ⊬ G`, so the criterion
-- does not supply that conjunct — it presupposes it.
--
-- ────────────────────────────────────────────────────────────────────
-- THE TWO ROUTES, AND THAT THEY CLOSE DIFFERENTLY
--
-- स्यात् — in the respect of truth-functional interpretations, the
--          criterion fails because the needed model does not EXIST: the
--          diagonal sentence is false everywhere.
-- स्यात् — in the respect of syntax-indexed interpretations, the
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
-- (`noHalfTwo`) and needs ω-consistency.  Neither half is
-- model-theoretic, and §1 is the reason the first one cannot be.
--
-- ────────────────────────────────────────────────────────────────────
-- NOT CLAIMED
--
-- That syntax-indexed semantics is useless — §1 concerns one use of it,
-- supplying the first conjunct, and says nothing about the second.
--
-- That no model-theoretic proof of independence exists anywhere.  The
-- statement is about this class of models, and specifically about
-- models in which HBL1 holds in the form `Der a → P a ≡ true`.  A model
-- validating HBL1 some other way would evade §1.
--
-- That a full syntax-indexed model is constructed here.  §1 is a
-- parameter block: it assumes the model's data and derives the
-- consequence.  No `S`, no `Der`, no `P` is built, and the theorem is
-- about any that are.
--
-- PRIOR ART, by the conclusion type, grep run and quoted: searching
-- `formal/cubical` for `hblSound`, `syntax-indexed`, `refutingModel`
-- and `→ ¬ Der` returns nothing at all.  A version phrased with `P` as
-- a `Type`-valued predicate rather than `Bool`-valued would evade that
-- grep, and would also change §1, whose proof uses `false≢true`.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1.  A model refuting the negation of the diagonal sentence already
--     witnesses that the diagonal sentence is underivable
------------------------------------------------------------------------

module _ (S : Type₀) (Der : S → Type₀) (gs : S)
         (P : S → Bool)
         (hblSound : (a : S) → Der a → P a ≡ true)
         (w : Bool)
         (dfwdSound : impB w (not (P gs)) ≡ true)
         where

  -- `w ≡ true` says the model does NOT satisfy `¬ g`, which is exactly
  -- what the criterion's second premise asks for.
  refutingModelForcesUnmarked : w ≡ true → P gs ≡ false
  refutingModelForcesUnmarked p =
    notInjective (sym (cong (λ z → impB z (not (P gs))) p) ∙ dfwdSound)
    where
    notInjective : not (P gs) ≡ true → P gs ≡ false
    notInjective q with P gs
    ... | false = refl
    ... | true  = Empty.rec (false≢true q)

  refutingModelGivesFirstConjunct : w ≡ true → ¬ Der gs
  refutingModelGivesFirstConjunct p d =
    false≢true (sym (refutingModelForcesUnmarked p) ∙ hblSound gs d)
