{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- तृतीय-छिद्रम् — the third aperture, and a correction I owe the ladder.
--
-- GarbhaShreni claimed the tower's rungs are ONE predicate, "cost is not
-- exact" (NotExact ∂ V), instanced at π₀ and π₁.  That is TRUE for those
-- two rungs and FALSE as the general rung-relation, and the second claim
-- is the one that matters.  NotExact is abelian-flavoured: it needs the
-- invariant to be a coboundary-valued cochain (ℕ, ℤ).  The higher
-- k-invariants of this corpus are not of that kind — VakraValayaSanketa's
-- rung is an ORIENTATION BIT (ℤ/2 at H²), the double-twist the Klein
-- bottle costs and the torus does not.  "Cost is not exact at every
-- degree" is therefore the WRONG induction: cost is a degree-1 object;
-- there is no natural degree-2 cost.
--
-- What DOES span the rungs is the aperture EkamChidram already named:
-- the level-n forgetful map is NOT AN EQUIVALENCE.  ¬ isEquiv is
-- degree-blind and lane-blind — it is the type of "a fibre survived",
-- the śeṣa itself — and it swallows the H² rung too:
--
--   §1  THE HIGHER RUNG IS A NON-EQUIVALENCE.  For ANY map f between the
--       two second-cohomology carriers ⟨H²(𝕂²)⟩ and ⟨H²(T²)⟩,
--       ¬ isEquiv f — because an equivalence would hand back the very
--       type-equivalence सङ्केतः refutes.  One line, every f at once.
--   §2  SO THE TOWER'S UNIFIER IS ¬ isEquiv, NOT NotExact.  The two
--       cost rungs (EkamChidram.costIsNonEquiv, at π₁) and this
--       orientation rung (§1, at H²) are the SAME predicate at different
--       degrees — heterogeneous invariants, one obstruction type.
--       NotExact is retired to what it is: the abelian special case,
--       true only where the invariant is a group-valued cochain.
--
-- SYĀT — THE CLAIM, EXACTLY.  §1 for every map between the H² carriers,
-- from सङ्केतः; §2 the identification of this rung with EkamChidram's
-- cost rung under ¬ isEquiv.  NOT claimed: that ¬ isEquiv is the k-
-- invariant in the technical Postnikov sense (it is the obstruction's
-- INHABITANT — a surviving fibre — not the cohomology class as such);
-- nor the full ∞-tower.  What IS corrected: GarbhaShreni's "one
-- predicate for all rungs" — that predicate is ¬ isEquiv, and NotExact
-- was only the abelian shadow of it.
------------------------------------------------------------------------

module TrtiyaCidram_TheHigherRungIsAlsoANonEquivalenceSoTheApertureNotNonExactnessUnifiesTheTower where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (isEquiv ; _≃_)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Data.Int using (ℤ)
open import Cubical.HITs.KleinBottle using (KleinBottle)
open import Cubical.HITs.Sn using (S₊)
open import Cubical.Algebra.Group.Base using (Group)
open import Cubical.ZCohomology.GroupStructure using (coHomGr)

open import VakraValayaSanketa_TheForgottenSuccessionPrecipitatesTypeLevelAsOneBitAndTheFirstVeilIsItsFee
  using (सङ्केतः)

private
  ⟨_⟩ : ∀ {ℓ} → Group ℓ → Type ℓ
  ⟨ G ⟩ = fst G

------------------------------------------------------------------------
-- १ · The higher rung is a non-equivalence — for every candidate map.
------------------------------------------------------------------------

rung₂ : (f : ⟨ coHomGr 2 KleinBottle ⟩ → ⟨ coHomGr 2 (S₊ 1 × S₊ 1) ⟩)
  → ¬ isEquiv f
rung₂ f ie = सङ्केतः (f , ie)

------------------------------------------------------------------------
-- २ · The tower's unifier is ¬ isEquiv.  This rung and EkamChidram's
--     cost rung are the same predicate at different degrees; carried
--     here to state them together.
------------------------------------------------------------------------

open import EkamChidram_TheObstructionIsOneClassCostCryptoAndCollisionAreEachANonEquivalenceOfTheForgetfulMap
  using (μ ; costIsNonEquiv)

theWiderAperture :
  (¬ isEquiv μ)   -- cost, at π₁ (EkamChidram)
  × ((f : ⟨ coHomGr 2 KleinBottle ⟩ → ⟨ coHomGr 2 (S₊ 1 × S₊ 1) ⟩) → ¬ isEquiv f)
                  -- orientation, at H² (§1)
theWiderAperture = costIsNonEquiv , rung₂
