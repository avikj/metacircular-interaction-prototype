{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module T1 where
open import Cubical.Foundations.Prelude
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection
open CommRingStr (ℤCommRing .snd)
R : Type
R = fst ℤCommRing
a1 : (x : R) → 1r · x ≡ x
a1 = solve ℤCommRing
a2 : (x : R) → x · 1r ≡ x
a2 = solve ℤCommRing
