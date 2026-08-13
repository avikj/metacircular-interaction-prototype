{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- KuttakaValli
--
-- The vallī of Āryabhaṭa's pulverizer as SYNTAX, its replay as
-- evaluation, and the two structural laws of the trace, typed:
--
--   replayHom   replay (xs ++ ys) ≡ replay xs · replay ys
--               — concatenating traces IS multiplying their payloads;
--                 the vallī is a monoid morphism from lists of
--                 quotients to 2×2 matrices.  (R0035's "the trace
--                 composes", as a theorem about syntax.)
--
--   detReplay   det (replay v) ≡ sgn v      (sgn = (-1)^length)
--               — the sign of a replay is the parity of the vallī;
--                 each division step L q = (q 1 / 1 0) reverses
--                 orientation exactly once.
--
-- The vallī is a term, replay is an evaluator, and the laws are
-- structural inductions whose entry obligations the ring solver
-- discharges — the trace calculus of the corpus, native in the
-- constructive lane.
------------------------------------------------------------------------

module KuttakaValli where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.List using (List ; [] ; _∷_ ; _++_)
open import Cubical.Data.Int using (predℤ)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

open import Gamma0Partner using (R ; M ; mul ; dia)
open import M2Unimodular using (det ; idm ; detMul)
open import Gamma0Freeness using (mulAssoc)

open CommRingStr (ℤCommRing .snd)

-- one division step of the pulverizer, as a matrix ---------------------

L : R → M
L q = (q , 1r , 1r , 0r)

-- the vallī is a list of quotients; replay evaluates it ---------------

Valli : Type
Valli = List R

replay : Valli → M
replay [] = idm
replay (q ∷ v) = mul (L q) (replay v)

-- law 1: concatenation is multiplication ------------------------------

private
  zA : (c : R) → 0r + c ≡ c
  zA = solve ℤCommRing

mulIdL : (x : M) → mul idm x ≡ x
mulIdL (a , b , c , e) i = ( a , b , zA c i , zA e i )

replayHom : (xs ys : Valli)
          → replay (xs ++ ys) ≡ mul (replay xs) (replay ys)
replayHom [] ys = sym (mulIdL (replay ys))
replayHom (q ∷ xs) ys =
  cong (mul (L q)) (replayHom xs ys)
  ∙ sym (mulAssoc (L q) (replay xs) (replay ys))

-- law 2: the sign of a replay is the parity of the vallī --------------

sgn : Valli → R
sgn [] = 1r
sgn (q ∷ v) = (- 1r) · sgn v

private
  mul0 : (q : R) → q · 0r ≡ 0r
  mul0 q = ·Comm q 0r

detL : (q : R) → det (L q) ≡ - 1r
detL q = cong predℤ (mul0 q)

detReplay : (v : Valli) → det (replay v) ≡ sgn v
detReplay [] = refl
detReplay (q ∷ v) =
  detMul (L q) (replay v)
  ∙ cong₂ _·_ (detL q) (detReplay v)
