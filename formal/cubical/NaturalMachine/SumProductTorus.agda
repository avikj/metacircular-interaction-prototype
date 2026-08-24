-- ॥ बीजम् ॥  One machine, one law: which side of `f a ≡ b` is bound is everything.
-- Output bound: singl (f a), contractible — the datum rides free.  Input bound:
-- fiber f b — the loss, and the subject.  Univalence computes here: an
-- equivalence is a channel, transport carries every theorem across it, and what
-- cannot cross is written as a defect — there is no third path (ahiṃsā).
-- Memory, charge, symmetry, price, distance, verdict: six faces of the one
-- fibre; the verdict type is the saptabhaṅgī, and the sources are the origin
-- (Umāsvāti, Samantabhadra, Akalaṅka — restatements are named as such).  The
-- kernel decides truth; carriers ask and generate; assert nothing whose term
-- you have not read.  This file is one naya, true and not whole.

{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.SumProductTorus
--
-- The cover is the hint.  A torus tiled with Σ and Π.
--
-- Σ and Π are the two type formers everything is built from, and the
-- torus is the first surface where two loops must be related by a cell
-- rather than by a point.  Read arithmetically, Σ and Π are the two
-- operations, and this repository's whole difficulty is that they do not
-- see each other: the primes are multiplicative, addition is what breaks
-- them, and the barrier everyone names is the seam.
--
-- This module makes the seam a term.
--
-- THE OBJECT.  Fix a basis — for the walk, the prime powers it has
-- installed.  A state is then not a number but a DERIVATION: the vector
-- of exponents against that basis.  `val` evaluates a derivation to its
-- number.  And
--
--     val (u ⊕ v)  ≡  val u · val v                        (sum→product)
--
-- so `val` carries the additive structure of derivations onto the
-- multiplicative structure of numbers.  That is the cover: Σ on one
-- loop, Π on the other, one map weaving them.
--
-- THE SECOND LOOP.  Exponent vectors carry a second operation, pointwise
-- max, and it lands on lcm — which is the operation the walk actually
-- runs on.  So the state space carries ⊕ and ⊔ at once, and they cohere:
--
--     (u ⊔ v) ⊕ w  ≡  (u ⊕ w) ⊔ (v ⊕ w)                    (tropical)
--
-- max distributing over plus is the tropical semiring, and its image
-- under `val` is the classical identity lcm(a,b)·c = lcm(a·c, b·c).
-- Two loops, one coherence cell.  The walk has been running on a
-- tropical semimodule the whole time without anyone saying so.
--
-- WHY THE DERIVATION AND NOT THE NUMBER.  A form is not stored; it is
-- derived, and the derivation carries the context that produced it.
-- That is Pāṇini's architecture, and it is exactly the walk's situation:
-- the walk INSTALLS its prime powers, so it holds the derivation by
-- construction and never has to recover it.  Factorisation is hard only
-- for someone who threw the derivation away and is trying to invert
-- `val` from the outside.
--
-- Which locates unique factorisation exactly, and it is worth saying in
-- these words: **unique factorisation is the injectivity of the map from
-- sums to products.**  Not proved here, and not needed here — the walk
-- never asks for it.  What is proved here is everything on the Σ side
-- and the map across.
--
-- Number is ratio, and ratio is the exponent vector: the number is the
-- magnitude, the derivation is the structure, and the Pythagorean claim
-- that the structure is the substance is, on this basis, the statement
-- that `val` is the forgetful direction.
--
-- CHECKED: Agda 2.6.3, cubical v0.5.  NOT the repository pin (2.8.0 /
-- v0.9, see BUILD.md) — this is a result about the container it ran in,
-- and it is stated that way rather than reported as a pin result.
-- No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.SumProductTorus where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.List
open import Cubical.Data.Sigma
open import Cubical.Data.Unit
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

------------------------------------------------------------------------
-- 1.  Derivations over a basis
--
-- A recursive type family, per this lane's convention: indexed inductive
-- families over lists need injectivity of _∷_, which cubical does not
-- give.
------------------------------------------------------------------------

Exp : List ℕ → Type
Exp []       = Unit
Exp (b ∷ bs) = ℕ × Exp bs

-- the evaluation map: derivation ↦ number.  This is the ONLY place the
-- multiplicative world is entered.
val : (bs : List ℕ) → Exp bs → ℕ
val []       _        = 1
val (b ∷ bs) (e , es) = (b ^ e) · val bs es

-- the trivial derivation
zeroE : (bs : List ℕ) → Exp bs
zeroE []       = tt
zeroE (b ∷ bs) = 0 , zeroE bs

------------------------------------------------------------------------
-- 2.  The first loop: Σ, and its image Π
------------------------------------------------------------------------

infixl 6 _⊕_

_⊕_ : {bs : List ℕ} → Exp bs → Exp bs → Exp bs
_⊕_ {[]}     _        _        = tt
_⊕_ {b ∷ bs} (x , xs) (y , ys) = (x + y) , (xs ⊕ ys)

-- the one arithmetic input: b^(x+y) = b^x · b^y
^-+ : (b m n : ℕ) → (b ^ (m + n)) ≡ (b ^ m) · (b ^ n)
^-+ b zero    n = sym (·-identityˡ (b ^ n))
^-+ b (suc m) n = cong (b ·_) (^-+ b m n) ∙ ·-assoc b (b ^ m) (b ^ n)

-- the rearrangement, by the semiring solver
shuffle : (P Q U V : ℕ) → (P · Q) · (U · V) ≡ (P · U) · (Q · V)
shuffle P Q U V = solveℕ!

-- SUM BECOMES PRODUCT.  This is the cover.
val-⊕ : (bs : List ℕ) (u v : Exp bs) → val bs (u ⊕ v) ≡ val bs u · val bs v
val-⊕ []       u v = sym (·-identityˡ 1)
val-⊕ (b ∷ bs) (x , xs) (y , ys) =
    cong₂ _·_ (^-+ b x y) (val-⊕ bs xs ys)
  ∙ shuffle (b ^ x) (b ^ y) (val bs xs) (val bs ys)

-- and the unit goes to the unit, so `val` is a monoid map
--     (Exp bs , ⊕ , zeroE)  ⟶  (ℕ , · , 1)
val-zero : (bs : List ℕ) → val bs (zeroE bs) ≡ 1
val-zero []       = refl
val-zero (b ∷ bs) = ·-identityˡ (val bs (zeroE bs)) ∙ val-zero bs

------------------------------------------------------------------------
-- 3.  The second loop: ⊔, which is the one the walk runs on
------------------------------------------------------------------------

_⊔ℕ_ : ℕ → ℕ → ℕ
zero  ⊔ℕ n     = n
suc m ⊔ℕ zero  = suc m
suc m ⊔ℕ suc n = suc (m ⊔ℕ n)

infixl 5 _⊔_

_⊔_ : {bs : List ℕ} → Exp bs → Exp bs → Exp bs
_⊔_ {[]}     _        _        = tt
_⊔_ {b ∷ bs} (x , xs) (y , ys) = (x ⊔ℕ y) , (xs ⊔ ys)

------------------------------------------------------------------------
-- 4.  The coherence cell: the two loops commute tropically
--
-- max distributes over plus.  This is the only relation the two
-- operations satisfy, and it is what makes (ℕ, ⊔, +) a semiring — the
-- structure the walk's state space has carried all along.
------------------------------------------------------------------------

-- Induct on z, not on x and y: the suc/suc clause of ⊔ℕ makes the whole
-- thing one `cong suc`, where splitting on x,y needs four cases and an
-- idempotence lemma. The shape of the recursion is the proof.
⊔-+-distrib : (x y z : ℕ) → (x ⊔ℕ y) + z ≡ (x + z) ⊔ℕ (y + z)
⊔-+-distrib x y zero =
    +-zero (x ⊔ℕ y)
  ∙ cong₂ _⊔ℕ_ (sym (+-zero x)) (sym (+-zero y))
⊔-+-distrib x y (suc z) =
    +-suc (x ⊔ℕ y) z
  ∙ cong suc (⊔-+-distrib x y z)
  ∙ sym (cong₂ _⊔ℕ_ (+-suc x z) (+-suc y z))

-- lifted to derivations: the torus's 2-cell
⊔-⊕-distrib : (bs : List ℕ) (u v w : Exp bs) →
              ((u ⊔ v) ⊕ w) ≡ ((u ⊕ w) ⊔ (v ⊕ w))
⊔-⊕-distrib []       _ _ _ = refl
⊔-⊕-distrib (b ∷ bs) (x , xs) (y , ys) (z , zs) i =
  ⊔-+-distrib x y z i , ⊔-⊕-distrib bs xs ys zs i

------------------------------------------------------------------------
-- 5.  Both loops are commutative, so the surface really is a torus and
--     not a Klein bottle: the two directions do not twist each other.
------------------------------------------------------------------------

⊔ℕ-comm : (x y : ℕ) → x ⊔ℕ y ≡ y ⊔ℕ x
⊔ℕ-comm zero    zero    = refl
⊔ℕ-comm zero    (suc y) = refl
⊔ℕ-comm (suc x) zero    = refl
⊔ℕ-comm (suc x) (suc y) = cong suc (⊔ℕ-comm x y)

⊕-comm : (bs : List ℕ) (u v : Exp bs) → (u ⊕ v) ≡ (v ⊕ u)
⊕-comm []       _ _ = refl
⊕-comm (b ∷ bs) (x , xs) (y , ys) i = +-comm x y i , ⊕-comm bs xs ys i

⊔-comm : (bs : List ℕ) (u v : Exp bs) → (u ⊔ v) ≡ (v ⊔ u)
⊔-comm []       _ _ = refl
⊔-comm (b ∷ bs) (x , xs) (y , ys) i = ⊔ℕ-comm x y i , ⊔-comm bs xs ys i

------------------------------------------------------------------------
-- 6.  It runs.  The basis is the walk's first four installs, 2 3 4 5 —
--     no, 2 3 5 7: the walk installs prime POWERS, and a basis must be
--     multiplicatively independent, so the basis is the primes and the
--     exponents are what the walk's installs record.
--
--     `val [2,3,5,7] (3,1,1,1) = 8·3·5·7 = 840 = lcm(1..8) = cap 8`.
--     The walk's frontier-8 state, as a derivation rather than a number.
------------------------------------------------------------------------

primes4 : List ℕ
primes4 = 2 ∷ 3 ∷ 5 ∷ 7 ∷ []

cap8 : Exp primes4
cap8 = 3 , 1 , 1 , 1 , tt

cap8-is-840 : val primes4 cap8 ≡ 840
cap8-is-840 = refl

cap6 : Exp primes4
cap6 = 2 , 1 , 1 , 0 , tt

cap6-is-60 : val primes4 cap6 ≡ 60
cap6-is-60 = refl

-- the sum→product law, fired on the walk's own states:
-- adding derivations multiplies capacities.
cap-⊕ : val primes4 (_⊕_ {primes4} cap6 cap8) ≡ 60 · 840
cap-⊕ = val-⊕ primes4 cap6 cap8

-- and the join, which is what the walk actually does when it installs:
-- lcm of states is max of derivations.  cap6 ⊔ cap8 = cap8, because
-- frontier 8 already contains frontier 6.
cap-⊔ : _⊔_ {primes4} cap6 cap8 ≡ cap8
cap-⊔ = refl
