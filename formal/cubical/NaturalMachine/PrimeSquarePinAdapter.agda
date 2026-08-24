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
-- NaturalMachine.PrimeSquarePinAdapter
--
-- EndogenousHorizon already checks the concrete F30/T5 collision:
-- divisibility observations at moduli 2 and 3 cannot distinguish 5 from 25,
-- while adjoining modulus 5 does.  This module turns exactly those two paths
-- into a PinnedSensorForcing witness.
--
-- The candidate universe deliberately has only the two declared observation
-- packages.  Nothing here defines primality, proves 25 composite, or
-- classifies every natural modulus.  It compiles one checked behavioral
-- obstruction into one forced sensor admission, at precisely its known scope.
------------------------------------------------------------------------

module NaturalMachine.PrimeSquarePinAdapter where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty as Empty using (⊥ ; rec)
open import Cubical.Data.List using (List)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (fst ; snd ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.EndogenousHorizon as Horizon
import NaturalMachine.PinnedSensorForcing as Pinning

------------------------------------------------------------------------
-- The declared finite sensor universe
------------------------------------------------------------------------

data Candidate : Type where
  subthreshold : Candidate
  extend-by-5  : Candidate

package : Candidate → List ℕ
package subthreshold = Horizon.thresh3
package extend-by-5  = Horizon.thresh5

-- A package refutes the local bad world exactly when it separates the two
-- endpoints of the already checked prime-square collision.
RefutesCollision : Candidate → Unit → Type₀
RefutesCollision candidate tt =
  ¬ (Horizon.obs (package candidate)
       (Horizon.Separator.good Horizon.sep-5-25)
     ≡ Horizon.obs (package candidate)
       (Horizon.Separator.bad Horizon.sep-5-25))

LocalGood : Unit → Type₀
LocalGood tt = ⊥

localBad : ¬ LocalGood tt
localBad impossible = impossible

module CollisionScheme =
  Pinning.Scheme LocalGood RefutesCollision

------------------------------------------------------------------------
-- The exact adapter
------------------------------------------------------------------------

-- The original blindness path is a proof that the sub-threshold package does
-- NOT refute the pair.  No arithmetic is replayed here.
subthreshold-cannot-refute : ¬ RefutesCollision subthreshold tt
subthreshold-cannot-refute claims-separation =
  claims-separation (Horizon.Separator.blind Horizon.sep-5-25)

-- Conversely, EndogenousHorizon's checked threshold-growth theorem is exactly
-- the required refutation witness for the extended package.
extend-by-5-refutes : RefutesCollision extend-by-5 tt
extend-by-5-refutes = Horizon.horizon-grows

prime-square-pin : CollisionScheme.Pinned tt extend-by-5
CollisionScheme.Pinned.refutes prime-square-pin = extend-by-5-refutes
CollisionScheme.Pinned.unique prime-square-pin subthreshold refutation =
  Empty.rec (subthreshold-cannot-refute refutation)
CollisionScheme.Pinned.unique prime-square-pin extend-by-5 refutation = refl

prime-square-pinning-family : CollisionScheme.PinningFamily
prime-square-pinning-family tt bad = extend-by-5 , prime-square-pin

-- This is T5 at the exact compiled scope: every sound anatomy over these two
-- packages must admit the modulus-5 extension.
prime-square-forces-extension :
  { ℓ : Level } (Active : Candidate → Type ℓ) →
  CollisionScheme.Sound Active → Active extend-by-5
prime-square-forces-extension Active sound =
  CollisionScheme.pinned-forces-active
    Active sound localBad prime-square-pin

------------------------------------------------------------------------
-- Positive control: the least forced anatomy is itself sound
------------------------------------------------------------------------

LeastAnatomy : Candidate → Type₀
LeastAnatomy subthreshold = ⊥
LeastAnatomy extend-by-5  = Unit

least-contains-pin :
  CollisionScheme.ContainsPins
    LeastAnatomy prime-square-pinning-family
least-contains-pin tt bad = tt

least-anatomy-sound : CollisionScheme.Sound LeastAnatomy
least-anatomy-sound =
  CollisionScheme.contains-pins→sound
    LeastAnatomy prime-square-pinning-family least-contains-pin

least-anatomy-really-admits-5 : LeastAnatomy extend-by-5
least-anatomy-really-admits-5 =
  prime-square-forces-extension LeastAnatomy least-anatomy-sound
