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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.AffineEmergenceCountedPath
--
-- The minimal affine-emergence counterexample from
-- notes/AFFINE_EMERGENCE.md, stated on the repository's native causal path
-- type rather than certified by a search:
--
--   seed = 2, target = 0 in Z/4
--   A(y) = 1
--   B(y) = 2y + 2 mod 4
--
-- A alone reaches 1 and remains there.  B alone fixes 2.  Nevertheless the
-- union admits 2 --A--> 1 --B--> 0.  The individual avoidance proofs quantify
-- over every finite CountedPath, so the result kills generatorwise
-- composition of no-hit verdicts, not merely a bounded test.
--
-- This exact witness does not classify affine semigroups, transfer the finite
-- path to an integer lift, prove a frequency of emergence, or compute an
-- optimal hitting time.
------------------------------------------------------------------------

module NaturalMachine.AffineEmergenceCountedPath where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Bool
  using (Bool ; false ; true ; true≢false)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Sigma using (Σ-syntax ; _,_)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.LawfulContinuationCore
  using (World ; State ; Lawful ; next ; CountedPath ; stop ; step ; endpoint)

------------------------------------------------------------------------
-- 1. The exact residue transition tables
------------------------------------------------------------------------

data Residue4 : Type₀ where
  r0 r1 r2 r3 : Residue4

isZero : Residue4 → Bool
isZero r0 = true
isZero r1 = false
isZero r2 = false
isZero r3 = false

r1≢r0 : ¬ (r1 ≡ r0)
r1≢r0 equality = true≢false (sym (cong isZero equality))

r2≢r0 : ¬ (r2 ≡ r0)
r2≢r0 equality = true≢false (sym (cong isZero equality))

-- A(y) = 1.
moveA : Residue4 → Residue4
moveA _ = r1

-- B(y) = 2y + 2 mod 4:
-- B(0)=2, B(1)=0, B(2)=2, B(3)=0.
moveB : Residue4 → Residue4
moveB r0 = r2
moveB r1 = r0
moveB r2 = r2
moveB r3 = r0

------------------------------------------------------------------------
-- 2. Singleton worlds and their union
------------------------------------------------------------------------

AWorld : World
State AWorld = Residue4
Lawful AWorld _ = Unit
next AWorld state _ = moveA state

BWorld : World
State BWorld = Residue4
Lawful BWorld _ = Unit
next BWorld state _ = moveB state

-- `false` selects A and `true` selects B.
UnionWorld : World
State UnionWorld = Residue4
Lawful UnionWorld _ = Bool
next UnionWorld state false = moveA state
next UnionWorld state true = moveB state

NeverHits : (W : World) → State W → State W → Type₀
NeverHits W seed target =
  (n : ℕ) (path : CountedPath W seed n) → ¬ (endpoint path ≡ target)

Hits : (W : World) → State W → State W → Type₀
Hits W seed target =
  Σ[ n ∈ ℕ ] Σ[ path ∈ CountedPath W seed n ] endpoint path ≡ target

------------------------------------------------------------------------
-- 3. Each generator separately avoids zero at every finite depth
------------------------------------------------------------------------

-- After the first A-step, the state is 1 and every later A-step fixes it.
A-from-r1-never-hits-r0 : NeverHits AWorld r1 r0
A-from-r1-never-hits-r0 zero (stop .r1) = r1≢r0
A-from-r1-never-hits-r0 (suc n) (step tt tail) =
  A-from-r1-never-hits-r0 n tail

A-alone-never-hits-r0-from-r2 : NeverHits AWorld r2 r0
A-alone-never-hits-r0-from-r2 zero (stop .r2) = r2≢r0
A-alone-never-hits-r0-from-r2 (suc n) (step tt tail) =
  A-from-r1-never-hits-r0 n tail

-- B fixes the seed 2, so every B-only path remains there.
B-alone-never-hits-r0-from-r2 : NeverHits BWorld r2 r0
B-alone-never-hits-r0-from-r2 zero (stop .r2) = r2≢r0
B-alone-never-hits-r0-from-r2 (suc n) (step tt tail) =
  B-alone-never-hits-r0-from-r2 n tail

------------------------------------------------------------------------
-- 4. The union reaches zero in two actual causal steps
------------------------------------------------------------------------

emergentPath : CountedPath UnionWorld r2 2
emergentPath = step false (step true (stop r0))

emergentPath-ends-at-r0 : endpoint emergentPath ≡ r0
emergentPath-ends-at-r0 = refl

union-hits-r0-from-r2 : Hits UnionWorld r2 r0
union-hits-r0-from-r2 = 2 , emergentPath , refl

