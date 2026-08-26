{-# OPTIONS --cubical --guardedness --safe --no-import-sorts #-}

------------------------------------------------------------------------
-- TransportDiv
--
-- DIVISION ON THE CHART.  `Transport` carries `+`, `TransportMul` carries
-- `·`, and both end with the same open remark: the walk
-- (`WalkBridge`) stalls at frontier m ≈ 8 because its
-- divisibility test is UNARY, costing Θ(cap m) with cap m = e^{ψ(m)}.
-- The test is the blocker, not the arithmetic around it.
--
-- This module carries the test across.  `modw n` is the Horner automaton
-- on digit words: one state in {0,…,n−1}, one step per digit, no mention
-- of the value it is testing.  `value-modw` proves it computes
-- `value w mod n`, so the automaton is the residue, not an estimate of
-- it, and `modw-zero→∣` turns a zero final state into divisibility of
-- the number itself.
--
-- COST.  `steps w ≡ suc (length w)`: the automaton visits each digit
-- once.  The unary test walks the value.  That gap is the whole content
-- of the frontier — and it is the third branch of
-- `Residual`: the two presentations are bridged (δ ≡ 0,
-- by `Digits`' equivalence) and the residual ϱ is nonzero, so no
-- equivalence-invariant response could have found it.
--
-- The chart map itself is NOT free, and nothing here pretends it is: the
-- edge costs stay explicit parameters, discharged with numbers only in
-- `TransportDivWitness`.
--
-- and not discovered by the author, which is the failure this repository's
-- protocol names first.  The object is classical and has a name: Sutner,
-- "Divisibility and State Complexity", Mathematica Journal 11:3 (2010),
-- calls r ↦ (b·r + d) mod m the HORNER AUTOMATON and states
-- δ(0,w) = val(w) mod m — which is `value-modw` verbatim.  Alexeev, JCSS
-- 69:2 (2004), gives the MINIMAL state counts, so "one state below the
-- modulus" is an upper bound and not the minimum.  mathlib's `Nat.ofDigits`
-- is definitionally this file's `value` and carries the surrounding API
-- (`ofDigits_modEq`, `dvd_iff_dvd_ofDigits`); the Agda standard library's
-- `Data.Digit.fromDigits` is `value` too.  No library found declares the
-- REDUCING fold, which is one induction wide.
--
-- THAT AUDIT WAS ITSELF INCOMPLETE, and the omission is the interesting
-- cited nineteen sources, all northwestern, for three objects with three
-- different provenances:
--
--   the reduction step   Euclidean descent, older than Euclid as
--                        anthyphairesis.  Correctly attributed to nobody
--                        in particular, which is fine.
--   the digit word       Piṅgala, Chandaḥśāstra, c. 300 BCE: prastāra,
--                        with naṣṭa and uddiṣṭa as the two directions of
--                        the addressing map.  This repository has eight
--                        checked modules on it (BOOK_INDEX chapter 2).
--   the chart `value`    place value with śūnya as a number carrying its
--                        own arithmetic: Brahmagupta, Brāhmasphuṭasiddhānta,
--                        628 (chapter 7).
--
-- And the harder problem this file's residue is a shadow of -- solve the
-- linear indeterminate congruence, not merely reduce it -- is Āryabhaṭa's
-- KUṬṬAKA, Āryabhaṭīya, Gaṇitapāda 32-33, 499 CE, which is a CHECKED
-- THEOREM in this repository at `formal/cubical/Kuttaka.agda` (`bezout`,
-- `inhomogeneous`), with `NaturalMachine/CakravalaNeedsKuttaka.agda` in
-- this very directory.  The audit searched the web and found a 2010 paper;
-- it did not search one directory up.
--
-- In this repository: `RadixSymptoma` already has the digit
-- action and its run law (`Radix.step`, `Radix.run≡`) in cubical Agda in
-- carries the Alexeev citation.  Note also that `scale-mod` below collides
-- in NAME with a different `scale-mod` there.  What is this file's own is
-- the reduce-at-every-digit variant that keeps the state bounded, its
-- cubical proof on this lane's chart, and the transport/cost framing.
------------------------------------------------------------------------

open import Cubical.Data.Nat using (ℕ ; zero ; suc)

module TransportDiv (k : ℕ) where

open import Cubical.Foundations.Prelude
open import Cubical.Data.Nat
open import Cubical.Data.Nat.Order
open import Cubical.Data.Nat.Mod
  using (_mod_ ; mod-rCancel ; mod·mod≡mod ; mod-idempotent
        ; remainder_/_ ; quotient_/_ ; ≡remainder+quotient)
open import Cubical.Data.Nat.Divisibility using (_∣_)
open import Cubical.Data.Fin using (Fin ; toℕ)
open import Cubical.Data.List using (List ; [] ; _∷_ ; length)
open import Cubical.Data.Sigma using (_×_ ; _,_ ; fst ; snd)
open import Cubical.HITs.PropositionalTruncation using (∣_∣₁)

open import Digits k

------------------------------------------------------------------------
-- 1.  The residue automaton.  One state, one pass, no value.
------------------------------------------------------------------------

modw : ℕ → Word → ℕ
modw n []      = 0 mod n
modw n (d ∷ w) = (toℕ d + b · modw n w) mod n

-- b · (x mod n) and b · x have the same residue: the state may be
-- reduced at every digit, which is what keeps the automaton bounded.
scale-mod : (n x : ℕ) → (b · x) mod n ≡ (b · (x mod n)) mod n
scale-mod n x =
    mod·mod≡mod n b x
  ∙ sym ( mod·mod≡mod n b (x mod n)
        ∙ cong (λ z → ((b mod n) · z) mod n) (mod-idempotent {n = n} x) )

------------------------------------------------------------------------
-- 2.  THE AUTOMATON IS THE RESIDUE.
------------------------------------------------------------------------

value-modw : (n : ℕ) (w : Word) → modw n w ≡ value w mod n
value-modw n []      = refl
value-modw n (d ∷ w) =
    cong (λ z → (toℕ d + b · z) mod n) (value-modw n w)
  ∙ sym step
  where
    step : (toℕ d + b · value w) mod n ≡ (toℕ d + b · (value w mod n)) mod n
    step =
        mod-rCancel n (toℕ d) (b · value w)
      ∙ cong (λ z → (toℕ d + z) mod n) (scale-mod n (value w))
      ∙ sym (mod-rCancel n (toℕ d) (b · (value w mod n)))

------------------------------------------------------------------------
-- 3.  A zero final state is divisibility, not evidence for it.
--
-- Stated for a positive modulus: `x mod 0 = 0` for every x, so the
-- automaton at n = 0 is silent by definition and must not be read as a
-- divisibility claim.
------------------------------------------------------------------------

modw-zero→∣ : (n : ℕ) (w : Word) → modw (suc n) w ≡ 0 → (suc n) ∣ value w
modw-zero→∣ n w h = ∣ (quotient (value w) / (suc n)) , q ∣₁
  where
    r0 : remainder (value w) / (suc n) ≡ 0
    r0 = sym (value-modw (suc n) w) ∙ h

    q : (quotient (value w) / (suc n)) · (suc n) ≡ value w
    q = ·-comm (quotient (value w) / (suc n)) (suc n)
      ∙ sym (+-zero ((suc n) · (quotient (value w) / (suc n))))
      ∙ +-comm ((suc n) · (quotient (value w) / (suc n))) 0
      ∙ cong (_+ (suc n) · (quotient (value w) / (suc n))) (sym r0)
      ∙ ≡remainder+quotient (suc n) (value w)

------------------------------------------------------------------------
-- 4.  Cost: one step per digit.
------------------------------------------------------------------------

steps : Word → ℕ
steps []      = 1
steps (d ∷ w) = suc (steps w)

steps-is-length : (w : Word) → steps w ≡ suc (length w)
steps-is-length []      = refl
steps-is-length (d ∷ w) = cong suc (steps-is-length w)

------------------------------------------------------------------------
-- 5.  The count is the algorithm's own recursion.
--
-- §4 as first written was a definitional identity about a function
-- connected to `modw` by nothing at all: `steps` counted its own clauses,
-- and no theorem said those clauses were the automaton's.  That objection
-- is correct and this section answers it.  `run` executes the automaton
-- and carries the count in the same recursion, so the two projections are
-- the state and the number of transitions that produced it.
------------------------------------------------------------------------

run : ℕ → Word → ℕ × ℕ
run n []      = (0 mod n) , 1
run n (d ∷ w) = ((toℕ d + b · fst (run n w)) mod n) , suc (snd (run n w))

run-state : (n : ℕ) (w : Word) → fst (run n w) ≡ modw n w
run-state n []      = refl
run-state n (d ∷ w) = cong (λ z → (toℕ d + b · z) mod n) (run-state n w)

run-count : (n : ℕ) (w : Word) → snd (run n w) ≡ steps w
run-count n []      = refl
run-count n (d ∷ w) = cong suc (run-count n w)

-- so the cost claim is about the residue computation and not about a
-- lookalike: one run, one state, one count, `suc (length w)` of them.
run-is-the-automaton :
    (n : ℕ) (w : Word)
  → (fst (run n w) ≡ value w mod n) × (snd (run n w) ≡ suc (length w))
run-is-the-automaton n w =
    (run-state n w ∙ value-modw n w)
  , (run-count n w ∙ steps-is-length w)

-- CHECKED: Agda 2.6.3, cubical **v0.7** (/tmp/cubical), --cubical --safe,
-- 2026-08-15.  No postulates, no holes.  NOT verified against the pin in
-- formal/cubical/BUILD.md (Agda 2.8.0, cubical v0.9), nor against the v0.5
-- the rest of this lane's headers quote: three toolchain states are live in
-- this repository at once and this file has only seen one of them.
