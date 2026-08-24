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
-- NaturalMachine.ChenTwoChargeProjector
--
-- Factory IV's exact two-charge seam.  This is support geometry parameterized
-- by an arithmetic witness field; it proves no Chen, twin-prime, or Goldbach
-- theorem.  Algebraic commutation of two projections is kept sharply distinct
-- from any lower-bound/intersection claim.
------------------------------------------------------------------------

module NaturalMachine.ChenTwoChargeProjector where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Foundations.Isomorphism using (iso ; isoToEquiv)
open import Cubical.Data.Bool using (Bool ; true ; false ; isSetBool)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; ΣPathP)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty using (⊥ ; rec)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

data Charge : Type₀ where
  one two : Charge

-- Liouville parity on the two admitted charges: Ω=1 is odd, Ω=2 is even.
liouvilleParity : Charge → Bool
liouvilleParity one = false
liouvilleParity two = true

-- Project onto the charge-one channel.  The complement of Liouville parity
-- is written directly, avoiding integer division by two.
chargeOneProjector : Charge → Bool
chargeOneProjector one = true
chargeOneProjector two = false

chargeOneFiber : Type₀
chargeOneFiber = Σ[ charge ∈ Charge ] chargeOneProjector charge ≡ true

chargeOneFiber≃Unit : chargeOneFiber ≃ Unit
chargeOneFiber≃Unit = isoToEquiv (iso to from to-from from-to)
  where
  to : chargeOneFiber → Unit
  to _ = tt

  from : Unit → chargeOneFiber
  from _ = one , refl

  to-from : (u : Unit) → to (from u) ≡ u
  to-from tt = refl

  from-to : (x : chargeOneFiber) → from (to x) ≡ x
  from-to (one , proof) = ΣPathP (refl , isSetBool _ _ _ _)
  from-to (two , proof) = rec (subst impossible proof tt)
    where
    impossible : Bool → Type₀
    impossible false = Unit
    impossible true = ⊥

------------------------------------------------------------------------
-- Finite two-dimensional support and commuting projections
------------------------------------------------------------------------

SupportField : Type₁
SupportField = ℕ → Charge → Type₀

Support : SupportField → Type₀
Support W = Σ[ radius ∈ ℕ ] Σ[ charge ∈ Charge ] W radius charge

RadiusThenCharge ChargeThenRadius :
  (W : SupportField) → ℕ → Charge → Type₀
RadiusThenCharge W radius charge =
  Σ[ point ∈ Support W ]
    ((fst point ≡ radius) × (fst (snd point) ≡ charge))
ChargeThenRadius W radius charge =
  Σ[ point ∈ Support W ]
    ((fst (snd point) ≡ charge) × (fst point ≡ radius))

projections-commute : (W : SupportField) (radius : ℕ) (charge : Charge)
  → RadiusThenCharge W radius charge ≃ ChargeThenRadius W radius charge
projections-commute W radius charge =
  isoToEquiv (iso forward backward forward-backward backward-forward)
  where
  forward : RadiusThenCharge W radius charge → ChargeThenRadius W radius charge
  forward (point , radiusPath , chargePath) = point , chargePath , radiusPath

  backward : ChargeThenRadius W radius charge → RadiusThenCharge W radius charge
  backward (point , chargePath , radiusPath) = point , radiusPath , chargePath

  forward-backward : (x : ChargeThenRadius W radius charge)
    → forward (backward x) ≡ x
  forward-backward x = refl

  backward-forward : (x : RadiusThenCharge W radius charge)
    → backward (forward x) ≡ x
  backward-forward x = refl

------------------------------------------------------------------------
-- Two cofinal faces need not meet at the desired corner
------------------------------------------------------------------------

CenteredField : Type₁
CenteredField = ℕ → ℕ → Charge → Type₀

-- Constructive "beyond N": the field has a witness at center suc N.  This
-- form is sufficient for the countermodel and avoids importing analytic order.
RadiusOneCofinal : CenteredField → Type₀
RadiusOneCofinal W =
  (bound : ℕ) → Σ[ charge ∈ Charge ] W (suc bound) 1 charge

ChargeOneCofinal : CenteredField → Type₀
ChargeOneCofinal W =
  (bound : ℕ) → Σ[ radius ∈ ℕ ] W (suc bound) radius one

CornerCofinal : CenteredField → Type₀
CornerCofinal W = (bound : ℕ) → W (suc bound) 1 one

-- At every center there are exactly the two crossed faces needed:
-- radius one at charge two, and charge one at radius two.
CrossedFaces : CenteredField
CrossedFaces center radius charge =
  ((radius ≡ 1) × (charge ≡ two))
  ⊎ ((radius ≡ 2) × (charge ≡ one))

radius-one-is-cofinal : RadiusOneCofinal CrossedFaces
radius-one-is-cofinal bound = two , inl (refl , refl)

charge-one-is-cofinal : ChargeOneCofinal CrossedFaces
charge-one-is-cofinal bound = 2 , inr (refl , refl)

one≢two : ¬ (one ≡ two)
one≢two path = subst distinguish path tt
  where
  distinguish : Charge → Type₀
  distinguish one = Unit
  distinguish two = ⊥

one≢twoℕ : ¬ (1 ≡ 2)
one≢twoℕ path = subst distinguish path tt
  where
  distinguish : ℕ → Type₀
  distinguish zero = Unit
  distinguish (suc zero) = Unit
  distinguish (suc (suc _)) = ⊥

corner-is-empty : (center : ℕ) → ¬ (CrossedFaces center 1 one)
corner-is-empty center (inl (radiusPath , chargePath)) = one≢two chargePath
corner-is-empty center (inr (radiusPath , chargePath)) = one≢twoℕ radiusPath

two-cofinal-faces-do-not-force-corner : ¬ (CornerCofinal CrossedFaces)
two-cofinal-faces-do-not-force-corner corner = corner-is-empty 1 (corner zero)

------------------------------------------------------------------------
-- Rigor boundary
--
-- Checked: exact two-charge parity/projector, its singleton fiber, commutation
-- of radius and charge restrictions for every parameterized finite support,
-- and an explicit field with two cofinal faces but an empty (1,one) corner.
--
-- Not claimed: that the parameterized witnesses are primes or semiprimes, or
-- any arithmetic Chen/twin/Goldbach lower bound.  Projection commutation is
-- algebra; intersection inhabitation is additional arithmetic content.
------------------------------------------------------------------------
