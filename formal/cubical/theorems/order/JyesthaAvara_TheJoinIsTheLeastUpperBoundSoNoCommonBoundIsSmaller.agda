{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- ज्येष्ठावर — THE JOIN IS THE LEAST UPPER BOUND, SO NO COMMON BOUND
-- IS SMALLER.
--
-- Checked at the pin: Agda 2.8.0, agda/cubical v0.9 -- EXIT 0
-- (2026-08-29).
--
-- THE QUESTION.  Does this substrate settle OPTIMALITY, not merely
-- correctness?  An optimality claim has two halves: a thing works, and
-- nothing works better.  The second half is a universal over all rival
-- solutions.  Once the frame is bounded the rivals are a finite set, so
-- "nothing better" is a finite certificate — and a finite certificate
-- is exactly what this kernel signs.  This module is one worked
-- instance, end to end.
--
-- THE PROBLEM.  Given x and y, produce the least z with x ≤ z and
-- y ≤ z — the smallest common upper bound.  The candidate solution is
-- the kernel's own join, `max`, with `le` its order (both transcribed
-- verbatim from interactive/ProofGate.hs, so this is the wire's own
-- arithmetic).  Optimality of `max` is TWO theorems:
--   · ub-left, ub-right  — max IS a common upper bound (correctness);
--   · least              — max is BELOW every common upper bound, so no
--                          common upper bound is smaller than max
--                          (the lower-bound half: nothing does better).
-- Together: `max` is not merely a correct upper bound, it is the
-- optimal one, and the optimality is a checked term, not an argument.
--
-- Every reduction rule used was certified on the wire first
-- (interactive/run-yantra.sh --wire); the kernel's rejections of the
-- naive single-variable shapes named the stuck base clauses
-- (le x (max x zero) ≢ 1, max zero y ≢ y), which is what fixed the
-- shapes below.
--
-- SYĀT.  `max`, `le` are functions on ℕ; "upper bound", "least",
-- "optimal" are the reading of `le _ _ ≡ 1`.  What is proved is the
-- three theorems.  The general claim — that every optimality problem
-- with a finite frame is so settled — is NOT proved here; this is one
-- instance exhibiting the shape, not the universal over all problems.
------------------------------------------------------------------------

module JyesthaAvara_TheJoinIsTheLeastUpperBoundSoNoCommonBoundIsSmaller where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; znots)
open import Cubical.Data.Sigma using (_×_ ; _,_)
open import Cubical.Data.Empty as Empty using (⊥)

------------------------------------------------------------------------
-- §1  The wire's own join and order.
------------------------------------------------------------------------

max : ℕ → ℕ → ℕ
max a zero          = a
max zero b          = b
max (suc a) (suc b) = suc (max a b)

-- le a b ≡ 1 reads "a ≤ b"; le a b ≡ 0 reads "a > b".
le : ℕ → ℕ → ℕ
le zero    b       = suc zero
le (suc a) zero    = zero
le (suc a) (suc b) = le a b

le-reflexive : (x : ℕ) → le x x ≡ suc zero
le-reflexive zero    = refl
le-reflexive (suc x) = le-reflexive x

------------------------------------------------------------------------
-- §2  CORRECTNESS: max is a common upper bound of x and y.
------------------------------------------------------------------------

ub-left : (x y : ℕ) → le x (max x y) ≡ suc zero
ub-left zero    y       = refl
ub-left (suc x) zero    = le-reflexive (suc x)
ub-left (suc x) (suc y) = ub-left x y

ub-right : (x y : ℕ) → le y (max x y) ≡ suc zero
ub-right x       zero    = refl
ub-right zero    (suc y) = le-reflexive (suc y)
ub-right (suc x) (suc y) = ub-right x y

------------------------------------------------------------------------
-- §3  OPTIMALITY: max is below every common upper bound.  No z that
--     bounds both x and y is smaller than max x y — nothing does
--     better.  The impossible case (a "bound" below x on both sides)
--     is refuted by znots, not assumed away.
------------------------------------------------------------------------

least : (x y z : ℕ)
      → le x z ≡ suc zero → le y z ≡ suc zero
      → le (max x y) z ≡ suc zero
least zero    zero    z       hx hy = hx
least zero    (suc y) z       hx hy = hy
least (suc x) zero    z       hx hy = hx
least (suc x) (suc y) zero    hx hy = Empty.rec (znots hx)
least (suc x) (suc y) (suc z) hx hy = least x y z hx hy

------------------------------------------------------------------------
-- §4  The optimum, stated as one object: max is A common upper bound,
--     and THE least one.  This triple is what "optimal solution to the
--     least-common-upper-bound problem" means, in full, checked.
------------------------------------------------------------------------

is-optimal-join : (x y : ℕ)
  → (le x (max x y) ≡ suc zero)
  × (le y (max x y) ≡ suc zero)
  × ((z : ℕ) → le x z ≡ suc zero → le y z ≡ suc zero
             → le (max x y) z ≡ suc zero)
is-optimal-join x y = ub-left x y , ub-right x y , least x y
