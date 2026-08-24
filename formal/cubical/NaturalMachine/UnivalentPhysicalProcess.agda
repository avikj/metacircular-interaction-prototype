-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.UnivalentPhysicalProcess
--
-- In this finite physical model, univalence is part of the state geometry,
-- not a post-hoc proof wrapper.  A reversible change of presentation is a
-- path in the universe.  Transport
-- along the phase-flip equivalence moves the physical state.  The resulting
-- loop is nontrivial, detected by that transported state.  An observation is
-- invariant only when state and evaluator move together; holding the
-- evaluator fixed changes the result.
------------------------------------------------------------------------

module NaturalMachine.UnivalentPhysicalProcess where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun)
open import Cubical.Foundations.Univalence using (ua ; uaβ)
open import Cubical.Data.Bool
  using (Bool ; true ; false ; not ; true≢false ; false≢true)
open import Cubical.Data.Sigma using (snd)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.StructuredDefect using (Pointed ; notEquiv)
open import NaturalMachine.EvaluatorTransport
  using (EvaluationFrame ; runEvaluation ; transportEvaluation
        ; transportEvaluation-invariant)

------------------------------------------------------------------------
-- 1. The model represents a reversible symmetry by a path of state spaces
------------------------------------------------------------------------

PhaseSpace : Type₀
PhaseSpace = Bool

phaseLoop : PhaseSpace ≡ PhaseSpace
phaseLoop = ua notEquiv

phase-transport : subst Pointed phaseLoop true ≡ false
phase-transport = uaβ notEquiv true

-- The loop is not collapsed to reflexivity: transporting the distinguished
-- state detects it.  Higher identity therefore carries executable content.
phase-loop-nontrivial : ¬ (phaseLoop ≡ refl)
phase-loop-nontrivial loop≡refl =
  false≢true
    (sym phase-transport
    ∙ cong (λ p → subst Pointed p true) loop≡refl
    ∙ substRefl {B = Pointed} true)

------------------------------------------------------------------------
-- 2. State and observer form one transported physical frame
------------------------------------------------------------------------

phaseReadout : Bool → Bool
phaseReadout = λ b → b

initialFrame : EvaluationFrame Bool Bool
initialFrame = phaseReadout , true

transportedFrame : EvaluationFrame Bool Bool
transportedFrame = transportEvaluation notEquiv initialFrame

-- The presentation change really moves the candidate state.
transported-state-is-opposite : snd transportedFrame ≡ false
transported-state-is-opposite = refl

-- But when the evaluator is transported contravariantly with it, the physical
-- result is unchanged.  This is the exact covariance law.
transported-result-conserved :
  runEvaluation transportedFrame ≡ runEvaluation initialFrame
transported-result-conserved =
  transportEvaluation-invariant notEquiv initialFrame

-- Moving the state while freezing the old observer is detectably different.
fixed-observer-detects-motion :
  ¬ (phaseReadout (equivFun notEquiv true) ≡ phaseReadout true)
fixed-observer-detects-motion = false≢true

------------------------------------------------------------------------
-- 3. Relation to the interaction-relative classical compiler
------------------------------------------------------------------------

-- PhysicalLearningCore proves that a population-only interaction compiles
-- this phase geometry to Unit, while a coherent interaction retains Bool.
-- The present module supplies what that set-level compilation deliberately
-- does not: its source identity is a nontrivial universe path, and lawful
-- reuse transports the observer together with the state.

------------------------------------------------------------------------
-- Rigor boundary
--
-- `phase-loop-nontrivial` and frame covariance are exact theorems of this
-- finite Cubical model.  They do not establish that every physical symmetry
-- is a universe path, that Bool is a complete quantum phase space, or that
-- covariance alone selects a physical theory.  A larger RQM/LQG realization
-- must supply its state family, interactions, amplitudes, and empirical link.
------------------------------------------------------------------------
