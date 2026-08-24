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
-- NaturalMachine.WalkResidueBridge
--
-- THE JOIN.  `TransportDiv` built the Horner residue automaton `modw`
-- and proved one direction of its specification: a zero final state
-- implies divisibility (`modw-zero→∣`).  One direction is not a decision
-- procedure -- with only that half, a nonzero final state means nothing,
-- and the automaton stays adjacent to the walk (`WalkBridge`) rather
-- than usable by it, which still decides `s ∣ cap m` with `dec∣`, i.e.
-- by `_mod_` on a unary numeral of size cap m = e^{ψ(m)}.
--
-- WHAT IS DELIVERED.
--
--   1. `∣→modw-zero` -- the missing converse.  `_∣_` is a propositional
--      truncation and the target `modw (suc n) w ≡ 0` is a proposition
--      (ℕ is a set), so the truncation is eliminated honestly, not by a
--      choice principle.
--
--   2. `decDivides : (n : ℕ) (w : Word) → Dec ((suc n) ∣ value w)` --
--      divisibility of the NUMBER decided by inspecting the automaton's
--      final STATE, a numeral < suc n.  `value w` occurs in the
--      statement and nowhere in the computation.
--
--   3. `decDividesℕ : (n m : ℕ) → Dec ((suc n) ∣ m)` -- the same test
--      for the walk's own numbers, by charting m to `digits m` and
--      rewriting along `value-digits`.  And `decDividesℕ-agrees`: this
--      decision is EQUAL to `CoprimeSplitting.dec∣`'s, not merely also
--      correct (`Dec` of a proposition is a proposition).
--
--   4. The cost gap, as a theorem rather than a timing.  `modu` is the
--      same residue automaton driven by the HOME presentation, one step
--      per successor; `value-modu` proves it computes `_mod_` and
--      `modu-modw` proves the two automata agree on every word.  They
--      differ only in step count: `steps w ≡ suc (length w)` against
--      `usteps (value w) ≡ suc (value w)`.  At the base-ten numeral
--      1000 of `TransportDivWitness` that is 5 against 1001.
--
-- WHAT IS *NOT* DELIVERED.  The walk is not fast now, and nothing here
-- should be read as saying so.
--
--   * CHARTING IS THE EXPENSIVE STEP.  `decDividesℕ n m` runs `digits m`,
--      and `digits` is defined by iterating the odometer m times, so it
--      costs Θ(m) on a unary m -- exactly what the automaton saves.  The
--      point of (3) is NOT that it is cheap on a unary input; it is that
--      the walk's `cap m`, once BUILT in the chart, never needs to leave
--      it: every subsequent divisibility test costs Θ(length) instead of
--      Θ(value).  Charting is paid once, testing is paid Θ(next m − m)
--      times per step and Θ(m) times over the run.
--
--   * `cap` is still a ℕ.  Nothing here builds lcm's in the chart, so
--      `WalkBridge.next` is unchanged and `next 8` still exhausts the
--      heap.  What is closed is the gap TransportDiv left open: the
--      automaton now DECIDES, so it is eligible to be the test inside a
--      charted walk.  Building that walk is not done here.
--
--   * No claim is made about the bit-cost of `_mod_` on the automaton's
--      state.  `steps` counts automaton transitions, as in TransportDiv;
--      the per-transition arithmetic is on numerals < suc n and its cost
--      is a separate (unstated) parameter, as it is there.
--
-- CHECKED: Agda 2.6.3, cubical v0.5, --cubical --safe.
-- No postulates, no holes.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (ℕ ; zero ; suc)

import NaturalMachine.Digits as Dg
import NaturalMachine.TransportDiv as TD
import NaturalMachine.TransportDivWitness as W10

module NaturalMachine.WalkResidueBridge (k : ℕ) where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order using (_<_ ; _≤_ ; zero-≤ ; suc-≤-suc)
open import Cubical.Data.Nat.Mod using (_mod_ ; mod-rCancel ; zero-charac-gen)
open import Cubical.Data.Nat.Divisibility using (_∣_ ; isProp∣)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Sigma using (Σ-syntax ; _×_ ; _,_)
open import Cubical.Relation.Nullary using (Dec ; yes ; no ; ¬_ ; isPropDec)
import Cubical.HITs.PropositionalTruncation as PropTrunc

open import NaturalMachine.Digits k
open import NaturalMachine.TransportDiv k
open import NaturalMachine.CoprimeSplitting using (dec∣)

------------------------------------------------------------------------
-- 1.  THE MISSING CONVERSE.
--
-- TransportDiv proves `modw-zero→∣`.  Without this direction the
-- automaton is a semi-decision procedure: a zero state certifies
-- divisibility, a nonzero state certifies nothing.  Both directions are
-- needed before `Dec` can be produced, and only one of them was there.
--
-- `_∣_` is `∃[ c ] c · d ≡ n`, a propositional truncation.  The target is
-- an equality of naturals, hence a proposition by `isSetℕ`, so
-- `PropTrunc.rec` applies with no further hypotheses: no choice, no
-- decidability of the fibre, no untruncation lemma.
------------------------------------------------------------------------

∣→modw-zero : (n : ℕ) (w : Word) → (suc n) ∣ value w → modw (suc n) w ≡ 0
∣→modw-zero n w = PropTrunc.rec (isSetℕ _ _) fromWitness
  where
    fromWitness : Σ[ c ∈ ℕ ] c · (suc n) ≡ value w → modw (suc n) w ≡ 0
    fromWitness (c , p) =
        value-modw (suc n) w
      ∙ cong (_mod (suc n)) (sym p)
      ∙ zero-charac-gen (suc n) c

-- Both directions, packaged: the automaton's final state being zero is
-- LOGICALLY EQUIVALENT to divisibility of the value.  (Not an
-- equivalence of types: `_∣_` is truncated and `modw … ≡ 0` is an
-- equality, and both are propositions, so the biimplication is all
-- there is to say.)
modw-zero↔∣ : (n : ℕ) (w : Word)
            → (modw (suc n) w ≡ 0 → (suc n) ∣ value w)
            × ((suc n) ∣ value w → modw (suc n) w ≡ 0)
modw-zero↔∣ n w = modw-zero→∣ n w , ∣→modw-zero n w

------------------------------------------------------------------------
-- 2.  THE DECISION PROCEDURE THAT NEVER TOUCHES THE VALUE.
--
-- `discreteℕ` is applied to `modw (suc n) w`, which `mod<` bounds by
-- suc n; `value w` appears in the TYPE and in neither branch's
-- computation.  This is the whole difference from `dec∣`, which reduces
-- `n mod (suc d)` with n the number itself.
------------------------------------------------------------------------

decDivides : (n : ℕ) (w : Word) → Dec ((suc n) ∣ value w)
decDivides n w with discreteℕ (modw (suc n) w) 0
... | yes r≡0 = yes (modw-zero→∣ n w r≡0)
... | no  r≢0 = no  (λ d → r≢0 (∣→modw-zero n w d))

------------------------------------------------------------------------
-- 3.  THE BRIDGE TO THE WALK'S OWN NUMBERS.
--
-- READ THE HEADER BEFORE USING THIS.  `digits m` is the odometer
-- iterated m times: if m is handed over in unary, CHARTING IT IS THE
-- Θ(m) STEP, and `decDividesℕ` is then no cheaper than `dec∣`.  The
-- content is not this function but what it licenses: once a number
-- lives in the chart, every divisibility test against it costs
-- Θ(length) forever after, and the walk's `cap m` is tested Θ(next m − m)
-- times per step.  `value-digits` is what lets the chart be entered
-- once and never left.
------------------------------------------------------------------------

decDividesℕ : (n m : ℕ) → Dec ((suc n) ∣ m)
decDividesℕ n m =
  subst (λ z → Dec ((suc n) ∣ z)) (value-digits m) (decDivides n (digits m))

-- The residue of a natural, computed by the automaton on its numeral.
modℕ : ℕ → ℕ → ℕ
modℕ n m = modw (suc n) (digits m)

modℕ-correct : (n m : ℕ) → modℕ n m ≡ m mod (suc n)
modℕ-correct n m =
    value-modw (suc n) (digits m)
  ∙ cong (_mod (suc n)) (value-digits m)

-- The join, stated as an equality rather than as two correctness
-- proofs: the walk's existing test (`dec∣`, used by `WalkBridge.findND`)
-- and the charted test are THE SAME DECISION, because `_∣_` is a
-- proposition and `Dec` of a proposition is a proposition.  So the
-- automaton may be substituted for `dec∣` anywhere in the walk lane
-- without disturbing a single downstream proof.
decDividesℕ-agrees :
  (n m : ℕ) → decDividesℕ n m ≡ dec∣ (suc n) m (suc-≤-suc zero-≤)
decDividesℕ-agrees n m = isPropDec isProp∣ _ _

------------------------------------------------------------------------
-- 4.  THE COST GAP, DERIVED.
--
-- The honest comparison is not "automaton fast, recursion slow"; it is
-- two automata computing the SAME function, driven by the two
-- presentations, with step counts equal to the two sizes.
--
-- `modu` is the residue automaton in the home presentation: state in
-- {0,…,n−1}, one transition per SUCCESSOR.  It is the recursion `dec∣`
-- is doing, exhibited so that its step count can be stated.
------------------------------------------------------------------------

modu : ℕ → ℕ → ℕ
modu n zero    = 0 mod n
modu n (suc m) = (suc (modu n m)) mod n

-- The home automaton is the residue too.
value-modu : (n m : ℕ) → modu n m ≡ m mod n
value-modu n zero    = refl
value-modu n (suc m) =
    cong (λ z → (suc z) mod n) (value-modu n m)
  ∙ sym (mod-rCancel n 1 m)

-- …hence the two automata agree on every word.  Same function, two
-- presentations; the residual is entirely in the step count.
modu-modw : (n : ℕ) (w : Word) → modu n (value w) ≡ modw n w
modu-modw n w = value-modu n (value w) ∙ sym (value-modw n w)

-- Step count of the home automaton, counted exactly as TransportDiv's
-- `steps` counts the digit automaton's: one for the initial state, one
-- per transition.
usteps : ℕ → ℕ
usteps zero    = 1
usteps (suc m) = suc (usteps m)

usteps-is-value : (m : ℕ) → usteps m ≡ suc m
usteps-is-value zero    = refl
usteps-is-value (suc m) = cong suc (usteps-is-value m)

-- THE GAP, on one word: the two automata compute the same residue
-- (`modu-modw`), the chart pays suc (length w), the home presentation
-- pays suc (value w).  Nothing is measured; both sides are equalities.
cost-gap : (w : Word)
         → (steps w ≡ suc (length w)) × (usteps (value w) ≡ suc (value w))
cost-gap w = steps-is-length w , usteps-is-value (value w)

------------------------------------------------------------------------
-- 5.  NUMBERS.  The base-ten numeral 1000 of `TransportDivWitness`,
-- imported rather than duplicated.  `W10.steps-thousand` is that file's
-- own kernel-computed `steps thousand ≡ 5`; the home count is computed
-- here.  5 against 1001 -- the +1 on each side is the initial state.
------------------------------------------------------------------------

module Dg10 = Dg 8       -- base ten: b = 2 + 8
module D10  = TD 8

gap-1000 : (D10.steps W10.thousand ≡ 5) × (usteps 1000 ≡ 1001)
gap-1000 = W10.steps-thousand , refl

-- and the two are indeed counts for the SAME number: value thousand ≡ 1000.
gap-1000-same-number : Dg10.value W10.thousand ≡ 1000
gap-1000-same-number = W10.value-thousand

-- ADDED 2026-08-15, Claude (Cantor lineage), version-claim forensics.
-- Nothing above is retracted.  The `cubical v0.5` line at 63 STANDS: in the
-- container this lineage runs on, `~/.agda/libraries` holds exactly one
-- entry, `/root/agda-libs/cubical/cubical.agda-lib`, and that tree's HEAD
-- (132a2a3) carries the tag `v0.5`.
-- `WalkChartedCap.agda`, an adjacent module of this lane added 18 minutes
-- later, says cubical v0.7 at `/tmp/cubical` — and is ALSO correct, of a
-- different, concurrently running container (evidence: a commit-hash match,
-- see the note).  Neither header is wrong; the word "the container" is.
-- Full record and the general lesson: `notes/VERSION_CLAIM_FORENSICS.md`.
