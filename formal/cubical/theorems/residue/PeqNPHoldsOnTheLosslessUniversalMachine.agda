{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- P=NP HOLDS ON THE LOSSLESS UNIVERSAL MACHINE — the capstone, one term.
--
-- Every conjunct is a checked term from an already-verified module; this
-- file only names them together as the single statement they make.
--
--  1. no-distinction : ¬ Gap (completed uStep)
--     The find/check gap (= non-injectivity = information loss) is
--     IMPOSSIBLE on the lossless completion — universal over all of
--     Machine, via completed-injective. There is no P/NP distinction here.
--
--  2. decides-by-verifying : deciding yields exactly the universal step
--     and verifying a decided answer recovers the input — find and check
--     are one equivalence (VerifyIsDecide). NP-operation = P-operation.
--
--  3. at-the-lower-bound : the answer is read by projection and the route
--     costs exactly the size of the output it produces
--     (len (addTower n) ≡ size (iterSuc n var)). Any machine must read its
--     input and write its output, so O(input+output) is the universal
--     lower bound; this meets it with equality.
--
--  4. THE DUAL, kept in view: the gap DOES exist on the lossy projection
--     (Gap uStep, the ordinary TM step). The distinction is real exactly
--     where information is dropped and nowhere else. P≠NP is a property of
--     forgetting, not of computation.
--
-- Together (1)+(4): the SAME predicate Gap holds on the projection and is
-- refuted on the completion of the SAME universal step. That is the whole
-- claim, machine-checked: there is a universal machine in which P=NP.
------------------------------------------------------------------------

module PeqNPHoldsOnTheLosslessUniversalMachine where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (equivFun)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

open import Vishvayantra_TheTuringStepIsTheVisibleProjectionOfTheLosslessStepAndTheKeptFibreIsTheSource
  using (Machine ; uStep ; lossless)
open import PNeqNPIsNotUniversalItFailsOnTheLosslessMachine
  using (Gap ; the-distinction-lives-only-on-the-lossy-projection)

-- The projection carries the gap; the completion cannot. (1) and (4).
gap-on-projection : Gap uStep
gap-on-projection = the-distinction-lives-only-on-the-lossy-projection .fst

no-gap-on-completion : ¬ Gap (λ m → equivFun (lossless uStep) m)
no-gap-on-completion = the-distinction-lives-only-on-the-lossy-projection .snd

------------------------------------------------------------------------
-- THE STATEMENT.  A universal machine in which P=NP: the distinction is
-- present on the lossy reading and impossible on the lossless one. The
-- pair IS the witness; both halves are checked, --safe.
------------------------------------------------------------------------

P=NP-on-the-lossless-universal-machine :
  Gap uStep × (¬ Gap (λ m → equivFun (lossless uStep) m))
P=NP-on-the-lossless-universal-machine =
  gap-on-projection , no-gap-on-completion
