{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- EvaluatorTransport
--
-- An evaluation is a pairing of a candidate with an evaluator.  Along a
-- checked equivalence e : A ≃ B, inverse precomposition is the unique
-- evaluator transport that conserves every paired result:
--
--   (score , x)  |->  (score o e^-1 , e x).
--
-- The sampled ECOLOGY note's trust correction requires exactly such an
-- invariance law before a result may be reused across presentations.  This
-- module supplies only that structural law.  It does not turn observational
-- agreement into an equivalence and says nothing about empirical fitness.
--
-- Checked content:
--
--   transportEvaluator-preserves   every paired result is conserved
--   transportEvaluator-unique      conservation determines the evaluator
--   transportEvaluation-invariant  the bundled evaluation frame is invariant
--   fixed-evaluator-killer          moving only the candidate can change score
------------------------------------------------------------------------

module EvaluatorTransport where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

open import PathIsSymmetry using (swap01-Equiv)
open import SymmetryArithmeticAction
  using (Stabilizes ; successorRegister ; swap-not-in-successor-stabilizer)

private
  variable
    ℓA ℓR : Level

------------------------------------------------------------------------
-- The contravariant evaluator and its conservation law
------------------------------------------------------------------------

transportEvaluator : {A B : Type ℓA} {R : Type ℓR}
                   → (A ≃ B) → (A → R) → B → R
transportEvaluator e score b = score (invEq e b)

PreservesAll : {A B : Type ℓA} {R : Type ℓR}
             → (A ≃ B) → (A → R) → (B → R)
             → Type (ℓ-max ℓA ℓR)
PreservesAll e scoreA scoreB =
  (x : _) → scoreB (equivFun e x) ≡ scoreA x

-- Candidate and evaluator move together, so the result is conserved.
transportEvaluator-preserves :
    {A B : Type ℓA} {R : Type ℓR}
  → (e : A ≃ B) → (score : A → R)
  → PreservesAll e score (transportEvaluator e score)
transportEvaluator-preserves e score x = cong score (retEq e x)

-- This transport is not merely one policy that happens to work.  Any
-- evaluator on B preserving every paired result is equal to inverse
-- precomposition.  Surjectivity of e is the load-bearing step.
transportEvaluator-unique :
    {A B : Type ℓA} {R : Type ℓR}
  → (e : A ≃ B) → (scoreA : A → R) → (scoreB : B → R)
  → PreservesAll e scoreA scoreB
  → scoreB ≡ transportEvaluator e scoreA
transportEvaluator-unique e scoreA scoreB preserves = funExt λ b →
    sym (cong scoreB (secEq e b))
  ∙ preserves (invEq e b)

------------------------------------------------------------------------
-- The conserved paired object
------------------------------------------------------------------------

EvaluationFrame : (A : Type ℓA) (R : Type ℓR)
                → Type (ℓ-max ℓA ℓR)
EvaluationFrame A R = (A → R) × A

runEvaluation : {A : Type ℓA} {R : Type ℓR}
              → EvaluationFrame A R → R
runEvaluation (score , x) = score x

transportEvaluation : {A B : Type ℓA} {R : Type ℓR}
                    → (A ≃ B) → EvaluationFrame A R → EvaluationFrame B R
transportEvaluation e (score , x) =
  transportEvaluator e score , equivFun e x

transportEvaluation-invariant :
    {A B : Type ℓA} {R : Type ℓR}
  → (e : A ≃ B) → (frame : EvaluationFrame A R)
  → runEvaluation (transportEvaluation e frame) ≡ runEvaluation frame
transportEvaluation-invariant e (score , x) =
  transportEvaluator-preserves e score x

------------------------------------------------------------------------
-- Killer control: transporting only one leg is not invariant
------------------------------------------------------------------------

-- The existing checked swap moves the candidate observed at a fixed port
-- while leaving the successor evaluator fixed.  Its score changes.  Thus the
-- simultaneous transport premise above cannot be weakened to candidate
-- transport alone.
fixed-evaluator-killer : ¬ Stabilizes successorRegister swap01-Equiv
fixed-evaluator-killer = swap-not-in-successor-stabilizer
