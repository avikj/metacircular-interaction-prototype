{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SetValuedObservationCannotCarryHolonomyProbe
--
-- The exact h-level boundary behind the shedding of graph representations.
--
-- Let q : X → O be any observation whose codomain O is a SET.  For every
-- loop p : x ≡ x, the observed loop cong q p is equal to refl because O has
-- no nontrivial path-between-path structure.  Therefore any family F with an
-- inhabitant moved by transport around p cannot descend through q.
--
-- This is not a claim that one graph schema happened to omit an edge.  Every
-- set-valued representation — graph, table, scalar, ordinary database state,
-- extensional record with set-level fields — has the same structural limit:
-- it cannot carry nontrivial holonomy.  To retain the law of transport, the
-- observer itself must live above h-level 2.
--
-- STATUS.  ~~Complete and hole-free; warm Nadi verdict owed.~~  It imports the
-- corrected generic probe from the same staging/include root.
--
-- STRUCK 2026-08-24, AND THE STRIKE IS THE POINT.  "Hole-free" was true and
-- was not a green: this module exited 42, and so did the corrected generic
-- probe it imports, on unsolved metavariables in `transport-naturality` whose
-- `q`, `F`, `D` were implicit and outside Miller's pattern fragment.  A module
-- with unsolved metas has ZERO holes and a nonzero exit code, so `goals`
-- cannot see this class and neither could the two lanes that reported on it
-- (collab/messages/0946 and 0951, both honest, both wrong).  That measurement
-- is kernel/nodes/008.
--
-- NOW GREEN, and stated with the toolchain because a green without one is a
-- coordinate reading (kernel/nodes/001):
--   Agda 2.8.0 / cubical v0.9 -- THE PIN -- EXIT 0
--   Agda 2.6.3 / cubical v0.5                EXIT 0
-- The whole holonomy set is green at both: this module, the corrected generic
-- probe, DescentRequiresTheObserverToRetainHolonomy, SetMetadataCannotRepair
-- LostHolonomy, SetTruncationCannotCarryNontrivialHolonomy, DescentSpectrum.
------------------------------------------------------------------------

module SetValuedObservationCannotCarryHolonomyProbe where

open import Cubical.Foundations.Prelude
open import Cubical.Relation.Nullary using (¬_)

open import HolonomyDescentObstructionCorrectedProbe
  using (HolonomyWitness ; kernel-holonomy-witness-obstructs-descent)
open import AvataranaBhanga_TheQuotientCannotHostTheTypeOfWitnessesAndTheProofIsOneTransport
  using (DependentFactorsThrough)

private
  variable
    ℓ ℓ' ℓ'' : Level

set-valued-observation-kills-loop :
  {X : Type ℓ} {O : Type ℓ'}
  (isSetO : isSet O) (q : X → O)
  {x : X} (p : x ≡ x)
  → cong q p ≡ refl
set-valued-observation-kills-loop isSetO q {x = x} p =
  isSetO (q x) (q x) (cong q p) refl

set-valued-observation-cannot-carry-holonomy :
  {X : Type ℓ} {O : Type ℓ'}
  (isSetO : isSet O) (q : X → O)
  (F : X → Type ℓ'')
  (x : X) (p : x ≡ x)
  → HolonomyWitness F x p
  → ¬ DependentFactorsThrough q F
set-valued-observation-cannot-carry-holonomy isSetO q F x p witness =
  kernel-holonomy-witness-obstructs-descent
    q F x p
    (set-valued-observation-kills-loop isSetO q p)
    witness
