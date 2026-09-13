{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- जेट-प्रवाह — the jet's flux.
--
-- HolonomyFluxDerivation states the representation-independent Leibniz
-- seam of the holonomy–flux algebra as a record, FluxDerivation, and
-- proves flux-subdivision for any inhabitant; ParallelNetworkComposition
-- builds the product of two inhabitants.  Neither names one.  This file
-- names the first: the first-order jet.
--
--   §1  THE JET ALGEBRA.  A jet is a pair (a , a′) read as a + a′ε with
--       ε² = 0 — the square-zero extension, the tangent of a family at
--       its base point.  Sum is pointwise; product is the dual-number
--       product (ab , ab′ + a′b), the ε² term dropped because there is
--       no coordinate to hold it.
--
--   §2  THE EULER DERIVATION.  flux (a , a′) = (0 , a′) — ε·d/dε, the
--       operator that reads off the tangent component.  It satisfies
--       Leibniz on the nose: the ε-part of a product is a b′ + a′ b, and
--       that is exactly (flux x) y + x (flux y).  Proved from the
--       semiring laws of ℕ alone; no subtraction, no field.
--
--   §3  WHAT KIND OF DERIVATION IT IS.  Nonzero: flux (0 , 1) = (0 , 1).
--       Idempotent: it is the projection onto the tangent direction.
--       Scalars are its kernel: flux (a , 0) = (0 , 0), so a representation
--       that lands in the ε-free part is invisible to it, and a flux
--       insertion is nonzero exactly on holonomies that carry a tangent.
--
-- The corpus already holds the jet as a charge (TatkalikiGati: the prime
-- charge is the tangent of the parity character; EkaBhara: that jet is
-- the one generator).  Here the jet is where the flux lives, which is
-- the Lie-algebra reading of an LQG flux — an infinitesimal insertion —
-- given as a term.  प्रवाह (pravāha, flow/flux) is ordinary Sanskrit.
------------------------------------------------------------------------

module JetPravaha_TheFirstOrderJetCarriesANonzeroFluxDerivationSoTheLeibnizSeamHasAnInhabitant where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Nat
  using (ℕ ; zero ; suc ; _+_ ; _·_ ; +-zero ; +-comm ; 0≡m·0 ; snotz)
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Bool using (Bool)
open import Cubical.Algebra.Group.Base using (GroupStr)
open import Cubical.Algebra.Group.Instances.Bool using (BoolGroup)

open import HolonomyFluxDerivation using (FluxDerivation)

private
  module B = GroupStr (snd BoolGroup)

------------------------------------------------------------------------
-- १ · The jet algebra.
------------------------------------------------------------------------

Jet : Type₀
Jet = ℕ × ℕ

_⊞_ : Jet → Jet → Jet
(a , a′) ⊞ (b , b′) = (a + b , a′ + b′)

-- (a + a′ε)(b + b′ε) = ab + (ab′ + a′b)ε, ε² = 0.
_⊠_ : Jet → Jet → Jet
(a , a′) ⊠ (b , b′) = (a · b , a · b′ + a′ · b)

------------------------------------------------------------------------
-- २ · The Euler derivation and its Leibniz law.
------------------------------------------------------------------------

pravāha : Jet → Jet
pravāha (a , a′) = (zero , a′)

leibniz : (x y : Jet) → pravāha (x ⊠ y) ≡ (pravāha x ⊠ y) ⊞ (x ⊠ pravāha y)
leibniz (a , a′) (b , b′) = cong₂ _,_ mūla śeṣa
  where
  -- scalar part: 0 ≡ 0·b + a·0, and 0·b + a·0 computes to a·0.
  mūla : zero ≡ zero · b + a · zero
  mūla = 0≡m·0 a
  -- tangent part: a·b′ + a′·b ≡ (0·b′ + a′·b) + (a·b′ + a′·0),
  -- and the right side computes to a′·b + (a·b′ + a′·0).
  śeṣa : a · b′ + a′ · b ≡ (zero · b′ + a′ · b) + (a · b′ + a′ · zero)
  śeṣa =
      +-comm (a · b′) (a′ · b)
    ∙ cong (a′ · b +_) (sym (+-zero (a · b′)) ∙ cong (a · b′ +_) (0≡m·0 a′))

-- The inhabitant of the Leibniz seam.
jetPravāha : FluxDerivation ℓ-zero
FluxDerivation.Carrier jetPravāha = Jet
FluxDerivation._⋆_     jetPravāha = _⊠_
FluxDerivation._⊕_     jetPravāha = _⊞_
FluxDerivation.flux    jetPravāha = pravāha
FluxDerivation.leibniz jetPravāha = leibniz

------------------------------------------------------------------------
-- ३ · Nonzero, idempotent, and scalars are its kernel.
------------------------------------------------------------------------

-- The derivation is not zero: the unit tangent survives it.
pravāha-anasta : pravāha (zero , suc zero) ≡ (zero , zero) → ⊥
pravāha-anasta p = snotz (cong snd p)

-- It is the projection onto the tangent direction.
pravāha-idempotent : (x : Jet) → pravāha (pravāha x) ≡ pravāha x
pravāha-idempotent (a , a′) = refl

-- Scalars — jets with no tangent — are exactly what it kills.
pravāha-kernel : (a : ℕ) → pravāha (a , zero) ≡ (zero , zero)
pravāha-kernel a = refl

------------------------------------------------------------------------
-- ४ · The seam, inhabited end to end: a group, a representation into
--     the jet, and flux-subdivision specialised to them.
------------------------------------------------------------------------

-- ℤ/2 represented by the scalar unit: represent-mul holds by computation.
ekamātra : Bool → Jet
ekamātra _ = (suc zero , zero)

ekamātra-mul : (g h : Bool) → ekamātra (g B.· h) ≡ ekamātra g ⊠ ekamātra h
ekamātra-mul _ _ = refl

-- flux-subdivision, with every parameter concrete: a flux insertion on
-- a subdivided ℤ/2 edge splits into its two edge insertions in the jet.
bool-jet-subdivision =
  HolonomyFluxDerivation.flux-subdivision BoolGroup jetPravāha ekamātra ekamātra-mul

-- On this scalar representation every represented holonomy sits in the
-- kernel of §3: the insertion is zero.  A representation with a tangent
-- component is where the insertion is nonzero.
ekamātra-śūnya : (g : Bool) → pravāha (ekamātra g) ≡ (zero , zero)
ekamātra-śūnya g = pravāha-kernel (suc zero)
