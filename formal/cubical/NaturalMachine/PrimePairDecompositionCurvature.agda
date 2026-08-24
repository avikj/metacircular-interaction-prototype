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
-- NaturalMachine.PrimePairDecompositionCurvature
--
-- Delta 26 §31's Prime-Pair calibration, on its exact finite carrier.
-- The carrier is the three residue classes modulo 3 and `Unit3 r` means
-- that the affine form in class r avoids the prime 3 locally.
--
-- The endpoint pattern {0,4} is locally admissible: starting in residue 1,
-- its two forms lie in residues 1 and 2.  The architecture that insists on
-- the materialized waypoint {0,2,4} is locally empty: in every starting
-- residue exactly one of the three forms lies in residue 0.
--
-- This is a decomposition-loss certificate, not a primality theorem.
-- In particular the integer tuple (3,5,7) is the familiar exceptional path:
-- it contains a form equal to the local modulus itself and therefore lies
-- outside the `Unit3` carrier.  Nothing below proves Goldbach, a prime-pair
-- asymptotic, or the absence of prime triples in the integers.
------------------------------------------------------------------------

module NaturalMachine.PrimePairDecompositionCurvature where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Sigma using (Σ; _×_; _,_)
open import Cubical.Relation.Nullary using (¬_)

data Residue3 : Type₀ where
  r0 r1 r2 : Residue3

-- Translation by the two offsets introduced by the proposed factorization.
-- `plus4` is addition by 4 modulo 3, hence addition by 1.
plus2 plus4 : Residue3 → Residue3
plus2 r0 = r2
plus2 r1 = r0
plus2 r2 = r1

plus4 r0 = r1
plus4 r1 = r2
plus4 r2 = r0

-- Local admissibility away from the modulus 3 itself.
data Unit3 : Residue3 → Type₀ where
  unit1 : Unit3 r1
  unit2 : Unit3 r2

zero-is-not-unit : ¬ Unit3 r0
zero-is-not-unit ()

-- The endpoint asks only for the two affine forms p and p+4.
Endpoint04 : Type₀
Endpoint04 = Σ[ r ∈ Residue3 ] Unit3 r × Unit3 (plus4 r)

endpoint04-feasible : Endpoint04
endpoint04-feasible = r1 , unit1 , unit2

-- The proposed proof/workflow architecture materializes p+2 as a mandatory
-- waypoint.  The nested pair keeps all three local witnesses proof-relevant.
Waypoint024 : Type₀
Waypoint024 =
  Σ[ r ∈ Residue3 ] (Unit3 r × Unit3 (plus2 r)) × Unit3 (plus4 r)

-- No minimizer or search restricted to this carrier can repair the loss:
-- each residue case exposes the particular affine form divisible by 3.
waypoint024-obstructed : ¬ Waypoint024
waypoint024-obstructed (r0 , ((u0 , u2) , u1)) = zero-is-not-unit u0
waypoint024-obstructed (r1 , ((u1 , u0) , u2)) = zero-is-not-unit u0
waypoint024-obstructed (r2 , ((u2 , u1) , u0)) = zero-is-not-unit u0

-- Boolean-feasibility curvature is infinite on this local task: the target
-- endpoint has a witness while the chosen factorization has none.
prime-pair-decomposition-loss : Endpoint04 × (¬ Waypoint024)
prime-pair-decomposition-loss = endpoint04-feasible , waypoint024-obstructed

