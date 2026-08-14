{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- The converse arithmetic fact needed to turn
-- NaturalMachine.WalkForcing.leastNonDivisor-no-coprime-split into the
-- direction (⇒) of notes/WALK_INSTALLS_ARE_JUMPS.md §(c).
--
-- WalkForcing proves: a least non-divisor admits NO proper coprime
-- splitting.  To read that as "a least non-divisor is a prime power" one
-- needs the converse: everything that is not a prime power DOES admit a
-- proper coprime splitting.
--
-- FORM PROVED: (A) of the brief, the positive form, which needs no
-- negative hypothesis and no definition of "not a prime power":
--
--     if p ≠ r are primes both dividing n > 0, then n admits a proper
--     coprime splitting  n = a·b, gcd a b = 1, 1 < a, 1 < b.
--
--   `two-primes→coprime-split`.  The splitting is explicit: a = p^e is
--   the full p-part of n and b = n/p^e its p-free part, both produced by
--   `NaturalMachine.WalkJumps.strip` (fuel recursion whose case split is
--   `prime-alt`, so no decidable divisibility is used anywhere -- exactly
--   the technique the brief asked to be reused rather than reinvented).
--
-- Composed with WalkForcing this gives the payoff theorem
--
--     `leastNonDivisor-prime-divisors-agree`:
--     any two prime divisors of a least non-divisor are EQUAL.
--
--   which is the prime-power property of a least non-divisor in the only
--   form statable without a factorisation existence theorem (see scope).
--
-- Form (C) is also recorded, but only in its cheap half: `IsPrimePower`
-- is defined and `two-primes→¬prime-power` shows two distinct prime
-- divisors really do refute prime-power-ness, so the hypothesis of form
-- (A) is genuinely the negation of the form-(C) hypothesis, not a
-- weakening of it.
--
-- WHAT REMAINS OPEN, precisely.
--
--   * Full form (C), "n > 1 not a prime power ⟹ n splits", needs the
--     EXISTENCE of a prime divisor of an arbitrary n > 1 (and then of a
--     second one).  That is the one step this file does not supply, and
--     the obstruction is exactly located: producing a least divisor > 1
--     of n requires DECIDING `d ∣ n` for each candidate d, and cubical
--     v0.5 has no decidable divisibility (`Cubical.Data.Nat.Divisibility`
--     defines `_∣_` as a propositional truncation and provides no
--     `Dec`).  Everything else here dodges that by taking the prime as
--     GIVEN and case-splitting with `prime-alt` instead of a decision
--     procedure; a prime-divisor existence proof cannot dodge it, since
--     it has no prime in hand to split on.  (A route exists -- transport
--     `d ∣ n` across `n % d ≡ 0` using the library's `_%_` and
--     `discreteℕ` -- but the specification lemmas for `%` needed to close
--     it are not in v0.5's Divisibility module and were not attempted
--     here.)
--   * Consequently "a least non-divisor IS p^a for some prime p and
--     a ≥ 1" is still not a checked term: what is checked is that it has
--     at most one prime divisor.
--   * §(b) of the note (the walk installs exactly the jump points) is
--     untouched, as before.
--
-- CHECKED: Agda 2.6.3, cubical v0.5, --cubical --safe, 2026-08-13.
-- No postulates, no holes.

module NaturalMachine.CoprimeSplitting where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.Nat.GCD
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_; yes; no)

open import NaturalMachine.WalkForcing
  using (ProperCoprimeSplit; LeastNonDivisor;
         leastNonDivisor-no-coprime-split)
open import NaturalMachine.WalkJumps
  using (IsPrime; prime-0<; prime-¬∣1; prime-alt; coprime-cancel;
         prime-∣-·; Strip; strip; ^-pos; 0<→≢0; isPrime2; isPrime3)

------------------------------------------------------------------------
-- Coprimality lemmas (gcd-side throughout; no Bezout, no valuations)
------------------------------------------------------------------------

-- coprimality restricts along divisors of either argument
coprime-∣ʳ : (a c d : ℕ) → isGCD a c 1 → d ∣ c → isGCD a d 1
coprime-∣ʳ a c d g d∣c =
  (∣-oneˡ a , ∣-oneˡ d) , least
  where
  least : (d' : ℕ) → isCD a d d' → d' ∣ 1
  least d' cd = g .snd d' (cd .fst , ∣-trans (cd .snd) d∣c)

-- coprimality is multiplicative in the first argument.  Proof: a common
-- divisor d of a·b and c is coprime to a (it divides c), hence divides b
-- by `coprime-cancel`; but it is coprime to b too, so it divides 1.
coprime-·ˡ : (a b c : ℕ) → isGCD a c 1 → isGCD b c 1 → isGCD (a · b) c 1
coprime-·ˡ a b c ga gb =
  (∣-oneˡ (a · b) , ∣-oneˡ c) , least
  where
  least : (d : ℕ) → isCD (a · b) c d → d ∣ 1
  least d cd = coprime-∣ʳ b c d gb (cd .snd) .snd d (d∣b , ∣-refl refl)
    where
    d∣b : d ∣ b
    d∣b = coprime-cancel d a b
            (symGCD (coprime-∣ʳ a c d ga (cd .snd))) (cd .fst)

-- hence a power of p is coprime to anything p is coprime to
coprime-^ˡ : (p u : ℕ) → isGCD p u 1 → (e : ℕ) → isGCD (p ^ e) u 1
coprime-^ˡ p u g zero    = symGCD (oneGCD u)
coprime-^ˡ p u g (suc e) = coprime-·ˡ p (p ^ e) u g (coprime-^ˡ p u g e)

-- a prime dividing a power of p divides p (Euclid, iterated)
prime-∣-^ : (r p e : ℕ) → IsPrime r → r ∣ (p ^ e) → r ∣ p
prime-∣-^ r p zero    pr h = Empty.rec (prime-¬∣1 r pr h)
prime-∣-^ r p (suc e) pr h with prime-∣-· r p (p ^ e) pr h
... | inl r∣p  = r∣p
... | inr r∣pe = prime-∣-^ r p e pr r∣pe

-- a prime divisor of a prime is that prime
prime-∣-prime : (r p : ℕ) → IsPrime r → IsPrime p → r ∣ p → r ≡ p
prime-∣-prime r p pr pp r∣p with pp .snd r r∣p
... | inl r≡1 = Empty.rec (¬m<m (subst (1 <_) r≡1 (pr .fst)))
... | inr r≡p = r≡p

pos-≢1→1< : (u : ℕ) → 0 < u → ¬ (u ≡ 1) → 1 < u
pos-≢1→1< zero          0<u h = Empty.rec (¬-<-zero 0<u)
pos-≢1→1< (suc zero)    0<u h = Empty.rec (h refl)
pos-≢1→1< (suc (suc u)) 0<u h = suc-≤-suc (suc-≤-suc zero-≤)

------------------------------------------------------------------------
-- THE THEOREM (form (A)): two distinct prime divisors force a proper
-- coprime splitting
------------------------------------------------------------------------

-- n = (p-part of n) · (p-free part of n).  The p-part is > 1 because p
-- divides it; the p-free part is > 1 because otherwise n would be a pure
-- power of p, and then the second prime r would divide p, forcing r ≡ p.
two-primes→coprime-split :
  (n p r : ℕ) → 0 < n →
  IsPrime p → IsPrime r → ¬ (p ≡ r) →
  p ∣ n → r ∣ n →
  ProperCoprimeSplit n
two-primes→coprime-split n p r 0<n pp pr p≢r p∣n r∣n =
  (p ^ e) , u , peu , cop , 1<pe , 1<u
  where
  0<p : 0 < p
  0<p = prime-0< p pp

  st : Strip p n
  st = strip p pp n n 0<n ≤-refl

  e     = st .fst
  u     = st .snd .fst
  0<u   = st .snd .snd .fst

  peu : ((p ^ e) · u) ≡ n
  peu = st .snd .snd .snd .fst

  ¬p∣u : ¬ (p ∣ u)
  ¬p∣u = st .snd .snd .snd .snd

  gpu : isGCD p u 1
  gpu with prime-alt p pp u
  ... | inl p∣u = Empty.rec (¬p∣u p∣u)
  ... | inr g   = g

  cop : isGCD (p ^ e) u 1
  cop = coprime-^ˡ p u gpu e

  -- p divides the p-part (it divides n = p^e · u but not u)
  p∣pe : p ∣ (p ^ e)
  p∣pe with prime-∣-· p (p ^ e) u pp (subst (p ∣_) (sym peu) p∣n)
  ... | inl h = h
  ... | inr h = Empty.rec (¬p∣u h)

  1<pe : 1 < (p ^ e)
  1<pe = <≤-trans (pp .fst)
           (m∣n→m≤n (0<→≢0 (p ^ e) (^-pos p e 0<p)) p∣pe)

  u≢1 : ¬ (u ≡ 1)
  u≢1 u≡1 = p≢r (sym (prime-∣-prime r p pr pp r∣p))
    where
    pe≡n : (p ^ e) ≡ n
    pe≡n = sym (·-identityʳ (p ^ e))
           ∙ sym (cong ((p ^ e) ·_) u≡1)
           ∙ peu

    r∣p : r ∣ p
    r∣p = prime-∣-^ r p e pr (subst (r ∣_) (sym pe≡n) r∣n)

  1<u : 1 < u
  1<u = pos-≢1→1< u 0<u u≢1

------------------------------------------------------------------------
-- PAYOFF: composed with WalkForcing
------------------------------------------------------------------------

-- A least non-divisor has AT MOST ONE prime divisor.  This is the
-- prime-power property of the walk's installs, in the strongest form
-- available without a prime-divisor existence theorem: WalkForcing says
-- such a q admits no proper coprime splitting, and the theorem above
-- says two distinct prime divisors would produce one.
leastNonDivisor-prime-divisors-agree :
  (L q : ℕ) → 0 < q → LeastNonDivisor L q →
  (p r : ℕ) → IsPrime p → IsPrime r → p ∣ q → r ∣ q →
  p ≡ r
leastNonDivisor-prime-divisors-agree L q 0<q lnd p r pp pr p∣q r∣q
  with discreteℕ p r
... | yes p≡r = p≡r
... | no  p≢r =
      Empty.rec (leastNonDivisor-no-coprime-split L q lnd
                  (two-primes→coprime-split q p r 0<q pp pr p≢r p∣q r∣q))

------------------------------------------------------------------------
-- Form (C), the half that is cheap: two distinct prime divisors really
-- do refute prime-power-ness
------------------------------------------------------------------------

IsPrimePower : ℕ → Type
IsPrimePower n = Σ[ p ∈ ℕ ] Σ[ a ∈ ℕ ] (IsPrime p × ((p ^ a) ≡ n))

two-primes→¬prime-power :
  (n p r : ℕ) → IsPrime p → IsPrime r → ¬ (p ≡ r) →
  p ∣ n → r ∣ n → ¬ (IsPrimePower n)
two-primes→¬prime-power n p r pp pr p≢r p∣n r∣n (s , a , ps , sa≡n) =
  p≢r (p≡s ∙ sym r≡s)
  where
  p≡s : p ≡ s
  p≡s = prime-∣-prime p s pp ps
          (prime-∣-^ p s a pp (subst (p ∣_) (sym sa≡n) p∣n))

  r≡s : r ≡ s
  r≡s = prime-∣-prime r s pr ps
          (prime-∣-^ r s a pr (subst (r ∣_) (sym sa≡n) r∣n))

-- Hence, for a least non-divisor q > 0 with two prime divisors: the
-- hypothesis of form (A) and the negated hypothesis of form (C) coincide
-- on q, and both are impossible.  (Stated as the contrapositive so that
-- no existence theorem is needed.)
leastNonDivisor-two-primes-absurd :
  (L q : ℕ) → 0 < q → LeastNonDivisor L q →
  (p r : ℕ) → IsPrime p → IsPrime r → ¬ (p ≡ r) → p ∣ q → r ∣ q → ⊥
leastNonDivisor-two-primes-absurd L q 0<q lnd p r pp pr p≢r p∣q r∣q =
  p≢r (leastNonDivisor-prime-divisors-agree L q 0<q lnd p r pp pr p∣q r∣q)

------------------------------------------------------------------------
-- The theorem fired on a concrete number
------------------------------------------------------------------------

2≢3 : ¬ (2 ≡ 3)
2≢3 e = znots (injSuc (injSuc e))

0<6 : 0 < 6
0<6 = suc-≤-suc zero-≤

-- 6 = 2 · 3 splits properly and coprimely.  (Stated existentially: the
-- content is that the construction runs, not any particular numeral.)
split-6 : ProperCoprimeSplit 6
split-6 =
  two-primes→coprime-split 6 2 3 0<6 isPrime2 isPrime3 2≢3
    (∣-left 3) (∣-right 2)

-- …and therefore 6 is never a least non-divisor of anything.
6-not-least-non-divisor : (L : ℕ) → ¬ (LeastNonDivisor L 6)
6-not-least-non-divisor L lnd =
  leastNonDivisor-no-coprime-split L 6 lnd split-6

-- 6 is not a prime power, by the form-(C) corollary.
6-not-prime-power : ¬ (IsPrimePower 6)
6-not-prime-power =
  two-primes→¬prime-power 6 2 3 isPrime2 isPrime3 2≢3 (∣-left 3) (∣-right 2)
