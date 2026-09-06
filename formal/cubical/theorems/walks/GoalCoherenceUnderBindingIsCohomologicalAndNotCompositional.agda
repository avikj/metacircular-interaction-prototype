{-# OPTIONS --safe --cubical #-}

------------------------------------------------------------------------
-- GoalCoherenceUnderBinding — the binding of agents is a cohomological
-- event: coupling two individually-coherent subsystems yields a coherent
-- whole IFF the coupling is consistent, and coherence is therefore NOT
-- compositional.  (See AGENCY_AS_COHOMOLOGY.md §5.)
--
-- THE FRAME (zero empiricism).  A "goal" of an agent is a value/potential
-- field its dynamics descends (Levin's TOTE setpoint, made a value
-- function).  A COHERENT global goal exists iff the preference cochain is
-- EXACT (a gradient of a potential) — HolonomyCriterionForExactness.  An
-- agent can be locally goal-directed everywhere yet globally FRUSTRATED
-- (no coherent goal): the obstruction is a nonzero holonomy / curvature
-- class.  "Binding" many selves into one (Levin's gap-junction coupling,
-- Fields' cone–cocone assembly) glues their preference fields; the
-- question Levin flags as unformalised — the compositional rule, with the
-- window "too little sharing → no unity; too much → loss of modularity" —
-- is answered here cohomologically.
--
-- THE MODEL.  Three coupled sites a, b, c (two subsystems a–b, b–c bound
-- by a coupling edge a–c).  The value group is ℤ (an ordered/abelian
-- value field — the honest setting for goals; the nonabelian case is the
-- open anticipatory-goal frontier).  A base potential gives coherent
-- part-fields; the coupling edge a–c carries a mismatch δ.
--
-- WHAT IS PROVEN, --safe at the pin:
--   F-coupled            the triangle curvature of the coupled field is
--                        exactly ⊖δ — the coupling mismatch IS the
--                        frustration.
--   couplingInconsistentFrustrates
--                        for ANY δ with ⊖δ ≠ 0, the coupled whole is NOT
--                        exact: no coherent global goal (general in δ).
--   consistentWhole      the consistent coupling (δ = 0) IS exact: a
--                        coherent global goal exists.
--   goalCoherenceNotCompositional
--                        the SAME coherent parts, bound by δ = 0, are a
--                        coherent Self; bound by δ = 1, are frustrated.
--                        Coherence is created or destroyed by the
--                        coupling alone — it is not a function of the
--                        parts.  This is Levin's binding window as a
--                        theorem: coherence lives only in the band where
--                        the assembled cochain is exact.
--
-- FENCE.  This is the ℤ (abelian) case — coherent goals as consistent
-- value fields.  Whether anticipatory/counterfactual goals need the
-- nonabelian value group (which the holonomy lane already supports) is
-- OPEN.  Biology is cited nowhere here; this is pure structure.
------------------------------------------------------------------------

module GoalCoherenceUnderBindingIsCohomologicalAndNotCompositional where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Int using (ℤ ; pos ; negsuc)
open import Cubical.Data.Bool using (Bool ; true ; false ; true≢false)
open import Cubical.Data.Sigma using (_×_ ; _,_)

open import HolonomyCriterionForExactness using (GroupOn ; ℤGroupOn)
import HolonomyCriterionForExactness as H
import CurvatureOfACoboundaryVanishesAndTriangleFlatnessIsExactness as C

------------------------------------------------------------------------
-- Three coupled sites; the value group ℤ.
------------------------------------------------------------------------

data Three : Type where
  a b c : Three

open GroupOn ℤGroupOn
open H.Traces Three ℤGroupOn using (Cochain ; d ; Exact)
open C.Curvature Three ℤGroupOn using (F ; Flat ; flatFromExact)

------------------------------------------------------------------------
-- The coupled preference field: coherent (zero) on the two subsystem
-- edges, carrying the mismatch δ on the coupling edge a–c.
------------------------------------------------------------------------

coupled : ℤ → Three → Three → ℤ
coupled δ a c = δ
coupled δ _ _ = pos 0

-- the triangle curvature of the coupled field is exactly the mismatch.
F-coupled : (δ : ℤ) → F (coupled δ) a b c ≡ ⊖ δ
F-coupled δ = cong (_⊕ (⊖ δ)) (gIdL (pos 0)) ∙ gIdL (⊖ δ)

------------------------------------------------------------------------
-- Inconsistent coupling ⇒ frustration (general in δ).
------------------------------------------------------------------------

couplingInconsistentFrustrates :
  (δ : ℤ) → ¬ (⊖ δ ≡ pos 0) → ¬ Exact (coupled δ)
couplingInconsistentFrustrates δ notneg (g , h) =
  notneg (sym (F-coupled δ) ∙ flatFromExact (coupled δ) g h a b c)

------------------------------------------------------------------------
-- Consistent coupling (δ = 0) ⇒ a coherent global goal exists.
------------------------------------------------------------------------

zeroField : (x y : Three) → coupled (pos 0) x y ≡ d (λ _ → pos 0) x y
zeroField a a = sym (gInvL (pos 0))
zeroField a b = sym (gInvL (pos 0))
zeroField a c = sym (gInvL (pos 0))
zeroField b a = sym (gInvL (pos 0))
zeroField b b = sym (gInvL (pos 0))
zeroField b c = sym (gInvL (pos 0))
zeroField c a = sym (gInvL (pos 0))
zeroField c b = sym (gInvL (pos 0))
zeroField c c = sym (gInvL (pos 0))

consistentWhole : Exact (coupled (pos 0))
consistentWhole = (λ _ → pos 0) , zeroField

------------------------------------------------------------------------
-- THE PUNCHLINE.  Same coherent parts; the coupling alone decides.
------------------------------------------------------------------------

-- ⊖ (pos 1) is negsuc 0, distinguishable from pos 0.
isNeg : ℤ → Bool
isNeg (pos _)    = false
isNeg (negsuc _) = true

⊖1≢0 : ¬ (⊖ (pos 1) ≡ pos 0)
⊖1≢0 p = true≢false (cong isNeg p)

frustratedWhole : ¬ Exact (coupled (pos 1))
frustratedWhole = couplingInconsistentFrustrates (pos 1) ⊖1≢0

-- Goal-coherence is NOT compositional: the identical coherent subsystems
-- become a coherent Self or a frustrated one according to the coupling.
goalCoherenceNotCompositional :
  Exact (coupled (pos 0)) × (¬ Exact (coupled (pos 1)))
goalCoherenceNotCompositional = consistentWhole , frustratedWhole
