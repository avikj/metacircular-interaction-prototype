{-# OPTIONS --cubical --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- WalkFast
--
-- THE THEOREM REPLACES THE COMPUTATION.  This is CLAUDE.md's central
-- rule applied to the walk's own execution, and it is the first place in
-- this lane where a proved theorem buys a superexponential speedup
-- rather than merely recording one.
--
-- `WalkBridge` makes the walk's step a total function
--
--     next m = least q ≥ 2 with q ∤ cap m ,          cap m = lcm(1..m),
--
-- and it RUNS: next 1..5 = 2,3,4,5,7 by refl.  Then it stops.  `next 7`
-- costs 86 s and `next 8` exhausts a 3.5 GB heap, for a derived reason —
-- the search decides `s ∣ cap m` per candidate, a unary divisibility
-- test on cap m costs Θ(cap m), and cap m = e^{ψ(m)}.  The walk's
-- storage law is its naive runtime law.
--
-- But `WalkPrimePowers` proved that the installs are exactly the prime
-- powers in increasing order.  So the expensive predicate
--
--     q ∤ cap m          (an object of size e^{ψ(m)})
--
-- can be traded for the cheap one
--
--     q is a prime power (an object of size m)
--
-- and `next-characterised` below is the exchange rate: to know `next m`,
-- exhibit a prime power q > m and refute prime-power-hood for the finitely
-- many r strictly between.  Both halves are decidable at size ~q by
-- `decIsPrimePower`, built here from `primeDivisor` and `strip`.
--
-- WHAT IS AND IS NOT DELIVERED HERE, stated before the theorems rather
-- than discovered by a later auditor.
--
-- DELIVERED: `next-characterised`, `decIsPrimePower`, and the decision
-- procedure's own non-vacuity (`test-9 : IsPrimePower 9`, obtained by
-- the kernel evaluating `decIsPrimePower 9`).  Whole file, EXIT=0, 3 s.
--
-- ALSO DELIVERED, AS OF 2026-08-15, BUT NOT IN THIS FILE: the payoff
-- instances.  `WalkFastInstance` typechecks
--
--     next-8  : next 8  ≡ 9
--     next-9  : next 9  ≡ 11
--     next-10 : next 10 ≡ 11
--
-- whole module ~3 s, EXIT=0, --safe, no postulate and no hole, with
-- `cap m` never evaluated.  The exchange rate has therefore been MADE,
-- not merely proved.  The paragraph this replaced said the opposite and
-- is preserved verbatim under HISTORY below; do not quote it as the
-- state of the lane.
--
-- AND THE SUSPECT THIS HEADER NAMED WAS INNOCENT.  The correction is
-- not "the `with` was fixed" — it is that the `with` was never the
-- cause.  `WalkFastInstance` carries the bisection log with its
-- controls, and two rows of it settle the question: applying
-- `next-characterised` itself, `with`-abstraction and all, at m = 8
-- exhausts the heap in 17 s; replacing the `with` by an antisymmetry
-- argument whose own case split is on VARIABLES fails identically, in
-- the same 17 s.  Both are rescued by the same change, a `let` with no
-- type signature.
--
-- WHAT ACTUALLY FORCES THE EVALUATION is in the conversion checker.
-- The goal type `next 8 ≡ 9` contains one occurrence of `next 8`;
-- instantiating any lemma of this file at m := 8 contributes a SECOND,
-- independently elaborated occurrence, and putting the two side by side
-- runs the walk on cap 8.  A metavariable is solved by assignment and
-- never by reduction, so handing the proof the goal's OWN `next 8` is
-- free; building a second one costs 3.5 GB.  Hence `WalkFastInstance`
-- packages everything the walk knows into one value, binds it with a
-- signature-free `let` (a signature is itself a second elaboration of
-- `next 8`, and loses), and lets the goal supply `next m` as a meta.
--
-- CONSEQUENCE FOR THIS FILE, and it is a real one.
-- `next-characterised` below is cheap to PROVE, because m is a
-- variable, and useless to APPLY at a numeral, because its conclusion
-- `next m ≡ q` writes `next m` a second time.  It is kept because it is
-- the statement the surrounding notes quote; the applicable form is
-- `WalkFastInstance.conclude`, which takes the walk's answer as a plain
-- variable `n`.  Anyone building a further instance should start there
-- and not here.
--
-- CHECKED: Agda 2.6.3, cubical v0.5, --cubical --safe, 2026-08-14.
-- No postulates, no holes.  EXIT=0 for this file and for the aggregate
-- `agda`, which imports it.
--
-- HEADER REVISED 2026-08-15 (comment only; not one line of code below
-- was touched).  Re-typechecked after the edit: EXIT=0 in 2.3 s, and
-- `WalkFastInstance` EXIT=0 in 3.1 s — but under Agda 2.6.3 with the
-- cubical checkout at /tmp/cubical (`cubical-0.7`), which is NOT the
-- repository pin (Agda 2.8.0 + cubical v0.9, see BUILD.md).  Treat that
-- as a syntax-and-scope check of the comment, not as a pin result; the
-- pin figures for `WalkFastInstance` (15 s wall, peak RSS 333-388 MB)
-- are recorded in its own header.
--
-- ------------------------------------------------------------------
-- HISTORY.  Kept rather than deleted, per this lane's convention — cf.
-- the retracted first-revision header preserved at the foot of
-- `WalkFastInstance`.  Until 2026-08-15 this section read:
--
-- > NOT DELIVERED: the payoff instances.  `next-8 : next 8 ≡ 9` — built
-- > exactly as the exchange rate prescribes, with every ingredient
-- > individually cheap (`decIsPrimePower 9` evaluates in 3 s; the
-- > interval is empty; the order proofs are `refl`) — nevertheless
-- > exhausts a 3.5 GB heap after 5 minutes.  So SOMETHING still forces
-- > `next 8`, and I do not yet know what; the obvious suspect is the
-- > `with`-abstraction on `q ≟ next m` inside `next-characterised`.
-- >
-- > That gap is left open and named rather than papered over.  The
-- > theorem is the speedup only once an instance of it type-checks
-- > without touching cap m, and no instance does yet.  Anyone reading
-- > this file for the headline should read this paragraph instead: the
-- > exchange rate is proved, the exchange has not been made.
--
-- The measurement in that paragraph was right; the diagnosis attached
-- to it was wrong.  "SOMETHING still forces `next 8`" was the correct
-- question, and the answer is: a second elaboration of `next 8`.
-- ------------------------------------------------------------------
------------------------------------------------------------------------

module WalkFast where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Divisibility
open import Cubical.Data.Sigma
open import Cubical.Data.Unit
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no)

open import WalkUnconditional using (cap)
open import WalkJumps
  using (IsPrime ; prime-0< ; prime-¬∣1 ; Strip ; strip)
open import CoprimeSplitting
  using ( IsPrimePower ; leastNonDivisor-isPrimePower
        ; primeDivisor ; two-primes→¬prime-power )
open import WalkBridge
  using (next ; next-2≤ ; next-lnd ; walk-step ; Jump)
open import WalkPrimePowers
  using (prime-power-is-jump ; pos-form ; ^-pos)

------------------------------------------------------------------------
-- 1.  `next m` is the least prime power above m.
------------------------------------------------------------------------

-- every install is a prime power: §(c)(⇒) applied to the step's own
-- certificate.  No ordering theorem is used.
next-isPP : (m : ℕ) → IsPrimePower (next m)
next-isPP m =
  leastNonDivisor-isPrimePower (cap m) (next m) (next-2≤ m) (next-lnd m)

module _ (m : ℕ) (1≤m : 1 ≤ m) where
  private
    W = walk-step m 1≤m

    j : ℕ
    j = W .fst

    next≡ : next m ≡ suc j
    next≡ = W .snd .fst

    m≤j : m ≤ j
    m≤j = W .snd .snd .fst

    skip : (i : ℕ) → m ≤ i → i < j → ¬ Jump i
    skip = W .snd .snd .snd .snd .snd

  next-> : m < next m
  next-> = subst (m <_) (sym next≡) (suc-≤-suc m≤j)

  -- nothing strictly between m and next m is a prime power
  next-least : (q : ℕ) → m < q → q < next m → ¬ IsPrimePower q
  next-least q m<q q<n ipp =
    skip i m≤i i<j (prime-power-is-jump i (subst IsPrimePower q≡si ipp))
    where
    pf : Σ[ i ∈ ℕ ] q ≡ suc i
    pf = pos-form q (<-weaken (≤<-trans 1≤m m<q))

    i : ℕ
    i = pf .fst

    q≡si : q ≡ suc i
    q≡si = pf .snd

    m≤i : m ≤ i
    m≤i = pred-≤-pred (subst (m <_) q≡si m<q)

    i<j : i < j
    i<j = pred-≤-pred (subst2 _<_ q≡si next≡ q<n)

-- THE EXCHANGE RATE.  To pin down `next m` you never touch cap m: you
-- exhibit a prime power beyond m and refute the finitely many numbers in
-- between.  Everything here has size ~q; cap m has size e^{ψ(m)}.
next-characterised :
  (m q : ℕ) → 1 ≤ m →
  IsPrimePower q → m < q →
  ((r : ℕ) → m < r → r < q → ¬ IsPrimePower r) →
  next m ≡ q
next-characterised m q 1≤m ippq m<q none with q ≟ next m
... | eq e    = sym e
... | lt q<n  = Empty.rec (next-least m 1≤m q m<q q<n ippq)
... | gt n<q  = Empty.rec (none (next m) (next-> m 1≤m) n<q (next-isPP m))

------------------------------------------------------------------------
-- 2.  Prime-power-hood is decidable, at size n.
--
--  n ≥ 2:  take a prime divisor p (bounded search), strip n at p to get
--          n = p^e · u with p ∤ u.  Then n is a prime power iff u = 1;
--          if u > 1 it has a prime divisor r ≠ p, and two distinct
--          primes divide n, which CoprimeSplitting already refutes.
------------------------------------------------------------------------

decPP≥2 : (n : ℕ) → 1 < n → Dec (IsPrimePower n)
decPP≥2 n 1<n = go (primeDivisor n 1<n)
  where
  0<n : 0 < n
  0<n = <-weaken 1<n

  go : Σ[ p ∈ ℕ ] (IsPrime p × (p ∣ n)) → Dec (IsPrimePower n)
  go (p , pp , p∣n) = go2 (strip p pp n n 0<n ≤-refl)
    where
    -- the two branches, taken as an argument rather than by `with`:
    -- u = 1 makes n = p^(e+1); u > 1 supplies a second prime.
    go3 : (e u : ℕ) → 0 < u → ((p ^ suc e) · u) ≡ n → ¬ (p ∣ u)
        → ((2 ≤ u) ⊎ (u < 2)) → Dec (IsPrimePower n)
    go3 e u 0<u peu ¬p∣u (inr u<2) =
      yes (p , suc e , pp , suc-≤-suc zero-≤ , pe≡n)
      where
      u≡1 : u ≡ 1
      u≡1 = ≤-antisym (pred-≤-pred u<2) 0<u

      pe≡n : (p ^ suc e) ≡ n
      pe≡n = sym (·-identityʳ (p ^ suc e))
           ∙ cong ((p ^ suc e) ·_) (sym u≡1)
           ∙ peu
    go3 e u 0<u peu ¬p∣u (inl 2≤u) =
      no (two-primes→¬prime-power n p r pp pr p≢r p∣n r∣n)
      where
      pd : Σ[ r ∈ ℕ ] (IsPrime r × (r ∣ u))
      pd = primeDivisor u 2≤u

      r : ℕ
      r = pd .fst

      pr : IsPrime r
      pr = pd .snd .fst

      r∣u : r ∣ u
      r∣u = pd .snd .snd

      u∣n : u ∣ n
      u∣n = subst (u ∣_) peu (∣-right (p ^ suc e))

      r∣n : r ∣ n
      r∣n = ∣-trans r∣u u∣n

      p≢r : ¬ (p ≡ r)
      p≢r e' = ¬p∣u (subst (_∣ u) (sym e') r∣u)

    -- e = 0 means n = u and p ∤ u, contradicting p ∣ n
    go2 : Strip p n → Dec (IsPrimePower n)
    go2 (zero , u , 0<u , peu , ¬p∣u) =
      Empty.rec (¬p∣u (subst (p ∣_) (sym (sym (·-identityˡ u) ∙ peu)) p∣n))
    go2 (suc e , u , 0<u , peu , ¬p∣u) =
      go3 e u 0<u peu ¬p∣u (splitℕ-≤ 2 u)

decIsPrimePower : (n : ℕ) → Dec (IsPrimePower n)
decIsPrimePower zero = no bad
  where
  bad : ¬ IsPrimePower 0
  bad (p , a , pp , 0<a , pa≡0) =
    ¬-<-zero (subst (0 <_) pa≡0 (^-pos p a (prime-0< p pp)))
decIsPrimePower (suc zero) = no bad
  where
  bad : ¬ IsPrimePower 1
  bad (p , a , pp , 0<a , pa≡1) =
    prime-¬∣1 p pp (subst (p ∣_) pa≡1 p∣pa)
    where
    pf : Σ[ b ∈ ℕ ] a ≡ suc b
    pf = pos-form a 0<a

    p∣pa : p ∣ (p ^ a)
    p∣pa = subst (λ x → p ∣ (p ^ x)) (sym (pf .snd)) (∣-left (p ^ (pf .fst)))
decIsPrimePower (suc (suc m)) =
  decPP≥2 (suc (suc m)) (suc-≤-suc (suc-≤-suc zero-≤))

------------------------------------------------------------------------
-- 3.  Turning a decision into a proof or a refutation BY COMPUTATION.
--     `refuteDec (decIsPrimePower 33) tt` type-checks exactly when the
--     kernel evaluates the decision to `no`; the `tt` is the evaluation.
------------------------------------------------------------------------

IsYes IsNo : {A : Type₀} → Dec A → Type₀
IsYes (yes _) = Unit
IsYes (no  _) = ⊥
IsNo  (yes _) = ⊥
IsNo  (no  _) = Unit

acceptDec : {A : Type₀} (d : Dec A) → IsYes d → A
acceptDec (yes p) _ = p
acceptDec (no  _) e = Empty.rec e

refuteDec : {A : Type₀} (d : Dec A) → IsNo d → ¬ A
refuteDec (yes _) e = Empty.rec e
refuteDec (no ¬p) _ = ¬p

-- the finitely many numbers strictly between m and suc (m + d)
noneIn : (m d : ℕ) →
         ((i : ℕ) → i < d → ¬ IsPrimePower (suc (m + i))) →
         (r : ℕ) → m < r → r < suc (m + d) → ¬ IsPrimePower r
noneIn m d h r m<r r<b = subst (λ z → ¬ IsPrimePower z) (sym r≡) (h t t<d)
  where
  t : ℕ
  t = m<r .fst

  r≡ : r ≡ suc (m + t)
  r≡ = sym (m<r .snd) ∙ +-suc t m ∙ cong suc (+-comm t m)

  t<d : t < d
  t<d = <-k+-cancel (pred-≤-pred (subst (_< suc (m + d)) r≡ r<b))


test-9 : IsPrimePower 9
test-9 = acceptDec (decIsPrimePower 9) tt
