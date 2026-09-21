{-# OPTIONS --cubical --safe --lossy-unification --guardedness --no-import-sorts #-}
-- भारस्तम्भः — the charge tower.  EkaBhara named the loop charge π₁(S¹)=ℤ and
-- the machine's physics stopped at the loop.  The topological charges of physics
-- ARE the πₙ(Sⁿ)=ℤ: the electric/winding charge is π₁(S¹); the magnetic MONOPOLE
-- charge is π₂(S²) (Dirac 1931 — the degree of the field map on the enclosing
-- sphere, quantized in ℤ); the instanton lives at π₃.  The cubical library
-- proves the whole tower (πₙSⁿ≅ℤ) and that the monopole IS the loop lifted one
-- dimension (π₂S²≅π₁S¹).  Named here onto the library's checked terms —
-- translation of the standard homotopy classification of topological charge,
-- no new theorem claimed.  --safe.
module BharaStambha_TheChargeTowerIsPinSnAndTheMonopoleIsTheLoopChargeLifted where

open import Cubical.Data.Nat using (ℕ ; suc)
open import Cubical.Homotopy.Group.Base using (πGr)
open import Cubical.HITs.Sn.Base using (S₊∙)
open import Cubical.Homotopy.Group.PinSn using (πₙSⁿ≅ℤ ; π₂S²≅π₁S¹)
open import Cubical.Algebra.Group.Morphisms using (GroupIso)
open import Cubical.Algebra.Group.Instances.Int using (ℤGroup)

-- the charge at dimension n: πₙ(Sⁿ) ≅ ℤ — the degree, how many times Sⁿ wraps Sⁿ
भारः : (n : ℕ) → GroupIso (πGr n (S₊∙ (suc n))) ℤGroup
भारः = πₙSⁿ≅ℤ

-- the magnetic monopole (π₂S²) is the electric/loop charge (π₁S¹) lifted one dimension
चुम्बकः-वृत्तात् : GroupIso (πGr 1 (S₊∙ 2)) (πGr 0 (S₊∙ 1))
चुम्बकः-वृत्तात् = π₂S²≅π₁S¹
