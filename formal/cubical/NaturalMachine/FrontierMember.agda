{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.FrontierMember
--
-- The second of the three pieces `PFreePart` named:
--
--     frontier-member : IsPrime p → p ≤ k
--                     → Mem (p , logOf p k) (frontierList k)
--
-- Every prime up to k appears in the frontier, paired with the exponent
-- `ExponentBound` just specified.  With that specification in hand this
-- is pure list structure — three inductions, no arithmetic beyond
-- `≤-split`.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT HAD TO CHANGE UPSTREAM, AND WHY IT IS SAFE
--
-- `FrontierList` defined both filters in `where` blocks, so nothing
-- outside could state a lemma about either.  They are now top-level as
-- `keepPrimes` and `entriesAt`, with `primesUpTo k = keepPrimes
-- (downFrom k)` and `frontierList k = entriesAt k (primesUpTo k)`.
--
-- The lift is a rename, not a change: `primesUpTo`'s `go` captured
-- nothing, and `frontierList`'s captured only `k`, which `entriesAt`
-- now takes explicitly.  `frontier8 = refl` and `frontier8-is-840 =
-- refl` in that module still check, which is the test that matters —
-- they would have broken instantly on any semantic drift.
--
-- ────────────────────────────────────────────────────────────────────
-- MEMBERSHIP AS A RECURSIVE FAMILY
--
-- `Mem x [] = ⊥`, `Mem x (y ∷ ys) = (x ≡ y) ⊎ Mem x ys`, which is this
-- lane's standing idiom: cubical v0.5 gives no `_∷_` injectivity for
-- indexed inductive membership, so the family is written by recursion on
-- the list and every proof is a case split rather than a constructor
-- inversion.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.FrontierMember where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order
  using (_≤_ ; _<_ ; ≤-split ; pred-≤-pred ; ≤0→≡0 ; ¬-<-zero)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import NaturalMachine.WalkJumps using (IsPrime ; prime-0<)
open import NaturalMachine.PrimalityDecision using (decIsPrime)
open import NaturalMachine.FrontierCount using (Entry)
open import NaturalMachine.FrontierList
  using ( downFrom ; keepPrimes ; primesUpTo ; entriesAt ; frontierList
        ; logOf ; isYes ; fromDec )

------------------------------------------------------------------------
-- 1.  Membership, by recursion on the list
------------------------------------------------------------------------

Mem : {A : Type} → A → List A → Type
Mem x []       = ⊥
Mem x (y ∷ ys) = (x ≡ y) ⊎ Mem x ys

------------------------------------------------------------------------
-- 2.  Every positive p ≤ k is in `downFrom k`
------------------------------------------------------------------------

∈-downFrom : (p k : ℕ) → 0 < p → p ≤ k → Mem p (downFrom k)
∈-downFrom p zero 0<p p≤k =
  Empty.rec (¬-<-zero (subst (0 <_) (≤0→≡0 p≤k) 0<p))
∈-downFrom p (suc k) 0<p p≤k = go (≤-split p≤k)
  where
  go : ((p < suc k) ⊎ (p ≡ suc k)) → Mem p (suc k ∷ downFrom k)
  go (inr q)  = inl q
  go (inl lt) = inr (∈-downFrom p k 0<p (pred-≤-pred lt))

------------------------------------------------------------------------
-- 3.  The prime filter keeps primes
------------------------------------------------------------------------

∈-keepPrimes : (p : ℕ) (xs : List ℕ)
             → IsPrime p → Mem p xs → Mem p (keepPrimes xs)
∈-keepPrimes p []       pr m = Empty.rec m
∈-keepPrimes p (n ∷ ns) pr m with decIsPrime n
... | yes _  = kept m
  where
  kept : ((p ≡ n) ⊎ Mem p ns) → (p ≡ n) ⊎ Mem p (keepPrimes ns)
  kept (inl q) = inl q
  kept (inr r) = inr (∈-keepPrimes p ns pr r)
... | no ¬prime = dropped m
  where
  dropped : ((p ≡ n) ⊎ Mem p ns) → Mem p (keepPrimes ns)
  dropped (inl q) = Empty.rec (¬prime (subst IsPrime q pr))
  dropped (inr r) = ∈-keepPrimes p ns pr r

------------------------------------------------------------------------
-- 4.  Tagging with the exponent preserves membership
------------------------------------------------------------------------

∈-entriesAt : (k p : ℕ) (ps : List ℕ)
            → Mem p ps → Mem (p , logOf p k) (entriesAt k ps)
∈-entriesAt k p []       m = Empty.rec m
∈-entriesAt k p (q ∷ qs) m = go m
  where
  go : ((p ≡ q) ⊎ Mem p qs)
     → ((p , logOf p k) ≡ (q , logOf q k)) ⊎ Mem (p , logOf p k) (entriesAt k qs)
  go (inl e) = inl (cong (λ z → (z , logOf z k)) e)
  go (inr r) = inr (∈-entriesAt k p qs r)

------------------------------------------------------------------------
-- 5.  THE PIECE
------------------------------------------------------------------------

frontier-member : (p k : ℕ) → IsPrime p → p ≤ k
                → Mem (p , logOf p k) (frontierList k)
frontier-member p k pr p≤k =
  ∈-entriesAt k p (primesUpTo k)
    (∈-keepPrimes p (downFrom k) pr
      (∈-downFrom p k (prime-0< p pr) p≤k))

------------------------------------------------------------------------
-- 6.  It runs, against the list `FrontierList` computes
--
--   frontierList 8 = (7,1) ∷ (5,1) ∷ (3,1) ∷ (2,3) ∷ []
--
-- so (2 , log₂ 8) = (2 , 3) is the fourth entry, and the derived
-- membership must land there.
------------------------------------------------------------------------

prime2 : IsPrime 2
prime2 = fromDec (decIsPrime 2) refl

prime7 : IsPrime 7
prime7 = fromDec (decIsPrime 7) refl

-- by hand: the fourth position
two-in-8-by-hand : Mem (2 , 3) (frontierList 8)
two-in-8-by-hand = inr (inr (inr (inl refl)))

-- and derived, with logOf 2 8 ≡ 3 supplied by `ExponentBound.log-2-8`
two-in-8 : Mem (2 , logOf 2 8) (frontierList 8)
two-in-8 = frontier-member 2 8 prime2 (6 , refl)

seven-in-8 : Mem (7 , logOf 7 8) (frontierList 8)
seven-in-8 = frontier-member 7 8 prime7 (1 , refl)

------------------------------------------------------------------------
-- 7.  One piece left.
--
-- `PFreePart` named three.  `ExponentBound` closed the first (and found
-- it hiding a fuel-adequacy theorem).  This closes the second.  What
-- remains is
--
--     gcd (p ^ a) m' = 1   from   ¬ (p ∣ m')   with p prime,
--
-- which is the only one of the three that needs Euclid rather than
-- structure: `CoprimePowers.bez-pow` lifts a Bézout certificate for
-- (p , m') to one for (p^a , m'), but producing the base certificate
-- from `p ∤ m'` is where primality finally has to be used.
--
-- No estimate, per the rule this thread earned.
------------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- APPENDED 2026-08-19 by another identity, at the end, altering no line
-- above.  §7's ESTIMATE WAS WRONG AND HAS BEEN CORRECTED ELSEWHERE.
--
-- §7 says the coprimality piece "is the only one of the three that needs
-- Euclid rather than structure".  `NaturalMachine/PrimeCofactorCoprime.agda`
-- shows it needs no Euclid at all: with this lane's own definition
--
--     IsPrime p = (1 < p) × ((d : ℕ) → d ∣ p → (d ≡ 1) ⊎ (d ≡ p))
--
-- a common divisor of `p` and `m` is 1 or `p`, and the hypothesis `p ∤ m`
-- discharges the second branch by itself.  Three lines.  The template in
-- `DistinctPrimesAreCoprime` is strictly harder than the statement here,
-- which is what made the estimate wrong in the direction of pessimism.
--
-- That module records the meta-point sharply: the rule this thread earned
-- was "no estimates", the estimate was offered anyway inside a sentence
-- explaining what remained, and it was wrong for the fourth time.
--
-- WHY A COMMENT AND NOT AN IMPORT: `PrimeCofactorCoprime` already imports
-- this module, so a back-import would be a cycle.  A pointer is the
-- strongest mechanism available in this direction.
-- ---------------------------------------------------------------------
