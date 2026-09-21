{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FrontierMember
--
-- The second of the three pieces `PFreePart` named:
--
--     frontier-member : IsPrime p ‚í p ‚â k
--                     ‚í Mem (p , logOf p k) (frontierList k)
--
-- Every prime up to k appears in the frontier, paired with the exponent
-- `ExponentBound` just specified.  With that specification in hand this
-- is pure list structure ‚î three inductions, no arithmetic beyond
-- `‚â-split`.
--
-- ‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î‚î
-- MEMBERSHIP AS A RECURSIVE FAMILY
--
-- `Mem x [] = ‚ä`, `Mem x (y ‚à ys) = (x ‚â° y) ‚ä Mem x ys`, which is this
-- lane's standing idiom: cubical v0.5 gives no `_‚à_` injectivity for
-- indexed inductive membership, so the family is written by recursion on
-- the list and every proof is a case split rather than a constructor
-- inversion.
------------------------------------------------------------------------

module FrontierMember where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (‚Ñï ; zero ; suc)
open import Cubical.Data.Nat.Order
  using (_‚â§_ ; _<_ ; ‚â§-split ; pred-‚â§-pred ; ‚â§0‚Üí‚â°0 ; ¬¨-<-zero)
open import Cubical.Data.List using (List ; [] ; _‚à∑_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_‚äé_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (‚ä•)
open import Cubical.Relation.Nullary using (¬¨_ ; Dec ; yes ; no)

open import WalkJumps using (IsPrime ; prime-0<)
open import PrimalityDecision using (decIsPrime)
open import FrontierCount using (Entry)
open import FrontierList
  using ( downFrom ; keepPrimes ; primesUpTo ; entriesAt ; frontierList
        ; logOf ; isYes ; fromDec )

------------------------------------------------------------------------
-- 1.  Membership, by recursion on the list
------------------------------------------------------------------------

Mem : {A : Type} ‚Üí A ‚Üí List A ‚Üí Type
Mem x []       = ‚ä•
Mem x (y ‚à∑ ys) = (x ‚â° y) ‚äé Mem x ys

------------------------------------------------------------------------
-- 2.  Every positive p ‚â k is in `downFrom k`
------------------------------------------------------------------------

‚àà-downFrom : (p k : ‚Ñï) ‚Üí 0 < p ‚Üí p ‚â§ k ‚Üí Mem p (downFrom k)
‚àà-downFrom p zero 0<p p‚â§k =
  Empty.rec (¬¨-<-zero (subst (0 <_) (‚â§0‚Üí‚â°0 p‚â§k) 0<p))
‚àà-downFrom p (suc k) 0<p p‚â§k = go (‚â§-split p‚â§k)
  where
  go : ((p < suc k) ‚äé (p ‚â° suc k)) ‚Üí Mem p (suc k ‚à∑ downFrom k)
  go (inr q)  = inl q
  go (inl lt) = inr (‚àà-downFrom p k 0<p (pred-‚â§-pred lt))

------------------------------------------------------------------------
-- 3.  The prime filter keeps primes
------------------------------------------------------------------------

‚àà-keepPrimes : (p : ‚Ñï) (xs : List ‚Ñï)
             ‚Üí IsPrime p ‚Üí Mem p xs ‚Üí Mem p (keepPrimes xs)
‚àà-keepPrimes p []       pr m = Empty.rec m
‚àà-keepPrimes p (n ‚à∑ ns) pr m with decIsPrime n
... | yes _  = kept m
  where
  kept : ((p ‚â° n) ‚äé Mem p ns) ‚Üí (p ‚â° n) ‚äé Mem p (keepPrimes ns)
  kept (inl q) = inl q
  kept (inr r) = inr (‚àà-keepPrimes p ns pr r)
... | no ¬¨prime = dropped m
  where
  dropped : ((p ‚â° n) ‚äé Mem p ns) ‚Üí Mem p (keepPrimes ns)
  dropped (inl q) = Empty.rec (¬¨prime (subst IsPrime q pr))
  dropped (inr r) = ‚àà-keepPrimes p ns pr r

------------------------------------------------------------------------
-- 4.  Tagging with the exponent preserves membership
------------------------------------------------------------------------

‚àà-entriesAt : (k p : ‚Ñï) (ps : List ‚Ñï)
            ‚Üí Mem p ps ‚Üí Mem (p , logOf p k) (entriesAt k ps)
‚àà-entriesAt k p []       m = Empty.rec m
‚àà-entriesAt k p (q ‚à∑ qs) m = go m
  where
  go : ((p ‚â° q) ‚äé Mem p qs)
     ‚Üí ((p , logOf p k) ‚â° (q , logOf q k)) ‚äé Mem (p , logOf p k) (entriesAt k qs)
  go (inl e) = inl (cong (Œª z ‚Üí (z , logOf z k)) e)
  go (inr r) = inr (‚àà-entriesAt k p qs r)

------------------------------------------------------------------------
-- 5.  THE PIECE
------------------------------------------------------------------------

frontier-member : (p k : ‚Ñï) ‚Üí IsPrime p ‚Üí p ‚â§ k
                ‚Üí Mem (p , logOf p k) (frontierList k)
frontier-member p k pr p‚â§k =
  ‚àà-entriesAt k p (primesUpTo k)
    (‚àà-keepPrimes p (downFrom k) pr
      (‚àà-downFrom p k (prime-0< p pr) p‚â§k))

------------------------------------------------------------------------
-- 6.  It runs, against the list `FrontierList` computes
--
--   frontierList 8 = (7,1) ‚à (5,1) ‚à (3,1) ‚à (2,3) ‚à []
--
-- so (2 , log‚ 8) = (2 , 3) is the fourth entry, and the derived
-- membership must land there.
------------------------------------------------------------------------

prime2 : IsPrime 2
prime2 = fromDec (decIsPrime 2) refl

prime7 : IsPrime 7
prime7 = fromDec (decIsPrime 7) refl

-- by hand: the fourth position
two-in-8-by-hand : Mem (2 , 3) (frontierList 8)
two-in-8-by-hand = inr (inr (inr (inl refl)))

-- and derived, with logOf 2 8 ‚â° 3 supplied by `ExponentBound.log-2-8`
two-in-8 : Mem (2 , logOf 2 8) (frontierList 8)
two-in-8 = frontier-member 2 8 prime2 (6 , refl)

seven-in-8 : Mem (7 , logOf 7 8) (frontierList 8)
seven-in-8 = frontier-member 7 8 prime7 (1 , refl)

------------------------------------------------------------------------
-- 7.  The coprimality piece.
--
-- The third ingredient `FrontierDividesHard` needs, beside `ExponentBound`
-- and this module, is
--
--     gcd (p ^ a) m' = 1   from   ¬ (p ‚à m')   with p prime,
--
-- which `NaturalMachine/PrimeCofactorCoprime.agda` proves without Euclid:
-- with this lane's own definition of `IsPrime` a common divisor of `p` and
-- `m` is 1 or `p`, and the hypothesis `p ‚à§ m` discharges the second branch
-- by itself.  Three lines.
------------------------------------------------------------------------
