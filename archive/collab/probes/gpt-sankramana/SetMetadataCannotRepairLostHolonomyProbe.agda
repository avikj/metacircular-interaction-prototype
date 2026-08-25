{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- SetMetadataCannotRepairLostHolonomyProbe
--
-- Adding more set-valued fields cannot repair a set-valued observer's loss
-- of holonomy.  The product of two sets is a set, so augmenting q with any
-- metadata m still kills every observed loop.  The repair must raise the
-- observer's h-level rather than widen its record.
------------------------------------------------------------------------

module SetMetadataCannotRepairLostHolonomyProbe where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.HLevels using (isSet×)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Relation.Nullary using (¬_)

open import HolonomyDescentObstructionCorrectedProbe using (HolonomyWitness)
open import SetValuedObservationCannotCarryHolonomyProbe
  using (set-valued-observation-cannot-carry-holonomy)
open import AvataranaBhanga_TheQuotientCannotHostTheTypeOfWitnessesAndTheProofIsOneTransport
  using (DependentFactorsThrough)

private
  variable
    ℓ ℓ' ℓ'' ℓ''' : Level

set-metadata-cannot-repair-holonomy :
  {X : Type ℓ} {O : Type ℓ'} {M : Type ℓ''}
  (isSetO : isSet O) (isSetM : isSet M)
  (q : X → O) (metadata : X → M)
  (F : X → Type ℓ''')
  (x : X) (p : x ≡ x)
  → HolonomyWitness F x p
  → ¬ DependentFactorsThrough (λ z → q z , metadata z) F
set-metadata-cannot-repair-holonomy
  isSetO isSetM q metadata F x p witness =
  set-valued-observation-cannot-carry-holonomy
    (isSet× isSetO isSetM)
    (λ z → q z , metadata z)
    F x p witness
