{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- HigherHolonomyDescentObstructionProbe
--
-- The h-level-3 rung of the descent-obstruction ladder opened by
-- gpt-sankramana's HolonomyDescentObstructionCorrectedProbe (kernel-1-loop
-- obstruction) and SetValuedObservationCannotCarryHolonomyProbe (the
-- set-valued corollary, isSet O ⇒ every observed loop dies).
--
-- THE LADDER.  isSet O (h-level 2) forces isProp (q x ≡ q x), so every
-- observed 1-loop cong q p is killed outright: cong q p ≡ refl.  That is
-- the FIRST rung and it is the content of the two probes above.
--
-- The next rung does not ask for a stronger vanishing at the same order —
-- it asks what survives when the observer is one level less collapsed.
-- isGroupoid O (h-level 3) forces isSet (q x ≡ q x), i.e. isProp on the
-- SECOND level: two parallel 1-paths in O can differ, but two parallel
-- 2-paths between the SAME pair of 1-paths cannot.  So a groupoid-valued
-- observer may see a nontrivial 1-loop (cong q p need not be refl) while
-- it still kills every SURFACE loop: for alpha : p ≡ p a 2-cell at p,
--   cong (cong q) alpha ≡ refl.
-- This is the exact h-level analogue of
-- `set-valued-observation-kills-loop`, one dimension up, and it is proved
-- below in full — checked, no holes.
--
-- THE DESCENT COROLLARY (stated, not yet closed — see the note at the
-- bottom).  The 1-loop case closes the obstruction via
-- `transport-naturality`: the comparison isomorphism F x ≡ D (q x)
-- intertwines transport along cong F p with transport along
-- cong D (cong q p), so a killed cong q p forces transport (cong F p) to
-- act as the identity, which a nontrivial-holonomy witness contradicts.
-- The surface-holonomy analogue needs the SAME naturality argument raised
-- one dimension: an intertwining of the 2-cell action
-- cong (cong F) alpha : cong F p ≡ cong F p with
-- cong (cong D) (cong (cong q) alpha), expressed as a SQUARE, not a path.
-- Formalising that square-level naturality cleanly (rather than smashing
-- it through with `transport` degenerating a dimension) is the open step;
-- see SurfaceHolonomyWitness and surface-holonomy-obstructs-descent below,
-- whose body is a stated, unfilled goal — landed here as a real Agda hole,
-- not asserted.
------------------------------------------------------------------------

module HigherHolonomyDescentObstructionProbe where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Relation.Nullary using (¬_)

open import AvataranaBhanga_TheQuotientCannotHostTheTypeOfWitnessesAndTheProofIsOneTransport
  using (DependentFactorsThrough)

private
  variable
    ℓ ℓ' ℓ'' : Level

------------------------------------------------------------------------
-- The h-level-3 killing lemma: fully checked.
------------------------------------------------------------------------

groupoid-valued-observation-kills-surface-loop :
  {X : Type ℓ} {O : Type ℓ'}
  (isGroupoidO : isGroupoid O) (q : X → O)
  {x : X} {p : x ≡ x} (alpha : p ≡ p)
  → cong (cong q) alpha ≡ refl
groupoid-valued-observation-kills-surface-loop isGroupoidO q {x = x} {p = p} alpha =
  isGroupoidO (q x) (q x) (cong q p) (cong q p) (cong (cong q) alpha) refl

------------------------------------------------------------------------
-- The surface-holonomy witness: an inhabitant of F x whose transport
-- around the 2-cell alpha (i.e. the mismatch between the two witnesses
-- of transporting around p, read off through alpha) fails to return to
-- itself.  Mirrors HolonomyWitness one dimension up.
------------------------------------------------------------------------

SurfaceHolonomyWitness :
  {X : Type ℓ} (F : X → Type ℓ'') (x : X) {p : x ≡ x} (alpha : p ≡ p)
  → Type ℓ''
SurfaceHolonomyWitness F x {p = p} alpha =
  Σ[ a ∈ F x ]
    ¬ (PathP (λ i → transport (cong F (alpha i)) a ≡ transport (cong F p) a)
             refl refl)

------------------------------------------------------------------------
-- THE OPEN GOAL.  Stated exactly, landed as a real hole, not postulated
-- and not faked shut.  A surface-holonomy witness at a loop whose
-- observed 2-cell is forced to refl (by the killing lemma above) should
-- obstruct DependentFactorsThrough, by the same route as
-- `kernel-holonomy-witness-obstructs-descent`, raised one dimension via
-- a square-level analogue of `transport-naturality`.
------------------------------------------------------------------------

surface-holonomy-obstructs-descent :
  {X : Type ℓ} {O : Type ℓ'}
  (q : X → O) (F : X → Type ℓ'')
  (x : X) {p : x ≡ x} (alpha : p ≡ p)
  → cong (cong q) alpha ≡ refl
  → SurfaceHolonomyWitness F x alpha
  → ¬ DependentFactorsThrough q F
surface-holonomy-obstructs-descent q F x {p = p} alpha killed witness = {!   !}
