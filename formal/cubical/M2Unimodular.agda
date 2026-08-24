-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Memory, charge, symmetry, price,
-- distance, verdict: six readings of the one fibre.  The kernel decides truth;
-- carriers ask and generate.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- M2Unimodular
--
-- The 2x2 toolkit the torsor theorems need, constructively: adjugate
-- identities (adj·H = H·adj = det·I, by solver, entrywise), det
-- multiplicativity (Binet at n=2, one polynomial identity), and the
-- nonvanishing of unimodular determinants (ε² = 1 → ε ≠ 0, the only
-- place discreteness of ℤ enters: 1 ≠ 0).
--
-- Next on top of this: freeness and transitivity of the Γ₀ action on
-- normalization events — the torsor of R0033, over all of ℤ.
------------------------------------------------------------------------

module M2Unimodular where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Empty using (⊥)
open import Cubical.Data.Nat using (snotz)
open import Cubical.Data.Int using (injPos)
open import Cubical.Algebra.CommRing
open import Cubical.Algebra.CommRing.Instances.Int
open import Cubical.Tactics.CommRingSolver.Reflection

open import Gamma0Partner using (R ; M ; mul ; dia)

open CommRingStr (ℤCommRing .snd)

adj : M → M
adj (a , b , c , e) = (e , - b , - c , a)

det : M → R
det (a , b , c , e) = a · e - b · c

idm : M
idm = dia 1r 1r

-- adjugate identities, entrywise by solver ---------------------------

private
  aL11 : (a b c e : R) → e · a + (- b) · c ≡ a · e - b · c
  aL11 _ _ _ _ = solve! ℤCommRing
  aL12 : (a b e : R) → e · b + (- b) · e ≡ 0r
  aL12 _ _ _ = solve! ℤCommRing
  aL21 : (a c e : R) → (- c) · a + a · c ≡ 0r
  aL21 _ _ _ = solve! ℤCommRing
  aL22 : (a b c e : R) → (- c) · b + a · e ≡ a · e - b · c
  aL22 _ _ _ _ = solve! ℤCommRing

  aR11 : (a b c e : R) → a · e + b · (- c) ≡ a · e - b · c
  aR11 _ _ _ _ = solve! ℤCommRing
  aR12 : (a b : R) → a · (- b) + b · a ≡ 0r
  aR12 _ _ = solve! ℤCommRing
  aR21 : (c e : R) → c · e + e · (- c) ≡ 0r
  aR21 _ _ = solve! ℤCommRing
  aR22 : (a b c e : R) → c · (- b) + e · a ≡ a · e - b · c
  aR22 _ _ _ _ = solve! ℤCommRing

adjL : (m : M) → mul (adj m) m ≡ dia (det m) (det m)
adjL (a , b , c , e) i =
  ( aL11 a b c e i , aL12 a b e i , aL21 a c e i , aL22 a b c e i )

adjR : (m : M) → mul m (adj m) ≡ dia (det m) (det m)
adjR (a , b , c , e) i =
  ( aR11 a b c e i , aR12 a b i , aR21 c e i , aR22 a b c e i )

-- determinant is multiplicative (Binet, n = 2) -----------------------

private
  binet : (a b c e a' b' c' e' : R)
        → (a · a' + b · c') · (c · b' + e · e')
          - (a · b' + b · e') · (c · a' + e · c')
          ≡ (a · e - b · c) · (a' · e' - b' · c')
  binet _ _ _ _ _ _ _ _ = solve! ℤCommRing

detMul : (x y : M) → det (mul x y) ≡ det x · det y
detMul (a , b , c , e) (a' , b' , c' , e') = binet a b c e a' b' c' e'

-- unimodular determinants do not vanish ------------------------------

oneNotZero : (1r ≡ 0r) → ⊥
oneNotZero p = snotz (injPos p)

private
  sq0 : (ε : R) → ε ≡ 0r → ε · ε ≡ 0r
  sq0 ε p = cong₂ _·_ p p ∙ z·z
    where
    z·z : 0r · 0r ≡ 0r
    z·z = solve! ℤCommRing

unimodularNonzero : (ε : R) → ε · ε ≡ 1r → (ε ≡ 0r) → ⊥
unimodularNonzero ε hε p = oneNotZero (sym hε ∙ sq0 ε p)
