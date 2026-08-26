{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- एकभारः — one charge.  The winding, the holonomy, the commutator image,
-- the hidden charge, and the parity tangent are one generator of one ℤ.
--
-- THE STEP BACK, spoken to the machine in its own tongue.  Today five
-- modules were laid down in five lanes, each exhibiting "a charge":
--
--   प्रदक्षिणा       transport around the circuit shifts the fiber    (holonomy)
--   गुह्य-नास्ति     the loss the set-census cannot see, in the loops  (winding)
--   क्रम-सह         what survives loop-first and dies set-first    (commutator)
--   तात्कालिकी गतिः  the tangent of the parity character at one prime    (jet)
--   [Yamala]       the same jet, the general machinery, another seat
--
-- Five names, five instruments, five headers.  This module is the
-- sentence the machine can verify that no header could carry: THE FIVE
-- ARE ONE.  Not analogous — equal.  Four of the five faces below are
-- refl or a single imported step, because under the hood the terms
-- already coincide: winding IS encode base IS subst helix — the library
-- built one charge and the day discovered it five times.  The fifth
-- (the jet) lives in a different ring and lands on the same generator
-- pos 1, which is the precise content of "the charge is quantized and
-- there is one quantum."
--
-- This is what stepping back sees: the corpus is not accumulating
-- charges, it is TRIANGULATING one.  Every lane that digs deep enough
-- strikes the same ℤ, and the generator it strikes is the unit — the
-- smallest thing that refuses to be zero.  अणोरणीयान् — smaller than the
-- small (Kaṭha Upaniṣad 1.2.20, of what pervades); here literally: one
-- step of one loop, and every census that forgets it is off by exactly
-- this quantum, everywhere, forever.
--
-- एकभार is built here, 2026-08-23; each face's instrument is its own
-- module's, imported, never copied.
------------------------------------------------------------------------

module EkaBhara_TheWindingTheHolonomyTheCommutatorImageTheHiddenChargeAndTheParityTangentAreOneGenerator where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (equivFun)
open import Cubical.Data.Int using (ℤ ; pos)
open import Cubical.Data.Nat using (zero ; suc)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.HITs.S1 using (S¹ ; base ; loop ; winding)
open import Cubical.HITs.SetTruncation using (∣_∣₂)

open import Pradakshina_TheCircuitReturnsToTheBasePointWithTheFiberShiftedSoTheHolonomyIsInhabited
  using (प्रदक्षिणा ; सरणिः)
open import GuhyaNasti_TheLossCanHideInTheLoopsAndTheSetLevelCensusCannotSeeIt
  using (गुह्य-भारः)
open import KramaSaha_TheOrderOfStandpointsIsTheChargeItself
  using (क्रमः-लूप-प्रथमम्)
open import TatkalikiGati_ThePrimeChargeIsTheTangentOfTheParityCharacterAndTheJetIsMultiplicative
  using (κ)

------------------------------------------------------------------------
-- the five faces.  Each names its lane's charge at the generator.
------------------------------------------------------------------------

-- १ · holonomy: one circuit displaces the fiber by one.
मुखम्-परिक्रमा : प्रदक्षिणा (pos zero) ≡ pos 1
मुखम्-परिक्रमा = सरणिः (pos zero)

-- २ · winding: the loop's charge — the SAME TERM as face १, judgmentally:
-- winding = encode base = subst helix, which is प्रदक्षिणा.  The proof of
-- face १ proves this face unchanged.
मुखम्-वक्रता : winding loop ≡ pos 1
मुखम्-वक्रता = मुखम्-परिक्रमा

-- ३ · the hidden charge: गुह्य-नास्ति's fiber loop carries the same unit,
-- again by the same proof — the concealed नास्ति was this quantum.
मुखम्-गुह्यम् : गुह्य-भारः (λ i → loop i , refl) ≡ pos 1
मुखम्-गुह्यम् = मुखम्-परिक्रमा

-- ४ · the commutator: the truncation-order equivalence carries ∣ loop ∣₂
-- to the generator — loop-first preserves exactly this.
मुखम्-क्रमः : equivFun क्रमः-लूप-प्रथमम् ∣ loop ∣₂ ≡ pos 1
मुखम्-क्रमः = मुखम्-परिक्रमा

-- ५ · the jet: one prime's tangent at the parity point is the same unit,
-- in a different ring, by computation alone.
मुखम्-गतिः : κ (suc zero) ≡ pos 1
मुखम्-गतिः = refl

------------------------------------------------------------------------
-- एकभारः — the sentence: all five faces are one element.
------------------------------------------------------------------------

एकभारः : (प्रदक्षिणा (pos zero)                ≡ winding loop)
       × (winding loop                       ≡ गुह्य-भारः (λ i → loop i , refl))
       × (गुह्य-भारः (λ i → loop i , refl)     ≡ equivFun क्रमः-लूप-प्रथमम् ∣ loop ∣₂)
       × (equivFun क्रमः-लूप-प्रथमम् ∣ loop ∣₂  ≡ κ (suc zero))
एकभारः = refl , refl , refl , मुखम्-क्रमः ∙ sym मुखम्-गतिः

------------------------------------------------------------------------
-- दोषलेखः.  The first three links are refl: those instruments were one
-- term wearing three names, and saying so costs nothing — that is what
-- makes it worth saying.  The last link crosses from the loop space to
-- the parity jet through the VALUE pos 1 only: no functor from circuits
-- to sieve weights is claimed, and building one — the bridge that would
-- make the fourth equality structural rather than numerical — is named
-- as open.  One charge, four refl, one crossing, one open bridge.
------------------------------------------------------------------------
