{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- DistinctPrimesAreCoprime
--
-- The last gap in the chain `BezoutIsGCD` §5 names.
--
--   `Kuttaka.bezout`     Āryabhaṭa's procedure returns the multipliers
--   `CoprimePowers`      certificates compose: coprime bases ⟹ coprime powers
--   `BezoutIsGCD`        a certificate is an `isGCD _ _ 1`
--   `CRTChain`           `isGCD` data ⟹ the residue equivalence
--   HERE                 distinct primes are coprime
--
-- ────────────────────────────────────────────────────────────────────
-- THE STATEMENT
--
--     distinct-primes-coprime :
--       IsPrime p → IsPrime q → ¬ (p ≡ q) → isGCD p q 1
--
-- with `IsPrime` the definition already in this lane
-- (`WalkJumps.IsPrime`: `1 < p` and every divisor is `1` or `p`).
--
-- The argument is the schoolbook one and it is three lines: a common
-- divisor `d` of `p` and `q` is `1` or `p` by primality of `p`; if it is
-- `p` then `p ∣ q`, so `p` is `1` or `q` by primality of `q`; `p ≠ 1`
-- because `1 < p`, and `p ≠ q` by hypothesis.  So `d ≡ 1`.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOW COMPLETE
--
-- Combining with `CoprimePowers` and `BezoutIsGCD`, the walk's residue
-- count is available at EVERY frontier and not only at named ones, given
-- the primality of the installed bases — which `WalkPrimePowers` supplies
-- and `PrimalityDecision.decIsPrime` decides.
--
-- What made this the last gap rather than the first is worth recording:
-- every earlier step was a certificate composing, and this one is the
-- only place where a case analysis on a PREDICATE was unavoidable.  The
-- kuṭṭaka's habit of returning a construction carried the chain as far as
-- it could go, and stopped exactly where primality enters.
--
-- WHAT IS NOT CLAIMED.  That the walk's installs are prime powers — that
-- is `WalkPrimePowers.installs-are-prime-powers`, already checked, and it
-- is a separate statement from anything here.  Nor that this gives the
-- residue count at a general frontier as a single term: assembling it
-- needs the list of installs, which is a different induction.  What is
-- closed is the arithmetic obstacle, which was the reason the assembly
-- could not be attempted.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module DistinctPrimesAreCoprime where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility using (_∣_ ; ∣-oneˡ ; ∣-refl)
open import Cubical.Data.Nat.GCD using (isGCD ; isCD)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import WalkJumps using (IsPrime)

------------------------------------------------------------------------
-- 1.  A prime is not 1
------------------------------------------------------------------------

prime-≢1 : (p : ℕ) → IsPrime p → ¬ (p ≡ 1)
prime-≢1 p pr p≡1 = ¬m<m (subst (1 <_) p≡1 (pr .fst))

------------------------------------------------------------------------
-- 2.  THE STATEMENT
------------------------------------------------------------------------

distinct-primes-coprime :
  (p q : ℕ) → IsPrime p → IsPrime q → ¬ (p ≡ q) → isGCD p q 1
distinct-primes-coprime p q pp qq p≢q =
  (∣-oneˡ p , ∣-oneˡ q) , divides
  where
  divides : (d : ℕ) → isCD p q d → d ∣ 1
  divides d (d∣p , d∣q) = go (pp .snd d d∣p)
    where
    go : (d ≡ 1) ⊎ (d ≡ p) → d ∣ 1
    go (inl d≡1) = ∣-refl d≡1
    go (inr d≡p) = Empty.rec (bad (qq .snd p (subst (_∣ q) d≡p d∣q)))
      where
      bad : (p ≡ 1) ⊎ (p ≡ q) → ⊥
      bad (inl p≡1) = prime-≢1 p pp p≡1
      bad (inr p≡q) = p≢q p≡q

------------------------------------------------------------------------
-- 3.  It runs, on the walk's own bases.
------------------------------------------------------------------------

open import PrimalityDecision using (decIsPrime)
open import Cubical.Relation.Nullary using (Dec ; yes ; no)
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)

-- read a decision off, with the impossible branch discharged by the
-- computation rather than by a fabricated witness
isYes : {A : Type} → Dec A → Bool
isYes (yes _) = true
isYes (no  _) = false

fromDec : {A : Type} (d : Dec A) → isYes d ≡ true → A
fromDec (yes a) _ = a
fromDec (no  _) p = Empty.rec (false≢true p)

prime-2 : IsPrime 2
prime-2 = fromDec (decIsPrime 2) refl

prime-3 : IsPrime 3
prime-3 = fromDec (decIsPrime 3) refl

2≢3 : ¬ (2 ≡ 3)
2≢3 p = znots (injSuc (injSuc p))

coprime-2-3 : isGCD 2 3 1
coprime-2-3 = distinct-primes-coprime 2 3 prime-2 prime-3 2≢3

------------------------------------------------------------------------
-- 4.  The chain is closed.
--
-- `distinct-primes-coprime` + `CoprimePowers.coprime-powers` +
-- `BezoutIsGCD.bezN→isGCD` + `CRTChain.crtChain` is the walk's residue
-- count from primality alone, with `LosslessLowerBound` making the count
-- a minimum and `OptimalObservation` making "optimal" a definition rather
-- than a word.
--
-- Five modules, one chain, and the only case analysis in it is here.
------------------------------------------------------------------------
