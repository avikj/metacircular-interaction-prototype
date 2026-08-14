{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.ConeOrder
--
-- Delta 17 T17.13, the remaining half: the ORDER condition on the cone.
-- And the finding is that it is not a remaining half at all — over ℕ the
-- parity congruence and the inequality are ONE condition, not two.
--
-- Delta 17 presents the cone with two constraints, a congruence
-- s ≡ d (mod 2) and an inequality bounding the gap by the sum.
-- `ConeImage` proved the congruence is exactly the image condition over
-- any commutative ring; that left the inequality, which needs an order
-- and so cannot live in the same generality.  The natural home is ℕ,
-- where "the legs are nonnegative" is not a hypothesis but the type.
--
-- THE STATEMENT.  Write the cone condition as
--
--     Cone s d  =  Σ[ m ∈ ℕ ] (s ≡ d + m + m).
--
-- One Σ, both constraints: the `+ m + m` is the parity, and the fact that
-- m is a NATURAL number is the inequality d ≤ s.  With it, T17.13 is an
-- isomorphism whose two directions are each one line.
--
-- WHY THIS IS THE RIGHT PACKAGING, and not a trick.  In `ConeImage` the
-- parity certificate was the LARGER leg; here the certificate m is the
-- SMALLER leg.  Same theorem — and which leg is made the certificate is
-- exactly what decides whether the order condition comes along for free.
-- Delta 17 lists two constraints because it takes the symmetric
-- coordinates (s,d) as primary; taking either leg as the certificate
-- fuses them.  That is a fact about the presentation, and deriving it is
-- what the corpus's standard asks for instead of restating the pair of
-- conditions.
--
-- Contents (no holes, no postulates, --safe):
--
--   Legs, sumOf, gapOf         a pair presented by its smaller leg and
--                              its gap — the same data as (p,q) with a
--                              proof p ≤ q, but with no relation to carry
--   Cone                       the fused condition
--   legs→cone                  T17.13 ⇒, certified by the smaller leg
--   cone→legs                  T17.13 ⇐, with the pair reconstructed
--   cone-roundtrip             the reconstruction really has that sum and
--                              that gap
--   parity-is-implied          the congruence of `ConeImage` recovered
--                              from `Cone` alone, so the two modules
--                              agree and neither assumes the other
--
-- NOT claimed: that the signed cone over an ordered ring reduces this
-- way.  Over ℕ the sign of the gap is fixed by which leg is called
-- smaller; the signed statement over ℤ needs |d| and then the fusion is
-- two cases, not one.  Recorded so nobody reads this as more than it is.
------------------------------------------------------------------------

module NaturalMachine.ConeOrder where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Sigma
open import Cubical.Data.Nat using (ℕ ; _+_)
open import Cubical.Tactics.NatSolver.Reflection using (solveℕ!)

------------------------------------------------------------------------
-- §1  The two sides.
--
-- A pair with p ≤ q is the same data as (p , d) with q = p + d.  Carrying
-- the gap instead of an order proof is what removes subtraction from
-- every statement below; it is the same move `ConeImage` made with the
-- parity certificate, applied to the order instead.
------------------------------------------------------------------------

Legs : Type
Legs = ℕ × ℕ

smaller larger : Legs → ℕ
smaller (p , d) = p
larger  (p , d) = p + d

sumOf gapOf : Legs → ℕ
sumOf (p , d) = p + (p + d)
gapOf (p , d) = d

-- The cone, in symmetric coordinates, with both of Delta 17's conditions
-- in one witness.
Cone : ℕ → ℕ → Type
Cone s d = Σ[ m ∈ ℕ ] (s ≡ d + m + m)

------------------------------------------------------------------------
-- §2  T17.13, both directions.
------------------------------------------------------------------------

encode : (p d : ℕ) → p + (p + d) ≡ d + p + p
encode p d = solveℕ!

-- ⇒  An ordered pair lands in the cone, certified by its SMALLER leg.
legs→cone : (l : Legs) → Cone (sumOf l) (gapOf l)
legs→cone (p , d) = p , encode p d

-- ⇐  A cone point reconstructs an ordered pair: the certificate m is the
-- smaller leg, and the gap is d, so the pair is (m , m + d).  Nothing is
-- subtracted and no inequality is discharged — both were carried by the
-- fact that m is a natural number.
cone→legs : (s d : ℕ) → Cone s d → Legs
cone→legs s d (m , _) = m , d

cone-roundtrip : (s d : ℕ) (c : Cone s d)
               → (sumOf (cone→legs s d c) ≡ s)
               × (gapOf (cone→legs s d c) ≡ d)
cone-roundtrip s d (m , hs) = (encode m d ∙ sym hs) , refl

-- … and going the other way, the certificate recovered from a pair is the
-- pair's own smaller leg, so the two directions are inverse on the data
-- that matters.
legs-roundtrip : (l : Legs)
               → cone→legs (sumOf l) (gapOf l) (legs→cone l) ≡ l
legs-roundtrip (p , d) = refl

------------------------------------------------------------------------
-- §3  Agreement with ConeImage.
--
-- `ConeImage` characterised the cone over a commutative ring by "s + d is
-- a double".  Here that congruence is not assumed: it FOLLOWS from the
-- fused condition, with the double exhibited.  So the two modules are
-- consistent and neither is assuming the other's conclusion — which is
-- the only thing worth checking when the same theorem is landed twice at
-- different generality.
------------------------------------------------------------------------

parity-lemma : (d m : ℕ) → (d + m + m) + d ≡ (d + m) + (d + m)
parity-lemma d m = solveℕ!

parity-is-implied : (s d : ℕ) → Cone s d → Σ[ k ∈ ℕ ] (s + d ≡ k + k)
parity-is-implied s d (m , hs) =
  (d + m) , (cong (λ z → z + d) hs ∙ parity-lemma d m)
