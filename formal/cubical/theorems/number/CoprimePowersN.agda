{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- CoprimePowersN
--
-- The arithmetic the walk's general frontier needs, assembled over ‚ï:
--
--     primes‚ícoprime-powers :
--       IsPrime p ‚í IsPrime q ‚í ¬ (p ‚â° q)
--       ‚í (i j : ‚ï) ‚í isGCD (p ^ i) (q ^ j) 1
--
-- `CoprimePowers` proved certificates compose, over any ring.
-- `DistinctPrimesAreCoprime` supplied the base case over ‚ï.  What was
-- missing, and named there as the last gap, is the transfer between ‚ï and
-- ‚.  Both directions are here.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- PRIOR ART, SEARCHED FIRST THIS TIME
--
-- `Cubical.Data.Int.Divisibility` already carries the whole Euclidean
-- apparatus: a `B©zout` record, `b©zout : (m n : ‚) ‚í B©zout m n` built by
-- the Euclidean algorithm, and the two transfer maps
--
--     ‚à‚í‚à‚ï : m ‚à n ‚í abs m ‚à‚ï abs n
--     ‚à‚ï‚í‚à : abs m ‚à‚ï abs n ‚í m ‚à n
--
-- so the bridge is a matter of using them.  Six rediscoveries were logged
-- in this session by finding prior art at audit time; this file was
-- written after grepping for it, which is the whole of the difference.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- WHAT THE TWO DIRECTIONS COST
--
--   ‚ï ‚í ‚  (`isGCD‚íBez`)  run `b©zout`, argue its gcd is a unit because
--                          it divides 1 in ‚ï, then fix the sign.
--   ‚ ‚í ‚ï  (`Bez‚íisGCD`)  a common divisor divides both terms, hence the
--                          sum, hence 1.  Three lines.
--
-- Only the first needs the Euclidean algorithm.  That asymmetry is the
-- reason a certificate-carrying style pays: getting a certificate is
-- work; everything downstream of having one is not.  It is also exactly
-- ryabhaa's division of labour ‚î the kuaka is the hard part and the
-- multipliers are what you keep.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 ‚î the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module CoprimePowersN where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc ; _^_)
open import Cubical.Data.Nat.GCD using (isGCD ; isCD)
open import Cubical.Data.Nat.Divisibility using (‚à£-oneÀ° ; antisym‚à£) renaming (_‚à£_ to _‚à£‚Ñï_)
open import Cubical.Data.Int using (‚Ñ§ ; pos ; _+_ ; _¬∑_ ; -_ ; abs)
open import Cubical.Data.Int.Properties using (pos¬∑pos ; abs‚Üí‚äé ; -Involutive)
open import Cubical.Data.Int.Divisibility
  using (b√©zout ; B√©zout ; ‚à£‚Üí‚à£‚Ñï ; ‚à£‚Ñï‚Üí‚à£ ; ‚à£-+ ; ‚à£-left¬∑)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Relation.Nullary using (¬¨_)
open import Cubical.Algebra.CommRing.Instances.Int using (‚Ñ§CommRing)
open import Cubical.Tactics.CommRingSolver.Reflection using (solve!)

open import CoprimePowers using (module Bezout)
open import WalkJumps using (IsPrime)
open import DistinctPrimesAreCoprime using (distinct-primes-coprime)

open Bezout ‚Ñ§CommRing using (Bez ; pow ; coprime-powers)
open Cubical.Data.Int.Divisibility using () renaming (_‚à£_ to _‚à£‚Ñ§_)

------------------------------------------------------------------------
-- 0.  Ring rearrangements, by the solver
------------------------------------------------------------------------

private
  flip : (a b x y : ‚Ñ§) ‚Üí (a ¬∑ x) + (b ¬∑ y) ‚â° (x ¬∑ a) + (y ¬∑ b)
  flip a b x y = solve! ‚Ñ§CommRing

  negBoth : (a b x y : ‚Ñ§) ‚Üí
    (a ¬∑ (- x)) + (b ¬∑ (- y)) ‚â° - ((x ¬∑ a) + (y ¬∑ b))
  negBoth a b x y = solve! ‚Ñ§CommRing

------------------------------------------------------------------------
-- 1.  ‚ certificate ‚ü ‚ï coprimality.  Three lines and a transfer.
------------------------------------------------------------------------

Bez‚ÜíisGCD : (a b : ‚Ñï) ‚Üí Bez (pos a) (pos b) ‚Üí isGCD a b 1
Bez‚ÜíisGCD a b (x , y , p) = (‚à£-oneÀ° a , ‚à£-oneÀ° b) , divides
  where
  divides : (d : ‚Ñï) ‚Üí isCD a b d ‚Üí d ‚à£‚Ñï 1
  divides d (d‚à£a , d‚à£b) = ‚à£‚Üí‚à£‚Ñï (subst (pos d ‚à£‚Ñ§_) p sum)
    where
    dA : pos d ‚à£‚Ñ§ pos a
    dA = ‚à£‚Ñï‚Üí‚à£ {m = pos d} {n = pos a} d‚à£a

    dB : pos d ‚à£‚Ñ§ pos b
    dB = ‚à£‚Ñï‚Üí‚à£ {m = pos d} {n = pos b} d‚à£b

    sum : pos d ‚à£‚Ñ§ ((pos a ¬∑ x) + (pos b ¬∑ y))
    sum = ‚à£-+ (‚à£-left¬∑ {m = x} dA) (‚à£-left¬∑ {m = y} dB)

------------------------------------------------------------------------
-- 2.  ‚ï coprimality ‚ü ‚ certificate.  This is where Euclid runs.
------------------------------------------------------------------------

isGCD‚ÜíBez : (a b : ‚Ñï) ‚Üí isGCD a b 1 ‚Üí Bez (pos a) (pos b)
isGCD‚ÜíBez a b (_ , greatest) = go (abs‚Üí‚äé g (abs g) refl)
  where
  B = b√©zout (pos a) (pos b)

  c‚ÇÅ c‚ÇÇ g : ‚Ñ§
  c‚ÇÅ = B .B√©zout.coef‚ÇÅ
  c‚ÇÇ = B .B√©zout.coef‚ÇÇ
  g  = B .B√©zout.gcd

  ident : (c‚ÇÅ ¬∑ pos a) + (c‚ÇÇ ¬∑ pos b) ‚â° g
  ident = B .B√©zout.identity

  absg‚à£1 : abs g ‚à£‚Ñï 1
  absg‚à£1 = greatest (abs g) (‚à£‚Üí‚à£‚Ñï (B .B√©zout.isCD .fst) , ‚à£‚Üí‚à£‚Ñï (B .B√©zout.isCD .snd))

  absg‚â°1 : abs g ‚â° 1
  absg‚â°1 = antisym‚à£ absg‚à£1 (‚à£-oneÀ° (abs g))

  go : (g ‚â° pos (abs g)) ‚äé (g ‚â° - pos (abs g)) ‚Üí Bez (pos a) (pos b)
  go (inl q) = c‚ÇÅ , c‚ÇÇ , flip (pos a) (pos b) c‚ÇÅ c‚ÇÇ ‚àô ident ‚àô q ‚àô cong pos absg‚â°1
  go (inr q) =
      (- c‚ÇÅ) , (- c‚ÇÇ)
    , ( negBoth (pos a) (pos b) c‚ÇÅ c‚ÇÇ
      ‚àô cong -_ ident
      ‚àô cong -_ (q ‚àô cong (Œª k ‚Üí - pos k) absg‚â°1)
      ‚àô negneg )
    where
    negneg : - (- pos 1) ‚â° pos 1
    negneg = -Involutive (pos 1)

------------------------------------------------------------------------
-- 3.  Powers transfer
------------------------------------------------------------------------

posPow : (a n : ‚Ñï) ‚Üí pos (a ^ n) ‚â° pow (pos a) n
posPow a zero    = refl
posPow a (suc n) = pos¬∑pos a (a ^ n) ‚àô cong (pos a ¬∑_) (posPow a n)

------------------------------------------------------------------------
-- 4.  THE STATEMENT
------------------------------------------------------------------------

primes‚Üícoprime-powers :
  (p q : ‚Ñï) ‚Üí IsPrime p ‚Üí IsPrime q ‚Üí ¬¨ (p ‚â° q)
  ‚Üí (i j : ‚Ñï) ‚Üí isGCD (p ^ i) (q ^ j) 1
primes‚Üícoprime-powers p q pp qq p‚â¢q i j =
  Bez‚ÜíisGCD (p ^ i) (q ^ j)
    (subst2 Bez (sym (posPow p i)) (sym (posPow q j))
      (coprime-powers {a = pos p} {b = pos q}
        (isGCD‚ÜíBez p q (distinct-primes-coprime p q pp qq p‚â¢q)) i j))

------------------------------------------------------------------------
-- 5.  The chain is closed, end to end.
--
--   Kuttaka / Cubical's `b©zout`   the multipliers exist
--   DistinctPrimesAreCoprime       distinct primes are coprime
--   here ¬ß2                        that becomes a certificate over ‚
--   CoprimePowers                  certificates compose to powers
--   here ¬ß1                        the certificate becomes `isGCD` over ‚ï
--   CRTChain                       `isGCD` data ‚ü the residue equivalence
--   LosslessLowerBound             and the count is a minimum
--   OptimalObservation             so "optimal" is a definition
--
-- Every link checked, `--safe`, no postulates.  The walk's residue count
-- now rests on primality of its installs and nothing else.
------------------------------------------------------------------------
