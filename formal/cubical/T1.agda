{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module T1 where
open import Cubical.Foundations.Prelude
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection
open CommRingStr (ℤCommRing .snd)
R : Type
R = fst ℤCommRing
b6 : (D u v x y : R) → (x · u + D · (y · v)) · u + D · ((x · v + y · u) · v)
   ≡ ((1r + 1r) · u) · (x · u + D · (y · v)) - (u · u - D · (v · v)) · x
b6 = solve ℤCommRing
b7gen : (e u : R) → ((e + e) · u) · u - e ≡ (e + e) · (u · u) - e
b7gen = solve ℤCommRing
b7 : (u : R) → ((1r + 1r) · u) · u - 1r ≡ (1r + 1r) · (u · u) - 1r
b7 u = b7gen 1r u
