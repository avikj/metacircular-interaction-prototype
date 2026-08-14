{-# OPTIONS --cubical --safe --no-import-sorts #-}
module ZZTestSolver where
open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Tactics.NatSolver.Reflection using (solve)

t1 : (y : ℕ) → (1 + y) · y + ((2 + y) + ((2 + y) + (2 + y)))
              ≡ (2 + y) · (2 + y) + 2
t1 = solve

t2 : (y : ℕ) → y · (2 + y) + ((2 + y) + (2 + y))
              ≡ (2 + y) · (2 + y) + 0
t2 = solve
