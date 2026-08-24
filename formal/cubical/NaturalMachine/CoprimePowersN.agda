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
-- NaturalMachine.CoprimePowersN
--
-- The arithmetic the walk's general frontier needs, assembled over ℕ:
--
--     primes→coprime-powers :
--       IsPrime p → IsPrime q → ¬ (p ≡ q)
--       → (i j : ℕ) → isGCD (p ^ i) (q ^ j) 1
--
-- `CoprimePowers` proved certificates compose, over any ring.
-- `DistinctPrimesAreCoprime` supplied the base case over ℕ.  What was
-- missing, and named there as the last gap, is the transfer between ℕ and
-- ℤ.  Both directions are here.
--
-- ────────────────────────────────────────────────────────────────────
-- PRIOR ART, SEARCHED FIRST THIS TIME
--
-- `Cubical.Data.Int.Divisibility` already carries the whole Euclidean
-- apparatus: a `Bézout` record, `bézout : (m n : ℤ) → Bézout m n` built by
-- the Euclidean algorithm, and the two transfer maps
--
--     ∣→∣ℕ : m ∣ n → abs m ∣ℕ abs n
--     ∣ℕ→∣ : abs m ∣ℕ abs n → m ∣ n
--
-- so the bridge is a matter of using them.  Six rediscoveries were logged
-- in this session by finding prior art at audit time; this file was
-- written after grepping for it, which is the whole of the difference.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THE TWO DIRECTIONS COST
--
--   ℕ → ℤ  (`isGCD→Bez`)  run `bézout`, argue its gcd is a unit because
--                          it divides 1 in ℕ, then fix the sign.
--   ℤ → ℕ  (`Bez→isGCD`)  a common divisor divides both terms, hence the
--                          sum, hence 1.  Three lines.
--
-- Only the first needs the Euclidean algorithm.  That asymmetry is the
-- reason a certificate-carrying style pays: getting a certificate is
-- work; everything downstream of having one is not.  It is also exactly
-- Āryabhaṭa's division of labour — the kuṭṭaka is the hard part and the
-- multipliers are what you keep.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.CoprimePowersN where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _^_)
open import Cubical.Data.Nat.GCD using (isGCD ; isCD)
open import Cubical.Data.Nat.Divisibility using (∣-oneˡ ; antisym∣) renaming (_∣_ to _∣ℕ_)
open import Cubical.Data.Int using (ℤ ; pos ; _+_ ; _·_ ; -_ ; abs)
open import Cubical.Data.Int.Properties using (pos·pos ; abs→⊎ ; -Involutive)
open import Cubical.Data.Int.Divisibility
  using (bézout ; Bézout ; ∣→∣ℕ ; ∣ℕ→∣ ; ∣-+ ; ∣-left·)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Relation.Nullary using (¬_)
open import Cubical.Algebra.CommRing.Instances.Int using (ℤCommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

open import NaturalMachine.CoprimePowers using (module Bezout)
open import NaturalMachine.WalkJumps using (IsPrime)
open import NaturalMachine.DistinctPrimesAreCoprime using (distinct-primes-coprime)

open Bezout ℤCommRing using (Bez ; pow ; coprime-powers)
open Cubical.Data.Int.Divisibility using () renaming (_∣_ to _∣ℤ_)

------------------------------------------------------------------------
-- 0.  Ring rearrangements, by the solver
------------------------------------------------------------------------

private
  flip : (a b x y : ℤ) → (a · x) + (b · y) ≡ (x · a) + (y · b)
  flip a b x y = solve! ℤCommRing

  negBoth : (a b x y : ℤ) →
    (a · (- x)) + (b · (- y)) ≡ - ((x · a) + (y · b))
  negBoth a b x y = solve! ℤCommRing

------------------------------------------------------------------------
-- 1.  ℤ certificate ⟹ ℕ coprimality.  Three lines and a transfer.
------------------------------------------------------------------------

Bez→isGCD : (a b : ℕ) → Bez (pos a) (pos b) → isGCD a b 1
Bez→isGCD a b (x , y , p) = (∣-oneˡ a , ∣-oneˡ b) , divides
  where
  divides : (d : ℕ) → isCD a b d → d ∣ℕ 1
  divides d (d∣a , d∣b) = ∣→∣ℕ (subst (pos d ∣ℤ_) p sum)
    where
    dA : pos d ∣ℤ pos a
    dA = ∣ℕ→∣ {m = pos d} {n = pos a} d∣a

    dB : pos d ∣ℤ pos b
    dB = ∣ℕ→∣ {m = pos d} {n = pos b} d∣b

    sum : pos d ∣ℤ ((pos a · x) + (pos b · y))
    sum = ∣-+ (∣-left· {m = x} dA) (∣-left· {m = y} dB)

------------------------------------------------------------------------
-- 2.  ℕ coprimality ⟹ ℤ certificate.  This is where Euclid runs.
------------------------------------------------------------------------

isGCD→Bez : (a b : ℕ) → isGCD a b 1 → Bez (pos a) (pos b)
isGCD→Bez a b (_ , greatest) = go (abs→⊎ g (abs g) refl)
  where
  B = bézout (pos a) (pos b)

  c₁ c₂ g : ℤ
  c₁ = B .Bézout.coef₁
  c₂ = B .Bézout.coef₂
  g  = B .Bézout.gcd

  ident : (c₁ · pos a) + (c₂ · pos b) ≡ g
  ident = B .Bézout.identity

  absg∣1 : abs g ∣ℕ 1
  absg∣1 = greatest (abs g) (∣→∣ℕ (B .Bézout.isCD .fst) , ∣→∣ℕ (B .Bézout.isCD .snd))

  absg≡1 : abs g ≡ 1
  absg≡1 = antisym∣ absg∣1 (∣-oneˡ (abs g))

  go : (g ≡ pos (abs g)) ⊎ (g ≡ - pos (abs g)) → Bez (pos a) (pos b)
  go (inl q) = c₁ , c₂ , flip (pos a) (pos b) c₁ c₂ ∙ ident ∙ q ∙ cong pos absg≡1
  go (inr q) =
      (- c₁) , (- c₂)
    , ( negBoth (pos a) (pos b) c₁ c₂
      ∙ cong -_ ident
      ∙ cong -_ (q ∙ cong (λ k → - pos k) absg≡1)
      ∙ negneg )
    where
    negneg : - (- pos 1) ≡ pos 1
    negneg = -Involutive (pos 1)

------------------------------------------------------------------------
-- 3.  Powers transfer
------------------------------------------------------------------------

posPow : (a n : ℕ) → pos (a ^ n) ≡ pow (pos a) n
posPow a zero    = refl
posPow a (suc n) = pos·pos a (a ^ n) ∙ cong (pos a ·_) (posPow a n)

------------------------------------------------------------------------
-- 4.  THE STATEMENT
------------------------------------------------------------------------

primes→coprime-powers :
  (p q : ℕ) → IsPrime p → IsPrime q → ¬ (p ≡ q)
  → (i j : ℕ) → isGCD (p ^ i) (q ^ j) 1
primes→coprime-powers p q pp qq p≢q i j =
  Bez→isGCD (p ^ i) (q ^ j)
    (subst2 Bez (sym (posPow p i)) (sym (posPow q j))
      (coprime-powers {a = pos p} {b = pos q}
        (isGCD→Bez p q (distinct-primes-coprime p q pp qq p≢q)) i j))

------------------------------------------------------------------------
-- 5.  The chain is closed, end to end.
--
--   Kuttaka / Cubical's `bézout`   the multipliers exist
--   DistinctPrimesAreCoprime       distinct primes are coprime
--   here §2                        that becomes a certificate over ℤ
--   CoprimePowers                  certificates compose to powers
--   here §1                        the certificate becomes `isGCD` over ℕ
--   CRTChain                       `isGCD` data ⟹ the residue equivalence
--   LosslessLowerBound             and the count is a minimum
--   OptimalObservation             so "optimal" is a definition
--
-- Every link checked, `--safe`, no postulates.  The walk's residue count
-- now rests on primality of its installs and nothing else.
------------------------------------------------------------------------
