{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- PMIncidenceLocalSystem
--
-- The first honest overlap base for the Peres--Mermin cover.  Its points are
-- the six contexts and each observable generates a path between the two
-- contexts containing it.  A Bool local system is trivial on eight overlaps
-- and transports by negation across ZZ.  The standard six-edge cycle then
-- has nontrivial holonomy and the family has no global section.
--
-- This is the obstruction line of the cover, not yet the full sheaf of local
-- observable valuations.  It supplies the incidence HIT and a nontrivial
-- overlap transport which PMRelationalNoFit proved the discrete base lacked.
------------------------------------------------------------------------

module PMIncidenceLocalSystem where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Univalence using (ua)
open import Cubical.Data.Bool
  using (Bool ; true ; false ; not ; false≢true)
open import Cubical.Relation.Nullary using (¬_)

import PMTorus as PM
import StructuredDefect as Defect
import RelationalProcessCore as Rel

------------------------------------------------------------------------
-- 1. Geometric realization of the context--observable incidence graph
------------------------------------------------------------------------

data CoverBase : Type₀ where
  context : PM.Ctx → CoverBase
  incidencePath : (observable : PM.Obs)
    → context (fst (PM.pmContexts observable))
      ≡ context (snd (PM.pmContexts observable))

-- The cocycle is concentrated on ZZ, exactly as PMCokernel.twist is
-- concentrated on C2.  Every clause is an explicit overlap equivalence.
overlapPath : PM.Obs → Bool ≡ Bool
overlapPath PM.XI = refl
overlapPath PM.IX = refl
overlapPath PM.XX = refl
overlapPath PM.IY = refl
overlapPath PM.YI = refl
overlapPath PM.YY = refl
overlapPath PM.XY = refl
overlapPath PM.YX = refl
overlapPath PM.ZZ = ua Defect.notEquiv

ObstructionSheet : CoverBase → Type₀
ObstructionSheet (context c) = Bool
ObstructionSheet (incidencePath observable i) = overlapPath observable i

-- Eight overlaps preserve the sheet; ZZ exchanges it.
xi-transport : subst ObstructionSheet (incidencePath PM.XI) true ≡ true
xi-transport = refl

zz-transport : subst ObstructionSheet (incidencePath PM.ZZ) true ≡ false
zz-transport = refl

------------------------------------------------------------------------
-- 2. The cover cycle detects the obstruction
------------------------------------------------------------------------

-- R0 -XI- C0 -IY- R1 -YI- C1 -YX- R2 -ZZ- C2 -XX- R0.
coverCycle : context PM.R0 ≡ context PM.R0
coverCycle =
    incidencePath PM.XI
  ∙ sym (incidencePath PM.IY)
  ∙ incidencePath PM.YI
  ∙ sym (incidencePath PM.YX)
  ∙ incidencePath PM.ZZ
  ∙ sym (incidencePath PM.XX)

cycle-carries-true-to-false :
  subst ObstructionSheet coverCycle true ≡ false
cycle-carries-true-to-false = refl

cycle-is-negation :
  (phase : Bool)
  → subst ObstructionSheet coverCycle phase ≡
    not phase
cycle-is-negation true  = refl
cycle-is-negation false = refl

GlobalSheet : Type₀
GlobalSheet = (point : CoverBase) → ObstructionSheet point

section-naturality :
  (section : GlobalSheet) {x y : CoverBase} (path : x ≡ y)
  → subst ObstructionSheet path (section x) ≡ section y
section-naturality section {x} {y} path =
  Rel.section-naturality ObstructionSheet section path

cycle-has-no-fixed-sheet :
  (phase : Bool)
  → ¬ (subst ObstructionSheet coverCycle phase ≡ phase)
cycle-has-no-fixed-sheet true fixed =
  false≢true (sym (cycle-is-negation true) ∙ fixed)
cycle-has-no-fixed-sheet false fixed =
  false≢true (sym fixed ∙ cycle-is-negation false)

no-global-sheet : ¬ GlobalSheet
no-global-sheet section =
  cycle-has-no-fixed-sheet (section (context PM.R0))
    (section-naturality section coverCycle)

------------------------------------------------------------------------
-- Rigor boundary
--
-- Checked: the incidence HIT, all nine overlap paths, nontrivial ZZ
-- transport, the six-edge holonomy, and absence of a global sheet.
--
-- Not checked: an equivalence between this GlobalSheet and
-- PMCokernel.Section.  The present fibre is only the one-dimensional
-- obstruction local system, not the contextwise three-observable valuation
-- space with restriction maps.  Building that Čech object remains the next
-- step; this module prevents it from reverting to a discrete context base.
------------------------------------------------------------------------
