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

{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- NaturalMachine.CountedDigitsEdge
--
-- THE COST EDGE, CLOSED.
--
-- `CountedDigits` ends with a confession, and three further modules
-- re-name it verbatim:
--
--   CountedDigits      "`sucw` performs real recursive carry propagation,
--                      but the imported development proves semantic
--                      equations, not a work measure for that recursion.
--                      … A costed execution edge remains open until a
--                      native carry-cost theorem is installed."
--   CountedComposition "This is what makes a tick count a *cost*" — of a
--                      tick whose own work is unpriced.
--   AcceptanceTest     "`cost` is a DECLARED plan cost: it prices one
--                      scheduled `sucC` tick … at one unit.  `sucC`
--                      performs real recursive carry propagation whose
--                      cost nobody here bounds."
--   CompileBridge      "No native-work theorem is claimed here, and the
--                      open cost edge of the corpus is not closed."
--
-- One sentence, four times: THE LANE COUNTS TICKS OF `sucC` AND HAS NO
-- THEOREM SAYING WHAT ONE TICK COSTS, so every "strictly cheaper" in the
-- lane is a statement about a schedule and not about work.
--
-- What is installed here is exactly that theorem, and its consequences.
--
--
-- §1-§2  THE COUNTER IS THE COMPUTATION.  `sucwR` is the odometer with
--        the carry count carried in the SAME recursion — the discipline
--        of `TransportDiv.run-is-the-automaton`, which exists because an
--        audit caught this lane pricing a lookalike counter.  Nothing is
--        counted that is not executed:
--
--          sucwR-is-sucw : fst (sucwR w) ≡ sucw w
--          runC-is-run   : runC n ≡ CountedDigits.run n
--
--        The second is the point: the object whose cost is measured below
--        is, as a checked path in `CanWord`, the very `run` of the module
--        that confessed the gap.
--
-- §3     THE CARRY-COST LAW, EXACT.  The native carry cost of one tick is
--        not a fitted number and not a stipulated one; it is determined by
--        the digit sum, which the odometer moves by an exact amount:
--
--          digitSum (fst (sucwR w)) + snd (sucwR w) · (b−1)
--            ≡ digitSum w + b
--
--        Read: a tick that propagates c carries destroys c−1 maximal
--        digits (each worth b−1) and adds 1.  This is the potential-
--        function identity behind the folklore "increment is amortised
--        O(1)", written as an equation rather than as a bound, per
--        CLAUDE.md §2 (derive the constant, do not fit it).
--
-- §5     THE EXECUTION LAW, EXACT.  Telescoped over a whole run from zero:
--
--          digitSum (digits n) + snd (runR n) · (b−1) ≡ n · b
--
--        so the total native carry work C(n) of the first n increments
--        satisfies (b−1)·C(n) + digitSum (digits n) = n·b EXACTLY, with no
--        error term to hide and no scale at which the constant changes
--        (CLAUDE.md, HOLOGRAM §7: a number without its X-dependence looks
--        like knowledge).  Corollaries: n ≤ C(n) and (b−1)·C(n) ≤ n·b.
--
-- §6     WHAT THE LANE'S DECLARED COST WAS.  `AcceptanceTest.cost` prices
--        a tick at 1.  §5 says that price is a LOWER bound that is never
--        off by more than the factor b/(b−1) — an exact constant, derived.
--        So the declared cost was sound all along, and now it is a theorem
--        rather than a convention.
--
-- §7     WORK COMPOSES ACROSS A CHECKPOINT.  `CountedComposition.run-+`
--        for native work rather than for scheduled ticks:
--
--          snd (runRfrom w (m + n))
--            ≡ snd (runRfrom w n) + snd (runRfrom (fst (runRfrom w n)) m)
--
--        "no ticks are created or destroyed at a checkpoint" was proved
--        there of ticks; here it is proved of carries.
--
-- §8     THE ACCEPTANCE TEST, IN NATIVE WORK.  `AcceptanceTest.betterProgram`
--        is re-proved with `nativeCost` in place of the declared `cost`,
--        and `nativeRun-is-exec` proves that `nativeCost p` is the cost of
--        running exactly the word `AcceptanceTest.exec p` computes.  The
--        improvement is no longer "fewer scheduled transitions": resuming
--        from a nonempty checkpoint does strictly less CARRY PROPAGATION.
--
-- §9     A NEGATIVE FINDING ABOUT THE COST GEOMETRY, and it is why this
--        module does not instantiate `CostGeometry.Edge`.  `Edge` holds
--        `cost : Cost` — ONE natural number per edge — and `Work` is a
--        single natural too.  The quantity `CountedDigits` confesses is a
--        FUNCTION of the state: `no-native-cost-is-constant` proves the
--        odometer's carry cost is 1 at `[]` and 2 at the one-digit maximal
--        word, so
--
--          no-edge-carries-native-cost :
--            ¬ Σ[ e ∈ Edge odometer odometer ]
--                ((w : Word) → snd (sucwR w) ≡ cost e)
--
--        `CostGeometry` is therefore a geometry of costs AT A FIXED INPUT;
--        it prices translations, and the odometer's carry recursion is not
--        a translation.  What it does buy is `workAt`: for each word the
--        `Work` slot may now be filled with a DERIVED number rather than a
--        stipulated one (`CostGeometryWitness` W2: "the weights are
--        STIPULATED, not measured here"), with `workAt-≤-suc-length` as
--        the uniform bound a `Neighbour`'s `work` field wants.
--
-- §10    THE COUNTER, RUN.  Eight `refl`s at base ten and base two.  The
--        base parameter therefore sits on the inner `module Base (k : ℕ)`
--        rather than on this module's header (`CountedDigits` and
--        `AcceptanceTest` put it on the header; a parameterised module
--        cannot instantiate itself).  Downstream: `open
--        NaturalMachine.CountedDigitsEdge.Base k`.
--
--
-- WHAT IS DELIBERATELY NOT CLAIMED
--
--  * The unit is one DIGIT-POSITION UPDATE of the odometer, i.e. one
--    invocation of `dsuc` plus the cons that follows it.  That is the
--    atomic step of the algorithm `Digits.sucw` actually is; it is not a
--    machine word, a bit operation, or a wall-clock second.  Everything
--    below is exact in that unit and says nothing in any other.
--  * `dsuc` itself is priced at one.  `dsucΣ` case-splits on `≤-split`
--    over a bounded digit; pricing it at one is the same convention as
--    `TransportDiv.steps` pricing one Horner step at one, and it is a
--    convention.  What is NOT a convention, and is the whole content
--    here, is how many times it runs.
--  * No optimality: nothing says schoolbook increment is the cheapest
--    successor on digit words.  §5 measures this algorithm.
--  * §8 improves `AcceptanceTest`'s cost model, not its `Plan` type.
--    `Plan` is still a two-constructor enumeration and there is still no
--    compiler; every disclaimer in that module's ledger that is not about
--    cost stands unchanged.
--  * §9 is a statement about `CostGeometry`'s record, not about the
--    cost geometry programme.  Indexing `Work` by the carrier would
--    repair it; that is not done here.
--  * §10 is two bases and finitely many n.  It certifies that the counter
--    RUNS and that §3/§5 have the constants they claim at those points; it
--    is evidence for the definitions, not for the theorems, which are §3
--    and §5 and hold at every k and every n.
------------------------------------------------------------------------

module NaturalMachine.CountedDigitsEdge where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Bool using (Bool ; true ; false ; false≢true)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Fin using (Fin ; fzero ; fone ; toℕ)
open import Cubical.Data.Sigma
open import Cubical.Data.Empty as Empty using (⊥)
open import Cubical.Relation.Nullary using (¬_)

open import NaturalMachine.CostGeometry
  using (Presentation ; pres ; Edge ; edge ; move ; cost ; Cost ; Work)

import NaturalMachine.Digits
import NaturalMachine.Transport
import NaturalMachine.CountedExecution
import NaturalMachine.CountedDigits
import NaturalMachine.AcceptanceTest

module CE = NaturalMachine.CountedExecution

-- The base is `b = 2 + k`, as everywhere in this lane.  The parameter is
-- INTERNAL rather than on the module header (unlike `CountedDigits k`)
-- for one reason: §10 instantiates it at two bases and runs the counter,
-- so the file certifies its own numbers instead of asserting them.
module Base (k : ℕ) where

  open NaturalMachine.Digits k public
  open NaturalMachine.Transport k using (sucC)

  module CD = NaturalMachine.CountedDigits k
  module AT = NaturalMachine.AcceptanceTest k
  ------------------------------------------------------------------------
  -- 0.  The potential function: the digit sum.
  --
  -- Not a new object — it is `value` with the place weights forgotten, and
  -- it is the only thing about a word the carry recursion moves by a known
  -- amount.
  ------------------------------------------------------------------------

  digitSum : Word → ℕ
  digitSum []      = 0
  digitSum (d ∷ w) = toℕ d + digitSum w

  ------------------------------------------------------------------------
  -- 1.  The odometer, executed with its own carry counter.
  --
  -- Clause for clause `Digits.sucw` / `Digits.sucwAux`, with a second
  -- component threaded through the SAME recursion.  Compare
  -- `TransportDiv.run`: the count is not a separate function that happens
  -- to look like the algorithm, it is a projection of the algorithm.
  ------------------------------------------------------------------------

  mutual
    sucwR : Word → Word × ℕ
    sucwR []      = (fone ∷ []) , 1
    sucwR (d ∷ w) = sucwAuxR (dsuc d) w

    sucwAuxR : Digit × Bool → Word → Word × ℕ
    sucwAuxR (d' , false) w = (d' ∷ w) , 1
    sucwAuxR (d' , true)  w = (d' ∷ fst (sucwR w)) , suc (snd (sucwR w))

  ------------------------------------------------------------------------
  -- 2.  THE COUNTER IS COUNTING THE ODOMETER.
  ------------------------------------------------------------------------

  sucwR-is-sucw : (w : Word) → fst (sucwR w) ≡ sucw w
  sucwR-is-sucw []      = refl
  sucwR-is-sucw (d ∷ w) = aux (dsuc d)
    where
      aux : (r : Digit × Bool) → fst (sucwAuxR r w) ≡ sucwAux r w
      aux (d' , false) = refl
      aux (d' , true)  = cong (d' ∷_) (sucwR-is-sucw w)

  -- and therefore it is counting the successor, by `Digits`' own certificate.
  sucwR-observed : (w : Word) → value (fst (sucwR w)) ≡ suc (value w)
  sucwR-observed w = cong value (sucwR-is-sucw w) ∙ value-sucw w

  ------------------------------------------------------------------------
  -- 3.  THE CARRY-COST LAW.
  --
  -- The exact statement, with b − 1 = suc k.  A tick costs c; the digit sum
  -- goes up by 1 and down by (c − 1)(b − 1), because each carry turns one
  -- maximal digit into a zero.  Rearranged to avoid subtraction:
  --
  --   digitSum (sucw w) + c · (b−1) ≡ digitSum w + b.
  ------------------------------------------------------------------------

  private
    shuffle : (a c z : ℕ) → a + (c + z) ≡ c + (a + z)
    shuffle a c z = +-assoc a c z ∙ cong (_+ z) (+-comm a c) ∙ sym (+-assoc c a z)

  carry-cost-law : (w : Word)
    → digitSum (fst (sucwR w)) + snd (sucwR w) · suc k ≡ digitSum w + b
  carry-cost-law []      = cong suc (+-zero (suc k))
  carry-cost-law (d ∷ w) = aux (fst (dsucΣ d)) (snd (dsucΣ d))
    where
      Φ' : ℕ
      Φ' = digitSum (fst (sucwR w))

      C : ℕ
      C = snd (sucwR w)

      X : ℕ
      X = toℕ d + digitSum w

      aux : (r : Digit × Bool)
          → suc (toℕ d) ≡ toℕ (fst r) + carryVal (snd r) · b
          → digitSum (fst (sucwAuxR r w)) + snd (sucwAuxR r w) · suc k
            ≡ digitSum (d ∷ w) + b
      aux (d' , false) spec =
          cong (λ z → (z + digitSum w) + (suc k + 0)) d'eq
        ∙ cong (λ z → suc (X + z)) (+-zero (suc k))
        ∙ sym (+-suc X (suc k))
        where
          d'eq : toℕ d' ≡ suc (toℕ d)
          d'eq = sym (spec ∙ +-zero (toℕ d'))
      aux (d' , true) spec =
          sym (+-assoc (toℕ d') Φ' (suc k + C · suc k))
        ∙ cong (toℕ d' +_) (shuffle Φ' (suc k) (C · suc k))
        ∙ cong (λ z → toℕ d' + (suc k + z)) (carry-cost-law w)
        ∙ +-assoc (toℕ d') (suc k) (digitSum w + b)
        ∙ cong (_+ (digitSum w + b)) (sym d-eq)
        ∙ +-assoc (toℕ d) (digitSum w) b
        where
          d-eq : toℕ d ≡ toℕ d' + suc k
          d-eq = injSuc ( spec
                        ∙ cong (toℕ d' +_) (+-zero b)
                        ∙ +-suc (toℕ d') (suc k) )

  ------------------------------------------------------------------------
  -- 4.  Two elementary bounds on one tick.
  --
  -- Both are about `sucwR`'s own second projection, so both are about the
  -- odometer.  The upper bound is the one a `Neighbour`'s `work` field can
  -- consume (§9).
  ------------------------------------------------------------------------

  sucwR-pos : (w : Word) → 1 ≤ snd (sucwR w)
  sucwR-pos []      = ≤-refl
  sucwR-pos (d ∷ w) = aux (dsuc d)
    where
      aux : (r : Digit × Bool) → 1 ≤ snd (sucwAuxR r w)
      aux (d' , false) = ≤-refl
      aux (d' , true)  = suc-≤-suc zero-≤

  sucwR-≤-suc-length : (w : Word) → snd (sucwR w) ≤ suc (length w)
  sucwR-≤-suc-length []      = ≤-refl
  sucwR-≤-suc-length (d ∷ w) = aux (dsuc d)
    where
      aux : (r : Digit × Bool) → snd (sucwAuxR r w) ≤ suc (suc (length w))
      aux (d' , false) = suc-≤-suc zero-≤
      aux (d' , true)  = suc-≤-suc (sucwR-≤-suc-length w)

  ------------------------------------------------------------------------
  -- 5.  Counted execution that carries its own carry bill.
  ------------------------------------------------------------------------

  runRfrom : Word → ℕ → Word × ℕ
  runRfrom w zero    = w , 0
  runRfrom w (suc n) =
      fst (sucwR (fst (runRfrom w n)))
    , snd (runRfrom w n) + snd (sucwR (fst (runRfrom w n)))

  runR : ℕ → Word × ℕ
  runR = runRfrom []

  -- 5a.  Again: the machine being billed is the certified one.

  runR-state : (n : ℕ) → fst (runR n) ≡ digits n
  runR-state zero    = refl
  runR-state (suc n) =
      sucwR-is-sucw (fst (runR n))
    ∙ cong sucw (runR-state n)

  runR-observed : (n : ℕ) → value (fst (runR n)) ≡ n
  runR-observed n = cong value (runR-state n) ∙ value-digits n

  runR-canonical : (n : ℕ) → Canonical (fst (runR n))
  runR-canonical n = subst Canonical (sym (runR-state n)) (canonical-digits n)

  runC : ℕ → CanWord
  runC n = fst (runR n) , runR-canonical n

  -- THE TIE.  The billed execution IS `CountedDigits.run`, as a path in
  -- `CanWord`.  `snd (runR n)` is therefore the carry cost OF the run that
  -- module confessed it could not price, not of a lookalike.
  runC-is-run : (n : ℕ) → runC n ≡ CD.run n
  runC-is-run n =
      Σ≡Prop isPropCanonical (runR-state n)
    ∙ sym (CD.run-is-digitsC n)

  -- 5b.  THE EXECUTION COST LAW, telescoped.  Exact, at every n, for every
  -- base: no fitted coefficient, and the b-dependence is explicit.

  execution-cost-law : (n : ℕ)
    → digitSum (fst (runR n)) + snd (runR n) · suc k ≡ n · b
  execution-cost-law zero    = refl
  execution-cost-law (suc n) =
      cong (Φ' +_) (sym (·-distribʳ C c (suc k)))
    ∙ cong (Φ' +_) (+-comm (C · suc k) (c · suc k))
    ∙ +-assoc Φ' (c · suc k) (C · suc k)
    ∙ cong (_+ C · suc k) (carry-cost-law W)
    ∙ sym (+-assoc (digitSum W) b (C · suc k))
    ∙ cong (digitSum W +_) (+-comm b (C · suc k))
    ∙ +-assoc (digitSum W) (C · suc k) b
    ∙ cong (_+ b) (execution-cost-law n)
    ∙ +-comm (n · b) b
    where
      W : Word
      W = fst (runR n)

      C : ℕ
      C = snd (runR n)

      c : ℕ
      c = snd (sucwR W)

      Φ' : ℕ
      Φ' = digitSum (fst (sucwR W))

  -- The same law read on the canonical numeral, which is what a reader of
  -- `CountedDigits` has in hand.
  execution-cost-law-digits : (n : ℕ)
    → digitSum (digits n) + snd (runR n) · suc k ≡ n · b
  execution-cost-law-digits n =
    cong (λ u → digitSum u + snd (runR n) · suc k) (sym (runR-state n))
    ∙ execution-cost-law n

  ------------------------------------------------------------------------
  -- 6.  What the lane's declared cost was, now as two theorems.
  --
  --   work-lower  n ≤ C(n)          one tick is at least one carry, so the
  --                                 declared price never over-charges;
  --   work-upper  C(n)·(b−1) ≤ n·b  and never under-charges by more than
  --                                 the factor b/(b−1), exactly.
  ------------------------------------------------------------------------

  work-lower : (n : ℕ) → n ≤ snd (runR n)
  work-lower zero    = zero-≤
  work-lower (suc n) =
    subst (_≤ snd (runR n) + snd (sucwR (fst (runR n)))) (+-comm n 1)
      (≤-+-≤ (work-lower n) (sucwR-pos (fst (runR n))))

  work-upper : (n : ℕ) → snd (runR n) · suc k ≤ n · b
  work-upper n = digitSum (fst (runR n)) , execution-cost-law n

  private
    m≤m·sk : (m : ℕ) → m ≤ m · suc k
    m≤m·sk m =
      subst2 _≤_ (+-zero m) (·-comm (suc k) m)
        (≤-·k {m = 1} {n = suc k} {k = m} (suc-≤-suc zero-≤))

  -- The crude form, for a reader who wants one number: the whole carry
  -- bill of the first n increments is at most n·b.
  work-≤-n·b : (n : ℕ) → snd (runR n) ≤ n · b
  work-≤-n·b n = ≤-trans (m≤m·sk (snd (runR n))) (work-upper n)

  -- Packaged: the sandwich the four confessing headers asked for.
  declared-cost-is-sound : (n : ℕ)
    → (n ≤ snd (runR n)) × (snd (runR n) · suc k ≤ n · b)
  declared-cost-is-sound n = work-lower n , work-upper n

  ------------------------------------------------------------------------
  -- 7.  Native work composes across a checkpoint.
  --
  -- `CountedComposition.run-+` says scheduled ticks concatenate.  These two
  -- say the CARRIES do — which is what that module's own header claimed the
  -- additivity was for ("no ticks are created or destroyed at a
  -- checkpoint").
  ------------------------------------------------------------------------

  runRfrom-state-+ : (w : Word) (m n : ℕ)
    → fst (runRfrom w (m + n)) ≡ fst (runRfrom (fst (runRfrom w n)) m)
  runRfrom-state-+ w zero    n = refl
  runRfrom-state-+ w (suc m) n =
    cong (λ u → fst (sucwR u)) (runRfrom-state-+ w m n)

  runRfrom-work-+ : (w : Word) (m n : ℕ)
    → snd (runRfrom w (m + n))
    ≡ snd (runRfrom w n) + snd (runRfrom (fst (runRfrom w n)) m)
  runRfrom-work-+ w zero    n = sym (+-zero (snd (runRfrom w n)))
  runRfrom-work-+ w (suc m) n =
      cong₂ _+_ (runRfrom-work-+ w m n)
                (cong (λ u → snd (sucwR u)) (runRfrom-state-+ w m n))
    ∙ sym (+-assoc (snd (runRfrom w n))
                   (snd (runRfrom W' m))
                   (snd (sucwR (fst (runRfrom W' m)))))
    where
      W' : Word
      W' = fst (runRfrom w n)

  ------------------------------------------------------------------------
  -- 8.  THE ACCEPTANCE TEST, IN NATIVE CARRY WORK.
  --
  -- `AcceptanceTest.betterProgram` compares `cost`, a declared price.  Here
  -- the same two plans are compared by the number of carry propagations
  -- their executions actually perform, and `resume` still wins, strictly,
  -- on exactly the same range (nonempty checkpoint).
  ------------------------------------------------------------------------

  nativeRun : AT.Plan → Word × ℕ
  nativeRun (AT.restart m n) = runR (m + n)
  nativeRun (AT.resume  m n) = runRfrom (digits n) m

  nativeCost : AT.Plan → ℕ
  nativeCost p = snd (nativeRun p)

  -- 8a.  `nativeCost p` is the bill for computing `AcceptanceTest.exec p`,
  -- and not for computing something else that agrees with it.  This is the
  -- lemma `AcceptanceTest.exec-runs-cost` could only state definitionally.

  private
    runRfrom-is-run : (x : CanWord) (m : ℕ)
      → fst (runRfrom (fst x) m) ≡ fst (CE.run x sucC m)
    runRfrom-is-run x zero    = refl
    runRfrom-is-run x (suc m) =
        sucwR-is-sucw (fst (runRfrom (fst x) m))
      ∙ cong sucw (runRfrom-is-run x m)

  nativeRun-is-exec : (p : AT.Plan) → fst (nativeRun p) ≡ fst (AT.exec p)
  nativeRun-is-exec (AT.restart m n) =
    runRfrom-is-run (digitsC zero) (m + n)
  nativeRun-is-exec (AT.resume  m n) =
    runRfrom-is-run (digitsC n) m

  -- 8b.  The strict improvement, in carries.

  private
    <-plus-pos : (p R : ℕ) → R < suc p + R
    <-plus-pos p R = p , +-suc p R

    run-work-pos : (n : ℕ) → Σ[ p ∈ ℕ ] snd (runR (suc n)) ≡ suc p
    run-work-pos n =
        (fst (work-lower (suc n)) + n)
      , ( sym (snd (work-lower (suc n)))
        ∙ +-suc (fst (work-lower (suc n))) n )

  resume-cheaper-natively : (m n : ℕ)
    → nativeCost (AT.resume m (suc n)) < nativeCost (AT.restart m (suc n))
  resume-cheaper-natively m n =
    subst (R <_) (sym split)
      (subst (λ z → R < z + R) (sym (snd (run-work-pos n)))
        (<-plus-pos (fst (run-work-pos n)) R))
    where
      R : ℕ
      R = snd (runRfrom (digits (suc n)) m)

      split : snd (runR (m + suc n)) ≡ snd (runR (suc n)) + R
      split =
          runRfrom-work-+ [] m (suc n)
        ∙ cong (λ u → snd (runR (suc n)) + snd (runRfrom u m))
               (runR-state (suc n))

  -- The acceptance test as one term, with the cost model derived instead of
  -- declared.  The `replay` half is `AcceptanceTest`'s, unchanged: what is
  -- replaced is only the second component.
  betterProgram-natively : (m n : ℕ)
    → (AT.exec (AT.resume m (suc n)) ≡ AT.exec (AT.restart m (suc n)))
    × (nativeCost (AT.resume m (suc n)) < nativeCost (AT.restart m (suc n)))
  betterProgram-natively m n =
    AT.replay m (suc n) , resume-cheaper-natively m n

  ------------------------------------------------------------------------
  -- 9.  WHY THIS IS NOT AN INSTANCE OF `CostGeometry.Edge`.
  --
  -- The natural move would be to make the odometer a node and one tick an
  -- edge.  It does not work, and the reason is worth more than the fit
  -- would have been: `Edge` carries `cost : Cost`, a single natural, and so
  -- does `Work`.  The carry cost of the odometer is a function of the
  -- state, and is provably non-constant.
  ------------------------------------------------------------------------

  -- The maximal digit: b − 1 = suc k, which is < b.
  dmax : Digit
  dmax = suc k , (0 , refl)

  -- It carries.  Proved from `dsucΣ`'s certificate, not by computing
  -- `≤-split`: if the maximal digit did not carry, its successor digit
  -- would have value b, contradicting the `Fin b` bound it comes with.
  dsuc-max-carries : snd (dsuc dmax) ≡ true
  dsuc-max-carries = aux (fst (dsucΣ dmax)) (snd (dsucΣ dmax))
    where
      aux : (r : Digit × Bool)
          → suc (toℕ dmax) ≡ toℕ (fst r) + carryVal (snd r) · b
          → snd r ≡ true
      aux (d' , true)  _    = refl
      aux (d' , false) spec = Empty.rec (¬m<m (subst (_< b) d'≡b (snd d')))
        where
          d'≡b : toℕ d' ≡ b
          d'≡b = sym (+-zero (toℕ d')) ∙ sym spec

  sucwR-carry-cons : (d : Digit) (w : Word) → snd (dsuc d) ≡ true
    → snd (sucwR (d ∷ w)) ≡ suc (snd (sucwR w))
  sucwR-carry-cons d w h = aux (dsuc d) h
    where
      aux : (r : Digit × Bool) → snd r ≡ true
          → snd (sucwAuxR r w) ≡ suc (snd (sucwR w))
      aux (d' , true)  _ = refl
      aux (d' , false) p = Empty.rec (false≢true p)

  -- One tick costs 1 here …
  native-cost-at-nil : snd (sucwR []) ≡ 1
  native-cost-at-nil = refl

  -- … and 2 here.  Two words, two costs, one algorithm.
  native-cost-at-max : snd (sucwR (dmax ∷ [])) ≡ 2
  native-cost-at-max = sucwR-carry-cons dmax [] dsuc-max-carries

  no-native-cost-is-constant : ¬ (Σ[ c ∈ ℕ ] ((w : Word) → snd (sucwR w) ≡ c))
  no-native-cost-is-constant (c , h) = znots (injSuc one≡two)
    where
      one≡c : 1 ≡ c
      one≡c = sym native-cost-at-nil ∙ h []

      two≡c : 2 ≡ c
      two≡c = sym native-cost-at-max ∙ h (dmax ∷ [])

      one≡two : 1 ≡ 2
      one≡two = one≡c ∙ sym two≡c

  -- The odometer as a node of the cost geometry.  `Presentation.op` is
  -- binary, so the unary successor is presented as a projection-then-tick;
  -- nothing below depends on the second argument.
  odometer : Presentation
  odometer = pres Word (λ w _ → sucw w)

  -- THE NEGATIVE RESULT.  No edge of the cost geometry can hold the number
  -- `CountedDigits` asked for, because the field is a constant and the
  -- number is not.
  no-edge-carries-native-cost :
    ¬ (Σ[ e ∈ Edge odometer odometer ] ((w : Word) → snd (sucwR w) ≡ cost e))
  no-edge-carries-native-cost (e , h) = no-native-cost-is-constant (cost e , h)

  -- What the geometry DOES get: a derived weight at each node, in place of
  -- `CostGeometryWitness` W2's stipulated one, with a uniform bound.
  workAt : Word → Work
  workAt w = snd (sucwR w)

  workAt-≤-suc-length : (w : Word) → workAt w ≤ suc (length w)
  workAt-≤-suc-length = sucwR-≤-suc-length

  -- and the tick edge as the lane actually prices it, kept so the gap
  -- between the declared weight and `workAt` is visible in one place.
  declaredTick : Edge odometer odometer
  declaredTick = edge sucw 1

  declaredTick-is-the-odometer : move declaredTick ≡ sucw
  declaredTick-is-the-odometer = refl


------------------------------------------------------------------------
-- 10.  THE COUNTER, RUN.
--
-- Exact finite verification — a mathematical object, not a measurement
-- (CLAUDE.md: "a finite exhaustive verification … produces mathematical
-- objects").  It is in this file rather than in a companion witness file
-- for one reason: a cost theorem about a counter nobody ever ran is the
-- defect this module exists to repair.  Every equation below is `refl`.
------------------------------------------------------------------------

module Decimal = Base 8      -- b = 10
module Binary  = Base 0      -- b = 2

-- The counted execution and the certified numeral are the same word, by
-- computation and not only by `runR-state`.
decimal-100-state : fst (Decimal.runR 100) ≡ Decimal.digits 100
decimal-100-state = refl

-- Carries spent by the first hundred increments in base ten:
-- 100 units + 10 tens + 1 hundreds = 111.  This is `runR`'s own second
-- projection; nothing here is a separate model of it.
decimal-100-work : snd (Decimal.runR 100) ≡ 111
decimal-100-work = refl

-- and §5's law at that point, both sides computed:  1 + 111·9 = 1000.
decimal-100-potential : Decimal.digitSum (Decimal.digits 100) ≡ 1
decimal-100-potential = refl

-- Base two, first sixteen increments: 16 + 8 + 4 + 2 + 1 = 31.
binary-16-work : snd (Binary.runR 16) ≡ 31
binary-16-work = refl

binary-16-potential : Binary.digitSum (Binary.digits 16) ≡ 1
binary-16-potential = refl

-- ONE TICK IS NOT ONE UNIT, computed.  The first decimal increment costs
-- one carry step; the hundredth costs three.  This is §9's
-- `no-native-cost-is-constant` with numbers on it.
decimal-tick-1 : snd (Decimal.sucwR (fst (Decimal.runR 0))) ≡ 1
decimal-tick-1 = refl

decimal-tick-100 : snd (Decimal.sucwR (fst (Decimal.runR 99))) ≡ 3
decimal-tick-100 = refl

-- §8 at one instance: computing the base-ten numeral of 105 from the
-- checkpoint at 100 does five carry steps; recomputing from zero does a
-- hundred and sixteen.  `AcceptanceTest.cost` prices these 5 and 105.
decimal-resume-work : Decimal.nativeCost (Decimal.AT.resume 5 100) ≡ 5
decimal-resume-work = refl

decimal-restart-work : Decimal.nativeCost (Decimal.AT.restart 5 100) ≡ 116
decimal-restart-work = refl

------------------------------------------------------------------------
-- CHECKED: Agda 2.6.3, cubical v0.7 (/tmp/cubical, with the
-- `withReduceDefs` → `dontReduceDefs` back-port that landed 2026-08-15
-- and unblocked `Cubical.Tactics.*`; without it `NaturalMachine.Transport`
-- does not scope-check under this compiler and neither do the four
-- modules this file closes).  --cubical --safe --guardedness, no
-- postulates, no holes, no warnings.  Also checked against cubical v0.6
-- (Agda 2.6.3) during development.  NOT verified against the pin in
-- formal/cubical/BUILD.md (Agda 2.8.0, cubical v0.9): four toolchain
-- states are now live in this repository at once.
------------------------------------------------------------------------
