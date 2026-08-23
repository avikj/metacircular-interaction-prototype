{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- उत्थापन — evaluation, the raising of an expression to its value at a
-- point (the term is Bhāskara II's, Bījagaṇita (1150), for substituting a
-- value and computing; the THEOREM below is not attributed to that text —
-- it is stated here for the runtime's G7 gate, per the naming rule's
-- honesty clause).
--
-- THE GAP THIS CLOSES (owner's biography rule, 2026-08-23: a declaration
-- can be valid as a declaration while its mathematics is still waiting to
-- become a term).  crystallize/install.py G7 decides a polynomial
-- identity "by exact evaluation on an integer grid whose size is a
-- complete bound for the degree" — the completeness of that grid is the
-- gate's license and was declared, not checked.  Its univariate core,
-- checked here over ℤ:
--
--     a polynomial with MORE DISTINCT ROOTS THAN COEFFICIENTS is the
--     zero function.
--
-- Proof: the Horner quotient.  quot a p is synthetic division of p by
-- (x − a); the factor identity  p(x) − p(a) ≡ (x − a)·(quot a p)(x)  is
-- one induction whose step is pure ring algebra; a root at a plus a root
-- at b ≠ a forces (b−a)·q(b) ≡ 0, and ℤ is an integral domain
-- (isIntegralℤ), so the quotient inherits the remaining roots; lengths
-- drop by one; induction on the point list closes it.
--
-- CHECKED:
--   §1  evalP, quot, and the factor identity.
--   §2  roots descend to the quotient (integral domain step).
--   §3  grid : length p ≤ length pts, pts distinct, p vanishing on pts
--       ⟹ evalP p x ≡ 0 for EVERY x.
--
-- SCOPE, stated before the prose can overreach: univariate, over ℤ, in
-- the vanishing form.  The two-sided form (two degree-bounded
-- polynomials agreeing on the grid agree everywhere) follows by applying
-- this to their coefficientwise difference and is owed with a checked
-- subtraction lemma; the MULTIVARIATE grid G7 also uses (a product of
-- grids, one variable at a time) is a further induction not taken here.
-- G7's license is this theorem's job only at one variable.
--
-- CHECKED under the pin (Agda 2.8.0 + cubical v0.9).
------------------------------------------------------------------------

module Utthapana_APolynomialVanishingAtMorePointsThanItsLengthIsTheZeroFunction where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Int using (ℤ; pos; _+_; -_; _·_; _-_)
open import Cubical.Data.Int.Properties using (isIntegralℤ; -Cancel; -≡0)
open import Cubical.Data.Nat using (ℕ; zero; suc)
open import Cubical.Data.Nat.Order using (_≤_; pred-≤-pred; ¬-<-zero; zero-≤)
open import Cubical.Data.List using (List; []; _∷_; length)
open import Cubical.Data.Sigma using (_×_; _,_; fst; snd)
open import Cubical.Data.Unit using (Unit; tt)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver using (solve!)

------------------------------------------------------------------------
-- §1 · polynomials as little-endian coefficient lists; Horner evaluation;
-- the Horner quotient by (x − a).
Poly : Type
Poly = List ℤ

evalP : Poly → ℤ → ℤ
evalP []       x = pos 0
evalP (c ∷ cs) x = c + x · evalP cs x

-- synthetic division by (x − a): drops one coefficient.
quot : ℤ → Poly → Poly
quot a []           = []
quot a (c ∷ [])     = []
quot a (c ∷ d ∷ ds) = evalP (d ∷ ds) a ∷ quot a (d ∷ ds)

private
  -- the inductive step of the factor identity, constants generalized so
  -- the solver meets only variables.
  key : (c x a X A Q : ℤ) → X - A ≡ (x - a) · Q
      → (c + x · X) - (c + a · A) ≡ (x - a) · (A + x · Q)
  key c x a X A Q h =
    step1 ∙ cong (λ w → x · w + (x - a) · A) h ∙ step3
    where
    step1 : (c + x · X) - (c + a · A) ≡ x · (X - A) + (x - a) · A
    step1 = solve! ℤCommRing
    step3 : x · ((x - a) · Q) + (x - a) · A ≡ (x - a) · (A + x · Q)
    step3 = solve! ℤCommRing

-- THE FACTOR IDENTITY: p(x) − p(a) ≡ (x − a) · (quot a p)(x).
factor : (p : Poly) (a x : ℤ)
       → evalP p x - evalP p a ≡ (x - a) · evalP (quot a p) x
factor []           a x = solve! ℤCommRing
factor (c ∷ [])     a x = solve! ℤCommRing
factor (c ∷ d ∷ ds) a x =
  key c x a (evalP (d ∷ ds) x) (evalP (d ∷ ds) a)
      (evalP (quot a (d ∷ ds)) x) (factor (d ∷ ds) a x)

-- a root at a rewrites p as its factored form everywhere.
private
  minusZero : (z : ℤ) → z - pos 0 ≡ z
  minusZero z = solve! ℤCommRing

vanish-shift : (p : Poly) (a : ℤ) → evalP p a ≡ pos 0
             → (x : ℤ) → evalP p x ≡ (x - a) · evalP (quot a p) x
vanish-shift p a va x =
  sym (cong (λ w → evalP p x - w) va ∙ minusZero (evalP p x)) ∙ factor p a x

------------------------------------------------------------------------
-- §2 · ROOTS DESCEND TO THE QUOTIENT: a further root b ≠ a of p is a
-- root of quot a p — the integral-domain step.
root-quot : (p : Poly) (a b : ℤ)
          → evalP p a ≡ pos 0 → evalP p b ≡ pos 0 → ¬ b ≡ a
          → evalP (quot a p) b ≡ pos 0
root-quot p a b va vb neq =
  isIntegralℤ (b - a) (evalP (quot a p) b)
    (sym (vanish-shift p a va b) ∙ vb)
    (λ e → neq (-≡0 b a e))

------------------------------------------------------------------------
-- §3 · THE GRID.  All and Distinct, then the theorem by induction on the
-- point list (the quotient is not a subterm of p, so the points carry
-- the recursion; length p ≤ length pts shrinks with them).
data All (P : ℤ → Type) : List ℤ → Type where
  nil  : All P []
  cons : {b : ℤ} {bs : List ℤ} → P b → All P bs → All P (b ∷ bs)

Distinct : List ℤ → Type
Distinct []       = Unit
Distinct (a ∷ as) = All (λ b → ¬ b ≡ a) as × Distinct as

private
  -- push both vanishing and distinctness through the quotient at once.
  descendAll : (p : Poly) (a : ℤ) → evalP p a ≡ pos 0
             → (bs : List ℤ)
             → All (λ b → evalP p b ≡ pos 0) bs
             → All (λ b → ¬ b ≡ a) bs
             → All (λ b → evalP (quot a p) b ≡ pos 0) bs
  descendAll p a va []       nil          nil          = nil
  descendAll p a va (b ∷ bs) (cons vb vs) (cons nb ns) =
    cons (root-quot p a b va vb nb) (descendAll p a va bs vs ns)

  -- the quotient's length: one less than p's (stated as ≤ the tail).
  lenQuot : (a c : ℤ) (cs : Poly) (n : ℕ)
          → length cs ≤ n → length (quot a (c ∷ cs)) ≤ n
  lenQuot a c []       n h = zero-≤
  lenQuot a c (d ∷ ds) n h = subst (_≤ n) (sym lem) h
    where
    lem : length (quot a (c ∷ d ∷ ds)) ≡ length (d ∷ ds)
    lem i = suc (len≡ ds d i)
      where
      len≡ : (ds : Poly) (d : ℤ)
           → length (quot a (d ∷ ds)) ≡ length ds
      len≡ []       d = refl
      len≡ (e ∷ es) d = cong suc (len≡ es e)

  mulZeroR : (z : ℤ) → z · pos 0 ≡ pos 0
  mulZeroR z = solve! ℤCommRing

-- THE THEOREM: more distinct roots than coefficients ⟹ zero function.
grid : (pts : List ℤ) (p : Poly)
     → length p ≤ length pts
     → Distinct pts
     → All (λ b → evalP p b ≡ pos 0) pts
     → (x : ℤ) → evalP p x ≡ pos 0
grid []       []       _   _    _   x = refl
grid []       (c ∷ cs) len _    _   x = Empty.rec (¬-<-zero len)
grid (a ∷ as) []       _   _    _   x = refl
grid (a ∷ as) (c ∷ cs) len dist (cons va vs) x =
  vanish-shift (c ∷ cs) a va x
  ∙ cong ((x - a) ·_) (grid as (quot a (c ∷ cs))
      (lenQuot a c cs (length as) (pred-≤-pred len))
      (snd dist)
      (descendAll (c ∷ cs) a va as vs (fst dist))
      x)
  ∙ mulZeroR (x - a)
