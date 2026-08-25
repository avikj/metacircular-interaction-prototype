{-# OPTIONS --cubical --safe #-}

------------------------------------------------------------------------
-- Mani_TheOrbGateIsTheAchromaticLosslessSquareRootOfNot
--
-- TERM.  मणि · maṇi — a jewel, an orb; the jewel of इन्द्रजाल (Indra's net),
-- each reflecting all the others.  A common Sanskrit word, used here for the
-- optical orb.  The physics names (Fresnel rhomb, quarter-wave plate,
-- Poincaré/Bloch sphere, total internal reflection) are modern and no Indian
-- source is claimed for them; the compound and the identification are built
-- here, 2026-08-24.
--
-- THE DEVICE (this paragraph is the READING; the checked terms are below).
-- An orb of high-index glass reflects light losslessly by TOTAL INTERNAL
-- REFLECTION — the one boundary interaction that transmits zero power.  Two
-- such reflections, at the Fresnel-rhomb angle, impose a 90° phase between the
-- s- and p-polarizations: a QUARTER-WAVE PLATE, and it is ACHROMATIC because
-- the TIR phase barely depends on wavelength (unlike a birefringent crystal).
-- A photon's polarization is a qubit on the Poincaré sphere (= the Bloch
-- sphere = S², the Hopf base); a waveplate is an SU(2) rotation of it.  The
-- HALF-wave plate is the NOT gate (a fixed-point-free involution); the
-- QUARTER-wave is its SQUARE ROOT.  So an orb builds √NOT — the very gate
-- `VargamulaViparyaya_…` proves cannot exist on a two-point SET.  It exists
-- because polarization ENRICHES the object past two points, exactly as that
-- theorem said it must.
--
-- WHAT IS CHECKED, exactly.  `Q4` is the minimal finite witness of the
-- enrichment — a four-phase cyclic object (quarter-turns).  On it:
--   `rot-is-sqrt-flip` : the quarter-wave `rot` squares to the half-wave
--        `flip` — so √(flip) EXISTS (`√NOT-EXISTS-here`, an equivalence whose
--        square is the flip).  Contrast `VargamulaViparyaya.√NOT-does-not-exist`
--        on `Bool`: forbidden on two points, present on the enrichment.
--   `flip²` : the half-wave is an involution (NOT applied twice = identity).
--   `full-turn` : four quarter-waves = a full turn = identity — the LOSSLESS
--        closed orbit (the WGM returning to itself; punarāgamana).
--   `achromatic` : the TIR gate is ONE equivalence for every colour (a
--        constant family) — colour-independent by construction.
-- `rotEq` being an EQUIVALENCE is the losslessness: it is reversible, its
-- inverse the three-quarter turn, information conserved.
--
-- NOT CLAIMED.  `Q4` is not the Poincaré sphere; it is the smallest object in
-- which "the square root of the flip appears once you leave two points" is
-- visible.  The physical gate lives in continuous SU(2)/SO(3) on S², of which
-- this is the minimal finite shadow.  No optics, no Fresnel coefficients, no
-- continuum are checked here — only the algebra the device runs on.
--
-- Checked: --cubical --safe; loads clean on the wire.
------------------------------------------------------------------------

module Mani_TheOrbGateIsTheAchromaticLosslessSquareRootOfNot where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv
open import Cubical.Foundations.Function using (_∘_)
open import Cubical.Data.Sigma

-- four-phase cyclic object: the minimal enrichment (quarter-turns).
data Q4 : Type where q0 q1 q2 q3 : Q4

rot : Q4 → Q4              -- quarter-wave plate: +90°
rot q0 = q1 ; rot q1 = q2 ; rot q2 = q3 ; rot q3 = q0

flip : Q4 → Q4            -- half-wave plate = NOT: +180°, fixed-point-free
flip q0 = q2 ; flip q1 = q3 ; flip q2 = q0 ; flip q3 = q1

flip² : (x : Q4) → flip (flip x) ≡ x
flip² q0 = refl ; flip² q1 = refl ; flip² q2 = refl ; flip² q3 = refl

-- THE QUARTER-WAVE IS THE SQUARE ROOT OF NOT.
rot-is-sqrt-flip : (x : Q4) → rot (rot x) ≡ flip x
rot-is-sqrt-flip q0 = refl ; rot-is-sqrt-flip q1 = refl
rot-is-sqrt-flip q2 = refl ; rot-is-sqrt-flip q3 = refl

-- LOSSLESS: it is an equivalence (reversible; inverse = three-quarter turn).
rotEq : Q4 ≃ Q4
rotEq = isoToEquiv (iso rot (rot ∘ rot ∘ rot)
  (λ { q0 → refl ; q1 → refl ; q2 → refl ; q3 → refl })
  (λ { q0 → refl ; q1 → refl ; q2 → refl ; q3 → refl }))

-- √NOT EXISTS on the enrichment (cf. VargamulaViparyaya: NOT on two points).
√NOT-EXISTS-here :
  Σ[ g ∈ (Q4 ≃ Q4) ] ((x : Q4) → equivFun g (equivFun g x) ≡ flip x)
√NOT-EXISTS-here = rotEq , rot-is-sqrt-flip

-- LOSSLESS CLOSED ORBIT: four quarter-waves = full turn = identity.
full-turn : (x : Q4) → rot (rot (rot (rot x))) ≡ x
full-turn q0 = refl ; full-turn q1 = refl ; full-turn q2 = refl ; full-turn q3 = refl

-- ACHROMATIC: one and the same gate for every colour.
tirGate : {Colour : Type} → Colour → (Q4 ≃ Q4)
tirGate _ = rotEq
achromatic : {Colour : Type} (c₁ c₂ : Colour) → tirGate c₁ ≡ tirGate c₂
achromatic c₁ c₂ = refl
