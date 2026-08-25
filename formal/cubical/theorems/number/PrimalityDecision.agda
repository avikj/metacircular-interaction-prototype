{-# OPTIONS --cubical --safe #-}

-- PrimalityDecision: `Dec (IsPrime n)` for every n : ℕ.
--
-- WHAT THIS CLOSES.  `WalkJumps` (its `IsPrime` block), `CoprimeSplitting`
-- (§ header, "no `Dec (IsPrime n)` in NaturalMachine/"), and the README's
-- §1 work-queue row all record the same confession, re-checked open on
-- 2026-08-15:
--
--     "there is no `Dec (IsPrime n)` anywhere in NaturalMachine/.  What
--      DOES exist is WalkFast.decIsPrimePower (decides prime-POWER-hood,
--      which is what the walk needs) and CoprimeSplitting.primeDivisor
--      (PRODUCES a prime divisor).  Deciding IsPrime itself is a bounded
--      search that nobody in this lane has had a use for; it is unwritten,
--      not blocked."
--
-- It was, exactly as diagnosed, unwritten rather than blocked: no new
-- number theory is used.  `CoprimeSplitting.searchDiv n k` already returns
-- either a nontrivial divisor ≤ k or a proof that none exists; the whole
-- decision is dispatching on that one search at k = n-1.
--
--   * NoDivBelow n (n-1)  ⟶  IsPrime n           (noDiv→prime)
--   * a divisor d, 1<d, d≤n-1, d∣n  ⟶  ¬ IsPrime n
--         (primality would force d ≡ 1 or d ≡ n, both refuted by the
--          bounds the divisor already carries)
--
-- The bound k = n-1 is what makes the divisor case a refutation rather
-- than merely "found a divisor": a divisor d ≤ n-1 with d ∣ n and 1 < d
-- is exactly a proper nontrivial factor.
--
-- CHECKED: Agda 2.6.3, cubical (local pin), --cubical --safe.
-- No postulates, no holes.

module PrimalityDecision where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_; Dec; yes; no)

open import WalkJumps using (IsPrime)
open import CoprimeSplitting
  using (DivBelow; NoDivBelow; searchDiv; noDiv→prime)

------------------------------------------------------------------------
-- The refutation half: a nontrivial divisor ≤ n-1 contradicts primality.
------------------------------------------------------------------------

-- For n = suc (suc m): a divisor d with 1 < d, d ≤ suc m, d ∣ n cannot
-- exist alongside IsPrime n, because IsPrime's divisor clause forces
-- d ≡ 1 (impossible, 1 < d) or d ≡ n (impossible, d ≤ n-1 = suc m).
divBelow→¬prime :
  (m : ℕ) → DivBelow (suc (suc m)) (suc m) → ¬ IsPrime (suc (suc m))
divBelow→¬prime m (d , 1<d , d≤sm , d∣n) pr with pr .snd d d∣n
... | inl d≡1 = ¬m<m (subst (1 <_) d≡1 1<d)              -- 1 < 1
... | inr d≡n = ¬m<m (subst (_≤ suc m) d≡n d≤sm)          -- suc m < suc m

------------------------------------------------------------------------
-- The decision procedure.
------------------------------------------------------------------------

-- 0 and 1 fail the `1 < p` clause; from 2 upward the single bounded
-- search decides it.
decIsPrime : (n : ℕ) → Dec (IsPrime n)
decIsPrime zero          = no (λ pr → ¬-<-zero (pr .fst))       -- 1 < 0
decIsPrime (suc zero)    = no (λ pr → ¬m<m (pr .fst))           -- 1 < 1
decIsPrime (suc (suc m)) with searchDiv (suc (suc m)) (suc m)
... | inl below = no (divBelow→¬prime m below)
... | inr none  = yes (noDiv→prime (suc m) (suc-≤-suc (suc-≤-suc zero-≤)) none)
