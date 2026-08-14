{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- A generated obstruction changes executable future behavior.
--
-- This is the composite that was previously distributed across
-- Obstruction, GenerativeLoop, CompileBridge, AcceptanceTest, and
-- FutureBehavior.  For the concrete task already used by CompileBridge:
--
--   * the generative step produces the missing capability;
--   * installing it changes compilation from restart to resume;
--   * both programs compute the same mathematical answer;
--   * the installed program has strictly smaller counted cost; and
--   * consequently every future answer agrees while future cost does not.
--
-- The action alphabet here has one operation: repeat the generated
-- installation.  Repetition is idempotent at the two-state interface.
-- No objective, cost model, or task is inferred: this closes the checked
-- execution/comparison composite for the supplied concrete task.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (ℕ ; suc)

module NaturalMachine.GeneratedCapability (k : ℕ) where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; false ; true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.List using ([] ; _∷_)
open import Cubical.Data.Nat.Order using (_<_ ; ¬m<m)
open import Cubical.Data.Sigma using (_×_ ; Σ-syntax ; _,_)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.FutureBehavior using (FutureEq)
open import NaturalMachine.Obstruction using (Vocab ; Obstruction)
open import NaturalMachine.CompileBridge
import NaturalMachine.AcceptanceTest

open NaturalMachine.AcceptanceTest k
  using (Plan ; restart ; resume ; exec ; cost ; replay ; resume-cheaper)
open Bridge k resumeCap using (TermImprovementAt)
open ConcreteTask k using (task-compiles-better)

-- `false` is compilation before the generated definition is installed;
-- `true` is compilation after installation.
installStep : Bool → Unit → Bool
installStep false tt = true
installStep true  tt = true

plan : (m n : ℕ) → Bool → Plan
plan m n false = restart m (suc n)
plan m n true  = resume  m (suc n)

answer : (m n : ℕ) → Bool → _
answer m n stage = exec (plan m n stage)

work : (m n : ℕ) → Bool → ℕ
work m n stage = cost (plan m n stage)

-- Installation preserves the complete answer behavior, including the
-- empty future.  After one action both sides are definitionally `true`.
answer-future-preserved : (m n : ℕ)
  → FutureEq installStep (answer m n) false true
answer-future-preserved m n []       = sym (replay m (suc n))
answer-future-preserved m n (tt ∷ word) = refl

-- The same two states are separated by counted work already at the empty
-- future.  Hence installation is observable as capability even though it
-- is invisible in the mathematical answer.
work-future-changed : (m n : ℕ)
  → ¬ FutureEq installStep (work m n) false true
work-future-changed m n same =
  ¬m<m (subst (λ z → work m n true < z) (same []) (resume-cheaper m n))

-- The full checked cycle in one type.  The first component is the actual
-- generated obstruction/definition/compilation proof from CompileBridge;
-- the second and third components state its effect on complete futures.
generated-capability-changes-future : (m n : ℕ)
  → (Σ[ X ∈ Vocab ] Σ[ o ∈ Obstruction X ]
       TermImprovementAt X o taskTm m n)
    × (FutureEq installStep (answer m n) false true)
    × (¬ FutureEq installStep (work m n) false true)
generated-capability-changes-future m n =
  task-compiles-better m n
  , answer-future-preserved m n
  , work-future-changed m n
