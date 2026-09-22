{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- HypothesesAssumedWhereTheyAreDerivable
--
-- ────────────────────────────────────────────────────────────────────
-- THE QUESTION
--
-- At each site that ASSUMES a hypothesis �
-- `isSet T`, `Discrete T`, stable paths, `Answerable`, `Dec` — is the
-- hypothesis derivable there?  That question has failing instances.
--
-- ────────────────────────────────────────────────────────────────────
-- THE FINDING
--
-- `ExclusionRecoversGroundAtAPrice` §6 assumes BOTH
--
--     (isSetT : isSet T) (discT : Discrete T)
--
-- and `Discrete→isSet` is in the library.  The first hypothesis is
-- derivable from the second at that site: it is redundant.
--
-- `WhereTheTowerCanStillBeThree` §3 assumes `isSet T` alongside
-- POINTWISE path-stability along `t`.  That one is NOT redundant, and
-- the reason is exact: Hedberg's argument needs stability at ALL pairs
-- of the type, and stability along the image of a particular `t` does
-- not give it.  Strengthening the hypothesis to `Separated T` makes
-- `isSet T` derivable there too — at the cost of assuming stability
-- where none was needed.
--
-- ────────────────────────────────────────────────────────────────────
-- SO THERE ARE TWO FORMS AND NEITHER DOMINATES
--
-- स्यात् — in the respect of path-stability demanded, the pointwise
--          form asks less: only the pairs `t` actually compares;
-- स्यात् — in the respect of hypothesis COUNT, the separated form asks
--          less: one hypothesis instead of two, since Hedberg supplies
--          the other.
--
-- These are two नयs and the collision between them is not a defect to
-- be resolved by picking one.  Aneknta licenses a collapse only where
-- there is agreement; here the two forms disagree about which
-- hypothesis is cheap, and a module that shipped only one of them
-- would be asserting a standpoint by denying the other.  Both are
-- proved below.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS PROVED
--
--   §1  the derivability chain, quoted from the library so the claim
--       is checkable at a glance rather than asserted;
--   §2  the §6 statement with `isSet T` DROPPED — same conclusion,
--       one fewer hypothesis;
--   §3  the §3 statement in separated form, `isSet T` dropped, and the
--       pointwise form beside it with `isSet T` retained, so the two
--       nayas stand together;
--   §4  and the one thing that makes this a finding rather than a
--       tidy-up: `Discrete T` is strictly more than `isSet T` needs,
--       and separatedness is the hypothesis Hedberg's argument uses.
--
------------------------------------------------------------------------

module HypothesesAssumedWhereTheyAreDerivable where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬_ ; Discrete ; Stable ; Separated)
open import Cubical.Relation.Nullary.Properties
  using (Discrete→Separated ; Separated→isSet ; Discrete→isSet)

open import FiniteInformation
  using (FiberConstant ; FactorsThrough
        ; fiberConstant→factorsThrough ; factorsThrough→fiberConstant)
open import ExclusionRecoversGroundAtAPrice
  using (CoExclude ; fiberConstant-transfer-stableTarget)
open import WhereTheTowerCanStillBeThree
  using (stableFiberConstant ; Stable-↔)

private
  variable
    ℓx ℓy ℓy' ℓt : Level

------------------------------------------------------------------------
-- 1.  The chain, quoted rather than asserted
------------------------------------------------------------------------

discrete→separated : {T : Type ℓt} → Discrete T → Separated T
discrete→separated = Discrete→Separated

separated→set : {T : Type ℓt} → Separated T → isSet T
separated→set = Separated→isSet

discrete→set : {T : Type ℓt} → Discrete T → isSet T
discrete→set = Discrete→isSet

------------------------------------------------------------------------
-- 2.  The transfer theorem with `isSet T` dropped
--
-- Identical conclusion to `ExclusionRecoversGroundAtAPrice`
-- §6/§9, with the redundant hypothesis removed and Hedberg supplying
-- it from the one that remains.
------------------------------------------------------------------------

factorsThrough-transfer-discreteTarget′ :
  {X : Type ℓx} {Y : Type ℓy} {Y' : Type ℓy'} {T : Type ℓt}
  (discT : Discrete T)
  (q : X → Y) (q' : X → Y') (t : X → T)
  → CoExclude q q' → FactorsThrough q t → FactorsThrough q' t
factorsThrough-transfer-discreteTarget′ discT q q' t ce ft =
  fiberConstant→factorsThrough (Discrete→isSet discT) q' t
    (fiberConstant-transfer-stableTarget q q' t
      (λ x x' → Discrete→Separated discT (t x) (t x'))
      ce (factorsThrough→fiberConstant q t ft))

------------------------------------------------------------------------
-- 3.  The two nayas on stability of factoring, standing together
--
-- 3a asks less of the type and keeps `isSet T`.
-- 3b asks stability everywhere and derives `isSet T`.
-- Neither is an instance of the other.
------------------------------------------------------------------------

stableFactorsThrough-pointwise :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (isSetT : isSet T) (q : X → Y) (t : X → T)
  → ((x x' : X) → Stable (t x ≡ t x'))
  → Stable (FactorsThrough q t)
stableFactorsThrough-pointwise isSetT q t st =
  Stable-↔ (fiberConstant→factorsThrough isSetT q t)
           (factorsThrough→fiberConstant q t)
           (stableFiberConstant q t st)

stableFactorsThrough-separated :
  {X : Type ℓx} {Y : Type ℓy} {T : Type ℓt}
  (sepT : Separated T) (q : X → Y) (t : X → T)
  → Stable (FactorsThrough q t)
stableFactorsThrough-separated sepT q t =
  stableFactorsThrough-pointwise (Separated→isSet sepT) q t
    (λ x x' → sepT (t x) (t x'))

------------------------------------------------------------------------
-- 4.  What is established
--
-- At
-- two sites a hypothesis was assumed that the site could derive, and one
-- of the two was genuinely redundant.
------------------------------------------------------------------------

-- recorded as an object so the redundancy cannot quietly return: the
-- old hypothesis is recoverable from the new one, at the same site.
redundantHypothesis :
  {T : Type ℓt} → Discrete T → isSet T
redundantHypothesis = Discrete→isSet
