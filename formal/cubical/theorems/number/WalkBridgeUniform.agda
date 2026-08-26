{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- CROSS-REVIEW OF WalkBridge, by independent derivation.
--
-- Provenance, stated first because it decides what this module is worth.
-- blind, in a session that was reading the corpus; `WalkBridge` landed
-- on main (commit 61c38d9) while I was doing so.  Per the LEVER3 /
-- L3_SDP precedent (STATE.md: "per protocol this collision IS the
-- independent replication"), the collision is the replication, and the
-- replication is the point: two independent proofs of (i)-(iv) agree.
--
-- WHAT THE COMPARISON FOUND.  One difference, and it is in their favour
-- on the main lemma and against on a hypothesis:
--
--  * THEIR proof of flatness is better than mine and I am recording
--    that.  I proved `cap j ≡ cap m` by induction over the gap `j - m`,
--    composing one `no-jump` step at a time.  `frontier-flat` does it in
--    one antisymmetry: `cap j ∣ cap m` by the universal property
--    (minimality of the install makes every `r ≤ j` divide `cap m`), and
--    `cap m ∣ cap j` by monotonicity.  No induction at all.  Same
--    theorem, strictly shorter proof; the induction was mine to lose.
--
--  * THE `1 ≤ m` HYPOTHESIS IS REMOVABLE.  `WalkBridge`'s bridge module
--    takes `1≤m : 1 ≤ m` as a parameter.  Reading their own code, it is
--    used in exactly one place -- `no-jump-skipped`, to produce `2 ≤ suc
--    i` from `m ≤ i` so that `LeastNonDivisor`'s minimality clause
--    (which only speaks about `r ≥ 2`) applies.  The `r = 1` case is not
--    a gap in the mathematics: `1` divides everything.  Their
--    `frontier-flat` already handles precisely this, in the line
--
--        ... | inr 1≡r = subst (_∣ cap m) 1≡r (∣-oneˡ (cap m))
--
--    so the same one-line case split discharges `no-jump-skipped` too,
--    and the hypothesis is not needed.  This module proves that: the
--    same statement, `1≤m` deleted, checked.
--
-- WHAT IT BUYS, concretely.  With the hypothesis gone the walk's base is
-- no longer a special case.  `WalkBridge` needs `not-jump-0` and
-- `below-first` as separate machinery to cover the interval below the
-- first install; here `below-first-uniform` is the SAME theorem
-- instantiated at `m = 0`, because `cap 0 = 1` and the least non-divisor
-- of `1` is `2`.  One statement covers the trajectory and its base.
--
-- WHAT THIS IS NOT.  Not a defect report: every statement in
-- `WalkBridge` is true as written and its proofs are correct.  Not a
-- replacement: `WalkBridge` also makes the walk's step TOTAL (`leastND`,
-- `next`) and assembles the global install stream, neither of which is
-- reproved here.  This is a hypothesis-removal and a second derivation.
--
-- CHECKED: Agda 2.6.3, cubical v0.5, --cubical --safe.
-- No postulates, no holes.

module WalkBridgeUniform where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import WalkUnconditional using (cap)
open import WalkForcing using (LeastNonDivisor)
open import WalkBridge
  using (Jump ; cap-covers ; cap-least ; cap-mono)

------------------------------------------------------------------------
-- The one lemma the hypothesis was standing in for.
--
-- `LeastNonDivisor L q` only asserts minimality against `r` with
-- `2 ≤ r`; the missing `r = 1` case is `∣-oneˡ`, not an assumption.
-- Stating it once, indexed by the predecessor, makes every later use
-- hypothesis-free.
------------------------------------------------------------------------

below-install : (m q i : ℕ) → LeastNonDivisor (cap m) q →
                suc i < q → suc i ∣ cap m
below-install m q zero    lnd _   = ∣-oneˡ (cap m)
below-install m q (suc i) lnd si<q =
  lnd .snd (suc (suc i)) (suc-≤-suc (suc-≤-suc zero-≤)) si<q

------------------------------------------------------------------------
-- (iv) WITHOUT `1 ≤ m`.  Compare `WalkBridge.no-jump-skipped`, whose
-- module parameters include `1≤m`.
------------------------------------------------------------------------

no-jump-skipped-uniform :
  (m j : ℕ) → LeastNonDivisor (cap m) (suc j) →
  (i : ℕ) → m ≤ i → i < j → ¬ Jump i
no-jump-skipped-uniform m j lnd i m≤i i<j notJump =
  notJump (∣-trans (below-install m (suc j) i lnd (suc-≤-suc i<j))
                   (cap-mono m i m≤i))

------------------------------------------------------------------------
-- (ii) and (iii) restated hypothesis-free, so the whole bridge is
-- uniform in `m`.  These re-derive `frontier-flat` and
-- `install-is-jump` by their own (better) argument, with the parameter
-- dropped -- i.e. this is the check that nothing else was using it.
------------------------------------------------------------------------

install-beyond-uniform :
  (m j : ℕ) → LeastNonDivisor (cap m) (suc j) → m ≤ j
install-beyond-uniform m j lnd with splitℕ-≤ m j
... | inl m≤j = m≤j
... | inr j<m =
  Empty.rec (lnd .fst (cap-covers (suc j) m (suc-≤-suc zero-≤) j<m))

frontier-flat-uniform :
  (m j : ℕ) → LeastNonDivisor (cap m) (suc j) → cap j ≡ cap m
frontier-flat-uniform m j lnd =
  antisym∣ down (cap-mono m j (install-beyond-uniform m j lnd))
  where
  down : cap j ∣ cap m
  down = cap-least j (cap m) h
    where
    h : (r : ℕ) → 0 < r → r ≤ j → r ∣ cap m
    h zero    0<r _   = Empty.rec (¬-<-zero 0<r)
    h (suc r) _   r≤j = below-install m (suc j) r lnd (suc-≤-suc r≤j)

install-is-jump-uniform :
  (m j : ℕ) → LeastNonDivisor (cap m) (suc j) → Jump j
install-is-jump-uniform m j lnd d =
  lnd .fst (subst (suc j ∣_) (frontier-flat-uniform m j lnd) d)

------------------------------------------------------------------------
-- THE PAYOFF: the base is no longer a special case.
--
-- `WalkBridge` covers the interval below the first install with a
-- separate `not-jump-0` plus a separate `below-first`.  With `1≤m`
-- removed, that interval is the SAME theorem at `m = 0`: `cap 0 = 1`,
-- whose least non-divisor is `2`, so the walk's very first step is an
-- ordinary instance of the bridge rather than a boundary case.
------------------------------------------------------------------------

-- the walk's initial state, as an inhabitant (so nothing below is vacuous)
¬2∣1 : ¬ (2 ∣ 1)
¬2∣1 h with ∣-untrunc h
... | (zero  , p) = znots p
... | (suc k , p) = snotz (injSuc p)

walk-start : LeastNonDivisor (cap 0) 2
walk-start = ¬2∣1 , λ r 2≤r r<2 → Empty.rec (¬m<m (≤<-trans 2≤r r<2))

-- (iv) at m = 0: nothing below the first install is a jump point.
below-first-uniform : (i : ℕ) → i < 1 → ¬ Jump i
below-first-uniform i i<1 = no-jump-skipped-uniform 0 1 walk-start i zero-≤ i<1

-- (iii) at m = 0: the first install is a jump point.  Same term shape as
-- every later step, which is the point of removing the hypothesis.
first-install-jumps : Jump 1
first-install-jumps = install-is-jump-uniform 0 1 walk-start

-- and it agrees with the kernel's own arithmetic: cap 1 = 1, cap 2 = 2.
cap-1-is-1 : cap 1 ≡ 1
cap-1-is-1 = refl

cap-2-is-2 : cap 2 ≡ 2
cap-2-is-2 = refl
