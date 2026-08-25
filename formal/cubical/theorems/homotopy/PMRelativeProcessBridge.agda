{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PMRelativeProcessBridge
--
-- The Peres--Mermin incidence HIT is a genuine dependent RelativeProcess
-- base: its overlap paths are process arrows and the obstruction sheet is
-- the fact family.  The six-edge loop composes in the path groupoid, and the
-- generic no-fixed-loop theorem yields the existing no-global-sheet result.
--
-- Correction boundary: PMMonodromyDerivationNoGo proves that endpoint signs
-- do not select the ZZ-supported edge representative.  Thus this bridge
-- consumes an explicitly chosen local system; it does not derive or globally
-- fix that gauge representative.  Nothing here identifies contextuality with
-- RQM.
------------------------------------------------------------------------

module PMRelativeProcessBridge where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool using (Bool ; not)
open import Cubical.Relation.Nullary using (¬_)

import PMTorus as Torus
import PMIncidenceLocalSystem as PM
import PMMonodromyDerivationNoGo as NoGo
import PMCokernel as Cokernel
import PauliWeyl as Weyl
import RelationalProcessCore as Rel

incidenceProcess : Rel.RelativeProcess
Rel.Locus incidenceProcess = PM.CoverBase
Rel.Fact  incidenceProcess = PM.ObstructionSheet

incidenceArrow : (observable : Torus.Obs)
  → Rel.ProcessArrow incidenceProcess
      (PM.context (fst (Torus.pmContexts observable)))
      (PM.context (snd (Torus.pmContexts observable)))
incidenceArrow = PM.incidencePath

incidenceInteraction : (observable : Torus.Obs) (phase : Bool)
  → Rel.Interaction incidenceProcess
      (PM.context (fst (Torus.pmContexts observable)))
      (PM.context (snd (Torus.pmContexts observable)))
incidenceInteraction observable phase =
  Rel.follow incidenceProcess (incidenceArrow observable) phase

-- The already-checked six-edge cycle is literally an arrow of the process
-- groupoid; its composite transport is negation.
cycleArrow : Rel.ProcessArrow incidenceProcess
  (PM.context Torus.R0) (PM.context Torus.R0)
cycleArrow = PM.coverCycle

cycle-transport-is-negation : (phase : Bool)
  → Rel.transportFact incidenceProcess cycleArrow phase ≡
    not phase
cycle-transport-is-negation = PM.cycle-is-negation

-- The generic path-groupoid theorem, rather than a PM-specific replay,
-- derives the lack of a global section.
no-global-sheet-via-process :
  ¬ ((point : Rel.Locus incidenceProcess) → Rel.Fact incidenceProcess point)
no-global-sheet-via-process =
  Rel.loop-obstructs-global incidenceProcess cycleArrow
    PM.cycle-has-no-fixed-sheet

-- Hostile control inherited from the derivation no-go: no rule using only
-- the two endpoint context signs can supply the odd loop charge of the chosen
-- local system.  Composition preserves the class once supplied; it does not
-- canonically choose its edge support.
endpoint-signs-do-not-select-the-obstruction :
  (rule : NoGo.EndpointRule)
  → ¬ (NoGo.endpointCycleCharge rule ≡
       Cokernel.total Weyl.derived-s)
endpoint-signs-do-not-select-the-obstruction =
  NoGo.endpoint-rule-cannot-carry-obstruction
