{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- BhavanaSemiring � Brahmagupta's composition law over �, proved.
--
-- BRAHMAGUPTA, Brhmasphuasiddhnta, 628 CE, ch. 18, the rule called
-- bhvan ("production", "composition"):
--
--     (x�² − D y�²)(x�² − D y�²)
--        = (x�x� + D y�y�)² − D(x�y� + x�y�)²
--
-- the multiplicativity of the norm form N(x,y) = x² − D y².  `Bhavana.agda`
-- carries it over �.  This file is about �, and about a fact that is not a
-- restatement of Brahmagupta but a consequence of putting him in a place he
-- was not working in.
--
-- BHVAN AS STATED IS FALSE OVER �.  Monus is truncated: where both true
-- norms are negative, each side flattens to 0 and the identity fails.  The
-- witness, found by exhaustive search in machine/thoughts.bhavana.math, is
-- (x�,y�,x�,y�) = (0,1,0,1): the true norms are (−1,−1) at D = 1, so the
-- left side is 0 � 0 = 0 while the right side is 1.
--
-- The repair is the one this repository uses everywhere for denominators �
-- clear the offending operation instead of restricting the domain.  Move
-- every negative term across.  With cx = x�x� + D y�y� and
-- cy = x�y� + x�y�, bhvan becomes, subtraction-free:
--
--     cx² + D x�² y�² + D x�² y�²  =  x�² x�² + D² y�² y�² + D cy²
--
-- Over � that is bhvan, by adding the same two terms to both sides.  Over
-- � it is true with NO hypothesis and no monus at all.
--
-- WHY THIS FILE EXISTS.  That statement was verified on 28561 points at
-- D = 1 and D = 2, zero failures.  Exhaustive checking of a *bounded box* is
-- not a proof of a statement quantified over all of � � CLAUDE.md is explicit
-- that a finite exhaustive verification is proof only of what it exhausts.
-- The identity is in fact a commutative-semiring identity: expanding both
-- sides gives the same five monomials, with the cross term 2D x�x�y�y�
-- appearing once on each side.  So it needs no induction, no ordering, and
-- no subtraction � it holds in ANY commutative semiring, and � is one.
--
-- 28561 points become � x� y� x� y� : �.
------------------------------------------------------------------------

module BhavanaSemiring where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; _+_ ; _·_)
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

-- the two composed coordinates, exactly as Brahmagupta gives them
cx : ℕ → ℕ → ℕ → ℕ → ℕ → ℕ
cx D x₁ y₁ x₂ y₂ = x₁ · x₂ + D · (y₁ · y₂)

cy : ℕ → ℕ → ℕ → ℕ → ℕ
cy x₁ y₁ x₂ y₂ = x₁ · y₂ + x₂ · y₁

-- BHVAN OVER �, subtraction-free.
--
-- Read it as the � identity with both negative terms carried across:
-- (x�²−Dy�²)(x�²−Dy�²) = cx² − D�cy² becomes, adding D x�²y�² + D x�²y�²
-- to each side, the statement below.
bhavanaℕ : (D x₁ y₁ x₂ y₂ : ℕ)
         → cx D x₁ y₁ x₂ y₂ · cx D x₁ y₁ x₂ y₂
             + (D · (x₁ · x₁ · (y₂ · y₂)) + D · (x₂ · x₂ · (y₁ · y₁)))
         ≡ x₁ · x₁ · (x₂ · x₂)
             + (D · D · (y₁ · y₁ · (y₂ · y₂))
                + D · (cy x₁ y₁ x₂ y₂ · cy x₁ y₁ x₂ y₂))
bhavanaℕ D x₁ y₁ x₂ y₂ = solveℕ!

-- The two specialisations the engine was handed, so the general theorem and
-- the machine's own candidates are visibly the same object.

bhavana₁ : (x₁ y₁ x₂ y₂ : ℕ)
         → cx 1 x₁ y₁ x₂ y₂ · cx 1 x₁ y₁ x₂ y₂
             + (x₁ · x₁ · (y₂ · y₂) + x₂ · x₂ · (y₁ · y₁))
         ≡ x₁ · x₁ · (x₂ · x₂)
             + (y₁ · y₁ · (y₂ · y₂) + cy x₁ y₁ x₂ y₂ · cy x₁ y₁ x₂ y₂)
bhavana₁ x₁ y₁ x₂ y₂ = solveℕ!

bhavana₂ : (x₁ y₁ x₂ y₂ : ℕ)
         → cx 2 x₁ y₁ x₂ y₂ · cx 2 x₁ y₁ x₂ y₂
             + (2 · (x₁ · x₁ · (y₂ · y₂)) + 2 · (x₂ · x₂ · (y₁ · y₁)))
         ≡ x₁ · x₁ · (x₂ · x₂)
             + (4 · (y₁ · y₁ · (y₂ · y₂))
                + 2 · (cy x₁ y₁ x₂ y₂ · cy x₁ y₁ x₂ y₂))
bhavana₂ x₁ y₁ x₂ y₂ = solveℕ!

-- COMMUTATIVITY OF THE COMPOSITION � samsa-bhvan is symmetric in the two
-- composed pairs, which is what makes the solutions a monoid rather than
-- merely a set closed under an operation.  This is the structural half of
-- what cakravla stands on.
cxComm : (D x₁ y₁ x₂ y₂ : ℕ) → cx D x₁ y₁ x₂ y₂ ≡ cx D x₂ y₂ x₁ y₁
cxComm D x₁ y₁ x₂ y₂ = solveℕ!

cyComm : (x₁ y₁ x₂ y₂ : ℕ) → cy x₁ y₁ x₂ y₂ ≡ cy x₂ y₂ x₁ y₁
cyComm x₁ y₁ x₂ y₂ = solveℕ!

-- COMPOSITION WITH THE UNIT (1,0) fixes the pair: the Pell identity element.
cxUnit : (D x y : ℕ) → cx D x y 1 0 ≡ x
cxUnit D x y = solveℕ!

cyUnit : (x y : ℕ) → cy x y 1 0 ≡ y
cyUnit x y = solveℕ!
