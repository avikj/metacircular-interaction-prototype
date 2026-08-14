{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module SolverProbe where
open import Cubical.Foundations.Prelude
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection
open CommRingStr (ℤCommRing .snd)
R : Type
R = fst ℤCommRing

-- 4 vars, degree 4
p4 : (a b c x : R) → (x · x · x · x + a · (x · x · x)) + (b · (x · x) + c · x + 1r)
                   ≡ (x · x · x · x + b · (x · x) + 1r) + x · (a · (x · x) + c)
p4 = solve ℤCommRing
