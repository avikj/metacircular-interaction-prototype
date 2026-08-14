{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}
module TmpProbe where
open import Cubical.Foundations.Prelude
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection
open import Gamma0Partner using (R ; M ; mul ; dia)
open CommRingStr (ℤCommRing .snd)

oneR : (x : R) → x · 1r ≡ x
oneR = solve ℤCommRing

dist2 : (p x y : R) → p · (x - y) ≡ p · x - p · y
dist2 = solve ℤCommRing

pmul : (d k p : R) → p · (d · k) ≡ (d · p) · k
pmul = solve ℤCommRing

dsimp : (x y : R) → x · y - 0r · 0r ≡ x · y
dsimp = solve ℤCommRing

commL : (x y : R) → x · y ≡ y · x
commL = solve ℤCommRing

zeroL : (x : R) → 0r + x ≡ x
zeroL = solve ℤCommRing

cancelSelf : (x : R) → x - x ≡ 0r
cancelSelf = solve ℤCommRing

regF : (c kq : R) → c ≡ (c - kq) + kq
regF = solve ℤCommRing
