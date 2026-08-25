{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FrontierIsWellFormed
--
-- `FrontierList.countAt` gives the frontier's residue count only at a
-- `k` you name:
--
--     countAt : (k : ℕ)
--             → isYes (decAllPrime (frontierList k)) ≡ true
--             → isYes (decDistinct (frontierList k)) ≡ true
--             → Fin (prodOf (frontierList k)) ≃ VecOf (frontierList k)
--
-- Both hypotheses are supplied by `refl` at each concrete `k`.  That is
-- the same arrangement `notes/THE_FUEL_WAS_NEVER_IN_THE_TYPE.md` is
-- about, one level up: a decision procedure run at one input standing in
-- for a theorem about all of them.  Here it is the theorem.
--
--     frontier-allPrime : (k : ℕ) → AllPrime  (frontierList k)
--     frontier-distinct : (k : ℕ) → Distinct  (frontierList k)
--     frontier-count-at : (k : ℕ)
--                       → Fin (prodOf (frontierList k)) ≃ VecOf (frontierList k)
--
-- ────────────────────────────────────────────────────────────────────
-- WHY IT IS SHORT NOW
--
-- Because `FrontierMember` already had to lift `keepPrimes` and
-- `entriesAt` out of their `where` blocks to state membership.  With
-- names on them, both properties are structural:
--
--   primality   the filter admits `n` only in the branch where
--               `decIsPrime n` said `yes`, and that branch's witness is
--               the proof;
--   distinctness `downFrom` is strictly descending, so its head exceeds
--               every tail element, and both the filter and the tagging
--               preserve "not in".
--
-- No arithmetic beyond `¬m<m`.  The two auxiliary families `NotIn` and
-- `NoDup` are recursive over the list, this lane's standing idiom.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module FrontierIsWellFormed where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc)
open import Cubical.Data.Nat.Order using (_<_ ; ≤-refl ; <-weaken ; ¬m<m)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import WalkJumps using (IsPrime)
open import PrimalityDecision using (decIsPrime)
open import FrontierCount
  using ( Entry ; prodOf ; VecOf ; AllPrime ; FreshFrom ; Distinct
        ; frontier-count )
open import FrontierList
  using (downFrom ; keepPrimes ; primesUpTo ; entriesAt ; frontierList ; logOf)

------------------------------------------------------------------------
-- 1.  Two recursive families over ℕ-lists
------------------------------------------------------------------------

AllP : List ℕ → Type
AllP []       = Unit
AllP (n ∷ ns) = IsPrime n × AllP ns

NotIn : ℕ → List ℕ → Type
NotIn a []       = Unit
NotIn a (n ∷ ns) = (¬ (a ≡ n)) × NotIn a ns

NoDup : List ℕ → Type
NoDup []       = Unit
NoDup (n ∷ ns) = NotIn n ns × NoDup ns

------------------------------------------------------------------------
-- 2.  The filter admits only primes, and its witness is at hand
------------------------------------------------------------------------

keepPrimes-allP : (xs : List ℕ) → AllP (keepPrimes xs)
keepPrimes-allP []       = tt
keepPrimes-allP (n ∷ ns) with decIsPrime n
... | yes pr = pr , keepPrimes-allP ns
... | no  _  = keepPrimes-allP ns

------------------------------------------------------------------------
-- 3.  The filter and the tagging both preserve "not in"
------------------------------------------------------------------------

keepPrimes-notIn : (a : ℕ) (xs : List ℕ) → NotIn a xs → NotIn a (keepPrimes xs)
keepPrimes-notIn a []       ni = tt
keepPrimes-notIn a (n ∷ ns) ni with decIsPrime n
... | yes _ = fst ni , keepPrimes-notIn a ns (snd ni)
... | no  _ = keepPrimes-notIn a ns (snd ni)

keepPrimes-noDup : (xs : List ℕ) → NoDup xs → NoDup (keepPrimes xs)
keepPrimes-noDup []       nd = tt
keepPrimes-noDup (n ∷ ns) nd with decIsPrime n
... | yes _ = keepPrimes-notIn n ns (fst nd) , keepPrimes-noDup ns (snd nd)
... | no  _ = keepPrimes-noDup ns (snd nd)

------------------------------------------------------------------------
-- 4.  `downFrom` is strictly descending, hence duplicate-free
------------------------------------------------------------------------

notIn-above : (a n : ℕ) → n < a → NotIn a (downFrom n)
notIn-above a zero    n<a = tt
notIn-above a (suc n) n<a =
  (λ q → ¬m<m (subst (_< a) (sym q) n<a)) , notIn-above a n (<-weaken n<a)

downFrom-noDup : (n : ℕ) → NoDup (downFrom n)
downFrom-noDup zero    = tt
downFrom-noDup (suc n) = notIn-above (suc n) n ≤-refl , downFrom-noDup n

------------------------------------------------------------------------
-- 5.  Tagging with the exponent transports both properties
------------------------------------------------------------------------

entriesAt-allPrime : (k : ℕ) (ps : List ℕ) → AllP ps → AllPrime (entriesAt k ps)
entriesAt-allPrime k []       ap = tt
entriesAt-allPrime k (p ∷ ps) ap = fst ap , entriesAt-allPrime k ps (snd ap)

entriesAt-fresh : (k a : ℕ) (ps : List ℕ)
                → NotIn a ps → FreshFrom a (entriesAt k ps)
entriesAt-fresh k a []       ni = tt
entriesAt-fresh k a (p ∷ ps) ni = fst ni , entriesAt-fresh k a ps (snd ni)

entriesAt-distinct : (k : ℕ) (ps : List ℕ) → NoDup ps → Distinct (entriesAt k ps)
entriesAt-distinct k []       nd = tt
entriesAt-distinct k (p ∷ ps) nd =
  entriesAt-fresh k p ps (fst nd) , entriesAt-distinct k ps (snd nd)

------------------------------------------------------------------------
-- 6.  THE TWO HYPOTHESES, now theorems
------------------------------------------------------------------------

frontier-allPrime : (k : ℕ) → AllPrime (frontierList k)
frontier-allPrime k =
  entriesAt-allPrime k (primesUpTo k) (keepPrimes-allP (downFrom k))

frontier-distinct : (k : ℕ) → Distinct (frontierList k)
frontier-distinct k =
  entriesAt-distinct k (primesUpTo k)
    (keepPrimes-noDup (downFrom k) (downFrom-noDup k))

------------------------------------------------------------------------
-- 7.  THE RESIDUE COUNT, at every k
------------------------------------------------------------------------

frontier-count-at :
  (k : ℕ) → Fin (prodOf (frontierList k)) ≃ VecOf (frontierList k)
frontier-count-at k =
  frontier-count (frontierList k) (frontier-allPrime k) (frontier-distinct k)

------------------------------------------------------------------------
-- 8.  What this removes.
--
-- `countAt` still exists and still works; nothing about it was wrong.
-- What it could not do was be applied to a `k` nobody had evaluated,
-- because its hypotheses were `refl`s about a decision procedure's
-- output.  `frontier-count-at` takes only `k`.
--
-- Together with `FrontierDividesHard`, the frontier at every k now has
-- both of its properties as theorems:
--
--   prodOf (frontierList k) is lcm(1 … k)      universal property
--   Fin (prodOf (frontierList k)) ≃ VecOf …    residue count
--
-- and neither rests on a computed instance any more.
--
-- The general shape, third instance in this thread: a decision
-- procedure run at one input is the same kind of stand-in as a fuelled
-- computation checked at one input.  `Dec` at least cannot lie about
-- the input it was run on — which is exactly why this one was harmless
-- and the fuel ones were not.
------------------------------------------------------------------------
