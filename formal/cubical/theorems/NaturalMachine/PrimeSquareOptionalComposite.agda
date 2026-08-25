{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.PrimeSquareOptionalComposite
--
-- The concrete arithmetic control omitted by a whole-anatomy reading of T5:
-- modulus 5 is forced by the 5/25 collision, while an added composite modulus
-- 4 is inert on that collision and can be present or absent.  Thus the same
-- arithmetic instance has a unique forced core and multiple sound anatomies.
------------------------------------------------------------------------

module NaturalMachine.PrimeSquareOptionalComposite where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty as Empty using (⊥ ; rec)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Nat using (ℕ)
open import Cubical.Data.Sigma using (_×_ ; snd ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

import NaturalMachine.EndogenousHorizon as Horizon
import NaturalMachine.PinnedSensorForcing as Pinning

data Candidate : Type where
  subthreshold : Candidate
  add-composite-4 : Candidate
  add-modulus-5 : Candidate

package : Candidate → List ℕ
package subthreshold   = Horizon.thresh3
package add-composite-4 = 2 ∷ 3 ∷ 4 ∷ []
package add-modulus-5 = Horizon.thresh5

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

module Scheme = Pinning.Scheme LocalGood RefutesCollision

------------------------------------------------------------------------
-- Exactly one declared package separates this pair
------------------------------------------------------------------------

subthreshold-blind :
  Horizon.obs (package subthreshold) 5
    ≡ Horizon.obs (package subthreshold) 25
subthreshold-blind = Horizon.Separator.blind Horizon.sep-5-25

-- The additional composite sensor is executable arithmetic, not a stipulated
-- inert label: both remainders are 1 modulo 4, so reduction computes to the
-- same observation string.
composite-4-blind :
  Horizon.obs (package add-composite-4) 5
    ≡ Horizon.obs (package add-composite-4) 25
composite-4-blind = refl

subthreshold-cannot-refute : ¬ RefutesCollision subthreshold tt
subthreshold-cannot-refute refutation = refutation subthreshold-blind

composite-4-cannot-refute : ¬ RefutesCollision add-composite-4 tt
composite-4-cannot-refute refutation = refutation composite-4-blind

modulus-5-refutes : RefutesCollision add-modulus-5 tt
modulus-5-refutes = Horizon.horizon-grows

modulus-5-pin : Scheme.Pinned tt add-modulus-5
Scheme.Pinned.refutes modulus-5-pin = modulus-5-refutes
Scheme.Pinned.unique modulus-5-pin subthreshold refutation =
  Empty.rec (subthreshold-cannot-refute refutation)
Scheme.Pinned.unique modulus-5-pin add-composite-4 refutation =
  Empty.rec (composite-4-cannot-refute refutation)
Scheme.Pinned.unique modulus-5-pin add-modulus-5 refutation = refl

pinning-family : Scheme.PinningFamily
pinning-family tt bad = add-modulus-5 , modulus-5-pin

------------------------------------------------------------------------
-- One forced core, two sound arithmetic anatomies
------------------------------------------------------------------------

Least : Candidate → Type₀
Least subthreshold = ⊥
Least add-composite-4 = ⊥
Least add-modulus-5 = Unit

WithComposite : Candidate → Type₀
WithComposite subthreshold = ⊥
WithComposite add-composite-4 = Unit
WithComposite add-modulus-5 = Unit

least-contains : Scheme.ContainsPins Least pinning-family
least-contains tt bad = tt

with-composite-contains :
  Scheme.ContainsPins WithComposite pinning-family
with-composite-contains tt bad = tt

least-sound : Scheme.Sound Least
least-sound = Scheme.contains-pins→sound Least pinning-family least-contains

with-composite-sound : Scheme.Sound WithComposite
with-composite-sound =
  Scheme.contains-pins→sound
    WithComposite pinning-family with-composite-contains

PointwiseEquivalent :
  (Candidate → Type₀) → (Candidate → Type₀) → Type₀
PointwiseEquivalent Left Right =
  (candidate : Candidate) →
  (Left candidate → Right candidate) ×
  (Right candidate → Left candidate)

-- The composite modulus is admitted only by WithComposite.  Both anatomies
-- are sound because both contain the genuinely forced modulus-5 core.
least≠with-composite : ¬ PointwiseEquivalent Least WithComposite
least≠with-composite equivalent =
  snd (equivalent add-composite-4) tt

modulus-5-forced-in-every-sound-anatomy :
  { ℓ : Level } (Active : Candidate → Type ℓ) →
  Scheme.Sound Active → Active add-modulus-5
modulus-5-forced-in-every-sound-anatomy Active sound =
  Scheme.pinned-forces-active Active sound localBad modulus-5-pin

