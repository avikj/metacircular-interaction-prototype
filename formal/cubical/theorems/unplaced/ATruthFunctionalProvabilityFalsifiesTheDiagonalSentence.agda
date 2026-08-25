{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

module ATruthFunctionalProvabilityFalsifiesTheDiagonalSentence where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; true ; false ; not ; false≢true)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Relation.Nullary using (¬_)
open import ASmallTheoryWithAnIndependentSentence using (impB)

------------------------------------------------------------------------
-- ATruthFunctionalProvabilityFalsifiesTheDiagonalSentence
--
-- The open question from last cycle, answered on the negative side.
--
-- ────────────────────────────────────────────────────────────────────
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
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
-- Suppose the semantics interprets `prov` by some `f : Bool → Bool`
-- applied to the value of its argument — that is what "truth-
-- functional" means and it is what every valuation semantics in this
-- thread has done.  Suppose two soundness conditions the rules force:
--
--   HBL1 at the level of values:  `f true ≡ true`
--       (if `a` is true it must not make `prov a` false, since `a`
--        derivable forces `prov a` derivable);
--
--   the forward diagonal axiom `g → ¬ prov g` is valid:
--       `impB x (not (f x)) ≡ true`, where `x` is the value of `g`.
--
-- Then `x ≡ false`: the diagonal sentence is FALSE in every such model
-- (§1).  Hence `¬ g` is true in every such model (§2), so no model
-- refutes it, and the second premise of the two-model criterion is
-- unavailable at `g` (§3).  Independence of the diagonal sentence
-- cannot be obtained this way at all.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IT SAYS ABOUT WHERE THE DIFFICULTY ACTUALLY IS
--
-- The obstruction is not about which rules are chosen.  §1 uses only
-- the forward half of the diagonal and the value-level form of HBL1;
-- consistency, ω-consistency, contraposition, transitivity and the
-- backward half are all unused.  What it uses is that `prov` is
-- interpreted as a function of a TRUTH VALUE.
--
-- In a real theory it is not.  `Prov(⌜s⌝)` is a statement about the
-- syntax of `s`, and two sentences with the same truth value in a model
-- can have different provability status.  That is the exact property
-- this thread's semantics has been unable to express, and §1 is the
-- proof that no amount of rule-choosing repairs it while the
-- interpretation stays truth-functional.
--
-- ────────────────────────────────────────────────────────────────────
-- NOT CLAIMED
--
-- That independence of a diagonal sentence is impossible — only that
-- it is unobtainable from a truth-functional interpretation of `prov`
-- via the two-model criterion.  A semantics indexing provability by
-- syntax is not built here.
--
-- That `f true ≡ true` is the only value-level reading of HBL1; it is
-- the one forced if `prov` is truth-functional and derivable sentences
-- are true, and §1 assumes exactly it.
--
-- That the small theory of the previous module is affected: it has no
-- `prov` worth the name and its independence result stands untouched.
--
-- PRIOR ART, by the conclusion type — and the first draft of this
-- paragraph was wrong, which is why it is stated as a checked result.
-- A grep of `formal/cubical` for `truth-functional` returns ONE hit:
-- `RepresentabilityIsNotEnoughForIndependence` line 32, a sentence of
-- prose describing `wimp`, not a theorem.  A grep for `impB` outside
-- the previous module returns nothing.  A version phrased over a valuation into a larger algebra
-- than `Bool` would evade that grep — and would also evade §1, which
-- is a fact about two-valued semantics.
------------------------------------------------------------------------

------------------------------------------------------------------------
-- 1.  The diagonal sentence is false in every truth-functional model
------------------------------------------------------------------------

diagonalValueIsFalse :
  (f : Bool → Bool) (x : Bool)
  → f true ≡ true
  → impB x (not (f x)) ≡ true
  → x ≡ false
diagonalValueIsFalse f false _   _ = refl
diagonalValueIsFalse f true  hbl dfwd =
  Empty.rec (false≢true (sym (cong not hbl) ∙ dfwd))

------------------------------------------------------------------------
-- 2.  Hence its negation is true in every such model
------------------------------------------------------------------------

negDiagonalValueIsTrue :
  (f : Bool → Bool) (x : Bool)
  → f true ≡ true
  → impB x (not (f x)) ≡ true
  → not x ≡ true
negDiagonalValueIsTrue f x hbl dfwd =
  cong not (diagonalValueIsFalse f x hbl dfwd)

------------------------------------------------------------------------
-- 3.  So the second premise of the two-model criterion is unavailable
--
-- The criterion needs a model in which `¬ g` FAILS.  §2 says every
-- model of this kind makes `¬ g` hold, so no such model exists.
------------------------------------------------------------------------

noModelRefutesNegDiagonal :
  (f : Bool → Bool)
  → f true ≡ true
  → ¬ (Σ[ x ∈ Bool ] ((impB x (not (f x)) ≡ true) × (¬ (not x ≡ true))))
noModelRefutesNegDiagonal f hbl (x , dfwd , refuted) =
  refuted (negDiagonalValueIsTrue f x hbl dfwd)
