{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- Factorisation
--
-- `FrontierDivides` §2 names the hard half of the universal property and
-- says why it is hard: it needs EXISTENCE OF PRIME FACTORISATION, which
-- no certificate-composition produces.  Here it is.
--
--     factorise : (n : ℕ) → 0 < n → Σ[ ps ] (AllPrimeL ps × (prodL ps ≡ n))
--
-- ────────────────────────────────────────────────────────────────────
-- PRIOR ART, SEARCHED FIRST
--
-- `CoprimeSplitting.primeDivisor` already provides the
-- atom — `(n : ℕ) → 1 < n → Σ[ p ] (IsPrime p × (p ∣ n))`, a fuelled
-- linear search with the fuel accounted for honestly in that module's
-- header.  Factorisation is that atom plus a descent, and the descent is
-- the only new thing here.
--
-- Seven rediscoveries were logged in this session by finding prior art at
-- audit time.  This is the fourth in a row found before writing.
--
-- ────────────────────────────────────────────────────────────────────
-- THE DESCENT
--
-- Peel a prime divisor `p` off `n`, leaving `c` with `c · p ≡ n`.  Then
-- `c < n`, because `1 < p` and `0 < c` give `c < 2·c ≤ p·c ≡ n` — and the
-- recursion is on `c`.  Fuel carries the termination, in the same style
-- as `primeDivisor-fuel`, because that is this lane's idiom for searches
-- whose bound is obvious and whose well-foundedness is not worth a
-- separate development.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT THIS DOES AND DOES NOT UNLOCK
--
-- DOES: every positive `n` is a product of primes, with the list as data.
--
-- DOES NOT: `m ∣ prodOf (frontierList k)` for `m ≤ k`, which is the
-- statement `FrontierDivides` wanted.  Getting there from a factorisation
-- needs the list GROUPED BY PRIME with exponents compared against
-- `⌊log_p k⌋` — bookkeeping, not a new idea, and not done here.  The
-- distinction is worth keeping sharp: the mathematical obstacle is gone,
-- the assembly is not.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module Factorisation where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility using (_∣_ ; ∣-untrunc)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Data.Empty as Empty using (⊥)

open import WalkJumps using (IsPrime)
open import CoprimeSplitting using (primeDivisor)

------------------------------------------------------------------------
-- 1.  Factorisations
------------------------------------------------------------------------

prodL : List ℕ → ℕ
prodL []       = 1
prodL (p ∷ ps) = p · prodL ps

AllPrimeL : List ℕ → Type
AllPrimeL []       = Unit
AllPrimeL (p ∷ ps) = IsPrime p × AllPrimeL ps

Factorisation : ℕ → Type
Factorisation n = Σ[ ps ∈ List ℕ ] (AllPrimeL ps × (prodL ps ≡ n))

------------------------------------------------------------------------
-- 2.  The descent step: peeling a prime strictly shrinks the cofactor
------------------------------------------------------------------------

private
  c<2c : (c : ℕ) → 0 < c → c < 2 · c
  c<2c c 0<c = subst2 _≤_ (+-comm c 1) (sym two-c) (≤-k+ 0<c)
    where
    two-c : 2 · c ≡ c + c
    two-c = cong (c +_) (+-zero c)

  cofactor-shrinks : (c p n : ℕ) → 0 < c → 1 < p → c · p ≡ n → c < n
  cofactor-shrinks c p n 0<c 1<p pc =
    subst (c <_) (·-comm p c ∙ pc) (<≤-trans (c<2c c 0<c) (≤-·k 1<p))

  cofactor-pos : (c p n : ℕ) → 0 < n → c · p ≡ n → 0 < c
  cofactor-pos zero    p n 0<n pc = Empty.rec (¬-<-zero (subst (0 <_) (sym pc) 0<n))
  cofactor-pos (suc c) p n _   _  = suc-≤-suc zero-≤

------------------------------------------------------------------------
-- 3.  THE THEOREM, by fuel — this lane's idiom for a bounded search
------------------------------------------------------------------------

factorise-fuel : (fuel n : ℕ) → 0 < n → n ≤ fuel → Factorisation n
factorise-fuel zero    n 0<n n≤f = Empty.rec (¬-<-zero (<≤-trans 0<n n≤f))
factorise-fuel (suc f) n 0<n n≤f = go (splitℕ-≤ n 1)
  where
  go : ((n ≤ 1) ⊎ (1 < n)) → Factorisation n
  go (inl n≤1) = [] , tt , ≤-antisym 0<n n≤1
  go (inr 1<n) = peel (primeDivisor n 1<n)
    where
    peel : Σ[ p ∈ ℕ ] (IsPrime p × (p ∣ n)) → Factorisation n
    peel (p , pp , p∣n) = split (∣-untrunc p∣n)
      where
      split : Σ[ c ∈ ℕ ] (c · p ≡ n) → Factorisation n
      split (c , pc) =
        (p ∷ rec .fst) , (pp , rec .snd .fst) ,
        (cong (p ·_) (rec .snd .snd) ∙ ·-comm p c ∙ pc)
        where
        0<c : 0 < c
        0<c = cofactor-pos c p n 0<n pc

        c<n : c < n
        c<n = cofactor-shrinks c p n 0<c (pp .fst) pc

        rec : Factorisation c
        rec = factorise-fuel f c 0<c (pred-≤-pred (<≤-trans c<n n≤f))

factorise : (n : ℕ) → 0 < n → Factorisation n
factorise n 0<n = factorise-fuel n n 0<n ≤-refl

------------------------------------------------------------------------
-- 4.  It runs.
------------------------------------------------------------------------

fact-12 : Factorisation 12
fact-12 = factorise 12 (suc-≤-suc zero-≤)

fact-12-product : prodL (fact-12 .fst) ≡ 12
fact-12-product = fact-12 .snd .snd

------------------------------------------------------------------------
-- 5.  Where this sits.
--
--   `CoprimeSplitting.primeDivisor`   every n > 1 has a prime divisor
--   here                              hence a factorisation
--   `FrontierDivides`                 coprime divisors multiply (Gauss)
--   `FrontierCount`                   and the residue count is CRT
--
-- The remaining assembly — grouping a factorisation by prime and
-- comparing exponents to `⌊log_p k⌋` — is the last thing between this
-- chain and `prodOf (frontierList k) ≡ lcm(1..k)`.  It is bookkeeping,
-- and saying so is not the same as doing it.
------------------------------------------------------------------------
