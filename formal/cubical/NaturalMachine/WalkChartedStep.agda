{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.WalkChartedStep
--
-- THE SEARCH, IN THE CHART.  Two modules of this lane name the same
-- remaining gap in their own headers.  `WalkResidueBridge`:
--
--     "`cap` is still a ℕ.  Nothing here builds lcm's in the chart, so
--      `WalkBridge.next` is unchanged."
--
-- and `WalkChartedCap`, which removed that half and then listed what a
-- fast walk step still needs:
--
--     "(a) `findND` re-typed against `Word`, using `WalkResidueBridge`'s
--      `decDivides` in place of `dec∣` -- the mathematics is done, the
--      rewrite is not."
--
-- (a) is what this file is.  The two halves it stands on are already
-- proved: `WalkResidueBridge.decDividesℕ-agrees` says the charted
-- divisibility test IS `dec∣`'s decision (`Dec` of a proposition is a
-- proposition), so it substitutes without disturbing a downstream proof;
-- `WalkChartedCap.value-capw` says the charted capacity IS the capacity.
-- What was missing is the search between them: a `findND` that consumes
-- the capacity as a `Word` and never converts it back.
--
-- WHAT IS DELIVERED.
--
--   1. `decDvd` -- `WalkResidueBridge.decDivides` re-indexed by the
--      candidate itself rather than by its predecessor, so that the
--      search may case on it with no transport in the computed path;
--      and `decDvd-agrees`, that this is `dec∣`'s decision, verbatim
--      `decDividesℕ-agrees`'s argument (`isPropDec isProp∣`).
--
--   2. `findNDw` -- `WalkBridge.findND` with `L : ℕ` replaced by
--      `w : Word` and `dec∣` replaced by `decDvd`.  Specification
--      unchanged: it returns the least q ≥ 2 with q ∤ value w, as a
--      `LeastNonDivisor (value w) q`.  `leastNDw` supplies the bound.
--
--   3. `nextw : ℕ → ℕ`, the walk's step computed through `capw`, and
--
--        nextw≡next : (m : ℕ) → nextw m ≡ next m
--
--      for EVERY m, with no side hypothesis.  It is not proved by
--      matching the two searches clause for clause; it is proved from
--      the SPECIFICATION both searches satisfy, because a least
--      non-divisor is unique (`lnd-unique`, three lines of trichotomy).
--      `value-capw` moves the specification from `value (capw m)` to
--      `cap m`, and uniqueness closes it against `WalkBridge.next-lnd`.
--      So no theorem of the walk is re-derived here, and none is
--      disturbed: `nextw` inherits `walk-step`, §(b), the install stream
--      and everything downstream by rewriting along `nextw≡next`.
--
--   4. THE BOUND THAT MAKES THE SEARCH TOTAL, and the one place this
--      file deviates from `WalkBridge`.  `WalkBridge.leastND` runs the
--      search with fuel `L'` where `L ≡ suc L'`, i.e. the never-divides
--      endpoint is `L + 1`.  Transcribed literally that would be
--      `value w + 1`, and the FUEL IS FORCED BY THE RECURSION: producing
--      it in unary is exactly the Θ(value w) materialisation of the
--      capacity this lane exists to avoid.  The endpoint used here is
--      `2 + b ^ length w`, a function of the WORD, and the never-divides
--      obligation is discharged the same way -- an endpoint strictly
--      above a positive number cannot divide it -- from
--
--        value-<-pow : (w : Word) → value w < b ^ length w
--
--      which is one induction and holds for every word, canonical or
--      not (`toℕ d < b` is all it uses).
--
--   5. THE COST CLAIM, exactly and no more.  Per candidate s ≥ 2 the
--      test is one pass of `TransportDiv.run`: the number the decision
--      inspects is that run's final state (`candidate-state`) and the
--      run's own step count is `suc (length w)`
--      (`candidate-cost`, i.e. `run-is-the-automaton`), against
--      `usteps (value w) ≡ suc (value w)` for the recursion `dec∣`
--      performs on the numeral (`candidate-cost-gap`).
--
-- WHAT IS *NOT* DELIVERED.  The walk is not fast, and nothing here says
-- it is.
--
--   * NO KERNEL WITNESS, AND NOT FOR WANT OF ASKING.  There is no
--     `nextw 8 ≡ 9` below.  `capw` runs through `WalkChartedCap`'s
--     `chartedQuot`, hence through the library's `gcd` (`euclid`'s
--     well-founded recursion) and `Cubical.Data.Fin.Properties._%_` (a
--     transport along a residue equivalence); `WalkChartedCap`'s header
--     already flags that its evaluation behaviour is a separate
--     question, and this file does not answer it either.  The measured
--     outcome of the attempt is recorded in the session report, not
--     here: a timing is not a theorem, and the theorems above are about
--     the definitions.
--
--   * NO BOUND ON `length (capw m)`.  `value-<-pow` bounds the value by
--     the length, which is the direction the fuel needs; the converse --
--     that the length is logarithmic in the value -- needs
--     `Canonical (capw m)`, which `WalkChartedCap` states it does not
--     prove for `scale`.  So `b ^ length (capw m)` is not claimed small,
--     only cheap to PEEL: the recursion consumes it one `suc` at a time
--     and stops at the first non-divisor.
--
--   * NO TOTAL-COST THEOREM FOR THE STEP.  §5 is per candidate.  The
--     number of candidates is `next m − m`, which is a fact about prime
--     powers and not about this file.
--
--   * THE PER-TRANSITION ARITHMETIC IS AN UNSTATED PARAMETER, as in
--     `TransportDiv` and `WalkChartedCap`: `run` counts transitions, and
--     the cost of one `_mod_` on numerals < s is not counted here.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (ℕ ; zero ; suc)

module NaturalMachine.WalkChartedStep (k : ℕ) where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Mod using (_mod_)
open import Cubical.Data.Nat.Divisibility
  using (_∣_ ; isProp∣ ; m∣sn→m≤sn)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; isPropDec)
open import Cubical.Data.Fin using (toℕ)

open import NaturalMachine.Digits k
open import NaturalMachine.TransportDiv k
open import NaturalMachine.WalkResidueBridge k
  using (decDivides ; usteps ; usteps-is-value)
open import NaturalMachine.WalkChartedCap using (pos-form ; module Charted)
open import NaturalMachine.WalkUnconditional using (cap)
open import NaturalMachine.WalkForcing using (LeastNonDivisor)
open import NaturalMachine.WalkBridge using (cap-pos ; next ; next-2≤ ; next-lnd)
open import NaturalMachine.CoprimeSplitting using (dec∣)

open Charted k using (capw ; value-capw)

------------------------------------------------------------------------
-- 1.  THE TEST, INDEXED BY THE CANDIDATE.
--
-- `decDivides n w : Dec (suc n ∣ value w)` is indexed by the modulus'
-- predecessor.  The search's candidate is a variable s with 2 ≤ s, so
-- the two must be reconciled.  Doing it with `subst` would put a
-- transport of a `Dec` on the path the kernel actually runs; matching
-- s as `suc (suc s')` instead makes `decDivides (suc s') w` have the
-- required type on the nose, and the two impossible shapes of s are
-- refuted from `2 ≤ s`.
------------------------------------------------------------------------

decDvd : (s : ℕ) → 2 ≤ s → (w : Word) → Dec (s ∣ value w)
decDvd zero          2≤s w = Empty.rec (¬-<-zero 2≤s)
decDvd (suc zero)    2≤s w = Empty.rec (¬-<-zero (pred-≤-pred 2≤s))
decDvd (suc (suc s)) _   w = decDivides (suc s) w

-- …and it is `dec∣`'s decision, not merely another correct one.  Same
-- argument as `WalkResidueBridge.decDividesℕ-agrees`: `_∣_` is a
-- proposition, so `Dec (s ∣ value w)` is a proposition.  This is the
-- licence to substitute the charted test for `dec∣` inside `findND`
-- without touching a downstream proof.
decDvd-agrees :
  (s : ℕ) (2≤s : 2 ≤ s) (w : Word) (0<s : 0 < s)
  → decDvd s 2≤s w ≡ dec∣ s (value w) 0<s
decDvd-agrees s 2≤s w 0<s = isPropDec isProp∣ _ _

------------------------------------------------------------------------
-- 2.  THE BOUND.  A word's value is below b ^ its length.
--
-- One induction, no canonicity: `toℕ d < b` is the only input.  This is
-- what replaces `WalkBridge.leastND`'s `L ≡ suc L'`, whose fuel is the
-- value itself.
------------------------------------------------------------------------

value-<-pow : (w : Word) → value w < b ^ length w
value-<-pow []      = ≤-refl
value-<-pow (d ∷ w) = <≤-trans below-b·suc above
  where
  below-b·suc : toℕ d + b · value w < b · suc (value w)
  below-b·suc = subst (toℕ d + b · value w <_)
                      (sym (·-suc b (value w)))
                      (<-+k (snd d))

  above : b · suc (value w) ≤ b · (b ^ length w)
  above = subst2 _≤_ (·-comm (suc (value w)) b) (·-comm (b ^ length w) b)
                  (≤-·k (value-<-pow w))

-- a divisor of a positive number is at most that number
∣→≤-pos : (d N : ℕ) → 0 < N → d ∣ N → d ≤ N
∣→≤-pos d N 0<N d∣N =
  subst (d ≤_) (sym e) (m∣sn→m≤sn (subst (d ∣_) e d∣N))
  where
  e : N ≡ suc (pos-form N 0<N .fst)
  e = pos-form N 0<N .snd

-- hence the endpoint never divides: exactly `WalkBridge`'s reason
-- (an endpoint strictly above a positive L cannot divide L), with
-- `L + 1` replaced by `2 + b ^ length w`.
pow-endpoint-∤ : (w : Word) → 0 < value w
               → ¬ ((2 + (b ^ length w)) ∣ value w)
pow-endpoint-∤ w 0<v d = ¬m<m (≤<-trans (∣→≤-pos _ _ 0<v d) big)
  where
  big : value w < 2 + (b ^ length w)
  big = <≤-trans (value-<-pow w) ≤SumRight

------------------------------------------------------------------------
-- 3.  THE SEARCH.  `WalkBridge.findND`, with `L : ℕ` replaced by
--     `w : Word` and `dec∣` replaced by `decDvd`.  Nothing else moves:
--     the two `where` clauses below are its two, verbatim.
------------------------------------------------------------------------

findNDw : (w : Word) (s n : ℕ) → 2 ≤ s →
          ((r : ℕ) → 2 ≤ r → r < s → r ∣ value w) →
          ¬ ((s + n) ∣ value w) →
          Σ[ q ∈ ℕ ] (2 ≤ q) × LeastNonDivisor (value w) q
findNDw w s zero 2≤s bel ¬b =
  s , 2≤s , (subst (λ z → ¬ (z ∣ value w)) (+-zero s) ¬b , bel)
findNDw w s (suc n) 2≤s bel ¬b with decDvd s 2≤s w
... | no  s∤w = s , 2≤s , (s∤w , bel)
... | yes s∣w = findNDw w (suc s) n (≤-suc 2≤s) bel' ¬b'
  where
  bel' : (r : ℕ) → 2 ≤ r → r < suc s → r ∣ value w
  bel' r 2≤r r<ss with ≤-split (pred-≤-pred r<ss)
  ... | inl r<s = bel r 2≤r r<s
  ... | inr r≡s = subst (_∣ value w) (sym r≡s) s∣w

  ¬b' : ¬ ((suc s + n) ∣ value w)
  ¬b' = subst (λ z → ¬ (z ∣ value w)) (+-suc s n) ¬b

leastNDw : (w : Word) → 0 < value w
         → Σ[ q ∈ ℕ ] (2 ≤ q) × LeastNonDivisor (value w) q
leastNDw w 0<v = findNDw w 2 (b ^ length w) ≤-refl vac (pow-endpoint-∤ w 0<v)
  where
  vac : (r : ℕ) → 2 ≤ r → r < 2 → r ∣ value w
  vac r 2≤r r<2 = Empty.rec (¬m<m (≤<-trans 2≤r r<2))

------------------------------------------------------------------------
-- 4.  THE CHARTED STEP.
------------------------------------------------------------------------

capw-pos : (m : ℕ) → 0 < value (capw m)
capw-pos m = subst (0 <_) (sym (value-capw m)) (cap-pos m)

nextw : ℕ → ℕ
nextw m = leastNDw (capw m) (capw-pos m) .fst

nextw-2≤ : (m : ℕ) → 2 ≤ nextw m
nextw-2≤ m = leastNDw (capw m) (capw-pos m) .snd .fst

-- the specification, moved off the chart by `value-capw` -- the only
-- place the charted capacity is identified with the capacity.
nextw-lnd : (m : ℕ) → LeastNonDivisor (cap m) (nextw m)
nextw-lnd m =
  subst (λ L → LeastNonDivisor L (nextw m)) (value-capw m)
        (leastNDw (capw m) (capw-pos m) .snd .snd)

------------------------------------------------------------------------
-- 5.  THE THEOREM.  `nextw m ≡ next m`, for every m.
--
-- Via uniqueness of the least non-divisor, so that the walk's own
-- specification is used and not re-derived: if p and q are both least
-- non-divisors of L and both ≥ 2 then neither can be below the other,
-- since the smaller would divide L by the larger's minimality while
-- failing to divide it by its own.
------------------------------------------------------------------------

lnd-unique : (L p q : ℕ) → 2 ≤ p → 2 ≤ q
           → LeastNonDivisor L p → LeastNonDivisor L q → p ≡ q
lnd-unique L p q 2≤p 2≤q lp lq with p ≟ q
... | lt p<q = Empty.rec (lp .fst (lq .snd p 2≤p p<q))
... | eq p≡q = p≡q
... | gt q<p = Empty.rec (lq .fst (lp .snd q 2≤q q<p))

nextw≡next : (m : ℕ) → nextw m ≡ next m
nextw≡next m =
  lnd-unique (cap m) (nextw m) (next m)
             (nextw-2≤ m) (next-2≤ m) (nextw-lnd m) (next-lnd m)

-- Two corollaries, recorded because they are what "substitutes without
-- disturbing a proof" means operationally: everything `WalkBridge`
-- proves of `next` transports to `nextw` along `nextw≡next`.  (Stated
-- generically rather than instance by instance -- `walk-step`, §(b), the
-- install stream all follow by `subst P (sym (nextw≡next m))`.)
nextw-transports : (P : ℕ → Type) (m : ℕ) → P (next m) → P (nextw m)
nextw-transports P m = subst P (sym (nextw≡next m))

nextw-lnd-cap : (m : ℕ) → LeastNonDivisor (cap m) (nextw m)
nextw-lnd-cap = nextw-lnd

------------------------------------------------------------------------
-- 6.  COST, per candidate.  Read this as exactly what it says.
--
-- `decDvd s 2≤s w` is `decDivides`, which decides by comparing
-- `modw s w` with 0.  `candidate-state` says that number is the final
-- state of `TransportDiv.run`, and `candidate-cost` is
-- `run-is-the-automaton`: that run takes `suc (length w)` transitions.
-- `candidate-cost-gap` puts it beside the count of the same residue
-- computed in the home presentation, which is `suc (value w)` --
-- `WalkResidueBridge.usteps-is-value`.  For w = capw m the latter is
-- suc (cap m) = e^{ψ(m)} + 1.
--
-- Nothing is measured; every line is an equality.  No claim is made
-- about the number of candidates, about `length (capw m)`, or about the
-- arithmetic inside one transition.
------------------------------------------------------------------------

candidate-state : (s : ℕ) (w : Word)
                → modw (suc (suc s)) w ≡ fst (run (suc (suc s)) w)
candidate-state s w = sym (run-state (suc (suc s)) w)

candidate-cost : (s : ℕ) (w : Word)
               → (fst (run (suc (suc s)) w) ≡ value w mod (suc (suc s)))
               × (snd (run (suc (suc s)) w) ≡ suc (length w))
candidate-cost s w = run-is-the-automaton (suc (suc s)) w

candidate-cost-gap : (s : ℕ) (w : Word)
                   → (snd (run (suc (suc s)) w) ≡ suc (length w))
                   × (usteps (value w) ≡ suc (value w))
candidate-cost-gap s w =
  run-is-the-automaton (suc (suc s)) w .snd , usteps-is-value (value w)

-- And the fuel is a function of the word, not of its value: this is the
-- statement that the search never materialises the capacity as a
-- numeral, in the only form it can be given -- the endpoint `findNDw`
-- counts down from is `2 + b ^ length w`, and `value w` occurs in
-- `leastNDw` only inside the proof `pow-endpoint-∤`, which the search
-- carries and never evaluates.
fuel-is-a-length-function : (w : Word) → ℕ
fuel-is-a-length-function w = b ^ length w

fuel-bounds-the-value : (w : Word) → value w < fuel-is-a-length-function w
fuel-bounds-the-value = value-<-pow
