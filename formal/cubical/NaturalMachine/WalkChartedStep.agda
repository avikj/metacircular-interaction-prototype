{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.WalkChartedStep
--
-- THE SEARCH, IN THE CHART.  Two modules of this lane name the same
-- remaining gap in their own headers.  `WalkResidueBridge`:
--
--     "`cap` is still a ℕ.  Nothing here builds lcm's in the chart, so
--      `WalkBridge.next` is unchanged and `next 8` still exhausts the
--      heap."
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
--      candidate itself rather than by its predecessor, so the search
--      may case on it with no transport on the computed path; and
--      `decDvd-agrees`, that this is `dec∣`'s decision, by
--      `decDividesℕ-agrees`'s own argument (`isPropDec isProp∣`).
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
--      `value-capw` moves that specification from `value (capw m)` to
--      `cap m`, and uniqueness closes it against `WalkBridge.next-lnd`.
--      So no theorem of the walk is re-derived here, and none is
--      disturbed: `nextw` inherits `walk-step`, §(b), the install stream
--      and all the rest by rewriting along `nextw≡next`
--      (`nextw-transports`).
--
--   4. THE BOUND THAT MAKES THE SEARCH TOTAL, and the one place this
--      file deviates from `WalkBridge`.  `WalkBridge.leastND` runs the
--      search with fuel `L'` where `L ≡ suc L'`, i.e. the never-divides
--      endpoint is `L + 1`.  Transcribed literally that would be
--      `value w + 1`, and THE FUEL IS FORCED BY THE RECURSION: producing
--      it in unary is exactly the Θ(value w) materialisation of the
--      capacity this lane exists to avoid.  The endpoint used here is
--      `2 + b ^ length w`, a function of the WORD, and the never-divides
--      obligation is discharged for the same reason as `WalkBridge`'s --
--      an endpoint strictly above a positive number cannot divide it --
--      from
--
--        value-<-pow : (w : Word) → value w < b ^ length w
--
--      one induction, valid for every word, canonical or not (`toℕ d < b`
--      is its only input).
--
--   5. THE COST CLAIM, exactly and no more.  Per candidate s ≥ 2 the
--      test is one pass of `TransportDiv.run`: the number the decision
--      inspects is that run's final state (`candidate-state`), and the
--      run's own step count is `suc (length w)` (`candidate-cost`, i.e.
--      `run-is-the-automaton`), against `usteps (value w) ≡ suc (value w)`
--      for the recursion `dec∣` performs on the numeral
--      (`candidate-cost-gap`).  The capacity is never materialised as a
--      numeral: `value w` occurs in `leastNDw` only inside the proof
--      `pow-endpoint-∤`, which the search carries and never evaluates.
--
--   6. `capws` AND THE KERNEL WITNESSES.  `nextw!` is `nextw` with the
--      capacity THREADED AS AN ARGUMENT instead of re-called, and
--      `capws≡capw` proves the two capacities are the same word, so
--      nothing mathematical distinguishes them; §7 below says why the
--      distinction is nevertheless the difference between m = 13 and
--      m = 50 in the kernel.  With it,
--
--        next-8 : next 8 ≡ 9
--
--      is a term.  `WalkBridge` reports `next 8` exhausting a 3.5 GB
--      heap; it is not evaluated here either -- `nextw! 8 ≡ 9` is
--      evaluated, and `nextw!≡next` carries it.  That is the point of the
--      chart, in the one form that cannot be argued with.
--      Also `next 9 ≡ 11`, `next 13 ≡ 16`, `next 16 ≡ 17` -- prime
--      powers, §(c) firing at frontiers past the wall.  (No superlative
--      is claimed for 16 = 2⁴: `WalkBridge`'s own `next 3 ≡ 4` is
--      already a non-prime install.)
--
-- WHAT IS *NOT* DELIVERED.  The walk is not fast, and nothing here says
-- it is.
--
--   * NO ASYMPTOTIC CLAIM, AND THE TIMINGS ARE NOT RESULTS.  §5 is a
--     per-candidate count and there is no theorem here bounding the
--     number of candidates (that is `next m − m`, a fact about prime
--     powers) or `length (capw m)`.  Wall times appear only in §7, as
--     build metadata in `WalkBridge`'s sense; no exponent is fitted to
--     them and none should be.
--
--   * NO BOUND ON `length (capw m)`.  `value-<-pow` bounds the value by
--     the length, which is the direction the fuel needs; the converse --
--     the length is logarithmic in the value -- needs
--     `Canonical (capw m)`, which `WalkChartedCap` states it does not
--     prove for `scale`.  `b ^ length w` is therefore not claimed small,
--     only cheap to PEEL: the recursion consumes it one `suc` at a time
--     and stops at the first non-divisor.
--
--   * THE PER-TRANSITION ARITHMETIC IS AN UNSTATED PARAMETER, as in
--     `TransportDiv` and `WalkChartedCap`.  `run` counts transitions;
--     the cost of one `_mod_` on numerals < s is not counted, and no
--     count is claimed for `gcd`.
--
-- CHECKED: Agda 2.6.3, cubical v0.7 (/tmp/cubical), --cubical --safe,
-- 2026-08-15.  No postulates, no holes.  NOT verified against the pin in
-- formal/cubical/BUILD.md (Agda 2.8.0, cubical v0.9).
------------------------------------------------------------------------

module NaturalMachine.WalkChartedStep where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Mod using (_mod_ ; quotient_/_)
open import Cubical.Data.Nat.GCD using (gcd)
open import Cubical.Data.Nat.Divisibility using (_∣_ ; isProp∣ ; m∣sn→m≤sn)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_ ; fst ; snd)
open import Cubical.Data.Sum using (_⊎_ ; inl ; inr)
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_ ; Dec ; yes ; no ; isPropDec)
open import Cubical.Data.Fin using (toℕ)

open import Texts.WalkChartedCap using (pos-form ; module Charted)
open import NaturalMachine.WalkUnconditional using (cap)
open import NaturalMachine.WalkForcing using (LeastNonDivisor)
open import NaturalMachine.WalkBridge using (cap-pos ; next ; next-2≤ ; next-lnd)
open import NaturalMachine.CoprimeSplitting using (dec∣)

------------------------------------------------------------------------
-- Uniqueness of the least non-divisor.  Base-independent, so it lives
-- outside the chart: this is what makes §5's theorem a two-line
-- consequence of the two searches' shared specification rather than a
-- simulation of one search by the other.
------------------------------------------------------------------------

lnd-unique : (L p q : ℕ) → 2 ≤ p → 2 ≤ q
           → LeastNonDivisor L p → LeastNonDivisor L q → p ≡ q
lnd-unique L p q 2≤p 2≤q lp lq with p ≟ q
... | lt p<q = Empty.rec (lp .fst (lq .snd p 2≤p p<q))
... | eq p≡q = p≡q
... | gt q<p = Empty.rec (lq .fst (lp .snd q 2≤q q<p))

------------------------------------------------------------------------
-- Everything else is over a fixed base b = 2 + k, as in `Digits`.
------------------------------------------------------------------------

module Step (k : ℕ) where

  open import NaturalMachine.Digits k
  open import NaturalMachine.TransportDiv k
  open import NaturalMachine.WalkResidueBridge k
    using (decDivides ; usteps ; usteps-is-value)

  open Charted k using (capw ; value-capw ; scale)

  ----------------------------------------------------------------------
  -- 1.  THE TEST, INDEXED BY THE CANDIDATE.
  --
  -- `decDivides n w : Dec (suc n ∣ value w)` is indexed by the modulus'
  -- predecessor.  The search's candidate is a variable s with 2 ≤ s, so
  -- the two must be reconciled.  Doing it with `subst` would put a
  -- transport of a `Dec` on the path the kernel actually runs; matching
  -- s as `suc (suc s')` instead gives `decDivides (suc s') w` the
  -- required type on the nose, and the two impossible shapes of s are
  -- refuted from `2 ≤ s`.
  ----------------------------------------------------------------------

  decDvd : (s : ℕ) → 2 ≤ s → (w : Word) → Dec (s ∣ value w)
  decDvd zero          2≤s w = Empty.rec (¬-<-zero 2≤s)
  decDvd (suc zero)    2≤s w = Empty.rec (¬-<-zero (pred-≤-pred 2≤s))
  decDvd (suc (suc s)) _   w = decDivides (suc s) w

  -- …and it is `dec∣`'s decision, not merely another correct one.  Same
  -- argument as `WalkResidueBridge.decDividesℕ-agrees`: `_∣_` is a
  -- proposition, so `Dec (s ∣ value w)` is one.  This is the licence to
  -- substitute the charted test for `dec∣` inside `findND` without
  -- touching a downstream proof.
  decDvd-agrees :
    (s : ℕ) (2≤s : 2 ≤ s) (w : Word) (0<s : 0 < s)
    → decDvd s 2≤s w ≡ dec∣ s (value w) 0<s
  decDvd-agrees s 2≤s w 0<s = isPropDec isProp∣ _ _

  ----------------------------------------------------------------------
  -- 2.  THE BOUND.  A word's value is below b ^ its length.
  ----------------------------------------------------------------------

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

  -- hence the endpoint never divides: `WalkBridge`'s reason exactly,
  -- with `L + 1` replaced by `2 + b ^ length w`.
  pow-endpoint-∤ : (w : Word) → 0 < value w
                 → ¬ ((2 + (b ^ length w)) ∣ value w)
  pow-endpoint-∤ w 0<v d = ¬m<m (≤<-trans (∣→≤-pos _ _ 0<v d) big)
    where
    big : value w < 2 + (b ^ length w)
    big = <≤-trans (value-<-pow w) ≤SumRight

  ----------------------------------------------------------------------
  -- 3.  THE SEARCH.  `WalkBridge.findND` with `L : ℕ` replaced by
  --     `w : Word` and `dec∣` replaced by `decDvd`.  Nothing else moves:
  --     the two `where` clauses below are its two, verbatim.
  ----------------------------------------------------------------------

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
  leastNDw w 0<v =
    findNDw w 2 (b ^ length w) ≤-refl vac (pow-endpoint-∤ w 0<v)
    where
    vac : (r : ℕ) → 2 ≤ r → r < 2 → r ∣ value w
    vac r 2≤r r<2 = Empty.rec (¬m<m (≤<-trans 2≤r r<2))

  ----------------------------------------------------------------------
  -- 4.  THE CHARTED STEP.
  ----------------------------------------------------------------------

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

  ----------------------------------------------------------------------
  -- 5.  THE THEOREM.  `nextw m ≡ next m`, for every m and every base.
  ----------------------------------------------------------------------

  nextw≡next : (m : ℕ) → nextw m ≡ next m
  nextw≡next m =
    lnd-unique (cap m) (nextw m) (next m)
               (nextw-2≤ m) (next-2≤ m) (nextw-lnd m) (next-lnd m)

  -- what "substitutes without disturbing a proof" means operationally:
  -- every property `WalkBridge` proves of `next` transports to `nextw`.
  -- Stated once and generically rather than instance by instance --
  -- `walk-step`, §(b), `install`, all follow from this.
  nextw-transports : (P : ℕ → Type) (m : ℕ) → P (next m) → P (nextw m)
  nextw-transports P m = subst P (sym (nextw≡next m))

  ----------------------------------------------------------------------
  -- 6.  COST, per candidate.  Read it as exactly what it says.
  --
  -- `decDvd s 2≤s w` is `decDivides`, which decides by comparing
  -- `modw s w` with 0.  `candidate-state` says that number is the final
  -- state of `TransportDiv.run`; `candidate-cost` is
  -- `run-is-the-automaton`: that run takes `suc (length w)` transitions.
  -- `candidate-cost-gap` puts it beside the count of the same residue in
  -- the home presentation, `suc (value w)` -- which for w = capw m is
  -- e^{ψ(m)} + 1.  Every line is an equality; nothing is measured.
  ----------------------------------------------------------------------

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

  -- the fuel is a function of the word, not of its value
  fuel : Word → ℕ
  fuel w = b ^ length w

  fuel-bounds-the-value : (w : Word) → value w < fuel w
  fuel-bounds-the-value = value-<-pow

  ----------------------------------------------------------------------
  -- 7.  THE SAME CAPACITY, THREADED.
  --
  -- `WalkChartedCap.capw` names its argument twice:
  --
  --     capw (suc m)      = scale (chartedQuot m) (capw m) 0
  --     chartedQuot m     = quotient (suc m) / gcd (modw (suc m) (capw m)) (suc m)
  --
  -- Two occurrences of `capw m` in one clause.  Agda's evaluator shares
  -- an ARGUMENT's thunk but not two independent calls of a definition,
  -- so evaluating `capw m` re-evaluates `capw (m−1)` twice, and the
  -- kernel cost doubles with every frontier -- for reasons that have
  -- nothing to do with the mathematics and nothing to do with `cap`.
  -- `capws` is the same recursion with the word passed in, so the two
  -- occurrences become two uses of one bound variable.
  --
  -- THIS IS NOT A NEW CAPACITY.  `capws≡capw` proves them equal, and
  -- `nextw!≡nextw` follows; §8's witnesses are therefore witnesses about
  -- `WalkChartedCap`'s capacity, not about a variant of it.  What
  -- changes is only which of them the kernel can afford to unfold.
  ----------------------------------------------------------------------

  capStep : Word → ℕ → Word
  capStep w m = scale (quotient (suc m) / gcd (modw (suc m) w) (suc m)) w 0

  capws : ℕ → Word
  capws zero    = digits 1
  capws (suc m) = capStep (capws m) m

  capws≡capw : (m : ℕ) → capws m ≡ capw m
  capws≡capw zero    = refl
  capws≡capw (suc m) = cong (λ w → capStep w m) (capws≡capw m)

  value-capws : (m : ℕ) → value (capws m) ≡ cap m
  value-capws m = cong value (capws≡capw m) ∙ value-capw m

  capws-pos : (m : ℕ) → 0 < value (capws m)
  capws-pos m = subst (0 <_) (sym (value-capws m)) (cap-pos m)

  nextw! : ℕ → ℕ
  nextw! m = leastNDw (capws m) (capws-pos m) .fst

  nextw!-2≤ : (m : ℕ) → 2 ≤ nextw! m
  nextw!-2≤ m = leastNDw (capws m) (capws-pos m) .snd .fst

  nextw!-lnd : (m : ℕ) → LeastNonDivisor (cap m) (nextw! m)
  nextw!-lnd m =
    subst (λ L → LeastNonDivisor L (nextw! m)) (value-capws m)
          (leastNDw (capws m) (capws-pos m) .snd .snd)

  nextw!≡next : (m : ℕ) → nextw! m ≡ next m
  nextw!≡next m =
    lnd-unique (cap m) (nextw! m) (next m)
               (nextw!-2≤ m) (next-2≤ m) (nextw!-lnd m) (next-lnd m)

  nextw!≡nextw : (m : ℕ) → nextw! m ≡ nextw m
  nextw!≡nextw m = nextw!≡next m ∙ sym (nextw≡next m)

  -- THE TRANSFER, STATED FOR VARIABLE m AND n so that `sym` and `_∙_`
  -- are checked once, symbolically, against a `nextw!≡next m` that is
  -- stuck.  Applied at concrete arguments it then only has its type
  -- INSTANTIATED, never re-elaborated.  §8 records the one further
  -- precaution the application still needs, and why: writing the
  -- concrete type by hand costs 3 GB, and letting Agda infer it costs
  -- nothing.
  next-from-chart : (m n : ℕ) → nextw! m ≡ n → next m ≡ n
  next-from-chart m n e = sym (nextw!≡next m) ∙ e

------------------------------------------------------------------------
-- 8.  IT COMPUTES -- PAST THE WALL.
--
-- Base ten, as in `TransportDivWitness`.  Each `refl` below is the
-- charted walk taking a step in the kernel: build the capacity in the
-- chart, then decide each candidate by one pass of the residue
-- automaton over its digits.  `next-8 … next-16` are then the WALK's own
-- installs, obtained from §7's `nextw!≡next` -- `next m` itself is never
-- evaluated, which is the whole point: `WalkBridge` records `next 8`
-- exhausting a 3.5 GB heap, and its computed stream stops at `next 5`.
--
-- 9, 11, 16, 17: prime powers, in increasing order, skipping 10, 12, 14,
-- 15 -- §(c) of the note, on the stream §(b) identifies, at frontiers
-- the unary walk could not reach.  (Nothing is claimed about 16 = 2⁴
-- being the first non-prime install: `WalkBridge.next-3 : next 3 ≡ 4`
-- is one already.  What is new is only the range.)
--
-- WALL TIMES ARE BUILD METADATA, in `WalkBridge`'s sense; no exponent is
-- fitted to them and none should be.  This whole file, witnesses
-- included, checks in ~15 s.  `nextw! 30 ≡ 31` checks in ~21 s and
-- `nextw! 50 ≡ 53` in ~3 min; both are excluded only for gate cost,
-- exactly as `WalkBridge` excludes `next 7` at 86 s.  For contrast, and
-- as a measurement of §7's threading and of nothing else, the same
-- witnesses over the UNthreaded `capw` (i.e. `nextw`) cost ~2 s at
-- m = 9, ~20 s at m = 12, ~42 s at m = 13 and ~5 min at m = 16 --
-- consistent with the doubling §7 names, and the reason `nextw!` exists.
------------------------------------------------------------------------

module Base10 = Step 8

nextw-8 : Base10.nextw! 8 ≡ 9
nextw-8 = refl

nextw-9 : Base10.nextw! 9 ≡ 11
nextw-9 = refl

nextw-13 : Base10.nextw! 13 ≡ 16
nextw-13 = refl

nextw-16 : Base10.nextw! 16 ≡ 17
nextw-16 = refl

-- …and therefore, without evaluating `next` anywhere:
--
-- WHY EACH INSTALL IS WRITTEN TWICE.  Attaching the signature directly,
--
--     next-8 : next 8 ≡ 9
--     next-8 = Base10.next-from-chart 8 9 nextw-8 ,
--
-- DOES NOT CHECK in 3 GB.  Agda compares the ascribed type against the
-- freshly instantiated type of the lemma, the syntactic fast path does
-- not fire, and the fallback takes the weak head normal form of
-- `next 8` -- exactly the evaluation this file exists to avoid (measured:
-- heap exhausted after ~3 min, i.e. `WalkBridge`'s own wall, reached
-- through the TYPE rather than through the term).  INFERRING the type
-- costs nothing, and restating an inferred type against a signature
-- costs nothing.  So each install is elaborated once with no signature
-- and then named.  Same term, same theorem; only the order of the two
-- type comparisons differs.  It is the file's own subject arriving by
-- the back door: a numeral you never write down is a numeral you never
-- pay for.

private
  raw-8  = Base10.next-from-chart 8  9  nextw-8
  raw-9  = Base10.next-from-chart 9  11 nextw-9
  raw-13 = Base10.next-from-chart 13 16 nextw-13
  raw-16 = Base10.next-from-chart 16 17 nextw-16

next-8 : next 8 ≡ 9
next-8 = raw-8

next-9 : next 9 ≡ 11
next-9 = raw-9

next-13 : next 13 ≡ 16
next-13 = raw-13

next-16 : next 16 ≡ 17
next-16 = raw-16
