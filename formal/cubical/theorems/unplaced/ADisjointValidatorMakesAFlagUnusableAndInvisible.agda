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
-- The previous cycle observed that seams 1 and 3 have the SAME SHAPE —
-- a defect undetectable exactly where it is harmless — and said that
-- shape is a property of the SECTION, so the remaining seams should be
-- checked against it FIRST.  Doing that here: seam 2 has the same
-- shape, and this is its statement rather than its restatement.
--
-- ────────────────────────────────────────────────────────────────────
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
-- **Third instance of the section's shape, and it was predicted.**  The
-- defect is invisible exactly to runs using the default, which is every
-- run until someone passes the flag explicitly — at which point the
-- flag is not merely wrong but UNUSABLE, since no intended spelling is
-- accepted and the only accepted spelling is one nobody would write.
-- Seams 1, 2 and 3 are now three instances of "undetectable exactly
-- where harmless", and that is a fact about §2 rather than three
-- coincidences.
--
-- ────────────────────────────────────────────────────────────────────
-- GRADE, unchanged: **I DID NOT READ THE CODE, and this seam is about
-- PYTHON'S SEMANTICS.**  No request to github.com was made, and no
-- claim is made here about what `argparse` does, what Python's
-- adjacent-literal concatenation does, or what the pinned file
-- contains.  What is modelled is the SITUATION §2 describes — a
-- validator whose accepted set is disjoint from the intended set — and
-- the theorems are about that situation.  If §2 misread the code, the
-- situation simply does not arise and nothing here is affected.
--
-- NO NOVELTY.  Disjointness implies rejection; this is a triviality.
-- It is written because the seam reads as a typo, and a typo whose
-- consequence is "the flag cannot be used at all, and no one will
-- notice" deserves the consequence stated.
--
-- SYĀT — THE CLAIM, EXACTLY.  Tokens are ℕ, standing for strings; no string
-- type, no concatenation operation and no Python is modelled, so
-- `concatenationIsDisjoint` is an ASSUMPTION about the instance encoded
-- as three distinct numerals, not a derivation from concatenation.
-- Nothing is said about what the fall-through branch DOES — §2 says it
-- reaches random selection, and no semantics of selection appears here.
-- Nothing is said about the default's own value: §2's point that
-- `argparse` does not reject an untyped default is about validation
-- being skipped, and skipping is not modelled either.
--
-- SEAM 4 IS NOT TOUCHED, AND HERE IS WHY.  It reports that the prose
-- says the selected parent analyses its own logs while the appendix and
-- code say a separate diagnostic call reads them.  That is a
-- discrepancy about WHICH AGENT PERFORMS A STEP — an attribution of an
-- action, not a relation between values — and nothing in §2 turns it
-- into a claim with a truth condition this substrate can carry.  Saying
-- so with a reason is the honest closure; inventing a formalisation
-- would be the dishonest one.
--
-- CHECKED on the CONTAINER (Agda 2.6.3, cubical v0.5 — NOT the declared
-- pin, Agda 2.8.0 + cubical v0.9).  --safe, no postulates, no holes.
------------------------------------------------------------------------

module ADisjointValidatorMakesAFlagUnusableAndInvisible where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; snotz ; znots ; injSuc)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Sum using (inl ; inr)
open import Cubical.Data.Empty as ⊥ using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import KramaAstiNasti_TheFourthCornerCannotLiveOverAnEnumerableDecidableInstanceSet
  using (Any)

------------------------------------------------------------------------
-- 1.  Membership, and what disjointness costs a user
------------------------------------------------------------------------

Mem : ℕ → List ℕ → Type
Mem t xs = Any (λ y → y ≡ t) xs

disjointRejectsEveryIntended :
  (accepted intended : List ℕ)
  → ((t : ℕ) → Mem t intended → ¬ Mem t accepted)
  → (t : ℕ) → Mem t intended → ¬ Mem t accepted
disjointRejectsEveryIntended accepted intended dis = dis

------------------------------------------------------------------------
-- 2.  The instance: two literals meant, their concatenation accepted
--
-- 0 stands for `score_child_prop`, 1 for `best`, 2 for the
-- concatenation `score_child_propbest`.  No strings are modelled; the
-- only fact used is that the three are distinct.
------------------------------------------------------------------------

accepted intended : List ℕ
accepted = 2 ∷ []
intended = 0 ∷ 1 ∷ []

¬0≡2 : ¬ (0 ≡ 2)
¬0≡2 e = znots e

¬1≡2 : ¬ (1 ≡ 2)
¬1≡2 e = znots (injSuc e)

¬2≡0 : ¬ (2 ≡ 0)
¬2≡0 e = snotz e

¬2≡1 : ¬ (2 ≡ 1)
¬2≡1 e = snotz (injSuc e)

concatenationIsDisjoint :
  (t : ℕ) → Mem t intended → ¬ Mem t accepted
concatenationIsDisjoint t (inl e0) (inl e2) = ¬0≡2 (e0 ∙ sym e2)
concatenationIsDisjoint t (inl e0) (inr ())
concatenationIsDisjoint t (inr (inl e1)) (inl e2) = ¬1≡2 (e1 ∙ sym e2)
concatenationIsDisjoint t (inr (inl e1)) (inr ())
concatenationIsDisjoint t (inr (inr ())) _

theAcceptedTokenIsNotIntended : ¬ Mem 2 intended
theAcceptedTokenIsNotIntended (inl e)       = ¬2≡0 (sym e)
theAcceptedTokenIsNotIntended (inr (inl e)) = ¬2≡1 (sym e)
theAcceptedTokenIsNotIntended (inr (inr ()))

------------------------------------------------------------------------
-- 3.  So the flag is unusable, and unusable invisibly
------------------------------------------------------------------------

theFlagIsUnusable :
    ((t : ℕ) → Mem t intended → ¬ Mem t accepted)
  × (¬ Mem 2 intended)
theFlagIsUnusable = concatenationIsDisjoint , theAcceptedTokenIsNotIntended

-- a run that never supplies the flag never meets the validator at all,
-- so no member of `intended` is ever tested: the seam is invisible
theSeamIsInvisibleWhileNobodySuppliesTheFlag :
  (supplied : List ℕ)
  → ((t : ℕ) → ¬ Mem t supplied)
  → (t : ℕ) → Mem t supplied → ¬ Mem t accepted
theSeamIsInvisibleWhileNobodySuppliesTheFlag supplied none t m =
  ⊥.rec (none t m)
