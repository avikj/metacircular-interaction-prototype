{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PMRelationalNoFit
--
-- The Peres--Mermin no-section theorem does NOT instantiate the S¹
-- RelativeProcess obstruction by simply taking measurement contexts as the
-- base and contextwise satisfying assignments as fibers.
--
-- That naive dependent family has a global section: `local-section` chooses
-- an assignment independently in every context.  PMCokernel's actual global
-- section demands one shared observable assignment satisfying every context,
-- and that type is empty.  The missing datum is overlap compatibility.
-- A genuine dependent-cover realization therefore needs an incidence/Čech
-- base (or equivalent gluing structure), not the discrete context type alone.
------------------------------------------------------------------------

module PMRelationalNoFit where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_ ; equivFun)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Relation.Nullary using (¬_)

import PMTorus as Torus
import PMCokernel as PM
import RelationalProcessCore as Rel

------------------------------------------------------------------------
-- 1. The naive context-indexed family
------------------------------------------------------------------------

ContextLocalFact : Torus.Ctx → Type₀
ContextLocalFact context =
  Σ[ valuation ∈ (Torus.Obs → Bool) ]
    (PM.δ valuation context ≡ PM.s context)

contextRelativeProcess : Rel.RelativeProcess
contextRelativeProcess .Rel.Locus = Torus.Ctx
contextRelativeProcess .Rel.Fact = ContextLocalFact

ContextwiseGlobal : Type₀
ContextwiseGlobal = (context : Torus.Ctx) → ContextLocalFact context

-- Every context has a witness, so the naive dependent family glues merely by
-- choosing those unrelated witnesses pointwise.
contextwise-global-exists : ContextwiseGlobal
contextwise-global-exists = PM.local-section

------------------------------------------------------------------------
-- 2. The actual PM section is strictly more structured
------------------------------------------------------------------------

-- One compatible PM assignment certainly induces a pointwise family: reuse
-- the same observable valuation in all six contexts.
compatible→contextwise : PM.Section → ContextwiseGlobal
compatible→contextwise (valuation , law) context =
  valuation , law context

-- But no operation can turn every pointwise family into a compatible shared
-- assignment: applying it to the checked local family would contradict the
-- Peres--Mermin parity obstruction.
no-contextwise→compatible : ¬ (ContextwiseGlobal → PM.Section)
no-contextwise→compatible assemble =
  PM.no-global-section (assemble contextwise-global-exists)

-- In particular these two candidate "global section" types are not
-- equivalent.  Local inhabitation plus ordinary dependent choice is not the
-- cover-gluing theorem that contextuality needs.
not-the-same-section-type : ¬ (ContextwiseGlobal ≃ PM.Section)
not-the-same-section-type equivalence =
  PM.no-global-section (equivFun equivalence contextwise-global-exists)

record RelationalNoFit : Type₁ where
  field
    localFamily : Torus.Ctx → Type₀
    pointwiseSection : (context : Torus.Ctx) → localFamily context
    compatibleSectionBlocked : ¬ PM.Section
    pointwiseCannotAssemble :
      ¬ (((context : Torus.Ctx) → localFamily context) → PM.Section)

pm-relational-no-fit : RelationalNoFit
pm-relational-no-fit .RelationalNoFit.localFamily = ContextLocalFact
pm-relational-no-fit .RelationalNoFit.pointwiseSection =
  contextwise-global-exists
pm-relational-no-fit .RelationalNoFit.compatibleSectionBlocked =
  PM.no-global-section
pm-relational-no-fit .RelationalNoFit.pointwiseCannotAssemble =
  no-contextwise→compatible

------------------------------------------------------------------------
-- Rigor boundary
--
-- Checked: the naive context-indexed RelativeProcess is globally inhabited,
-- the true PM Section is empty, a true section restricts pointwise, and no
-- reverse assembler/equivalence exists.
--
-- Not constructed: the Čech nerve, incidence HIT, or sheaf whose dependent
-- sections are definitionally PMCokernel.Section.  This theorem identifies
-- why that additional base/coherence is necessary; it does not pretend the
-- missing higher cover has already been formalized.
------------------------------------------------------------------------
