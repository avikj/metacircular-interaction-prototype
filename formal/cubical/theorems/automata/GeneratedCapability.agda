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

module GeneratedCapability (k : ℕ) where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; false ; true)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.List using ([] ; _∷_)
open import Cubical.Data.Nat.Order using (_<_ ; ¬m<m)
open import Cubical.Data.Sigma using (_×_ ; Σ-syntax ; _,_)
open import Cubical.Relation.Nullary using (¬_)

open import FutureBehavior using (FutureEq)
open import ObstructionSubstrate
  using (Vocab ; Obstruction ; Tm ; Over ; extend ; unfold ; unfold-elim)
open Obstruction
open import CompileBridge
open import PayloadMorphism using (MorphismClass)
open import DatumSensitivePayload using (DatumSensitivePayloadOver)
import AcceptanceTest

open AcceptanceTest k
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

------------------------------------------------------------------------
-- The payload joint: generation supplies the missing definition; a
-- realization witness certifies the mathematical datum installed with it.
-- These are deliberately separate inputs.  The generated obstruction does
-- not infer arithmetic data.
------------------------------------------------------------------------

module _ {Ans : Type₀} {M : MorphismClass Ans}
         (P : DatumSensitivePayloadOver Ans M) where

  open DatumSensitivePayloadOver P
  open Bridge k resumeCap using (ImprovementAt)
  open ConcreteTask k using (task-step-improves)

  RealizedGeneratedInstallation : Type₀
  RealizedGeneratedInstallation =
    Σ[ st ∈ Store baseVocab ]
    Σ[ x ∈ Datum (residual taskObstruction) ]
      Realizes st (residual taskObstruction) (witness taskObstruction)
        (witnessBase taskObstruction) x

  -- One checked composite, at the obstruction actually returned by the
  -- concrete generative step.  Its first component is executable progress;
  -- its second says the supplied, realized datum is installed by `installP`
  -- and preserves the old mathematical meaning; its last two components are
  -- equality of all future answers and inequality of future work.
  generated-realized-capability :
    (r : RealizedGeneratedInstallation) (t : Tm)
    (h : Over (extend baseVocab taskObstruction) t) (m n : ℕ)
    → ImprovementAt baseVocab taskObstruction m n
    × (sem (installP (fst r) (residual taskObstruction)
               (witness taskObstruction) (witnessBase taskObstruction)
               (fst (snd r))) t h
       ≡ sem (fst r)
           (unfold (residual taskObstruction) (witness taskObstruction) t)
           (unfold-elim baseVocab (residual taskObstruction)
             (witness taskObstruction) (witnessBase taskObstruction) t h))
    × FutureEq installStep (answer m n) false true
    × (¬ FutureEq installStep (work m n) false true)
  generated-realized-capability (st , x , rx) t h m n =
      task-step-improves m n
    , unfold-preserves st (residual taskObstruction) (witness taskObstruction)
        (witnessBase taskObstruction) x rx t h
    , answer-future-preserved m n
    , work-future-changed m n
