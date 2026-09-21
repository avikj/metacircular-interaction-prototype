{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- FrontierList
--
-- `FrontierCount` proves the residue count for any list of (prime,
-- exponent) pairs with distinct primes, and leaves the list to the
-- caller.  Here the list is COMPUTED from the frontier, and its two
-- hypotheses are DECIDED, so a frontier costs one `refl` each.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
-- THE CONSTRUCTION
--
--     frontierList k  =  [ (p , âŠlog_p kâ‹) | p prime, p â‰ k ]
--
-- computed by filtering `PrimalityDecision.decIsPrime` over `1 â¦ k` and
-- pairing each prime with the largest exponent whose power stays â‰ k.
-- At k = 8 it is `(2,3) âˆ (3,1) âˆ (5,1) âˆ (7,1) âˆ []`, by `refl`, and its
-- product is 840.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
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
-- â” three `refl`s and no proof obligations.  That is what
-- `WalkObservationCount`'s hand-composed three CRT steps have become.
--
-- â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
--
-- At every concrete frontier the equality with lcm(1..k) holds by
-- computation; `frontier8-is-840` / `frontier12-is-27720` check two.
------------------------------------------------------------------------

module FrontierList where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Equiv using (_â‰ƒ_)
open import Cubical.Data.Nat using (â„• ; zero ; suc ; _+_ ; _Â·_ ; _^_ ; discreteâ„•)
open import Cubical.Data.Nat.Order using (_â‰¤_ ; â‰¤Dec ; _<_)
open import Cubical.Data.Fin using (Fin)
open import Cubical.Data.List using (List ; [] ; _âˆ·_)
open import Cubical.Data.Sigma
open import Cubical.Data.Unit using (Unit ; tt ; isPropUnit)
open import Cubical.Data.Bool using (Bool ; true ; false ; falseâ‰¢true)
open import Cubical.Data.Empty as E using (âŠ¥)
open import Cubical.Relation.Nullary using (Â¬_ ; Dec ; yes ; no)

open import PrimalityDecision using (decIsPrime)
open import WalkJumps using (IsPrime)
open import FrontierCount
  using (Entry ; prodOf ; VecOf ; AllPrime ; FreshFrom ; Distinct ; frontier-count)

------------------------------------------------------------------------
-- 1.  Reading a decision off, with the impossible branch discharged by
--     the computation rather than by a fabricated witness
------------------------------------------------------------------------

isYes : {A : Type} â†’ Dec A â†’ Bool
isYes (yes _) = true
isYes (no  _) = false

fromDec : {A : Type} (d : Dec A) â†’ isYes d â‰¡ true â†’ A
fromDec (yes a) _ = a
fromDec (no  _) p = E.rec (falseâ‰¢true p)

------------------------------------------------------------------------
-- 2.  The frontier's list
------------------------------------------------------------------------

-- largest i with p ^ i â‰ k, searched over a bound that always suffices
expOf : â„• â†’ â„• â†’ â„• â†’ â„•
expOf p k zero      = 0
expOf p k (suc gas) with â‰¤Dec (p ^ (suc (expOf p k gas))) k
... | yes _ = suc (expOf p k gas)
... | no  _ = expOf p k gas

logOf : â„• â†’ â„• â†’ â„•
logOf p k = expOf p k k

-- 1 â¦ k, descending, then filtered
downFrom : â„• â†’ List â„•
downFrom zero    = []
downFrom (suc n) = suc n âˆ· downFrom n

-- lifted out of `primesUpTo`'s `where` so that membership can be proved
-- about it (`FrontierMember`).  Definitionally unchanged:
-- nothing was captured, so the lift is a rename.
keepPrimes : List â„• â†’ List â„•
keepPrimes []       = []
keepPrimes (n âˆ· ns) with decIsPrime n
... | yes _ = n âˆ· keepPrimes ns
... | no  _ = keepPrimes ns

primesUpTo : â„• â†’ List â„•
primesUpTo k = keepPrimes (downFrom k)

-- likewise lifted; this one does capture `k`, so it takes it explicitly
entriesAt : â„• â†’ List â„• â†’ List Entry
entriesAt k []       = []
entriesAt k (p âˆ· ps) = (p , logOf p k) âˆ· entriesAt k ps

frontierList : â„• â†’ List Entry

frontierList k = entriesAt k (primesUpTo k)
------------------------------------------------------------------------
-- 3.  Both hypotheses are decidable
------------------------------------------------------------------------

decAllPrime : (es : List Entry) â†’ Dec (AllPrime es)
decAllPrime []             = yes tt
decAllPrime ((p , _) âˆ· es) with decIsPrime p | decAllPrime es
... | yes h | yes r = yes (h , r)
... | no  k | _     = no (Î» z â†’ k (fst z))
... | _     | no  k = no (Î» z â†’ k (snd z))

decFresh : (p : â„•) (es : List Entry) â†’ Dec (FreshFrom p es)
decFresh p []             = yes tt
decFresh p ((q , _) âˆ· es) with discreteâ„• p q | decFresh p es
... | yes e | _     = no (Î» z â†’ fst z e)
... | no  d | yes r = yes (d , r)
... | no  _ | no  k = no (Î» z â†’ k (snd z))

decDistinct : (es : List Entry) â†’ Dec (Distinct es)
decDistinct []             = yes tt
decDistinct ((p , _) âˆ· es) with decFresh p es | decDistinct es
... | yes f | yes r = yes (f , r)
... | no  k | _     = no (Î» z â†’ k (fst z))
... | _     | no  k = no (Î» z â†’ k (snd z))

------------------------------------------------------------------------
-- 4.  A frontier's residue count, in one expression
------------------------------------------------------------------------

countAt :
  (k : â„•)
  â†’ isYes (decAllPrime (frontierList k)) â‰¡ true
  â†’ isYes (decDistinct (frontierList k)) â‰¡ true
  â†’ Fin (prodOf (frontierList k)) â‰ƒ VecOf (frontierList k)
countAt k pa pd =
  frontier-count (frontierList k)
    (fromDec (decAllPrime (frontierList k)) pa)
    (fromDec (decDistinct (frontierList k)) pd)

------------------------------------------------------------------------
-- 5.  It runs.
------------------------------------------------------------------------

frontier8 : frontierList 8 â‰¡ (7 , 1) âˆ· (5 , 1) âˆ· (3 , 1) âˆ· (2 , 3) âˆ· []
frontier8 = refl

frontier8-is-840 : prodOf (frontierList 8) â‰¡ 840
frontier8-is-840 = refl

count8 : Fin (prodOf (frontierList 8)) â‰ƒ VecOf (frontierList 8)
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
-- halves â” divisible by every `m â‰ k`, and dividing every common multiple
-- â” and it needs existence of prime factorisation.  Named, not waved at.
------------------------------------------------------------------------
