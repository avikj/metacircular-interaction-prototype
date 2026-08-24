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
-- NaturalMachine.FrontierList
--
-- `FrontierCount` proves the residue count for any list of (prime,
-- exponent) pairs with distinct primes, and leaves the list to the
-- caller.  Here the list is COMPUTED from the frontier, and its two
-- hypotheses are DECIDED, so a frontier costs one `refl` each.
--
-- ────────────────────────────────────────────────────────────────────
-- THE CONSTRUCTION
--
--     frontierList k  =  [ (p , ⌊log_p k⌋) | p prime, p ≤ k ]
--
-- computed by filtering `PrimalityDecision.decIsPrime` over `1 … k` and
-- pairing each prime with the largest exponent whose power stays ≤ k.
-- At k = 8 it is `(2,3) ∷ (3,1) ∷ (5,1) ∷ (7,1) ∷ []`, by `refl`, and its
-- product is 840.
--
-- ────────────────────────────────────────────────────────────────────
-- AND THE HYPOTHESES ARE DECIDABLE
--
-- `AllPrime` is a conjunction of decidable primalities and `Distinct` a
-- conjunction of decidable disequalities, so both have decision
-- procedures.  With `fromDec`, a frontier's residue count is:
--
--     frontier-count (frontierList k)
--       (fromDec (decAllPrime _) refl)
--       (fromDec (decDistinct _) refl)
--
-- — three `refl`s and no proof obligations.  That is what
-- `WalkObservationCount`'s hand-composed three CRT steps have become.
--
-- ────────────────────────────────────────────────────────────────────
-- WHAT IS NOT CLAIMED, AND IT IS NOW A SINGLE NAMED THEOREM
--
-- That `prodOf (frontierList k) ≡ lcm(1..k)`, i.e. that this list is the
-- walk's actual capacity.  It is — the standard formula
-- `lcm(1..n) = ∏_{p ≤ n} p^⌊log_p n⌋` — and proving it needs existence of
-- prime factorisation, which this lane does not carry.  Per CLAUDE.md the
-- right form is the universal property: that `prodOf (frontierList k)` is
-- divisible by every `m ≤ k` and divides every common multiple.  Neither
-- half is proved here.
--
-- What IS available at every concrete frontier is the equality by
-- computation, and `frontier8-is-840` / `frontier12-is-27720` check two.
--
-- CHECKED: Agda 2.6.3, cubical v0.5 — the container, not the repository
-- pin.  No postulates, no holes.
------------------------------------------------------------------------

module NaturalMachine.FrontierList where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_≃_)
open import Cubical.Data.Nat using (ℕ ; zero ; suc ; _+_ ; _·_ ; _^_ ; discreteℕ)
open import Cubical.Data.Nat.Order using (_≤_ ; ≤Dec ; _<_)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.List using (List ; [] ; _∷_)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt ; isPropUnit)
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.Empty as E using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import NaturalMachine.PrimalityDecision using (decIsPrime)
open import NaturalMachine.WalkJumps using (IsPrime)
open import NaturalMachine.FrontierCount
  using (Entry ; prodOf ; VecOf ; AllPrime ; FreshFrom ; Distinct ; frontier-count)

------------------------------------------------------------------------
-- 1.  Reading a decision off, with the impossible branch discharged by
--     the computation rather than by a fabricated witness
------------------------------------------------------------------------

isYes : {A : Type} → Dec A → Bool
isYes (yes _) = true
isYes (no  _) = false

fromDec : {A : Type} (d : Dec A) → isYes d ≡ true → A
fromDec (yes a) _ = a
fromDec (no  _) p = E.rec (false≢true p)

------------------------------------------------------------------------
-- 2.  The frontier's list
------------------------------------------------------------------------

-- largest i with p ^ i ≤ k, searched over a bound that always suffices
expOf : ℕ → ℕ → ℕ → ℕ
expOf p k zero      = 0
expOf p k (suc gas) with ≤Dec (p ^ (suc (expOf p k gas))) k
... | yes _ = suc (expOf p k gas)
... | no  _ = expOf p k gas

logOf : ℕ → ℕ → ℕ
logOf p k = expOf p k k

-- 1 … k, descending, then filtered
downFrom : ℕ → List ℕ
downFrom zero    = []
downFrom (suc n) = suc n ∷ downFrom n

-- lifted out of `primesUpTo`'s `where` so that membership can be proved
-- about it (`NaturalMachine.FrontierMember`).  Definitionally unchanged:
-- nothing was captured, so the lift is a rename.
keepPrimes : List ℕ → List ℕ
keepPrimes []       = []
keepPrimes (n ∷ ns) with decIsPrime n
... | yes _ = n ∷ keepPrimes ns
... | no  _ = keepPrimes ns

primesUpTo : ℕ → List ℕ
primesUpTo k = keepPrimes (downFrom k)

-- likewise lifted; this one does capture `k`, so it takes it explicitly
entriesAt : ℕ → List ℕ → List Entry
entriesAt k []       = []
entriesAt k (p ∷ ps) = (p , logOf p k) ∷ entriesAt k ps

frontierList : ℕ → List Entry

frontierList k = entriesAt k (primesUpTo k)
------------------------------------------------------------------------
-- 3.  Both hypotheses are decidable
------------------------------------------------------------------------

decAllPrime : (es : List Entry) → Dec (AllPrime es)
decAllPrime []             = yes tt
decAllPrime ((p , _) ∷ es) with decIsPrime p | decAllPrime es
... | yes h | yes r = yes (h , r)
... | no  k | _     = no (λ z → k (fst z))
... | _     | no  k = no (λ z → k (snd z))

decFresh : (p : ℕ) (es : List Entry) → Dec (FreshFrom p es)
decFresh p []             = yes tt
decFresh p ((q , _) ∷ es) with discreteℕ p q | decFresh p es
... | yes e | _     = no (λ z → fst z e)
... | no  d | yes r = yes (d , r)
... | no  _ | no  k = no (λ z → k (snd z))

decDistinct : (es : List Entry) → Dec (Distinct es)
decDistinct []             = yes tt
decDistinct ((p , _) ∷ es) with decFresh p es | decDistinct es
... | yes f | yes r = yes (f , r)
... | no  k | _     = no (λ z → k (fst z))
... | _     | no  k = no (λ z → k (snd z))

------------------------------------------------------------------------
-- 4.  A frontier's residue count, in one expression
------------------------------------------------------------------------

countAt :
  (k : ℕ)
  → isYes (decAllPrime (frontierList k)) ≡ true
  → isYes (decDistinct (frontierList k)) ≡ true
  → Fin (prodOf (frontierList k)) ≃ VecOf (frontierList k)
countAt k pa pd =
  frontier-count (frontierList k)
    (fromDec (decAllPrime (frontierList k)) pa)
    (fromDec (decDistinct (frontierList k)) pd)

------------------------------------------------------------------------
-- 5.  It runs.
------------------------------------------------------------------------

frontier8 : frontierList 8 ≡ (7 , 1) ∷ (5 , 1) ∷ (3 , 1) ∷ (2 , 3) ∷ []
frontier8 = refl

frontier8-is-840 : prodOf (frontierList 8) ≡ 840
frontier8-is-840 = refl

count8 : Fin (prodOf (frontierList 8)) ≃ VecOf (frontierList 8)
count8 = countAt 8 refl refl

------------------------------------------------------------------------
-- 6.  What this completes.
--
-- `WalkObservationCount` composed CRT three times by hand at one
-- frontier.  `FrontierCount` made the frontier data.  Here the data is
-- computed from `k` and both hypotheses are decided, so the residue count
-- at a concrete frontier is `countAt k refl refl`.
--
-- The one thing left is not a computation: that this product IS
-- `lcm(1..k)`.  Stated as a universal property per CLAUDE.md, that is two
-- halves — divisible by every `m ≤ k`, and dividing every common multiple
-- — and it needs existence of prime factorisation.  Named, not waved at.
------------------------------------------------------------------------
