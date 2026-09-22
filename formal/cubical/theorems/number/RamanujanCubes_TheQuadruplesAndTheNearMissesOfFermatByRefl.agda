{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- रामानुजन्, घन — THE QUADRUPLES, AND THE NEAR-MISSES OF FERMAT,
-- BY REFL.
--
-- From the notebooks: cube quadruples a³ + b³ + c³ = d³ and the
-- taxicab's shadow, x³ + y³ = z³ ± 1 — Fermat missed by one, which
-- Ramanujan parameterized completely.  Every statement below is a
-- closed computation the kernel performs; the largest sums five
-- million units in unary and does not blink.
--
--   quadruples:   3,4,5,6   1,6,8,9   7,14,17,20   11,15,27,29
--   (7,14,17,20 is Ramanujan's parametric family at (a,b) = (2,1):
--    3a²+5ab−5b², 4a²−4ab+6b², 5a²−5ab−3b², 6a²−4ab+4b².)
--
--   near-misses:  6³ + 8³ + 1 ≡ 9³        (Fermat fails by one, low)
--                 9³ + 10³ ≡ 12³ + 1      (the taxicab itself: 1729)
--                 135³ + 138³ + 1 ≡ 172³  (the notebook's big one)
------------------------------------------------------------------------

module RamanujanCubes_TheQuadruplesAndTheNearMissesOfFermatByRefl where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; _+_ ; _·_)
open import Cubical.Data.Sigma

open import Ramanujan1729_TheTaxicabNumberBothRepresentationsByReflAndMinimalityByBoundedReflection
  using (cube)

quadruple-3456 : cube 3 + cube 4 + cube 5 ≡ cube 6
quadruple-3456 = refl

quadruple-1689 : cube 1 + cube 6 + cube 8 ≡ cube 9
quadruple-1689 = refl

quadruple-7-14-17-20 : cube 7 + cube 14 + cube 17 ≡ cube 20
quadruple-7-14-17-20 = refl

quadruple-11-15-27-29 : cube 11 + cube 15 + cube 27 ≡ cube 29
quadruple-11-15-27-29 = refl

near-miss-low : cube 6 + cube 8 + 1 ≡ cube 9
near-miss-low = refl

near-miss-taxicab : cube 9 + cube 10 ≡ cube 12 + 1
near-miss-taxicab = refl

near-miss-large : cube 135 + cube 138 + 1 ≡ cube 172
near-miss-large = refl
