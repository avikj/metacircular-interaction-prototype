{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

-- WITNESSES FOR THE COST GEOMETRY
--
-- `CostGeometry` states the structure and proves two theorems about it.
-- This module supplies the two instances that make those theorems mean
-- something, kept separate so each is falsifiable on its own.
--
--   (W1) the repo's OWN measured edge, as a NEGATIVE instance: transporting
--        `+` from unary ℕ to binary words is not a speedup, and T1 says so
--        without rerunning the 35.8-second benchmark;
--
--   (W2) a POSITIVE instance: a residue-style presentation where the work
--        gap exceeds the round trip, so the detour provably wins.  This is
--        the shape of CRT multiplication, Karatsuba and the FFT.
--
-- Honesty about W2: the weights are STIPULATED, not measured here.  That is
-- exactly the epistemic status an algorithm designer's cost model has --
-- "schoolbook is n², componentwise is n, conversion is linear" is an
-- assumption about an implementation, and the theorem is what follows FROM
-- it.  What is proved here is the implication, and the implication is the
-- part that was folklore.

module CostGeometryWitness where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_)
open import Cubical.Data.Nat.Order using (_<_ ; _≤_)
open import Cubical.Data.Unit using (Unit ; tt)

open import CostGeometry

--------------------------------------------------------------------------
-- Two schematic presentations.  Carriers are irrelevant to the weights, so
-- the witnesses use a trivial carrier: the geometry is about the numbers on
-- the edges, and pretending otherwise would smuggle in unchecked content.
--------------------------------------------------------------------------

triv : Presentation
triv = pres Unit (λ _ _ → tt)

step : Cost → Edge triv triv
step c = edge (λ _ → tt) c

--------------------------------------------------------------------------
-- (W1)  THE MEASURED EDGE IS A NEGATIVE INSTANCE
--
-- TransportCost: native ripple-carry is FLAT in the number of chained
-- operations; the transported term pays a full round trip through unary ℕ
-- per operation.  So the far side's work is not smaller -- take them equal
-- and even then, by T1, no detour can win.  The measurement said 3.5s /
-- 12.2s / 35.8s; the theorem says "never", for free.
--------------------------------------------------------------------------

measured-edge-is-no-speedup :
    (travelOut travelBack w : Cost)
  → NoSpeedup (step travelOut) (step travelBack) w w
measured-edge-is-no-speedup travelOut travelBack w =
  transport-is-never-free (step travelOut) (step travelBack) w w (0 , refl)

--------------------------------------------------------------------------
-- (W2)  A CERTIFIED SPEEDUP
--
-- Stipulated cost model for multiplying two ten-digit operands:
--
--   home  (schoolbook, digit by digit)      work = 100   (= 10²)
--   far   (residue system, componentwise)   work =  10
--   out   (convert one operand in)          cost =  20
--   back  (reconstruct the result)          cost =  20
--
-- detour = (20 + 20) + (20 + 10) = 70  <  100 = direct.
--
-- The witness is `refl`-checked: 70 < 100 holds by 29 + suc 70 ≡ 100, which
-- Agda verifies by computation, not by assertion.
--------------------------------------------------------------------------

homeWork farWork travel : Cost
homeWork = 100
farWork  = 10
travel   = 20

residue-speedup :
  Speedup (step travel) (step travel) homeWork farWork
residue-speedup = 29 , refl

-- Its consequence, read back through T2: any such win forces the far
-- presentation to be strictly better at the work itself.  Here 10 < 100 --
-- and the point is that this was DERIVED from the route being cheaper, not
-- assumed.  A speedup is never bought with translation alone.

residue-neighbour-is-better : farWork < homeWork
residue-neighbour-is-better =
  speedup-forces-better-neighbour
    (step travel) (step travel) homeWork farWork residue-speedup

--------------------------------------------------------------------------
-- (W3)  THE AMORTISATION THRESHOLD
--
-- The design rule algorithm designers use without stating it: a detour pays
-- exactly when the WORK GAP exceeds the ROUND TRIP.  Unfolding `detour`,
-- that is the whole content -- which is why it deserves to be written down
-- once rather than rediscovered per algorithm.
--------------------------------------------------------------------------

gap-beats-travel :
    (travelOut travelBack wHere wThere : Cost)
  → ((travelOut + travelOut) + (travelBack + wThere)) < wHere
  → Speedup (step travelOut) (step travelBack) wHere wThere
gap-beats-travel travelOut travelBack wHere wThere gap = gap

-- CHECKED: Agda 2.6.3, cubical **v0.7** (/tmp/cubical), --cubical --safe,
-- 2026-08-15.  No postulates, no holes.  NOT verified against the pin in
-- formal/cubical/BUILD.md (Agda 2.8.0, cubical v0.9), nor against the v0.5
-- the rest of this lane's headers quote: three toolchain states are live in
-- this repository at once and this file has only seen one of them.
