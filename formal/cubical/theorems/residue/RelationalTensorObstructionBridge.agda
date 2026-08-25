{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- RelationalTensorObstructionBridge
--
-- The RQM-adjacent S¹ family and the local/joint compiler share an exact
-- residual: the Bool fibre with negation monodromy.  Their obstructions are
-- nevertheless different.
--
--   relational obstruction : no loop-coherent dependent section;
--   tensor obstruction     : no right inverse to a constant local quotient.
--
-- A bare local choice exists in the tensor chart, so these cannot be merged
-- into one slogan such as "there is no local state".  What is common is the
-- phase fibre and its exchange; what differs is the diagram required to
-- commute.
------------------------------------------------------------------------

module RelationalTensorObstructionBridge where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (equivFun)
open import Cubical.Data.Bool using (Bool ; true ; false)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Data.Unit using (tt)
open import Cubical.HITs.S1 using (base ; loop)
open import Cubical.Relation.Nullary using (¬_)

import RelationalProcessCore as Rel
import UnivalentTensorInteraction as Ten

------------------------------------------------------------------------
-- 1. Exact common carrier
------------------------------------------------------------------------

base-fibre-is-joint-sector : Rel.RelativeFact base ≡ Ten.JointCoherence
base-fibre-is-joint-sector = refl

-- The monodromy of the relational family is the same point motion as the
-- univalent phase-exchange presentation.
monodromy-is-joint-exchange :
  (phase : Bool)
  → subst Rel.RelativeFact loop phase ≡ equivFun Ten.phaseExchange phase
monodromy-is-joint-exchange true  = refl
monodromy-is-joint-exchange false = refl

LoopStable : Type₀
LoopStable = Σ[ phase ∈ Bool ] (subst Rel.RelativeFact loop phase ≡ phase)

no-loop-stable-phase : ¬ LoopStable
no-loop-stable-phase (phase , stable) =
  Rel.no-loop-fixed-point phase stable

-- A global relative fact would in particular produce a stable point in the
-- common Bool fibre.  This isolates the exact monodromy obstruction.
global-fact→loop-stable : Rel.GlobalFact → LoopStable
global-fact→loop-stable section =
  section base , Rel.section-naturality Rel.RelativeFact section loop

------------------------------------------------------------------------
-- 2. The tensor obstruction is a different diagram
------------------------------------------------------------------------

LocalChoice : Type₀
LocalChoice = Ten.SeparatePopulation → Ten.JointCoherence

-- Unlike a global section, a bare local choice is easy: it need not respect
-- the loop and need not reconstruct both points of the forgotten fibre.
local-choice-exists : LocalChoice
local-choice-exists populations = Ten.plus

ExactLocalReconstruction : Type₀
ExactLocalReconstruction =
  Σ[ recover ∈ LocalChoice ]
    ((phase : Ten.JointCoherence)
      → recover (Ten.forgetJoint phase) ≡ phase)

no-exact-local-reconstruction : ¬ ExactLocalReconstruction
no-exact-local-reconstruction (recover , round) =
  Ten.no-local-reconstruction recover round

------------------------------------------------------------------------
-- 3. Preservation ledger
------------------------------------------------------------------------

record ObstructionComparison : Type₁ where
  field
    sameFibre : Rel.RelativeFact base ≡ Ten.JointCoherence
    sameMotion :
      (phase : Bool)
      → subst Rel.RelativeFact loop phase
        ≡ equivFun Ten.phaseExchange phase
    localChoiceSurvives : LocalChoice
    globalCoherenceFails : ¬ Rel.GlobalFact
    quotientRetractionFails : ¬ ExactLocalReconstruction

relational-tensor-comparison : ObstructionComparison
relational-tensor-comparison .ObstructionComparison.sameFibre =
  base-fibre-is-joint-sector
relational-tensor-comparison .ObstructionComparison.sameMotion =
  monodromy-is-joint-exchange
relational-tensor-comparison .ObstructionComparison.localChoiceSurvives =
  local-choice-exists
relational-tensor-comparison .ObstructionComparison.globalCoherenceFails =
  Rel.no-global-fact
relational-tensor-comparison .ObstructionComparison.quotientRetractionFails =
  no-exact-local-reconstruction

------------------------------------------------------------------------
-- Rigor boundary
--
-- Checked: equality of the base fibres, equality of their point motions,
-- absence of a loop-stable phase, existence of a bare local choice, and the
-- two distinct no-go statements.
--
-- Not claimed: equivalence of GlobalFact and ExactLocalReconstruction, or an
-- identification of RQM with entanglement.  The former is false at the level
-- of bare local choice exhibited above; a larger physical theory must specify
-- the actual comparison diagram before either obstruction can be transported.
------------------------------------------------------------------------
