{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module T1 where
open import Cubical.Foundations.Prelude
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection
open CommRingStr (ℤCommRing .snd)
R : Type
R = fst ℤCommRing
b3 : (a x : R) → a - 1r · x ≡ a - x
b3 = solve ℤCommRing
b4 : (D u v : R) → 1r · u + D · (0r · v) ≡ u
b4 = solve ℤCommRing
b5 : (u : R) → ((1r + 1r) · u) · u - 1r ≡ (1r + 1r) · (u · u) - 1r
b5 = solve ℤCommRing
b6 : (D u v x y : R) → (x · u + D · (y · v)) · u + D · ((x · v + y · u) · v)
   ≡ ((1r + 1r) · u) · (x · u + D · (y · v)) - (u · u - D · (v · v)) · x
b6 = solve ℤCommRing
