{-# OPTIONS --cubical --safe --no-import-sorts #-}

-- Direction (⇒) of notes/WALK_INSTALLS_ARE_JUMPS.md §(c), CLOSED.
--
-- NaturalMachine.WalkForcing proves that a least non-divisor admits NO
-- proper coprime splitting.  Reading that as "a least non-divisor is a
-- prime power" needs the converse arithmetic fact, which is what this
-- file supplies.
--
-- WHAT IS PROVED.
--
--   (A) `two-primes→coprime-split` -- the brief's recommended target, in
--       its positive form, needing no negative hypothesis and no
--       definition of "not a prime power":
--
--         p ≠ r primes, both dividing n > 0
--           ⟹  n = a·b with gcd a b = 1 and 1 < a, 1 < b.
--
--       The splitting is explicit: a = p^e is the full p-part of n and
--       b its p-free cofactor, both produced by
--       `NaturalMachine.WalkJumps.strip` -- the fuel recursion whose case
--       split is `prime-alt`, so no valuation function and no decidable
--       divisibility enters here (the technique the brief asked to be
--       reused rather than reinvented).
--
--   (C) `leastNonDivisor-isPrimePower` -- the full form, which turned out
--       to be reachable after all:
--
--         q > 1 a least non-divisor of L  ⟹  q = p^a, p prime, a ≥ 1.
--
--       The missing ingredient was the EXISTENCE of a prime divisor of an
--       arbitrary n > 1.  That needs `Dec (d ∣ n)`, which cubical v0.5
--       does not provide -- but it is derivable in ten lines from
--       `Cubical.Data.Nat.Mod` (`≡remainder+quotient` one way,
--       `zero-charac-gen` the other), and `dec∣` below does so.  With it,
--       a bounded search (`searchDiv`) plus a fuel recursion
--       (`primeDivisor`) give the prime divisor, and the argument closes:
--       strip q at p, and if the p-free cofactor u exceeded 1 it would
--       carry a second prime r ≠ p, hence a coprime splitting of q,
--       contradicting WalkForcing.  So u = 1 and q = p^e.
--
--   Also recorded: `leastNonDivisor-prime-divisors-agree` (any two prime
--   divisors of a least non-divisor are equal -- the weaker statement
--   that needs no prime-divisor existence) and
--   `two-primes→¬prime-power` (two distinct prime divisors really do
--   refute prime-power-ness, so form (A)'s hypothesis is exactly the
--   negation of form (C)'s).
--
--   NON-VACUITY.  Both theorems are fired on inhabited hypotheses, not
--   left as implications: `split-6` splits 6 = 2·3 (hence
--   `6-not-least-non-divisor`: the walk never installs 6), and
--   `lnd-4 : LeastNonDivisor 6 4` — 4 really is the least non-divisor of
--   lcm(1,2,3) = 6, the walk's third install — is pushed through form (C)
--   to give `4-is-prime-power`.
--
-- WHAT REMAINS OPEN -- ORIGINAL WORDING (2026-08-13), WITH THE
-- 2026-08-15 AUDIT UNDERNEATH EACH ITEM.  The first item is closed; the
-- other two are not.  Nothing is deleted: the confession is the record
-- of what the closure cost.
--
--   * The other direction of §(c), (⇐), is NaturalMachine.WalkJumps
--     (`prime-power-not-covered`), already checked.  Together with this
--     file, §(c) is now closed in both directions -- but note the two
--     halves are phrased against different objects: WalkJumps works with
--     `IsLCM (range1 n)` and this file with `LeastNonDivisor`, and the
--     bridge between them (that the walk's least non-divisor of cap(k) is
--     the frontier's jump point) is §(b) of the note, which is still not
--     formalised.  Composing the two into the single statement "the
--     installs are exactly the prime powers in increasing order" requires
--     that bridge.
--
--     CLOSED, 2026-08-14.  The bridge is NaturalMachine.WalkBridge:
--     `cap` is flat across the interval the walk skips, so the install
--     event IS the jump point and no jump point is passed over; the same
--     file makes the step total as `next : ℕ → ℕ`.  The composition this
--     paragraph asks for -- "the installs are exactly the prime powers,
--     in increasing order" -- is NaturalMachine.WalkPrimePowers
--     (`installs-are-prime-powers`, `prime-powers-are-installed`,
--     with `WalkBridge.install-mono` for the ordering).  Worth recording
--     against this paragraph's expectation: the (⇒) half of the
--     composition does NOT use the bridge at all -- it is this file's
--     `leastNonDivisor-isPrimePower` applied to `WalkBridge.next-lnd`.
--     Only the (⇐) half needs §(b), and it needs one genuinely new
--     induction (`WalkPrimePowers.locate`) on top of it.
--
--   * No decision procedure for PRIMALITY is provided; `dec∣` decides
--     divisibility only.  `primeDivisor` produces a prime together with
--     its primality proof, which is all that is needed here.
--
--     STILL TRUE, 2026-08-15.  There is still no `Dec (IsPrime n)` in
--     NaturalMachine/.  What was added since is
--     `NaturalMachine.WalkFast.decIsPrimePower : (n : ℕ) →
--     Dec (IsPrimePower n)`, built from this file's `primeDivisor` and
--     `WalkJumps.strip` and refuting the two-prime case by this file's
--     `two-primes→¬prime-power`.  So prime-POWER-hood is now decidable
--     at size n; primality itself is not decided anywhere.
--
--     CLOSED, 2026-08-18: primality IS now decided, by
--     `NaturalMachine.PrimalityDecision.decIsPrime`, and it is built from
--     THIS file -- `searchDiv` at bound n-1 plus `noDiv→prime` -- with no
--     new number theory.
--
--   * `searchDiv` and `primeDivisor` are linear searches with fuel; they
--     are proofs, not algorithms, and nothing here claims otherwise.
--
--     STILL TRUE, 2026-08-15, and now load-bearing rather than merely
--     honest: `decIsPrimePower` inherits the linear fuel search, so the
--     walk's speedup (WalkFast) is "size of the answer instead of size
--     of cap m", not "polynomial".
--
-- CHECKED: Agda 2.6.3, cubical v0.5, --cubical --safe, 2026-08-13.
-- No postulates, no holes.
--
-- HEADER REVISED 2026-08-15 (comment only; no code changed).  Re-checked
-- EXIT=0 after the edit under Agda 2.6.3 + the /tmp/cubical checkout
-- (`cubical-0.7`), which is NOT the repository pin (BUILD.md); that run
-- verifies the comment parses, not the pin.

module NaturalMachine.CoprimeSplitting where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.Nat.GCD
open import Cubical.Data.Nat.Mod
open import Cubical.Data.Sigma
open import Cubical.Data.Sum
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_; Dec; yes; no)

open import NaturalMachine.WalkForcing
  using (ProperCoprimeSplit; LeastNonDivisor;
         leastNonDivisor-no-coprime-split)
open import NaturalMachine.WalkJumps
  using (IsPrime; prime-0<; prime-¬∣1; prime-alt; coprime-cancel;
         prime-∣-·; Strip; strip; ^-pos; 0<→≢0; isPrime2; isPrime3)

------------------------------------------------------------------------
-- Coprimality lemmas (gcd-side throughout; no Bezout, no valuations)
------------------------------------------------------------------------

-- coprimality restricts along divisors of the second argument
coprime-∣ʳ : (a c d : ℕ) → isGCD a c 1 → d ∣ c → isGCD a d 1
coprime-∣ʳ a c d g d∣c =
  (∣-oneˡ a , ∣-oneˡ d) , least
  where
  least : (d' : ℕ) → isCD a d d' → d' ∣ 1
  least d' cd = g .snd d' (cd .fst , ∣-trans (cd .snd) d∣c)

-- coprimality is multiplicative in the first argument.  Proof: a common
-- divisor d of a·b and c is coprime to a (because it divides c), hence
-- divides b by `coprime-cancel`; but it is coprime to b too, so d ∣ 1.
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

-- hence a power of p is coprime to whatever p is coprime to
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
-- THE THEOREM, form (A): two distinct prime divisors force a proper
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

  -- p divides the p-part: it divides n = p^e · u, but not u
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
-- Composed with WalkForcing: prime divisors of an install coincide
------------------------------------------------------------------------

-- A least non-divisor has AT MOST ONE prime divisor.  WalkForcing says
-- such a q admits no proper coprime splitting; the theorem above says
-- two distinct prime divisors would produce one.
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
-- Prime powers, and the cheap half of form (C)
------------------------------------------------------------------------

IsPrimePower : ℕ → Type
IsPrimePower n =
  Σ[ p ∈ ℕ ] Σ[ a ∈ ℕ ] (IsPrime p × (0 < a) × ((p ^ a) ≡ n))

two-primes→¬prime-power :
  (n p r : ℕ) → IsPrime p → IsPrime r → ¬ (p ≡ r) →
  p ∣ n → r ∣ n → ¬ (IsPrimePower n)
two-primes→¬prime-power n p r pp pr p≢r p∣n r∣n (s , a , ps , _ , sa≡n) =
  p≢r (p≡s ∙ sym r≡s)
  where
  p≡s : p ≡ s
  p≡s = prime-∣-prime p s pp ps
          (prime-∣-^ p s a pp (subst (p ∣_) (sym sa≡n) p∣n))

  r≡s : r ≡ s
  r≡s = prime-∣-prime r s pr ps
          (prime-∣-^ r s a pr (subst (r ∣_) (sym sa≡n) r∣n))

------------------------------------------------------------------------
-- Decidable divisibility (absent from cubical v0.5, derivable from Mod)
------------------------------------------------------------------------

-- `Cubical.Data.Nat.Divisibility` defines _∣_ as a propositional
-- truncation and supplies no decision procedure; `Cubical.Data.Nat.Mod`
-- supplies the two halves of the specification of _mod_ needed to build
-- one.  This is the only place in the file where divisibility is decided,
-- and it is needed only to FIND a prime divisor: everything downstream of
-- a given prime uses `prime-alt` instead.
∣-from-mod : (d n : ℕ) → (n mod (suc d)) ≡ 0 → (suc d) ∣ n
∣-from-mod d n r≡0 = subst ((suc d) ∣_) qeq (∣-left (quotient n / suc d))
  where
  qeq : (suc d) · (quotient n / suc d) ≡ n
  qeq = cong (_+ ((suc d) · (quotient n / suc d))) (sym r≡0)
       ∙ ≡remainder+quotient (suc d) n

mod-from-∣ : (d n : ℕ) → (suc d) ∣ n → (n mod (suc d)) ≡ 0
mod-from-∣ d n h =
  cong (_mod (suc d)) (sym (∣-untrunc h .snd))
  ∙ zero-charac-gen (suc d) (∣-untrunc h .fst)

dec∣ : (d n : ℕ) → 0 < d → Dec (d ∣ n)
dec∣ zero    n 0<d = Empty.rec (¬-<-zero 0<d)
dec∣ (suc d) n _   with discreteℕ (n mod (suc d)) 0
... | yes r≡0 = yes (∣-from-mod d n r≡0)
... | no  r≢0 = no (λ h → r≢0 (mod-from-∣ d n h))

------------------------------------------------------------------------
-- Existence of a prime divisor
------------------------------------------------------------------------

DivBelow : ℕ → ℕ → Type
DivBelow n k = Σ[ d ∈ ℕ ] ((1 < d) × (d ≤ k) × (d ∣ n))

NoDivBelow : ℕ → ℕ → Type
NoDivBelow n k = (d : ℕ) → 1 < d → d ≤ k → ¬ (d ∣ n)

extendNoDiv : (n k : ℕ) → NoDivBelow n k → ¬ ((suc k) ∣ n) → NoDivBelow n (suc k)
extendNoDiv n k none ¬sk d 1<d d≤sk d∣n with ≤-split d≤sk
... | inl d<sk = none d 1<d (pred-≤-pred d<sk) d∣n
... | inr d≡sk = ¬sk (subst (_∣ n) d≡sk d∣n)

-- bounded search for a nontrivial divisor ≤ k
searchDiv : (n k : ℕ) → DivBelow n k ⊎ NoDivBelow n k
searchDiv n zero =
  inr (λ d 1<d d≤0 → Empty.rec (¬-<-zero (<≤-trans 1<d d≤0)))
searchDiv n (suc zero) =
  inr (λ d 1<d d≤1 → Empty.rec (¬m<m (<≤-trans 1<d d≤1)))
searchDiv n (suc (suc k)) with searchDiv n (suc k)
... | inl (d , 1<d , d≤sk , d∣n) = inl (d , 1<d , ≤-suc d≤sk , d∣n)
... | inr none with dec∣ (suc (suc k)) n (suc-≤-suc zero-≤)
...   | yes h = inl (suc (suc k) , suc-≤-suc (suc-≤-suc zero-≤) , ≤-refl , h)
...   | no ¬h = inr (extendNoDiv n (suc k) none ¬h)

-- no nontrivial divisor below n makes n prime
noDiv→prime : (m : ℕ) → 1 < suc m → NoDivBelow (suc m) m → IsPrime (suc m)
noDiv→prime m 1<sm none = 1<sm , divs
  where
  small : (d : ℕ) → d ∣ suc m → d ≤ m → d ≡ 1
  small d d∣sm d≤m with splitℕ-≤ 2 d
  ... | inl 2≤d = Empty.rec (none d 2≤d d≤m d∣sm)
  ... | inr d<2 = ≤-antisym (pred-≤-pred d<2) (m∣sn→z<m d∣sm)

  divs : (d : ℕ) → d ∣ suc m → (d ≡ 1) ⊎ (d ≡ suc m)
  divs d d∣sm with ≤-split (m∣sn→m≤sn d∣sm)
  ... | inl d<sm = inl (small d d∣sm (pred-≤-pred d<sm))
  ... | inr d≡sm = inr d≡sm

primeDivisor-fuel :
  (fuel n : ℕ) → 1 < n → n ≤ fuel → Σ[ p ∈ ℕ ] (IsPrime p × (p ∣ n))
primeDivisor-fuel zero    n       1<n n≤f =
  Empty.rec (¬-<-zero (<≤-trans 1<n n≤f))
primeDivisor-fuel (suc f) zero    1<n n≤f = Empty.rec (¬-<-zero 1<n)
primeDivisor-fuel (suc f) (suc m) 1<n n≤f with searchDiv (suc m) m
... | inr none = suc m , noDiv→prime m 1<n none , ∣-refl refl
... | inl (d , 1<d , d≤m , d∣sm) =
      recur .fst , recur .snd .fst , ∣-trans (recur .snd .snd) d∣sm
  where
  recur : Σ[ p ∈ ℕ ] (IsPrime p × (p ∣ d))
  recur = primeDivisor-fuel f d 1<d (≤-trans d≤m (pred-≤-pred n≤f))

-- EVERY n > 1 HAS A PRIME DIVISOR.
primeDivisor : (n : ℕ) → 1 < n → Σ[ p ∈ ℕ ] (IsPrime p × (p ∣ n))
primeDivisor n 1<n = primeDivisor-fuel n n 1<n ≤-refl

------------------------------------------------------------------------
-- THE THEOREM, form (C): a least non-divisor IS a prime power
------------------------------------------------------------------------

^-exp-pos : (p e q : ℕ) → 1 < q → (p ^ e) ≡ q → 0 < e
^-exp-pos p zero    q 1<q pe≡q = Empty.rec (¬m<m (subst (1 <_) (sym pe≡q) 1<q))
^-exp-pos p (suc e) q 1<q pe≡q = suc-≤-suc zero-≤

-- Direction (⇒) of WALK_INSTALLS_ARE_JUMPS §(c), in full.  Take a prime
-- divisor p of q and strip q at p, q = p^e · u with p ∤ u.  If u were
-- > 1 it would have a prime divisor r, necessarily ≠ p, and then q would
-- have two distinct prime divisors, hence a proper coprime splitting —
-- which WalkForcing forbids.  So u = 1 and q = p^e.
leastNonDivisor-isPrimePower :
  (L q : ℕ) → 1 < q → LeastNonDivisor L q → IsPrimePower q
leastNonDivisor-isPrimePower L q 1<q lnd =
  p , e , pp , ^-exp-pos p e q 1<q pe≡q , pe≡q
  where
  0<q : 0 < q
  0<q = <-trans (suc-≤-suc zero-≤) 1<q

  pd : Σ[ p ∈ ℕ ] (IsPrime p × (p ∣ q))
  pd = primeDivisor q 1<q

  p    = pd .fst
  pp   = pd .snd .fst
  p∣q  = pd .snd .snd

  st : Strip p q
  st = strip p pp q q 0<q ≤-refl

  e     = st .fst
  u     = st .snd .fst
  0<u   = st .snd .snd .fst

  peu : ((p ^ e) · u) ≡ q
  peu = st .snd .snd .snd .fst

  ¬p∣u : ¬ (p ∣ u)
  ¬p∣u = st .snd .snd .snd .snd

  u∣q : u ∣ q
  u∣q = subst (u ∣_) peu (∣-right (p ^ e))

  -- if u > 1 it carries a second prime, and q splits
  u≡1 : u ≡ 1
  u≡1 with discreteℕ u 1
  ... | yes h = h
  ... | no  h =
        Empty.rec (leastNonDivisor-no-coprime-split L q lnd
          (two-primes→coprime-split q p r 0<q pp pr p≢r p∣q
            (∣-trans r∣u u∣q)))
    where
    rd : Σ[ p' ∈ ℕ ] (IsPrime p' × (p' ∣ u))
    rd = primeDivisor u (pos-≢1→1< u 0<u h)

    r    = rd .fst
    pr   = rd .snd .fst
    r∣u  = rd .snd .snd

    p≢r : ¬ (p ≡ r)
    p≢r p≡r = ¬p∣u (subst (_∣ u) (sym p≡r) r∣u)

  pe≡q : (p ^ e) ≡ q
  pe≡q = sym (·-identityʳ (p ^ e))
         ∙ sym (cong ((p ^ e) ·_) u≡1)
         ∙ peu

------------------------------------------------------------------------
-- The theorems fired on concrete numbers
------------------------------------------------------------------------

2≢3 : ¬ (2 ≡ 3)
2≢3 e = znots (injSuc (injSuc e))

0<6 : 0 < 6
0<6 = suc-≤-suc zero-≤

-- 6 = 2 · 3 splits properly and coprimely.
split-6 : ProperCoprimeSplit 6
split-6 =
  two-primes→coprime-split 6 2 3 0<6 isPrime2 isPrime3 2≢3
    (∣-left 3) (∣-right 2)

-- …hence 6 is never a least non-divisor: the walk never installs it.
6-not-least-non-divisor : (L : ℕ) → ¬ (LeastNonDivisor L 6)
6-not-least-non-divisor L lnd =
  leastNonDivisor-no-coprime-split L 6 lnd split-6

-- …and 6 is not a prime power, by the form-(C) corollary.
6-not-prime-power : ¬ (IsPrimePower 6)
6-not-prime-power =
  two-primes→¬prime-power 6 2 3 isPrime2 isPrime3 2≢3 (∣-left 3) (∣-right 2)

------------------------------------------------------------------------
-- NON-VACUITY: a real LeastNonDivisor, pushed through the main theorem
------------------------------------------------------------------------

-- Everything above is stated under hypotheses; nothing so far exhibits a
-- LeastNonDivisor at all.  Here is one — 4 is the least non-divisor of
-- lcm(1,2,3) = 6, the walk's third install — and the form-(C) theorem
-- applied to it, so the implication is fired on an inhabited hypothesis.

¬4∣6 : ¬ (4 ∣ 6)
¬4∣6 h = go (∣-untrunc h)
  where
  go : Σ[ c ∈ ℕ ] ((c · 4) ≡ 6) → ⊥
  go (zero          , e) = znots e
  go (suc zero      , e) = znots (injSuc (injSuc (injSuc (injSuc e))))
  go (suc (suc c)   , e) =
    snotz (injSuc (injSuc (injSuc (injSuc (injSuc (injSuc e))))))

below-4 : (r : ℕ) → 2 ≤ r → r < 4 → r ∣ 6
below-4 zero                      2≤r r<4 = Empty.rec (¬-<-zero 2≤r)
below-4 (suc zero)                2≤r r<4 = Empty.rec (¬m<m 2≤r)
below-4 (suc (suc zero))          2≤r r<4 = ∣-left 3
below-4 (suc (suc (suc zero)))    2≤r r<4 = ∣-right 2
below-4 (suc (suc (suc (suc r)))) 2≤r r<4 =
  Empty.rec (¬-<-zero
    (pred-≤-pred (pred-≤-pred (pred-≤-pred (pred-≤-pred r<4)))))

lnd-4 : LeastNonDivisor 6 4
lnd-4 = ¬4∣6 , below-4

1<4 : 1 < 4
1<4 = suc-≤-suc (suc-≤-suc zero-≤)

-- 4 IS a prime power (and the proof term is the one the theorem builds:
-- prime divisor 2, strip, cofactor 1).
4-is-prime-power : IsPrimePower 4
4-is-prime-power = leastNonDivisor-isPrimePower 6 4 1<4 lnd-4
